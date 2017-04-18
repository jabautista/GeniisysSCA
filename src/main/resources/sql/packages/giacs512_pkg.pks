CREATE OR REPLACE PACKAGE CPI.GIACS512_PKG
AS
     
    FUNCTION get_last_cutoff_date(
        p_extract_year      VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION validate_before_extract(
        p_extract_year      giac_cpc_dtl.tran_year%TYPE,
        p_intm_no           giis_intermediary.intm_no%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_type              VARCHAR2
    ) RETURN VARCHAR2;
    
    FUNCTION validate_before_print(
        p_extract_year      giac_cpc_dtl.tran_year%TYPE,
        p_user_id           giis_users.user_id%TYPE,
        p_type              VARCHAR2
    ) RETURN VARCHAR2;
    
    PROCEDURE CPC_EXTRACT_PREM_COMM(
        p_extract_year      IN  NUMBER,
		p_intm_no           IN  giis_intermediary.intm_no%TYPE,
		p_cut_off_date      IN  VARCHAR2,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_rec_count         OUT NUMBER
    );
    
    PROCEDURE CPC_EXTRACT_OS_DTL (
        p_extract_year      IN  NUMBER,
		p_intm_no           IN  giis_intermediary.intm_no%TYPE,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_rec_count         OUT NUMBER
    );
    
    PROCEDURE CPC_EXTRACT_LOSS_PAID (
        p_extract_year      IN  NUMBER,
		p_intm_no           IN  giis_intermediary.intm_no%type,
        p_user_id           IN  giis_users.user_id%TYPE,
        p_rec_count         OUT NUMBER
    );
    
END GIACS512_PKG;
/


