CREATE OR REPLACE PACKAGE BODY CPI.giacr253_pkg AS

/*
**Created by : Benedict G. Castillo
**Date Created: 07/23/2013
**Description: GIACR253:Taxes Withheld
*/

FUNCTION populate_giacr253 (
    p_date1             VARCHAR2,
    p_date2             VARCHAR2,
    p_exculde_tag       VARCHAR2,
    p_exclude_tag       VARCHAR2,
    p_module_id         VARCHAR2,
    p_payee             VARCHAR2,
    p_post_tran_toggle  VARCHAR2,
    p_tax_id            VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr253_tab PIPELINED AS

v_rec       giacr253_type;
v_from_date DATE := TO_DATE(p_date1, 'MM/DD/RRRR');
v_to_date   DATE := TO_DATE(p_date2, 'MM/DD/RRRR');
v_not_exist BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giisp.v('COMPANY_ADDRESS');
    v_rec.v_date            := 'From '||TO_CHAR(v_from_date, 'fmMonth DD, YYYY')||' to '||TO_CHAR(v_to_date, 'fmMonth DD, YYYY');
    
    FOR i IN(SELECT   a.payee_class_cd, INITCAP (d.class_desc) class_desc, a.payee_cd,
                      RTRIM (b.payee_last_name)|| DECODE (b.payee_first_name,'', 
                        DECODE (b.payee_middle_name, '', NULL, ','),',')
                         || RTRIM (b.payee_first_name)
                         || ' '
                         || b.payee_middle_name NAME,
                      SUM (a.income_amt) income, SUM (a.wholding_tax_amt) wtax, e.whtax_desc,
                      b.tin,
                      e.bir_tax_cd
             FROM giac_taxes_wheld a,
                  giis_payees b,
                  giac_acctrans c,
                  giis_payee_class d,
                  giac_wholding_taxes e
             WHERE a.gacc_tran_id NOT IN (SELECT e.gacc_tran_id
                                          FROM giac_reversals e, giac_acctrans f
                                          WHERE e.reversing_tran_id = f.tran_id
                                           AND f.tran_flag <> 'D'
                                           and f.tran_date <= v_to_date)
             AND a.payee_class_cd = b.payee_class_cd
             AND a.payee_cd = b.payee_no
             AND b.payee_class_cd = d.payee_class_cd
             AND a.gacc_tran_id = c.tran_id
             AND c.tran_flag <> 'D'
             AND e.whtax_id = a.gwtx_whtax_id
             AND a.payee_class_cd = NVL (p_payee, a.payee_class_cd)
             AND a.gwtx_whtax_id = NVL (p_tax_id, a.gwtx_whtax_id)
             AND c.tran_flag <> NVL (p_exculde_tag, 'A')
             AND (   (    TRUNC (c.tran_date) BETWEEN v_from_date AND v_to_date
                      AND p_post_tran_toggle = 'T')
                  OR (    TRUNC (c.posting_date) BETWEEN v_from_date AND v_to_date
                      AND p_post_tran_toggle = 'P'))
             AND (   (    p_post_tran_toggle = 'T'
                      AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                  OR p_post_tran_toggle = 'P')
             AND check_user_per_iss_cd_acctg2 (NULL, c.gibr_branch_cd, p_module_id, p_user_id) = 1
            GROUP BY a.payee_class_cd,
                     d.class_desc,
                     a.payee_cd,
                     
                        RTRIM (b.payee_last_name)
                     || DECODE (
                           b.payee_first_name,
                           '', DECODE (b.payee_middle_name, '', NULL, ','),
                           ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     e.whtax_desc,
                     b.tin,
                     e.bir_tax_cd
            ORDER BY e.whtax_desc,
                     d.class_desc,
                        RTRIM (b.payee_last_name)
                     || DECODE (
                           b.payee_first_name,
                           '', DECODE (b.payee_middle_name, '', NULL, ','),
                           ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name)
    LOOP
        v_not_exist         := FALSE;
        v_rec.bir_tax_cd    := i.bir_tax_cd;
        v_rec.whtax_desc    := i.whtax_desc;
        v_rec.class_desc    := i.class_desc;
        v_rec.name          := i.name;
        v_rec.tin           := i.tin;
        v_rec.income        := i.income;
        v_rec.wtax          := i.wtax;
        PIPE ROW(v_rec);
        
    END LOOP;
    
    IF v_not_exist THEN
        v_rec.flag := 'T';
        PIPE ROW(v_rec);
    END IF;

END populate_giacr253;

END giacr253_pkg;
/


