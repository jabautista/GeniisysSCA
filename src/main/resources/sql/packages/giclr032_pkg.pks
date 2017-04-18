CREATE OR REPLACE PACKAGE CPI.giclr032_pkg
IS
   TYPE giclr032_type IS RECORD (
      claim_id         gicl_claims.claim_id%TYPE,
      advice_id        gicl_advice.advice_id%TYPE,
      policy_no        VARCHAR2 (50),
      claim_no         VARCHAR2 (50),
      -- advice_no           VARCHAR2(50),
      assd_no          gicl_claims.assd_no%TYPE,
      assured_name     gicl_claims.assured_name%TYPE,
      assd_name2       gicl_claims.assd_name2%TYPE,
      NAME             VARCHAR2 (600),
      --changed by robert from varchar2(300) 10.04.2013
      payee_class_cd   giis_payees.payee_class_cd%TYPE,
      payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      acct_of_cd       gicl_claims.acct_of_cd%TYPE,
      line_cd          gicl_claims.line_cd%TYPE,
      dsp_loss_date    VARCHAR2 (50),
      currency_cd      gicl_advice.currency_cd%TYPE,
      convert_rate     gicl_advice.convert_rate%TYPE,
      final_tag        gicl_clm_loss_exp.final_tag%TYPE,
      ex_gratia_sw     gicl_clm_loss_exp.ex_gratia_sw%TYPE,
      loss_amt         gicl_clm_loss_exp.net_amt%TYPE,
      exp_amt          gicl_clm_loss_exp.net_amt%TYPE,
      advise_amt       gicl_clm_loss_exp.advise_amt%TYPE,
      net_amt          gicl_clm_loss_exp.net_amt%TYPE,
      paid_amt         gicl_clm_loss_exp.paid_amt%TYPE,
      net_ret          gicl_loss_exp_ds.shr_le_adv_amt%TYPE,
      facul            gicl_loss_exp_ds.shr_le_adv_amt%TYPE,
      treaty           gicl_loss_exp_ds.shr_le_adv_amt%TYPE,
      remarks          gicl_advice.remarks%TYPE,
      csr_no           VARCHAR2 (50),
      iss_cd           gicl_claims.iss_cd%TYPE,
      title            VARCHAR2 (500),
      attention        VARCHAR2 (500),
      cf_v_sp          VARCHAR2 (2000),
      acct_of          VARCHAR2 (300),
      term             VARCHAR2 (100),
      intm             VARCHAR2 (250),
      loss_ctgry       VARCHAR2 (250),
      loss_exp_cd      gicl_loss_exp_dtl.loss_exp_cd%TYPE,
      loss_exp_desc    giis_loss_exp.loss_exp_desc%TYPE,
      sum_b_dtl_amt    gicl_loss_exp_dtl.dtl_amt%TYPE,
      clm_clmnt_no     gicl_loss_exp_dtl.dtl_amt%TYPE,
      vat_label        VARCHAR2 (200),
      tax_input        gicl_loss_exp_tax.tax_amt%TYPE,
      tax_others       gicl_loss_exp_tax.tax_amt%TYPE,
      cf_curr          VARCHAR2 (50),
      tax_in_adv       gicl_loss_exp_tax.tax_amt%TYPE,
      tax_oth_adv      gicl_loss_exp_tax.tax_amt%TYPE,
      cf_final         VARCHAR (200),
      peril_sname      giis_peril.peril_sname%TYPE,
      peril_paid_amt   gicl_clm_loss_exp.paid_amt%TYPE,
      doc_type_desc    VARCHAR2 (200),
      payment_for      VARCHAR2 (600),
      --changed by robert from varchar2(200) 11.28.2013
      doc_no           gicl_loss_exp_bill.doc_number%TYPE,
      label            VARCHAR2 (200),
      designation      VARCHAR2 (200),
      signatory        VARCHAR2 (200),
      show_dist        VARCHAR2 (1),
      show_peril       VARCHAR2 (1),
      signatory_sw     VARCHAR2 (1),                   -- andrew - 04.18.2012
      sum_loss         gicl_loss_exp_tax.tax_amt%TYPE, -- bonok :: 11.28.2012
      label_tag        gipi_polbasic.label_tag%TYPE    -- bonok :: 12.07.2012
   );

   TYPE giclr032_tab IS TABLE OF giclr032_type;

   FUNCTION populate_giclr032 (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_advice_id   gicl_advice.advice_id%TYPE
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION cf_v_spformula (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_name             VARCHAR2,
      p_ex_gratia_sw     gicl_clm_loss_exp.ex_gratia_sw%TYPE,
      p_currency_cd      gicl_clm_loss_exp.currency_cd%TYPE,
      p_paid_amt         gicl_clm_loss_exp.paid_amt%TYPE,
      p_final_tag        gicl_clm_loss_exp.final_tag%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION cf_termformula (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_intmformula (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN VARCHAR2;

   FUNCTION cf_loss_ctgryformula (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_advice_id   gicl_advice.advice_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION cf_csr_noformula (
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_claim_id         gicl_clm_loss_exp.claim_id%TYPE,
      p_advice_id        gicl_clm_loss_exp.advice_id%TYPE,
      p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_clm_loss_exp_desc (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION get_clm_loss_exp_desc2 (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,
                                                   --added by aliza 10/27/2014
      p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE
                                                   --added by aliza 10/27/2014
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION get_clm_deductibles (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,
                                                   --added by aliza 10/27/2014
      p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE
                                                   --added by aliza 10/27/2014
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION get_tax_input (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,
                                                   --added by aliza 10/27/2014
      p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE
                                                   --added by aliza 10/27/2014
   )
      RETURN NUMBER;

   FUNCTION get_tax_others (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,
                                                   --added by aliza 10/27/2014
      p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE
                                                   --added by aliza 10/27/2014
   )
      RETURN NUMBER;

   FUNCTION get_tax_oth_adv (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,
                                                   --added by aliza 10/27/2014
      p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE
                                                   --added by aliza 10/27/2014
   )
      RETURN NUMBER;

   FUNCTION get_tax_in_adv (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE,
      p_final_tag          gicl_clm_loss_exp.final_tag%TYPE,
                                                   --added by aliza 10/27/2014
      p_ex_gratia_sw       gicl_clm_loss_exp.ex_gratia_sw%TYPE
                                                   --added by aliza 10/27/2014
   )
      RETURN NUMBER;

   FUNCTION cf_finalformula (
      p_claim_id       gicl_claims.claim_id%TYPE,
      p_advice_id      gicl_advice.advice_id%TYPE,
      p_name           VARCHAR2,
      p_ex_gratia_sw   gicl_clm_loss_exp.ex_gratia_sw%TYPE,
      p_final_tag      gicl_clm_loss_exp.final_tag%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_clm_perils (
      p_claim_id    gicl_claims.claim_id%TYPE,
      p_advice_id   gicl_advice.advice_id%TYPE,
      p_line_cd     gicl_advice.line_cd%TYPE
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION get_payment_dtls (
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_advice_id        gicl_advice.advice_id%TYPE,
      p_payee_class_cd   gicl_clm_loss_exp.payee_class_cd%TYPE,
      p_payee_cd         gicl_clm_loss_exp.payee_cd%TYPE
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION get_clm_signatory (
      p_line_cd     giis_line.line_cd%TYPE,
      p_branch_cd   gicl_claims.iss_cd%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION show_dist (p_line_cd gicl_claims.line_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION show_peril (p_line_cd gicl_claims.line_cd%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_clm_signatory2 (
      p_line_cd     giis_line.line_cd%TYPE,
      p_branch_cd   gicl_claims.iss_cd%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN giclr032_tab PIPELINED;

   FUNCTION get_label_tag (
      p_line_cd      gipi_polbasic.line_cd%TYPE,
      p_subline_cd   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     gipi_polbasic.renew_no%TYPE,
      p_loss_date    gipi_polbasic.eff_date%TYPE
   )
      RETURN VARCHAR2;
END;
/


