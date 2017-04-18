CREATE OR REPLACE PACKAGE CPI.giclr056_pkg
AS
   TYPE giclr056_main_type IS RECORD (
      cat_cd            gicl_cat_dtl.catastrophic_cd%TYPE,
      cat               VARCHAR2 (60),
      loss_cat          VARCHAR2 (30),
      LOCATION          gicl_cat_dtl.LOCATION%TYPE,
      BLOCK             VARCHAR2 (50),
      district          VARCHAR2 (50),
      city              VARCHAR2 (50),
      province          VARCHAR2 (40),
      loss_date         VARCHAR2 (100),
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      line_cd           giis_line.line_cd%TYPE
   );

   TYPE giclr056_main_tab IS TABLE OF giclr056_main_type;

   FUNCTION get_giclr056 (p_cat_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN giclr056_main_tab PIPELINED;

   TYPE detail_type IS RECORD (
      claim_no            VARCHAR2 (50),
      policy_no           VARCHAR2 (50),
      assd_name           giis_assured.assd_name%TYPE,
      loss_cat            VARCHAR2 (30),
      dsp_loss_date       gicl_claims.dsp_loss_date%TYPE,
      LOCATION            gicl_cat_dtl.LOCATION%TYPE,
      in_hou_adj          gicl_claims.in_hou_adj%TYPE,
      clm_stat            VARCHAR2 (40),
      reserve_amt         gicl_reserve_ds.shr_loss_res_amt%TYPE,
      paid_amt            gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      reserve_net         gicl_reserve_ds.shr_loss_res_amt%TYPE,
      paid_net            gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      reserve_facul       gicl_reserve_ds.shr_loss_res_amt%TYPE,    
      paid_facul          gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      reserve_treaty      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      paid_treaty         gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      reserve_treaty_np   gicl_reserve_ds.shr_loss_res_amt%TYPE,
      paid_treaty_np      gicl_loss_exp_ds.shr_le_pd_amt%TYPE
   );

   TYPE detail_tab IS TABLE OF detail_type;

   FUNCTION get_details (p_cat_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN detail_tab PIPELINED;

   PROCEDURE get_amounts (
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_line_cd             IN       giis_line.line_cd%TYPE,
      p_reserve_amt         OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_amt            OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_net         OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_net            OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_facul       OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,    
      p_paid_facul          OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_treaty      OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_treaty         OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE,
      p_reserve_treaty_np   OUT      gicl_reserve_ds.shr_loss_res_amt%TYPE,
      p_paid_treaty_np      OUT      gicl_loss_exp_ds.shr_le_pd_amt%TYPE
   );
END giclr056_pkg;
/


