DROP PROCEDURE CPI.GET_EXPIRY_INCEPT;

CREATE OR REPLACE PROCEDURE CPI.GET_EXPIRY_INCEPT (p_expiry_date   IN OUT gicl_claims.expiry_date%TYPE,
                             p_incept_date   IN OUT gicl_claims.expiry_date%TYPE,
                             p_loss_date            gicl_claims.loss_date%TYPE,
                             p_clm_endt_seq_no      gicl_claims.max_endt_seq_no%TYPE,
                             p_line_cd              gicl_claims.line_cd%TYPE,
                             p_subline_cd           gicl_claims.subline_cd%TYPE,
                             p_pol_iss_cd           gicl_claims.iss_cd%TYPE,
                             p_issue_yy             gicl_claims.issue_yy%TYPE,
                             p_pol_seq_no           gicl_claims.pol_seq_no%TYPE,
                             p_renew_no         gicl_claims.renew_no%TYPE)
IS
  v_expiry_date  gicl_claims.expiry_date%TYPE;
  v_incept_date  gicl_claims.expiry_date%TYPE;
  v_loss_date            gicl_claims.loss_date%TYPE;
BEGIN
  -- first get the expiry_date of the policy
  IF v_expiry_date IS NULL or v_incept_date IS NULL THEN
     FOR A1 IN (SELECT expiry_date, incept_date
                  FROM gipi_polbasic a
                 WHERE a.line_cd    = p_line_cd
                   AND a.subline_cd = p_subline_cd
                   AND a.iss_cd     = p_pol_iss_cd
                   AND a.issue_yy   = p_issue_yy
                   AND a.pol_seq_no = p_pol_seq_no
                   AND a.renew_no   = p_renew_no
                   AND a.pol_flag IN ('1','2','3','X')
                   AND NVL(a.endt_seq_no,0) = 0)
     LOOP
       p_expiry_date  := NVL(p_expiry_date,a1.expiry_date);
       p_incept_date  := NVL(p_incept_date,a1.incept_date);
       EXIT;
     END LOOP;
  END IF;
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
                AND a.pol_flag IN ('1','2','3','X')
                AND a.eff_date   <= NVL(p_loss_date,sysdate)
                AND NVL(a.endt_seq_no,0) > p_clm_endt_seq_no
                AND expiry_date <> p_expiry_date
                AND expiry_date = endt_expiry_date
           ORDER BY a.eff_date DESC, a.endt_seq_no DESC)
  LOOP
    p_expiry_date  := b1.expiry_date;
    --check for change in expiry using backward endt.
    FOR C IN (SELECT expiry_date
                FROM gipi_polbasic a
               WHERE a.line_cd    = p_line_cd
                 AND a.subline_cd = p_subline_cd
                 AND a.iss_cd     = p_pol_iss_cd
                 AND a.issue_yy   = p_issue_yy
                 AND a.pol_seq_no = p_pol_seq_no
                 AND a.renew_no   = p_renew_no
                 AND a.pol_flag IN ('1','2','3','X')
                 AND a.eff_date   <= NVL(v_loss_date,sysdate)
                 AND NVL(a.endt_seq_no,0) > 0
                 AND expiry_date <> p_expiry_date
                 AND expiry_date = endt_expiry_date
                 AND NVL(a.back_stat,5) = 2
                 AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
            ORDER BY a.endt_seq_no DESC)
    LOOP
      p_expiry_date  := c.expiry_date;
      EXIT;
    END LOOP;
    EXIT;
  END LOOP;
  -- then check and retrieve for any change of incept in case there is
  -- endorsement of incept date
  FOR B1 IN (SELECT incept_date, endt_seq_no
              FROM gipi_polbasic a
             WHERE a.line_cd    = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd     = p_pol_iss_cd
               AND a.issue_yy   = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no   = p_renew_no
               AND a.pol_flag IN ('1','2','3','X')
               AND a.eff_date   <= NVL(p_loss_date,sysdate)
               AND NVL(a.endt_seq_no,0) > p_clm_endt_seq_no
               AND incept_date <> p_incept_date
               AND expiry_date = endt_expiry_date
          ORDER BY a.eff_date DESC, a.endt_seq_no DESC)
  LOOP
    p_incept_date  := b1.incept_date;
    --check for change in expiry using backward endt.
    FOR C IN (SELECT incept_date
                FROM gipi_polbasic a
               WHERE a.line_cd    = p_line_cd
                 AND a.subline_cd = p_subline_cd
                 AND a.iss_cd     = p_pol_iss_cd
                 AND a.issue_yy   = p_issue_yy
                 AND a.pol_seq_no = p_pol_seq_no
                 AND a.renew_no   = p_renew_no
                 AND a.pol_flag IN ('1','2','3','X')
                 AND a.eff_date   <= NVL(p_loss_date,sysdate)
                 AND NVL(a.endt_seq_no,0) > 0
                 AND incept_date <> p_incept_date
                 AND expiry_date = endt_expiry_date
                 AND NVL(a.back_stat,5) = 2
                 AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
            ORDER BY a.endt_seq_no DESC)
    LOOP
      p_incept_date  := c.incept_date;
      EXIT;
    END LOOP;
    EXIT;
  END LOOP;
END;
/


