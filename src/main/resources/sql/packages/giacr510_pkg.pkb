CREATE OR REPLACE PACKAGE BODY CPI.giacr510_pkg
AS
   FUNCTION get_giacr510_dtls (
      p_year        VARCHAR2,
      p_dt_basis    VARCHAR2,
      p_tran_flag   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacr510_tab PIPELINED
   IS
      v_rec   giacr510_type;
   BEGIN
      FOR i IN (SELECT e.gl_acct_name gl_acct_name, c.gl_acct_id gl_acct_id,
                       c.budget
                  FROM giac_chart_of_accts e, giac_budget c
                 WHERE 1 = 1
                   AND e.gl_acct_id = c.gl_acct_id
                   --AND e.acct_type = 'E'
                   AND c.YEAR = p_year)
      LOOP
         v_rec.gl_acct_name := i.gl_acct_name;
         v_rec.gl_acct_id := i.gl_acct_id;
         v_rec.budget := i.budget;
         v_rec.cf_report_title :=
                             'COMPARATIVE GEN. ' || '&' || ' ADMIN. EXPENSES';
         v_rec.cf_report_date := 'For the Year ' || p_year;
         v_rec.budget_for_year := 'Budget for the year ' || p_year;

         IF p_dt_basis = 1
         THEN
            v_rec.cf_date_basis := 'Report Based on Transaction Year';
         ELSIF p_dt_basis = 2
         THEN
            v_rec.cf_date_basis := 'Report Based on Year Posted';
         END IF;

         BEGIN
            SELECT param_value_v
              INTO v_rec.cf_company_name
              FROM giis_parameters
             WHERE UPPER (param_name) = 'COMPANY_NAME';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.cf_company_name := '';
         END;

         FOR j IN (SELECT gl_acct_id, curr_exp, prev_exp
                     FROM giac_comp_expense_ext
                    WHERE user_id = p_user_id)
         LOOP
            v_rec.curr_exp := j.curr_exp;
            v_rec.prev_exp := j.prev_exp;
            v_rec.cf_ic_period :=
                                 cf_ic_periodformula (j.curr_exp, j.prev_exp);
            v_rec.cf_ic_budget := cf_ic_budgetformula (j.curr_exp, i.budget);
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   FUNCTION cf_ic_periodformula (
      p_curr_exp   giac_comp_expense_ext.curr_exp%TYPE,
      p_prev_exp   giac_comp_expense_ext.prev_exp%TYPE
   )
      RETURN NUMBER
   IS
      v_inc_dec   NUMBER (12, 2);
      v_temp      NUMBER;
      v_divisor   NUMBER;
   BEGIN
      v_temp := NVL (p_curr_exp, 0) - NVL (p_prev_exp, 0);

      IF p_prev_exp <= 0
      THEN
         v_divisor := 1;
      ELSE
         v_divisor := p_prev_exp;
      END IF;

      v_inc_dec := v_temp / v_divisor;
      RETURN (v_inc_dec);
   END cf_ic_periodformula;

   FUNCTION cf_ic_budgetformula (
      p_curr_exp   giac_comp_expense_ext.curr_exp%TYPE,
      p_budget     giac_budget.budget%TYPE
   )
      RETURN NUMBER
   IS
      v_inc_dec   NUMBER (12, 2);
      v_temp      NUMBER;
      v_divisor   NUMBER;
   BEGIN
      v_temp := NVL (p_curr_exp, 0) - NVL (p_budget, 0);

      IF p_budget <= 0
      THEN
         v_divisor := 1;
      ELSE
         v_divisor := p_budget;
      END IF;

      v_inc_dec := v_temp / v_divisor;
      RETURN (v_inc_dec);
   END cf_ic_budgetformula;
END;
/


