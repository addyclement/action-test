-- V8__create_bronze_transactions_stream.sql
CREATE OR REPLACE STREAM bankingdb.bronze.transactions_stream
  ON TABLE bankingdb.bronze.transactions
  SHOW_INITIAL_ROWS = TRUE;