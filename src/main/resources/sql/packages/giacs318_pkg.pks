CREATE OR REPLACE PACKAGE CPI.giacs318_pkg
AS
   TYPE whtax_type IS RECORD (
      whtax_id               giac_wholding_taxes.whtax_id%TYPE,
      gibr_gfun_fund_cd      giac_wholding_taxes.gibr_gfun_fund_cd%TYPE,
      gibr_branch_cd         giac_wholding_taxes.gibr_branch_cd%TYPE,
      whtax_code             giac_wholding_taxes.whtax_code%TYPE,
      whtax_desc             giac_wholding_taxes.whtax_desc%TYPE,
      ind_corp_tag           giac_wholding_taxes.ind_corp_tag%TYPE,
      dsp_ind_corp_tag       cg_ref_codes.rv_meaning%TYPE,
      bir_tax_cd             giac_wholding_taxes.bir_tax_cd%TYPE,
      percent_rate           giac_wholding_taxes.percent_rate%TYPE,
      start_dt               VARCHAR2 (30),
      end_dt                 VARCHAR2 (30),
      gl_acct_id             giac_wholding_taxes.gl_acct_id%TYPE,
      dsp_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      dsp_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      dsp_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      dsp_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      dsp_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      dsp_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      dsp_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      dsp_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      dsp_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
      dsp_gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      sl_type_cd             giac_wholding_taxes.sl_type_cd%TYPE,
      dsp_sl_type_name       giac_sl_types.sl_type_name%TYPE,
      remarks                giac_wholding_taxes.remarks%TYPE,
      user_id                giac_wholding_taxes.user_id%TYPE,
      last_update            VARCHAR2 (30)
   );

   TYPE whtax_tab IS TABLE OF whtax_type;

   TYPE gl_acct_list_type IS RECORD (
      gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE,
      gl_acct_name       giac_chart_of_accts.gl_acct_name%TYPE,
      gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      gslt_sl_type_cd    giac_chart_of_accts.gslt_sl_type_cd%TYPE,
      sl_type_name       giac_sl_types.sl_type_name%TYPE
   );

   TYPE gl_acct_list_tab IS TABLE OF gl_acct_list_type;

   FUNCTION get_whtax_list (
      p_fund_cd        giac_wholding_taxes.gibr_gfun_fund_cd%TYPE,
      p_branch_cd      giac_wholding_taxes.gibr_branch_cd%TYPE,
      p_ind_corp_tag   giac_wholding_taxes.ind_corp_tag%TYPE,
      p_whtax_code     giac_wholding_taxes.whtax_code%TYPE,
      p_whtax_desc     giac_wholding_taxes.whtax_desc%TYPE,
      p_bir_tax_cd     giac_wholding_taxes.bir_tax_cd%TYPE,
      p_percent_rate   giac_wholding_taxes.percent_rate%TYPE
   )
      RETURN whtax_tab PIPELINED;

   PROCEDURE set_whtax (p_rec giac_wholding_taxes%ROWTYPE);

   PROCEDURE del_whtax (p_whtax_id giac_wholding_taxes.whtax_id%TYPE);

   PROCEDURE val_del_whtax (p_whtax_id giac_wholding_taxes.whtax_id%TYPE);

   FUNCTION validate_gl_account_code (
      p_gl_acct_category   giac_chart_of_accts.gl_acct_category%TYPE,
      p_gl_control_acct    giac_chart_of_accts.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_chart_of_accts.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_chart_of_accts.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_chart_of_accts.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_chart_of_accts.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_chart_of_accts.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_chart_of_accts.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_chart_of_accts.gl_sub_acct_7%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_gl_acct_lov (p_find VARCHAR2)
      RETURN gl_acct_list_tab PIPELINED;
END;
/


