-- V7_create_transactions_table.sql
CREATE OR REPLACE TABLE bankingdb.bronze.transactions (
  transaction_id INT AUTOINCREMENT PRIMARY KEY,
  customer_id INT NOT NULL REFERENCES bankingdb.bronze.customers(customer_id),
  amount NUMBER(12,2) NOT NULL,
  transaction_date DATE NOT NULL,
  description STRING,
  created_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP
);