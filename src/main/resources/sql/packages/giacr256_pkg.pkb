CREATE OR REPLACE PACKAGE BODY CPI.giacr256_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/27/2013
**Description: GIACR256 : TAXES WITHHELD FROM ALL PAYEES - DETAILED
*/
FUNCTION populate_giacr256(
    p_date1             VARCHAR2,
    p_date2             VARCHAR2,
    p_exclude_tag       VARCHAR2,
    p_module_id         VARCHAR2,
    p_payee             VARCHAR2,
    p_post_tran_toggle  VARCHAR2,
    p_tax_cd            VARCHAR2,
    p_user_id           VARCHAR2
)RETURN giacr256_tab PIPELINED AS

v_rec       giacr256_type;
v_not_exist BOOLEAN := TRUE;
v_date1     DATE := TO_DATE(p_date1, 'MM/DD/RRRR');
v_date2     DATE := TO_DATE(p_date2, 'MM/DD/RRRR');

BEGIN
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giisp.v('COMPANY_ADDRESS');
    v_rec.v_label           := 'From '||TO_CHAR(v_date1,'fmMonth DD, YYYY')||' to '||TO_CHAR(v_date2,'fmMonth DD, YYYY');
    
    FOR i IN( SELECT INITCAP(a.class_desc) Payee_class 
                    ,RTRIM (b.payee_last_name)
                        || DECODE (b.payee_first_name, '', DECODE (b.payee_middle_name, '', NULL, ','),',')
                        || RTRIM (b.payee_first_name)
                        || ' '
                        || b.payee_middle_name Name
                   ,c.tran_date
                   ,c.posting_date
                   ,c.tran_class      
                   ,c.tran_id
                   ,SUM(d.income_amt)  income 
                   ,SUM(d.wholding_tax_amt)  wtax
                   ,e.whtax_desc  whtax
                   ,e.percent_rate rate
                   ,b.TIN 
                   ,e.bir_tax_cd
                   ,b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3 mail_add
              FROM giis_payee_class a
                  ,giis_payees b
                  ,giac_acctrans c
                  ,giac_taxes_wheld d
                  ,giac_wholding_taxes e
              WHERE 1=1
               AND d.payee_class_cd = b.payee_class_cd
               AND d.payee_cd = b.payee_no
               AND b.payee_class_cd = a.payee_class_cd    
               AND d.gacc_tran_id = c.tran_id
               AND d.payee_class_cd = NVL(P_PAYEE,d.payee_class_cd)
               AND c.tran_flag <> 'D'
               AND ((TRUNC (c.tran_date) BETWEEN v_date1 AND v_date2  AND P_POST_TRAN_TOGGLE = 'T')
                    OR (TRUNC (c.posting_date) BETWEEN v_date1 AND v_date2 AND P_POST_TRAN_TOGGLE ='P' ))
               AND e.whtax_id = d.gwtx_whtax_id
               AND e.whtax_code = NVL(p_tax_cd, e.whtax_code) -- Added by Jerome 09.26.2016 SR 5671
               AND( (P_POST_TRAN_TOGGLE = 'T' and c.tran_flag <> NVL( p_exclude_tag,' ')) OR P_POST_TRAN_TOGGLE = 'P')
               AND check_user_per_iss_cd_acctg2 (NULL, c.gibr_branch_cd, P_MODULE_ID, p_user_id) = 1
              GROUP BY  a.class_desc
                       ,RTRIM (b.payee_last_name)
                            || DECODE (b.payee_first_name,'', DECODE (b.payee_middle_name, '', NULL, ','),',')
                            || RTRIM (b.payee_first_name)
                            || ' '
                            || b.payee_middle_name
                       ,c.tran_date
                       ,c.posting_date
                       ,c.tran_class      
                       ,c.tran_id 
                       ,e.whtax_desc
                       ,e.percent_rate
                       ,b.TIN
                       ,e.bir_tax_cd
                       ,b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3
              ORDER BY CLASS_DESC, RTRIM (b.payee_last_name)
                                    || DECODE (b.payee_first_name,'', DECODE (b.payee_middle_name, '', NULL, ','),',')
                                    || RTRIM (b.payee_first_name)
                                    || ' '
                                    || b.payee_middle_name)
    LOOP
        v_not_exist             := FALSE;
        v_rec.payee_class       := i.payee_class;
        v_rec.name              := i.name;
        v_rec.mail_add          := i.mail_add;
        v_rec.tin               := i.tin;
        v_rec.bir_tax_cd        := i.bir_tax_cd;
        v_rec.v_desc            := (i.bir_tax_cd ||'   '||i.whtax||' / '||'Rate:'||TO_CHAR(i.rate, '99.00'));
        v_rec.tran_date         := i.tran_date;
        v_rec.posting_date      := i.posting_date;
        <<sub>>
        FOR z in (SELECT get_ref_no(i.tran_id) ref_no FROM dual)
        LOOP
            v_rec.ref_no := z.ref_no;
            exit sub;
        END LOOP;
        v_rec.income            := i.income;
        v_rec.wtax              := i.wtax;
        PIPE ROW(v_rec);
    END LOOP;
    
    
    IF v_not_exist THEN
        v_rec.flag := 'T';
        PIPE ROW(v_rec);
    END IF;
END populate_giacr256;


END giacr256_pkg;
/


