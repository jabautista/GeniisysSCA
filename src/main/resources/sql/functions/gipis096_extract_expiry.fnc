DROP FUNCTION CPI.GIPIS096_EXTRACT_EXPIRY;

CREATE OR REPLACE FUNCTION CPI.GIPIS096_EXTRACT_EXPIRY
(p_line_cd           GIPI_POLBASIC.line_cd%TYPE,
 p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
 p_iss_cd            GIPI_POLBASIC.iss_cd%TYPE,
 p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
 p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
 p_renew_no          GIPI_POLBASIC.renew_no%TYPE)

RETURN DATE IS

  /*
  **  Created by   : Veronica V. Raymundo
  **  Date Created : July 21, 2011
  **  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
  **  Description  : Extract the latest expiry date in case there is an endorsement of expiry
  */
  
  v_max_eff_date      GIPI_POLBASIC.eff_date%TYPE;
  v_expiry_date       GIPI_POLBASIC.expiry_date%TYPE;
  v_max_endt_seq      GIPI_POLBASIC.endt_seq_no%TYPE;
  
BEGIN
  -- first get the expiry_date of the policy
  FOR A1 in (SELECT expiry_date
              FROM GIPI_POLBASIC a
             WHERE a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd     = p_iss_cd
               AND a.issue_yy   = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no   = p_renew_no
               AND a.pol_flag in ('1','2','3','X')
               AND NVL(a.endt_seq_no,0) = 0)
  LOOP
    v_expiry_date  := a1.expiry_date;
    -- then check and retrieve for any change of expiry in case there is 
    -- endorsement of expiry date
    FOR B1 IN (SELECT expiry_date, endt_seq_no
                 FROM GIPI_POLBASIC a
                WHERE a.line_cd    = p_line_cd
                  AND a.subline_cd = p_subline_cd
                  AND a.iss_cd     = p_iss_cd
                  AND a.issue_yy   = p_issue_yy
                  AND a.pol_seq_no = p_pol_seq_no
                  AND a.renew_no   = p_renew_no
                  AND a.pol_flag IN ('1','2','3','X')
                  AND NVL(a.endt_seq_no,0) > 0
                  AND expiry_date <> a1.expiry_date
                  AND expiry_date = endt_expiry_date
                ORDER BY a.eff_date DESC)
    LOOP
      v_expiry_date  := b1.expiry_date;
      v_max_endt_seq := b1.endt_seq_no;
      FOR B2 IN (SELECT expiry_date, endt_seq_no
                   FROM GIPI_POLBASIC a
                  WHERE a.line_cd    = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd     = p_iss_cd
                    AND a.issue_yy   = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no   = p_renew_no
                    AND a.pol_flag in ('1','2','3','X')
                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> B1.expiry_date
                    AND expiry_date = endt_expiry_date
               ORDER BY a.eff_date DESC)
      LOOP
        v_expiry_date  := b2.expiry_date;
        v_max_endt_seq := b2.endt_seq_no;
        EXIT;
     END LOOP;
      --check for change in expiry using backward endt. 
      FOR C IN (SELECT expiry_date
                  FROM GIPI_POLBASIC a
                 WHERE a.line_cd    = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd     = p_iss_cd
                   AND a.issue_yy   = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no   = p_renew_no
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
  RETURN v_expiry_date;      
END;
/


