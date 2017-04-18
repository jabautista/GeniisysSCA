CREATE OR REPLACE PACKAGE CPI.GIPI_POLNREP_PKG AS

  FUNCTION get_polnrep_count (p_policy_id GIPI_POLBASIC.policy_id%TYPE)
    RETURN NUMBER;
    
    --added by gab 05.10.2016 SR 21421
  FUNCTION get_latest_renew_no (p_policy_id GIPI_POLBASIC.policy_id%TYPE)
    RETURN VARCHAR2;
    
END GIPI_POLNREP_PKG;
/


