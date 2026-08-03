CREATE VIEW vw_Customer_RFM AS
WITH BaseSnapshot AS (
    -- Dataset ki sab se latest date mein 1 din add karke baseline date set kar rahe hain
    SELECT DATEADD(day, 1, MAX(InvoiceDate)) AS SnapshotDate
    FROM raw_retail_sales
),
CustomerMetrics AS (
    -- Step 1: Har Customer ka Raw Recency, Frequency, aur Monetary score nikalna
    SELECT
        s.CustomerID,
        s.Country,
        MAX(s.InvoiceDate) AS LastPurchaseDate,
        DATEDIFF(day, MAX(s.InvoiceDate), snap.SnapshotDate) AS RecencyDays,
        COUNT(DISTINCT s.InvoiceNo) AS Frequency,
        SUM(s.TotalAmount) AS MonetaryValue
    FROM raw_retail_sales s
    CROSS JOIN BaseSnapshot snap
    GROUP BY s.CustomerID, s.Country, snap.SnapshotDate
),
RFMScores AS (
    -- Step 2: NTILE(5) se 1 se 5 ki Percentile Scores assign karna
    SELECT
        CustomerID,
        Country,
        LastPurchaseDate,
        RecencyDays,
        Frequency,
        MonetaryValue,
        -- Recency: Jitne kam din (recent purchase), utna high score (5)
        NTILE(5) OVER (ORDER BY RecencyDays DESC) AS R_Score,
        -- Frequency: Jitni ziada purchases, utna high score (5)
        NTILE(5) OVER (ORDER BY Frequency ASC) AS F_Score,
        -- Monetary: Jitna ziada spend, utna high score (5)
        NTILE(5) OVER (ORDER BY MonetaryValue ASC) AS M_Score
    FROM CustomerMetrics
)
-- Step 3: Combined RFM Score aur Actionable Customer Segmentation
SELECT
    CustomerID,
    Country,
    LastPurchaseDate,
    RecencyDays,
    Frequency,
    MonetaryValue,
    R_Score,
    F_Score,
    M_Score,
    (CAST(R_Score AS VARCHAR(1)) + CAST(F_Score AS VARCHAR(1)) + CAST(M_Score AS VARCHAR(1))) AS RFM_Cell,
    (R_Score + F_Score + M_Score) AS Total_RFM_Score,
    CASE
        WHEN R_Score >= 4 AND F_Score >= 4 AND M_Score >= 4 THEN 'Champions'
        WHEN R_Score >= 3 AND F_Score >= 3 THEN 'Loyal Customers'
        WHEN R_Score >= 4 AND F_Score <= 2 THEN 'New / Promising Customers'
        WHEN R_Score <= 2 AND F_Score >= 3 AND M_Score >= 3 THEN 'At-Risk (High Spend)'
        WHEN R_Score <= 2 AND F_Score <= 2 AND M_Score <= 2 THEN 'Lost / Hibernating'
        ELSE 'Needs Attention'
    END AS Customer_Segment
FROM RFMScores;