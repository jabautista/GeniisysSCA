DROP PROCEDURE CPI.EXTRACT_EXPIRY3;

CREATE OR REPLACE PROCEDURE CPI.extract_expiry3(
    p_line_cd           IN GIPI_WPOLBAS.line_cd%TYPE,
    p_subline_cd        IN GIPI_WPOLBAS.subline_cd%TYPE,
    p_pol_iss_cd        IN GIPI_WPOLBAS.iss_cd%TYPE,
    p_issue_yy          IN GIPI_WPOLBAS.issue_yy%TYPE,
    p_pol_seq_no        IN GIPI_WPOLBAS.pol_seq_no%TYPE,
    p_renew_no          IN GIPI_WPOLBAS.renew_no%TYPE,
    p_loss_date         IN gipi_polbasic.eff_date%TYPE,
    p_expiry_date       OUT gipi_polbasic.expiry_date%TYPE
    ) IS
  v_max_eff_date      gipi_polbasic.eff_date%TYPE;
  v_expiry_date       gipi_polbasic.expiry_date%TYPE;
  v_max_endt_seq      gipi_polbasic.endt_seq_no%TYPE; -- by Pia, 02/09/02

BEGIN
  -- first get the expiry_date of the policy
  FOR A1 in (SELECT expiry_date
              FROM gipi_polbasic a
             WHERE a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd     = p_pol_iss_cd
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
                FROM gipi_polbasic a
               WHERE a.line_cd    = p_line_cd
                 AND a.subline_cd = p_subline_cd
                 AND a.iss_cd     = p_pol_iss_cd
                 AND a.issue_yy   = p_issue_yy
                 AND a.pol_seq_no = p_pol_seq_no
                 AND a.renew_no   = p_renew_no
                 AND a.pol_flag in ('1','2','3','X')
                 AND a.eff_date   <= p_loss_date              
                 AND NVL(a.endt_seq_no,0) > 0
                 AND expiry_date <> a1.expiry_date
                 AND expiry_date = endt_expiry_date
            ORDER BY a.eff_date desc)
    LOOP
      v_expiry_date  := b1.expiry_date;
/* the following have been added by Pia, 02/09/02 
** (v_max_endt_seq_no, B1 loop) */
      v_max_endt_seq := b1.endt_seq_no;
      FOR B2 IN (SELECT expiry_date, endt_seq_no
                   FROM gipi_polbasic a
                  WHERE a.line_cd    = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd     = p_pol_iss_cd
                    AND a.issue_yy   = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no   = p_renew_no
                    AND a.pol_flag in ('1','2','3','X')
                    AND TRUNC(a.eff_date)   <= TRUNC(p_loss_date)              
                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> B1.expiry_date
                    AND expiry_date = endt_expiry_date
               ORDER BY a.eff_date desc)
      LOOP
        v_expiry_date  := b2.expiry_date;
        v_max_endt_seq := b2.endt_seq_no;
        EXIT;
      END LOOP; --B2
      --check for change in expiry using backward endt. 
      FOR C IN (SELECT expiry_date
                  FROM gipi_polbasic a
                 WHERE a.line_cd    = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd     = p_pol_iss_cd
                   AND a.issue_yy   = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no   = p_renew_no
                   AND a.pol_flag in ('1','2','3','X')
                   AND a.eff_date   <= p_loss_date
                   AND NVL(a.endt_seq_no,0) > 0
                   AND expiry_date <> a1.expiry_date
                   AND expiry_date = endt_expiry_date
                   AND nvl(a.back_stat,5) = 2
               --    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no --comment by Pia 020902
                   AND NVL(a.endt_seq_no,0) > v_max_endt_seq
              ORDER BY a.endt_seq_no desc)
      LOOP
        v_expiry_date  := c.expiry_date;
        EXIT;
      END LOOP;    
      EXIT;
    END LOOP;
  END LOOP;
  p_expiry_date := v_expiry_date;      
END;
/


