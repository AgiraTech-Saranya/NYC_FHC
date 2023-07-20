-- Models\Transforming folder\HighRisk_FlagStatus_dbt.sql

With SHL as
(
    select * from {{ref("SHL_Driver_dbt")}}
),

MedallDrvier as
(
    select * from {{ref("MedallianDriver_dbt")}}
),
Fleet as -- text
(
    select * from {{ref("FleetInfo_dbt")}}
),
Crash as
(
    select * from {{ref("Crash_Report_dbt")}}
),
FieldTr as
(
    select * from {{ref("FieldTrip_dbt")}}
),
VisionZero as
(
    select * from {{ref("VisionZeroBase_dbt")}}
),

VehicleInspec as
(
    select * from {{ref("VehicleIns_dbt")}}
),

final as
(
select fleet.FI_MID
     , case when SHL_Expiration_Date >= current_date()  and  SHL.SHL_DriverLicense_Number = 497161
            then 1 
            else 0 
            end as DriverActive_Status
     , case when VEHICLE_INFORMATION_COMPLETE  = TRUE 
			then 1
			else 0
			end as Vehicle_Drivability_Status

    , case when PARSE_DATE('%m/%d/%Y',CRASH_DATE) is not null 
		   then 1
		   else 0
		   end as Police_Report_Filed

    , case when FT.tpep_pickup_date  > DATE_Add(current_date(),interval -60 day) and Crash.CRASH_DATE is not null 
		   then 1
		   else 0
		   end as LastTripDate_Status

	,case when VI._2ndInspectionDate >= Date_Add(Current_Date(),interval -4 month) 
	      then 1
	      else 0
	      end as VehicleInspectionStatus

 from SHL 
 inner join MedallDrvier on MedallDrvier.MID = SHL.SHL_MID
 inner join fleet on fleet.FI_MID = MedallDrvier.MID
 inner join Crash on Crash.CrashReport_FID = fleet.FID
 inner join VisionZero VZ on VZ.Vision_VZID=Crash.Crash_Report_VZID
 inner join FieldTr FT on FT.FieldTrip_VZID = VZ.Vision_VZID
 inner join VehicleInspec VI on VI.VehicleIns_MID = MedallDrvier.MID 
)

select * from final



