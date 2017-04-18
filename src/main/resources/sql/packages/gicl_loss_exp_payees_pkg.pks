CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_PAYEES_PKG AS

    TYPE gicl_loss_exp_payees_type IS RECORD(
        claim_id            GICL_LOSS_EXP_PAYEES.claim_id%TYPE,     
        item_no             GICL_LOSS_EXP_PAYEES.item_no%TYPE,
        peril_cd            GICL_LOSS_EXP_PAYEES.peril_cd%TYPE,
        grouped_item_no     GICL_LOSS_EXP_PAYEES.grouped_item_no%TYPE,
        payee_type          GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
        payee_type_desc     VARCHAR2(30),
        payee_class_cd      GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
        class_desc          GIIS_PAYEE_CLASS.class_desc%TYPE,
        payee_cd            GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
        payee_last_name     VARCHAR2(600), --Lara 12/02/2013
        clm_clmnt_no        GICL_LOSS_EXP_PAYEES.clm_clmnt_no%TYPE,
        user_id             GICL_LOSS_EXP_PAYEES.user_id%TYPE,
        last_update         GICL_LOSS_EXP_PAYEES.last_update%TYPE,
        exist_clm_loss_exp  VARCHAR2(1)
    );

    TYPE gicl_loss_exp_payees_tab IS TABLE OF gicl_loss_exp_payees_type;

    FUNCTION get_gicl_loss_exp_payees(p_claim_id        GICL_LOSS_EXP_PAYEES.claim_id%TYPE,     
                                      p_item_no         GICL_LOSS_EXP_PAYEES.item_no%TYPE,
                                      p_peril_cd        GICL_LOSS_EXP_PAYEES.peril_cd%TYPE,
                                      p_grouped_item_no GICL_LOSS_EXP_PAYEES.grouped_item_no%TYPE,
                                      p_payee           VARCHAR2,
                                      p_payee_class     VARCHAR2,
                                      p_payee_type      VARCHAR2)
     RETURN gicl_loss_exp_payees_tab PIPELINED;
     
     PROCEDURE insert_loss_exp_payees
    (p_claim_id         IN  GICL_LOSS_EXP_PAYEES.claim_id%TYPE,
     p_item_no          IN  GICL_LOSS_EXP_PAYEES.item_no%TYPE,
     p_peril_cd         IN  GICL_LOSS_EXP_PAYEES.peril_cd%TYPE,  
     p_grouped_item_no  IN  GICL_LOSS_EXP_PAYEES.grouped_item_no%TYPE,
     p_payee_type       IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_class_cd   IN  GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
     p_payee_cd         IN  GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
     p_clm_clmnt_no     IN  GICL_LOSS_EXP_PAYEES.clm_clmnt_no%TYPE,
     p_user_id          IN  GICL_LOSS_EXP_PAYEES.user_id%TYPE );

END gicl_loss_exp_payees_pkg;
/


