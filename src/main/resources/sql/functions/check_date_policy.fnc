DROP FUNCTION CPI.CHECK_DATE_POLICY;

CREATE OR REPLACE FUNCTION CPI.Check_Date_Policy
    /* rollie 19july2004
	** evaluates given column date
	** if falls between given dates
	** per policy  
    */
	(p_param_date	 NUMBER,
	 p_from_date	 DATE,
	 p_to_date	     DATE,
	 p_issue_date	 DATE,
	 p_eff_date   DATE,
	 p_acct_ent_date DATE,
	 p_spld_acct	 DATE,
 	 p_booking_mth	 GIPI_POLBASIC.booking_mth%TYPE,
	 p_booking_year  GIPI_POLBASIC.booking_year%TYPE
)
   RETURN NUMBER IS
	 v_check_date	NUMBER(1) := 0;
   BEGIN
	 IF p_param_date = 1 THEN ---based on issue_date
 	    IF TRUNC(p_issue_date) BETWEEN p_from_date AND p_to_date THEN
	       v_check_date := 1;
	    END IF;
	 ELSIF p_param_date = 2 THEN --based on incept_date
	    IF TRUNC(p_eff_date) BETWEEN p_from_date AND p_to_date THEN
	       v_check_date := 1;
	    END IF;
	 ELSIF p_param_date = 3 THEN --based on booking mth/yr
	    IF LAST_DAY ( TO_DATE ( p_booking_mth || ',' || TO_CHAR (p_booking_year),'FMMONTH,YYYY'))
	 	   BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
		    v_check_date := 1;
 	    END IF;
	 ELSIF p_param_date = 4 THEN --based on acct_ent_date
	    IF (TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date
         OR NVL (TRUNC (p_spld_acct), p_to_date + 1)    BETWEEN p_from_date AND p_to_date) THEN
		    v_check_date := 1;
		END IF;
  	 END IF;
 	 RETURN (v_check_Date);
   END;
/


