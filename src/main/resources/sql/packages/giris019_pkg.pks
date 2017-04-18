CREATE OR REPLACE PACKAGE CPI.giris019_pkg
AS
   TYPE giis_ri_type IS RECORD (
      ri_cd      giis_reinsurer.ri_cd%TYPE,
      ri_name    giis_reinsurer.ri_name%TYPE,
      ri_sname   giis_reinsurer.ri_sname%TYPE
   );

   TYPE giis_ri_tab IS TABLE OF giis_ri_type;

   TYPE inward_ri_type IS RECORD (
      ri_cd             giri_polbasic_inwfacul_v.ri_cd%TYPE,
      policy_id         giri_polbasic_inwfacul_v.policy_id%TYPE,
      line_cd           giri_polbasic_inwfacul_v.line_cd%TYPE,
      b250_iss_cd       giri_polbasic_inwfacul_v.b250_iss_cd%TYPE,
      subline_cd        giri_polbasic_inwfacul_v.subline_cd%TYPE,
      issue_yy          giri_polbasic_inwfacul_v.issue_yy%TYPE,
      pol_seq_no        giri_polbasic_inwfacul_v.pol_seq_no%TYPE,
      renew_no          giri_polbasic_inwfacul_v.renew_no%TYPE,
      endt_iss_cd       giri_polbasic_inwfacul_v.endt_iss_cd%TYPE,
      endt_yy           giri_polbasic_inwfacul_v.endt_yy%TYPE,
      endt_seq_no       giri_polbasic_inwfacul_v.endt_seq_no%TYPE,
      assd_no           giri_polbasic_inwfacul_v.assd_no%TYPE,
      assd_name         giri_polbasic_inwfacul_v.assd_name%TYPE,
      ri_sname          giri_polbasic_inwfacul_v.ri_sname%TYPE,
      accept_no         giri_polbasic_inwfacul_v.accept_no%TYPE,
      iss_cd            giri_polbasic_inwfacul_v.iss_cd%TYPE,
      prem_seq_no       giri_polbasic_inwfacul_v.prem_seq_no%TYPE,
      due_date          giri_polbasic_inwfacul_v.due_date%TYPE,
      dsp_due_date      VARCHAR2 (50),
      prem_amt          giri_polbasic_inwfacul_v.prem_amt%TYPE,
      tax_amt           giri_polbasic_inwfacul_v.tax_amt%TYPE,
      ri_comm_amt       giri_polbasic_inwfacul_v.ri_comm_amt%TYPE,
      ri_comm_vat       giri_polbasic_inwfacul_v.ri_comm_vat%TYPE,
      currency_rt       giri_polbasic_inwfacul_v.currency_rt%TYPE,
      ri_policy_no      giri_polbasic_inwfacul_v.ri_policy_no%TYPE,
      ri_endt_no        giri_polbasic_inwfacul_v.ri_endt_no%TYPE,
      ri_binder_no      giri_polbasic_inwfacul_v.ri_binder_no%TYPE,
      eff_date          giri_polbasic_inwfacul_v.eff_date%TYPE,
      expiry_date       giri_polbasic_inwfacul_v.expiry_date%TYPE,
      currency_cd       giri_polbasic_inwfacul_v.currency_cd%TYPE,
      currency_desc     giri_polbasic_inwfacul_v.currency_desc%TYPE,
      total_amt         giri_polbasic_inwfacul_v.total_amt%TYPE,
      net_due           giri_polbasic_inwfacul_v.net_due%TYPE,
      total_amt_paid    giri_polbasic_inwfacul_v.total_amt_paid%TYPE,
      balance           giri_polbasic_inwfacul_v.balance%TYPE,
      drv_iss_cd        VARCHAR2 (100),
      dsp_endt_iss_cd   giri_polbasic_inwfacul_v.endt_iss_cd%TYPE,
      dsp_endt_yy       giri_polbasic_inwfacul_v.endt_yy%TYPE,
      dsp_endt_seq_no   giri_polbasic_inwfacul_v.endt_seq_no%TYPE,
      policy_no         VARCHAR2 (50),
      endt_no           VARCHAR2 (50),
      dsp_eff_date      VARCHAR2 (50),
      dsp_expiry_date   VARCHAR2 (50)
   );

   TYPE inward_ri_tab IS TABLE OF inward_ri_type;

   FUNCTION get_giis_reinsurer
      RETURN giis_ri_tab PIPELINED;

   FUNCTION get_binder_list (
      p_ri_cd     giri_polbasic_inwfacul_v.ri_cd%TYPE,
      p_user_id   giis_users.user_id%TYPE
   )
      RETURN inward_ri_tab PIPELINED;
END giris019_pkg;
/


