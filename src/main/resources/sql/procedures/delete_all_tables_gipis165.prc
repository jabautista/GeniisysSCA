DROP PROCEDURE CPI.DELETE_ALL_TABLES_GIPIS165;

CREATE OR REPLACE PROCEDURE CPI.DELETE_ALL_TABLES_GIPIS165 (
    p_par_id        IN  GIPI_PARLIST.par_id%TYPE
) IS
    v_dist_no      giuw_pol_dist.dist_no%TYPE;
    v_frps_yy      giri_wdistfrps.frps_yy%TYPE;
    v_frps_seq_no  giri_wdistfrps.frps_seq_no%TYPE;    
BEGIN
    DELETE    GIPI_WBOND_BASIC
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WCOSIGNTRY
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WCOMM_INV_PERILS
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WCOMM_INVOICES
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WPACKAGE_INV_TAX
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WINSTALLMENT
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WINVOICE
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WINVPERL
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WINV_TAX
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WITMPERL
     WHERE    par_id   =  p_par_id;
    DELETE    GIPI_WITEM
     WHERE    par_id   =  p_par_id;
     
    BEGIN
      SELECT     dist_no
        INTO     v_dist_no
        FROM     giuw_pol_dist
       WHERE     par_id   =  p_par_id;

      DELETE     giuw_witemperilds_dtl
       WHERE     dist_no   =   v_dist_no;
      DELETE     giuw_witemperilds
       WHERE     dist_no   =   v_dist_no;
      DELETE     giuw_wperilds_dtl
       WHERE     dist_no   =   v_dist_no;
      DELETE     giuw_wperilds
       WHERE     dist_no   =   v_dist_no;
      DELETE     giuw_witemds_dtl
       WHERE     dist_no   =   v_dist_no;
      DELETE     giuw_witemds
       WHERE     dist_no   =   v_dist_no;
       
       BEGIN
          SELECT     frps_yy,   frps_seq_no
            INTO     v_frps_yy, v_frps_seq_no
            FROM     giri_wdistfrps
           WHERE     dist_no  =  v_dist_no
        GROUP BY     frps_yy,   frps_seq_no;
          DELETE     giri_wfrperil
           WHERE     frps_yy     =   v_frps_yy
             AND     frps_seq_no =   v_frps_seq_no;
          DELETE     giri_wfrps_ri
           WHERE     frps_yy     =   v_frps_yy
             AND     frps_seq_no =   v_frps_seq_no;
          DELETE     giri_wdistfrps
           WHERE     frps_yy     =   v_frps_yy
             AND     frps_seq_no =   v_frps_seq_no;
       EXCEPTION
           WHEN TOO_MANY_ROWS THEN
              NULL;
           WHEN NO_DATA_FOUND THEN 
              NULL;
       END;
       
      DELETE     giuw_wpolicyds_dtl
       WHERE     dist_no   =   v_dist_no;
      DELETE     giuw_wpolicyds
       WHERE     dist_no   =   v_dist_no;
   EXCEPTION
      WHEN NO_DATA_FOUND THEN
           NULL;
   END;
END DELETE_ALL_TABLES_GIPIS165;
/


