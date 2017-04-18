CREATE OR REPLACE PACKAGE CPI.GIACR078_PKG
AS
    
    TYPE report_header_type IS RECORD(
        company_name        GIIS_PARAMETERS.PARAM_VALUE_V%type,
        company_address     GIIS_PARAMETERS.PARAM_VALUE_V%type,
        rundate             VARCHAR2(20),
        cf_date             VARCHAR2(100),
        print_company       VARCHAR2(1)
    );
    
    TYPE report_header_tab IS TABLE OF report_header_type;
    
    FUNCTION get_report_header(
        p_date_from     giac_coll_analysis_ext.DATE_FROM%type,
        p_date_to       giac_coll_analysis_ext.DATE_TO%type,
        p_date_tag      VARCHAR2
    ) RETURN report_header_tab PIPELINED;
    
    
    TYPE report_details_type IS RECORD(
        branch_intm         VARCHAR2(240),
        policy_no           giac_coll_analysis_ext.POLICY_NO%type,
        or_no               VARCHAR2(16),
        iss_cd              giac_coll_analysis_ext.ISS_CD%type,
        prem_seq_no         giac_coll_analysis_ext.PREM_SEQ_NO%type,
        payor               giac_coll_analysis_ext.PAYOR%type,
        intm_no             giac_coll_analysis_ext.INTM_NO%type,
        intm_name           giac_coll_analysis_ext.INTM_NAME%type,
        effect_date         VARCHAR2(20),
        age                 giac_coll_analysis_ext.AGE%type,
        amount              giac_coll_analysis_ext.AMOUNT%type,
        cf_inv_no           VARCHAR2(20),
        cf_column_no        NUMBER(10),
        cf_amount           NUMBER(12,2)         
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    FUNCTION CF_INV_NO(
        p_iss_cd        giac_coll_analysis_ext.ISS_CD%type,
        p_prem_seq_no   giac_coll_analysis_ext.PREM_SEQ_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_COLUMN_NO(
        p_age   giac_coll_analysis_ext.AGE%type
    ) RETURN NUMBER;
    
    
    FUNCTION get_report_details(
        p_date_from     giac_coll_analysis_ext.DATE_FROM%type,
        p_date_to       giac_coll_analysis_ext.DATE_TO%type,
        p_rep_type      VARCHAR2,
        p_branch_cd     giac_coll_analysis_ext.BRANCH_CD%type,
        p_intm_no       giac_coll_analysis_ext.INTM_NO%type,
        p_user          giac_coll_analysis_ext.USER_ID%type
    ) RETURN report_details_tab PIPELINED;
    
    
    TYPE coll_analysis_title_type IS RECORD (
        column_no       giac_coll_analysis_title.COLUMN_NO%type,
        column_title    giac_coll_analysis_title.COLUMN_TITLE%type
    );
    
    TYPE coll_analysis_title_tab IS TABLE OF coll_analysis_title_type;
    
    FUNCTION get_analysis_title
        RETURN coll_analysis_title_tab PIPELINED;
        
    TYPE analysis_column_details_type IS RECORD(
        branch_intm     VARCHAR2(240),
        policy_no       giac_coll_analysis_ext.POLICY_NO%type,
        or_no           VARCHAR2(16),
        intm_no         giac_coll_analysis_ext.INTM_NO%type,
        age             giac_coll_analysis_ext.AGE%type,
        column_no       giac_coll_analysis_title.COLUMN_NO%type,
        column_title    giac_coll_analysis_title.COLUMN_TITLE%type,
        cf_amount       NUMBER(12,2)
    );
    
    TYPE analysis_column_details_tab IS TABLE OF analysis_column_details_type;
    
    FUNCTION get_analysis_column_details(
        p_date_from     giac_coll_analysis_ext.DATE_FROM%type,
        p_date_to       giac_coll_analysis_ext.DATE_TO%type,
        p_rep_type      VARCHAR2,
        p_branch_cd     giac_coll_analysis_ext.BRANCH_CD%type,
        p_intm_no       giac_coll_analysis_ext.INTM_NO%type,
        p_user          giac_coll_analysis_ext.USER_ID%type,
        p_branch_intm   VARCHAR2,
        p_policy_no     giac_coll_analysis_ext.POLICY_NO%type,
        p_or_no         VARCHAR2,
        --intm_no         giac_coll_analysis_ext.INTM_NO%type,
        p_age           giac_coll_analysis_ext.AGE%type
    ) RETURN analysis_column_details_tab PIPELINED;
    

END GIACR078_PKG;
/


