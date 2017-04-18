CREATE OR REPLACE PACKAGE CPI.GIACS320_PKG
AS
   
   TYPE tax_type IS RECORD(
      fund_cd                 giac_taxes.fund_cd%TYPE,
      tax_cd                  giac_taxes.tax_cd%TYPE,
      tax_name                giac_taxes.tax_name%TYPE,
      tax_type                giac_taxes.tax_type%TYPE,
      priority_cd             giac_taxes.priority_cd%TYPE,
      gl_acct_id              giac_taxes.gl_acct_id%TYPE,
      gl_sub_acct_1           giac_taxes.gl_sub_acct_1%TYPE,
      gl_sub_acct_2           giac_taxes.gl_sub_acct_2%TYPE,
      gl_sub_acct_3           giac_taxes.gl_sub_acct_3%TYPE,
      gl_sub_acct_4           giac_taxes.gl_sub_acct_4%TYPE,
      gl_sub_acct_5           giac_taxes.gl_sub_acct_5%TYPE,
      gl_sub_acct_6           giac_taxes.gl_sub_acct_6%TYPE,
      gl_sub_acct_7           giac_taxes.gl_sub_acct_7%TYPE,
      gl_acct_category        giac_taxes.gl_acct_category%TYPE,
      gl_control_acct         giac_taxes.gl_control_acct%TYPE,
      remarks                 giac_taxes.remarks%TYPE,
      user_id                 giac_taxes.user_id%TYPE,
      last_update             giac_taxes.last_update%TYPE,
      dsp_last_update         VARCHAR2(50)
   );
   TYPE tax_tab IS TABLE OF tax_type;
   
   TYPE tax_type_lov_type IS RECORD(
      rv_low_value            cg_ref_codes.rv_low_value%TYPE,
      rv_meaning              cg_ref_codes.rv_meaning%TYPE
   );
   TYPE tax_type_lov_tab IS TABLE of tax_type_lov_type;
   
   TYPE gl_type IS RECORD(
      gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_id              giac_chart_of_accts.gl_acct_id%TYPE,
      gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE
   );
   TYPE gl_tab IS TABLE OF gl_type;
   
   TYPE fund_type IS RECORD(
      fund_cd                 giis_funds.fund_cd%TYPE,
      fund_desc               giis_funds.fund_desc%TYPE
   );
   TYPE fund_tab IS TABLE OF fund_type;
   
   FUNCTION get_tax_list(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE,
      p_tax_name              giac_taxes.tax_name%TYPE,
      p_tax_type              giac_taxes.tax_type%TYPE,
      p_priority_cd           giac_taxes.priority_cd%TYPE,
      p_gl_acct_category      giac_taxes.gl_acct_category%TYPE,
      p_gl_control_acct       giac_taxes.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_taxes.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_taxes.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_taxes.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_taxes.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_taxes.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_taxes.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_taxes.gl_sub_acct_7%TYPE
   )
     RETURN tax_tab PIPELINED;
     
   FUNCTION get_tax_type_lov(
      p_find_text             VARCHAR2
   )
     RETURN tax_type_lov_tab PIPELINED;
     
   FUNCTION get_gl_lov(
      p_find_text             VARCHAR2
   )
     RETURN gl_tab PIPELINED;
     
   PROCEDURE val_add_rec(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE
   );
     
   PROCEDURE set_tax(
      p_rec                   giac_taxes%ROWTYPE
   );
     
   PROCEDURE val_del_rec(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE
   );
   
   PROCEDURE del_tax(
      p_fund_cd               giac_taxes.fund_cd%TYPE,
      p_tax_cd                giac_taxes.tax_cd%TYPE
   );
   
   FUNCTION check_account_code(
      p_gl_acct_category      giac_taxes.gl_acct_category%TYPE,
      p_gl_control_acct       giac_taxes.gl_control_acct%TYPE,
      p_gl_sub_acct_1         giac_taxes.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2         giac_taxes.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3         giac_taxes.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4         giac_taxes.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5         giac_taxes.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6         giac_taxes.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7         giac_taxes.gl_sub_acct_7%TYPE
   )
     RETURN NUMBER;
     
   FUNCTION get_fund_lov(
      p_find_text             VARCHAR2
   )
     RETURN fund_tab PIPELINED;
   
END GIACS320_PKG;
/


