DROP PROCEDURE CPI.GIPIS002_POPULATE_TABLES;

CREATE OR REPLACE PROCEDURE CPI.gipis002_populate_tables (
   p_par_id          IN   gipi_wopen_policy.par_id%TYPE,
   p_line_cd         IN   gipi_wopen_policy.line_cd%TYPE,
   p_op_subline_cd   IN   gipi_wopen_policy.op_subline_cd%TYPE,
   p_op_iss_cd       IN   gipi_wopen_policy.op_iss_cd%TYPE,
   p_op_issue_yy     IN   gipi_wopen_policy.op_issue_yy%TYPE,
   p_op_pol_seqno    IN   gipi_wopen_policy.op_pol_seqno%TYPE,
   p_op_renew_no     IN   gipi_wopen_policy.op_renew_no%TYPE,
   p_policy_id		 IN	  gipi_polbasic.policy_id%TYPE
)
IS
   /* USED IN OPEN POLICY FOR GIPIS002 - BRY 09/21/2010*/
   v_policy_id      gipi_polbasic.policy_id%TYPE;
   v_line_cd        gipi_itmperil.line_cd%TYPE;
   v_item_no        gipi_item.item_no%TYPE;
   v_peril_cd       gipi_itmperil.peril_cd%TYPE;
   v_tsi_amt        gipi_itmperil.tsi_amt%TYPE;
   v_prem_amt       gipi_itmperil.prem_amt%TYPE;
   v_ann_tsi_amt    gipi_itmperil.ann_tsi_amt%TYPE;
   v_ann_prem_amt   gipi_itmperil.ann_prem_amt%TYPE;
   v_prem_rt        gipi_itmperil.prem_rt%TYPE;
   v_rec_flag       gipi_itmperil.rec_flag%TYPE;
   v_curr_cd        gipi_item.currency_cd%TYPE;
   v_curr_rt        gipi_item.currency_rt%TYPE;
   v_itm_grp        gipi_item.item_grp%TYPE;
   v_endt_id        gipi_polbasic.policy_id%TYPE;
   v_subline_cd     giex_expiry.subline_cd%TYPE;
   v_currency_rt    gipi_witem.currency_rt%TYPE;
   v_comp_rem       gipi_witmperl.comp_rem%TYPE;
   v_item_title     gipi_witem.item_title%TYPE;

   CURSOR policy_tab
   IS
      SELECT   policy_id, NVL (endt_seq_no, 0) endt_seq_no, pol_flag
          FROM gipi_polbasic b
         WHERE b.line_cd = p_line_cd
           AND b.subline_cd = p_op_subline_cd
           AND b.iss_cd = p_op_iss_cd
           AND b.issue_yy = p_op_issue_yy
           AND b.pol_seq_no = p_op_pol_seqno
           AND b.renew_no = p_op_renew_no
           AND (endt_seq_no = 0)
      ORDER BY eff_date, endt_seq_no;

   CURSOR endt_tab
   IS
      SELECT   policy_id, NVL (endt_seq_no, 0) endt_seq_no, pol_flag
          FROM gipi_polbasic b
         WHERE b.line_cd = p_line_cd
           AND b.subline_cd = p_op_subline_cd
           AND b.iss_cd = p_op_iss_cd
           AND b.issue_yy = p_op_issue_yy
           AND b.pol_seq_no = p_op_pol_seqno
           AND b.renew_no = p_op_renew_no
           AND (   endt_seq_no = 0
                OR (    endt_seq_no > 0
                    AND TRUNC (endt_expiry_date) >= TRUNC (expiry_date)
                   )
               )
      ORDER BY eff_date, endt_seq_no;
BEGIN
   DELETE FROM gipi_witmperl
         WHERE par_id = p_par_id;

   DELETE FROM gipi_witem
         WHERE par_id = p_par_id;

   FOR b IN (SELECT currency_cd, currency_rt, item_grp
               FROM gipi_item
              WHERE policy_id = p_policy_id)
   LOOP
      v_curr_cd := b.currency_cd;
      v_curr_rt := b.currency_rt;
      v_itm_grp := b.item_grp;
   END LOOP;

   IF v_curr_cd IS NULL
   THEN
      --if endt, and no record is retrieved in gipi_item, get from orig policy
      FOR b IN (SELECT currency_cd, currency_rt, item_grp
                  FROM gipi_item
                 WHERE policy_id =
                          (SELECT policy_id
                             FROM gipi_polbasic
                            WHERE line_cd = p_line_cd
                              AND subline_cd = p_op_subline_cd
                              AND iss_cd = p_op_iss_cd
                              AND issue_yy = p_op_issue_yy
                              AND pol_seq_no = p_op_pol_seqno
                              AND renew_no = p_op_renew_no
                              AND endt_seq_no = 0))
      LOOP
         v_curr_cd := b.currency_cd;
         v_curr_rt := b.currency_rt;
         v_itm_grp := b.item_grp;
      END LOOP;
   END IF;

   INSERT INTO gipi_witem
               (par_id, item_no, item_title, currency_cd, currency_rt,
                item_grp
               )
        VALUES (p_par_id, 1, 'ITEM', v_curr_cd, v_curr_rt,
                v_itm_grp
               );

   FOR polbasic IN policy_tab
   LOOP
      v_policy_id := polbasic.policy_id;         -- added by aaron 10/31/2007

      FOR DATA IN
         (SELECT a.peril_cd, a.prem_amt, a.tsi_amt, a.tarf_cd, a.prem_rt,
                 a.comp_rem, a.line_cd, a.item_no, b.item_title,
                 b.pack_subline_cd, b.currency_rt, a.ann_tsi_amt,
                 a.ann_prem_amt
            --added by aaron 10/31/2007 @fpac to correct value of ann_tsi_amt
            FROM gipi_itmperil a, gipi_item b
           WHERE a.policy_id = b.policy_id
             AND a.item_no = b.item_no
             AND a.policy_id = polbasic.policy_id)
      LOOP
         v_currency_rt := DATA.currency_rt;
         v_peril_cd := DATA.peril_cd;
         v_line_cd := DATA.line_cd;
         v_prem_amt := DATA.prem_amt;
         v_tsi_amt := DATA.tsi_amt;
         v_item_title := DATA.item_title;
         v_prem_rt := DATA.prem_rt;
         v_comp_rem := DATA.comp_rem;
         v_ann_tsi_amt := DATA.ann_tsi_amt;
                                           -- added by aaron 10/31/2007 @fpac
         v_ann_prem_amt := DATA.ann_prem_amt;
                                           -- added by aaron 10/31/2007 @fpac

         FOR row_no2 IN endt_tab
         LOOP
            v_endt_id := row_no2.policy_id;

            FOR data2 IN
               (SELECT a.prem_amt, a.tsi_amt, a.prem_rt, a.comp_rem,
                       a.ri_comm_rate, a.ri_comm_amt, b.item_title,
                       a.ann_tsi_amt,
            --added by aaron 10/31/2007 @fpac to correct value of ann_tsi_amt
                       a.ann_prem_amt       --added by aaron 10/31/2007 @fpac
                  FROM gipi_itmperil a, gipi_item b
                 WHERE a.policy_id = b.policy_id
                   AND a.item_no = b.item_no
                   AND peril_cd = v_peril_cd
                   AND a.item_no = DATA.item_no
                   AND a.policy_id = v_endt_id)
            LOOP
               IF v_policy_id <> v_endt_id
               THEN
                  v_item_title := NVL (data2.item_title, v_item_title);
                  v_prem_amt := NVL (v_prem_amt, 0) + NVL (data2.prem_amt, 0);
                  v_tsi_amt := NVL (v_tsi_amt, 0) + NVL (data2.tsi_amt, 0);
                  v_ann_tsi_amt := NVL (data2.ann_tsi_amt, 0);
            --added by aaron 10/31/2007 @fpac to correct value of ann_tsi_amt
                  v_ann_prem_amt := NVL (data2.ann_prem_amt, 0);
                                            --added by aaron 10/31/2007 @fpac

                  IF NVL (data2.prem_rt, 0) > 0
                  THEN
                     v_prem_rt := data2.prem_rt;
                  END IF;

                  v_comp_rem := NVL (data2.comp_rem, v_comp_rem);
               END IF;
            END LOOP;
         END LOOP;

         IF NVL (v_tsi_amt, 0) > 0
         THEN
            --message('1');message('1');
            INSERT INTO gipi_witmperl
                        (par_id, line_cd, item_no, peril_cd, tsi_amt,
                         prem_amt, prem_rt, ann_tsi_amt,
                         ann_prem_amt, rec_flag
                        )
                 VALUES (p_par_id, v_line_cd, 1, v_peril_cd, v_tsi_amt,
                         v_prem_amt, v_prem_rt, v_ann_tsi_amt,
                         v_ann_prem_amt, v_rec_flag
                        );

            v_peril_cd := NULL;
            v_line_cd := NULL;
            v_prem_amt := NULL;
            v_tsi_amt := NULL;
            v_prem_rt := NULL;
            v_currency_rt := NULL;
            v_comp_rem := NULL;
         END IF;
      END LOOP;
   END LOOP;
END gipis002_populate_tables;
/


