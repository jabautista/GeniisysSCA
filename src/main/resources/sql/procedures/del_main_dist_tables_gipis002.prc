DROP PROCEDURE CPI.DEL_MAIN_DIST_TABLES_GIPIS002;

CREATE OR REPLACE PROCEDURE CPI.Del_Main_Dist_Tables_Gipis002
(pi_dist_no IN NUMBER) IS
BEGIN
        
        
        DELETE   GIUW_ITEMPERILDS_DTL
         WHERE   dist_no = pi_dist_no;  
        DELETE   GIUW_ITEMPERILDS
         WHERE   dist_no = pi_dist_no;  
       DELETE   GIUW_PERILDS_DTL
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_ITEMDS_DTL
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_POLICYDS_DTL
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_PERILDS
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_ITEMDS
        WHERE   dist_no  =  pi_dist_no;
       DELETE   GIUW_POLICYDS
        WHERE   dist_no  =  pi_dist_no;
END;
/


