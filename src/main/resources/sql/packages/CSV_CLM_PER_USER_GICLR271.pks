CREATE OR REPLACE PACKAGE CPI.CSV_CLM_PER_USER_GICLR271
AS
     TYPE claims_per_user_type IS RECORD(
        claim_processor         gicl_claims.user_id%TYPE,
        policy_number           VARCHAR2 (100),
        assured_name            gicl_claims.assured_name%TYPE,
        claim_number            VARCHAR2 (100),
        loss_date               VARCHAR2 (50),
        file_date               VARCHAR2 (50),
        entry_date              VARCHAR2 (50),
        claim_status      giis_clm_stat.clm_stat_desc%TYPE,
        loss_details            gicl_claims.loss_dtls%TYPE,
        loss_reserve            gicl_claims.loss_res_amt%TYPE,
        losses_paid             gicl_claims.loss_pd_amt%TYPE,
        expense_reserve         gicl_claims.exp_res_amt%TYPE,
        expenses_paid           gicl_claims.exp_pd_amt%TYPE
    );
    
    TYPE claims_per_user_tab IS TABLE OF claims_per_user_type;
    
    FUNCTION csv_giclr271(
        p_in_hou_adj        gicl_claims.in_hou_adj%TYPE,
        p_as_of_date        DATE,
        p_as_of_ldate       DATE,   
        p_from_date         DATE,
        p_from_ldate        DATE,
        p_to_date           DATE,
        p_to_ldate          DATE,
        p_as_of_edate       DATE,
        p_from_edate        DATE,
        p_to_edate          DATE,
        p_user_id           VARCHAR2
   )
    RETURN claims_per_user_tab PIPELINED;
    
END CSV_CLM_PER_USER_GICLR271;
/
