DROP PROCEDURE CPI.EXTRACT_INCEPT2;

CREATE OR REPLACE PROCEDURE CPI.extract_incept2(
    p_line_cd           GIPI_POLBASIC.line_cd%TYPE,   
    p_subline_cd        GIPI_POLBASIC.subline_cd%TYPE,
    p_pol_iss_cd        GIPI_POLBASIC.iss_cd%TYPE,
    p_issue_yy          GIPI_POLBASIC.issue_yy%TYPE,
    p_pol_seq_no        GIPI_POLBASIC.pol_seq_no%TYPE,
    p_renew_no          GIPI_POLBASIC.renew_no%TYPE,
    p_loss_date         GIPI_POLBASIC.eff_date%TYPE,
    p_pol_eff_date  OUT VARCHAR2,
    p_pol_eff_date2 OUT GIPI_POLBASIC.incept_date%TYPE
    ) IS
  v_incept_date       gipi_polbasic.incept_date%TYPE;
  v_subline_time      varchar2(11);
BEGIN
    -- annabelle 02.03.06
  FOR v IN (SELECT SUBSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MI AM'), INSTR(TO_CHAR(TO_DATE(subline_time, 'SSSSS'), 'MM/DD/YYYY HH:MM AM'),'/',1, 2)+6) stime,
                   TO_DATE(TO_CHAR(TO_DATE(subline_time,'SSSSS'),'HH:MI AM'),'HH:MI AM') stime2 
                          FROM giis_subline
                          WHERE line_cd    = p_line_cd
                            AND subline_cd = p_subline_cd)
  LOOP
       v_subline_time := v.stime;
       exit;
  END LOOP;

-- get first the effectivity date of the policy
  FOR A1 IN
    (SELECT incept_date
       FROM gipi_polbasic
      WHERE line_cd    = p_line_cd
        AND subline_cd = p_subline_cd
        AND iss_cd     = p_pol_iss_cd
        AND issue_yy   = p_issue_yy
        AND pol_seq_no = p_pol_seq_no
        AND renew_no   = p_renew_no
        AND pol_flag IN ('1','2','3','X')
        AND NVL(endt_seq_no,0) = 0)
  LOOP
    v_incept_date  := a1.incept_date;
    EXIT;
  END LOOP;
  -- then check and retrieve for any change of incept in case there is
  -- endorsement of incept date
  FOR B1 IN
    (SELECT incept_date, endt_seq_no
       FROM gipi_polbasic
      WHERE line_cd            = p_line_cd
        AND subline_cd         = p_subline_cd
        AND iss_cd             = p_pol_iss_cd
        AND issue_yy           = p_issue_yy
        AND pol_seq_no         = p_pol_seq_no
        AND renew_no           = p_renew_no
        AND pol_flag           IN ('1','2','3','X')
        AND trunc(eff_date)    <= trunc(NVL(p_loss_date,sysdate))
        AND NVL(endt_seq_no,0) > 0
        AND incept_date        <> v_incept_date
        AND expiry_date         = endt_expiry_date
      ORDER BY eff_date DESC, endt_seq_no DESC)
  LOOP
    v_incept_date := b1.incept_date;
    --check for change in expiry using backward endt.
    FOR C IN
      (SELECT incept_date
         FROM gipi_polbasic
        WHERE line_cd              = p_line_cd
          AND subline_cd           = p_subline_cd
          AND iss_cd               = p_pol_iss_cd
          AND issue_yy             = p_issue_yy
          AND pol_seq_no           = p_pol_seq_no
          AND renew_no             = p_renew_no
          AND pol_flag             IN ('1','2','3','X')
          AND trunc(eff_date)      <= trunc(NVL(p_loss_date,sysdate))
          AND NVL(endt_seq_no,0)   > 0
          AND incept_date          <> b1.incept_date
          AND expiry_date          = endt_expiry_date
          AND NVL(back_stat,5)     = 2
          AND NVL(endt_seq_no,0)   > b1.endt_seq_no
        ORDER BY endt_seq_no DESC)
    LOOP
      v_incept_date  := c.incept_date;
      EXIT;
    END LOOP;
    EXIT;
  END LOOP;
    
    IF v_incept_date IS NULL THEN
        p_pol_eff_date := v_incept_date;
    ELSIF v_incept_date IS NOT NULL THEN
        --edited by annabelle 02.03.06
        -- commented by gmi :c003.pol_eff_date := to_date(to_char(v_incept_date, 'MM/DD/RRRR')||' '||v_subline_time, 'MM/DD/RRRR HH:MI AM');
        p_pol_eff_date := to_char(v_incept_date, 'MM-DD-RRRR')||' '||v_subline_time; --to_date(to_char(v_incept_date, 'MM/DD/RRRR')||v_subline_time, 'MM/DD/RRRR HH:MI AM');
        p_pol_eff_date2 := to_date(to_char(v_incept_date, 'MM/DD/RRRR')||v_subline_time, 'MM/DD/RRRR HH:MI AM');
    END IF;
END;
/


