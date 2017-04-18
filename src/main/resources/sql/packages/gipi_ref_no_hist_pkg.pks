CREATE OR REPLACE PACKAGE CPI.gipi_ref_no_hist_pkg
AS
    TYPE bank_ref_no_type IS RECORD(
        acct_iss_cd         VARCHAR2(32000),
        branch_cd           VARCHAR2(32000),
        ref_no              VARCHAR2(32000),
        mod_no              VARCHAR2(32000),
        bank_ref_no         VARCHAR2(32000)
        );
     
    TYPE bank_ref_no_tab IS TABLE OF bank_ref_no_type;  
    
    TYPE ref_no_hist_type IS RECORD(
        acct_iss_cd         VARCHAR2(2),
        branch_cd           VARCHAR2(4),
        ref_no              VARCHAR2(7),
        mod_no              VARCHAR2(2),
        user_id             GIPI_REF_NO_HIST.user_id%TYPE,
        last_update         VARCHAR2(20),
        remarks             GIPI_REF_NO_HIST.remarks%TYPE,
        bank_ref_no         GIPI_REF_NO_HIST.bank_ref_no%TYPE
    );
    TYPE ref_no_hist_tab IS TABLE OF ref_no_hist_type;

    FUNCTION get_bank_ref_no_list(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_keyword       VARCHAr2)
    RETURN bank_ref_no_tab PIPELINED;
    
    FUNCTION get_bank_ref_no_list_for_pack(
        p_acct_iss_cd   VARCHAR2,
        p_branch_cd     VARCHAR2,
        p_keyword       VARCHAR2)
    RETURN bank_ref_no_tab PIPELINED;
    
    FUNCTION get_ref_no_hist_list_by_user(
        p_user_id       GIPI_REF_NO_HIST.user_id%TYPE,
        p_acct_iss_cd   GIPI_REF_NO_HIST.acct_iss_cd%TYPE,
        p_branch_cd     GIPI_REF_NO_HIST.branch_cd%TYPE,
        p_ref_no        GIPI_REF_NO_HIST.ref_no%TYPE,
        p_mod_no        GIPI_REF_NO_HIST.mod_no%TYPE,
        p_remarks       GIPI_REF_NO_HIST.remarks%TYPE,
        p_last_update   VARCHAR2
    )
      RETURN ref_no_hist_tab PIPELINED;
      
    FUNCTION get_mod_no(
        p_acct_iss_cd   GIPI_REF_NO_HIST.acct_iss_cd%TYPE,
        p_branch_cd     GIPI_REF_NO_HIST.branch_cd%TYPE,
        p_ref_no        GIPI_REF_NO_HIST.ref_no%TYPE
    )
      RETURN NUMBER;
      
    FUNCTION get_unused_ref_no(
        p_user_id       GIPI_REF_NO_HIST.user_id%TYPE,
        p_range         NUMBER,
        p_exact_date    VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    )
      RETURN ref_no_hist_tab PIPELINED;
    
END;
/


