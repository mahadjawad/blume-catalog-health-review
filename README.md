# Blume Catalog Health Review
### Pricing, Inventory & Portfolio Risk Assessment — Business Analytics Capstone

An end-to-end business analytics project analyzing a **live catalog snapshot** of [Blume](https://meetblume.com) — a small, internationally-shipping Canadian skincare and wellness brand sold direct-to-consumer and through retail partners such as Ulta Beauty.

The project uses **SQL Server, Python, Excel, and Power BI** to assess pricing strategy, inventory availability, and listing data quality across Blume's 34-product catalog, and concludes with a written business report and three prioritized, financially-quantified recommendations.

---

## Business Question

> Blume's operations and merchandising teams have observed inconsistent stock availability and heavy reliance on discounting across the catalog. Which products are at risk of stockout, which categories or product lines are over-discounted, and does the catalog contain duplicate listings that distort inventory and sales reporting? What should be prioritized first, and what is the estimated financial impact?

---

## Headline Findings

| Finding | Detail |
|---|---|
| **53% of the catalog is "at risk"** | 18 of 34 SKUs fall into Watch, High Risk, or Critical tiers |
| **Bundle line is the highest-risk segment** | 84.6% of "Blume" (bundle) products are on sale vs. 23.8% for "blume-box" (standalone) — and bundles have a 27.3% stockout rate vs. 5.6% for standalone skincare |
| **Two products discounted at 83.3%** | The steepest markdowns in the catalog, at very different price points — suggesting a deliberate clearance tier |
| **5 products (15%) are duplicate listings** | Fragmenting sales and inventory data across multiple SKU records for the same item |
| **Estimated financial impact (baseline 30 units/SKU/month)** | ~$73,800/yr recoverable from discount-rate alignment + ~$60,900/yr in bundle stockout exposure |

![Risk Distribution](risk_distribution.png)
![Vendor On-Sale Comparison](vendor_on_sale.png)

---

## Tools & Tech Stack

| Tool | Role |
|---|---|
| **Apify** | Live scrape of Blume's Shopify storefront (34 SKUs, June 2026) |
| **SQL Server (T-SQL)** | Data storage, cleaning, and 7 diagnostic queries — pricing, discounts, duplicates, stockouts, price spread, vendor comparison, and a risk classification |
| **Python** (pandas, matplotlib, seaborn) | Exploratory analysis, 4 visualizations, and a bundle-component dependency investigation |
| **Excel** | Formula-driven "what-if" scenario model for revenue impact estimation |
| **Power BI** | 4-page interactive dashboard with KPI cards, category breakdowns, and a live revenue-recovery slider |

---

## Repository Contents

| File | Description |
|---|---|
| [`Blume_Catalog_Health_Review.pdf`](Blume_Catalog_Health_Review.pdf) | Full 20-page written business report — executive summary, methodology, findings, financial model, and recommendations |
| [`blume_products_dataset.xlsx`](blume_products_dataset.xlsx) | Raw 34-SKU catalog snapshot, scraped live via Apify |
| [`blume — live scraped data.sql`](<blume%20%E2%80%94%20live%20scraped%20data.sql>) | Raw scraped data, formatted for SQL Server import |
| [`analysis_queries.sql`](analysis_queries.sql) | All 7 SQL diagnostic queries, with the business question and finding for each written as comments |
| [`products_with_risk.csv`](products_with_risk.csv) | Output of the SQL risk-classification query — feeds the Python and Power BI work |
| [`blume_risk_analysis.ipynb`](blume_risk_analysis.ipynb) | Python notebook — EDA, 4 visualizations, and the bundle-dependency investigation |
| [`risk_distribution.png`](risk_distribution.png), [`discount_by_category.png`](discount_by_category.png), [`vendor_on_sale.png`](vendor_on_sale.png), [`price_vs_discount.png`](price_vs_discount.png) | Exported chart images from the Python notebook |
| [`blume_markdown_exposure_model.xlsx`](blume_markdown_exposure_model.xlsx) | Formula-driven Excel "what-if" model for the revenue-recovery scenarios |
| [`excel_model.png`](excel_model.png) | Screenshot of the Excel model |
| [`blume.pbix`](blume.pbix) | Power BI dashboard source file |
| [`page1_executive_summary.jpg`](page1_executive_summary.jpg), [`page2_pricing_discounts.jpg`](page2_pricing_discounts.jpg), [`page3_stockout_risk.jpg`](page3_stockout_risk.jpg), [`page4_recommendations.jpg`](page4_recommendations.jpg) | Screenshots of all 4 Power BI dashboard pages |

---

## Methodology Note

The original analysis plan assumed transactional/time-series data (e.g. year-over-year delivery trends, inventory turnover ratios, and a SKU clustering model). Because the dataset is a **single live snapshot** with no historical order or stock-movement data, the plan was adapted:

- "Query 5" (a delay-trend query) was superseded by **Query 6** (price spread) and **Query 7** (vendor-line comparison) — both cross-sectional analyses suited to a snapshot dataset.
- K-Means clustering was replaced with a **price-vs-discount scatter plot** colored by risk tier, since 34 rows / 2 vendors / 4 categories would not produce a meaningful cluster model.
- The bundle-component dependency analysis used a **manually researched component map** (reviewed from Blume's product pages) rather than text-parsing, since product descriptions were not present in the scraped data.

Full details are in [`Blume_Catalog_Health_Review.pdf`](Blume_Catalog_Health_Review.pdf), Section 3 (Data & Methodology).

---

## The Dashboard

![Dashboard Page 1](dashboard_page1.jpg)

The full 4-page interactive Power BI dashboard (Executive Summary, Pricing & Discounts, Stockout & Risk, and Recommendations & Revenue Recovery Scenario) is shown above and in `page2_pricing_discounts.jpg` through `page4_recommendations.jpg`, with the source `blume.pbix` file included for anyone wanting to explore the live scenario slider.

---

## The Financial Model

![Excel Model](excel_model.png)

All values in the Excel model (except the three blue assumption cells) are **live formulas** linked to the raw data — changing the "units sold per month" assumption automatically recalculates every downstream figure. See [`blume_markdown_exposure_model.xlsx`](blume_markdown_exposure_model.xlsx).

---

## Recommendations

1. **Consolidate duplicate SKU listings** (High Priority) — merge the 5 duplicated products into single listings with variant options.
2. **Review bundle pricing & inventory strategy** (High Priority) — cap bundle discounting closer to the standalone benchmark (23.8%) and add bundle-level stock monitoring, since stockouts were found to be independent of component availability.
3. **Investigate the 83.3% discount tier** (Medium Priority) — confirm whether this reflects intentional clearance or a reference-price data issue.

Full reasoning, expected impact, timelines, and owners for each recommendation are in [`Blume_Catalog_Health_Review.pdf`](Blume_Catalog_Health_Review.pdf), Section 7.

---

## Author

**Mahad** — Final-Year Business Analytics Student, FAST NUCES Lahore

Data source: live Shopify storefront snapshot of [meetblume.com](https://meetblume.com), 34 SKUs, captured June 2026 via Apify. This project is for educational/portfolio purposes and is not affiliated with or endorsed by Blume.
