DROP PROCEDURE CPI.CREATE_DIST_LONG_A_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Create_Dist_Long_A_Gipis002
  (b240_par_id IN NUMBER) IS
BEGIN
  FOR A IN (SELECT dist_no
              FROM GIUW_POL_DIST
             WHERE par_id = b240_par_id)
  LOOP
 -- replaced w/ database procedure by mOn 02122009 -- 
 --DELETE_RI_TABLES(a.dist_no);
 Delete_Ri_Tables_Gipis002(A.dist_no);
 --DELETE_WORKING_DIST_TABLES(a.dist_no);
 Del_Work_Dist_Tables_Gipis002(A.dist_no);
 --DELETE_MAIN_DIST_TABLES(a.dist_no);
 Del_Main_Dist_Tables_Gipis002(A.dist_no);
 -- end mOn 02122009 --
  END LOOP;
  DELETE   GIUW_POL_DIST
  WHERE   par_id  =  b240_par_id;  
END;
/


