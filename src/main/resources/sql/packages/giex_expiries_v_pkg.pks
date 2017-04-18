CREATE OR REPLACE PACKAGE CPI.giex_expiries_v_pkg
AS
   TYPE giex_expiries_v_type IS RECORD 
   (
      count_              NUMBER,--added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      rownum_             NUMBER, --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      policy_id           giex_expiries_v.policy_id%TYPE,
      expiry_date         giex_expiries_v.expiry_date%TYPE,
      renew_flag          giex_expiries_v.renew_flag%TYPE,
      line_cd             giex_expiries_v.line_cd%TYPE, 
      subline_cd          giex_expiries_v.subline_cd%TYPE,
      same_polno_sw       giex_expiries_v.same_polno_sw%TYPE,
      cpi_rec_no          giex_expiries_v.cpi_rec_no%TYPE,
      cpi_branch_cd       giex_expiries_v.cpi_branch_cd%TYPE,
      iss_cd              giex_expiries_v.iss_cd%TYPE,
      post_flag           giex_expiries_v.post_flag%TYPE,
      balance_flag        giex_expiries_v.balance_flag%TYPE,
      claim_flag          giex_expiries_v.claim_flag%TYPE,
      extract_user        giex_expiries_v.extract_user%TYPE,
      extract_date        giex_expiries_v.extract_date%TYPE,
      processor           giex_expiries_v.processor%TYPE,
      cred_branch         gipi_polbasic.cred_branch%TYPE,
      user_id             giex_expiries_v.user_id%TYPE,
      last_update         giex_expiries_v.last_update%TYPE,
      date_printed        giex_expiries_v.date_printed%TYPE,
      no_of_copies        giex_expiries_v.no_of_copies%TYPE,
      auto_renew_flag     giex_expiries_v.auto_renew_flag%TYPE,
      update_flag         giex_expiries_v.update_flag%TYPE,
      tsi_amt             giex_expiries_v.tsi_amt%TYPE,
      prem_amt            giex_expiries_v.prem_amt%TYPE,
      ren_tsi_amt         giex_expiries_v.ren_tsi_amt%TYPE,
      ren_prem_amt        giex_expiries_v.ren_prem_amt%TYPE,
      summary_sw          giex_expiries_v.summary_sw%TYPE,
      incept_date         giex_expiries_v.incept_date%TYPE,
      assd_no             giex_expiries_v.assd_no%TYPE,
      assd_name           giex_expiries_v.assd_name%TYPE, --added by pjsantos 10/13/2016, GENQA 5685
      auto_sw             giex_expiries_v.auto_sw%TYPE,
      tax_amt             giex_expiries_v.tax_amt%TYPE,
      policy_tax_amt      giex_expiries_v.policy_tax_amt%TYPE,
      issue_yy            giex_expiries_v.issue_yy%TYPE,
      pol_seq_no          giex_expiries_v.pol_seq_no%TYPE,
      renew_no            giex_expiries_v.renew_no%TYPE,
      color               giex_expiries_v.color%TYPE,
      motor_no            giex_expiries_v.motor_no%TYPE,
      model_year          giex_expiries_v.model_year%TYPE,
      make                giex_expiries_v.make%TYPE,
      serialno            giex_expiries_v.serialno%TYPE,
      plate_no            giex_expiries_v.plate_no%TYPE,
      ren_notice_cnt      giex_expiries_v.ren_notice_cnt%TYPE,
      ren_notice_date     giex_expiries_v.ren_notice_date%TYPE,
      item_title          giex_expiries_v.item_title%TYPE,
      loc_risk1           giex_expiries_v.loc_risk1%TYPE,
      loc_risk2           giex_expiries_v.loc_risk2%TYPE,
      loc_risk3           giex_expiries_v.loc_risk3%TYPE,
      car_company         giex_expiries_v.car_company%TYPE,
      intm_no             giex_expiries_v.intm_no%TYPE,
      remarks             giex_expiries_v.remarks%TYPE,
      orig_tsi_amt        giex_expiries_v.orig_tsi_amt%TYPE,
      sms_flag            giex_expiries_v.sms_flag%TYPE,
      renewal_id          giex_expiries_v.renewal_id%TYPE,
      reg_policy_sw       giex_expiries_v.reg_policy_sw%TYPE,
      assd_sms            giex_expiries_v.assd_sms%TYPE,
      intm_sms            giex_expiries_v.intm_sms%TYPE,
      email_doc           giex_expiries_v.email_doc%TYPE,
      email_sw            giex_expiries_v.email_sw%TYPE,
      email_stat          giex_expiries_v.email_stat%TYPE,
      assd_email          giex_expiries_v.assd_email%TYPE,
      intm_email          giex_expiries_v.intm_email%TYPE, 
      non_ren_reason      giex_expiries_v.non_ren_reason%TYPE,
      coc_serial_no       giex_expiries_v.coc_serial_no%TYPE,
      non_ren_reason_cd   giex_expiries_v.non_ren_reason_cd%TYPE,
      pack_policy_id      giex_expiries_v.pack_policy_id%TYPE,
      is_package          giex_expiries_v.is_package%TYPE,
      ref_pol_no          giex_expiries_v.ref_pol_no%TYPE, --added by pjsantos 10/13/2016 GENQA 5685
      policy_no           VARCHAR2 (50),
      dsp_prem            gipi_itmperil.prem_amt%TYPE,
      dsp_tsi             gipi_itmperil.tsi_amt%TYPE,
      dsp_orig_prem       gipi_itmperil.prem_amt%TYPE, 
      dsp_orig_tsi        gipi_itmperil.tsi_amt%TYPE,
      dist_sw             VARCHAR2 (1)    
   );

   TYPE giex_expiries_v_tab IS TABLE OF giex_expiries_v_type;

   TYPE renewals_type IS RECORD
   (
      policy_no     VARCHAR2 (50),
      par_no        VARCHAR2 (50),
	  same_polno_sw varchar2(1)
   );

   TYPE renewals_tab IS TABLE OF renewals_type;

   TYPE NUMBER_TT IS TABLE OF NUMBER;

   TYPE extracted_policies_type IS RECORD
   (
      policy_no      VARCHAR2 (50),
      line_cd        GIEX_EXPIRIES_V.line_cd%TYPE,
      subline_cd     GIEX_EXPIRIES_V.subline_cd%TYPE,
      iss_cd         GIEX_EXPIRIES_V.iss_cd%TYPE,
      issue_yy       GIEX_EXPIRIES_V.issue_yy%TYPE,
      pol_seq_no     GIEX_EXPIRIES_V.pol_seq_no%TYPE, 
      renew_no       GIEX_EXPIRIES_V.renew_no%TYPE,
      tsi_amt        NUMBER(21,2),--GIEX_EXPIRIES_V.tsi_amt%TYPE,
      prem_amt       NUMBER(16,2),--GIEX_EXPIRIES_V.prem_amt%TYPE,
      expiry_date_temp    GIEX_EXPIRIES_V.expiry_date%TYPE, --modified by pjsantos 10/11/2016, GENQA 5688
      expiry_date    VARCHAR2(13), --modified by pjsantos 10/11/2016, GENQA 5688
      post_flag      VARCHAR2 (5),
      expiry_flag    VARCHAR2 (5),
      user_id        GIEX_EXPIRIES_V.user_id%TYPE,
      extract_user   GIEX_EXPIRIES_V.extract_user%TYPE,
      policy_id      GIEX_EXPIRIES_V.policy_id%type,    --added by pjsantos 10/11/2016, GENQA 5688
      is_package     GIEX_EXPIRIES_V.is_package%type,   --added by pjsantos 10/11/2016, GENQA 5688
      summary_sw     GIEX_EXPIRIES_V.summary_sw%type,   --added by pjsantos 10/11/2016, GENQA 5688
      count_         NUMBER,                            --added by pjsantos 10/11/2016, GENQA 5688
      rownum_        NUMBER                             --added by pjsantos 10/11/2016, GENQA 5688     
   );

   TYPE extracted_policies_tab IS TABLE OF extracted_policies_type;

   FUNCTION get_expired_policies (
      p_user_id     giex_expiries_v.extract_user%TYPE,
      p_all_user    giis_users.all_user_sw%TYPE )
      RETURN giex_expiries_v_tab
      PIPELINED;

      FUNCTION get_expired_policies2 (
      p_user_id     giex_expiries_v.extract_user%TYPE,
      p_all_user    giis_users.all_user_sw%TYPE,
      p_line_cd       giex_expiries_v.line_cd%TYPE,
      p_subline_cd    giex_expiries_v.subline_cd%TYPE,
      p_iss_cd        giex_expiries_v.iss_cd%TYPE,
      p_issue_yy      giex_expiries_v.issue_yy%TYPE,
      p_pol_seq_no    giex_expiries_v.pol_seq_no%TYPE,
      p_renew_no      giex_expiries_v.renew_no%TYPE,
      p_claim_sw      giex_expiries_v.claim_flag%TYPE,
      p_balance_sw    giex_expiries_v.balance_flag%TYPE,
      p_intm_name     giis_intermediary.intm_name%TYPE,
      p_intm_no       giex_expiries_v.intm_no%TYPE,
      p_range_type    VARCHAR2,
      p_range         VARCHAR2,
      p_fm_date       DATE,
      p_to_date       DATE,
      p_fm_mon        NUMBER, --marco - changed types from DATE
      p_to_mon        NUMBER, --
      p_fm_year       NUMBER, --
      p_to_year       NUMBER )/*joanne*/
      RETURN giex_expiries_v_tab
      PIPELINED;

   PROCEDURE giexs004_post_query (
      p_count                  OUT NUMBER,
      p_pack_policy_id      IN     giex_expiries_v.pack_policy_id%TYPE,
      p_policy_id           IN     giex_expiries_v.policy_id%TYPE,
      p_from_post_query        OUT VARCHAR2,
      p_balance_flag           OUT giex_expiries_v.balance_flag%TYPE,
      p_non_ren_reason         OUT giex_expiries_v.non_ren_reason%TYPE,
      p_non_ren_reason_cd      OUT giex_expiries_v.non_ren_reason_cd%TYPE,
      p_remarks                OUT giex_expiries_v.remarks%TYPE,
      p_is_package          IN     giex_expiries_v.is_package%TYPE,
      p_nbt_line_cd            OUT gipi_pack_polbasic.line_cd%TYPE,
      p_nbt_subline_cd         OUT gipi_pack_polbasic.subline_cd%TYPE,
      p_nbt_iss_cd             OUT gipi_pack_polbasic.iss_cd%TYPE,
      p_nbt_issue_yy           OUT gipi_pack_polbasic.issue_yy%TYPE,
      p_nbt_pol_seq_no         OUT gipi_pack_polbasic.pol_seq_no%TYPE,
      p_nbt_renew_no           OUT gipi_pack_polbasic.renew_no%TYPE,
      p_pol_prem               OUT gipi_pack_polbasic.ann_prem_amt%TYPE,
      p_orig_pol_prem          OUT gipi_pack_polbasic.prem_amt%TYPE,
      p_par_id                 OUT gipi_pack_parlist.pack_par_id%TYPE,
      p_line_cd                OUT gipi_pack_parlist.line_cd%TYPE,
      p_iss_cd                 OUT gipi_pack_parlist.iss_cd%TYPE,
      p_par_yy                 OUT gipi_pack_parlist.par_yy%TYPE,
      p_par_seq_no             OUT gipi_pack_parlist.par_seq_no%TYPE,
      p_quote_seq_no           OUT gipi_pack_parlist.quote_seq_no%TYPE,
      p_par_type               OUT gipi_pack_parlist.par_type%TYPE,
      p_assd_no                OUT gipi_pack_parlist.assd_no%TYPE,
      p_dist_sw                OUT VARCHAR2,
      p_dsp_renew_flag         OUT VARCHAR2,
      p_pol_tsi                OUT gipi_itmperil.tsi_amt%TYPE,
      p_orig_pol_tsi           OUT gipi_itmperil.tsi_amt%TYPE,
      p_user_id                OUT giex_pack_expiry.user_id%TYPE,
      p_processor              OUT giex_expiry.processor%TYPE,
      p_last_update            OUT giex_pack_expiry.last_update%TYPE,
      p_nbt_email_status       OUT VARCHAR2,
      p_nbt_sms_status         OUT VARCHAR2,
      p_itmperil_exist         OUT VARCHAR2);

   PROCEDURE check_renew_flag (
      p_renew_flag    IN     giex_expiries_v.renew_flag%TYPE,
      p_policy_id     IN     giex_expiries_v.policy_id%TYPE,
      p_module        IN     giac_modules.module_name%TYPE,
      p_user          IN     giis_posting_limit.posting_user%TYPE,
      p_dsp_line_cd   IN     giis_posting_limit.line_cd%TYPE,
      p_dsp_iss_cd    IN     giis_posting_limit.iss_cd%TYPE,
      p_proceed          OUT VARCHAR2,
      p_msg              OUT VARCHAR2);

   PROCEDURE verify_override_rb (
      p_user               giis_posting_limit.posting_user%TYPE,
      p_policy_id          giex_expiries_v.policy_id%TYPE,
      p_renew_flag         giex_expiries_v.renew_flag%TYPE,
      p_auto_sw            giex_expiries_v.auto_sw%TYPE,
      p_balance_flag       giex_expiries_v.balance_flag%TYPE,
      p_claim_flag         giex_expiries_v.claim_flag%TYPE,
      p_dist_sw            VARCHAR2,
      p_msg            OUT VARCHAR2,
      p_alert_msg      OUT VARCHAR2);

   PROCEDURE get_dist_sw (
      p_is_package   IN     giex_expiries_v.is_package%TYPE,
      p_policy_id    IN     giex_expiries_v.policy_id%TYPE,
      p_dist_sw         OUT VARCHAR2);

   FUNCTION get_queried_expired_policies (
      p_user_id            giex_expiries_v.extract_user%TYPE,
      p_all_user           giis_users.all_user_sw%TYPE,
      p_dsp_intm_no        giex_expiries_v.intm_no%TYPE,
      p_dsp_intm_name      giis_intermediary.intm_name%TYPE,
      p_claim_sw           giex_expiries_v.claim_flag%TYPE,
      p_balance_sw         giex_expiries_v.balance_flag%TYPE,
      p_range_type         VARCHAR2,
      p_range              VARCHAR2,
      p_fm_date            VARCHAR2,
      p_to_date            VARCHAR2,
      p_fm_mon             VARCHAR2,
      p_fm_year            NUMBER,
      p_to_mon             VARCHAR2,
      p_to_year            NUMBER,
      p_dsp_line_cd2       gipi_polbasic.line_cd%TYPE,
      p_dsp_subline_cd2    gipi_polbasic.subline_cd%TYPE,
      p_dsp_iss_cd2        gipi_polbasic.iss_cd%TYPE,
      p_dsp_issue_yy2      gipi_polbasic.issue_yy%TYPE,
      p_dsp_pol_seq_no2    gipi_polbasic.pol_seq_no%TYPE,
      p_dsp_renew_no2      gipi_polbasic.renew_no%TYPE,
      p_order_by          VARCHAR2,      --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      p_asc_desc_flag     VARCHAR2,      --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      p_first_row         NUMBER,        --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      p_last_row          NUMBER         --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      )
      RETURN giex_expiries_v_tab
      PIPELINED;

   PROCEDURE save_process_tag (
      p_user_id            giex_expiries_v.extract_user%TYPE,
      p_all_user           giis_users.all_user_sw%TYPE,
      p_dsp_intm_no        giex_expiries_v.intm_no%TYPE,
      p_dsp_intm_name      giis_intermediary.intm_name%TYPE,
      p_claim_sw           giex_expiries_v.claim_flag%TYPE,
      p_balance_sw         giex_expiries_v.balance_flag%TYPE,
      p_range_type         VARCHAR2,
      p_range              VARCHAR2,
      p_fm_date            VARCHAR2,
      p_to_date            VARCHAR2,
      p_fm_mon             VARCHAR2,
      p_fm_year            NUMBER,
      p_to_mon             VARCHAR2,
      p_to_year            NUMBER,
      p_dsp_line_cd2       gipi_polbasic.line_cd%TYPE,
      p_dsp_subline_cd2    gipi_polbasic.subline_cd%TYPE,
      p_dsp_iss_cd2        gipi_polbasic.iss_cd%TYPE,
      p_dsp_issue_yy2      gipi_polbasic.issue_yy%TYPE,
      p_dsp_pol_seq_no2    gipi_polbasic.pol_seq_no%TYPE,
      p_dsp_renew_no2      gipi_polbasic.renew_no%TYPE,
      p_process            VARCHAR2,      
      p_order_by           VARCHAR2,      --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      p_asc_desc_flag      VARCHAR2,      --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      p_first_row          NUMBER,        --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      p_last_row           NUMBER         --added by pjsantos @pcic 10/13/2016, for optimization GENQA 5685
      );

   FUNCTION get_policy_id_for_process (
      p_user       IN giex_expiries_v.extract_user%TYPE,
      p_all_user   IN giis_users.all_user_sw%TYPE,
      p_line_cd       giex_expiries_v.line_cd%TYPE, --joanne
      p_subline_cd    giex_expiries_v.subline_cd%TYPE,
      p_iss_cd        giex_expiries_v.iss_cd%TYPE,
      p_issue_yy      giex_expiries_v.issue_yy%TYPE,
      p_pol_seq_no    giex_expiries_v.pol_seq_no%TYPE,
      p_renew_no      giex_expiries_v.renew_no%TYPE,
      p_claim_sw      giex_expiries_v.claim_flag%TYPE,
      p_balance_sw    giex_expiries_v.balance_flag%TYPE,
      p_intm_name     giis_intermediary.intm_name%TYPE,
      p_intm_no       giex_expiries_v.intm_no%TYPE,
      p_range_type    VARCHAR2,
      p_range         VARCHAR2,
      p_fm_date       DATE,
      p_to_date       DATE,
      p_fm_mon        NUMBER, --marco - 08.29.2014 - changed types from DATE
      p_to_mon        NUMBER, --
      p_fm_year       NUMBER, --
      p_to_year       NUMBER )/*joanne*/
      RETURN giex_expiries_v_tab
      PIPELINED;

   FUNCTION display_renewals (p_policy_ids VARCHAR2)
      RETURN renewals_tab
      PIPELINED;

   FUNCTION get_extracted_policies (
      p_user_id        GIEX_EXPIRIES_V.user_id%TYPE,
      p_all_user       GIIS_USERS.all_user_sw%TYPE,
      p_intm_no        GIEX_EXPIRIES_V.intm_no%TYPE,
      p_policy_no      VARCHAR2,
      p_line_cd        GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd     GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd         GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy       GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no     GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no       GIEX_EXPIRIES_V.renew_no%TYPE,
      p_tsi_amt        GIEX_EXPIRIES_V.tsi_amt%TYPE,
      p_prem_amt       GIEX_EXPIRIES_V.prem_amt%TYPE,
      p_expiry_date    VARCHAR2, --GIEX_EXPIRIES_V.expiry_date%TYPE, -- marco - 02.07.2013 - changed type
      p_from_month     VARCHAR2,
      p_from_year      VARCHAR2,
      p_to_month       VARCHAR2,
      p_to_year        VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_range          VARCHAR2,
      p_order_by          VARCHAR2,                     --added by pjsantos 10/11/2016, GENQA 5688
      p_asc_desc_flag     VARCHAR2,                     --added by pjsantos 10/11/2016, GENQA 5688
      p_first_row         NUMBER,                       --added by pjsantos 10/11/2016, GENQA 5688
      p_last_row          NUMBER )                      --added by pjsantos 10/11/2016, GENQA 5688
      RETURN extracted_policies_tab
      PIPELINED;

   PROCEDURE purge_based_not_param (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_all_user        GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw          GIIS_USERS.mis_sw%TYPE,
      p_all_exp_proc    VARCHAR2,
      p_all_unproc      VARCHAR2);

   PROCEDURE purge_based_not_time (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_all_user        GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw          GIIS_USERS.mis_sw%TYPE,
      p_all_exp_proc    VARCHAR2,
      p_all_unproc      VARCHAR2,
      p_line_cd         GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd      GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd          GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy        GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no      GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no        GIEX_EXPIRIES_V.renew_no%TYPE,
      p_intm_no         GIEX_EXPIRIES_V.intm_no%TYPE);

   PROCEDURE purge_based_on_before_month (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_all_user        GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw          GIIS_USERS.mis_sw%TYPE,
      p_all_exp_proc    VARCHAR2,
      p_all_unproc      VARCHAR2,
      p_line_cd         GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd      GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd          GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy        GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no      GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no        GIEX_EXPIRIES_V.renew_no%TYPE,
      p_intm_no         GIEX_EXPIRIES_V.intm_no%TYPE,
      p_from_month      VARCHAR2,
      p_from_year       VARCHAR2);

   PROCEDURE purge_based_on_before_date (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_all_user        GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw          GIIS_USERS.mis_sw%TYPE,
      p_all_exp_proc    VARCHAR2,
      p_all_unproc      VARCHAR2,
      p_line_cd         GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd      GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd          GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy        GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no      GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no        GIEX_EXPIRIES_V.renew_no%TYPE,
      p_intm_no         GIEX_EXPIRIES_V.intm_no%TYPE,
      p_from_date       VARCHAR2);

   PROCEDURE check_no_of_records_to_purge (
      p_user_id              GIEX_EXPIRIES_V.user_id%TYPE,
      p_all_user             GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw               VARCHAR2,
      p_based_on_param       VARCHAR2,
      p_all_exp_proc         VARCHAR2,
      p_all_unproc           VARCHAR2,
      p_line_cd              GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd           GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd               GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy             GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no           GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no             GIEX_EXPIRIES_V.renew_no%TYPE,
      p_intm_no              GIEX_EXPIRIES_V.intm_no%TYPE,
      p_from_month           VARCHAR2,
      p_from_year            VARCHAR2,
      p_to_month             VARCHAR2,
      p_to_year              VARCHAR2,
      p_from_date            VARCHAR2,
      p_to_date              VARCHAR2,
      p_range_type           VARCHAR2,
      p_range                VARCHAR2,
      v_cnt_proc         OUT NUMBER,
      v_cnt_unproc       OUT NUMBER,
      v_cnt_proc_all     OUT NUMBER);

   PROCEDURE purge_based_exact_month (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_all_user        GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw          GIIS_USERS.mis_sw%TYPE,
      p_all_exp_proc    VARCHAR2,
      p_all_unproc      VARCHAR2,
      p_line_cd         GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd      GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd          GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy        GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no      GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no        GIEX_EXPIRIES_V.renew_no%TYPE,
      p_intm_no         GIEX_EXPIRIES_V.intm_no%TYPE,
      p_from_month      VARCHAR2,
      p_from_year       VARCHAR2,
      p_to_month        VARCHAR2,
      p_to_year         VARCHAR2);

   PROCEDURE purge_based_exact_date (
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_all_user        GIIS_USERS.all_user_sw%TYPE,
      p_mis_sw          GIIS_USERS.mis_sw%TYPE,
      p_all_exp_proc    VARCHAR2,
      p_all_unproc      VARCHAR2,
      p_line_cd         GIEX_EXPIRIES_V.line_cd%TYPE,
      p_subline_cd      GIEX_EXPIRIES_V.subline_cd%TYPE,
      p_iss_cd          GIEX_EXPIRIES_V.iss_cd%TYPE,
      p_issue_yy        GIEX_EXPIRIES_V.issue_yy%TYPE,
      p_pol_seq_no      GIEX_EXPIRIES_V.pol_seq_no%TYPE,
      p_renew_no        GIEX_EXPIRIES_V.renew_no%TYPE,
      p_intm_no         GIEX_EXPIRIES_V.intm_no%TYPE,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2);

   TYPE policy_id_giexs006_type
      IS RECORD (policy_id giex_expiries_v.policy_id%TYPE);

   TYPE policy_id_giexs006_tab IS TABLE OF policy_id_giexs006_type;

   FUNCTION get_policy_id_giexs006 (
      p_fr_rn_seq_no      giex_rn_no.rn_seq_no%TYPE,
      p_to_rn_seq_no      giex_rn_no.rn_seq_no%TYPE,
      p_assd_no           giex_expiry.assd_no%TYPE,
      p_intm_no           giex_expiry.intm_no%TYPE,
      p_iss_cd            giex_expiry.iss_cd%TYPE,
      p_subline_cd        giex_expiry.subline_cd%TYPE,
      p_line_cd           giex_expiry.line_cd%TYPE,
      p_start_date        giex_expiry.expiry_date%TYPE,
      p_end_date          giex_expiry.expiry_date%TYPE,
      p_user_id           giis_users.user_id%TYPE,
      p_renew_flag        giex_expiry.renew_flag%TYPE,
      p_req_renewal_no    VARCHAR2)
      RETURN policy_id_giexs006_tab
      PIPELINED;

   FUNCTION get_par_no (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN CHAR;

FUNCTION get_POLICY_no (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN CHAR;
   /**
    added by Irwin Tabisora
    Date: 8.2.2012
   */
   TYPE variables_type IS RECORD
   (
      vOverride            VARCHAR2 (1),
      vRequireNRReason     VARCHAR2 (1),
      vAllowAR             VARCHAR (1),
      vAllowARWDist        VARCHAR2 (1),
      vExpiryAllowUndist   VARCHAR2 (1),
      vOverrideRenewal     VARCHAR2 (1),
      allow_renewal_other_user VARCHAR2 (1),
      validate_mc_fmv      giis_parameters.param_value_v%TYPE --benjo 11.24.2016 SR-5621
   );

   TYPE variables_tab IS TABLE OF variables_type;

   FUNCTION get_initial_variables
      RETURN variables_tab
      PIPELINED;

   FUNCTION get_renewed_list (p_policy_ids VARCHAR2)
      RETURN renewals_tab
      PIPELINED;
END giex_expiries_v_pkg;
/


