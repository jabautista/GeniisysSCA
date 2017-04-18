DROP PROCEDURE CPI.GIPIS081_DELETE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.GIPIS081_DELETE_DISTRIBUTION(p_dist_no   GIRI_DISTFRPS.dist_no%TYPE) 
IS

  CURSOR  C1  IS
      SELECT   distinct  frps_yy,
                         frps_seq_no
        FROM   giri_wdistfrps
       WHERE   dist_no = p_dist_no;
  CURSOR  C2  IS
      SELECT   distinct  frps_yy,
                         frps_seq_no
        FROM   giri_distfrps
       WHERE   dist_no = p_dist_no;

BEGIN
      FOR C1_rec IN C1 LOOP
      DELETE   giri_wfrperil
       WHERE   frps_yy     =   C1_rec.frps_yy
         AND   frps_seq_no =   C1_rec.frps_seq_no;
      DELETE   giri_wfrps_ri
       WHERE   frps_yy     =   C1_rec.frps_yy
         AND   frps_seq_no =   C1_rec.frps_seq_no;
      END LOOP;
      DELETE   giri_wdistfrps
       WHERE   dist_no = p_dist_no;  
      FOR C2_rec IN C2 LOOP
	    NULL;
        --MSG_ALERT('This PAR has corresponding records in the posted tables for RI.'||
                  --'  Could not proceed.','E',TRUE);
      END LOOP;
      DELETE_MAIN_DIST_TABLES(p_dist_no);
      DELETE   giuw_witemperilds_dtl
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_witemperilds
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_wperilds_dtl
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_witemds_dtl
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_wpolicyds_dtl
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_wperilds
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_witemds
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_wpolicyds
       WHERE   dist_no  =  p_dist_no;
      DELETE   giuw_distrel             --added to avoid integrity constraint
       WHERE   dist_no_old = p_dist_no;--for giuw_pol_dist
      DELETE   giuw_pol_dist
       WHERE   dist_no  =  p_dist_no;
END GIPIS081_DELETE_DISTRIBUTION;
/


