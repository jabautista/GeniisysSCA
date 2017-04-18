CREATE OR REPLACE PACKAGE BODY CPI.giacr241_pkg AS

/*
**Created By : Benedict G. Castillo
**Date Created: 07/25/2013
**Description: GAICR241 : Paid Checks per Department
*/

FUNCTION populate_giacr241(
    p_payee         VARCHAR2,
    p_branch        VARCHAR2,
    p_ouc_id        VARCHAR2,
    p_payee_no      VARCHAR2,
    p_sort_item     VARCHAR2,
    p_begin_date    VARCHAR2,
    p_end_date      VARCHAR2
)RETURN giacr241_tab PIPELINED AS

v_rec       giacr241_type;
v_not_exist BOOLEAN := TRUE;
v_begin     DATE := TO_DATE(p_begin_date, 'MM/DD/RRRR');
v_end       DATE := TO_DATE(p_end_date, 'MM/DD/RRRR');

BEGIN
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giacp.v('COMPANY_ADDRESS');
    
    if v_begin = v_end then
        v_rec.v_date    :=to_char(v_begin,'fmMONTH DD, YYYY');
    else
        v_rec.v_date    := 'For the Period of '||to_char(v_begin, 'fmMONTH DD, YYYY')
                            ||' to '|| to_char(v_end, 'fmMONTH DD, YYYY'); 
    end if;
    
    FOR i IN(SELECT payee_last_name||', '||payee_first_name||' '||payee_middle_name payee_name,
                    branch_cd,
                    branch_name,
                    particulars,
                    ouc_name,
                    check_no,
                    check_date,
                    dv_amt,
                    class_desc
            FROM giac_pd_checks_v
            WHERe ouc_id=nvl(p_ouc_id,ouc_id)
            AND TRUNC(check_date)>=nvl(v_begin,check_date) AND TRUNC(check_date)<=nvl(v_end,check_date))
    
    LOOP
        v_not_exist             := FALSE;
        v_rec.branch_cd         := i.branch_cd;
        v_rec.branch_name       := i.branch_name;
        v_rec.ouc_name          := i.ouc_name;
        v_rec.payee_name        := i.payee_name;
        v_rec.check_date        := TO_CHAR(i.check_date,  GET_REP_DATE_FORMAT);
        v_rec.particulars       := i.particulars;
        v_rec.check_no          := i.check_no;
        v_rec.dv_amt            := i.dv_amt;
        v_rec.class_desc        := i.class_desc;
        PIPE ROW(v_rec);
    END LOOP;
    
    IF v_not_exist THEN
        v_rec.flag  := 'T';
        PIPE ROW(v_rec);
    END IF;
END populate_giacr241;

END giacr241_pkg;
/


