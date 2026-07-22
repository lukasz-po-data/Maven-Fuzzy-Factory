/* Check if price and cogs columns align between orders and order_items tables. The outcome is 0, meaning the numbers are aligned between the 2 tables. */

with 
consolidated as
	(
	select 
		order_id				as order_id
		,sum(price_usd)			as price_usd
		,sum(cogs_usd)			as cogs_usd
	from order_items
	group by 1
	union
	select 
		order_id				as order_id
		,price_usd				as price_usd
		,cogs_usd				as cogs_usd
	from orders
	),
grouped_items as
	(
	select
		order_id
		,sum(price_usd)			as price_usd
		,sum(cogs_usd)			as cogs_usd
	from order_items
	group by 1
	)
select 
	sum(case when round(coalesce(o.price_usd, 0), 2) <> round(c.price_usd, 2) then 1 else 0 end)		as price_check_in_orders
	,sum(case when round(coalesce(o.cogs_usd, 0), 2) <> round(c.cogs_usd, 2) then 1 else 0 end)			as cogs_check_in_orders
	,sum(case when round(coalesce(gi.price_usd, 0), 2) <> round(c.price_usd, 2) then 1 else 0 end)		as price_check_in_order_items
	,sum(case when round(coalesce(gi.cogs_usd, 0), 2) <> round(c.cogs_usd, 2) then 1 else 0 end)		as cogs_check_in_order_items
from consolidated c
left join orders o using(order_id)
left join grouped_items gi using(order_id) 



/* Check if prices and cogs were changing during the analysis period. Outcome 0 means no price/cogs change history. */

select 
	product_id
	,max(price_usd) - min(price_usd)		as price_dynamics_check
	,max(cogs_usd) - min(cogs_usd)			as cogs_dynamics_check
from order_items
group by 1



/* Check if refunds are done at 100% and if there were refunds to non-existing order items. 0 means all refunds done to existing order items at 100% */

select
	sum(case when coalesce(price_usd, -5) - refund_amount_usd <> 0 then 1 else 0 end)			as refund_check
from order_items oi
right join order_item_refunds oir using(order_item_id)
	