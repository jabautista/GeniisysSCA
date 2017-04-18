CREATE OR REPLACE PACKAGE BODY CPI.compare_itmperil_dist_pkg
AS
   PROCEDURE compare_itmperil_to_ds (
      p_par_id    IN       gipi_witmperl.par_id%TYPE,
      p_dist_no   IN       giuw_perilds_dtl.dist_no%TYPE,
      p_balance   OUT      VARCHAR2
   )
   IS
      v_wperilds       VARCHAR2 (1) := 'Y';
      v_witemperilds   VARCHAR2 (1) := 'Y';
      v_witemds        VARCHAR2 (1) := 'Y';
      v_wpolicyds      VARCHAR2 (1) := 'Y';
   BEGIN
      --compare gipi_witmperl and giuw_witemperilds
      FOR itmperl IN (SELECT   par_id, item_no, line_cd, peril_cd,
                               SUM (NVL (tsi_amt, 0)) tsi_amt,
                               SUM (NVL (prem_amt, 0)) prem_amt,
                               SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                          FROM gipi_witmperl
                         WHERE par_id = p_par_id
                      GROUP BY par_id, item_no, line_cd, peril_cd)
      LOOP
         FOR itmperlds IN (SELECT   dist_no, item_no, line_cd, peril_cd,
                                    SUM (NVL (tsi_amt, 0)) tsi_amt,
                                    SUM (NVL (prem_amt, 0)) prem_amt,
                                    SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                               FROM giuw_witemperilds
                              WHERE dist_no = p_dist_no
                                AND item_no = itmperl.item_no
                                AND peril_cd = itmperl.peril_cd
                                AND line_cd = itmperl.line_cd
                           GROUP BY dist_no, item_no, line_cd, peril_cd)
         LOOP
            IF    (itmperl.tsi_amt - itmperlds.tsi_amt) <> 0
               OR (itmperl.prem_amt - itmperlds.prem_amt) <> 0
               OR (itmperl.ann_tsi_amt - itmperlds.ann_tsi_amt) <> 0
            THEN
               v_witemperilds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_witemperilds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      --compare gipi_witmperl and giuw_wperilds
      FOR itmperl2 IN (SELECT   par_id, line_cd, peril_cd,
                                SUM (NVL (tsi_amt, 0)) tsi_amt,
                                SUM (NVL (prem_amt, 0)) prem_amt,
                                SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                           FROM gipi_witmperl
                          WHERE par_id = p_par_id
                       GROUP BY par_id, line_cd, peril_cd)
      LOOP
         FOR perlds IN (SELECT   dist_no, line_cd, peril_cd,
                                 SUM (NVL (tsi_amt, 0)) tsi_amt,
                                 SUM (NVL (prem_amt, 0)) prem_amt,
                                 SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                            FROM giuw_wperilds
                           WHERE dist_no = p_dist_no
                             AND peril_cd = itmperl2.peril_cd
                             AND line_cd = itmperl2.line_cd
                        GROUP BY dist_no, line_cd, peril_cd)
         LOOP
            IF    (itmperl2.tsi_amt - perlds.tsi_amt) <> 0
               OR (itmperl2.prem_amt - perlds.prem_amt) <> 0
               OR (itmperl2.ann_tsi_amt - perlds.ann_tsi_amt) <> 0
            THEN
               v_wperilds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_wperilds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      --compare gipi_witmperl and giuw_witemds
      FOR itmperl3 IN (SELECT   a.par_id, a.line_cd, a.item_no,
                                SUM (NVL (DECODE (b.peril_type,
                                                  'B', a.tsi_amt,
                                                  0
                                                 ),
                                          0
                                         )
                                    ) tsi_amt,
                                SUM (NVL (a.prem_amt, 0)) prem_amt,
                                SUM (NVL (DECODE (b.peril_type,
                                                  'B', a.ann_tsi_amt,
                                                  0
                                                 ),
                                          0
                                         )
                                    ) ann_tsi_amt
                           FROM gipi_witmperl a, giis_peril b
                          WHERE a.par_id = p_par_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                       GROUP BY a.par_id, a.line_cd, a.item_no)
      LOOP
         FOR itemds IN (SELECT   dist_no, item_no,
                                 SUM (NVL (tsi_amt, 0)) tsi_amt,
                                 SUM (NVL (prem_amt, 0)) prem_amt,
                                 SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                            FROM giuw_witemds
                           WHERE dist_no = p_dist_no
                             AND item_no = itmperl3.item_no
                        GROUP BY dist_no, item_no)
         LOOP
            IF    (itmperl3.tsi_amt - itemds.tsi_amt) <> 0
               OR (itmperl3.prem_amt - itemds.prem_amt) <> 0
               OR (itmperl3.ann_tsi_amt - itemds.ann_tsi_amt) <> 0
            THEN
               v_witemds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_witemds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      --compare gipi_witmperl and giuw_wpolicyds
      FOR itmperl4 IN (SELECT SUM (NVL (DECODE (b.peril_type,
                                                'B', a.tsi_amt,
                                                0
                                               ),
                                        0
                                       )
                                  ) tsi_amt,
                              SUM (NVL (a.prem_amt, 0)) prem_amt,
                              SUM (NVL (DECODE (b.peril_type,
                                                'B', a.ann_tsi_amt,
                                                0
                                               ),
                                        0
                                       )
                                  ) ann_tsi_amt
                         FROM gipi_witmperl a, giis_peril b
                        WHERE a.par_id = p_par_id
                          AND a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd)
      LOOP
         FOR polds IN (SELECT SUM (NVL (tsi_amt, 0)) tsi_amt,
                              SUM (NVL (prem_amt, 0)) prem_amt,
                              SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                         FROM giuw_wpolicyds
                        WHERE dist_no = p_dist_no)
         LOOP
            IF    (itmperl4.tsi_amt - polds.tsi_amt) <> 0
               OR (itmperl4.prem_amt - polds.prem_amt) <> 0
               OR (itmperl4.ann_tsi_amt - polds.ann_tsi_amt) <> 0
            THEN
               v_wpolicyds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_wpolicyds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      IF    v_wperilds = 'N'
         OR v_witemperilds = 'N'
         OR v_witemds = 'N'
         OR v_wpolicyds = 'N'
      THEN
         p_balance := 'N';
      ELSE
         p_balance := 'Y';
      END IF;
   END compare_itmperil_to_ds;

   PROCEDURE get_peril_type (
      p_line_cd      IN       giis_peril.line_cd%TYPE,
      p_peril_cd     IN       giis_peril.peril_cd%TYPE,
      p_peril_type   OUT      giis_peril.peril_type%TYPE
   )
   IS
      v_peril_type   giis_peril.peril_type%TYPE;
   BEGIN
      SELECT peril_type
        INTO v_peril_type
        FROM giis_peril
       WHERE line_cd = p_line_cd AND peril_cd = p_peril_cd;

      p_peril_type := v_peril_type;
   END get_peril_type;

   PROCEDURE get_expiry (
      p_line_cd    IN       giuw_wperilds_dtl.line_cd%TYPE,
      p_share_cd   IN       giuw_wperilds_dtl.share_cd%TYPE,
      p_par_id     IN       giuw_pol_dist.par_id%TYPE,
      p_treaty     OUT      VARCHAR2,
      p_expired    OUT      VARCHAR2
   )
   IS
      v_treaty_name      VARCHAR2 (100);
      v_share_type       giis_dist_share.share_type%TYPE;
      v_line_cd          gipi_polbasic.line_cd%TYPE;
      v_nbt_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd           gipi_polbasic.iss_cd%TYPE;
      v_nbt_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_nbt_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_nbt_renew_no     gipi_polbasic.renew_no%TYPE;
      v_expired          VARCHAR2 (1) := 'N';
      v_policy_id        gipi_polbasic.POLICY_ID%TYPE := NULL;
   BEGIN
      /*SELECT trty_name, share_type    commented out by Gzelle 06272014 replaced with codes below as per latest modification
        INTO v_treaty_name, v_share_type
        FROM giis_dist_share
       WHERE line_cd = p_line_cd AND share_cd = p_share_cd;

        FOR b IN (SELECT policy_id
                  FROM gipi_polbasic
                 WHERE par_id = p_par_id)
        LOOP
            v_policy_id :=  b.policy_id;               
        END LOOP;

        IF v_policy_id IS NOT NULL THEN
            FOR i IN (SELECT a.trty_cd, a.trty_name, a.trty_yy, a.line_cd, a.share_cd,
                           a.share_type, a.eff_date, a.expiry_date
                      FROM giis_dist_share a, gipi_polbasic b
                     WHERE a.line_cd = p_line_cd
                       AND a.share_cd = p_share_cd
                       AND a.share_type = '2'
                       AND b.par_id = p_par_id
                       AND TRUNC(DECODE(NVL (prtfolio_sw, 'N'), 'N',b.incept_date, 'P',b.eff_date)) BETWEEN TRUNC(a.eff_date) AND TRUNC(a.expiry_date))
            LOOP
             v_expired := 'N';
            END LOOP;               
        ELSE    
            FOR i IN (SELECT a.trty_cd, a.trty_name, a.trty_yy, a.line_cd, a.share_cd,
                           a.share_type, a.eff_date, a.expiry_date
                      FROM giis_dist_share a, gipi_wpolbas b, gipi_parlist c
                     WHERE a.line_cd = p_line_cd
                       AND a.share_cd = p_share_cd
                       AND a.share_type = '2'
                       AND b.par_id = c.par_id
                       AND b.par_id = p_par_id
                       AND TRUNC(DECODE(NVL (prtfolio_sw, 'N'), 'N',b.incept_date, 'P',b.eff_date)) BETWEEN TRUNC(a.eff_date) AND TRUNC(a.expiry_date))
            LOOP
             v_expired := 'N';
            END LOOP;
        END IF;
      
      IF v_share_type <> '2' THEN
        v_expired := 'N';
      END IF;*/
      
        BEGIN
           SELECT trty_name, share_type
             INTO v_treaty_name, v_share_type
             FROM giis_dist_share
            WHERE line_cd = p_line_cd 
              AND share_cd = p_share_cd;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_treaty_name   := NULL;
            v_share_type    := NULL;
        END;
    
        BEGIN
            SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
             INTO v_line_cd, v_nbt_subline_cd, v_iss_cd, v_nbt_issue_yy, v_nbt_pol_seq_no, v_nbt_renew_no
             FROM gipi_wpolbas
            WHERE par_id = p_par_id;
        EXCEPTION WHEN NO_DATA_FOUND THEN
            v_line_cd           := NULL; 
            v_nbt_subline_cd    := NULL; 
            v_iss_cd            := NULL; 
            v_nbt_issue_yy      := NULL; 
            v_nbt_pol_seq_no    := NULL;
            v_nbt_renew_no      := NULL;
        END;

       FOR b IN (SELECT policy_id, line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
                   FROM gipi_polbasic
                  WHERE par_id = p_par_id)
       LOOP
          v_policy_id       := b.policy_id;
          v_line_cd         := b.line_cd;
          v_nbt_subline_cd  := b.subline_cd;
          v_iss_cd          := b.iss_cd;
          v_nbt_issue_yy    := b.issue_yy;
          v_nbt_pol_seq_no  := b.pol_seq_no;
          v_nbt_renew_no    := b.renew_no;
       END LOOP;

       IF v_policy_id IS NOT NULL THEN                                                                                                                                                       --outer modules
          FOR i IN (SELECT trty_cd, trty_name, trty_yy, a.line_cd, a.share_cd, a.share_type, a.eff_date, a.expiry_date
                      FROM giis_dist_share a, gipi_polbasic b, gipi_parlist c
                     WHERE a.line_cd = p_line_cd
                       AND a.share_cd = p_share_cd
                       AND a.share_type = '2'
                       AND b.par_id = c.par_id
                       AND b.policy_id = v_policy_id
                       AND (NVL (prtfolio_sw, 'N') = 'N' OR (NVL (prtfolio_sw, 'N') = 'P' AND TRUNC (a.expiry_date) < TRUNC (b.eff_date)))
                       AND (   NVL (prtfolio_sw, 'N') = 'P'
                            OR (NVL (prtfolio_sw, 'N') = 'N' AND c.par_type = 'P' AND TRUNC (a.expiry_date) < TRUNC (b.incept_date))
                            OR (    NVL (prtfolio_sw, 'N') = 'N'
                                AND c.par_type = 'E'
                                AND TRUNC (a.expiry_date) < TRUNC (b.incept_date)
                                AND NOT EXISTS (
                                       SELECT '1'
                                         FROM giis_dist_share a, giuw_policyds_dtl b, gipi_polbasic c, giuw_pol_dist d
                                        WHERE c.policy_id = d.policy_id
                                          AND b.dist_no = d.dist_no
                                          AND a.line_cd = c.line_cd
                                          AND a.line_cd = b.line_cd
                                          AND a.share_cd = b.share_cd
                                          AND share_type = '2'
                                          AND NVL (a.prtfolio_sw, 'N') = 'N'
                                          AND c.line_cd = v_line_cd
                                          AND c.subline_cd = v_nbt_subline_cd
                                          AND c.iss_cd = v_iss_cd
                                          AND c.issue_yy = v_nbt_issue_yy
                                          AND c.pol_seq_no = v_nbt_pol_seq_no
                                          AND c.renew_no = v_nbt_renew_no
                                          AND c.endt_seq_no = 0
                                          AND a.trty_name = v_treaty_name)
                               )
                           ))
          LOOP
             v_expired := 'Y';
          END LOOP;
       ELSE                                                                                                                                                                                  --inner modules
          FOR i IN (SELECT trty_cd, trty_name, trty_yy, a.line_cd, a.share_cd, a.share_type, a.eff_date, a.expiry_date
                      FROM giis_dist_share a, gipi_wpolbas b, gipi_parlist c
                     WHERE a.line_cd = p_line_cd
                       AND a.share_cd = p_share_cd
                       AND a.share_type = '2'
                       AND b.par_id = c.par_id
                       AND b.par_id = p_par_id
                       AND (NVL (prtfolio_sw, 'N') = 'N' OR (NVL (prtfolio_sw, 'N') = 'P' AND TRUNC (a.expiry_date) < TRUNC (b.eff_date)))
                       AND (   NVL (prtfolio_sw, 'N') = 'P'
                            OR (NVL (prtfolio_sw, 'N') = 'N' AND c.par_type = 'P' AND TRUNC (a.expiry_date) < TRUNC (b.incept_date))
                            OR (    NVL (prtfolio_sw, 'N') = 'N'
                                AND c.par_type = 'E'
                                AND TRUNC (a.expiry_date) < TRUNC (b.incept_date)
                                AND NOT EXISTS (
                                       SELECT '1'
                                         FROM giis_dist_share a, giuw_policyds_dtl b, gipi_polbasic c, giuw_pol_dist d
                                        WHERE c.policy_id = d.policy_id
                                          AND b.dist_no = d.dist_no
                                          AND a.line_cd = c.line_cd
                                          AND a.line_cd = b.line_cd
                                          AND a.share_cd = b.share_cd
                                          AND share_type = '2'
                                          AND NVL (a.prtfolio_sw, 'N') = 'N'
                                          AND c.line_cd = v_line_cd
                                          AND c.subline_cd = v_nbt_subline_cd
                                          AND c.iss_cd = v_iss_cd
                                          AND c.issue_yy = v_nbt_issue_yy
                                          AND c.pol_seq_no = v_nbt_pol_seq_no
                                          AND c.renew_no = v_nbt_renew_no
                                          AND c.endt_seq_no = 0
                                          AND a.trty_name = v_treaty_name)
                               )
                           ))
          LOOP
             v_expired := 'Y';
          END LOOP;
       END IF;     
      p_expired := v_expired;
      p_treaty  := v_treaty_name;
   END get_expiry;

   PROCEDURE compare_recompute_dist (
      p_dist_no     IN       giuw_pol_dist.dist_no%TYPE,
      p_msg_alert   OUT      VARCHAR2
   )
   IS
      v_dist_no     giuw_pol_dist.dist_no%TYPE;
      v_msg_alert   VARCHAR2 (100);
      v_msg_type    VARCHAR2 (1);
      v_error       BOOLEAN;
      v_cnt         NUMBER                       := 0;
   BEGIN
      v_dist_no := p_dist_no;

      LOOP
         v_cnt := v_cnt + 1;
         cmpare_amts_wrking_tbls.wperilds_vs_wperilds_dtl (v_dist_no,
                                                                 v_msg_alert,
                                                                 v_msg_type,
                                                                 v_error
                                                                );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.witmprilds_vs_witmprilds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.witmprilds_dtl_vs_wprilds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.witemds_vs_witemds_dtl (v_dist_no,
                                                               v_msg_alert,
                                                               v_msg_type,
                                                               v_error
                                                              );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.witmprilds_dtl_vs_witemds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.wpolicyds_vs_wpolicyds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.wpolcyds_dtl_vs_wperilds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.witmprlds_dtl_vs_wplicyds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         cmpare_amts_wrking_tbls.wpolicyds_dtl_vs_witemds_dtl
                                                                 (v_dist_no,
                                                                  v_msg_alert,
                                                                  v_msg_type,
                                                                  v_error
                                                                 );

         IF     v_msg_alert IS NOT NULL
            AND v_msg_type IS NOT NULL
            AND v_error IS NOT NULL
         THEN
            recompute_dist_peril_pkg.recompute_dtl_tables (v_dist_no);
            adjust_distribution_peril_pkg.adjust_distribution (v_dist_no);
            EXIT;
         END IF;

         EXIT WHEN v_cnt >= 1;
      END LOOP;
      COMMIT;
   END compare_recompute_dist;

   PROCEDURE get_takeup_term (
      p_par_id        IN       gipi_parlist.par_id%TYPE,
      p_takeup_term   OUT      gipi_wpolbas.takeup_term%TYPE
   )
   IS
      v_par_id        gipi_parlist.par_id%TYPE;
      v_pack_par_id   gipi_parlist.par_id%TYPE;
   BEGIN
      SELECT par_id, pack_par_id
        INTO v_par_id, v_pack_par_id
        FROM gipi_parlist
       WHERE par_id = p_par_id;

      IF v_pack_par_id IS NOT NULL
      THEN
         SELECT takeup_term
           INTO p_takeup_term
           FROM gipi_pack_wpolbas
          WHERE pack_par_id = v_pack_par_id;
          
         --added by apollo cruz 6.30.2014
         IF p_takeup_term IS NULL THEN
            SELECT takeup_term
              INTO p_takeup_term
              FROM gipi_wpolbas
             WHERE par_id = v_par_id;
         END IF;    
      ELSE
         SELECT takeup_term
           INTO p_takeup_term
           FROM gipi_wpolbas
          WHERE par_id = v_par_id;
      END IF;
   END get_takeup_term;

   PROCEDURE get_policy_takeup (
      p_policy_id     IN       gipi_polbasic.policy_id%TYPE,
      p_takeup_term   OUT      gipi_wpolbas.takeup_term%TYPE
   )
   IS
      v_policy_id        gipi_polbasic.policy_id%TYPE;
      v_pack_policy_id   gipi_polbasic.policy_id%TYPE;
   BEGIN
      SELECT policy_id, pack_policy_id
        INTO v_policy_id, v_pack_policy_id
        FROM gipi_polbasic
       WHERE policy_id = p_policy_id;

      IF v_pack_policy_id IS NOT NULL
      THEN
         SELECT takeup_term
           INTO p_takeup_term
           FROM gipi_pack_polbasic
          WHERE pack_policy_id = v_pack_policy_id;
          
         IF p_takeup_term IS NULL THEN
            SELECT takeup_term
              INTO p_takeup_term
              FROM gipi_polbasic
             WHERE policy_id = v_policy_id;
         END IF;
      ELSE
         SELECT takeup_term
           INTO p_takeup_term
           FROM gipi_polbasic
          WHERE policy_id = v_policy_id;
      END IF;
   END get_policy_takeup;

   PROCEDURE compare_pol_itmperil_to_ds (
      p_policy_id   IN       gipi_polbasic.policy_id%TYPE,
      p_dist_no     IN       giuw_perilds_dtl.dist_no%TYPE,
      p_balance     OUT      VARCHAR2
   )
   IS
      v_wperilds       VARCHAR2 (1) := 'Y';
      v_witemperilds   VARCHAR2 (1) := 'Y';
      v_witemds        VARCHAR2 (1) := 'Y';
      v_wpolicyds      VARCHAR2 (1) := 'Y';
   BEGIN
      --compare gipi_witmperl and giuw_witemperilds
      FOR itmperl IN (SELECT   policy_id, item_no, line_cd, peril_cd,
                               SUM (NVL (tsi_amt, 0)) tsi_amt,
                               SUM (NVL (prem_amt, 0)) prem_amt,
                               SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                          FROM gipi_itmperil
                         WHERE policy_id = p_policy_id
                      GROUP BY policy_id, item_no, line_cd, peril_cd)
      LOOP
         FOR itmperlds IN (SELECT   dist_no, item_no, line_cd, peril_cd,
                                    SUM (NVL (tsi_amt, 0)) tsi_amt,
                                    SUM (NVL (prem_amt, 0)) prem_amt,
                                    SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                               FROM giuw_witemperilds
                              WHERE dist_no = p_dist_no
                                AND item_no = itmperl.item_no
                                AND peril_cd = itmperl.peril_cd
                                AND line_cd = itmperl.line_cd
                           GROUP BY dist_no, item_no, line_cd, peril_cd)
         LOOP
            IF    (itmperl.tsi_amt - itmperlds.tsi_amt) <> 0
               OR (itmperl.prem_amt - itmperlds.prem_amt) <> 0
               OR (itmperl.ann_tsi_amt - itmperlds.ann_tsi_amt) <> 0
            THEN
               v_witemperilds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_witemperilds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      --compare gipi_witmperl and giuw_wperilds
      FOR itmperl2 IN (SELECT   policy_id, line_cd, peril_cd,
                                SUM (NVL (tsi_amt, 0)) tsi_amt,
                                SUM (NVL (prem_amt, 0)) prem_amt,
                                SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                           FROM gipi_itmperil
                          WHERE policy_id = p_policy_id
                       GROUP BY policy_id, line_cd, peril_cd)
      LOOP
         FOR perlds IN (SELECT   dist_no, line_cd, peril_cd,
                                 SUM (NVL (tsi_amt, 0)) tsi_amt,
                                 SUM (NVL (prem_amt, 0)) prem_amt,
                                 SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                            FROM giuw_wperilds
                           WHERE dist_no = p_dist_no
                             AND peril_cd = itmperl2.peril_cd
                             AND line_cd = itmperl2.line_cd
                        GROUP BY dist_no, line_cd, peril_cd)
         LOOP
            IF    (itmperl2.tsi_amt - perlds.tsi_amt) <> 0
               OR (itmperl2.prem_amt - perlds.prem_amt) <> 0
               OR (itmperl2.ann_tsi_amt - perlds.ann_tsi_amt) <> 0
            THEN
               v_wperilds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_wperilds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      --compare gipi_witmperl and giuw_witemds
      FOR itmperl3 IN (SELECT   a.policy_id, a.line_cd, a.item_no,
                                SUM (NVL (DECODE (b.peril_type,
                                                  'B', a.tsi_amt,
                                                  0
                                                 ),
                                          0
                                         )
                                    ) tsi_amt,
                                SUM (NVL (a.prem_amt, 0)) prem_amt,
                                SUM (NVL (DECODE (b.peril_type,
                                                  'B', a.ann_tsi_amt,
                                                  0
                                                 ),
                                          0
                                         )
                                    ) ann_tsi_amt
                           FROM gipi_itmperil a, giis_peril b
                          WHERE a.policy_id = p_policy_id
                            AND a.line_cd = b.line_cd
                            AND a.peril_cd = b.peril_cd
                       GROUP BY a.policy_id, a.line_cd, a.item_no)
      LOOP
         FOR itemds IN (SELECT   dist_no, item_no,
                                 SUM (NVL (tsi_amt, 0)) tsi_amt,
                                 SUM (NVL (prem_amt, 0)) prem_amt,
                                 SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                            FROM giuw_witemds
                           WHERE dist_no = p_dist_no
                             AND item_no = itmperl3.item_no
                        GROUP BY dist_no, item_no)
         LOOP
            IF    (itmperl3.tsi_amt - itemds.tsi_amt) <> 0
               OR (itmperl3.prem_amt - itemds.prem_amt) <> 0
               OR (itmperl3.ann_tsi_amt - itemds.ann_tsi_amt) <> 0
            THEN
               v_witemds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_witemds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      --compare gipi_witmperl and giuw_wpolicyds
      FOR itmperl4 IN (SELECT SUM (NVL (DECODE (b.peril_type,
                                                'B', a.tsi_amt,
                                                0
                                               ),
                                        0
                                       )
                                  ) tsi_amt,
                              SUM (NVL (a.prem_amt, 0)) prem_amt,
                              SUM (NVL (DECODE (b.peril_type,
                                                'B', a.ann_tsi_amt,
                                                0
                                               ),
                                        0
                                       )
                                  ) ann_tsi_amt
                         FROM gipi_itmperil a, giis_peril b
                        WHERE a.policy_id = p_policy_id
                          AND a.line_cd = b.line_cd
                          AND a.peril_cd = b.peril_cd)
      LOOP
         FOR polds IN (SELECT SUM (NVL (tsi_amt, 0)) tsi_amt,
                              SUM (NVL (prem_amt, 0)) prem_amt,
                              SUM (NVL (ann_tsi_amt, 0)) ann_tsi_amt
                         FROM giuw_wpolicyds
                        WHERE dist_no = p_dist_no)
         LOOP
            IF    (itmperl4.tsi_amt - polds.tsi_amt) <> 0
               OR (itmperl4.prem_amt - polds.prem_amt) <> 0
               OR (itmperl4.ann_tsi_amt - polds.ann_tsi_amt) <> 0
            THEN
               v_wpolicyds := 'N';
               EXIT;
            END IF;
         END LOOP;

         IF v_wpolicyds = 'N'
         THEN
            EXIT;
         END IF;
      END LOOP;

      IF    v_wperilds = 'N'
         OR v_witemperilds = 'N'
         OR v_witemds = 'N'
         OR v_wpolicyds = 'N'
      THEN
         p_balance := 'N';
      ELSE
         p_balance := 'Y';
      END IF;
   END compare_pol_itmperil_to_ds;
END compare_itmperil_dist_pkg;
/


