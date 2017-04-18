DROP PROCEDURE CPI.PRE_UPDATE_B540_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Pre_Update_B540_Gipis002
   (b540_subline_cd IN VARCHAR2,
    b540_ref_open_pol_no OUT VARCHAR2,
    b540_ref_pol_no IN VARCHAR2) IS 
  v_subline_cd   GIIS_SUBLINE.subline_cd%TYPE; 
BEGIN
  FOR mop IN (
    SELECT param_value_v
      FROM GIIS_PARAMETERS
     WHERE param_name = 'MN_SUBLINE_MOP')
  LOOP
    v_subline_cd := mop.param_value_v;
    EXIT;
  END LOOP;


  IF b540_subline_cd = v_subline_cd THEN
     b540_ref_open_pol_no := b540_ref_pol_no;
  END IF;

END;
/


