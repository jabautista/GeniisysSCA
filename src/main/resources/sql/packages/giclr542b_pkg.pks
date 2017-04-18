CREATE OR REPLACE PACKAGE CPI.giclr542b_pkg
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      cf_title          VARCHAR2 (100),
      cf_date           VARCHAR2 (50),
      p_assured         VARCHAR2 (200),
      clm_amt           VARCHAR2 (50),
      cf_assured        VARCHAR2 (600),  --kenneth SR 17610 08122015
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      cf_intm           VARCHAR2 (1000),
      eff_date          gicl_claims.pol_eff_date%TYPE,
      loss_date         gicl_claims.dsp_loss_date%TYPE,
      file_date         gicl_claims.clm_file_date%TYPE,
      cf_clm_stat       giis_clm_stat.clm_stat_desc%TYPE,
      peril_sname       giis_peril.peril_sname%TYPE,
      loss_amt          NUMBER (16, 2),
      RETENTION         NUMBER (16, 2),
      treaty            NUMBER (16, 2),
      xol               NUMBER (16, 2),
      facultative       NUMBER (16, 2),
      assd_no           gicl_claims.assd_no%TYPE,
      claim_id          gicl_claims.claim_id%TYPE,
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      peril_cd          giis_peril.peril_cd%TYPE,
      line_cd           gicl_claims.line_cd%TYPE,
      v_print           VARCHAR2(8)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_542b_report (
      p_assd_no    NUMBER,
      p_assured    VARCHAR2,
      p_end_dt     VARCHAR2,
      p_iss_cd     VARCHAR2,
      p_line_cd    VARCHAR2,
      p_loss_exp   VARCHAR2,
      p_start_dt   VARCHAR2,
      p_user_id    VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


