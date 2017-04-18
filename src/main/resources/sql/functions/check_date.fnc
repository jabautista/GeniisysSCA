DROP FUNCTION CPI.CHECK_DATE;

CREATE OR REPLACE FUNCTION CPI.Check_Date
/** rollie 02/18/04
*** date parameter of the last endorsement of policy
*** must not be within the date given, else it will
*** be exluded
*** NOTE: policy with pol_flag = '4' only
**/
	(p_scope	 	NUMBER,
	 p_line_cd	    gipi_polbasic.line_cd%TYPE,
	 p_subline_cd	gipi_polbasic.subline_Cd%TYPE,
	 p_iss_cd	    gipi_polbasic.iss_cd%TYPE,
	 p_issue_yy	    gipi_polbasic.issue_yy%TYPE,
	 p_pol_seq_no	gipi_polbasic.pol_seq_no%TYPE,
	 p_renew_no	    gipi_polbasic.renew_no%TYPE,
 	 p_param_date	NUMBER,
	 p_from_date	DATE,
	 p_to_date	    DATE
	 )
   RETURN NUMBER
IS
  v_check_date	NUMBER(1) := 0;
BEGIN
  FOR a IN (
    SELECT a.issue_date issue_date,
		   a.eff_date   eff_date,
		   a.booking_mth booking_month,
		   a.booking_year booking_year,
		   a.acct_ent_date acct_ent_date,
		   a.spld_acct_ent_date spld_acct_ent_date
      FROM gipi_polbasic a
	 WHERE a.line_cd     = p_line_cd
	   AND a.subline_cd  = p_subline_cd
 	   AND a.iss_cd      = p_iss_cd
	   AND a.issue_yy    = p_issue_yy
	   AND a.pol_seq_no  = p_pol_seq_no
	   AND a.renew_no    = p_renew_no
	   AND a.endt_seq_no = Get_Endt_Seq_No(a.line_cd,a.subline_cd,a.iss_cd,a.issue_yy,a.pol_seq_no,a.renew_no))
      LOOP
	    IF p_param_date = 1 THEN ---based on issue_date
 		   IF TRUNC(a.issue_date) NOT BETWEEN p_from_date AND p_to_date THEN
	          v_check_date := 1;
	       END IF;
		ELSIF p_param_date = 2 THEN --based on incept_date
		   IF TRUNC(a.eff_date) NOT BETWEEN p_from_date AND p_to_date THEN
	          v_check_date := 1;
	       END IF;
		ELSIF p_param_date = 3 THEN --based on booking mth/yr
		   IF LAST_DAY ( TO_DATE ( a.booking_month || ',' || TO_CHAR (a.booking_year),'FMMONTH,YYYY'))
		      NOT BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
			  v_check_date := 1;
		   END IF;
		ELSIF p_param_date = 4 THEN --based on acct_ent_date
		   IF (TRUNC (a.acct_ent_date) NOT BETWEEN p_from_date AND p_to_date
                  OR NVL (TRUNC (a.spld_acct_ent_date), p_to_date + 1)
                        NOT BETWEEN p_from_date AND p_to_date) THEN
			  v_check_date := 1;
		   END IF;
		END IF;
      END LOOP;
      RETURN (v_check_Date);
END;
/


