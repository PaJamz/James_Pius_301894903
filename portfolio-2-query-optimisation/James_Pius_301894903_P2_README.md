# Bank / Fintech Platform — SQL queries

## 1. Show related payment, account, customer records (up to 20).

```sql
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
```

| payment_payment_id | payment_idempotency_key | account_account_id | account_account_type | customer_customer_id | customer_customer_ref |
| --- | --- | --- | --- | --- | --- |
| 301 | idem-a301 | 201 | checking | 101 | CUST-A101 |

## 2. Find payment records where occurred_at matches "2026-02-01T12:15:00Z" (up to 20).

```sql
SELECT * FROM portfolio."payment"
WHERE "occurred_at" IS NOT DISTINCT FROM '2026-02-01T12:15:00Z'
ORDER BY "payment_id"
LIMIT 20;
```

| payment_id | account_id | idempotency_key | amount | status | occurred_at |
| --- | --- | --- | --- | --- | --- |
| 301 | 201 | idem-a301 | 25.5 | settled | 2026-02-01T12:15:00+00:00 |

## 3. Count payment records for each account_id (up to 20 groups).

```sql
SELECT "account_id", count(*) AS record_count
FROM portfolio."payment"
GROUP BY "account_id"
ORDER BY record_count DESC, "account_id" NULLS LAST
LIMIT 20;
```

| account_id | record_count |
| --- | --- |
| 201 | 1 |


## Index comparison

| Phase | Median (ms) | Three runs (ms) | Plan nodes | Buffer hits |
| --- | --- | --- | --- | --- |
| Before index | 2.42 | 2.361, 2.42, 4.864 | Sort → Seq Scan | 274 |
| After index | 0.351 | 1.468, 0.351, 0.291 | Sort → Bitmap Heap Scan → Bitmap Index Scan | 55 |

The median execution time changed from 2.42 ms to 0.351 ms. The measured plan used p2_filter_idx. The results matched in both phases. An index adds storage and write-maintenance costs; timings depend on the selected lookup and environment.

## Execution plans

### Before index, run 1

```text
Sort (actual time=2.327..2.33 rows=50 loops=1)
  Seq Scan on payment (actual time=0.015..2.29 rows=50 loops=1)
Planning Time: 0.363 ms
Execution Time: 2.361 ms
```

### Before index, run 2

```text
Sort (actual time=2.389..2.391 rows=50 loops=1)
  Seq Scan on payment (actual time=0.016..2.352 rows=50 loops=1)
Planning Time: 0.377 ms
Execution Time: 2.42 ms
```

### Before index, run 3

```text
Sort (actual time=4.794..4.798 rows=50 loops=1)
  Seq Scan on payment (actual time=0.022..4.736 rows=50 loops=1)
Planning Time: 0.495 ms
Execution Time: 4.864 ms
```

### After index, run 1

```text
Sort (actual time=0.343..0.348 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.049..0.278 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.025..0.025 rows=50 loops=1)
Planning Time: 0.729 ms
Execution Time: 1.468 ms
```

### After index, run 2

```text
Sort (actual time=0.238..0.24 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.033..0.2 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.555 ms
Execution Time: 0.351 ms
```

### After index, run 3

```text
Sort (actual time=0.232..0.235 rows=50 loops=1)
  Bitmap Heap Scan on payment (actual time=0.032..0.196 rows=50 loops=1)
    Bitmap Index Scan using p2_filter_idx (actual time=0.016..0.016 rows=50 loops=1)
Planning Time: 0.572 ms
Execution Time: 0.291 ms
```

## Reproduce

Use a fresh database with the Portfolio 1 schema and sample data. Run James_Pius_301894903_P2_Queries.sql, then James_Pius_301894903_P2_Optimisation.sql. The optimisation script creates a separate performance table and runs EXPLAIN (ANALYZE, BUFFERS).

[Query screenshot](screenshots/James_Pius_301894903_P2_QueryResults.png) · [Index comparison](screenshots/James_Pius_301894903_P2_IndexComparison.png)

## References

- [PostgreSQL — EXPLAIN](https://www.postgresql.org/docs/17/using-explain.html)

