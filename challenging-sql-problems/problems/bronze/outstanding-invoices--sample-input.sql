```sql
with

invoices(invoice_id, invoice_datetime, invoice_amount_usd, is_paid, invoice_currency) as (
    values
        (1, '2024-06-03 11:52:01'::timestamp, 100.00, true,  'USD'),
        (2, '2024-06-04 01:11:52'::timestamp, 200.00, false, 'INR'),
        (3, '2024-06-17 21:01:29'::timestamp, 300.00, false, 'USD'),
        (4, '2024-06-18 00:12:50'::timestamp, 499.00, false, 'GBP')
),

exchange_rates(from_datetime, from_currency, to_currency, rate) as (
    values
        ('2024-06-02 00:45:52'::timestamp, 'USD', 'GBP',  0.7808),
        ('2024-06-02 04:59:57'::timestamp, 'USD', 'INR', 83.0830),
        ('2024-06-14 03:35:27'::timestamp, 'USD', 'GBP',  0.7880),
        ('2024-06-14 07:49:32'::timestamp, 'USD', 'INR', 83.5470),
        ('2024-06-17 23:21:22'::timestamp, 'USD', 'GBP',  0.7870),
        ('2024-06-28 21:56:52'::timestamp, 'USD', 'GBP',  0.7909),
        ('2024-06-29 17:42:47'::timestamp, 'USD', 'INR', 83.5680)
)
```
