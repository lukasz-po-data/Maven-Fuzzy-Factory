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
- orders
- order_items
- order_item_refunds
- products
- website_sessions
- website_pageviews

### DATA VALIDATION AND PREPARATION
**MySQL** was used to review the data and prepare ir for futher analysis and visualisation in Power BI.

Checks done in SQL:
1. Check data consistency (price and cogs columns) between orders and order_items tables.
2. Check whether prices and cogs were changing througout the analysis period.
3. Check whether the refunds were always done at 100% and whether there were any refunds to non-existing orders.

Data preparation done in SQL:
1. Created view for order_items, so it inlucdes profit column and flag indicating whether order item was raised for refund.
2. Created view for website_sessions containging additional columns:
- flag column indicating whether the session ended with purchase (*purchase_processed*).
- flag column indicating whether /shipping page was reached (*reached_shipping*).
- count of pages reached during the session (*no_of_pages_reached*). This count excludes purchase funnel pages, as it's aim will be to compare users engagement before deciding to/not to buy.
- count of product pages reached during the session (*no_of_product_pages_reached*). This count is limited to 4 pages dedicated to each of the products offered.
- column (*channel*) grouping utm-source and utm-campaign data into 5 traffic channels: paid search - *brand, paid search - nonbrand, paid social campaign, direct access, organic search*.
3. Created view

