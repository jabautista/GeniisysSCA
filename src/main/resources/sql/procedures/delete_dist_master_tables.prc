DROP PROCEDURE CPI.DELETE_DIST_MASTER_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_DIST_MASTER_TABLES(
	   p_dist_no	  GIUW_POL_DIST.dist_no%TYPE
)
 IS
  v_dist_no			giuw_pol_dist.dist_no%TYPE;
BEGIN
  v_dist_no := p_dist_no;
  DELETE giuw_perilds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_perilds
   WHERE dist_no = v_dist_no;
  DELETE giuw_itemperilds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_itemperilds
   WHERE dist_no = v_dist_no;
  DELETE giuw_itemds_dtl
   WHERE dist_no = v_dist_no;
  DELETE giuw_itemds
   WHERE dist_no = v_dist_no;
  DELETE giuw_policyds_dtl
   WHERE dist_no = v_dist_no;
  FOR c1 IN (SELECT line_cd, frps_yy, frps_seq_no
               FROM giri_distfrps
              WHERE dist_no = v_dist_no)
  LOOP
    FOR c2 IN (SELECT fnl_binder_id
                 FROM giri_frps_ri
                WHERE line_cd     = c1.line_cd
                  AND frps_yy     = c1.frps_yy 
                  AND frps_seq_no = c1.frps_seq_no) 
    LOOP
      DELETE giri_binder_peril
       WHERE fnl_binder_id = c2.fnl_binder_id; 
      DELETE giri_binder
       WHERE fnl_binder_id = c2.fnl_binder_id;
    END LOOP;
    DELETE giri_frperil
     WHERE line_cd     = c1.line_cd
       AND frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;

    DELETE giri_frps_ri
     WHERE line_cd     = c1.line_cd
       AND frps_yy     = c1.frps_yy
       AND frps_seq_no = c1.frps_seq_no;

    DELETE giri_frps_peril_grp
     WHERE line_cd     = c1.line_cd
       AND frps_yy     = c1.frps_yy 
       AND frps_seq_no = c1.frps_seq_no;


  END LOOP;
  DELETE giri_distfrps
   WHERE dist_no = v_dist_no;
  DELETE giuw_policyds
   WHERE dist_no = v_dist_no;
END DELETE_DIST_MASTER_TABLES;
/


