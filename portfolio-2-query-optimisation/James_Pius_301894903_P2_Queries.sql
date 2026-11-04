-- Show related payment, account, customer records (up to 20).
SELECT t0."payment_id" AS "payment_payment_id",
       t0."idempotency_key" AS "payment_idempotency_key",
       t1."account_id" AS "account_account_id",
       t1."account_type" AS "account_account_type",
       t2."customer_id" AS "customer_customer_id",
       t2."customer_ref" AS "customer_customer_ref"
FROM portfolio."payment" t0
JOIN portfolio."account" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."customer" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."payment_id", t1."account_id", t2."customer_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT t0."payment_id" AS "payment_payment_id",
       t0."idempotency_key" AS "payment_idempotency_key",
       t1."account_id" AS "account_account_id",
       t1."account_type" AS "account_account_type",
       t2."customer_id" AS "customer_customer_id",
       t2."customer_ref" AS "customer_customer_ref"
FROM portfolio."payment" t0
JOIN portfolio."account" t1 ON t0."account_id" = t1."account_id"
JOIN portfolio."customer" t2 ON t1."customer_id" = t2."customer_id"
ORDER BY t0."payment_id", t1."account_id", t2."customer_id"
LIMIT 20;

-- Find payment records where occurred_at matches "2026-02-01T12:15:00Z" (up to 20).
SELECT * FROM portfolio."payment"
WHERE "occurred_at" IS NOT DISTINCT FROM '2026-02-01T12:15:00Z'
ORDER BY "payment_id"
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT * FROM portfolio."payment"
WHERE "occurred_at" IS NOT DISTINCT FROM '2026-02-01T12:15:00Z'
ORDER BY "payment_id"
LIMIT 20;

-- Count payment records for each account_id (up to 20 groups).
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;

EXPLAIN (ANALYZE, BUFFERS, FORMAT JSON)
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
