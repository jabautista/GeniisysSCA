CREATE OR REPLACE PACKAGE CPI.giclr252_pkg
AS
   TYPE report_type IS RECORD (
      claim_no          VARCHAR2 (100),
      policy_no         VARCHAR2 (100),
      assured_name      gicl_claims.assured_name%TYPE,
      clm_stat_cd       gicl_claims.clm_stat_cd%TYPE,
      clm_stat_desc     VARCHAR2 (100),
      dsp_loss_date     DATE,
      entry_date        DATE,
      clm_file_date     DATE,
      in_hou_adj        gicl_claims.in_hou_adj%TYPE,
      loss_res_amt      NUMBER (16, 2),
      exp_res_amt       NUMBER (16, 2),
      loss_pd_amt       NUMBER (16, 2),
      exp_pd_amt        NUMBER (16, 2),
      remarks           gicl_claims.remarks%TYPE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      date_type         VARCHAR2 (150)
   );

   TYPE report_tab IS TABLE OF report_type;

   FUNCTION get_giclr_252_report (
      p_user_id         VARCHAR2,
      p_stat            VARCHAR2,
      p_search_by_opt   VARCHAR2,
      p_date_as_of      VARCHAR2,
      p_date_from       VARCHAR2,
      p_date_to         VARCHAR2
   )
      RETURN report_tab PIPELINED;
END;
/


