DROP PROCEDURE CPI.POST_FORMS_COMMIT_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Post_Forms_Commit_A_Gipis002
  (b240_par_id IN NUMBER,
   b540_co_insurance_sw IN VARCHAR2,
   parameter_date_sw IN OUT VARCHAR2,
   parameter_date_sw2 IN OUT VARCHAR2,
   variables_long_term_dist OUT VARCHAR2) IS
BEGIN
  --POPULATE_ORIG_ITMPERIL;   -- replaced w/ database procedure by mOn 02132009 --
   Populate_Orig_Itmperl_Gipis002(b240_par_id, b540_co_insurance_sw);
   IF NVL(parameter_date_sw,'N') = 'Y' OR
      NVL(parameter_date_sw2, 'N') = 'Y' 
   THEN
      UPDATE GIPI_WITEM
         SET from_date = NULL,
             TO_DATE   = NULL
       WHERE par_id = b240_par_id;
       parameter_date_sw  := 'N';
       parameter_date_sw2 := 'N';
   END IF;    
-- added by Loth 092299
   variables_long_term_dist := 'Y';
END;
/


