CREATE DATABASE BlumeAnalytics;
GO
USE BlumeAnalytics;
GO

SELECT * FROM Products;
SELECT COUNT(*) FROM Products;

SELECT product_type, COUNT(*) AS total_products, AVG(price_min) AS avg_price
FROM Products
GROUP BY product_type
ORDER BY avg_price DESC;

SELECT 
    title,
    product_type,
    price_min,
    compare_at_price,
    discount_pct
FROM Products
WHERE on_sale = 1
ORDER BY discount_pct DESC;


SELECT 
    title,
    product_type,
    price_min,
    compare_at_price,
    ROUND(100.0 * (compare_at_price - price_min) / compare_at_price, 1) AS calculated_discount_pct
FROM Products
WHERE on_sale = 1 AND compare_at_price IS NOT NULL
ORDER BY calculated_discount_pct DESC;

SELECT 
    title,
    COUNT(*) AS listing_count,
    MIN(price_min) AS lowest_price,
    MAX(price_max) AS highest_price
FROM Products
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY listing_count DESC;

SELECT 
    title,
    COUNT(*) AS listing_count,
    SUM(variant_count) AS total_variants_across_listings,
    MIN(price_min) AS lowest_price,
    MAX(price_max) AS highest_price
FROM Products
GROUP BY title
HAVING COUNT(*) > 1
ORDER BY listing_count DESC;
;
SELECT 
    product_type,
    COUNT(*) AS total_products,
    SUM(CASE WHEN fully_out_of_stock = 1 THEN 1 ELSE 0 END) AS oos_count,
    CAST(100.0 * SUM(CASE WHEN fully_out_of_stock = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS oos_pct
FROM Products
GROUP BY product_type
ORDER BY oos_pct DESC;

SELECT COLUMN_NAME, DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Products';

SELECT 
    title,
    product_type,
    price_min,
    price_max,
    (price_max - price_min) AS price_spread,
    variant_count
FROM Products
WHERE variant_count > 1
ORDER BY price_spread DESC;

SELECT 
    vendor,
    COUNT(*) AS total_products,
    SUM(CASE WHEN on_sale = 1 THEN 1 ELSE 0 END) AS on_sale_count,
    CAST(100.0 * SUM(CASE WHEN on_sale = 1 THEN 1 ELSE 0 END) / COUNT(*) AS DECIMAL(5,1)) AS on_sale_pct,
    SUM(CASE WHEN fully_out_of_stock = 1 THEN 1 ELSE 0 END) AS oos_count,
    CAST(AVG(price_min) AS DECIMAL(10,2)) AS avg_price
FROM Products
GROUP BY vendor
ORDER BY total_products DESC;

SELECT 
    title,
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
