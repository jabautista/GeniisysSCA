DROP FUNCTION CPI.CHECK_GIRI_DISTFRPS_EXIST;

CREATE OR REPLACE FUNCTION CPI.check_giri_distfrps_exist (
   p_par_id   gipi_witem.par_id%TYPE
)
   RETURN VARCHAR2
IS
   p_exist   VARCHAR2 (1) := 'N';
BEGIN
   FOR x IN (SELECT dist_no
               FROM giuw_pol_dist
              WHERE par_id = p_par_id)
   LOOP
      FOR y IN (SELECT DISTINCT frps_yy, frps_seq_no
                           FROM giri_distfrps
                          WHERE dist_no = x.dist_no)
      LOOP
         p_exist := 'Y';
      END LOOP;
   END LOOP;

   RETURN p_exist;
END check_giri_distfrps_exist;
/


