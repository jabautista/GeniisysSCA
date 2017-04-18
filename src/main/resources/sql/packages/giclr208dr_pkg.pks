CREATE OR REPLACE PACKAGE CPI.giclr208dr_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      report_title      VARCHAR2 (300),
      date_title        VARCHAR2 (300),
      date_sw           VARCHAR2 (300),
      intm_no           gicl_res_brdrx_extr.intm_no%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      iss_cd            gicl_res_brdrx_extr.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      line_cd           gicl_res_brdrx_extr.line_cd%TYPE,
      line_name         giis_line.line_name%TYPE,
      eff_date          gicl_claims.pol_eff_date%TYPE,
      claim_no          gicl_res_brdrx_extr.claim_no%TYPE,
      policy_no         gicl_res_brdrx_extr.policy_no%TYPE,
      clm_file_date     gicl_res_brdrx_extr.clm_file_date%TYPE,
      loss_date         gicl_res_brdrx_extr.loss_date%TYPE,
      assd_name         giis_assured.assd_name%TYPE,
      loss_cat_des      giis_loss_ctgry.loss_cat_des%TYPE,
      claim_id          gicl_res_brdrx_extr.claim_id%TYPE,
      brdrx_record_id   gicl_res_brdrx_extr.brdrx_record_id%TYPE,
      no_of_days        NUMBER (38),
      exist             VARCHAR2 (1)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_208dr_report (
      p_aging_date     NUMBER,
      p_as_of_date     VARCHAR2,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_date_option    NUMBER,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_intm_break     NUMBER,
      p_iss_break      NUMBER,
      p_os_date        NUMBER,
      p_session_id     NUMBER
   )
      RETURN report_tab PIPELINED;

   TYPE giclr208dr_coltitle_type IS RECORD (
      column_title   VARCHAR2 (100),
      column_no      NUMBER (10)
   );

   TYPE giclr208dr_coltitle_tab IS TABLE OF giclr208dr_coltitle_type;

   FUNCTION get_giclr_208dr_coltitle
      RETURN giclr208dr_coltitle_tab PIPELINED;

   TYPE giclr208dr_coldtls_type IS RECORD (
      column_no          NUMBER (10),
      outstanding_loss   NUMBER (16, 2)
   );

   TYPE giclr208dr_coldtls_tab IS TABLE OF giclr208dr_coldtls_type;

   FUNCTION get_giclr208dr_coldtls (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_brdrx_rec_id   NUMBER,
      p_no_of_days     NUMBER
   )
      RETURN giclr208dr_coldtls_tab PIPELINED;

   FUNCTION get_giclr208dr_line_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_line_cd        VARCHAR2,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208dr_coldtls_tab PIPELINED;

   FUNCTION get_giclr208dr_branch_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_iss_cd         VARCHAR2
   )
      RETURN giclr208dr_coldtls_tab PIPELINED;

   FUNCTION get_giclr208dr_intm_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER,
      p_intm_no        VARCHAR2
   )
      RETURN giclr208dr_coldtls_tab PIPELINED;

   FUNCTION get_giclr208dr_grand_total (
      p_session_id     NUMBER,
      p_claim_id       NUMBER,
      p_cut_off_date   VARCHAR2,
      p_aging_date     NUMBER
   )
      RETURN giclr208dr_coldtls_tab PIPELINED;
END;
/


