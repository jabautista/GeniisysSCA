CREATE OR REPLACE PACKAGE CPI.GIACS240_PKG
AS
   TYPE giacs240_type IS RECORD(
      --added by MarkS SR-5862 12.12.2016 optimization
      count_            NUMBER,
      rownum_           NUMBER,
      --SR-5862
      check_no          giac_pd_checks_v.check_no%TYPE,
      check_date        giac_pd_checks_v.check_date%TYPE,
      department        VARCHAR2(110),
      bank_name         giac_pd_checks_v.bank_name%TYPE,
      bank_acct_no      giac_pd_checks_v.bank_acct_no%TYPE,
      dv_amt            giac_pd_checks_v.dv_amt%TYPE,
      particulars       giac_pd_checks_v.particulars%TYPE,
      user_id           giac_pd_checks_v.user_id%TYPE,
      last_update       giac_pd_checks_v.last_update%TYPE
   );
   
   TYPE giacs240_tab IS TABLE OF giacs240_type;
   
   FUNCTION get_giacs240_list(
      p_from_date       giac_pd_checks_v.check_date%TYPE,
      p_to_date         giac_pd_checks_v.check_date%TYPE,
      p_fund_cd         giac_pd_checks_v.fund_cd%TYPE,
      p_branch_cd       giac_pd_checks_v.branch_cd%TYPE,
      p_payee_class_cd  giac_pd_checks_v.payee_class_cd%TYPE,
      p_payee_no        giac_pd_checks_v.payee_no%TYPE,
      --added by MarkS SR-5862 12.12.2016 optimization
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER,
      p_check_no        VARCHAR2,
      p_dept            VARCHAR2,
      p_bank_name       VARCHAR2,
      p_bank_acct_no    VARCHAR2
      --SR-5862
   ) RETURN giacs240_tab PIPELINED;  
   
   TYPE payee_type IS RECORD(
      --added by MarkS SR-5862 12.12.2016 optimization
      count_            NUMBER,
      rownum_           NUMBER,
      --SR-5862
      payee_no          giis_payees.payee_no%TYPE,
      payee_class_cd    giis_payees.payee_class_cd%TYPE,
      class_desc        giis_payee_class.class_desc%TYPE,
      payee_name        VARCHAR2(560)
   );
   
   TYPE payee_tab IS TABLE OF payee_type;
   
   FUNCTION get_payee_lov(
      p_payee_class_cd  giis_payees.payee_class_cd%TYPE,
      --added by MarkS SR-5862 12.12.2016 optimization
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER,
      p_search_string   VARCHAR2
   ) RETURN payee_tab PIPELINED;
   
   FUNCTION validate_fund_cd(
      p_fund_cd         giis_funds.fund_cd%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION validate_branch_cd(
      p_branch_cd       giac_branches.branch_cd%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE
   ) RETURN VARCHAR2;
   
   PROCEDURE validate_payee_no(
      p_payee_class_cd  IN OUT giis_payees.payee_class_cd%TYPE,
      p_payee_no        IN giis_payees.payee_no%TYPE,
      p_class_desc      OUT giis_payee_class.class_desc%TYPE,
      p_payee_name      OUT VARCHAR2
   );
END GIACS240_PKG;
/


