CREATE OR REPLACE PACKAGE CPI.GICL_CLM_CLAIMANT_PKG AS

    TYPE gicl_clm_claimant_type IS RECORD(
        claim_id            GICL_CLM_CLAIMANT.claim_id%TYPE,
        clm_clmnt_no        GICL_CLM_CLAIMANT.clm_clmnt_no%TYPE,
        clmnt_no            GICL_CLM_CLAIMANT.clmnt_no%TYPE,
        payee_class_cd      GICL_CLM_CLAIMANT.payee_class_cd%TYPE,
        payee_class_desc    GIIS_PAYEE_CLASS.class_desc%TYPE,
        payee               VARCHAR2(1000),
        mail_addr1          GIIS_PAYEES.mail_addr1%TYPE,
        mail_addr2          GIIS_PAYEES.mail_addr2%TYPE,
        mail_addr3          GIIS_PAYEES.mail_addr3%TYPE,
        phone_no            GIIS_PAYEES.phone_no%TYPE,
        fax_no              GIIS_PAYEES.fax_no%TYPE,
        user_id             GICL_CLM_CLAIMANT.user_id%TYPE,
        last_update         GICL_CLM_CLAIMANT.last_update%TYPE,
        clm_paid            GICL_CLM_CLAIMANT.clm_paid%TYPE,
        remarks             GICL_CLM_CLAIMANT.remarks%TYPE,
        mc_payee_cd         GICL_CLM_CLAIMANT.mc_payee_cd%TYPE,
        mc_payee_name       VARCHAR2(1000),
        sdf_last_update     VARCHAR2(30) --added by steven 06.03.2013
        
    );

    TYPE gicl_clm_claimant_tab IS TABLE OF gicl_clm_claimant_type;

    FUNCTION get_gicl_clm_claimant(p_claim_id   IN   GICL_CLM_CLAIMANT.claim_id%TYPE)
     RETURN gicl_clm_claimant_tab PIPELINED;
    
END gicl_clm_claimant_pkg;
/


