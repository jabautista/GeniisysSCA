CREATE OR REPLACE PACKAGE CPI.p_prod_budget_yearly
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
			);

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
   RETURN NUMBER;
END p_prod_budget_yearly;
/


