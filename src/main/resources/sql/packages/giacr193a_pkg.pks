CREATE OR REPLACE PACKAGE CPI.GIACR193A_PKG
AS

    /* report variables */
    rep_date_format     varchar2(20);
    
    
    TYPE report_header_type IS RECORD(
        company_name        GIAC_PARAMETERS.param_value_v%type,
        company_address     GIAC_PARAMETERS.param_value_v%type,
        print_company       varchar2(1),
        title               varchar2(100),
        date_label          varchar2(100),
        paramdate           date,
        date_tag1           varchar2(300),
        date_tag2           varchar2(300),
        print_date_tag      varchar2(1),
        rundate             varchar2(20),
        print_footer_date   varchar2(1),
        print_user_id       varchar2(1)
    );
    
    TYPE report_header_tab IS TABLE OF report_header_type;
    
    
    PROCEDURE BEFOREREPORT;
        
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
        
    FUNCTION CF_TITLE
        RETURN VARCHAR2;
        
    FUNCTION CF_DATE_LABEL
        RETURN VARCHAR2;
        
    FUNCTION CF_DATE(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN DATE;
        
    FUNCTION CF_DATE_TAG1(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN VARCHAR2;
       
    FUNCTION CF_DATE_TAG2(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN VARCHAR2;
                
        
    FUNCTION GET_REPORT_HEADER(
        p_user_id   GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN report_header_tab PIPELINED;
            
    
    TYPE report_parent_type IS RECORD(
        branch_cd           giac_soa_rep_ext.BRANCH_CD%type,  
        cf_branch_name      giac_branches.BRANCH_NAME%type,
        incept_date         varchar2(20), --giac_soa_rep_ext.INCEPT_DATE%type,
        intm_type           giac_soa_rep_ext.INTM_TYPE%type,
        cf_intm_desc        giis_intm_type.INTM_DESC%type,
        cf_intm_add         varchar2(250),
        intm_no             giac_soa_rep_ext.INTM_NO%type,
        intm_name           giac_soa_rep_ext.INTM_NAME%type, 
        ref_intm_cd         giis_intermediary.REF_INTM_CD%type,
        column_title        giac_soa_rep_ext.COLUMN_TITLE%type,
        line_cd             giis_line.LINE_CD%type,
        cf_line_name        giis_line.LINE_NAME%type,
        column_no           giac_soa_rep_ext.COLUMN_NO%type,
        policy_no           giac_soa_rep_ext.POLICY_NO%type,
        bill_no             varchar2(20),
        ref_pol_no          giac_soa_rep_ext.REF_POL_NO%type,
        no_of_days          giac_soa_rep_ext.NO_OF_DAYS%type,
        assd_name           giac_soa_rep_ext.ASSD_NAME%type,
        assd_no             giac_soa_rep_ext.ASSD_NO%type,
        due_date            varchar2(20), --giac_soa_rep_ext.DUE_DATE%type,
        prem_bal_due        giac_soa_rep_ext.PREM_BAL_DUE%type,
        tax_bal_due         giac_soa_rep_ext.TAX_BAL_DUE%type,
        balance_amt_due     giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        iss_cd              giac_soa_rep_ext.ISS_CD%type,
        prem_seq_no         giac_soa_rep_ext.PREM_SEQ_NO%type,
        inst_no             giac_soa_rep_ext.INST_NO%type,
        user_id             giac_soa_rep_ext.USER_ID%type,
        label               varchar2(100),
        signatory           varchar2(100),
        designation         varchar2(100),
        print_branch_totals varchar2(1),
        print_signatory     varchar2(1)
    );
    
    TYPE report_parent_tab IS TABLE OF report_parent_type;
    
    FUNCTION CF_LABEL
        RETURN VARCHAR2;
        
    FUNCTION CF_SIGNATORY
        RETURN VARCHAR2;
        
    FUNCTION CF_DESIGNATION
        RETURN VARCHAR2;
        
    FUNCTION CF_BRANCH_NAME (
        p_branch_cd     GIAC_BRANCHES.BRANCH_CD%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION CF_INTM_DESC (
        p_intm_type     GIIS_INTM_TYPE.INTM_TYPE%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION CF_INTM_ADD(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION CF_LINE_NAME(
        p_line_cd       GIIS_LINE.LINE_CD%TYPE
    ) RETURN VARCHAR2;
    
    FUNCTION GET_REPORT_PARENT_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN report_parent_tab PIPELINED;
    
    
    TYPE tax_header_type IS RECORD(
        tax_cd      giac_taxes.TAX_CD%type,
        tax_name    giac_taxes.TAX_NAME%type
    );
    
    TYPE tax_header_tab IS TABLE OF tax_header_type;
    
    FUNCTION GET_TAX_HEADER
        RETURN tax_header_tab PIPELINED;
        
    
    TYPE tax_details_type IS RECORD(
        branch_cd       giac_soa_rep_ext.BRANCH_CD%type,     
        intm_type       giac_soa_rep_ext.INTM_TYPE%type,
        intm_no         giac_soa_rep_ext.INTM_NO%type,
        column_title    giac_soa_rep_ext.COLUMN_TITLE%type,
        line_cd         giis_line.LINE_CD%type,
        tax_cd          giac_taxes.TAX_CD%type,
        tax_name        giac_taxes.TAX_NAME%type,
        tax_bal_due     giac_soa_rep_tax_ext.TAX_BAL_DUE%type,
        iss_cd          giac_soa_rep_ext.ISS_CD%type,
        prem_seq_no     giac_soa_rep_ext.PREM_SEQ_NO%type,
        inst_no         giac_soa_rep_ext.INST_NO%type,
        user_id         giac_soa_rep_ext.USER_ID%type
    );
    
    TYPE tax_details_tab IS TABLE OF tax_details_type;
    
    FUNCTION GET_REPORT_TAX_DETAILS (
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type,
        p_column_title  giac_soa_rep_ext.COLUMN_TITLE%type,
        p_line_cd       giis_line.LINE_CD%type,
        p_iss_cd        giac_soa_rep_ext.ISS_CD%type,
        p_prem_seq_no   giac_soa_rep_ext.PREM_SEQ_NO%type,
        p_inst_no       giac_soa_rep_ext.INST_NO%type
    ) RETURN tax_details_tab PIPELINED;
    
    
    FUNCTION GET_LINE_TAX_DETAILS (
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type,
        p_column_title  giac_soa_rep_ext.COLUMN_TITLE%type,
        p_line_cd       giis_line.LINE_CD%type
    ) RETURN tax_details_tab PIPELINED;
    
    
    FUNCTION GET_COL_TAX_DETAILS (
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type,
        p_column_title  giac_soa_rep_ext.COLUMN_TITLE%type
    ) RETURN tax_details_tab PIPELINED;
    
    
    FUNCTION GET_INTM_NO_TAX_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN tax_details_tab PIPELINED;
    
    
    FUNCTION GET_INTM_TYPE_TAX_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN tax_details_tab PIPELINED;
    
    
    FUNCTION GET_BRANCH_TAX_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_bal_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    ) RETURN tax_details_tab PIPELINED;
    
    TYPE giacr193a_csv_type IS RECORD (
       branch              giac_branches.branch_name%TYPE,
       intermediary_type   giis_intm_type.intm_desc%TYPE,
       intermediay_no      giac_soa_rep_ext.intm_no%TYPE,
       ref_intm_cd         giis_intermediary.ref_intm_cd%TYPE,
       intermediay_name    giac_soa_rep_ext.intm_name%TYPE,
       address             VARCHAR2 (250),
       column_title        giac_soa_rep_ext.column_title%TYPE,
       line                giis_line.line_name%TYPE,
       policy              giac_soa_rep_ext.policy_no%TYPE,
       ref_pol_no          giac_soa_rep_ext.ref_pol_no%TYPE,
       assured             giac_soa_rep_ext.assd_name%TYPE,
       bill_no             VARCHAR2 (20),
       incept_date         giac_soa_rep_ext.incept_date%TYPE,
       due_date            giac_soa_rep_ext.due_date%TYPE,
       age                 giac_soa_rep_ext.no_of_days%TYPE,
       premium_amt         giac_soa_rep_ext.prem_bal_due%TYPE,
       doc_stamps          NUMBER,
       fst                 NUMBER,
       evat                NUMBER,
       lgt                 NUMBER,
       prem_tax            NUMBER,
       other_taxes         NUMBER,
       balance_amt         giac_soa_rep_ext.balance_amt_due%TYPE
   );
    
    TYPE giacr193a_csv_tab IS TABLE OF giacr193a_csv_type;
    
    FUNCTION get_giacr193a_csv (
       p_bal_amt_due   NUMBER,
       p_user          VARCHAR2,
       p_intm_no       NUMBER,
       p_intm_type     VARCHAR2,
       p_branch_cd     VARCHAR2,
       p_inc_overdue   VARCHAR2
    )
      RETURN giacr193a_csv_tab PIPELINED;
      
    TYPE csv_col_type IS RECORD (
      col_name VARCHAR2(100)
    );
   
   TYPE csv_col_tab IS TABLE OF csv_col_type;
       
   FUNCTION get_csv_cols
      RETURN csv_col_tab PIPELINED;      
    
        
END GIACR193A_PKG;
/


