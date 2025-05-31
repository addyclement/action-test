-- V11__initial_load_silver_transactions.sql
--
-- One‐time bootstrapping: copy all existing bronze.transactions rows into silver.transactions
INSERT INTO bankingdb.silver.transactions (
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    description,
    created_at
)
SELECT
    transaction_id,
    customer_id,
    amount,
    transaction_date,
    description,
    created_at
FROM bankingdb.bronze.transactions;
