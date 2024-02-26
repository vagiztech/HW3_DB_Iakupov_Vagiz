-- Задание 1
Select job_industry_category, count(customer_id) as num_customers
from castomer
group by job_industry_category
order by num_customers desc;
-- Задание 2
select 
    extract(year from t.transaction_date) as year,
    extract(month from t.transaction_date) as month,
    c.job_industry_category,
    sum(t.list_price) as total_price
from transaction t
join castomer c on t.customer_id = c.customer_id
group by year, month, c.job_industry_category
order by year, month, c.job_industry_category;
-- Задание 3
select 
    t.brand,
    count(*) as online_orders_count
from transaction t
join castomer c on t.customer_id = c.customer_id
where c.job_industry_category = 'IT'
and t.order_status = 'Approved'
and t.online_order = 'True'
group by t.brand
order by online_orders_count desc;
-- Задание 4
select 
    customer_id, 
    sum(list_price) as total_sum,
    max(list_price) as max_price,
    min(list_price) as min_price,
    count(*) as transactions_count
from transaction
group by customer_id
order by total_sum desc, transactions_count desc;
-- Задание 5.1
select 
    c.first_name, 
    c.last_name
from castomer c
join (
    select 
        customer_id, 
        sum(list_price) as total_transaction_sum
    from transaction
    where list_price is not null
    group by customer_id
    order by total_transaction_sum asc
    limit 1
) as min_transactions on c.customer_id = min_transactions.customer_id;
-- 5.2
select 
    c.first_name, 
    c.last_name
from castomer c
join (
    select 
        customer_id, 
        sum(list_price) as total_transaction_sum
    from transaction
    where list_price is not null
    group by customer_id
    order by total_transaction_sum desc
    limit 1
) as max_transactions on c.customer_id = max_transactions.customer_id;
-- Задание 6
with RankedTransactions as (
    select 
        *,
        row_number() over (partition by customer_id order by transaction_date, transaction_id) as rn
    from transaction
)
select
    transaction_id,
    customer_id,
    transaction_date,
    list_price
from RankedTransactions
where rn = 1;
-- Задание 7
with TransactionIntervals as (
    select
        customer_id,
        transaction_date,
        lead(transaction_date) over (partition by customer_id order by transaction_date) - transaction_date as interval_days
    from transaction
),
MaxInterval as (
    select 
        customer_id,
        max(interval_days) as max_interval
    from TransactionIntervals
    group by customer_id
    order by max_interval desc
    limit 1
)
select 
    c.first_name,
    c.last_name,
    c.job_title
from Castomer c
join MaxInterval mi on c.customer_id = mi.customer_id;


