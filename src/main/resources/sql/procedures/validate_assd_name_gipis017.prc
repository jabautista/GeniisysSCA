DROP PROCEDURE CPI.VALIDATE_ASSD_NAME_GIPIS017;

CREATE OR REPLACE PROCEDURE CPI.validate_assd_name_gipis017(
	   	  		  p_par_id			IN   GIPI_PARLIST.par_id%TYPE,
				  p_line_cd			IN   GIPI_PARLIST.line_cd%TYPE,
				  p_assd_no			IN   GIPI_PARLIST.assd_no%TYPE,
				  p_drv_assd_name	IN   GIIS_ASSURED.assd_name%TYPE						 					
	   	  		  )
	   IS
  v_payt_term	  GIIS_PAYTERM.payt_terms%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 19, 2010
  **  Reference By : (GIPIS017 - Bond Basic Information)
  **  Description  : WHEN-VALIDATE-ITEM in gipis017 drv_assd_name
  */
  FOR A IN (SELECT '1'
              FROM GIPI_WINVOICE
             WHERE par_id = p_par_id) LOOP 
     calc_payment_sched(p_par_id,p_line_cd,p_assd_no,v_payt_term);       
     EXIT;
  END LOOP;
  UPDATE GIPI_WINVOICE
     SET insured = p_drv_assd_name,
         payt_terms = v_payt_term
	WHERE par_id  = p_par_id;
END;
/


