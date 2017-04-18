DROP FUNCTION CPI.LOSS_EXPENSE_HIST_DTLS;

CREATE OR REPLACE FUNCTION CPI.Loss_Expense_Hist_Dtls (p_dtl VARCHAR2,
                                            p_claim_id gicl_claims.claim_id%TYPE,
                                            p_line_cd gicl_claims.line_cd%TYPE,
                                            p_item_no gicl_item_peril.item_no%TYPE,
                                            p_peril_cd gicl_item_peril.peril_cd%TYPE)
  RETURN VARCHAR2 IS
/* this function is created for the purpose of sorting item/peril details,
** which are non-base, on Loss/Expense History module (GICLS030)
** data to be returned are ite/item_title, peril/peril_name and
** currency. created by Pia, 03/20/03 */
   v_data  VARCHAR2(200);
BEGIN
  IF UPPER(p_dtl) = 'ITEM' THEN
     FOR itm IN
       (SELECT DISTINCT a.item_no item_no, c.item_title title
          FROM gicl_item_peril a, gicl_clm_item c
         WHERE a.claim_id = c.claim_id
           AND a.item_no  = c.item_no
           AND a.claim_id = p_claim_id
           AND EXISTS (SELECT 'X'
                         FROM gicl_clm_res_hist b
                        WHERE b.peril_cd = a.peril_cd
                          AND b.item_no  = a.item_no
                          AND b.claim_id = a.claim_id
                          AND b.dist_sw = 'Y'))
     LOOP
       v_data := TO_CHAR(itm.item_no)||'-'||itm.title;
     END LOOP;
  ELSIF UPPER(p_dtl) = 'PERIL' THEN
     FOR peril IN
       (SELECT DISTINCT a.item_no, a.peril_cd code, e.peril_name name
          FROM gicl_item_peril a, giis_peril e
         WHERE a.peril_cd = e.peril_cd
           AND a.claim_id = p_claim_id
           AND a.item_no  = p_item_no
           AND a.peril_cd = p_peril_cd
           AND e.line_cd  = p_line_cd
           AND EXISTS (SELECT 'X'
                         FROM gicl_clm_res_hist b
                        WHERE b.peril_cd = a.peril_cd
                          AND b.item_no  = a.item_no
                          AND b.claim_id = a.claim_id
                          AND b.dist_sw = 'Y'))
     LOOP
       v_data := TO_CHAR(peril.code)||'-'||peril.name;
     END LOOP;
  ELSIF UPPER(p_dtl) = 'CURRENCY' THEN
     FOR curncy IN
       (SELECT DISTINCT a.item_no, d.currency_desc des
          FROM gicl_item_peril a, gicl_clm_item c, giis_currency d
         WHERE a.claim_id    = c.claim_id
           AND a.item_no     = c.item_no
           AND c.currency_cd = d.main_currency_cd
           AND a.claim_id    = p_claim_id
           AND a.item_no     = p_item_no
           AND a.peril_cd    = p_peril_cd
           AND EXISTS (SELECT 'X'
                         FROM gicl_clm_res_hist b
                        WHERE b.peril_cd = a.peril_cd
                          AND b.item_no  = a.item_no
                          AND b.claim_id = a.claim_id
                          AND b.dist_sw = 'Y'))
     LOOP
       v_data := curncy.des;
     END LOOP;
  END IF;
  RETURN(v_data);
END;
/


