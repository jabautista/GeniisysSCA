CREATE OR REPLACE PACKAGE CPI.giacr118b_pkg
AS
   TYPE get_details_type IS RECORD (
      cf_company       giis_parameters.param_value_v%TYPE,
      cf_com_address   giis_parameters.param_value_v%TYPE,
      cf_top_date      VARCHAR2 (70),
      company_tin		  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      gen_version		  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      post_tran        VARCHAR2 (200),
      top_date         VARCHAR2 (70)
   );

   TYPE get_details_tab IS TABLE OF get_details_type;

   TYPE get_all_branches_type IS RECORD (
      acct_gibr_gfun_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      bal_amt                  NUMBER (38, 2),
      gl_acct_no               VARCHAR2 (72),
      acct_name                VARCHAR2 (100),
      db_amt                   NUMBER (38, 2),
      cd_amt                   NUMBER (38, 2),
      branch                   giac_branches.branch_name%TYPE
   );

   TYPE get_all_branches_tab IS TABLE OF get_all_branches_type;

   TYPE get_by_branches_type IS RECORD (
      acct_gibr_gfun_fund_cd   giac_disb_vouchers.gibr_gfun_fund_cd%TYPE,
      acct_gibr_branch_cd      giac_disb_vouchers.gibr_branch_cd%TYPE,
      acct_branch_name         giac_branches.branch_name%TYPE,
      bal_amt                  NUMBER (38, 2),
      gl_acct_no               VARCHAR2 (72),
      acct_name                VARCHAR2 (100),
      db_amt                   NUMBER (38, 2),
      cd_amt                   NUMBER (38, 2),
      branch                   giac_branches.branch_name%TYPE
   );

   TYPE get_by_branches_tab IS TABLE OF get_by_branches_type;

   FUNCTION get_details (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2
   )
      RETURN get_details_tab PIPELINED;

   FUNCTION get_all_branches (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_all_branches_tab PIPELINED;

   FUNCTION get_by_branches (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_branch_check       VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_by_branches_tab PIPELINED;
END;
/


