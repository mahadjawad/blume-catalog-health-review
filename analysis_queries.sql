/* =====================================================================
   Blume Catalog Health Review — SQL Analysis Queries
   ---------------------------------------------------------------------
   Database: SQL Server (T-SQL)
   Table:    Products (34 rows, loaded from data/blume_products_dataset.xlsx)

   Schema:
     product_id          INT IDENTITY(1,1) PRIMARY KEY
     title               NVARCHAR(200)
     vendor              NVARCHAR(100)
     product_type        NVARCHAR(100)
     price_min           DECIMAL(10,2)
     price_max           DECIMAL(10,2)
     compare_at_price    DECIMAL(10,2) NULL
     on_sale             BIT
     available           BIT
     fully_out_of_stock  BIT
     variant_count       INT
     url                 NVARCHAR(500)
     discount_pct        DECIMAL(5,2) NULL
   ===================================================================== */


/* ---------------------------------------------------------------------
   Query 1 — Category Pricing Overview
   Business question: Which product categories carry the highest average
   price, and how many SKUs fall into each category?
   --------------------------------------------------------------------- */
SELECT product_type,
       COUNT(*)          AS total_products,
       AVG(price_min)    AS avg_price
FROM Products
GROUP BY product_type
ORDER BY avg_price DESC;


/* ---------------------------------------------------------------------
   Query 2 — Discount Ranking
   Business question: Which products are discounted most heavily?
   Finding: Meltdown Acne Oil Treatment and Meltdown Gel Cream with
   Ceramides both sit at 83.3% off — the steepest markdowns in the catalog.
   --------------------------------------------------------------------- */
SELECT title,
       product_type,
       price_min,
       compare_at_price,
       discount_pct
FROM Products
WHERE on_sale = 1
ORDER BY discount_pct DESC;


/* ---------------------------------------------------------------------
   Query 3 — Duplicate SKU Detection
   Business question: Are there duplicate listings for the same product,
   fragmenting sales and inventory data?
   Finding: 5 products (15% of the catalog) exist as duplicate listings.
   --------------------------------------------------------------------- */
SELECT title,
       COUNT(*)          AS listing_count,
       MIN(price_min)    AS lowest_price,
       MAX(price_max)    AS highest_price
FROM Products
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY listing_count DESC;


/* ---------------------------------------------------------------------
   Query 4 — Stockout Rate by Category
   Business question: Which product categories have the most stockouts?
   Finding: Bundles are out of stock at 27.3% vs 5.6% for Skin Care —
   nearly 5x higher.
   --------------------------------------------------------------------- */
SELECT product_type,
       COUNT(*) AS total_products,
       SUM(CASE WHEN fully_out_of_stock = 1 THEN 1 ELSE 0 END) AS oos_count,
       CAST(100.0 * SUM(CASE WHEN fully_out_of_stock = 1 THEN 1 ELSE 0 END)
            / COUNT(*) AS DECIMAL(5,1)) AS oos_pct
FROM Products
GROUP BY product_type
ORDER BY oos_pct DESC;


/* ---------------------------------------------------------------------
   Query 6 — Price Spread Analysis
   Business question: Which products have the widest price range across
   their variants, and why?
   Finding: Meltdown Acne Oil Treatment spans $52.00–$179.00 ($127 spread),
   the widest in the catalog.

   Note: "Query 5" from the original analysis plan assumed transactional
   order-date data (e.g. delivery delay trends) that this snapshot dataset
   does not contain. It was superseded by Queries 6 and 7 — see the
   Methodology Limitation section in the full report.
   --------------------------------------------------------------------- */
SELECT title,
       product_type,
       price_min,
       price_max,
       (price_max - price_min) AS price_spread,
       variant_count
FROM Products
WHERE variant_count > 1
ORDER BY price_spread DESC;


/* ---------------------------------------------------------------------
   Query 7 — Vendor-Line Comparison
   Business question: Does the vendor grouping (Blume bundles vs.
   blume-box standalone items) correlate with discounting or stockout
   behavior?
   Finding: The strongest signal in the dataset — Blume (bundles) is on
   sale 84.6% of the time vs 23.8% for blume-box, and carries 4 of the
   catalog's 5 stockouts despite having fewer total SKUs.
   --------------------------------------------------------------------- */
SELECT vendor,
       COUNT(*) AS total_products,
       SUM(CASE WHEN on_sale = 1 THEN 1 ELSE 0 END) AS on_sale_count,
       CAST(100.0 * SUM(CASE WHEN on_sale = 1 THEN 1 ELSE 0 END)
            / COUNT(*) AS DECIMAL(5,1)) AS on_sale_pct,
       SUM(CASE WHEN fully_out_of_stock = 1 THEN 1 ELSE 0 END) AS oos_count,
       CAST(AVG(price_min) AS DECIMAL(10,2)) AS avg_price
FROM Products
GROUP BY vendor
ORDER BY total_products DESC;


/* ---------------------------------------------------------------------
   Query 8 — Risk Classification
   Business question: Can every SKU be classified into a single risk
   tier that synthesizes the stockout and discount findings above?
   Finding: 53% of the catalog (18/34 SKUs) falls into Watch, High Risk,
   or Critical — only 47% is "Healthy".

   This query's output (exported as data/products_with_risk.csv) feeds
   the Python visualizations and the Power BI dashboard.
   --------------------------------------------------------------------- */
SELECT title,
       vendor,
       product_type,
       price_min,
       on_sale,
       fully_out_of_stock,
       discount_pct,
       CASE
         WHEN fully_out_of_stock = 1 THEN 'Critical - Out of Stock'
         WHEN on_sale = 1 AND discount_pct >= 50 THEN 'High Risk - Deep Discount'
         WHEN on_sale = 1 THEN 'Watch - On Sale'
         ELSE 'Healthy'
       END AS risk_status
FROM Products
ORDER BY
  CASE
    WHEN fully_out_of_stock = 1 THEN 1
    WHEN on_sale = 1 AND discount_pct >= 50 THEN 2
    WHEN on_sale = 1 THEN 3
    ELSE 4
  END;
