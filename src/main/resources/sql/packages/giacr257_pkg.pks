CREATE OR REPLACE PACKAGE CPI.GIACR257_PKG
AS
   TYPE report_type IS RECORD (
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      report_title      VARCHAR2 (200),
      date_label        VARCHAR2 (100),
      report_date       DATE,
      date_tag1         VARCHAR2 (300),   
      date_tag2         VARCHAR2 (200),
      date_tag3         VARCHAR2 (300),   
      date_tag4         VARCHAR2 (200),
      branch_cd         GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
      iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE,
      intm_no           giis_intermediary.intm_no%TYPE, 
      ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
      intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE,
      prem_bal_due      NUMBER (16,2),
      tax_bal_due       NUMBER (16,2),
      balance_amt_due   NUMBER (16,2),
      col_title         GIAC_SOA_TITLE.COL_TITLE%TYPE,
      col_no            GIAC_SOA_TITLE.COL_NO%TYPE,
      user_id           GIAC_SOA_REP_EXT.USER_ID%TYPE
   );
   
   TYPE report_tab IS TABLE OF report_type;

  FUNCTION get_giacr257_report (
      p_as_of_date      VARCHAR2,
      p_bal_amt_due     NUMBER,
      p_branch_cd       VARCHAR2,
      p_inc_overdue     VARCHAR2,
      p_intm_no         giis_intermediary.intm_no%TYPE, --VARCHAR2,
      p_intm_type       VARCHAR2,
      p_month           VARCHAR2,
      p_user            VARCHAR2
   )
      RETURN report_tab PIPELINED;
   
   TYPE giacr257_column_type IS RECORD (
       COL_TITLE     GIAC_SOA_TITLE.COL_TITLE%TYPE,
       COL_NO        GIAC_SOA_TITLE.COL_NO%TYPE,
       REP_CD        GIAC_SOA_TITLE.rep_cd%TYPE
    );
    
    TYPE giacr257_column_tab IS TABLE OF giacr257_column_type;
    
   FUNCTION get_giacr257_columns
       RETURN giacr257_column_tab PIPELINED;
      
   TYPE giacr257_type IS RECORD (
       column_title     GIAC_SOA_TITLE.COL_TITLE%TYPE,
       col_no           GIAC_SOA_TITLE.COL_NO%TYPE,
       intm_type        VARCHAR2 (10),
       branch_cd        GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
       intmbal          NUMBER (16,2),
       intmprem         NUMBER (16,2),
       intmtax          NUMBER (16,2),
       intm_no          NUMBER (16,2),
       intm_name        GIIS_INTERMEDIARY.INTM_NAME%TYPE
    );
    
    TYPE giacr257_tab IS TABLE OF giacr257_type;

   FUNCTION get_giacr257_details (
       p_as_of_date      VARCHAR2,
       p_bal_amt_due     NUMBER,
       p_branch_cd       VARCHAR2,
       p_inc_overdue     VARCHAR2,
       p_intm_no        giis_intermediary.intm_no%TYPE, --VARCHAR2,
       p_intm_type       VARCHAR2,
       p_month           VARCHAR2,
       p_user            VARCHAR2
    )
       RETURN giacr257_tab PIPELINED;
       
    -- SR-3570 : shan 08.04.2015
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
        date_tag1         VARCHAR2 (300),   
        date_tag2         VARCHAR2 (200),
        date_tag3         VARCHAR2 (300),   
        date_tag4         VARCHAR2 (200),
        branch_cd         GIAC_SOA_REP_EXT.BRANCH_CD%TYPE,
        iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE,
        intm_no           giis_intermediary.intm_no%TYPE, 
        ref_intm_cd       GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
        intm_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        prem_bal_due      NUMBER (16,2),
        tax_bal_due       NUMBER (16,2),
        balance_amt_due   NUMBER (16,2),
        user_id           GIAC_SOA_REP_EXT.USER_ID%TYPE,
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
        no_of_dummy           NUMBER (10)
    );
   
    TYPE rep_tab IS TABLE OF rep_type;
   
   
    FUNCTION get_report_details(
        p_as_of_date    VARCHAR2,
        p_bal_amt_due   NUMBER,
        p_branch_cd     VARCHAR2,
        p_inc_overdue   VARCHAR2,
        p_intm_no       giis_intermediary.intm_no%TYPE, --VARCHAR2,
        p_intm_type     VARCHAR2,
        p_month         VARCHAR2,
        p_user          VARCHAR2
    ) RETURN rep_tab PIPELINED;
   
    -- end SR-3570
END;
/


