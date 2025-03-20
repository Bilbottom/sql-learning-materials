```sql
with recursive

die(face) as (from generate_series(1, 6)),

rolls(n, outcome) as (
        select 1, [face]
        from die
    union all
        select
            rolls.n + 1,
            list_reverse_sort(list_append(rolls.outcome, die.face)),
        from rolls
            cross join die
        where rolls.n < 3
),

battle_scenarios(attackers, defenders) as (
    select *
    from
        generate_series(1, 3) as attackers,
        generate_series(1, 2) as defenders
),

battle_outcomes as (
    select
        battle_scenarios.attackers,
        battle_scenarios.defenders,

        coalesce(attacker_rolls.outcome[1], 0) as attacker_roll_1,
        coalesce(attacker_rolls.outcome[2], 0) as attacker_roll_2,
        coalesce(defender_rolls.outcome[1], 0) as defender_roll_1,
        coalesce(defender_rolls.outcome[2], 0) as defender_roll_2,

        (0
            + (attacker_roll_1 > defender_roll_1)::int
            + (attacker_roll_2 > defender_roll_2 and battle_scenarios.defenders = 2)::int
        ) as attacks_won
    from battle_scenarios
        left join rolls as attacker_rolls
            on battle_scenarios.attackers = attacker_rolls.n
        left join rolls as defender_rolls
            on battle_scenarios.defenders = defender_rolls.n
),

battle_likelihoods as (
    select
        attackers,
        defenders,
        attacks_won,
        max(attacks_won) over scenario - attacks_won as attacks_lost,
        count(*) / sum(count(*)) over scenario as likelihood
    from battle_outcomes
    group by attackers, defenders, attacks_won
    window scenario as (partition by attackers, defenders)
),

invasions as (
        select
            8 as attackers_remaining,
            6 as defenders_remaining,
            1::numeric(12, 10) as likelihood,
    union all
        select
            invasions.attackers_remaining - battle_likelihoods.attacks_lost,
            invasions.defenders_remaining - battle_likelihoods.attacks_won,
            invasions.likelihood * coalesce(battle_likelihoods.likelihood, 0),
        from invasions
            inner join battle_likelihoods
                on  least(invasions.attackers_remaining, 3) = battle_likelihoods.attackers
                and least(invasions.defenders_remaining, 2) = battle_likelihoods.defenders
                and battle_likelihoods.attacks_won <= least(invasions.attackers_remaining, invasions.defenders_remaining)
)

select
    attackers_remaining,
    defenders_remaining,
    sum(likelihood) as likelihood,
    sum(sum(likelihood) filter (where attackers_remaining != 0)) over () as attackers_win_likelihood,
    sum(sum(likelihood) filter (where defenders_remaining != 0)) over () as defenders_win_likelihood,
from invasions
where attackers_remaining = 0 or defenders_remaining = 0
group by attackers_remaining, defenders_remaining
order by attackers_remaining, defenders_remaining
```
