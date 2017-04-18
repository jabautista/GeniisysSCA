DROP PROCEDURE CPI.VALIDATE_ASSD_NAME;

CREATE OR REPLACE PROCEDURE CPI.Validate_Assd_Name (
	   p_par_id 			IN GIPI_PARLIST.par_id%TYPE,
	   p_line_cd			IN GIPI_PARLIST.line_cd%TYPE,
	   p_iss_cd				IN GIPI_PARLIST.iss_cd%TYPE)
  IS 
	v_exist       		   VARCHAR2(1);
BEGIN

  /*
  **  Created by   : Jerome Orio
  **  Date Created : February 03, 2010
  **  Reference By : (GIPIS002 - Basic Information)
  **  Description  : to validate assd name / WHEN-VALIDATE-ITEM B540 DSP_ASSD_NAME in GIPIS002
  */
   B540_Dspassdnm_Wvi_B_Gipis002(v_exist, p_par_id);
   FOR A IN (SELECT '1'
		       FROM GIPI_WITMPERL
		      WHERE par_id = p_par_id)
   LOOP                       
     B540_Dspassdnm_Wvi_C_Gipis002(p_par_id,p_line_cd,p_iss_cd);  
   EXIT;
   END LOOP;  
END;
/


