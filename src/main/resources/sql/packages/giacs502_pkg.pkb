CREATE OR REPLACE PACKAGE BODY CPI.GIACS502_PKG
AS
/*
    **  Created by   :  Kenneth Mark Labrador
    **  Date Created : 07.26.2013
    **  Reference By : GIACS502 - Trial Balance As Of
    */
   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_lov_tab PIPELINED
   IS
      v_branch   branch_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM (SELECT branch_cd, branch_name
                          FROM giac_branches)
                 WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                     branch_cd,
                                                     'GIACS502',
                                                     p_user_id
                                                    ) = 1
                /*UNION         -- commented out by shan 09.02.2014
                SELECT NULL branch_cd, 'ALL BRANCHES' branch_name
                  FROM DUAL*/)
      LOOP
         v_branch.branch_cd := i.branch_cd;
         v_branch.branch_name := i.branch_name;
         PIPE ROW (v_branch);
      END LOOP;

      RETURN;
   END get_branch_lov;

   PROCEDURE extract_mother_accounts (
      p_user_id   giis_users.user_id%TYPE,
      p_month     NUMBER,
      p_year      NUMBER
   )
   IS
      v_gl_acct_id   NUMBER (6);
   BEGIN
      DELETE FROM giac_trial_balance_summary;

      FOR c IN (SELECT c.gl_acct_category, c.gl_control_acct,
                       DECODE (c.gl_sub_acct_2,
                               0, 0,
                               c.gl_sub_acct_1
                              ) mother_sub_1,
                       DECODE (c.gl_sub_acct_3,
                               0, 0,
                               c.gl_sub_acct_2
                              ) mother_sub_2,
                       DECODE (c.gl_sub_acct_4,
                               0, 0,
                               c.gl_sub_acct_3
                              ) mother_sub_3,
                       DECODE (c.gl_sub_acct_5,
                               0, 0,
                               c.gl_sub_acct_4
                              ) mother_sub_4,
                       DECODE (c.gl_sub_acct_6,
                               0, 0,
                               c.gl_sub_acct_5
                              ) mother_sub_5,
                       DECODE (c.gl_sub_acct_7,
                               0, 0,
                               c.gl_sub_acct_6
                              ) mother_sub_6,
                       gl_sub_acct_1 sub_1, gl_sub_acct_2 sub_2,
                       gl_sub_acct_3 sub_3, gl_sub_acct_4 sub_4,
                       gl_sub_acct_5 sub_5, gl_sub_acct_6 sub_6,
                       gl_sub_acct_7 sub_7, trans_balance, branch_cd,
                       fund_cd
                  FROM giac_chart_of_accts c, giac_finance_yr b -- dren 06.22.2015 : SR 0019456 - Removed comment out To fix GIACR502D Report
                  --FROM giac_chart_of_accts c, giac_monthly_totals b -- dren 06.22.2015 : SR 0019456 - Comment out To fix GIACR502D Report
                 WHERE c.gl_acct_id = b.gl_acct_id
                   AND tran_mm = p_month
                   AND tran_year = p_year)
      LOOP
         BEGIN
            SELECT gl_acct_id
              INTO v_gl_acct_id
              FROM giac_chart_of_accts
             WHERE gl_acct_category = c.gl_acct_category
               AND gl_control_acct = c.gl_control_acct
               AND gl_sub_acct_1 = c.mother_sub_1
               AND gl_sub_acct_2 = c.mother_sub_2
               AND gl_sub_acct_3 = c.mother_sub_3
               AND gl_sub_acct_4 = c.mother_sub_4
               AND gl_sub_acct_5 = c.mother_sub_5
               AND gl_sub_acct_6 = c.mother_sub_6
               AND gl_sub_acct_7 = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               SELECT gl_acct_id
                 INTO v_gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = c.gl_acct_category
                  AND gl_control_acct = c.gl_control_acct
                  AND gl_sub_acct_1 = c.sub_1
                  AND gl_sub_acct_2 = c.sub_2
                  AND gl_sub_acct_3 = c.sub_3
                  AND gl_sub_acct_4 = c.sub_4
                  AND gl_sub_acct_5 = c.sub_5
                  AND gl_sub_acct_6 = c.sub_6
                  AND gl_sub_acct_7 = c.sub_7;
         END;

         INSERT INTO giac_trial_balance_summary
                     (gl_acct_id, debit, credit, user_id, branch_cd,
                      fund_cd, trans_balance
                     )
              VALUES (v_gl_acct_id, NULL, NULL, p_user_id, c.branch_cd,
                      c.fund_cd, c.trans_balance
                     );
      END LOOP;
   END;

   PROCEDURE extract_mother_accounts_detail (
      p_user_id   giis_users.user_id%TYPE,
      p_month     NUMBER,
      p_year      NUMBER
   )
   IS
      v_gl_acct_id   NUMBER (6);
   BEGIN
      DELETE FROM giac_trial_balance_summary;
            --WHERE user_id = p_user_id;

      FOR c IN (SELECT c.gl_acct_category, c.gl_control_acct,
                       DECODE (c.gl_sub_acct_2,
                               0, 0,
                               c.gl_sub_acct_1
                              ) mother_sub_1,
                       DECODE (c.gl_sub_acct_3,
                               0, 0,
                               c.gl_sub_acct_2
                              ) mother_sub_2,
                       DECODE (c.gl_sub_acct_4,
                               0, 0,
                               c.gl_sub_acct_3
                              ) mother_sub_3,
                       DECODE (c.gl_sub_acct_5,
                               0, 0,
                               c.gl_sub_acct_4
                              ) mother_sub_4,
                       DECODE (c.gl_sub_acct_6,
                               0, 0,
                               c.gl_sub_acct_5
                              ) mother_sub_5,
                       DECODE (c.gl_sub_acct_7,
                               0, 0,
                               c.gl_sub_acct_6
                              ) mother_sub_6,
                       gl_sub_acct_1 sub_1, gl_sub_acct_2 sub_2,
                       gl_sub_acct_3 sub_3, gl_sub_acct_4 sub_4,
                       gl_sub_acct_5 sub_5, gl_sub_acct_6 sub_6,
                       gl_sub_acct_7 sub_7, beg_debit_amt, beg_credit_amt,
                       trans_debit_bal debit, trans_credit_bal credit,
                       trans_balance, branch_cd, fund_cd
                  FROM giac_chart_of_accts c, giac_finance_yr b -- dren 06.22.2015 : SR 0019456 - Removed omment out To fix GIACR502D Report
                  --FROM giac_chart_of_accts c, giac_monthly_totals b -- dren 06.22.2015 : SR 0019456 - Comment out To fix GIACR502D Report
                 WHERE c.gl_acct_id = b.gl_acct_id
                   AND tran_mm = p_month
                   AND tran_year = p_year)
      LOOP
         BEGIN
            SELECT gl_acct_id
              INTO v_gl_acct_id
              FROM giac_chart_of_accts
             WHERE gl_acct_category = c.gl_acct_category
               AND gl_control_acct = c.gl_control_acct
               AND gl_sub_acct_1 = c.mother_sub_1
               AND gl_sub_acct_2 = c.mother_sub_2
               AND gl_sub_acct_3 = c.mother_sub_3
               AND gl_sub_acct_4 = c.mother_sub_4
               AND gl_sub_acct_5 = c.mother_sub_5
               AND gl_sub_acct_6 = c.mother_sub_6
               AND gl_sub_acct_7 = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               SELECT gl_acct_id
                 INTO v_gl_acct_id
                 FROM giac_chart_of_accts
                WHERE gl_acct_category = c.gl_acct_category
                  AND gl_control_acct = c.gl_control_acct
                  AND gl_sub_acct_1 = c.sub_1
                  AND gl_sub_acct_2 = c.sub_2
                  AND gl_sub_acct_3 = c.sub_3
                  AND gl_sub_acct_4 = c.sub_4
                  AND gl_sub_acct_5 = c.sub_5
                  AND gl_sub_acct_6 = c.sub_6
                  AND gl_sub_acct_7 = c.sub_7;
         END;

         INSERT INTO giac_trial_balance_summary
                     (gl_acct_id, debit, credit, user_id,
                      branch_cd, fund_cd, trans_balance,
                      beg_debit_bal, beg_credit_bal
                     )
              VALUES (v_gl_acct_id, c.debit, c.credit, p_user_id,
                      c.branch_cd, c.fund_cd, c.trans_balance,
                      c.beg_debit_amt, c.beg_credit_amt
                     );
      END LOOP;
   END;
END GIACS502_PKG;
/


