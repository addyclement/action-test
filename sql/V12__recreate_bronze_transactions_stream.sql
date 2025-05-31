-- V12__recreate_bronze_transactions_stream.sql
--
-- Drop the old bronze.transactions_stream (if it exists), then create a fresh one
-- that only captures future changes (no initial snapshot).
DROP STREAM IF EXISTS bankingdb.bronze.transactions_stream;

CREATE OR REPLACE STREAM bankingdb.bronze.transactions_stream
  ON TABLE bankingdb.bronze.transactions
  SHOW_INITIAL_ROWS = FALSE;
