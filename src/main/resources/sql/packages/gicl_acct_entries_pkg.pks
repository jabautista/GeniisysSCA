CREATE OR REPLACE PACKAGE CPI.gicl_acct_entries_pkg
AS
   TYPE gicl_acct_entries_type IS RECORD (
      claim_id           gicl_acct_entries.claim_id%TYPE,
      advice_id          gicl_acct_entries.advice_id%TYPE,
      acct_entry_id      gicl_acct_entries.acct_entry_id%TYPE,
      clm_loss_id        gicl_acct_entries.clm_loss_id%TYPE,
      gl_acct_id         gicl_acct_entries.gl_acct_id%TYPE,
      gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      sl_cd              gicl_acct_entries.sl_cd%TYPE,
      debit_amt          gicl_acct_entries.debit_amt%TYPE,
      credit_amt         gicl_acct_entries.credit_amt%TYPE,
      generation_type    gicl_acct_entries.generation_type%TYPE,
      sl_type_cd         gicl_acct_entries.sl_type_cd%TYPE,
      sl_source_cd       gicl_acct_entries.sl_source_cd%TYPE,
      batch_csr_id       gicl_acct_entries.batch_csr_id%TYPE,
      remarks            gicl_acct_entries.remarks%TYPE,
      user_id            gicl_acct_entries.user_id%TYPE,
      last_update        gicl_acct_entries.last_update%TYPE,
      payee_class_cd     gicl_acct_entries.payee_class_cd%TYPE,
      payee_cd           gicl_acct_entries.payee_cd%TYPE,
      batch_dv_id        gicl_acct_entries.batch_dv_id%TYPE,
      nbt_gl_acct_name   VARCHAR2 (500),
      nbt_gl_acct_code   VARCHAR2 (500)
   );

   TYPE gicl_acct_entries_tab IS TABLE OF gicl_acct_entries_type;

   FUNCTION get_gicl_acct_entries (
      p_advice_id          gicl_acct_entries.advice_id%TYPE,
      p_claim_id           gicl_acct_entries.claim_id%TYPE,
      p_gl_acct_category   gicl_acct_entries.gl_acct_category%TYPE,
      p_gl_control_acct    gicl_acct_entries.gl_control_acct%TYPE,
      p_gl_sub_acct_1      gicl_acct_entries.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      gicl_acct_entries.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      gicl_acct_entries.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      gicl_acct_entries.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      gicl_acct_entries.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      gicl_acct_entries.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      gicl_acct_entries.gl_sub_acct_7%TYPE,
      p_sl_code            gicl_acct_entries.sl_cd%TYPE,
      p_debit_amt          gicl_acct_entries.debit_amt%TYPE,
      p_credit_amt         gicl_acct_entries.credit_amt%TYPE
   )
      RETURN gicl_acct_entries_tab PIPELINED;

  FUNCTION get_gicl_acct_entries_list(
    p_claim_id gicl_acct_entries.claim_id%TYPE,
    p_advice_id gicl_acct_entries.advice_id%TYPE,    
    p_payee_cd gicl_acct_entries.payee_cd%TYPE,
    p_payee_class_cd gicl_acct_entries.payee_class_cd%TYPE
  ) RETURN gicl_acct_entries_tab PIPELINED;

  
END gicl_acct_entries_pkg;
/


