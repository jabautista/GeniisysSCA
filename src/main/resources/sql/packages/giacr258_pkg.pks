CREATE OR REPLACE PACKAGE CPI.GIACR258_PKG
AS
/*
**  Created by   : Dwight See
**  Date Created : May 30 2013
**  Description  : For Module GIACR258
*/

    TYPE populate_giacr258_type IS RECORD(
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      report_title      VARCHAR2 (200),
      date_label        VARCHAR2 (100),
      report_date       DATE,
      branch_cd         GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
      iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE,
      intm_no           GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2 (10),
      parent_intm_no    GIIS_INTERMEDIARY.parent_intm_no%TYPE, --VARCHAR2 (10),
      parent_intm_name  GIIS_INTERMEDIARY.INTM_NAME%TYPE,
      intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE,
      ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
      br_prem_tot       giac_soa_rep_ext.prem_bal_due%TYPE,
      br_tax_tot        giac_soa_rep_ext.tax_bal_due%TYPE,
      br_bal_tot        giac_soa_rep_ext.balance_amt_due%TYPE,
      system_date       DATE,
      dsp_name          VARCHAR2(300),
      dsp_name2         VARCHAR2(300)
    );
    
    TYPE populate_giacr258_tab IS TABLE OF populate_giacr258_type;
    
    TYPE col_details_type IS RECORD(
      col_title         GIAC_SOA_TITLE.COL_TITLE%TYPE,
      col_no            GIAC_SOA_TITLE.COL_NO%TYPE,
      int_m_bal         giac_soa_rep_ext.balance_amt_due%TYPE
    );
    TYPE col_details_tab IS TABLE OF col_details_type;

  FUNCTION get_giacr258_report (
      P_BAL_AMT_DUE     NUMBER,
      P_BRANCH_CD       VARCHAR2,
      P_INC_OVERDUE     VARCHAR2,
      P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
      P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
      P_MONTH           VARCHAR2,
      P_USER            VARCHAR2
   )
      RETURN populate_giacr258_tab PIPELINED;
      
   FUNCTION fetch_giacr258_dynamic_cols
    RETURN col_details_tab PIPELINED;
   
   FUNCTION fetch_giacr258_dynamic_dets(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
     P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
     P_MONTH           VARCHAR2,
     P_USER            VARCHAR2
   )
    RETURN col_details_tab PIPELINED;
    
   FUNCTION fetch_total_par_intm(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
     P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
     P_MONTH           VARCHAR2,
     P_USER            VARCHAR2
   )
    RETURN col_details_tab PIPELINED;
    
   FUNCTION fetch_total_branch(
     P_BAL_AMT_DUE     NUMBER,
     P_BRANCH_CD       VARCHAR2,
     P_INC_OVERDUE     VARCHAR2,
     P_INTM_NO         GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2,
     P_INTM_TYPE       GIIS_INTERMEDIARY.intm_type%TYPE, --VARCHAR2,
     P_MONTH           VARCHAR2,
     P_USER            VARCHAR2
   )
    RETURN col_details_tab PIPELINED;

    -- SR-3501 : shan 08.05.2015
    TYPE title_type IS RECORD (
        dummy       NUMBER(10),
        col_title   giac_soa_title.col_title%TYPE,
        col_no      giac_soa_title.col_no%TYPE
    );

    TYPE title_tab IS TABLE OF title_type;
    
    TYPE column_header_type IS RECORD (
        dummy       NUMBER(10),
        col_no1      giac_soa_title.col_no%TYPE,
        col_title1   giac_soa_title.col_title%TYPE,
        col_no2      giac_soa_title.col_no%TYPE,
        col_title2   giac_soa_title.col_title%TYPE,
        col_no3      giac_soa_title.col_no%TYPE,
        col_title3   giac_soa_title.col_title%TYPE,
        col_no4      giac_soa_title.col_no%TYPE,
        col_title4   giac_soa_title.col_title%TYPE,
        col_no5      giac_soa_title.col_no%TYPE,
        col_title5   giac_soa_title.col_title%TYPE,
        col_no6      giac_soa_title.col_no%TYPE,
        col_title6   giac_soa_title.col_title%TYPE,
        no_of_dummy  NUMBER(10)
    );

    TYPE column_header_tab IS TABLE OF column_header_type;

    FUNCTION get_column_header
        RETURN column_header_tab PIPELINED;
   
    TYPE rep_type IS RECORD (
        company_name      VARCHAR2 (200),
        company_address   VARCHAR2 (200),
        report_title      VARCHAR2 (200),
        date_label        VARCHAR2 (100),
        report_date       DATE,
        cf_label          VARCHAR2(200),
        system_date       DATE,
        dsp_name          VARCHAR2(300),
        dsp_name2         VARCHAR2(300),
        branch_cd         GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
        iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE,
        cf_branch         VARCHAR2(50),
        intm_no           GIIS_INTERMEDIARY.intm_no%TYPE, --VARCHAR2 (10),
        parent_intm_no    GIIS_INTERMEDIARY.parent_intm_no%TYPE, --VARCHAR2 (10),
        parent_intm_name  GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
        br_prem_tot       giac_soa_rep_ext.prem_bal_due%TYPE,
        br_tax_tot        giac_soa_rep_ext.tax_bal_due%TYPE,
        br_bal_tot        giac_soa_rep_ext.balance_amt_due%TYPE,
        branch_cd_dummy       VARCHAR2 (200),
        dummy                 NUMBER(10),
        col_no1               giac_soa_rep_ext.column_no%TYPE,
        col_title1            giac_soa_title.col_title%TYPE,
        intmbal1              NUMBER (18, 2),
        intmprem1             NUMBER (18, 2),
        intmtax1              NUMBER (18, 2),
        col_no2               giac_soa_rep_ext.column_no%TYPE,
        col_title2            giac_soa_title.col_title%TYPE,
        intmbal2              NUMBER (18, 2),
        intmprem2             NUMBER (18, 2),
        intmtax2              NUMBER (18, 2),
        col_no3               giac_soa_rep_ext.column_no%TYPE,
        col_title3            giac_soa_title.col_title%TYPE,
        intmbal3              NUMBER (18, 2),
        intmprem3             NUMBER (18, 2),
        intmtax3              NUMBER (18, 2),
        col_no4               giac_soa_rep_ext.column_no%TYPE,
        col_title4            giac_soa_title.col_title%TYPE,
        intmbal4              NUMBER (18, 2),
        intmprem4             NUMBER (18, 2),
        intmtax4              NUMBER (18, 2),
        col_no5               giac_soa_rep_ext.column_no%TYPE,
        col_title5            giac_soa_title.col_title%TYPE,
        intmbal5              NUMBER (18, 2),
        intmprem5             NUMBER (18, 2),
        intmtax5              NUMBER (18, 2),
        col_no6               giac_soa_rep_ext.column_no%TYPE,
        col_title6            giac_soa_title.col_title%TYPE,
        intmbal6              NUMBER (18, 2),
        intmprem6             NUMBER (18, 2),
        intmtax6              NUMBER (18, 2),
        no_of_dummy           NUMBER (10)
    );
   
    TYPE rep_tab IS TABLE OF rep_type;
   
   
    FUNCTION get_report_details(
        p_bal_amt_due   NUMBER,
        p_branch_cd     VARCHAR2,
        p_inc_overdue   VARCHAR2,
        p_intm_no       giis_intermediary.intm_no%TYPE,
        p_intm_type     VARCHAR2,
        p_month         VARCHAR2,
        p_user          VARCHAR2
    ) RETURN rep_tab PIPELINED;
   
    -- end SR-3571
END;
/


