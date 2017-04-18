DROP PROCEDURE CPI.GIPIS039_DELETE_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.gipis039_delete_distribution (pi_dist_no IN NUMBER)
IS
   CURSOR c1
   IS
      SELECT DISTINCT frps_yy, frps_seq_no
                 FROM giri_wdistfrps
                WHERE dist_no = pi_dist_no;

   CURSOR c2
   IS
      SELECT DISTINCT frps_yy, frps_seq_no
                 FROM giri_distfrps
                WHERE dist_no = pi_dist_no;
                v_counter NUMBER := 0;
BEGIN
   FOR c1_rec IN c1
   LOOP
      DELETE      giri_wfrperil
            WHERE frps_yy = c1_rec.frps_yy
              AND frps_seq_no = c1_rec.frps_seq_no;

      DELETE      giri_wfrps_ri
            WHERE frps_yy = c1_rec.frps_yy
                  AND frps_seq_no = c1_rec.frps_seq_no;
   END LOOP;

   DELETE      giri_wdistfrps
         WHERE dist_no = pi_dist_no;
         
         /*
          FOR c2_rec IN c2
   LOOP
      raise_application_error
      v_counter := NVL(v_counter, 0) + 1;
         (-20001,
             'This PAR has corresponding records in the posted tables for RI.'
          || '  Could not proceed.'
         );
   END LOOP;*/

   FOR c2_rec IN c2
   LOOP
    
      v_counter := v_counter + 1;
   END LOOP;
   
   IF v_counter  > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'This PAR has corresponding records in the posted tables for RI. Could not proceed.');
    END IF;

   delete_main_dist_tables (pi_dist_no);

   DELETE      giuw_witemperilds_dtl
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_witemperilds
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_wperilds_dtl
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_witemds_dtl
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_wpolicyds_dtl
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_wperilds
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_witemds
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_wpolicyds
         WHERE dist_no = pi_dist_no;

   DELETE      giuw_distrel              --added to avoid integrity constraint
         WHERE dist_no_old = pi_dist_no;                   --for giuw_pol_dist

   DELETE      giuw_pol_dist
         WHERE dist_no = pi_dist_no;
END;
/


