DROP PROCEDURE CPI.AEG_CHECK_LEVEL_Y;

CREATE OR REPLACE PROCEDURE CPI.AEG_Check_Level_Y(cl_level         IN NUMBER,
                          cl_value         IN NUMBER,
                          cl_sub_acct1 IN OUT NUMBER,
                          cl_sub_acct2 IN OUT NUMBER,
                          cl_sub_acct3 IN OUT NUMBER,
                          cl_sub_acct4 IN OUT NUMBER,
                          cl_sub_acct5 IN OUT NUMBER,
                          cl_sub_acct6 IN OUT NUMBER,
                          cl_sub_acct7 IN OUT NUMBER) IS
BEGIN
--msg_alert('AEG CHECK LEVEL...','I',FALSE);
  IF cl_level = 1 THEN
    cl_sub_acct1 := cl_value;
  ELSIF cl_level = 2 THEN
    cl_sub_acct2 := cl_value;
  ELSIF cl_level = 3 THEN
    cl_sub_acct3 := cl_value;
  ELSIF cl_level = 4 THEN
    cl_sub_acct4 := cl_value;
  ELSIF cl_level = 5 THEN
    cl_sub_acct5 := cl_value;
  ELSIF cl_level = 6 THEN
    cl_sub_acct6 := cl_value;
  ELSIF cl_level = 7 THEN
    cl_sub_acct7 := cl_value;
  END IF;
END;
/


