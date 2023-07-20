{% set driverno = 497161 %}

With sample as(
select * from `dbtcore_project.Crash_Report`
),
final as
(
select current_date()  as date, crash_date, {{driverno}} as DRIVER_LICENSENUMBER
from sample
)
select * from final; --this is the sample file
