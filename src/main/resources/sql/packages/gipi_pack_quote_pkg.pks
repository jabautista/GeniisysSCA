CREATE OR REPLACE PACKAGE CPI.gipi_pack_quote_pkg
AS
   TYPE gipi_pack_quote_type IS RECORD (
      quote_no           VARCHAR2 (30),
      assd_name          gipi_pack_quote.assd_name%TYPE,
      incept_date        gipi_pack_quote.incept_date%TYPE,
      expiry_date        gipi_pack_quote.expiry_date%TYPE,
      incept_tag         gipi_pack_quote.incept_tag%TYPE,
      expiry_tag         gipi_pack_quote.expiry_tag%TYPE,
      no_of_days         NUMBER (5),
      accept_dt          gipi_pack_quote.accept_dt%TYPE,
      userid             gipi_pack_quote.underwriter%TYPE,
      line_cd            gipi_pack_quote.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         gipi_pack_quote.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      iss_cd             gipi_pack_quote.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      quotation_yy       gipi_pack_quote.quotation_yy%TYPE,
      quotation_no       gipi_pack_quote.quotation_no%TYPE,
      proposal_no        gipi_pack_quote.proposal_no%TYPE,
      cred_branch        gipi_pack_quote.cred_branch%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      valid_date         gipi_pack_quote.valid_date%TYPE,
      acct_of            giis_assured.assd_name%TYPE,
      address1           gipi_pack_quote.address1%TYPE,
      address2           gipi_pack_quote.address2%TYPE,
      address3           gipi_pack_quote.address3%TYPE,
      prorate_flag       gipi_pack_quote.prorate_flag%TYPE,
      header             gipi_pack_quote.header%TYPE,
      footer             gipi_pack_quote.footer%TYPE,
      remarks            gipi_pack_quote.remarks%TYPE,
      reason_cd          gipi_pack_quote.reason_cd%TYPE,
      reason_desc        giis_lost_bid.reason_desc%TYPE,
      comp_sw            gipi_pack_quote.comp_sw%TYPE,
      short_rt_percent   gipi_pack_quote.short_rt_percent%TYPE,
      acct_of_cd         gipi_pack_quote.acct_of_cd%TYPE,
      assd_no            gipi_pack_quote.assd_no%TYPE
   );

   TYPE gipi_pack_quote_tab IS TABLE OF gipi_pack_quote_type;

   TYPE gipi_pack_quote_list_type IS RECORD (
      pack_quote_id     gipi_pack_quote.pack_quote_id%TYPE,
      iss_cd            gipi_pack_quote.iss_cd%TYPE,
      line_cd           gipi_pack_quote.line_cd%TYPE,
      subline_cd        gipi_pack_quote.subline_cd%TYPE,
      quotation_yy      VARCHAR2 (20),
      quotation_no      VARCHAR2 (20),
      proposal_no       VARCHAR2 (20),
      assd_no           VARCHAR2 (20),
      assd_name         gipi_pack_quote.assd_name%TYPE,
      assured           giis_assured.assd_name%TYPE,
      assd_active_tag   giis_assured.active_tag%TYPE,
      valid_date        gipi_pack_quote.valid_date%TYPE,
      quote_no       VARCHAR2 (30)
   );

   TYPE gipi_pack_quote_list_tab IS TABLE OF gipi_pack_quote_list_type;

   TYPE attachment_type IS RECORD (
       file_name        gipi_quote_pictures.file_name%TYPE
   );
   
   TYPE attachment_tab IS TABLE OF attachment_type;

   FUNCTION get_pack_quote_list (
      p_line_cd   gipi_pack_quote.line_cd%TYPE,
      p_iss_cd    gipi_pack_quote.iss_cd%TYPE,
      p_module    giis_user_grp_modules.module_id%TYPE,
      p_keyword   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN gipi_pack_quote_list_tab PIPELINED;

   TYPE pack_quotation_listing_type IS RECORD (
      pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE,
      quote_no        VARCHAR2 (30),
      assd_name       gipi_pack_quote.assd_name%TYPE,
      assd_no         gipi_pack_quote.assd_no%TYPE,
      incept_date     gipi_pack_quote.incept_date%TYPE,
      expiry_date     gipi_pack_quote.expiry_date%TYPE,
      valid_date      gipi_pack_quote.valid_date%TYPE,
      user_id         gipi_pack_quote.user_id%TYPE,
      accept_dt       gipi_pack_quote.accept_dt%TYPE,
      iss_cd          gipi_pack_quote.iss_cd%TYPE,
      quotation_no    gipi_pack_quote.quotation_no%TYPE,
      quotation_yy    gipi_pack_quote.quotation_yy%TYPE,
      proposal_no     gipi_pack_quote.proposal_no%TYPE,
      subline_cd      gipi_pack_quote.subline_cd%TYPE
   );

   TYPE pack_quotation_listing_tab IS TABLE OF pack_quotation_listing_type;

   FUNCTION get_pack_quotation_listing (
      p_user     giis_users.user_id%TYPE,
      p_module   giis_modules.module_id%TYPE,
      p_line     giis_line.line_cd%TYPE
   )
      RETURN pack_quotation_listing_tab PIPELINED;

   TYPE gipi_pack_details_type IS RECORD (
      pack_quote_id      gipi_pack_quote.pack_quote_id%TYPE,
      quote_no           VARCHAR2 (30),
      assd_name          gipi_pack_quote.assd_name%TYPE,
      incept_date        gipi_pack_quote.incept_date%TYPE,
      expiry_date        gipi_pack_quote.expiry_date%TYPE,
      incept_tag         gipi_pack_quote.incept_tag%TYPE,
      expiry_tag         gipi_pack_quote.expiry_tag%TYPE,
      no_of_days         NUMBER (5),
      accept_dt          gipi_pack_quote.accept_dt%TYPE,
      underwriter        gipi_pack_quote.underwriter%TYPE,
      user_id            gipi_pack_quote.underwriter%TYPE,
      line_cd            gipi_pack_quote.line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         gipi_pack_quote.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      iss_cd             gipi_pack_quote.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      quotation_yy       gipi_pack_quote.quotation_yy%TYPE,
      quotation_no       gipi_pack_quote.quotation_no%TYPE,
      proposal_no        gipi_pack_quote.proposal_no%TYPE,
      cred_branch        gipi_pack_quote.cred_branch%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      valid_date         gipi_pack_quote.valid_date%TYPE,
      acct_of            giis_assured.assd_name%TYPE,
      address1           gipi_pack_quote.address1%TYPE,
      address2           gipi_pack_quote.address2%TYPE,
      address3           gipi_pack_quote.address3%TYPE,
      prorate_flag       gipi_pack_quote.prorate_flag%TYPE,
      header             gipi_pack_quote.header%TYPE,
      footer             gipi_pack_quote.footer%TYPE,
      remarks            gipi_pack_quote.remarks%TYPE,
      reason_cd          gipi_pack_quote.reason_cd%TYPE,
      reason_desc        giis_lost_bid.reason_desc%TYPE,
      comp_sw            gipi_pack_quote.comp_sw%TYPE,
      short_rt_percent   gipi_pack_quote.short_rt_percent%TYPE,
      acct_of_cd         gipi_pack_quote.acct_of_cd%TYPE,
      assd_no            gipi_pack_quote.assd_no%TYPE,
      prem_amt           gipi_pack_quote.prem_amt%TYPE,
      ann_prem_amt       gipi_pack_quote.ann_prem_amt%TYPE,
      tsi_amt            gipi_pack_quote.tsi_amt%TYPE,
      bank_ref_no        gipi_pack_quote.bank_ref_no%TYPE,
      account_sw         gipi_pack_quote.account_sw%TYPE
   );

   TYPE gipi_pack_details_tab IS TABLE OF gipi_pack_details_type;

   FUNCTION get_gipi_pack_quote (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   )
      RETURN gipi_pack_details_tab PIPELINED;

   PROCEDURE update_gipi_pack_quote (p_quote_id gipi_quote.quote_id%TYPE);

/**
    CREATED BY IRWIN TABISORA. APRIL 11, 2011
*/
   PROCEDURE process_packquote_to_par (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE,
      p_par_id          gipi_parlist.par_id%TYPE,
      p_line_cd         gipi_pack_quote.line_cd%TYPE,
      p_iss_cd          gipi_pack_quote.iss_cd%TYPE,
      p_assd_no         giis_assured.assd_no%TYPE,
      p_user            VARCHAR2
   );

   PROCEDURE save_gipi_pack_quotation (
      p_gipi_pack_quote   IN   gipi_pack_quote%ROWTYPE
   );

   PROCEDURE del_gipi_pack_quotation (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   );

   PROCEDURE deny_gipi_pack_quotation (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE,
      p_reason_cd       gipi_pack_quote.reason_cd%TYPE
   );

   PROCEDURE copy_gipi_pack_quotation (
      p_pack_quote_id         gipi_pack_quote.pack_quote_id%TYPE,
      p_new_quote_no    OUT   VARCHAR2,
      p_user_id               gipi_pack_quote.user_id%TYPE
   );

   PROCEDURE duplicate_gipi_pack_quote (
      p_pack_quote_id         gipi_pack_quote.pack_quote_id%TYPE,
      p_new_quote_no    OUT   VARCHAR2,
      p_user_id               gipi_pack_quote.user_id%TYPE
   );

   PROCEDURE generate_pack_bank_ref_no (
    p_pack_quote_id gipi_pack_quote.pack_quote_id%TYPE,  p_acct_iss_cd        IN   giis_ref_seq.acct_iss_cd%TYPE,
        p_branch_cd          IN   giis_ref_seq.branch_cd%TYPE,
        p_bank_ref_no       OUT   gipi_wpolbas.bank_ref_no%TYPE,
        p_msg_alert         OUT   VARCHAR2
   );
   
   TYPE existing_pack_quotation_type IS RECORD (
      pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE,
      line_cd         gipi_pack_quote.line_cd%TYPE,
      iss_cd          gipi_pack_quote.iss_cd%TYPE,
      tsi_amt         gipi_pack_quote.tsi_amt%TYPE,
      assd_name       gipi_pack_quote.assd_name%TYPE,
      address         VARCHAR2 (200),
      status          gipi_pack_quote.status%TYPE,
      quote_no varchar2(500),
      
      par_no varchar2(500),
      pol_no varchar2(500),
      incept_date varchar2(10),
      expiry_date varchar2(10)
   );

   TYPE existing_pack_quotation_tab IS TABLE OF existing_pack_quotation_type;

   FUNCTION get_existing_pack_quotations (
      p_line_cd   gipi_pack_quote.line_cd%TYPE,
      p_assd_no   gipi_pack_quote.assd_no%TYPE
   )
      RETURN existing_pack_quotation_tab PIPELINED;
      
   FUNCTION get_ora2010_sw
      RETURN VARCHAR2;

   FUNCTION get_pack_quote_pic (
      p_pack_quote_id   gipi_pack_quote.pack_quote_id%TYPE
   )
      RETURN attachment_tab PIPELINED;
  
END gipi_pack_quote_pkg;
/


