CREATE OR REPLACE PACKAGE CPI.giclr267_pkg
AS
   TYPE report_type IS RECORD (
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      assured_name      GICL_CLAIMS.ASSURED_NAME%TYPE,
      clm_stat_cd       GICL_CLAIMS.CLM_STAT_CD%TYPE,
      clm_stat_desc     VARCHAR2(100),
      dsp_loss_date     DATE,
      clm_file_date     DATE,
      loss_res_amt      GICL_CLAIMS.LOSS_RES_AMT%TYPE,
      loss_pd_amt       GICL_CLAIMS.LOSS_PD_AMT%TYPE,
      exp_res_amt       GICL_CLAIMS.EXP_RES_AMT%TYPE,
      exp_pd_amt        GICL_CLAIMS.EXP_PD_AMT%TYPE,
      ri_cd             GIIS_REINSURER.RI_CD%TYPE,
      ri_name           GIIS_REINSURER.RI_NAME%TYPE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_type         VARCHAR2 (150)
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giclr_267_report (
      p_user_id         VARCHAR2,
      p_ri_cd           VARCHAR2,
      p_from_date       VARCHAR2,
      p_to_date         VARCHAR2,
      p_as_of_date      VARCHAR2,
      p_from_ldate      VARCHAR2,
      p_to_ldate        VARCHAR2,
      p_as_of_ldate     VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


