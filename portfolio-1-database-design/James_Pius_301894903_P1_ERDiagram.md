# Bank / Fintech Platform — ER diagram

```mermaid
erDiagram
    direction LR
    customer {
        bigint customer_id PK
        text customer_ref UK
        text display_name
        timestamptz created_at
    }
    account {
        bigint account_id PK
        bigint customer_id FK
        text account_type
        text status
        date opened_on
        numeric balance
    }
    payment {
        bigint payment_id PK
        bigint account_id FK
        text idempotency_key UK
        numeric amount
        text status
        timestamptz occurred_at
    }
    customer ||--o{ account : "customer_id"
    account ||--o{ payment : "account_id"
```

PK identifies a record; FK links to another table; UK marks a single-field unique value. The relationship ends show exactly one, zero or one, or zero or many records. Composite unique keys and conditional rules are listed in the schema and design.

[Diagram image](../images/James_Pius_301894903_ERDiagram.png)
