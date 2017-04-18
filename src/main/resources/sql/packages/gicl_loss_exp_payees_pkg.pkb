CREATE OR REPLACE PACKAGE BODY CPI.GICL_LOSS_EXP_PAYEES_PKG AS
    
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 01.13.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Gets the list of gicl_loss_exp_payees
   */ 
   FUNCTION get_gicl_loss_exp_payees(p_claim_id        GICL_LOSS_EXP_PAYEES.claim_id%TYPE,
                                     p_item_no         GICL_LOSS_EXP_PAYEES.item_no%TYPE,
                                     p_peril_cd        GICL_LOSS_EXP_PAYEES.peril_cd%TYPE,
                                     p_grouped_item_no GICL_LOSS_EXP_PAYEES.grouped_item_no%TYPE,
                                     p_payee           VARCHAR2,
                                     p_payee_class     VARCHAR2,
                                     p_payee_type      VARCHAR2)
    RETURN gicl_loss_exp_payees_tab PIPELINED AS

    v_payees   gicl_loss_exp_payees_type;

    BEGIN

       FOR i IN (SELECT a.claim_id,       a.item_no,     a.peril_cd,     a.grouped_item_no, a.payee_type,
                        DECODE(a.payee_type, 'L', 'Loss', 'E', 'Expense') payee_type_desc,
                        a.payee_class_cd, b.class_desc, a.payee_cd,     c.payee_last_name,
                        a.clm_clmnt_no,   a.user_id,     a.last_update, 
                        c.payee_first_name, c.payee_middle_name, b.payee_class_tag --lara 12/02/2013
                 FROM GICL_LOSS_EXP_PAYEES a,
                      GIIS_PAYEE_CLASS b,
                      GIIS_PAYEES c
                 WHERE a.payee_class_cd = b.payee_class_cd
                   AND b.payee_class_cd = c.payee_class_cd
                   AND c.payee_no = a.payee_cd
                   AND a.claim_id = p_claim_id
                   AND a.item_no = p_item_no
                   AND a.peril_cd = p_peril_cd
                   AND a.grouped_item_no = p_grouped_item_no
                   AND UPPER (NVL(c.payee_last_name,'*')) LIKE UPPER (NVL (p_payee, NVL(c.payee_last_name,'*')))
                   AND UPPER (b.class_desc) LIKE UPPER (NVL (p_payee_class, b.class_desc))
                   AND UPPER (DECODE(a.payee_type, 'L', 'Loss', 'E', 'Expense')) LIKE UPPER (NVL (p_payee_type, DECODE(a.payee_type, 'L', 'Loss', 'E', 'Expense')))
                 ORDER BY a.payee_type DESC,
                          a.payee_class_cd ASC,
                          a.payee_cd ASC)

       LOOP
           v_payees.claim_id        := i.claim_id;
           v_payees.item_no         := i.item_no;
           v_payees.peril_cd        := i.peril_cd;
           v_payees.grouped_item_no := i.grouped_item_no;
           v_payees.payee_type      := i.payee_type;
           v_payees.payee_type_desc := i.payee_type_desc;
           v_payees.payee_class_cd := i.payee_class_cd;
           v_payees.class_desc      := i.class_desc;
           v_payees.payee_cd        := i.payee_cd;
           v_payees.payee_last_name := i.payee_last_name;
           v_payees.clm_clmnt_no    := i.clm_clmnt_no;
           v_payees.user_id         := i.user_id;
           v_payees.last_update     := i.last_update;
           v_payees.exist_clm_loss_exp := GICL_CLM_LOSS_EXP_PKG.check_exist_clm_loss_exp(i.claim_id, i.item_no,        i.peril_cd,   i.grouped_item_no,
                                                                                         i.payee_type,i.payee_class_cd, i.payee_cd);
            --Added by Lara 12/02/2013
            if i.payee_class_tag = 'M' then
                if i.payee_first_name is null or i.payee_first_name = '' then
                    v_payees.payee_last_name := i.payee_last_name;
                else
                    v_payees.payee_last_name := i.payee_last_name || ', ' || i.payee_first_name || ' ' || i.payee_middle_name;
                end if;
            else
                v_payees.payee_last_name := i.payee_last_name;
            end if;

           PIPE ROW(v_payees);
       END LOOP;

    END get_gicl_loss_exp_payees;
     
   /*
   **  Created by    : Veronica V. Raymundo
   **  Date Created  : 02.07.2012
   **  Reference By  : GICLS030 - Loss/Recovery History
   **  Description   : Insert gicl_loss_exp_payees record
   */ 
   
    PROCEDURE insert_loss_exp_payees
        (p_claim_id         IN  GICL_LOSS_EXP_PAYEES.claim_id%TYPE,
         p_item_no          IN  GICL_LOSS_EXP_PAYEES.item_no%TYPE,
         p_peril_cd         IN  GICL_LOSS_EXP_PAYEES.peril_cd%TYPE,  
         p_grouped_item_no  IN  GICL_LOSS_EXP_PAYEES.grouped_item_no%TYPE,
         p_payee_type       IN  GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
         p_payee_class_cd   IN  GICL_LOSS_EXP_PAYEES.payee_class_cd%TYPE,
         p_payee_cd         IN  GICL_LOSS_EXP_PAYEES.payee_cd%TYPE,
         p_clm_clmnt_no     IN  GICL_LOSS_EXP_PAYEES.clm_clmnt_no%TYPE,
         p_user_id          IN  GICL_LOSS_EXP_PAYEES.user_id%TYPE ) AS
     
    BEGIN
        
        --INSERT INTO GICL_LOSS_EXP_PAYEES --replaced by robert SR 5027 11.10.15
		MERGE INTO GICL_LOSS_EXP_PAYEES
         USING DUAL
         ON (claim_id = p_claim_id AND
             payee_type = p_payee_type AND
             payee_class_cd = p_payee_class_cd AND
             payee_cd = p_payee_cd AND
             item_no = p_item_no AND
             peril_cd = p_peril_cd)
        WHEN NOT MATCHED THEN
        INSERT
		-- end robert SR 5027 11.10.15
            (claim_id,   item_no,        peril_cd,   grouped_item_no,
             payee_type, payee_class_cd, payee_cd,   clm_clmnt_no,
             user_id,    last_update)
        VALUES
            (p_claim_id,   p_item_no,        p_peril_cd,   p_grouped_item_no,
             p_payee_type, p_payee_class_cd, p_payee_cd,   p_clm_clmnt_no,
             p_user_id,    SYSDATE);
             
    END insert_loss_exp_payees;


END gicl_loss_exp_payees_pkg;
/


