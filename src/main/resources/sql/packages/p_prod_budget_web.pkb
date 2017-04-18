CREATE OR REPLACE PACKAGE BODY CPI.P_PROD_BUDGET_WEB
AS

   PROCEDURE extract_prod_budget(
      p_iss_cd                IN VARCHAR2,
      p_line_cd               IN VARCHAR2,
      p_from_date             IN DATE,
      p_to_date               IN DATE,
      p_date_param            IN NUMBER,
      p_iss_param             IN NUMBER,
      p_special_pol           IN VARCHAR2,
      p_module_id             IN VARCHAR2,
      p_user_id               IN GIIS_USERS.user_id%TYPE,
      p_count                OUT NUMBER
   )
   IS
      TYPE v_iss_cd_tab        IS TABLE OF GIPI_POLBASIC.iss_cd%TYPE;
      TYPE v_line_cd_tab       IS TABLE OF GIPI_POLBASIC.line_cd%TYPE;
      TYPE v_prem_tab          IS TABLE OF GIXX_PROD_BUDGET.curr_prem%TYPE;
      TYPE v_year_tab          IS TABLE OF GIPI_POLBASIC.booking_year%TYPE;
      TYPE v_pct_tab           IS TABLE OF GIPI_INVOICE.currency_rt%TYPE;
      TYPE v_pol_tab           IS TABLE OF GIPI_polbasic.policy_id%TYPE;
      v_pol                    v_pol_tab;
      v_line_cd                v_line_cd_tab;
      v_iss_cd                 v_iss_cd_tab;
      v_curr_year              v_year_tab;
      v_prev_year              v_year_tab;
      v_curr_prem              v_prem_tab;
      v_prev_prem              v_prem_tab;
      v_prem_diff              v_prem_tab;
      v_prem_pct               v_pct_tab;
      v_budget                 v_prem_tab;
      v_budget_diff            v_prem_tab;
      v_budget_pct             v_pct_tab;
      v_year                   NUMBER(4);
   BEGIN
      DELETE FROM GIXX_PROD_BUDGET
       WHERE user_id = p_user_id;
       
      SELECT pol.line_cd,
             DECODE(p_iss_param,2,pol.iss_cd,NVL(pol.cred_branch,pol.iss_cd)) iss_cd,
             SUM(pol.prem_amt)
        BULK COLLECT INTO
             v_line_cd,
             v_iss_cd,
             v_curr_prem
        FROM GIPI_POLBASIC pol
       WHERE pol_flag<>'5'
         AND P_PROD_BUDGET_WEB.check_prod_budget_date_policy(p_date_param,
                                                             p_from_date,
                                                             p_to_date,
                                                             pol.issue_date,
                                                             pol.eff_date,
                                                             pol.acct_ent_date,
                                                             pol.spld_acct_ent_date,
                                                             pol.booking_year,
                                                             pol.booking_mth) = 1
         AND pol.line_cd = NVL(p_line_cd, pol.line_cd)
         AND pol.reg_policy_sw = DECODE(p_special_pol, 'Y', pol.reg_policy_sw, 'Y')
         AND DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)) =
             NVL(p_iss_cd, DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)))           
         AND DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd))
          IN (SELECT iss_cd
                FROM GIIS_ISSOURCE
               WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL, iss_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
       GROUP BY pol.line_cd, DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd));
      
      IF SQL%FOUND THEN
         FORALL cnt IN v_line_cd.FIRST..v_line_cd.LAST
            INSERT INTO GIXX_PROD_BUDGET(
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
                   p_user_id,
                   SYSDATE,
                   p_iss_param);
      END IF;
      
      MERGE INTO GIXX_PROD_BUDGET gpb USING (
            SELECT pol.line_cd line_cd,
                   DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)) iss_cd,
                   SUM(pol.prem_amt) prev_prem
              FROM GIPI_POLBASIC pol
             WHERE pol_flag<>'5'
               AND P_PROD_BUDGET_WEB.check_prod_budget_date_policy(p_date_param,
                                                                   ADD_MONTHS(p_from_date,-12),
                                                                   ADD_MONTHS(p_to_date,-12),
                                                                   pol.issue_date,
                                                                   pol.eff_date,
                                                                   pol.acct_ent_date,
                                                                   pol.spld_acct_ent_date,
                                                                   pol.booking_year,
                                                                   pol.booking_mth) = 1
               AND pol.line_cd = NVL(p_line_cd, pol.line_cd)
               AND pol.reg_policy_sw = DECODE(p_special_pol, 'Y', pol.reg_policy_sw, 'Y')
               AND DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)) =
                   NVL(p_iss_cd, DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)))           
               AND DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)) IN (
                   SELECT iss_cd
                     FROM GIIS_ISSOURCE
                    WHERE iss_cd = DECODE(check_user_per_iss_cd_acctg2(NULL,
                                                                       iss_cd,
                                                                       p_module_id,
                                                                       p_user_id), 1, iss_cd, NULL))
                    GROUP BY pol.line_cd, DECODE(p_iss_param, 2, pol.iss_cd, NVL(pol.cred_branch, pol.iss_cd)) ) prev_pol
         ON (gpb.iss_cd = prev_pol.iss_cd AND gpb.line_cd = prev_pol.line_cd AND gpb.user_id = p_user_id)
       WHEN MATCHED THEN UPDATE
            SET gpb.prev_prem = NVL(prev_pol.prev_prem, 0)
       WHEN NOT MATCHED THEN
            INSERT (iss_cd, line_cd, curr_year, prev_year, from_date, TO_DATE, prev_prem, user_id, last_update, iss_param, curr_prem)
            VALUES (prev_pol.iss_cd, prev_pol.line_cd, TO_CHAR(p_to_date,'YYYY'), TO_CHAR(ADD_MONTHS(p_to_date,-12),'YYYY'), p_from_date,
                   p_to_date, prev_pol.prev_prem, p_user_id, SYSDATE, p_iss_param, 0);
                   
      MERGE INTO GIXX_PROD_BUDGET gpb USING (
            SELECT YEAR,line_cd, iss_cd, SUM(budget) budget
              FROM GIAC_PROD_BUDGET
             WHERE LAST_DAY(TO_DATE(MONTH|| ',' ||TO_CHAR(YEAR),'FMMONTH,YYYY')) BETWEEN p_from_date AND p_to_date
               AND iss_cd IN (SELECT iss_cd
                                FROM GIIS_ISSOURCE
                               WHERE iss_cd = DECODE (check_user_per_iss_cd_acctg2(NULL, iss_cd, p_module_id, p_user_id), 1, iss_cd, NULL))
             GROUP BY YEAR, line_cd, iss_cd) budget
         ON (gpb.iss_cd = budget.iss_cd AND gpb.line_cd = budget.line_cd AND budget.YEAR = gpb.curr_year AND gpb.user_id = p_user_id)
       WHEN MATCHED THEN UPDATE
            SET gpb.budget = NVL(budget.budget, 0)
       WHEN NOT MATCHED THEN
            INSERT (iss_cd, line_cd, prev_year, curr_year, budget, user_id, last_update, from_date, TO_DATE, iss_param, curr_prem, prev_prem)
            VALUES (budget.iss_cd, budget.line_cd, TO_CHAR(ADD_MONTHS(p_to_date,-12), 'YYYY'),
                    TO_CHAR(p_to_date,'YYYY'), budget.budget, p_user_id, SYSDATE, p_from_date, p_to_date,
                    p_iss_param, 0, 0);
                    
      BEGIN
         SELECT COUNT(*)
           INTO p_count
           FROM GIXX_PROD_BUDGET
          WHERE user_id = p_user_id;
      EXCEPTION
         WHEN OTHERS THEN
            p_count := 0;
      END;
  END;

   FUNCTION check_prod_budget_date_policy(
      p_param_date               NUMBER,
      p_from_date                DATE,
      p_to_date                  DATE,
      p_issue_date               DATE,
      p_eff_date                 DATE,
      p_acct_ent_date            DATE,
      p_spld_acct                DATE,
      p_booking_year             GIPI_POLBASIC.booking_year%TYPE,
      p_booking_mth              GIPI_POLBASIC.booking_mth%TYPE
   )
     RETURN NUMBER
   IS
      v_check_date               NUMBER(1) := 0;
   BEGIN
      IF p_param_date = 1 THEN
         IF TRUNC(p_issue_date) BETWEEN p_from_date AND p_to_date THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 2 THEN
         IF TRUNC(p_eff_date) BETWEEN p_from_date AND p_to_date THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 3 THEN
         IF LAST_DAY(TO_DATE(p_booking_mth || ',' || TO_CHAR(p_booking_year),'FMMONTH,YYYY')) BETWEEN LAST_DAY(p_from_date) AND LAST_DAY(p_to_date) THEN
            v_check_date := 1;
         END IF;
      ELSIF p_param_date = 4 AND p_acct_ent_date IS NOT NULL THEN
         IF TRUNC (p_acct_ent_date) BETWEEN p_from_date AND p_to_date THEN
            IF TRUNC (p_spld_acct) BETWEEN p_from_date AND p_to_date AND p_spld_acct IS NOT NULL  THEN
               v_check_date := 0;
            ELSE
               v_check_date := 1;
            END IF;
         END IF;
      END IF;
      
      RETURN (v_check_date);
   END;
   
END P_PROD_BUDGET_WEB;
/


