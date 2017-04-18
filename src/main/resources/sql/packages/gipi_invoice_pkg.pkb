CREATE OR REPLACE PACKAGE BODY CPI.GIPI_INVOICE_PKG AS
FUNCTION get_pol_invoice(p_policy_id  GIPI_POLBASIC.policy_id%TYPE)
     
    RETURN gipi_pol_invoice_tab PIPELINED
    
  IS v_pol_invoice gipi_pol_invoice_type;
  
  BEGIN
    
     FOR i IN (SELECT policy_id,item_grp,iss_cd,prem_seq_no,
                      insured, property,ref_inv_no,
                      policy_currency, NVL(other_charges, 0) other_charges,
                      tax_amt,prem_amt,remarks,
                      NVL (prem_amt, 0)
                      + NVL (tax_amt, 0)
                      + NVL (other_charges, 0) amount_due
                 FROM GIPI_INVOICE
                WHERE policy_id = NVL(p_policy_id,policy_id))
     LOOP
        
        v_pol_invoice.policy_id           := i.policy_id;
        v_pol_invoice.item_grp            := i.item_grp;
        v_pol_invoice.iss_cd              := i.iss_cd;
        v_pol_invoice.prem_seq_no         := i.prem_seq_no;
        v_pol_invoice.insured             := i.insured;
        v_pol_invoice.remarks             := i.remarks;
        v_pol_invoice.tax_amt             := i.tax_amt;
        v_pol_invoice.property            := i.property;
        v_pol_invoice.prem_amt            := i.prem_amt;
        v_pol_invoice.ref_inv_no          := i.ref_inv_no;
        v_pol_invoice.other_charges       := i.other_charges;
        v_pol_invoice.amount_due          := i.amount_due;
        
--        modified by gab 07.05.2016  SR 22310
--        SELECT DISTINCT a.currency_desc
--          INTO v_pol_invoice.currency_desc
--          FROM giis_currency a, gipi_item b
--         WHERE b.policy_id = i.policy_id
--           AND b.item_grp = i.item_grp
--           AND b.currency_cd = a.main_currency_cd;
        BEGIN   
        SELECT DISTINCT a.currency_desc
          INTO v_pol_invoice.currency_desc
          FROM giis_currency a, gipi_item b
         WHERE b.policy_id = i.policy_id
           AND b.item_grp = i.item_grp
           AND b.currency_cd = a.main_currency_cd;
        EXCEPTION 
        WHEN NO_DATA_FOUND
        THEN
              v_pol_invoice.currency_desc := '';       
        END;   
        
        BEGIN
        
            SELECT par_id,iss_cd,insured,tax_amt,remarks,
                   prem_amt,ref_inv_no,prem_seq_no,NVL(other_charges, 0),
                   NVL (prem_amt, 0)
                   + NVL (tax_amt, 0)
                   + NVL (other_charges, 0)
              INTO v_pol_invoice.orig_par_id,
                   v_pol_invoice.orig_iss_cd,
                   v_pol_invoice.orig_insured,
                   v_pol_invoice.orig_tax_amt,
                   v_pol_invoice.orig_remarks,
                   v_pol_invoice.orig_prem_amt,
                   v_pol_invoice.orig_ref_inv_no,
                   v_pol_invoice.orig_prem_seq_no,
                   v_pol_invoice.orig_other_charges,
                   v_pol_invoice.orig_amount_due
              FROM gipi_orig_invoice
             WHERE policy_id = i.policy_id AND item_grp = i.item_grp;
         
            v_pol_invoice.orig_currency_desc := v_pol_invoice.currency_desc;
        
        EXCEPTION
        WHEN NO_DATA_FOUND
        THEN
        
            v_pol_invoice.orig_par_id           := '';
            v_pol_invoice.orig_iss_cd           := '';
            v_pol_invoice.orig_insured          := '';
            v_pol_invoice.orig_tax_amt          := '';
            v_pol_invoice.orig_remarks          := '';
            v_pol_invoice.orig_prem_amt         := '';
            v_pol_invoice.orig_ref_inv_no       := '';
            v_pol_invoice.orig_prem_seq_no      := '';
            v_pol_invoice.orig_other_charges    := '';
            v_pol_invoice.orig_currency_desc    := '';
         
        END;
        
        
        IF i.iss_cd = GIACP.V('RI_ISS_CD') THEN
        
            v_pol_invoice.prem_coll_mode      :=    'INWFACUL';
            
        ELSE 
            v_pol_invoice.prem_coll_mode      :=    'DIRECT';
        END IF;
        
        PIPE ROW (v_pol_invoice);
        
     END LOOP;
     
  END get_pol_invoice;                      --moses3252011
  
  /*
  **    Created by:     D.alcantara
  **    Date Created:   04/13/2011
  **    Used in:        GIACS333 (DCB No. Maintenance)
  **    Description:    deletes records in giac_colln_batch
  */
  FUNCTION get_invoice_taxes (
    --p_policy_id     GIPI_INVOICE.policy_id%TYPE,
    p_prem_seq_no   GIPI_INVOICE.prem_seq_no%TYPE,
    p_iss_cd        GIPI_POLBASIC.iss_cd%TYPE
   -- p_item_no       GIPI_WITEM.item_no%TYPE,
    --p_peril_cd      GIIS_PERIL.peril_cd%TYPE
  ) RETURN gipi_invoice_taxes_tab PIPELINED
  IS
    v_taxes     gipi_invoice_taxes_type;
  BEGIN
    FOR i IN ( SELECT b140.iss_cd, b140.prem_seq_no, b140.policy_id, A230.TAX_DESC TAX_DESC, B330.tax_amt, b330.tax_cd
                FROM GIPI_INVOICE B140
                    ,GIPI_INV_TAX B330
                    ,GIIS_TAX_CHARGES A230
                             WHERE B140.PREM_SEQ_NO = B330.PREM_SEQ_NO
                 AND B140.ISS_CD  = B330.ISS_CD
                 AND B330.ISS_CD  = A230.ISS_CD
                 AND B330.LINE_CD = A230.LINE_CD
                 AND B330.TAX_CD  = A230.TAX_CD
                 AND B330.TAX_ID  = A230.TAX_ID
                 AND B140.prem_seq_no = p_prem_seq_no
                 AND B140.iss_cd = p_iss_cd
                 /*AND B330.TAX_CD NOT IN (SELECT PARAM_VALUE_N
                                                                   FROM GIIS_PARAMETERS
                                                                WHERE PARAM_NAME LIKE 'EVAT'
                                                                      AND PARAM_TYPE = 'N')*/
    )  LOOP
        v_taxes.tax_cd          :=  i.tax_cd;
        v_taxes.iss_cd          :=  i.iss_cd;
        v_taxes.prem_seq_no     :=  i.prem_seq_no;
        v_taxes.tax_desc        :=  i.tax_desc;
        v_taxes.tax_amt         :=  i.tax_amt;
        PIPE ROW(v_taxes);
    END LOOP;
  END get_invoice_taxes; 
/**
* Rey Jadlocon
* 07.29.2011
* bill premium main query
*
*
* nieko 07252016 SR 5463, KB 2990, added NVL for tax amounts, ri_comm_vat, ri_comm_amt
*/
    FUNCTION get_bill_premium_main(
        p_policy_id    GIPI_INVOICE.POLICY_ID%TYPE
    )
      RETURN bill_premium_tab PIPELINED 
    IS 
        v_bill_premium  bill_premium_type;
        v_tax_sum       gipi_inv_tax.tax_amt%TYPE;
        v_grp_prem_amt  gipi_item.ann_prem_amt%TYPE;
    BEGIN 
          FOR I IN(SELECT DISTINCT *
                     FROM (SELECT a.policy_id, a.prem_seq_no, a.item_grp, a.insured,
                                a.property, a.payt_terms, a.due_date, 
                                TO_CHAR (a.due_date, 'MM-dd-rrrr') str_due_date,
                                a.currency_rt, a.policy_currency, a.remarks, a.ref_inv_no,
                                a.other_charges, a.ri_comm_vat, a.ri_comm_amt,
                                a.multi_booking_yy, a.multi_booking_mm,
                                a.acct_ent_date, a.user_id, a.last_upd_date,
                                (a.prem_amt + NVL(a.tax_amt, 0) - NVL(a.ri_comm_vat, 0) - NVL(a.ri_comm_amt, 0)) amount_due,c.iss_cd,
                                   c.iss_cd
                                || ' -'
                                || TO_CHAR (a.prem_seq_no, '00000009') bill_no,
                                a.multi_booking_mm || ' - ' || a.multi_booking_yy multi_booking_dt,
                                NVL(GET_TAX_SUM(p_policy_id), 0) tax_sum,i.currency_desc,h.ann_prem_amt,h.ann_tsi_amt,
                                h.tsi_amt, h.prem_amt, c.line_cd,
                                h.item_no, h.item_title               
                           FROM gipi_invoice a,
                                gipi_polbasic c,
                                gipi_inv_tax d,
                                giis_tax_charges f,
                                gipi_invperil g,
                                gipi_item h,
                                giis_currency i
                          WHERE a.policy_id = c.policy_id
                            AND a.prem_seq_no = g.prem_seq_no
                            AND a.prem_seq_no = d.prem_seq_no(+)
                            AND a.iss_cd = g.iss_cd
                            AND a.iss_cd = d.iss_cd(+)
                            AND d.tax_cd = f.tax_cd(+)
                            AND d.iss_cd = f.iss_cd(+)
                            AND h.currency_cd = i.main_currency_cd
                            AND d.line_cd = f.line_cd(+)
                            AND d.tax_id = f.tax_id(+)
                            AND h.policy_id = a.policy_id
                            AND h.item_grp = a.item_grp
                            AND a.policy_id = p_policy_id
                          UNION --added to show bill details in policy inquiry for tax endorsement -- by :Ma'am grace
                         SELECT a.policy_id, a.prem_seq_no, a.item_grp, a.insured, 
                               a.property, a.payt_terms, a.due_date, 
                               TO_CHAR (a.due_date, 'MM-dd-rrrr') str_due_date, 
                               a.currency_rt, a.policy_currency, a.remarks, a.ref_inv_no, 
                               a.other_charges, a.ri_comm_vat, a.ri_comm_amt, 
                               a.multi_booking_yy, a.multi_booking_mm, 
                               a.acct_ent_date, a.user_id, a.last_upd_date,
                               (a.prem_amt + NVL(a.tax_amt, 0) - NVL(a.ri_comm_vat, 0) - NVL(a.ri_comm_amt, 0)) amount_due, c.iss_cd, 
                                 c.iss_cd 
                               || ' -' 
                               || TO_CHAR (a.prem_seq_no, '00000009') bill_no,
                               a.multi_booking_mm || ' - ' || a.multi_booking_yy multi_booking_dt, 
                               NVL(get_tax_sum (p_policy_id), 0) tax_sum, i.currency_desc, c.ann_prem_amt, c.ann_tsi_amt, 
                               c.tsi_amt, c.prem_amt, c.line_cd, 
                               NULL, NULL
                         FROM gipi_invoice a, gipi_polbasic c, gipi_inv_tax d, giis_tax_charges f, giis_currency i, gipi_endttext j
                        WHERE a.policy_id = c.policy_id
                          AND a.prem_seq_no = d.prem_seq_no(+)
                          AND a.iss_cd = d.iss_cd(+)
                          AND d.iss_cd = f.iss_cd(+)
                          AND a.currency_cd = i.main_currency_cd
                          AND d.line_cd = f.line_cd
                          AND d.tax_id = f.tax_id(+)
                          AND c.policy_id = j.policy_id
                          AND NVL (j.endt_tax, 'N') = 'Y'
                          AND a.policy_id = p_policy_id)
                    ORDER BY item_grp, item_no)
        LOOP
            BEGIN
                SELECT SUM(a.tax_amt) 
                  INTO v_tax_sum
                  FROM gipi_inv_tax a, gipi_invoice b  
                 WHERE a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND b.policy_id = p_policy_id
                   AND a.item_grp = i.item_grp;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_tax_sum := 0;
            END; -- marco - 09.06.2012
            
            BEGIN
                SELECT SUM(prem_amt)--SUM(ann_prem_amt) replaced by: Nica 09.28.2012
                  INTO v_grp_prem_amt
                  FROM gipi_item
                 WHERE policy_id = p_policy_id
                   AND item_grp = i.item_grp;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    v_grp_prem_amt := 0;
            END; -- marco - 09.06.2012
                   
            v_bill_premium.policy_id        := i.policy_id;
            v_bill_premium.prem_seq_no      := i.prem_seq_no;
            v_bill_premium.item_grp         := i.item_grp;
            v_bill_premium.insured          := i.insured;
            v_bill_premium.property         := i.property;
            v_bill_premium.payt_terms       := i.payt_terms;
            v_bill_premium.due_date         := i.due_date;
            v_bill_premium.str_due_date     := i.str_due_date; -- added by: Angelo 04.22.2014
            v_bill_premium.currency_rt      := i.currency_rt;
            v_bill_premium.policy_currency   := i.policy_currency;
            v_bill_premium.remarks          := i.remarks;
            v_bill_premium.ref_inv_no       := i.ref_inv_no;
            v_bill_premium.other_charges    := i.other_charges;
            v_bill_premium.ri_comm_vat      := i.ri_comm_vat;
            v_bill_premium.ri_comm_amt      := i.ri_comm_amt;
            v_bill_premium.multi_booking_yy := i.multi_booking_yy;
            v_bill_premium.multi_booking_mm := i.multi_booking_mm;
            v_bill_premium.acct_ent_date    := i.acct_ent_date;
            v_bill_premium.user_id          := i.user_id;
            v_bill_premium.last_upd_date    := i.last_upd_date;
            v_bill_premium.iss_cd           := i.iss_cd;
            v_bill_premium.amount_due       := i.amount_due;
            v_bill_premium.bill_no          := i.bill_no;
            v_bill_premium.multi_booking_dt := i.multi_booking_dt;
            v_bill_premium.tax_sum          := v_tax_sum;
            v_bill_premium.currency_desc    := i.currency_desc;
            v_bill_premium.ann_prem_amt     := i.ann_prem_amt;
            v_bill_premium.ann_tsi_amt      := i.ann_tsi_amt;
            v_bill_premium.tsi_amt          := i.tsi_amt;
            v_bill_premium.item_prem_amt    := i.prem_amt; -- added by: Nica 05.15.2013
            v_bill_premium.line_cd          := i.line_cd;
            v_bill_premium.item_no          := i.item_no;
            v_bill_premium.item_title       := i.item_title;
            v_bill_premium.grp_prem_amt     := v_grp_prem_amt;
            PIPE ROW(v_bill_premium);
        END LOOP
        
        RETURN;
 END get_bill_premium_main;
 /**
 * Rey Jadlocon
 * 08.01.2011
 * return the bill tax list
 **/
     FUNCTION get_bill_tax_list(
        p_policy_id   GIPI_INVOICE.policy_id%TYPE,
        p_item_no      GIPI_ITEM.item_no%TYPE,
        p_item_grp    GIPI_INVOICE.item_grp%TYPE
    )
      RETURN bill_tax_tab PIPELINED
    IS
        v_bill_tax bill_tax_type;        
    BEGIN
        FOR i IN(SELECT TO_CHAR(a.tax_cd,'09') tax_cd, a.tax_id, b.tax_desc, a.tax_amt, c.prem_seq_no,
                        GET_TAX_SUM(p_policy_id) tax_sum
                   FROM gipi_inv_tax a, giis_tax_charges b, gipi_invoice c, gipi_item d
                  WHERE a.iss_cd = b.iss_cd
                    AND a.line_cd = b.line_cd
                    AND a.tax_cd = b.tax_cd
                    AND a.tax_id = b.tax_id
                    AND a.iss_cd = c.iss_cd
                    AND a.prem_seq_no = c.prem_seq_no
                    AND c.policy_id = d.policy_id
                    AND c.item_grp = d.item_grp
                    AND c.policy_id = p_policy_id
                    AND d.item_grp = p_item_grp -- marco - 09.06.2012 - to limit query
                    AND d.item_no = p_item_no)
        LOOP
            BEGIN
                SELECT SUM(a.tax_amt)
                  INTO v_bill_tax.tax_sum
                  FROM GIPI_INV_TAX a, GIPI_INVOICE b, GIPI_ITEM c
                 WHERE a.iss_cd = b.iss_cd
                   AND a.prem_seq_no = b.prem_seq_no
                   AND b.policy_id = c.policy_id
                    AND b.item_grp = c.item_grp
                   AND b.policy_id = p_policy_id
                   AND b.item_grp = p_item_grp
                   AND c.item_no = p_item_no;
            END; -- marco - 09.06.2012
            
            v_bill_tax.tax_cd      := i.tax_cd;
               v_bill_tax.tax_id      := i.tax_id;
               v_bill_tax.tax_amt     := i.tax_amt;
               v_bill_tax.tax_desc    := i.tax_desc;
               v_bill_tax.prem_seq_no := i.prem_seq_no;
               --v_bill_tax.tax_sum     := i.tax_sum;
               PIPE ROW(v_bill_tax);
        END LOOP;
        
        --added by gab 06.14.2016 SR 22310
        IF p_item_no = 0 THEN
        
            FOR i IN(SELECT TO_CHAR(a.tax_cd,'09') tax_cd, a.tax_id, b.tax_desc, a.tax_amt, c.prem_seq_no
                   FROM gipi_inv_tax a, giis_tax_charges b, gipi_invoice c
                  WHERE a.iss_cd = b.iss_cd
                    AND a.line_cd = b.line_cd
                    AND a.tax_cd = b.tax_cd
                    AND a.tax_id = b.tax_id
                    AND a.iss_cd = c.iss_cd
                    AND a.prem_seq_no = c.prem_seq_no
                    AND c.policy_id = p_policy_id
                    AND c.item_grp = p_item_grp)
              LOOP
                  BEGIN
                      SELECT SUM(a.tax_amt)
                        INTO v_bill_tax.tax_sum
                        FROM GIPI_INV_TAX a, GIPI_INVOICE b
                       WHERE a.iss_cd = b.iss_cd
                         AND a.prem_seq_no = b.prem_seq_no
                         AND b.policy_id = p_policy_id
                         AND b.item_grp = p_item_grp;
                  END;
                  
                     v_bill_tax.tax_cd      := i.tax_cd;
                     v_bill_tax.tax_id      := i.tax_id;
                     v_bill_tax.tax_amt     := i.tax_amt;
                     v_bill_tax.tax_desc    := i.tax_desc;
                     v_bill_tax.prem_seq_no := i.prem_seq_no;
                     PIPE ROW(v_bill_tax);
              END LOOP;
        
        
        END IF;          
        RETURN;
    END get_bill_tax_list;
    /*
    **    Created by:     emman
    **    Date Created:   08/08/2011
    **    Used in:        GIUWS012 (Distribution by Peril)
    **    Description:    gets monthly booking year and monthly booking date
    */
    FUNCTION get_multi_booking_dt_by_policy  (p_policy_id   GIPI_POLBASIC_POL_DIST_V1.policy_id%TYPE,
                                              p_dist_no     GIPI_POLBASIC_POL_DIST_V1.dist_no%TYPE)
      RETURN VARCHAR2
    IS
      v_multi_booking_date      VARCHAR2(30);
    BEGIN
      FOR x IN (SELECT multi_booking_mm, multi_booking_yy
                  FROM GIPI_INVOICE
                 WHERE takeup_seq_no = (SELECT NVL(takeup_seq_no,1)
                                          FROM giuw_pol_dist
                                         WHERE dist_no = p_dist_no
                                           AND policy_id = p_policy_id)
                   AND item_grp = (SELECT NVL(item_grp,1)
                                     FROM giuw_pol_dist
                                    WHERE dist_no = p_dist_no
                                      AND policy_id = p_policy_id)
                             AND policy_id = p_policy_id)
      LOOP
        v_multi_booking_date := x.multi_booking_mm || ' - ' || x.multi_booking_yy;
      END LOOP;
      
      RETURN v_multi_booking_date;
    END get_multi_booking_dt_by_policy;
    
    /*
    **    Created by:     Robert Virrey
    **    Date Created:   09/28/2011
    **    Used in:        GIEXS004 (TAG EXPIRED POLICIES FOR RENEWAL)
    **    Description:    populate_basic_details program unit
    */
    FUNCTION populate_basic_details(
        p_pack_policy_id  gipi_polbasic.pack_policy_id%TYPE,
        p_policy_id       gipi_polbasic.policy_id%TYPE
    )
    RETURN gipi_invoice_tab1 PIPELINED
    IS
        v_tab           gipi_invoice_type1;
        v_line_cd       gipi_polbasic.line_cd%TYPE;
        v_subline_cd    gipi_polbasic.subline_cd%TYPE;
        v_iss_cd        gipi_polbasic.iss_cd%TYPE;
        v_issue_yy      gipi_polbasic.issue_yy%TYPE;
        v_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE;
        v_renew_no      gipi_polbasic.renew_no%TYPE;
    BEGIN
    
        IF p_pack_policy_id > 0 THEN
             FOR cur IN (SELECT line_cd, subline_cd, iss_cd, 
                                issue_yy, pol_seq_no, renew_no
                           FROM gipi_polbasic
                          WHERE pack_policy_id = p_pack_policy_id)
             LOOP
                v_line_cd     := cur.line_cd;
                v_subline_cd  := cur.subline_cd;
                v_iss_cd      := cur.iss_cd;
                v_issue_yy    := cur.issue_yy;
                v_pol_seq_no  := cur.pol_seq_no;
                v_renew_no    := cur.renew_no;
                EXIT;
             END LOOP;
        ELSE
             FOR cur IN (SELECT line_cd, subline_cd, iss_cd, 
                                issue_yy, pol_seq_no, renew_no
                           FROM gipi_polbasic
                          WHERE policy_id = p_policy_id)
             LOOP
                v_line_cd     := cur.line_cd;
                v_subline_cd  := cur.subline_cd;
                v_iss_cd      := cur.iss_cd;
                v_issue_yy    := cur.issue_yy;
                v_pol_seq_no  := cur.pol_seq_no;
                v_renew_no    := cur.renew_no;
                EXIT;
             END LOOP;
        END IF;
    
        FOR P IN(SELECT policy_id
                   FROM gipi_polbasic
                  WHERE line_cd    = v_line_cd
                    AND subline_cd = v_subline_cd
                    AND iss_cd     = v_iss_cd
                    AND issue_yy   = v_issue_yy
                    AND pol_seq_no = v_pol_seq_no
                    AND renew_no   = v_renew_no
                    AND pol_flag IN ('1','2','3')
               ORDER BY eff_date)
        LOOP
          FOR I IN (SELECT a.iss_cd|| ' - '||TO_CHAR (a.prem_seq_no, '099999999999') invoice_no, 
                           a.due_date, SUM(b.balance_amt_due) balance_due
                      FROM gipi_invoice a, giac_aging_soa_details b
                     WHERE a.policy_id = p.policy_id
                       AND a.iss_cd = b.iss_cd
                       AND a.prem_seq_no = b.prem_seq_no
                  GROUP BY a.iss_cd, a.prem_seq_no, a.due_date)
          LOOP
            v_tab.invoice_no    := i.invoice_no;
            v_tab.balance_due   := i.balance_due;
            v_tab.due_date      := i.due_date;   
            PIPE ROW(v_tab); 
          END LOOP;
        END LOOP;
        
    END populate_basic_details;
/**
* Rey Jadlocon
* 10-11-2011
**/
FUNCTION get_bond_bill_details(p_policy_id          gipi_invoice.policy_id%TYPE)
            RETURN bond_bill_details_tab PIPELINED
          IS 
                v_bond_details bond_bill_details_type;
                
          BEGIN
           --START hdrtagudin 07222015 SR 19824  
                FOR i IN(SELECT DISTINCT NVL(a.bond_tsi_amt,0) bond_tsi_amt,a.bond_rate,NVL(a.tax_amt,0) tax_amt,a.payt_terms,NVL(a.notarial_fee,0) notarial_fee,a.iss_cd,c.ri_comm_rate,NVL(a.ri_comm_amt,0) ri_comm_amt, a.ri_comm_vat,
                                a.prem_seq_no,a.ref_inv_no,a.prem_amt,a.remarks,
                               CASE (a.iss_cd)
                                WHEN GIISP.V('ISS_CD_RI') THEN
                                    NVL(a.prem_amt,0)+NVL(a.tax_amt,0)-NVL(a.ri_comm_amt,0)-NVL(a.ri_comm_vat,0)
                                ELSE
                                    NVL(a.prem_amt,0)+NVL(a.tax_amt,0)-- +a.notarial_fee --removed as ma'am jhing's advice 
                                END   
                                    total_amt_due
                           FROM gipi_invoice a, gipi_itmperil c
                          WHERE a.policy_id = c.policy_id (+) --modified hdrtagudin 07302015 SR 19824, removed gipi_inv_tax
                            AND a.policy_id = p_policy_id
                          GROUP BY a.bond_tsi_amt,a.bond_rate,a.tax_amt,a.payt_terms,a.notarial_fee,a.iss_cd,c.ri_comm_rate,
                                a.prem_seq_no,a.ref_inv_no,a.prem_amt,a.remarks, a.ri_comm_amt, a.ri_comm_vat
                          ORDER BY 1 ASC )
                     --END hdrtagudin 07222015 SR 19824
                LOOP
                        v_bond_details.bond_tsi_amt             := i.bond_tsi_amt;
                        v_bond_details.bond_rate                := i.bond_rate;
                        v_bond_details.tax_amt                  := i.tax_amt;
                        v_bond_details.payt_terms               := i.payt_terms;
                        v_bond_details.notarial_fee             := i.notarial_fee;
                        v_bond_details.iss_cd                   := i.iss_cd;
                        v_bond_details.prem_seq_no              := i.prem_seq_no;
                        v_bond_details.ref_inv_no               := i.ref_inv_no;
                        v_bond_details.prem_amt                 := i.prem_amt;
                        v_bond_details.total_amt_due            := i.total_amt_due;
                        v_bond_details.remarks                  := i.remarks;
                        v_bond_details.ri_comm_rate             := i.ri_comm_rate;
                        --added by hdrtagudin 07222015 SR 19824
                        v_bond_details.ri_comm_amt             := i.ri_comm_amt;
                        v_bond_details.ri_comm_vat             := i.ri_comm_vat;

                        
                    PIPE ROW(v_bond_details);
                        
                END LOOP;
            
          END;
/**
* Rey Jadlocon
* 10-11-2011
**/
FUNCTION get_bond_bill_tax_list(p_policy_id         gipi_invoice.policy_id%TYPE)
            RETURN bond_bill_tax_list_tab PIPELINED
          IS
                v_bond_bill_tax_list     bond_bill_tax_list_type;
          BEGIN
                FOR i IN(SELECT DISTINCT b.tax_cd,c.tax_desc,b.tax_amt
                           FROM gipi_invoice a, gipi_inv_tax b, giis_tax_charges c
                          WHERE a.iss_cd = b.iss_cd
                            AND a.prem_seq_no = b.prem_seq_no
                            AND a.policy_id = p_policy_id
                            AND b.iss_cd = c.iss_cd
                            AND b.line_cd = c.line_cd
                            AND b.tax_cd = c.tax_cd
                            AND b.tax_id = c.tax_id 
                          ORDER BY 1 ASC)
                 LOOP
                        v_bond_bill_tax_list.tax_cd             := i.tax_cd;
                        v_bond_bill_tax_list.tax_desc           := i.tax_desc;
                        v_bond_bill_tax_list.tax_amt            := i.tax_amt;
                        PIPE ROW(v_bond_bill_tax_list);
                 END LOOP;
          END;

/* Created by: Christian
** Date Created: 4/25/2013 
*/
    FUNCTION get_giacs408_bill_no(
      p_iss_cd      gipi_invoice.iss_cd%TYPE, 
      p_user_id giis_users.user_id%TYPE)
    RETURN giacs408_bill_no_list_tab PIPELINED
    IS
         v_bill_no_list   giacs408_bill_no_list_type;
         v_param_value_v  giac_parameters.param_value_v%TYPE;
    BEGIN
        BEGIN
           SELECT param_value_v
             INTO v_param_value_v
             FROM giac_parameters
            WHERE param_name LIKE ('RI_ISS_CD');
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_param_value_v := NULL;
        END;
    
        FOR i IN(SELECT b140.iss_cd, b140.prem_seq_no, b140.policy_id, b140.prem_amt 
                   FROM gipi_invoice b140 
                  WHERE b140.iss_cd != v_param_value_v --added by steven 10.16.2014
                    --AND b140.iss_cd = DECODE(check_user_per_iss_cd_acctg2(null,b140.iss_cd,'GIACS408', p_user_id),1,b140.iss_cd,NULL)
                    AND (   EXISTS ( --added by steven 10.15.2014; to replace check_user_per_iss_cd_acctg2
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_iss_cd b2,
                                 giis_modules_tran c,
                                 giis_user_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b140.iss_cd
                             AND c.module_id = 'GIACS408'
                             AND a.user_id = b2.userid
                             AND d.userid = a.user_id
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                    OR EXISTS (
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_grp_dtl b2,
                                 giis_modules_tran c,
                                 giis_user_grp_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b140.iss_cd
                             AND c.module_id = 'GIACS408'
                             AND a.user_grp = b2.user_grp
                             AND d.user_grp = a.user_grp
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id))
                    AND NVL(b140.iss_cd, '%') LIKE NVL(p_iss_cd, '%')
                    ORDER BY b140.iss_cd, b140.prem_seq_no)
        LOOP
            v_bill_no_list.iss_cd       := i.iss_cd;
            v_bill_no_list.prem_seq_no  := i.prem_seq_no;
            v_bill_no_list.policy_id    := i.policy_id;
            v_bill_no_list.prem_amt     := i.prem_amt;
            PIPE ROW(v_bill_no_list);
        END LOOP;
    
    END;
    
    --added by steven
    FUNCTION get_giacs408_iss_cd(
      p_iss_cd      gipi_invoice.iss_cd%TYPE, 
      p_user_id giis_users.user_id%TYPE)
    RETURN giacs408_bill_no_list_tab PIPELINED
    IS
         v_bill_no_list   giacs408_bill_no_list_type;
         v_param_value_v  giac_parameters.param_value_v%TYPE;
    BEGIN
        BEGIN
           SELECT param_value_v
             INTO v_param_value_v
             FROM giac_parameters
            WHERE param_name LIKE ('RI_ISS_CD');
        EXCEPTION
           WHEN NO_DATA_FOUND
           THEN
              v_param_value_v := NULL;
        END;
    
        FOR i IN(SELECT distinct b140.iss_cd
                   FROM gipi_invoice b140 
                  WHERE b140.iss_cd != v_param_value_v --added by steven 10.16.2014
                    --AND b140.iss_cd = DECODE(check_user_per_iss_cd_acctg2(null,b140.iss_cd,'GIACS408', p_user_id),1,b140.iss_cd,NULL)
                    AND (   EXISTS ( --added by steven 10.15.2014; to replace check_user_per_iss_cd_acctg2
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_iss_cd b2,
                                 giis_modules_tran c,
                                 giis_user_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b140.iss_cd
                             AND c.module_id = 'GIACS408'
                             AND a.user_id = b2.userid
                             AND d.userid = a.user_id
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                    OR EXISTS (
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_grp_dtl b2,
                                 giis_modules_tran c,
                                 giis_user_grp_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b140.iss_cd
                             AND c.module_id = 'GIACS408'
                             AND a.user_grp = b2.user_grp
                             AND d.user_grp = a.user_grp
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id))
                    AND UPPER(NVL(b140.iss_cd, '%')) LIKE UPPER(NVL(p_iss_cd, '%'))
                    ORDER BY b140.iss_cd)
        LOOP
            v_bill_no_list.iss_cd       := i.iss_cd;
            PIPE ROW(v_bill_no_list);
        END LOOP;
    
    END;
    
    FUNCTION get_gipis156_invoice (
       p_policy_id  VARCHAR2
    )
       RETURN gipis156_invoice_tab PIPELINED
    IS
       v_list gipis156_invoice_type;
    BEGIN
       FOR i IN (SELECT prem_seq_no, policy_id,
                        multi_booking_yy, multi_booking_mm,
                        acct_ent_date, takeup_seq_no, iss_cd,
                        item_grp
                   FROM gipi_invoice
                  WHERE policy_id = p_policy_id)
       LOOP
          v_list.prem_seq_no := i.prem_seq_no;
          v_list.policy_id := i.policy_id;
          v_list.multi_booking_yy := i.multi_booking_yy;
          v_list.multi_booking_mm := i.multi_booking_mm;
          v_list.acct_ent_date := i.acct_ent_date;
          v_list.takeup_seq_no := i.takeup_seq_no;
          v_list.iss_cd := i.iss_cd;
          v_list.item_grp := i.item_grp;
          
          PIPE ROW(v_list);
       END LOOP;
    END get_gipis156_invoice; 
    
        
    
    /* Created by: Marie Kris Felipe
    ** Date Created: 9.09.2013
    ** Desciption: Retrieves list of invoices
    ** Reference: (GIPIS137 - View Invoice Information) 
    */
    FUNCTION get_invoice_list(
        p_user_id       giis_users.user_id%TYPE
    ) RETURN invoice_dtl_tab PIPELINED
    IS
        v_invoice           invoice_dtl_type;
    BEGIN
    
        FOR rec IN (SELECT a.cred_branch, 
                           a.line_cd, a.subline_Cd, a.iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                           a.endt_iss_cd, a.endt_yy, a.endt_Seq_no, a.par_id, a.assd_no,
                           b.policy_id,
                           b.prem_amt, b.tax_amt, b.other_charges, b.prem_seq_no, b.item_grp,
                           b.currency_cd, b.currency_rt, property, payt_terms, remarks
                      FROM gipi_polbasic a, gipi_invoice b
                     WHERE a.policy_id = b.policy_id
                             /* jhing 11.27.2012 added condition for checking of access rights */
                       AND (   check_user_per_iss_cd2 (a.line_cd, b.iss_cd, 'GIPIS137', p_user_id) = 1
                            OR check_user_per_iss_cd2 (a.line_cd, a.cred_branch, 'GIPIS137', p_user_id) = 1)
                     )
        LOOP
        
            v_invoice.line_cd := rec.line_cd;
            v_invoice.subline_Cd := rec.subline_Cd;
            v_invoice.iss_cd := rec.iss_cd;
            v_invoice.prem_seq_no := rec.prem_seq_no;
            v_invoice.item_grp := rec.item_grp;
            v_invoice.cred_branch := rec.cred_branch;
            v_invoice.currency_rate := rec.currency_rt;
            v_invoice.currency_cd := rec.currency_cd;
            v_invoice.prem_amt := rec.prem_amt;
            v_invoice.tax_amt := rec.tax_amt;
            v_invoice.property := rec.property;
            v_invoice.payt_terms := rec.payt_terms;
            v_invoice.remarks := rec.remarks;
            
            v_invoice.total_amt_due := NVL(rec.PREM_AMT,0) + NVL(rec.TAX_AMT,0) + NVL(rec.OTHER_CHARGES,0);
            
            v_invoice.policy_no := rec.line_cd || ' - ' || rec.subline_cd || ' - '|| rec.iss_cd || ' - ' || LTRIM(TO_CHAR(rec.issue_yy, '09')) || ' - ' ||
                                    LTRIM(TO_CHAR(rec.pol_seq_no, '0999999')) || ' - ' || LTRIM(TO_CHAR(rec.renew_no, '09'));
            
            v_invoice.invoice_no := rec.iss_Cd || ' - ' || LTRIM(TO_CHAR(rec.prem_seq_no, '099999999999')) || ' - ' || LTRIM(TO_CHAR(rec.item_grp, '09999'));
            
            IF rec.endt_seq_no <> 0 THEN                       
                v_invoice.endt_no   := rec.endt_iss_cd || ' - ' || LTRIM(TO_CHAR(rec.endt_yy, '09')) || ' - ' || LTRIM(TO_CHAR(rec.endt_seq_no, '0999999'));
            END IF;
            
            IF NVL(rec.other_charges,0) = 0 THEN
                v_invoice.other_charges := 0;
            ELSE
                v_invoice.other_charges := rec.other_charges;
            END IF;
  
            FOR a IN (SELECT ASSD_NAME
                        FROM GIIS_ASSURED
                       WHERE ASSD_NO IN (SELECT ASSD_NO
                                           FROM GIPI_PARLIST
                                          WHERE PAR_ID = rec.PAR_ID))
            LOOP
                v_invoice.assd_name := a.assd_name;
            END LOOP;
            
            FOR a IN (SELECT currency_desc
                        FROM giis_currency
                       WHERE main_currency_cd = rec.currency_cd)
            LOOP
                v_invoice.currency_desc := a.currency_desc;
            END LOOP;
            
            FOR i IN (SELECT payt_terms_desc
                        FROM giis_payterm
                       WHERE payt_terms = rec.payt_terms)
            LOOP
                v_invoice.payt_terms_desc := i.payt_terms_desc;
            END LOOP;
            
            PIPE ROW(v_invoice);
        END LOOP;
        
    END get_invoice_list; 
    
END GIPI_INVOICE_PKG;
/


