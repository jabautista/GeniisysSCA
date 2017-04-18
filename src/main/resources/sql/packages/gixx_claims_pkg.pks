CREATE OR REPLACE PACKAGE CPI.gixx_claims_pkg AS

    -- added by Kris 03.04.2013 for GIPIS101
    TYPE gixx_claims_type IS RECORD (
        extract_id          gixx_claims.extract_id%TYPE,
        claim_id            gixx_claims.claim_id%TYPE,
        line_cd             gixx_claims.line_cd%TYPE,
        subline_cd          gixx_claims.subline_cd%TYPE,
        clm_yy              gixx_claims.clm_yy%TYPE,
        clm_seq_no          gixx_claims.clm_seq_no%TYPE,
        iss_cd              gixx_claims.iss_cd%TYPE,
        clm_setl_date       gixx_claims.clm_setl_date%TYPE,
        clm_file_date       gixx_claims.clm_file_date%TYPE,
        loss_date           gixx_claims.loss_date%TYPE,
        loss_res_amt        gixx_claims.loss_res_amt%TYPE,
        exp_res_amt         gixx_claims.exp_res_amt%TYPE,
        loss_pd_amt         gixx_claims.loss_pd_amt%TYPE,
        exp_pd_amt          gixx_claims.exp_pd_amt%TYPE,
        
        claim_no            VARCHAR2(1000),
        claim_amt           NUMBER(20,2),
        paid_amt            NUMBER(20,2)
    );
    
    TYPE gixx_claims_tab IS TABLE OF gixx_claims_type;
    
    FUNCTION get_gixx_claims (
        p_extract_id    gixx_claims.extract_id %TYPE
    ) RETURN gixx_claims_tab PIPELINED;
    -- end 03.04.2013 for GIPIS101
    
END gixx_claims_pkg;
/


