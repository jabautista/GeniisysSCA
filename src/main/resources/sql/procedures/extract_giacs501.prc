DROP PROCEDURE CPI.EXTRACT_GIACS501;

CREATE OR REPLACE PROCEDURE CPI.EXTRACT_GIACS501 (
   /*
    ** Created by   : Kenneth L.
    ** Date Created : 07.22.2013
    ** Description  : for monthly trial balance
   */
   p_user_id   giis_users.user_id%TYPE,
   p_month     NUMBER,
   p_year      NUMBER
)
IS
   v_gl_acct_id         NUMBER;
   v_gl_acct_category   NUMBER;
   v_gl_control_acct    NUMBER;
   v_gl_sub_acct_1      NUMBER;
   v_gl_sub_acct_2      NUMBER;
   v_gl_sub_acct_3      NUMBER;
   v_gl_sub_acct_4      NUMBER;
   v_gl_sub_acct_5      NUMBER;
   v_gl_sub_acct_6      NUMBER;
   v_gl_sub_acct_7      NUMBER;
BEGIN
   DELETE FROM giac_trial_balance_summary
         WHERE user_id = p_user_id;

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
                    gl_sub_acct_7 sub_7, trans_debit_bal debit,
                    trans_credit_bal credit, branch_cd, fund_cd
               FROM giac_chart_of_accts c, giac_monthly_totals b
              WHERE c.gl_acct_id = b.gl_acct_id
                AND tran_mm = p_month
                AND tran_year = p_year)
   LOOP
      v_gl_acct_category := c.gl_acct_category;
      v_gl_control_acct := c.gl_control_acct;
      v_gl_sub_acct_1 := c.sub_1;
      v_gl_sub_acct_2 := c.sub_2;
      v_gl_sub_acct_3 := c.sub_3;
      v_gl_sub_acct_4 := c.sub_4;
      v_gl_sub_acct_5 := c.sub_5;
      v_gl_sub_acct_6 := c.sub_6;
      v_gl_sub_acct_7 := c.sub_7;

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
                   fund_cd, gl_acct_category, gl_control_acct,
                   gl_sub_acct_1,
                   gl_sub_acct_2,
                   gl_sub_acct_3,
                   gl_sub_acct_4,
                   gl_sub_acct_5,
                   gl_sub_acct_6,
                   gl_sub_acct_7
                  )
           VALUES (v_gl_acct_id, c.debit, c.credit, p_user_id, c.branch_cd,
                   c.fund_cd, v_gl_acct_category, v_gl_control_acct,
                   DECODE (v_gl_sub_acct_1,
                           0, 0,
                           DECODE (v_gl_sub_acct_2,
                                   0, v_gl_control_acct,
                                   v_gl_sub_acct_1
                                  )
                          ),
                   DECODE (v_gl_sub_acct_2,
                           0, 0,
                           DECODE (v_gl_sub_acct_3,
                                   0, v_gl_sub_acct_1,
                                   v_gl_sub_acct_2
                                  )
                          ),
                   DECODE (v_gl_sub_acct_3,
                           0, 0,
                           DECODE (v_gl_sub_acct_4,
                                   0, v_gl_sub_acct_2,
                                   v_gl_sub_acct_3
                                  )
                          ),
                   DECODE (v_gl_sub_acct_4,
                           0, 0,
                           DECODE (v_gl_sub_acct_5,
                                   0, v_gl_sub_acct_3,
                                   v_gl_sub_acct_4
                                  )
                          ),
                   DECODE (v_gl_sub_acct_5,
                           0, 0,
                           DECODE (v_gl_sub_acct_6,
                                   0, v_gl_sub_acct_4,
                                   v_gl_sub_acct_5
                                  )
                          ),
                   DECODE (v_gl_sub_acct_6,
                           0, 0,
                           DECODE (v_gl_sub_acct_7,
                                   0, v_gl_sub_acct_5,
                                   v_gl_sub_acct_6
                                  )
                          )
                   ----------
                          ,
                   DECODE (v_gl_sub_acct_7,
                           0, 0,
                           DECODE (99,
                                   0, v_gl_sub_acct_6,
                                   v_gl_sub_acct_7
                                  )
                          )
                   --------
                   --99
                   
                  );
   END LOOP;
END EXTRACT_GIACS501;
/


