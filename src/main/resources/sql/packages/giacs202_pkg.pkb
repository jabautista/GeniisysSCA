CREATE OR REPLACE PACKAGE BODY CPI.giacs202_pkg
AS
   /* Create by : J. Diago
   ** Date Created : 07.31.2013
   ** Reference by : GIACS202 Bills by Assured and Age
   */
   FUNCTION get_giacs202_dtls (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_column_no   giac_aging_parameters.column_no%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN giacs202_dtls_tab PIPELINED
   IS
      v_list   giacs202_dtls_type;
   BEGIN
      FOR i IN (SELECT b.gagp_aging_id, b.a020_assd_no, b.balance_amt_due,
                       c.assd_name, a.column_heading
                  FROM giac_aging_parameters a,
                       giac_aging_summaries_v b,
                       giis_assured c
                 WHERE a.aging_id = b.gagp_aging_id
                   AND b.a020_assd_no = c.assd_no
                   AND a.gibr_gfun_fund_cd = p_fund_cd
                   AND a.gibr_branch_cd = p_branch_cd
                   AND a.column_no = NVL (p_column_no, a.column_no)
                   AND check_user_per_iss_cd_acctg2 (NULL,
                                                    a.gibr_branch_cd,
                                                    'GIACS202',
                                                    p_user_id
                                                   ) = 1)
      LOOP
         v_list.gagp_aging_id := i.gagp_aging_id;
         v_list.a020_assd_no := i.a020_assd_no;
         v_list.balance_amt_due := i.balance_amt_due;
         v_list.assd_name := i.assd_name;
         v_list.column_heading := i.column_heading;

         BEGIN
            SELECT SUM (balance_amt_due)
              INTO v_list.sum_balance_amt_due
              FROM giac_aging_summaries_v
             WHERE gagp_aging_id = i.gagp_aging_id;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_giacs202_dtls;

   FUNCTION get_aging_list_dtls (
      p_fund_cd     giac_aging_totals_v.gibr_gfun_fund_cd%TYPE,
      p_branch_cd   giac_aging_totals_v.gibr_branch_cd%TYPE
   )
      RETURN giacs202_aging_list_tab PIPELINED
   IS
      v_list   giacs202_aging_list_type;
   BEGIN
      FOR i IN (SELECT a.gibr_gfun_fund_cd, a.gibr_branch_cd,
                       b.column_heading, a.balance_amt_due
                  FROM giac_aging_totals_v a, giac_aging_parameters b
                 WHERE a.gagp_aging_id = b.aging_id
                   AND a.gibr_gfun_fund_cd =
                                          NVL (p_fund_cd, a.gibr_gfun_fund_cd)
                   AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd))
      LOOP
         v_list.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.column_heading := i.column_heading;
         v_list.balance_amt_due := i.balance_amt_due;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_aging_list_dtls;

   FUNCTION get_age_level_lov
      RETURN aging_level_lov_tab PIPELINED
   IS
      v_list   aging_level_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT column_no, column_heading
                           FROM giac_aging_parameters
                       ORDER BY 1 ASC)
      LOOP
         v_list.column_no := i.column_no;
         v_list.column_heading := i.column_heading;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_age_level_lov;

   FUNCTION get_branch_cd_lov (p_fund_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED
   IS
      v_list   branch_cd_lov_type;
   BEGIN
      FOR i IN (SELECT branch_cd, branch_name
                  FROM giac_branches
                 WHERE gfun_fund_cd = NVL (p_fund_cd, gfun_fund_cd)
                   AND check_user_per_iss_cd_acctg2 (NULL,
                                                     branch_cd,
                                                     'GIACS202',
                                                     p_user_id
                                                    ) = 1)
      LOOP
         v_list.branch_cd := i.branch_cd;
         v_list.branch_name := i.branch_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_branch_cd_lov;
END;
/


