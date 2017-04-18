CREATE OR REPLACE PACKAGE CPI.gicl_aviation_dtl_pkg
AS
   TYPE gicl_aviation_dtl_type IS RECORD (
      claim_id                gicl_aviation_dtl.claim_id%TYPE,
      item_no                 gicl_aviation_dtl.item_no%TYPE,
      user_id                 gicl_aviation_dtl.user_id%TYPE,
      item_title              gicl_aviation_dtl.item_title%TYPE,
      dsp_currency_desc       giis_currency.currency_desc%TYPE,
      vessel_cd               gicl_aviation_dtl.vessel_cd%TYPE,
      total_fly_time          gicl_aviation_dtl.total_fly_time%TYPE,
      qualification           gicl_aviation_dtl.qualification%TYPE,
      purpose                 gicl_aviation_dtl.purpose%TYPE,
      geog_limit              gicl_aviation_dtl.geog_limit%TYPE,
      deduct_text             gicl_aviation_dtl.deduct_text%TYPE,
      rec_flag                gicl_aviation_dtl.rec_flag%TYPE,
      fixed_wing              gicl_aviation_dtl.fixed_wing%TYPE,
      rotor                   gicl_aviation_dtl.rotor%TYPE,
      prev_util_hrs           gicl_aviation_dtl.prev_util_hrs%TYPE,
      est_util_hrs            gicl_aviation_dtl.est_util_hrs%TYPE,
      loss_date               VARCHAR2(30), --VARCHAR2 (10), shan 04.15.2014
      cpi_rec_no              gicl_aviation_dtl.cpi_rec_no%TYPE,
      cpi_branch_cd           gicl_aviation_dtl.cpi_branch_cd%TYPE,
      currency_cd             gicl_aviation_dtl.currency_cd%TYPE,
      currency_rate           gicl_aviation_dtl.currency_rate%TYPE,
      item_desc               gicl_clm_item.item_desc%TYPE,
      item_desc2              gicl_clm_item.item_desc2%TYPE,
      last_update             gicl_aviation_dtl.last_update%TYPE,
      dsp_rpc_no              VARCHAR2 (15),
      dsp_vessel_name         VARCHAR2 (30),
      dsp_air_type            VARCHAR2 (20),
      gicl_item_peril_exist   VARCHAR2 (1),
      gicl_mortgagee_exist    VARCHAR2 (1),
      gicl_item_peril_msg     VARCHAR2 (1)
   );

   TYPE gicl_aviation_dtl_tab IS TABLE OF gicl_aviation_dtl_type;

   TYPE gicl_aviation_dtl_cur IS REF CURSOR
      RETURN gicl_aviation_dtl_type;

    /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  10.05.2011
   **  Reference By : (GICLS020- Claims Aviation Item Information)
   **  Description  : Retrieves the Aviation Item Info
   */
   FUNCTION get_aviation_dtl_item (p_claim_id gicl_cargo_dtl.claim_id%TYPE)
      RETURN gicl_aviation_dtl_tab PIPELINED;

      /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  10.11.11
   **  Reference By : (GICLS020- Claims Aviatiojn Item Information)
   **  Description  : Validates the item_no
   */
   PROCEDURE validate_gicl_aviation_item_no (
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
      p_claim_id                gicl_aviation_dtl.claim_id%TYPE,
      p_from                    VARCHAR2,
      p_to                      VARCHAR2,
      c033             IN OUT   gicl_aviation_dtl_cur,
      p_item_exist     OUT      NUMBER,
      p_override_fl    OUT      VARCHAR2,
      p_tloss_fl       OUT      VARCHAR2,
      p_item_exist2    OUT      VARCHAR2,
      p_iss_cd                  gipi_polbasic.iss_cd%TYPE
   );

   /*
   **  Created by   :  Irwin Tabisora
   **  Date Created :  10.11.11
   **  Reference By : (GICLS020- Claims Aviatiojn Item Information)
   **  Description  : check item_no if exist
   */
   FUNCTION check_aviation_item_no (
      p_claim_id    gicl_aviation_dtl.claim_id%TYPE,
      p_item_no     gicl_aviation_dtl.item_no%TYPE,
      p_start_row   VARCHAR2,
      p_end_row     VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION extract_latest_avdata (
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
      RETURN gicl_aviation_dtl_tab PIPELINED;

   PROCEDURE set_gicl_aviation_dtl (
      p_claim_id         gicl_aviation_dtl.claim_id%TYPE,
      p_item_no          gicl_aviation_dtl.item_no%TYPE,
      p_item_title       gicl_aviation_dtl.item_title%TYPE,
      p_cpi_rec_no       gicl_aviation_dtl.cpi_rec_no%TYPE,
      p_cpi_branch_cd    gicl_aviation_dtl.cpi_branch_cd%TYPE,
      p_currency_cd      gicl_aviation_dtl.currency_cd%TYPE,
      p_currency_rate     gicl_aviation_dtl.currency_rate%TYPE,
      p_vessel_cd        gicl_aviation_dtl.vessel_cd%TYPE,
      p_total_fly_time   gicl_aviation_dtl.total_fly_time%TYPE,
      p_qualification    gicl_aviation_dtl.qualification%TYPE,
      p_purpose          gicl_aviation_dtl.purpose%TYPE,
      p_geog_limit       gicl_aviation_dtl.geog_limit%TYPE,
      p_deduct_text      gicl_aviation_dtl.deduct_text%TYPE,
      p_rec_flag         gicl_aviation_dtl.rec_flag%TYPE,
      p_fixed_wing       gicl_aviation_dtl.fixed_wing%TYPE,
      p_rotor            gicl_aviation_dtl.rotor%TYPE,
      p_prev_util_hrs    gicl_aviation_dtl.prev_util_hrs%TYPE,
      p_est_util_hrs     gicl_aviation_dtl.est_util_hrs%TYPE
   );
   
    PROCEDURE del_gicl_aviation_dtl (
      p_claim_id   gicl_aviation_dtl.claim_id%TYPE,
      p_item_no    gicl_aviation_dtl.item_no%TYPE
   );
END;
/


