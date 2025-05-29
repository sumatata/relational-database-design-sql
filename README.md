# Relational Database Design: Contact Management Schema

This project presents a normalized relational database schema designed to manage contacts, organizations, emails, phone numbers, and addresses. It includes comprehensive SQL DDL scripts and entity-relationship diagrams to illustrate the database structure.

##  Files Included

- `contact_schema.sql` – Main schema creation script (base tables)
- `contact_target_schema.sql` – Additional target schema for reference
- `contact_er_diagram.jpg` – ER diagram for the base schema
- `target_er_diagram.jpg` – ER diagram for the target schema

##  Schema Overview

The normalized schema comprises key entities such as:

- `TBL_CONTACT` – Central entity containing personal contact information
- `TBL_CONTACT_EMAIL` – One-to-many relationship between contacts and emails
- `TBL_CONTACT_PHONE` – One-to-many relationship between contacts and phone numbers
- `TBL_CONTACT_ADDRESS` – Linking table between contacts and addresses
- `PHONE_TYPE`, `ADDRESS_TYPE` – Lookup/reference tables
- `ORGANIZATION`, `PROPOSAL`, `APPLICANT` – Related entities

##  Key Features

- Implements proper use of **primary and foreign keys**
- Enforces **referential integrity**
- Avoids redundancy using **normalization principles**
- Designed to scale for contact tracking systems and proposal management

##  How to Use

1. Open your SQL client (e.g., Oracle SQL Developer, pgAdmin, DBeaver).
2. Load `contact_schema.sql` and execute it to create the base schema.
3. (Optional) Load `contact_target_schema.sql` for extended tables.
4. Use the ER diagrams (`contact_er_diagram.jpg`, `target_er_diagram.jpg`) for visual schema reference.


## = Author

**Suma Tata**  
MS in  Data Science, University of Delaware  
