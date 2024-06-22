```sql
with precipitation(grid_id, pr_january, pr_february, pr_march, pr_april, pr_may, pr_june, pr_july, pr_august, pr_september, pr_october, pr_november, pr_december) as (
    values
        ('AB-12',  98.654982000,  95.465774000,  93.622460000,  94.100401000, 87.123098000, 67.165477000, 54.468731000, 55.012740000, 57.335890000,  67.232145000,  85.332001000,  92.165432000),
        ('AB-34', 154.119868000, 125.977546000, 101.024456000, 134.523452000, 99.456788000, 95.025468000, 92.135497000, 93.653200000, 98.126477000, 103.332032000, 111.360141000, 125.216407000),
        ('C-56',   56.963354000,  76.455462000,  61.879871000,  87.666547000, 85.931607000, 83.636598000, 51.258741000, 65.165441000, 71.636687000,  94.654210000,  92.632147000, 101.300156000)
)
```