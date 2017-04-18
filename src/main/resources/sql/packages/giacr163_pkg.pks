CREATE OR REPLACE PACKAGE CPI.GIACR163_PKG
AS

    TYPE detail_type IS RECORD(
        header_img_path     VARCHAR2(1000),
        print_details       VARCHAR2(1),
        cf_agent_cd         VARCHAR2(8),
        cf_agent_name       giis_intermediary.INTM_NAME%type,
        cf_ocv_no           VARCHAR2(15),
        --cf_cv_date        VARCHAR2(20),
        policy_no           giac_parent_comm_voucher.POLICY_NO%type,
        assd_no             giac_parent_comm_voucher.ASSD_NO%type,
        assd_name           giis_assured.ASSD_NAME%type,
        iss_cd              giac_parent_comm_invprl.ISS_CD%type,
        prem_seq_no         giac_parent_comm_invprl.PREM_SEQ_NO%type,
        bill_no             VARCHAR2(20),
        cv_number           VARCHAR2(20),
        cvdate              giac_parent_comm_voucher.PRINT_DATE%type,
        created_by          giac_parent_comm_voucher.USER_ID%type,
        cf_policy_ctr       NUMBER(10),
        cf_policy_id        gipi_invoice.POLICY_ID%type,
        cf_line_cd          gipi_polbasic.LINE_CD%type,
        tax                 NUMBER(16,3),
        cf_wtax_i           NUMBER(16,3),
        cf_input_vat_i      NUMBER(16,3),
        cf_adv              NUMBER(16,3)
    );
    
    TYPE detail_tab IS TABLE OF detail_type;
    
    
    FUNCTION CF_AGENT_CD(
        p_intm_no       giis_intermediary.INTM_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_AGENT_NAME(
        p_intm_no       giis_intermediary.INTM_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_POLICY_ID(
        p_iss_cd        giac_parent_comm_voucher.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_voucher.PREM_SEQ_NO%type
    ) RETURN NUMBER;
    
    
    FUNCTION CF_LINE_CD(
        p_policy_id     gipi_invoice.POLICY_ID%type
    ) RETURN VARCHAR;
    
    
    PROCEDURE CF_PARTIAL_AMT(
        p_iss_cd        IN  GIPI_COMM_INV_PERIL.ISS_CD%type,
        p_prem_seq_no   IN  GIPI_COMM_INV_PERIL.PREM_SEQ_NO%type,
        p_premium_amt   IN  GIPI_COMM_INV_PERIL.PREMIUM_AMT%type,
        p_comm_amt      IN  GIAC_PARENT_COMM_INVPRL.COMMISSION_AMT%type,
        p_partial_comm  OUT NUMBER,
        p_partial_prem  OUT NUMBER
    );
    
    
    FUNCTION CF_WTAX_I(
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN NUMBER;
    
    
    FUNCTION CF_INPUT_VAT_I(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN NUMBER;
    
    
    FUNCTION CF_ADV(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN NUMBER;
    
    
    FUNCTION populate_report(
        p_intm_no           giac_parent_comm_voucher.INTM_NO%type,
        p_commv_pref        giac_parent_comm_voucher.OCV_PREF_SUF%type,
        p_comm_vcr_no       VARCHAR2,
        p_cv_date           VARCHAR2,
        p_user              giac_parent_comm_voucher.USER_ID%type
    ) RETURN detail_tab PIPELINED;

    
    TYPE q1_type IS RECORD(
        tran_date           giac_acctrans.TRAN_DATE%type,
        ref_no              VARCHAR2(50)
    );
    
    TYPE q1_tab IS TABLE OF q1_type;
    
    
    FUNCTION get_tran_date_ref_no(
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type
    ) RETURN q1_tab PIPELINED;
    
    
    TYPE amounts_type IS RECORD(
        peril_sname         giis_peril.PERIL_SNAME%type,
        comm_rt             GIAC_PARENT_COMM_INVPRL.COMMISSION_RT%type,
        partial_comm        NUMBER(16,3),
        partial_prem        NUMBER(16,3)    
    );
    
    TYPE amounts_tab IS TABLE OF amounts_type;
    
    
    FUNCTION get_policy_amounts(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_iss_cd        giac_parent_comm_invprl.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_invprl.PREM_SEQ_NO%type,
        p_cf_policy_id  gipi_invoice.POLICY_ID%type,
        p_cf_line_cd    gipi_polbasic.LINE_CD%type  
    ) RETURN amounts_tab PIPELINED;
    
    
    TYPE signatory_type IS RECORD(
        label               GIAC_REP_SIGNATORY.LABEL%type,
        signatory           GIIS_SIGNATORY_NAMES.SIGNATORY%type,
        designation         GIIS_SIGNATORY_NAMES.DESIGNATION%type,
        item_no             GIAC_REP_SIGNATORY.ITEM_NO%type 
    );
    
    TYPE signatory_tab IS TABLE OF signatory_type;
    
    
    FUNCTION get_signatories(
        p_user          GIAC_USERS.USER_ID%type,       
        p_branch_cd     GIAC_DOCUMENTS.BRANCH_CD%type
    ) RETURN signatory_tab PIPELINED;
        
        
END GIACR163_PKG;
/


