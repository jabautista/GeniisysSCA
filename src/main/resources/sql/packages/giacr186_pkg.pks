CREATE OR REPLACE PACKAGE CPI.GIACR186_PKG AS

TYPE giacr186_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE,
    date_posted         DATE,
    branch_cd           GIAC_BRANCHES.BRANCH_CD%TYPE, --Dren 05.03.2016 SR-5355    
    branch_name         GIAC_BRANCHES.BRANCH_NAME%TYPE,
    bank_name           GIAC_BANKS.BANK_NAME%TYPE,
    dv_no               VARCHAR2(20),
    dv_prefix         giac_disb_vouchers.dv_pref%TYPE, --Dren 05.03.2016 SR-5355
    dv_no2            VARCHAR2 (10), --Dren 05.03.2016 SR-5355       
    dv_date             DATE,
    check_date          DATE,
    check_amount        GIAC_CHK_DISBURSEMENT.AMOUNT%TYPE,
    check_no            VARCHAR2(20),
    check_prefix      giac_chk_disbursement.check_pref_suf%TYPE, --Dren 05.03.2016 SR-5355
    check_no2         giac_chk_disbursement.check_no%TYPE, --Dren 05.03.2016 SR-5355     
    date_released       DATE,
    clearing_date       DATE,
    bank_acct_no        GIAC_BANK_ACCOUNTS.BANK_ACCT_NO%TYPE,
    payee               GIAC_CHK_DISBURSEMENT.PAYEE%TYPE,
    check_status        cg_ref_codes.rv_meaning%TYPE --SR19642 Lara 07092015
        
);

TYPE giacr186_tab IS TABLE OF giacr186_type;

FUNCTION populate_giacr186(
    p_bank_cd       VARCHAR2,
    p_cleared       VARCHAR2,
    p_bank_acct_cd  VARCHAR2,
    p_null          VARCHAR2,
    p_branch_cd     VARCHAR2,
    p_from_date     DATE,
    p_to_date       DATE,
    p_as_of_date    DATE,
    p_user_id       VARCHAR2
    
)
RETURN giacr186_tab PIPELINED;

 FUNCTION get_total_checks_per_bank_acct(
    p_bank_cd       VARCHAR2,
    p_cleared       VARCHAR2,
    p_bank_acct_cd  VARCHAR2,
    p_null          VARCHAR2,
    p_branch_cd     VARCHAR2,
    p_from_date     DATE,
    p_to_date       DATE,
    p_as_of_date    DATE,
    p_user_id       VARCHAR2
    
) RETURN NUMBER;   
END GIACR186_PKG;
/
