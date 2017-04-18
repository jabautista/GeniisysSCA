CREATE OR REPLACE PACKAGE CPI.gicl_adv_line_amt_pkg
AS
  
  FUNCTION get_range_to(
    p_user_id giis_users.user_id%TYPE,
    p_line_cd gicl_adv_line_amt.line_cd%TYPE,
    p_iss_cd gicl_adv_line_amt.iss_cd%TYPE)
  RETURN NUMBER;
  
END;
/


