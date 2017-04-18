CREATE OR REPLACE PACKAGE cpi.csv_brdrx_str
AS
   variables_ri_iss_cd   giac_parameters.param_value_v%TYPE
                                                     := giacp.v ('RI_ISS_CD');

   TYPE str_csv_rec_type IS RECORD (
      rec   VARCHAR2 (32767)
   );

   TYPE str_csv_rec_tab IS TABLE OF str_csv_rec_type;

   TYPE brdrx_rec_type IS RECORD (
      iss_type              VARCHAR2 (2),
      buss_source           gicl_res_brdrx_extr.buss_source%TYPE,
      buss_source_type      VARCHAR2 (2),
      source_name           giis_intermediary.intm_name%TYPE,
      source_type_desc      giis_intm_type.intm_desc%TYPE,
      iss_cd                giis_issource.iss_cd%TYPE,
      iss_name              giis_issource.iss_name%TYPE,
      line_cd               giis_line.line_cd%TYPE,
      line_name             giis_line.line_name%TYPE,
      subline_cd            giis_subline.subline_cd%TYPE,
      subline_name          giis_subline.subline_name%TYPE,
      loss_year             gicl_res_brdrx_extr.loss_year%TYPE,
      claim_id              gicl_claims.claim_id%TYPE,
      claim_no              gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no             gicl_res_brdrx_extr.policy_no%TYPE,
      pol_no_ref_no         VARCHAR2 (70),
      assd_no               giis_assured.assd_no%TYPE,
      assd_name             giis_assured.assd_name%TYPE,
      incept_date           DATE,
      expiry_date           DATE,
      loss_date             DATE,
      item_no               NUMBER,
      item_title            VARCHAR2 (200),
      grouped_item_no       NUMBER,
      peril_cd              giis_peril.peril_cd%TYPE,
      peril_name            giis_peril.peril_name%TYPE,
      loss_cat_des          giis_loss_ctgry.loss_cat_des%TYPE,
      tsi_amt               gipi_polbasic.tsi_amt%TYPE,
      intm_no               giis_intermediary.intm_no%TYPE,
      intm_ri               VARCHAR2 (4000),
      voucher_chk_no_loss   VARCHAR2 (4000),
      voucher_chk_no_exp    VARCHAR2 (4000),
      clm_res_hist_id       gicl_clm_res_hist.clm_res_hist_id%TYPE,
      term                  VARCHAR2 (40),
      enrollee              gicl_res_brdrx_extr.enrollee%TYPE,
      os_loss               NUMBER,
      os_expense            NUMBER,
      losses_paid           NUMBER,
      expenses_paid         NUMBER
   );

   TYPE brdrx_rec_tab IS TABLE OF brdrx_rec_type;

   FUNCTION csv_giclr205le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr206le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr221le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr221l (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr221e (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr222le (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr222l (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;

   FUNCTION csv_giclr222e (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_paid_date    NUMBER,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2
   )
      RETURN str_csv_rec_tab PIPELINED;
END;
/