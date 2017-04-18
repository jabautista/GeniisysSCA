CREATE OR REPLACE PACKAGE CPI.GIACR217_pkg
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.025.2013
    **  Reference By : GIACR217_PKG - PRODUCTION REGISTER PER INTERMEDIARY 
    */
    TYPE giacr217_type IS RECORD (
    branch VARCHAR2(100),
    intermediary_1 VARCHAR2(240),
    INTERMEDIARY_TYPE VARCHAR2(100),
    LINE VARCHAR2(20),
    SUBLINE VARCHAR2(300),
    assured_name VARCHAR2(500),
    incept_date  DATE,
    expiry_date DATE,
    commission NUMBER(12,2),
    endt_seq_no NUMBER(6),
    line_cd VARCHAR2(2),
    subline_cd VARCHAR2(7),
    iss_cd VARCHAR2(2), 
    issue_yy NUMBER(2),
    pol_seq_no NUMBER(7),
    renew_no NUMBER(2),
    endt_iss_cd  VARCHAR2(2),
    endt_yy NUMBER(2),
    sum_insured NUMBER(16,2),
    premium_amt NUMBER(16,2),
    tax_amount NUMBER(16,2),
    premium_receivable NUMBER(16,2),
    policy_id NUMBEr(12),
    iss_cd1 VARCHAR2(2),
    company_name VARCHAR2(300),
    company_address VARCHAR2(300),
    as_of   VARCHAR2(100),
    policy VARCHAR2(2000)
    );
    TYPE giacr217_tab IS TABLE OF giacr217_type;
    
    FUNCTION get_giacr217_record(
    p_from_acct_ent_date VARCHAR2,
    p_to_acct_ent_date   VARCHAR2,
    p_intm_no   NUMBER,
    p_intm_type VARCHAR2,
    p_iss_cred  VARCHAR2,
    p_iss_cd VARCHAR2,
    p_user_id VARCHAR2
    )
    RETURN giacr217_tab PIPELINED;
END;
/


