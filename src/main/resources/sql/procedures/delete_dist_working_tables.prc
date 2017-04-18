DROP PROCEDURE CPI.DELETE_DIST_WORKING_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DIST_WORKING_TABLES (v_dist_no giuw_pol_dist.dist_no%TYPE) IS
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : April 05, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : DELETE_DIST_WORKING_TABLES program unit
  */
  
  DELETE giuw_wperilds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_wperilds
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemperilds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemperilds
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_witemds
   WHERE dist_no = v_dist_no;
  DELETE giuw_wpolicyds_dtl
   WHERE dist_no = v_dist_no;
  FOR c1 IN (SELECT frps_yy, frps_seq_no, line_cd --added line_cd edgar 09/15/2104
               FROM giri_wdistfrps
              WHERE dist_no = v_dist_no)
  LOOP
    FOR c2 IN (SELECT pre_binder_id
                 FROM giri_wfrps_ri
                WHERE frps_yy     = c1.frps_yy 
                  AND frps_seq_no = c1.frps_seq_no
                  AND line_cd = c1.line_cd) --added line_cd edgar 09/15/2104 
    LOOP
      DELETE giri_wbinder_peril
       WHERE pre_binder_id = c2.pre_binder_id; 
      DELETE giri_wbinder
       WHERE pre_binder_id = c2.pre_binder_id;
    END LOOP;
    DELETE giri_wfrperil
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no
       AND line_cd = c1.line_cd; --added line_cd edgar 09/15/2104
    DELETE giri_wfrps_ri
     WHERE frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no
       AND line_cd = c1.line_cd; --added line_cd edgar 09/15/2104
  END LOOP;
  DELETE giri_wdistfrps
   WHERE dist_no = v_dist_no;
  DELETE giuw_wpolicyds
   WHERE dist_no = v_dist_no;
END;
/


