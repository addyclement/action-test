-- V9__create_silver_merge_task.sql
CREATE OR REPLACE TASK bankingdb.silver.merge_transactions_task
  WAREHOUSE = COMPUTE_WH
  SCHEDULE = 'USING CRON */5 * * * * UTC'
AS
MERGE INTO bankingdb.silver.transactions AS target
USING (
  SELECT
    METADATA$ACTION AS action,
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    description,
    created_at
  FROM bankingdb.bronze.transactions_stream
) AS source
ON target.transaction_id = source.transaction_id
WHEN MATCHED AND source.action = 'DELETE' THEN
  DELETE
WHEN MATCHED AND source.action IN ('INSERT','UPDATE') THEN
  UPDATE SET
    customer_id = source.customer_id,
    amount = source.amount,
    transaction_date = source.transaction_date,
    description = source.description,
    created_at = source.created_at
WHEN NOT MATCHED AND source.action = 'INSERT' THEN
  INSERT (transaction_id, customer_id, amount, transaction_date, description, created_at)
  VALUES (source.transaction_id, source.customer_id, source.amount, source.transaction_date, source.description, source.created_at);