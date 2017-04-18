CREATE OR REPLACE PACKAGE CPI.GICLR268_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.05.2013
    **  Reference By      : GICLR268 - CLAIM LISTING PER PLATE NO.
    */
AS
	TYPE giclr268_type IS RECORD(
        plate_no            gicl_claims.plate_no%TYPE,
        claim_id            gicl_motor_car_dtl.claim_id%TYPE,
        item_no             gicl_motor_car_dtl.item_no%TYPE,
        claim_no            VARCHAR2(50),
        policy_no           VARCHAR2(50),
        assd_name           giis_assured.assd_name%TYPE,
        item                VARCHAR(100),
        loss_reserve        gicl_clm_reserve.loss_reserve%TYPE,
        sum_loss_reserve    gicl_clm_reserve.loss_reserve%TYPE,
        losses_paid         gicl_clm_reserve.losses_paid%TYPE,
        sum_losses_paid     gicl_clm_reserve.losses_paid%TYPE,
        expense_reserve     gicl_clm_reserve.expense_reserve%TYPE,
        sum_expense_reserve gicl_clm_reserve.expense_reserve%TYPE,
        expenses_paid       gicl_clm_reserve.expenses_paid%TYPE,
        sum_expenses_paid   gicl_clm_reserve.expenses_paid%TYPE,
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        date_type           VARCHAR(150)
	);
	
	TYPE giclr268_tab IS TABLE OF giclr268_type;
    
    FUNCTION get_giclr268_details(
        p_plate_no          gicl_claims.plate_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_user_id           VARCHAR2 --Pol Cruz 5.31.2013 (changed check_user_per_line to check_user_per_line2)
    ) RETURN giclr268_tab PIPELINED;
END GICLR268_PKG;
/


