```sql
with

stages(stage, step) as (
    values
        ('full application',     1),
        ('decision',             2),
        ('documentation',        3),
        ('valuation inspection', 4),
        ('valuation made',       5),
        ('valuation submitted',  6),
        ('solicitation',         7),
        ('funds released',       8)
),

cohorts as (
    select
        applications.event_id,
        applications.event_date,
        applications.mortgage_id,
        applications.stage,
        stages.step,
        datetrunc('month', first_value(applications.event_date) over (
            partition by applications.mortgage_id
            order by stages.step
        )) as cohort
    from applications
        inner join stages
            using (stage)
),

cohorts_by_stage as (
    select
        cohort,
        stage,
        any_value(step) as step,
        count(*) as mortgages
    from cohorts
    group by
        cohort,
        stage
),

axis as (
    select
        cohort,
        stages.stage,
        stages.step
    from (select distinct cohort from cohorts_by_stage)
        cross join stages
),

funnel as (
    select
        axis.cohort,
        axis.stage,
        axis.step,
        coalesce(cohorts_by_stage.mortgages, 0) as mortgages,
    from axis
        left join cohorts_by_stage
            using (cohort, step)
)

select
    strftime(cohort, '%Y-%m') as cohort,
    stage,
    mortgages,
    round(100.0 * coalesce(mortgages / lag(mortgages, 1, mortgages) over cohort_by_step, 0), 2) as step_rate,
    round(100.0 * mortgages / first_value(mortgages) over cohort_by_step, 2) as total_rate,
from funnel
window cohort_by_step as (
    partition by cohort
    order by step
)
order by
    cohort,
    step
```
