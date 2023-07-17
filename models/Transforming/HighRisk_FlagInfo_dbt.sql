-- Models\Transforming folder\HighRisk_FlagInfo_dbt.sql

With SHL as
(
    select * from {{ref("SHL_Driver_dbt")}}
),

MedallDrvier as
(
    select * from {{ref("MedallianDriver_dbt")}}
),
Fleet as
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
    select * from  SHL 
 inner join MedallDrvier on MedallDrvier.MID = SHL.SHL_MID
 inner join fleet on fleet.FI_MID = MedallDrvier.MID
 inner join Crash on Crash.CrashReport_FID = fleet.FID
 inner join VisionZero VZ on VZ.Vision_VZID=Crash.Crash_Report_VZID
 inner join FieldTr FT on FT.FieldTrip_VZID = VZ.Vision_VZID
 inner join VehicleInspec VI on VI.VehicleIns_MID = MedallDrvier.MID 
)

select * from final 
--comment changes


