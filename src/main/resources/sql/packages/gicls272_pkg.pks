CREATE OR REPLACE PACKAGE CPI.GICLS272_PKG
AS
    TYPE new_clm_list_per_bill_type IS RECORD (
        item_title          VARCHAR2(100),
        peril_name          VARCHAR2(100),
        le_stat_desc        VARCHAR2(100),
        paid_amt            NUMBER(16,2),
        net_amt             NUMBER(16,2),
        advise_amt          NUMBER(16,2),
        clm_stat_cd         VARCHAR2(5),
        assd_no             VARCHAR2(12),
        loss_date           DATE,
        clm_file_date       DATE,
        claim_no            VARCHAR2(100),
        policy_no           VARCHAR2(100),
        assd_name           VARCHAR2(500),
        clm_stat_desc       VARCHAR2(100)
    );
    
    TYPE new_clm_list_per_bill_tab IS TABLE OF new_clm_list_per_bill_type;
    
    TYPE clm_list_per_bill_type IS RECORD (
        doc_type            GICL_LOSS_EXP_BILL.doc_type%TYPE,
        rv_meaning          CG_REF_CODES.rv_meaning%TYPE,
        doc_number          GICL_LOSS_EXP_BILL.doc_number%TYPE,
        amount              GICL_LOSS_EXP_BILL.amount%TYPE,
        bill_date           GICL_LOSS_EXP_BILL.bill_date%TYPE,
        item_no             GICL_CLM_LOSS_EXP.item_no%TYPE,
        item_title          GICL_CLM_ITEM.item_title%TYPE,
        peril_cd            GICL_CLM_LOSS_EXP.peril_cd%TYPE,
        peril_name          GIIS_PERIL.peril_name%TYPE,
        le_stat_desc        GICL_LE_STAT.le_stat_desc%TYPE,
        paid_amt            GICL_CLM_LOSS_EXP.paid_amt%TYPE,
        net_amt             GICL_CLM_LOSS_EXP.net_amt%TYPE,
        advise_amt          GICL_CLM_LOSS_EXP.advise_amt%TYPE,
        claim_no            VARCHAR2(100),
        policy_no           VARCHAR2(100),
        clm_stat_desc       GIIS_CLM_STAT.clm_stat_desc%TYPE,
        assured_name        GICL_CLAIMS.assured_name%TYPE,
        loss_date           GICL_CLAIMS.loss_date%TYPE,
        clm_file_date       GICL_CLAIMS.clm_file_date%TYPE,
        payee_cd            GICL_LOSS_EXP_BILL.payee_cd%TYPE,
        payee_class_cd      GIIS_PAYEES.payee_class_cd%TYPE
    );
    
    TYPE clm_list_per_bill_tab IS TABLE OF clm_list_per_bill_type;
    
    TYPE bill_list_type IS RECORD(
        payee_no             GIIS_PAYEES.payee_no%TYPE,
        payee_last_name      GIIS_PAYEES.payee_last_name%TYPE,
        payee_first_name     GIIS_PAYEES.payee_first_name%TYPE,
        payee_middle_name    GIIS_PAYEES.payee_middle_name%TYPE,
        payee_class_cd       GIIS_PAYEES.payee_class_cd%TYPE,
        class_desc           GIIS_PAYEE_CLASS.class_desc%TYPE
    );
    
    TYPE bill_list_tab IS TABLE OF bill_list_type;
    
    TYPE payee_names_list_type IS RECORD (
        payee_no             GIIS_PAYEES.payee_no%TYPE,
        payee_name           GIIS_PAYEES.payee_last_name%TYPE
   );

   TYPE payee_names_list_tab IS TABLE OF payee_names_list_type;
    
    FUNCTION get_clm_list_per_bill(
        p_payee_no          GIIS_PAYEES.payee_no%TYPE,
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_user_id           GIIS_USERS.user_id%TYPE,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
    )
        RETURN clm_list_per_bill_tab PIPELINED;
        
    FUNCTION validate_payee(
        p_payee_no    VARCHAR2,
        p_payee_name  VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION validate_payee_class(
        p_payee_class_cd    VARCHAR2,
        p_payee_class       VARCHAR2      
    ) RETURN VARCHAR2;
    
    FUNCTION validate_doc_number(
        p_doc_number        VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION get_payee_names(
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_payee_cd          GICL_LOSS_EXP_BILL.payee_cd%TYPE,  
        p_payee_name        VARCHAR2     
    )
        RETURN payee_names_list_tab PIPELINED;
        
    TYPE payee_class_list_type IS RECORD (
        payee_class_cd             GIIS_PAYEE_CLASS.payee_class_cd%TYPE,
        payee_class_name           GIIS_PAYEE_CLASS.class_desc%TYPE
    );

    TYPE payee_class_list_tab IS TABLE OF payee_class_list_type;
    
    FUNCTION get_payee_class(
        p_payee_cd          GICL_LOSS_EXP_BILL.payee_cd%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_payee_class       GIIS_PAYEE_CLASS.class_desc%TYPE
    )
        RETURN payee_class_list_tab PIPELINED;
        
    TYPE doc_number_list_type IS RECORD (
        doc_number    GICL_LOSS_EXP_BILL.doc_number%TYPE,
        doc_type      GICL_LOSS_EXP_BILL.doc_type%TYPE,
        amount        GICL_LOSS_EXP_BILL.amount%TYPE,
        bill_date     GICL_LOSS_EXP_BILL.bill_date%TYPE,
        rv_meaning    CG_REF_CODES.rv_meaning%TYPE
    );

    TYPE doc_number_list_tab IS TABLE OF doc_number_list_type;
    
    FUNCTION get_doc_number(
        p_payee_cd          GICL_LOSS_EXP_BILL.payee_cd%TYPE,
        p_payee_class_cd    GIIS_PAYEES.payee_class_cd%TYPE,
        p_doc_type          GICL_LOSS_EXP_BILL.doc_type%TYPE,
        p_rv_meaning        CG_REF_CODES.rv_meaning%TYPE,
        p_doc_number        GICL_LOSS_EXP_BILL.doc_number%TYPE,
        p_amount            GICL_LOSS_EXP_BILL.amount%TYPE,
        p_bill_date         GICL_LOSS_EXP_BILL.bill_date%TYPE  
    )
        RETURN doc_number_list_tab PIPELINED;
        
    FUNCTION new_get_clm_list_per_bill(
        p_payee_no          VARCHAR2,
        p_payee_class_cd    VARCHAR2,
        p_doc_number        VARCHAR2,
        p_search_by         VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2
    )
        RETURN new_clm_list_per_bill_tab PIPELINED;

END;
/


