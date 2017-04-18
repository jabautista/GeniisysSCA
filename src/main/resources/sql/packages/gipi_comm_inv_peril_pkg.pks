CREATE OR REPLACE PACKAGE CPI.GIPI_COMM_INV_PERIL_PKG AS
    /**
    * Rey Jadlocon
    * 08.05.2011
    * invoice commission
    **/
    TYPE invoice_commission_type IS RECORD(
        peril_cd              GIPI_COMM_INV_PERIL.PERIL_CD%TYPE,
        premium_amt           GIPI_COMM_INV_PERIL.PREMIUM_AMT%TYPE,
        peril_name            GIIS_PERIL.PERIL_NAME%TYPE,
        policy_id             GIPI_COMM_INV_PERIL.POLICY_ID%TYPE,
        wholding_tax          GIPI_COMM_INV_PERIL.WHOLDING_TAX%TYPE,
        commission_rt         GIPI_COMM_INV_PERIL.COMMISSION_RT%TYPE,
        commission_amt        GIPI_COMM_INV_PERIL.COMMISSION_AMT%TYPE,
        net_com_amt           GIPI_COMM_INV_PERIL.COMMISSION_AMT%TYPE,
        intm_no               GIIS_INTERMEDIARY.INTM_NO%TYPE,
        intm_name             GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        parent_intm_no        GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE,
        ref_intm_cd           GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
        total_commission      GIPI_COMM_INV_PERIL.COMMISSION_AMT%TYPE,
        total_tax_wholding    GIPI_COMM_INV_PERIL.WHOLDING_TAX%TYPE,    
        intm_cd_name          varchar2 (100),
        share_percentage      GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE,
        prem_seq_no           GIPI_COMM_INV_PERIL.PREM_SEQ_NO%TYPE,
        share_prem            GIPI_COMM_INV_PERIL.PREMIUM_AMT%TYPE
    );
    TYPE invoice_commission_tab IS TABLE OF invoice_commission_type;
    
    TYPE invoice_intermediary_type IS RECORD(
        intm_no               GIIS_INTERMEDIARY.INTM_NO%TYPE,
        intm_name             GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        ref_intm_cd           GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
        parent_intm_no        GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE,
        share_percentage      GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE,
        share_prem            GIPI_COMM_INV_PERIL.PREMIUM_AMT%TYPE,
        policy_id             GIPI_COMM_INV_PERIL.policy_id%TYPE,            
        prem_seq_no           GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
        total_comm            GIPI_COMM_INV_PERIL.commission_amt%TYPE,
        total_wtax            GIPI_COMM_INV_PERIL.wholding_tax%TYPE,
        net_comm              GIPI_COMM_INV_PERIL.commission_amt%TYPE
    );
    TYPE invoice_intermediary_tab IS TABLE OF invoice_intermediary_type;
    
    TYPE invoice_intermediary_dtls_type IS RECORD(
        peril_cd              GIPI_COMM_INV_PERIL.PERIL_CD%TYPE,
        premium_amt           GIPI_COMM_INV_PERIL.PREMIUM_AMT%TYPE,
        peril_name            GIIS_PERIL.PERIL_NAME%TYPE,
        policy_id             GIPI_COMM_INV_PERIL.POLICY_ID%TYPE,
        wholding_tax          GIPI_COMM_INV_PERIL.WHOLDING_TAX%TYPE,
        commission_rt         GIPI_COMM_INV_PERIL.COMMISSION_RT%TYPE,
        commission_amt        GIPI_COMM_INV_PERIL.COMMISSION_AMT%TYPE,
        intm_no               GIIS_INTERMEDIARY.INTM_NO%TYPE,
        prem_seq_no           GIPI_COMM_INV_PERIL.PREM_SEQ_NO%TYPE,
        net_com_amt           GIPI_COMM_INV_PERIL.COMMISSION_AMT%TYPE
    );
    TYPE invoice_intermediary_dtls_tab IS TABLE OF invoice_intermediary_dtls_type;
    
    --added by hdrtagudin 07232015 SR 19824
    TYPE bond_invoice_intermediary_type IS RECORD(
        intm_no               GIIS_INTERMEDIARY.INTM_NO%TYPE,
        intm_name             GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        ref_intm_cd           GIIS_INTERMEDIARY.REF_INTM_CD%TYPE,
        parent_intm_no        GIIS_INTERMEDIARY.PARENT_INTM_NO%TYPE,
        parent_intm_name      GIIS_INTERMEDIARY.INTM_NAME%TYPE,
        share_percentage      GIPI_COMM_INVOICE.SHARE_PERCENTAGE%TYPE,
        share_prem            GIPI_COMM_INV_PERIL.PREMIUM_AMT%TYPE,
        policy_id             GIPI_COMM_INV_PERIL.policy_id%TYPE,            
        prem_seq_no           GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
        total_comm            GIPI_COMM_INV_PERIL.commission_amt%TYPE,
        wholding_tax          GIPI_COMM_INV_PERIL.wholding_tax%TYPE,
        net_comm              GIPI_COMM_INV_PERIL.commission_amt%TYPE,
        commission_rt         GIPI_COMM_INV_PERIL.commission_rt%TYPE
    );
    TYPE bond_invoice_intermediary_tab IS TABLE OF bond_invoice_intermediary_type;
    
    FUNCTION get_invoice_commission(p_policy_id    gipi_comm_inv_peril.policy_id%TYPE,
                                    p_prem_seq_no  gipi_comm_inv_peril.prem_seq_no%TYPE,
                                    p_line_cd      giis_peril.line_cd%TYPE)
      RETURN invoice_commission_tab PIPELINED;
           
    FUNCTION get_invoice_intermediaries(p_policy_id    GIPI_COMM_INV_PERIL.policy_id%TYPE,
                                        p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
                                        p_line_cd      GIIS_PERIL.line_cd%TYPE)
      RETURN invoice_intermediary_tab PIPELINED;
      
    FUNCTION get_invoice_commission_dtls(p_policy_id    gipi_comm_inv_peril.policy_id%TYPE,
                                         p_prem_seq_no  gipi_comm_inv_peril.prem_seq_no%TYPE,
                                         p_line_cd      giis_peril.line_cd%TYPE,
                                         p_intm_no      gipi_comm_inv_peril.intrmdry_intm_no%TYPE)
      RETURN invoice_intermediary_dtls_tab PIPELINED;
      
      --added by hdrtagudin 07232015 SR 19824
      FUNCTION get_bond_intermediaries(p_policy_id    GIPI_COMM_INV_PERIL.policy_id%TYPE,
                                        p_prem_seq_no  GIPI_COMM_INV_PERIL.prem_seq_no%TYPE,
                                        p_line_cd      GIIS_PERIL.line_cd%TYPE)
                                         RETURN bond_invoice_intermediary_tab PIPELINED;
END GIPI_COMM_INV_PERIL_PKG;
/


