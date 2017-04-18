DROP PROCEDURE CPI.POST_FORMS_COMMIT_B_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Post_Forms_Commit_B_Gipis002
  (GLOBAL_enter IN OUT VARCHAR2,
   b240_par_id IN NUMBER,
   b240_line_cd IN VARCHAR2,
   b240_iss_cd IN VARCHAR2) IS
BEGIN
  IF GLOBAL_enter = 'Y' THEN
    FOR X IN (SELECT 1 
         FROM GIPI_WITMPERL
         WHERE PAR_ID = b240_par_id)
    LOOP
     GLOBAL_ENTER := 'N';
    END LOOP;
  END IF;
   
  IF GLOBAL_ENTER = 'N' THEN
 Create_Winvoice(0,0,0, b240_par_id, b240_line_cd, b240_iss_cd); -- modified by aivhie 120301
  END IF;
END;
/


