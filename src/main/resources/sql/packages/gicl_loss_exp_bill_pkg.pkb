CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_BILL_PKG AS

    /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 03.21.2012
   **  Reference By  : GICLS030 - Loss/Expense History
   **  Description   : Gets the list of records from GICL_LOSS_EXP_BILL
   **                  table with the given parameters.
   */ 

    FUNCTION get_gicl_loss_exp_bill_list(p_claim_id         IN  GICL_LOSS_EXP_BILL.claim_id%TYPE,
                                         p_claim_loss_id    IN  GICL_LOSS_EXP_BILL.claim_loss_id%TYPE)
    RETURN gicl_loss_exp_bill_tab PIPELINED AS
    
    loss_exp_bill       gicl_loss_exp_bill_type;
    
    BEGIN
        FOR i IN (SELECT claim_id,     claim_loss_id,   payee_class_cd,  payee_cd,        
                         doc_type,     DECODE(doc_type, 1, 'Invoice', 2, 'Bill') doc_type_desc,                 
                         doc_number,   amount,          remarks,         user_id,     
                         last_update,  bill_date
                         FROM GICL_LOSS_EXP_BILL
                   WHERE claim_id = p_claim_id 
                     AND claim_loss_id = p_claim_loss_id)
        LOOP
            loss_exp_bill.claim_id            := i.claim_id; 
            loss_exp_bill.claim_loss_id       := i.claim_loss_id;  
            loss_exp_bill.payee_class_cd      := i.payee_class_cd; 
            loss_exp_bill.payee_cd            := i.payee_cd;
            loss_exp_bill.doc_type            := i.doc_type;
            loss_exp_bill.doc_type_desc       := i.doc_type_desc; 
            loss_exp_bill.doc_number          := i.doc_number;
            loss_exp_bill.amount              := i.amount;
            loss_exp_bill.remarks             := i.remarks; 
            loss_exp_bill.user_id             := i.user_id; 
            loss_exp_bill.last_update         := i.last_update; 
            loss_exp_bill.bill_date           := i.bill_date;
            
            BEGIN
              SELECT a.class_desc, 
                     b.payee_last_name 
                INTO loss_exp_bill.dsp_payee_class, loss_exp_bill.dsp_payee
                FROM GIIS_PAYEE_CLASS a, GIIS_PAYEES b
               WHERE a.payee_class_cd = b.payee_class_cd 
                 AND a.payee_class_cd = i.payee_class_cd
                 AND b.payee_no = i.payee_cd;
                
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                loss_exp_bill.dsp_payee_class  := NULL;
                loss_exp_bill.dsp_payee        := NULL;
            END;
            
            PIPE ROW(loss_exp_bill);  
            
        END LOOP;             
                     
    END get_gicl_loss_exp_bill_list;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Inserts or updates record on GICL_LOSS_EXP_BILL table
    */ 

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
     p_user_id          IN   GICL_LOSS_EXP_BILL.user_id%TYPE ) AS
     
    BEGIN
        MERGE INTO GICL_LOSS_EXP_BILL
        USING dual ON (claim_id = p_claim_id
                   AND claim_loss_id = p_claim_loss_id
                   AND payee_class_cd = p_payee_class_cd
                   AND payee_cd = p_payee_cd
                   AND doc_type = p_doc_type
                   AND doc_number = p_doc_number)
                   
        WHEN NOT MATCHED THEN
              INSERT
               (claim_id, claim_loss_id, payee_class_cd, payee_cd, doc_type, doc_number,
                amount,   remarks,       bill_date,      user_id,  last_update)
              VALUES
               (p_claim_id, p_claim_loss_id, p_payee_class_cd, p_payee_cd, p_doc_type, p_doc_number,
                p_amount,   p_remarks,       p_bill_date,      p_user_id,  SYSDATE)
        
        WHEN MATCHED THEN
              UPDATE SET 
                  amount    = p_amount,
                  remarks   = p_remarks,
                  bill_date = p_bill_date,
                  user_id   = p_user_id,
                  last_update = SYSDATE;
          
    END set_gicl_loss_exp_bill;
    
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 03.22.2012
    **  Reference By  : GICLS030 - Loss/Expense History
    **  Description   : Deletes record from GICL_LOSS_EXP_BILL table
    */

    PROCEDURE delete_gicl_loss_exp_bill
    (p_claim_id         IN   GICL_LOSS_EXP_BILL.claim_id%TYPE,
     p_claim_loss_id    IN   GICL_LOSS_EXP_BILL.claim_loss_id%TYPE,
     p_payee_class_cd   IN   GICL_LOSS_EXP_BILL.payee_class_cd%TYPE,
     p_payee_cd         IN   GICL_LOSS_EXP_BILL.payee_cd%TYPE,
     p_doc_type         IN   GICL_LOSS_EXP_BILL.doc_type%TYPE,
     p_doc_number       IN   GICL_LOSS_EXP_BILL.doc_number%TYPE) AS
     
    BEGIN
        
        DELETE FROM GICL_LOSS_EXP_BILL
              WHERE claim_id = p_claim_id
                AND claim_loss_id = p_claim_loss_id
                AND payee_class_cd = p_payee_class_cd
                AND payee_cd = p_payee_cd
                AND doc_type = p_doc_type
                AND doc_number = p_doc_number;
                
    END delete_gicl_loss_exp_bill;
    
    /*
    **  Created by      : Jerome Bautista
    **  Date Created    : 05.28.2015
    **  Reference       : GICLS030 - Loss/Expense History
    **  Description     : Checks if a bill no is currently in use by other claims
    */
   PROCEDURE chk_gicl_loss_exp_bill
    (p_payee_class_cd   IN   GICL_LOSS_EXP_BILL.payee_class_cd%TYPE,
     p_payee_cd         IN   GICL_LOSS_EXP_BILL.payee_cd%TYPE,
     p_doc_type         IN   GICL_LOSS_EXP_BILL.doc_type%TYPE,
     p_doc_number       IN   GICL_LOSS_EXP_BILL.doc_number%TYPE,
     p_message          OUT  VARCHAR2,
     p_counter          OUT  INTEGER
     ) 
     AS
        v_counter  INTEGER := 0;
     BEGIN
          FOR a IN (SELECT claim_id 
                       FROM   gicl_loss_exp_bill
                       WHERE  payee_class_cd = p_payee_class_cd
                       AND    payee_cd = p_payee_cd
                       AND    doc_type = p_doc_type
                       AND    doc_number = p_doc_number)
          LOOP
               p_message := get_claim_number(a.claim_id) ||','|| p_message;
               v_counter := v_counter + 1;
               p_counter := v_counter;
          END LOOP;             
     END chk_gicl_loss_exp_bill;    
END GICL_LOSS_EXP_BILL_PKG;
/


