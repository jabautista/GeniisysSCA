CREATE OR REPLACE PACKAGE BODY CPI.giacr050_cpi_pkg
AS
   FUNCTION get_giac_or_rep (                    --Added by Alfred 03/04/2011
      p_or_pref   VARCHAR2,
      p_or_no     VARCHAR2,
      p_tran_id   giac_order_of_payts.gacc_tran_id%TYPE
   )
      RETURN giac_or_tab PIPELINED
   IS
      v_giac_or   giac_or_type;
   BEGIN
      FOR i IN
         (SELECT gop.gacc_tran_id, gop.gibr_gfun_fund_cd, gop.gibr_branch_cd,
                 gop.payor, TO_CHAR (gop.or_date, 'MM-DD-RRRR') or_date,
                 DECODE (gop.gross_tag,
                         'Y', gop.gross_amt,
                         gop.collection_amt
                        ) op_collection_amt,
                 NVL (gop.currency_cd, 1) currency_cd, gop.gross_tag,
                 gop.intm_no, gop.prov_receipt_no,
                 DECODE (gop.or_no,
                         NULL, p_or_pref
                          || '-'
                          || LTRIM (TO_CHAR (p_or_no, '0999999999')),
                            gop.or_pref_suf
                         || '-'
                         || LTRIM (TO_CHAR (gop.or_no, '0999999999'))
                        ) or_no,
                 gop.cashier_cd, gop.particulars, gop.dcb_no,
                    gop.address_1
                 || ' '
                 || gop.address_2
                 || ' '
                 || gop.address_3 address,
                 gop.with_pdc, SYSDATE, gop.tin, gc.short_name,
                 (   a.line_cd
                  || '-'
                  || a.subline_cd
                  || '-'
                  || a.iss_cd
                  || '-'
                  || a.clm_yy
                  || '-'
                  || a.clm_seq_no
                 ) claim_no,
                 a.assured_name,
                    TO_CHAR (a.dsp_loss_date, 'DD/MM/RRRR')
                 || ' (d/m/y)' loss_date,
                 (   c.line_cd
                  || '-'
                  || c.iss_cd
                  || '-'
                  || c.rec_year
                  || '-'
                  || c.rec_seq_no
                 ) recovery_no,
                 or_flag, gop.or_pref_suf,
                   
                   /*(SELECT DISTINCT NVL(d.or_print_tag,'Y')
                      FROM giac_op_text d
                     WHERE d.gacc_tran_id = p_tran_id) or_print_tag,*/ -- bonok :: 10.04.2012
                   (NVL (cf_tot_collns (p_tran_id), 0))
                 - (  (  NVL (cf_giot_prem (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_lgt (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_fst (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_evat (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                       + NVL (cf_giot_prem_tax (p_tran_id,
                                                v_giac_or.currency_cd
                                               ),
                              0
                             )
                       + NVL (cf_giot_doc (p_tran_id, v_giac_or.currency_cd),
                              0
                             )
                      )
                    - (  NVL (cf_giot_ri_comm (p_tran_id,
                                               v_giac_or.currency_cd
                                              ),
                              0
                             )
                       + NVL (cf_giot_vat_comm (p_tran_id,
                                                v_giac_or.currency_cd
                                               ),
                              0
                             )
                      )
                   )
                 + (NVL (cf_giot_fst (p_tran_id, v_giac_or.currency_cd), 0))
                                                              cf_giot_others
            FROM giac_order_of_payts gop,
                 giis_currency gc,
                 gicl_claims a,
                 giac_loss_recoveries b,
                 gicl_clm_recovery c
           WHERE gop.currency_cd = gc.main_currency_cd
             AND a.claim_id(+) = b.claim_id
             AND gop.gacc_tran_id = b.gacc_tran_id(+)
             AND b.recovery_id = c.recovery_id(+)
             AND gop.gacc_tran_id = NVL (p_tran_id, gop.gacc_tran_id))
      LOOP
         v_giac_or.gacc_tran_id := i.gacc_tran_id;
         v_giac_or.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_giac_or.gibr_branch_cd := i.gibr_branch_cd;
         v_giac_or.payor := i.payor;
         v_giac_or.or_date := TO_DATE (i.or_date, 'MM-DD-YYYY');
         v_giac_or.op_collection_amt := i.op_collection_amt;
         v_giac_or.currency_cd := i.currency_cd;
         v_giac_or.gross_tag := i.gross_tag;
         v_giac_or.intm_no := i.intm_no;
         v_giac_or.prov_receipt_no := i.prov_receipt_no;
         v_giac_or.or_no := i.or_no;
         v_giac_or.cashier_cd := i.cashier_cd;
         v_giac_or.particulars := i.particulars;
         v_giac_or.dcb_no := i.dcb_no;
         v_giac_or.address := i.address;
         v_giac_or.with_pdc := i.with_pdc;
         v_giac_or.tin := i.tin;
         v_giac_or.short_name := i.short_name;
         v_giac_or.claim_no := i.claim_no;
         v_giac_or.assured_name := i.assured_name;
         v_giac_or.loss_date := i.loss_date;
         v_giac_or.recovery_no := i.recovery_no;
         v_giac_or.or_flag := i.or_flag;
         v_giac_or.or_pref_suf := i.or_pref_suf;
         --v_giac_or.or_print_tag := i.or_print_tag;
         v_giac_or.cf_giot_others := i.cf_giot_others;
         v_giac_or.cf_giot_prem :=
                              cf_giot_prem (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_doc :=
                               cf_giot_doc (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_lgt :=
                               cf_giot_lgt (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_ri_comm :=
                           cf_giot_ri_comm (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_vat_comm :=
                          cf_giot_vat_comm (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_prem_tax :=
                          cf_giot_prem_tax (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_giot_evat :=
                              cf_giot_evat (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_tot_collns := cf_tot_collns (p_tran_id);
         v_giac_or.cf_giot_fst :=
                               cf_giot_fst (p_tran_id, v_giac_or.currency_cd);
         v_giac_or.cf_or_type :=
            cf_or_type (v_giac_or.or_pref_suf,
                        v_giac_or.gibr_gfun_fund_cd,
                        v_giac_or.gibr_branch_cd
                       );
         v_giac_or.check_ri_comm := check_ri_comm (p_tran_id);
         v_giac_or.check_item_text := check_item_text (p_tran_id);
         PIPE ROW (v_giac_or);
      END LOOP;

      RETURN;
   END get_giac_or_rep;

   FUNCTION get_giac_collection_dtl_rep (         --Added by Alfred 03/04/2011
      p_cp_check_title    giac_collection_dtl.check_no%TYPE,
      p_cp_credit_title   giac_collection_dtl.check_no%TYPE,
      p_gross_tag         giac_order_of_payts.gross_tag%TYPE,
      p_cp_sum            VARCHAR2,
      p_tran_id           giac_collection_dtl.gacc_tran_id%TYPE
   )
      RETURN giac_colln_dtl_rep_tab PIPELINED
   IS
      v_giac_collection_dtl   giac_colln_dtl_rep_type;
   BEGIN
      BEGIN
         FOR i IN (SELECT   a.gacc_tran_id, a.bank_cd,
                            DECODE (a.pay_mode,
                                    'CA', ' ',
                                    'CHK', DECODE (p_cp_check_title,
                                                   'Y', 'Various Check',
                                                   check_no
                                                  ),
                                    'PDC', DECODE ('N',
                                                   'Y', 'Various CHECK',
                                                   check_no
                                                  ),
                                    'CM', DECODE (p_cp_credit_title,
                                                  'Y', 'Various C.M.',
                                                  'CREDIT MEMO'
                                                 ),
                                    'CMI', check_no
                                   ) check_no,
                            a.check_date,
                            DECODE (p_gross_tag,
                                    'Y', DECODE (NVL (a.currency_cd, 1),
                                                 1, a.gross_amt,
                                                 a.fc_gross_amt
                                                ),
                                    DECODE (NVL (a.currency_cd, 1),
                                            1, a.amount,
                                            a.fcurrency_amt
                                           )
                                   ) amount,
                            a.pay_mode, a.amount net_amount,
                            a.commission_amt
                       FROM giac_collection_dtl a, giac_banks b
                      WHERE p_cp_sum = 'N'
                        AND a.gacc_tran_id = NVL (p_tran_id, a.gacc_tran_id)
                   --AND A.bank_cd = b.bank_cd
                   ORDER BY a.pay_mode)
         LOOP
            v_giac_collection_dtl.gacc_tran_id := i.gacc_tran_id;
            v_giac_collection_dtl.bank_cd := i.bank_cd;
            v_giac_collection_dtl.bank_name :=
               giac_banks_details_pkg.cf_bank_snameformula (i.bank_cd,
                                                            i.pay_mode
                                                           );
            v_giac_collection_dtl.check_no := i.check_no;
            v_giac_collection_dtl.check_date := i.check_date;
            v_giac_collection_dtl.gross_amt := i.amount;
            v_giac_collection_dtl.pay_mode := i.pay_mode;
            v_giac_collection_dtl.amount := i.net_amount;
            v_giac_collection_dtl.commission_amt := i.commission_amt;
            v_giac_collection_dtl.count_paymode_chk :=
                                                 count_paymode_chk (p_tran_id);
         END LOOP;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            IF v_giac_collection_dtl.pay_mode = 'CA'
            THEN
               v_giac_collection_dtl.bank_name := 'CASH';
            ELSIF v_giac_collection_dtl.pay_mode = 'CMI'
            THEN
               v_giac_collection_dtl.bank_name := 'CREDIT MEMO (I)';
            ELSE
               v_giac_collection_dtl.bank_name := NULL;
            END IF;
      END;

      PIPE ROW (v_giac_collection_dtl);
      RETURN;
   END get_giac_collection_dtl_rep;
END;
/

DROP PACKAGE CPI.GIACR050_CPI_PKG;

