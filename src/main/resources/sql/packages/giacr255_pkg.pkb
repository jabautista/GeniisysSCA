CREATE OR REPLACE PACKAGE BODY CPI.giacr255_pkg AS

/*
**Created by: Benedict G Castillo
**Date Created: 07/23/2013
**Description: GIACR255 - Taxes withheld - Detailed
*/

FUNCTION populate_giacr255(
    p_date1             VARCHAR2,
    p_date2             VARCHAR2,
    p_exclude_tag       VARCHAR2,
    p_module_id         VARCHAR2,
    p_payee             VARCHAR2,
    p_post_tran_toggle  VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr255_tab PIPELINED AS

v_rec   giacr255_type;
v_date1 DATE := TO_DATE(p_date1, 'MM/DD/RRRR');
v_date2 DATE := TO_DATE(p_date2, 'MM/DD/RRRR');
v_not_exist BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giisp.v('COMPANY_ADDRESS');
    v_rec.v_date            := 'From '||TO_CHAR(v_date1, 'fmMonth DD, YYYY')|| ' to '||TO_CHAR(v_date2, 'fmMonth DD, YYYY');
    
    FOR i IN(SELECT INITCAP(a.class_desc) Payee_class, 
                    RTRIM (b.payee_last_name)|| DECODE (b.payee_first_name,
                        '', DECODE (b.payee_middle_name, '', NULL, ','),',')
                        || RTRIM (b.payee_first_name)
                        || ' '
                        || b.payee_middle_name NAME
                   ,c.tran_date
                   ,c.posting_date
                   ,c.tran_class      
                   ,c.tran_id
                   ,SUM(d.income_amt)  income 
                   ,SUM(d.wholding_tax_amt)  wtax
              FROM giis_payee_class a
                   ,giis_payees b
                   ,giac_acctrans c
                   ,giac_taxes_wheld d
                WHERE d.gacc_tran_id NOT IN
                                      (SELECT H.gacc_tran_id
                                       FROM giac_reversals H
                                           ,giac_acctrans J
                                       WHERE H.reversing_tran_id = J.tran_id 
                                       AND J.tran_flag <>'D')
               AND d.payee_class_cd = b.payee_class_cd
               AND d.payee_cd = b.payee_no
               AND b.payee_class_cd = a.payee_class_cd    
               AND d.gacc_tran_id = c.tran_id
               AND c.tran_flag <> 'D'
               AND D.PAYEE_CLASS_CD = NVL(P_PAYEE, D.PAYEE_CLASS_CD)
               AND ((TRUNC (c.tran_date) BETWEEN v_date1 AND v_date2  AND P_POST_TRAN_TOGGLE = 'T')
                    OR (TRUNC (c.posting_date) BETWEEN v_date1 AND v_date2 AND P_POST_TRAN_TOGGLE ='P' ))
               AND( (P_POST_TRAN_TOGGLE = 'T' and c.tran_flag <> NVL( p_exclude_tag,' ')) OR P_POST_TRAN_TOGGLE = 'P')
               AND check_user_per_iss_cd_acctg2 (NULL, c.gibr_branch_cd, P_MODULE_ID, p_user_id) = 1
               GROUP BY  a.class_desc
                        ,RTRIM (b.payee_last_name)|| DECODE (b.payee_first_name,'', 
                            DECODE (b.payee_middle_name, '', NULL, ','), ',')
                            || RTRIM (b.payee_first_name)
                            || ' '
                            || b.payee_middle_name
                        ,c.tran_date
                        ,c.posting_date
                        ,c.tran_class      
                        ,c.tran_id 
                ORDER BY CLASS_DESC, RTRIM (b.payee_last_name)
                         || DECODE (
                               b.payee_first_name,
                               '', DECODE (b.payee_middle_name, '', NULL, ','),
                               ',')
                         || RTRIM (b.payee_first_name)
                         || ' '
                         || b.payee_middle_name)    
    LOOP
        v_not_exist         := FALSE;
        v_rec.payee_class   := i.payee_class;
        v_rec.name          := i.name;
        v_rec.tran_date     := i.tran_date;
        v_rec.posting_date  := i.posting_date;
        
        <<ref1>>
        FOR z in (SELECT get_ref_no(i.tran_id) ref_no
              FROM dual)
        LOOP
            v_rec.ref_no := z.ref_no;
            exit ref1;
        END LOOP;
        
        v_rec.income        := i.income;
        v_rec.wtax          := i.wtax;
        PIPE ROW(v_rec);
    END LOOP;
 
    IF v_not_exist THEN
        v_rec.flag  := 'T';
        PIPE ROW(v_rec);
    END IF;

END populate_giacr255;
END giacr255_pkg;
/


