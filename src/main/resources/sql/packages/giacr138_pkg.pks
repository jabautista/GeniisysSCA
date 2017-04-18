CREATE OR REPLACE PACKAGE CPI.giacr138_pkg
AS
   TYPE main_type IS RECORD (
      gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      branch_name      giac_branches.branch_name%TYPE,
      tran_date        giac_acctrans.tran_date%TYPE,
      posting_date     giac_acctrans.posting_date%TYPE,
      tran_id          VARCHAR2 (15),
      ref_no           VARCHAR2 (100),
      jv_tran_type     giac_acctrans.jv_tran_type%TYPE,
      particulars      giac_acctrans.particulars%TYPE,
      db_amt           NUMBER (16, 2),
      cd_amt           NUMBER (16, 2),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      company_tin       giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      gen_version			giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      from_date         VARCHAR2 (100),
      to_date           VARCHAR2 (100),
      jv_ref_no         VARCHAR2(100) -- added by gab 09.14.2015
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main_rep (
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_tran_class   VARCHAR2,
      p_jv_tran_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_tran_post    VARCHAR2,
      p_coldv        VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE acct_type IS RECORD (
      gl_acct_no   VARCHAR2 (500),
      acct_name    VARCHAR2 (500),
      db_amt       NUMBER (16, 2),
      cd_amt       NUMBER (16, 2)
   );

   TYPE acct_tab IS TABLE OF acct_type;

   FUNCTION get_accts (p_tran_id VARCHAR2)
      RETURN acct_tab PIPELINED;

   TYPE summ_type IS RECORD (
      gfun_fund_cd     giac_acctrans.gfun_fund_cd%TYPE,
      gibr_branch_cd   giac_acctrans.gibr_branch_cd%TYPE,
      branch_name      giac_branches.branch_name%TYPE,
      gl_acct_no       VARCHAR2 (500),
      acct_name        VARCHAR2 (500),
      db_amt           NUMBER (16, 2),
      cd_amt           NUMBER (16, 2),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      company_tin       giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      gen_version			giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      from_date         VARCHAR2 (100),
      to_date           VARCHAR2 (100)
   );

   TYPE summ_tab IS TABLE OF summ_type;

   FUNCTION get_summ (
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_tran_class   VARCHAR2,
      p_jv_tran_cd   VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_tran_post    VARCHAR2,
      p_coldv        VARCHAR2
   )
      RETURN summ_tab PIPELINED;
END;
/
