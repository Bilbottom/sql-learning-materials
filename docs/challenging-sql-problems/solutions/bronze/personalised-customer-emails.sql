```sql
select *
from values
    ('Fractal Factory',  'billiam@fractal-factory.co.uk', 'William'),
    ('Friends For Hire', 'joe.trib@f4hire.com',           'Joey'),
    ('Some Company',     'admin@somecompany.com',         null)
as solution(company_name, company_email_address, salutation_name)
```
