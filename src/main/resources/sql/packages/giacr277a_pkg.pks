CREATE OR REPLACE PACKAGE CPI.GIACR277A_pkg
AS
/*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.023.2013
    **  Reference By : GIACR277_PKG - SCHEDULE OF RI COMMISSION INCOME (SUMMARY)
    */
    TYPE giacr277a_type IS RECORD (

    line_cd  VARCHAR2(2), 
    iss_cd   VARCHAR2(2), 
    total_prem_amt NUMBER(12,2), 
    nr_prem_amt NUMBER(12,2), 
    treaty_prem NUMBER, 
    treaty_comm NUMBER, 
    trty_acct_type NUMBER,
    facul_prem NUMBER(12,2),
    facul_comm NUMBER(12,2),
    trty_name   VARCHAR2(100),
    total_detail_t_prem NUMBER,
    total_detail_t_comm NUMBER,
    total_detail_f_prem NUMBER,
    total_detail_f_comm NUMBER,
    per_line_t_prem     NUMBER,
    per_line_t_comm     NUMBER,
    per_line_f_prem     NUMBER,
    per_line_f_comm     NUMBER,
    total_per_line_t_prem NUMBER,
    total_per_line_t_comm NUMBER,
    grand_total_t_prem    NUMBER,
    grand_total_t_comm    NUMBER,
    grand_total_f_prem    NUMBER,
    grand_total_f_comm    NUMBER,
    grandtotal_t_prem     NUMBER,
    grandtotal_t_comm     NUMBER

    );
    
    TYPE giacr277a_tab IS TABLE OF giacr277a_type;
    
    TYPE main1_type IS RECORD (
    main_line_cd  VARCHAR2(2), 
    main_iss_cd   VARCHAR2(2), 
    main_total_prem_amt NUMBER(12,2), 
    main_nr_prem_amt NUMBER(12,2),
    iss_source  VARCHAR2(100),
    total_per_line_name VARCHAR2(200),
    comp_name   VARCHAR2(500),
    address     VARCHAR2(500),
    from_to     VARCHAR(300),
    line_cd1        VARCHAR2(100),
    iss_header  VARCHAR2(100)
    );
    TYPE main1_tab IS TABLE OF main1_type;
    FUNCTION get_giacr277A_record(
    p_iss_param VARCHAR2,
    p_from      VARCHAR2,
    p_to        VARCHAR2,
    p_line_cd   VARCHAR2,
    p_user_id   VARCHAR2,
    p_iss       VARCHAR2
    
    )
    RETURN giacr277a_tab PIPELINED;
    
    FUNCTION main1(
    p_iss_param VARCHAR2,
    p_from      VARCHAR2,
    p_to        VARCHAR2,
    p_line_cd   VARCHAR2,
    p_user_id   VARCHAR2,
    p_iss       VARCHAR2
    
    )
    RETURN main1_tab PIPELINED;
END;
/


