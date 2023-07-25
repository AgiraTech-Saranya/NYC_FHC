With InsuranceClaims_Report as
(
    select 
    Claim_ID	
,   MVC_ID	
,   CLAIM__	
,   BOROUGH	
,   parse_date('%m-%d-%Y',(replace(OCCURRENCE_DATE,'/','-'))) as OCCURRENCE_DATE		
,   parse_date('%m-%d-%Y',(replace(FILED_DATE,'/','-'))) as FILED_DATE		
,   CLAIM_TYPE		
,   MOTORCOLLISION_ID		
,   parse_date('%m-%d-%Y',(replace(DISPOSITION_DATE,'/','-'))) as DISPOSITION_DATE		
,   DISPOSITION_AMOUNT	
,   AGENCY		
,   CLAIM_ACTION		
,   FISCAL_YEAR__FY_	
    
    from `dbtcore_project.ClaimsReport`
)

select * from InsuranceClaims_Report