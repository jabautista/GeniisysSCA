CREATE OR REPLACE PACKAGE CPI.giacs211_pkg
AS
   TYPE gipi_invoice_type IS RECORD (
      count_           NUMBER, -- andrew - 07212015 - 19643
      rownum_          NUMBER, -- andrew - 07212015 - 19643
      iss_cd                  gipi_invoice.iss_cd%TYPE,
      prem_seq_no             gipi_invoice.prem_seq_no%TYPE,
      policy_id               gipi_invoice.policy_id%TYPE,
      property                gipi_invoice.property%TYPE,
      currency_cd             gipi_invoice.currency_cd%TYPE,
      currency_rt             gipi_invoice.currency_rt%TYPE,
      prem_amt                gipi_invoice.prem_amt%TYPE,
      tax_amt                 gipi_invoice.tax_amt%TYPE,
      other_charges           gipi_invoice.other_charges%TYPE,
      notarial_fee            gipi_invoice.notarial_fee%TYPE,
      payt_terms              gipi_invoice.payt_terms%TYPE,
      insured                 gipi_invoice.insured%TYPE,
      assd_no                 giis_assured.assd_no%TYPE,
      designation             giis_assured.designation%TYPE,
      assd_name               giis_assured.assd_name%TYPE,
      dsp_line_cd             gipi_polbasic.line_cd%TYPE,
      dsp_subline_cd          gipi_polbasic.subline_cd%TYPE,
      dsp_iss_cd              gipi_polbasic.iss_cd%TYPE,
      dsp_issue_yy            gipi_polbasic.issue_yy%TYPE,
      dsp_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      dsp_renew_no            gipi_polbasic.renew_no%TYPE,
      dsp_endt_iss_cd         gipi_polbasic.endt_iss_cd%TYPE,
      dsp_endt_yy             gipi_polbasic.endt_yy%TYPE,
      dsp_endt_seq_no         gipi_polbasic.endt_seq_no%TYPE,
      dsp_endt_type           gipi_polbasic.endt_type%TYPE,
      pack_policy_id          gipi_pack_polbasic.pack_policy_id%TYPE,
      pack_line_cd            gipi_pack_polbasic.line_cd%TYPE,
      pack_subline_cd         gipi_pack_polbasic.subline_cd%TYPE,
      pack_iss_cd             gipi_pack_polbasic.iss_cd%TYPE,
      pack_issue_yy           gipi_pack_polbasic.issue_yy%TYPE,
      pack_pol_seq_no         gipi_pack_polbasic.pol_seq_no%TYPE,
      pack_renew_no           gipi_pack_polbasic.renew_no%TYPE,
      pack_endt_iss_cd        gipi_pack_polbasic.endt_iss_cd%TYPE,
      pack_endt_yy            gipi_pack_polbasic.endt_yy%TYPE,
      pack_endt_seq_no        gipi_pack_polbasic.endt_seq_no%TYPE,
      pack_bill_iss_cd        gipi_pack_invoice.iss_cd%TYPE,
      pack_bill_prem_seq_no   gipi_pack_invoice.prem_seq_no%TYPE,
      pol_flag                gipi_polbasic.pol_flag%TYPE,
      due_date                gipi_invoice.due_date%TYPE,
      incept_date             gipi_polbasic.incept_date%TYPE,
      expiry_date             gipi_polbasic.expiry_date%TYPE,
      issue_date              gipi_polbasic.issue_date%TYPE,
      spld_date               gipi_polbasic.spld_date%TYPE,
      due_date_char           VARCHAR2 (20),
      incept_date_char        VARCHAR2 (20),
      expiry_date_char        VARCHAR2 (20),
      issue_date_char         VARCHAR2 (20),
      spld_date_char          VARCHAR2 (20),
      ref_pol_no              gipi_polbasic.ref_pol_no%TYPE,
      intm_name               giis_intermediary.intm_name%TYPE,
      ref_intm_cd             giis_intermediary.ref_intm_cd%TYPE,
      intm_type               giis_intermediary.intm_type%TYPE,
      share_percentage        gipi_comm_invoice.share_percentage%TYPE,
      intrmdry_intm_no        gipi_comm_invoice.intrmdry_intm_no%TYPE,
      policy_status           VARCHAR2 (150),
      reg_policy_sw           VARCHAR2 (100),
      php_prem                NUMBER (16, 2),
      php_tax                 NUMBER (16, 2),
      php_charges             NUMBER (16, 2),
      total_amt_due           NUMBER (16, 2),
      curr_desc               giis_currency.currency_desc%TYPE,
      foren_prem              NUMBER (16, 2),
      foren_tax               NUMBER (16, 2),
      foren_charges           NUMBER (16, 2),
      foren_total             NUMBER (16, 2),
      net_premium             NUMBER (16, 2),
      endt_no                 VARCHAR2(100)
   );

   TYPE gipi_invoice_tab IS TABLE OF gipi_invoice_type;

   TYPE giac_direct_prem_collns_type IS RECORD (
      dsp_or_no              VARCHAR2 (20),
      gacc_tran_id           giac_direct_prem_collns.gacc_tran_id%TYPE,
      transaction_type       giac_direct_prem_collns.transaction_type%TYPE,
      collection_amt         giac_direct_prem_collns.collection_amt%TYPE,
      gibr_branch_cd         giac_acctrans.gibr_branch_cd%TYPE,
      tran_class             giac_acctrans.tran_class%TYPE,
      tran_class_no          giac_acctrans.tran_class_no%TYPE,
      jv_no                  giac_acctrans.jv_no%TYPE,
      tran_year              giac_acctrans.tran_year%TYPE,
      tran_month             giac_acctrans.tran_month%TYPE,
      tran_seq_no            giac_acctrans.tran_seq_no%TYPE,
      tran_date              giac_acctrans.tran_date%TYPE,
      tran_date_char         VARCHAR2 (20),
      dsp_transaction_type   giac_direct_prem_collns.transaction_type%TYPE,
      dsp_collection_amt     giac_direct_prem_collns.collection_amt%TYPE,
      curr_desc2             giis_currency.short_name%TYPE,
      foren_coll             NUMBER (16, 2),
      conv_rate2             giis_currency.CURRENCY_RT%TYPE, --NUMBER (16, 2),
      balance_due            NUMBER (16, 2),
      total_collection_amt   NUMBER (16, 2),
      foren_balance          NUMBER (16, 2),
      foren_total2           NUMBER (16, 2)
   );

   TYPE giac_direct_prem_collns_tab IS TABLE OF giac_direct_prem_collns_type;

   TYPE giis_intermediary_lov_type IS RECORD (
      count_        NUMBER, -- andrew - 07212015 - 19643
      rownum_       NUMBER, -- andrew - 07212015 - 19643   
      intm_no       giis_intermediary.intm_no%TYPE,
      ref_intm_cd   giis_intermediary.ref_intm_cd%TYPE,
      intm_name     giis_intermediary.intm_name%TYPE
   );

   TYPE giis_intermediary_lov_tab IS TABLE OF giis_intermediary_lov_type;

   TYPE giis_intm_type_lov_type IS RECORD (
      count_           NUMBER, -- andrew - 07212015 - 19643
      rownum_          NUMBER, -- andrew - 07212015 - 19643
      intm_type   giis_intm_type.intm_type%TYPE,
      intm_desc   giis_intm_type.intm_desc%TYPE
   );

   TYPE giis_intm_type_lov_tab IS TABLE OF giis_intm_type_lov_type;

   TYPE giis_assured_lov_type IS RECORD (
      count_           NUMBER, -- andrew - 07212015 - 19643
      rownum_          NUMBER, -- andrew - 07212015 - 19643   
      assd_no     giis_assured.assd_no%TYPE,
      assd_name   giis_assured.assd_name%TYPE
   );

   TYPE giis_assured_lov_tab IS TABLE OF giis_assured_lov_type;

   TYPE cg_ref_codes_lov_type IS RECORD (
      rv_low_value      cg_ref_codes.rv_low_value%TYPE,
      rv_meaning        cg_ref_codes.rv_meaning%TYPE,
      rv_abbreviation   cg_ref_codes.rv_abbreviation%TYPE
   );

   TYPE cg_ref_codes_lov_tab IS TABLE OF cg_ref_codes_lov_type;

   TYPE premium_info_type IS RECORD (
      iss_cd        gipi_invperil.iss_cd%TYPE,
      prem_seq_no   gipi_invperil.prem_seq_no%TYPE,
      peril_cd      gipi_invperil.peril_cd%TYPE,
      item_grp      gipi_invperil.item_grp%TYPE,
      tsi_amt       gipi_invperil.tsi_amt%TYPE,
      prem_amt      gipi_invperil.prem_amt%TYPE,
      peril_name    giis_peril.peril_name%TYPE
   );

   TYPE premium_info_tab IS TABLE OF premium_info_type;

   TYPE taxes_info_type IS RECORD (
      iss_cd        gipi_inv_tax.iss_cd%TYPE,
      prem_seq_no   gipi_inv_tax.prem_seq_no%TYPE,
      tax_cd        gipi_inv_tax.tax_cd%TYPE,
      item_grp      gipi_inv_tax.item_grp%TYPE,
      tax_amt       gipi_inv_tax.tax_amt%TYPE,
      dsp_tax_amt   gipi_inv_tax.tax_amt%TYPE,
      tax_desc      giis_tax_charges.tax_desc%TYPE
   );

   TYPE taxes_info_tab IS TABLE OF taxes_info_type;

   TYPE pdc_payment_info_type IS RECORD (
      apdc_id          giac_apdc_payt.apdc_id%TYPE,
      apdc_flag        giac_apdc_payt.apdc_flag%TYPE,
      apdc_no          VARCHAR (20),
      apdc_date        giac_apdc_payt.apdc_date%TYPE,
      payor            giac_apdc_payt.payor%TYPE,
      bank_branch      giac_apdc_payt_dtl.bank_branch%TYPE,
      bank_cd          giac_apdc_payt_dtl.bank_cd%TYPE,
      check_class      giac_apdc_payt_dtl.check_class%TYPE,
      check_no         giac_apdc_payt_dtl.check_no%TYPE,
      check_date       giac_apdc_payt_dtl.check_date%TYPE,
      bank_sname       giac_banks.bank_sname%TYPE,
      collection_amt   giac_pdc_prem_colln.collection_amt%TYPE,
      pdc_id           giac_pdc_prem_colln.pdc_id%TYPE,
      sdf_check_date   VARCHAR (20),
      sdf_apdc_date    VARCHAR (20),
      prem_seq_no      giac_pdc_prem_colln.prem_seq_no%TYPE,
      iss_cd           giac_pdc_prem_colln.iss_cd%TYPE
   );

   TYPE pdc_payment_info_tab IS TABLE OF pdc_payment_info_type;

   TYPE balances_info_type IS RECORD (
      inst_no            giac_aging_soa_details.inst_no%TYPE,
      prem_balance_due   giac_aging_soa_details.prem_balance_due%TYPE,
      tax_balance_due    giac_aging_soa_details.tax_balance_due%TYPE,
      balance_amt_due    giac_aging_soa_details.balance_amt_due%TYPE
   );

   TYPE balances_info_tab IS TABLE OF balances_info_type;

   FUNCTION get_bill_details(
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   ) RETURN gipi_invoice_tab PIPELINED;
      
   FUNCTION get_gipi_invoice (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN gipi_invoice_tab PIPELINED;

   FUNCTION get_policy_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,
      p_ref_pol_no    gipi_polbasic.ref_pol_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,  
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_bill_iss_cd   gipi_invoice.iss_cd%TYPE,      
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN gipi_invoice_tab PIPELINED;
      
   FUNCTION get_pack_policy_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_line_cd       gipi_pack_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_pack_polbasic.subline_cd%TYPE,
      p_iss_cd        gipi_pack_polbasic.iss_cd%TYPE,
      p_issue_yy      gipi_pack_polbasic.issue_yy%TYPE,
      p_pol_seq_no    gipi_pack_polbasic.pol_seq_no%TYPE,
      p_renew_no      gipi_pack_polbasic.renew_no%TYPE,
      p_endt_iss_cd   gipi_pack_polbasic.endt_iss_cd%TYPE,
      p_endt_yy       gipi_pack_polbasic.endt_yy%TYPE,
      p_endt_seq_no   gipi_pack_polbasic.endt_seq_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,  
      p_assd_no       gipi_pack_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_policy_id     gipi_polbasic.policy_id%TYPE,
      p_pack_bill_iss_cd   gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_bill_iss_cd   gipi_invoice.iss_cd%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN gipi_invoice_tab PIPELINED;      

   FUNCTION get_giac_direct_prem_collns (
      p_iss_cd          gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no     gipi_invoice.prem_seq_no%TYPE,
      p_currency_cd     gipi_invoice.currency_cd%TYPE,
      p_currency_rt     gipi_invoice.currency_rt%TYPE,
      p_pol_flag        gipi_polbasic.pol_flag%TYPE,
      p_total_amt_due   NUMBER
   )
      RETURN giac_direct_prem_collns_tab PIPELINED;

   FUNCTION get_giis_intermediary_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_type     giis_intermediary.intm_type%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER
   )
      RETURN giis_intermediary_lov_tab PIPELINED;

   FUNCTION get_giis_intm_type_lov (     
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_no       gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER 
   ) RETURN giis_intm_type_lov_tab PIPELINED;

   FUNCTION get_giis_assured_lov(
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_policy_id       gipi_invoice.policy_id%TYPE,
      p_due_date        VARCHAR2,
      p_incept_date     VARCHAR2,
      p_expiry_date     VARCHAR2,
      p_issue_date      VARCHAR2,
      p_intm_no         gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_pack_policy_id     gipi_pack_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd   gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_bill_iss_cd     gipi_invoice.iss_cd%TYPE, 
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )  RETURN giis_assured_lov_tab PIPELINED;

   FUNCTION get_cg_ref_codes_lov
      RETURN cg_ref_codes_lov_tab PIPELINED;

   FUNCTION get_premium_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN premium_info_tab PIPELINED;

   FUNCTION get_taxes_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_currency_rt   gipi_invoice.currency_rt%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN taxes_info_tab PIPELINED;

   FUNCTION get_pdc_payments_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN pdc_payment_info_tab PIPELINED;

   FUNCTION get_balances_info (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE,
      p_to_foreign    NUMBER
   )
      RETURN balances_info_tab PIPELINED;
      
    TYPE iss_cd_type IS RECORD (     
      count_        NUMBER, -- andrew - 07212015 - 19643
      rownum_       NUMBER, -- andrew - 07212015 - 19643     
      iss_cd        gipi_invoice.iss_cd%TYPE
   );

   TYPE iss_cd_tab IS TABLE OF iss_cd_type;      
      
    -- shan 11.14.2014
    FUNCTION get_iss_cd_lov (
      p_module_id     giis_modules.module_id%TYPE,
      p_user_id       giis_users.user_id%TYPE,
      p_policy_id     gipi_invoice.policy_id%TYPE,
      p_assd_no       gipi_polbasic.assd_no%TYPE,
      p_intm_type     giis_intermediary.intm_type%TYPE,
      p_intm_no       giis_intermediary.intm_no%TYPE,
      p_due_date      VARCHAR2,
      p_incept_date   VARCHAR2,
      p_expiry_date   VARCHAR2,
      p_issue_date    VARCHAR2,
      p_pack_policy_id gipi_polbasic.pack_policy_id%TYPE,
      p_pack_bill_iss_cd gipi_pack_invoice.iss_cd%TYPE,
      p_pack_bill_prem_seq_no gipi_pack_invoice.prem_seq_no%TYPE,
      p_find_text     VARCHAR2,
      p_order_by      VARCHAR2,
      p_asc_desc_flag VARCHAR2,
      p_from          NUMBER,
      p_to            NUMBER 
    )
    RETURN iss_cd_tab PIPELINED;
END;
/
