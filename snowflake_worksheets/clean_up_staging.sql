USE ROLE T_E_DLT_ROLE;

USE WAREHOUSE COMPUTE_WH;

USE DATABASE ENGINEER_ADS;

USE SCHEMA STAGING;


DELETE FROM engineer_field_job_ads
WHERE id IN (
    SELECT id
    FROM engineer_field_job_ads
    GROUP BY id
    HAVING COUNT(*) > 1
);