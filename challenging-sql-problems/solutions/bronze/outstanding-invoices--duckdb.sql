```sql
select
    invoices.invoice_currency,
    ceil(100 * sum(invoices.invoice_amount_usd * coalesce(exchange_rates.rate, 1))) / 100 as amount_outstanding
from invoices
    asof left join exchange_rates
        on  invoices.invoice_datetime >= exchange_rates.from_datetime
        and invoices.invoice_currency = exchange_rates.to_currency
        and exchange_rates.from_currency = 'USD'
where invoices.is_paid = false
group by invoices.invoice_currency
order by invoices.invoice_currency
```
