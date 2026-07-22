/* create view for order_items wit profit column and flag column indicating whether line item was refunded */

create view vw_order_items as
select 
	oi.*
	,oi.price_usd - oi.cogs_usd 															as profit_usd
	,case when oir.order_item_id is not null then 1 else 0 end								as refunded_item
from order_items oi
left join order_item_refunds oir using(order_item_id)


/* create view for website_sessions so it contains the following columns:
  - purchase processed - indicating whether the session ended up with order placement
  - reached shipping - indicating whether user reached shipping page
  - no of pages reached - to check user engagement; exdluding transaction funnel pages
  - no of product pages reached
  - channel - grouping utm data into 5 categories */


create or replace view vw_website_sessions as
with
pageviews_aggregated as 
	(
	select
		website_session_id
		,sum(case when pageview_url not in ('/thank-you-for-your-order', '/cart', '/shipping', '/billing', '/billing-2') then 1 else 0 end)										as no_of_pages_reached
		,sum(case when pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear', '/the-birthday-sugar-panda', '/the-hudson-river-mini-bear') then 1 else 0 end)		as no_of_product_pages_reached
		,max(case when pageview_url like '%shipping%' then 1 else 0 end)																										as reached_shipping
	from website_pageviews
	group by 1
	)
select 
	ws.website_session_id
	,ws.created_at 
	,ws.user_id 
	,ws.is_repeat_session 
	,ws.utm_source 
	,ws.utm_campaign 
	,ws.utm_content 
	,ws.device_type 
	,case 
			when ws.utm_source like '%search' and ws.utm_campaign = 'brand' then 'Paid search - brand'
			when ws.utm_source like '%search' and ws.utm_campaign = 'nonbrand' then 'Paid search - nonbrand'
			when ws.utm_source = 'socialbook' then 'Paid social campaign'
			when ws.utm_source = 'NULL' and ws.http_referer = 'NULL' then 'Direct access'
			when ws.utm_source = 'NULL' and ws.http_referer like '%search%' then 'Organic search'
			else 'unclassified' end																						as channel	
	,case when o.website_session_id is not null then 1 else 0 end 														as purchase_processed
	,pa.reached_shipping 											 													as reached_shipping
	,pa.no_of_pages_reached 
	,pa.no_of_product_pages_reached
from website_sessions ws
left join orders o using(website_session_id)
left join pageviews_aggregated pa using(website_session_id)




/* create view to lean orders table. It will be needed as mainly a bridge table between order_items and website_sessions. */

create or replace view vw_orders as
select
	order_id
	,website_session_id 
	,user_id
from orders


/* create view for futher analysis of primary and secondary products */

create or replace view vw_primary_products as
with primary_orders as 
	(
	select 
		primary_product_id					as product_id
		,count(order_id)					as orders_as_primary
	from orders
	where items_purchased > 1
	group by 1
	),
secondary_orders as
	(
	select 
		product_id							as product_id
		,count(order_id)					as orders_as_secondary
	from order_items
	where is_primary_item = 0
	group by 1
	)
select
	po.product_id
	,po.orders_as_primary
	,so.orders_as_secondary
	,po.orders_as_primary - so.orders_as_secondary			as difference
from primary_orders po join secondary_orders so using(product_id)



