CREATE OR REPLACE PACKAGE CPI.GIACR121B_PKG AS

TYPE giacr121b_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE,
    cut_off             VARCHAR2(40),
    extract_date        VARCHAR2(40),
    ri_code				giis_reinsurer.ri_cd%TYPE, --added by Daniel Marasigan SR 5348
    ri_name             giac_ri_stmt_ext.ri_name%TYPE,
    after_date_comm     giac_ri_stmt_ext.after_date_comm%TYPE,
    month               VARCHAR2(30),
    col_title1          VARCHAR2(50),
    col_title2          VARCHAR2(50),
    col_title3          VARCHAR2(50),
    amt_1               NUMBER(16,2),
    comm_1              NUMBER(16,2),
    amt_2               NUMBER(16,2),
    comm_2              NUMBER(16,2),
    amt_3               NUMBER(16,2),
    comm_3              NUMBER(16,2),
    tot_amt             NUMBER,
    tot_comm            NUMBER,
    after_dt_amt        NUMBER,
    balance             NUMBER,
    bal_comm            NUMBER,
    prem_comm           NUMBER,
    net_bal_due         NUMBER,
    net_prem1           NUMBER,
    net_prem2           NUMBER,
    net_prem3           NUMBER,
    tot_net_prem        NUMBER,
    after_dt_bal_prem   NUMBER,
    after_dt_bal_comm   NUMBER,
    bal_aft_date        NUMBER,
    v_not_exist       VARCHAR2 (8)
    
);

TYPE giacr121b_tab IS TABLE OF giacr121b_type;

FUNCTION populate_giacr121b(
    p_ri_cd     VARCHAR2,
    p_line_cd   VARCHAR2,
    p_aging     VARCHAR2,
    p_comm      VARCHAR2,
    p_user      VARCHAR2,
    p_cut_off   VARCHAR2
)
RETURN giacr121b_tab PIPELINED;

END GIACR121B_PKG;
/


