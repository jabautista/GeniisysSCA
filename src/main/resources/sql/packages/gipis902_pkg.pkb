CREATE OR REPLACE PACKAGE BODY CPI.gipis902_pkg
AS
   FUNCTION get_gipi_risk_loss_profile (p_user_id VARCHAR2)
      RETURN gipi_risk_loss_profile_tab PIPELINED
   IS
      v gipi_risk_loss_profile_type;
   BEGIN
      FOR i IN (SELECT COUNT(*) no_of_range, a.line_cd, b.line_name, a.subline_cd, c.subline_name,
                       a.cred_branch, a.all_line_tag, d.iss_name, a.date_from, a.date_to,
                       a.loss_date_from, a.loss_date_to
                       FROM gipi_risk_loss_profile a, giis_line b,
                            giis_subline c, giis_issource d
                      WHERE a.line_cd = b.line_cd (+)
                        AND a.line_cd = c.line_cd (+)
                        AND a.subline_cd = c.subline_cd (+)
                        AND a.cred_branch = d.iss_cd (+)
                        AND a.user_id = p_user_id
                        AND check_user_per_line2(a.line_cd, NULL, 'GIPIS902', p_user_id) = 1
                   GROUP BY a.line_cd, b.line_name, a.subline_cd, c.subline_name,
                            a.cred_branch, a.all_line_tag, d.iss_name, a.date_from, a.date_to,
                            a.loss_date_from, a.loss_date_to)
      LOOP
         v.line_cd := i.line_cd;
         v.line_name := i.line_name;
         v.subline_cd := i.subline_cd;
         v.subline_name := i.subline_name;
         v.cred_branch := i.cred_branch;
         v.iss_name := i.iss_name;
         v.all_line_tag := i.all_line_tag;
         v.date_from := TO_CHAR(i.date_from, 'mm-dd-yyyy');
         v.date_to := TO_CHAR(i.date_to, 'mm-dd-yyyy');
         v.loss_date_from := TO_CHAR(i.loss_date_from, 'mm-dd-yyyy');
         v.loss_date_to := TO_CHAR(i.loss_date_to, 'mm-dd-yyyy');
         v.no_of_range := i.no_of_range;
         
         PIPE ROW(v);
      END LOOP;
   END get_gipi_risk_loss_profile;
   
   
   FUNCTION get_risk_loss_profile_range (
      p_line_cd VARCHAR2,
      p_subline_cd VARCHAR2,
      p_user_id VARCHAR2
   )
      RETURN risk_loss_profile_range_tab PIPELINED
   IS
      v risk_loss_profile_range_type;
   BEGIN
      FOR i IN (SELECT range_from, range_to
                  FROM gipi_risk_loss_profile
                 WHERE line_cd = p_line_cd
                   AND (subline_cd = p_subline_cd or (subline_cd IS NULL AND p_subline_cd IS NULL))
                   AND user_id = p_user_id --uncommented by robert
              ORDER BY 1
                   )
      LOOP
         v.range_from := i.range_from;
         v.range_to := i.range_to;
         PIPE ROW(v);
      END LOOP;
   END get_risk_loss_profile_range;   
   
   FUNCTION get_line_lov (p_user_id VARCHAR2)
      RETURN line_lov_tab PIPELINED
   IS
      v line_lov_type;
   BEGIN
      FOR i IN (SELECT line_name, line_cd
                  FROM giis_line
                 WHERE check_user_per_iss_cd2(line_cd, NULL, 'GIPIS902',p_user_id) = 1
              ORDER BY line_cd, line_name)
      LOOP
         v.line_cd := i.line_cd;
         v.line_name := i.line_name;
         PIPE ROW(v);
      END LOOP;
   END get_line_lov;
   
   FUNCTION get_subline_lov (p_user_id VARCHAR2, p_line_cd VARCHAR2)
      RETURN subline_lov_tab PIPELINED
   IS
      v subline_lov_type;
   BEGIN
      FOR i IN ( SELECT a.subline_name, a.subline_cd, a.line_cd, b.line_name
                   FROM giis_subline a, giis_line b
                  WHERE a.line_cd = NVL (p_line_cd, a.line_cd)
                    AND a.line_cd = b.line_cd
                    AND check_user_per_iss_cd2 (a.line_cd, NULL, 'GIPIS902', p_user_id) = 1
               ORDER BY a.subline_cd, a.subline_name)
      LOOP
         v.subline_cd := i.subline_cd;
         v.subline_name := i.subline_name;
         v.line_cd := i.line_cd;
         v.line_name := i.line_name;
         
         PIPE ROW(v);
      END LOOP;
   END get_subline_lov;
   
   FUNCTION get_iss_lov (p_user_id VARCHAR2)
      RETURN iss_lov_tab PIPELINED
   IS
      v iss_lov_type;
   BEGIN
      FOR i IN (SELECT iss_cd, iss_name
                  FROM giis_issource
                 WHERE check_user_per_iss_cd2 (NULL, iss_cd, 'GIPIS902', p_user_id) = 1)
      LOOP
         v.iss_cd := i.iss_cd;
         v.iss_name := i.iss_name;
         
         PIPE ROW(v);
      END LOOP;
   END get_iss_lov;
   
   PROCEDURE delete (
      p_line_cd VARCHAR2,
      p_subline_cd VARCHAR2,
      p_all_line_tag VARCHAR2,
      p_type VARCHAR2,
      p_user_id VARCHAR2
   )
   IS
      v_subline_cd VARCHAR2(7);
   BEGIN
      v_subline_cd := p_subline_cd;
      IF UPPER(v_subline_cd) = 'NULL' THEN
         v_subline_cd := NULL;
      END IF;
      
      
   
      --raise_application_error(-20001, 'Geniisys Exception#E#pol test - ' || p_line_cd || ' - ' || v_subline_cd || ' - ' || p_user_id);
      DELETE FROM gipi_risk_loss_profile
       WHERE line_cd    = p_line_cd
         AND (subline_cd = v_subline_cd or (subline_cd IS NULL AND v_subline_cd IS NULL))
         AND user_id = p_user_id;
         
      DELETE FROM gicl_risk_loss_profile
       WHERE line_cd    = p_line_cd
         AND (subline_cd = v_subline_cd or (subline_cd IS NULL AND v_subline_cd IS NULL))
         AND user_id = p_user_id;
         
      IF p_all_line_tag = 'R' THEN
         DELETE FROM gipi_risk_loss_profile_item
          WHERE line_cd    = p_line_cd
            AND (subline_cd = v_subline_cd or (subline_cd IS NULL AND v_subline_cd IS NULL))
            AND user_id = p_user_id;
      END IF;
      
      IF p_type = 'UPDATE' THEN
         DELETE FROM gicl_loss_profile
          WHERE line_cd = p_line_cd
            AND (subline_cd = v_subline_cd or (subline_cd IS NULL AND v_subline_cd IS NULL))
            AND user_id = p_user_id;
      END IF;         
   END;
   
   PROCEDURE update_profile (
      p_line_cd VARCHAR2,
      p_subline_cd VARCHAR2,
      p_user_id VARCHAR2,
      p_date_from VARCHAR2,
      p_date_to VARCHAR2,
      p_loss_date_from VARCHAR2,
      p_loss_date_to VARCHAR2,
      p_all_line_tag VARCHAR2,
      p_cred_branch VARCHAR2
   )
   IS
      v_date_from DATE;
      v_date_to DATE;
      v_loss_date_from DATE;
      v_loss_date_to DATE;   
   BEGIN
   
      BEGIN
         SELECT TRUNC(date_from), TRUNC(date_to),
                TRUNC(loss_date_from), TRUNC(loss_date_to)
           INTO v_date_from, v_date_to,
                v_loss_date_from, v_loss_date_to     
           FROM gipi_risk_loss_profile
          WHERE line_cd = p_line_cd
            AND (subline_cd = p_subline_cd OR (subline_cd IS NULL AND p_subline_cd IS NULL))
            AND (cred_branch = p_cred_branch OR (cred_branch IS NULL AND p_cred_branch IS NULL))
            AND user_id = p_user_id
            AND ROWNUM = 1;    
      END;
   
      IF v_date_from <> TO_DATE(p_date_from, 'mm-dd-yyyy')
         OR v_date_to <> TO_DATE(p_date_to, 'mm-dd-yyyy')
         OR v_loss_date_from <> TO_DATE(p_loss_date_from, 'mm-dd-yyyy')
         OR v_loss_date_to <> TO_DATE(p_loss_date_to, 'mm-dd-yyyy')
      
       THEN
         UPDATE gicl_loss_profile
            SET date_from = to_date(p_date_from, 'mm-dd-yyyy'),
                date_to = to_date(p_date_to, 'mm-dd-yyyy'),
                loss_date_from = to_date(p_loss_date_from, 'mm-dd-yyyy'),
                loss_date_to = to_date(p_loss_date_to, 'mm-dd-yyyy')
           WHERE line_cd = p_line_cd;   
      END IF;
   
      UPDATE gipi_risk_loss_profile
         SET user_id = p_user_id,
             date_from = TO_DATE(p_date_from, 'mm-dd-yyyy'),
             date_to = TO_DATE(p_date_to, 'mm-dd-yyyy'),
             loss_date_from = TO_DATE(p_loss_date_from, 'mm-dd-yyyy'),
             loss_date_to = TO_DATE(p_loss_date_to, 'mm-dd-yyyy'),
             all_line_tag = p_all_line_tag,
             cred_branch = p_cred_branch
       WHERE line_cd = p_line_cd
         AND (subline_cd = p_subline_cd or (subline_cd IS NULL AND p_subline_cd IS NULL));
         
      UPDATE gicl_risk_loss_profile
         SET user_id = p_user_id,
             date_from = TO_DATE(p_date_from, 'mm-dd-yyyy'),
             date_to = TO_DATE(p_date_to, 'mm-dd-yyyy'),
             loss_date_from = TO_DATE(p_loss_date_from, 'mm-dd-yyyy'),
             loss_date_to = TO_DATE(p_loss_date_to, 'mm-dd-yyyy'),
             all_line_tag = p_all_line_tag
             --cred_branch = p_cred_branch
       WHERE line_cd = p_line_cd
         AND (subline_cd = p_subline_cd or (subline_cd IS NULL AND p_subline_cd IS NULL));
         
      IF p_all_line_tag = 'R' THEN
         DELETE FROM gipi_risk_loss_profile_item
          WHERE line_cd    = p_line_cd
            AND (subline_cd = p_subline_cd or (subline_cd IS NULL AND p_subline_cd IS NULL));
            
         FOR i IN (SELECT *
                     FROM gipi_risk_loss_profile
                     WHERE line_cd = p_line_cd
                       AND (subline_cd = p_subline_cd or (subline_cd IS NULL AND p_subline_cd IS NULL)))
         LOOP
            INSERT INTO gipi_risk_loss_profile_item
                   (line_cd, subline_cd, user_id, range_from,
                    range_to, policy_count, net_retention, quota_share, treaty,
                    facultative, date_from, date_to,
                    loss_date_from,
                    loss_date_to,
                    all_line_tag, cred_branch
                   )
            VALUES (i.line_cd, i.subline_cd, i.user_id, i.range_from,
                    i.range_to, 0, 0, 0, 0,
                    0, i.date_from, i.date_to,
                    i.loss_date_from,
                    i.loss_date_to,
                    i.all_line_tag, i.cred_branch
                   );
         END LOOP;
            
      END IF;                  
         
   END update_profile;
   
   PROCEDURE save_profile (
      p_line_cd VARCHAR2,
      p_subline_cd VARCHAR2,
      p_user_id VARCHAR2,
      p_range_from VARCHAR2,
      p_range_to VARCHAR2,
      p_date_from VARCHAR2,
      p_date_to VARCHAR2,
      p_loss_date_from VARCHAR2,
      p_loss_date_to VARCHAR2,
      p_all_line_tag VARCHAR2,
      p_cred_branch VARCHAR2
   )
   IS
   BEGIN
      
      FOR i IN (SELECT line_cd
                  FROM giis_line
                 WHERE line_cd LIKE NVL(p_line_cd, '%'))
      LOOP
         INSERT INTO gipi_risk_loss_profile
                (line_cd, subline_cd, user_id, range_from,
                 range_to, policy_count, net_retention, quota_share, treaty,
                 facultative, date_from, date_to,
                 loss_date_from,
                 loss_date_to,
                 all_line_tag, cred_branch
                )                                      
         VALUES (i.line_cd, p_subline_cd, p_user_id, p_range_from,
                 p_range_to, 0, 0, 0, 0,
                 0, TO_DATE(p_date_from, 'mm-dd-yyyy'),TO_DATE(p_date_to, 'mm-dd-yyyy'),
                 TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), TO_DATE(p_loss_date_to, 'mm-dd-yyyy'),              
                 p_all_line_tag, p_cred_branch
                );
                
         INSERT INTO gicl_risk_loss_profile
                (line_cd, subline_cd, user_id, range_from,
                 range_to, policy_count, net_retention, quota_share, treaty,
                 facultative, date_from, date_to,
                 loss_date_from,
                 loss_date_to,
                 all_line_tag
                )
         VALUES (i.line_cd, p_subline_cd, p_user_id, p_range_from,
                 p_range_to, 0, 0, 0, 0,
                 0, TO_DATE(p_date_from, 'mm-dd-yyyy'),TO_DATE(p_date_to, 'mm-dd-yyyy'),
                 TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), TO_DATE(p_loss_date_to, 'mm-dd-yyyy'),              
                 p_all_line_tag
                );
                
         IF p_all_line_tag = 'R' THEN
            INSERT INTO gipi_risk_loss_profile_item
                   (line_cd, subline_cd, user_id, range_from,
                    range_to, policy_count, net_retention, quota_share, treaty,
                    facultative, date_from, date_to,
                    loss_date_from,
                    loss_date_to,
                    all_line_tag, cred_branch
                   )
            VALUES (i.line_cd, p_subline_cd, p_user_id, p_range_from,
                    p_range_to, 0, 0, 0, 0,
                    0, TO_DATE(p_date_from, 'mm-dd-yyyy'),TO_DATE(p_date_to, 'mm-dd-yyyy'),
                    TO_DATE(p_loss_date_from, 'mm-dd-yyyy'), TO_DATE(p_loss_date_to, 'mm-dd-yyyy'),
                    p_all_line_tag, p_cred_branch
                   );
         END IF;                
                
      END LOOP;                      
   END save_profile;
   
--   PROCEDURE update_gicl_loss_profile (
--      p_line_cd         VARCHAR2,
--      p_date_from       VARCHAR2,
--      p_date_to         VARCHAR2,
--      p_loss_date_from  VARCHAR2,
--      p_loss_date_to    VARCHAR2
--   )
--   IS
--   BEGIN
--      UPDATE gicl_loss_profile
--        SET date_from = TO_DATE(p_date_from, 'mm-dd-yyyy'),
--            date_to = TO_DATE(p_date_to, 'mm-dd-yyyy'),
--            loss_date_from = TO_DATE(p_loss_date_from, 'mm-dd-yyyy'),
--            loss_date_to = TO_DATE(p_loss_date_to, 'mm-dd-yyyy')
--      WHERE line_cd = p_line_cd;  
--   END update_gicl_loss_profile;

   PROCEDURE loss_profile_extract_loss_amt (
      p_pol_sw           VARCHAR2,
      p_loss_sw          VARCHAR2,
      p_line_cd          VARCHAR2,
      p_subline_cd       VARCHAR2,
      p_date_to          VARCHAR2,
      p_date_from        VARCHAR2,
      p_loss_date_to     VARCHAR2,
      p_loss_date_from   VARCHAR2,
      p_all_line_tag     VARCHAR2,
      p_user_id          VARCHAR2
   )
   IS
      v_update              VARCHAR2 (32000);
      v_treatyx             gicl_loss_profile.treaty%TYPE;
      v_claim_count         NUMBER                                 := 0;
      rec_counter           NUMBER                                 := 0;
      v_tsi_amt             gipi_polbasic.tsi_amt%TYPE             := 0;
      v_acct_trty_type      giis_dist_share.acct_trty_type%TYPE;
      v_range_from          gicl_loss_profile.range_from%TYPE;
      v_range_to            gicl_loss_profile.range_to%TYPE;
      v_net_retention       gicl_loss_profile.net_retention%TYPE;
      v_quota_share         gicl_loss_profile.quota_share%TYPE;
      v_facultative         gicl_loss_profile.facultative%TYPE;
      v_rec_net_retention   gicl_loss_profile.net_retention%TYPE;
      v_quota_share2        gicl_loss_profile.quota_share%TYPE;
      v_rec_treaty          gicl_loss_profile.treaty%TYPE;
      v_rec_treaty1         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty2         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty3         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty4         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty5         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty6         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty7         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty8         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty9         gicl_loss_profile.treaty%TYPE;
      v_rec_treaty10        gicl_loss_profile.treaty%TYPE;
      v_rec_facultative     gicl_loss_profile.facultative%TYPE;
      v_exist               VARCHAR2 (1)                           := 'N';
      v_chk_ext             NUMBER                                 := 0;
      v_xol                 gicl_loss_profile.xol_treaty%TYPE;
      v_param_value_v       giac_parameters.param_value_v%TYPE;

      TYPE col_name IS TABLE OF VARCHAR2 (40)
         INDEX BY VARCHAR2 (10);

      TYPE cols IS RECORD (
         col   col_name
      );

      TYPE treaty_type IS TABLE OF cols
         INDEX BY PLS_INTEGER;

      treaties              treaty_type;
      treaty_count          NUMBER                                 := 0;

      PROCEDURE add_treaties (p_treaty_cd NUMBER, p_treaty NUMBER, p_sign VARCHAR2)
      IS
      BEGIN
         treaty_count := treaty_count + 1;
         treaties (treaty_count).col ('treaty_cd') := p_treaty_cd;

         BEGIN
            IF p_sign = 'Y'
            THEN
               treaties (treaty_count).col ('treaty') :=
                                treaties (treaty_count).col ('treaty')
                                + p_treaty;
            ELSE
               treaties (treaty_count).col ('treaty') :=
                                treaties (treaty_count).col ('treaty')
                                - p_treaty;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               treaties (treaty_count).col ('treaty') := p_treaty;
         END;
      END;
   BEGIN
      IF p_all_line_tag IN ('Y', 'N')
      THEN
         p_risk_loss_profile.get_loss_ext3 (p_loss_sw,
                                            p_loss_date_from,
                                            p_loss_date_to,
                                            p_line_cd,
                                            p_subline_cd
                                           );
      ELSIF p_all_line_tag = 'R'
      THEN
         IF p_line_cd = 'MC'
         THEN
            p_risk_loss_profile.get_loss_ext3_motor (p_loss_sw,
                                                     p_loss_date_from,
                                                     p_loss_date_to,
                                                     p_line_cd,
                                                     p_subline_cd
                                                    );
         ELSIF p_line_cd = 'FI'
         THEN
            p_risk_loss_profile.get_loss_ext3_fire (p_loss_sw,
                                                    p_loss_date_from,
                                                    p_loss_date_to,
                                                    p_line_cd,
                                                    p_subline_cd
                                                   );
         END IF;
      ELSIF p_all_line_tag = 'P'
      THEN
         p_risk_loss_profile.get_loss_ext3_peril (p_loss_sw,
                                                  p_loss_date_from,
                                                  p_loss_date_to,
                                                  p_line_cd,
                                                  p_subline_cd
                                                 );
      END IF;

      FOR a IN (SELECT 1
                  FROM gicl_risk_loss_profile
                 WHERE user_id = p_user_id)
      LOOP
         v_exist := 'Y';
         EXIT;
      END LOOP;

      BEGIN
         SELECT param_value_v
           INTO v_param_value_v
           FROM giac_parameters
          WHERE param_name = 'XOL_TRTY_SHARE_TYPE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_param_value_v := NULL;
      END;

      IF v_exist = 'Y'
      THEN
         UPDATE gicl_risk_loss_profile --Deo [12.21.2016]: SR-23479
            SET treaty1_cd = NULL,
                treaty2_cd = NULL,
                treaty3_cd = NULL,
                treaty4_cd = NULL,
                treaty5_cd = NULL,
                treaty6_cd = NULL,
                treaty7_cd = NULL,
                treaty8_cd = NULL,
                treaty9_cd = NULL,
                treaty10_cd = NULL,
                treaty1_loss = NULL,
                treaty2_loss = NULL,
                treaty3_loss = NULL,
                treaty4_loss = NULL,
                treaty5_loss = NULL,
                treaty6_loss = NULL,
                treaty7_loss = NULL,
                treaty8_loss = NULL,
                treaty9_loss = NULL,
                treaty10_loss = NULL
          WHERE line_cd = NVL (p_line_cd, line_cd)
            AND NVL (subline_cd, '1') = NVL (p_subline_cd, '1')
            AND user_id = p_user_id;
            
         FOR rng IN (SELECT range_from, range_to, line_cd, subline_cd
                       FROM gicl_risk_loss_profile
                      WHERE line_cd = NVL (p_line_cd, line_cd)
                        AND NVL (subline_cd, '1') = NVL (p_subline_cd, '1')
                        AND user_id = p_user_id)
         LOOP
            v_range_from := rng.range_from;
            v_range_to := rng.range_to;
            v_net_retention := 0;
            v_quota_share := 0;
            v_treatyx := 0;
            v_facultative := 0;
            v_claim_count := 0;
            v_tsi_amt := 0;
            v_xol := 0;
            treaty_count := 0; --Deo [12.21.2016]: SR-23479
            
            --modified by gab 06.23.2016 SR 21538
--            FOR clm IN (SELECT a.claim_id
--                          FROM gicl_risk_loss_profile_ext3 a,
--                               gicl_claims b,
--                               gipi_risk_loss_profile_dtl c
--                         WHERE a.claim_id = b.claim_id
--                           AND b.line_cd = c.line_cd
--                           AND b.subline_cd = c.subline_cd
--                           AND b.pol_iss_cd = c.iss_cd
--                           AND c.all_line_tag = p_all_line_tag
--                           AND b.issue_yy = c.issue_yy
--                           AND b.pol_seq_no = c.pol_seq_no
--                           AND b.renew_no = c.renew_no
--                           AND c.ann_tsi_amt >= v_range_from
--                           AND c.ann_tsi_amt <= v_range_to
--                           AND c.date_from = p_date_from
--                           AND c.date_to = p_date_to
--                           AND b.line_cd = p_line_cd
--                           AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
--                           AND a.close_sw = 'N')
--            LOOP
--               rec_counter := rec_counter + 1;
--               v_chk_ext := 1;
--               v_claim_count := NVL (v_claim_count, 0) + 1;

--               FOR a IN (SELECT   c018.grp_seq_no, c018.share_type,
--                                  SUM (  NVL (c018.shr_loss_res_amt, 0)
--                                       + NVL (c018.shr_exp_res_amt, 0)
--                                      ) loss
--                             FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
--                            WHERE 1 = 1
--                              AND c017.claim_id = clm.claim_id
--                              AND c017.claim_id = c018.claim_id
--                              AND c017.clm_res_hist_id = c018.clm_res_hist_id
--                              AND NVL (c017.dist_sw, 'N') = 'Y'
--                         GROUP BY c018.grp_seq_no, c018.share_type)
--               LOOP
--                  IF a.share_type = '1'
--                  THEN
--                     v_net_retention :=
--                                       NVL (v_net_retention, 0)
--                                       + NVL (a.loss, 0);
--                  ELSIF a.share_type = '3'
--                  THEN
--                     v_facultative := NVL (v_facultative, 0) + NVL (a.loss, 0);
--                  ELSIF a.share_type = '2'
--                  THEN
--                     v_treatyx := NVL (v_treatyx, 0) + NVL (a.loss, 0);
--                     add_treaties (NVL (a.grp_seq_no, 0), NVL (a.loss, 0), 'Y');
--                  ELSIF a.share_type = v_param_value_v
--                  THEN
--                     v_xol := NVL (v_xol, 0) + NVL (a.loss, 0);
--                     add_treaties (NVL (a.grp_seq_no, 0), NVL (a.loss, 0), 'Y');
--                  END IF;
--               END LOOP;

--               FOR get_recovery IN
--                  (SELECT   c018.grp_seq_no, c018.acct_trty_type,
--                            c018.share_type,
--                            SUM (NVL (c018.shr_recovery_amt, 0)) recovered_amt
--                       FROM gicl_claims c003,
--                            gicl_recovery_payt c017,
--                            gicl_recovery_ds c018
--                      WHERE c003.claim_id = clm.claim_id
--                        AND NVL (c017.cancel_tag, 'N') = 'N'
--                        AND TO_NUMBER (TO_CHAR (c003.loss_date, 'YYYY')) =
--                                     TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
--                        AND c017.claim_id = c003.claim_id
--                        AND c017.recovery_id = c018.recovery_id
--                        AND c017.recovery_payt_id = c018.recovery_payt_id
--                        AND NVL (c018.negate_tag, 'N') = 'N'
--                   GROUP BY c018.grp_seq_no, c018.acct_trty_type,
--                            c018.share_type)
--               LOOP
--                  IF get_recovery.share_type = '1'
--                  THEN
--                     v_net_retention :=
--                          NVL (v_net_retention, 0)
--                        - NVL (get_recovery.recovered_amt, 0);
--                  ELSIF get_recovery.share_type = '3'
--                  THEN
--                     v_facultative :=
--                          NVL (v_facultative, 0)
--                        - NVL (get_recovery.recovered_amt, 0);
--                  ELSIF get_recovery.share_type = '2'
--                  THEN
--                     add_treaties (NVL (get_recovery.grp_seq_no, 0),
--                                   NVL (get_recovery.recovered_amt, 0),
--                                   'N'
--                                  );
--                     v_treatyx :=
--                          NVL (v_treatyx, 0)
--                          - NVL (get_recovery.recovered_amt, 0);
--                  ELSIF get_recovery.share_type = v_param_value_v
--                  THEN
--                     v_xol :=
--                             NVL (v_xol, 0)
--                             - NVL (get_recovery.recovered_amt, 0);
--                     add_treaties (NVL (get_recovery.grp_seq_no, 0),
--                                   NVL (get_recovery.recovered_amt, 0),
--                                   'N'
--                                  );
--                  END IF;
--               END LOOP;
--            END LOOP;

--            FOR clm2 IN (SELECT a.claim_id
--                           FROM gicl_risk_loss_profile_ext3 a,
--                                gicl_claims b,
--                                gipi_risk_loss_profile_dtl c
--                          WHERE a.claim_id = b.claim_id
--                            AND b.line_cd = c.line_cd
--                            AND b.subline_cd = c.subline_cd
--                            AND b.pol_iss_cd = c.iss_cd
--                            AND c.all_line_tag = p_all_line_tag
--                            AND b.issue_yy = c.issue_yy
--                            AND b.pol_seq_no = c.pol_seq_no
--                            AND b.renew_no = c.renew_no
--                            AND c.ann_tsi_amt >= v_range_from
--                            AND c.ann_tsi_amt <= v_range_to
--                            AND c.date_from = p_date_from
--                            AND c.date_to = p_date_to
--                            AND b.line_cd = p_line_cd
--                            AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
--                            AND a.close_sw = 'Y')
--            LOOP
--               rec_counter := rec_counter + 1;
--               v_chk_ext := 1;
--               v_claim_count := NVL (v_claim_count, 0) + 1;

--               FOR b IN (SELECT   c018.grp_seq_no, c018.acct_trty_type,
--                                  c018.share_type,
--                                  SUM (NVL (c018.shr_le_net_amt, 0)) loss
--                             FROM gicl_clm_res_hist c017,
--                                  gicl_clm_loss_exp c016,
--                                  gicl_loss_exp_ds c018
--                            WHERE c017.claim_id = clm2.claim_id
--                              AND NVL (c017.cancel_tag, 'N') = 'N'
--                              AND c017.tran_id IS NOT NULL
--                              AND c016.claim_id = c017.claim_id
--                              AND c016.tran_id = c017.tran_id
--                              AND c016.item_no = c017.item_no
--                              AND c016.peril_cd = c017.peril_cd
--                              AND c018.claim_id = c016.claim_id
--                              AND c018.clm_loss_id = c016.clm_loss_id
--                              AND NVL (c018.negate_tag, 'N') = 'N'
--                         GROUP BY c018.grp_seq_no,
--                                  c018.acct_trty_type,
--                                  c018.share_type)
--               LOOP
--                  IF b.share_type = '1'
--                  THEN
--                     v_net_retention :=
--                                       NVL (v_net_retention, 0)
--                                       + NVL (b.loss, 0);
--                  ELSIF b.share_type = '3'
--                  THEN
--                     v_facultative := NVL (v_facultative, 0) + NVL (b.loss, 0);
--                  ELSIF b.share_type = '2'
--                  THEN
--                     add_treaties (NVL (b.grp_seq_no, 0), NVL (b.loss, 0), 'Y');
--                     v_treatyx := NVL (v_treatyx, 0) + NVL (b.loss, 0);
--                  ELSIF b.share_type = v_param_value_v
--                  THEN
--                     v_xol := NVL (v_xol, 0) + NVL (b.loss, 0);
--                     add_treaties (NVL (b.grp_seq_no, 0), NVL (b.loss, 0), 'Y');
--                  END IF;
--               END LOOP;

--               FOR get_recovery IN
--                  (SELECT   c018.grp_seq_no, c018.acct_trty_type,
--                            c018.share_type,
--                            SUM (NVL (c018.shr_recovery_amt, 0)) recovered_amt
--                       FROM gicl_claims c003,
--                            gicl_recovery_payt c017,
--                            gicl_recovery_ds c018
--                      WHERE c003.claim_id = clm2.claim_id
--                        AND NVL (c017.cancel_tag, 'N') = 'N'
--                        AND TO_NUMBER (TO_CHAR (c003.loss_date, 'YYYY')) =
--                                     TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
--                        AND c017.claim_id = c003.claim_id
--                        AND c017.recovery_id = c018.recovery_id
--                        AND c017.recovery_payt_id = c018.recovery_payt_id
--                        AND NVL (c018.negate_tag, 'N') = 'N'
--                   GROUP BY c018.grp_seq_no, c018.acct_trty_type,
--                            c018.share_type)
--               LOOP
--                  IF get_recovery.share_type = '1'
--                  THEN
--                     v_net_retention :=
--                          NVL (v_net_retention, 0)
--                        - NVL (get_recovery.recovered_amt, 0);
--                  ELSIF get_recovery.share_type = '3'
--                  THEN
--                     v_facultative :=
--                          NVL (v_facultative, 0)
--                        - NVL (get_recovery.recovered_amt, 0);
--                  ELSIF get_recovery.share_type = '2'
--                  THEN
--                     add_treaties (NVL (get_recovery.grp_seq_no, 0),
--                                   NVL (get_recovery.recovered_amt, 0),
--                                   'N'
--                                  );
--                     v_treatyx :=
--                          NVL (v_treatyx, 0)
--                          - NVL (get_recovery.recovered_amt, 0);
--                  ELSIF get_recovery.share_type = v_param_value_v
--                  THEN
--                     v_xol :=
--                             NVL (v_xol, 0)
--                             - NVL (get_recovery.recovered_amt, 0);
--                     add_treaties (NVL (get_recovery.grp_seq_no, 0),
--                                   NVL (get_recovery.recovered_amt, 0),
--                                   'N'
--                                  );
--                  END IF;
--               END LOOP;
--            END LOOP;
            FOR clm IN (SELECT a.claim_id, a.close_sw
                          FROM gicl_risk_loss_profile_ext3 a,
                               gicl_claims b,
                               gipi_risk_loss_profile_dtl c
                         WHERE a.claim_id = b.claim_id
                           AND b.line_cd = c.line_cd
                           AND b.subline_cd = c.subline_cd
                           AND b.pol_iss_cd = c.iss_cd
                           AND c.all_line_tag = p_all_line_tag
                           AND b.issue_yy = c.issue_yy
                           AND b.pol_seq_no = c.pol_seq_no
                           AND b.renew_no = c.renew_no
                           AND c.ann_tsi_amt >= v_range_from
                           AND c.ann_tsi_amt <= v_range_to
                           AND c.date_from = p_date_from
                           AND c.date_to = p_date_to
                           AND b.line_cd = p_line_cd
                           AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
                           )
            LOOP
               rec_counter := rec_counter + 1;
               v_chk_ext := 1;
               v_claim_count := NVL (v_claim_count, 0) + 1;
               
               IF clm.close_sw = 'N' THEN
                    FOR a IN (SELECT   c018.grp_seq_no, c018.share_type,
                                  SUM (  NVL (c018.shr_loss_res_amt, 0)
                                       + NVL (c018.shr_exp_res_amt, 0)
                                      ) loss
                             FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
                            WHERE 1 = 1
                              AND c017.claim_id = clm.claim_id
                              AND c017.claim_id = c018.claim_id
                              AND c017.clm_res_hist_id = c018.clm_res_hist_id
                              AND NVL (c017.dist_sw, 'N') = 'Y'
                              AND c018.share_type in ('1', '3')
                         GROUP BY c018.grp_seq_no, c018.share_type)
                     LOOP
                        IF a.share_type = '1'
                        THEN
                           v_net_retention :=
                                             NVL (v_net_retention, 0)
                                             + NVL (a.loss, 0);
                        ELSIF a.share_type = '3'
                        THEN
                           v_facultative := NVL (v_facultative, 0) + NVL (a.loss, 0);
                        END IF;
                     END LOOP;
               
               ELSIF clm.close_sw = 'Y' THEN
                    FOR b IN (SELECT   c018.grp_seq_no, c018.acct_trty_type,
                                  c018.share_type,
                                  SUM (NVL (c018.shr_le_net_amt, 0)) loss
                             FROM gicl_clm_res_hist c017,
                                  gicl_clm_loss_exp c016,
                                  gicl_loss_exp_ds c018
                            WHERE c017.claim_id = clm.claim_id
                              AND NVL (c017.cancel_tag, 'N') = 'N'
                              AND c017.tran_id IS NOT NULL
                              AND c016.claim_id = c017.claim_id
                              AND c016.tran_id = c017.tran_id
                              AND c016.item_no = c017.item_no
                              AND c016.peril_cd = c017.peril_cd
                              AND c018.claim_id = c016.claim_id
                              AND c018.clm_loss_id = c016.clm_loss_id
                              AND NVL (c018.negate_tag, 'N') = 'N'
                              AND c018.share_type in ('1', '3')
                         GROUP BY c018.grp_seq_no,
                                  c018.acct_trty_type,
                                  c018.share_type)
                     LOOP
                        IF b.share_type = '1'
                        THEN    
                           v_net_retention :=
                                             NVL (v_net_retention, 0)
                                             + NVL (b.loss, 0);
                        ELSIF b.share_type = '3'
                        THEN
                           v_facultative := NVL (v_facultative, 0) + NVL (b.loss, 0);
                           
                        END IF;
                        
                     END LOOP;
               
               END IF;
                    
               FOR get_recovery IN
                  (SELECT   c018.grp_seq_no, c018.acct_trty_type,
                            c018.share_type,
                            SUM (NVL (c018.shr_recovery_amt, 0)) recovered_amt
                       FROM gicl_claims c003,
                            gicl_recovery_payt c017,
                            gicl_recovery_ds c018
                      WHERE c003.claim_id = clm.claim_id
                        AND NVL (c017.cancel_tag, 'N') = 'N'
                        AND TO_NUMBER (TO_CHAR (c003.loss_date, 'YYYY')) =
                                     TO_NUMBER (TO_CHAR (c017.tran_date, 'YYYY'))
                        AND c017.claim_id = c003.claim_id
                        AND c017.recovery_id = c018.recovery_id
                        AND c017.recovery_payt_id = c018.recovery_payt_id
                        AND NVL (c018.negate_tag, 'N') = 'N'
                   GROUP BY c018.grp_seq_no, c018.acct_trty_type,
                            c018.share_type)
               LOOP
                  IF get_recovery.share_type = '1'
                  THEN
                     v_net_retention :=
                          NVL (v_net_retention, 0)
                        - NVL (get_recovery.recovered_amt, 0);
                  ELSIF get_recovery.share_type = '3'
                  THEN
                     v_facultative :=
                          NVL (v_facultative, 0)
                        - NVL (get_recovery.recovered_amt, 0);
                  ELSIF get_recovery.share_type = '2'
                  THEN
                     add_treaties (NVL (get_recovery.grp_seq_no, 0),
                                   NVL (get_recovery.recovered_amt, 0),
                                   'N'
                                  );
                     v_treatyx :=
                          NVL (v_treatyx, 0)
                          - NVL (get_recovery.recovered_amt, 0);
                  ELSIF get_recovery.share_type = v_param_value_v
                  THEN
                     v_xol :=
                             NVL (v_xol, 0)
                             - NVL (get_recovery.recovered_amt, 0);
                     add_treaties (NVL (get_recovery.grp_seq_no, 0),
                                   NVL (get_recovery.recovered_amt, 0),
                                   'N'
                                  );
                  END IF;
               END LOOP;
            END LOOP;
            
            FOR c IN (SELECT   c018.grp_seq_no, c018.share_type,
                                  SUM (  NVL (c018.shr_loss_res_amt, 0)
                                       + NVL (c018.shr_exp_res_amt, 0)
                                      ) loss
                             FROM gicl_clm_res_hist c017, gicl_reserve_ds c018
                            WHERE 1 = 1
                              AND c017.claim_id IN (SELECT a.claim_id
                                                      FROM gicl_risk_loss_profile_ext3 a,
                                                           gicl_claims b,
                                                           gipi_risk_loss_profile_dtl c
                                                     WHERE a.claim_id = b.claim_id
                                                       AND b.line_cd = c.line_cd
                                                       AND b.subline_cd = c.subline_cd
                                                       AND b.pol_iss_cd = c.iss_cd
                                                       AND c.all_line_tag = p_all_line_tag
                                                       AND b.issue_yy = c.issue_yy
                                                       AND b.pol_seq_no = c.pol_seq_no
                                                       AND b.renew_no = c.renew_no
                                                       AND c.ann_tsi_amt >= v_range_from
                                                       AND c.ann_tsi_amt <= v_range_to
                                                       AND c.date_from = p_date_from
                                                       AND c.date_to = p_date_to
                                                       AND b.line_cd = p_line_cd
                                                       AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
                                                       AND a.close_sw = 'N' --Deo [12.21.2016]: SR-23479
                                                    )
                              AND c017.claim_id = c018.claim_id
                              AND c017.clm_res_hist_id = c018.clm_res_hist_id
                              AND NVL (c017.dist_sw, 'N') = 'Y'
                              AND c018.share_type in ('2', v_param_value_v)
                         GROUP BY c018.grp_seq_no, c018.share_type
                         UNION
                         SELECT   c018.grp_seq_no, c018.share_type,
                                  SUM (NVL (c018.shr_le_net_amt, 0)) loss
                             FROM gicl_clm_res_hist c017,
                                  gicl_clm_loss_exp c016,
                                  gicl_loss_exp_ds c018
                            WHERE c017.claim_id IN (SELECT a.claim_id
                                                      FROM gicl_risk_loss_profile_ext3 a,
                                                           gicl_claims b,
                                                           gipi_risk_loss_profile_dtl c
                                                     WHERE a.claim_id = b.claim_id
                                                       AND b.line_cd = c.line_cd
                                                       AND b.subline_cd = c.subline_cd
                                                       AND b.pol_iss_cd = c.iss_cd
                                                       AND c.all_line_tag = p_all_line_tag
                                                       AND b.issue_yy = c.issue_yy
                                                       AND b.pol_seq_no = c.pol_seq_no
                                                       AND b.renew_no = c.renew_no
                                                       AND c.ann_tsi_amt >= v_range_from
                                                       AND c.ann_tsi_amt <= v_range_to
                                                       AND c.date_from = p_date_from
                                                       AND c.date_to = p_date_to
                                                       AND b.line_cd = p_line_cd
                                                       AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
                                                       AND a.close_sw = 'Y' --Deo [12.21.2016]: SR-23479
                                                   )
                              AND NVL (c017.cancel_tag, 'N') = 'N'
                              AND c017.tran_id IS NOT NULL
                              AND c016.claim_id = c017.claim_id
                              AND c016.tran_id = c017.tran_id
                              AND c016.item_no = c017.item_no
                              AND c016.peril_cd = c017.peril_cd
                              AND c018.claim_id = c016.claim_id
                              AND c018.clm_loss_id = c016.clm_loss_id
                              AND NVL (c018.negate_tag, 'N') = 'N'
                              AND c018.share_type in ('2', v_param_value_v)
                         GROUP BY c018.grp_seq_no,
                                  c018.acct_trty_type,
                                  c018.share_type)
                    LOOP
                        IF c.share_type = '2'
                        THEN
                           add_treaties (NVL (c.grp_seq_no, 0), NVL (c.loss, 0), 'Y');
                           v_treatyx := NVL (v_treatyx, 0) + NVL (c.loss, 0);
                        ELSIF c.share_type = v_param_value_v
                        THEN
                           v_xol := NVL (v_xol, 0) + NVL (c.loss, 0);
                           add_treaties (NVL (c.grp_seq_no, 0), NVL (c.loss, 0), 'Y');
                        END IF;
                     END LOOP;
            --end gab SR 21538

            DECLARE
               rg_name   VARCHAR2 (50) := 'TREATY';
               rg_0      VARCHAR2 (40) := rg_name || '.treaty';
               rg_1      VARCHAR2 (40) := rg_name || '.treaty_cd';
               value0    VARCHAR2 (40);
               value1    VARCHAR2 (40);
               v_count   NUMBER;
               v_exist   BOOLEAN       := FALSE;
            BEGIN
               IF TRUE
               THEN
                  IF treaty_count > 0
                  THEN
                     FOR query_cur IN 1 .. treaty_count
                     LOOP
                        value0 := treaties (query_cur).col ('treaty');
                        value1 := treaties (query_cur).col ('treaty_cd');
                        v_update :=
                              'UPDATE gicl_risk_loss_profile
                                            SET policy_count               = NVL('
                           || ''''
                           || v_claim_count
                           || ''''
                           || ',policy_count),
                                                total_tsi_amt              = NVL('
                           || ''''
                           || v_tsi_amt
                           || ''''
                           || ',total_tsi_amt),
                                                net_retention              = NVL('
                           || ''''
                           || v_net_retention
                           || ''''
                           || ',net_retention),
                                                quota_share                = NVL('
                           || ''''
                           || v_quota_share
                           || ''''
                           || ',quota_share),
                                                treaty                     = NVL('
                           || ''''
                           || v_treatyx
                           || ''''
                           || ',treaty),
                                                       treaty'
                           || query_cur
                           || '_loss = NVL('
                           || ''''
                           || value0
                           || ''''
                           || ', treaty'
                           || query_cur
                           || '_loss),
                                                       treaty'
                           || query_cur
                           || '_cd   = NVL('
                           || ''''
                           || value1
                           || ''''
                           || ', treaty'
                           || query_cur
                           || '_cd),
                                                       facultative                = NVL('
                           || ''''
                           || v_facultative
                           || ''''
                           || ',facultative),
                                          xol_treaty                    = NVL('
                           || ''''
                           || v_xol
                           || ''''
                           || ',xol_treaty)
                                           WHERE line_cd                    = '
                           || ''''
                           || rng.line_cd
                           || ''''
                           || '                            
                                             AND NVL(subline_cd, '
                           || '1'
                           || ') = NVL('
                           || ''''
                           || rng.subline_cd
                           || ''''
                           || ', '
                           || '1'
                           || ')
                                             AND range_from                 = '
                           || ''''
                           || rng.range_from
                           || ''''
                           || '
                                             AND range_to                   = '
                           || ''''
                           || rng.range_to
                           || ''''
                           || '
                                             AND user_id                    = '
                           || ''''
                           || p_user_id
                           || ''''
                           || '';
                        exec_immediate (v_update);
                     END LOOP;
                     
                     treaties.DELETE; --Deo [12.21.2016]: SR-23479
                  ELSE
                     UPDATE gicl_risk_loss_profile
                        SET policy_count = NVL (v_claim_count, policy_count),
                            total_tsi_amt = NVL (v_tsi_amt, total_tsi_amt),
                            net_retention = NVL (v_net_retention, net_retention),
                            quota_share = NVL (v_quota_share, quota_share),
                            treaty = NVL (v_treatyx, treaty),
                            facultative = NVL (v_facultative, facultative),
                            xol_treaty = NVL (v_xol, xol_treaty)
                      WHERE line_cd = rng.line_cd
                        AND NVL (subline_cd, '1') = NVL (rng.subline_cd, '1')
                        AND range_from = rng.range_from
                        AND range_to = rng.range_to
                        AND user_id = p_user_id;
                  END IF;
               END IF;
            END;
         END LOOP;

         v_chk_ext := 1;
      END IF;
   END loss_profile_extract_loss_amt;
     
END;
/
