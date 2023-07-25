-- Models\Staging folder\SHL_Driver_dbt.sql

WITH
 SHL_Driver AS (
      SELECT
        MID as SHL_MID,
        SID as SHL_SID,
        License_Number as SHL_DriverLicense_Number,
        Driver_Name as SHL_Driver_Name,
        Status_Code as SHL_StatusCode,
        Expiration_Date as SHL_Expiration_Date
      FROM
        `data-engineering-learn.dbtcore_project.SHLDriverData`
        )
select * from SHL_Driver