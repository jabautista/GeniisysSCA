DROP FUNCTION CPI.GET_CANCEL_EFFECTIVITY;

CREATE OR REPLACE FUNCTION CPI.Get_Cancel_Effectivity
   (p_line_cd     gipi_polbasic.line_cd%TYPE,
	p_subline_cd  gipi_polbasic.subline_cd%TYPE,
	p_iss_cd      gipi_polbasic.iss_cd%TYPE,
	p_issue_yy    gipi_polbasic.issue_yy%TYPE,
	p_pol_seq_no  gipi_polbasic.pol_seq_no%TYPE,
	p_renew_no    gipi_polbasic.renew_no%TYPE)
RETURN VARCHAR2 AS
  v_eff_date	DATE;
BEGIN
  FOR pol IN (SELECT eff_date
                FROM gipi_polbasic
			   WHERE line_cd    = p_line_cd
			     AND subline_cd = p_subline_cd
				 AND iss_cd     = p_iss_cd
				 AND issue_yy   = p_issue_yy
				 AND pol_seq_no = p_pol_seq_no
				 AND renew_no   = p_renew_no
				 AND pol_flag   = '4'
			   ORDER BY endt_seq_no DESC)
  LOOP
--	RETURN(pol.eff_date);
    v_eff_date := pol.eff_date;
	EXIT;
  END LOOP;
  IF v_eff_date >= SYSDATE THEN
     RETURN ('Y');
  ELSE
	 RETURN ('N');
  END IF;
END;
/


