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
        ('funds released',       8),
),

cohorts as (
    select
        applications.event_id,
        applications.event_date,
        applications.mortgage_id,
        applications.stage,
        stages.step,
        first_value(applications.event_date) over (
            partition by applications.mortgage_id
            order by stages.step
        ).strftime('%Y-%m') as cohort,
    from applications
        inner join stages
            using (stage)
),

cohorts_by_stage as (
    select
        cohort,
        stage,
        any_value(step) as step,
        count(*) as cohort_mortgages,
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
        coalesce(cohorts_by_stage.cohort_mortgages, 0) as mortgages,
        lag(mortgages, 1, mortgages) over cohort_by_step as prev_mortgages,
        first_value(mortgages) over cohort_by_step as first_mortgages,
    from axis
        left join cohorts_by_stage
            using (cohort, step)
    window cohort_by_step as (
        partition by axis.cohort
        order by axis.step
    )
)

select
    cohort,
    stage,
    mortgages,
    round(100.0 * if(prev_mortgages = 0, 0, mortgages / prev_mortgages), 2) as step_rate,
    round(100.0 * if(first_mortgages = 0, 0, mortgages / first_mortgages), 2) as total_rate,
from funnel
order by
    cohort,
    step
```
