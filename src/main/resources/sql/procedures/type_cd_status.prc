DROP PROCEDURE CPI.TYPE_CD_STATUS;

CREATE OR REPLACE PROCEDURE CPI.type_cd_status
(p_line_cd              IN        GIIS_LINE.line_cd%TYPE,
 p_param_value_exist    OUT        VARCHAR2) 

IS
  v_param_value    VARCHAR2(1) := 'N';

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 07, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  :  This determines whether param_value_v exist 
**                  in GIIS_PARAMETERS for a specified line_cd.         
*/

BEGIN
  FOR A IN (
     SELECT param_value_v
       FROM giis_parameters
      WHERE param_name LIKE 'TYPE_CD_LINES%'
        AND param_value_v = p_line_cd) 
  LOOP
      v_param_value  :=  'Y';
  END LOOP;
  
  p_param_value_exist := v_param_value;
END;
/


