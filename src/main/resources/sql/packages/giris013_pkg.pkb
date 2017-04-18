CREATE OR REPLACE PACKAGE BODY CPI.giris013_pkg
AS
   FUNCTION get_inw_ri_payt_stat (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN giris013_tab PIPELINED
   IS
      v_list   giris013_type;
   BEGIN
      FOR i IN (SELECT a.policy_id, a.iss_cd, a.prem_seq_no,
                          a.iss_cd
                       || ' - '
                       || TO_CHAR (LTRIM (a.prem_seq_no), '09999999')
                                                                  invoice_no,
                       b.currency_desc,
                       NVL ((  (a.prem_amt + NVL (a.tax_amt, 0))
                             - (a.ri_comm_amt + NVL (a.ri_comm_vat, 0))
                            ),
                            0
                           ) net_due,
                         (  NVL ((  (a.prem_amt + NVL (a.tax_amt, 0))
                                  - (a.ri_comm_amt + NVL (a.ri_comm_vat, 0))
                                 ),
                                 0
                                )
                          * a.currency_rt
                         )
                       - (NVL (get_inwfacul_tot_amt (a.iss_cd, a.prem_seq_no),
                               0
                              )
                         ) balance
                  FROM gipi_invoice a, giis_currency b
                 WHERE a.currency_cd = b.main_currency_cd
                   AND a.policy_id = p_policy_id)
      LOOP
         v_list.policy_id := i.policy_id;
         v_list.iss_cd := i.iss_cd;
         v_list.prem_seq_no := i.prem_seq_no;
         v_list.invoice_no := i.invoice_no;
         v_list.currency_desc := i.currency_desc;
         v_list.net_due := i.net_due;
         v_list.balance := i.balance;
         v_list.collection_amt :=
                               get_inwfacul_tot_amt (i.iss_cd, i.prem_seq_no);
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_inw_ri_payt_stat;

   FUNCTION get_polno_lov (p_line_cd giis_line.line_cd%TYPE)
      RETURN polno_lov_tab PIPELINED
   IS
      v_list   polno_lov_type;
   BEGIN
      FOR i IN (SELECT   line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                         renew_no, endt_iss_cd, endt_yy, endt_seq_no,
                         ri_policy_no, a.policy_id, ri_endt_no, ri_binder_no,
                         ri_sname, a.eff_date, a.expiry_date,
                         get_policy_no (a.policy_id) policy_no
                    FROM gipi_polbasic a, giri_inpolbas b, giis_reinsurer c
                   WHERE a.policy_id = b.policy_id AND b.ri_cd = c.ri_cd
                ORDER BY line_cd,
                         subline_cd,
                         iss_cd,
                         issue_yy,
                         pol_seq_no,
                         renew_no,
                         endt_seq_no)
      LOOP
         v_list.policy_no := i.policy_no;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.endt_iss_cd := i.endt_iss_cd;
         v_list.endt_yy := i.endt_yy;
         v_list.endt_seq_no := i.endt_seq_no;
         v_list.ri_policy_no := i.ri_policy_no;
         v_list.policy_id := i.policy_id;
         v_list.ri_endt_no := i.ri_endt_no;
         v_list.ri_binder_no := i.ri_binder_no;
         v_list.ri_sname := i.ri_sname;
         v_list.eff_date := i.eff_date;
         v_list.expiry_date := i.expiry_date;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_polno_lov;

   FUNCTION get_inw_ri_payt_dtls (
      p_iss_cd        gipi_invoice.iss_cd%TYPE,
      p_prem_seq_no   gipi_invoice.prem_seq_no%TYPE
   )
      RETURN giris013_dtls_tab PIPELINED
   IS
      v_list   giris013_dtls_type;
   BEGIN
      FOR i IN
         (SELECT gacc.tran_class,
                 DECODE (gacc.tran_class,
                         'COL', DECODE (giop.or_pref_suf,
                                        NULL, LTRIM (TO_CHAR (giop.or_no,
                                                              '0000000000'
                                                             )
                                                    ),
                                           gacc.tran_class/*giop.or_pref_suf*/
                                        || '-'
                                        || LTRIM (TO_CHAR (giop.or_no,
                                                           '0000000000'
                                                          )
                                                 )
                                       ),
                         'DV', DECODE (gidv.dv_pref,
                                       NULL, LTRIM (TO_CHAR (gidv.dv_no,
                                                             '0000000000'
                                                            )
                                                   ),
                                          gacc.tran_class/*gidv.dv_pref*/
                                       || '-'
                                       || LTRIM (TO_CHAR (gidv.dv_no,
                                                          '0000000000'
                                                         )
                                                )
                                      ),
                         LTRIM (TO_CHAR (gacc.tran_class_no, '0000000000'))
                        ) ref_no,
                 DECODE (gacc.tran_class,
                         'COL', giop.or_date,
                         'DV', gidv.dv_create_date,
                         gacc.tran_date
                        ) pay_date,
                 gipc.collection_amt collection_amt, gipc.b140_iss_cd iss_cd,
                 gipc.b140_prem_seq_no prem_seq_no,
                 gacc.tran_id gacc_tran_id
            FROM giac_disb_vouchers gidv,
                 giac_order_of_payts giop,
                 giac_acctrans gacc,
                 giac_inwfacul_prem_collns gipc
           WHERE 1 = 1
             AND gipc.gacc_tran_id = gacc.tran_id
             AND gacc.tran_id = giop.gacc_tran_id(+)
             AND gacc.tran_id = gidv.gacc_tran_id(+)
             AND gipc.b140_iss_cd = p_iss_cd
             AND gipc.b140_prem_seq_no = p_prem_seq_no
             AND DECODE (gacc.tran_class,
                         'COL', DECODE (giop.or_pref_suf,
                                        NULL, LTRIM (TO_CHAR (giop.or_no,
                                                              '0000000000'
                                                             )
                                                    ),
                                           gacc.tran_class/*giop.or_pref_suf*/
                                        || '-'
                                        || LTRIM (TO_CHAR (giop.or_no,
                                                           '0000000000'
                                                          )
                                                 )
                                       ),
                         'DV', DECODE (gidv.dv_pref,
                                       NULL, LTRIM (TO_CHAR (gidv.dv_no,
                                                             '0000000000'
                                                            )
                                                   ),
                                          gacc.tran_class/*gidv.dv_pref*/
                                       || '-'
                                       || LTRIM (TO_CHAR (gidv.dv_no,
                                                          '0000000000'
                                                         )
                                                )
                                      ),
                         LTRIM (TO_CHAR (gacc.tran_class_no, '0000000000'))
                        ) IS NOT NULL
             AND NOT EXISTS (
                    SELECT c.gacc_tran_id
                      FROM giac_reversals c, giac_acctrans d
                     WHERE c.reversing_tran_id = d.tran_id
                       AND d.tran_flag <> 'D'
                       AND c.gacc_tran_id = gidv.gacc_tran_id)
          UNION
          SELECT gacc.tran_class,
                    DECODE (gprq.document_cd,
                            NULL, NULL,
                            LTRIM (gprq.document_cd || '-')
                           )
                 || DECODE (gprq.line_cd,
                            NULL, NULL,
                            LTRIM (gprq.line_cd || '-')
                           )
                 || DECODE (gprq.doc_mm,
                            NULL, NULL,
                            LTRIM (TO_CHAR (gprq.doc_mm, '09') || '-')
                           )
                 || DECODE (gprq.doc_year,
                            NULL, NULL,
                            LTRIM (TO_CHAR (gprq.doc_year, '0009') || '-')
                           )
                 || DECODE (gprq.doc_seq_no,
                            NULL, NULL,
                            LTRIM (TO_CHAR (gprq.doc_seq_no, '0000009'))
                           ) ref_no,
                 request_date pay_date, gipc.collection_amt collection_amt,
                 gipc.b140_iss_cd iss_cd, gipc.b140_prem_seq_no prem_seq_no,
                 gacc.tran_id gacc_tran_id
            FROM giac_acctrans gacc,
                 giac_inwfacul_prem_collns gipc,
                 giac_payt_requests_dtl gprd,
                 giac_payt_requests gprq
           WHERE 1 = 1
             AND gacc.tran_id = gipc.gacc_tran_id
             AND gacc.tran_id = gprd.tran_id
             AND gprq.ref_id = gprd.gprq_ref_id
             AND gipc.b140_iss_cd = p_iss_cd
             AND gipc.b140_prem_seq_no = p_prem_seq_no
             AND NVL (gprq.with_dv, 'N') = 'N'
             AND NOT EXISTS (
                    SELECT c.gacc_tran_id
                      FROM giac_reversals c, giac_acctrans d
                     WHERE c.reversing_tran_id = d.tran_id
                       AND d.tran_flag <> 'D'
                       AND c.gacc_tran_id = gprd.tran_id))
      LOOP
         v_list.ref_no := i.ref_no;
         v_list.pay_date := i.pay_date;
         v_list.collection_amt := i.collection_amt;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_inw_ri_payt_dtls;
END;
/


