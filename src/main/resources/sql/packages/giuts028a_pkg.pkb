CREATE OR REPLACE PACKAGE BODY CPI.giuts028a_pkg
AS
   FUNCTION when_new_form_giuts028a
      RETURN when_new_form_giuts028a_tab PIPELINED
   IS
      v_rec   when_new_form_giuts028a_type;
   BEGIN
      FOR i IN (SELECT param_value_v
                  FROM giac_parameters
                 WHERE param_name = 'ALLOW_SPOILAGE')
      LOOP
         v_rec.allow_spoilage := i.param_value_v;
         EXIT;
      END LOOP;

      v_rec.v_iss_cd_param := giacp.v ('BRANCH_CD');
      v_rec.v_ho := giisp.v ('ISS_CD_HO');
      v_rec.v_restrict := giisp.v ('RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE');
      v_rec.v_subline := giisp.v ('SUBLINE_MN_MOP');
      --v_rec.v_renew := giisp.v ('ALLOW_REINSTATEMENT_WRENEW_POL'); --benjo 09.03.2015 comment out
      PIPE ROW (v_rec);
   END when_new_form_giuts028a;

   FUNCTION get_policy_giuts028a_lov (p_user_id giis_users.user_id%TYPE)
      RETURN get_policy_giuts028a_lov_tab PIPELINED
   IS
      res   get_policy_giuts028a_lov_type;
   BEGIN
      FOR i IN (SELECT a.pack_policy_id,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09')) pack_policy_no,
                       b.assd_name, a.line_cd, a.subline_cd, a.iss_cd,
                       a.issue_yy, a.pol_seq_no, a.renew_no
                  FROM gipi_pack_polbasic a, giis_assured b
                 WHERE a.assd_no = b.assd_no
                   AND check_user_per_iss_cd2 (a.line_cd,
                                               NVL (NULL, a.iss_cd),
                                               'GIUTS028A',
                                               p_user_id
                                              ) = 1
                   /*AND check_user_per_line2 (a.line_cd,
                                             NVL (NULL, a.iss_cd),
                                             'GIUTS0028A',
                                             p_user_id
                                            ) = 1*/
                   AND endt_seq_no = 0
                   AND (   pol_flag = '4'
                        OR pack_policy_id IN (SELECT pack_policy_id
                                                FROM gipi_pack_reinstate_hist)
                        OR pack_policy_id IN (
                              SELECT pack_policy_id
                                FROM gipi_polbasic a
                               WHERE a.pol_flag = '4'
                                 AND a.pack_pol_flag = 'Y'
                                 AND a.pack_policy_id = a.pack_policy_id)
                       ))
      LOOP
         res.v_subcancel := NULL;
         res.pack_pol_flag := NULL;
         res.v_hist := NULL;
         res.pack_policy_id := i.pack_policy_id;
         res.pack_policy_no := i.pack_policy_no;
         res.assd_name := i.assd_name;
         res.line_cd := i.line_cd;
         res.subline_cd := i.subline_cd;
         res.iss_cd := i.iss_cd;
         res.issue_yy := i.issue_yy;
         res.pol_seq_no := i.pol_seq_no;
         res.renew_no := i.renew_no;

         FOR y IN (SELECT pol_flag
                     FROM gipi_polbasic
                    WHERE pack_policy_id = i.pack_policy_id)
         LOOP
            IF y.pol_flag = '4'
            THEN
               res.v_subcancel := 'Y';
            END IF;
         END LOOP;

         FOR x IN (SELECT pol_flag
                     FROM gipi_pack_polbasic
                    WHERE pack_policy_id = i.pack_policy_id)
         LOOP
            res.pack_pol_flag := x.pol_flag;
         END LOOP;

         FOR x IN (SELECT '1'
                     FROM gipi_pack_reinstate_hist
                    WHERE pack_policy_id = i.pack_policy_id)
         LOOP
            res.v_hist := 'Y';
         END LOOP;

         PIPE ROW (res);
      END LOOP;

      RETURN;
   END get_policy_giuts028a_lov;

   FUNCTION get_reinstatement_hist (
      p_pack_policy_id   gipi_pack_polbasic.pack_policy_id%TYPE
   )
      RETURN reinstatement_hist_tab PIPELINED
   IS
      v_rec   reinstatement_hist_type;
   BEGIN
      FOR i IN (SELECT hist_id, max_endt_seq_no, user_id, last_update
                  FROM gipi_pack_reinstate_hist
                 WHERE pack_policy_id = p_pack_policy_id)
      LOOP
         v_rec.hist_id := i.hist_id;
         v_rec.max_endt_seq_no := i.max_endt_seq_no;
         v_rec.user_id := i.user_id;
         v_rec.last_update := i.last_update;
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END get_reinstatement_hist;

   PROCEDURE process_reinstate (
      p_user_id          IN       giis_users.user_id%TYPE,
      p_line_cd          IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN       gipi_polbasic.renew_no%TYPE,
      p_pack_policy_id   IN       gipi_pack_polbasic.pack_policy_id%TYPE,
      p_subpol_check     OUT      VARCHAR2
   )
   IS
      curr_value             VARCHAR2 (1);
      v_sw                   giis_issource.ho_tag%TYPE;
      v_cancel_all           VARCHAR2 (1);
      v_alert_btn            NUMBER;
      v_alert_msg            VARCHAR2 (500);
      v_subpol_check         VARCHAR2 (1);
      v_reinstate            VARCHAR2 (1);
      v_cancel_pack_policy   gipi_pack_polbasic.pack_policy_id%TYPE;
      v_max_endt             gipi_polbasic.endt_seq_no%TYPE;
      v_line_cd              giis_line.line_cd%TYPE;
      v_subline_cd           gipi_polbasic.subline_cd%TYPE;
      v_iss_cd               gipi_polbasic.iss_cd%TYPE;
      v_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE;
      v_issue_yy             gipi_polbasic.issue_yy%TYPE;
      v_renew_no             gipi_polbasic.renew_no%TYPE;
      v_pol_flag             gipi_polbasic.pol_flag%TYPE;
      v_old_pol_flag         gipi_pack_polbasic.old_pol_flag%TYPE;
      v_subpol_id            gipi_polbasic.policy_id%TYPE;
      v_cancel_policy        gipi_polbasic.policy_id%TYPE;
      v_acct_ent_date        gipi_polbasic.acct_ent_date%TYPE;
      v_spld_flag            gipi_polbasic.spld_flag%TYPE;
      v_iss_cd_param         giac_parameters.param_value_v%TYPE
                                                     := giacp.v ('BRANCH_CD');
      v_ho                   giis_parameters.param_value_v%TYPE
                                                     := giisp.v ('ISS_CD_HO');
      v_restrict             giis_parameters.param_value_v%TYPE
                          := giisp.v ('RESTRICT_SPOIL_OF_REC_WACCT_ENT_DATE');
      v_subline              giis_parameters.param_value_v%TYPE
                                                := giisp.v ('SUBLINE_MN_MOP');
      v_renew                giis_parameters.param_value_v%TYPE
                                := giisp.v ('ALLOW_REINSTATEMENT_WRENEW_POL');
      v_msg_alert1           VARCHAR2 (1000)                          := NULL;
      v_msg_alert2           VARCHAR2 (1000)                          := NULL;
      v_msg_alert3           BOOLEAN;
      v_msg_alert4           VARCHAR2 (1000)                          := NULL;
      v_msg_alert5           VARCHAR2 (1000)                          := NULL;
      v_msg_alert6           BOOLEAN;
      v_msg_alert7           VARCHAR2 (1000)                          := NULL;
      v_msg_alert8           VARCHAR2 (1000)                          := NULL;
      v_msg_alert9           BOOLEAN;
      v_alert                VARCHAR2 (1)                             := NULL;
   BEGIN
      v_subpol_check := 'N';
      v_reinstate := 'N';

      FOR a IN (SELECT   pack_policy_id, acct_ent_date, spld_flag,
                         endt_seq_no
                    FROM gipi_pack_polbasic a
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND pol_flag = '4'
                     AND pack_policy_id <> p_pack_policy_id
                ORDER BY endt_seq_no DESC)
      LOOP
         v_cancel_pack_policy := a.pack_policy_id;
         v_max_endt := a.endt_seq_no;
         EXIT;
      END LOOP;

      check_package_cancellation (v_cancel_all, p_pack_policy_id);

      IF v_cancel_all = 'N'
      THEN
         raise_application_error
                         ('-20001',
                          'RAE EPNYC Entire package not yet cancelled. FALSE'
                         );
      END IF;

      FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, policy_id, pol_flag, old_pol_flag
                  FROM gipi_polbasic
                 WHERE pack_policy_id = p_pack_policy_id)
      LOOP
         v_line_cd := a.line_cd;
         v_subline_cd := a.subline_cd;
         v_iss_cd := a.iss_cd;
         v_pol_seq_no := a.pol_seq_no;
         v_issue_yy := a.issue_yy;
         v_renew_no := a.renew_no;
         v_subpol_id := a.policy_id;
         v_pol_flag := a.pol_flag;
         v_old_pol_flag := a.old_pol_flag;

         FOR sub IN (SELECT   policy_id, acct_ent_date, spld_flag,
                              endt_seq_no
                         FROM gipi_polbasic a
                        WHERE line_cd = v_line_cd
                          AND subline_cd = v_subline_cd
                          AND iss_cd = v_iss_cd
                          AND issue_yy = v_issue_yy
                          AND pol_seq_no = v_pol_seq_no
                          AND renew_no = v_renew_no
                          AND pol_flag = '4'
                          AND policy_id <> v_subpol_id
                     ORDER BY endt_seq_no DESC)
         LOOP
            v_cancel_policy := sub.policy_id;
            v_acct_ent_date := sub.acct_ent_date;
            v_spld_flag := sub.spld_flag;
            v_max_endt := sub.endt_seq_no;
            EXIT;
         END LOOP;

         IF v_cancel_policy IS NULL
         THEN
            raise_application_error
                        ('-20001',
                         'RAE NCER No cancellation endorsement record. FALSE'
                        );
         END IF;

         IF v_iss_cd_param IS NULL
         THEN
            raise_application_error
                        ('-20001',
                         'RAE PBCX Parameter branch_cd does not exist. FALSE'
                        );
         END IF;

         IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param = v_ho
         THEN
            BEGIN
               SELECT ho_tag
                 INTO v_sw
                 FROM giis_issource
                WHERE iss_cd = p_iss_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                          ('-20001',
                           'RAE ISX Issuing source not in maintenance. FALSE'
                          );
            END;

            IF NVL (v_sw, 'N') = 'N'
            THEN
               raise_application_error
                                ('-20001',
                                 'RAE REINA Reinstatement not allowed. FALSE'
                                );
            END IF;
         END IF;

         IF p_iss_cd <> v_iss_cd_param AND v_iss_cd_param <> v_ho
         THEN
            raise_application_error
                                ('-20001',
                                 'RAE REINA Reinstatement not allowed. FALSE'
                                );
         END IF;

         IF v_subline_cd = v_subline
         THEN
            check_mrn (v_line_cd,
                       v_subline_cd,
                       v_iss_cd,
                       v_issue_yy,
                       v_pol_seq_no,
                       v_renew_no
                      );
         END IF;

         COMMIT;

         IF v_spld_flag = '3'
         THEN
            raise_application_error ('-20001',
                                     'RAE REIA Reinstated already. FALSE'
                                    );
         ELSE
            FOR a2 IN (SELECT   eff_date, endt_type
                           FROM gipi_wpolbas
                          WHERE line_cd = v_line_cd
                            AND subline_cd = v_subline_cd
                            AND iss_cd = v_iss_cd
                            AND issue_yy = v_issue_yy
                            AND pol_seq_no = v_pol_seq_no
                            AND renew_no = v_renew_no
                       ORDER BY eff_date DESC, endt_seq_no DESC)
            LOOP
               raise_application_error ('-20001',
                                        'RAE EONG Endorsement ongoing. FALSE'
                                       );
            END LOOP;
         END IF;

         validate_reinstatement.check_paid_policy (v_cancel_policy,
                                                   p_iss_cd,
                                                   v_msg_alert1,
                                                   v_msg_alert2,
                                                   v_msg_alert3
                                                  );

         IF v_msg_alert1 IS NOT NULL
         THEN
            raise_application_error ('-20001', v_msg_alert1);
         END IF;

         validate_reinstatement.check_reinsurance_payment (v_cancel_policy,
                                                           p_line_cd,
                                                           v_msg_alert4,
                                                           v_msg_alert5,
                                                           v_msg_alert6
                                                          );

         IF v_msg_alert4 IS NOT NULL
         THEN
            raise_application_error ('-20001', v_msg_alert4);
         END IF;

         validate_reinstatement.check_pack_acct_ent_date (v_acct_ent_date,
                                                          v_restrict,
                                                          v_msg_alert7,
                                                          v_msg_alert8,
                                                          v_msg_alert9
                                                         );

         IF v_msg_alert7 IS NOT NULL
         THEN
            raise_application_error ('-20001', v_msg_alert7);
         END IF;

         validate_reinstatement.validate_renewal_pack_policy (p_line_cd,
                                                              p_subline_cd,
                                                              p_iss_cd,
                                                              p_issue_yy,
                                                              p_pol_seq_no,
                                                              p_renew_no,
                                                              v_renew,
                                                              v_alert
                                                             );

         IF v_alert = 'N'
         THEN
            raise_application_error
                                ('-20001',
                                 'RAE REEXISTR Existing renewal not allowed.'
                                );
         END IF;

         IF v_alert = 'Y'
         THEN
            v_subpol_check := 'Y';
         END IF;

         p_subpol_check := v_subpol_check;
      END LOOP;
   END process_reinstate;

   PROCEDURE check_package_cancellation (
      p_cancel_all       OUT      VARCHAR2,
      p_pack_policy_id   IN       gipi_pack_polbasic.pack_policy_id%TYPE
   )
   IS
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
      v_subpol_id    gipi_polbasic.policy_id%TYPE;
      v_pol_flag     gipi_polbasic.pol_flag%TYPE;
   BEGIN
      FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, policy_id, pol_flag
                  FROM gipi_polbasic
                 WHERE pack_policy_id = p_pack_policy_id)
      LOOP
         v_line_cd := a.line_cd;
         v_subline_cd := a.subline_cd;
         v_iss_cd := a.iss_cd;
         v_pol_seq_no := a.pol_seq_no;
         v_issue_yy := a.issue_yy;
         v_renew_no := a.renew_no;
         v_subpol_id := a.policy_id;
         v_pol_flag := a.pol_flag;

         IF v_pol_flag != '4'
         THEN
            p_cancel_all := 'N';
            EXIT;
         END IF;
      END LOOP;
   END check_package_cancellation;

   PROCEDURE check_mrn (
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_iss_cd       IN   VARCHAR2,
      p_issue_yy     IN   VARCHAR2,
      p_pol_seq_no   IN   VARCHAR2,
      p_renew_no     IN   VARCHAR2
   )
   IS
      v_exist     VARCHAR2 (1)                   := 'N';
      v_subline   giis_subline.subline_cd%TYPE;
   BEGIN
      FOR exist IN (SELECT 'a'
                      FROM gipi_wopen_policy
                     WHERE op_subline_cd = p_subline_cd
                       AND op_iss_cd = p_iss_cd
                       AND op_issue_yy = p_issue_yy
                       AND op_pol_seqno = p_pol_seq_no
                       AND op_renew_no = p_renew_no)
      LOOP
         v_exist := 'Y';
      END LOOP;

      FOR exist1 IN (SELECT 'a'
                       FROM gipi_open_policy
                      WHERE op_subline_cd = p_subline_cd
                        AND op_iss_cd = p_iss_cd
                        AND op_issue_yy = p_issue_yy
                        AND op_pol_seqno = p_pol_seq_no
                        AND op_renew_no = p_renew_no)
      LOOP
         v_exist := 'Y';
      END LOOP;

      FOR mop IN (SELECT subline_cd
                    FROM giis_subline
                   WHERE open_policy_sw = 'Y' AND line_cd = p_line_cd)
      LOOP
         v_subline := mop.subline_cd;
         EXIT;
      END LOOP;

      IF v_exist = 'Y'
      THEN
         raise_application_error
            ('20001',
                'MOP Policy / Endorsement has been used by another declaration policy ('
             || v_subline
             || ').'
            );
      END IF;
   END check_mrn;

   PROCEDURE post_reinstate (
      p_user_id          IN   giis_users.user_id%TYPE,
      p_line_cd          IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd           IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN   gipi_polbasic.renew_no%TYPE,
      p_pack_policy_id   IN   gipi_pack_polbasic.pack_policy_id%TYPE
   )
   IS
      curr_value             VARCHAR2 (1);
      v_sw                   giis_issource.ho_tag%TYPE;
      v_cancel_all           VARCHAR2 (1);
      v_reinstate            VARCHAR2 (1);
      v_cancel_pack_policy   gipi_pack_polbasic.pack_policy_id%TYPE;
      v_max_endt             gipi_polbasic.endt_seq_no%TYPE;
      v_line_cd              giis_line.line_cd%TYPE;
      v_subline_cd           gipi_polbasic.subline_cd%TYPE;
      v_iss_cd               gipi_polbasic.iss_cd%TYPE;
      v_pol_seq_no           gipi_polbasic.pol_seq_no%TYPE;
      v_issue_yy             gipi_polbasic.issue_yy%TYPE;
      v_renew_no             gipi_polbasic.renew_no%TYPE;
      v_subpol_id            gipi_polbasic.policy_id%TYPE;
      v_pol_flag             gipi_polbasic.pol_flag%TYPE;
      v_old_pol_flag         gipi_pack_polbasic.old_pol_flag%TYPE;
      v_cancel_policy        gipi_polbasic.policy_id%TYPE;
      v_acct_ent_date        gipi_polbasic.acct_ent_date%TYPE;
      v_spld_flag            gipi_polbasic.spld_flag%TYPE;
   BEGIN
      v_reinstate := 'N';

      FOR a IN (SELECT   pack_policy_id, acct_ent_date, spld_flag,
                         endt_seq_no
                    FROM gipi_pack_polbasic a
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                     AND pol_flag = '4'
                     AND pack_policy_id <> p_pack_policy_id
                ORDER BY endt_seq_no DESC)
      LOOP
         v_cancel_pack_policy := a.pack_policy_id;
         v_max_endt := a.endt_seq_no;
         EXIT;
      END LOOP;

      check_package_cancellation (v_cancel_all, p_pack_policy_id);

      FOR a IN (SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no,
                       renew_no, policy_id, pol_flag, old_pol_flag
                  FROM gipi_polbasic
                 WHERE pack_policy_id = p_pack_policy_id)
      LOOP
         v_line_cd := a.line_cd;
         v_subline_cd := a.subline_cd;
         v_iss_cd := a.iss_cd;
         v_pol_seq_no := a.pol_seq_no;
         v_issue_yy := a.issue_yy;
         v_renew_no := a.renew_no;
         v_subpol_id := a.policy_id;
         v_pol_flag := a.pol_flag;
         v_old_pol_flag := a.old_pol_flag;

         FOR sub IN (SELECT   policy_id, acct_ent_date, spld_flag,
                              endt_seq_no
                         FROM gipi_polbasic a
                        WHERE line_cd = v_line_cd
                          AND subline_cd = v_subline_cd
                          AND iss_cd = v_iss_cd
                          AND issue_yy = v_issue_yy
                          AND pol_seq_no = v_pol_seq_no
                          AND renew_no = v_renew_no
                          AND pol_flag = '4'
                          AND policy_id <> v_subpol_id
                     ORDER BY endt_seq_no DESC)
         LOOP
            v_cancel_policy := sub.policy_id;
            v_acct_ent_date := sub.acct_ent_date;
            v_spld_flag := sub.spld_flag;
            v_max_endt := sub.endt_seq_no;
            EXIT;
         END LOOP;

         reinstate (v_reinstate,
                    v_cancel_policy,
                    v_line_cd,
                    v_old_pol_flag,
                    v_subline_cd,
                    v_iss_cd,
                    v_issue_yy,
                    v_pol_seq_no,
                    v_renew_no,
                    p_user_id
                   );

         UPDATE gipi_polbasic
            SET reinstate_tag = 'Y'
          WHERE policy_id = v_cancel_policy;
      END LOOP;

      /* reinstate_package (v_cancel_pack_policy,
                          v_old_pol_flag,
                          v_line_cd,
                          v_subline_cd,
                          v_iss_cd,
                          v_issue_yy,
                          v_pol_seq_no,
                          v_renew_no,
                          v_max_endt,
                          p_user_id,
                          p_pack_policy_id
                         ); */
      reinstate_package (v_cancel_pack_policy,
                         v_old_pol_flag,
                         p_line_cd,
                         p_subline_cd,
                         p_iss_cd,
                         p_issue_yy,
                         p_pol_seq_no,
                         p_renew_no,
                         v_max_endt,
                         p_user_id,
                         p_pack_policy_id
                        );
   END post_reinstate;

   PROCEDURE reinstate (
      p_reinstate       OUT      VARCHAR2,
      p_cancel_policy   IN       gipi_polbasic.policy_id%TYPE,
      p_line_cd         IN       gipi_polbasic.line_cd%TYPE,
      p_old_pol_flag    IN       gipi_polbasic.old_pol_flag%TYPE,
      p_subline_cd      IN       gipi_polbasic.subline_cd%TYPE,
      p_iss_cd          IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN       gipi_polbasic.renew_no%TYPE,
      p_user_id         IN       giis_users.user_id%TYPE
   )
   IS
   BEGIN
      FOR a2 IN (SELECT dist_no
                   FROM giuw_pol_dist
                  WHERE policy_id = p_cancel_policy)
      LOOP
         check_reinsurance (a2.dist_no, p_line_cd);
      END LOOP;

      FOR a2 IN (SELECT dist_no
                   FROM giuw_pol_dist
                  WHERE policy_id = p_cancel_policy)
      LOOP
         UPDATE giuw_pol_dist
            SET negate_date = SYSDATE,
                dist_flag = '4'
          WHERE policy_id = p_cancel_policy AND dist_no = a2.dist_no;
      END LOOP;

      UPDATE gipi_polbasic
         SET spld_flag = '3',
             pol_flag = '5',
             spld_date = SYSDATE,
             spld_user_id = p_user_id,
             spld_approval = p_user_id,
             dist_flag = '4',
             user_id = p_user_id,
             last_upd_date = SYSDATE,
             reinstatement_date = SYSDATE
       WHERE policy_id = p_cancel_policy;

      UPDATE gipi_polbasic
         SET pol_flag = p_old_pol_flag
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND issue_yy = p_issue_yy
         AND pol_seq_no = p_pol_seq_no
         AND renew_no = p_renew_no
         AND pol_flag != '5'
         AND policy_id != p_cancel_policy;

      UPDATE eim_takeup_info
         SET eim_flag =
                DECODE (eim_flag,
                        NULL, '3',
                        '1', '3',
                        '2', '5',
                        '4', '5',
                        eim_flag
                       )
       WHERE policy_id = p_cancel_policy;

      update_affected_endt (p_line_cd,
                            p_subline_cd,
                            p_iss_cd,
                            p_issue_yy,
                            p_pol_seq_no,
                            p_renew_no,
                            p_user_id
                           );

      UPDATE gipi_polbasic
         SET eis_flag = 'N'
       WHERE policy_id = p_cancel_policy;

      p_reinstate := 'Y';
   END reinstate;

   PROCEDURE update_affected_endt (
      p_line_cd      IN   VARCHAR2,
      p_subline_cd   IN   VARCHAR2,
      p_iss_cd       IN   VARCHAR2,
      p_issue_yy     IN   VARCHAR2,
      p_pol_seq_no   IN   VARCHAR2,
      p_renew_no     IN   VARCHAR2,
      p_user_id      IN   giis_users.user_id%TYPE
   )
   IS
      v_comp_prem          gipi_witmperl.tsi_amt%TYPE;
      v_prorate            gipi_witmperl.prem_rt%TYPE;
      v_cancel_policy      gipi_polbasic.policy_id%TYPE;
      v_prorate_flag       gipi_polbasic.prorate_flag%TYPE;
      v_endt_exp_date      gipi_polbasic.endt_expiry_date%TYPE;
      v_eff_date           gipi_polbasic.eff_date%TYPE;
      v_short_rt_percent   gipi_polbasic.short_rt_percent%TYPE;
      v_comp_sw            gipi_polbasic.comp_sw%TYPE;
   BEGIN
      FOR a IN (SELECT   policy_id, prorate_flag, endt_expiry_date, eff_date,
                         short_rt_percent, comp_sw
                    FROM gipi_polbasic
                   WHERE line_cd = p_line_cd
                     AND subline_cd = p_subline_cd
                     AND iss_cd = p_iss_cd
                     AND issue_yy = p_issue_yy
                     AND pol_seq_no = p_pol_seq_no
                     AND renew_no = p_renew_no
                ORDER BY endt_seq_no DESC)
      LOOP
         v_cancel_policy := a.policy_id;
         v_prorate_flag := a.prorate_flag;
         v_endt_exp_date := a.endt_expiry_date;
         v_eff_date := a.eff_date;
         v_short_rt_percent := a.short_rt_percent;
         v_comp_sw := a.comp_sw;
         EXIT;
      END LOOP;

      IF v_cancel_policy IS NULL
      THEN
         raise_application_error
                       ('-20001',
                        'RAE NCERF No cancellation endorsement record found.'
                       );
      END IF;

      FOR itmperl IN (SELECT b480.item_no, b480.currency_rt, a170.peril_type,
                             b490.peril_cd, b490.tsi_amt, b490.prem_amt
                        FROM gipi_item b480,
                             giis_peril a170,
                             gipi_itmperil b490
                       WHERE b480.policy_id = b490.policy_id
                         AND b480.item_no = b490.item_no
                         AND b490.line_cd = a170.line_cd
                         AND b490.peril_cd = a170.peril_cd
                         AND b490.policy_id = v_cancel_policy)
      LOOP
         v_comp_prem := NULL;

         IF NVL (v_prorate_flag, 2) = 1
         THEN
            IF v_comp_sw = 'Y'
            THEN
               v_prorate :=
                    ((TRUNC (v_endt_exp_date) - TRUNC (v_eff_date)) + 1
                    )
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            ELSIF v_comp_sw = 'M'
            THEN
               v_prorate :=
                    ((TRUNC (v_endt_exp_date) - TRUNC (v_eff_date)) - 1
                    )
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            ELSE
               v_prorate :=
                    (TRUNC (v_endt_exp_date) - TRUNC (v_eff_date))
                  / (ADD_MONTHS (v_eff_date, 12) - v_eff_date);
            END IF;

            v_comp_prem := itmperl.prem_amt / v_prorate;
         ELSIF NVL (v_prorate_flag, 2) = 2
         THEN
            v_comp_prem := itmperl.prem_amt;
         ELSE
            v_comp_prem := itmperl.prem_amt / (v_short_rt_percent / 100);
         END IF;

         FOR a1 IN (SELECT policy_id
                      FROM gipi_polbasic b250
                     WHERE b250.line_cd = p_line_cd
                       AND b250.subline_cd = p_subline_cd
                       AND b250.iss_cd = p_iss_cd
                       AND b250.issue_yy = p_issue_yy
                       AND b250.pol_seq_no = p_pol_seq_no
                       AND b250.renew_no = p_renew_no
                       AND b250.eff_date > v_eff_date
                       AND b250.endt_seq_no > 0
                       AND b250.pol_flag IN ('1', '2', '3')
                       AND NVL (b250.endt_expiry_date, b250.expiry_date) >=
                                                                    v_eff_date)
         LOOP
            FOR perl IN (SELECT '1'
                           FROM gipi_itmperil b380
                          WHERE b380.item_no = itmperl.item_no
                            AND b380.peril_cd = itmperl.peril_cd
                            AND b380.policy_id = a1.policy_id)
            LOOP
               UPDATE gipi_itmperil
                  SET ann_tsi_amt = ann_tsi_amt + itmperl.tsi_amt,
                      ann_prem_amt =
                            ann_prem_amt + NVL (v_comp_prem, itmperl.prem_amt)
                WHERE policy_id = a1.policy_id
                  AND item_no = itmperl.item_no
                  AND peril_cd = itmperl.peril_cd;
            END LOOP;

            IF itmperl.peril_type = 'B'
            THEN
               UPDATE gipi_item
                  SET ann_tsi_amt = ann_tsi_amt - itmperl.tsi_amt,
                      ann_prem_amt =
                            ann_prem_amt - NVL (v_comp_prem, itmperl.prem_amt)
                WHERE policy_id = a1.policy_id AND item_no = itmperl.item_no;

               UPDATE gipi_polbasic
                  SET ann_tsi_amt =
                           ann_tsi_amt
                         - ROUND ((  itmperl.tsi_amt
                                   * NVL (itmperl.currency_rt, 1)
                                  ),
                                  2
                                 ),
                      ann_prem_amt =
                           ann_prem_amt
                         - ROUND ((  NVL (v_comp_prem, itmperl.prem_amt)
                                   * NVL (itmperl.currency_rt, 1)
                                  ),
                                  2
                                 )
                WHERE policy_id = a1.policy_id;
            ELSE
               UPDATE gipi_item
                  SET ann_prem_amt =
                            ann_prem_amt + NVL (v_comp_prem, itmperl.prem_amt)
                WHERE policy_id = a1.policy_id AND item_no = itmperl.item_no;

               UPDATE gipi_polbasic
                  SET ann_prem_amt =
                           ann_prem_amt
                         - ROUND ((  NVL (v_comp_prem, itmperl.prem_amt)
                                   * NVL (itmperl.currency_rt, 1)
                                  ),
                                  2
                                 )
                WHERE policy_id = a1.policy_id;
            END IF;
         END LOOP;
      END LOOP;
   END update_affected_endt;

   PROCEDURE reinstate_package (
      p_pack_policy_id        IN   gipi_pack_polbasic.pack_policy_id%TYPE,
      p_old_pol_flag          IN   gipi_polbasic.old_pol_flag%TYPE,
      p_line_cd               IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd            IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd                IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy              IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no            IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no              IN   gipi_polbasic.renew_no%TYPE,
      p_max_endt_no           IN   gipi_polbasic.endt_seq_no%TYPE,
      p_user_id               IN   giis_users.user_id%TYPE,
      p_b250_pack_policy_id   IN   gipi_pack_polbasic.pack_policy_id%TYPE
   )
   IS
   BEGIN
      UPDATE gipi_pack_polbasic
         SET spld_flag = '3',
             pol_flag = '5',
             spld_date = SYSDATE,
             spld_user_id = p_user_id,
             spld_approval = p_user_id,
             dist_flag = '4',
             user_id = p_user_id,
             last_upd_date = SYSDATE,
             reinstatement_date = SYSDATE
       WHERE pack_policy_id = p_pack_policy_id;

      UPDATE gipi_pack_polbasic
         SET pol_flag = p_old_pol_flag
       WHERE line_cd = p_line_cd
         AND subline_cd = p_subline_cd
         AND iss_cd = p_iss_cd
         AND issue_yy = p_issue_yy
         AND pol_seq_no = p_pol_seq_no
         AND renew_no = p_renew_no
         AND pol_flag != '5'
         AND pack_policy_id != p_pack_policy_id;

      UPDATE gipi_pack_polbasic
         SET eis_flag = 'N'
       WHERE pack_policy_id = p_pack_policy_id;

      UPDATE gipi_pack_polbasic
         SET reinstate_tag = 'Y'
       WHERE pack_policy_id = p_pack_policy_id;

      create_history (p_max_endt_no, p_b250_pack_policy_id, p_user_id);
   END reinstate_package;

   PROCEDURE create_history (
      p_endt_seq_no      IN   NUMBER,
      p_pack_policy_id   IN   gipi_pack_polbasic.pack_policy_id%TYPE,
      p_user_id          IN   giis_users.user_id%TYPE
   )
   IS
   BEGIN
      INSERT INTO gipi_pack_reinstate_hist
                  (pack_policy_id, hist_id, max_endt_seq_no,
                   user_id, last_update
                  )
           VALUES (p_pack_policy_id, hist_id_s.NEXTVAL, p_endt_seq_no,
                   p_user_id, SYSDATE
                  );
   END create_history;
   
   /* benjo 09.03.2015 UW-SPECS-2015-080 */
   FUNCTION chk_orig_renew_status (
      p_pack_policy_id    gipi_pack_polbasic.pack_policy_id%TYPE
   )
      RETURN chk_orig_renew_status_tab PIPELINED
   IS
      v_rec     chk_orig_renew_status_type;
   BEGIN
      /* FOR x IN (SELECT 1
                  FROM gipi_pack_polbasic a, gipi_pack_polnrep b
                 WHERE a.pack_policy_id = b.old_pack_policy_id
                   AND a.pol_flag IN ('4', '5')
                   AND b.ren_rep_sw = 1
                   AND b.new_pack_policy_id = p_pack_policy_id)
      LOOP
        v_rec.invalid_orig := 'Y';
      END LOOP; */
      -- marco - UCPB SR 21097 - 12.07.2015 - removed validation
      
      IF NVL(v_rec.invalid_orig, 'N') != 'Y' THEN
          FOR y IN (SELECT a.pol_flag
                      FROM gipi_pack_polbasic a, gipi_pack_polnrep b
                     WHERE a.pack_policy_id = b.new_pack_policy_id
                       AND b.ren_rep_sw = 1
                       AND b.old_pack_policy_id = p_pack_policy_id)
          LOOP
            IF y.pol_flag NOT IN ('4', '5') THEN
                v_rec.valid_renew := 'Y';
            ELSIF y.pol_flag = '4' THEN
                v_rec.cancel_renew := 'Y';
            END IF;
          END LOOP;
          
          FOR z IN (SELECT 1
                      FROM gipi_pack_parlist a, gipi_pack_wpolnrep b
                     WHERE a.pack_par_id = b.pack_par_id
                       AND a.par_status IN (98, 99)
                       AND b.old_pack_policy_id = p_pack_policy_id)
          LOOP
            v_rec.cancel_renew := 'Y';
          END LOOP;
      END IF;
      
      PIPE ROW (v_rec);
      RETURN;
   END chk_orig_renew_status;
END;
/


