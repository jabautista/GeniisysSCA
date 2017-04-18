CREATE OR REPLACE PACKAGE CPI.csv_acctg
AS
   TYPE crr_rec_type IS RECORD (
      gibr_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      or_no             VARCHAR2 (50),
      tran_id           giac_order_of_payts.gacc_tran_id%TYPE,       --reymon
      dcb_no            giac_order_of_payts.dcb_no%TYPE,
      or_date           DATE,
      posting_date      giac_acctrans.posting_date%TYPE,
      intm_cd           VARCHAR2 (100),
      payor             VARCHAR2 (550),
                                       -- modified by aaron from varchar2(50)
      tin               giac_order_of_payts.tin%TYPE,
      collection_amt    giac_order_of_payts.collection_amt%TYPE,
      particulars       giac_acctrans.particulars%TYPE,
      gl_account        VARCHAR2 (50),
      gl_account_name   giac_chart_of_accts.gl_acct_name%TYPE,
      sl_cd             giac_acct_entries.sl_cd%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE
   );

   TYPE crr_type IS TABLE OF crr_rec_type;

   TYPE crr_rec_type2 IS RECORD (
      gibr_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      gl_account        VARCHAR2 (50),
      gl_account_name   giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE,
      balance_amt       giac_acct_entries.debit_amt%TYPE
   );

   TYPE crr_type2 IS TABLE OF crr_rec_type2;

   TYPE cdr_rec_type IS RECORD (
      gibr_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      posting_date      VARCHAR2 (20),/*giac_acctrans.posting_date%TYPE,*/  --Deo [03.13.2017]: change datatype (SR-23914)
      dv_no             VARCHAR2 (20),       --GIAC_DISB_VOUCHERS.dv_no%TYPE,
      tran_id           giac_disb_vouchers.gacc_tran_id%TYPE,
      ref_no            giac_disb_vouchers.ref_no%TYPE,
      check_no          VARCHAR2 (20),
      chk_date          VARCHAR2 (20),
      check_amount      giac_chk_disbursement.amount%TYPE,
      particulars       giac_acctrans.particulars%TYPE,
      payee             giac_disb_vouchers.payee%TYPE,
      tin               giis_payees.tin%TYPE,
      dv_amt            giac_disb_vouchers.dv_amt%TYPE,
      gl_account        VARCHAR2 (50),
      gl_account_name   giac_chart_of_accts.gl_acct_name%TYPE,
      sl_cd             giac_acct_entries.sl_cd%TYPE,
      debit_amt         giac_acct_entries.debit_amt%TYPE,
      credit_amt        giac_acct_entries.credit_amt%TYPE,
      balance_amt       NUMBER (18, 2)
   );                                              --added by april 07/08/09);

   TYPE cdr_type IS TABLE OF cdr_rec_type;

   TYPE cdr_type2 IS TABLE OF crr_rec_type2;

   -- START added by Jayson 10.25.2011 --
   -- For print to CSV of Purchase Register --
   TYPE cdrpr_rec_type IS RECORD (
      branch        giis_issource.iss_name%TYPE,
      date_         giac_acctrans.posting_date%TYPE,
      ref_no        VARCHAR2 (16),
      tin           giis_payees.tin%TYPE,
      payee         giac_disb_vouchers.payee%TYPE,
      particulars   giac_disb_vouchers.particulars%TYPE,
      amount        giac_acct_entries.debit_amt%TYPE,
      discount      NUMBER,
      input_vat     giac_acct_entries.debit_amt%TYPE,
      net_amt       giac_acct_entries.debit_amt%TYPE
   );

   TYPE cpr_table IS TABLE OF cdrpr_rec_type;

   -- END added by Jayson 10.25.2011 --
   TYPE jvr_rec_type IS RECORD (
      gibr_branch_cd    giac_acctrans.gibr_branch_cd%TYPE,
      branch_name       giac_branches.branch_name%TYPE,
      tran_date         giac_acctrans.posting_date%TYPE,
      posting_date      giac_acctrans.posting_date%TYPE,
      tran_id           giac_acctrans.tran_id%TYPE,
      ref_no            VARCHAR2 (100),
      jv_tran_type      giac_acctrans.jv_tran_type%TYPE,
      particulars       giac_acctrans.particulars%TYPE,
      lr_or_no          VARCHAR2 (25),
      lr_or_date        VARCHAR2 (25),
      gl_account        VARCHAR2 (50),
      gl_account_name   giac_chart_of_accts.gl_acct_name%TYPE,
      debit_amt     giac_acct_entries.debit_amt%TYPE,
      credit_amt    giac_acct_entries.credit_amt%TYPE,
      jv_ref_no         VARCHAR2 (100) -- added by gab 09.14.2015
   );

   TYPE jvr_type IS TABLE OF jvr_rec_type;

   TYPE jvr_rec_type2 IS RECORD (
      gl_account        VARCHAR2 (50),
      gl_account_name   giac_chart_of_accts.gl_acct_name%TYPE,
      debit_balance     giac_acct_entries.debit_amt%TYPE, --edited MarkS 5.15.2016 SR5599
      credit_balance    giac_acct_entries.credit_amt%TYPE --edited MarkS 5.15.2016 SR5599
   );

   TYPE jvr_type2 IS TABLE OF jvr_rec_type2;

   TYPE ifrsl_rec_type IS RECORD (
      reinsurer           giis_reinsurer.ri_name%TYPE,
      line_name           giis_line.line_name%TYPE,
      policy_no           VARCHAR2 (50),
      ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
      issue_date          gipi_polbasic.issue_date%TYPE,
      incept_date         gipi_polbasic.incept_date%TYPE,
      invoice_no          VARCHAR2 (20),
      ri_policy_no        giri_inpolbas.ri_policy_no%TYPE,
      ri_binder_no        giri_inpolbas.ri_binder_no%TYPE,
      assd_name           giis_assured.assd_name%TYPE,       --ADDED BY APRIL
      amount_insured      gipi_polbasic.tsi_amt%TYPE,
      premium             NUMBER (12, 2),
      vat                 NUMBER (12, 2),
      ri_commission       NUMBER (12, 2),
      vat_on_commission   NUMBER (12, 2),
      net_due             NUMBER (12, 2),
      ref_date            DATE,
      ref_no              VARCHAR2 (60),  -- jhing GENQA 5269 changed from varchar2(20) to varchar2(60) 
      collection_amt      giac_inwfacul_prem_collns.collection_amt%TYPE,
      balance             NUMBER (12, 2)
   );

   TYPE ifrsl_type IS TABLE OF ifrsl_rec_type;

   TYPE orsl_rec_type IS RECORD (
      ri_name           giis_reinsurer.ri_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      eff_date          giri_binder.eff_date%TYPE,
      ppw               giri_binder.eff_date%TYPE,
                                                 --added by Jayson 11.14.2011
      binder            VARCHAR2 (20),
      policy_no         VARCHAR2 (50),
      assured           giis_assured.assd_name%TYPE,
      intm              VARCHAR2 (12),
      amt_insured       giri_binder.ri_tsi_amt%TYPE,
      prem              giri_binder.ri_prem_amt%TYPE,
      ri_prem_vat       giri_binder.ri_prem_vat%TYPE,
      comm              giri_binder.ri_comm_amt%TYPE,
      ri_comm_vat       giri_binder.ri_comm_vat%TYPE,
      ri_wholding_vat   giri_binder.ri_wholding_vat%TYPE,
      net_prem          NUMBER (18, 2),
      ref_date          VARCHAR2 (300),                        --aaron 080608
      --ref_date       DATE,
      ref_no            VARCHAR2 (300),
      --ref_no         VARCHAR2(20),
      disb_amt          NUMBER (18, 2),                                  --);
      bal_amt           NUMBER (18, 2)
   );                                                         --alfie 05252009

   TYPE orsl_type IS TABLE OF orsl_rec_type;
   
   -- jhing 01.28.2016, created new data type for GENQA 5270
  TYPE orsl_rec_type_v2 IS RECORD (
      ri_name           giis_reinsurer.ri_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      eff_date          giri_binder.eff_date%TYPE,
      ppw               giri_binder.eff_date%TYPE,
      binder            VARCHAR2 (20),
      policy_no         VARCHAR2 (50),
      assured           giis_assured.assd_name%TYPE,
      intm              VARCHAR2 (12),
      amt_insured       giri_binder.ri_tsi_amt%TYPE,
      prem              giri_binder.ri_prem_amt%TYPE,
      ri_prem_vat       giri_binder.ri_prem_vat%TYPE,
      comm              giri_binder.ri_comm_amt%TYPE,
      ri_comm_vat       giri_binder.ri_comm_vat%TYPE,
      ri_wholding_vat   giri_binder.ri_wholding_vat%TYPE,
      net_prem          NUMBER (18, 2),
      ref_date          DATE,
      ref_no            VARCHAR2 (300),
      disb_amt          NUMBER (18, 2),                              
      bal_amt           NUMBER (18, 2)
   );     
   
   TYPE orsl_type_v2 IS TABLE OF orsl_rec_type_v2;                                                   
   

   --added by reymon for official receipts register
   TYPE orr_rec_type IS RECORD (
      branch             VARCHAR2 (52),
      or_no              VARCHAR2 (20),
      or_date            giac_order_of_payts.or_date%TYPE,
      tran_date          giac_acctrans.tran_date%TYPE,
      posting_date       giac_acctrans.posting_date%TYPE,
      payor              giac_order_of_payts.payor%TYPE,
      amount_received    giac_collection_dtl.amount%TYPE,
      currency           giis_currency.short_name%TYPE,
      foreign_currency   giac_collection_dtl.fcurrency_amt%TYPE
   );

   TYPE orr_type IS TABLE OF orr_rec_type;

   TYPE orr_rec_type2 IS RECORD (
      branch             VARCHAR2 (52),
      or_no              VARCHAR2 (20),
      or_date            giac_order_of_payts.or_date%TYPE,
      tran_date          giac_acctrans.tran_date%TYPE,
      posting_date       giac_acctrans.posting_date%TYPE,
      payor              giac_order_of_payts.payor%TYPE,
      amount_received    giac_collection_dtl.amount%TYPE,
      currency           giis_currency.short_name%TYPE,
      foreign_currency   giac_collection_dtl.fcurrency_amt%TYPE
   );

   TYPE orr_type2 IS TABLE OF orr_rec_type2;                   --end of reymon

   /* Added by reymon 02282012
   ** For AC-SPECS-2012-013
   ** Added report GIACR135 (CHECK REGISTER)
   */
   TYPE cr_rec_type IS RECORD (
      branch              giac_branches.branch_name%TYPE,
      bank                giac_banks.bank_name%TYPE,
      bank_account_no     giac_bank_accounts.bank_acct_no%TYPE,
      disbursement        VARCHAR2 (20),
      payee               giac_chk_disbursement.payee%TYPE,
      particulars         giac_disb_vouchers.particulars%TYPE,
      date_posted         giac_acctrans.posting_date%TYPE,
      dv_date             giac_disb_vouchers.dv_date%TYPE,
      dv_number           VARCHAR2 (20),
      check_date          giac_chk_disbursement.check_date%TYPE,
      check_no            VARCHAR2 (20),
      batch_tag           VARCHAR2 (2),
      check_amount        giac_chk_disbursement.amount%TYPE,
      date_released       giac_chk_release_info.check_release_date%TYPE,
      unreleased_amount   giac_chk_disbursement.amount%TYPE,
      ref_no              giac_disb_vouchers.ref_no%TYPE,
      gibr_branch_cd      giac_branches.branch_cd%TYPE         --erma02012013
   );

   TYPE cr_type IS TABLE OF cr_rec_type;

   --added by steven 06.17.2014
   TYPE giacr135_include_part_type IS RECORD (
      branch              giac_branches.branch_name%TYPE,
      bank                giac_banks.bank_name%TYPE,
      bank_account_no     giac_bank_accounts.bank_acct_no%TYPE,
      disbursement        VARCHAR2 (20),
      payee               giac_chk_disbursement.payee%TYPE,
      particulars         giac_disb_vouchers.particulars%TYPE,
      date_posted         giac_acctrans.posting_date%TYPE,
      dv_date             giac_disb_vouchers.dv_date%TYPE,
      dv_number           VARCHAR2 (20),
      check_date          giac_chk_disbursement.check_date%TYPE,
      check_no            VARCHAR2 (20),
      batch_tag           VARCHAR2 (2),
      check_amount        giac_chk_disbursement.amount%TYPE,
      date_released       giac_chk_release_info.check_release_date%TYPE,
      unreleased_amount   giac_chk_disbursement.amount%TYPE
   );

   TYPE giacr135_include_part_tab IS TABLE OF giacr135_include_part_type;

   TYPE giacr135_exclude_part_type IS RECORD (
      branch              giac_branches.branch_name%TYPE,
      bank                giac_banks.bank_name%TYPE,
      bank_account_no     giac_bank_accounts.bank_acct_no%TYPE,
      disbursement        VARCHAR2 (20),
      payee               giac_chk_disbursement.payee%TYPE,
      date_posted         giac_acctrans.posting_date%TYPE,
      dv_date             giac_disb_vouchers.dv_date%TYPE,
      dv_number           VARCHAR2 (20),
      check_date          giac_chk_disbursement.check_date%TYPE,
      check_no            VARCHAR2 (20),
      batch_tag           VARCHAR2 (2),
      check_amount        giac_chk_disbursement.amount%TYPE,
      date_released       giac_chk_release_info.check_release_date%TYPE,
      unreleased_amount   giac_chk_disbursement.amount%TYPE
   );

   TYPE giacr135_exclude_part_tab IS TABLE OF giacr135_exclude_part_type;

   --steven end

   --end of 02282012
   FUNCTION cashreceiptsregister_d (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN crr_type PIPELINED;

   FUNCTION cashreceiptsregister_s (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN crr_type2 PIPELINED;

   FUNCTION cashdisbregister_d (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_dv_check           VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_user_id            VARCHAR2  --Deo [03.13.2017]: add parameter (SR-23914)
   )
      RETURN cdr_type PIPELINED;

   FUNCTION cashdisbregister_s (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2
   )
      RETURN crr_type2 PIPELINED;

   -- START added by Jayson 10.25.2011 --
   -- For print to CSV of Purchase Register --
   FUNCTION cashdisbregister_pr (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2
   )
      RETURN cpr_table PIPELINED;

   -- END added by Jayson 10.25.2011 --
   FUNCTION journalvoucherregister_d (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_jv_tran_cd         VARCHAR2,
      p_coldv              VARCHAR2
   )
      RETURN jvr_type PIPELINED;

   FUNCTION journalvoucherregister_s (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_jv_tran_cd         VARCHAR2
   )
      RETURN jvr_type2 PIPELINED;

   FUNCTION infacrisubsledger (
      p_from_date   DATE,
      p_to_date     DATE,
      p_ri_cd       NUMBER,
      p_line_cd     VARCHAR2,
      p_date_type   VARCHAR2,
      p_module_id   VARCHAR2,  -- added by jhing 01.08.2015 
      p_user_id     VARCHAR2   -- added by jhing 01.08.2015 
   )
      RETURN ifrsl_type PIPELINED;

   FUNCTION outrisubsledger_old (  -- jhing GENQA 5270, renamed original function to old. Will redesign CSV output
      p_date_from   DATE,
      p_date_to     DATE,
      p_ri_cd       NUMBER,
      p_line_cd     VARCHAR2,
      p_date_type   VARCHAR2,
      p_module_id   VARCHAR2, --mikel 11.23.2015; UCPBGEN 20878
      p_user_id     VARCHAR2 --mikel 11.23.2015; UCPBGEN 20878
   )
      RETURN orsl_type PIPELINED;
      
    FUNCTION outrisubsledger (   -- jhing GENQA 5270, new function for the CSV output of GIACR106
      p_date_from   DATE,
      p_date_to     DATE,
      p_ri_cd       NUMBER,
      p_line_cd     VARCHAR2,
      p_date_type   VARCHAR2,
      p_module_id   VARCHAR2, 
      p_user_id     VARCHAR2 
   )
      RETURN orsl_type_v2 PIPELINED;   

   FUNCTION officialreceiptsregister_ap (
      p_date        DATE,
      p_date2       DATE,
      p_branch_cd   VARCHAR2,
      p_tran_flag   NUMBER,
      p_user_id     VARCHAR2
   )
      RETURN orr_type PIPELINED;

   FUNCTION officialreceiptsregister_u (
      p_date        DATE,
      p_date2       DATE,
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN orr_type2 PIPELINED;

   /* Added by reymon 02282012
   ** For AC-SPECS-2012-013
   ** Added report GIACR135 (CHECK REGISTER)
   */
   FUNCTION checkregister (
      p_post_tran_toggle   VARCHAR2,
      p_branch             VARCHAR2,
      p_begin_date         DATE,
      p_end_date           DATE,
      p_bank_cd            VARCHAR2,
      p_bank_acct_no       VARCHAR2
   )
      RETURN cr_type PIPELINED;

--end 02282012
   --Added by Robert SR 5197 03.01.2016
   TYPE v_giacr135_type IS RECORD ( 
          currency_cd           NUMBER(2),
          unreleased_amt        NUMBER,
          check_amt             NUMBER,
          dv_date               DATE,
          gibr_gfun_fund_cd     VARCHAR2(3),
          gibr_branch_cd        VARCHAR2(2),
          branch_name           VARCHAR2(50),
          bank_cd               VARCHAR2(3),
          bank_name             VARCHAR2(100),
          bank_acct_cd          VARCHAR2(4),
          bank_acct_no          VARCHAR2(30),
          check_date            DATE,
          view_check_date       varchar2(1000),
          dsp_check_no          varchar2(1000),
          view_check_no         varchar2(1000),
          dv_no                 VARCHAR2(200),
          ref_no                VARCHAR2(15),
          view_dv_no            varchar2(1000),
          posting_date          DATE,
          dv_amt                NUMBER(12,2),
          particulars           VARCHAR2(2000),
          release_date          DATE,
          released_by           VARCHAR2(30),
          dv_flag               CHARACTER(1),
          check_pref_suf        VARCHAR2(5),
          check_no              VARCHAR2(200),     
          tran_id               NUMBER(12),
          batch_tag             CHARACTER(1),
          disb_mode             CHARACTER(1),
          gdv_particulars       VARCHAR2(2000)
      );
   TYPE v_giacr135_tab IS TABLE OF v_giacr135_type;
   --end of codes by Robert SR 5197 03.01.2016
   FUNCTION get_giacr135_exclude_part (
      p_post_tran_toggle   VARCHAR2,
      p_branch             VARCHAR2,
      p_begin_date         DATE,
      p_end_date           DATE,
      p_bank_cd            VARCHAR2,
      p_bank_acct_no       VARCHAR2,
      p_order_by           VARCHAR2, --Added by Robert SR 5197 03.01.2016
      p_user_id            VARCHAR2 --Added by Jerome Bautista SR 21299 01.20.2016
   )
      RETURN giacr135_exclude_part_tab PIPELINED;

   FUNCTION get_giacr135_include_part (
      p_post_tran_toggle   VARCHAR2,
      p_branch             VARCHAR2,
      p_begin_date         DATE,
      p_end_date           DATE,
      p_bank_cd            VARCHAR2,
      p_bank_acct_no       VARCHAR2,
      p_order_by           VARCHAR2, --Added by Robert SR 5197 03.01.2016
      p_user_id            VARCHAR2 --Added by Jerome Bautista SR 21299 01.20.2016
   )
      RETURN giacr135_include_part_tab PIPELINED;

   /* start - Gzelle 12022015 SR19822 CSV for GIACR168A */
   TYPE orr_rec_type3 IS RECORD (
      branch             VARCHAR2 (52),
      or_no              VARCHAR2 (20),
      or_date            giac_order_of_payts.or_date%TYPE,
      tran_date          giac_acctrans.tran_date%TYPE,
      posting_date       giac_acctrans.posting_date%TYPE,
      payor              giac_order_of_payts.payor%TYPE,
      amount_received    giac_collection_dtl.amount%TYPE,
      premium            giac_direct_prem_collns.premium_amt%TYPE,
      vat_tax_amt        giac_tax_collns.tax_amt%TYPE,
      lgt_tax_amt        giac_tax_collns.tax_amt%TYPE,
      dst_tax_amt        giac_tax_collns.tax_amt%TYPE,
      fst_tax_amt        giac_tax_collns.tax_amt%TYPE,
      other_tax_amt      giac_tax_collns.tax_amt%TYPE,      
      currency           giis_currency.short_name%TYPE,
      foreign_currency   giac_collection_dtl.fcurrency_amt%TYPE
   );

   TYPE orr_type3 IS TABLE OF orr_rec_type3; 
      
   FUNCTION officialreceiptsregister_ap_a (
      p_date        VARCHAR2,
      p_date2       VARCHAR2,
      p_branch_cd   VARCHAR2,
      p_posted      VARCHAR2,
      p_user_id     VARCHAR2,
      p_or_tag      VARCHAR2
   )
      RETURN orr_type3 PIPELINED;
   /* end - Gzelle 12022015 SR19822 CSV for GIACR168A */        
END;
/
