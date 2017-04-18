DROP PROCEDURE CPI.DELETE_WORKING_BINDER_TABLES;

CREATE OR REPLACE PROCEDURE CPI.DELETE_WORKING_BINDER_TABLES(
   p_dist_no            GIUW_POL_DIST.dist_no%TYPE,
   p_dist_seq_no        GIUW_WPOLICYDS.dist_seq_no%TYPE
)
IS
BEGIN
   FOR c1 IN(SELECT line_cd, frps_yy, frps_seq_no
               FROM giri_wdistfrps
              WHERE dist_no = p_dist_no
                AND dist_seq_no = p_dist_seq_no)
   LOOP
      FOR c2 IN(SELECT pre_binder_id
                  FROM giri_wfrps_ri
                 WHERE line_cd = c1.line_cd
                   AND frps_yy = c1.frps_yy
                   AND frps_seq_no = c1.frps_seq_no) 
      LOOP
         DELETE giri_wbinder_peril       
          WHERE pre_binder_id = c2.pre_binder_id;
                  
         DELETE giri_wbinder
          WHERE pre_binder_id = c2.pre_binder_id;
      END LOOP;
      
      DELETE giri_wfrperil
       WHERE line_cd = c1.line_cd
         AND frps_yy = c1.frps_yy
         AND frps_seq_no = c1.frps_seq_no;
         
      DELETE giri_wfrps_ri
       WHERE line_cd = c1.line_cd 
         AND frps_yy = c1.frps_yy
         AND frps_seq_no = c1.frps_seq_no;
         
      DELETE giri_wfrps_peril_grp
       WHERE line_cd = c1.line_cd
         AND frps_yy = c1.frps_yy
         AND frps_seq_no = c1.frps_seq_no;           
   END LOOP;
END;
/


