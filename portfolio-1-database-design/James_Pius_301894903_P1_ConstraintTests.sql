-- Run these deliberately invalid statements one at a time, outside a transaction.
-- Each should fail at the named constraint; the sample rows should remain unchanged.

-- 1. customer pk duplicate. Expected: pk_customer, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at")
VALUES (101, 'CUST-TEST901', 'Jordan Lee', '2026-02-01T10:00:00Z');

-- 2. customer unique duplicate. Expected: uq_customer_0, SQLSTATE 23505.
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at")
VALUES (901, 'CUST-A101', 'Jordan Lee', '2026-02-01T10:01:00Z');

-- 3. customer customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at")
VALUES (NULL, 'CUST-TEST902', 'Jordan Lee', '2026-02-01T10:02:00Z');

-- 4. customer customer ref null. Expected: customer_ref, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at")
VALUES (903, NULL, 'Jordan Lee', '2026-02-01T10:03:00Z');

-- 5. customer display name null. Expected: display_name, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at")
VALUES (904, 'CUST-TEST904', NULL, '2026-02-01T10:04:00Z');

-- 6. customer created at null. Expected: created_at, SQLSTATE 23502.
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at")
VALUES (905, 'CUST-TEST905', 'Jordan Lee', NULL);

-- 7. account pk duplicate. Expected: pk_account, SQLSTATE 23505.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (201, 101, 'savings', 'active', '2026-02-02', 100);

-- 8. account fk missing customer. Expected: fk_account_0, SQLSTATE 23503.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (902, 999999, 'checking', 'active', '2026-02-02', 100);

-- 9. account account id null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (NULL, 101, 'checking', 'active', '2026-02-03', 100);

-- 10. account customer id null. Expected: customer_id, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (904, NULL, 'checking', 'active', '2026-02-03', 100);

-- 11. account account type null. Expected: account_type, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (905, 101, NULL, 'active', '2026-02-03', 100);

-- 12. account status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (906, 101, 'checking', NULL, '2026-02-03', 100);

-- 13. account opened on null. Expected: opened_on, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (907, 101, 'checking', 'active', NULL, 100);

-- 14. account balance null. Expected: balance, SQLSTATE 23502.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (908, 101, 'checking', 'active', '2026-02-03', NULL);

-- 15. account balance negative. Expected: account_balance_nonnegative, SQLSTATE 23514.
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance")
VALUES (909, 101, 'checking', 'active', '2026-02-03', -1);

-- 16. payment pk duplicate. Expected: pk_payment, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (301, 201, 'idem-test911', 10, 'pending', '2026-02-03T11:00:00Z');

-- 17. payment unique duplicate. Expected: uq_payment_0, SQLSTATE 23505.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (912, 201, 'idem-a301', 10, 'pending', '2026-02-03T11:01:00Z');

-- 18. payment fk missing account. Expected: fk_payment_0, SQLSTATE 23503.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (913, 999999, 'idem-test913', 10, 'pending', '2026-02-03T11:02:00Z');

-- 19. payment payment id null. Expected: payment_id, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (NULL, 201, 'idem-test914', 10, 'pending', '2026-02-03T11:03:00Z');

-- 20. payment account id null. Expected: account_id, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (915, NULL, 'idem-test915', 10, 'pending', '2026-02-03T11:04:00Z');

-- 21. payment idempotency key null. Expected: idempotency_key, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (916, 201, NULL, 10, 'pending', '2026-02-03T11:05:00Z');

-- 22. payment amount null. Expected: amount, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (917, 201, 'idem-test917', NULL, 'pending', '2026-02-03T11:06:00Z');

-- 23. payment status null. Expected: status, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (918, 201, 'idem-test918', 10, NULL, '2026-02-03T11:07:00Z');

-- 24. payment occurred at null. Expected: occurred_at, SQLSTATE 23502.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (919, 201, 'idem-test919', 10, 'pending', NULL);

-- 25. payment amount zero. Expected: payment_amount_positive, SQLSTATE 23514.
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at")
VALUES (920, 201, 'idem-test920', 0, 'pending', '2026-02-03T11:08:00Z');
