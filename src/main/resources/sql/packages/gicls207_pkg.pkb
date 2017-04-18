CREATE OR REPLACE PACKAGE BODY CPI.gicls207_pkg
AS
/*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.26.2013
   **  Reference By : GICLS207- OS LOSS DETAILS
   **  Description  :
   */
   FUNCTION get_batch_os_records (p_user_id giis_users.user_id%TYPE)
      RETURN batch_os_tab PIPELINED
   IS
      v_rec   batch_os_type;
   BEGIN
      FOR i IN
         (SELECT DISTINCT TRUNC (tran_date) tran_date, gibr_branch_cd,
                          tran_id, tran_class
                     FROM giac_acctrans b
                    WHERE 1 = 1
                      AND b.tran_class IN ('OL', 'OLR')
                      AND b.tran_flag IN ('P', 'C')
                      AND gibr_branch_cd IN (
                             SELECT iss_cd
                               FROM giis_issource
                              WHERE iss_cd =
                                       DECODE
                                          (check_user_per_iss_cd2 (NULL,
                                                                   iss_cd,
                                                                   'GICLS207',
                                                                   p_user_id
                                                                  ),
                                           1, iss_cd,
                                           NULL
                                          ))
                 ORDER BY tran_date DESC, tran_id DESC)
      LOOP
         v_rec.tran_date := TO_CHAR(i.tran_date,'MM-DD-YYYY');
         v_rec.gibr_branch_cd := i.gibr_branch_cd;
         v_rec.tran_id := i.tran_id;
         v_rec.tran_class := i.tran_class;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION validate_loss_exp (
      p_user_id   giis_users.user_id%TYPE,
      p_tran_id   gicl_clm_res_hist.tran_id%TYPE
   )
      RETURN loss_exp_tab PIPELINED
   IS
      v_rec   loss_exp_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM TABLE (gicls207_pkg.get_batch_os_records (p_user_id))
                 WHERE tran_id = NVL (p_tran_id, tran_id))
      LOOP
         BEGIN
            SELECT DISTINCT acct_tran_id
                       INTO v_rec.tran_id
                       FROM gicl_reserve_ds_xtr
                      WHERE acct_tran_id = i.tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_rec.tran_id := 0;
         END;

         v_rec.msg := '';
         v_rec.tag := 'N';
         v_rec.extract_tran_id := '';

         IF i.tran_class = 'OL'
         THEN
            IF v_rec.tran_id > 0
            THEN
               v_rec.tag := 'Y';
            ELSE
               v_rec.extract_tran_id := i.tran_id;
               v_rec.msg :=
                     'Extraction of loss/expense details for Tran ID '
                  || TO_CHAR (i.tran_id)
                  || ' will now be performed. Continue?';
            END IF;
         END IF;

         PIPE ROW (v_rec);
      END LOOP;
   END;

--this procedure creates record in table gicl_reserve_ds_xtr
--and gicl_reserve_rids_xtr which will be used in reports
--that will support the generated data during batch o/s take up
   PROCEDURE extract_os_detail (p_tran_id gicl_clm_res_hist.tran_id%TYPE)
   IS
      v_ds_loss       gicl_take_up_hist.os_loss%TYPE;  --store sum of os_loss
      v_ds_exp        gicl_take_up_hist.os_loss%TYPE;   --store sum of os_exp
      v_rids_loss     gicl_take_up_hist.os_loss%TYPE;  --store sum of os_loss
      v_rids_exp      gicl_take_up_hist.os_loss%TYPE;   --store sum of os_exp
      v_grp_seq_no    gicl_reserve_ds.grp_seq_no%TYPE;
      --store grp_seq_no that will be updated
      v_offset_loss   gicl_take_up_hist.os_loss%TYPE;    --loss offset amount
      v_offset_exp    gicl_take_up_hist.os_loss%TYPE; --expense offset amount
      v_ri_cd         gicl_reserve_rids.ri_cd%TYPE;
   --store ri_cd that will be updated
   BEGIN
      --retrieve first all the records in table gicl_take_up_hist
      --that have acct_tran_id equal to the passed parameter
      FOR take_up IN (SELECT os_loss, os_expense, claim_id, clm_res_hist_id,
                             item_no, peril_cd, dist_no
                        FROM gicl_take_up_hist
                       WHERE acct_tran_id = p_tran_id)
      LOOP
         --initialize variables to be used
         v_ds_loss := 0;
         v_ds_exp := 0;
         v_grp_seq_no := NULL;
         v_offset_loss := 0;
         v_offset_exp := 0;

         --compute for the amounts for each grp_seq_no using records
         --in gicl_reserve_ds
         FOR resds IN (SELECT NVL (take_up.os_loss, 0)
                              * (shr_pct / 100) loss,
                                NVL (take_up.os_expense, 0)
                              * (shr_pct / 100) expense,
                              acct_trty_type, grp_seq_no, share_type,
                              shr_pct, line_cd
                         FROM gicl_reserve_ds
                        WHERE claim_id = take_up.claim_id
                          AND clm_res_hist_id = take_up.clm_res_hist_id
                          AND clm_dist_no = take_up.dist_no)
         LOOP
            --add all the accumulated amounts of gicl_reserve_ds per record
            --in gicl_take_up_hist that will be used for offsetting
            v_ds_loss := v_ds_loss + resds.loss;
            v_ds_exp := v_ds_exp + resds.expense;
            v_grp_seq_no := resds.grp_seq_no;

            --insert record in extract table
            INSERT INTO gicl_reserve_ds_xtr
                        (acct_tran_id, acct_trty_type, claim_id,
                         grp_seq_no, item_no,
                         peril_cd, line_cd, share_type,
                         shr_pct, shr_loss_res_amt, shr_exp_res_amt,
                         clm_res_hist_id, clm_dist_no
                        )
                 VALUES (p_tran_id, resds.acct_trty_type, take_up.claim_id,
                         resds.grp_seq_no, take_up.item_no,
                         take_up.peril_cd, resds.line_cd, resds.share_type,
                         resds.shr_pct, resds.loss, resds.expense,
                         take_up.clm_res_hist_id, take_up.dist_no
                        );
         END LOOP;

         --check for offset amts
         v_offset_loss := NVL (take_up.os_loss, 0) - NVL (v_ds_loss, 0);
         v_offset_exp := NVL (take_up.os_expense, 0) - NVL (v_ds_exp, 0);

         --if offset amt is detected then update the corresponding record
         IF NVL (v_offset_loss, 0) <> 0 OR NVL (v_offset_exp, 0) <> 0
         THEN
            UPDATE gicl_reserve_ds_xtr
               SET shr_exp_res_amt = shr_exp_res_amt + v_offset_exp,
                   shr_loss_res_amt = shr_loss_res_amt + v_offset_loss
             WHERE acct_tran_id = p_tran_id
               AND claim_id = take_up.claim_id
               AND clm_res_hist_id = take_up.clm_res_hist_id;
         END IF;
      END LOOP;

      --retrieved records in table gicl_reserve_ds_xtr
      --that have acct_tran_id equal to the passed parameter
      --and only those with records in gicl_reserve_rids
      FOR resds IN (SELECT a.claim_id, a.clm_res_hist_id, a.grp_seq_no,
                           a.item_no, a.line_cd, a.peril_cd,
                           a.shr_exp_res_amt, a.shr_loss_res_amt,
                           a.clm_dist_no, a.shr_pct
                      FROM gicl_reserve_ds_xtr a
                     WHERE a.acct_tran_id = p_tran_id
                       AND EXISTS (
                              SELECT '1'
                                FROM gicl_reserve_rids b
                               WHERE b.claim_id = a.claim_id
                                 AND b.clm_res_hist_id = a.clm_res_hist_id
                                 AND b.clm_dist_no = a.clm_dist_no))
      LOOP
         --initialize variables to be use
         v_rids_loss := 0;
         v_rids_exp := 0;
         v_ri_cd := NULL;
         v_offset_loss := 0;
         v_offset_exp := 0;

         --compute for the amounts for each grp_seq_no using records
         --in gicl_reserve_ds
         FOR resrids IN (SELECT     NVL (resds.shr_loss_res_amt, 0)
                                  * (shr_ri_pct / resds.shr_pct) loss,
                                    NVL (resds.shr_exp_res_amt, 0)
                                  * (shr_ri_pct / resds.shr_pct) expense,
                                  
--             NVL(resds.shr_loss_res_amt,0) * (shr_ri_pct/100) loss,
--             NVL(resds.shr_exp_res_amt,0) * (shr_ri_pct/100) expense,
                                  shr_ri_pct, ri_cd
                             FROM gicl_reserve_rids
                            WHERE claim_id = resds.claim_id
                              AND clm_res_hist_id = resds.clm_res_hist_id
--         AND clm_res_hist_id = resds.clm_res_hist_id
                              AND grp_seq_no = resds.grp_seq_no
                              AND clm_dist_no = resds.clm_dist_no
                         GROUP BY shr_ri_pct, ri_cd)
         LOOP
            --add all the accumulated amounts of gicl_reserve_rids per record
            --in gicl_reserve_ds_xtr that will be used for offsetting
            v_rids_loss := v_rids_loss + resrids.loss;
            v_rids_exp := v_rids_exp + resrids.expense;
            v_ri_cd := resrids.ri_cd;

            --insert record in gicl_reserve_rids_xtr
            INSERT INTO gicl_reserve_rids_xtr
                        (acct_tran_id, claim_id, line_cd,
                         grp_seq_no, item_no, peril_cd,
                         shr_loss_res_amt, shr_exp_res_amt,
                         clm_res_hist_id, shr_pct,
                         ri_cd, clm_dist_no
                        )
                 VALUES (p_tran_id, resds.claim_id, resds.line_cd,
                         resds.grp_seq_no, resds.item_no, resds.peril_cd,
                         resrids.loss, resrids.expense,
                         resds.clm_res_hist_id, resrids.shr_ri_pct,
                         resrids.ri_cd, resds.clm_dist_no
                        );
         END LOOP;

         --compute for offset amounts
         v_offset_loss :=
                         NVL (resds.shr_loss_res_amt, 0)
                         - NVL (v_rids_loss, 0);
         v_offset_exp := NVL (resds.shr_exp_res_amt, 0) - NVL (v_rids_exp, 0);

         --if offset amt is detected then update the corresponding record
         IF NVL (v_offset_loss, 0) <> 0 OR NVL (v_offset_exp, 0) <> 0
         THEN
            UPDATE gicl_reserve_rids_xtr
               SET shr_exp_res_amt = shr_exp_res_amt + v_offset_exp,
                   shr_loss_res_amt = shr_loss_res_amt + v_offset_loss
             WHERE acct_tran_id = p_tran_id
               AND claim_id = resds.claim_id
               AND clm_res_hist_id = resds.clm_res_hist_id
               AND grp_seq_no = resds.grp_seq_no
               AND ri_cd = v_ri_cd;
         END IF;
      END LOOP;
   END;
END;
/


