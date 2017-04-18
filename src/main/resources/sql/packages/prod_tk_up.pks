CREATE OR REPLACE PACKAGE CPI.PROD_TK_UP
AS
    /* mofified by judyann 07142008
   ** added iss_cd and prem_seq_no as parameters in getting the amounts for take-up;
   ** due to the long-term policy enhancement, amounts should be per invoice
   */
   FUNCTION get_inv_amount (
      p_policy_id     NUMBER,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER;

   FUNCTION get_inv_amount_f (
      p_policy_id     NUMBER,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER;                                      -- judyann 01062006

   FUNCTION get_intm_ri_amount (
      p_policy_id     NUMBER,
      --p_line_cd varchar2)
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER;

   FUNCTION get_comm_input_vat (
      p_policy_id     NUMBER,
      p_iss_cd        VARCHAR2,
      p_prem_seq_no   NUMBER
   )
      RETURN NUMBER;                                      -- judyann 01042006

   FUNCTION check_if_exist (
      p_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
      p_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
      p_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_cd              giac_acct_entries.sl_cd%TYPE,
      p_v_branch_cd          GIAC_ACCTRANS.gibr_branch_cd%type,
      p_v_fund_cd            GIAC_ACCTRANS.gfun_fund_cd%type,
      p_v_tran_id            GIAC_ACCTRANS.tran_id%type
   )
      RETURN BOOLEAN;
END;
/


