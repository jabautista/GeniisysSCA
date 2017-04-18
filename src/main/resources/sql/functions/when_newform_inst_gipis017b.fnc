DROP FUNCTION CPI.WHEN_NEWFORM_INST_GIPIS017B;

CREATE OR REPLACE FUNCTION CPI.WHEN_NEWFORM_INST_GIPIS017B(
	p_par_id	gipi_winvoice.par_id%TYPE
)
RETURN NUMBER
AS
	v_variables_comm	NUMBER := 0;
BEGIN
	FOR i IN(SELECT distinct 1
	  		   FROM gipi_winvoice
	 		  WHERE par_id = p_par_id)
 	LOOP
		v_variables_comm := 1;
	END LOOP;
	
	RETURN v_variables_comm;		   
END;
/


