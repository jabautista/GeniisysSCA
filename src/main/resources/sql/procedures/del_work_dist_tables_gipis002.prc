DROP PROCEDURE CPI.DEL_WORK_DIST_TABLES_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Del_Work_Dist_Tables_Gipis002 (pi_dist_no IN VARCHAR2) IS
BEGIN
        
        
        DELETE   GIUW_WITEMPERILDS_DTL
         WHERE   dist_no = pi_dist_no;  
        DELETE   GIUW_WITEMPERILDS
         WHERE   dist_no = pi_dist_no;  
       DELETE   GIUW_WPERILDS_DTL
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_WITEMDS_DTL
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_WPOLICYDS_DTL
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_WPERILDS
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_WITEMDS
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_WPOLICYDS
        WHERE   dist_no  =  pi_dist_no;

END;
/


