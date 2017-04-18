CREATE OR REPLACE PACKAGE BODY CPI.gicls255_pkg
AS
   FUNCTION get_gicls255_clm_info_lov (
      p_module           VARCHAR2,
      p_line_cd          gicl_claims.line_cd%TYPE,
      p_subline_cd       gicl_claims.subline_cd%TYPE,
      p_clm_line_cd      gicl_claims.line_cd%TYPE,
      p_clm_subline_cd   gicl_claims.subline_cd%TYPE,
      p_iss_cd           gicl_claims.iss_cd%TYPE,
      p_pol_iss_cd       gicl_claims.iss_cd%TYPE,
      p_clm_yy           gicl_claims.issue_yy%TYPE,
      p_issue_yy         gicl_claims.issue_yy%TYPE,
      p_clm_seq_no       gicl_claims.clm_seq_no%TYPE,
      p_pol_seq_no       gicl_claims.clm_seq_no%TYPE,
      p_renew_no         gicl_claims.renew_no%TYPE,
      p_user_id          giis_users.user_id%TYPE
   )
      RETURN claims_info_tab PIPELINED
   IS
      v_claims   claims_info_type;
   BEGIN
      FOR gc IN (SELECT claim_id, line_cd, line_cd AS clm_line_cd,
                        subline_cd, subline_cd AS clm_subline_cd, iss_cd,
                        pol_iss_cd, clm_yy, issue_yy, clm_seq_no, pol_seq_no,
                        renew_no, assured_name, loss_date, loss_cat_cd,
                        clm_stat_cd
                   FROM gicl_claims a
                  WHERE a.line_cd =
                              NVL (NVL (p_line_cd, p_clm_line_cd), a.line_cd)
                    AND a.subline_cd =
                           NVL (NVL (p_subline_cd, p_clm_subline_cd),
                                a.subline_cd
                               )
                    AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                    AND a.clm_yy = NVL (p_clm_yy, a.clm_yy)
                    AND a.clm_seq_no = NVL (p_clm_seq_no, a.clm_seq_no)
                    AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd)
                    AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                    AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                    AND a.renew_no = NVL (p_renew_no, a.renew_no)
                    AND check_user_per_line2 (line_cd,
                                              pol_iss_cd,
                                              p_module,
                                              p_user_id
                                             ) = 1
                    AND check_user_per_iss_cd2 (line_cd,
                                                NULL,
                                                p_module,
                                                p_user_id
                                               ) = 1)
      LOOP
         v_claims.claim_id := gc.claim_id;
         v_claims.line_cd := gc.line_cd;
         v_claims.subline_cd := gc.subline_cd;
         v_claims.clm_line_cd := gc.clm_line_cd;
         v_claims.clm_subline_cd := gc.clm_subline_cd;
         v_claims.iss_cd := gc.iss_cd;
         v_claims.clm_yy := gc.clm_yy;
         v_claims.clm_seq_no := gc.clm_seq_no;
         v_claims.pol_iss_cd := gc.pol_iss_cd;
         v_claims.issue_yy := gc.issue_yy;
         v_claims.pol_seq_no := gc.pol_seq_no;
         v_claims.renew_no := gc.renew_no;
         v_claims.assured_name := gc.assured_name;
         v_claims.loss_date := gc.loss_date;

         FOR glc IN (SELECT loss_cat_des
                       FROM giis_loss_ctgry
                      WHERE loss_cat_cd = gc.loss_cat_cd
                        AND line_cd = gc.line_cd)
         LOOP
            v_claims.loss_cat := gc.loss_cat_cd || '-' || glc.loss_cat_des;
            EXIT;
         END LOOP;

         FOR gcs IN (SELECT clm_stat_desc
                       FROM giis_clm_stat
                      WHERE clm_stat_cd = gc.clm_stat_cd)
         LOOP
            v_claims.clm_stat_desc := gcs.clm_stat_desc;
            EXIT;
         END LOOP;

         PIPE ROW (v_claims);
      END LOOP;
   END;

   FUNCTION get_clm_reserve_info (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN reserve_info_tab PIPELINED
   IS
      v_res   reserve_info_type;
   BEGIN
      FOR x IN (SELECT a.*, b.line_cd
                  FROM gicl_clm_res_hist a, gicl_claims b
                 WHERE a.claim_id = p_claim_id
                   AND a.claim_id = b.claim_id
                   AND dist_sw = 'Y')
      LOOP
         v_res.claim_id := x.claim_id;
         v_res.clm_res_hist_id := x.clm_res_hist_id;
         v_res.item_no := x.item_no;
         v_res.grouped_item_no := x.grouped_item_no;
         v_res.peril_cd := x.peril_cd;
         v_res.loss_reserve := x.loss_reserve;
         v_res.expense_reserve := x.expense_reserve;

         BEGIN
            SELECT get_gpa_item_title (p_claim_id,
                                       x.line_cd,
                                       x.item_no,
                                       x.grouped_item_no
                                      )
              INTO v_res.item_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT get_peril_name (x.line_cd, x.peril_cd)
              INTO v_res.peril_name
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_res);
      END LOOP;
   END;

   FUNCTION get_reserve_ds (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_clm_res_hist_id   gicl_clm_res_hist.clm_res_hist_id%TYPE
   )
      RETURN reserve_ds_tab PIPELINED
   IS
      v_res_ds   reserve_ds_type;
   BEGIN
      FOR xd IN (SELECT a.*, b.trty_name
                   FROM gicl_reserve_ds a, giis_dist_share b
                  WHERE NVL (negate_tag, 'N') = 'N'
                    AND a.line_cd = b.line_cd
                    AND a.grp_seq_no = b.share_cd
                    AND a.clm_res_hist_id = p_clm_res_hist_id
                    AND claim_id = p_claim_id)
      LOOP
         v_res_ds.claim_id := xd.claim_id;
         v_res_ds.clm_res_hist_id := xd.clm_res_hist_id;
         v_res_ds.clm_dist_no := xd.clm_dist_no;
         v_res_ds.grp_seq_no := xd.grp_seq_no;
         v_res_ds.item_no := xd.item_no;
         v_res_ds.peril_cd := xd.peril_cd;
         v_res_ds.line_cd := xd.line_cd;
         v_res_ds.dist_year := xd.dist_year;
         v_res_ds.shr_pct := xd.shr_pct;
         v_res_ds.shr_loss_res_amt := xd.shr_loss_res_amt;
         v_res_ds.shr_exp_res_amt := xd.shr_exp_res_amt;
         v_res_ds.trty_name := xd.trty_name;
         
         PIPE ROW (v_res_ds);
      END LOOP;
   END;

   FUNCTION get_res_ds_ri (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_clm_res_hist_id   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      p_grp_seq_no        gicl_reserve_ds.grp_seq_no%TYPE,
      p_clm_dist_no       gicl_reserve_ds.clm_dist_no%TYPE
   )
      RETURN reserve_ri_tab PIPELINED
   IS
      v_ds_ri   reserve_ri_type;
   BEGIN
      FOR xdri IN (SELECT a.*, b.ri_sname
                     FROM gicl_reserve_rids a, giis_reinsurer b
                    WHERE a.ri_cd = b.ri_cd
                      AND clm_res_hist_id = p_clm_res_hist_id
                      AND grp_seq_no = p_grp_seq_no
                      AND clm_dist_no = p_clm_dist_no
                      AND claim_id = p_claim_id)
      LOOP
         v_ds_ri.claim_id := xdri.claim_id;
         v_ds_ri.clm_res_hist_id := xdri.clm_res_hist_id;
         v_ds_ri.clm_dist_no := xdri.clm_dist_no;
         v_ds_ri.grp_seq_no := xdri.grp_seq_no;
         v_ds_ri.line_cd := xdri.line_cd;
         v_ds_ri.ri_cd := xdri.ri_cd;
         v_ds_ri.dist_year := xdri.dist_year;
         v_ds_ri.ri_sname := xdri.ri_sname;
         v_ds_ri.shr_ri_pct := xdri.shr_ri_pct;
         v_ds_ri.shr_loss_ri_res_amt := xdri.shr_loss_ri_res_amt;
         v_ds_ri.shr_exp_ri_res_amt := xdri.shr_exp_ri_res_amt;
         
         PIPE ROW (v_ds_ri);
      END LOOP;
   END;

   FUNCTION get_clm_loss_exp_info (
      p_claim_id          gicl_claims.claim_id%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE
   )
      RETURN loss_exp_info_tab PIPELINED
   IS
      v_loss_exp   loss_exp_info_type;
   BEGIN
      FOR i IN (SELECT gcle.claim_id, gcle.clm_loss_id, gcle.item_no,
                       gcle.grouped_item_no, gcle.peril_cd, hist_seq_no,
                       item_stat_cd, dist_sw, paid_amt, net_amt, advise_amt,
                       gcle.payee_type, gcle.payee_cd, gcle.payee_class_cd
                  FROM gicl_clm_loss_exp gcle, gicl_loss_exp_payees glep
                 WHERE gcle.claim_id = glep.claim_id
                   AND gcle.item_no = glep.item_no
                   AND gcle.peril_cd = glep.peril_cd
                   AND gcle.payee_cd = glep.payee_cd
                   AND gcle.payee_type = glep.payee_type
                   AND gcle.payee_class_cd = glep.payee_class_cd
                   AND gcle.claim_id = p_claim_id)
      LOOP
         v_loss_exp.claim_id := i.claim_id;
         v_loss_exp.clm_loss_id := i.clm_loss_id;
         v_loss_exp.item_no := i.item_no;
         v_loss_exp.grouped_item_no := i.grouped_item_no;
         v_loss_exp.peril_cd := i.peril_cd;
         v_loss_exp.hist_seq_no := i.hist_seq_no;
         v_loss_exp.item_stat_cd := i.item_stat_cd;
         v_loss_exp.dist_sw := i.dist_sw;
         v_loss_exp.paid_amt := i.paid_amt;
         v_loss_exp.net_amt := i.net_amt;
         v_loss_exp.advise_amt := i.advise_amt;
         v_loss_exp.payee_type := i.payee_type;
         v_loss_exp.payee_cd := i.payee_cd;
         v_loss_exp.payee_class_cd := i.payee_class_cd;

         BEGIN
            SELECT DECODE (a.payee_first_name,
                           NULL, payee_last_name,
                              a.payee_last_name
                           || ', '
                           || a.payee_first_name
                           || ' '
                           || a.payee_middle_name
                          )
              INTO v_loss_exp.payee_name
              FROM giis_payees a
             WHERE a.payee_class_cd = i.payee_class_cd
               AND a.payee_no = i.payee_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT get_gpa_item_title (i.claim_id,
                                       p_line_cd,
                                       i.item_no,
                                       i.grouped_item_no
                                      )
              INTO v_loss_exp.item_title
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT get_peril_name (p_line_cd, i.peril_cd)
              INTO v_loss_exp.peril_name
              FROM DUAL;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_loss_exp);
      END LOOP;
   END;

   FUNCTION get_loss_exp_ds (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_clm_loss_id   gicl_loss_exp_ds.clm_loss_id%TYPE,
      p_item_no       gicl_loss_exp_ds.item_no%TYPE,
      p_peril_cd      gicl_loss_exp_ds.peril_cd%TYPE
   )
      RETURN loss_exp_ds_tab PIPELINED
   IS
      v_le_ds   loss_exp_ds_type;
   BEGIN
      FOR ids IN (SELECT a.*, b.trty_name
                    FROM gicl_loss_exp_ds a, giis_dist_share b
                   WHERE negate_tag <> 'Y'
                      OR     negate_tag IS NULL
                         AND a.line_cd = b.line_cd
                         AND a.grp_seq_no = b.share_cd
                         AND a.peril_cd = p_peril_cd
                         AND a.item_no = p_item_no
                         AND a.clm_loss_id = p_clm_loss_id
                         AND a.claim_id = p_claim_id)
      LOOP
         v_le_ds.claim_id := ids.claim_id;
         v_le_ds.clm_loss_id := ids.clm_loss_id;
         v_le_ds.item_no := ids.item_no;
         v_le_ds.peril_cd := ids.peril_cd;
         v_le_ds.grp_seq_no := ids.grp_seq_no;
         v_le_ds.clm_dist_no := ids.clm_dist_no;
         v_le_ds.dist_year := ids.dist_year;
         v_le_ds.line_cd := ids.line_cd;
         v_le_ds.trty_name := ids.trty_name;
         v_le_ds.acct_trty_type := ids.acct_trty_type;
         v_le_ds.share_type := ids.share_type;
         v_le_ds.shr_loss_exp_pct := ids.shr_loss_exp_pct;
         v_le_ds.shr_le_pd_amt := ids.shr_le_pd_amt;
         v_le_ds.shr_le_adv_amt := ids.shr_le_adv_amt;  
         v_le_ds.shr_le_net_amt := ids.shr_le_net_amt;
         v_le_ds.negate_tag := ids.negate_tag;
         
         PIPE ROW (v_le_ds);
      END LOOP;
      RETURN;
   END;

   FUNCTION get_le_ds_ri (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_clm_loss_id   gicl_loss_exp_rids.clm_loss_id%TYPE,
      p_grp_seq_no    gicl_reserve_ds.grp_seq_no%TYPE,
      p_clm_dist_no   gicl_reserve_ds.clm_dist_no%TYPE
   )
      RETURN le_ds_ri_tab PIPELINED
   IS
      v_le_ds_ri   le_ds_ri_type;
   BEGIN
      FOR idsri IN (SELECT a.*, b.ri_sname
                      FROM gicl_loss_exp_rids a, giis_reinsurer b
                     WHERE a.ri_cd = b.ri_cd
                       AND claim_id = p_claim_id
                       AND clm_loss_id = p_clm_loss_id
                       AND clm_dist_no = p_clm_dist_no
                       AND grp_seq_no = p_grp_seq_no)
      LOOP
         v_le_ds_ri.claim_id := idsri.claim_id;
         v_le_ds_ri.clm_loss_id := idsri.clm_loss_id;
         v_le_ds_ri.clm_dist_no := idsri.clm_dist_no;
         v_le_ds_ri.grp_seq_no := idsri.grp_seq_no;
         v_le_ds_ri.item_no := idsri.item_no;
         v_le_ds_ri.peril_cd := idsri.peril_cd;
         v_le_ds_ri.line_cd := idsri.line_cd;
         v_le_ds_ri.ri_cd := idsri.ri_cd;
         v_le_ds_ri.dist_year := idsri.dist_year;
         v_le_ds_ri.ri_sname := idsri.ri_sname;
         v_le_ds_ri.acct_trty_type := idsri.acct_trty_type;
         v_le_ds_ri.share_type := idsri.share_type;
         v_le_ds_ri.shr_loss_exp_ri_pct := idsri.shr_loss_exp_ri_pct;
         v_le_ds_ri.shr_le_ri_pd_amt := idsri.shr_le_ri_pd_amt;
         v_le_ds_ri.shr_le_ri_adv_amt := idsri.shr_le_ri_adv_amt;
         v_le_ds_ri.shr_le_ri_net_amt := idsri.shr_le_ri_net_amt;
         
         PIPE ROW (v_le_ds_ri);
      END LOOP;
      RETURN;
   END;
END;
/


