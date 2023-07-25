-- Models\Staging folder\Crash_Report.sql

With  Crash_Report AS (
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
      FROM data-engineering-learn.dbtcore_project.MotorVehicleCollision
     )
Select * from Crash_Report