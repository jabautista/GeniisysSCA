CREATE OR REPLACE PACKAGE cpi.giacs609_pkg
AS
   variables_fund_cd        giis_funds.fund_cd%TYPE    := giacp.v ('FUND_CD');
   variables_source_cd      giac_upload_file.source_cd%TYPE;
   variables_file_no        giac_upload_file.file_no%TYPE;
   variables_ri_cd          giac_upload_file.ri_cd%TYPE;
   variables_user_id        giis_users.user_id%TYPE;
   variables_branch_cd      giis_user_grp_hdr.grp_iss_cd%TYPE;
   variables_tran_id        giac_acctrans.tran_id%TYPE;
   variables_currency_cd    giac_upload_outfacul_prem.currency_cd%TYPE;
   variables_convert_rate   giac_upload_outfacul_prem.convert_rate%TYPE;

   PROCEDURE get_parameters (
      p_user_id                 IN       VARCHAR2,
      p_branch_cd               OUT      giis_user_grp_hdr.grp_iss_cd%TYPE,
      p_branch_name             OUT      giac_branches.branch_name%TYPE,
      p_document_cd             OUT      giac_parameters.param_value_v%TYPE,
      p_jv_tran_type            OUT      giac_jv_trans.jv_tran_cd%TYPE,
      p_jv_tran_desc            OUT      giac_jv_trans.jv_tran_desc%TYPE,
      p_stale_check             OUT      giac_parameters.param_value_n%TYPE,
      p_stale_days              OUT      giac_parameters.param_value_n%TYPE,
      p_stale_mgr_chk           OUT      giac_parameters.param_value_n%TYPE,
      p_dflt_dcb_bank_cd        OUT      giac_dcb_users.bank_cd%TYPE,
      p_dflt_dcb_bank_name      OUT      giac_banks.bank_name%TYPE,
      p_dflt_dcb_bank_acct_cd   OUT      giac_dcb_users.bank_acct_cd%TYPE,
      p_dflt_dcb_bank_acct_no   OUT      giac_bank_accounts.bank_acct_no%TYPE,
      p_line_cd_tag             OUT      giac_payt_req_docs.line_cd_tag%TYPE,
      p_yy_tag                  OUT      giac_payt_req_docs.yy_tag%TYPE,
      p_mm_tag                  OUT      giac_payt_req_docs.mm_tag%TYPE,
      p_dflt_currency_cd        OUT      giac_parameters.param_value_n%TYPE,
      p_dflt_currency_sname     OUT      giis_currency.short_name%TYPE,
      p_dflt_currency_rt        OUT      giis_currency.currency_rt%TYPE
   );

   TYPE get_giacs609_header_type IS RECORD (
      source_cd       giac_upload_file.source_cd%TYPE,
      file_no         giac_upload_file.source_cd%TYPE,
      file_name       giac_upload_file.file_name%TYPE,
      convert_date    giac_upload_file.convert_date%TYPE,
      upload_date     giac_upload_file.upload_date%TYPE,
      file_status     giac_upload_file.file_status%TYPE,
      no_of_records   giac_upload_file.no_of_records%TYPE,
      tran_class      giac_upload_file.tran_class%TYPE,
      tran_id         giac_upload_file.tran_id%TYPE,
      tran_date       giac_upload_file.tran_date%TYPE,
      remarks         giac_upload_file.remarks%TYPE,
      ri_cd           giac_upload_file.ri_cd%TYPE,
      dsp_source      giac_file_source.source_name%TYPE,
      dsp_ri          giis_reinsurer.ri_name%TYPE,
      dsp_or_reg_jv   VARCHAR2 (100)
   );

   TYPE get_giacs609_header_tab IS TABLE OF get_giacs609_header_type;

   FUNCTION get_giacs609_header (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE
   )
      RETURN get_giacs609_header_tab PIPELINED;

   FUNCTION get_legend
      RETURN VARCHAR2;

   TYPE giacs609_rec_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      line_cd            giac_upload_outfacul_prem.line_cd%TYPE,
      binder_yy          giac_upload_outfacul_prem.binder_yy%TYPE,
      binder_seq_no      giac_upload_outfacul_prem.binder_seq_no%TYPE,
      binder_no          VARCHAR2 (15),
      ldisb_amt          giac_upload_outfacul_prem.ldisb_amt%TYPE,
      lprem_amt          giac_upload_outfacul_prem.lprem_amt%TYPE,
      lprem_vat          giac_upload_outfacul_prem.lprem_vat%TYPE,
      lcomm_amt          giac_upload_outfacul_prem.lcomm_amt%TYPE,
      lcomm_vat          giac_upload_outfacul_prem.lcomm_vat%TYPE,
      lwholding_vat      giac_upload_outfacul_prem.lwholding_vat%TYPE,
      prem_chk_flag      giac_upload_outfacul_prem.prem_chk_flag%TYPE,
      chk_remarks        giac_upload_outfacul_prem.chk_remarks%TYPE,
      tran_date          giac_upload_outfacul_prem.tran_date%TYPE,
      dsp_prem_diff      NUMBER (16, 2),
      dsp_pvat_diff      NUMBER (16, 2),
      dsp_camt_diff      NUMBER (16, 2),
      dsp_cvat_diff      NUMBER (16, 2),
      dsp_wvat_diff      NUMBER (16, 2),
      dsp_tot_prem       NUMBER (16, 2),
      dsp_tot_pvat       NUMBER (16, 2),
      dsp_tot_comm       NUMBER (16, 2),
      dsp_tot_cvat       NUMBER (16, 2),
      dsp_tot_wvat       NUMBER (16, 2),
      dsp_tot_disb       NUMBER (16, 2),
      dsp_tot_pdiff      NUMBER (16, 2),
      dsp_tot_pvdiff     NUMBER (16, 2),
      dsp_tot_cdiff      NUMBER (16, 2),
      dsp_tot_cvdiff     NUMBER (16, 2),
      dsp_tot_wvdiff     NUMBER (16, 2),
      currency_cd        giac_upload_outfacul_prem.currency_cd%TYPE,
      currency_sname     giis_currency.short_name%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      convert_rate       giac_upload_outfacul_prem.convert_rate%TYPE,
      fprem_amt          giac_upload_outfacul_prem.fprem_amt%TYPE,
      fprem_vat          giac_upload_outfacul_prem.fprem_vat%TYPE,
      fcomm_amt          giac_upload_outfacul_prem.fcomm_amt%TYPE,
      fcomm_vat          giac_upload_outfacul_prem.fcomm_vat%TYPE,
      fwholding_vat      giac_upload_outfacul_prem.fwholding_vat%TYPE,
      fdisb_amt          giac_upload_outfacul_prem.fdisb_amt%TYPE,
      prem_amt_due       giac_upload_outfacul_prem.prem_amt_due%TYPE,
      prem_vat_due       giac_upload_outfacul_prem.prem_vat_due%TYPE,
      comm_amt_due       giac_upload_outfacul_prem.comm_amt_due%TYPE,
      comm_vat_due       giac_upload_outfacul_prem.comm_vat_due%TYPE,
      wholding_vat_due   giac_upload_outfacul_prem.wholding_vat_due%TYPE,
      dsp_fprem_diff     NUMBER (16, 2),
      dsp_fpvat_diff     NUMBER (16, 2),
      dsp_fcamt_diff     NUMBER (16, 2),
      dsp_fcvat_diff     NUMBER (16, 2),
      dsp_fwvat_diff     NUMBER (16, 2),
      dsp_fdisb_diff     NUMBER (16, 2)
   );

   TYPE giacs609_rec_tab IS TABLE OF giacs609_rec_type;

   FUNCTION get_giacs609_records (
      p_source_cd       giac_upload_outfacul_prem.source_cd%TYPE,
      p_file_no         giac_upload_outfacul_prem.file_no%TYPE,
      p_binder_no       VARCHAR2,
      p_lprem_amt       giac_upload_outfacul_prem.lprem_amt%TYPE,
      p_lprem_vat       giac_upload_outfacul_prem.lprem_vat%TYPE,
      p_lcomm_amt       giac_upload_outfacul_prem.lcomm_amt%TYPE,
      p_lcomm_vat       giac_upload_outfacul_prem.lcomm_vat%TYPE,
      p_lwholding_vat   giac_upload_outfacul_prem.lwholding_vat%TYPE,
      p_ldisb_amt       giac_upload_outfacul_prem.ldisb_amt%TYPE,
      p_dsp_prem_diff   NUMBER,
      p_dsp_pvat_diff   NUMBER,
      p_dsp_camt_diff   NUMBER,
      p_dsp_cvat_diff   NUMBER,
      p_dsp_wvat_diff   NUMBER,
      p_prem_chk_flag   giac_upload_outfacul_prem.prem_chk_flag%TYPE,
      p_chk_remarks     giac_upload_outfacul_prem.chk_remarks%TYPE,
      p_from            NUMBER,
      p_to              NUMBER,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2
   )
      RETURN giacs609_rec_tab PIPELINED;

   TYPE gucd_rec_type IS RECORD (
      count_                 NUMBER,
      rownum_                NUMBER,
      source_cd              giac_upload_colln_dtl.source_cd%TYPE,
      file_no                giac_upload_colln_dtl.file_no%TYPE,
      item_no                giac_upload_colln_dtl.item_no%TYPE,
      pay_mode               giac_upload_colln_dtl.pay_mode%TYPE,
      amount                 giac_upload_colln_dtl.amount%TYPE,
      gross_amt              giac_upload_colln_dtl.gross_amt%TYPE,
      commission_amt         giac_upload_colln_dtl.commission_amt%TYPE,
      vat_amt                giac_upload_colln_dtl.vat_amt%TYPE,
      check_class            giac_upload_colln_dtl.check_class%TYPE,
      dsp_class_mean         cg_ref_codes.rv_meaning%TYPE,
      check_date             VARCHAR (10),
      check_no               giac_upload_colln_dtl.check_no%TYPE,
      particulars            giac_upload_colln_dtl.particulars%TYPE,
      bank_cd                giac_upload_colln_dtl.bank_cd%TYPE,
      dsp_bank_sname         giac_banks.bank_sname%TYPE,
      dsp_bank_name          giac_banks.bank_name%TYPE,
      currency_cd            giac_upload_colln_dtl.currency_cd%TYPE,
      dsp_short_name         giis_currency.short_name%TYPE,
      dsp_ccy_desc           giis_currency.currency_desc%TYPE,
      currency_rt            giac_upload_colln_dtl.currency_rt%TYPE,
      dcb_bank_cd            giac_upload_colln_dtl.dcb_bank_cd%TYPE,
      dsp_dcb_bank_name      giac_banks.bank_name%TYPE,
      dcb_bank_acct_cd       giac_upload_colln_dtl.dcb_bank_acct_cd%TYPE,
      dsp_dcb_bank_acct_no   giac_bank_accounts.bank_acct_no%TYPE,
      fc_comm_amt            giac_upload_colln_dtl.fc_comm_amt%TYPE,
      fc_vat_amt             giac_upload_colln_dtl.fc_vat_amt%TYPE,
      fc_gross_amt           giac_upload_colln_dtl.fc_gross_amt%TYPE,
      tran_id                giac_upload_colln_dtl.tran_id%TYPE,
      dsp_fc_net             giac_upload_colln_dtl.fc_gross_amt%TYPE,
      dsp_tot_loc            NUMBER (16, 2),
      dsp_tot_fc             NUMBER (16, 2),
      tot_ldisb_amt          NUMBER (16, 2),
      next_item_no           giac_upload_colln_dtl.item_no%TYPE
   );

   TYPE gucd_rec_tab IS TABLE OF gucd_rec_type;

   FUNCTION get_colln_dtls (
      p_source_cd          giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no            giac_upload_colln_dtl.file_no%TYPE,
      p_item_no            giac_upload_colln_dtl.item_no%TYPE,
      p_pay_mode           giac_upload_colln_dtl.pay_mode%TYPE,
      p_dsp_bank_sname     giac_banks.bank_sname%TYPE,
      p_dsp_class_mean     cg_ref_codes.rv_meaning%TYPE,
      p_check_no           giac_upload_colln_dtl.check_no%TYPE,
      p_check_date         VARCHAR2,
      p_amount             giac_upload_colln_dtl.amount%TYPE,
      p_fc_net             giac_upload_colln_dtl.fc_gross_amt%TYPE,
      p_dsp_short_name     giis_currency.short_name%TYPE,
      p_dcb_bank_cd        giac_upload_colln_dtl.dcb_bank_cd%TYPE,
      p_dcb_bank_acct_cd   giac_upload_colln_dtl.dcb_bank_acct_cd%TYPE,
      p_particulars        giac_upload_colln_dtl.particulars%TYPE,
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER
   )
      RETURN gucd_rec_tab PIPELINED;

   PROCEDURE set_colln_dtls (p_rec giac_upload_colln_dtl%ROWTYPE);

   PROCEDURE del_colln_dtls (
      p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE,
      p_item_no     IN   giac_upload_colln_dtl.item_no%TYPE
   );

   FUNCTION get_tot_ldisb (
      p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE
   )
      RETURN NUMBER;

   TYPE bank_lov_type IS RECORD (
      bank_cd      giac_banks.bank_cd%TYPE,
      bank_sname   giac_banks.bank_sname%TYPE,
      bank_name    giac_banks.bank_name%TYPE
   );

   TYPE bank_lov_tab IS TABLE OF bank_lov_type;

   FUNCTION get_bank_lov (p_keyword VARCHAR2)
      RETURN bank_lov_tab PIPELINED;

   FUNCTION get_dcb_bank_lov (p_keyword VARCHAR2)
      RETURN bank_lov_tab PIPELINED;

   TYPE dcb_bank_acct_lov_type IS RECORD (
      bank_acct_cd     giac_bank_accounts.bank_acct_cd%TYPE,
      bank_acct_no     giac_bank_accounts.bank_acct_no%TYPE,
      bank_acct_type   giac_bank_accounts.bank_acct_type%TYPE,
      branch_cd        giac_bank_accounts.branch_cd%TYPE
   );

   TYPE dcb_bank_acct_lov_tab IS TABLE OF dcb_bank_acct_lov_type;

   FUNCTION get_dcb_bank_acct_lov (
      p_dcb_bank_cd   giac_bank_accounts.bank_cd%TYPE,
      p_keyword       VARCHAR2
   )
      RETURN dcb_bank_acct_lov_tab PIPELINED;

   TYPE goop_lov_type IS RECORD (
      count_          NUMBER,
      rownum_         NUMBER,
      tran_id         giac_acctrans.tran_id%TYPE,
      branch_cd       giac_order_of_payts.gibr_branch_cd%TYPE,
      dcb_no          giac_order_of_payts.dcb_no%TYPE,
      particulars     giac_order_of_payts.particulars%TYPE,
      or_date         VARCHAR2 (10),
      or_no           VARCHAR2 (20),
      has_colln_dtl   VARCHAR2 (1)
   );

   TYPE goop_lov_tab IS TABLE OF goop_lov_type;

   FUNCTION get_or_lov (
      p_or_date         VARCHAR2,
      p_user_id         VARCHAR2,
      p_keyword         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN goop_lov_tab PIPELINED;

   FUNCTION get_or_colln_dtls (
      p_source_cd   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     giac_upload_colln_dtl.file_no%TYPE,
      p_tran_id     giac_upload_colln_dtl.tran_id%TYPE
   )
      RETURN gucd_rec_tab PIPELINED;

   PROCEDURE validate_colln_amt (
      p_source_cd   IN   giac_upload_colln_dtl.source_cd%TYPE,
      p_file_no     IN   giac_upload_colln_dtl.file_no%TYPE
   );

   TYPE gudpd_rec_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      source_cd          giac_upload_dv_payt_dtl.source_cd%TYPE,
      file_no            giac_upload_dv_payt_dtl.file_no%TYPE,
      document_cd        giac_upload_dv_payt_dtl.document_cd%TYPE,
      branch_cd          giac_upload_dv_payt_dtl.branch_cd%TYPE,
      line_cd            giac_upload_dv_payt_dtl.line_cd%TYPE,
      doc_year           giac_upload_dv_payt_dtl.doc_year%TYPE,
      doc_mm             giac_upload_dv_payt_dtl.doc_mm%TYPE,
      doc_seq_no         giac_upload_dv_payt_dtl.doc_seq_no%TYPE,
      dept_id            giac_upload_dv_payt_dtl.gouc_ouc_id%TYPE,
      dsp_dept_cd        giac_oucs.ouc_cd%TYPE,
      dsp_dept_name      giac_oucs.ouc_name%TYPE,
      request_date       VARCHAR2 (10),
      payee_class_cd     giac_upload_dv_payt_dtl.payee_class_cd%TYPE,
      payee_cd           giac_upload_dv_payt_dtl.payee_cd%TYPE,
      payee              giac_upload_dv_payt_dtl.payee%TYPE,
      particulars        giac_upload_dv_payt_dtl.particulars%TYPE,
      dsp_fshort_name    giis_currency.short_name%TYPE,
      dv_fcurrency_amt   giac_upload_dv_payt_dtl.dv_fcurrency_amt%TYPE,
      currency_rt        giac_upload_dv_payt_dtl.currency_rt%TYPE,
      payt_amt           giac_upload_dv_payt_dtl.payt_amt%TYPE,
      currency_cd        giac_upload_dv_payt_dtl.currency_cd%TYPE,
      tran_id            giac_upload_dv_payt_dtl.tran_id%TYPE,
      line_cd_tag        giac_payt_req_docs.line_cd_tag%TYPE,
      yy_tag             giac_payt_req_docs.yy_tag%TYPE,
      mm_tag             giac_payt_req_docs.mm_tag%TYPE
   );

   TYPE gudpd_rec_tab IS TABLE OF gudpd_rec_type;

   FUNCTION get_dv_dtls (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE,
      p_user_id     VARCHAR2
   )
      RETURN gudpd_rec_tab PIPELINED;

   PROCEDURE set_dv_dtls (p_rec giac_upload_dv_payt_dtl%ROWTYPE);

   PROCEDURE del_dv_dtls (p_source_cd VARCHAR2, p_file_no VARCHAR2);

   FUNCTION get_payt_rqst_lov (
      p_document_cd     VARCHAR2,
      p_user_id         VARCHAR2,
      p_keyword         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gudpd_rec_tab PIPELINED;

   TYPE document_lov_type IS RECORD (
      document_cd     giac_payt_req_docs.document_cd%TYPE,
      document_name   giac_payt_req_docs.document_name%TYPE,
      line_cd_tag     giac_payt_req_docs.line_cd_tag%TYPE,
      yy_tag          giac_payt_req_docs.yy_tag%TYPE,
      mm_tag          giac_payt_req_docs.mm_tag%TYPE
   );

   TYPE document_lov_tab IS TABLE OF document_lov_type;

   FUNCTION get_document_lov (
      p_branch_cd   giac_payt_req_docs.gibr_branch_cd%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN document_lov_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   TYPE dept_lov_type IS RECORD (
      dept_id     giac_oucs.ouc_id%TYPE,
      dept_cd     giac_oucs.ouc_cd%TYPE,
      dept_name   giac_oucs.ouc_name%TYPE
   );

   TYPE dept_lov_tab IS TABLE OF dept_lov_type;

   FUNCTION get_dept_lov (p_branch_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN dept_lov_tab PIPELINED;

   TYPE payee_class_lov_type IS RECORD (
      payee_class_cd   giis_payee_class.payee_class_cd%TYPE,
      class_desc       giis_payee_class.class_desc%TYPE
   );

   TYPE payee_class_lov_tab IS TABLE OF payee_class_lov_type;

   FUNCTION get_payee_class_lov (p_keyword VARCHAR2)
      RETURN payee_class_lov_tab PIPELINED;

   TYPE payee_lov_type IS RECORD (
      payee_no            giis_payees.payee_no%TYPE,
      payee_first_name    giis_payees.payee_first_name%TYPE,
      payee_middle_name   giis_payees.payee_middle_name%TYPE,
      payee_last_name     giis_payees.payee_last_name%TYPE,
      dsp_payee           VARCHAR2 (600)
   );

   TYPE payee_lov_tab IS TABLE OF payee_lov_type;

   FUNCTION get_payee_lov (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_keyword          VARCHAR2
   )
      RETURN payee_lov_tab PIPELINED;

   TYPE gujpd_rec_type IS RECORD (
      count_             NUMBER,
      rownum_            NUMBER,
      source_cd          giac_upload_jv_payt_dtl.source_cd%TYPE,
      file_no            giac_upload_jv_payt_dtl.file_no%TYPE,
      branch_cd          giac_upload_jv_payt_dtl.branch_cd%TYPE,
      dsp_branch_name    giac_branches.branch_name%TYPE,
      tran_date          VARCHAR2 (10),
      jv_tran_tag        giac_upload_jv_payt_dtl.jv_tran_tag%TYPE,
      jv_tran_type       giac_upload_jv_payt_dtl.jv_tran_type%TYPE,
      dsp_jv_tran_desc   giac_jv_trans.jv_tran_desc%TYPE,
      jv_tran_mm         giac_upload_jv_payt_dtl.jv_tran_mm%TYPE,
      jv_tran_yy         giac_upload_jv_payt_dtl.jv_tran_yy%TYPE,
      tran_year          giac_upload_jv_payt_dtl.tran_year%TYPE,
      tran_month         giac_upload_jv_payt_dtl.tran_month%TYPE,
      tran_seq_no        giac_upload_jv_payt_dtl.tran_seq_no%TYPE,
      jv_pref_suff       giac_upload_jv_payt_dtl.jv_pref_suff%TYPE,
      jv_no              giac_upload_jv_payt_dtl.jv_no%TYPE,
      particulars        giac_upload_jv_payt_dtl.particulars%TYPE,
      tran_id            giac_upload_jv_payt_dtl.tran_id%TYPE
   );

   TYPE gujpd_rec_tab IS TABLE OF gujpd_rec_type;

   FUNCTION get_jv_dtls (
      p_source_cd   giac_upload_jv_payt_dtl.source_cd%TYPE,
      p_file_no     giac_upload_jv_payt_dtl.file_no%TYPE,
      p_user_id     VARCHAR2
   )
      RETURN gujpd_rec_tab PIPELINED;

   PROCEDURE set_jv_dtls (p_rec giac_upload_jv_payt_dtl%ROWTYPE);

   PROCEDURE del_jv_dtls (
      p_source_cd   giac_upload_jv_payt_dtl.source_cd%TYPE,
      p_file_no     giac_upload_jv_payt_dtl.file_no%TYPE
   );

   TYPE jv_tran_type_type IS RECORD (
      jv_tran_type   giac_jv_trans.jv_tran_cd%TYPE,
      jv_tran_desc   giac_jv_trans.jv_tran_desc%TYPE
   );

   TYPE jv_tran_type_tab IS TABLE OF jv_tran_type_type;

   FUNCTION get_jv_tran_type_lov (
      p_jv_tran_tag   giac_jv_trans.jv_tran_tag%TYPE,
      p_keyword       VARCHAR2,
      p_row_num       NUMBER
   )
      RETURN jv_tran_type_tab PIPELINED;

   FUNCTION get_jv_lov (
      p_tran_date       VARCHAR2,
      p_user_id         VARCHAR2,
      p_keyword         VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gujpd_rec_tab PIPELINED;

   TYPE currency_lov_type IS RECORD (
      short_name         giis_currency.short_name%TYPE,
      currency_desc      giis_currency.currency_desc%TYPE,
      main_currency_cd   giis_currency.main_currency_cd%TYPE,
      currency_rt        giis_currency.currency_rt%TYPE
   );

   TYPE currency_lov_tab IS TABLE OF currency_lov_type;

   FUNCTION get_currency_lov (p_keyword VARCHAR2)
      RETURN currency_lov_tab PIPELINED;

   TYPE branch_lov_type IS RECORD (
      branch_cd        giac_branches.branch_cd%TYPE,
      branch_name      giac_branches.branch_name%TYPE,
      line_cd_tag      giac_payt_req_docs.line_cd_tag%TYPE,
      yy_tag           giac_payt_req_docs.yy_tag%TYPE,
      mm_tag           giac_payt_req_docs.mm_tag%TYPE,
      doc_cd_exists    VARCHAR2 (1),
      dept_id_exists   VARCHAR2 (1)
   );

   TYPE branch_lov_tab IS TABLE OF branch_lov_type;

   FUNCTION get_branch_lov (
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2,
      p_keyword     VARCHAR2,
      p_doc_cd      VARCHAR2,
      p_dept_id     VARCHAR2
   )
      RETURN branch_lov_tab PIPELINED;

   PROCEDURE check_data (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE,
      p_override    VARCHAR2
   );

   PROCEDURE get_disbursement_amt (
      p_binder_id           giri_binder.fnl_binder_id%TYPE,
      p_ri_cd               giac_upload_file.ri_cd%TYPE,
      p_tran_type           giac_outfacul_prem_payts.transaction_type%TYPE,
      p_ri_prem             giri_binder.ri_prem_amt%TYPE,
      p_out_prem            giac_outfacul_prem_payts.prem_amt%TYPE,
      p_tot_rec       OUT   gipi_invoice.prem_amt%TYPE,
      p_direct_prem   OUT   giac_direct_prem_collns.premium_amt%TYPE,
      p_actual_pay    OUT   giac_outfacul_prem_payts.disbursement_amt%TYPE
   );

   PROCEDURE validate_print (
      p_source_cd     IN       giac_upload_file.source_cd%TYPE,
      p_file_no       IN       giac_upload_file.file_no%TYPE,
      p_user_id       IN       giac_upload_file.user_id%TYPE,
      p_tran_class    IN       giac_upload_file.tran_class%TYPE,
      p_tran_id       IN       giac_acctrans.tran_id%TYPE,
      p_fund_cd       OUT      giac_parameters.param_value_v%TYPE,
      p_fund_desc     OUT      giis_funds.fund_cd%TYPE,
      p_branch_cd     OUT      giac_upload_dv_payt_dtl.branch_cd%TYPE,
      p_branch_name   OUT      giac_branches.branch_name%TYPE,
      p_document_cd   OUT      giac_upload_dv_payt_dtl.document_cd%TYPE,
      p_gprq_ref_id   OUT      giac_payt_requests_dtl.gprq_ref_id%TYPE
   );

   PROCEDURE upload_begin (
      p_source_cd    IN       giac_upload_file.source_cd%TYPE,
      p_file_no      IN       giac_upload_file.file_no%TYPE,
      p_tran_class   IN       giac_upload_file.tran_class%TYPE,
      p_user_id      IN       VARCHAR2,
      p_tran_date    IN OUT   VARCHAR2,
      p_branch_cd    OUT      VARCHAR2,
      p_message      OUT      VARCHAR2
   );

   PROCEDURE validate_tran_date (
      p_source_cd    IN       giac_upload_file.source_cd%TYPE,
      p_file_no      IN       giac_upload_file.file_no%TYPE,
      p_tran_class   IN       giac_upload_file.tran_class%TYPE,
      p_branch_cd    IN       VARCHAR2,
      p_tran_date    IN       VARCHAR2,
      p_user_id      IN       VARCHAR2,
      p_message      OUT      VARCHAR2
   );

   PROCEDURE check_tran_mm (p_date giac_acctrans.tran_date%TYPE);

   PROCEDURE check_upload_all (
      p_source_cd    IN       giac_upload_file.source_cd%TYPE,
      p_file_no      IN       giac_upload_file.file_no%TYPE,
      p_tran_class   IN       giac_upload_file.tran_class%TYPE,
      p_tran_date    IN       VARCHAR2,
      p_user_id      IN       VARCHAR2,
      p_valid_sw     OUT      VARCHAR2
   );

   PROCEDURE upload_payments (
      p_source_cd    giac_upload_file.source_cd%TYPE,
      p_file_no      giac_upload_file.file_no%TYPE,
      p_tran_class   giac_upload_file.tran_class%TYPE,
      p_tran_date    VARCHAR2,
      p_user_id      VARCHAR2
   );

   PROCEDURE generate_or (p_or_date VARCHAR2);

   PROCEDURE generate_dv;

   PROCEDURE generate_jv;

   PROCEDURE get_user_grp_iss_cd (p_user_id VARCHAR2);

   FUNCTION get_reinsurer (
      p_line_cd         giri_binder.line_cd%TYPE,
      p_binder_yy       giri_binder.binder_yy%TYPE,
      p_binder_seq_no   giri_binder.binder_seq_no%TYPE
   )
      RETURN NUMBER;

   PROCEDURE process_payments;

   PROCEDURE insert_into_outfacul_prem_payt (
      p_line_cd               giac_upload_outfacul_prem.line_cd%TYPE,
      p_binder_yy             giac_upload_outfacul_prem.binder_yy%TYPE,
      p_binder_seq_no         giac_upload_outfacul_prem.binder_seq_no%TYPE,
      p_prem_chk_flag         giac_upload_outfacul_prem.prem_chk_flag%TYPE,
      p_ldisb_amt             giac_upload_outfacul_prem.ldisb_amt%TYPE,
      p_fdisb_amt             giac_upload_outfacul_prem.fdisb_amt%TYPE,
      p_prem_colln      OUT   giac_upload_outfacul_prem.ldisb_amt%TYPE
   );

   PROCEDURE generate_op_text;

   PROCEDURE generate_misc_op_text (
      p_item_text   giac_op_text.item_text%TYPE,
      p_item_amt    giac_op_text.item_amt%TYPE
   );

   PROCEDURE cancel_file (
      p_source_cd   giac_upload_file.source_cd%TYPE,
      p_file_no     giac_upload_file.file_no%TYPE,
      p_user_id     giac_upload_file.user_id%TYPE
   );
END;
/