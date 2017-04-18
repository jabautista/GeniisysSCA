CREATE OR REPLACE PACKAGE CPI.giac_retprem
/*
|| Author: Remar J.L. Uy
||
|| Overview: Procedures called from module GIACS185. Populates extract tables used
||           for Return Premiums Report.
||
|| Major Modifications (when, who, what):
|| 10/30/2000 - RLU - Create Package
||
*/
AS
   PROCEDURE GET_POLICY(v_start     IN date,
                        v_end       IN giac_retprem_pol_ext.end_date%TYPE,
                        v_date_type IN giac_retprem_pol_ext.date_type%TYPE);
                        -- valid values for v_date_type:
                        --     A - Accounting entry date
                        --     I - Issue date
                        --     N - Incept date
   PROCEDURE GET_PAYMENTS;
   PROCEDURE GET_SUMMARY;
END giac_retprem;
/


DROP PACKAGE CPI.giac_retprem;