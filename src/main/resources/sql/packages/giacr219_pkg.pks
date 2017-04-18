CREATE OR REPLACE PACKAGE CPI.GIACR219_pkg
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.025.2013
    **  Reference By : GIACR219_PKG - PRODUCTION REGISTER PER INTERMEDIARY (SUMMARY)
    */
    TYPE giacr219_type IS RECORD (
    C_IN_TYPE VARCHAR2(100),
    C_ISS_NAME VARCHAR2(20),
    C_INTM_NAME VARCHAR2(240),
    INTERMEDIARY_TYPE VARCHAR2(2),
    C_LINE VARCHAR2(20),
    C_SUBLINE VARCHAR2(300),
    assured_name VARCHAR2(500),
    c_date  DATE,
    c_sdate DATE,
    c_comm NUMBER(12,2),
    endt_seq_no NUMBER(6),
    line_cd VARCHAR2(2),
    subline_cd VARCHAR2(7),
    C_ISS_CD VARCHAR2(2),
    issue_yy NUMBER(2),
    pol_seq_no NUMBER(7),
    renew_no NUMBER(2),
    endt_iss_cd  VARCHAR2(2),
    endt_yy NUMBER(2),
    C_TOTAL_INS NUMBER(16,2),
    C_PREM NUMBER(16,2),
    C_TAX NUMBER(16,2),
    premium_receivable NUMBER(16,2),
    policy_id NUMBEr(12),
    iss_cd VARCHAR2(2),
    cname   VARCHAR2(100),
    cadd    VARCHAR2(100),
    ret_num NUMBER,
    prems   NUMBER,
    prem_amt    NUMBER,
    tax     NUMBER,
    comm    NUMBER,
    final_date  VARCHAR2(200)
    );
    TYPE giacr219_tab IS TABLE OF giacr219_type;
    
    FUNCTION get_giacr219_record (
    p_from_acct_ent_date VARCHAR2,
    p_to_acct_ent_date   VARCHAR2,
    p_intm_no   NUMBER,
    p_intm_type VARCHAR2,
    p_iss_cred  VARCHAR2,
    p_iss_cd VARCHAR2,
    p_user_id VARCHAR2
    )
    RETURN giacr219_tab PIPELINED;
END;
/


