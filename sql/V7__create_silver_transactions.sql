CREATE OR REPLACE TABLE bankingdb.silver.transactions (
  transaction_id INT AUTOINCREMENT PRIMARY KEY,
  customer_id INT NOT NULL,
  amount NUMBER(12,2) NOT NULL,
  transaction_date DATE NOT NULL,
  description STRING,
  created_at TIMESTAMP_LTZ DEFAULT CURRENT_TIMESTAMP
);