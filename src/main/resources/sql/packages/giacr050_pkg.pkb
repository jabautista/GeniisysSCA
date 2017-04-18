CREATE OR REPLACE PACKAGE BODY CPI.giacr050_pkg
AS
   FUNCTION get_or_details (
      p_or_pref   VARCHAR2,
      p_or_no     VARCHAR2,
      p_tran_id   giac_or_stat_hist.gacc_tran_id%TYPE
   )
      RETURN or_details_tab PIPELINED
   IS
      v_giac_or           or_details_type;
      v_vat_sale          NUMBER;
      v_vat_exempt_sale   NUMBER;
      v_vat_zero_sale     NUMBER;
   BEGIN
      FOR i IN (SELECT gacc_tran_id, gibr_gfun_fund_cd, gibr_branch_cd,
                       payor, or_date,
                       DECODE (gross_tag,
                               'Y', gross_amt,
                               collection_amt
                              ) op_collection_amt,
                       NVL (currency_cd, 1) currency_cd, gross_tag, intm_no,
                       prov_receipt_no,
                       DECODE (or_no,
                               NULL, p_or_pref
                                || '-'
                                || LTRIM (TO_CHAR (p_or_no, '0999999999')),
                                  or_pref_suf
                               || '-'
                               || LTRIM (TO_CHAR (or_no, '0999999999'))
                              ) or_no,
                       cashier_cd, particulars, dcb_no,
                       address_1 || ' ' || address_2 || ' '
                       || address_3 address,
                       with_pdc, SYSDATE, tin, gc.short_name
                  FROM giac_order_of_payts, giis_currency gc
                 WHERE gacc_tran_id = NVL (p_tran_id, gacc_tran_id)
                   AND currency_cd = gc.main_currency_cd)
      LOOP
         v_giac_or.gacc_tran_id         := i.gacc_tran_id;
         v_giac_or.gibr_gfun_fund_cd    := i.gibr_gfun_fund_cd;
         v_giac_or.gibr_branch_cd       := i.gibr_branch_cd;
         v_giac_or.payor                := i.payor;
         v_giac_or.or_date              := TO_CHAR (i.or_date, 'MM/DD/RRRR');
         v_giac_or.op_collection_amt    := i.op_collection_amt;
         v_giac_or.currency_cd          := i.currency_cd;
         v_giac_or.gross_tag            := i.gross_tag;
         v_giac_or.intm_no              := i.intm_no;
         v_giac_or.prov_receipt_no      := i.prov_receipt_no;
         v_giac_or.or_no                := i.or_no;
         v_giac_or.cashier_cd           := i.cashier_cd;
         v_giac_or.particulars          := i.particulars;
         v_giac_or.dcb_no               := i.dcb_no;
         v_giac_or.address              := i.address;
         v_giac_or.with_pdc             := i.with_pdc;
         v_giac_or.tin                  := i.tin;
         v_giac_or.short_name           := i.short_name;
         v_giac_or.bir_permit_no        := giisp.v ('BIR_PERMIT_NO');

         BEGIN
            SELECT branch_tin_cd
              INTO v_giac_or.branch_tin_cd
              FROM giis_issource
             WHERE iss_cd = i.gibr_branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.branch_tin_cd := NULL;
         END;

         BEGIN
            SELECT remarks
              INTO v_giac_or.branch_remarks
              FROM giis_issource
             WHERE iss_cd = i.gibr_branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.branch_remarks := NULL;
         END;

         BEGIN
            SELECT address1 || ' ' || address2 || ' ' || address3
              INTO v_giac_or.branch_add
              FROM giis_issource
             WHERE iss_cd = i.gibr_branch_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.branch_add := NULL;
         END;

         BEGIN
            SELECT print_name
              INTO v_giac_or.cashier_name
              FROM giac_dcb_users
             WHERE gibr_fund_cd = i.gibr_gfun_fund_cd
               AND gibr_branch_cd = i.gibr_branch_cd
               AND cashier_cd = i.cashier_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.cashier_name := NULL;
         END;

         BEGIN
            FOR rec IN (SELECT a.currency_rt, b.short_name
                          FROM giac_collection_dtl a, giis_currency b
                         WHERE gacc_tran_id = p_tran_id
                           AND main_currency_cd = NVL (a.currency_cd, 1))
            LOOP
               v_giac_or.cf_gcd_curr_rt := rec.currency_rt;
               v_giac_or.cp_gcd_curr_sname := rec.short_name;
               EXIT;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.cf_gcd_curr_rt := NULL;
               v_giac_or.cp_gcd_curr_sname := NULL;
         END;

         BEGIN
            FOR a IN (SELECT SUM (  premium_amt
                                  / NVL (v_giac_or.cf_gcd_curr_rt, 1)
                                 ) premium
                        FROM giac_direct_prem_collns
                       WHERE gacc_tran_id = p_tran_id)
            LOOP
               IF a.premium IS NOT NULL
               THEN
                  v_giac_or.prem_title := 'Premium';
               ELSE
                  v_giac_or.prem_title := 'X';
               END IF;
            END LOOP;

            FOR a IN (SELECT SUM (  premium_amt
                                  / NVL (v_giac_or.cf_gcd_curr_rt, 1)
                                 ) premium
                        FROM giac_inwfacul_prem_collns
                       WHERE gacc_tran_id = p_tran_id)
            LOOP
               IF a.premium IS NOT NULL
               THEN
                  v_giac_or.prem_title := 'RI Premium';
               END IF;
            END LOOP;

            FOR t IN (SELECT '1' exist
                        FROM giac_op_text
                       WHERE gacc_tran_id = p_tran_id
                         AND (   item_text LIKE UPPER ('%RI COMMISSION%')
                              OR item_text LIKE UPPER ('%RI COMM%VAT%')
                             ))
            LOOP
               IF t.exist IS NOT NULL
               THEN
                  v_giac_or.prem_title := 'Binder RI Comm';
               END IF;
            END LOOP;
         END;

         v_giac_or.cf_giot_prem_amt     := cf_giot_prem (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cp_ri_comm_amt       := cf_giot_ri_comm (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cp_ri_comm_vat       := cf_giot_vat_comm (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cp_doc_stamps        := cf_giot_doc (p_tran_id, v_giac_or.currency_cd);

         BEGIN
            SELECT   SUM (a.tax_amt) / v_giac_or.cf_gcd_curr_rt
                                                               tax_amt_collns
                INTO v_giac_or.cf_vat
                FROM giac_tax_collns a, giac_taxes b
               WHERE a.fund_cd = b.fund_cd
                 AND a.b160_tax_cd = b.tax_cd
                 AND a.gacc_tran_id = p_tran_id
                 AND a.b160_tax_cd = giacp.n ('EVAT')
            GROUP BY a.gacc_tran_id, a.b160_tax_cd, b.tax_name;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.cf_vat := NULL;
         END;

         BEGIN
            SELECT   SUM (tax_amount / convert_rate) prem_vat
                INTO v_giac_or.cf_vat_exempt
                FROM giac_inwfacul_prem_collns
               WHERE gacc_tran_id = p_tran_id
            GROUP BY gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.cf_vat_exempt := NULL;
         END;

         BEGIN
            SELECT SUM (DECODE (NVL (v_giac_or.currency_cd, 1),
                                1, b.item_amt,
                                b.foreign_curr_amt
                               )
                       ) grand_total
              INTO v_giac_or.cs_grand_total
              FROM giac_op_text b
             WHERE b.gacc_tran_id = NVL (p_tran_id, b.gacc_tran_id)
               AND NVL (b.or_print_tag, 'Y') = 'Y';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_giac_or.cs_grand_total := NULL;
         END;

         BEGIN
            v_vat_sale := 0;

            -- for direct premium bill with VAT to included in vat sale --
            FOR a IN
               (SELECT NVL (SUM (  premium_amt
                                 / NVL (v_giac_or.cf_gcd_curr_rt, 1)
                                ),
                            0
                           ) premium
                FROM   giac_direct_prem_collns z
                 WHERE gacc_tran_id = p_tran_id
                   AND EXISTS (
                          SELECT   '1'
                              FROM giac_tax_collns a
                             WHERE a.gacc_tran_id = z.gacc_tran_id
                               AND b160_tax_cd = giacp.n ('EVAT')
                               AND tax_amt <> 0
                               AND b160_iss_cd || '-' || b160_prem_seq_no =
                                      z.b140_iss_cd || '-'
                                      || z.b140_prem_seq_no
                          GROUP BY b160_iss_cd, b160_prem_seq_no, b160_tax_cd))
            LOOP
               v_giac_or.cp_vat_sale := v_vat_sale + a.premium;
            END LOOP;

            -- for RI commissions to be included in vat sale --
            FOR t IN
               (SELECT foreign_curr_amt ri_comm
                  FROM giac_op_text
                 WHERE item_text LIKE UPPER ('%RI COMMISSION%')
                   AND item_text NOT LIKE UPPER ('%RI COMMISSION VAT%')
                   AND gacc_tran_id = p_tran_id)
            LOOP
               v_giac_or.cp_vat_sale := v_vat_sale + t.ri_comm;
            END LOOP;
         END;

         BEGIN
            v_vat_exempt_sale := 0;

            -- for PA direct premium bills to be included in vat-exempt sale --
            FOR a IN
               (SELECT NVL (SUM (  premium_amt
                                 / NVL (v_giac_or.cf_gcd_curr_rt, 1)
                                ),
                            0
                           ) premium
                FROM   giac_direct_prem_collns z
                 WHERE gacc_tran_id = p_tran_id
                   AND NOT EXISTS (
                          SELECT   '1'
                              FROM giac_tax_collns a
                             WHERE a.gacc_tran_id = z.gacc_tran_id
                               AND b160_tax_cd = giacp.n ('EVAT')
                               AND b160_iss_cd || '-' || b160_prem_seq_no =
                                      z.b140_iss_cd || '-'
                                      || z.b140_prem_seq_no
                          GROUP BY b160_iss_cd, b160_prem_seq_no, b160_tax_cd))
            LOOP
               v_giac_or.cp_vat_exempt_sale := v_vat_exempt_sale + a.premium;
            END LOOP;

            -- for RI bills to be included in the vat-exempt sale --
            FOR a IN
               (SELECT NVL (SUM (  premium_amt
                                 / NVL (v_giac_or.cf_gcd_curr_rt, 1)
                                ),
                            0
                           ) premium
                  FROM giac_inwfacul_prem_collns
                 WHERE gacc_tran_id = p_tran_id)
            LOOP
               v_giac_or.cp_vat_exempt_sale := v_vat_exempt_sale + a.premium;
            END LOOP;

            -- for non-insurance (manually entered entries in the OR preview module) to be included in the vat-exempt sale --
            IF v_giac_or.prem_title = 'X'
            THEN
               v_giac_or.cp_vat_exempt_sale := v_giac_or.cs_grand_total;
            END IF;
         END;

         BEGIN
            v_vat_zero_sale := 0;

            -- for direct premium bill with 0 VAT to included in vat zero-rated sale --
            FOR a IN
               (SELECT NVL (SUM (  premium_amt
                                 / NVL (v_giac_or.cf_gcd_curr_rt, 1)
                                ),
                            0
                           ) premium
                  FROM giac_direct_prem_collns z
                 WHERE gacc_tran_id = p_tran_id
                   AND EXISTS (
                          SELECT   '1'
                              FROM giac_tax_collns a
                             WHERE a.gacc_tran_id = z.gacc_tran_id
                               AND b160_tax_cd = giacp.n ('EVAT')
                               AND tax_amt = 0
                               AND b160_iss_cd || '-' || b160_prem_seq_no =
                                      z.b140_iss_cd || '-'
                                      || z.b140_prem_seq_no
                          GROUP BY b160_iss_cd, b160_prem_seq_no, b160_tax_cd))
            LOOP
               v_giac_or.cp_vat_zero_rated_sale :=
                                                  v_vat_zero_sale + a.premium;
            END LOOP;
         END;


         BEGIN
            v_giac_or.cp_payment_forms := NULL;
            
            FOR a IN (SELECT DISTINCT a.pay_mode, b.rv_meaning
                        FROM giac_collection_dtl a, cg_ref_codes b
                       WHERE 1 = 1
                         AND a.gacc_tran_id = p_tran_id
                         AND a.pay_mode = b.rv_low_value
                         AND rv_domain = 'GIAC_COLLECTION_DTL.PAY_MODE')
            LOOP
                IF v_giac_or.cp_payment_forms IS NULL THEN
                    v_giac_or.cp_payment_forms := a.rv_meaning;
                ELSE
                    v_giac_or.cp_payment_forms := v_giac_or.cp_payment_forms || ', ' || a.rv_meaning;
                END IF;
            END LOOP;
         END;
         
         PIPE ROW (v_giac_or);
      END LOOP;

      RETURN;
   END get_or_details;
   
   FUNCTION get_tax_collections (
        P_OR_PREF                 VARCHAR2,
        P_OR_NO                   VARCHAR2,
        P_TRAN_ID                 giac_or_stat_hist.gacc_tran_id%TYPE
   )
      RETURN tax_collections_tab PIPELINED
   IS
      v_detail   tax_collections_type;
   BEGIN
      FOR i IN (SELECT   a.gacc_tran_id, a.b160_tax_cd,
                         SUM (a.tax_amt) / (select cf_gcd_curr_rt from table(giacr050_pkg.get_or_details(p_or_pref, p_or_no, p_tran_id))) tax_amt_collns,
                         INITCAP (b.tax_name) tax_name
                    FROM giac_tax_collns a, giac_taxes b
                   WHERE a.fund_cd = b.fund_cd
                     AND a.b160_tax_cd = b.tax_cd
                     AND a.b160_tax_cd NOT IN
                                      (giacp.n ('DOC_STAMPS'), giacp.n ('EVAT'))
                     AND a.gacc_tran_id = p_tran_id
                GROUP BY a.gacc_tran_id, a.b160_tax_cd, b.tax_name)
      LOOP
         v_detail.tax_name := i.tax_name;
         v_detail.tax_amount_collections := i.tax_amt_collns;
         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_tax_collections;
   
   FUNCTION get_item_details (
      p_or_pref   VARCHAR2,
      p_or_no     VARCHAR2,
      p_tran_id   giac_or_stat_hist.gacc_tran_id%TYPE
   )
      RETURN item_details_tab PIPELINED
   IS
      v_detail   item_details_type;
   BEGIN
      FOR i IN(SELECT b.gacc_tran_id, b.item_seq_no, b.item_text || DECODE(bill_no, null, null, ' / '||bill_no) item_text,
	                  DECODE(NVL((select currency_cd from table(giacr050_pkg.get_or_details(p_or_pref , p_or_no, p_tran_id))),1),1,b.item_amt,b.foreign_curr_amt) item_amt,
       	              b.or_print_tag
                 FROM giac_op_text b
                WHERE b.gacc_tran_id = NVL(p_tran_id, b.gacc_tran_id)
                  AND NVL(b.or_print_tag,'Y') = 'Y'
             ORDER BY b.item_seq_no)
      LOOP
         v_detail.item_text    := i.item_text;
         v_detail.item_amount := i.item_amt;
         PIPE ROW (v_detail);
      END LOOP;

      RETURN;
   END get_item_details;
   
   FUNCTION get_bank_details (
      P_CP_CHECK_TITLE          giac_collection_dtl.check_no%TYPE,
      P_CP_CREDIT_TITLE         giac_collection_dtl.check_no%TYPE,
      P_GROSS_TAG               giac_order_of_payts.gross_tag%TYPE,
      P_CP_SUM                  VARCHAR2,
      P_TRAN_ID                 giac_collection_dtl.gacc_tran_id%TYPE
   )
      RETURN bank_details_tab PIPELINED
   IS
      v_detail      bank_details_type;
   BEGIN
   
      
      FOR i IN(SELECT   gacc_tran_id "gacc_tran_id3", bank_cd,
                 DECODE (pay_mode,
                         'CA', ' ',
                         'CHK', DECODE (p_cp_check_title,
                                        'Y', 'Various Check',
                                        check_no
                                       ),
                         'PDC', DECODE ('N', 'Y', 'Various CHECK', check_no),
                         'CM', DECODE (p_cp_credit_title,
                                       'Y', 'Various C.M.',
                                       'CREDIT MEMO'
                                      ),
                         'CMI', check_no   
                        ) check_no,
                 check_date,
                 DECODE (p_gross_tag,
                         'Y', DECODE (NVL (currency_cd, 1),
                                      1, gross_amt,
                                      fc_gross_amt
                                     ),
                         DECODE (NVL (currency_cd, 1), 1, amount, fcurrency_amt)
                        ) amount2,
                 pay_mode, amount net_amount, commission_amt
            FROM giac_collection_dtl
           WHERE p_cp_sum = 'N' AND gacc_tran_id = NVL (p_tran_id, gacc_tran_id)
        ORDER BY pay_mode)
        
      LOOP
         v_detail.check_no    := i.check_no;
         v_detail.check_date1 := i.check_date;
         v_detail.bank_cd     := i.bank_cd;
         v_detail.cf_bank_sname     := GIAC_BANKS_DETAILS_PKG.cf_bank_snameformula(i.bank_cd, i.pay_mode);

         BEGIN
             SELECT gross_tag
               INTO v_detail.gross_tag
               FROM giac_order_of_payts
              WHERE gacc_tran_id = p_tran_id;
         EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
               v_detail.gross_tag := NULL;
         END;
         
         PIPE ROW (v_detail);
      END LOOP;  
        
      
      RETURN;
   END get_bank_details;
END;
/


