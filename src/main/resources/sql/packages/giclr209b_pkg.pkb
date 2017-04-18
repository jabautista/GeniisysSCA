CREATE OR REPLACE PACKAGE BODY CPI.GICLR209B_PKG
AS
    FUNCTION cf_clm_statformula(
      p_claim_id         NUMBER,
      p_clm_loss_id      VARCHAR2,
      p_brdrx_record_id  NUMBER,
      p_session_id       NUMBER    
    )
       RETURN VARCHAR2
    IS
       v_clm_stat     gicl_clm_loss_exp.item_stat_cd%TYPE;
       var_clm_stat   VARCHAR2 (50);
    BEGIN
       FOR i IN (SELECT a.item_stat_cd
                   FROM gicl_clm_loss_exp a, gicl_item_peril b, gicl_clm_res_hist c
                  WHERE a.claim_id = b.claim_id
                    AND a.item_no = b.item_no
                    AND a.peril_cd = b.peril_cd
                    AND a.claim_id = c.claim_id
                    AND a.clm_loss_id = c.clm_loss_id
                    AND a.payee_type = 'E'
                    AND a.claim_id = p_claim_id
                    AND a.clm_loss_id = p_clm_loss_id
                    AND b.loss_cat_cd IN (SELECT loss_cat_cd
                                            FROM gicl_res_brdrx_extr
                                           WHERE session_id = p_session_id 
                                             AND claim_id = p_claim_id 
                                             AND brdrx_record_id = p_brdrx_record_id 
                                             AND peril_cd = a.peril_cd))
       LOOP
          v_clm_stat := i.item_stat_cd;

          IF var_clm_stat IS NULL THEN
             var_clm_stat := v_clm_stat;
          ELSE
             var_clm_stat := v_clm_stat || '/' || var_clm_stat;
          END IF;
       END LOOP;

       RETURN (var_clm_stat);
    END;
   FUNCTION get_giclr209b_report (
      p_claim_id     NUMBER,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER,
      p_paid_date    VARCHAR2,
      p_session_id   NUMBER,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2
   )
      RETURN giclr209b_tab PIPELINED
   IS
      v_list          giclr209b_type;
      v_tran_date     VARCHAR2 (100);
      var_tran_date   VARCHAR2 (200);
      v_loss          NUMBER (16, 2);
      v_check_no      VARCHAR2 (50);
      var_check_no    VARCHAR2 (500)                        := NULL;
      v_cancel_date   gicl_clm_res_hist.cancel_date%TYPE;
      v_clm_stat      gicl_clm_loss_exp.item_stat_cd%TYPE;
      var_clm_stat    VARCHAR2 (50);
      v_header        BOOLEAN                               := TRUE;
   BEGIN
      v_list.header_flag := 'N';
      v_list.company_name := giisp.v ('COMPANY_NAME');
      v_list.company_address := giisp.v ('COMPANY_ADDRESS');

      IF p_intm_break = 0
      THEN
         v_list.title_sw := 'LOSSES EXPENSES PAID REGISTER - PER BRANCH';
      ELSIF p_intm_break = 1
      THEN
         v_list.title_sw :=
                           'LOSSES EXPENSES PAID REGISTER - PER INTERMEDIARY';
      END IF;

      BEGIN
         SELECT DECODE (p_paid_date,
                        1, 'Transaction Date',
                        2, 'Posting Date'
                       )
           INTO v_list.date_title
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.date_title := NULL;
      END;

      BEGIN
         SELECT    'from '
                || TO_CHAR (TO_DATE (p_date_from, 'mm-dd-yyyy'),
                            'fmMonth DD, YYYY'
                           )
                || ' to '
                || TO_CHAR (TO_DATE (p_date_to, 'mm-dd-yyyy'),
                            'fmMonth DD, YYYY'
                           )
           INTO v_list.date_sw
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.date_sw := NULL;
      END;

      FOR i IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                         a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                         a.claim_no, a.policy_no, a.clm_file_date,
                         a.loss_date, a.loss_cat_cd, a.intm_no, a.clm_loss_id,
                         NVL (a.expenses_paid, 0) paid_loss, a.pd_date_opt,a.from_date, a.to_date
                    FROM gicl_res_brdrx_extr a
                   WHERE a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND NVL (a.expenses_paid, 0) <> 0
                ORDER BY a.intm_no,
                         a.iss_cd,
                         a.line_cd,
                         a.clm_loss_id,
                         a.claim_no,
                         a.policy_no)
      LOOP
         v_header := FALSE;
         v_list.header_flag := 'Y';
         v_list.intm_no := NVL (LTRIM (TO_CHAR (i.intm_no, '0009')), ' ');
         v_list.brdrx_record_id := i.brdrx_record_id;
         v_list.buss_source := i.buss_source;
         v_list.iss_cd := i.iss_cd;
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.claim_id := i.claim_id;
         v_list.assd_no := i.assd_no;
         v_list.claim_no := i.claim_no;
         v_list.policy_no := i.policy_no;
         v_list.clm_file_date := i.clm_file_date;
         v_list.loss_date := i.loss_date;
         v_list.clm_loss_id := i.clm_loss_id;
         v_list.loss_cat_cd := i.loss_cat_cd;
         v_list.paid_loss := i.paid_loss;

         BEGIN
            SELECT intm_name
              INTO v_list.intm_name
              FROM giis_intermediary
             WHERE intm_no = i.intm_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.intm_name := ' ';
         END;

         BEGIN
            SELECT iss_name
              INTO v_list.iss_name
              FROM giis_issource
             WHERE iss_cd = i.iss_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.iss_name := NULL;
         END;

         BEGIN
            SELECT line_name
              INTO v_list.line_name
              FROM giis_line
             WHERE line_cd = i.line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.line_name := NULL;
         END;

         BEGIN
            SELECT pol_eff_date
              INTO v_list.eff_date
              FROM gicl_claims
             WHERE claim_id = i.claim_id;
         END;

         BEGIN
            SELECT assd_name
              INTO v_list.assd_name
              FROM giis_assured
             WHERE assd_no = i.assd_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.assd_name := NULL;
         END;

         BEGIN
            SELECT loss_cat_des
              INTO v_list.loss_cat_category
              FROM giis_loss_ctgry
             WHERE line_cd = i.line_cd AND loss_cat_cd = i.loss_cat_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.loss_cat_category := NULL;
         END;

         BEGIN
            v_list.share_type1 := 0;

            FOR shr1 IN (SELECT NVL (a.expenses_paid, 0) paid_loss
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = 1)
                            AND a.claim_id = NVL (i.claim_id, a.claim_id)
                            AND a.brdrx_record_id = i.brdrx_record_id
                            AND NVL (a.expenses_paid, 0) <> 0)
            LOOP
               v_list.share_type1 := v_list.share_type1 + shr1.paid_loss;
            END LOOP;
         END;

         BEGIN
            v_list.share_type2 := 0;

            FOR shr2 IN (SELECT NVL (a.expenses_paid, 0) paid_loss
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = 2)
                            AND a.claim_id = NVL (i.claim_id, a.claim_id)
                            AND a.brdrx_record_id = i.brdrx_record_id
                            AND NVL (a.expenses_paid, 0) <> 0)
            LOOP
               v_list.share_type2 := v_list.share_type2 + shr2.paid_loss;
            END LOOP;
         END;

         BEGIN
            v_list.share_type3 := 0;

            FOR shr3 IN (SELECT NVL (a.expenses_paid, 0) paid_loss
                           FROM gicl_res_brdrx_ds_extr a
                          WHERE a.session_id = p_session_id
                            AND a.grp_seq_no IN (
                                   SELECT a.share_cd
                                     FROM giis_dist_share a
                                    WHERE a.line_cd = i.line_cd
                                      AND a.share_type = 3)
                            AND a.claim_id = NVL (i.claim_id, a.claim_id)
                            AND a.brdrx_record_id = i.brdrx_record_id
                            AND NVL (a.expenses_paid, 0) <> 0)
            LOOP
               v_list.share_type3 := v_list.share_type3 + shr3.paid_loss;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.share_type3 := 0;
         END;

         BEGIN
            v_list.paid := 0;

            FOR a IN
               (SELECT NVL (a.expenses_paid, 0) paid
                  FROM gicl_res_brdrx_ds_extr a
                 WHERE a.session_id = p_session_id
                   AND a.grp_seq_no IN (
                          SELECT a.share_cd
                            FROM giis_dist_share a
                           WHERE a.line_cd = i.line_cd
                             AND a.share_type =
                                    (SELECT param_value_v
                                       FROM giac_parameters
                                      WHERE param_name = 'XOL_TRTY_SHARE_TYPE'))
                   AND a.claim_id = NVL (i.claim_id, a.claim_id)
                   AND a.brdrx_record_id = i.brdrx_record_id
                   AND NVL (a.expenses_paid, 0) <> 0)
            LOOP
               v_list.paid := a.paid + v_list.paid;
            END LOOP;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_list.paid := 0;
         END;

         /*BEGIN
            FOR a IN (SELECT SIGN (i.paid_loss) expenses_paid
                        FROM DUAL)
            LOOP
               v_loss := a.expenses_paid;

               IF v_loss < 1
               THEN
                  FOR d1 IN (SELECT   TO_CHAR (a.date_paid,
                                               'MM-DD-RRRR'
                                              ) tran_date,
                                      TO_CHAR (a.cancel_date,
                                               'MM-DD-RRRR'
                                              ) cancel_date
                                 FROM gicl_clm_res_hist a,
                                      giac_acctrans b,
                                      giac_reversals c
                                WHERE a.tran_id = c.gacc_tran_id
                                  AND b.tran_id = c.reversing_tran_id
                                  AND a.claim_id = i.claim_id
                                  AND a.clm_loss_id = i.clm_loss_id
                             GROUP BY a.date_paid, a.cancel_date
                               HAVING SUM (a.expenses_paid) > 0)
                  LOOP
                     v_tran_date := d1.tran_date;

                     IF var_tran_date IS NULL
                     THEN
                        v_list.tran_date := v_tran_date;
                     ELSE
                        v_list.tran_date :=
                                      v_tran_date || CHR (10)
                                      || var_tran_date;
                     END IF;
                  END LOOP;
               ELSE
                  FOR d2 IN
                     (SELECT   TO_CHAR (a.date_paid, 'MM-DD-RRRR') tran_date
                          FROM gicl_clm_res_hist a, giac_acctrans b
                         WHERE a.claim_id = i.claim_id
                           AND a.clm_loss_id = i.clm_loss_id
                           AND a.tran_id = b.tran_id
                           AND DECODE (p_paid_date,
                                       1, TRUNC (a.date_paid),
                                       2, TRUNC (b.posting_date)
                                      ) BETWEEN (TO_DATE (p_date_from,
                                                          'mm-dd-yyyy'
                                                         )
                                                )
                                            AND (TO_DATE (p_date_to,
                                                          'mm-dd-yyyy'
                                                         )
                                                )
                      GROUP BY a.date_paid
                        HAVING SUM (a.expenses_paid) > 0)
                  LOOP
                     v_tran_date := d2.tran_date;

                     IF var_tran_date IS NULL
                     THEN
                        v_list.tran_date := v_tran_date;
                     ELSE
                        v_list.tran_date :=
                                      v_tran_date || CHR (10)
                                      || var_tran_date;
                     END IF;
                  END LOOP;
               END IF;
            END LOOP;
         END;

         BEGIN
            FOR a IN (SELECT SIGN (i.paid_loss) losses_paid
                        FROM DUAL)
            LOOP
               v_loss := a.losses_paid;

               IF v_loss < 1
               THEN
--                  FOR c1 IN
--                     (SELECT DISTINCT    b.check_pref_suf
--                                      || '-'
--                                      || LTRIM (TO_CHAR (b.check_no,
--                                                         '0999999999'
--                                                        )
--                                               ) check_no,
--                                      TO_CHAR (a.cancel_date,
--                                               'MM/DD/YYYY'
--                                              ) cancel_date
--                                 FROM gicl_clm_res_hist a,
--                                      giac_chk_disbursement b,
--                                      giac_acctrans c,
--                                      giac_reversals d
--                                WHERE a.tran_id = b.gacc_tran_id
--                                  AND a.tran_id = d.gacc_tran_id
--                                  AND c.tran_id = d.reversing_tran_id
--                                  AND a.claim_id = i.claim_id
--                                  AND a.clm_loss_id = i.clm_loss_id
--                             GROUP BY b.check_pref_suf,
--                                      b.check_no,
--                                      a.cancel_date
--                               HAVING SUM (a.losses_paid) > 0)
                   FOR c1 IN (SELECT DISTINCT b.check_pref_suf||'-'||LTRIM(TO_CHAR(b.check_no,'0999999999')) check_no,
                                     TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date                
                                FROM gicl_clm_res_hist a, giac_chk_disbursement b, 
                                     giac_acctrans c, giac_reversals d 
                               WHERE a.tran_id = b.gacc_tran_id
                                 AND a.tran_id = d.gacc_tran_id
                                 AND c.tran_id = d.reversing_tran_id 
                                 AND a.claim_id = i.claim_id
                                 AND a.clm_loss_id = i.clm_loss_id
                               GROUP BY b.check_pref_suf, b.check_no, a.cancel_date
                              HAVING SUM(a.expenses_paid) > 0)
                  LOOP
                     v_check_no :=
                           c1.check_no
                        || CHR (10)
                        || 'cancelled '
                        || c1.cancel_date;

                     IF var_check_no IS NULL
                     THEN
                        v_list.check_no := v_check_no;
                     ELSE
                        v_list.check_no :=
                                        v_check_no || CHR (10)
                                        || var_check_no;
                     END IF;
                  END LOOP;
               ELSE
--                  FOR c2 IN
--                     (SELECT DISTINCT    b.check_pref_suf
--                                      || '-'
--                                      || LTRIM (TO_CHAR (b.check_no,
--                                                         '0999999999'
--                                                        )
--                                               ) check_no
--                                 FROM gicl_clm_res_hist a,
--                                      giac_chk_disbursement b,
--                                      giac_disb_vouchers c,
--                                      giac_direct_claim_payts d,
--                                      giac_acctrans e
--                                WHERE a.tran_id = e.tran_id
--                                  AND b.gacc_tran_id = c.gacc_tran_id
--                                  AND b.gacc_tran_id = d.gacc_tran_id(+)
--                                  AND b.gacc_tran_id = e.tran_id
--                                  AND a.claim_id = i.claim_id
--                                  AND a.clm_loss_id = i.clm_loss_id
--                                  AND DECODE (p_paid_date,
--                                              1, TRUNC (a.date_paid),
--                                              2, TRUNC (e.posting_date)
--                                             ) BETWEEN (TO_DATE (p_date_from,
--                                                                 'mm-dd-yyyy'
--                                                                )
--                                                       )
--                                                   AND (TO_DATE (p_date_to,
--                                                                 'mm-dd-yyyy'
--                                                                )
--                                                       )
--                             GROUP BY b.check_pref_suf, b.check_no
--                               HAVING SUM (a.losses_paid) > 0)
                   v_list.check_no := NULL;
                  FOR c2 IN (SELECT DISTINCT b.check_pref_suf||'-'||LTRIM(TO_CHAR(b.check_no,'0999999999')) check_no
                               FROM gicl_clm_res_hist a, giac_chk_disbursement b, giac_disb_vouchers c,
                                    giac_direct_claim_payts d, giac_acctrans e
                              WHERE a.tran_id = e.tran_id    
                                AND b.gacc_tran_id = c.gacc_tran_id
                                AND b.gacc_tran_id = d.gacc_tran_id
                                AND b.gacc_tran_id = e.tran_id
                                AND a.claim_id = i.claim_id
                                AND a.clm_loss_id = i.clm_loss_id 
                                AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(e.posting_date)) 
                                    BETWEEN TO_DATE(p_date_from,'mm-dd-yyyy') AND TO_DATE(p_date_to,'mm-dd-yyyy')
                              GROUP BY b.check_pref_suf, b.check_no
                             HAVING SUM(a.expenses_paid) > 0)
                  LOOP
                     v_check_no := c2.check_no;

                     IF var_check_no IS NULL
                     THEN
                        v_list.check_no := v_check_no;
                     ELSE
                        v_list.check_no :=
                                        v_check_no || CHR (10)
                                        || var_check_no;
                     END IF;
                  END LOOP;
                                 
--                  IF var_check_no IS NULL
--                  THEN
--                     FOR a IN
--                        (SELECT get_ref_no (a.tran_id) ref_no
--                           FROM gicl_clm_res_hist a, giac_acctrans e
--                          WHERE a.claim_id = i.claim_id
--                            AND a.clm_loss_id = i.clm_loss_id
--                            AND DECODE (p_paid_date,
--                                        1, TRUNC (a.date_paid),
--                                        2, TRUNC (e.posting_date)
--                                       ) BETWEEN (TO_DATE (p_date_from,
--                                                           'mm-dd-yyyy'
--                                                          )
--                                                 )
--                                             AND (TO_DATE (p_date_to,
--                                                           'mm-dd-yyyy'
--                                                          )
--                                                 )
--                            AND a.tran_id = e.tran_id)
--                     LOOP
--                        v_list.check_no := a.ref_no;
--                     END LOOP;
--                  END IF;
               END IF;
            END LOOP;
         END;*/

--         BEGIN
--            FOR j IN (SELECT a.item_stat_cd
--                        FROM gicl_clm_loss_exp a,
--                             gicl_item_peril b,
--                             gicl_clm_res_hist c
--                       WHERE a.claim_id = b.claim_id
--                         AND a.item_no = b.item_no
--                         AND a.peril_cd = b.peril_cd
--                         AND a.claim_id = c.claim_id
--                         AND a.clm_loss_id = c.clm_loss_id
--                         AND a.payee_type = 'E'
--                         AND a.claim_id = i.claim_id
--                         AND a.clm_loss_id = i.clm_loss_id
--                         AND b.loss_cat_cd IN (
--                                SELECT loss_cat_cd
--                                  FROM gicl_res_brdrx_extr
--                                 WHERE session_id = p_session_id
--                                   AND claim_id = i.claim_id
--                                   AND brdrx_record_id = i.brdrx_record_id
--                                   AND peril_cd = a.peril_cd))
--            LOOP
--               v_clm_stat := j.item_stat_cd;

--               IF v_clm_stat IS NULL
--               THEN
--                  v_list.clm_stat := v_clm_stat;
--               ELSE
--                  v_list.clm_stat :=v_list.clm_stat || '/' ||  v_list.clm_stat ;
--               END IF;
--            END LOOP;
--         END;
         --v_list.clm_stat := giclr209b_pkg.cf_clm_statformula(i.claim_id, i.clm_loss_id, i.brdrx_record_id, p_session_id);
         v_list.tran_date := GICLS202_EXTRACTION_PKG.GET_GICLR209_DTL(i.claim_id, i.from_date, i.to_date, i.pd_date_opt, 'E', 'TRAN_DATE');
         v_list.check_no := GICLS202_EXTRACTION_PKG.GET_GICLR209_DTL(i.claim_id, i.from_date, i.to_date, i.pd_date_opt, 'E', 'CHECK_NO');
         v_list.clm_stat := GICLS202_EXTRACTION_PKG.GET_GICLR209_DTL(i.claim_id, i.from_date, i.to_date, i.pd_date_opt, 'E', 'ITEM_STAT_CD');
         PIPE ROW (v_list);
      END LOOP;

      IF (v_header = TRUE)
      THEN
         PIPE ROW (v_list);
      END IF;

      RETURN;
   END get_giclr209b_report;
END;
/


