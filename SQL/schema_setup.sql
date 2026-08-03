CREATE TABLE raw_retail_sales (
    InvoiceNo VARCHAR(50),
    StockCode VARCHAR(50),
    Description VARCHAR(255),
    Quantity INT,
    InvoiceDate TIMESTAMP,
    UnitPrice NUMERIC(10,2),
    CustomerID VARCHAR(50),
    Country VARCHAR(50),
    TotalAmount NUMERIC(12,2)
);