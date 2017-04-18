CREATE OR REPLACE PACKAGE CPI.GICL_RECOVERY_ACCT_PKG
AS

    TYPE gicl_recovery_acct_type IS RECORD (
        recovery_acct_id        GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        iss_cd                  GICL_RECOVERY_ACCT.iss_cd%TYPE,
        rec_acct_year           GICL_RECOVERY_ACCT.rec_acct_year%TYPE,
        rec_acct_seq_no         GICL_RECOVERY_ACCT.rec_acct_seq_no%TYPE,
        recovery_amt            GICL_RECOVERY_ACCT.recovery_amt%TYPE,
        recovery_acct_flag      GICL_RECOVERY_ACCT.recovery_acct_flag%TYPE,
        acct_tran_id            GICL_RECOVERY_ACCT.acct_tran_id%TYPE,
        tran_date               GICL_RECOVERY_ACCT.tran_date%TYPE,
        dsp_tran_flag           GIAC_ACCTRANS.tran_flag%TYPE,
        dsp_recovery_acct_no    VARCHAR2(50),
		acct_exists             VARCHAR2(2),
        nbt_claim_id            GICL_CLAIMS.claim_id%TYPE
    );
    
    TYPE gicl_recovery_acct_tab IS TABLE OF gicl_recovery_acct_type;

    FUNCTION get_gicl_recovery_acct_list (
        p_claim_id             GICL_CLAIMS.claim_id%TYPE,
        p_user_id              GIIS_USERS.user_id%TYPE,
        p_module_id            VARCHAR2,
        p_recovery_acct_id     GICL_RECOVERY_ACCT.recovery_acct_id%TYPE
    ) RETURN gicl_recovery_acct_tab PIPELINED;
    
    PROCEDURE generate_recovery_acct_info (
        p_iss_cd            IN     GICL_RECOVERY_ACCT.iss_cd%TYPE,
        p_recovery_acct_id  OUT    GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        p_rec_acct_year     OUT    GICL_RECOVERY_ACCT.rec_acct_year%TYPE,
        p_rec_acct_seq_no   OUT    GICL_RECOVERY_ACCT.rec_acct_seq_no%TYPE
    );
    
    PROCEDURE set_generated_rec_acct (
        p_recovery_acct_id        GICL_RECOVERY_ACCT.recovery_acct_id%TYPE,
        p_iss_cd                  GICL_RECOVERY_ACCT.iss_cd%TYPE,
        p_rec_acct_year           GICL_RECOVERY_ACCT.rec_acct_year%TYPE,
        p_rec_acct_seq_no         GICL_RECOVERY_ACCT.rec_acct_seq_no%TYPE,
        p_recovery_amt            GICL_RECOVERY_ACCT.recovery_amt%TYPE,
        p_recovery_acct_flag      GICL_RECOVERY_ACCT.recovery_acct_flag%TYPE,
        p_acct_tran_id            GICL_RECOVERY_ACCT.acct_tran_id%TYPE,
        p_tran_date               GICL_RECOVERY_ACCT.tran_date%TYPE,
        p_user_id                 GICL_RECOVERY_ACCT.user_id%TYPE
    );
    
END GICL_RECOVERY_ACCT_PKG;
/


