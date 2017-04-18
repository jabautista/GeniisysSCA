CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_PAYEE_GICLR259
    /*
    **  Created by        : Carlo Rubenecia
    **  Date Created      : 06.23.2016
    */
AS
    TYPE giclr259_type IS RECORD(
        payee_class            VARCHAR2 (100),
        payee_name             VARCHAR2 (600), 
        claim_number           VARCHAR (50),
        policy_number          VARCHAR (50),
        assured_name           gicl_claims.assured_name%TYPE,
        loss_date              VARCHAR2(50),
        item_title             VARCHAR2 (200),
        peril                  VARCHAR2 (200),
        advice_no              VARCHAR2(50),
        history_seq_no         VARCHAR2 (10),
        paid_amount            VARCHAR2(50),
        net_amount             VARCHAR2(50),
        advise_amount          VARCHAR2(50)
    );
    
    TYPE giclr259_tab IS TABLE OF giclr259_type;
    
    FUNCTION get_giclr259_details(
        p_payee_no             GIIS_PAYEES.payee_no%TYPE,
        p_payee_class_cd       GIIS_PAYEE_CLASS.payee_class_cd%TYPE,
        p_from_date            VARCHAR2,
        p_to_date              VARCHAR2,
        p_as_of_date           VARCHAR2,
        p_from_ldate           VARCHAR2,
        p_to_ldate             VARCHAR2,
        p_as_of_ldate          VARCHAR2,
        p_user_id              GIIS_USERS.user_id%TYPE
    ) RETURN giclr259_tab PIPELINED;
END CSV_CLM_PER_PAYEE_GICLR259;
/
