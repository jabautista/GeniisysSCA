CREATE OR REPLACE PACKAGE cpi.giacb007_pkg
AS
   PROCEDURE prod_take_up (
      p_prod_date   IN       DATE,
      p_user_id     IN       giis_users.user_id%TYPE,
      p_msg         OUT      VARCHAR2
   );

   PROCEDURE generate_acct_entries (p_prod_date IN DATE, p_msg IN OUT VARCHAR2);

   PROCEDURE insert_giac_acctrans (
      p_prod_date   IN       DATE,
      p_tran_id     OUT      giac_acctrans.tran_id%TYPE,
      p_msg         IN OUT   VARCHAR2
   );

   FUNCTION get_acct_line_cd (p_line_cd VARCHAR2)
      RETURN NUMBER;

   PROCEDURE check_level (
      p_line_dependency_level   IN       giac_module_entries.line_dependency_level%TYPE,
      p_acct_line_cd            IN       giis_line.acct_line_cd%TYPE,
      p_gl_sub_acct_1           IN OUT   giac_module_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2           IN OUT   giac_module_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3           IN OUT   giac_module_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4           IN OUT   giac_module_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5           IN OUT   giac_module_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6           IN OUT   giac_module_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7           IN OUT   giac_module_entries.gl_sub_acct_7%TYPE
   );

   PROCEDURE check_chart_of_accts (
      p_gl_acct_category   IN       giac_module_entries.gl_acct_category%TYPE,
      p_gl_control_acct    IN       giac_module_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      IN       giac_module_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      IN       giac_module_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      IN       giac_module_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      IN       giac_module_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      IN       giac_module_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      IN       giac_module_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      IN       giac_module_entries.gl_sub_acct_7%TYPE,
      p_gl_acct_id         IN OUT   giac_chart_of_accts.gl_acct_id%TYPE,
      p_dr_cr_tag          IN OUT   giac_chart_of_accts.dr_cr_tag%TYPE,
      p_msg                IN OUT   VARCHAR2
   );

   PROCEDURE insert_giac_acct_entries (
      p_gacc_tran_id          IN   giac_acct_entries.gacc_tran_id%TYPE,
      p_gacc_gfun_fund_cd     IN   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_gibr_branch_cd   IN   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gl_acct_id            IN   giac_acct_entries.gl_acct_id%TYPE,
      p_gl_acct_category      IN   giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct       IN   giac_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         IN   giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         IN   giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         IN   giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         IN   giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         IN   giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         IN   giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         IN   giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd                 IN   giac_acct_entries.sl_cd%TYPE,
      p_debit_amt             IN   giac_acct_entries.debit_amt%TYPE,
      p_credit_amt            IN   giac_acct_entries.credit_amt%TYPE,
      p_generation_type       IN   giac_acct_entries.generation_type%TYPE,
      p_sl_type_cd            IN   giac_acct_entries.sl_type_cd%TYPE
   );

   FUNCTION check_if_exist (
      p_gacc_tran_id          giac_acct_entries.gacc_tran_id%TYPE,
      p_gacc_gfun_fund_cd     giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_gacc_gibr_branch_cd   giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_gl_acct_id            giac_chart_of_accts.gl_acct_id%TYPE,
      p_gl_acct_category      giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct       giac_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd                 giac_acct_entries.sl_cd%TYPE
   )
      RETURN BOOLEAN;

   PROCEDURE check_debit_credit_amt (
      p_gacc_tran_id   IN       giac_acct_entries.gacc_tran_id%TYPE,
      p_msg            IN OUT   VARCHAR2
   );
END;
/