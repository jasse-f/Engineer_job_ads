--- #### DLT ROLE
USE ROLE USERADMIN;
CREATE ROLE IF NOT EXISTS T_E_dlt_role;
USE ROLE SECURITYADMIN;

--- #### GRANTING ROLES
GRANT ROLE T_E_DLT_ROLE TO USER T_E_DLT;
GRANT ROLE T_E_DLT_ROLE TO USER ricky_user;
GRANT ROLE T_E_DLT_ROLE TO USER rajneet_user;
GRANT ROLE T_E_DLT_ROLE TO USER kristofer_user;
GRANT ROLE T_E_DLT_ROLE TO USER jassef;


--- #### STAGING LAYER GRANTS
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE T_E_dlt_role;
GRANT USAGE ON DATABASE ENGINEER_ADS TO ROLE T_E_dlt_role;
GRANT USAGE ON SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_dlt_role;
GRANT CREATE TABLE ON SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_DLT_ROLE;
GRANT INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_DLT_ROLE;
GRANT INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_DLT_ROLE;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA ENGINEER_ADS.STAGING TO ROLE T_E_DLT_ROLE;
GRANT TRUNCATE ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.STAGING TO ROLE T_E_DLT_ROLE;

--- #### Testing
USE ROLE T_E_DLT_ROLE;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE ENGINEER_ADS;
CREATE TABLE IF NOT EXISTS Staging.test(
    test INTEGER PRIMARY KEY
);
INSERT INTO staging.test (test) 
VALUES(2);

SELECT * FROM staging.test;
DROP TABLE staging.test;



--- #### SHOW GRANTS

USE ROLE SECURITYADMIN;
SHOW GRANTS TO ROLE T_E_DLT_ROLE;
SHOW GRANTS ON SCHEMA ENGINEER_ADS.STAGING;

GRANT ALL PRIVILEGES ON DATABASE ENGINEER_ADS TO ROLE T_E_dlt_role;
GRANT ALL PRIVILEGES ON SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_dlt_role;
