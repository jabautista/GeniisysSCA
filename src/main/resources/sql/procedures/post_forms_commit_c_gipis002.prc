DROP PROCEDURE CPI.POST_FORMS_COMMIT_C_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Post_Forms_Commit_C_Gipis002
  (parameter_delete_sw OUT VARCHAR2,
   b240_par_id IN NUMBER) IS
BEGIN
  parameter_delete_sw := 'N';
      UPDATE GIPI_PARLIST
         SET par_status = 5
       WHERE par_id = b240_par_id; 
END;
/


