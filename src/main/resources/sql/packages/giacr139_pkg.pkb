CREATE OR REPLACE PACKAGE BODY CPI.giacr139_pkg
AS
   /*
   **  Created by   : Steven Ramirez
   **  Date Created : 07.03.2013
   **  Reference By : GIACR139- Distribution Share-Treaty
   **  Description  : When I understand this report well enough to finish it,then in that moment I also love doing it.
   */
   FUNCTION get_giacr139_records (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_date_from   DATE,
      p_date_to     DATE,
      p_user_id     giis_users.user_name%TYPE
   )
      RETURN giacr139_records_tab PIPELINED
   IS
      v_rec           giacr139_records_type;
      v_cnt           NUMBER (10)                                := 0;
      v_cnt_subline   NUMBER (10)                                := 1;
      v_cnt_trty      NUMBER (10)                                := 0;
      v_cnt_trty2     NUMBER (10)                                := 0;
      v_prem          NUMBER (20, 2)                             := NULL;
      v_tsi           NUMBER (20, 2)                             := NULL;
      v_isstsi        NUMBER (20, 2)                             := NULL;
      v_issprem       NUMBER (20, 2)                             := NULL;
      v_linetsi       NUMBER (20, 2)                             := NULL;
      v_lineprem      NUMBER (20, 2)                             := NULL;
      v_sublinetsi    NUMBER (20, 2)                             := NULL;
      v_sublineprem   NUMBER (20, 2)                             := NULL;
      v_exist         VARCHAR2 (1)                               := 'N';
      v_same          VARCHAR2 (1)                               := 'N';
      v_policy_id     giac_dtl_distribution_ext.policy_id%TYPE   := NULL;
      v_list_bulk     v_tab;
   BEGIN
      v_rec.cf_company := giisp.v ('COMPANY_NAME');
      v_rec.cf_company_address := giacp.v ('COMPANY_ADDRESS');
      v_rec.cf_from_date := TO_CHAR (p_date_from, 'FMMonth DD, YYYY');
      v_rec.cf_to_date := TO_CHAR (p_date_to, 'FMMonth DD, YYYY');

      SELECT   *
      BULK COLLECT INTO v_list_bulk
          FROM (SELECT DISTINCT trty_name, share_cd
                           FROM giac_dtl_distribution_ext
                          WHERE iss_cd = NVL (p_iss_cd, iss_cd)
                            AND line_cd = NVL (p_line_cd, line_cd)
                            AND acct_ent_date BETWEEN p_date_from AND p_date_to
                            /*AND check_user_per_iss_cd2 (line_cd,
                                                        iss_cd,
                                                        'GIACS138',
                                                        p_user_id
                                                       ) = 1*/ --removed by carloR
                            AND iss_cd IN (SELECT branch_cd
                                                   FROM TABLE (security_access.get_branch_line ('AC', 'GIACS138', p_user_id))) --added by carloR SR-4463 09-30-2016
                UNION
                SELECT 'TOTAL' trty_name, NULL share_cd
                  FROM DUAL)
      ORDER BY share_cd;

      v_cnt := v_list_bulk.COUNT;

      FOR prime IN (SELECT DISTINCT pol_name, iss_cd, line_cd, line_name,
                                    subline_cd, subline_name, policy_id,
                                    dist_no, dist_seq_no
                               FROM giac_dtl_distribution_ext
                              WHERE iss_cd = NVL (p_iss_cd, iss_cd)
                                AND line_cd = NVL (p_line_cd, line_cd)
                                AND acct_ent_date BETWEEN p_date_from
                                                      AND p_date_to
                                /*AND check_user_per_iss_cd2 (line_cd,
                                                            iss_cd,
                                                            'GIACS138',
                                                            p_user_id
                                                           ) = 1*/ --removed by carloR
                                AND iss_cd IN (SELECT branch_cd
                                                   FROM TABLE (security_access.get_branch_line ('AC', 'GIACS138', p_user_id))) --added by carloR SR-4463 09-30-2016
                           ORDER BY policy_id)
      LOOP
         v_exist := 'Y';
         v_rec.pol_name := prime.pol_name;
         v_rec.policy_id := prime.policy_id;
         v_rec.iss_cd := prime.iss_cd;
         v_rec.orig_iss_cd := prime.iss_cd;
         v_rec.line_cd := prime.line_cd;
         v_rec.orig_line_cd := prime.line_cd;
         v_rec.line_name := prime.line_name;
         v_rec.subline_cd := prime.subline_cd;
         v_rec.orig_subline_cd := prime.subline_cd;
         v_rec.subline_name := prime.subline_name;
         v_rec.dist_no := prime.dist_no;
         v_rec.dist_seq_no := prime.dist_seq_no;
         v_rec.dummy_group := 'GROUP_0';
         v_cnt_trty := 0;
         v_cnt_trty2 := 0;

         IF v_policy_id IS NULL
         THEN
            v_policy_id := prime.policy_id;
         ELSE
            IF v_policy_id = prime.policy_id
            THEN
               v_same := 'Y';
               v_rec.orig_subline_cd := NULL;
               v_rec.orig_line_cd := NULL;
            ELSE
               v_same := 'N';
               v_policy_id := prime.policy_id;
            END IF;
         END IF;

         IF v_list_bulk.LAST > 0
         THEN
            FOR i IN v_list_bulk.FIRST .. v_list_bulk.LAST
            LOOP
               IF i > 9
               THEN
                  v_cnt_subline := TRUNC (i / 9);
               END IF;

               v_cnt_trty := v_cnt_trty + 1;
               v_cnt_trty2 := v_cnt_trty2 + 1;

               FOR amt IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.iss_cd,
                                           a.share_cd, a.policy_id,
                                           a.dist_tsi, a.dist_prem, b.isstsi,
                                           b.issprem, b.linetsi, b.lineprem,
                                           b.sublinetsi, b.sublineprem
                                      FROM giac_dtl_distribution_ext a,
                                           giac_sum_distribution_ext b
                                     WHERE a.policy_id = prime.policy_id
                                       AND a.dist_no = prime.dist_no
                                       AND a.dist_seq_no = prime.dist_seq_no
                                       AND a.line_cd = prime.line_cd
                                       AND a.subline_cd = prime.subline_cd
                                       AND a.share_cd =
                                                      v_list_bulk (i).share_cd
                                       AND a.line_cd = b.line_cd
                                       AND a.subline_cd = b.subline_cd
                                       AND a.share_cd = b.share_cd
                                       AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                                       AND a.iss_cd = b.iss_cd
                                       AND a.line_cd =
                                                    NVL (p_line_cd, a.line_cd)
                                       AND a.acct_ent_date BETWEEN p_date_from
                                                               AND p_date_to)
               LOOP
                  v_prem := amt.dist_prem;
                  v_tsi := amt.dist_tsi;
                  EXIT;
               END LOOP;

               IF v_cnt_trty = 1
               THEN
                  v_rec.trty_name1 := v_list_bulk (i).trty_name;
                  v_rec.share_cd1 := v_list_bulk (i).share_cd;
                  v_rec.prem1 := v_prem;
                  v_rec.tsi1 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem1 := NULL;
                        v_rec.tsi1 := NULL;
                     ELSE
                        v_rec.prem1 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi1 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 2
               THEN
                  v_rec.trty_name2 := v_list_bulk (i).trty_name;
                  v_rec.share_cd2 := v_list_bulk (i).share_cd;
                  v_rec.prem2 := v_prem;
                  v_rec.tsi2 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem2 := NULL;
                        v_rec.tsi2 := NULL;
                     ELSE
                        v_rec.prem2 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi2 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 3
               THEN
                  v_rec.trty_name3 := v_list_bulk (i).trty_name;
                  v_rec.share_cd3 := v_list_bulk (i).share_cd;
                  v_rec.prem3 := v_prem;
                  v_rec.tsi3 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem3 := NULL;
                        v_rec.tsi3 := NULL;
                     ELSE
                        v_rec.prem3 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi3 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 4
               THEN
                  v_rec.trty_name4 := v_list_bulk (i).trty_name;
                  v_rec.share_cd4 := v_list_bulk (i).share_cd;
                  v_rec.prem4 := v_prem;
                  v_rec.tsi4 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem4 := NULL;
                        v_rec.tsi4 := NULL;
                     ELSE
                        v_rec.prem4 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi4 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 5
               THEN
                  v_rec.trty_name5 := v_list_bulk (i).trty_name;
                  v_rec.share_cd5 := v_list_bulk (i).share_cd;
                  v_rec.prem5 := v_prem;
                  v_rec.tsi5 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem5 := NULL;
                        v_rec.tsi5 := NULL;
                     ELSE
                        v_rec.prem5 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi5 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 6
               THEN
                  v_rec.trty_name6 := v_list_bulk (i).trty_name;
                  v_rec.share_cd6 := v_list_bulk (i).share_cd;
                  v_rec.prem6 := v_prem;
                  v_rec.tsi6 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem6 := NULL;
                        v_rec.tsi6 := NULL;
                     ELSE
                        v_rec.prem6 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi6 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 7
               THEN
                  v_rec.trty_name7 := v_list_bulk (i).trty_name;
                  v_rec.share_cd7 := v_list_bulk (i).share_cd;
                  v_rec.prem7 := v_prem;
                  v_rec.tsi7 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem7 := NULL;
                        v_rec.tsi7 := NULL;
                     ELSE
                        v_rec.prem7 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi7 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 8
               THEN
                  v_rec.trty_name8 := v_list_bulk (i).trty_name;
                  v_rec.share_cd8 := v_list_bulk (i).share_cd;
                  v_rec.prem8 := v_prem;
                  v_rec.tsi8 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem8 := NULL;
                        v_rec.tsi8 := NULL;
                     ELSE
                        v_rec.prem8 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi8 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;
               ELSIF v_cnt_trty = 9
               THEN
                  v_rec.trty_name9 := v_list_bulk (i).trty_name;
                  v_rec.share_cd9 := v_list_bulk (i).share_cd;
                  v_rec.prem9 := v_prem;
                  v_rec.tsi9 := v_tsi;
                  v_prem := NULL;
                  v_tsi := NULL;

                  IF     v_list_bulk (i).trty_name = 'TOTAL'
                     AND v_list_bulk (i).share_cd IS NULL
                  THEN
                     IF v_same = 'Y'
                     THEN
                        v_rec.prem9 := NULL;
                        v_rec.tsi9 := NULL;
                     ELSE
                        v_rec.prem9 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'PREM'
                                                  );
                        v_rec.tsi9 :=
                           giacr139_pkg.get_total (p_iss_cd,
                                                   p_line_cd,
                                                   p_date_from,
                                                   p_date_to,
                                                   p_user_id,
                                                   prime.policy_id,
                                                   prime.iss_cd,
                                                   prime.line_cd,
                                                   prime.subline_cd,
                                                   v_list_bulk,
                                                   'TSI'
                                                  );
                     END IF;
                  END IF;

                  v_cnt_trty := 0;
                  PIPE ROW (v_rec);
                  v_rec.trty_name1 := NULL;
                  v_rec.trty_name2 := NULL;
                  v_rec.trty_name3 := NULL;
                  v_rec.trty_name4 := NULL;
                  v_rec.trty_name5 := NULL;
                  v_rec.trty_name6 := NULL;
                  v_rec.trty_name7 := NULL;
                  v_rec.trty_name8 := NULL;
                  v_rec.trty_name9 := NULL;
                  v_rec.share_cd1 := NULL;
                  v_rec.share_cd2 := NULL;
                  v_rec.share_cd3 := NULL;
                  v_rec.share_cd4 := NULL;
                  v_rec.share_cd5 := NULL;
                  v_rec.share_cd6 := NULL;
                  v_rec.share_cd7 := NULL;
                  v_rec.share_cd8 := NULL;
                  v_rec.share_cd9 := NULL;
                  v_rec.prem1 := NULL;
                  v_rec.prem2 := NULL;
                  v_rec.prem3 := NULL;
                  v_rec.prem4 := NULL;
                  v_rec.prem5 := NULL;
                  v_rec.prem6 := NULL;
                  v_rec.prem7 := NULL;
                  v_rec.prem8 := NULL;
                  v_rec.prem9 := NULL;
                  v_rec.tsi1 := NULL;
                  v_rec.tsi2 := NULL;
                  v_rec.tsi3 := NULL;
                  v_rec.tsi4 := NULL;
                  v_rec.tsi5 := NULL;
                  v_rec.tsi6 := NULL;
                  v_rec.tsi7 := NULL;
                  v_rec.tsi8 := NULL;
                  v_rec.tsi9 := NULL;
                  v_rec.subline_cd := prime.subline_cd || '_' || v_cnt_subline;
                  v_rec.line_cd := prime.line_cd || '_' || v_cnt_subline;
                  v_rec.iss_cd := prime.iss_cd|| '_' || v_cnt_subline;
                  v_rec.dummy_group := 'GROUP_' || v_cnt_subline;
               END IF;

               IF v_cnt_trty2 = v_cnt AND v_cnt_trty != 0
               THEN
                  v_cnt_trty := 0;
                  PIPE ROW (v_rec);
                  v_rec.trty_name1 := NULL;
                  v_rec.trty_name2 := NULL;
                  v_rec.trty_name3 := NULL;
                  v_rec.trty_name4 := NULL;
                  v_rec.trty_name5 := NULL;
                  v_rec.trty_name6 := NULL;
                  v_rec.trty_name7 := NULL;
                  v_rec.trty_name8 := NULL;
                  v_rec.trty_name9 := NULL;
                  v_rec.share_cd1 := NULL;
                  v_rec.share_cd2 := NULL;
                  v_rec.share_cd3 := NULL;
                  v_rec.share_cd4 := NULL;
                  v_rec.share_cd5 := NULL;
                  v_rec.share_cd6 := NULL;
                  v_rec.share_cd7 := NULL;
                  v_rec.share_cd8 := NULL;
                  v_rec.share_cd9 := NULL;
                  v_rec.prem1 := NULL;
                  v_rec.prem2 := NULL;
                  v_rec.prem3 := NULL;
                  v_rec.prem4 := NULL;
                  v_rec.prem5 := NULL;
                  v_rec.prem6 := NULL;
                  v_rec.prem7 := NULL;
                  v_rec.prem8 := NULL;
                  v_rec.prem9 := NULL;
                  v_rec.tsi1 := NULL;
                  v_rec.tsi2 := NULL;
                  v_rec.tsi3 := NULL;
                  v_rec.tsi4 := NULL;
                  v_rec.tsi5 := NULL;
                  v_rec.tsi6 := NULL;
                  v_rec.tsi7 := NULL;
                  v_rec.tsi8 := NULL;
                  v_rec.tsi9 := NULL;
                  v_rec.subline_cd :=
                                     prime.subline_cd || '_' || v_cnt_subline;
                  v_rec.line_cd := prime.line_cd || '_' || v_cnt_subline;
                  v_rec.iss_cd := prime.iss_cd|| '_' || v_cnt_subline;
                  v_rec.dummy_group := 'GROUP_' || v_cnt_subline;
               END IF;
            END LOOP;
         END IF;
      END LOOP;

      IF v_exist = 'N'
      THEN
         v_rec.exist := 'N';
         PIPE ROW (v_rec);
      END IF;

      RETURN;
   END;

   FUNCTION get_total (
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_date_from    DATE,
      p_date_to      DATE,
      p_user_id      giis_users.user_name%TYPE,
      p_policy_id    giac_dtl_distribution_ext.policy_id%TYPE,
      p_iss_cd2      giis_issource.iss_cd%TYPE,
      p_line_cd2     giac_dtl_distribution_ext.line_cd%TYPE,
      p_subline_cd   giac_dtl_distribution_ext.subline_cd%TYPE,
      p_list         v_tab,
      p_return       VARCHAR2
   )
      RETURN NUMBER
   IS
      v_total_tsi    NUMBER (20, 2) := 0;
      v_total_prem   NUMBER (20, 2) := 0;
   BEGIN
      IF p_list.LAST > 0
      THEN
         FOR i IN p_list.FIRST .. p_list.LAST
         LOOP
            FOR amt IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.iss_cd,
                                        a.share_cd, a.policy_id, a.dist_tsi,
                                        a.dist_prem, b.isstsi, b.issprem,
                                        b.linetsi, b.lineprem, b.sublinetsi,
                                        b.sublineprem
                                   FROM giac_dtl_distribution_ext a,
                                        giac_sum_distribution_ext b
                                  WHERE a.policy_id = p_policy_id
                                    AND a.iss_cd = p_iss_cd2
                                    AND a.line_cd = p_line_cd2
                                    AND a.subline_cd = p_subline_cd
                                    AND a.share_cd = p_list (i).share_cd
                                    AND a.line_cd = b.line_cd
                                    AND a.subline_cd = b.subline_cd
                                    AND a.share_cd = b.share_cd
                                    --and a.policy_id=b.policy_id
                                    AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                                    AND a.iss_cd = b.iss_cd
                                    AND a.line_cd = NVL (p_line_cd, a.line_cd)
                                    AND a.acct_ent_date BETWEEN p_date_from
                                                            AND p_date_to)
            LOOP
               v_total_prem := v_total_prem + amt.dist_prem;
               v_total_tsi := v_total_tsi + amt.dist_tsi;
            END LOOP;
         END LOOP;
      END IF;

      IF p_return = 'TSI'
      THEN
         RETURN v_total_tsi;
      ELSE
         RETURN v_total_prem;
      END IF;
   END;
END;
/


