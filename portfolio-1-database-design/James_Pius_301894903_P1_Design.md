# Bank / Fintech Platform — database design

My case study records customer, account, payment.

## Users

- Bank operations analyst
- Payments engineer
- Database student

## Main operations

- Register customers and open accounts.
- Record positive-value payments with an idempotency key.
- Find payments by account type, status, and time period.
- Summarize settled payment amounts by customer and month.
- Separately benchmark a date-range filter on synthetic payments before and after indexing.

## Entities

| Entity | Information stored |
| --- | --- |
| customer | A synthetic bank customer who may own accounts. |
| account | A customer-owned account with a nonnegative balance. |
| payment | A payment debit recorded against one account. |

## customer

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| customer_id | BIGINT | PK | Yes |
| customer_ref | TEXT | Unique | Yes |
| display_name | TEXT |  | Yes |
| created_at | TIMESTAMPTZ |  | Yes |
- Unique key: (customer_ref).

## account

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| account_id | BIGINT | PK | Yes |
| customer_id | BIGINT | FK | Yes |
| account_type | TEXT |  | Yes |
| status | TEXT |  | Yes |
| opened_on | DATE |  | Yes |
| balance | NUMERIC(18,2) |  | Yes |
- customer_id → customer.customer_id

## payment

| Field | Type | Key | Required |
| --- | --- | --- | --- |
| payment_id | BIGINT | PK | Yes |
| account_id | BIGINT | FK | Yes |
| idempotency_key | TEXT | Unique | Yes |
| amount | NUMERIC(18,2) |  | Yes |
| status | TEXT |  | Yes |
| occurred_at | TIMESTAMPTZ |  | Yes |
- account_id → account.account_id
- Unique key: (idempotency_key).

## Relationships and business rules

- Each customer has a unique synthetic customer reference.
- Every account belongs to an existing customer.
- An account balance must be zero or greater.
- Every payment references an existing account.
- A payment amount must be greater than zero.
- A payment idempotency key can identify at most one payment.

## Assumptions

- All records and identifiers are synthetic; customer references and payment idempotency keys are unique within this exercise.
- Accounts cannot have a negative balance. A payment debit and its payment record are one transaction.
- Worked normalization example: begin with a payment record containing payment_id, account_id, account_type, customer_id, customer_name, amount, and occurred_at. With payment_id as the key, account_id determines account_type and customer_id, and customer_id determines customer_name. Decompose into payment, account, and customer so each fact is stored with its own entity; payment has one account ancestor and account has one customer ancestor in this example.

