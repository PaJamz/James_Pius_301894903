# Bank / Fintech Platform — normalisation

The example uses the saved sample records. The full set of fields is in the design and schema.

## Starting grouped records

| account_id | payment records (list) |
| --- | --- |
| 201 | [301] |


The record IDs are grouped in a list. In 1NF, each record has its own row and each cell holds one value.

## 1NF: one value per cell

| payment.payment_id | payment.account_id | payment.idempotency_key | account.account_id | account.customer_id | account.account_type | customer.customer_id | customer.customer_ref |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | idem-a301 | 201 | 101 | checking | 101 | CUST-A101 |

Key: payment_id.

## 2NF: depend on the whole key

The declared candidate keys do not introduce a partial dependency here, so the 1NF rows stay unchanged at this step.

## payment_example

| payment.payment_id | payment.account_id | payment.idempotency_key | account.account_id | account.customer_id | account.account_type | customer.customer_id | customer.customer_ref |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 301 | 201 | idem-a301 | 201 | 101 | checking | 101 | CUST-A101 |

## 3NF: store each entity’s details once

The entity keys determine their own descriptions. Related records keep foreign keys rather than repeating those descriptions.

## customer

| customer_id | customer_ref | display_name | created_at |
| --- | --- | --- | --- |
| 101 | CUST-A101 | Avery Morgan | 2026-01-10T09:30:00+00:00 |

## account

| account_id | customer_id | account_type | status | opened_on | balance |
| --- | --- | --- | --- | --- | --- |
| 201 | 101 | checking | active | 2026-01-11 | 500 |

## payment

| payment_id | account_id | idempotency_key | amount | status | occurred_at |
| --- | --- | --- | --- | --- | --- |
| 301 | 201 | idem-a301 | 25.5 | settled | 2026-02-01T12:15:00+00:00 |

## Dependencies

- customer: (customer_id) → customer_ref, display_name, created_at
- account: (account_id) → customer_id, account_type, status, opened_on, balance
- payment: (payment_id) → account_id, idempotency_key, amount, status, occurred_at

Joining the decomposed sample tables reproduces the original 1 example rows. The design assumes the declared keys describe the relevant business dependencies.
