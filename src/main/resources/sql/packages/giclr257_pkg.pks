CREATE OR REPLACE PACKAGE CPI.GICLR257_PKG
    /*
    **  Created by        : bonok
    **  Date Created      : 03.07.2013
    **  Reference By      : GICLR257 - Claim Listing Per Adjuster
    */
AS
    TYPE giclr257_type IS RECORD(
        payee_name          VARCHAR2(600),
        claim_no            VARCHAR2(50),
        policy_no           VARCHAR2(50),
        assured_name        gicl_claims.assured_name%TYPE,
        loss_date           gicl_claims.loss_date%TYPE,
        clm_file_date       gicl_claims.clm_file_date%TYPE,
        clm_stat_desc       giis_clm_stat.clm_stat_desc%TYPE,
        private_adjuster    giis_adjuster.payee_name%TYPE,
        assign_date         gicl_clm_adjuster.assign_date%TYPE,
        complt_date         gicl_clm_adjuster.complt_date%TYPE,
        cancel_date         gicl_clm_adj_hist.cancel_date%TYPE,
        no_of_days          NUMBER(4),
        paid_amt            gicl_clm_loss_exp.paid_amt%TYPE,
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        date_type           VARCHAR(150)
    );
    
    TYPE giclr257_tab IS TABLE OF giclr257_type;
    
    FUNCTION get_giclr257_details(
        p_payee_no          giis_payees.payee_no%TYPE,
        p_from_date         VARCHAR2,
        p_to_date           VARCHAR2,
        p_as_of_date        VARCHAR2,
        p_from_ldate        VARCHAR2,
        p_to_ldate          VARCHAR2,
        p_as_of_ldate       VARCHAR2,
        p_from_adate        VARCHAR2,
        p_to_adate          VARCHAR2,
        p_as_of_adate       VARCHAR2,
        p_stat              VARCHAR2,
        p_user_id           VARCHAR2
    ) RETURN giclr257_tab PIPELINED;
END GICLR257_PKG;
/


