DROP PROCEDURE CPI.LATEST_PREM_RT;

CREATE OR REPLACE PROCEDURE CPI.latest_prem_rt(p_line_cd      IN gipi_polbasic.line_cd%TYPE,
                           p_subline_cd   IN gipi_polbasic.line_cd%TYPE,
                           p_iss_cd       IN gipi_polbasic.iss_cd%TYPE,
                           p_issue_yy     IN gipi_polbasic.issue_yy%TYPE,
                           p_pol_seq_no   IN gipi_polbasic.pol_seq_no%TYPE,
                           p_renew_no     IN gipi_polbasic.renew_no%TYPE,
                           p_item_no      IN gipi_fireitem.item_no%TYPE,
						   p_peril_cd     IN gipi_itmperil.peril_cd%TYPE,
   			               v_prem_rt     OUT gipi_itmperil.prem_rt%TYPE) IS
  BEGIN
    FOR prem IN  (SELECT y.prem_rt prem_rt
                    FROM gipi_polbasic x,
                         gipi_itmperil y
                   WHERE x.line_cd    = p_line_cd
                     AND x.subline_cd = p_subline_cd
                     AND x.iss_cd     = p_iss_cd
                     AND x.issue_yy   = p_issue_yy
                     AND x.pol_seq_no = p_pol_seq_no
                     AND x.renew_no   = p_renew_no
                     AND x.pol_flag IN ('1','2','3','X')
                     AND x.policy_id  = y.policy_id
                     AND y.item_no    = p_item_no
					 AND y.peril_cd   = p_peril_cd
                     AND y.prem_rt IS NOT NULL
		           ORDER BY x.endt_seq_no DESC)
    LOOP
      v_prem_rt := prem.prem_rt;
	EXIT;
    END LOOP;
  END;
/


