CREATE OR REPLACE PACKAGE BODY CPI.giacs138_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.02.2013
   **  Reference By : GIACS138- Distribution Register per Treaty Name
   **  Description  :
   */
   FUNCTION get_subline_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_branch_cd   giis_issource.iss_cd%TYPE
   )
      RETURN subline_lov_tab PIPELINED
   IS
      v_rec   subline_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.subline_cd subline_cd,
                                b.subline_name subline_name
                           FROM gipi_polbasic a, giis_subline b
                          WHERE a.line_cd = b.line_cd
                            AND a.subline_cd = b.subline_cd
                            AND a.iss_cd = NVL (p_branch_cd, a.iss_cd)
                            AND a.line_cd = NVL (p_line_cd, a.line_cd))
      LOOP
         v_rec.subline_cd := i.subline_cd;
         v_rec.subline_name := i.subline_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_line_lov (p_user_id giis_users.user_id%TYPE)
      RETURN line_lov_tab PIPELINED
   IS
      v_rec   line_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT line_cd line_cd, line_name line_name
                           FROM giis_line
                          WHERE /*check_user_per_line2 (line_cd,
                                                      NULL,
                                                      'GIACS138',
                                                      p_user_id
                                                     ) = 1*/ --removed by carloR
                                                          /*and line_cd in (select line_cd from giis_user_line where userid = user and tran_cd = 9 and iss_cd = NVL(:misc.iss_code,iss_cd))*/--commented by ailene 052208 to allow checking in giis_user_grp_line
              			 EXISTS (SELECT 'X'
                                                   FROM TABLE (security_access.get_branch_line ('AC', 'GIACS138', p_user_id))) --added by carloR SR-4463 09-30-2016
              )
      LOOP
         v_rec.line_cd := i.line_cd;
         v_rec.line_name := i.line_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   FUNCTION get_branch_lov (p_user_id giis_users.user_id%TYPE)
      RETURN branch_lov_tab PIPELINED
   IS
      v_rec   branch_lov_type;
   BEGIN
      FOR i IN (SELECT DISTINCT iss_cd, iss_name
                           FROM giis_issource
                          WHERE check_user_per_iss_cd_acctg2 (NULL,
                                                              iss_cd,
                                                              'GIACS138',
                                                              p_user_id
                                                             ) = 1
                            AND iss_cd IN (SELECT iss_cd
                                             FROM gipi_polbasic)
                                                                /*commented out and changed by reymon 05252012
                                                                select distinct iss_cd ,iss_name from giis_issource where  Check_User_Per_Iss_Cd2(null,iss_cd,'GIACS138',user) = 1 and
                                                                iss_cd in (select iss_cd from gipi_polbasic)*/
              )
      LOOP
         v_rec.branch_cd := i.iss_cd;
         v_rec.branch_name := i.iss_name;
         PIPE ROW (v_rec);
      END LOOP;
   END;

   PROCEDURE populate_policy (
      p_iss_code       giis_issource.iss_cd%TYPE,
      p_line_code      giis_line.line_cd%TYPE,
      p_subline_code   gipi_polbasic.subline_cd%TYPE,
      p_from_date      DATE,
      p_to_date        DATE,
      p_per_branch     VARCHAR,
      p_user_id        giis_users.user_id%TYPE
   )
   IS
   BEGIN
      DELETE FROM giac_distribution_ext
            WHERE policy_id IS NOT NULL;

      IF p_per_branch = 'I'
      THEN
         FOR i IN
            (SELECT a.policy_id,
                    DECODE (a.endt_seq_no,
                            0, (   a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.issue_yy))
                                || '-'
                                || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (a.renew_no, '09'))
                             ),
                            (   a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.issue_yy))
                             || '-'
                             || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                             || '-'
                             || LTRIM (TO_CHAR (a.renew_no, '09'))
                             || '/'
                             || a.endt_iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_yy))
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                            )
                           ) pol_name,
                    a.acct_ent_date, a.iss_cd, a.subline_cd, a.line_cd
               FROM gipi_polbasic a, giuw_pol_dist b --added by steven 03.10.2014. Confirm to Mam Juday
              WHERE a.iss_cd = NVL (p_iss_code, a.iss_cd)
                AND a.line_cd = NVL (p_line_code, a.line_cd)
                AND a.subline_cd = NVL (p_subline_code, a.subline_cd)
                AND a.policy_id = b.policy_id --added by steven 03.10.2014. Confirm to Mam Juday
                AND (   a.acct_ent_date BETWEEN p_from_date AND p_to_date
                     OR b.acct_neg_date BETWEEN p_from_date AND p_to_date --added by steven 03.10.2014. Confirm to Mam Juday
                    )
                AND check_user_per_line2 (a.line_cd,
                                          NULL,
                                          'GIACS138',
                                          p_user_id
                                         ) = 1
                ----kat 09.12.2007
                AND check_user_per_iss_cd2 (NULL,
                                            a.iss_cd,
                                            'GIACS138',
                                            p_user_id
                                           ) = 1
                --sherwin 092707
                AND DECODE (p_per_branch,
                            'C', NVL (a.cred_branch, a.iss_cd),
                            a.iss_cd
                           ) =
                       NVL (p_iss_code,
                            DECODE (p_per_branch,
                                    'C', NVL (a.cred_branch, a.iss_cd),
                                    a.iss_cd
                                   )
                           ))     --kat 09.12.2007, modified by sherwin 092707
         LOOP
            INSERT INTO giac_distribution_ext
                        (policy_id, pol_name, iss_cd, acct_ent_date,
                         subline_cd, line_cd
                        )
                 VALUES (i.policy_id, i.pol_name, i.iss_cd, i.acct_ent_date,
                         i.subline_cd, i.line_cd
                        );
         END LOOP;
      ELSIF p_per_branch = 'C'
      THEN
         FOR i IN
            (SELECT a.policy_id,
                    DECODE (a.endt_seq_no,
                            0, (   a.line_cd
                                || '-'
                                || a.subline_cd
                                || '-'
                                || a.iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (a.issue_yy))
                                || '-'
                                || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                                || '-'
                                || LTRIM (TO_CHAR (a.renew_no, '09'))
                             ),
                            (   a.line_cd
                             || '-'
                             || a.subline_cd
                             || '-'
                             || a.iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.issue_yy))
                             || '-'
                             || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                             || '-'
                             || LTRIM (TO_CHAR (a.renew_no, '09'))
                             || '/'
                             || a.endt_iss_cd
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_yy))
                             || '-'
                             || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                            )
                           ) pol_name,
                    a.acct_ent_date, NVL (a.cred_branch, a.iss_cd) iss_cd,
                    a.subline_cd, a.line_cd
               FROM gipi_polbasic a, giuw_pol_dist b --added by steven 03.10.2014. Confirm to Mam Juday
              WHERE NVL (a.cred_branch, a.iss_cd) =
                              NVL (p_iss_code, NVL (a.cred_branch, a.iss_cd))
                AND a.line_cd = NVL (p_line_code, a.line_cd)
                AND a.subline_cd = NVL (p_subline_code, a.subline_cd)
                AND a.policy_id = b.policy_id --added by steven 03.10.2014. Confirm to Mam Juday
                AND (   a.acct_ent_date BETWEEN p_from_date AND p_to_date
                     OR b.acct_neg_date BETWEEN p_from_date AND p_to_date --added by steven 03.10.2014. Confirm to Mam Juday
                    )
                AND check_user_per_line2 (a.line_cd,
                                          NULL,
                                          'GIACS138',
                                          p_user_id
                                         ) = 1
                --kat 09.12.2007
                AND check_user_per_iss_cd2 (NULL,
                                            a.iss_cd,
                                            'GIACS138',
                                            p_user_id
                                           ) = 1
                --sherwin 092707
                AND DECODE (p_per_branch,
                            'C', NVL (a.cred_branch, a.iss_cd),
                            a.iss_cd
                           ) = NVL (p_iss_code, a.iss_cd))    --kat 09.12.2007
         LOOP
            INSERT INTO giac_distribution_ext
                        (policy_id, pol_name, iss_cd, acct_ent_date,
                         subline_cd, line_cd
                        )
                 VALUES (i.policy_id, i.pol_name, i.iss_cd, i.acct_ent_date,
                         i.subline_cd, i.line_cd
                        );
         END LOOP;
      END IF;
   END;

   PROCEDURE populate_details (p_user_id giis_users.user_id%TYPE)
   IS
      v_dist_tsi    giuw_policyds_dtl.dist_tsi%TYPE;
      v_dist_prem   giuw_policyds_dtl.dist_prem%TYPE;
   BEGIN
      DELETE FROM giac_dtl_distribution_ext;

      FOR i IN (SELECT DISTINCT a.negate_date, a.policy_id, e.pol_name,
                                e.iss_cd, f.share_cd, f.trty_name,
                                DECODE (c.dist_tsi,
                                        NULL, '0.00',
                                        c.dist_tsi
                                       ) dist_tsi,
                                DECODE (c.dist_prem,
                                        NULL, '0.00',
                                        c.dist_prem
                                       ) dist_prem,
                                e.line_cd, d.line_name, e.subline_cd,
                                g.subline_name, c.dist_no, c.dist_seq_no,
                                e.acct_ent_date
                           FROM giuw_pol_dist a,
                                giuw_policyds b,
                                giuw_policyds_dtl c,
                                giis_line d,
                                giis_dist_share f,
                                giac_distribution_ext e,
                                giis_subline g,
                                gipi_polbasic h               --sherwin 092707
                          WHERE a.dist_no = b.dist_no
                            AND b.dist_no = c.dist_no
                            AND b.dist_seq_no = c.dist_seq_no
                            AND c.line_cd = d.line_cd
                            AND c.line_cd = f.line_cd
                            AND d.line_cd = f.line_cd
                            AND c.share_cd = f.share_cd
                            AND a.policy_id = e.policy_id
                            AND d.line_cd = e.line_cd
                            AND g.subline_cd = e.subline_cd
                            AND d.line_cd = g.line_cd
                            AND a.policy_id = h.policy_id     --sherwin 097207
                            AND check_user_per_iss_cd2 (NULL,
                                                        h.iss_cd,
                                                        'GIACS138',
                                                        p_user_id
                                                       ) = 1  --sherwin 092707
                            AND check_user_per_line2 (h.line_cd,
                                                      NULL,
                                                      'GIACS138',
                                                      p_user_id
                                                     ) = 1    --sherwin 092707
                       ORDER BY e.line_cd, e.subline_cd, a.policy_id)
      LOOP
         --added by steven 03.10.2014. Confirm to Mam Juday; If negate_date have a value the dist_tsi and dist_prem should be in negative value.
         IF i.negate_date IS NOT NULL
         THEN
            v_dist_tsi := -1 * (i.dist_tsi);
            v_dist_prem := -1 * (i.dist_prem);
         ELSE
            v_dist_tsi := i.dist_tsi;
            v_dist_prem := i.dist_prem;
         END IF;

         INSERT INTO giac_dtl_distribution_ext
                     (policy_id, pol_name, iss_cd, share_cd,
                      trty_name, dist_no, dist_seq_no, line_cd,
                      line_name, subline_cd, subline_name,
                      acct_ent_date, dist_tsi, dist_prem
                     )
              VALUES (i.policy_id, i.pol_name, i.iss_cd, i.share_cd,
                      i.trty_name, i.dist_no, i.dist_seq_no, i.line_cd,
                      i.line_name, i.subline_cd, i.subline_name,
                      i.acct_ent_date, v_dist_tsi, v_dist_prem
                     );
      END LOOP;
   END;

   PROCEDURE populate_sum (p_user_id giis_users.user_id%TYPE)
   IS
   BEGIN
      DELETE FROM giac_sum_distribution_ext;

      FOR y IN (SELECT   a.subline_cd, a.line_cd, a.iss_cd, a.share_cd,
                         SUM (a.dist_tsi) sublinetsi,
                         SUM (a.dist_prem) sublineprem
                    FROM giac_dtl_distribution_ext a, gipi_polbasic b
                   WHERE a.policy_id = b.policy_id           --sherwin 097207
                     AND check_user_per_iss_cd2 (NULL,
                                                 b.iss_cd,
                                                 'GIACS138',
                                                 p_user_id
                                                ) = 1         --sherwin 092707
                     AND check_user_per_line2 (b.line_cd,
                                               NULL,
                                               'GIACS138',
                                               p_user_id
                                              ) = 1
                --sherwin 092707
                GROUP BY a.subline_cd, a.line_cd, a.iss_cd, a.share_cd)
      LOOP
         INSERT INTO giac_sum_distribution_ext
                     (subline_cd, line_cd, iss_cd, share_cd,
                      sublinetsi, sublineprem
                     )
              VALUES (y.subline_cd, y.line_cd, y.iss_cd, y.share_cd,
                      y.sublinetsi, y.sublineprem
                     );
      END LOOP;

      FOR l IN (SELECT   a.line_cd, a.iss_cd, a.share_cd,
                         SUM (a.dist_tsi) linetsi, SUM (a.dist_prem) lineprem
                    FROM giac_dtl_distribution_ext a, gipi_polbasic b
                   WHERE a.policy_id = b.policy_id            --sherwin 092707
                     AND check_user_per_iss_cd2 (NULL,
                                                 b.iss_cd,
                                                 'GIACS138',
                                                 p_user_id
                                                ) = 1         --sherwin 092707
                     AND check_user_per_line2 (b.line_cd,
                                               NULL,
                                               'GIACS138',
                                               p_user_id
                                              ) = 1           --sherwin 092707
                GROUP BY a.line_cd, a.iss_cd, a.share_cd)
      LOOP
         UPDATE giac_sum_distribution_ext
            SET linetsi = l.linetsi,
                lineprem = l.lineprem
          WHERE share_cd = l.share_cd
            AND line_cd = l.line_cd
            AND iss_cd = l.iss_cd;
      END LOOP;

      FOR i IN (SELECT   a.iss_cd, a.share_cd, SUM (a.dist_tsi) isstsi,
                         SUM (a.dist_prem) issprem
                    FROM giac_dtl_distribution_ext a, gipi_polbasic b
                   WHERE a.policy_id = b.policy_id            --sherwin 092707
                     AND check_user_per_iss_cd2 (NULL,
                                                 b.iss_cd,
                                                 'GIACS138',
                                                 p_user_id
                                                ) = 1         --sherwin 092707
                     AND check_user_per_line2 (b.line_cd,
                                               NULL,
                                               'GIACS138',
                                               p_user_id
                                              ) = 1
                --sherwin 092707
                GROUP BY a.iss_cd, a.share_cd)
      LOOP
         UPDATE giac_sum_distribution_ext
            SET isstsi = i.isstsi,
                issprem = i.issprem
          WHERE share_cd = i.share_cd AND iss_cd = i.iss_cd;
      END LOOP;
   END;
END;
/


