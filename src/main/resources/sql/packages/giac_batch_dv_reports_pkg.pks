CREATE OR REPLACE PACKAGE CPI.giac_batch_dv_reports_pkg
AS
/******************************************************************************
   NAME:       GIAC_BATCH_DV_REPORTS_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        1/3/2012    Irwin Tabisora   Containts the GIACS086 REPORTS Procedures
******************************************************************************/
   TYPE main_query_type IS RECORD (
      cnt                  NUMBER(12),
      batch_no             VARCHAR (100),
      claim_no             VARCHAR (100),
      policy_no            VARCHAR (100),
      title                VARCHAR2 (100),
      csr_attn             VARCHAR2 (100),
      var_v_sp             VARCHAR2 (2000),
      sum_paid_amt         gicl_clm_loss_exp.paid_amt%TYPE,           -- cs_1
      sum_net_amt          NUMBER, -- added by: Nica 02.12.2013
      line_cd_1            gicl_claims.line_cd%TYPE,
      branch_cd               giac_batch_dv.branch_cd%TYPE, -- added by: Nica 12.04.2012
      --  in_acct_of1
       -- f_term1
      --  f_intm1
      deductible_cd        VARCHAR2 (2),--added 8-14-2013 by Nante
      f_assured_name       gicl_claims.assured_name%TYPE,
      f_assd_name2         gicl_claims.assd_name2%TYPE,
      final_assured_name   VARCHAR(4000),--gicl_claims.assured_name%TYPE, modified by Jerome Bautista 08.03.2015 SR 19902
      acct_of              giis_assured.assd_name%TYPE,
      term_date            VARCHAR2 (100),
      intm                 VARCHAR2 (250),
      dsp_loss_date        VARCHAR2 (30),
      loss_cat_des         VARCHAR2 (100),
      request_no           VARCHAR2 (50),
      currency             giis_currency.short_name%TYPE,
      remark               VARCHAR2 (200),
      show_csr_peril       VARCHAR2 (1),
      claim_id             gicl_claims.claim_id%TYPE,
      advice_id            gicl_advice.advice_id%TYPE,
      payee_class_cd       giac_batch_dv.payee_class_cd%TYPE,
      payee_cd             giac_batch_dv.payee_cd%TYPE,
      SWITCH               VARCHAR2 (1),
      label                giac_rep_signatory.label%TYPE,
      signatory            giis_signatory_names.signatory%TYPE,
      designation          giis_signatory_names.designation%TYPE,
      remarks              gicl_advice.remarks%TYPE
   );

   TYPE main_query_tab IS TABLE OF main_query_type;

   TYPE policy_list_type IS RECORD (
      claim_no        VARCHAR (100),
      policy_no       VARCHAR (100),
      assured_name    gicl_claims.assured_name%TYPE,
      dsp_loss_date   VARCHAR2 (30),
      loss_cat_des    VARCHAR2 (100),
      intm            VARCHAR2 (250),
      currency        giis_currency.short_name%TYPE,
      paid_amt        gicl_clm_loss_exp.paid_amt%TYPE,
      peril    varchar2(1000)
   );

   TYPE policy_list_tab IS TABLE OF policy_list_type;

   FUNCTION get_main_query_086c (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_report_id     VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN main_query_tab PIPELINED;

   FUNCTION get_main_query_086 (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_tran_id       giac_batch_dv.tran_id%TYPE,
      p_report_id     VARCHAR2,
      p_user_id       VARCHAR2,
      p_line_cd       gicl_claims.line_cd%TYPE,
      p_branch_cd     gicl_claims.line_cd%TYPE
   )
      RETURN main_query_tab PIPELINED;


   FUNCTION get_policies (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN policy_list_tab PIPELINED;

   TYPE loss_exp_type IS RECORD (
      loss_exp_desc   giis_loss_exp.loss_exp_desc%TYPE,
      dtl_amt         gicl_loss_exp_dtl.dtl_amt%TYPE
   );

   TYPE loss_exp_tab IS TABLE OF loss_exp_type;

   FUNCTION get_loss_exp (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN loss_exp_tab PIPELINED;

   FUNCTION get_loss_exp2 (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN loss_exp_tab PIPELINED;

   TYPE tax_amt_type IS RECORD (
      tax_amt     gicl_loss_exp_tax.tax_amt%TYPE,
      tax_input   gicl_loss_exp_tax.tax_amt%TYPE
   );

   TYPE tax_amt_tab IS TABLE OF tax_amt_type;

   FUNCTION get_tax_amt (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED;

   FUNCTION get_tax_amt2 (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED;

   FUNCTION get_tax_input (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED;

   FUNCTION get_tax_input2 (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN tax_amt_tab PIPELINED;

   FUNCTION get_total_dist_liab (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN gicl_loss_exp_dtl.dtl_amt%TYPE;

   TYPE distribution_type IS RECORD (
      net_ret   gicl_loss_exp_dtl.dtl_amt%TYPE,
      facul     gicl_loss_exp_dtl.dtl_amt%TYPE,
      treaty    gicl_loss_exp_dtl.dtl_amt%TYPE,
      total     gicl_loss_exp_dtl.dtl_amt%TYPE
   );

   TYPE distribution_tab IS TABLE OF distribution_type;

   FUNCTION get_distribution (p_batch_dv_id giac_batch_dv.batch_dv_id%TYPE)
      RETURN distribution_tab PIPELINED;

   TYPE payee_info_type IS RECORD (
      class_desc        giis_payee_class.class_desc%TYPE,
      payee_last_name   giis_payees.payee_last_name%TYPE,
      title             VARCHAR2 (50),
      doc_number        gicl_loss_exp_bill.doc_number%TYPE,
      bill_date         gicl_loss_exp_bill.bill_date%TYPE
   );

   TYPE payee_info_tab IS TABLE OF payee_info_type;

   FUNCTION get_payee_information (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE
   )
      RETURN payee_info_tab PIPELINED;

   TYPE perils_type IS RECORD (
      peril_name       giis_peril.peril_sname%TYPE,
      peril_paid_amt   gicl_clm_loss_exp.paid_amt%TYPE
   );

   TYPE perils_tab IS TABLE OF perils_type;

   FUNCTION get_perils (
      p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE,
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_advice_id     gicl_advice.advice_id%TYPE,
      p_line_cd       gicl_claims.line_cd%TYPE
   )
      RETURN perils_tab PIPELINED;
    
   FUNCTIOn get_policies_and_perils( p_batch_dv_id   giac_batch_dv.batch_dv_id%TYPE)
      RETURN policy_list_tab PIPELINED;
      

   FUNCTION get_request_no (p_tran_id giac_payt_requests_dtl.tran_id%TYPE)
      RETURN VARCHAR2;
      
    
   -- added by: Nica 12.04.2012 for report signatory
   
   TYPE signatory_type IS RECORD (
      label                giac_rep_signatory.label%TYPE,
      signatory            giis_signatory_names.signatory%TYPE,
      designation          giis_signatory_names.designation%TYPE
   );

   TYPE signatory_tab IS TABLE OF signatory_type;
   
   FUNCTION get_report_signatory (p_report_id     GIAC_DOCUMENTS.report_id%TYPE,
                                     p_line_cd      GIIS_LINE.line_cd%TYPE,
                                    p_branch_cd    GICL_CLAIMS.iss_cd%TYPE,
                                  p_user         GIIS_USERS.user_id%TYPE)
      RETURN signatory_tab PIPELINED;  
    
END giac_batch_dv_reports_pkg;
/


