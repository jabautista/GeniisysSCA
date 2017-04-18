CREATE OR REPLACE PACKAGE CPI.GICLR203_PKG
AS
   TYPE report_type IS RECORD (
      date_sw               VARCHAR2 (300),
      line_cd               GICL_RES_BRDRX_EXTR.LINE_CD%TYPE,
      iss_cd                GICL_RES_BRDRX_EXTR.ISS_CD%TYPE,
      ri_iss_cd             GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
      intm_type_desc        GIIS_INTM_TYPE.INTM_DESC%TYPE,
      intm_ri               VARCHAR2 (50),
      intm_ri_no            NUMBER (38),
      ri_name               VARCHAR2 (300),
      intm_type             VARCHAR2 (100),
      assd_name             GIIS_ASSURED.ASSD_NAME%TYPE,
      claim_no              GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
      policy_no             GICL_RES_BRDRX_EXTR.POLICY_NO%TYPE,
--      incept_date           GICL_RES_BRDRX_EXTR.INCEPT_DATE%TYPE, -- bonok :: 7.9.2015 :: UCPB Fullweb :: SR 19674 :: set to string for print to excel
--      expiry_date           GICL_RES_BRDRX_EXTR.EXPIRY_DATE%TYPE,
      incept_date           VARCHAR2(50),
      expiry_date           VARCHAR2(50),
      intm                  VARCHAR2 (500),
--      clm_file_date         GICL_RES_BRDRX_EXTR.CLM_FILE_DATE%TYPE, -- bonok :: 7.9.2015 :: UCPB Fullweb :: SR 19674 :: set to string for print to excel
--      loss_date             GICL_RES_BRDRX_EXTR.LOSS_DATE%TYPE,
      clm_file_date         VARCHAR2(50),
      loss_date             VARCHAR2(50),
      item_name             VARCHAR2 (200),     
      tsi_amt               GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
      prem_amt              GICL_RES_BRDRX_EXTR.PREM_AMT%TYPE,
      loss_reserve          GICL_RES_BRDRX_EXTR.LOSS_RESERVE%TYPE,
      expense_reserve       GICL_RES_BRDRX_EXTR.EXPENSE_RESERVE%TYPE,
      losses_paid           GICL_RES_BRDRX_EXTR.LOSSES_PAID%TYPE,
      expenses_paid         GICL_RES_BRDRX_EXTR.EXPENSES_PAID%TYPE,
      recovered_amt         GICL_RES_BRDRX_EXTR.RECOVERED_AMT%TYPE,
      total_per_ri          VARCHAR2 (300),
      total_per_intm_type   VARCHAR2 (300),
      cf_break              VARCHAR2 (500),
      date_title            VARCHAR2 (300),
      date_to               DATE,
      date_from             DATE,
      line_name             GIIS_LINE.LINE_NAME%TYPE,
      branch_name           GIIS_ISSOURCE.ISS_NAME%TYPE,
      brdrx_record_id       GICL_RES_BRDRX_EXTR.BRDRX_RECORD_ID%TYPE,
      withdrawn_status      GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
      denied_status         GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
      cancelled_status      GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
      closed_status         GIAC_PARAMETERS.PARAM_VALUE_V%TYPE,
      clm_stat_desc         GIIS_CLM_STAT.CLM_STAT_DESC%TYPE,
      loss_cat_des          GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE,     
      peril_name            GIIS_PERIL.PERIL_NAME%TYPE
      );
   
   TYPE report_tab IS TABLE OF report_type;
   
   FUNCTION get_giclr_203_report (
      p_branch_clm_pol      VARCHAR2,
      p_date_sw             VARCHAR2,
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_intermediary_tag    VARCHAR2,
      p_intm_no             VARCHAR2,
      p_iss_cd              VARCHAR2,
      p_iss_cd_tag          VARCHAR2,
      p_line_cd             VARCHAR2,
      p_line_cd_tag         VARCHAR2,
      p_peril_cd            VARCHAR2,
      p_session_id          VARCHAR2,
      p_subline_cd          VARCHAR2
   )
      RETURN report_tab PIPELINED; 
    
   /* Added by Dren 09.15.2015
   ** For SR 0020264
   ** Added CSV Report for giclr_203
   */   
   TYPE GICLR203_CSV_REPORT IS RECORD (
      claim_no              GICL_RES_BRDRX_EXTR.CLAIM_NO%TYPE,
      policy_no             GICL_RES_BRDRX_EXTR.POLICY_NO%TYPE,
      assd_name             GIIS_ASSURED.ASSD_NAME%TYPE,
      incept_date           VARCHAR2(50),
      expiry_date           VARCHAR2(50),      
      intm                  VARCHAR2(500),
      clm_file_date         VARCHAR2(50),
      loss_date             VARCHAR2(50),      
      clm_stat_desc         GIIS_CLM_STAT.CLM_STAT_DESC%TYPE,
      loss_cat_des          GIIS_LOSS_CTGRY.LOSS_CAT_DES%TYPE,   
      item_name             VARCHAR2 (200),
      peril_name            GIIS_PERIL.PERIL_NAME%TYPE,
      tsi_amt               GICL_RES_BRDRX_EXTR.TSI_AMT%TYPE,
      prem_amt              GICL_RES_BRDRX_EXTR.PREM_AMT%TYPE,      
      loss_reserve          GICL_RES_BRDRX_EXTR.LOSS_RESERVE%TYPE,
      expense_reserve       GICL_RES_BRDRX_EXTR.EXPENSE_RESERVE%TYPE,      
      losses_paid           GICL_RES_BRDRX_EXTR.LOSSES_PAID%TYPE,
      expenses_paid         GICL_RES_BRDRX_EXTR.EXPENSES_PAID%TYPE,      
      recovered_amt         GICL_RES_BRDRX_EXTR.RECOVERED_AMT%TYPE          
   );         
   TYPE GICLR203_CSV_TABLE IS TABLE OF GICLR203_CSV_REPORT;      
   FUNCTION CSV_GICLR203 ( 
      p_branch_clm_pol      VARCHAR2,
      p_date_sw             VARCHAR2,
      p_from_date           VARCHAR2,
      p_to_date             VARCHAR2,
      p_intermediary_tag    VARCHAR2,
      p_intm_no             VARCHAR2,
      p_iss_cd              VARCHAR2,
      p_iss_cd_tag          VARCHAR2,
      p_line_cd             VARCHAR2,
      p_line_cd_tag         VARCHAR2,
      p_peril_cd            VARCHAR2,
      p_session_id          VARCHAR2,
      p_subline_cd          VARCHAR2
   )
      RETURN GICLR203_CSV_TABLE PIPELINED; -- Dren 09.15.2015 SR 0020264 : Added CSV Report for GICLR203 - End
          
END;
/


