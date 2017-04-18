DROP FUNCTION CPI.EXTRACT_EXPIRY;

CREATE OR REPLACE FUNCTION CPI.extract_expiry(p_par_id IN GIPI_WPOLBAS.par_id%TYPE) 
  RETURN DATE IS
/*
**  Created by    : Menandro G.C. Robes
**  Date Created  : May 26, 2010
**  Reference By  : (GIPIS097 - Endorsement Item Peril Information)
**  Description   : Function to extract the latest expiry date in case there is an endorsement of expiry 
*/   
  v_max_eff_date      gipi_polbasic.eff_date%TYPE;
  v_expiry_date       gipi_polbasic.expiry_date%TYPE;
  v_max_endt_seq      gipi_polbasic.endt_seq_no%TYPE;
BEGIN
  FOR i IN (
    SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
      FROM gipi_wpolbas
     WHERE par_id = p_par_id)
  LOOP   
      -- first get the expiry_date of the policy
      FOR A1 in (SELECT expiry_date
                  FROM gipi_polbasic a
                 WHERE a.line_cd    = i.line_cd
                   AND a.subline_cd = i.subline_cd
                   AND a.iss_cd     = i.iss_cd
                   AND a.issue_yy   = i.issue_yy
                   AND a.pol_seq_no = i.pol_seq_no
                   AND a.renew_no   = i.renew_no
                   AND a.pol_flag in ('1','2','3','X')
                   AND NVL(a.endt_seq_no,0) = 0)
      LOOP
        v_expiry_date  := a1.expiry_date;
        -- then check and retrieve for any change of expiry in case there is 
        -- endorsement of expiry date
        FOR B1 IN (SELECT expiry_date, endt_seq_no
                     FROM gipi_polbasic a
                    WHERE a.line_cd    = i.line_cd
                      AND a.subline_cd = i.subline_cd
                      AND a.iss_cd     = i.iss_cd
                      AND a.issue_yy   = i.issue_yy
                      AND a.pol_seq_no = i.pol_seq_no
                      AND a.renew_no   = i.renew_no
                      AND a.pol_flag IN ('1','2','3','X')
                      AND NVL(a.endt_seq_no,0) > 0
                      AND expiry_date <> a1.expiry_date
                      AND expiry_date = endt_expiry_date
                    ORDER BY a.eff_date DESC)
        LOOP
          v_expiry_date  := b1.expiry_date;
          v_max_endt_seq := b1.endt_seq_no;
          FOR B2 IN (SELECT expiry_date, endt_seq_no
                       FROM gipi_polbasic a
                      WHERE a.line_cd    = i.line_cd
                        AND a.subline_cd = i.subline_cd
                        AND a.iss_cd     = i.iss_cd
                        AND a.issue_yy   = i.issue_yy
                        AND a.pol_seq_no = i.pol_seq_no
                        AND a.renew_no   = i.renew_no
                        AND a.pol_flag in ('1','2','3','X')
                        AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                        AND expiry_date <> B1.expiry_date
                        AND expiry_date = endt_expiry_date
                   ORDER BY a.eff_date desc)
          LOOP
            v_expiry_date  := b2.expiry_date;
            v_max_endt_seq := b2.endt_seq_no;
            EXIT;
         END LOOP;
          --check for change in expiry using backward endt. 
          FOR C IN (SELECT expiry_date
                      FROM gipi_polbasic a
                     WHERE a.line_cd    = i.line_cd
                       AND a.subline_cd = i.subline_cd
                       AND a.iss_cd     = i.iss_cd
                       AND a.issue_yy   = i.issue_yy
                       AND a.pol_seq_no = i.pol_seq_no
                       AND a.renew_no   = i.renew_no
                       AND a.pol_flag in ('1','2','3','X')
                       AND NVL(a.endt_seq_no,0) > 0
                       AND expiry_date <> a1.expiry_date
                       AND expiry_date = endt_expiry_date
                       AND nvl(a.back_stat,5) = 2
                       AND NVL(a.endt_seq_no,0) > v_max_endt_seq
                  ORDER BY a.endt_seq_no desc)
          LOOP
            v_expiry_date  := c.expiry_date;
            EXIT;
          END LOOP;    
          EXIT;
        END LOOP;
      END LOOP;
  END LOOP;      
  RETURN v_expiry_date;      
END;
/


