```sql
with contact_preferences as (
    select
        company.full_name as company_name,
        company.email_address as company_email_address,
        individual.first_name,

        /* Could also use `jaro_similarity`, `jaro_winkler_similarity`, `levenshtein` */
        jaccard(
            lower(split_part(company.email_address, '@', 1)),
            lower(individual.full_name)
        ) as similarity,

        row_number() over(
            partition by company_name
            order by similarity desc
        ) as contact_preference
    from customer_relationships as relationships
        left join customers as company
            on relationships.parent_customer_id = company.customer_id
        left join customers as individual
            on relationships.child_customer_id = individual.customer_id
)

select
    company_name,
    company_email_address,
    /* Set a match threshold of 25% */
    if(similarity >= 0.25, first_name, null) as salutation_name
from contact_preferences
where contact_preference = 1
order by company_name
```
