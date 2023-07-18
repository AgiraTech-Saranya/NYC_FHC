With sample as(
select * from `dbtcore_project.Crash_Report`
),
final as
(
select current_date()  as date, crash_date
from sample
)
select * from final; --this is the sample file
