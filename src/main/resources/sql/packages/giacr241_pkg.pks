CREATE OR REPLACE PACKAGE CPI.giacr241_pkg AS

/*
**Created by; Benedict G. Castillo
**Date Created: 07/25/2013
**Description: GIACR241 : Paid Checks per Department
*/

TYPE giacr241_type IS RECORD(
    flag                VARCHAR2(2),
    company_name        VARCHAR2(300),
    company_address     VARCHAR2(500),
    v_date              VARCHAR2(100),
    branch_cd           giac_pd_checks_v.branch_cd%TYPE,
    branch_name         giac_pd_checks_v.branch_name%TYPE,
    ouc_name            giac_pd_checks_v.ouc_name%TYPE,
    payee_name          VARCHAR2(550),
    check_date          VARCHAR2(20),
    particulars         giac_pd_checks_v.particulars%TYPE,
    check_no            giac_pd_checks_v.check_no%TYPE,
    dv_amt              giac_pd_checks_v.dv_amt%TYPE, 
    class_desc          giac_pd_checks_v.class_desc%TYPE           
);
TYPE giacr241_tab IS TABLE OF giacr241_type;

FUNCTION populate_giacr241(
    p_payee         VARCHAR2,
    p_branch        VARCHAR2,
    p_ouc_id        VARCHAR2,
    p_payee_no      VARCHAR2,
    p_sort_item     VARCHAR2,
    p_begin_date    VARCHAR2,
    p_end_date      VARCHAR2
)RETURN giacr241_tab PIPELINED;


END giacr241_pkg;
/


