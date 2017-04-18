CREATE OR REPLACE PACKAGE CPI.giclr208e_pkg
AS
   TYPE get_giclr208e_report_type IS RECORD (
      cf_company         giac_parameters.param_value_v%TYPE,
      cf_com_address     giac_parameters.param_value_v%TYPE,
      report_title       VARCHAR2 (80),
      cf_param_date      VARCHAR2 (100),
      cf_date            VARCHAR2 (100),
      iss_cd             gicl_res_brdrx_extr.iss_cd%TYPE,
      line_cd            gicl_res_brdrx_extr.line_cd%TYPE,
      subline_cd         gicl_res_brdrx_extr.subline_cd%TYPE,
      claim_id           gicl_res_brdrx_extr.claim_id%TYPE,
      assd_no            gicl_res_brdrx_extr.assd_no%TYPE,
      claim_no           gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no          gicl_res_brdrx_extr.policy_no%TYPE,
      clm_file_date      gicl_res_brdrx_extr.clm_file_date%TYPE,
      loss_date          gicl_res_brdrx_extr.loss_date%TYPE,
      loss_cat_cd        gicl_res_brdrx_extr.loss_cat_cd%TYPE,
      peril_cd           gicl_res_brdrx_extr.peril_cd%TYPE,
      intm_no            gicl_res_brdrx_extr.intm_no%TYPE,
      tsi_amt            gicl_res_brdrx_extr.tsi_amt%TYPE,
      outstanding_loss   NUMBER (16, 2),
      cf_intm_name       VARCHAR2 (252),
      line_name          giis_line.line_name%TYPE,
      iss_name           giis_issource.iss_name%TYPE,
      assd_name          giis_assured.assd_name%TYPE,
      cf_intm_ri         VARCHAR2 (2000),
      pol_eff_date       gicl_claims.pol_eff_date%TYPE,
      expiry_date        gicl_claims.expiry_date%TYPE,
      loss_cat_des       giis_loss_ctgry.loss_cat_des%TYPE,
      LOCATION           VARCHAR2 (150),
      item_no            gicl_res_brdrx_extr.item_no%TYPE,
      item_name          VARCHAR2 (200),
      grouped_item_no    gicl_res_brdrx_extr.grouped_item_no%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      claim_status       giis_clm_stat.clm_stat_desc%TYPE,
      cf_share_type1     NUMBER (16, 2),
      cf_share_type2     NUMBER (16, 2),
      cf_share_type3     NUMBER (16, 2),
      cf_share_type4     NUMBER (16, 2),
      RECOVERABLE        NUMBER (16, 2),
      exist              VARCHAR2 (1)
   );

   TYPE get_giclr208e_report_tab IS TABLE OF get_giclr208e_report_type;

   FUNCTION get_giclr208e_report (
      p_claim_id      NUMBER,
      p_session_id    VARCHAR2,
      p_intm_break    NUMBER,
      p_os_date       NUMBER,
      p_date_option   NUMBER,
      p_from_date     VARCHAR2,
      p_to_date       VARCHAR2,
      p_as_of_date    VARCHAR2
   )
      RETURN get_giclr208e_report_tab PIPELINED;
END;
/


