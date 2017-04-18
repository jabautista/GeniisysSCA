CREATE OR REPLACE PACKAGE CPI.GIACR500B_PKG AS

TYPE GIACR500B_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE,
    gl_acct_name        giac_chart_of_accts.GL_ACCT_NAME%TYPE,
    gl_acct_id          giac_trial_balance_summary.GL_ACCT_ID%TYPE,
    gl_no               VARCHAR2(50),
    debit               giac_trial_balance_summary.DEBIT%TYPE,
    credit              giac_trial_balance_summary.CREDIT%TYPE,     
    as_of_date          VARCHAR2(50)
);

TYPE GIACR500B_tab IS TABLE OF GIACR500B_type;
FUNCTION populate_GIACR500B(
    p_month       NUMBER,
    p_year        NUMBER,
    p_user_id     VARCHAR2
    )
RETURN GIACR500B_tab PIPELINED;


END GIACR500B_PKG;
/


