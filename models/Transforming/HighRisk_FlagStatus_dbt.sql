
With DriverLicence_status as
(
  select    MID
          ,  case when parse_date('%m-%d-%Y',Expiration_Date) >= current_date() and Expiration_Date is not null
              then 1 
              else 0 
              end as DriverLicenseActive_Status
  from `dbtcore_project.MedallianDriver_dbt`
  where DriverLicense_Number = {{var("DriverLicenceNumber")}}
),

SHLDriverActive as
(
  select    SHL_SID
          , SHL_MID
          , SHL_DriverLicense_Number
          , SHL_Driver_Name
          , SHL_Expiration_Date
          , case when SHL_StatusCode = 1 
                then 1 
                else 0 
                end as DriverActiveStatus
  from `dbtcore_project.SHL_Driver_dbt`
  where SHL_DriverLicense_Number = {{var("DriverLicenceNumber")}}
),

VehicleStatus as
(
  select    FID
          , FI_MID
          , case when VEHICLE_INFORMATION_COMPLETE  = 1 and  VEHICLE_INFORMATION_COMPLETE is not null
			        then 1
			        else 0
			        end as VehicleDrivability_Status
  from `dbtcore_project.FleetInfo_dbt` 
  where BIC_PLATE_NUMBER = '{{var("BIC_PlateNumber")}}'
),

PoliceReport_Status as
(
  select    Crash_Report_VZID
          , CrashReport_FID
          , MVC_ID
          , case  when CRASH_DATE is not null 
		              then 1
		              else 0
		              end as Police_Report_Filed

  from `dbtcore_project.Crash_Report_dbt` 
  where CrashReport_BIC_PlateNumber = '{{var("BIC_PlateNumber")}}'
),

Trip_Status as 
(
  select    FieldTrip_VZID
          , FTID
          , VZID
          , case  when FT.tpep_pickup_date  > DATE_Add(current_date(),interval -60 day) 
                        and P.CRASH_DATE is not null 
                      --have to compare with pickupdate should between on the day or 1 to 4 days before crashdate 
		              then 1
		              else 0
		        end as LastTripDate_Status
  from `dbtcore_project.FieldTrip_dbt`FT 
  inner join `dbtcore_project.Crash_Report_dbt`P on FT.VZID = P.Crash_Report_VZID
  where CrashReport_BIC_PlateNumber = '{{var("BIC_PlateNumber")}}'
),

VehicleInsStatus as

(
  select  VehicleIns_MID			
        , VehicleIns_VID			
        , VehicleIns_MedallianNumber			
        , _2ndInspectionScheduled_Date			
        , VehicleIns_VENDOR_NAME		
        , case 	when _2ndInspectionScheduled_Date >= Date_Add(Current_Date(),interval -4 month) 
	              then 1
	              else 0
	              end as VehicleInspectionStatus

  from `dbtcore_project.VehicleIns_dbt` V
  inner join `dbtcore_project.MedallianDriver_dbt` M on M.MID = V.VehicleIns_MID
  where M.DriverLicense_Number = {{var("DriverLicenceNumber")}}
),

HigherClaimReport as 
(
  select  Claim_ID
        , Cl.MVC_ID
        , OCCURRENCE_DATE
        , FILED_DATE
        , DISPOSITION_AMOUNT
        , DISPOSITION_DATE
        , CLAIM_ACTION
        , case when OCCURRENCE_DATE = C.Crash_date and Cl.Disposition_Amount < 10000
                then 1
                else 0 
                end as LessAmountClaimed
  from `dbtcore_project.Claims_Report_dbt` Cl
  inner join `dbtcore_project.Crash_Report_dbt` C on Cl.MVC_ID = C.MVC_ID
  where CrashReport_BIC_PlateNumber = '{{var("BIC_PlateNumber")}}'
),


final as

(
  select    DriverLicenseActive_Status
          , DriverActiveStatus
          , VehicleDrivability_Status
          , Police_Report_Filed
          , LastTripDate_Status
          , VehicleInspectionStatus
          , LessAmountClaimed
          
  from DriverLicence_status D 
  inner join SHLDriverActive S  on D.MID = S.SHL_MID
  inner join VehicleStatus V on D.MID = V.FI_MID
  inner join PoliceReport_Status P on P.CrashReport_FID = V.FID
  inner join Trip_Status T on T.FieldTrip_VZID = P.Crash_Report_VZID
  inner join VehicleInsStatus VI on VI.VehicleIns_MID = D.MID
  inner join HigherClaimReport H on H.MVC_ID = P.MVC_ID


)

select * from final