CREATE OR REPLACE PACKAGE CPI.gicl_motor_car_dtl_pkg
AS
/******************************************************************************
   NAME:       GICL_MOTOR_CAR_DTL_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/23/2011  Irwin Tabisora  1. Created this package.
******************************************************************************/
   TYPE gicl_motor_car_dtl_type IS RECORD (
      claim_id                gicl_motor_car_dtl.claim_id%TYPE,
      item_no                 gicl_motor_car_dtl.item_no%TYPE,
      motor_no                gicl_motor_car_dtl.motor_no%TYPE,
      user_id                 gicl_motor_car_dtl.user_id%TYPE,
      item_title              gicl_motor_car_dtl.item_title%TYPE,
      model_year              gicl_motor_car_dtl.model_year%TYPE,
      plate_no                gicl_motor_car_dtl.plate_no%TYPE,
      drvr_occ_cd             gicl_motor_car_dtl.drvr_occ_cd%TYPE,
      drvr_name               gicl_motor_car_dtl.drvr_name%TYPE,
      drvr_sex                gicl_motor_car_dtl.drvr_sex%TYPE,
      drvr_age                gicl_motor_car_dtl.drvr_age%TYPE,
      motcar_comp_cd          gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      make_cd                 gicl_motor_car_dtl.make_cd%TYPE,
      color                   gicl_motor_car_dtl.color%TYPE,
      subline_type_cd         gicl_motor_car_dtl.subline_type_cd%TYPE,
      basic_color_cd          gicl_motor_car_dtl.basic_color_cd%TYPE,
      color_cd                gicl_motor_car_dtl.color_cd%TYPE,
      serial_no               gicl_motor_car_dtl.serial_no%TYPE,
      loss_date               VARCHAR2 (10),
      currency_cd             gicl_motor_car_dtl.currency_cd%TYPE,
      mot_type                gicl_motor_car_dtl.mot_type%TYPE,
      series_cd               gicl_motor_car_dtl.series_cd%TYPE,
      currency_rate           gicl_motor_car_dtl.currency_rate%TYPE,
      no_of_pass              gicl_motor_car_dtl.no_of_pass%TYPE,
      towing                  gicl_motor_car_dtl.towing%TYPE,
      drvr_add                gicl_motor_car_dtl.drvr_add%TYPE,
      other_info              gicl_motor_car_dtl.other_info%TYPE,
      drvng_exp               gicl_motor_car_dtl.drvng_exp%TYPE,
      nationality_cd          gicl_motor_car_dtl.nationality_cd%TYPE,
      relation                gicl_motor_car_dtl.relation%TYPE,
      assignee                gicl_motor_car_dtl.assignee%TYPE,
      last_update             gicl_motor_car_dtl.last_update%TYPE,
      item_desc               gicl_clm_item.item_desc%TYPE,
      item_desc2              gicl_clm_item.item_desc2%TYPE,
      mv_file_no              gicl_motor_car_dtl.mv_file_no%TYPE,
      dsp_currency_desc       giis_currency.currency_desc%TYPE,
      subline_type_desc       giis_mc_subline_type.subline_type_desc%TYPE,
      motcar_comp_desc        giis_mc_car_company.car_company%TYPE,
      make_desc               giis_mc_make.make%TYPE,
      basic_color             giis_mc_color.basic_color%TYPE,
      mot_type_desc           giis_motortype.motor_type_desc%TYPE,
      engine_series           giis_mc_eng_series.engine_series%TYPE,
      drvr_occ_desc           gicl_drvr_occptn.occ_desc%TYPE,
      nationality_desc        giis_nationality.nationality_desc%TYPE,
      gicl_item_peril_exist   VARCHAR2 (1),
      gicl_mortgagee_exist    VARCHAR2 (1),
      gicl_item_peril_msg     VARCHAR2 (1),
      cpi_rec_no            gicl_fire_dtl.cpi_rec_no%TYPE,
        cpi_branch_cd         gicl_fire_dtl.cpi_branch_cd%TYPE
   );

   TYPE gicl_motor_car_dtl_tab IS TABLE OF gicl_motor_car_dtl_type;

   TYPE gicl_motor_car_dtl_cur IS REF CURSOR
      RETURN gicl_motor_car_dtl_type;

   FUNCTION get_gicl_motor_car_dtl (
      p_claim_id   gicl_motor_car_dtl.claim_id%TYPE
   )
      RETURN gicl_motor_car_dtl_tab PIPELINED;

/*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.202011
   **  Reference By : (GICLS014- Claims Motorcar Item Information)
   **  Description  : Validates the item_no
   */
   PROCEDURE validate_gicl_motorcar_item_no (
      p_line_cd                 gipi_polbasic.line_cd%TYPE,
      p_subline_cd              gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd              gipi_polbasic.iss_cd%TYPE,
      p_issue_yy                gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no              gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no                gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date            gipi_polbasic.eff_date%TYPE,
      p_expiry_date             gipi_polbasic.expiry_date%TYPE,
      p_loss_date               gipi_polbasic.expiry_date%TYPE,
      p_incept_date             gipi_polbasic.incept_date%TYPE,
      p_item_no                 gipi_item.item_no%TYPE,
      p_claim_id                gicl_motor_car_dtl.claim_id%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c005             IN OUT   gicl_motor_car_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2
   );

   /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.202011
   **  Reference By : (GICLS014- Claims Motorcar Item Information)
   **  Description  : check item_no if exist
   */
   FUNCTION check_motorcar_item_no (
      p_claim_id    gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no     gicl_motor_car_dtl.item_no%TYPE,
      p_start_row   VARCHAR2,
      p_end_row     VARCHAR2
   )
      RETURN VARCHAR2;

   /*
    **  Created by    : Irwin Tabisora
    **  Date Created  : 09.21.2011
    **  Reference By  : (GICLS014 - Motorcar Item Information)
    **  Description   : extract_latest_motordata program unit - extracting motor car details
    */
   FUNCTION extract_latest_motordata (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE
   )
      RETURN gicl_motor_car_dtl_tab PIPELINED;

   /*
   **  Created by    : Irwin Tabisora
   **  Date Created  : 09.22.2011
   **  Reference By  : (GICLS014 - Motorcar Item Information)
   **  Description   : Deletes record in GICL_MOTOR_CAR_DTL
   */
   PROCEDURE del_gicl_motor_car_dtl (
      p_claim_id   gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no    gicl_motor_car_dtl.item_no%TYPE
   );

   PROCEDURE set_gicl_motor_car_dtl (
      p_claim_id          gicl_motor_car_dtl.claim_id%TYPE,
      p_item_no           gicl_motor_car_dtl.item_no%TYPE,
      p_motor_no          gicl_motor_car_dtl.motor_no%TYPE,
      p_item_title        gicl_motor_car_dtl.item_title%TYPE,
      p_model_year        gicl_motor_car_dtl.model_year%TYPE,
      p_plate_no          gicl_motor_car_dtl.plate_no%TYPE,
      p_drvr_occ_cd       gicl_motor_car_dtl.drvr_occ_cd%TYPE,
      p_drvr_name         gicl_motor_car_dtl.drvr_name%TYPE,
      p_drvr_sex          gicl_motor_car_dtl.drvr_sex%TYPE,
      p_drvr_age          gicl_motor_car_dtl.drvr_age%TYPE,
      p_motcar_comp_cd    gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      p_make_cd           gicl_motor_car_dtl.make_cd%TYPE,
      p_color             gicl_motor_car_dtl.color%TYPE,
      p_subline_type_cd   gicl_motor_car_dtl.subline_type_cd%TYPE,
      p_basic_color_cd    gicl_motor_car_dtl.basic_color_cd%TYPE,
      p_color_cd          gicl_motor_car_dtl.color_cd%TYPE,
      p_serial_no         gicl_motor_car_dtl.serial_no%TYPE,
      p_currency_cd       gicl_motor_car_dtl.currency_cd%TYPE,
      p_mot_type          gicl_motor_car_dtl.mot_type%TYPE,
      p_series_cd         gicl_motor_car_dtl.series_cd%TYPE,
      p_currency_rate     gicl_motor_car_dtl.currency_rate%TYPE,
      p_no_of_pass        gicl_motor_car_dtl.no_of_pass%TYPE,
      p_towing            gicl_motor_car_dtl.towing%TYPE,
      p_drvr_add          gicl_motor_car_dtl.drvr_add%TYPE,
      p_other_info        gicl_motor_car_dtl.other_info%TYPE,
      p_drvng_exp         gicl_motor_car_dtl.drvng_exp%TYPE,
      p_nationality_cd    gicl_motor_car_dtl.nationality_cd%TYPE,
      p_relation          gicl_motor_car_dtl.relation%TYPE,
      p_assignee          gicl_motor_car_dtl.assignee%TYPE,
      p_item_desc         gicl_clm_item.item_desc%TYPE,
      p_item_desc2        gicl_clm_item.item_desc2%TYPE,
      p_mv_file_no        gicl_motor_car_dtl.mv_file_no%TYPE,
       p_cpi_rec_no            gicl_fire_dtl.cpi_rec_no%TYPE,
        p_cpi_branch_cd         gicl_fire_dtl.cpi_branch_cd%TYPE
   );
   
   TYPE vehicle_info_type IS RECORD (
      claim_id           gicl_motor_car_dtl.claim_id%TYPE,
      item_no            gicl_motor_car_dtl.item_no%TYPE,
      plate_no           gicl_motor_car_dtl.plate_no%TYPE,
      model_year         gicl_motor_car_dtl.model_year%TYPE,
      serial_no          gicl_motor_car_dtl.serial_no%TYPE,
      motor_no           gicl_motor_car_dtl.motor_no%TYPE,
      mot_type           gicl_motor_car_dtl.mot_type%TYPE,
      motorcar_comp_cd   gicl_motor_car_dtl.motcar_comp_cd%TYPE,
      make_cd            gicl_motor_car_dtl.make_cd%TYPE,
      series_cd          gicl_motor_car_dtl.series_cd%TYPE,
      basic_color_cd     gicl_motor_car_dtl.basic_color_cd%TYPE,
      color_cd           gicl_motor_car_dtl.color_cd%TYPE,
      drvr_occ_cd        gicl_motor_car_dtl.drvr_occ_cd%TYPE,
      drvr_name          gicl_motor_car_dtl.drvr_name%TYPE,
      drvr_age           gicl_motor_car_dtl.drvr_age%TYPE,
      drvr_sex           gicl_motor_car_dtl.drvr_sex%TYPE,
      other_info         varchar2(30000),
      user_id            gicl_motor_car_dtl.user_id%TYPE,
      last_update        gicl_motor_car_dtl.last_update%TYPE,
      drvr_add           gicl_motor_car_dtl.drvr_add%TYPE,
      basic_color_desc   giis_mc_color.basic_color%TYPE,
      color_desc         giis_mc_color.color%TYPE,
      car_com_desc       giis_mc_car_company.car_company%TYPE,
      make_desc          giis_mc_make.make%TYPE,
      engine_series      giis_mc_eng_series.engine_series%TYPE,
      drvr_occ_desc      gicl_drvr_occptn.occ_desc%TYPE,
      nationality_desc   giis_nationality.nationality_desc%TYPE,
       motor_type_desc    giis_motortype.motor_type_desc%TYPE
   );
   
   type vehicle_info_tab is table of vehicle_info_type;
   
   /**
      Description: GICLS070 Mc Evaluation report vehicle information
      Date: Feb.20, 2012
      Created By: Irwin Co. Tabisora
   */
   FUNCTION get_gicls070_vehicle_info (
      p_claim_id         gicl_motor_car_dtl.claim_id%TYPE,
      p_subline_cd       gicl_claims.subline_cd%type
   )
      RETURN vehicle_info_tab PIPELINED;
	  
   FUNCTION get_gicls260_motor_car_dtl (
      p_claim_id   gicl_motor_car_dtl.claim_id%TYPE
   )
      RETURN gicl_motor_car_dtl_tab PIPELINED;
     
   --kenneth SR4855 10072015
   TYPE gipi_item_type IS RECORD (
        policy_id       GIPI_ITEM.policy_id%TYPE,
        item_no         GIPI_ITEM.item_no%TYPE,
        item_title      GIPI_ITEM.item_title%TYPE,
        item_grp        GIPI_ITEM.item_grp%TYPE,
        item_desc       GIPI_ITEM.item_desc%TYPE,
        item_desc2      GIPI_ITEM.item_desc2%TYPE,
        tsi_amt         GIPI_ITEM.tsi_amt%TYPE,
        prem_amt        GIPI_ITEM.prem_amt%TYPE,
        ann_tsi_amt     GIPI_ITEM.ann_tsi_amt%TYPE,
        ann_prem_amt    GIPI_ITEM.ann_prem_amt%TYPE,
        rec_flag        GIPI_ITEM.rec_flag%TYPE,    
        currency_cd     GIPI_ITEM.currency_cd%TYPE,
        currency_rt     GIPI_ITEM.currency_rt%TYPE,
        group_cd        GIPI_ITEM.group_cd%TYPE,
        from_date       GIPI_ITEM.from_date%TYPE,
        to_date         GIPI_ITEM.to_date%TYPE,
        pack_line_cd    GIPI_ITEM.pack_line_cd%TYPE,
        pack_subline_cd GIPI_ITEM.pack_subline_cd%TYPE,
        discount_sw     GIPI_ITEM.discount_sw%TYPE,
        coverage_cd     GIPI_ITEM.coverage_cd%TYPE,
        other_info      GIPI_ITEM.other_info%TYPE,
        surcharge_sw    GIPI_ITEM.surcharge_sw%TYPE,
        region_cd       GIPI_ITEM.region_cd%TYPE,
        changed_tag     GIPI_ITEM.changed_tag%TYPE,
        comp_sw         GIPI_ITEM.comp_sw%TYPE,
        short_rt_percent GIPI_ITEM.short_rt_percent%TYPE,
        pack_ben_cd     GIPI_ITEM.pack_ben_cd%TYPE,
        payt_terms      GIPI_ITEM.payt_terms%TYPE,
        risk_no         GIPI_ITEM.risk_no%TYPE,
        risk_item_no    GIPI_ITEM.risk_item_no%TYPE,
        prorate_flag    GIPI_ITEM.prorate_flag%TYPE,
        currency_desc   GIIS_CURRENCY.currency_desc%TYPE,
        grouped_item_no         GICL_ACCIDENT_DTL.grouped_item_no%TYPE,
        grouped_item_title      GICL_ACCIDENT_DTL.grouped_item_title%TYPE);
    
    TYPE gipi_item_tab IS TABLE OF gipi_item_type;
   
   --kenneth SR4855 10072015
   FUNCTION get_item_no_list_MC(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_claim_id              gicl_claims.claim_id%type,
        p_find_text             varchar2
    )
    RETURN gipi_item_tab PIPELINED;
    
    --kenneth SR4855 10072015
    FUNCTION check_existing_item(
        p_line_cd               gipi_polbasic.line_cd%TYPE,
        p_subline_cd            gipi_polbasic.subline_cd%TYPE,
        p_pol_iss_cd            gipi_polbasic.iss_cd%TYPE,
        p_issue_yy              gipi_polbasic.issue_yy%TYPE,
        p_pol_seq_no            gipi_polbasic.pol_seq_no%TYPE,
        p_renew_no              gipi_polbasic.renew_no%TYPE,
        p_pol_eff_date          gipi_polbasic.eff_date%TYPE,
        p_expiry_date           gipi_polbasic.expiry_date%TYPE,
        p_loss_date             gipi_polbasic.expiry_date%TYPE,
        p_item_no               gipi_item.item_no%TYPE) 
    RETURN NUMBER;  
      
END gicl_motor_car_dtl_pkg;
/
