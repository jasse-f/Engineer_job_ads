--- #### DBT ROLE
USE ROLE USERADMIN;
CREATE ROLE IF NOT EXISTS T_E_dbt_role;
USE ROLE SECURITYADMIN;

--- #### GRANTING ROLES
GRANT ROLE T_E_DBT_ROLE TO USER T_E_DBT;
GRANT ROLE T_E_DBT_ROLE TO USER jassef;
GRANT ROLE T_E_DBT_ROLE TO USER ricky_user;


--- #### WAREHOUSE LAYER GRANTS
GRANT USAGE ON WAREHOUSE COMPUTE_WH TO ROLE T_E_DBT_ROLE;
GRANT USAGE ON DATABASE Engineer_ads TO ROLE T_E_DBT_ROLE;

GRANT USAGE ON SCHEMA engineer_ads.staging TO ROLE T_E_DBT_ROLE;
GRANT SELECT ON ALL TABLES IN SCHEMA ENGINEER_ADS.STAGING TO ROLE T_E_DBT_ROLE;
GRANT SELECT ON ALL VIEWS IN SCHEMA ENGINEER_ADS.STAGING TO ROLE T_E_DBT_ROLE;
GRANT SELECT ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.STAGING TO ROLE T_E_DBT_ROLE;
GRANT SELECT ON FUTURE VIEWS IN SCHEMA ENGINEER_ADS.STAGING TO ROLE T_E_DBT_ROLE;
GRANT USAGE ON SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT CREATE TABLE ON SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT CREATE VIEW ON SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL VIEWS IN SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE VIEWS IN SCHEMA ENGINEER_ADS.Warehouse TO ROLE T_E_DBT_ROLE;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA ENGINEER_ADS.WAREHOUSE TO ROLE T_E_DBT_ROLE;
GRANT TRUNCATE ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.WAREHOUSE TO ROLE T_E_DBT_ROLE;


--- #### TESTING
USE ROLE T_E_DBT_ROLE;

USE WAREHOUSE COMPUTE_WH;
USE DATABASE ENGINEER_ADS;

CREATE TABLE IF NOT EXISTS Warehouse.test(
    test INTEGER PRIMARY KEY
);
SHOW TABLES IN Warehouse;

INSERT INTO warehouse.test (test) 
VALUES(2);

SELECT * FROM warehouse.test;
DROP TABLE warehouse.test;


--- #### MARTS LAYER GRANTS

USE ROLE SECURITYADMIN;
GRANT USAGE ON SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT CREATE TABLE ON SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT CREATE VIEW ON SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL VIEWS IN SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT SELECT, INSERT, UPDATE, DELETE ON FUTURE VIEWS IN SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT TRUNCATE ON ALL TABLES IN SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;
GRANT TRUNCATE ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.marts TO ROLE T_E_DBT_ROLE;

GRANT INSERT ON ALL TABLES IN SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_dlt_role;
GRANT INSERT ON FUTURE TABLES IN SCHEMA ENGINEER_ADS.Staging TO ROLE T_E_dlt_role;


--- #### TESTING MARTS
USE ROLE T_E_DBT_ROLE;

USE WAREHOUSE COMPUTE_WH;
USE DATABASE ENGINEER_ADS;
CREATE TABLE IF NOT EXISTS Marts.test(
    test INTEGER PRIMARY KEY
);

SHOW TABLES IN Marts;
INSERT INTO Marts.test (test) 
VALUES(2);

SELECT * FROM Marts.test;
DROP TABLE Marts.test;



--- #### SHOW GRANTS
SHOW GRANTS TO ROLE T_E_DBT_ROLE;
SHOW GRANTS ON SCHEMA ENGINEER_ADS.MARTS;
SHOW GRANTS ON SCHEMA ENGINEER_ADS.WAREHOUSE;