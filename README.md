# 📊 E-Commerce Customer Lifetime Value (LTV) & RFM Segmentation

![Domain](https://img.shields.io/badge/Domain-E--Commerce%20%26%20Retail-blue)
![Tech Stack](https://img.shields.io/badge/Tech%20Stack-Python%20|%20SQL%20|%20Excel%20|%20Power%20BI-brightgreen)
![Analysis](https://img.shields.io/badge/Analysis-RFM%20%7C%20Cohort%20Retention-orange)

## 📌 Business Overview & Core Problem

Retail businesses often face rising customer churn rates due to unsegmented, generic marketing campaigns. Sending uniform promotions to all customers lowers ROI and damages high-value customer engagement.

**Objective:**
Transform raw, uncleaned transactional data into an actionable customer intelligence system. By modeling **Recency, Frequency, and Monetary (RFM)** metrics and tracking 12-month cohort retention, we identify at-risk high spenders, optimize retention budgets, and maximize **Customer Lifetime Value (LTV)**.

---

## 🔗 Live Interactive Dashboard Demo
👉 **[View Interactive Power BI Dashboard on Power BI Services]https://app.powerbi.com/groups/me/reports/4d36a68f-b996-4086-802f-fe0ee0362f98/cd01abc59d918c2da912?experience=power-bi

---

## 🏗️ Data Architecture & Pipeline

[ Raw CSV Data ]│▼ (Python - Pandas Data Cleaning & Type Formatting)[ Cleaned Transactions ]│▼ (SQL Ingestion & Window Functions: NTILE(5), CTEs)[ SQL Database: vw_Customer_RFM ]├──► [ Excel: Dynamic Array Cohort Matrix & Retention Heatmap ]└──► [ Power BI: Star Schema Engine, DAX Measures & Bookmarks ]
---

## 🛠️ End-to-End Implementation Steps

### 1. Data Cleaning & Preprocessing (Python)
- Handled ~25% missing `CustomerID` records.
- Filtered negative quantities and unit prices (returns/canceled orders).
- Engineered the `TotalAmount` transactional metric and normalized date formats.

### 2. SQL RFM Segmentation (`vw_Customer_RFM`)
- Computed **Recency Days** using baseline date snapshots.
- Applied **`NTILE(5)`** window functions across Recency, Frequency, and Monetary metrics.
- Classified customers into automated segments: *Champions*, *Loyal Customers*, *At-Risk (High Spend)*, *New/Promising*, and *Lost/Hibernating*.

```sql
-- Snippet of RFM Scoring logic in SQL View
NTILE(5) OVER (ORDER BY RecencyDays DESC) AS R_Score,
NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
NTILE(5) OVER (ORDER BY MonetaryValue ASC) AS M_Score
3. Cohort Retention Analysis (Excel)Built a 12-Month Customer Retention Matrix using dynamic offset calculations and Pivot Data Models.Applied 3-color conditional formatting (Heatmap) to identify month-over-month drop-off trends.4. Data Modeling & DAX Measures (Power BI)Designed an enterprise Star Schema Model (Fact_Sales, Dim_Customer, Dim_Product, Dim_Date).Authored custom Time-Intelligence & Revenue DAX measures:Customer LTV = DIVIDE([Total Revenue], [Total Customers], 0)YoY Revenue Growth % = DIVIDE([Total Revenue] - [Revenue SPLY], [Revenue SPLY], 0)At-Risk Revenue = CALCULATE([Total Revenue], Dim_Customer[Customer_Segment] = "At-Risk (High Spend)")Embedded dual view navigation (Executive View vs Customer Detail View) using Power BI Bookmarks & Selection Panels.💡 Key Business Insights & Strategic RecommendationsCustomer SegmentTotal Revenue ShareActionable StrategyChampions~35%VIP perks, early access to new product launches, referral incentives.At-Risk (High Spend)~18%Priority win-back campaigns, personalized discount offers before churn.Loyal Customers~25%Cross-sell & up-sell complementary categories.Lost / Hibernating~7%Automated low-cost re-engagement emails; minimize ad spend.


📂 Repository Structure
Plaintext
ecommerce-rfm-ltv-analysis/
├── data/              # Raw & Cleaned transactional CSV samples
├── python/            # Data cleaning scripts (Pandas)
├── sql/               # Schema DDL and vw_Customer_RFM creation queries
├── excel/             # Cohort analysis heatmap spreadsheet
├── power_bi/          # .pbix report file with bookmarks and DAX model
├── assets/            # Screenshots and visuals for documentation
├── LICENSE
└── README.md
🚀 How to Run & Replicate
Clone this repository:

Bash
git clone [https://github.com/zeefest/ecommerce-rfm-ltv-analysis.git]

Run python/data_cleaning_ingestion.py to generate cleaned_data.csv.

Execute sql/vw_Customer_RFM.sql in your SQL Server or PostgreSQL database.

Open power_bi/ECommerce_RFM_LTV_Dashboard.pbix and refresh the data source path.