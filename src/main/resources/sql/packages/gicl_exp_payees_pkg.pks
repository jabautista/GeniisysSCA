CREATE OR REPLACE PACKAGE CPI.GICL_EXP_PAYEES_PKG AS

    TYPE gicl_exp_payees_type IS RECORD(
        claim_id            GICL_EXP_PAYEES.claim_id%TYPE,
        payee_class_cd      GICL_EXP_PAYEES.payee_class_cd%TYPE,
        payee_class_desc    GIIS_PAYEE_CLASS.class_desc%TYPE,
        adj_company_cd      GICL_EXP_PAYEES.adj_company_cd%TYPE,
        adj_company_name    VARCHAR2(1000),
        priv_adj_cd         GICL_EXP_PAYEES.priv_adj_cd%TYPE,
        adj_name            VARCHAR2(1000),
        mail_addr1          GIIS_PAYEES.mail_addr1%TYPE,
        mail_addr2          GIIS_PAYEES.mail_addr2%TYPE,
        mail_addr3          GIIS_PAYEES.mail_addr3%TYPE,
        phone_no            GIIS_PAYEES.phone_no%TYPE,
        assign_date         GICL_EXP_PAYEES.assign_date%TYPE,
        clm_paid            GICL_EXP_PAYEES.clm_paid%TYPE,
        remarks             GICL_EXP_PAYEES.remarks%TYPE,
        user_id             GICL_EXP_PAYEES.user_id%TYPE,
        last_update         GICL_EXP_PAYEES.last_update%TYPE
    );

    TYPE gicl_exp_payees_tab IS TABLE OF gicl_exp_payees_type;

    FUNCTION get_gicl_exp_payees(p_claim_id   IN   GICL_EXP_PAYEES.claim_id%TYPE)
     RETURN gicl_exp_payees_tab PIPELINED;
	 
	FUNCTION check_exist_exp_payees(p_claim_id  IN    GICL_EXP_PAYEES.claim_id%TYPE)
     RETURN VARCHAR2;
	 
END gicl_exp_payees_pkg;
/


