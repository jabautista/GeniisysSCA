CREATE OR REPLACE PACKAGE CPI.giacr117b_pkg
AS
   
   TYPE get_giacr117b_type IS RECORD (
        acct_gfun_fund_cd       GIAC_ACCTRANS.GFUN_FUND_CD%TYPE,
        acct_branch_name        VARCHAR2(200),
        gl_acct_number          VARCHAR2(200),
        gl_acct_name            giac_chart_of_accts.gl_acct_name%TYPE,
        debit_amt               GIAC_ACCT_ENTRIES.DEBIT_AMT%TYPE,
        credit_amt              GIAC_ACCT_ENTRIES.CREDIT_AMT%TYPE,
        balance_amt             GIAC_ACCT_ENTRIES.CREDIT_AMT%TYPE,
        company_name            VARCHAR2(500),
        company_address         VARCHAR(2000),
        company_tin       		  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
        gen_version				  giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
        header_date             VARCHAR(2000),
        print_details           VARCHAR2(1)
   );

   TYPE get_giacr117b_tab IS TABLE OF get_giacr117b_type;


    FUNCTION get_cash_rcpt_rgstr_smmry(
         p_date                 DATE,
         p_date2                DATE,
         p_tran_class           GIAC_ACCTRANS.TRAN_CLASS%TYPE,
         p_post_tran_toggle     GIAC_ACCTRANS.TRAN_CLASS%TYPE,
         p_branch               GIAC_ACCTRANS.GIBR_BRANCH_CD%TYPE,
         p_per_branch           VARCHAR2,
         p_user_id              GIAC_ACCTRANS.USER_ID%type      --added by shan 12.18.2013
         )
   
   RETURN get_giacr117b_tab PIPELINED;

END;
/


