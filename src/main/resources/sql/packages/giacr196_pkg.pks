CREATE OR REPLACE PACKAGE CPI.GIACR196_PKG
AS
    /* report variables */
    dsp_name2       varchar2(200);
    
    TYPE report_details_type IS RECORD(
        company_name        varchar2(200),
        company_address     varchar2(350),
        print_company       varchar2(1),
        cf_title            varchar2(100),
        cf_date_label       varchar2(100),
        cf_date             DATE,
        cf_date_tag1        varchar2(300),
        cf_date_tag2        varchar2(300),
        print_date_tag      varchar2(1),
        print_user_id       varchar2(1),
        
        branch_cd           GIAC_SOA_REP_EXT.BRANCH_CD%type,
        cf_branch_name      GIIS_ISSOURCE.ISS_NAME%type,   
        intm_no             GIAC_SOA_REP_EXT.INTM_NO%type,
        intm_name           GIAC_SOA_REP_EXT.INTM_NAME%type,
        cf_ref_intm_cd      GIIS_INTERMEDIARY.REF_INTM_CD%type,   
        cf_intm_add         varchar2(250),
        intm_type           GIAC_SOA_REP_EXT.INTM_TYPE%type,
        col_no              giac_soa_title.COL_NO%type,
        column_title        GIAC_SOA_REP_EXT.COLUMN_TITLE%type, 
        policy_no           GIAC_SOA_REP_EXT.POLICY_NO%type,
        ref_pol_no          GIAC_SOA_REP_EXT.REF_POL_NO%type,
        assd_no             GIAC_SOA_REP_EXT.ASSD_NO%type,
        assd_name           GIAC_SOA_REP_EXT.ASSD_NAME%type,
        bill_no             varchar2(20),
        iss_cd              GIAC_SOA_REP_EXT.ISS_CD%type,
        due_date            GIAC_SOA_REP_EXT.DUE_DATE%type,
        no_of_days          GIAC_SOA_REP_EXT.NO_OF_DAYS%type,
        prem_seq_no         GIAC_SOA_REP_EXT.PREM_SEQ_NO%type,
        balance_amt_due     GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%type,
        prem_bal_due        GIAC_SOA_REP_EXT.PREM_BAL_DUE%type,
        tax_bal_due         GIAC_SOA_REP_EXT.TAX_BAL_DUE%type,
        cf_comm_amt         number,
        cf_net_amt          number,
        
        cf_label            varchar2(100),
        cf_signatory        varchar2(100),
        cf_designation      varchar2(100),
        print_signatory     varchar2(1),
        print_footer_date   varchar2(1)
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
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
        p_user_id   IN  GIAC_SOA_REP_EXT.USER_ID%type
    ) RETURN VARCHAR2;
        
           
    FUNCTION CF_LABEL
        RETURN VARCHAR2;
        
       
    FUNCTION CF_SIGNATORY
        RETURN VARCHAR2;
        
       
    FUNCTION CF_DESIGNATION
        RETURN VARCHAR2;
        
    
    FUNCTION CF_BRANCH_NAME(
        p_branch_cd     giis_issource.ISS_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_REF_INTM_CD(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_INTM_ADD(
        p_intm_no       GIIS_INTERMEDIARY.INTM_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_COMM_AMT(
        p_cut_off       giac_acctrans.TRAN_DATE%type,
        p_intm_no       giac_comm_payts.INTM_NO%type,
        p_iss_cd        giac_comm_payts.ISS_CD%type,
        p_prem_seq_no   giac_comm_payts.PREM_SEQ_NO%type
    ) RETURN NUMBER;
    
    
    FUNCTION CF_NET_AMT(
        p_balance_amt_due   GIAC_SOA_REP_EXT.BALANCE_AMT_DUE%type,
        p_cf_comm_amt       NUMBER
    ) RETURN NUMBER;
    
    
    FUNCTION GET_REPORT_DETAILS(
        p_branch_cd     giac_soa_rep_ext.BRANCH_CD%type,
        p_intm_no       giac_soa_rep_ext.INTM_NO%type,
        p_intm_type     giac_soa_rep_ext.INTM_TYPE%type,
        p_inc_overdue   giac_soa_rep_ext.DUE_TAG%type,
        p_cut_off       giac_acctrans.TRAN_DATE%type,
        p_user          giac_soa_rep_ext.USER_ID%type
    
    ) RETURN report_details_tab PIPELINED;    
    

END GIACR196_PKG;
/


