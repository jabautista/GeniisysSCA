CREATE OR REPLACE PACKAGE CPI.GIACR328_PKG
AS
   TYPE giacr328_rec_type IS RECORD (
      cf_company_name   giis_parameters.param_value_v%TYPE,
      cf_company_add    VARCHAR2 (500),
      cf_title          VARCHAR2 (500),
      prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
      intm_no           giac_aging_prem_paid_ext.intm_no%TYPE,
      line_cd           giac_aging_prem_paid_ext.line_cd%TYPE,
      ref_intm_cd       giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
      invoice_no        giac_aging_prem_paid_ext.invoice_no%TYPE,
      policy_no         giac_aging_prem_paid_ext.policy_no%TYPE,
      iss_cd            giac_aging_prem_paid_ext.iss_cd%TYPE,
      eff_date          giac_aging_prem_paid_ext.eff_date%TYPE,
      incept_date       giac_aging_prem_paid_ext.incept_date%TYPE,
      age               giac_aging_prem_paid_ext.age%TYPE,
      gross_prem_amt    giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      column_title      giis_report_aging.column_title%TYPE,
      prem              giac_aging_prem_paid_ext.prem_amt%TYPE
   );

   TYPE giacr328_rec_tab IS TABLE OF giacr328_rec_type;

   TYPE distinct_details_type IS RECORD (
      cf_company_name   giis_parameters.param_value_v%TYPE,
      cf_company_add    VARCHAR2 (500),
      cf_title          VARCHAR2 (500),
      prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
      intm_no           giac_aging_prem_paid_ext.intm_no%TYPE,
      line_cd           giac_aging_prem_paid_ext.line_cd%TYPE,
      ref_intm_cd       giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
      iss_cd            giac_aging_prem_paid_ext.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      intm_name         giis_intermediary.intm_name%TYPE,
      line_name         giis_line.line_name%TYPE,
      gross_prem_amt    giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      dummy_total       giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   );

   TYPE distinct_details_tab IS TABLE OF distinct_details_type;

   TYPE column_title_type IS RECORD (
      column_title   giis_report_aging.column_title%TYPE,
      dummy_row      NUMBER
   );

   TYPE column_title_tab IS TABLE OF column_title_type;

   TYPE column_details_type IS RECORD (
      prem_amt         giac_aging_prem_paid_ext.prem_amt%TYPE,
      intm_no          giac_aging_prem_paid_ext.intm_no%TYPE,
      line_cd          giac_aging_prem_paid_ext.line_cd%TYPE,
      ref_intm_cd      giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
      invoice_no       giac_aging_prem_paid_ext.invoice_no%TYPE,
      policy_no        giac_aging_prem_paid_ext.policy_no%TYPE,
      iss_cd           giac_aging_prem_paid_ext.iss_cd%TYPE,
      eff_date         giac_aging_prem_paid_ext.eff_date%TYPE,
      incept_date      giac_aging_prem_paid_ext.incept_date%TYPE,
      age              giac_aging_prem_paid_ext.age%TYPE,
      gross_prem_amt   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      iss_name         giis_issource.iss_name%TYPE,
      intm_name        giis_intermediary.intm_name%TYPE,
      line_name        giis_line.line_name%TYPE,
      column_title     giis_report_aging.column_title%TYPE,
      prem             giac_aging_prem_paid_ext.prem_amt%TYPE
   );

   TYPE column_details_tab IS TABLE OF column_details_type;

   FUNCTION get_giacr328_rec (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN giacr328_rec_tab PIPELINED;

   FUNCTION get_distinct_details (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_date        VARCHAR2
   )
      RETURN distinct_details_tab PIPELINED;

   FUNCTION get_column_title
      RETURN column_title_tab PIPELINED;

   FUNCTION get_column_details (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE
   )
      RETURN column_details_tab PIPELINED;

   TYPE giacr328_header_type IS RECORD (
      iss_cd            giis_issource.iss_cd%TYPE,
      iss_name          giis_issource.iss_name%TYPE,
      iss_cd_dummy      VARCHAR2 (100),
      col_no_1          giis_report_aging.column_no%TYPE,
      col_no_2          giis_report_aging.column_no%TYPE,
      col_no_3          giis_report_aging.column_no%TYPE,
      col_no_4          giis_report_aging.column_no%TYPE,
      col_name_1        giis_report_aging.column_title%TYPE,
      col_name_2        giis_report_aging.column_title%TYPE,
      col_name_3        giis_report_aging.column_title%TYPE,
      col_name_4        giis_report_aging.column_title%TYPE,
      cf_company_name   giis_parameters.param_value_v%TYPE,
      cf_company_add    VARCHAR2 (500),
      cf_title          VARCHAR2 (500),
      prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
      aging_value_1     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_2     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_3     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_4     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      v_flag            VARCHAR2 (1)
   );

   TYPE giacr328_header_tab IS TABLE OF giacr328_header_type;

   TYPE column_type IS RECORD (
      col_no        giis_report_aging.column_no%TYPE,
      col_name      giis_report_aging.column_title%TYPE,
      aging_value   giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   );

   TYPE column_tab IS TABLE OF column_type;

   FUNCTION get_giacr328_header (
      p_user_id     VARCHAR2,
      p_iss_cd      VARCHAR2,
      p_from_date   DATE,
      p_to_date     DATE,
      p_date        VARCHAR2
   )
      RETURN giacr328_header_tab PIPELINED;

   TYPE aging_values_type IS RECORD (
      col_no_1        giis_report_aging.column_no%TYPE,
      col_no_2        giis_report_aging.column_no%TYPE,
      col_no_3        giis_report_aging.column_no%TYPE,
      col_no_4        giis_report_aging.column_no%TYPE,
      aging_value_1   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_2   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_3   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      aging_value_4   giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      iss_cd          VARCHAR2 (100),
      policy_no       VARCHAR2 (100)
   );

   TYPE aging_values_tab IS TABLE OF aging_values_type;

   FUNCTION get_aging_values (
      p_iss_cd_dummy   VARCHAR2,
      p_user_id        VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_from_date      DATE,
      p_to_date        DATE,
      p_date           VARCHAR2,
      p_line_cd        VARCHAR2,
      p_intm_no        NUMBER,
      p_gross_prem     giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
      p_policy_no      VARCHAR2
   )
      RETURN aging_values_tab PIPELINED;

   FUNCTION get_aging_values_total (
      p_iss_cd_dummy   VARCHAR2,
      p_user_id        VARCHAR2,
      p_iss_cd         VARCHAR2,
      p_from_date      DATE,
      p_to_date        DATE,
      p_date           VARCHAR2,
      p_intm_no        NUMBER,
      p_gross_prem     giac_aging_prem_paid_ext.gross_prem_amt%TYPE
   )
      RETURN aging_values_tab PIPELINED;
      
      
    -- start SR-3247 : shan 07.28.2015
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
      no_of_dummy  NUMBER(10)
   );

   TYPE column_header_tab IS TABLE OF column_header_type;

   FUNCTION get_column_header
      RETURN column_header_tab PIPELINED;
      
      
    TYPE report_type IS RECORD(
        cf_company_name   giis_parameters.param_value_v%TYPE,
        cf_company_add    VARCHAR2 (500),
        cf_title          VARCHAR2 (500),
        prem_amt          giac_aging_prem_paid_ext.prem_amt%TYPE,
        intm_no           giac_aging_prem_paid_ext.intm_no%TYPE,
        line_cd           giac_aging_prem_paid_ext.line_cd%TYPE,
        ref_intm_cd       giac_aging_prem_paid_ext.ref_intm_cd%TYPE,
        invoice_no        giac_aging_prem_paid_ext.invoice_no%TYPE,
        policy_no         giac_aging_prem_paid_ext.policy_no%TYPE,
        iss_cd            giac_aging_prem_paid_ext.iss_cd%TYPE,
        eff_date          giac_aging_prem_paid_ext.eff_date%TYPE,
        due_date          giac_aging_prem_paid_ext.DUE_DATE%TYPE,
        ext_by_date       giac_aging_prem_paid_ext.eff_date%TYPE,
        incept_date       giac_aging_prem_paid_ext.incept_date%TYPE,
        age               giac_aging_prem_paid_ext.age%TYPE,
        gross_prem_amt    giac_aging_prem_paid_ext.gross_prem_amt%TYPE,
        iss_name          giis_issource.iss_name%TYPE,
        intm_name         giis_intermediary.intm_name%TYPE,
        line_name         giis_line.line_name%TYPE,
        prem              giac_aging_prem_paid_ext.prem_amt%TYPE,
        iss_cd_dummy      VARCHAR2 (100),
        col_no_1          giis_report_aging.column_no%TYPE,
        col_name_1        giis_report_aging.column_title%TYPE,
        col_prem_amt_1    giac_aging_prem_paid_ext.prem_amt%TYPE,
        col_no_2          giis_report_aging.column_no%TYPE,
        col_name_2        giis_report_aging.column_title%TYPE,
        col_prem_amt_2    giac_aging_prem_paid_ext.prem_amt%TYPE,
        col_no_3          giis_report_aging.column_no%TYPE,
        col_name_3        giis_report_aging.column_title%TYPE,
        col_prem_amt_3    giac_aging_prem_paid_ext.prem_amt%TYPE,
        col_no_4          giis_report_aging.column_no%TYPE,
        col_name_4        giis_report_aging.column_title%TYPE,
        col_prem_amt_4    giac_aging_prem_paid_ext.prem_amt%TYPE
    );
    
    TYPE report_tab IS TABLE OF report_type;
    
    FUNCTION get_report_details(
        p_user_id     VARCHAR2,
        p_iss_cd      VARCHAR2,
        p_from_date   DATE,
        p_to_date     DATE,
        p_date        VARCHAR2
    ) RETURN report_tab PIPELINED;
    -- end SR-3247
    
END GIACR328_PKG;
/


