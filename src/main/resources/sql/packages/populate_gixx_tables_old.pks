CREATE OR REPLACE PACKAGE CPI.Populate_Gixx_Tables_OLD AS


PROCEDURE extract_poldoc_record(
		   p_policy_id		gipi_polbasic.policy_id%TYPE,
		   v_extract_id     gixx_polbasic.extract_id%TYPE);

PROCEDURE extract_wpoldoc_record(
		   p_par_id		gipi_wpolbas.par_id%TYPE,
		   v_extract_id gixx_polbasic.extract_id%TYPE);


END;
/


