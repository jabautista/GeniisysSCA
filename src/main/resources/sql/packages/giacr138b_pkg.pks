CREATE OR REPLACE PACKAGE CPI.giacr138b_pkg
AS
   TYPE main_type IS RECORD (
      gfun_fund_cd      VARCHAR2 (100),
      gl_acct_no        VARCHAR2 (500),
      gl_acct_name      VARCHAR2 (500),
      db_amt            NUMBER (16, 2),
      cd_amt            NUMBER (16, 2),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      company_tin       giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      gen_version			giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      from_date         VARCHAR2 (100),
      TO_DATE           VARCHAR2 (100)
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
END;
/


