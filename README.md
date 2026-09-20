# 🛒 Enterprise Retail Analytics & Data Warehouse using MySQL

## 📌 Project Overview

This project is an end-to-end **Retail Data Analytics and SQL Data Warehouse project** developed using **MySQL 8.0+**.

The objective is to analyze a large-scale retail business dataset containing customers, orders, order items, products, categories, suppliers, stores, employees, payments, promotions, shipments, and returns.

The project simulates the type of SQL-based analytical work performed by Data Analysts, Business Analysts, BI Analysts, and Analytics teams in large-scale e-commerce and retail organizations.

The project focuses on transforming raw relational data into meaningful business insights using **SQL from basic querying to advanced analytical techniques**.

---

## 🎯 Business Objective

The retail organization wants to understand:

- Overall sales and revenue performance
- Customer purchasing behavior
- Customer lifetime value
- Repeat purchasing and retention
- Product and category performance
- Store performance
- Supplier contribution
- Promotion effectiveness
- Return and refund behavior
- Shipment performance
- Employee productivity
- Monthly and yearly sales trends
- Revenue growth
- Top and underperforming business segments

The project uses MySQL to create a structured analytical workflow capable of answering these business questions.

---

# 🗂️ Dataset Structure

The project contains multiple relational tables representing different aspects of the retail business.

| Table | Purpose |
|---|---|
| `customers` | Customer master information |
| `orders` | Order-level transaction information |
| `order_items` | Individual products purchased in each order |
| `products` | Product master information |
| `categories` | Product category information |
| `suppliers` | Supplier information |
| `stores` | Retail store information |
| `employees` | Employee information |
| `payments` | Payment transactions |
| `promotions` | Promotion and discount information |
| `shipments` | Shipment and delivery information |
| `returns` | Returned order items and refunds |

---

# 📊 Dataset Scale

The dataset contains approximately:

- 50,000 customers
- 300,000 orders
- 600,000 order items
- 10,000 products
- 30 product categories
- 200 suppliers
- 100 stores
- 1,000 employees
- 300,000 payment records
- 50 promotions
- 30,000 returns
- 300,000 shipment records

This provides enough data volume to demonstrate practical SQL querying, aggregation, analytical SQL, and query optimization techniques.

---

# 🏗️ Data Model

The database follows a relational retail data model.

```text
                         ┌──────────────┐
                         │  categories  │
                         └──────┬───────┘
                                │
                                │
                         ┌──────▼───────┐
                         │   products   │
                         └───┬──────┬───┘
                             │      │
                    supplier │      │ category
                             │      │
                    ┌────────▼─┐    │
                    │ suppliers│    │
                    └──────────┘    │
                                    │
                              ┌─────▼──────┐
                              │order_items │
                              └─────┬──────┘
                                    │
                              ┌─────▼─────┐
                              │   orders  │
                              └─┬───┬───┬─┘
                                │   │   │
                ┌───────────────┘   │   └──────────────┐
                │                   │                  │
        ┌───────▼───────┐    ┌──────▼─────┐    ┌──────▼──────┐
        │   customers   │    │  payments  │    │  shipments  │
        └───────────────┘    └────────────┘    └─────────────┘

                         ┌─────────────┐
                         │  returns    │
                         └──────┬──────┘
                                │
                         order_items

        ┌─────────────┐
        │    stores   │
        └──────┬──────┘
               │
        ┌──────▼───────┐
        │  employees   │
        └──────────────┘

        ┌──────────────┐
        │ promotions   │
        └──────┬───────┘
               │
             orders
