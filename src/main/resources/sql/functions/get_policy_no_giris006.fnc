DROP FUNCTION CPI.GET_POLICY_NO_GIRIS006;

CREATE OR REPLACE FUNCTION CPI.get_policy_no_GIRIS006 (p_dist_no   giuw_pol_dist.dist_no%TYPE )
RETURN VARCHAR2 IS
    v_policy_no VARCHAR2(50);
    BEGIN
        FOR i IN (SELECT t1.line_cd
                      ||'-'
                      ||t1.subline_cd
                      ||'-'
                      ||t1.iss_cd
                      ||'-'
                      ||TO_CHAR(t1.issue_yy,'09')
                      ||'-'
                      ||TO_CHAR(t1.pol_seq_no,'0000009')
                      ||'-'
                      ||TO_CHAR(t1.renew_no,'09') policy_no
                    FROM gipi_polbasic T1,
                         giuw_pol_dist T2,
                         gipi_parlist T3
                   WHERE T1.par_id    = T3.par_id
                     AND T1.policy_id = T2.policy_id
                     AND T2.dist_no   = p_dist_no
                  UNION   
                  SELECT t1.line_cd
                      ||'-'
                      ||t1.subline_cd
                      ||'-'
                      ||t1.iss_cd
                      ||'-'
                      ||t1.issue_yy
                      ||'-'
                      ||t1.pol_seq_no
                      ||'-'
                      ||t1.renew_no policy_no
                    FROM gipi_wpolbas T1,
                         giuw_pol_dist T2,
                         gipi_parlist T3
                   WHERE T1.par_id    = T3.par_id
                     AND T1.par_id    = T2.par_id
                     AND T3.par_type  = 'E'
                     AND T2.dist_no   = p_dist_no) 
      LOOP
          v_policy_no := nvl( i.policy_no,null);
      END LOOP;  
     RETURN(v_policy_no);
    END;
/


