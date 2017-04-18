CREATE OR REPLACE PACKAGE CPI.GIACR163A_PKG
AS

    TYPE detail_type IS RECORD(
        header_img_path     VARCHAR2(1000),
        company_name        VARCHAR2(100),
        company_address     VARCHAR2(100),
        company_number      VARCHAR2(100),
        company_tin         VARCHAR2(100),
        company_email       VARCHAR2(100),
        company_website     VARCHAR2(100),
        print_details       VARCHAR2(1),
        
        intm_no             giac_parent_comm_voucher.INTM_NO%type,
        intm_name           VARCHAR2(300),
        chld_intm_no        giac_parent_comm_voucher.CHLD_INTM_NO%type,
        iss_cd              giac_parent_comm_voucher.ISS_CD%type,
        prem_seq_no         giac_parent_comm_voucher.PREM_SEQ_NO%type,
        ref_no              giac_parent_comm_voucher.REF_NO%type,
        policy_id           giac_parent_comm_voucher.POLICY_ID%type,
        policy_no           giac_parent_comm_voucher.POLICY_NO%type,
        assd_no             giac_parent_comm_voucher.ASSD_NO%type,
        assd_name           giis_assured.ASSD_NAME%type,
        bill_no             VARCHAR2(20)      
    );
    
    TYPE detail_tab IS TABLE OF detail_type;
    
    
    FUNCTION populate_report(
        p_intm_no           giac_parent_comm_voucher.INTM_NO%type,
        p_comm_vcr_no       VARCHAR2
    ) RETURN detail_tab PIPELINED;
    
    
    TYPE peril_type IS RECORD(        
        peril_sname         giis_peril.PERIL_SNAME%type,
        prem_amt         giac_parent_comm_invprl.PREMIUM_AMT%type,
        comm_rt          giac_parent_comm_invprl.COMMISSION_RT%type,
        comm_amt         giac_parent_comm_invprl.COMMISSION_AMT%type  
    );
    
    TYPE peril_tab IS TABLE OF peril_type;
    
    
    FUNCTION get_peril(
        p_intm_no       giac_parent_comm_voucher.INTM_NO%type,
        p_chld_intm_no  giac_parent_comm_voucher.CHLD_INTM_NO%type,
        p_iss_cd        giac_parent_comm_voucher.ISS_CD%type,
        p_prem_seq_no   giac_parent_comm_voucher.PREM_SEQ_NO%type
    ) RETURN peril_tab PIPELINED;

    
    TYPE totals_type IS RECORD(
        sum_comm        NUMBER(16,2),
        sum_ivat        NUMBER(16,2),
        sum_whtax_n     NUMBER(16,2),
        sum_adv_n       NUMBER(16,2),
        total           NUMBER(16,2),
        net_due         NUMBER(16,2)
    );
    
    TYPE totals_tab IS TABLE OF totals_type;
    
    FUNCTION compute_totals (
        p_intm_no           giac_parent_comm_voucher.INTM_NO%type,
        p_comm_vcr_no       VARCHAR2
    ) RETURN totals_tab PIPELINED;
    
END GIACR163A_PKG;
/


