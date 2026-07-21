# MAVEN FUZZY FACTORY
Analysis of profit and website sessions data for a fictitious e-commerce business selling teddy bears.  
Dataset source: *kaggle.com*  
Technologies used: *SQL, Power Query, Power BI*

## OBJECTIVES
Analyze profit trends throughout the 3 years period, identify key products and potential growth opportunities.  
Analyze website sessions through the lens of various traffic channels, conversion rate, users engagement. Identify improvement opportunities.

## ANALYTICAL PROCESS
### DATASET
Dataset consists of 6 tables:
- *orders*
- *order_items*
- *order_item_refunds*
- *products*
- *website_sessions*
- *website_pageviews*

### DATA VALIDATION AND PREPARATION
**MySQL** was used to review the data and prepare ir for futher analysis and visualisation in Power BI.

Checks done in SQL:
1. Check data consistency (price and cogs columns) between *orders* and *order_items* tables.
2. Check whether prices and cogs were changing througout the analysis period.
3. Check whether the refunds were always done at 100% and whether there were any refunds to non-existing orders.

Data preparation done in SQL:
1. Created view for *order_items*, so it inlucdes:
- *profit_usd* column (price_usd - cogs_usd)
- flag column indicating whether order item was raised for refund (*refunded_item*).
2. Created view for website_sessions containging additional columns:
- flag column indicating whether the session ended with purchase (*purchase_processed*).
- flag column indicating whether /shipping page was reached (*reached_shipping*).
- count of pages reached during the session (*no_of_pages_reached*). This count excludes purchase funnel pages, as it's aim will be to compare users engagement before deciding to/not to buy.
- count of product pages reached during the session (*no_of_product_pages_reached*). This count is limited to 4 pages dedicated to each of the products offered.
- *channel* column grouping utm-source and utm-campaign data into 5 traffic channels: paid search - *brand, paid search - nonbrand, paid social campaign, direct access, organic search*.
3. Created view for orders to lean the table and remove redundant columns.

Columns kept:
- *order_id*
- *website_session_id*
- *user_id*

Columns removed due to being redundant (duplicated with *order_items* table):
- *created_at*
- *primary_product_id*
- *items_purchased*
- *price_usd*
- *cogs_usd*

4. Create view summarizing primary and secondary products on orders with more than one item (*primary_products*).
5. Additional data transformation which considered was to move prices and cogs from *order_items* to *products* table in order to optimize the dataset. Nevertheless the final decision was taken to keep these figures in *order_items* as main fact table, to make it more realistic. This is the way how it would be kept in open data model where future changes of prices and cogs need to be expected (unlike the subject dataset, in which both prices and cogs remained unchanged throughout the period).

### DATA TRANFORMATION IN POWER QUERY

1. The following tables (or views) were imported to Power Query and furhter to Power BI:
   - *order_items (view)*
   - *orders (view)*
   - *website_sessions (view)*
   - *order_item_refunds*
   - *products*
   - *website_pageviews*
   - *primary_products*
  2. Two custom columns added to *website_sessions* in order to make final Power BI visulisation more user friendly. The two columns translate numeric flag columns (0, 1) to text columns (yes, no). Columns created: *purchase_session* (for *purchase_processed*) and *user_type* (for *is_repeat_session*).

### POWER BI ANALYSIS
The analysis has been divided into 2 parts:
 - Profit analysis
 - Website sessions analysis


PROFIT ANALYSIS - Key metrics




