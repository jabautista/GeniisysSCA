DROP PROCEDURE CPI.LATEST_LOC_RISK;

CREATE OR REPLACE PROCEDURE CPI.latest_loc_risk (p_line_cd     IN gipi_polbasic.line_cd%TYPE,
                             p_subline_cd  IN gipi_polbasic.line_cd%TYPE,
                             p_iss_cd      IN gipi_polbasic.iss_cd%TYPE,
                             p_issue_yy    IN gipi_polbasic.issue_yy%TYPE,
                             p_pol_seq_no  IN gipi_polbasic.pol_seq_no%TYPE,
                             p_renew_no    IN gipi_polbasic.renew_no%TYPE,
                             p_item_no     IN gipi_fireitem.item_no%TYPE,
                             p_loc_risk   OUT VARCHAR2) IS
  BEGIN
    FOR loc IN (SELECT y.loc_risk1||' '||y.loc_risk2||' '||y.loc_risk3 loc_risk
                  FROM gipi_polbasic x,
                       gipi_fireitem y
                 WHERE x.line_cd    = p_line_cd
                   AND x.subline_cd = p_subline_cd
                   AND x.iss_cd     = p_iss_cd
                   AND x.issue_yy   = p_issue_yy
                   AND x.pol_seq_no = p_pol_seq_no
                   AND x.renew_no   = p_renew_no
                   AND x.pol_flag IN ('1','2','3','X')
                   AND NOT EXISTS(SELECT 'X'
                                    FROM gipi_polbasic m,
                                         gipi_fireitem  n
                                   WHERE m.line_cd    = p_line_cd
                                     AND m.subline_cd = p_subline_cd
                                     AND m.iss_cd     = p_iss_cd
                                     AND m.issue_yy   = p_issue_yy
                                     AND m.pol_seq_no = p_pol_seq_no
                                     AND m.renew_no   = p_renew_no
                                     AND m.pol_flag IN ('1','2','3','X')
                                     AND m.endt_seq_no > x.endt_seq_no
                                     AND NVL(m.back_stat,5) = 2
                                     AND m.policy_id  = n.policy_id
                                     AND n.item_no    = p_item_no
                                     AND (n.loc_risk1 IS NOT NULL
                                          OR n.loc_risk2 IS NOT NULL
                                          OR n.loc_risk3 IS NOT NULL))
                   AND x.policy_id  = y.policy_id
                   AND y.item_no    = p_item_no
                   AND (y.loc_risk1 IS NOT NULL
                        OR y.loc_risk2 IS NOT NULL
                        OR y.loc_risk3 IS NOT NULL)
              ORDER BY x.eff_date DESC)
    LOOP
      p_loc_risk := loc.loc_risk;
      EXIT;
    END LOOP;
  END;
/


