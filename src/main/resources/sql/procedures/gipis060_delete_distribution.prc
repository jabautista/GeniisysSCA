DROP PROCEDURE CPI.GIPIS060_DELETE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_DELETE_DISTRIBUTION(
	   p_par_id	   IN GIPI_WPOLBAS.par_id%TYPE,
	   p_dist_no   IN GIUW_POL_DIST.dist_no%TYPE,
	   p_message   OUT VARCHAR2)
IS
  /*
	**  Created by		: Emman
	**  Date Created 	: 06.24.2010
	**  Reference By 	: (GIPIS060 - Item Information)
	**  Description 	: Calls the procedure DELETE_DISTRIBUTION
	*/
	
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
  	  p_message := 'SUCCESS';
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
        p_message := 'This PAR has corresponding records in the posted tables for RI.'||
                  '  Could not proceed.';
		RETURN;
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
      DELETE   giuw_distrel             
       WHERE   dist_no_old = p_dist_no;
      DELETE   giuw_pol_dist
       WHERE   dist_no  =  p_dist_no;
END;
/


