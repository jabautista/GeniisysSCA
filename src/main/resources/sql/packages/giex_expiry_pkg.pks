CREATE OR REPLACE PACKAGE CPI.giex_expiry_pkg
AS
   TYPE giex_expiry_type IS RECORD (
      policy_id             giex_expiry.policy_id%TYPE,
      expiry_date           giex_expiry.expiry_date%TYPE,
      renew_flag            giex_expiry.renew_flag%TYPE,
      line_cd               giex_expiry.line_cd%TYPE,
      subline_cd            giex_expiry.subline_cd%TYPE,
      same_polno_sw         giex_expiry.same_polno_sw%TYPE,
      cpi_rec_no            giex_expiry.cpi_rec_no%TYPE,
      iss_cd                giex_expiry.iss_cd%TYPE,
      post_flag             giex_expiry.post_flag%TYPE,
      balance_flag          giex_expiry.balance_flag%TYPE,
      claim_flag            giex_expiry.claim_flag%TYPE,
      extract_user          giex_expiry.extract_user%TYPE,
      extract_date          giex_expiry.extract_date%TYPE,
      user_id               giex_expiry.user_id%TYPE,
      last_update           giex_expiry.last_update%TYPE,
      date_printed          giex_expiry.date_printed%TYPE,
      no_of_copies          giex_expiry.no_of_copies%TYPE,
      auto_renew_flag       giex_expiry.auto_renew_flag%TYPE,
      update_flag           giex_expiry.update_flag%TYPE,
      tsi_amt               giex_expiry.tsi_amt%TYPE,
      prem_amt              giex_expiry.prem_amt%TYPE,
      summary_sw            giex_expiry.summary_sw%TYPE,
      incept_date           giex_expiry.incept_date%TYPE,
      assd_no               giex_expiry.assd_no%TYPE,
      auto_sw               giex_expiry.auto_sw%TYPE,
      tax_amt               giex_expiry.tax_amt%TYPE,
      policy_tax_amt        giex_expiry.policy_tax_amt%TYPE,
      issue_yy              giex_expiry.issue_yy%TYPE,
      pol_seq_no            giex_expiry.pol_seq_no%TYPE,
      renew_no              giex_expiry.renew_no%TYPE,
      color                 giex_expiry.color%TYPE,
      motor_no              giex_expiry.motor_no%TYPE,
      model_year            giex_expiry.model_year%TYPE,
      make                  giex_expiry.make%TYPE,
      serialno              giex_expiry.serialno%TYPE,
      plate_no              giex_expiry.plate_no%TYPE,
      ren_notice_cnt        giex_expiry.ren_notice_cnt%TYPE,
      ren_notice_date       giex_expiry.ren_notice_date%TYPE,
      item_title            giex_expiry.item_title%TYPE,
      loc_risk1             giex_expiry.loc_risk1%TYPE,
      loc_risk2             giex_expiry.loc_risk2%TYPE,
      loc_risk3             giex_expiry.loc_risk3%TYPE,
      intm_no               giex_expiry.intm_no%TYPE,
      car_company           giex_expiry.car_company%TYPE,
      remarks               giex_expiry.remarks%TYPE,
      orig_tsi_amt          giex_expiry.orig_tsi_amt%TYPE,
      sms_flag              giex_expiry.sms_flag%TYPE,
      renewal_id            giex_expiry.renewal_id%TYPE,
      reg_policy_sw         giex_expiry.reg_policy_sw%TYPE,
      assd_sms              giex_expiry.assd_sms%TYPE,
      intm_sms              giex_expiry.intm_sms%TYPE,
      email_doc             giex_expiry.email_doc%TYPE,
      email_sw              giex_expiry.email_sw%TYPE,
      email_stat            giex_expiry.email_stat%TYPE,
      assd_email            giex_expiry.assd_email%TYPE,
      intm_email            giex_expiry.intm_email%TYPE,
      non_ren_reason        giex_expiry.non_ren_reason%TYPE,
      non_ren_reason_cd     giex_expiry.non_ren_reason_cd%TYPE,
      pack_policy_id        giex_expiry.pack_policy_id%TYPE,
      risk_no               giex_expiry.risk_no%TYPE,
      risk_item_no          giex_expiry.risk_item_no%TYPE,
      motor_coverage        giex_expiry.motor_coverage%TYPE,
      ren_tsi_amt           giex_expiry.ren_tsi_amt%TYPE,
      ren_prem_amt          giex_expiry.ren_prem_amt%TYPE,
      currency_prem_amt     giex_expiry.currency_prem_amt%TYPE,
      policy_currency       giex_expiry.policy_currency%TYPE,
      coc_serial_no         giex_expiry.coc_serial_no%TYPE,
      approve_tag           giex_expiry.approve_tag%TYPE,
      approve_date          giex_expiry.approve_date%TYPE,
      print_tag             giex_expiry.print_tag%TYPE,
      print_date            giex_expiry.print_date%TYPE,
      sms_date              giex_expiry.sms_date%TYPE,
      bank_ref_no           giex_expiry.bank_ref_no%TYPE,

      dsp_pack_line_cd      giex_pack_expiry.line_cd%TYPE,
      dsp_pack_subline_cd   giex_pack_expiry.subline_cd%TYPE,
      dsp_pack_iss_cd       giex_pack_expiry.iss_cd%TYPE,
      dsp_pack_issue_yy     giex_pack_expiry.issue_yy%TYPE,
      dsp_pack_pol_seq_no   giex_pack_expiry.pol_seq_no%TYPE,
      dsp_pack_renew_no     giex_pack_expiry.renew_no%TYPE,
      pack_pol_flag         giis_line.pack_pol_flag%TYPE,
      nbt_issue_yy          gipi_polbasic.issue_yy%TYPE,
      nbt_pol_seq_no        gipi_polbasic.pol_seq_no%TYPE,
      nbt_renew_no          gipi_polbasic.renew_no%TYPE,
      nbt_prorate_flag      gipi_polbasic.prorate_flag%TYPE,
      endt_expiry_date      gipi_polbasic.endt_expiry_date%TYPE,
      eff_date              gipi_polbasic.eff_date%TYPE,
      short_rt_percent      gipi_polbasic.short_rt_percent%TYPE,
      prov_prem_pct         gipi_polbasic.prov_prem_pct%TYPE,
      prov_prem_tag         gipi_polbasic.prov_prem_tag%TYPE,
      dsp_assd_name         GIIS_ASSURED.assd_name%TYPE,
      v_comp_sw             GIPI_WPOLBAS.COMP_SW%TYPE,
      v_sw                  VARCHAR2(1),
      v_is_pack             VARCHAR2(1),
      v_is_gpa              VARCHAR2(1)
   );
   TYPE giex_expiry_tab IS TABLE OF giex_expiry_type;

   TYPE sms_renewal_type IS RECORD(
        policy_id           GIEX_EXPIRY.policy_id%TYPE,
        line_cd             GIEX_EXPIRY.line_cd%TYPE,
        subline_cd          GIEX_EXPIRY.subline_cd%TYPE,
        iss_cd              GIEX_EXPIRY.iss_cd%TYPE,
        issue_yy            GIEX_EXPIRY.issue_yy%TYPE,
        pol_seq_no          GIEX_EXPIRY.pol_seq_no%TYPE,
        renew_no            GIEX_EXPIRY.renew_no%TYPE,
        tsi_amt             GIEX_EXPIRY.tsi_amt%TYPE,
        prem_amt            GIEX_EXPIRY.prem_amt%TYPE,
        expiry_date         GIEX_EXPIRY.expiry_date%TYPE,
        chk_received        VARCHAR2(1),
        chk_sent            VARCHAR2(1),
        assd_no             GIEX_EXPIRY.assd_no%TYPE,
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        intm_no             GIEX_EXPIRY.intm_no%TYPE,
        intm_name           GIIS_INTERMEDIARY.intm_name%TYPE,
        renew_flag          GIEX_EXPIRY.renew_flag%TYPE,
        balance_flag        GIEX_EXPIRY.balance_flag%TYPE,
        claim_flag          GIEX_EXPIRY.claim_flag%TYPE,
        user_id             GIEX_EXPIRY.user_id%TYPE,
        last_update         GIEX_EXPIRY.last_update%TYPE,
        remarks             GIEX_EXPIRY.remarks%TYPE,
        pack_policy_id      GIEX_EXPIRY.pack_policy_id%TYPE,
        policy_no           VARCHAR2(100),
        assd_sms            GIEX_EXPIRY.assd_sms%TYPE,
        intm_sms            GIEX_EXPIRY.intm_sms%TYPE,
        post_flag           GIEX_EXPIRY.post_flag%TYPE,
        cp_no               GIIS_ASSURED.cp_no%TYPE,
        with_msg            VARCHAR2(1),
        intm_cp_no          GIIS_INTERMEDIARY.cp_no%TYPE,
        intm_with_msg       VARCHAR2(1),
        sms_for_renew       VARCHAR2(1),
        sms_for_non_renew   VARCHAR2(1)
    );
    TYPE sms_renewal_tab IS TABLE OF sms_renewal_type;

    FUNCTION get_extraction_history (
        p_user_id   giex_expiry.extract_user%TYPE
    )
    RETURN giex_expiry_tab PIPELINED;

   FUNCTION check_record_user (
    p_policy_id        giex_expiry.policy_id%TYPE,
    p_assd_no        giex_expiry.assd_no%TYPE,
    p_intm_no        giex_expiry.intm_no%TYPE,
    p_iss_cd        giex_expiry.iss_cd%TYPE,
    p_subline_cd    giex_expiry.subline_cd%TYPE,
    p_line_cd        giex_expiry.line_cd%TYPE,
    p_start_date    giex_expiry.expiry_date%TYPE,
    p_end_date        giex_expiry.expiry_date%TYPE,
    p_fr_rn_seq_no    giex_rn_no.rn_seq_no%TYPE,
    p_to_rn_seq_no    giex_rn_no.rn_seq_no%TYPE,
    p_user_id        giis_users.user_id%TYPE
    )
    RETURN VARCHAR2;
    PROCEDURE get_last_extraction_history (
        p_extract_user OUT   giex_expiry.extract_user%TYPE,
        p_extract_date OUT   VARCHAR2,
        p_iss_ri       OUT   giis_parameters.param_value_v%TYPE
    );

    PROCEDURE extract_expiring_policies(
        p_fm_mon                IN      VARCHAR2,
        p_fm_year               IN      NUMBER,
        p_to_mon                IN      VARCHAR2,
        p_to_year               IN      NUMBER,
        p_fm_date               IN      VARCHAR2,
        p_to_date               IN      VARCHAR2,
        p_range_type            IN      NUMBER,
        p_range                 IN      NUMBER,
        p_pol_line_cd           IN      gipi_polbasic.line_cd%TYPE,
        p_pol_subline_cd        IN      gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            IN      gipi_polbasic.iss_cd%TYPE,
        p_line_cd               IN      gipi_polbasic.line_cd%TYPE,
        p_subline_cd            IN      gipi_polbasic.subline_cd%TYPE,
        p_iss_cd                IN      gipi_polbasic.iss_cd%TYPE,
        p_cred_branch           IN      gipi_polbasic.cred_branch%TYPE, --benjo 11.12.2015 UW-SPECS-2015-087
        p_intm_no               IN      giex_expiry.intm_no%TYPE,
        p_plate_no              IN      gipi_vehicle.plate_no%TYPE,
        p_line_pack_pol_flag    IN      VARCHAR2,
        p_include_package       IN      VARCHAR2,
        p_pol_issue_yy          IN      NUMBER,
        p_pol_pol_seq_no        IN      NUMBER,
        p_pol_renew_no          IN      NUMBER,
        p_inc_special_sw        IN      VARCHAR2,
        p_def_is_pol_summ_sw    IN      VARCHAR2,
        p_def_same_polno_sw     IN      VARCHAR2,
        p_user_id               IN      giis_users.user_id%TYPE,
        p_msg                   OUT     VARCHAR2,
        p_policy_count          OUT     VARCHAR2
    );

    PROCEDURE update_balance_claim_flag(
        p_all_user  VARCHAR2,
        p_user      giex_expiry.extract_user%TYPE
    );

    PROCEDURE ar_validation(
        p_is_package            VARCHAR2,
        p_from_post_query       VARCHAR2,
        p_policy_id             giex_expiry.policy_id%TYPE,
        p_update_flag           giex_expiry.update_flag%TYPE,
        p_same_polno_sw         giex_expiry.same_polno_sw%TYPE,
        p_summary_sw            giex_expiry.summary_sw%TYPE,
        p_non_ren_reason        giex_expiry.non_ren_reason%TYPE,
        p_non_ren_reason_cd     giex_expiry.non_ren_reason_cd%TYPE,
        p_peril_pol_id      OUT giex_expiry.policy_id%TYPE,
        p_need_commit       OUT VARCHAR2,
        p_override_ok       OUT VARCHAR2,
        p_msg               OUT VARCHAR2
    );

     PROCEDURE update_f000_field(
        p_from_post_query   VARCHAR2,
        p_is_package        VARCHAR2,
        p_summary_sw        giex_pack_expiry.summary_sw%TYPE,
        p_same_polno_sw     giex_pack_expiry.same_polno_sw%TYPE,
        p_update_flag       giex_pack_expiry.update_flag%TYPE,
        p_balance_flag      giex_pack_expiry.balance_flag%TYPE,
        p_claim_flag        giex_pack_expiry.claim_flag%TYPE,
        p_reg_policy_sw     giex_pack_expiry.reg_policy_sw%TYPE,
        p_renew_flag        giex_pack_expiry.renew_flag%TYPE,
        p_remarks           giex_pack_expiry.remarks%TYPE,
        p_non_ren_reason_cd giex_pack_expiry.non_ren_reason_cd%TYPE,
        p_non_ren_reason    giex_pack_expiry.non_ren_reason%TYPE,
        p_policy_id         giex_pack_expiry.pack_policy_id%TYPE,
        p_processor         giex_expiry.processor%TYPE -- andrew - 09212015 - SR 4942
    );

    FUNCTION get_giexs007_b240_info (
        p_pack_policy_id    giex_expiry.pack_policy_id%TYPE,
        p_policy_id         giex_expiry.policy_id%TYPE
    )
    RETURN giex_expiry_tab PIPELINED;

    FUNCTION get_policy_id (
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
        p_req_renewal_no    VARCHAR2,
        p_prem_balance_only VARCHAR2,	--Gzelle 05202015 SR3703
        p_claims_only       VARCHAR2	--Gzelle 05202015 SR3698
    )
    RETURN giex_expiry_tab PIPELINED;

    FUNCTION check_policy_id_giexs006 (
        p_policy_id        giex_expiry.policy_id%TYPE
    )
    RETURN VARCHAR2;

    FUNCTION check_record_user_nr (
        p_policy_id        giex_expiry.policy_id%TYPE,
        p_assd_no        giex_expiry.assd_no%TYPE,
        p_intm_no        giex_expiry.intm_no%TYPE,
        p_iss_cd        giex_expiry.iss_cd%TYPE,
        p_subline_cd    giex_expiry.subline_cd%TYPE,
        p_line_cd        giex_expiry.line_cd%TYPE,
        p_start_date    giex_expiry.expiry_date%TYPE,
        p_end_date        giex_expiry.expiry_date%TYPE,
        p_user_id        giis_users.user_id%TYPE
    )
        RETURN VARCHAR2;

    TYPE pop_non_ren_notice_type IS RECORD (
        policy_id        giex_expiry.policy_id%TYPE
        /*line_cd            giex_expiry.line_cd%TYPE,
        line_name        giis_line.line_name%TYPE,
        iss_cd            giex_expiry.iss_cd%TYPE,
        non_ren_reason    giex_expiry.non_ren_reason%TYPE,
        intm_no            giex_expiry.intm_no%TYPE,
        ref_intm_cd        giis_intermediary.ref_intm_cd%TYPE,
        loc_risk        VARCHAR2(500),
        sign            VARCHAR2(200),
        des                VARCHAR2(200)*/
    );

    TYPE pop_non_ren_notice_tab IS TABLE OF pop_non_ren_notice_type;

    FUNCTION pop_non_ren_notice (
        p_policy_id        giex_expiry.policy_id%TYPE,
        p_assd_no        giex_expiry.assd_no%TYPE,
        p_intm_no        giex_expiry.intm_no%TYPE,
        p_iss_cd        giex_expiry.iss_cd%TYPE,
        p_subline_cd    giex_expiry.subline_cd%TYPE,
        p_line_cd        giex_expiry.line_cd%TYPE,
        p_start_date    giex_expiry.expiry_date%TYPE,
        p_end_date        giex_expiry.expiry_date%TYPE,
        p_user_id        giis_users.user_id%TYPE
    )
        RETURN pop_non_ren_notice_tab PIPELINED;

    FUNCTION get_sms_renewal_policies(
        p_line_cd       GIEX_EXPIRY.line_cd%TYPE,
        p_subline_cd    GIEX_EXPIRY.subline_cd%TYPE,
        p_iss_cd        GIEX_EXPIRY.iss_cd%TYPE,
        p_issue_yy      GIEX_EXPIRY.issue_yy%TYPE,
        p_pol_seq_no    GIEX_EXPIRY.pol_seq_no%TYPE,
        p_renew_no      GIEX_EXPIRY.renew_no%TYPE,
        p_tsi_amt       GIEX_EXPIRY.tsi_amt%TYPE,
        p_prem_amt      GIEX_EXPIRY.prem_amt%TYPE,
        p_expiry_date   VARCHAR2,
        p_policy_no     VARCHAR2,
        p_renew_flag    GIEX_EXPIRY.renew_flag%TYPE,
        p_user_id       GIEX_EXPIRY.user_id%TYPE -- marco - 05.26.2015 - GENQA SR 4485
    )
      RETURN sms_renewal_tab PIPELINED;

    PROCEDURE update_print_tag(
        p_policy_id     giex_expiry.policy_id%TYPE,
        p_is_pack       VARCHAR2,
        p_user_id       giex_expiry.extract_user%TYPE
    );

END giex_expiry_pkg; 
/


