CREATE OR REPLACE PACKAGE CPI.GIACR277_PKG
AS
 /*
    **  Created by   :  Melvin John O. Ostia
    **  Date Created : 07.020.2013s
    **  Reference By : GIACR277_PKG - SCHEDULE ON MONTHLY COMMISION INCOME
    **  Modified by : Kevin S. for SR-18635 7-11-2016
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
         grand_total_comm   NUMBER(12,2),
         header1            VARCHAR2(100),
         header2            VARCHAR2(100),
         header3            VARCHAR2(100),
         header4            VARCHAR2(100),
         header5            VARCHAR2(100),
         header6            VARCHAR2(100),
         header7            VARCHAR2(100),
         header8            VARCHAR2(100),
         header9            VARCHAR2(100),
         header10           VARCHAR2(100),
         detail1            NUMBER(12,2),
         detail2            NUMBER(12,2),
         detail3            NUMBER(12,2),
         detail4            NUMBER(12,2),
         detail5            NUMBER(12,2),
         detail6            NUMBER(12,2),
         detail7            NUMBER(12,2),
         detail8            NUMBER(12,2),
         detail9            NUMBER(12,2),
         detail10           NUMBER(12,2),
         trty1              VARCHAR2(50),
         trty2              VARCHAR2(50),
         trty3              VARCHAR2(50),
         trty4              VARCHAR2(50),
         trty5              VARCHAR2(50),
         grand_total1       NUMBER(12,2),
         grand_total2       NUMBER(12,2),
         grand_total3       NUMBER(12,2),
         grand_total4       NUMBER(12,2),
         grand_total5       NUMBER(12,2),
         grand_total6       NUMBER(12,2),
         grand_total7       NUMBER(12,2),
         grand_total8       NUMBER(12,2),
         grand_total9       NUMBER(12,2),
         grand_total10      NUMBER(12,2),
         line_count         NUMBER
    );
    TYPE giacr277_tab IS TABLE OF giacr277_type;
    
    TYPE giacr277_line_type IS RECORD (
         line_cd            VARCHAR2(2),
         comp_name          VARCHAR2(300),
         address            VARCHAR2(500), 
         from_to            VARCHAR2(500),
         line               VARCHAR2(100),
         print_grand_total  NUMBER,
         facul_prem         NUMBER(12,2),
         facul_comm         NUMBER(12,2),
         grand_total_nr_prem_amt NUMBER(12,2),
         grand_total_prem_amt NUMBER(12,2)
    );
    TYPE giacr277_line_tab IS TABLE OF giacr277_line_type;
    
    FUNCTION get_giacr277_record(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_line_cd_all   VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER,
        p_grand_total_prem NUMBER,
        p_grand_total_comm NUMBER,
        p_print_grand_total VARCHAR2,
        p_grand_total_prem_amt NUMBER,
        p_grand_total_nr_prem_amt NUMBER
    )
    RETURN giacr277_tab PIPELINED;
    
    FUNCTION get_giacr277_line(
        p_iss_param     VARCHAR2,
        p_from          VARCHAR2,
        p_to            VARCHAR2,
        p_line_cd       VARCHAR2,
        p_user_id       VARCHAR2,
        p_policy_id     NUMBER,
        p_peril_cd      NUMBER,
        p_acct_type     NUMBER
    )
    RETURN giacr277_line_tab PIPELINED;
END;
/


