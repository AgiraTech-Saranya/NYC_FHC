-- Models\Staging folder\Staging_status_dbt.sql

WITH
 SHL_Driver AS (
      SELECT
        MID as SHL_MID,
        SID,
        License_Number,
        Driver_Name,
        Status_Code,
        Expiration_Date
      FROM
        data-engineering-learn.dbtcore_project.SHL_Driver
        ),
 MedallianDriver_Active AS (
      SELECT
        MID,
        License_Number AS VehicleLicense_Number,
        Name AS Driver_Name,
        Expiration_Date,
        Type
      FROM
        data-engineering-learn.dbtcore_project.MedallianDriver_active ),

 FleetInfo AS (
      SELECT
        MID as FI_MID,
        FID,
        ACCOUNT_NAME AS Agent_Name,
        MEDALLIAN_NUMBER,
        VEHICLE_INFORMATION_COMPLETE,
        BIC_NUMBER,
        BIC_PLATE_NUMBER,
        VENDOR_ID,
        VEHICLE_BODY_TYPE,
        VEHICLE_MODEL,
        VEHICLE_YEAR,
        VEHICLE_OWNERSHIP_TYPE
      FROM
       data-engineering-learn.dbtcore_project.FleetInformation ),
   Crash_Report AS (
      SELECT
        FID as CrashReport_FID,
        MVC_ID,
        VZID as Crash_Report_VZID,     
        COLLISION_ID,
        CRASH_DATE,
        VENDOR_ID as CrashReport_VendorID,
        BIC_PLATE_NUMBER as CrashReport_BIC_PlateNumber,
        STATE_REGISTRATION,
        VEHICLE_MAKE,
        VEHICLE_MODEL as Crashreport_VehicleModel,
        VEHICLE_TYPE,
        VEHICLE_YEAR as Crashreport_Vehicleyear,
        TRAVEL_DIRECTION,
        VEHICLE_OCCUPANTS,
        DRIVER_SEX,
        DRIVER_LICENSENUMBER as Crashreport_DriverLicenseNumber,
        DRIVER_LICENSE_STATUS,
        DRIVER_LICENSE_JURISDICTION,
        PRE_CRASH,
        POINT_OF_IMPACT,
        VEHICLE_DAMAGE,
        VEHICLE_DAMAGE_1
      from `dbtcore_project.Crash_Report`
     ),
FieldTrip AS (
      SELECT
        FTID,
        VZID as FieldTrip_VZID,
        VendorID as FieldTrip_VendorID,
        tpep_pickup_date
      FROM
        data-engineering-learn.dbtcore_project.FieldTrip
         ),
VisionZeroBase as
  (
    select 
      VZID	,		
      VENDOR_ID	as VisionZeroBase_VendorID	 ,
      VENDOR_LICENSE_NUMBER	,	
      VENDOR_NAME	 ,
      GREEN_TAXI_SERVICE	  ,	
      AFFILIATED_VEHICLES		
    from 
      data-engineering-learn.dbtcore_project.VisionZeroBase
  ),

  VehicleIns as
  (
      select
        MID as VehicleIns_MID,
        VID as VehicleIns_VID,
        Medallion_Number as VehicleIns_MedallianNumber,
        _1st_Inspection_DMV_Facility_Inspection_Month,
        _2nd_Inspection_Scheduled_Date,
        _3rd_Inspection_Scheduled_Date,
        _2ndInspectionDate
        FleetAgentCode,
        AgentName as VehicleIns_VENDOR_NAME
    
      from
          data-engineering-learn.dbtcore_project.VehicleInspection
  ),
 final as (
        select * from SHL_Driver S
        inner join MedallianDriver_Active ma on s.MID=ma.mid
        inner join FleetInfo f on f.FI_MID=ma.MID
        inner join Crash_Report C on c.CrashReport_FID = f.FID
        inner join VisionZeroBase VZ on VZ.VZID=C.Crash_Report_VZID
        inner join FieldTrip FT on Ft.FieldTrip_VZID = VZ.VZID
        inner join VehicleIns VI on VI.VehicleIns_MID = ma.MID


    )


select * from final