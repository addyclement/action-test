-- 003_create_customers_table.sql
CREATE OR REPLACE TABLE bankingdb.bronze.customers (
  customer_id INT AUTOINCREMENT PRIMARY KEY,
  first_name STRING NOT NULL,
  last_name STRING NOT NULL,
  email STRING UNIQUE NOT NULL,
  created_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP
);