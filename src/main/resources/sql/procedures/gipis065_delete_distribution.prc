DROP PROCEDURE CPI.GIPIS065_DELETE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.GIPIS065_DELETE_DISTRIBUTION(pi_dist_no  IN NUMBER) IS
tmpVar NUMBER;
/******************************************************************************
   NAME:       GIPIS065_DELETE_DISTRIBUTION
   PURPOSE:    

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/14/2010        IRWIN  1. Created this procedure.

   NOTES:

   Automatically available Auto Replace Keywords:
      Object Name:     GIPIS065_DELETE_DISTRIBUTION
      Sysdate:         9/14/2010
      Date and Time:   9/14/2010, 2:41:42 PM, and 9/14/2010 2:41:42 PM
      Username:         (set in TOAD Options, Procedure Editor)
      Table Name:       (set in the "New PL/SQL Object" dialog)

******************************************************************************/
CURSOR  C1  IS
      SELECT   distinct  frps_yy,
                         frps_seq_no
        FROM   giri_wdistfrps
       WHERE   dist_no = pi_dist_no;
  CURSOR  C2  IS
      SELECT   distinct  frps_yy,
                         frps_seq_no
        FROM   giri_distfrps
       WHERE   dist_no = pi_dist_no;

BEGIN
  
      FOR C1_rec IN C1 LOOP
      DELETE   giri_wfrperil
       WHERE   frps_yy     =   C1_rec.frps_yy
         AND   frps_seq_no =   C1_rec.frps_seq_no;
      DELETE   giri_wfrps_ri
       WHERE   frps_yy     =   C1_rec.frps_yy
         AND   frps_seq_no =   C1_rec.frps_seq_no;
      DELETE   giri_wdistfrps
       WHERE   dist_no = pi_dist_no;  
      END LOOP;
      FOR C2_rec IN C2 LOOP
      null;
        --MSG_ALERT('This PAR has corresponding records in the posted tables for RI.'||
          --        '  Could not proceed.','E',TRUE); already handled in front end.
      END LOOP;
      DELETE   giuw_witemperilds_dtl
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_wperilds_dtl
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_witemds_dtl
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_wpolicyds_dtl
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_witemperilds
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_wperilds
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_witemds
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_wpolicyds
       WHERE   dist_no  =  pi_dist_no;
      DELETE   giuw_pol_dist
       WHERE   dist_no  =  pi_dist_no;
       
END GIPIS065_DELETE_DISTRIBUTION;
/


