CREATE OR REPLACE PACKAGE CPI.GIACR512A_PKG
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.02.2013
    **  Reference By : GIACR512A_PKG - OUTSTANDING LOSS
    */
    TYPE giacr512A_record_type IS RECORD(
        parent_intm_no      NUMBER(12),
        intm_no             NUMBER(12),
        claim_no            VARCHAR2(300),
        policy_no           VARCHAR2(300),
        clm_file_date       DATE,        
        pol_eff_date        DATE,
        dsp_loss_date       DATE,
        assd_no             NUMBER(12),
        loss_cat_cd         VARCHAR2(2),
        peril_name          VARCHAR2(20),
        os_amt              NUMBER,
        facul_shr           NUMBER,
        peril_cd            NUMBER(5),
        line_cd             VARCHAR2(2),
        intm_name           VARCHAR2(300),
        company_name        VARCHAR2(300),
        company_add         VARCHAR2(300),
        assd_name           VARCHAR2(500),
        nature_of_loss      VARCHAR2(300),
        peril_name_main     VARCHAR2(300),
        net_loss            NUMBER(12,2),
        pb_parent_intm_no   NUMBER(12),
        pb_peril_name       VARCHAR2(20),
        pb_peril_cd         NUMBER(12),
        pb_os_amt           NUMBER,
        pb_facul_shr        NUMBER,
        parent_intm         giis_intermediary.intm_name%TYPE,
        sub_parent_intm_no      NUMBER(12),
        sub_intm_no             NUMBER(12),
        sub_claim_no            VARCHAR2(300),
        sub_policy_no           VARCHAR2(300),
        sub_clm_file_date       DATE,       
        sub_pol_eff_date        DATE,
        sub_dsp_loss_date       DATE,
        sub_assd_no             NUMBER(12), 
        sub_loss_cat_cd         VARCHAR2(2),
        sub_peril_name          VARCHAR2(20),
        sub_os_amt              NUMBER,
        sub_facul_shr           NUMBER,
        sub_peril_cd            NUMBER(5),
        sub_line_cd             VARCHAR2(2),
        sub_intm_name           giis_intermediary.intm_name%TYPE,
        sub_assd_name           giis_assured.assd_name%TYPE,
        sub_nature_of_loss      giis_loss_ctgry.loss_cat_des%TYPE,
        sub_peril_name_main     giis_peril.peril_name%TYPE,
        sub_net_loss            NUMBER(12)
        );
    TYPE giacr512A_record_tab IS TABLE OF giacr512A_record_type;
    
    FUNCTION get_giacr512A_record(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512A_record_tab PIPELINED;
    
    FUNCTION giacr512A_perilbreakdown(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512A_record_tab PIPELINED;
    FUNCTION giacr512A_subagent(
    P_BRANCH_CD     VARCHAR2,
    P_TRAN_YEAR     VARCHAR2,
    P_INTM_NO       NUMBER,
    P_USER_ID       giis_users.user_id%TYPE
    )
    RETURN giacr512A_record_tab PIPELINED;    
END;
/


