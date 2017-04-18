CREATE OR REPLACE PACKAGE BODY CPI.giacr254_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/23/2013
**Description: GIACR254 - Tax Withheld
*/
FUNCTION F_refnoFormula (p_tran_class VARCHAR2, p_tran_id NUMBER)
return VARCHAR2 is
v_jv  VARCHAR2(20);
v_dvn  VARCHAR2(20);
v_dvy  VARCHAR2(20);
V_col  VARCHAR2(20);

BEGIN  

IF p_tran_class ='JV' THEN
  FOR jv IN (
    SELECT  c.tran_class ||'-'|| LPAD(TO_CHAR(c.tran_class_no),10,0)a --added leading zeros by JJJPajilan 08/04/2011                                          
      FROM giac_acctrans c       
    WHERE c.tran_id =p_tran_id)LOOP

    v_jv := jv.a;
    RETURN v_jv;
    END LOOP; --jv
ELSIF p_tran_class = 'COL' THEN
  FOR col IN (
    SELECT e.or_pref_suf ||'-'|| LPAD(TO_CHAR(e.or_no),10,0) b 
      FROM giac_acctrans c
           ,giac_order_of_payts e
    WHERE c.tran_id =p_tran_id
    AND c.tran_id = e.gacc_tran_id)LOOP
       
    v_col := col.b;
    RETURN v_col;
    END LOOP; --col
ELSIF p_tran_class = 'DV' THEN
 FOR dv IN (
   SELECT k.with_dv, k.document_cd ||'-'|| LPAD(TO_CHAR(k.doc_seq_no),6,0) c 
     FROM giac_payt_requests k,
          giac_payt_requests_dtl l,
          giac_acctrans c
   WHERE k.ref_id = l.gprq_ref_id
   AND   c.tran_id = l.tran_id
   AND   c.tran_id =p_tran_id) LOOP
      
       IF dv.with_dv = 'Y' THEN
         FOR y IN(
           SELECT n.dv_pref ||'-'||LPAD(TO_CHAR(n.dv_no),10,0) d --added leading zeros by JJJPajilan 08/04/2011
             FROM giac_disb_vouchers n                                      
           WHERE n.gacc_tran_id =p_tran_id) LOOP
       v_dvy :=y.d;
       RETURN v_dvy;       
       END LOOP;--y
       ELSIF dv.with_dv = 'N' THEN
            v_dvn := dv.c;
       END IF;        
  END LOOP;--dv
END IF;
RETURN NULL; END;




  



FUNCTION populate_giacr254(
    p_date1                 VARCHAR2,
    p_date2                 VARCHAR2,
    p_exclude_tag           VARCHAR2,
    p_module_id             VARCHAR2,
    p_payee                 VARCHAR2,
    p_post_tran_toggle      VARCHAR2,
    p_tax_id                VARCHAR2,
    p_user_id               VARCHAR2
)
RETURN giacr254_tab PIPELINED AS

v_rec       giacr254_type;
v_date1     DATE := TO_DATE(p_date1,'MM/DD/RRRR');
v_date2     DATE := TO_DATE(p_date2, 'MM/DD/RRRR');
v_not_exist BOOLEAN := TRUE;
BEGIN
    v_rec.company_name      := giisp.v('COMPANY_NAME');
    v_rec.company_address   := giisp.v('COMPANY_ADDRESS');
    v_rec.v_date            := 'From '||TO_CHAR(v_date1, 'fmMonth DD, YYYY')||' to '||TO_CHAR(v_date2, 'fmMonth DD, YYYY');
    <<main>>
    FOR i IN(SELECT  INITCAP (a.class_desc) payee_class,
                     RTRIM (b.payee_last_name)|| DECODE (b.payee_first_name,
                           '', DECODE (b.payee_middle_name, '', NULL, ','),
                           ',')|| RTRIM (b.payee_first_name)|| ' '|| b.payee_middle_name NAME,
                     TRUNC (c.tran_date) trans_date, c.posting_date, c.tran_class, c.tran_id,
                     SUM (d.income_amt) income, SUM (d.wholding_tax_amt) wtax, e.whtax_desc,
                     b.tin,
                     b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3 buss_add,
                     e.bir_tax_cd
            FROM giis_payee_class a,
                 giis_payees b,
                 giac_acctrans c,
                 giac_taxes_wheld d,
                 giac_wholding_taxes e
           WHERE d.gacc_tran_id NOT IN (SELECT h.gacc_tran_id
                                          FROM giac_reversals h, giac_acctrans j
                                         WHERE h.reversing_tran_id = j.tran_id
                                           AND j.tran_flag <> 'D')
             AND d.payee_class_cd = b.payee_class_cd
             AND d.gwtx_whtax_id = e.whtax_id
             AND d.payee_cd = b.payee_no
             AND b.payee_class_cd = a.payee_class_cd
             AND d.gacc_tran_id = c.tran_id
             AND c.tran_flag <> 'D'
             AND d.payee_class_cd = NVL (p_payee, d.payee_class_cd)
             AND d.gwtx_whtax_id = NVL (p_tax_id, d.gwtx_whtax_id)
             AND (   (    TRUNC (c.tran_date) BETWEEN v_date1 AND v_date2
                      AND p_post_tran_toggle = 'T')
                  OR (    TRUNC (c.posting_date) BETWEEN v_date1 AND v_date2
                      AND p_post_tran_toggle = 'P'))
             AND (   (    p_post_tran_toggle = 'T'
                      AND c.tran_flag <> NVL (p_exclude_tag, ' '))
                  OR p_post_tran_toggle = 'P')
             AND check_user_per_iss_cd_acctg2 (NULL, c.gibr_branch_cd, P_MODULE_ID, p_user_id) = 1
            GROUP BY a.class_desc,
                        RTRIM (b.payee_last_name)
                     || DECODE (
                           b.payee_first_name,
                           '', DECODE (b.payee_middle_name, '', NULL, ','),
                           ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name,
                     c.tran_date,
                     c.posting_date,
                     c.tran_class,
                     c.tran_id,
                     e.whtax_desc,
                     b.tin,
                     b.mail_addr1||' '||b.mail_addr2||' '||b.mail_addr3,
                     e.bir_tax_cd
            ORDER BY e.whtax_desc,
                     class_desc,
                        RTRIM (b.payee_last_name)
                     || DECODE (
                           b.payee_first_name,
                           '', DECODE (b.payee_middle_name, '', NULL, ','),
                           ',')
                     || RTRIM (b.payee_first_name)
                     || ' '
                     || b.payee_middle_name)
    LOOP
        v_not_exist             := FALSE;
        v_rec.bir_tax_cd        := i.bir_tax_cd;
        v_rec.whtax_desc        := i.whtax_desc;
        v_rec.payee_class       := i.payee_class;
        v_rec.name              := i.name;
        v_rec.buss_add          := i.buss_add;
        v_rec.tin               := i.tin;
        v_rec.trans_date        := i.trans_date;
        v_rec.posting_date      := i.posting_date;
        v_rec.tran_class        := i.tran_class;
        v_rec.income            := i.income;
        v_rec.wtax              := i.wtax;
        v_rec.refno             := F_refnoFormula(i.tran_class, i.tran_id);        
        PIPE ROW(v_rec);
    END LOOP main;
    
    IF v_not_exist THEN
        v_rec.flag  := 'T';
        PIPE ROW(v_rec);
    END IF;

END populate_giacr254;

END giacr254_pkg;
/


