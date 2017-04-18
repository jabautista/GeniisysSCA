CREATE OR REPLACE PACKAGE CSV_CLM_PER_PLATENO_GICLR268
AS
    /*
    **  Created by        : carlo
    **  Date Created      : 03.31.2016 SR5406
    */
    TYPE giclr268_type IS RECORD(
        plate_no            gicl_claims.plate_no%TYPE,
        claim_number        VARCHAR2(50),
        policy_number       VARCHAR2(50),
        assured_name        giis_assured.assd_name%TYPE,
        item                VARCHAR(100),
        loss_reserve        VARCHAR2(50),
        losses_paid         VARCHAR2(50),
        expense_reserve     VARCHAR2(50),
        expenses_paid       VARCHAR2(50)
    );
    
    TYPE giclr268_tab IS TABLE OF giclr268_type;
    
    FUNCTION csv_giclr268(
        p_plate_no          gicl_claims.plate_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_user_id           VARCHAR2 
    ) RETURN giclr268_tab PIPELINED;
END CSV_CLM_PER_PLATENO_GICLR268;
/
