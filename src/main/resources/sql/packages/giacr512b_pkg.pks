CREATE OR REPLACE PACKAGE CPI.GIACR512B_PKG
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.03.2013
    **  Reference By : GIACR512B_PKG - LOSSES PAID
    */
    TYPE giacr512b_record_type IS RECORD(
        parent_intm_no      NUMBER(12),
        intm_no             NUMBER(12), 
        claim_no            VARCHAR2(300),
        policy_no           VARCHAR2(300),
        clm_file_date       DATE,        
        pol_eff_date        DATE,
        dsp_loss_date       DATE,
        assd_no             NUMBER(12), 
        loss_cat_cd         VARCHAR2(2),
        paid_amt            NUMBER(12,2),
        facul_shr           NUMBER,
        peril_cd            NUMBER(5),
        line_cd             VARCHAR2(2),
        check_no            VARCHAR2(300),
        check_date          VARCHAR2(300),
        company_name        giis_parameters.param_value_v%TYPE,
        company_add         giis_parameters.param_value_v%TYPE,
        intm_name           giis_intermediary.intm_name%TYPE := NULL,
        assd_name           giis_assured.assd_name%TYPE := NULL,
        nature_of_loss      giis_loss_ctgry.loss_cat_des%TYPE := NULL,
        peril_name          giis_peril.peril_name%TYPE := NULL,
        net_paid_amt        NUMBER(12,2),
        sub_parent_intm_no      NUMBER(12),
        sub_intm_no             NUMBER(12),
        sub_claim_no            VARCHAR2(300),
        sub_policy_no           VARCHAR2(300),
        sub_clm_file_date       DATE,        
        sub_pol_eff_date        DATE,
        sub_dsp_loss_date       DATE,
        sub_assd_no             NUMBER(12), 
        sub_loss_cat_cd         VARCHAR2(2),
        sub_paid_amt            NUMBER(12,2),
        sub_facul_shr           NUMBER,
        sub_peril_cd            NUMBER(5),
        sub_line_cd             VARCHAR2(2),
        sub_check_no            VARCHAR2(300),
        sub_check_date          VARCHAR2(300),
        sub_intm_name           giis_intermediary.intm_name%TYPE := NULL,
        sub_assd_name           giis_assured.assd_name%TYPE := NULL,
        sub_net_loss            giis_loss_ctgry.loss_cat_des%TYPE := NULL,
        sub_peril_name          giis_peril.peril_name%TYPE := NULL,
        sub_net_paid_amt        NUMBER(12),
        peril_intermediary_no         NUMBER(12),
        peril_line_cd                 VARCHAR2(2),
        peril_peril_cd                NUMBER(5),
        peril_paid_amt_sum            NUMBER(12,2),
        peril_facul_shr_sum           NUMBER,
        peril_peril_name              giis_peril.peril_name%TYPE := NULL
    );
    
    TYPE giacr512b_record_tab IS TABLE OF giacr512b_record_type;
    
    FUNCTION get_giacr512b_record(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2, 
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    
    RETURN giacr512b_record_tab PIPELINED;
    
    FUNCTION get_giacr512b_recordSUB(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    
    RETURN giacr512b_record_tab PIPELINED;
    
    FUNCTION get_giacr512b_recordperil(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    
    RETURN giacr512b_record_tab PIPELINED;
END;
/


