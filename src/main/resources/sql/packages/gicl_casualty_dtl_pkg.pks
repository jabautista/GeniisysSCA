CREATE OR REPLACE PACKAGE CPI.GICL_CASUALTY_DTL_PKG
AS
   /**
   * Rey Jadlocon
   * 09-21-2011
   **/
   TYPE get_casualty_item_info_type IS RECORD
   (
      claim_no                 VARCHAR2 (50),
      policy_no                VARCHAR2 (50),
      line_cd                  gicl_claims.line_cd%TYPE,
      dsp_loss_date            gicl_claims.dsp_loss_date%TYPE,
      loss_date                gicl_claims.loss_date%TYPE,
      assured_name             gicl_claims.assured_name%TYPE,
      renew_no                 gicl_claims.renew_no%TYPE,
      loss_ctgry               VARCHAR2 (50),
      pol_seq_no               gicl_claims.pol_seq_no%TYPE,
      issue_yy                 gicl_claims.issue_yy%TYPE,
      pol_iss_cd               gicl_claims.pol_iss_cd%TYPE,
      subline_cd               gicl_claims.subline_cd%TYPE,
      expiry_date              gicl_claims.expiry_date%TYPE,
      pol_eff_date             gicl_claims.pol_eff_date%TYPE,
      claim_id                 gicl_claims.claim_id%TYPE,
      clm_stat_desc            giis_clm_stat.clm_stat_desc%TYPE,
      catastrophic_cd          gicl_claims.catastrophic_cd%TYPE,
      clm_file_date            gicl_claims.clm_file_date%TYPE,
      loss_cat_cd              gicl_claims.loss_cat_cd%TYPE,
      item_no                  gicl_item_peril.item_no%TYPE,
      peril_cd                 gicl_item_peril.peril_cd%TYPE,
      close_flag               gicl_item_peril.close_flag%TYPE,
      item_title               gicl_casualty_dtl.item_title%TYPE,
      grouped_item_no          gicl_casualty_dtl.grouped_item_no%TYPE,
      grouped_item_title       gicl_casualty_dtl.grouped_item_title%TYPE,
      currency_cd              gicl_casualty_dtl.currency_cd%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      currency_rate            gicl_casualty_dtl.currency_rate%TYPE,
      section_or_hazard_info   gicl_casualty_dtl.section_or_hazard_info%TYPE,
      section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_cd%TYPE,
      item_desc                gicl_clm_item.item_desc%TYPE,
      item_desc2               gicl_clm_item.item_desc2%TYPE,
      property_no              gicl_casualty_dtl.property_no%TYPE,
      property_no_type         gicl_casualty_dtl.property_no_type%TYPE,
      location                 gicl_casualty_dtl.LOCATION%TYPE,
      conveyance_info          gicl_casualty_dtl.conveyance_info%TYPE,
      interest_on_premises     gicl_casualty_dtl.interest_on_premises%TYPE,
      amount_coverage          gicl_casualty_dtl.amount_coverage%TYPE,
      limit_of_liability       gicl_casualty_dtl.limit_of_liability%TYPE,
      capacity_cd              gicl_casualty_dtl.capacity_cd%TYPE,
      position                 giis_position.position%TYPE,
      section_line_cd          GICL_CASUALTY_DTL.SECTION_LINE_CD%TYPE,
      section_subline_cd       GICL_CASUALTY_DTL.SECTION_SUBLINE_CD%TYPE,
      location_cd              GICL_CASUALTY_DTL.LOCATION_CD%TYPE,
      itm                      VARCHAR2 (10),
      gicl_item_peril_exist    VARCHAR2 (1),
      gicl_mortgagee_exist     VARCHAR2 (1),
      gicl_item_peril_msg      VARCHAR2 (1)
   );

   TYPE get_casualty_item_info_tab IS TABLE OF get_casualty_item_info_type;

   TYPE gicl_casualty_dtl_cur IS REF CURSOR
      RETURN get_casualty_item_info_type;

   FUNCTION get_casualty_item_lov (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN get_casualty_item_info_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 09-22-2011
   **/

   PROCEDURE extract_latest_grouped (
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_subline_cd            gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy              gicl_claims.issue_yy%TYPE,
      p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      p_renew_no              gicl_claims.renew_no%TYPE,
      p_expiry_date           gicl_claims.expiry_date%TYPE,
      p_loss_date             gicl_claims.loss_date%TYPE,
      p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,
      p_item_no               gipi_item.item_no%TYPE,
      p_grouped_item_no       gicl_casualty_dtl.grouped_item_no%TYPE,
      grouped             OUT get_casualty_item_info_type);

   /**
   * Rey Jadlocon
   * 09-22-2011
   **/
   PROCEDURE extract_latest_CAdata (
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_subline_cd            gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy              gicl_claims.issue_yy%TYPE,
      p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      p_renew_no              gicl_claims.renew_no%TYPE,
      p_expiry_date           gicl_claims.expiry_date%TYPE,
      p_loss_date             gicl_claims.loss_date%TYPE,
      p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,
      p_item_no               gipi_item.item_no%TYPE,
      CAData           IN OUT get_casualty_item_info_type);

   /**
   * Rey Jadlocon
   * 09-28-2011
   **/

   FUNCTION check_casualty_item_no (
      p_claim_id     gicl_casualty_dtl.claim_id%TYPE,
      p_item_no      gicl_casualty_dtl.item_no%TYPE,
      p_start_row    VARCHAR2,
      p_end_row      VARCHAR2)
      RETURN VARCHAR2;

   /**
   * Rey Jadlocon
   * 09-28-2011
   **/

   FUNCTION check_existing_item (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date    gipi_polbasic.eff_date%TYPE,
      p_expiry_date     gipi_polbasic.expiry_date%TYPE,
      p_loss_date       gipi_polbasic.expiry_date%TYPE,
      p_item_no         gipi_item.item_no%TYPE)
      RETURN NUMBER;

   /**
   * Rey Jadlocon
   * 09-28-2011
   **/

   PROCEDURE validate_gicl_casualty_dtl (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date       gipi_polbasic.eff_date%TYPE,
      p_expiry_date        gipi_polbasic.expiry_date%TYPE,
      p_loss_date          gipi_polbasic.expiry_date%TYPE,
      p_incept_date        gipi_polbasic.incept_date%TYPE,
      p_item_no            gipi_item.item_no%TYPE,
      p_claim_id           gicl_casualty_dtl.claim_id%TYPE,
      p_from               VARCHAR2,
      p_to                 VARCHAR2,
      casaulty         OUT GICL_CASUALTY_DTL_PKG.gicl_casualty_dtl_cur,
      p_item_exist     OUT NUMBER,
      p_override_fl    OUT VARCHAR2,
      p_tloss_fl       OUT VARCHAR2,
      p_item_exist2    OUT VARCHAR2);

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   PROCEDURE extract_casualty_data (
      p_line_cd             gipi_polbasic.line_cd%TYPE,
      p_subline_cd          gipi_polbasic.subline_cd%TYPE,
      p_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            gipi_polbasic.renew_no%TYPE,
      p_item_no             gipi_item.item_no%TYPE,
      p_claim_id            gicl_claims.claim_id%TYPE,
      casualty_dtl   IN OUT get_casualty_item_info_type);

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   FUNCTION get_casualty_dtl (
      p_line_cd         gipi_polbasic.line_cd%TYPE,
      p_subline_cd      gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        gipi_polbasic.renew_no%TYPE,
      p_item_no         gipi_item.item_no%TYPE,
      p_expiry_date     GIPI_POLBASIC.EXPIRY_DATE%TYPE,
      p_loss_date       GICL_CASUALTY_DTL.LOSS_DATE%TYPE,
      p_pol_eff_date    GIPI_POLBASIC.EFF_DATE%TYPE,
      p_claim_id        gicl_claims.claim_id%TYPE)
      RETURN get_casualty_item_info_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   TYPE personnel_list_type IS RECORD
   (
      personnel_no     gicl_casualty_personnel.personnel_no%TYPE,
      name             gicl_casualty_personnel.name%TYPE,
      capacity_cd      gicl_casualty_personnel.capacity_cd%TYPE,
      amount_covered   gicl_casualty_personnel.amount_covered%TYPE,
      position         giis_position.position%TYPE,
      position_cd      giis_position.position_cd%TYPE
   );

   TYPE personnel_list_tab IS TABLE OF personnel_list_type;

   FUNCTION get_personnel (
      p_item_no        gicl_casualty_personnel.item_no%TYPE,
      p_capacity_cd    gicl_casualty_personnel.capacity_cd%TYPE)
      RETURN personnel_list_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 09-29-2011
   **/

   PROCEDURE set_gicl_casualty_dtl (
      p_amount_coverage           gicl_casualty_dtl.amount_coverage%TYPE,
      p_capacity_cd               gicl_casualty_dtl.capacity_cd%TYPE,
      p_claim_id                  gicl_casualty_dtl.claim_id%TYPE,
      p_conveyance_info           gicl_casualty_dtl.conveyance_info%TYPE,
      p_cpi_branch_cd             gicl_casualty_dtl.cpi_branch_cd%TYPE,
      p_cpi_rec_no                gicl_casualty_dtl.cpi_rec_no%TYPE,
      p_currency_cd               gicl_casualty_dtl.currency_cd%TYPE,
      p_loss_date                 gicl_casualty_dtl.loss_date%TYPE,
      p_currency_rate             gicl_casualty_dtl.currency_rate%TYPE,
      p_grouped_item_no           gicl_casualty_dtl.grouped_item_no%TYPE,
      p_grouped_item_title        gicl_casualty_dtl.grouped_item_title%TYPE,
      p_interest_on_premises      gicl_casualty_dtl.interest_on_premises%TYPE,
      p_item_no                   gicl_casualty_Dtl.item_no%TYPE,
      p_item_title                gicl_casualty_dtl.item_title%TYPE,
      p_last_update               gicl_casualty_dtl.last_update%TYPE,
      p_limit_of_liability        gicl_casualty_dtl.limit_of_liability%TYPE,
      p_location                  gicl_casualty_dtl.location%TYPE,
      p_location_cd               gicl_casualty_dtl.location_cd%TYPE,
      p_property_no               gicl_casualty_dtl.property_no%TYPE,
      p_property_no_type          gicl_casualty_dtl.property_no_type%TYPE,
      p_section_line_cd           gicl_casualty_dtl.section_line_cd%TYPE,
      p_section_or_hazard_cd      gicl_casualty_dtl.section_or_hazard_cd%TYPE,
      p_section_or_hazard_info    gicl_casualty_dtl.section_or_hazard_info%TYPE,
      p_section_subline_cd        gicl_casualty_dtl.section_subline_cd%TYPE,
      p_user_id                   gicl_casualty_dtl.user_id%TYPE);

   /**
   * Rey Jadlocon
   * 10-03-2011
   **/
   TYPE position_type IS RECORD
   (
      position      giis_position.position%TYPE,
      position_cd   giis_position.position_cd%TYPE
   );

   TYPE position_tab IS TABLE OF position_type;

   FUNCTION get_position (p_position_cd giis_position.position_cd%TYPE)
      RETURN position_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 10-03-2011
   **/

   TYPE get_personnel_dtl_type IS RECORD
   (
      name             gicl_casualty_personnel.name%TYPE,
      capacity_cd      gicl_casualty_personnel.capacity_cd%TYPE,
      include_tag      gicl_casualty_personnel.include_tag%TYPE,
      amount_covered   gicl_casualty_personnel.amount_covered%TYPE,
      position         giis_position.position%TYPE,
      user_id          giis_position.user_id%TYPE,
      last_update      gicl_casualty_dtl.last_update%TYPE
   );

   TYPE personnel_dtl_tab IS TABLE OF get_personnel_dtl_type;

   TYPE gicl_personnel_dtl_cur IS REF CURSOR
      RETURN get_personnel_dtl_type;


   PROCEDURE extract_latest_personel (
      p_line_cd               gipi_polbasic.line_cd%TYPE,
      p_subline_cd            gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
      p_issue_yy              gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no              gipi_polbasic.renew_no%TYPE,
      p_item_no               gipi_item.item_no%TYPE,
      p_claim_id              gicl_claims.claim_id%TYPE,
      p_personnel_no          gicl_casualty_personnel.personnel_no%TYPE,
      p_loss_date             gicl_casualty_dtl.loss_date%TYPE,
      p_expiry_date           gicl_casualty_dtl.loss_date%TYPE,
      p_pol_eff_date          gicl_casualty_dtl.loss_date%TYPE,
      p_capacity_cd           gicl_casualty_dtl.capacity_cd%TYPE,
      personnel_dtl    IN OUT get_personnel_dtl_type);

   /**
   * Rey Jadlocon
   * 10-04-2011
   **/
   TYPE get_personnel_type IS RECORD
   (
      endt_seq_no      gipi_polbasic.endt_seq_no%TYPE,
      name             gicl_casualty_personnel.name%TYPE,
      capacity_cd      gicl_casualty_personnel.capacity_cd%TYPE,
      include_tag      gicl_casualty_personnel.include_tag%TYPE,
      amount_covered   gicl_casualty_personnel.amount_covered%TYPE
   );

   TYPE get_personnel_tab IS TABLE OF get_personnel_type;

   TYPE gicl_personnel_cur IS REF CURSOR
      RETURN get_personnel_type;


   FUNCTION get_personnel_list (
      p_claim_id        gicl_casualty_dtl.claim_id%TYPE,
      p_item_no         gicl_casualty_dtl.item_no%TYPE,
      p_capacity_cd     gicl_casualty_dtl.capacity_cd%TYPE,
      p_personnel_no    gicl_casualty_personnel.personnel_no%TYPE)
      RETURN personnel_dtl_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 10-13-2011
   **/

   TYPE gicl_casualty_dtl_type IS RECORD
   (
      claim_id                 gicl_casualty_dtl.claim_id%TYPE,
      item_no                  gicl_casualty_dtl.item_no%TYPE,
      currency_cd              gicl_casualty_dtl.currency_cd%TYPE,
      user_id                  gicl_casualty_dtl.user_id%TYPE,
      last_update              gicl_casualty_dtl.last_update%TYPE,
      loss_date                gicl_casualty_dtl.loss_date%TYPE,
      item_title               gicl_casualty_dtl.item_title%TYPE,
      section_line_cd          gicl_casualty_dtl.section_line_cd%TYPE,
      section_subline_cd       gicl_casualty_dtl.section_subline_cd%TYPE,
      section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_cd%TYPE,
      capacity_cd              gicl_casualty_dtl.capacity_cd%TYPE,
      property_no_type         gicl_casualty_dtl.property_no_type%TYPE,
      property_no              gicl_casualty_dtl.property_no%TYPE,
      location                 gicl_casualty_dtl.location%TYPE,
      conveyance_info          gicl_casualty_dtl.conveyance_info%TYPE,
      interest_on_premises     gicl_casualty_dtl.interest_on_premises%TYPE,
      limit_of_liability       gicl_casualty_dtl.limit_of_liability%TYPE,
      section_or_hazard_info   gicl_casualty_dtl.section_or_hazard_info%TYPE,
      grouped_item_no          gicl_casualty_dtl.grouped_item_no%TYPE,
      grouped_item_title       gicl_casualty_dtl.grouped_item_title%TYPE,
      amount_coverage          gicl_casualty_dtl.amount_coverage%TYPE,
      cpi_rec_no               gicl_casualty_dtl.cpi_rec_no%TYPE,
      cpi_branch_cd            gicl_casualty_dtl.cpi_branch_cd%TYPE,
      currency_rate            gicl_casualty_dtl.currency_rate%TYPE,
      location_cd              gicl_casualty_dtl.location_cd%TYPE,
      item_desc                gicl_clm_item.item_desc%TYPE,
      item_desc2               gicl_clm_item.item_desc2%TYPE,
      position                 giis_position.position%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      msg_alert                VARCHAR2 (32000),
      gicl_item_peril_exist    VARCHAR2 (1),
      gicl_mortgagee_exist     VARCHAR2 (1),
      gicl_item_peril_msg      VARCHAR2 (1)
   );

   TYPE gicl_casualty_dtl_tab IS TABLE OF gicl_casualty_dtl_type;

   FUNCTION get_gicl_casualty_dtl (
      p_claim_id gicl_casualty_dtl.claim_id%TYPE)
      RETURN gicl_casualty_dtl_tab
      PIPELINED;

   /**
   * Rey Jadlocon
   * 10-14-2011
   **/

   PROCEDURE del_gicl_casualty_dtl (
      p_claim_id    gicl_casualty_dtl.claim_id%TYPE,
      p_item_no     gicl_casualty_dtl.item_no%TYPE);

   FUNCTION get_gicl_casualty_dtl_exist (
      p_claim_id gicl_casualty_dtl.claim_id%TYPE)
      RETURN VARCHAR2;

   /**
   * Rey Jadlocon
   * 04-20-2012
   **/

   TYPE group_list_type IS RECORD (group_no NUMBER);

   TYPE group_list_tab IS TABLE OF group_list_type;


   FUNCTION get_group_lov (p_line_cd         VARCHAR2,
                           p_subline_cd      VARCHAR2,
                           p_pol_iss_cd      VARCHAR2,
                           p_issue_yy        NUMBER,
                           p_pol_seq_no      NUMBER,
                           p_renew_no        NUMBER,
                           p_pol_eff_date    DATE,
                           p_loss_date       DATE,
                           p_item_no         NUMBER,
                           p_expiry_date     DATE)
      RETURN group_list_tab
      PIPELINED;


   PROCEDURE validate_Group_ItemNo (
      p_line_cd                gipi_polbasic.line_cd%TYPE,
      p_subline_cd             gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy               gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no               gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date           gipi_polbasic.eff_date%TYPE,
      p_expiry_date            gipi_polbasic.expiry_date%TYPE,
      p_loss_date              gipi_polbasic.expiry_date%TYPE,
      p_item_no                gipi_item.item_no%TYPE,
      p_grouped_item_no        NUMBER,
      grouped_item_title   OUT gicl_casualty_dtl.grouped_item_title%TYPE,
      amount_coverage      OUT gicl_casualty_dtl.amount_coverage%TYPE,
      exist                OUT VARCHAR2);

   PROCEDURE validate_personnel_no (
      p_line_cd            gipi_polbasic.line_cd%TYPE,
      p_subline_cd         gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd         gipi_polbasic.iss_cd%TYPE,
      p_issue_yy           gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no         gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no           gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date       gipi_polbasic.eff_date%TYPE,
      p_expiry_date        gipi_polbasic.expiry_date%TYPE,
      p_loss_date          gipi_polbasic.expiry_date%TYPE,
      p_item_no            gipi_item.item_no%TYPE,
      p_claim_id           gicl_claims.claim_id%TYPE,
      p_personnel_no       gicl_casualty_personnel.capacity_cd%TYPE,
      name         out      GICL_CASUALTY_PERSONNEL.name%TYPE,
      capacity_cd      OUT VARCHAR2,
      amount_covered   OUT GICL_CASUALTY_PERSONNEL.amount_covered%TYPE,
      position         OUT giis_position.position%TYPE);

    TYPE gicl_casualty_gicls260_type IS RECORD -- bonok :: 05.15.2013 :: for GICLS260
   (
      claim_id                 gicl_casualty_dtl.claim_id%TYPE,
      item_no                  gicl_casualty_dtl.item_no%TYPE,
      currency_cd              gicl_casualty_dtl.currency_cd%TYPE,
      user_id                  gicl_casualty_dtl.user_id%TYPE,
      last_update              gicl_casualty_dtl.last_update%TYPE,
      loss_date                gicl_casualty_dtl.loss_date%TYPE,
      item_title               gicl_casualty_dtl.item_title%TYPE,
      section_line_cd          gicl_casualty_dtl.section_line_cd%TYPE,
      section_subline_cd       gicl_casualty_dtl.section_subline_cd%TYPE,
      section_or_hazard_cd     gicl_casualty_dtl.section_or_hazard_cd%TYPE,
      capacity_cd              gicl_casualty_dtl.capacity_cd%TYPE,
      property_no_type         gicl_casualty_dtl.property_no_type%TYPE,
      property_no              gicl_casualty_dtl.property_no%TYPE,
      location                 gicl_casualty_dtl.location%TYPE,
      conveyance_info          gicl_casualty_dtl.conveyance_info%TYPE,
      interest_on_premises     gicl_casualty_dtl.interest_on_premises%TYPE,
      limit_of_liability       gicl_casualty_dtl.limit_of_liability%TYPE,
      section_or_hazard_info   gicl_casualty_dtl.section_or_hazard_info%TYPE,
      grouped_item_no          gicl_casualty_dtl.grouped_item_no%TYPE,
      grouped_item_title       gicl_casualty_dtl.grouped_item_title%TYPE,
      amount_coverage          gicl_casualty_dtl.amount_coverage%TYPE,
      cpi_rec_no               gicl_casualty_dtl.cpi_rec_no%TYPE,
      cpi_branch_cd            gicl_casualty_dtl.cpi_branch_cd%TYPE,
      currency_rate            gicl_casualty_dtl.currency_rate%TYPE,
      location_cd              gicl_casualty_dtl.location_cd%TYPE,
      item_desc                gicl_clm_item.item_desc%TYPE,
      item_desc2               gicl_clm_item.item_desc2%TYPE,
      position                 giis_position.position%TYPE,
      currency_desc            giis_currency.currency_desc%TYPE,
      msg_alert                VARCHAR2 (32000),
      gicl_item_peril_exist    VARCHAR2 (1),
      gicl_mortgagee_exist     VARCHAR2 (1),
      gicl_item_peril_msg      VARCHAR2 (1),
      personnel_no             gicl_casualty_personnel.personnel_no%TYPE,
      name                     gicl_casualty_personnel.name%TYPE,
      pers_capacity_cd         gicl_casualty_personnel.capacity_cd%TYPE,
      nbt_position             giis_position.position%TYPE,
      amount_covered           gicl_casualty_personnel.amount_covered%TYPE,
      detail                   NUMBER,
      dsp_currency_desc        giis_currency.currency_desc%TYPE,
      loss_date_char           VARCHAR(30)      --shan 04.15.2014
   );

   TYPE gicl_casualty_gicls260_tab IS TABLE OF gicl_casualty_gicls260_type;
   
   FUNCTION get_casualty_dtl_gicls260 (
      p_claim_id gicl_casualty_dtl.claim_id%TYPE
   ) RETURN gicl_casualty_gicls260_tab PIPELINED;
   
END GICL_CASUALTY_DTL_PKG;
/


