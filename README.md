# South Africa Provincial Voter Turnout Audit & Reconciliation (SQL)

## 📌 Project Overview
This project demonstrates an end-to-end **data validation, formula verification, and reconciliation workflow** using SQL on South African provincial election turnout data. 

Mirroring real-world **audit analytics** procedures, the script ingests reported provincial figures, enforces the Electoral Commission of South Africa's (IEC) exact denominator logic, flags calculation variances, and benchmarks provincial performance against national totals.

---

## 🎯 Business & Audit Objectives
1. **Data Standardization:** Convert formatted raw figures (spaces as thousand separators, commas as decimals) into clean relational database types (`INT` and `DECIMAL`).
2. **Formula Verification:** Independently recalculate `% Voter Turnout` using the official formula:
   $$\text{\% Voter Turnout} = \left( \frac{\text{Voter Turnout}}{\text{Registered Voters} + \text{MEC7 Votes}} \right) \times 100$$
3. **Exception Testing:** Automatically compare recalculated figures against reported percentages to flag any rounding or reporting discrepancies (`PASS` vs. `VARIANCE DETECTED`).
4. **National Reconciliation:** Aggregate provincial figures to verify national totals (`29,227,639` registered voters, `24,496` MEC7 votes, and `15,288,904` total turnout) and measure provincial variance from the `52.27%` national benchmark.

---

## 🛠️ Technical Skills & SQL Concepts Demonstrated
* **Schema Design & Data Integrity:** Defining primary keys, `NOT NULL` constraints, and appropriate numeric precision.
* **Precision Arithmetic:** Using `CAST(... AS DECIMAL(18, 4))` to prevent integer-division truncation errors during percentage calculations.
* **Conditional Audit Logic:** Implementing `CASE` expressions to automate quality assurance status flags.
* **Common Table Expressions (CTEs) & Joins:** Using `WITH` clauses and `CROSS JOIN` operations to benchmark individual provinces against aggregated national metrics.

---

## 📊 Key Findings Summary
* **100% Formula Reconciliation:** All 9 provinces returned a `PASS` audit status when `MEC7 Votes` were properly included alongside `Registered Voters` in the denominator.
* **Highest Turnout:** **Northern Cape** recorded the highest turnout at **57.66%** (+5.39% above the national benchmark), followed by **Western Cape** at **55.05%**.
* **Lowest Turnout:** **Limpopo** recorded the lowest turnout at **48.31%** (-3.96% below the national benchmark).
* **Largest Vote Share:** **Gauteng** and **KwaZulu-Natal** accounted for the largest share of total national votes cast.

---

## 📂 Repository Structure
* `voter_turnout_audit.sql` — Complete SQL script containing table creation, data ingestion, formula verification, and national benchmarking queries.
* `README.md` — Project documentation, methodology, and audit findings.

---

## 🚀 How to Run
1. Open any standard SQL environment (PostgreSQL, MySQL, SQL Server, or SQLite).
2. Execute `voter_turnout_audit.sql` from top to bottom.
3. Inspect the two output result sets for provincial audit status flags and national variance metrics.
