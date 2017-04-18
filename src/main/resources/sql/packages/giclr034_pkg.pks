CREATE OR REPLACE PACKAGE CPI.giclr034_pkg
AS
   TYPE giclr034_type IS RECORD (
      claim_id          gicl_claims.claim_id%TYPE,
      line_cd           gicl_claims.line_cd%TYPE,
      subline_cd        gicl_claims.subline_cd%TYPE,
      pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      issue_yy          gicl_claims.issue_yy%TYPE,
      pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      renew_no          gicl_claims.renew_no%TYPE,
      claim_number      VARCHAR2 (100),
      policy_number     VARCHAR2 (100),
      loss_location     VARCHAR2 (1000),
      uw_year           VARCHAR2 (2),
      assd_no           gicl_claims.assd_no%TYPE,
      assured_name      gicl_claims.assured_name%TYPE,
      address           VARCHAR (1000),
      issue_date        gipi_polbasic.issue_date%TYPE,
      dsp_loss_date     gicl_claims.dsp_loss_date%TYPE, 
      loss_date         gicl_claims.loss_date%TYPE,
      clm_file_date     gicl_claims.clm_file_date%TYPE,
      pol_eff_date      gicl_claims.pol_eff_date%TYPE,
      expiry_date       gicl_claims.expiry_date%TYPE,
      in_hou_adj        gicl_claims.in_hou_adj%TYPE,
      recovery_sw       gicl_claims.recovery_sw%TYPE,
      remarks           gicl_claims.remarks%TYPE,
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      clm_stat_desc     giis_clm_stat.clm_stat_desc%TYPE,
      loss_dtls         gicl_claims.loss_dtls%TYPE,
      city_cd           gicl_claims.city_cd%TYPE,
      province_cd       gicl_claims.province_cd%TYPE,
      acct_of_cd        gicl_claims.acct_of_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      user_name         giis_users.user_name%TYPE,
      contact_no        giis_assured.phone_no%TYPE,
      leased_to_label   VARCHAR2 (50),
      leased_to         VARCHAR2 (200),
      currency          giis_currency.short_name%TYPE,
      deductible_amt    gipi_deductibles.deductible_amt%TYPE,
      mortgagee         giis_mortgagee.mortg_name%TYPE,
      intermediary      giis_intermediary.intm_name%TYPE,
      deductible2       gipi_deductibles.deductible_amt%TYPE,
      no_of_claims      NUMBER,
      tot_pd_amt        NUMBER,
      tot_res_amt       NUMBER,
      tot_os            NUMBER,
      ri_name           giis_reinsurer.ri_name%TYPE
   );

   TYPE giclr034_tab IS TABLE OF giclr034_type;

   FUNCTION populate_giclr034 (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN giclr034_tab PIPELINED;

   TYPE q_policy_type IS RECORD (
      endt_no       VARCHAR2 (100),
      issue_date    gipi_polbasic.issue_date%TYPE,
      eff_date      gipi_polbasic.eff_date%TYPE,
      endt_seq_no   gipi_polbasic.endt_seq_no%TYPE
   );

   TYPE q_policy_tab IS TABLE OF q_policy_type;

   FUNCTION get_q_policy (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_policy_tab PIPELINED;

   TYPE q_motor_car_type IS RECORD (
      item_no             gicl_motor_car_dtl.item_no%TYPE,
      item_title          gicl_motor_car_dtl.item_title%TYPE,
      plate_no            gicl_motor_car_dtl.plate_no%TYPE,
      motor_no            gicl_motor_car_dtl.motor_no%TYPE,
      serial_no           gicl_motor_car_dtl.serial_no%TYPE,
      model_year          gicl_motor_car_dtl.model_year%TYPE,
      color               gicl_motor_car_dtl.color%TYPE,
      drvr_name           gicl_motor_car_dtl.drvr_name%TYPE,
      drvr_age            gicl_motor_car_dtl.drvr_age%TYPE,
      car_company         giis_mc_car_company.car_company%TYPE,
      make                giis_mc_make.make%TYPE,
      subline_cd          giis_mc_subline_type.subline_cd%TYPE,
      subline_type_desc   giis_mc_subline_type.subline_type_desc%TYPE
   );

   TYPE q_motor_car_tab IS TABLE OF q_motor_car_type;

   FUNCTION get_q_motor_car (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_motor_car_tab PIPELINED;

   TYPE q_adjuster_type IS RECORD (
      adj_company_cd   gicl_clm_adjuster.adj_company_cd%TYPE,
      adjuster         VARCHAR2 (1000)
   );

   TYPE q_adjuster_tab IS TABLE OF q_adjuster_type;

   FUNCTION get_q_adjuster_company (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_adjuster_tab PIPELINED;

   TYPE q_motorshop_type IS RECORD (
      motorshop   VARCHAR2 (1000)
   );

   TYPE q_motorshop_tab IS TABLE OF q_motorshop_type;

   FUNCTION get_q_motorshop (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN q_motorshop_tab PIPELINED;

   TYPE q_item_type IS RECORD (
      item_no           gicl_clm_item.item_no%TYPE,
      grouped_item_no   gicl_clm_item.grouped_item_no%TYPE,
      item              VARCHAR2 (500),
      currency          giis_currency.short_name%TYPE,
      grouped_item      VARCHAR2 (500)
   );

   TYPE q_item_tab IS TABLE OF q_item_type;

   FUNCTION get_q_claim_item (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN q_item_tab PIPELINED;

   TYPE q_item_peril_type IS RECORD (
      peril_cd     gipi_itmperil.peril_cd%TYPE,
      peril_name   giis_peril.peril_name%TYPE,
      tsi          NUMBER
   );

   TYPE q_item_peril_tab IS TABLE OF q_item_peril_type;

   FUNCTION get_q_claim_item_peril (p_claim_id gicl_claims.claim_id%TYPE, p_item_no gicl_clm_item.item_no%TYPE)
      RETURN q_item_peril_tab PIPELINED;

   FUNCTION get_q_reserve_item (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN q_item_tab PIPELINED;

   TYPE q_reserve_type IS RECORD (
      peril_cd          gicl_item_peril.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE,
      loss_reserve      gicl_clm_reserve.loss_reserve%TYPE,
      loss_short_name   giis_currency.short_name%TYPE,
      expense_reserve   gicl_clm_reserve.expense_reserve%TYPE,
      exp_short_name    giis_currency.short_name%TYPE
   );

   TYPE q_reserve_tab IS TABLE OF q_reserve_type;

   FUNCTION get_q_reserve (p_claim_id gicl_claims.claim_id%TYPE, p_item_no gicl_clm_item.item_no%TYPE)
      RETURN q_reserve_tab PIPELINED;

   TYPE reserve_hist_type IS RECORD (
      item_no           gicl_item_peril.item_no%TYPE,
      peril_cd          gicl_item_peril.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      loss_reserve      gicl_clm_reserve.loss_reserve%TYPE,
      loss_short_name   giis_currency.short_name%TYPE,
      expense_reserve   gicl_clm_reserve.expense_reserve%TYPE,
      exp_short_name    giis_currency.short_name%TYPE,
      user_id           gicl_clm_res_hist.user_id%TYPE,
      setup_date        VARCHAR2 (50),
      setup_by          gicl_clm_res_hist.setup_by%TYPE,
      remarks           gicl_clm_res_hist.remarks%TYPE
   );

   TYPE reserve_hist_tab IS TABLE OF reserve_hist_type;

   FUNCTION get_reserve_history (p_claim_id gicl_claims.claim_id%TYPE, p_line_cd gicl_claims.line_cd%TYPE)
      RETURN reserve_hist_tab PIPELINED;

   TYPE premium_payment_type IS RECORD (
      ref_no        VARCHAR (100),
      premium_amt   NUMBER,
      tran_date     giac_acctrans.tran_date%TYPE,
      short_name    giis_currency.short_name%TYPE
   );

   TYPE premium_payment_tab IS TABLE OF premium_payment_type;

   FUNCTION get_premium_payments (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN premium_payment_tab PIPELINED;

   TYPE dist_share_type IS RECORD (
      share_type   giis_dist_share.share_type%TYPE,
      share_name   VARCHAR2 (50)
   );

   TYPE dist_share_tab IS TABLE OF dist_share_type;

   FUNCTION get_dist_share (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN dist_share_tab PIPELINED;

   TYPE uw_dist_type IS RECORD (
      shr_tsi_amt   NUMBER,
      short_name    giis_currency.short_name%TYPE
   );

   TYPE uw_dist_tab IS TABLE OF uw_dist_type;

   FUNCTION get_uw_dist (p_claim_id gicl_claims.claim_id%TYPE, p_share_type giis_dist_share.share_type%TYPE)
      RETURN uw_dist_tab PIPELINED;

   TYPE uw_ri_type IS RECORD (
      ri_cd        giis_reinsurer.ri_cd%TYPE,
      ri_name      giis_reinsurer.ri_name%TYPE,
      binder_no    VARCHAR2 (100),
      ri_shr_pct   giri_binder.ri_shr_pct%TYPE,
      ri_tsi_amt   giri_binder.ri_tsi_amt%TYPE,
      short_name   giis_currency.short_name%TYPE
   );

   TYPE uw_ri_tab IS TABLE OF uw_ri_type;

   FUNCTION get_uw_ri (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN uw_ri_tab PIPELINED;

   TYPE reserve_dist_type IS RECORD (
      shr_res_amt   NUMBER,
      short_name    giis_currency.short_name%TYPE
   );

   TYPE reserve_dist_tab IS TABLE OF reserve_dist_type;

   FUNCTION get_reserve_dist (p_claim_id gicl_claims.claim_id%TYPE, p_share_type giis_dist_share.share_type%TYPE)
      RETURN reserve_dist_tab PIPELINED;

   TYPE reserve_ri_type IS RECORD (
      ri_cd        giis_reinsurer.ri_cd%TYPE,
      ri_name      giis_reinsurer.ri_name%TYPE,
      pla_no       VARCHAR2 (100),
      ri_shr_pct   giri_binder.ri_shr_pct%TYPE,
      pla_amt      NUMBER,
      short_name   giis_currency.short_name%TYPE
   );

   TYPE reserve_ri_tab IS TABLE OF reserve_ri_type;

   FUNCTION get_reserve_ri (p_claim_id gicl_claims.claim_id%TYPE, p_total_loss NUMBER, p_total_exp NUMBER)
      RETURN reserve_ri_tab PIPELINED;

   TYPE document_type IS RECORD (
      clm_doc_cd      gicl_clm_docs.clm_doc_cd%TYPE,
      clm_doc_desc    gicl_clm_docs.clm_doc_desc%TYPE,
      doc_cmpltd_dt   gicl_reqd_docs.doc_cmpltd_dt%TYPE
   );

   TYPE document_tab IS TABLE OF document_type;

   FUNCTION get_documents (
      p_claim_id     gicl_claims.claim_id%TYPE,
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN document_tab PIPELINED;

   TYPE payments_type IS RECORD (
      claim_id                gicl_claims.claim_id%TYPE,
      advice_id               gicl_advice.claim_id%TYPE,
      item_no                 gicl_clm_loss_exp.item_no%TYPE,
      peril_cd                gicl_clm_loss_exp.peril_cd%TYPE,
      clm_loss_id             gicl_clm_loss_exp.clm_loss_id%TYPE,
      payee_cd                gicl_clm_loss_exp.payee_cd%TYPE,
      payee_class_cd          gicl_clm_loss_exp.payee_class_cd%TYPE,
      tran_id                 gicl_clm_loss_exp.tran_id%TYPE,
      item_peril              VARCHAR2 (10),
      paid_amt                NUMBER,
      currency_cd             gicl_advice.currency_cd%TYPE,
      short_name              giis_currency.short_name%TYPE,
      CATEGORY                VARCHAR2 (50),
      payee_address           VARCHAR2 (2000),
      tran_no                 VARCHAR2 (20),
      dv_date                 giac_disb_vouchers.dv_date%TYPE,
      check_no                giac_chk_disbursement.check_no%TYPE,
      date_released           giac_payt_requests.request_date%TYPE,
      released                VARCHAR2 (1),
      tot_payt_released_net   NUMBER
   );

   TYPE payments_tab IS TABLE OF payments_type;

   FUNCTION get_payments (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN payments_tab PIPELINED;

   TYPE recovery_type IS RECORD (
      recovery_no       VARCHAR2 (100),
      short_name        giis_currency.short_name%TYPE,
      payor             VARCHAR2 (1000),
      reference_no      VARCHAR2 (100),
      recovered_amt     gicl_recovery_payt.recovered_amt%TYPE,
      tot_rec_amt_net   NUMBER
   );

   TYPE recovery_tab IS TABLE OF recovery_type;

   FUNCTION get_recoveries (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN recovery_tab PIPELINED;

   TYPE summary_type IS RECORD (
      tran_year     NUMBER,
      short_name    giis_currency.short_name%TYPE,
      os_reserves   NUMBER,
      payments      NUMBER,
      reserve_adj   NUMBER
   );

   TYPE summary_tab IS TABLE OF summary_type;

   FUNCTION get_summary (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN summary_tab PIPELINED;

   TYPE fire_type IS RECORD (
      item_no         gicl_clm_item.item_no%TYPE,
      item_title      gicl_clm_item.item_title%TYPE,
      district_no     gicl_fire_dtl.district_no%TYPE,
      block_id        gicl_fire_dtl.block_id%TYPE,
      block_no        gicl_fire_dtl.block_no%TYPE,
      ann_tsi_amt     NUMBER,
      district_desc   giis_block.district_desc%TYPE,
      block_desc      giis_block.block_desc%TYPE,
      short_name      giis_currency.short_name%TYPE
   );

   TYPE fire_tab IS TABLE OF fire_type;

   FUNCTION get_fire (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN fire_tab PIPELINED;

   TYPE cargo_type IS RECORD (
      item_no           gicl_clm_item.item_no%TYPE,
      item_title        gicl_clm_item.item_title%TYPE,
      vessel_cd         gicl_cargo_dtl.vessel_cd%TYPE,
      cargo_type        gicl_cargo_dtl.cargo_type%TYPE,
      origin            gicl_cargo_dtl.origin%TYPE,
      destn             gicl_cargo_dtl.destn%TYPE,
      vessel_name       giis_vessel.vessel_name%TYPE,
      cargo_type_desc   giis_cargo_type.cargo_type_desc%TYPE
   );

   TYPE cargo_tab IS TABLE OF cargo_type;

   FUNCTION get_cargo (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN cargo_tab PIPELINED;

   TYPE casualty_type IS RECORD (
      item_no       gicl_clm_item.item_no%TYPE,
      item_title    gicl_clm_item.item_title%TYPE,
      ann_tsi_amt   NUMBER,
      short_name    giis_currency.short_name%TYPE
   );

   TYPE casualty_tab IS TABLE OF casualty_type;

   FUNCTION get_casualty (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN casualty_tab PIPELINED;

   TYPE accident_type IS RECORD (
      item_no            gicl_clm_item.item_no%TYPE,
      beneficiary_name   gicl_beneficiary_dtl.beneficiary_name%TYPE,
      date_of_birth      gicl_beneficiary_dtl.date_of_birth%TYPE,
      age                gicl_beneficiary_dtl.age%TYPE,
      relation           gicl_beneficiary_dtl.relation%TYPE
   );

   TYPE accident_tab IS TABLE OF accident_type;

   FUNCTION get_accident (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN accident_tab PIPELINED;

   TYPE oldest_os_prem_type IS RECORD (
      policy_id        gipi_polbasic.policy_id%TYPE,
      oldest_os_prem   VARCHAR2 (20)
   );

   TYPE oldest_os_prem_tab IS TABLE OF oldest_os_prem_type;

   FUNCTION get_oldest_os_prem (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN oldest_os_prem_tab PIPELINED;

   TYPE signatory_type IS RECORD (
      label         giac_rep_signatory.label%TYPE,
      signatory     giis_signatory_names.signatory%TYPE,
      designation   giis_signatory_names.designation%TYPE
   );

   TYPE signatory_tab IS TABLE OF signatory_type;

   FUNCTION get_signatory (p_line_cd giis_line.line_cd%TYPE)
      RETURN signatory_tab PIPELINED;

   TYPE ri_recovery_share_type IS RECORD (
      share_type        gicl_advs_fla.share_type%TYPE,
      share_type_desc   VARCHAR2 (50)
   );

   TYPE ri_recovery_share_tab IS TABLE OF ri_recovery_share_type;

   FUNCTION get_ri_recovery_share (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN ri_recovery_share_tab PIPELINED;
      
   TYPE ri_recovery_type IS RECORD (
      ri_cd             gicl_advs_fla.ri_cd%TYPE,
      recy_trn          VARCHAR2 (20),
      amount            NUMBER,
      short_name        giis_currency.short_name%TYPE, 
      ri_name           giis_reinsurer.ri_name%TYPE,
      request_date      giac_payt_requests.request_date%TYPE,
      csr_no            VARCHAR2 (100),
      item_peril        VARCHAR2 (20),
      category          VARCHAR2 (20)
   );

   TYPE ri_recovery_tab IS TABLE OF ri_recovery_type;

   FUNCTION get_ri_recovery (
     p_claim_id gicl_claims.claim_id%TYPE,
     p_share_type   gicl_loss_exp_rids.share_type%TYPE)
      RETURN ri_recovery_tab PIPELINED;
          
END;
/


