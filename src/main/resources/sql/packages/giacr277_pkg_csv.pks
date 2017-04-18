CREATE OR REPLACE PACKAGE CPI.GIACR277_PKG_CSV
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.020.2013
    **  Reference By : GIACR277_PKG - SCHEDULE ON MONTHLY COMMISION INCOME
    */
    TYPE giacr277_type IS RECORD (
         line_cd            VARCHAR2(2),
         iss_cd             VARCHAR2(2), 
         assd_no            NUMBER(12,2), 
         policy_id          NUMBER(12,2), 
         incept_date        DATE,
         acct_ent_date      DATE,   
         peril_cd           NUMBER(12,2), 
         total_prem_amt     NUMBER(12,2),  
         nr_prem_amt        NUMBER(12,2), 
         trty_acct_type     NUMBER(12,2),
         facul_prem         NUMBER(12,2),  
         facul_comm         NUMBER(12,2),
         comp_name          VARCHAR2(300),
         address            VARCHAR2(500), 
         from_to            VARCHAR2(500),
         line               VARCHAR2(100),
         iss_header         VARCHAR2(100),
         iss_source         VARCHAR2(100),
         assd_name          VARCHAR2(500),
         policy_no          VARCHAR2(100),
         peril_name         VARCHAR2(100),
         trty_name          VARCHAR2(30),
         title_formula      VARCHAR2(500),
         name_per_line      VARCHAR2(300),
         grand_total_prem   NUMBER(12,2),
         grand_total_comm   NUMBER(12,2)
    );
    TYPE giacr277_tab IS TABLE OF giacr277_type;
    
    TYPE matrix_type IS RECORD (
         line_cd            VARCHAR2(2),
         iss_cd             VARCHAR2(2), 
         policy_id          NUMBER(12,2),  
         peril_cd           NUMBER(12,2),
         treaty_prem        NUMBER(12,2), 
         treaty_comm        NUMBER(12,2),  
         trty_acct_type     NUMBER(12,2),
         trty_name          VARCHAR2(30),
         facul_prem         NUMBER(12,2),  
         facul_comm         NUMBER(12,2),
         trty_acct_type2    NUMBER(12,2),
         total_prem         NUMBER(12,2),
         total_comm         NUMBER(12,2),
         TOTAL_treaty_prem  NUMBER(12,2),
         TOTAL_treaty_comm  NUMBER(12,2),
         f_prem             NUMBER(12,2),
         f_comm             NUMBER(12,2),
         iss_treaty_prem    NUMBER(12,2),
         iss_treaty_comm    NUMBER(12,2),
         line_treaty_prem   NUMBER(12,2),
         line_treaty_comm   NUMBER(12,2),
         line_treaty_prem1   NUMBER(12,2),
         line_treaty_comm1   NUMBER(12,2)
    );
    TYPE matrix_tab IS TABLE OF matrix_type;
    
    TYPE grand_total_type IS RECORD( --added by Kevin for grand total column error SR-18635 6-1-2016
         line_cd            VARCHAR2(2),
         trty_acct_type     NUMBER(12,2),
         total_treaty_prem  NUMBER(12,2),
         total_treaty_comm  NUMBER(12,2)
    );
    TYPE grand_total_tab IS TABLE OF grand_total_type;
    
    FUNCTION matrix(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2, 
        p_user_id       VARCHAR2, 
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER,
        p_iss           VARCHAR2
    )
    RETURN matrix_tab PIPELINED;
    
    FUNCTION get_giacr277_record(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER
    )
    RETURN giacr277_tab PIPELINED;
    
    FUNCTION get_grand_total( --added by Kevin for grand total column error SR-18635 6-1-2016
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2
    )
    RETURN grand_total_tab PIPELINED;
    
END;
/


