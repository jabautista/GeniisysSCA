CREATE OR REPLACE PACKAGE CPI.GIACS031_PKG
AS  
   global_fund_cd       VARCHAR2(3);
   global_branch_cd     VARCHAR2(2);
   global_gacc_tran_id  NUMBER(12);
   global_user_id       VARCHAR2(8);
   
   TYPE giacs031_bill_lov_type IS RECORD (
      iss_cd            gipi_polbasic.iss_cd%TYPE,
      prem_seq_no       giac_aging_soa_details.prem_seq_no%TYPE,
      property          gipi_invoice.property%TYPE,
      ref_inv_no        gipi_invoice.ref_inv_no%TYPE,
      policy_id         gipi_polbasic.policy_id%TYPE,
      policy_number     VARCHAR2(50),
      ref_pol_no        gipi_polbasic.ref_pol_no%TYPE,
      assd_no           gipi_polbasic.assd_no%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE,   
      currency_cd       gipi_invoice.currency_cd%TYPE,
      currency_rt       gipi_invoice.currency_rt%TYPE,
      currency_desc     giis_currency.currency_desc%TYPE
   ); 

   TYPE giacs031_bill_lov_tab IS TABLE OF giacs031_bill_lov_type;

   FUNCTION get_giacs031_bill_tran1_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
   RETURN giacs031_bill_lov_tab PIPELINED;
   
   FUNCTION get_giacs031_bill_tran2_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
   RETURN giacs031_bill_lov_tab PIPELINED;
   
   FUNCTION get_giacs031_bill_tran3_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
   RETURN giacs031_bill_lov_tab PIPELINED;
   
   FUNCTION get_giacs031_bill_tran4_lov(
        p_iss_cd    VARCHAR2,
        p_search    VARCHAR2
   )
   RETURN giacs031_bill_lov_tab PIPELINED;
   
   TYPE giacs031_inst_lov_type IS RECORD (
      iss_cd            giac_aging_soa_details.iss_cd%TYPE,
      prem_seq_no       giac_aging_soa_details.prem_seq_no%TYPE,
      inst_no           giac_aging_soa_details.inst_no%TYPE,
      collection_amt    giac_aging_soa_details.balance_amt_due%TYPE,
      collection_amt1   giac_aging_soa_details.balance_amt_due%TYPE,
      total_balance     NUMBER(16,2)
   ); 
   
   TYPE giacs031_inst_lov_tab IS TABLE OF giacs031_inst_lov_type;
   
   FUNCTION get_giacs031_inst_tran1_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED;
   
   FUNCTION get_giacs031_inst_tran2_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED;
   
   FUNCTION get_giacs031_inst_tran3_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED;
   
   FUNCTION get_giacs031_inst_tran4_lov(
        p_iss_cd        VARCHAR2,
        p_prem_seq_no   NUMBER,
        p_gacc_tran_id  NUMBER
   )
   RETURN giacs031_inst_lov_tab PIPELINED;
   
   TYPE giacs031_list_type IS RECORD (
      gacc_tran_id      giac_pdc_payts.gacc_tran_id%TYPE,  
      iss_cd            giac_pdc_payts.iss_cd%TYPE,          
      prem_seq_no       giac_pdc_payts.prem_seq_no%TYPE,     
      inst_no           giac_pdc_payts.inst_no%TYPE,         
      collection_amt    giac_pdc_payts.collection_amt%TYPE,  
      currency_cd       giac_pdc_payts.currency_cd%TYPE,     
      currency_rt       giac_pdc_payts.currency_rt%TYPE,
      fcurrency_amt     giac_pdc_payts.fcurrency_amt%TYPE,
      particulars       giac_pdc_payts.particulars%TYPE,
      transaction_type  giac_pdc_payts.transaction_type%TYPE,
      user_id           giac_pdc_payts.user_id%TYPE,
      last_update       VARCHAR2(50),
      policy_no         VARCHAR2(50),
      assd_name         VARCHAR2(500),
      currency_desc     giis_currency.currency_desc%TYPE
   ); 
   
   TYPE giacs031_list_tab IS TABLE OF giacs031_list_type;
   
   FUNCTION get_giacs031_list(
        p_tran_id       VARCHAR2
   )
   RETURN giacs031_list_tab PIPELINED;
   
   PROCEDURE val_add_rec(
    p_gacc_tran_id  giac_pdc_payts.gacc_tran_id%TYPE,
    p_iss_cd        giac_pdc_payts.iss_cd%TYPE,      
    p_prem_seq_no   giac_pdc_payts.prem_seq_no%TYPE, 
    p_inst_no       giac_pdc_payts.inst_no%TYPE     
   );
   
   PROCEDURE set_rec (p_rec giac_pdc_payts%ROWTYPE);
   
   PROCEDURE del_rec (p_rec giac_pdc_payts%ROWTYPE);
   
   PROCEDURE check_op_text_insert (
    p_collection_amt  IN NUMBER, 
    p_iss_cd          IN giac_pdc_payts.iss_cd%TYPE,
    p_prem_seq_no     IN giac_pdc_payts.prem_seq_no%TYPE,
    p_seq_no          IN NUMBER,
    p_currency_cd     IN giac_pdc_payts.currency_cd%TYPE,
    p_gen_type           giac_modules.generation_type%TYPE,
    p_rec                giac_pdc_payts%ROWTYPE              
   );
   
   PROCEDURE post_commit (p_rec giac_pdc_payts%ROWTYPE);
   
   TYPE giacs031_policy_type IS RECORD (
      line_cd           gipi_polbasic.line_cd%TYPE,    
      subline_cd        gipi_polbasic.subline_cd%TYPE, 
      iss_cd            gipi_polbasic.iss_cd%TYPE,     
      issue_yy          gipi_polbasic.issue_yy%TYPE,   
      pol_seq_no        gipi_polbasic.pol_seq_no%TYPE, 
      renew_no          gipi_polbasic.renew_no%TYPE,   
      ref_pol_no        gipi_polbasic.ref_pol_no%TYPE
   ); 
   
   TYPE giacs031_policy_tab IS TABLE OF giacs031_policy_type;
   
   FUNCTION get_giacs031_policy_lov(
        p_line_cd       VARCHAR2,   
        p_subline_cd    VARCHAR2,
        p_iss_cd        VARCHAR2,
        p_issue_yy      VARCHAR2,
        p_pol_seq_no    VARCHAR2,
        p_renew_no      VARCHAR2,
        p_ref_pol_no    VARCHAR2,
        p_due_sw        VARCHAR2
   )
   RETURN giacs031_policy_tab PIPELINED;
   
   TYPE policy_dummy_type IS RECORD (
      iss_cd            giac_pdc_payts.iss_cd%TYPE,          
      prem_seq_no       giac_pdc_payts.prem_seq_no%TYPE,     
      inst_no           giac_pdc_payts.inst_no%TYPE,         
      collection_amt    giac_pdc_payts.collection_amt%TYPE,  
      currency_cd       giac_pdc_payts.currency_cd%TYPE,     
      currency_rt       giac_pdc_payts.currency_rt%TYPE,
      policy_no         VARCHAR2(50),
      assd_name         VARCHAR2(500),
      currency_desc     giis_currency.currency_desc%TYPE,
      pol_flag          gipi_polbasic.pol_flag%TYPE
   ); 
   
   TYPE policy_dummy_tab IS TABLE OF policy_dummy_type;
   
   FUNCTION query_policy_list(
       p_line_cd       gipi_polbasic.line_cd%TYPE,
       p_subline_cd    gipi_polbasic.subline_cd%TYPE,
       p_iss_cd        gipi_polbasic.iss_cd%TYPE,
       p_issue_yy      gipi_polbasic.issue_yy%TYPE,
       p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
       p_renew_no      gipi_polbasic.renew_no%TYPE,
       p_due_sw        VARCHAR2 
   )
   RETURN policy_dummy_tab PIPELINED;
   
   PROCEDURE post_forms_commit (
        p_gacc_tran_id giac_pdc_payts.gacc_tran_id%TYPE,
        p_fund_cd      VARCHAR2,
        p_branch_cd    VARCHAR2,
        p_user_id      VARCHAR2
   );
   
   PROCEDURE aeg_delete_acct_entries(
        p_gacc_tran_id      giac_pdc_payts.gacc_tran_id%TYPE,
        p_generation_type   giac_modules.generation_type%TYPE
   );
   
   PROCEDURE aeg_create_acct_entries(
        p_collection_amt    giac_bank_collns.collection_amt%TYPE,
        p_gen_type          giac_acct_entries.generation_type%TYPE,
        p_module_id         giac_modules.module_id%TYPE
   );
   
   PROCEDURE aeg_insert_update_acct_entries(
        p_gl_acct_category  giac_acct_entries.gl_acct_category%TYPE,
        p_gl_control_acct   giac_acct_entries.gl_control_acct%TYPE,
        p_gl_sub_acct_1     giac_acct_entries.gl_sub_acct_1%TYPE,
        p_gl_sub_acct_2     giac_acct_entries.gl_sub_acct_2%TYPE,
        p_gl_sub_acct_3     giac_acct_entries.gl_sub_acct_3%TYPE,
        p_gl_sub_acct_4     giac_acct_entries.gl_sub_acct_4%TYPE,
        p_gl_sub_acct_5     giac_acct_entries.gl_sub_acct_5%TYPE,
        p_gl_sub_acct_6     giac_acct_entries.gl_sub_acct_6%TYPE,
        p_gl_sub_acct_7     giac_acct_entries.gl_sub_acct_7%TYPE,
        p_generation_type   giac_acct_entries.generation_type%TYPE,
        p_gl_acct_id        giac_chart_of_accts.gl_acct_id%TYPE,
        p_debit_amt         giac_acct_entries.debit_amt%TYPE,
        p_credit_amt        giac_acct_entries.credit_amt%TYPE
   );
   
END;
/


