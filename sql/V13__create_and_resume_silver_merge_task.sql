-- V13__create_and_resume_silver_merge_task.sql
--
-- Recreate the merge task to run every 5 minutes only when there is new data in the stream.

CREATE OR REPLACE TASK bankingdb.silver.merge_transactions_task
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = '5 MINUTE'
  WHEN
    SYSTEM$STREAM_HAS_DATA('bankingdb.bronze.transactions_stream')
AS
MERGE INTO bankingdb.silver.transactions AS target
USING (
  SELECT
    METADATA$ACTION      AS action,
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    description,
    created_at
  FROM bankingdb.bronze.transactions_stream
) AS source
  ON target.transaction_id = source.transaction_id

  -- Delete rows that were deleted in bronze
  WHEN MATCHED AND source.action = 'DELETE' THEN
    DELETE

  -- Update rows that were updated in bronze
  WHEN MATCHED AND source.action = 'UPDATE' THEN
    UPDATE SET
      customer_id     = source.customer_id,
      amount          = source.amount,
      transaction_date = source.transaction_date,
      description     = source.description,
      created_at      = source.created_at

  -- Insert rows that are new in bronze
  WHEN NOT MATCHED AND source.action = 'INSERT' THEN
    INSERT (
      transaction_id,
      customer_id,
      amount,
      transaction_date,
      description,
      created_at
    )
    VALUES (
      source.transaction_id,
      source.customer_id,
      source.amount,
      source.transaction_date,
      source.description,
      source.created_at
    );

-- Newly created tasks are suspended by default, so we explicitly resume it here:
-- ALTER TASK bankingdb.silver.merge_transactions_task RESUME;
