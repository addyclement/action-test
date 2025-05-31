-- V15__fix_delete_clause_in_merge_task.sql

CREATE OR REPLACE TASK bankingdb.silver.merge_transactions_task
  WAREHOUSE       = COMPUTE_WH
  SCHEDULE        = '5 MINUTE'
  WHEN
    SYSTEM$STREAM_HAS_DATA('bankingdb.bronze.transactions_stream')
AS
MERGE INTO bankingdb.silver.transactions AS target
USING (
  SELECT
    METADATA$ACTION      AS action,
    METADATA$ISUPDATE    AS is_update,
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    description,
    created_at
  FROM bankingdb.bronze.transactions_stream
) AS source
  ON target.transaction_id = source.transaction_id

  -- 1) Only delete if this is a true DELETE (not part of an UPDATE)
  WHEN MATCHED 
    AND source.action = 'DELETE' 
    AND source.is_update = FALSE
  THEN
    DELETE

  -- 2) Handle an UPDATE (DELETE+INSERT with is_update=TRUE) by performing an UPDATE here
  WHEN MATCHED 
    AND source.action = 'INSERT' 
    AND source.is_update = TRUE
  THEN
    UPDATE SET
      customer_id     = source.customer_id,
      amount          = source.amount,
      transaction_date = source.transaction_date,
      description     = source.description,
      created_at      = source.created_at

  -- 3) Insert truly new rows (INSERT with is_update=FALSE)
  WHEN NOT MATCHED 
    AND source.action = 'INSERT' 
    AND source.is_update = FALSE
  THEN
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

-- Resume the task so it begins running on its 5‐minute schedule
ALTER TASK bankingdb.silver.merge_transactions_task RESUME;
