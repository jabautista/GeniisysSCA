CREATE OR REPLACE PACKAGE CPI.GICLR271_PKG 
AS
     TYPE claims_per_user_type IS RECORD(
        in_hou_adj          gicl_claims.in_hou_adj%TYPE,
        policy_no           VARCHAR2 (100),
        assured_name        gicl_claims.assured_name%TYPE,
        claim_no            VARCHAR2 (100),
        dsp_loss_date       VARCHAR2 (50),
        clm_file_date       VARCHAR2 (50),
        entry_date          VARCHAR2 (50),
        clm_stat_desc       giis_clm_stat.clm_stat_desc%TYPE,
        loss_dtls           gicl_claims.loss_dtls%TYPE,
        loss_res_amt        gicl_claims.loss_res_amt%TYPE,
        loss_pd_amt         gicl_claims.loss_pd_amt%TYPE,
        exp_res_amt         gicl_claims.exp_res_amt%TYPE,
        exp_pd_amt          gicl_claims.exp_pd_amt%TYPE,
        cf_company          VARCHAR2 (200),
        cf_address          VARCHAR2 (200),
        date_type           VARCHAR2 (250)
    );
    
    TYPE claims_per_user_tab IS TABLE OF claims_per_user_type;
    
    FUNCTION get_claims_per_user(
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
    
END GICLR271_PKG;
/


