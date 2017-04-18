DROP PROCEDURE CPI.B540_DSPASSDNM_WVI_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.B540_Dspassdnm_Wvi_B_Gipis002
  (v_exist IN OUT VARCHAR2,
   b240_par_id IN NUMBER) IS
BEGIN
  v_exist := 'N';
  UPDATE GIPI_WITEM
  SET group_cd = NULL
   WHERE par_id = b240_par_id;              
  UPDATE GIPI_WGROUPED_ITEMS
  SET group_cd = NULL
   WHERE par_id = b240_par_id;    
   
END;
/


