DROP PROCEDURE CPI.UPDATE_POL_DIST_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Update_Pol_Dist_Gipis002
  (b540_eff_date IN VARCHAR2,
   b540_par_id IN VARCHAR2,
   variables_long_term_dist IN VARCHAR2) IS
   v_eff_date  DATE;
BEGIN
	 v_eff_date := TO_DATE(b540_eff_date,'MM-DD-YYYY');
  UPDATE GIUW_POL_DIST
     SET eff_date = v_eff_date
   WHERE par_id = b540_par_id
     AND variables_long_term_dist = 'N';
END;
/


