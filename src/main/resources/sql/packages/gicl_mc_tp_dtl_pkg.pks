CREATE OR REPLACE PACKAGE CPI.gicl_mc_tp_dtl_pkg
AS
/******************************************************************************
   NAME:       gicl_mc_tp_dtl_pkg
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        9/16/2011    Irwin Tabisora  1. Created this package.
******************************************************************************/
   PROCEDURE save_gicl_mc_tp_dtl (
      p_claim_id             gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no              gicl_mc_tp_dtl.item_no%TYPE,
      p_payee_class_cd       gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no             gicl_mc_tp_dtl.payee_no%TYPE,
      p_tp_type              gicl_mc_tp_dtl.tp_type%TYPE,
      p_plate_no             gicl_mc_tp_dtl.plate_no%TYPE,
      p_model_year           gicl_mc_tp_dtl.model_year%TYPE,
      p_serial_no            gicl_mc_tp_dtl.serial_no%TYPE,
      p_motor_no             gicl_mc_tp_dtl.motor_no%TYPE,
      p_mot_type             gicl_mc_tp_dtl.mot_type%TYPE,
      p_motorcar_comp_cd     gicl_mc_tp_dtl.motorcar_comp_cd%TYPE,
      p_make_cd              gicl_mc_tp_dtl.make_cd%TYPE,
      p_series_cd            gicl_mc_tp_dtl.series_cd%TYPE,
      p_basic_color_cd       gicl_mc_tp_dtl.basic_color_cd%TYPE,
      p_color_cd             gicl_mc_tp_dtl.color_cd%TYPE,
      p_drvr_occ_cd          gicl_mc_tp_dtl.drvr_occ_cd%TYPE,
      p_drvr_name            gicl_mc_tp_dtl.drvr_name%TYPE,
      p_drvr_sex             gicl_mc_tp_dtl.drvr_sex%TYPE,
      p_drvr_age             gicl_mc_tp_dtl.drvr_age%TYPE,
      p_other_info           gicl_mc_tp_dtl.other_info%TYPE,
      p_user_id              gicl_mc_tp_dtl.user_id%TYPE,
      p_ri_cd                gicl_mc_tp_dtl.ri_cd%TYPE,
      p_drvr_add             gicl_mc_tp_dtl.drvr_add%TYPE,
      p_drvng_exp            gicl_mc_tp_dtl.drvng_exp%TYPE,
      p_nationality_cd       gicl_mc_tp_dtl.nationality_cd%TYPE,
      p_new_payee_class_cd   VARCHAR2,
      p_new_payee_no         NUMBER
   );

   PROCEDURE del_gicl_mc_tp_dtl (
      p_claim_id         gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no          gicl_mc_tp_dtl.item_no%TYPE,
      p_payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_tp_dtl.payee_no%TYPE
   );

   PROCEDURE update_gicl_mc_tp_dtl (
      p_claim_id             gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no              gicl_mc_tp_dtl.item_no%TYPE,
      p_payee_class_cd       gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no             gicl_mc_tp_dtl.payee_no%TYPE,
      p_tp_type              gicl_mc_tp_dtl.tp_type%TYPE,
      p_plate_no             gicl_mc_tp_dtl.plate_no%TYPE,
      p_model_year           gicl_mc_tp_dtl.model_year%TYPE,
      p_serial_no            gicl_mc_tp_dtl.serial_no%TYPE,
      p_motor_no             gicl_mc_tp_dtl.motor_no%TYPE,
      p_mot_type             gicl_mc_tp_dtl.mot_type%TYPE,
      p_motorcar_comp_cd     gicl_mc_tp_dtl.motorcar_comp_cd%TYPE,
      p_make_cd              gicl_mc_tp_dtl.make_cd%TYPE,
      p_series_cd            gicl_mc_tp_dtl.series_cd%TYPE,
      p_basic_color_cd       gicl_mc_tp_dtl.basic_color_cd%TYPE,
      p_color_cd             gicl_mc_tp_dtl.color_cd%TYPE,
      p_drvr_occ_cd          gicl_mc_tp_dtl.drvr_occ_cd%TYPE,
      p_drvr_name            gicl_mc_tp_dtl.drvr_name%TYPE,
      p_drvr_sex             gicl_mc_tp_dtl.drvr_sex%TYPE,
      p_drvr_age             gicl_mc_tp_dtl.drvr_age%TYPE,
      p_other_info           gicl_mc_tp_dtl.other_info%TYPE,
      p_user_id              gicl_mc_tp_dtl.user_id%TYPE,
      p_ri_cd                gicl_mc_tp_dtl.ri_cd%TYPE,
      p_drvr_add             gicl_mc_tp_dtl.drvr_add%TYPE,
      p_drvng_exp            gicl_mc_tp_dtl.drvng_exp%TYPE,
      p_nationality_cd       gicl_mc_tp_dtl.nationality_cd%TYPE,
      p_new_payee_class_cd   VARCHAR2,
      p_new_payee_no         NUMBER
   );

   TYPE gicl_mc_tp_dtl_type IS RECORD (
      claim_id           gicl_mc_tp_dtl.claim_id%TYPE,
      item_no            gicl_mc_tp_dtl.item_no%TYPE,
      payee_class_cd     gicl_mc_tp_dtl.payee_class_cd%TYPE,
      payee_no           gicl_mc_tp_dtl.payee_no%TYPE,
      tp_type            gicl_mc_tp_dtl.tp_type%TYPE,
      plate_no           gicl_mc_tp_dtl.plate_no%TYPE,
      model_year         gicl_mc_tp_dtl.model_year%TYPE,
      serial_no          gicl_mc_tp_dtl.serial_no%TYPE,
      motor_no           gicl_mc_tp_dtl.motor_no%TYPE,
      mot_type           gicl_mc_tp_dtl.mot_type%TYPE,
      motorcar_comp_cd   gicl_mc_tp_dtl.motorcar_comp_cd%TYPE,
      make_cd            gicl_mc_tp_dtl.make_cd%TYPE,
      series_cd          gicl_mc_tp_dtl.series_cd%TYPE,
      basic_color_cd     gicl_mc_tp_dtl.basic_color_cd%TYPE,
      color_cd           gicl_mc_tp_dtl.color_cd%TYPE,
      drvr_occ_cd        gicl_mc_tp_dtl.drvr_occ_cd%TYPE,
      drvr_name          gicl_mc_tp_dtl.drvr_name%TYPE,
      drvr_age           gicl_mc_tp_dtl.drvr_age%TYPE,
      drvr_sex           gicl_mc_tp_dtl.drvr_sex%TYPE,
      other_info         varchar2(30000),
      user_id            gicl_mc_tp_dtl.user_id%TYPE,
      ri_cd              gicl_mc_tp_dtl.ri_cd%TYPE,
      last_update        gicl_mc_tp_dtl.last_update%TYPE,
      drvr_add           gicl_mc_tp_dtl.drvr_add%TYPE,
      drvng_exp          gicl_mc_tp_dtl.drvng_exp%TYPE,
      nationality_cd     gicl_mc_tp_dtl.nationality_cd%TYPE,
      class_desc         giis_payee_class.class_desc%TYPE,
      payee_desc         VARCHAR2 (1000), --increase size from 100 to 1000 to prevent ORA-06502 error if payee name is greater than 100 by MAC 07/19/2013.
      motor_type_desc    giis_motortype.motor_type_desc%TYPE,
      ri_name            giis_reinsurer.ri_name%TYPE,
      basic_color_desc   giis_mc_color.basic_color%TYPE,
      color_desc         giis_mc_color.color%TYPE,
      car_com_desc       giis_mc_car_company.car_company%TYPE,
      make_desc          giis_mc_make.make%TYPE,
      engine_series      giis_mc_eng_series.engine_series%TYPE,
      drvr_occ_desc      gicl_drvr_occptn.occ_desc%TYPE,
      nationality_desc   giis_nationality.nationality_desc%TYPE,
      payee_add          gicl_mc_tp_dtl.drvr_add%TYPE	--added by Gzelle 09032014
   );

   TYPE gicl_mc_tp_dtl_tab IS TABLE OF gicl_mc_tp_dtl_type;
   
   TYPE gicl_mc_tp_dtl_payee_type IS RECORD(
      payee_class_cd      GICL_MC_TP_DTL.payee_class_cd%TYPE,
      payee_no            GICL_MC_TP_DTL.payee_no%TYPE,
      payee_name          VARCHAR2(1000),
      claim_id            GICL_CLAIMS.claim_id%TYPE,
      item_no             GICL_MC_TP_DTL.item_no%TYPE
   );
   
   TYPE gicl_mc_tp_dtl_payee_tab IS TABLE OF gicl_mc_tp_dtl_payee_type;
   
   TYPE gicls260_mc_tp_dtl_type IS RECORD(
      claim_id            GICL_CLAIMS.claim_id%TYPE,
      item_no             GICL_MC_TP_DTL.item_no%TYPE,
	  payee_class_cd      GICL_MC_TP_DTL.payee_class_cd%TYPE,
      payee_no            GICL_MC_TP_DTL.payee_no%TYPE,
	  class_desc          GIIS_PAYEE_CLASS.class_desc%TYPE,
      payee_name          VARCHAR2 (1000),
	  payee_address       VARCHAR2 (1000),
	  tp_type             GICL_MC_TP_DTL.tp_type%TYPE
   );

   TYPE gicls260_mc_tp_dtl_tab IS TABLE OF gicls260_mc_tp_dtl_type;

   FUNCTION get_gicl_mc_tp_dtl (
      p_claim_id     gicl_mc_tp_dtl.claim_id%TYPE,
      p_item_no      gicl_mc_tp_dtl.item_no%TYPE,
      -- p_payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
      -- p_payee_no         gicl_mc_tp_dtl.payee_no%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN gicl_mc_tp_dtl_tab PIPELINED;

   /**
      Description: GICLS070 Mc Evaluation report vehicle information
      Date: Feb.20, 2012
      Created By: Irwin Co. Tabisora
   */
   FUNCTION get_gicls070_vehicle_info (
      p_claim_id         gicl_mc_tp_dtl.claim_id%TYPE,
      p_payee_class_cd   gicl_mc_tp_dtl.payee_class_cd%TYPE,
      p_payee_no         gicl_mc_tp_dtl.payee_no%TYPE,
      p_subline_cd       gicl_claims.subline_cd%type
   )
      RETURN gicl_mc_tp_dtl_tab PIPELINED;
      
   FUNCTION get_mc_tp_dtl_payee_list(p_claim_id IN GICL_CLAIMS.claim_id%TYPE)
    RETURN gicl_mc_tp_dtl_payee_tab PIPELINED;
	
   FUNCTION get_gicls260_mc_tp_dtl(p_claim_id     GICL_MC_TP_DTL.claim_id%TYPE,
                                   p_item_no      GICL_MC_TP_DTL.item_no%TYPE)
    RETURN gicls260_mc_tp_dtl_tab PIPELINED;
   
   FUNCTION get_gicls260_mc_tp_other_dtls (
      p_claim_id     	GICL_MC_TP_DTL.claim_id%TYPE,
      p_item_no      	GICL_MC_TP_DTL.item_no%TYPE,
      p_payee_class_cd  GICL_MC_TP_DTL.payee_class_cd%TYPE,
      p_payee_no        GICL_MC_TP_DTL.payee_no%TYPE,
	  p_subline_cd      GICL_CLAIMS.subline_cd%TYPE
   )
      RETURN gicl_mc_tp_dtl_tab PIPELINED;
    	
END;
/


