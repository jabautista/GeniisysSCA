DROP PROCEDURE CPI.CHECKER_DUEDATE1_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.Checker_Duedate1_Gipis026(
	   	  		  			 p_par_id IN  gipi_wpolbas.par_id%TYPE
							,p_date2  OUT gipi_winstallment.due_date%TYPE
							,p_date1  OUT gipi_winstallment.due_date%TYPE ) IS					
BEGIN
	FOR C IN (SELECT expiry_date, eff_date 
	           FROM gipi_wpolbas
	          WHERE par_id = p_par_id) 
	LOOP
		p_date2 := TRUNC(c.expiry_date);
		p_date1 := TRUNC(c.eff_date);
		EXIT;
	END LOOP;
END;
/


