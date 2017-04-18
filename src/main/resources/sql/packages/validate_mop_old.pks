CREATE OR REPLACE PACKAGE CPI.VALIDATE_MOP_OLD AS
    v_incept_date      gipi_polbasic.incept_date%type;
    v_expiry_date      gipi_polbasic.expiry_date%type;
    v_limit_liab       gipi_open_liab.limit_liability%type;
    v_incept_rn         GIPI_WPOLBAS.INCEPT_DATE%TYPE;
    v_expiry_rn         GIPI_WPOLBAS.EXPIRY_DATE%TYPE;

  PROCEDURE get_open_pol_dtl(v_par_id IN NUMBER);
  FUNCTION validate_risknote_dtl(v_par_id GIPI_PARLIST.PAR_ID%type) RETURN NUMBER;

END VALIDATE_MOP_OLD;
/

DROP PACKAGE CPI.VALIDATE_MOP_OLD;