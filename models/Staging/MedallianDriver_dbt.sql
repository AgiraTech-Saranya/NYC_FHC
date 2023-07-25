-- Models\Staging folder\MedallianDriver_dbt.sql

With MedallianDriver_Active AS (
      SELECT
        MID,
        License_Number AS DriverLicense_Number,
        Name AS Driver_Name,
        replace(Expiration_Date,'/','-') as Expiration_Date,
        Type
      FROM
        `data-engineering-learn.dbtcore_project.MedallianActiveDriver`
        )
        
Select * from MedallianDriver_Active