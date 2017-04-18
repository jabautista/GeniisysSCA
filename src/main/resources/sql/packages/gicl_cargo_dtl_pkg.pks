CREATE OR REPLACE PACKAGE CPI.gicl_cargo_dtl_pkg
AS
   TYPE gicl_cargo_dtl_type IS RECORD (
      claim_id                gicl_cargo_dtl.claim_id%TYPE,
      item_no                 gicl_cargo_dtl.item_no%TYPE,
      user_id                 gicl_cargo_dtl.user_id%TYPE,
      item_title              gicl_cargo_dtl.item_title%TYPE,
      geog_cd                 gicl_cargo_dtl.geog_cd%TYPE,
      cargo_class_cd          gicl_cargo_dtl.cargo_class_cd%TYPE,
      voyage_no               gicl_cargo_dtl.voyage_no%TYPE,
      bl_awb                  gicl_cargo_dtl.bl_awb%TYPE,
      origin                  gicl_cargo_dtl.origin%TYPE,
      destn                   gicl_cargo_dtl.destn%TYPE,
      etd                     gicl_cargo_dtl.etd%TYPE,
      eta                     gicl_cargo_dtl.eta%TYPE,
      cargo_type              gicl_cargo_dtl.cargo_type%TYPE,
      deduct_text             gicl_cargo_dtl.deduct_text%TYPE,
      pack_method             gicl_cargo_dtl.pack_method%TYPE,
      tranship_origin         gicl_cargo_dtl.tranship_origin%TYPE,
      tranship_destination    gicl_cargo_dtl.tranship_destination%TYPE,
      lc_no                   gicl_cargo_dtl.lc_no%TYPE,
      loss_date               VARCHAR2 (30),    -- VARCHAR2 (10), shan 04.15.2014
      cpi_rec_no              gicl_cargo_dtl.cpi_rec_no%TYPE,
      cpi_branch_cd           gicl_cargo_dtl.cpi_branch_cd%TYPE,
      currency_cd             gicl_cargo_dtl.currency_cd%TYPE,
      currency_rate           gicl_cargo_dtl.currency_rate%TYPE,
      item_desc               gicl_clm_item.item_desc%TYPE,
      item_desc2              gicl_clm_item.item_desc2%TYPE,
      last_update             gicl_cargo_dtl.last_update%TYPE,
      vessel_cd               gicl_cargo_dtl.vessel_cd%TYPE,
      vessel_name             VARCHAR2 (30),
      geog_desc               VARCHAR2 (30),
      cargo_class_desc        VARCHAR2 (300),
      cargo_type_desc         VARCHAR2 (300),
      dsp_currency_desc       giis_currency.currency_desc%TYPE,
      gicl_item_peril_exist   VARCHAR2 (1),
      gicl_mortgagee_exist    VARCHAR2 (1),
      gicl_item_peril_msg     VARCHAR2 (1)
   );

   TYPE gicl_cargo_dtl_tab IS TABLE OF gicl_cargo_dtl_type;

    /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.29.2011
   **  Reference By : (GICLS019- Claims Marine Cargo Item Information)
   **  Description  : Retrieves the Cargo Item Info
   */
   FUNCTION get_gicl_cargo_dtl (p_claim_id gicl_cargo_dtl.claim_id%TYPE)
      RETURN gicl_cargo_dtl_tab PIPELINED;

   TYPE gicl_cargo_dtl_cur IS REF CURSOR
      RETURN gicl_cargo_dtl_type;

      /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.302011
   **  Reference By : (GICLS019- Claims Marine Cargo Item Information)
   **  Description  : Validates the item_no
   */
   PROCEDURE validate_gicl_cargo_item_no (
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
      p_claim_id                gicl_cargo_dtl.claim_id%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c006             IN OUT   gicl_cargo_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2
   );

   /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  09.302011
   **  Reference By : (GICLS014- Claims marine cargo Item Information)
   **  Description  : check item_no if exist
   */
   FUNCTION check_cargo_item_no (
      p_claim_id    gicl_cargo_dtl.claim_id%TYPE,
      p_item_no     gicl_cargo_dtl.item_no%TYPE,
      p_start_row   VARCHAR2,
      p_end_row     VARCHAR2
   )
      RETURN VARCHAR2;

     /*
   **  Created by    : Irwin Tabisora
   **  Date Created  : 09.30.2011
   **  Reference By  : (GICLS019 - cargo Item Information)
   **  Description   : extract_marine_data program unit - extracting marine cargo details
   */
   FUNCTION extract_latest_marine_data (
      p_line_cd        gipi_polbasic.line_cd%TYPE,
      p_subline_cd     gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       gipi_polbasic.renew_no%TYPE,
      p_pol_eff_date   gipi_polbasic.eff_date%TYPE,
      p_expiry_date    gipi_polbasic.expiry_date%TYPE,
      p_loss_date      gipi_polbasic.expiry_date%TYPE,
      p_item_no        gipi_item.item_no%TYPE,
      p_claim_id       gicl_cargo_dtl.claim_id%TYPE
   )
      RETURN gicl_cargo_dtl_tab PIPELINED;

   PROCEDURE del_gicl_cargo_dtl (
      p_claim_id   gicl_cargo_dtl.claim_id%TYPE,
      p_item_no    gicl_cargo_dtl.item_no%TYPE
   );

   PROCEDURE set_gicl_cargo_dtl (
      p_claim_id   gicl_cargo_dtl.claim_id%TYPE,
      p_item_no    gicl_cargo_dtl.item_no%TYPE,
      p_vessel_cd gicl_cargo_dtl.vessel_cd%TYPE,
      p_geog_cd  gicl_cargo_dtl.geog_cd%TYPE,
      p_cargo_class_cd gicl_cargo_dtl.cargo_class_cd%TYPE,
      p_voyage_no gicl_cargo_dtl.voyage_no%TYPE,
      p_bl_awb gicl_cargo_dtl.bl_awb%TYPE,
      p_origin gicl_cargo_dtl.origin%TYPE,
      p_destn gicl_cargo_dtl.destn%TYPE,
      p_etd gicl_cargo_dtl.etd%TYPE,
      p_eta gicl_cargo_dtl.eta%TYPE,
      p_cargo_type gicl_cargo_dtl.cargo_type%TYPE,
      p_deduct_text gicl_cargo_dtl.deduct_text%TYPE,
      p_pack_method gicl_cargo_dtl.pack_method%TYPE,
      p_tranship_origin gicl_cargo_dtl.tranship_origin%TYPE,
      p_tranship_destination gicl_cargo_dtl.tranship_destination%TYPE,
      p_lc_no gicl_cargo_dtl.lc_no%TYPE,
      p_item_title gicl_cargo_dtl.item_title%TYPE,
      p_currency_cd gicl_cargo_dtl.currency_cd%TYPE,
      p_currency_rate gicl_cargo_dtl.currency_rate%TYPE,
       p_cpi_rec_no gicl_cargo_dtl.cpi_rec_no%TYPE,
      p_cpi_branch_cd gicl_cargo_dtl.cpi_branch_cd%TYPE
   );
END;
/


