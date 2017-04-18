CREATE OR REPLACE PACKAGE CPI.gipi_quote_pkg
AS
   TYPE gipi_quote_type IS RECORD (
      quote_id           gipi_quote.quote_id%TYPE,
      quote_no           VARCHAR2 (50),
      assd_name          gipi_quote.assd_name%TYPE,
      incept_date        gipi_quote.incept_date%TYPE,
      expiry_date        gipi_quote.expiry_date%TYPE,
      incept_tag         gipi_quote.incept_tag%TYPE,
      expiry_tag         gipi_quote.expiry_tag%TYPE,
      no_of_days         NUMBER (5),
      accept_dt          gipi_quote.accept_dt%TYPE,
      underwriter        gipi_quote.underwriter%TYPE,
      userid             gipi_quote.user_id%TYPE,
      line_cd            gipi_quote.line_cd%TYPE,
      menu_line_cd       giis_line.menu_line_cd%TYPE,
      line_name          giis_line.line_name%TYPE,
      subline_cd         gipi_quote.subline_cd%TYPE,
      subline_name       giis_subline.subline_name%TYPE,
      iss_cd             gipi_quote.iss_cd%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      quotation_yy       gipi_quote.quotation_yy%TYPE,
      quotation_no       gipi_quote.quotation_no%TYPE,
      proposal_no        gipi_quote.proposal_no%TYPE,
      cred_branch        gipi_quote.cred_branch%TYPE,
      cred_branch_name   giis_issource.iss_name%TYPE,
      valid_date         gipi_quote.valid_date%TYPE,
      acct_of            giis_assured.assd_name%TYPE,
      address1           gipi_quote.address1%TYPE,
      address2           gipi_quote.address2%TYPE,
      address3           gipi_quote.address3%TYPE,
      prorate_flag       gipi_quote.prorate_flag%TYPE,
       header             varchar2(32767),--gipi_quote.header%TYPE,
      footer             varchar2(32767),
      remarks            varchar2(32767),
      reason_cd          gipi_quote.reason_cd%TYPE,
      reason_desc        giis_lost_bid.reason_desc%TYPE,
      comp_sw            gipi_quote.comp_sw%TYPE,
      short_rt_percent   gipi_quote.short_rt_percent%TYPE,
      acct_of_cd         gipi_quote.acct_of_cd%TYPE,
      assd_no            gipi_quote.assd_no%TYPE,
      prem_amt           gipi_quote.prem_amt%TYPE,
      ann_prem_amt       gipi_quote.ann_prem_amt%TYPE,
      tsi_amt            gipi_quote.tsi_amt%TYPE,
      bank_ref_no        gipi_quote.bank_ref_no%TYPE,
      with_tariff_sw     gipi_quote.with_tariff_sw%TYPE, -- Added by MarkS 5.23.2016 SR-5105
      account_sw         gipi_quote.account_sw%TYPE -- Added by Jerome 08.18.2016 SR 5586
   );

   TYPE gipi_quote_tab IS TABLE OF gipi_quote_type;

   FUNCTION get_gipi_quote (v_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote_tab PIPELINED;

   TYPE quote_listing_type IS RECORD (
      quote_id       gipi_quote.quote_id%TYPE,
      quote_no       VARCHAR2 (50),
      assd_name      gipi_quote.assd_name%TYPE,
      incept_date    gipi_quote.incept_date%TYPE,
      expiry_date    gipi_quote.expiry_date%TYPE,
      valid_date     gipi_quote.valid_date%TYPE,
      user_id        gipi_quote.user_id%TYPE,
      assd_no        gipi_quote.assd_no%TYPE,
      accept_dt      gipi_quote.accept_dt%TYPE,
      reason_cd      gipi_quote.reason_cd%TYPE, 
      iss_cd         gipi_quote.iss_cd%TYPE,
      quotation_no   gipi_quote.quotation_no%TYPE,
      quotation_yy   gipi_quote.quotation_yy%TYPE,
      proposal_no    gipi_quote.proposal_no%TYPE,
      subline_cd     gipi_quote.subline_cd%TYPE,
      remarks        gipi_quote.remarks%TYPE,
      pack_pol_flag  gipi_quote.pack_pol_flag%TYPE, 
      pack_quote_id  gipi_quote.pack_quote_id%TYPE,
      pack_quote_no  VARCHAR(50),
      pack_quote_line_cd    gipi_quote.LINE_CD%type,     -- shan 08.27.2014
      count_            NUMBER,                          --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      rownum_           NUMBER                           --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
   );
 
   TYPE quote_listing_tab IS TABLE OF quote_listing_type; 

   FUNCTION get_quote_listing ( 
      p_user                 giis_users.user_id%TYPE, 
      p_module               giis_modules.module_id%TYPE,
      p_line                 giis_line.line_cd%TYPE,  
      p_filter_assd_name     gipi_quote.assd_name%type, --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_incept_dt     VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_expiry_dt     VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_valid_dt      VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_user_id       VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_quote_no      VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_iss_cd        VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_quotation_yy  VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_quotation_no  VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_proposal_no   VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_remarks       VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_filter_subline_cd    VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_order_by             VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_asc_desc_flag        VARCHAR2,                  --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_first_row            NUMBER,                    --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
      p_last_row             NUMBER                     --added by pjsantos @pcic 09/20/2016, for optimization GENQA 5670
   )
      RETURN quote_listing_tab PIPELINED;
      
   FUNCTION get_reassign_quote_listing (
      p_user_id      giis_users.user_id%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      /*added by pjsantos 10/18/2016, for optimization GENQA 5786*/
      p_filter_assd_name        VARCHAR2,
      p_filter_incept_date      VARCHAR2,
      p_filter_expiry_date      VARCHAR2,
      p_filter_valid_date       VARCHAR2,   
      p_filter_user_id          VARCHAR2,
      p_filter_quote_no         VARCHAR2,
      p_filter_iss_cd           VARCHAR2,
      p_filter_quotation_yy     VARCHAR2, 
      p_filter_quotation_no     VARCHAR2,
      p_filter_proposal_no      VARCHAR2,
      p_filter_remarks          VARCHAR2,
      p_filter_subline_cd       VARCHAR2,
      p_order_by                VARCHAR2,      
      p_asc_desc_flag           VARCHAR2,     
      p_first_row               NUMBER,        
      p_last_row                NUMBER 
      /*pjsantos end*/
   )
      RETURN quote_listing_tab PIPELINED;

   FUNCTION get_filtered_quote_listing (
      p_line           gipi_quote.line_cd%TYPE,
      p_subline        gipi_quote.subline_cd%TYPE,
      p_iss_cd         gipi_quote.iss_cd%TYPE,
      p_quote_yy       gipi_quote.quotation_yy%TYPE,
      p_quote_seq_no   gipi_quote.quotation_no%TYPE,
      p_proposal_no    gipi_quote.proposal_no%TYPE,
      p_assd_name      gipi_quote.assd_name%TYPE,
      p_module         giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN quote_listing_tab PIPELINED;

   TYPE checked_quote_list_type IS RECORD (
      quote_id       gipi_quote.quote_id%TYPE,
      line_cd        gipi_quote.line_cd%TYPE,
      iss_cd         gipi_quote.iss_cd%TYPE,
      subline_cd     gipi_quote.subline_cd%TYPE,
      quotation_yy   gipi_quote.quotation_yy%TYPE,
      quote_no       VARCHAR2 (15),
      proposal_no    VARCHAR2 (10),
      assd_no        VARCHAR2 (20),
      assd_name      gipi_quote.assd_name%TYPE
   );

   TYPE checked_quote_list_tab IS TABLE OF checked_quote_list_type;

   FUNCTION get_checked_quote_list (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN checked_quote_list_tab PIPELINED;

   FUNCTION get_checked_quote_line_list (
      p_line_cd     giis_line.line_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN checked_quote_list_tab PIPELINED;

   TYPE quote_list_status_type IS RECORD (
   	  --Added by MarkS SR5780 10.24.2016 Optimization
      count_                NUMBER,
      rownum_               NUMBER,
      --Added by MarkS SR5780 10.24.2016 Optimization
      quote_id      gipi_quote.quote_id%TYPE,
      quote_no      VARCHAR2 (50),
      assd_name     gipi_quote.assd_name%TYPE,
      incept_date   gipi_quote.incept_date%TYPE,
      expiry_date   gipi_quote.expiry_date%TYPE,
      valid_date    gipi_quote.valid_date%TYPE,
      user_id       gipi_quote.user_id%TYPE,
      assd_no       gipi_quote.assd_no%TYPE,
      accept_dt     gipi_quote.accept_dt%TYPE,
      status        cg_ref_codes.rv_meaning%TYPE,
      par_assd      gipi_quote.assd_name%TYPE,
      reason_desc   giis_lost_bid.reason_desc%TYPE,
      par_no        VARCHAR (50),
      pol_no        VARCHAR (50),
      pack_pol_flag gipi_quote.pack_pol_flag%TYPE,
      pack_quote_no VARCHAR2(50),
      pack_quote_id gipi_quote.pack_quote_id%TYPE,
      par_id gipi_parlist.par_id%type,
      reason_cd gipi_quote.reason_cd%type
   );

   TYPE quote_list_status_tab IS TABLE OF quote_list_status_type;

   FUNCTION get_quote_list_status (
      p_date_from   gipi_quote.accept_dt%TYPE,
      p_date_to     gipi_quote.accept_dt%TYPE,
      p_status      gipi_quote.status%TYPE,
      p_user        giis_users.user_id%TYPE,
      p_module      giis_modules.module_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN quote_list_status_tab PIPELINED;

   PROCEDURE reassign_quotation (
      p_user_id    gipi_quote.user_id%TYPE,
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_remarks    gipi_quote.remarks%TYPE
   );

   FUNCTION get_copied_quote_id (p_quote_id gipi_quote.quote_id%TYPE)
      RETURN gipi_quote.copied_quote_id%TYPE;

   PROCEDURE set_gipi_quote (
      v_quote_id                IN OUT   gipi_quote.quote_id%TYPE,
      v_line_name               IN       giis_line.line_name%TYPE,
      v_subline_name            IN       giis_subline.subline_name%TYPE,
      v_iss_name                IN       giis_issource.iss_name%TYPE,
      v_quotation_yy            IN       gipi_quote.quotation_yy%TYPE,
      v_quotation_no            IN       gipi_quote.quotation_no%TYPE,
      v_proposal_no             IN       gipi_quote.proposal_no%TYPE,
      v_assd_no                 IN       gipi_quote.assd_no%TYPE,
      v_assd_name               IN       gipi_quote.assd_name%TYPE,
      v_tsi_amt                 IN       gipi_quote.tsi_amt%TYPE,
      v_prem_amt                IN       gipi_quote.prem_amt%TYPE,
      v_print_dt                IN       gipi_quote.print_dt%TYPE,
      v_accept_dt               IN       gipi_quote.accept_dt%TYPE,
      v_post_dt                 IN       gipi_quote.post_dt%TYPE,
      v_denied_dt               IN       gipi_quote.denied_dt%TYPE,
      v_status                  IN       gipi_quote.status%TYPE,
      v_print_tag               IN       gipi_quote.print_tag%TYPE,
      v_header                  IN       gipi_quote.header%TYPE,
      v_footer                  IN       gipi_quote.footer%TYPE,
      v_remarks                 IN       gipi_quote.remarks%TYPE,
      v_user_id                 IN       gipi_quote.user_id%TYPE,
      v_last_update             IN       gipi_quote.last_update%TYPE,
      v_cpi_rec_no              IN       gipi_quote.cpi_rec_no%TYPE,
      v_cpi_branch_cd           IN       gipi_quote.cpi_branch_cd%TYPE,
      v_quotation_printed_cnt   IN       gipi_quote.cpi_rec_no%TYPE,
      v_incept_date             IN       gipi_quote.incept_date%TYPE,
      v_expiry_date             IN       gipi_quote.expiry_date%TYPE,
      v_origin                  IN       gipi_quote.origin%TYPE,
      v_reason_cd               IN       gipi_quote.reason_cd%TYPE,
      v_address1                IN       gipi_quote.address1%TYPE,
      v_address2                IN       gipi_quote.address2%TYPE,
      v_address3                IN       gipi_quote.address3%TYPE,
      v_valid_date              IN       gipi_quote.valid_date%TYPE,
      v_prorate_flag            IN       gipi_quote.prorate_flag%TYPE,
      v_short_rt_percent        IN       gipi_quote.short_rt_percent%TYPE,
      v_comp_sw                 IN       gipi_quote.comp_sw%TYPE,
      v_underwriter             IN       gipi_quote.underwriter%TYPE,
      v_insp_no                 IN       gipi_quote.insp_no%TYPE,
      v_ann_prem_amt            IN       gipi_quote.ann_prem_amt%TYPE,
      v_ann_tsi_amt             IN       gipi_quote.ann_tsi_amt%TYPE,
      v_with_tariff_sw          IN       gipi_quote.with_tariff_sw%TYPE,
      v_incept_tag              IN       gipi_quote.incept_tag%TYPE,
      v_expiry_tag              IN       gipi_quote.expiry_tag%TYPE,
      v_cred_branch             IN       giis_issource.iss_name%TYPE,
      v_acct_of_cd              IN       gipi_quote.acct_of_cd%TYPE,
      v_acct_of_cd_sw           IN       gipi_quote.acct_of_cd_sw%TYPE,
      v_pack_quote_id           IN       gipi_quote.pack_quote_id%TYPE,
      v_pack_pol_flag           IN       gipi_quote.pack_pol_flag%TYPE
      ,v_bank_ref_no            IN       gipi_quote.bank_ref_no%TYPE    --added by Gzelle 12.12.2013 SR398
   );
   
   PROCEDURE set_gipi_quote_2 (
      v_quote_id                IN OUT   gipi_quote.quote_id%TYPE,
      v_line_name               IN       giis_line.line_name%TYPE,
      v_subline_cd              IN       giis_subline.subline_cd%TYPE,
      v_subline_name            IN       giis_subline.subline_name%TYPE,
      v_iss_name                IN       giis_issource.iss_name%TYPE,
      v_quotation_yy            IN       gipi_quote.quotation_yy%TYPE,
      v_quotation_no            IN       gipi_quote.quotation_no%TYPE,
      v_proposal_no             IN       gipi_quote.proposal_no%TYPE,
      v_assd_no                 IN       gipi_quote.assd_no%TYPE,
      v_assd_name               IN       gipi_quote.assd_name%TYPE,
      v_tsi_amt                 IN       gipi_quote.tsi_amt%TYPE,
      v_prem_amt                IN       gipi_quote.prem_amt%TYPE,
      v_print_dt                IN       gipi_quote.print_dt%TYPE,
      v_accept_dt               IN       gipi_quote.accept_dt%TYPE,
      v_post_dt                 IN       gipi_quote.post_dt%TYPE,
      v_denied_dt               IN       gipi_quote.denied_dt%TYPE,
      v_status                  IN       gipi_quote.status%TYPE,
      v_print_tag               IN       gipi_quote.print_tag%TYPE,
      v_header                  IN       gipi_quote.header%TYPE,
      v_footer                  IN       gipi_quote.footer%TYPE,
      v_remarks                 IN       gipi_quote.remarks%TYPE,
      v_user_id                 IN       gipi_quote.user_id%TYPE,
      v_last_update             IN       gipi_quote.last_update%TYPE,
      v_cpi_rec_no              IN       gipi_quote.cpi_rec_no%TYPE,
      v_cpi_branch_cd           IN       gipi_quote.cpi_branch_cd%TYPE,
      v_quotation_printed_cnt   IN       gipi_quote.cpi_rec_no%TYPE,
      v_incept_date             IN       gipi_quote.incept_date%TYPE,
      v_expiry_date             IN       gipi_quote.expiry_date%TYPE,
      v_origin                  IN       gipi_quote.origin%TYPE,
      v_reason_cd               IN       gipi_quote.reason_cd%TYPE,
      v_address1                IN       gipi_quote.address1%TYPE,
      v_address2                IN       gipi_quote.address2%TYPE,
      v_address3                IN       gipi_quote.address3%TYPE,
      v_valid_date              IN       gipi_quote.valid_date%TYPE,
      v_prorate_flag            IN       gipi_quote.prorate_flag%TYPE,
      v_short_rt_percent        IN       gipi_quote.short_rt_percent%TYPE,
      v_comp_sw                 IN       gipi_quote.comp_sw%TYPE,
      v_underwriter             IN       gipi_quote.underwriter%TYPE,
      v_insp_no                 IN       gipi_quote.insp_no%TYPE,
      v_ann_prem_amt            IN       gipi_quote.ann_prem_amt%TYPE,
      v_ann_tsi_amt             IN       gipi_quote.ann_tsi_amt%TYPE,
      v_with_tariff_sw          IN       gipi_quote.with_tariff_sw%TYPE,
      v_incept_tag              IN       gipi_quote.incept_tag%TYPE,
      v_expiry_tag              IN       gipi_quote.expiry_tag%TYPE,
      v_cred_branch             IN       giis_issource.iss_name%TYPE,
      v_acct_of_cd              IN       gipi_quote.acct_of_cd%TYPE,
      v_acct_of_cd_sw           IN       gipi_quote.acct_of_cd_sw%TYPE,
      v_pack_quote_id           IN       gipi_quote.pack_quote_id%TYPE,
      v_pack_pol_flag           IN       gipi_quote.pack_pol_flag%TYPE,
      v_account_sw              IN       gipi_quote.account_sw%TYPE, --Added by Jerome 08.18.2016
      v_bank_ref_no             IN       gipi_quote.bank_ref_no%TYPE --Added by Jerome 11.08.2016
   );

   PROCEDURE copy_quotation (
      p_quote_id   IN   gipi_quote.quote_id%TYPE,
      p_user       IN   giis_users.user_id%TYPE
   );

   PROCEDURE delete_quotation (p_quote_id IN gipi_quote.quote_id%TYPE);

   PROCEDURE deny_quotation (p_quote_id IN gipi_quote.quote_id%TYPE);

   PROCEDURE compute_quote_no (
      p_line_cd        IN       gipi_quote.line_cd%TYPE,
      p_subline_cd     IN       gipi_quote.subline_cd%TYPE,
      p_iss_cd         IN       gipi_quote.iss_cd%TYPE,
      p_quotation_yy   IN       gipi_quote.quotation_yy%TYPE,
      p_quotation_no   OUT      gipi_quote.quotation_no%TYPE
   );

   PROCEDURE duplicate_quotation (
      p_quote_id   IN   gipi_quote.quote_id%TYPE,
      p_user       IN   giis_users.user_id%TYPE
   );

   FUNCTION compute_proposal (
      p_line_cd        IN   VARCHAR2,
      p_subline_cd     IN   VARCHAR2,
      p_iss_cd         IN   VARCHAR2,
      p_quotation_yy   IN   NUMBER,
      p_quotation_no   IN   NUMBER
   )
      RETURN NUMBER;

   TYPE gipi_quote_list_type IS RECORD (
      quote_id          gipi_quote.quote_id%TYPE,
      iss_cd            gipi_quote.iss_cd%TYPE,
      line_cd           gipi_quote.line_cd%TYPE,
      subline_cd        gipi_quote.subline_cd%TYPE,
      quotation_yy      VARCHAR2 (20),
      quotation_no      VARCHAR2 (20),
      proposal_no       VARCHAR2 (20),
      assd_no           VARCHAR2 (12),
      assd_name         gipi_quote.assd_name%TYPE,
      assd_active_tag   giis_assured.active_tag%TYPE,
      valid_date        gipi_quote.valid_date%TYPE,
      quote_no          VARCHAR (50),
      incept_date       gipi_quote.incept_date%TYPE,
      expiry_date       gipi_quote.expiry_date%TYPE
   );

   TYPE gipi_quote_list_tab IS TABLE OF gipi_quote_list_type;

   FUNCTION get_quote_list (
      p_iss_cd    gipi_quote.iss_cd%TYPE,
      p_line_cd   gipi_quote.line_cd%TYPE,
      p_module    giis_user_grp_modules.module_id%TYPE,
      p_keyword   VARCHAR2,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN gipi_quote_list_tab PIPELINED;

   PROCEDURE set_quote_to_par_updates (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_assd_no    gipi_quote.assd_no%TYPE,
      p_line_cd    gipi_quote.line_cd%TYPE,
      p_iss_cd     gipi_quote.iss_cd%TYPE
   );

   PROCEDURE update_status (
      p_line_cd        gipi_quote.line_cd%TYPE,
      p_iss_cd         gipi_quote.iss_cd%TYPE,
      p_quotation_yy   gipi_quote.quotation_yy%TYPE,
      p_quotation_no   gipi_quote.quotation_no%TYPE,
      p_subline_cd     gipi_quote.subline_cd%TYPE,
      p_status         gipi_quote.status%TYPE
   );

   PROCEDURE updatequotepremamt (
      p_quote_id   gipi_quote.quote_id%TYPE,
      p_premamt    gipi_quote.prem_amt%TYPE
   );

   PROCEDURE update_return_from_par_status (
      p_quote_id   gipi_quote.quote_id%TYPE
   );

   PROCEDURE update_reason_cd (
      p_quote_id    gipi_quote.quote_id%TYPE,
      p_reason_cd   gipi_quote.reason_cd%TYPE
   );

   TYPE existing_quotes_type IS RECORD (
      quotation_no   gipi_quote.quotation_no%TYPE,
      quote_id       gipi_quote.quote_id%TYPE,
      quotation_yy   gipi_quote.quotation_yy%TYPE,
      quote_no       VARCHAR2 (50),
      par_no         VARCHAR2 (30),
      pol_no         VARCHAR2 (50),
      proposal_no    gipi_quote.proposal_no%TYPE,
      incept_date    gipi_quote.incept_date%TYPE,
      expiry_date    gipi_quote.expiry_date%TYPE,
      status         cg_ref_codes.rv_meaning%TYPE,
      par_id         gipi_parlist.par_id%TYPE,
      par_yy         gipi_parlist.par_yy%TYPE,
      par_seq_no     gipi_parlist.par_seq_no%TYPE,
      quote_seq_no   gipi_parlist.quote_seq_no%TYPE,
      policy_id      gipi_polbasic.policy_id%TYPE,
      orig_policy_id gipi_polbasic.policy_id%TYPE, -- added by: Nica 07.17.2012 to assign original policy_id of the policy being endorse
      subline_cd     gipi_polbasic.subline_cd%TYPE,
      issue_yy       gipi_polbasic.issue_yy%TYPE,
      pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      endt_iss_cd    gipi_polbasic.endt_iss_cd%TYPE,
      endt_yy        gipi_polbasic.endt_yy%TYPE,
      endt_seq_no    gipi_polbasic.endt_seq_no%TYPE,
      renew_no       gipi_polbasic.renew_no%TYPE,
      line_cd        gipi_quote.line_cd%TYPE,
      iss_cd         gipi_parlist.iss_cd%TYPE,
      tsi_amt        gipi_polbasic.tsi_amt%TYPE,
      assd_name      giis_assured.assd_name%TYPE,
      assd_no        giis_assured.assd_no%TYPE,
      address1       gipi_parlist.address1%TYPE,
      address2       gipi_parlist.address2%TYPE,
      address3       gipi_parlist.address3%TYPE,
      address        varchar2(1000)
   );

   TYPE existing_quotes_tab IS TABLE OF existing_quotes_type;

   FUNCTION get_existing_quotes_pol_list (
       p_line_cd     gipi_quote.line_cd%TYPE,
      p_assd_no     gipi_quote.assd_no%TYPE,
      p_assd_name   gipi_quote.assd_name%TYPE,
      v_exist2      varchar2
   )
      RETURN existing_quotes_tab PIPELINED;

   TYPE agent_prod_list_type IS RECORD (
      intm_no        VARCHAR2 (12),
      intermediary   VARCHAR2 (260),
      line_cd        gipi_quote.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE,
      quotation_no   VARCHAR2 (100),
      assd_name      giis_assured.assd_name%TYPE,
      policy_no      VARCHAR2 (100),
      incept_date    gipi_quote.incept_date%TYPE,
      prem_amt       gipi_invoice.prem_amt%TYPE,
      total_prem     NUMBER (20, 2),
      remarks        gipi_quote.remarks%TYPE, 
      print_header  VARCHAR2 (1) -- Kenneth 05.13.2014
   );

   TYPE agent_prod_list_tab IS TABLE OF agent_prod_list_type;

   FUNCTION get_agent_prod_list (
      p_line_cd     gipi_quote.line_cd%TYPE,
      p_intm_no     VARCHAR2,
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2
   )
      RETURN agent_prod_list_tab PIPELINED;

   TYPE converted_quote_type IS RECORD (
      line_cd        VARCHAR2 (2),
      line_name      giis_line.line_name%TYPE,
      quotation      VARCHAR2 (65),
      assd_name      giis_assured.assd_name%TYPE,
      POLICY         VARCHAR2 (65),
      incept_date    gipi_quote.incept_date%TYPE,
      intermediary   VARCHAR2 (281),
      remarks        VARCHAR2 (4000),
      prem_amt       gipi_invoice.prem_amt%TYPE,
      total_prem     NUMBER (20, 2),
      print_header  VARCHAR2 (1)-- Kenneth 05.13.2014
   );

   TYPE converted_quote_tab IS TABLE OF converted_quote_type;

   FUNCTION get_converted_quote (
      p_from_date   VARCHAR2,
      p_to_date     VARCHAR2,
      p_intm_no     VARCHAR2,
      p_line_cd     gipi_quote.line_cd%TYPE
   )
      RETURN converted_quote_tab PIPELINED;

   TYPE agent_broker_prod_rep_type IS RECORD (
      intermediary   VARCHAR (260),
      line_name      giis_line.line_name%TYPE,
      quotation_no   VARCHAR (100),
      assd_name      giis_assured.assd_name%TYPE,
      incept_date    gipi_quote.incept_date%TYPE,
      prem_amt       gipi_invoice.prem_amt%TYPE,
      total_prem     NUMBER (20, 2),
      reason_desc    VARCHAR (200),
      print_header  VARCHAR2 (1) -- Kenneth 05.13.2014
   );

   TYPE agent_broker_prod_rep_tab IS TABLE OF agent_broker_prod_rep_type;

   FUNCTION get_agent_broker_prod_rep (
      p_line_cd     gipi_quote.line_cd%TYPE,
      p_intm_no     gipi_comm_invoice.intrmdry_intm_no%TYPE,
      p_from_date   gipi_quote.incept_date%TYPE,
      p_to_date     gipi_quote.incept_date%TYPE
   )
      RETURN agent_broker_prod_rep_tab PIPELINED;

   TYPE check_assd_name_type IS RECORD (
      assd_no    giis_assured.assd_no%TYPE,
      address1   giis_assured.mail_addr1%TYPE,
      address2   giis_assured.mail_addr2%TYPE,
      address3   giis_assured.mail_addr3%TYPE,
       v_exist1   VARCHAR2(1),
       v_exist2   VARCHAR2(1),
      v_count    NUMBER -- Apollo Cruz 12.08.2014
   );

   TYPE check_assd_name_tab IS TABLE OF check_assd_name_type;

   --Modified by Apollo Cruz 12.08.2014 - added p_assd_no
   FUNCTION check_assd_name (p_assd_name giis_assured.assd_name%TYPE, p_assd_no VARCHAR2)
      RETURN check_assd_name_tab PIPELINED;

   TYPE gipi_pack_quotations_type IS RECORD (
      quote_id       gipi_quote.quote_id%TYPE,
      line_cd        gipi_quote.line_cd%TYPE,
      line_name      giis_line.line_name%TYPE,
      subline_cd     gipi_quote.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE,
      iss_cd         gipi_quote.iss_cd%TYPE,
      quotation_yy   gipi_quote.quotation_yy%TYPE,
      quotation_no   gipi_quote.quotation_no%TYPE,
      proposal_no    gipi_quote.proposal_no%TYPE,
      remarks        gipi_quote.remarks%TYPE
   );

   TYPE gipi_pack_quotations_tab IS TABLE OF gipi_pack_quotations_type;

   FUNCTION get_pack_quotations (
      p_pack_quote_id   gipi_quote.pack_quote_id%TYPE,
      p_user_id         gipi_quote.user_id%TYPE
   )
      RETURN gipi_pack_quotations_tab PIPELINED;

   FUNCTION get_gipi_pack_quote_list (
      p_pack_quote_id   gipi_quote.pack_quote_id%TYPE
   )
      RETURN gipi_quote_tab PIPELINED;

   PROCEDURE generate_quote_bank_ref_no (
      p_quote_id               gipi_quote.quote_id%TYPE,
      p_acct_iss_cd   IN       giis_ref_seq.acct_iss_cd%TYPE,
      p_branch_cd     IN       giis_ref_seq.branch_cd%TYPE,
      p_bank_ref_no   OUT      gipi_wpolbas.bank_ref_no%TYPE,
      p_msg_alert     OUT      VARCHAR2
   );

   FUNCTION get_quote_list_status2 (
       p_line_cd        gipi_quote.line_cd%TYPE,
       p_user           giis_users.user_id%TYPE,
       p_module         giis_modules.module_id%TYPE,
       p_date_from      varchar2,
       p_date_to        varchar2,
       p_status         gipi_quote.status%TYPE,
       p_proposal_no    gipi_quote.proposal_no%TYPE,
       p_quotation_yy   gipi_quote.quotation_yy%TYPE,
       p_quotation_no   gipi_quote.quotation_no%TYPE,
       p_iss_cd         gipi_quote.iss_cd%TYPE,
       p_assd_name      gipi_quote.assd_name%TYPE,
       p_quote_id       gipi_quote.quote_id%TYPE,
       p_create_user    gipi_quote.user_id%TYPE,
       p_subline_cd     gipi_quote.subline_cd%TYPE,
       p_incept_date    varchar2,
       p_expiry_date    varchar2,
       p_par_assd       GIIS_ASSURED.assd_name%TYPE,
       p_quote_no       varchar2
    )
       RETURN quote_list_status_tab PIPELINED;


    PROCEDURE reassign_package_quotation (
          p_user_id       gipi_quote.user_id%TYPE,
          p_quote_id      gipi_quote.quote_id%TYPE,
          p_remarks       gipi_quote.remarks%TYPE,
          p_pack_quote_id gipi_quote.pack_quote_id%TYPE
       );

    PROCEDURE copy_quotation_2 (
      p_quote_id        IN   GIPI_QUOTE.quote_id%TYPE,
      p_user_id         IN   GIIS_USERS.user_id%TYPE,
      p_new_quote_id    OUT  GIPI_QUOTE.quote_id%TYPE
    );

    PROCEDURE duplicate_quotation_2 (
      p_quote_id        IN   GIPI_QUOTE.quote_id%TYPE,
      p_user_id         IN   GIIS_USERS.user_id%TYPE,
      p_new_quote_id    OUT  GIPI_QUOTE.quote_id%TYPE
   );
   
   FUNCTION get_vat_tag(
    p_quote_id              GIPI_QUOTE.quote_id%TYPE
   )
     RETURN VARCHAR2;

FUNCTION GET_QUOTATION_STATUS_LIST(P_LINE_CD GIPI_QUOTE.LINE_CD%TYPE,
       p_user_id           giis_users.user_id%TYPE,
       p_user_id2       giis_users.user_id%TYPE, --added by steven 11.7.2012
       p_date_from      varchar2,
       p_date_to        varchar2,
       p_status         gipi_quote.status%TYPE,
       p_proposal_no    gipi_quote.proposal_no%TYPE,
       p_quotation_yy   gipi_quote.quotation_yy%TYPE,
       p_quotation_no   gipi_quote.quotation_no%TYPE,
       p_iss_cd         gipi_quote.iss_cd%TYPE,
       p_assd_name      gipi_quote.assd_name%TYPE,
       p_quote_id       gipi_quote.quote_id%TYPE,
       p_subline_cd     gipi_quote.subline_cd%TYPE,
       p_incept_date    varchar2,
       p_expiry_date    varchar2,
       p_par_assd       GIIS_ASSURED.assd_name%TYPE,
       p_quote_no       varchar2,
       --Added by MarkS SR5780 10.24.2016 optimization
       p_filter_status  VARCHAR2,
       p_order_by      	VARCHAR2,
       p_asc_desc_flag  VARCHAR2,
       p_from          	NUMBER,
       p_to            	NUMBER
       --SR5780 10.24.2016
   ) RETURN quote_list_status_tab PIPELINED;
   
   --Apollo Cruz 12.08.2014
   --modified version of the function set_exist_msg
   --added p_quote_id to avoid prompting exists message when updating the assured of a saved quotation
   FUNCTION set_exist_msg (
      p_line_cd   VARCHAR2,
      p_assd_no   VARCHAR2,
      p_assd_name VARCHAR2,
      p_quote_id  VARCHAR2
   )
      RETURN VARCHAR2;                         
    
   PROCEDURE delete_quotation2 (p_quote_id IN gipi_quote.quote_id%TYPE);  
END gipi_quote_pkg;
/
