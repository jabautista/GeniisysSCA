CREATE OR REPLACE PACKAGE CPI.GICL_LOSS_EXP_BILL_PKG AS

    TYPE gicl_loss_exp_bill_type IS RECORD(
        claim_id            GICL_LOSS_EXP_BILL.claim_id%TYPE,  
        claim_loss_id       GICL_LOSS_EXP_BILL.claim_loss_id%TYPE,  
        payee_class_cd      GICL_LOSS_EXP_BILL.payee_class_cd%TYPE, 
        dsp_payee_class     GIIS_PAYEE_CLASS.class_desc%TYPE,
        payee_cd            GICL_LOSS_EXP_BILL.payee_cd%TYPE,
        dsp_payee           GIIS_PAYEES.payee_last_name%TYPE, 
        doc_type            GICL_LOSS_EXP_BILL.doc_type%TYPE,
        doc_type_desc       VARCHAR(10), 
        doc_number          GICL_LOSS_EXP_BILL.doc_number%TYPE,
        amount              GICL_LOSS_EXP_BILL.amount%TYPE,
        remarks             GICL_LOSS_EXP_BILL.remarks%TYPE, 
        user_id             GICL_LOSS_EXP_BILL.user_id%TYPE, 
        last_update         GICL_LOSS_EXP_BILL.last_update%TYPE, 
        bill_date           GICL_LOSS_EXP_BILL.bill_date%TYPE
    );

    TYPE gicl_loss_exp_bill_tab IS TABLE OF gicl_loss_exp_bill_type;

    FUNCTION get_gicl_loss_exp_bill_list(p_claim_id         IN  GICL_LOSS_EXP_BILL.claim_id%TYPE,
                                         p_claim_loss_id    IN  GICL_LOSS_EXP_BILL.claim_loss_id%TYPE)
    RETURN gicl_loss_exp_bill_tab PIPELINED;
    
    PROCEDURE set_gicl_loss_exp_bill
    (p_claim_id         IN   GICL_LOSS_EXP_BILL.claim_id%TYPE,
     p_claim_loss_id    IN   GICL_LOSS_EXP_BILL.claim_loss_id%TYPE,
     p_payee_class_cd   IN   GICL_LOSS_EXP_BILL.payee_class_cd%TYPE,
     p_payee_cd         IN   GICL_LOSS_EXP_BILL.payee_cd%TYPE,
     p_doc_type         IN   GICL_LOSS_EXP_BILL.doc_type%TYPE,
     p_doc_number       IN   GICL_LOSS_EXP_BILL.doc_number%TYPE,
     p_amount           IN   GICL_LOSS_EXP_BILL.amount%TYPE,
     p_remarks          IN   GICL_LOSS_EXP_BILL.remarks%TYPE,
     p_bill_date        IN   GICL_LOSS_EXP_BILL.bill_date%TYPE,
     p_user_id          IN   GICL_LOSS_EXP_BILL.user_id%TYPE);
    
    PROCEDURE delete_gicl_loss_exp_bill
    (p_claim_id         IN   GICL_LOSS_EXP_BILL.claim_id%TYPE,
     p_claim_loss_id    IN   GICL_LOSS_EXP_BILL.claim_loss_id%TYPE,
     p_payee_class_cd   IN   GICL_LOSS_EXP_BILL.payee_class_cd%TYPE,
     p_payee_cd         IN   GICL_LOSS_EXP_BILL.payee_cd%TYPE,
     p_doc_type         IN   GICL_LOSS_EXP_BILL.doc_type%TYPE,
     p_doc_number       IN   GICL_LOSS_EXP_BILL.doc_number%TYPE);

    PROCEDURE chk_gicl_loss_exp_bill
    (p_payee_class_cd   IN   GICL_LOSS_EXP_BILL.payee_class_cd%TYPE,
     p_payee_cd         IN   GICL_LOSS_EXP_BILL.payee_cd%TYPE,
     p_doc_type         IN   GICL_LOSS_EXP_BILL.doc_type%TYPE,
     p_doc_number       IN   GICL_LOSS_EXP_BILL.doc_number%TYPE,
     p_message          OUT  VARCHAR2,
     p_counter          OUT  INTEGER);

END GICL_LOSS_EXP_BILL_PKG;
/


