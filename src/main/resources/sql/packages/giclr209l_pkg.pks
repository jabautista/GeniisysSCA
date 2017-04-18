CREATE OR REPLACE PACKAGE CPI.GICLR209L_PKG
AS
   TYPE giclr209l_report_type IS RECORD (
      v_company_name      VARCHAR2 (500),
      v_company_address   VARCHAR2 (500),
      v_title             VARCHAR2 (100),
      v_param_date        VARCHAR2 (100),
      v_date              VARCHAR2 (100),
      intm_name           giis_intermediary.intm_name%TYPE,
      intm_no             gicl_res_brdrx_extr.intm_no%TYPE,
      iss_cd              gicl_res_brdrx_extr.iss_cd%TYPE,
      line_cd             gicl_res_brdrx_extr.line_cd%TYPE,
      iss_name            giis_issource.iss_name%TYPE,
      line_name           giis_line.line_name%TYPE,
      claim_no            gicl_res_brdrx_extr.claim_no%TYPE,
      assd_name           giis_assured.assd_name%TYPE,
      eff_date            gicl_claims.pol_eff_date%TYPE,
      loss_date           gicl_res_brdrx_extr.loss_date%TYPE,
      loss_cat_des        giis_loss_ctgry.loss_cat_des%TYPE,
      item_title          VARCHAR2 (200),/*gicl_clm_item.item_title%TYPE,*/ --benjo 11.24.2015 GENQA-SR-5154
      peril_name          giis_peril.peril_name%TYPE,
      tsi_amt             gicl_res_brdrx_extr.tsi_amt%TYPE,
      paid_loss           gicl_res_brdrx_extr.losses_paid%TYPE,
      cf_share_type1      NUMBER (16, 2),
      cf_share_type2      NUMBER (16, 2),
      cf_share_type3      NUMBER (16, 2),
      cf_share_type4      NUMBER (16, 2),
      v_recoverable       NUMBER (16, 2),
      tran_date           VARCHAR2 (200),
      policy_no           gicl_res_brdrx_extr.policy_no%TYPE,
      intm_ri             VARCHAR2 (2000),
      expiry_date         gicl_claims.expiry_date%TYPE,
      clm_file_date       gicl_res_brdrx_extr.clm_file_date%TYPE,
      LOCATION            VARCHAR2 (250),
      claim_status        VARCHAR2 (500),
      header_flag         VARCHAR2 (1)
   );

   TYPE giclr209l_report_tab IS TABLE OF giclr209l_report_type;

   FUNCTION get_giclr209l_details (
      p_session_id   gicl_res_brdrx_extr.session_id%TYPE,
      p_claim_id     gicl_res_brdrx_extr.claim_id%TYPE,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_iss_break    VARCHAR2,
      p_paid_date    NUMBER,
      p_intm_break   NUMBER
   )
      RETURN giclr209l_report_tab PIPELINED;
END;
/


