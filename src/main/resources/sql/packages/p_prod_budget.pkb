CREATE OR REPLACE PACKAGE BODY CPI.P_Prod_Budget
/* rollie 31jan2005 @ CPI QUAD
** This package will hold all the procedures and functions that will
** handle the extraction of budget production
*/
AS
  PROCEDURE EXTRACT(
            p_iss_cd       IN VARCHAR2,
            p_line_cd      IN VARCHAR2,
            p_from_date    IN DATE,
            p_to_date      IN DATE,
            p_date_param   IN NUMBER, /*  1 - based on issue_date
                                          2 - based on incept_date
                                          3 - based on booking_month
                                          4 - based on acct_ent_date */
            p_iss_param    IN NUMBER, /*  1 - based on cred_branch
                                          2 - based on iss_cd */
            p_special_pol  IN VARCHAR2,/* Y - include special policies
                                          N - exclue special policies */
            p_module_id IN VARCHAR2) /*Added: Ronnie 06082012 use to determine module access*/
    AS
    TYPE v_iss_cd_tab         IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
    TYPE v_line_cd_tab        IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
    TYPE v_prem_tab           IS TABLE OF GIXX_PROD_BUDGET.curr_prem%TYPE;
    TYPE v_year_tab           IS TABLE OF GIPI_POLBASIC.booking_year%TYPE;
    TYPE v_pct_tab            IS TABLE OF GIPI_INVOICE.currency_rt%TYPE;
    TYPE v_pol_tab            IS TABLE OF GIPI_polbasic.policy_id%TYPE;
    v_pol                     v_pol_tab;
    v_line_cd                 v_line_cd_tab;
    v_iss_cd                  v_iss_cd_tab;
    v_curr_year               v_year_tab;
    v_prev_year               v_year_tab;
    v_curr_prem               v_prem_tab;
    v_prev_prem               v_prem_tab;
    v_prem_diff               v_prem_tab;
    v_prem_pct                v_pct_tab;
    v_budget                  v_prem_tab;
    v_budget_diff             v_prem_tab;
    v_budget_pct              v_pct_tab;
    v_year                    NUMBER(4);

  BEGIN
    DELETE FROM GIXX_PROD_BUDGET
	 WHERE user_id = USER;

	/* getting the data for the current year*/

    SELECT pol.line_cd,
           DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) iss_cd,
           SUM(pol.prem_amt)
    BULK COLLECT INTO
            v_line_cd,
             v_iss_cd,
           v_curr_prem
      FROM GIPI_POLBASIC pol
     WHERE pol_flag<>'5'
       AND Check_Date_Policy(p_date_param,
                                   p_from_date,
                             p_to_date,
                             pol.issue_date,
                             pol.eff_date,
                             pol.acct_ent_date,
                             pol.spld_acct_ent_date,
                             pol.booking_year,
                             pol.booking_mth) = 1
       AND pol.line_cd          = NVL(p_line_cd,pol.line_cd)
       AND pol.reg_policy_sw = DECODE(p_special_pol,'Y',pol.reg_policy_sw,'Y')
         AND DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) =
              NVL(p_iss_cd,DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)))
      --Begin: RCD 06082012 Check accessible branch per user           
      AND DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) IN (
             SELECT iss_cd
               FROM giis_issource
              WHERE iss_cd =
                       DECODE (check_user_per_iss_cd_acctg (NULL,
                                                            iss_cd,
                                                            p_module_id
                                                           ),
                               1, iss_cd,
                               NULL
                              ))
      --End: RCD 06082012 Check accessible branch per user         
      GROUP BY pol.line_cd, DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd));
    IF SQL%FOUND THEN
      FORALL cnt IN v_line_cd.FIRST..v_line_cd.LAST
        INSERT INTO GIXX_PROD_BUDGET (
                         prev_year,
                     curr_year,
                     from_date,
                     TO_DATE,
                     line_cd,
                     iss_cd,
                     curr_prem,
                     prev_prem,
                     budget,
                     user_id,
                     last_update,
                     iss_param)
               VALUES (TO_CHAR(ADD_MONTHS(p_to_date,-12),'YYYY'),
                      TO_CHAR(p_to_date,'YYYY'),
                     p_from_date,
                     p_to_date,
                     v_line_cd(cnt),
                     v_iss_cd(cnt),
                     v_curr_prem(cnt),
                     0,
                     0,
                     USER,
                     SYSDATE,
                     p_iss_param);
    END IF;


	/* getting the data from previous year */

	MERGE INTO GIXX_PROD_BUDGET gpb USING (
      SELECT pol.line_cd line_cd,
               DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd))  iss_cd,
             SUM(pol.prem_amt) prev_prem
           FROM GIPI_POLBASIC pol
       WHERE pol_flag<>'5'
         AND Check_Date_Policy(p_date_param,
                                   ADD_MONTHS(p_from_date,-12),
                             ADD_MONTHS(p_to_date,-12),
                             pol.issue_date,
                             pol.eff_date,
                             pol.acct_ent_date,
                             pol.spld_acct_ent_date,
                             pol.booking_year,
                             pol.booking_mth) = 1
         AND pol.line_cd        = NVL(p_line_cd,pol.line_cd)
         AND pol.reg_policy_sw = DECODE(p_special_pol,'Y',pol.reg_policy_sw,'Y')
         AND DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) =
               NVL(p_iss_cd,DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)))
         --Begin: RCD 06082012 Check accessible branch per user           
      AND DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) IN (
             SELECT iss_cd
               FROM giis_issource
              WHERE iss_cd =
                       DECODE (check_user_per_iss_cd_acctg (NULL,
                                                            iss_cd,
                                                            p_module_id
                                                           ),
                               1, iss_cd,
                               NULL
                              ))
      --End: RCD 06082012 Check accessible branch per user      
       GROUP BY pol.line_cd, DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) ) prev_pol
     ON (gpb.iss_cd = prev_pol.iss_cd AND gpb.line_cd = prev_pol.line_cd AND gpb.user_id = USER)
     WHEN MATCHED THEN UPDATE
       SET gpb.prev_prem = NVL(prev_pol.prev_prem,0)
     WHEN NOT MATCHED THEN
       INSERT (iss_cd,line_cd,curr_year,prev_year,from_date,TO_DATE,prev_prem,user_id,last_update,iss_param,curr_prem)
       VALUES (prev_pol.iss_cd,prev_pol.line_cd,TO_CHAR(p_to_date,'YYYY'),
                      TO_CHAR(ADD_MONTHS(p_to_date,-12),'YYYY'),p_from_date,
                             p_to_date,prev_pol.prev_prem,USER,SYSDATE,p_iss_param,0);

    /* merging giac_prod_budget with gixx_prod_budget */

    MERGE INTO GIXX_PROD_BUDGET gpb USING (
      SELECT YEAR,line_cd,iss_cd,SUM(budget) budget
        FROM GIAC_PROD_BUDGET
       WHERE LAST_DAY(TO_DATE(MONTH|| ',' ||TO_CHAR(YEAR),'FMMONTH,YYYY')) BETWEEN p_from_date AND p_to_date
       --Begin: RCD 06082012 Check accessible branch per user           
         AND iss_cd IN (
             SELECT iss_cd
               FROM giis_issource
              WHERE iss_cd =
                       DECODE (check_user_per_iss_cd_acctg (NULL,
                                                            iss_cd,
                                                            p_module_id
                                                           ),
                               1, iss_cd,
                               NULL
                              ))
      --End: RCD 06082012 Check accessible branch per user
       GROUP BY YEAR,line_cd,iss_cd) budget
     ON (gpb.iss_cd = budget.iss_cd AND gpb.line_cd = budget.line_cd AND budget.YEAR = gpb.curr_year AND gpb.user_id = USER)
     WHEN MATCHED THEN UPDATE
       SET gpb.budget = NVL(budget.budget,0)
     WHEN NOT MATCHED THEN
       INSERT (iss_cd,line_cd,prev_year,curr_year,budget,user_id,last_update,from_date,TO_DATE,
                    iss_param,curr_prem,prev_prem)
       VALUES (budget.iss_cd,budget.line_cd,TO_CHAR(ADD_MONTHS(p_to_date,-12),'YYYY'),
                     TO_CHAR(p_to_date,'YYYY'),budget.budget,USER,SYSDATE,p_from_date,p_to_date,
                     p_iss_param,0,0);

    COMMIT;
  END;

  FUNCTION Check_Date_Policy
   /* rollie 31jan2005 @ CPI QUAD
   ** validates if policy's date is within the given date parameter
   */
   (p_param_date  	 NUMBER,
    p_from_date		 DATE,
	p_to_date		 DATE,
 	p_issue_date  	 DATE,
  	p_eff_date   	 DATE,
  	p_acct_ent_date  DATE,
  	p_spld_acct  	 DATE,
  	p_booking_year   GIPI_POLBASIC.booking_year%TYPE,
	p_booking_mth    GIPI_POLBASIC.booking_mth%TYPE)
   RETURN NUMBER IS
   	 v_check_date NUMBER(1) := 0;
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
        IF LAST_DAY ( TO_DATE ( p_booking_mth || ',' || TO_CHAR(p_booking_year),'FMMONTH,YYYY'))
           BETWEEN LAST_DAY (p_from_date) AND LAST_DAY (p_to_date) THEN
           v_check_date := 1;
        END IF;
     ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL THEN --based on acct_ent_date
        IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date THEN
           IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date
		      AND p_spld_acct IS NOT NULL  THEN
		      v_check_date := 0;
		   ELSE
              v_check_date := 1;
		   END IF;
        END IF;
     END IF;
     RETURN (v_check_date);
   END;
END P_Prod_Budget;
/


