-- Fictional sample records for Bank / Fintech Platform.
BEGIN;
SET LOCAL standard_conforming_strings = on;
INSERT INTO portfolio."customer" ("customer_id", "customer_ref", "display_name", "created_at") VALUES (101, 'CUST-A101', 'Avery Morgan', '2026-01-10T09:30:00Z');
INSERT INTO portfolio."account" ("account_id", "customer_id", "account_type", "status", "opened_on", "balance") VALUES (201, 101, 'checking', 'active', '2026-01-11', 500);
INSERT INTO portfolio."payment" ("payment_id", "account_id", "idempotency_key", "amount", "status", "occurred_at") VALUES (301, 201, 'idem-a301', 25.5, 'settled', '2026-02-01T12:15:00Z');
COMMIT;
