DROP PROCEDURE CPI.EXTRACT_EXPIRY4;

CREATE OR REPLACE PROCEDURE CPI.extract_expiry4(
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,   
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_loss_date         GIPI_POLBASIC.eff_date%TYPE,
    p_expiry_date  OUT  VARCHAR2,  
    p_expiry_date2 OUT  GIPI_POLBASIC.expiry_date%TYPE
    ) IS
  v_max_eff_date        gipi_polbasic.eff_date%TYPE;
  v_expiry_date         gipi_polbasic.expiry_date%TYPE;
  v_max_endt_seq        gipi_polbasic.endt_seq_no%TYPE;
  v_test                NUMBER;
  v_subline_time        giis_subline.subline_time%TYPE;
BEGIN
    -- annabelle 02.03.06
  FOR v IN (SELECT SUBSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MI AM'), INSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'),'/',1, 2)+6) stime
                          FROM giis_subline
                          WHERE line_cd    = p_line_cd
                            AND subline_cd = p_subline_cd)
  LOOP
       v_subline_time := v.stime;
  END LOOP;
    
  -- first get the expiry_date of the policy
  FOR A1 IN (SELECT expiry_date
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
                 AND a.pol_flag IN ('1','2','3','X')
                 AND a.eff_date   <= NVL(p_loss_date,sysdate)
                 AND NVL(a.endt_seq_no,0) > 0
                 AND expiry_date <> a1.expiry_date
                 AND expiry_date = endt_expiry_date
            ORDER BY a.eff_date DESC)
    LOOP
      v_expiry_date  := b1.expiry_date;
      v_max_endt_seq := b1.endt_seq_no;
      --check if changes again occured in expiry date
      FOR B2 IN (SELECT expiry_date, endt_seq_no
                   FROM gipi_polbasic a
                  WHERE a.line_cd    = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd     = p_pol_iss_cd
                    AND a.issue_yy   = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no   = p_renew_no
                    AND a.pol_flag IN ('1','2','3','X')
                    AND a.eff_date   <= NVL(p_loss_date,sysdate)
                    AND NVL(a.endt_seq_no,0) > b1.endt_seq_no
                    AND expiry_date <> b1.expiry_date
                    AND expiry_date = endt_expiry_date
               ORDER BY a.eff_date DESC)
     LOOP
       v_expiry_date  := b2.expiry_date;
       v_max_endt_seq :=b2.endt_seq_no;
       EXIT;
     END LOOP; 
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
                   AND a.eff_date   <= NVL(p_loss_date,sysdate)
                   AND NVL(a.endt_seq_no,0) > 0
                   AND expiry_date <> a1.expiry_date
                   AND expiry_date = endt_expiry_date
                   AND NVL(a.back_stat,5) = 2
                   AND NVL(a.endt_seq_no,0) > v_max_endt_seq
              ORDER BY a.endt_seq_no DESC)
      LOOP
        v_expiry_date  := c.expiry_date;
        EXIT;
      END LOOP;
      EXIT;
    END LOOP;
  END LOOP;
  IF v_expiry_date IS NULL THEN
       p_expiry_date := v_expiry_date;
       p_expiry_date2 := v_expiry_date;
  ELSIF v_expiry_date IS NOT NULL THEN
       p_expiry_date := to_char(v_expiry_date, 'MM-DD-RRRR')||' '||v_subline_time;
       p_expiry_date2 := to_date(to_char(v_expiry_date, 'MM/DD/RRRR')||v_subline_time, 'MM/DD/RRRR HH:MI AM');
  END IF;
END;
/


