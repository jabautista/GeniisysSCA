CREATE OR REPLACE PACKAGE BODY CPI.p_prod_budget_yearly
/* rollie 31jan2005 @ CPI QUAD
** This package will hold all the procedures and functions that will
** handle the extraction of budget production
*/
AS
  PROCEDURE EXTRACT(
  			p_iss_cd   	   IN VARCHAR2,
			p_line_cd	   IN VARCHAR2,
			p_year		   IN NUMBER,
			p_date_param   IN NUMBER, /*  1 - based on issue_date
						   	   		  	  2 - based on incept_date
										  3 - based on booking_month
										  4 - based on acct_ent_date */
			p_iss_param    IN NUMBER, /*  1 - based on cred_branch
						   	  		 	  2 - based on iss_cd */
			p_special_pol  IN VARCHAR2/*  Y - include special policies
						   	  			  N - exclue special policies */
			)
    AS
	TYPE v_iss_cd_tab 		  IS TABLE OF gipi_polbasic.iss_cd%TYPE;
	TYPE v_line_cd_tab 	      IS TABLE OF gipi_polbasic.line_cd%TYPE;
	TYPE v_prem_tab 	      IS TABLE OF gixx_prod_budget.curr_prem%TYPE;
	TYPE v_year_tab 	      IS TABLE OF gipi_polbasic.booking_year%TYPE;
	TYPE v_pct_tab			  IS TABLE OF gipi_invoice.currency_rt%TYPE;
	v_line_cd				  v_line_cd_tab;
	v_iss_cd				  v_iss_cd_tab;
	v_curr_year				  v_year_tab;
	v_prev_year				  v_year_tab;
	v_curr_prem			  	  v_prem_tab;
	v_prev_prem			  	  v_prem_tab;
	v_prem_diff				  v_prem_tab;
	v_prem_pct				  v_pct_tab;
	v_budget				  v_prem_tab;
	v_budget_diff			  v_prem_tab;
	v_budget_pct			  v_pct_tab;
	v_prev_year				  NUMBER(4) := p_year - 1;

  BEGIN
    DELETE FROM gixx_prod_budget
	 WHERE user_id = USER;

	/* getting the data for the current year*/

	SELECT pol.line_cd,
		   pol.iss_cd,
		   SUM(pol.prem_amt)
	BULK COLLECT INTO
	 	   v_line_cd,
	  	   v_iss_cd,
		   v_curr_prem
	  FROM gipi_polbasic pol
	 WHERE pol_flag<>'5'
/*	   AND DECODE(p_date_param,1,TO_CHAR(pol.issue_date,'YYYY'),
	   	   					   2,TO_CHAR(pol.eff_date,'YYYY'),
							   3,pol.booking_year,
							   4,TO_CHAR(pol.acct_ent_date,'YYYY')) = p_year*/
       AND check_date_policy(p_date_param,
	   	   					 p_year,
							 pol.issue_date,
							 pol.eff_date,
							 pol.acct_ent_date,
							 pol.spld_acct_ent_date,
							 pol.booking_year) = 1
       AND pol.line_cd = NVL(p_line_cd,pol.line_cd)
	   AND pol.reg_policy_sw = DECODE(p_special_pol,'Y',pol.reg_policy_sw,'Y')
	   AND DECODE(p_iss_param,2,pol.iss_cd,pol.cred_branch) =
	   	   NVL(p_iss_cd,DECODE(p_iss_param,2,pol.iss_cd,pol.cred_branch))
      GROUP BY pol.line_cd, pol.iss_cd;
	IF SQL%FOUND THEN
	  FORALL cnt IN v_line_cd.FIRST..v_line_cd.LAST
        INSERT INTO gixx_prod_budget (
		 	   		 prev_year,
					 curr_year,
					 line_cd,
					 iss_cd,
					 curr_prem,
					 prev_prem,
					 budget,
					 user_id,
					 last_update,
					 iss_param)
  			 VALUES (p_year-1,
			 		 p_year,
					 v_line_cd(cnt),
					 v_iss_cd(cnt),
					 v_curr_prem(cnt),
					 NULL,
					 NULL,
					 USER,
					 SYSDATE,
					 p_iss_param);
	END IF;

	/* getting the data from previous year */

	MERGE INTO gixx_prod_budget gpb USING (
      SELECT pol.line_cd line_cd,
	  		 pol.iss_cd  iss_cd,
		     SUM(pol.prem_amt) prev_prem
   	    FROM gipi_polbasic pol
	   WHERE pol_flag<>'5'
	     /*AND DECODE(p_date_param,1,TO_CHAR(pol.issue_date,'YYYY'),
	   	   					     2,TO_CHAR(pol.eff_date,'YYYY'),
							     3,pol.booking_year,
							     4,TO_CHAR(pol.acct_ent_date,'YYYY')) = p_year - 1*/
         AND check_date_policy(p_date_param,
	   	   					 (p_year - 1),
							 pol.issue_date,
							 pol.eff_date,
							 pol.acct_ent_date,
							 pol.spld_acct_ent_date,
							 pol.booking_year) = 1
         AND pol.line_cd = NVL(p_line_cd,pol.line_cd)
		 AND pol.reg_policy_sw = DECODE(p_special_pol,'Y',pol.reg_policy_sw,'Y')
	     AND DECODE(p_iss_param,2,pol.iss_cd,pol.cred_branch) =
	    	   NVL(p_iss_cd,DECODE(p_iss_param,2,pol.iss_cd,pol.cred_branch))
       GROUP BY pol.line_cd, pol.iss_cd ) prev_pol
     ON (gpb.iss_cd = prev_pol.iss_cd AND gpb.line_cd = prev_pol.line_cd AND gpb.user_id = USER)
     WHEN MATCHED THEN UPDATE
       SET gpb.prev_prem = NVL(prev_pol.prev_prem,0),
	   	   gpb.prev_year = p_year - 1
     WHEN NOT MATCHED THEN
       INSERT (iss_cd,line_cd,curr_year,prev_year,prev_prem,user_id,last_update)
       VALUES (prev_pol.iss_cd,prev_pol.line_cd,p_year,p_year-1,prev_pol.prev_prem,USER,SYSDATE);

	/* merging giac_prod_budget with gixx_prod_budget */

	MERGE INTO gixx_prod_budget gpb USING (
      SELECT YEAR,line_cd,iss_cd,budget
	    FROM giac_prod_budget
	   WHERE YEAR = p_year) budget
     ON (gpb.iss_cd = budget.iss_cd AND gpb.line_cd = budget.line_cd AND budget.YEAR = gpb.curr_year AND gpb.user_id = USER)
     WHEN MATCHED THEN UPDATE
       SET gpb.budget = NVL(budget.budget,0)
     WHEN NOT MATCHED THEN
       INSERT (iss_cd,line_cd,curr_year,prev_year,budget,user_id,last_update)
       VALUES (budget.iss_cd,budget.line_cd,p_year,p_year-1,budget.budget,USER,SYSDATE);

	COMMIT;
  END;

  FUNCTION check_date_policy
   /* rollie 31jan2005 @ CPI QUAD
   ** validates if policy's date is within the given date parameter
   */
   (p_param_date  	      NUMBER,
    p_year                NUMBER,
 	p_curr_issue_date  	  DATE,
  	p_curr_eff_date   	  DATE,
  	p_curr_acct_ent_date  DATE,
  	p_curr_spld_acct  	  DATE,
  	p_curr_booking_year   gipi_polbasic.booking_year%TYPE)
   RETURN NUMBER IS
   	 v_check_date NUMBER(1) := 0;
   BEGIN
     IF p_param_date = 1 THEN ---based on issue_date
        IF TO_CHAR(p_curr_issue_date,'YYYY') = p_year THEN
           v_check_date := 1;
     	END IF;
     ELSIF p_param_date = 2 THEN --based on incept_date
        IF TO_CHAR(p_curr_eff_date,'YYYY') = p_year THEN
           v_check_date := 1;
        END IF;
  	 ELSIF p_param_date = 3 THEN --based on booking mth/yr
        IF TO_CHAR(p_curr_booking_year,'YYYY') = p_year THEN
           v_check_date := 1;
        END IF;
     ELSIF p_param_date = 4 THEN --based on acct_ent_date
        IF TO_CHAR(p_curr_acct_ent_date,'YYYY') = p_year THEN
           IF TO_CHAR(p_curr_spld_acct,'YYYY') = p_year AND
			  p_curr_spld_acct IS NOT NULL THEN
		      v_check_date := 0;
		   ELSE
              v_check_date := 1;
		   END IF;
        END IF;
     END IF;
     RETURN (v_check_date);
   END;
END p_prod_budget_yearly;
/


