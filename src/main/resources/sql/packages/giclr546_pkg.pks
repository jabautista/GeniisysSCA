CREATE OR REPLACE PACKAGE CPI.giclr546_pkg
AS
   TYPE report_type IS RECORD (
      company_name       VARCHAR2 (200),
      company_address    VARCHAR2 (200),
      cf_title           VARCHAR2 (100),
      cf_date            VARCHAR2 (50),
      policy_number      VARCHAR2 (100),
      claim_number       VARCHAR2 (100),
      cf_intm            VARCHAR2 (240),
      pol_eff_date       gicl_claims.pol_eff_date%TYPE,
      dsp_loss_date      gicl_claims.dsp_loss_date%TYPE,
      clm_file_date      gicl_claims.clm_file_date%TYPE,
      clm_stat_desc      giis_clm_stat.clm_stat_desc%TYPE,
      cf_clm_amt         VARCHAR2 (50),
      cf_loss            NUMBER (16, 2),
      cf_exp             NUMBER (16, 2),
      cf_retention       NUMBER (16, 2),
      cf_exp_retention   NUMBER (16, 2),
      cf_treaty          NUMBER (16, 2),
      cf_exp_treaty      NUMBER (16, 2),
      cf_xol             NUMBER (16, 2),
      cf_exp_xol         NUMBER (16, 2),
      cf_facul           NUMBER (16, 2),
      cf_exp_facul       NUMBER (16, 2),
      peril_cd           giis_peril.peril_cd%TYPE,
      claim_id           gicl_claims.claim_id%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      clm_stat_cd        gicl_claims.clm_stat_cd%TYPE,
      v_print            VARCHAR2(8)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_546_report (
      p_clmstat_cd     VARCHAR2,
      p_clmstat_type   VARCHAR2,
      p_end_dt         VARCHAR2,
      p_issue_yy       NUMBER,
      p_line_cd        VARCHAR2,
      p_loss_exp       VARCHAR2,
      p_pol_iss_cd     VARCHAR2,
      p_pol_seq_no     NUMBER,
      p_renew_no       NUMBER,
      p_start_dt       VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   )
      RETURN report_tab PIPELINED;

   FUNCTION get_giclr_546_dtls (
      p_claim_id      NUMBER,
      p_loss_exp      VARCHAR2,
      p_clm_stat_cd   VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


