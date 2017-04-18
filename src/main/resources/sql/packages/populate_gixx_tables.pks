CREATE OR REPLACE PACKAGE CPI.Populate_Gixx_Tables AS


PROCEDURE extract_poldoc_record(
     p_policy_id  GIPI_POLBASIC.policy_id%TYPE,
     v_extract_id     GIXX_POLBASIC.extract_id%TYPE);

PROCEDURE extract_wpoldoc_record(
     p_par_id  GIPI_WPOLBAS.par_id%TYPE,
     v_extract_id GIXX_POLBASIC.extract_id%TYPE);


END;
/


