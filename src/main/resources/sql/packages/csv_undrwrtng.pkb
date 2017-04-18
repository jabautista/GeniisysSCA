CREATE OR REPLACE PACKAGE BODY CPI.CSV_UNDRWRTNG
AS
   /* Modified by: Dean
   ** Date Modified: 03.01.2013
   ** Description: Added Functions CSV_GIPIR210, CSV_GIPIR211, CSV_GIPIR212 UW-SPECS-2013-00001
   */
   --------------------------------- 1 ---------------------------------
   FUNCTION CSV_GIPIR924 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924_type
      PIPELINED
   IS
      v_gipir924         gipir924_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (50);
      v_param_v          VARCHAR2 (1);
      v_total            NUMBER (38, 2);
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                     SUM(DECODE (DECODE (P_SCOPE, 4, NULL, spld_date),
                                 NULL, NVL (a.total_tsi, 0),
                                 0))
                        total_si,
                     SUM(DECODE (DECODE (P_SCOPE, 4, NULL, spld_date),
                                 NULL, NVL (a.total_prem, 0),
                                 0))
                        total_prem,
                     SUM (NVL (DECODE (spld_date, NULL, a.evatprem), 0))
                        evatprem,
                     SUM (NVL (DECODE (spld_date, NULL, a.fst), 0)) fst,
                     SUM (NVL (DECODE (spld_date, NULL, a.lgt), 0)) lgt,
                     SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps), 0))
                        doc_stamps,
                     SUM (NVL (DECODE (spld_date, NULL, a.other_taxes), 0))
                        other_taxes,
                     SUM (NVL (DECODE (spld_date, NULL, a.other_charges), 0))
                        other_charges,
                       SUM (NVL (DECODE (spld_date, NULL, a.total_prem), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.evatprem), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.fst), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.lgt), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.other_taxes), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.other_charges), 0))
                        total,
                     SUM(DECODE (DECODE (P_SCOPE, 4, NULL, spld_date),
                                 NULL, 1,
                                 0))
                        pol_count,
                       SUM (NVL (DECODE (spld_date, NULL, a.evatprem), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.fst), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.lgt), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.other_taxes), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.other_charges), 0))
                        total_taxes,
                     SUM(DECODE (DECODE (P_SCOPE, 4, NULL, spld_date),
                                 NULL, NVL (a.comm_amt, 0),
                                 --get commission amount based on gipi_uwreports_ext not on gipi_comm_invoice by MAC 02/27/2013
                                 0))
                        commission
              FROM /*comment out by MAC 02/27/2013
                               (  SELECT   SUM(DECODE (
                                                   c.ri_comm_amt * c.currency_rt,
                                                   0,
                                                   NVL (b.commission_amt * c.currency_rt, 0),
                                                   c.ri_comm_amt * c.currency_rt
                                                ))
                                               commission_amt,
                                            c.policy_id policy_id
                                     FROM   gipi_comm_invoice b, gipi_invoice c
                                    WHERE   b.iss_cd = c.iss_cd
                                            AND b.prem_seq_no = c.prem_seq_no
                                 GROUP BY   c.policy_id) b,*/
                  gipi_uwreports_ext a
             WHERE --a.policy_id = b.policy_id(+) comment out by MAC 02/27/2013
                  a  .user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND ( (P_SCOPE = 5 AND endt_seq_no = endt_seq_no)
                          OR (    P_SCOPE = 1
                              AND endt_seq_no = 0
                              AND pol_flag <> '5')
                          OR (    P_SCOPE = 2
                              AND endt_seq_no > 0
                              AND pol_flag <> '5')
                          OR (P_SCOPE = 4 AND POL_FLAG = '5'))
          GROUP BY   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd))
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get TOTAL
         FOR A IN (SELECT   param_value_v
                     FROM   giac_parameters
                    WHERE   param_name = 'SHOW_TOTAL_TAXES')
         LOOP
            v_param_v := a.param_value_v;
         END LOOP;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total;
         END IF;

         --get COMMISSION
         /*comment out by MAC 02/27/2013
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         c.ri_comm_amt,
                         c.currency_rt,
                         b.commission_amt,
                         a.spld_date
                  FROM   gipi_comm_invoice b,
                         gipi_invoice c,
                         gipi_uwreports_ext a
                 WHERE       a.policy_id = b.policy_id
                         AND b.prem_seq_no = c.prem_seq_no
                         AND b.iss_cd = c.iss_cd
                         AND a.policy_id = c.policy_id
                         AND a.user_id = p_user_id
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.ISS_CD
                         AND a.line_cd = rec.LINE_CD
                         AND a.subline_cd = rec.SUBLINE_CD
                         AND ( (p_scope = 5 AND a.endt_seq_no = a.endt_seq_no)
                              OR (    p_scope = 1
                                  AND a.endt_seq_no = 0
                                  AND a.pol_flag <> '5')
                              OR (    p_scope = 2
                                  AND a.endt_seq_no > 0
                                  AND a.pol_flag <> '5')
                              OR (p_scope = 4 AND a.pol_flag = '5')))
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   acct_ent_date,
                                 commission_amt,
                                 comm_rec_id,
                                 intm_no
                          FROM   giac_new_comm_inv
                         WHERE       iss_cd = rc.iss_cd
                                 AND prem_seq_no = rc.prem_seq_no
                                 AND fund_cd = v_fund_cd
                                 AND branch_cd = v_branch_cd
                                 AND tran_flag = 'P'
                                 AND NVL (delete_sw, 'N') = 'N'
                      ORDER BY   comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt; --commission

               IF p_scope = 4
               THEN
                  v_commission := v_commission;
               ELSIF rc.spld_date IS NULL
               THEN
                  v_commission := v_commission;
               ELSE
                  v_commission := 0;
               END IF;
            END LOOP;
         END;*/

         v_gipir924.iss_name := v_iss_name;
         v_gipir924.line := rec.line_cd;
         v_gipir924.subline := v_subline;
         v_gipir924.pol_count := rec.pol_count;
         v_gipir924.tot_sum_insured := rec.total_si;
         v_gipir924.tot_premium := rec.total_prem;
         v_gipir924.evat := rec.evatprem;
         v_gipir924.lgt := rec.lgt;
         v_gipir924.doc_stamps := rec.doc_stamps;
         v_gipir924.fire_service_tax := rec.fst;
         v_gipir924.other_charges := rec.other_taxes;
         v_gipir924.total := v_total;
         v_gipir924.commission := rec.commission;
         --get commission amount based on gipi_uwreports_ext table by MAC 02/27/2013

         PIPE ROW (v_gipir924);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 2 ---------------------------------

   FUNCTION CSV_GIPIR924J (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924j_type
      PIPELINED
   IS
      v_gipir924j   gipir924j_rec_type;
      v_iss_name    VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
      v_param_v     VARCHAR2 (1);
      v_total       NUMBER (38, 2);
   BEGIN
      FOR rec
      IN (  SELECT   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, gp.cred_branch, gp.iss_cd) iss_cd,
                     SUM (NVL (total_tsi, 0)) total_si,
                     SUM (NVL (total_prem, 0)) total_prem,
                     SUM (NVL (evatprem, 0)) evatprem,
                     SUM (NVL (fst, 0)) fst,
                     SUM (NVL (lgt, 0)) lgt,
                     SUM (NVL (doc_stamps, 0)) doc_stamps,
                     SUM (NVL (other_taxes, 0)) other_taxes,
                     SUM (NVL (other_charges, 0)) other_charges,
                       SUM (NVL (total_prem, 0))
                     + SUM (NVL (evatprem, 0))
                     + SUM (NVL (fst, 0))
                     + SUM (NVL (lgt, 0))
                     + SUM (NVL (doc_stamps, 0))
                     + SUM (NVL (other_taxes, 0))
                     + SUM (NVL (other_charges, 0))
                        total,
                     COUNT (policy_id) pol_count,
                       SUM (NVL (evatprem, 0))
                     + SUM (NVL (fst, 0))
                     + SUM (NVL (lgt, 0))
                     + SUM (NVL (doc_stamps, 0))
                     + SUM (NVL (other_taxes, 0))
                     + SUM (NVL (other_charges, 0))
                        total_taxes
              FROM   gipi_uwreports_ext gp
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, gp.cred_branch, gp.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param,
                                      1, gp.cred_branch,
                                      gp.iss_cd)
                           )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND p_scope = 3
                     AND pol_flag = '4'
          GROUP BY   iss_cd,
                     line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, gp.cred_branch, gp.iss_cd))
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get TOTAL
         FOR A IN (SELECT   param_value_v
                     FROM   giac_parameters
                    WHERE   param_name = 'SHOW_TOTAL_TAXES')
         LOOP
            v_param_v := a.param_value_v;
         END LOOP;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total;
         END IF;

         v_gipir924j.iss_name := v_iss_name;
         v_gipir924j.line := rec.line_cd;
         v_gipir924j.subline := v_subline;
         v_gipir924j.pol_count := rec.pol_count;
         v_gipir924j.tot_sum_insured := rec.total_si;
         v_gipir924j.tot_premium := rec.total_prem;
         v_gipir924j.evat := rec.evatprem;
         v_gipir924j.lgt := rec.lgt;
         v_gipir924j.doc_stamps := rec.doc_stamps;
         v_gipir924j.fire_service_tax := rec.fst;
         v_gipir924j.other_charges := rec.other_taxes;
         v_gipir924j.total := v_total;

         PIPE ROW (v_gipir924j);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 3 ---------------------------------

   /* Modified by Abegail Pascual
 ** Date modified : 09.14.2012
 ** Description : Consolidate fixes from RSIC SR 10341
 ** and UCPBGEN SR 10440
 ** Fix discrepancies found for commission amount
 **
 ** Udel 09292012 @PNBGEN
 ** Synchronized SELECT query of CSV_GIPIR923 to
 ** GIPIR923 6/15/2009 6:13 PM version
 */
   FUNCTION csv_gipir923 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923_type
      PIPELINED
   IS
      v_gipir923         gipir923_rec_type;
      v_iss_name         VARCHAR2 (100);
      v_line             VARCHAR2 (50);
      v_subline          VARCHAR2 (30);
      v_policy_no        VARCHAR2 (100);
      v_endt_no          VARCHAR2 (30);
      v_ref_pol_no       VARCHAR2 (35) := NULL;
      v_assured          VARCHAR2 (500);
      v_param_value_v    giis_parameters.param_value_v%TYPE;
      v_testing          VARCHAR2 (50);
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
      v_param_v          VARCHAR2 (1);
      v_total            NUMBER (38, 2);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (a.spld_date,
                             NULL, DECODE (a.dist_flag, 3, 'D', 'U'),
                             'S')
                        dist_flag,
                     a.line_cd,
                     a.subline_cd,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                        iss_cd_head,
                     a.iss_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     a.issue_date,
                     a.incept_date,
                     a.expiry_date,
                     DECODE (a.spld_date, NULL, a.total_tsi, 0) total_tsi,
                     DECODE (a.spld_date, NULL, a.total_prem, 0) total_prem,
                     DECODE (a.spld_date, NULL, a.evatprem, 0) evatprem,
                     DECODE (a.spld_date, NULL, a.lgt, 0) lgt,
                     DECODE (a.spld_date, NULL, a.doc_stamps, 0) doc_stamp,
                     DECODE (a.spld_date, NULL, a.fst, 0) fst,
                     DECODE (a.spld_date, NULL, a.other_taxes, 0) other_taxes,
                     DECODE (
                        a.spld_date,
                        NULL,
                        (  a.total_prem
                         + a.evatprem
                         + a.lgt
                         + a.doc_stamps
                         + a.fst
                         + a.other_taxes),
                        0
                     )
                        total_charges,
                     DECODE (
                        spld_date,
                        NULL,
                        (  a.evatprem
                         + a.lgt
                         + a.doc_stamps
                         + a.fst
                         + a.other_taxes),
                        0
                     )
                        total_taxes,
                     a.param_date,
                     a.from_date,
                     a.TO_DATE,
                     a.SCOPE,
                     a.user_id,
                     a.policy_id,
                     a.assd_no,
                     DECODE (
                        a.spld_date,
                        NULL,
                        NULL,
                        ' S   P  O  I  L  E  D       /       '
                        || TO_CHAR (a.spld_date, 'MM-DD-YYYY')
                     )
                        spld_date,
                     DECODE (a.spld_date, NULL, 1, 0) pol_count,
                     DECODE (a.spld_date, NULL, NVL (a.comm_amt, 0), 0)
                        commission_amt,
                     --DECODE(a.spld_date,NULL,NVL(b.commission_amt2,0),0) commission_amt, -- adpascual 09122012
                     DECODE (a.spld_date, NULL, NVL (b.wholding_tax2, 0), 0)
                        wholding_tax,
                     DECODE (a.spld_date, NULL, NVL (b.net_comm2, 0), 0)
                        net_comm,
                     b.ref_inv_no2
              FROM   (  SELECT   SUM(DECODE (
                                        c.ri_comm_amt * c.currency_rt,
                                        0,
                                        NVL (b.commission_amt * c.currency_rt, 0),
                                        c.ri_comm_amt * c.currency_rt
                                     ))
                                    commission_amt2,
                                 SUM (NVL (b.wholding_tax, 0)) wholding_tax2,
                                 SUM(NVL (b.commission_amt, 0)
                                     - NVL (b.wholding_tax, 0))
                                    net_comm2,
                                 c.policy_id policy_id2,
                                 --c.ref_inv_no ref_inv_no2 --Commented by Hero 08.14.2012; Replaced with the query below
                                 c.iss_cd || '-' || c.prem_seq_no
                                 --Added by Hero 08.14.2012; To print the appropriate invoice number for the policies
                                 || DECODE (c.ref_inv_no,
                                            '', '',
                                            ' / ' || c.ref_inv_no)
                                    ref_inv_no2
                          FROM   gipi_comm_invoice b, gipi_invoice c
                         WHERE   b.iss_cd = c.iss_cd
                                 AND b.prem_seq_no = c.prem_seq_no
                      --GROUP BY   c.policy_id, c.ref_inv_no) b,
                      GROUP BY   c.policy_id,
                                 c.iss_cd,
                                 c.prem_seq_no,
                                 c.ref_inv_no) b,
                     --Modified by Hero 08.14.2012,
                     gipi_uwreports_ext a
             WHERE   a.policy_id = b.policy_id2(+) AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND ( (p_scope = 5 AND a.endt_seq_no = a.endt_seq_no AND pol_flag <> '5') --added pol_flag by robert 03.20.15
                          OR (    p_scope = 1
                              AND a.endt_seq_no = 0
                              AND a.pol_flag <> '5')
                          OR (    p_scope = 2
                              AND a.endt_seq_no > 0
                              AND a.pol_flag <> '5')
                          --OR  (p_scope=4 AND a.pol_flag='5' )) -- Udel 09292012 replaced by code below
                          OR (p_scope = 3 AND a.pol_flag = '4'))
          ORDER BY   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     a.line_cd,
                     a.subline_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.iss_cd_head;

            -- rec.iss_cd;  adpascual 08.17.2012
            v_iss_name := rec.iss_cd_head || ' - ' || v_iss_name;
         --  rec.ISS_CD||' - '||v_iss_name; -- adpascual 08.30.2012
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR b IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.line_cd)
         LOOP
            v_line := b.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.line_cd AND subline_cd = rec.subline_cd)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get POLICY_NO
         BEGIN
            v_policy_no :=
                  rec.line_cd
               || '-'
               || rec.subline_cd
               || '-'
               || LTRIM (rec.iss_cd)
               || '-'
               || LTRIM (TO_CHAR (rec.issue_yy, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.pol_seq_no))
               || '-'
               || LTRIM (TO_CHAR (rec.renew_no, '09'));

            IF rec.endt_seq_no <> 0
            THEN
               v_endt_no :=
                     rec.endt_iss_cd
                  || '-'
                  || LTRIM (TO_CHAR (rec.endt_yy, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.endt_seq_no));
            ELSE
               v_endt_no := NULL;
            --Added by Hero 08.14.2012; To be used by policies with no endorsements
            END IF;

            BEGIN
               SELECT   ref_pol_no
                 INTO   v_ref_pol_no
                 FROM   gipi_polbasic
                WHERE   policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_pol_no := NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         --get ASSURED
         FOR c IN (SELECT   assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         --get INVOICE
         BEGIN
            SELECT   param_value_v
              INTO   v_param_value_v
              FROM   giis_parameters
             WHERE   param_name = 'PRINT_REF_INV';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_param_value_v := NULL;
         END;

         IF v_param_value_v = 'N'
         THEN
            v_testing := rec.issue_date;
         ELSE
            v_testing := rec.ref_inv_no2;
         END IF;

         --get TOTAL
         FOR a IN (SELECT   param_value_v
                     FROM   giac_parameters
                    WHERE   param_name = 'SHOW_TOTAL_TAXES')
         LOOP
            v_param_v := a.param_value_v;
         END LOOP;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total_charges;
         END IF;

         --get COMMISSION
         /* commented out segment code since commission amount was already
         ** retrieved on the first select or cursor
         ** adpascual 09.14.2012
         BEGIN

            SELECT DISTINCT TO_DATE
              INTO v_to_date
              FROM gipi_uwreports_ext
             WHERE user_id = p_user_id;

            v_fund_cd   := giacp.v('FUND_CD');
            v_branch_cd := giacp.v('BRANCH_CD');

            FOR rc IN (SELECT b.intrmdry_intm_no, b.iss_cd, b.prem_seq_no, c.ri_comm_amt, c.currency_rt, b.commission_amt
                         FROM gipi_comm_invoice  b,
                              gipi_invoice c,
                              gipi_uwreports_ext a
                        WHERE a.policy_id  = c.policy_id
                          AND b.iss_cd  = c.iss_cd
                          AND b.prem_seq_no  = c.prem_seq_no
                          AND a.user_id    = p_user_id
                          AND DECODE(p_iss_param,1,a.cred_branch,a.iss_cd)     = rec.iss_cd_head
                          AND a.line_cd    = rec.line_cd
                          AND a.subline_cd = rec.subline_cd
                          AND a.policy_id = rec.policy_id
                          AND ((p_scope=5 AND a.endt_seq_no= a.endt_seq_no )
                           OR  (p_scope=1 AND a.endt_seq_no=0 AND a.pol_flag <> '5' )
                           OR  (p_scope=2 AND a.endt_seq_no>0 AND a.pol_flag <> '5' )
                           OR  (p_scope=3 AND a.pol_flag='4' )) )
            LOOP
              IF (rc.ri_comm_amt * rc.currency_rt) = 0 THEN
                 v_commission_amt := rc.commission_amt;
                 FOR c1 IN (SELECT acct_ent_date, commission_amt, comm_rec_id, intm_no
                              FROM giac_new_comm_inv
                           WHERE iss_cd = rc.iss_cd
                               AND prem_seq_no = rc.prem_seq_no
                               AND fund_cd            = v_fund_cd
                               AND branch_cd          = v_branch_cd
                               AND tran_flag          = 'P'
                               AND NVL(delete_sw,'N') = 'N'
                          ORDER BY comm_rec_id DESC)
                 LOOP
                   IF c1.acct_ent_date > v_to_date THEN
                     FOR c2 IN (SELECT commission_amt
                                  FROM giac_prev_comm_inv
                              WHERE fund_cd = v_fund_cd
                                AND branch_cd = v_branch_cd
                                AND comm_rec_id = c1.comm_rec_id
                                AND intm_no = c1.intm_no)
                     LOOP
                       v_commission_amt := c2.commission_amt;
                     END LOOP;
                   ELSE
                     v_commission_amt := c1.commission_amt;
                   END IF;
                   EXIT;
                 END LOOP;
                  v_comm_amt := NVL(v_commission_amt * rc.currency_rt,0);
              ELSE
                v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
              END IF;
              v_commission := NVL(v_commission,0) + v_comm_amt;
              IF rec.spld_date IS NOT NULL THEN
                 v_commission := 0;
              END IF;
            END LOOP;
          END;*/
         v_gipir923.iss_name := v_iss_name;
         v_gipir923.line := v_line;
         v_gipir923.subline := v_subline;
         v_gipir923.stat := rec.dist_flag;
         v_gipir923.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir923.assured := v_assured;
         v_gipir923.invoice := v_testing;
         v_gipir923.incept_date := rec.incept_date;
         v_gipir923.expiry_date := rec.expiry_date;
         v_gipir923.total_si := rec.total_tsi;
         v_gipir923.tot_premium := rec.total_prem;
         v_gipir923.evat := rec.evatprem;
         v_gipir923.lgt := rec.lgt;
         v_gipir923.doc_stamps := rec.doc_stamp;
         v_gipir923.fire_service_tax := rec.fst;
         v_gipir923.other_charges := rec.other_taxes;
         v_gipir923.total := v_total;
         v_gipir923.commission := rec.commission_amt;
         --v_commission; --commented out. adpascual 09.14.2012
         PIPE ROW (v_gipir923);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 4 ---------------------------------

   FUNCTION CSV_GIPIR923E (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923e_type
      PIPELINED
   IS
      v_gipir923e    gipir923e_rec_type;
      v_iss_name     VARCHAR2 (100);
      v_line         VARCHAR2 (50);
      v_subline      VARCHAR2 (30);
      v_policy_no    VARCHAR2 (100);
      v_endt_no      VARCHAR2 (30);
      v_ref_pol_no   VARCHAR2 (35) := NULL;
      v_assured      VARCHAR2 (500);

      v_param_v      VARCHAR2 (1);
      v_total        NUMBER (38, 2);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (SPLD_DATE,
                             NULL, DECODE (dist_flag, 3, 'D', 'U'),
                             'S')
                        DIST_FLAG,
                     line_cd,
                     subline_cd,
                     iss_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd_header,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no,
                     issue_date,
                     incept_date,
                     expiry_date,
                     total_tsi,
                     total_prem,
                     evatprem,
                     lgt,
                     fst,
                     doc_stamps,
                     other_taxes,
                     (  total_prem
                      + evatprem
                      + lgt
                      + doc_stamps
                      + fst
                      + other_taxes)
                        TOTAL_CHARGES,
                     (evatprem + lgt + doc_stamps + fst + other_taxes)
                        TOTAL_TAXES,
                     param_date,
                     from_date,
                     TO_DATE,
                     scope,
                     user_id,
                     policy_id,
                     assd_no,
                     SPLD_DATE,
                     DECODE (SPLD_DATE, NULL, 1, 1) POL_COUNT
              FROM   GIPI_UWREPORTS_EXT
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (p_scope = 4 AND pol_flag = '5')
          ORDER BY   line_cd,
                     subline_cd,
                     iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR b IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.LINE_CD)
         LOOP
            v_line := b.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get POLICY_NO
         BEGIN
            V_POLICY_NO :=
                  rec.LINE_CD
               || '-'
               || rec.SUBLINE_CD
               || '-'
               || LTRIM (rec.ISS_CD)
               || '-'
               || LTRIM (TO_CHAR (rec.ISSUE_YY, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.POL_SEQ_NO))
               || '-'
               || LTRIM (TO_CHAR (rec.RENEW_NO, '09'));

            IF rec.ENDT_SEQ_NO <> 0
            THEN
               V_ENDT_NO :=
                     rec.ENDT_ISS_CD
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_YY, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_SEQ_NO));
            END IF;

            BEGIN
               SELECT   ref_pol_no
                 INTO   v_ref_pol_no
                 FROM   gipi_polbasic
                WHERE   policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_pol_no := NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         --get ASSURED
         FOR c IN (SELECT   assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         --get TOTAL
         FOR A IN (SELECT   param_value_v
                     FROM   giac_parameters
                    WHERE   param_name = 'SHOW_TOTAL_TAXES')
         LOOP
            v_param_v := a.param_value_v;
         END LOOP;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total_charges;
         END IF;

         v_gipir923e.iss_name := v_iss_name;
         v_gipir923e.line := v_line;
         v_gipir923e.subline := v_subline;
         v_gipir923e.stat := rec.dist_flag;
         v_gipir923e.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir923e.assured := v_assured;
         v_gipir923e.issue_date := rec.issue_date;
         v_gipir923e.incept_date := rec.incept_date;
         v_gipir923e.expiry_date := rec.expiry_date;
         v_gipir923e.spoiled := rec.spld_date;
         v_gipir923e.total_si := rec.total_tsi;
         v_gipir923e.tot_premium := rec.total_prem;
         v_gipir923e.evat := rec.evatprem;
         v_gipir923e.lgt := rec.lgt;
         v_gipir923e.doc_stamps := rec.doc_stamps;
         v_gipir923e.fire_service_tax := rec.fst;
         v_gipir923e.other_charges := rec.other_taxes;
         v_gipir923e.total := v_total;

         PIPE ROW (v_gipir923e);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 5 ---------------------------------

   FUNCTION CSV_GIPIR923C (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923c_type
      PIPELINED
   IS
      v_gipir923c   gipir923c_rec_type;
      v_iss_name    VARCHAR2 (100);
      v_line        VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
      v_assured     VARCHAR2 (500);
   BEGIN
      FOR rec
      IN (SELECT   TO_NUMBER (NVL (TO_CHAR (ACCT_ENT_DATE, 'MM'), '13'))
                      ACCTG_SEQ,
                   NVL (TO_CHAR (ACCT_ENT_DATE, 'FmMonth, RRRR'),
                        'NOT TAKEN UP')
                      ACCT_ENT_DATE,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                      iss_cd_header,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no,
                   GET_POLICY_NO (POLICY_ID) POLICY_NO,
                   issue_date,
                   incept_date,
                   expiry_date,
                   total_tsi TOTAL_TSI,
                   total_prem TOTAL_PREM,
                   EVATPREM EVATPREM,
                   lgt LGT,
                   doc_stamps DOC_STAMP,
                   fst FST,
                   other_taxes OTHER_TAXES,
                   (  total_prem
                    + evatprem
                    + lgt
                    + doc_stamps
                    + fst
                    + other_taxes)
                      TOTAL_CHARGES,
                   param_date,
                   from_date,
                   TO_DATE,
                   scope,
                   user_id,
                   policy_id,
                   assd_no
            FROM   GIPI_UWREPORTS_EXT a
           WHERE   user_id = p_user_id
                   AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                         NVL (
                            p_iss_cd,
                            DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                         )
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND ( (    p_scope = 5
                          AND endt_seq_no = endt_seq_no
                          AND spld_date IS NULL)
                        OR (    p_scope = 1
                            AND endt_seq_no = 0
                            AND spld_date IS NULL)
                        OR (    p_scope = 2
                            AND endt_seq_no > 0
                            AND spld_date IS NULL)
                        OR (p_scope = 4 AND pol_flag = '5'))
          UNION
          SELECT   TO_NUMBER (NVL (TO_CHAR (SPLD_ACCT_ENT_DATE, 'MM'), '13'))
                      ACCTG_SEQ,
                   NVL (TO_CHAR (spld_ACCT_ENT_DATE, 'FmMonth, RRRR'),
                        'NOT TAKEN UP')
                      ACCT_ENT_DATE,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                      iss_cd_header,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no,
                   GET_POLICY_NO (POLICY_ID) || '*' POLICY_NO,
                   issue_date,
                   incept_date,
                   expiry_date,
                   -1 * total_tsi TOTAL_TSI,
                   -1 * total_prem TOTAL_PREM,
                   -1 * EVATPREM EVATPREM,
                   -1 * lgt LGT,
                   -1 * doc_stamps DOC_STAMP,
                   -1 * fst FST,
                   -1 * other_taxes OTHER_TAXES,
                   -1
                   * (  total_prem
                      + evatprem
                      + lgt
                      + doc_stamps
                      + fst
                      + other_taxes)
                      TOTAL_CHARGES,
                   param_date,
                   from_date,
                   TO_DATE,
                   scope,
                   user_id,
                   policy_id,
                   assd_no
            FROM   GIPI_UWREPORTS_EXT a
           WHERE   user_id = p_user_id
                   AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                         NVL (
                            p_iss_cd,
                            DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                         )
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND ( (    p_scope = 5
                          AND endt_seq_no = endt_seq_no
                          AND spld_date IS NULL)
                        OR (    p_scope = 1
                            AND endt_seq_no = 0
                            AND spld_date IS NULL)
                        OR (    p_scope = 2
                            AND endt_seq_no > 0
                            AND spld_date IS NULL)
                        OR (p_scope = 4 AND pol_flag = '5'))
                   AND SPLD_ACCT_ENT_DATE IS NOT NULL
          ORDER BY   ACCTG_SEQ,
                     line_cd,
                     subline_cd,
                     iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR b IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.LINE_CD)
         LOOP
            v_line := b.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get ASSURED
         FOR c IN (SELECT   assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         v_gipir923c.iss_name := v_iss_name;
         v_gipir923c.line := v_line;
         v_gipir923c.subline := v_subline;
         v_gipir923c.acct_ent_date := rec.acct_ent_date;
         v_gipir923c.policy_no := rec.policy_no;
         v_gipir923c.assured := v_assured;
         v_gipir923c.issue_date := rec.issue_date;
         v_gipir923c.incept_date := rec.incept_date;
         v_gipir923c.expiry_date := rec.expiry_date;
         v_gipir923c.total_si := rec.total_tsi;
         v_gipir923c.tot_premium := rec.total_prem;
         v_gipir923c.evat := rec.evatprem;
         v_gipir923c.lgt := rec.lgt;
         v_gipir923c.doc_stamps := rec.doc_stamp;
         v_gipir923c.fire_service_tax := rec.fst;
         v_gipir923c.other_charges := rec.other_taxes;
         v_gipir923c.total := rec.total_charges;

         PIPE ROW (v_gipir923c);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 6 ---------------------------------

   FUNCTION CSV_GIPIR923F (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923f_type
      PIPELINED
   IS
      v_gipir923f   gipir923f_rec_type;
      v_iss_name    VARCHAR2 (100);
      v_line        VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
      v_assured     VARCHAR2 (500);
   BEGIN
      FOR rec
      IN (SELECT   TO_NUMBER (NVL (TO_CHAR (ACCT_ENT_DATE, 'MM'), '13'))
                      ACCTG_SEQ,
                   NVL (TO_CHAR (ACCT_ENT_DATE, 'FmMonth, RRRR'),
                        'NOT TAKEN UP')
                      ACCT_ENT_DATE,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   DECODE (p_iss_param, 1, cred_branch, iss_cd) ISS_CD_HEAD,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no,
                   GET_POLICY_NO (POLICY_ID) POLICY_NO,
                   issue_date,
                   incept_date,
                   expiry_date,
                   total_tsi TOTAL_TSI,
                   lgt LGT,
                   doc_stamps DOC_STAMP,
                   total_prem TOTAL_PREM,
                   EVATPREM EVATPREM,
                   fst FST,
                   other_taxes OTHER_TAXES,
                   (  total_prem
                    + evatprem
                    + lgt
                    + doc_stamps
                    + fst
                    + other_taxes)
                      TOTAL_CHARGES,
                   param_date,
                   from_date,
                   TO_DATE,
                   scope,
                   user_id,
                   policy_id,
                   assd_no,
                   spld_date
            FROM   GIPI_UWREPORTS_EXT
           WHERE   user_id = p_user_id
                   AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                         NVL (p_iss_cd,
                              DECODE (p_iss_param, 1, cred_branch, iss_cd))
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                        OR (p_scope = 1 AND endt_seq_no = 0)
                        OR (p_scope = 2 AND endt_seq_no > 0)
                        OR (p_scope = 4 AND pol_flag = '5'))
          UNION
          SELECT   TO_NUMBER (NVL (TO_CHAR (SPLD_ACCT_ENT_DATE, 'MM'), '13'))
                      ACCTG_SEQ,
                   NVL (TO_CHAR (spld_ACCT_ENT_DATE, 'FmMonth, RRRR'),
                        'NOT TAKEN UP')
                      ACCT_ENT_DATE,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   DECODE (p_iss_param, 1, cred_branch, iss_cd) ISS_CD_HEAD,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no,
                   GET_POLICY_NO (POLICY_ID) || '*' POLICY_NO,
                   issue_date,
                   incept_date,
                   expiry_date,
                   -1 * total_tsi TOTAL_TSI,
                   -1 * total_prem TOTAL_PREM,
                   -1 * EVATPREM EVATPREM,
                   -1 * lgt LGT,
                   -1 * doc_stamps DOC_STAMP,
                   -1 * fst FST,
                   -1 * other_taxes OTHER_TAXES,
                   -1
                   * (  total_prem
                      + evatprem
                      + lgt
                      + doc_stamps
                      + fst
                      + other_taxes)
                      TOTAL_CHARGES,
                   param_date,
                   from_date,
                   TO_DATE,
                   scope,
                   user_id,
                   policy_id,
                   assd_no,
                   spld_date
            FROM   GIPI_UWREPORTS_EXT
           WHERE   user_id = p_user_id
                   AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                         NVL (p_iss_cd,
                              DECODE (p_iss_param, 1, cred_branch, iss_cd))
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND (   (p_scope = 5 AND endt_seq_no = endt_seq_no)
                        OR (p_scope = 1 AND endt_seq_no = 0)
                        OR (p_scope = 2 AND endt_seq_no > 0)
                        OR (p_scope = 4 AND pol_flag = '5'))
                   AND SPLD_ACCT_ENT_DATE IS NOT NULL
          ORDER BY   ACCTG_SEQ,
                     line_cd,
                     subline_cd,
                     iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR b IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.LINE_CD)
         LOOP
            v_line := b.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get ASSURED
         FOR c IN (SELECT   assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         v_gipir923f.iss_name := v_iss_name;
         v_gipir923f.line := v_line;
         v_gipir923f.subline := v_subline;
         v_gipir923f.acct_ent_date := rec.acct_ent_date;
         v_gipir923f.policy_no := rec.policy_no;
         v_gipir923f.assured := v_assured;
         v_gipir923f.issue_date := rec.issue_date;
         v_gipir923f.incept_date := rec.incept_date;
         v_gipir923f.expiry_date := rec.expiry_date;
         v_gipir923f.spld_date := rec.spld_date;
         v_gipir923f.total_si := rec.total_tsi;
         v_gipir923f.tot_premium := rec.total_prem;
         v_gipir923f.evat := rec.evatprem;
         v_gipir923f.lgt := rec.lgt;
         v_gipir923f.doc_stamps := rec.doc_stamp;
         v_gipir923f.fire_service_tax := rec.fst;
         v_gipir923f.other_charges := rec.other_taxes;
         v_gipir923f.total := rec.total_charges;

         PIPE ROW (v_gipir923f);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 7 ---------------------------------

   FUNCTION CSV_GIPIR930A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir930a_type
      PIPELINED
   IS
      v_gipir930a    gipir930a_rec_type;
      v_iss_name     VARCHAR2 (50);
      v_total_si     GIPI_UWREPORTS_RI_EXT.total_si%TYPE := 0;
      v_total_prem   GIPI_UWREPORTS_RI_EXT.total_prem%TYPE := 0;
      v_reinsured    GIPI_UWREPORTS_RI_EXT.sum_reinsured%TYPE := 0;

      v_param_v      VARCHAR2 (1);
      v_total        NUMBER (38, 2);
   BEGIN
      FOR rec
      IN (  SELECT   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                     INITCAP (line_name) line_name,
                     INITCAP (subline_name) subline_name,
                     SUM (NVL (total_si, 0)) TSI,
                     SUM (NVL (total_prem, 0)) PREM,
                     SUM (NVL (sum_reinsured, 0)) REINSURED,
                     SUM (NVL (share_premium, 0)) SHARE_PREM,
                     SUM (NVL (ri_comm_amt, 0)) RI_COMM,
                     SUM (NVL (net_due, 0)) NET_DUE,
                     COUNT (DISTINCT BINDER_NO) BINDER_COUNT,
                     SUM (NVL (ri_prem_vat, 0)) RI_PREM_VAT,
                     SUM (NVL (ri_comm_vat, 0)) RI_COMM_VAT,
                     SUM (NVL (ri_wholding_vat, 0)) RI_WHOLDING_VAT
              FROM   gipi_uwreports_ri_ext
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd),
                     line_name,
                     subline_name)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUM_INSURED, PREMIUM
         BEGIN
            FOR c1
            IN (SELECT   DISTINCT policy_id, dist_no
                  FROM   GIPI_UWREPORTS_RI_EXT
                 WHERE   user_id = p_user_id
                         AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0))
                         AND line_cd = rec.line_cd
                         AND subline_cd = rec.subline_cd
                         AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                               rec.iss_cd)
            LOOP
               FOR c2 IN (SELECT   tsi_amt, prem_amt
                            FROM   giuw_pol_dist
                           WHERE   dist_no = c1.dist_no)
               LOOP
                  v_total_si := v_total_si + c2.tsi_amt;
                  v_total_prem := v_total_prem + c2.prem_amt;
                  EXIT;
               END LOOP;
            END LOOP;
         END;

         --get SUM_REINSURED
         FOR c1
         IN (SELECT   DISTINCT frps_line_cd,
                               frps_yy,
                               frps_seq_no,
                               ri_cd
               FROM   GIPI_UWREPORTS_RI_EXT
              WHERE   user_id = p_user_id
                      AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                           OR (p_scope = 1 AND endt_seq_no = 0)
                           OR (p_scope = 2 AND endt_seq_no > 0))
                      AND line_cd = rec.line_cd
                      AND subline_cd = rec.subline_cd
                      AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                            rec.iss_cd)
         LOOP
            FOR c2
            IN (SELECT   SUM (a.ri_tsi_amt * b.currency_rt) ri_tsi_amt
                  FROM   giis_peril c, giri_distfrps b, giri_frperil a
                 WHERE       b.line_cd = a.line_cd
                         AND b.frps_yy = a.frps_yy
                         AND b.frps_seq_no = a.frps_seq_no
                         AND a.line_cd = c.line_cd
                         AND a.peril_cd = c.peril_cd
                         AND c.peril_type = 'B'
                         AND a.line_cd = c1.frps_line_cd
                         AND a.frps_yy = c1.frps_yy
                         AND a.frps_seq_no = c1.frps_seq_no
                         AND a.ri_cd = c1.ri_cd)
            LOOP
               v_reinsured := v_reinsured + c2.ri_tsi_amt;
            END LOOP;
         END LOOP;

         v_gipir930a.iss_name := v_iss_name;
         v_gipir930a.line := rec.line_name;
         v_gipir930a.subline := rec.subline_name;
         v_gipir930a.bndr_count := rec.binder_count;
         v_gipir930a.sum_insured := v_total_si;
         v_gipir930a.premium := v_total_prem;
         v_gipir930a.sum_reinsured := v_reinsured;
         v_gipir930a.share_prem := rec.share_prem;
         v_gipir930a.share_prem_vat := rec.ri_prem_vat;
         v_gipir930a.ri_comm := rec.ri_comm;
         v_gipir930a.comm_vat := rec.ri_comm_vat;
         v_gipir930a.wholding_vat := rec.ri_wholding_vat;
         v_gipir930a.net_due := rec.net_due;

         PIPE ROW (v_gipir930a);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 8 ---------------------------------

   FUNCTION CSV_GIPIR930 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir930_type
      PIPELINED
   IS
      v_gipir930     gipir930_rec_type;
      v_iss_name     VARCHAR2 (50);
      v_total_si     GIPI_UWREPORTS_RI_EXT.total_si%TYPE := 0;
      v_total_prem   GIPI_UWREPORTS_RI_EXT.total_prem%TYPE := 0;
   --   v_reinsured    GIPI_UWREPORTS_RI_EXT.sum_reinsured%TYPE := 0;  -- jhing commented out 01.23.2013
   BEGIN
      FOR rec
      IN (  SELECT   SUBSTR (assd_name, 1, 50) assd_name,
                     line_cd,
                     subline_cd,
                     iss_cd,
                     incept_date,
                     expiry_date,
                     INITCAP (line_name) line_name,
                     INITCAP (subline_name) subline_name,
                     policy_no,
                     binder_no,
                     ri_short_name,
                     ri_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd_header,
                     frps_line_cd,
                     frps_yy,
                     frps_seq_no,
                     /* commented out and replace by jhing 01.22.2013 */
                     --                     SUM (NVL (total_si, 0)) total_si,
                     --                     SUM (NVL (total_prem, 0)) total_prem,
                     --                     SUM (NVL (sum_reinsured, 0)) sum_reinsured,
                     --                     SUM (NVL (share_premium, 0)) share_premium,
                     --                     SUM (NVL (ri_comm_amt, 0)) ri_comm_amt,
                     --                     SUM (NVL (net_due, 0)) net_due,
                     --                     SUM (NVL (ri_prem_vat, 0)) ri_prem_vat,
                     --                     SUM (NVL (ri_comm_vat, 0)) ri_comm_vat,
                     --                     SUM (NVL (ri_wholding_vat, 0)) ri_wholding_vat
                     /* revised field field jhing 01.22.2013 */
                     NVL (total_si, 0) total_si,
                     NVL (total_prem, 0) total_prem,
                     NVL (sum_reinsured, 0) sum_reinsured,
                     NVL (share_premium, 0) share_premium,
                     NVL (ri_comm_amt, 0) ri_comm_amt,
                     NVL (net_due, 0) net_due,
                     NVL (ri_prem_vat, 0) ri_prem_vat,
                     NVL (ri_comm_vat, 0) ri_comm_vat,
                     NVL (ri_wholding_vat, 0) ri_wholding_vat
              FROM   gipi_uwreports_ri_ext
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   assd_name,
                     line_cd,
                     subline_cd,
                     iss_cd,
                     incept_date,
                     expiry_date,
                     INITCAP (line_name),
                     INITCAP (subline_name),
                     policy_no,
                     binder_no,
                     ri_short_name,
                     ri_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd),
                     frps_line_cd,
                     frps_yy,
                     frps_seq_no /* additional group by condition jhing 01.22.2013 */
                                ,
                     NVL (total_si, 0),
                     NVL (total_prem, 0),
                     NVL (sum_reinsured, 0),
                     NVL (share_premium, 0),
                     NVL (ri_comm_amt, 0),
                     NVL (net_due, 0),
                     NVL (ri_prem_vat, 0),
                     NVL (ri_comm_vat, 0),
                     NVL (ri_wholding_vat, 0)
          ORDER BY   INITCAP (line_name),
                     INITCAP (subline_name),
                     policy_no,
                     assd_name)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         /* jhing 01.22.2013 commented out ..causes discrepancies when there are multiple binder reversal of the same frps and ri_cd ; used the gipi_uwreports_ri_ext.sum_reinsured instead */
         --         --get SUM_REINSURED
         --         FOR c2
         --         IN (SELECT   SUM (a.ri_tsi_amt * b.currency_rt) ri_tsi_amt
         --               FROM   giis_peril c, giri_distfrps b, giri_frperil a
         --              WHERE       b.line_cd = a.line_cd
         --                      AND b.frps_yy = a.frps_yy
         --                      AND b.frps_seq_no = a.frps_seq_no
         --                      AND a.line_cd = c.line_cd
         --                      AND a.peril_cd = c.peril_cd
         --                      AND c.peril_type = 'B'
         --                      AND a.line_cd = rec.frps_line_cd
         --                      AND a.frps_yy = rec.frps_yy
         --                      AND a.frps_seq_no = rec.frps_seq_no
         --                      AND a.ri_cd = rec.ri_cd)
         --         LOOP
         --            v_reinsured := v_reinsured + c2.ri_tsi_amt;
         --         END LOOP;

         v_gipir930.iss_name := v_iss_name;
         v_gipir930.line := rec.line_cd || ' - ' || rec.line_name;
         v_gipir930.subline := rec.subline_cd || ' - ' || rec.subline_name;
         v_gipir930.policy_no := rec.policy_no;
         v_gipir930.assured := rec.assd_name;
         v_gipir930.incept_date := rec.incept_date;
         v_gipir930.expiry_date := rec.expiry_date;
         v_gipir930.total_si := rec.total_si;
         v_gipir930.tot_premium := rec.total_prem;
         v_gipir930.binder_no := rec.binder_no;
         v_gipir930.ri_short_name := rec.ri_short_name;
         v_gipir930.sum_reinsured := /* v_reinsured ;  -- replaced with rec.sum_reinsured by jhing 01.22.2013 */
                                    rec.sum_reinsured;
         v_gipir930.share_prem := rec.share_premium;
         v_gipir930.share_prem_vat := rec.ri_prem_vat;
         v_gipir930.ri_comm := rec.ri_comm_amt;
         v_gipir930.comm_vat := rec.ri_comm_vat;
         v_gipir930.wholding_vat := rec.ri_wholding_vat;
         v_gipir930.net_due := rec.net_due;

         PIPE ROW (v_gipir930);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 9 ---------------------------------

   FUNCTION CSV_GIPIR946B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946b_type
      PIPELINED
   IS
      v_gipir946b        gipir946b_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (30);
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                     line_cd,
                     line_name,
                     subline_cd,
                     peril_cd,
                     peril_name,
                     peril_type,
                     SUM (DECODE (peril_type, 'B', tsi_amt, 0)) tsi_basic,
                     SUM (tsi_amt) tsi_amt,
                     SUM (prem_amt) prem_amt
              FROM   gipi_uwreports_peril_ext
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   DECODE (p_iss_param, 1, cred_branch, iss_cd),
                     line_cd,
                     line_name,
                     subline_cd,
                     peril_cd,
                     peril_name,
                     peril_type
          ORDER BY   peril_name)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get COMM_AMT
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_peril_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         b.policy_id,
                         b.peril_cd,
                         a.iss_cd a_iss_cd,
                         d.ri_comm_amt,
                         commission_amt,
                         e.currency_rt
                  FROM   gipi_uwreports_peril_ext a,
                         gipi_comm_inv_peril b,
                         gipi_invperil d,
                         gipi_invoice e
                 WHERE       a.policy_id = b.policy_id
                         AND a.peril_cd = b.peril_cd
                         AND a.policy_id = e.policy_id
                         AND e.iss_cd = d.iss_cd
                         AND e.prem_seq_no = d.prem_seq_no
                         AND a.user_id = p_user_id
                         AND d.peril_cd = a.peril_cd
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.iss_cd
                         AND a.line_cd = rec.line_cd
                         AND subline_cd = rec.subline_cd
                         AND a.peril_cd = rec.peril_cd
                         AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
               IF rc.a_iss_cd = 'RI'
               THEN
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               ELSE
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   a.acct_ent_date,
                                 b.commission_amt,
                                 b.comm_rec_id,
                                 b.intm_no,
                                 b.comm_peril_id
                          FROM   giac_new_comm_inv_peril b, giac_new_comm_inv a
                         WHERE       1 = 1
                                 AND b.fund_cd = a.fund_cd
                                 AND b.branch_cd = a.branch_cd
                                 AND b.comm_rec_id = a.comm_rec_id
                                 AND b.intm_no = a.intm_no
                                 AND b.peril_cd = rc.peril_cd
                                 AND a.iss_cd = rc.iss_cd
                                 AND a.prem_seq_no = rc.prem_seq_no
                                 AND a.fund_cd = v_fund_cd
                                 AND a.branch_cd = v_branch_cd
                                 AND a.tran_flag = 'P'
                                 AND NVL (a.delete_sw, 'N') = 'N'
                      ORDER BY   a.comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv_peril
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no
                                     AND comm_peril_id = c1.comm_peril_id)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;
            END LOOP;
         END;

         v_gipir946b.iss_name := v_iss_name;
         v_gipir946b.line := rec.line_name;
         v_gipir946b.subline := v_subline;
         v_gipir946b.peril_name := rec.peril_name;
         v_gipir946b.peril_type := rec.peril_type;
         v_gipir946b.tsi_amt := rec.tsi_amt;
         v_gipir946b.prem_amt := rec.prem_amt;
         v_gipir946b.comm_amt := v_commission;

         PIPE ROW (v_gipir946b);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 10 ---------------------------------

   FUNCTION CSV_GIPIR946F (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946f_type
      PIPELINED
   IS
      v_gipir946f   gipir946f_rec_type;
      v_iss_name    VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
      v_intm        VARCHAR2 (275);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                     a.line_cd,
                     a.line_name,
                     a.subline_cd,
                     a.intm_no,
                     a.intm_name,
                     SUM (DECODE (a.PERIL_TYPE, 'B', a.TSI_AMT, 0)) TSI_BASIC,
                     SUM (a.tsi_amt) tsi_amt,
                     SUM (a.prem_amt) prem_amt,
                     b.ref_intm_cd
              FROM   gipi_uwreports_peril_ext a, giis_intermediary b
             WHERE       a.iss_cd <> giacp.v ('RI_ISS_CD')
                     AND a.user_id = p_user_id
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
                     AND a.intm_no = b.intm_no
          GROUP BY   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     a.line_cd,
                     a.line_name,
                     a.subline_cd,
                     a.intm_no,
                     a.intm_name,
                     b.ref_intm_cd
          ORDER BY   b.ref_intm_cd)
      LOOP
         v_intm :=
            rec.ref_intm_cd || '/' || rec.intm_no || ' ' || rec.intm_name;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         v_gipir946f.iss_name := v_iss_name;
         v_gipir946f.line := rec.line_name;
         v_gipir946f.subline := v_subline;
         v_gipir946f.agent := v_intm;
         v_gipir946f.tsi_amt := rec.tsi_amt;
         v_gipir946f.prem_amt := rec.prem_amt;

         PIPE ROW (v_gipir946f);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 11 ---------------------------------

   FUNCTION CSV_GIPIR946 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946_type
      PIPELINED
   IS
      v_gipir946         gipir946_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (30);
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                     line_cd,
                     line_name,
                     subline_cd,
                     peril_cd,
                     peril_name,
                     peril_type,
                     intm_no,
                     intm_name,
                     SUM (DECODE (peril_type, 'B', tsi_amt, 0)),
                     SUM (tsi_amt) tsi_amt,
                     SUM (prem_amt) prem_amt
              FROM   gipi_uwreports_peril_ext
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   DECODE (p_iss_param, 1, cred_branch, iss_cd),
                     line_cd,
                     line_name,
                     subline_cd,
                     peril_cd,
                     peril_name,
                     peril_type,
                     intm_no,
                     intm_name)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get COMM_AMT
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_peril_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         b.policy_id,
                         b.peril_cd,
                         a.iss_cd a_iss_cd,
                         d.ri_comm_amt,
                         commission_amt,
                         e.currency_rt
                  FROM   gipi_uwreports_peril_ext a,
                         gipi_comm_inv_peril b,
                         gipi_invperil d,
                         gipi_invoice e
                 WHERE       a.policy_id = b.policy_id
                         AND a.peril_cd = b.peril_cd
                         AND a.policy_id = e.policy_id
                         AND e.iss_cd = d.iss_cd
                         AND e.prem_seq_no = d.prem_seq_no
                         AND a.user_id = p_user_id
                         AND d.peril_cd = a.peril_cd
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.iss_cd
                         AND a.line_cd = rec.line_cd
                         AND subline_cd = rec.subline_cd
                         AND a.peril_cd = rec.peril_cd
                         AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
               IF rc.a_iss_cd = 'RI'
               THEN
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               ELSE
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   a.acct_ent_date,
                                 b.commission_amt,
                                 b.comm_rec_id,
                                 b.intm_no,
                                 b.comm_peril_id
                          FROM   giac_new_comm_inv_peril b, giac_new_comm_inv a
                         WHERE       1 = 1
                                 AND b.fund_cd = a.fund_cd
                                 AND b.branch_cd = a.branch_cd
                                 AND b.comm_rec_id = a.comm_rec_id
                                 AND b.intm_no = a.intm_no
                                 AND b.peril_cd = rc.peril_cd
                                 AND a.iss_cd = rc.iss_cd
                                 AND a.prem_seq_no = rc.prem_seq_no
                                 AND a.fund_cd = v_fund_cd
                                 AND a.branch_cd = v_branch_cd
                                 AND a.tran_flag = 'P'
                                 AND NVL (a.delete_sw, 'N') = 'N'
                      ORDER BY   a.comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv_peril
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no
                                     AND comm_peril_id = c1.comm_peril_id)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;
            END LOOP;
         END;

         v_gipir946.iss_name := v_iss_name;
         v_gipir946.line := rec.line_name;
         v_gipir946.subline := v_subline;
         v_gipir946.peril_name := rec.peril_name;
         v_gipir946.peril_type := rec.peril_type;
         v_gipir946.intm_name := rec.intm_name;
         v_gipir946.tsi_amt := rec.tsi_amt;
         v_gipir946.prem_amt := rec.prem_amt;
         v_gipir946.comm_amt := v_commission;

         PIPE ROW (v_gipir946);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 12 ---------------------------------

   FUNCTION CSV_GIPIR946D (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir946d_type
      PIPELINED
   IS
      v_gipir946d   gipir946d_rec_type;
      v_iss_name    VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
   BEGIN
      FOR rec
      IN (  SELECT   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                     line_name,
                     SUM (DECODE (PERIL_TYPE, 'B', TSI_AMT, 0)) TSI_BASIC,
                     SUM (tsi_amt) tsi_amt,
                     SUM (prem_amt) prem_amt,
                     peril_cd,
                     peril_name,
                     peril_type,
                     intm_no,
                     intm_name
              FROM   gipi_uwreports_peril_ext
             WHERE   user_id = p_user_id AND iss_cd <> giacp.v ('RI_ISS_CD')
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd),
                     line_name,
                     peril_cd,
                     peril_name,
                     peril_type,
                     intm_no,
                     intm_name
          ORDER BY   peril_name ASC)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         v_gipir946d.iss_name := v_iss_name;
         v_gipir946d.line := rec.line_name;
         v_gipir946d.subline := v_subline;
         v_gipir946d.agent := rec.intm_name;
         v_gipir946d.peril_name := rec.peril_name;
         v_gipir946d.peril_type := rec.peril_type;
         v_gipir946d.tsi_amt := rec.tsi_amt;
         v_gipir946d.prem_amt := rec.prem_amt;

         PIPE ROW (v_gipir946d);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 13 ---------------------------------

   FUNCTION CSV_GIPIR924A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924a_type
      PIPELINED
   IS
      v_gipir924a   gipir924a_rec_type;
      v_iss_name    VARCHAR2 (50);
   BEGIN
      FOR rec
      IN (  SELECT   SUBSTR (assd_name, 1, 50) assd_name,
                     LINE_CD,
                     LINE_NAME,
                     SUBLINE_CD,
                     SUBLINE_NAME,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd) ISS_CD,
                     SUM (NVL (TOTAL_TSI, 0)) total_tsi,
                     SUM (NVL (TOTAL_PREM, 0)) total_prem,
                     SUM (NVL (EVATPREM, 0)) evatprem,
                     SUM (NVL (FST, 0)) fst,
                     SUM (NVL (LGT, 0)) lgt,
                     SUM (NVL (DOC_STAMPS, 0)) doc_stamps,
                     SUM (NVL (OTHER_TAXES, 0)) other_taxes,
                     SUM (NVL (OTHER_CHARGES, 0)) other_charges,
                     PARAM_DATE,
                     FROM_DATE,
                     TO_DATE,
                     SCOPE,
                     USER_ID,
                     COUNT (POLICY_ID) pol_count,
                       SUM (NVL (TOTAL_PREM, 0))
                     + SUM (NVL (EVATPREM, 0))
                     + SUM (NVL (FST, 0))
                     + SUM (NVL (LGT, 0))
                     + SUM (NVL (DOC_STAMPS, 0))
                     + SUM (NVL (OTHER_TAXES, 0))
                     + SUM (NVL (OTHER_CHARGES, 0))
                        total
              FROM   GIPI_UWREPORTS_INTM_EXT
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND assd_no = NVL (p_assd_no, assd_no)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   assd_name,
                     LINE_CD,
                     LINE_NAME,
                     SUBLINE_CD,
                     SUBLINE_NAME,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd),
                     PARAM_DATE,
                     FROM_DATE,
                     TO_DATE,
                     SCOPE,
                     USER_ID
          ORDER BY   6, 1)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir924a.assd_name := rec.assd_name;
         v_gipir924a.iss_name := v_iss_name;
         v_gipir924a.line := rec.line_name;
         v_gipir924a.subline := rec.subline_name;
         v_gipir924a.pol_count := rec.pol_count;
         v_gipir924a.total_tsi := rec.total_tsi;
         v_gipir924a.total_prem := rec.total_prem;
         v_gipir924a.evatprem := rec.evatprem;
         v_gipir924a.lgt := rec.lgt;
         v_gipir924a.doc_stamps := rec.doc_stamps;
         v_gipir924a.fire_service_tax := rec.fst;
         v_gipir924a.other_charges := rec.other_taxes;
         v_gipir924a.total := rec.total;

         PIPE ROW (v_gipir924a);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 14 ---------------------------------

   FUNCTION CSV_GIPIR924B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924b_type
      PIPELINED
   IS
      v_gipir924b        gipir924b_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_intm_type        VARCHAR2 (20);
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   a.LINE_CD,
                     a.LINE_NAME,
                     a.SUBLINE_CD,
                     a.SUBLINE_NAME,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) ISS_CD,
                     SUM (a.TOTAL_TSI) total_tsi,
                     SUM (a.TOTAL_PREM) total_prem,
                     SUM (a.EVATPREM) evatprem,
                     SUM (a.LGT) lgt,
                     SUM (a.DOC_STAMPS) doc_stamps,
                     SUM (a.FST) fst,
                     SUM (a.OTHER_TAXES) other_taxes,
                     SUM (a.OTHER_CHARGES) other_charges,
                     a.PARAM_DATE,
                     a.FROM_DATE,
                     a.TO_DATE,
                     a.SCOPE,
                     a.USER_ID,
                     a.intm_no,
                     a.INTM_NAME,
                     a.INTM_TYPE,
                       SUM (a.TOTAL_PREM)
                     + SUM (a.EVATPREM)
                     + SUM (a.LGT)
                     + SUM (a.DOC_STAMPS)
                     + SUM (a.FST)
                     + SUM (a.OTHER_TAXES)
                     + SUM (a.OTHER_CHARGES)
                        TOTAL,
                     COUNT (a.POLICY_ID) POL_COUNT,
                     SUM (B.COMMISSION) commission
              FROM   GIPI_UWREPORTS_INTM_EXT a,
                     (  SELECT   C.POLICY_ID,
                                 SUM(DECODE (
                                        c.ri_comm_amt * c.currency_rt,
                                        0,
                                        NVL (b.commission_amt * c.currency_rt, 0),
                                        c.ri_comm_amt * c.currency_rt
                                     ))
                                    commission
                          FROM   GIPI_COMM_INVOICE b, GIPI_INVOICE c
                         WHERE   B.POLICY_ID = C.POLICY_ID
                      GROUP BY   C.POLICY_ID) B
             WHERE       a.policy_id = b.policy_id(+)
                     AND a.user_id = p_user_id
                     AND ASSD_NO = NVL (P_ASSD_NO, ASSD_NO)
                     AND INTM_NO = NVL (P_INTM_NO, INTM_NO)
                     AND INTM_TYPE = NVL (P_INTM_TYPE, INTM_TYPE)
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.LINE_CD = NVL (P_LINE_CD, a.LINE_CD)
                     AND SUBLINE_CD = NVL (P_SUBLINE_CD, SUBLINE_CD)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   LINE_CD,
                     LINE_NAME,
                     SUBLINE_CD,
                     SUBLINE_NAME,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     PARAM_DATE,
                     a.FROM_DATE,
                     a.TO_DATE,
                     SCOPE,
                     a.USER_ID,
                     intm_no,
                     INTM_NAME,
                     a.INTM_TYPE
          ORDER BY   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     a.INTM_TYPE,
                     a.INTM_NAME)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get INTM_TYPE
         BEGIN
            SELECT   intm_desc
              INTO   v_intm_type
              FROM   giis_intm_type
             WHERE   intm_type = rec.intm_type;
         END;

         --get COMMISSION
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_intm_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         c.ri_comm_amt,
                         c.currency_rt,
                         b.commission_amt
                  FROM   gipi_comm_invoice b,
                         gipi_invoice c,
                         gipi_uwreports_intm_ext a
                 WHERE       a.policy_id = b.policy_id
                         AND a.policy_id = c.policy_id
                         AND a.user_id = p_user_id
                         AND intm_no = rec.intm_no
                         AND intm_type = rec.intm_type
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.iss_cd
                         AND a.line_cd = rec.line_cd
                         AND subline_cd = rec.subline_cd
                         AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   acct_ent_date,
                                 commission_amt,
                                 comm_rec_id,
                                 intm_no
                          FROM   giac_new_comm_inv
                         WHERE       iss_cd = rc.iss_cd
                                 AND prem_seq_no = rc.prem_seq_no
                                 AND fund_cd = v_fund_cd
                                 AND branch_cd = v_branch_cd
                                 AND tran_flag = 'P'
                                 AND NVL (delete_sw, 'N') = 'N'
                      ORDER BY   comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;
            END LOOP;
         END;

         v_gipir924b.iss_name := v_iss_name;
         v_gipir924b.intm_type := v_intm_type;
         v_gipir924b.intm_name := rec.intm_name;
         v_gipir924b.line := rec.line_name;
         v_gipir924b.subline := rec.subline_name;
         v_gipir924b.pol_count := rec.pol_count;
         v_gipir924b.total_tsi := rec.total_tsi;
         v_gipir924b.total_prem := rec.total_prem;
         v_gipir924b.evatprem := rec.evatprem;
         v_gipir924b.lgt := rec.lgt;
         v_gipir924b.doc_stamps := rec.doc_stamps;
         v_gipir924b.fire_service_tax := rec.fst;
         v_gipir924b.other_charges := rec.other_taxes;
         v_gipir924b.total := rec.total;
         v_gipir924b.commission := v_commission;

         PIPE ROW (v_gipir924b);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 15 ---------------------------------

   FUNCTION CSV_GIPIR923A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923a_type
      PIPELINED
   IS
      v_gipir923a   gipir923a_rec_type;
      v_iss_name    VARCHAR2 (50);
   BEGIN
      FOR rec
      IN (  SELECT   SUBSTR (assd_name, 1, 50) assd_name,
                     line_name,
                     subline_name,
                     issue_date,
                     incept_date,
                     expiry_date,
                     total_tsi,
                     total_prem,
                     evatprem,
                     fst,
                     lgt,
                     doc_stamps,
                     other_taxes,
                     line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_seq_no,
                     endt_iss_cd,
                     endt_yy,
                     policy_id,
                     Get_Policy_No (policy_id) policy_no,
                       NVL (total_prem, 0)
                     + NVL (evatprem, 0)
                     + NVL (fst, 0)
                     + NVL (lgt, 0)
                     + NVL (doc_stamps, 0)
                     + NVL (other_taxes, 0)
                        total_charges
              FROM   GIPI_UWREPORTS_INTM_EXT
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                           NVL (p_iss_cd,
                                DECODE (p_iss_param, 1, cred_branch, iss_cd))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND assd_no = NVL (p_assd_no, assd_no)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          ORDER BY   assd_name,
                     iss_cd,
                     line_name,
                     subline_name,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir923a.assd_name := rec.assd_name;
         v_gipir923a.iss_name := v_iss_name;
         v_gipir923a.line := rec.line_name;
         v_gipir923a.subline := rec.subline_name;
         v_gipir923a.policy_no := rec.policy_no;
         v_gipir923a.issue_date := rec.issue_date;
         v_gipir923a.incept_date := rec.incept_date;
         v_gipir923a.expiry_date := rec.expiry_date;
         v_gipir923a.total_tsi := rec.total_tsi;
         v_gipir923a.total_prem := rec.total_prem;
         v_gipir923a.evatprem := rec.evatprem;
         v_gipir923a.lgt := rec.lgt;
         v_gipir923a.doc_stamps := rec.doc_stamps;
         v_gipir923a.fire_service_tax := rec.fst;
         v_gipir923a.other_charges := rec.other_taxes;
         v_gipir923a.total := rec.total_charges;

         PIPE ROW (v_gipir923a);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 16 ---------------------------------

   FUNCTION CSV_GIPIR923B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_intm_type     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923b_type
      PIPELINED
   IS
      v_gipir923b        gipir923b_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_intm_type        VARCHAR2 (20);
      v_param_value_v1   giis_parameters.param_value_v%TYPE;
      v_param_value_v2   giis_parameters.param_value_v%TYPE;
      --policy_no
      v_policy_no        VARCHAR2 (150);
      v_endt_no          VARCHAR2 (100);
      v_ref_pol_no       VARCHAR2 (100) := NULL;
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   a.assd_no,
                     SUBSTR (a.assd_name, 1, 50) assd_name,
                     a.line_cd,
                     a.line_name,
                     a.subline_cd,
                     a.subline_name,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                     a.iss_cd iss_cd2,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     a.incept_date,
                     a.expiry_date,
                     a.total_tsi,
                     a.total_prem,
                     a.evatprem,
                     a.lgt,
                     a.doc_stamps,
                     a.fst,
                     a.other_taxes,
                     a.other_charges,
                     a.param_date,
                     a.from_date,
                     a.TO_DATE,
                     a.scope,
                     a.user_id,
                     a.policy_id,
                     a.intm_name,
                     a.intm_no,
                       a.total_prem
                     + a.evatprem
                     + a.lgt
                     + a.doc_stamps
                     + a.fst
                     + a.other_taxes
                        total,
                     B.COMMISSION commission,
                     B.REF_INV_NO,
                     a.intm_type
              FROM   GIPI_UWREPORTS_INTM_EXT a,
                     (  SELECT   C.POLICY_ID,
                                 SUM(DECODE (
                                        c.ri_comm_amt * c.currency_rt,
                                        0,
                                        NVL (b.commission_amt * c.currency_rt, 0),
                                        c.ri_comm_amt * c.currency_rt
                                     ))
                                    commission,
                                 c.iss_Cd || '-' || c.prem_seq_no
                                 || DECODE (NVL (REF_INV_NO, '1'),
                                            '1', ' ',
                                            ' / ' || REF_INV_NO)
                                    REF_INV_NO
                          FROM   GIPI_COMM_INVOICE b, GIPI_INVOICE c
                         WHERE   B.POLICY_ID = C.POLICY_ID
                      GROUP BY   C.POLICY_ID,
                                 c.iss_Cd || '-' || c.prem_seq_no
                                 || DECODE (NVL (REF_INV_NO, '1'),
                                            '1', ' ',
                                            ' / ' || REF_INV_NO)) B
             WHERE   a.policy_id = b.policy_id(+) AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND assd_no = NVL (p_assd_no, assd_no)
                     AND intm_no = NVL (p_intm_no, intm_no)
                     AND intm_type = NVL (p_intm_type, intm_type)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          ORDER BY   DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     a.intm_type,
                     a.intm_name,
                     a.line_name,
                     subline_name,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_seq_no)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get INTM_TYPE
         BEGIN
            SELECT   intm_desc
              INTO   v_intm_type
              FROM   giis_intm_type
             WHERE   intm_type = rec.intm_type;
         END;

         --get POLICY_NO
         BEGIN
            V_POLICY_NO :=
                  rec.LINE_CD
               || '-'
               || rec.SUBLINE_CD
               || '-'
               || LTRIM (rec.ISS_CD2)
               || '-'
               || LTRIM (TO_CHAR (rec.ISSUE_YY, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.POL_SEQ_NO))
               || '-'
               || LTRIM (TO_CHAR (rec.RENEW_NO, '09'));

            IF rec.ENDT_SEQ_NO <> 0
            THEN
               V_ENDT_NO :=
                     rec.ENDT_ISS_CD
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_YY, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_SEQ_NO));
            END IF;

            BEGIN
               SELECT   ref_pol_no
                 INTO   v_ref_pol_no
                 FROM   gipi_polbasic
                WHERE   policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         --get INVOICE
         BEGIN
            BEGIN
               SELECT   param_value_v
                 INTO   v_param_value_v2
                 FROM   giis_parameters
                WHERE   param_name = 'PRINT_REF_INV';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_param_value_v2 := NULL;
            END;

            IF v_param_value_v2 = 'Y'
            THEN
               v_param_value_v2 := rec.ref_inv_no;
            ELSE
               v_param_value_v2 := rec.incept_date;
            END IF;
         END;

         --get POL_DATE
         BEGIN
            BEGIN
               SELECT   param_value_v
                 INTO   v_param_value_v1
                 FROM   giis_parameters
                WHERE   param_name = 'PRINT_REF_INV';
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_param_value_v1 := NULL;
            END;

            IF v_param_value_v1 = 'Y'
            THEN
               v_param_value_v1 := rec.incept_date;
            ELSE
               v_param_value_v1 := rec.expiry_date;
            END IF;
         END;

         --get COMMISSION
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_intm_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         c.ri_comm_amt,
                         c.currency_rt,
                         b.commission_amt
                  FROM   gipi_comm_invoice b,
                         gipi_invoice c,
                         gipi_uwreports_intm_ext a
                 WHERE       a.policy_id = b.policy_id
                         AND a.policy_id = c.policy_id
                         AND a.user_id = p_user_id
                         AND intm_no = rec.intm_no
                         AND intm_type = rec.intm_type
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.iss_cd
                         AND a.line_cd = rec.line_cd
                         AND subline_cd = rec.subline_cd
                         AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                              OR (p_scope = 1 AND endt_seq_no = 0)
                              OR (p_scope = 2 AND endt_seq_no > 0)))
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   acct_ent_date,
                                 commission_amt,
                                 comm_rec_id,
                                 intm_no
                          FROM   giac_new_comm_inv
                         WHERE       iss_cd = rc.iss_cd
                                 AND prem_seq_no = rc.prem_seq_no
                                 AND fund_cd = v_fund_cd
                                 AND branch_cd = v_branch_cd
                                 AND tran_flag = 'P'
                                 AND NVL (delete_sw, 'N') = 'N'
                      ORDER BY   comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;
            END LOOP;
         END;

         v_gipir923b.iss_name := v_iss_name;
         v_gipir923b.intm_type := v_intm_type;
         v_gipir923b.intm_name := rec.intm_no || ' - ' || rec.intm_name;
         v_gipir923b.line := rec.line_name;
         v_gipir923b.subline := rec.subline_name;
         v_gipir923b.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir923b.assured := rec.assd_name;
         v_gipir923b.invoice := v_param_value_v2;
         v_gipir923b.pol_date := v_param_value_v1;
         v_gipir923b.total_tsi := rec.total_tsi;
         v_gipir923b.total_prem := rec.total_prem;
         v_gipir923b.evatprem := rec.evatprem;
         v_gipir923b.lgt := rec.lgt;
         v_gipir923b.doc_stamps := rec.doc_stamps;
         v_gipir923b.fire_service_tax := rec.fst;
         v_gipir923b.other_charges := rec.other_taxes;
         v_gipir923b.total := rec.total;
         v_gipir923b.commission := v_commission;

         PIPE ROW (v_gipir923b);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 17 ---------------------------------

   FUNCTION CSV_GIPIR929B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir929b_type
      PIPELINED
   IS
      v_gipir929b    gipir929b_rec_type;
      v_iss_name     VARCHAR2 (50);
      --policy_no
      v_policy_no    VARCHAR2 (150);
      v_endt_no      VARCHAR2 (100);
      v_ref_pol_no   VARCHAR2 (100) := NULL;
   BEGIN
      FOR rec
      IN (  SELECT   a.ri_name,
                     a.ri_cd,
                     a.line_cd,
                     a.line_name,
                     a.subline_cd,
                     a.subline_name,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     a.incept_date,
                     a.expiry_date,
                     a.total_tsi,
                     a.total_prem,
                     a.evatprem,
                     a.lgt,
                     a.doc_stamps,
                     a.fst,
                     a.other_taxes,
                     a.other_charges,
                     a.param_date,
                     a.from_date,
                     a.TO_DATE,
                     a.scope,
                     a.user_id,
                     a.policy_id,
                       a.total_prem
                     + a.evatprem
                     + a.lgt
                     + a.doc_stamps
                     + a.fst
                     + a.other_taxes
                        total,
                     SUM (b.ri_comm_amt) commission,
                     c.ri_comm_vat ri_comm_vat
              FROM   GIPI_UWREPORTS_INW_RI_EXT a,
                     GIPI_ITMPERIL b,
                     gipi_invoice c
             WHERE       a.policy_id = b.policy_id(+)
                     AND a.policy_id = c.policy_id
                     AND a.user_id = p_user_id
                     AND NVL (a.cred_branch, 'x') =
                           NVL (p_iss_cd, NVL (a.cred_branch, 'x'))
                     AND a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND ri_cd = NVL (p_ri_cd, ri_cd)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   a.ri_name,
                     a.ri_cd,
                     a.line_cd,
                     a.line_name,
                     a.subline_cd,
                     a.subline_name,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd),
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     a.incept_date,
                     a.expiry_date,
                     a.total_tsi,
                     a.total_prem,
                     a.evatprem,
                     a.lgt,
                     a.doc_stamps,
                     a.fst,
                     a.other_taxes,
                     a.other_charges,
                     a.param_date,
                     a.from_date,
                     a.TO_DATE,
                     a.scope,
                     a.user_id,
                     a.policy_id,
                       a.total_prem
                     + a.evatprem
                     + a.lgt
                     + a.doc_stamps
                     + a.fst
                     + a.other_taxes,
                     a.cred_branch,
                     c.ri_comm_vat
          ORDER BY   a.ri_cd,
                     a.line_name,
                     a.subline_name,
                     a.cred_branch,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get POLICY_NO
         BEGIN
            V_POLICY_NO :=
                  rec.LINE_CD
               || '-'
               || rec.SUBLINE_CD
               || '-'
               || rec.ISS_CD
               || '-'
               || LPAD (TO_CHAR (rec.ISSUE_YY), 2, '0')
               || '-'
               || LPAD (TO_CHAR (rec.POL_SEQ_NO), 7, '0')
               || '-'
               || LPAD (TO_CHAR (rec.RENEW_NO), 2, '0');

            IF rec.ENDT_SEQ_NO <> 0
            THEN
               V_ENDT_NO :=
                     rec.ENDT_ISS_CD
                  || '-'
                  || LPAD (TO_CHAR (rec.ENDT_YY), 2, '0')
                  || '-'
                  || LPAD (TO_CHAR (rec.ENDT_SEQ_NO), 7, '0');
            END IF;

            BEGIN
               SELECT   ref_pol_no
                 INTO   v_ref_pol_no
                 FROM   gipi_polbasic
                WHERE   policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         v_gipir929b.iss_name := v_iss_name;
         v_gipir929b.intm_name := rec.ri_cd || ' - ' || rec.ri_name;
         v_gipir929b.line := rec.line_name;
         v_gipir929b.subline := rec.subline_name;
         v_gipir929b.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir929b.incept_date := rec.incept_date;
         v_gipir929b.total_tsi := rec.total_tsi;
         v_gipir929b.total_prem := rec.total_prem;
         v_gipir929b.evatprem := rec.evatprem;
         v_gipir929b.lgt := rec.lgt;
         v_gipir929b.doc_stamps := rec.doc_stamps;
         v_gipir929b.fire_service_tax := rec.fst;
         v_gipir929b.other_charges := rec.other_taxes;
         v_gipir929b.total := rec.total;
         v_gipir929b.commission := rec.commission;
         v_gipir929b.ri_comm_vat := rec.ri_comm_vat;

         PIPE ROW (v_gipir929b);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 18 ---------------------------------
   /* Modified by : Joms Diago
   ** Date Modified : 04232013
   ** Description : Fetch records from extract table instead of invoice and condition tables for commission and vat
   */

   FUNCTION CSV_GIPIR929A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_intm_no       NUMBER,
                           p_assd_no       NUMBER,
                           p_ri_cd         VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir929a_type
      PIPELINED
   IS
      v_gipir929a    gipir929a_rec_type;
      v_iss_name     VARCHAR2 (50);
      --policy_no
      v_policy_no    VARCHAR2 (150);
      v_endt_no      VARCHAR2 (100);
      v_ref_pol_no   VARCHAR2 (100) := NULL;
   BEGIN
      FOR rec
      IN (  SELECT   a.ri_cd,
                     a.ri_name,
                     a.LINE_CD,
                     a.LINE_NAME,
                     a.SUBLINE_CD,
                     a.SUBLINE_NAME,
                     a.cred_branch ISS_CD,
                     SUM (a.TOTAL_TSI) total_tsi,
                     SUM (a.TOTAL_PREM) total_prem,
                     SUM (a.EVATPREM) evatprem,
                     SUM (a.LGT) lgt,
                     SUM (a.DOC_STAMPS) doc_stamps,
                     SUM (a.FST) fst,
                     SUM (a.OTHER_TAXES) other_taxes,
                     SUM (a.OTHER_CHARGES) other_charges,
                     a.PARAM_DATE,
                     a.FROM_DATE,
                     a.TO_DATE,
                     a.SCOPE,
                     a.USER_ID,
                       SUM (a.TOTAL_PREM)
                     + SUM (a.EVATPREM)
                     + SUM (a.LGT)
                     + SUM (a.DOC_STAMPS)
                     + SUM (a.FST)
                     + SUM (a.OTHER_TAXES)
                     + SUM (a.OTHER_CHARGES)
                        TOTAL,
                     COUNT (a.POLICY_ID) POL_COUNT,
                     --SUM (B.commission) commission,
                     --SUM (c.ri_comm_vat) ri_comm_vat
                     SUM (a.ri_comm_amt) commission,
                     SUM (a.ri_comm_vat) ri_comm_vat
              FROM   GIPI_UWREPORTS_INW_RI_EXT a
             /*,
                    (  SELECT   x.policy_id,
                                x.line_cd,
                                x.subline_cd,
                                SUM (y.ri_comm_amt) commission
                         FROM   gipi_uwreports_inw_ri_ext x, gipi_itmperil y
                        WHERE   x.policy_id = y.policy_id AND x.user_id = p_user_id --added by aliza 03/24/2013 to avoide adding comm of policies extracted by multiple users
                     GROUP BY   x.line_cd, x.subline_cd, x.policy_id) b,
                    gipi_invoice c
            WHERE       a.policy_id = b.policy_id(+)
                    AND a.policy_id = c.policy_id
                    AND*/
             WHERE   a.user_id = p_user_id AND a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                     AND NVL (a.cred_branch, 'x') =
                           NVL (p_iss_cd, NVL (a.cred_branch, 'x'))
                     AND a.LINE_CD = NVL (P_LINE_CD, a.LINE_CD)
                     AND a.SUBLINE_CD = NVL (P_SUBLINE_CD, a.SUBLINE_CD)
                     AND (   (p_scope = 3 AND endt_seq_no = endt_seq_no)
                          OR (p_scope = 1 AND endt_seq_no = 0)
                          OR (p_scope = 2 AND endt_seq_no > 0))
          GROUP BY   a.LINE_CD,
                     a.LINE_NAME,
                     a.SUBLINE_CD,
                     a.SUBLINE_NAME,
                     a.cred_branch,
                     PARAM_DATE,
                     a.FROM_DATE,
                     a.TO_DATE,
                     SCOPE,
                     a.USER_ID,
                     a.ri_cd,
                     a.ri_name
          ORDER BY   a.cred_branch,
                     a.ri_name,
                     a.LINE_NAME,
                     a.SUBLINE_NAME)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir929a.iss_name := v_iss_name;
         v_gipir929a.intm_name := rec.ri_name;
         v_gipir929a.line := rec.line_name;
         v_gipir929a.subline := rec.subline_name;
         v_gipir929a.pol_count := rec.pol_count;
         v_gipir929a.total_tsi := rec.total_tsi;
         v_gipir929a.total_prem := rec.total_prem;
         v_gipir929a.evatprem := rec.evatprem;
         v_gipir929a.lgt := rec.lgt;
         v_gipir929a.doc_stamps := rec.doc_stamps;
         v_gipir929a.fire_service_tax := rec.fst;
         v_gipir929a.other_charges := rec.other_taxes;
         v_gipir929a.total := rec.total;
         v_gipir929a.commission := rec.commission;
         v_gipir929a.ri_comm_vat := rec.ri_comm_vat;

         PIPE ROW (v_gipir929a);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 19 ---------------------------------

   FUNCTION CSV_GIPIR924C (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924c_type
      PIPELINED
   IS
      v_gipir924c   gipir924c_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   c.dist_flag,
                     r.rv_meaning,
                     l.line_name,
                     s.subline_name,
                     DECODE (
                        b.endt_seq_no,
                        0,
                           b.line_cd
                        || '-'
                        || b.subline_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (b.renew_no, '09')),
                           b.line_cd
                        || '-'
                        || b.subline_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (b.renew_no, '09'))
                        || '/'
                        || b.endt_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b.endt_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.endt_seq_no, '099999'))
                     )
                        policy_no,
                     b.issue_date,
                     b.incept_date,
                     SUBSTR (a.assd_name, 1, 50) assd_name,
                     b.tsi_amt,
                     b.prem_amt,
                     b.policy_id
              FROM   cg_ref_codes r,
                     giis_line l,
                     gipi_polbasic b,
                     giuw_pol_dist c,
                     giis_subline s,
                     giis_assured a,
                     gipi_parlist p
             WHERE       r.rv_low_value = b.dist_flag
                     AND r.rv_low_value IN ('1', '2')
                     AND c.dist_flag IN ('1', '2')
                     AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'
                     AND b.iss_cd IN
                              (SELECT   iss_cd
                                 FROM   giis_issource
                                WHERE   ( (    iss_cd = giacp.v ('REINSURER')
                                           AND p_direct <> 1
                                           AND p_ri = 1)
                                         OR (iss_cd <> giacp.v ('REINSURER')
                                             AND p_direct = 1
                                             AND p_ri <> 1)
                                         OR (    1 = 1
                                             AND p_direct = 1
                                             AND p_ri = 1)))
                     AND l.line_cd = b.line_cd
                     AND b.policy_id = c.policy_id
                     AND s.subline_cd = b.subline_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                           )
                     AND s.line_cd = l.line_cd
                     AND a.assd_no = b.assd_no
                     AND p.par_id = b.par_id
                     AND b.pol_flag <> '5'
                     AND NVL (b.endt_type, 0) <> 'N'
                     AND s.op_flag <> 'Y'
                     AND p.line_cd = NVL (p_line_cd, p.line_cd)
                     AND b.policy_id > 0
          ORDER BY   r.rv_meaning,
                     l.line_name,
                     s.subline_name,
                     b.line_cd,
                     b.subline_cd,
                     b.iss_cd,
                     b.issue_yy,
                     b.pol_seq_no,
                     b.renew_no,
                     a.assd_name)
      LOOP
         v_gipir924c.rv_meaning := rec.rv_meaning;
         v_gipir924c.line := rec.line_name;
         v_gipir924c.subline := rec.subline_name;
         v_gipir924c.policy_no := rec.policy_no;
         v_gipir924c.assured := rec.assd_name;
         v_gipir924c.issue_date := rec.issue_date;
         v_gipir924c.incept_date := rec.incept_date;
         v_gipir924c.tsi_amt := rec.tsi_amt;
         v_gipir924c.prem_amt := rec.prem_amt;

         PIPE ROW (v_gipir924c);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 20 ---------------------------------

   FUNCTION CSV_GIPIR924D (p_direct       VARCHAR2,
                           p_line_cd      VARCHAR2,
                           p_iss_cd       VARCHAR2,
                           p_iss_param    VARCHAR2,
                           p_ri           VARCHAR2)
      RETURN gipir924d_type
      PIPELINED
   IS
      v_gipir924d   gipir924d_rec_type;
      v_iss_name    VARCHAR2 (50);
   BEGIN
      FOR rec
      IN (  SELECT   c.dist_flag,
                     r.rv_meaning,
                     l.line_name,
                     s.subline_name,
                     DECODE (
                        b.endt_seq_no,
                        0,
                           b.line_cd
                        || '-'
                        || b.subline_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (b.renew_no, '09')),
                           b.line_cd
                        || '-'
                        || b.subline_cd
                        || '-'
                        || b.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (b.renew_no, '09'))
                        || '/'
                        || b.endt_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (b.endt_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (b.endt_seq_no, '099999'))
                     )
                        policy_no,
                     b.issue_date,
                     b.incept_date,
                     SUBSTR (a.assd_name, 1, 50) assd_name,
                     b.tsi_amt,
                     b.prem_amt,
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd
              FROM   cg_ref_codes r,
                     giis_line l,
                     gipi_polbasic b,
                     giuw_pol_dist c,
                     giis_subline s,
                     giis_assured a,
                     gipi_parlist p
             WHERE       r.rv_low_value = b.dist_flag
                     AND r.rv_low_value IN ('1', '2', '4')
                     AND c.dist_flag IN ('1', '2', '4')
                     AND r.rv_domain = 'GIPI_POLBASIC.DIST_FLAG'
                     AND b.iss_cd IN
                              (SELECT   iss_cd
                                 FROM   giis_issource
                                WHERE   ( (    iss_cd = giacp.v ('REINSURER')
                                           AND p_direct <> 1
                                           AND p_ri = 1)
                                         OR (iss_cd <> giacp.v ('REINSURER')
                                             AND p_direct = 1
                                             AND p_ri <> 1)
                                         OR (    1 = 1
                                             AND p_direct = 1
                                             AND p_ri = 1)))
                     AND l.line_cd = b.line_cd
                     AND s.subline_cd = b.subline_cd
                     AND s.line_cd = l.line_cd
                     AND a.assd_no = b.assd_no
                     AND p.par_id = b.par_id
                     AND b.policy_id = c.policy_id
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                           )
                     AND b.pol_flag <> '5'
                     AND NVL (b.endt_type, 0) <> 'N'
                     AND b.subline_cd <> 'MOP'
                     AND b.line_cd = NVL (p_line_cd, b.line_cd)
          ORDER BY   DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                     r.rv_meaning,
                     l.line_name,
                     s.subline_name,
                     b.line_cd,
                     b.subline_cd,
                     b.iss_cd,
                     b.issue_yy,
                     b.pol_seq_no,
                     b.renew_no,
                     a.assd_name)
      LOOP
         --get ISS_NAME
         BEGIN
            BEGIN
               SELECT   iss_name
                 INTO   v_iss_name
                 FROM   giis_issource
                WHERE   iss_cd = rec.iss_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_iss_name := 'No branch name';
            END;
         END;

         v_gipir924d.iss_name := v_iss_name;
         v_gipir924d.rv_meaning := rec.rv_meaning;
         v_gipir924d.line := rec.line_name;
         v_gipir924d.subline := rec.subline_name;
         v_gipir924d.policy_no := rec.policy_no;
         v_gipir924d.assured := rec.assd_name;
         v_gipir924d.issue_date := rec.issue_date;
         v_gipir924d.incept_date := rec.incept_date;
         v_gipir924d.tsi_amt := rec.tsi_amt;
         v_gipir924d.prem_amt := rec.prem_amt;

         PIPE ROW (v_gipir924d);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 21 ---------------------------------
   FUNCTION CSV_GIPIR924F (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924f_type
      PIPELINED
   IS
      v_gipir924f        gipir924f_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_subline          VARCHAR2 (50);
      v_param_v          VARCHAR2 (1);
      v_total            NUMBER (38, 2);
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   line_cd,
                     subline_cd,
                     SUM (NVL (DECODE (spld_date, NULL, a.total_tsi, 0), 0))
                        total_si,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) iss_cd,
                     SUM (NVL (DECODE (spld_date, NULL, a.total_prem, 0), 0))
                        total_prem,
                     SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                        evatprem,
                     SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0)) fst,
                     SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0)) lgt,
                     SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                        doc_stamps,
                     SUM (NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0))
                        other_taxes,
                     SUM (
                        NVL (DECODE (spld_date, NULL, a.other_charges, 0), 0)
                     )
                        other_charges,
                       SUM (NVL (DECODE (spld_date, NULL, a.total_prem, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                     + SUM (
                          NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0)
                       )
                     + SUM (
                          NVL (DECODE (spld_date, NULL, a.other_charges, 0), 0)
                       )
                        total,
                     COUNT (DECODE (spld_date, NULL, 1, 0)) pol_count,
                       SUM (NVL (DECODE (spld_date, NULL, a.evatprem, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.fst, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.lgt, 0), 0))
                     + SUM (NVL (DECODE (spld_date, NULL, a.doc_stamps, 0), 0))
                     + SUM (
                          NVL (DECODE (spld_date, NULL, a.other_taxes, 0), 0)
                       )
                     + SUM (
                          NVL (DECODE (spld_date, NULL, a.other_charges, 0), 0)
                       )
                        total_taxes,
                     SUM (NVL (DECODE (spld_date, NULL, b.commission, 0), 0))
                        commission
              FROM   gipi_uwreports_ext a,
                     (  SELECT   SUM(DECODE (
                                        c.ri_comm_amt * c.currency_rt,
                                        0,
                                        NVL (b.commission_amt * c.currency_rt, 0),
                                        c.ri_comm_amt * c.currency_rt
                                     ))
                                    commission,
                                 c.policy_id policy_id
                          FROM   gipi_comm_invoice b, gipi_invoice c
                         WHERE   b.policy_id = c.policy_id
                      GROUP BY   c.policy_id) b
             WHERE   a.policy_id = b.policy_id(+) AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
          GROUP BY   line_cd,
                     subline_cd,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd))
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get TOTAL
         SELECT   giacp.v ('SHOW_TOTAL_TAXES') INTO v_param_v FROM DUAL;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total;
         END IF;

         --get COMMISSION
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         c.ri_comm_amt,
                         c.currency_rt,
                         b.commission_amt,
                         a.spld_date
                  FROM   gipi_comm_invoice b,
                         gipi_invoice c,
                         gipi_uwreports_ext a
                 WHERE       a.policy_id = b.policy_id
                         AND a.policy_id = c.policy_id
                         AND a.user_id = p_user_id
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.iss_cd
                         AND a.line_cd = rec.line_cd
                         AND a.subline_cd = rec.subline_cd)
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   acct_ent_date,
                                 commission_amt,
                                 comm_rec_id,
                                 intm_no
                          FROM   giac_new_comm_inv
                         WHERE       iss_cd = rc.iss_cd
                                 AND prem_seq_no = rc.prem_seq_no
                                 AND fund_cd = v_fund_cd
                                 AND branch_cd = v_branch_cd
                                 AND tran_flag = 'P'
                                 AND NVL (delete_sw, 'N') = 'N'
                      ORDER BY   comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;

               IF rc.spld_date IS NOT NULL
               THEN
                  v_commission := 0;
                  EXIT;
               END IF;
            END LOOP;
         END;

         v_gipir924f.iss_name := v_iss_name;
         v_gipir924f.line := rec.line_cd;
         v_gipir924f.subline := v_subline;
         v_gipir924f.pol_count := rec.pol_count;
         v_gipir924f.tot_sum_insured := rec.total_si;
         v_gipir924f.tot_premium := rec.total_prem;
         v_gipir924f.evat := rec.evatprem;
         v_gipir924f.lgt := rec.lgt;
         v_gipir924f.doc_stamps := rec.doc_stamps;
         v_gipir924f.fire_service_tax := rec.fst;
         v_gipir924f.other_charges := rec.other_taxes;
         v_gipir924f.total := v_total;
         v_gipir924f.commission := v_commission;

         PIPE ROW (v_gipir924f);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 22 ---------------------------------
   FUNCTION CSV_GIPIR924E (p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924e_type
      PIPELINED
   IS
      v_gipir924e        gipir924e_rec_type;
      v_iss_name         VARCHAR2 (50);
      v_line             VARCHAR2 (50);
      v_subline          VARCHAR2 (50);
      v_pol_flag         cg_ref_codes.rv_meaning%TYPE;
      v_assured          VARCHAR2 (500);
      v_param_v          VARCHAR2 (1);
      v_total            NUMBER (38, 2);
      --policy_no
      v_policy_no        VARCHAR2 (100);
      v_endt_no          VARCHAR2 (30);
      v_ref_pol_no       VARCHAR2 (35) := NULL;
      --commission
      v_to_date          DATE;
      v_fund_cd          giac_new_comm_inv.fund_cd%TYPE;
      v_branch_cd        giac_new_comm_inv.branch_cd%TYPE;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (SPLD_DATE,
                             NULL, DECODE (a.dist_flag, 3, 'D', 'U'),
                             'S')
                        DIST_FLAG,
                     a.line_cd,
                     a.subline_cd,
                     DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                        iss_cd_header,
                     a.iss_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     a.issue_date,
                     a.incept_date,
                     a.expiry_date,
                     DECODE (spld_date, NULL, a.total_tsi, 0) TOTAL_TSI,
                     DECODE (spld_date, NULL, a.total_prem, 0) TOTAL_PREM,
                     DECODE (spld_date, NULL, a.evatprem, 0) EVATPREM,
                     DECODE (spld_date, NULL, a.lgt, 0) LGT,
                     DECODE (spld_date, NULL, a.doc_stamps, 0) DOC_STAMP,
                     DECODE (spld_date, NULL, a.fst, 0) FST,
                     DECODE (spld_date, NULL, a.other_taxes, 0) OTHER_TAXES,
                     DECODE (
                        spld_date,
                        NULL,
                        (  a.total_prem
                         + a.evatprem
                         + a.lgt
                         + a.doc_stamps
                         + a.fst
                         + a.other_taxes),
                        0
                     )
                        TOTAL_CHARGES,
                     DECODE (
                        spld_date,
                        NULL,
                        (  a.evatprem
                         + a.lgt
                         + a.doc_stamps
                         + a.fst
                         + a.other_taxes),
                        0
                     )
                        TOTAL_TAXES,
                     a.param_date,
                     a.from_date,
                     a.TO_DATE,
                     scope,
                     a.user_id,
                     a.policy_id,
                     a.assd_no,
                     DECODE (
                        SPLD_DATE,
                        NULL,
                        NULL,
                        ' S   P  O  I  L  E  D       /       '
                        || TO_CHAR (SPLD_DATE, 'MM-DD-YYYY')
                     )
                        SPLD_DATE,
                     DECODE (SPLD_DATE, NULL, 1, 0) POL_COUNT,
                     DECODE (spld_date, NULL, b.commission_amt, 0)
                        commission_amt,
                     DECODE (spld_date, NULL, b.wholding_tax, 0) wholding_tax,
                     DECODE (spld_date, NULL, b.net_comm, 0) net_comm,
                     a.pol_flag
              FROM   GIPI_UWREPORTS_EXT a,
                     (  SELECT   SUM(DECODE (
                                        c.ri_comm_amt * c.currency_rt,
                                        0,
                                        NVL (b.commission_amt * c.currency_rt, 0),
                                        c.ri_comm_amt * c.currency_rt
                                     ))
                                    commission_amt,
                                 SUM (NVL (b.wholding_tax, 0)) wholding_tax,
                                 SUM( (NVL (b.commission_amt, 0)
                                       - NVL (b.wholding_tax, 0)))
                                    net_comm,
                                 c.policy_id policy_id
                          FROM   gipi_comm_invoice b, gipi_invoice c
                         WHERE   c.policy_id = b.policy_id
                      GROUP BY   c.policy_id) b
             WHERE   a.policy_id = b.policy_id(+) AND a.user_id = p_user_id
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
          ORDER BY   a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.issue_yy,
                     a.pol_seq_no,
                     a.renew_no,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no)
      LOOP
         v_commission := 0;

         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR c IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.line_cd)
         LOOP
            v_line := c.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get POL_FLAG
         BEGIN
            FOR c1
            IN (SELECT   rv_meaning
                  FROM   cg_ref_codes
                 WHERE   rv_domain = 'GIPI_POLBASIC.POL_FLAG'
                         AND rv_low_value = rec.pol_flag)
            LOOP
               v_pol_flag := c1.rv_meaning;
            END LOOP;
         END;

         --get POLICY_NO
         BEGIN
            V_POLICY_NO :=
                  rec.LINE_CD
               || '-'
               || rec.SUBLINE_CD
               || '-'
               || LTRIM (rec.ISS_CD)
               || '-'
               || LTRIM (TO_CHAR (rec.ISSUE_YY, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.POL_SEQ_NO))
               || '-'
               || LTRIM (TO_CHAR (rec.RENEW_NO, '09'));

            IF rec.ENDT_SEQ_NO <> 0
            THEN
               V_ENDT_NO :=
                     rec.ENDT_ISS_CD
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_YY, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_SEQ_NO));
            END IF;

            BEGIN
               SELECT   ref_pol_no
                 INTO   v_ref_pol_no
                 FROM   gipi_polbasic
                WHERE   policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_pol_no := NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         --get ASSURED
         FOR c IN (SELECT   SUBSTR (assd_name, 1, 50) assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         --get TOTAL
         SELECT   giacp.v ('SHOW_TOTAL_TAXES') INTO v_param_v FROM DUAL;

         IF v_param_v = 'Y'
         THEN
            IF rec.spld_date IS NULL
            THEN
               v_total := rec.total_taxes;
            ELSE
               v_total := rec.total_charges;
            END IF;
         ELSE
            v_total := rec.total_charges;
         END IF;

         --get COMMISSION
         BEGIN
            SELECT   DISTINCT TO_DATE
              INTO   v_to_date
              FROM   gipi_uwreports_ext
             WHERE   user_id = p_user_id;

            v_fund_cd := giacp.v ('FUND_CD');
            v_branch_cd := giacp.v ('BRANCH_CD');

            FOR rc
            IN (SELECT   b.intrmdry_intm_no,
                         b.iss_cd,
                         b.prem_seq_no,
                         c.ri_comm_amt,
                         c.currency_rt,
                         b.commission_amt,
                         a.spld_date
                  FROM   gipi_comm_invoice b,
                         gipi_invoice c,
                         gipi_uwreports_ext a
                 WHERE       a.policy_id = b.policy_id
                         AND a.policy_id = c.policy_id
                         AND a.user_id = p_user_id
                         AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                               rec.iss_cd
                         AND a.line_cd = rec.line_cd
                         AND a.subline_cd = rec.subline_cd
                         AND a.policy_id = rec.policy_id)
            LOOP
               IF (rc.ri_comm_amt * rc.currency_rt) = 0
               THEN
                  v_commission_amt := rc.commission_amt;

                  FOR c1
                  IN (  SELECT   acct_ent_date,
                                 commission_amt,
                                 comm_rec_id,
                                 intm_no
                          FROM   giac_new_comm_inv
                         WHERE       iss_cd = rc.iss_cd
                                 AND prem_seq_no = rc.prem_seq_no
                                 AND fund_cd = v_fund_cd
                                 AND branch_cd = v_branch_cd
                                 AND tran_flag = 'P'
                                 AND NVL (delete_sw, 'N') = 'N'
                      ORDER BY   comm_rec_id DESC)
                  LOOP
                     IF c1.acct_ent_date > v_to_date
                     THEN
                        FOR c2
                        IN (SELECT   commission_amt
                              FROM   giac_prev_comm_inv
                             WHERE       fund_cd = v_fund_cd
                                     AND branch_cd = v_branch_cd
                                     AND comm_rec_id = c1.comm_rec_id
                                     AND intm_no = c1.intm_no)
                        LOOP
                           v_commission_amt := c2.commission_amt;
                        END LOOP;
                     ELSE
                        v_commission_amt := c1.commission_amt;
                     END IF;

                     EXIT;
                  END LOOP;

                  v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
               ELSE
                  v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
               END IF;

               v_commission := NVL (v_commission, 0) + v_comm_amt;

               IF rc.spld_date IS NOT NULL
               THEN
                  v_commission := 0;
               END IF;
            END LOOP;
         END;

         v_gipir924e.iss_name := v_iss_name;
         v_gipir924e.line := v_line;
         v_gipir924e.subline := v_subline;
         v_gipir924e.pol_flag := v_pol_flag;
         v_gipir924e.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir924e.assured := v_assured;
         v_gipir924e.issue_date := rec.issue_date;
         v_gipir924e.incept_date := rec.incept_date;
         v_gipir924e.expiry_date := rec.expiry_date;
         v_gipir924e.tot_sum_insured := rec.total_tsi;
         v_gipir924e.tot_premium := rec.total_prem;
         v_gipir924e.evat := rec.evatprem;
         v_gipir924e.lgt := rec.lgt;
         v_gipir924e.doc_stamps := rec.doc_stamp;
         v_gipir924e.fire_service_tax := rec.fst;
         v_gipir924e.other_charges := rec.other_taxes;
         v_gipir924e.total := v_total;
         v_gipir924e.commission := v_commission;

         PIPE ROW (v_gipir924e);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 23 ---------------------------------

   FUNCTION CSV_GIPIR928B (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928b_type
      PIPELINED
   IS
      v_gipir928b   gipir928b_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   B.LINE_NAME line_name,
                     C.SUBLINE_CD subline_cd,
                     A.POLICY_NO policy_no,
                     SUM (
                        DECODE (A.peril_type, 'A', 0, NVL (A.NR_DIST_TSI, 0))
                     )
                        NET_RET_TSi,
                     SUM (NVL (A.NR_DIST_PREM, 0)) NET_RET_PREM,
                     SUM (
                        DECODE (A.peril_type, 'A', 0, NVL (A.TR_DIST_TSI, 0))
                     )
                        TREATY_TSI,
                     SUM (NVL (A.TR_DIST_PREM, 0)) TREATY_PREM,
                     SUM (
                        DECODE (A.peril_type, 'A', 0, NVL (A.FA_DIST_TSI, 0))
                     )
                        FACULTATIVE_TSI,
                     SUM (NVL (A.FA_DIST_PREM, 0)) FACULTATIVE_PREM,
                     SUM (
                        DECODE (A.peril_type, 'A', 0, NVL (A.NR_DIST_TSI, 0))
                     )
                     + SUM (
                          DECODE (A.peril_type, 'A', 0, NVL (A.TR_DIST_TSI, 0))
                       )
                     + SUM (
                          DECODE (A.peril_type, 'A', 0, NVL (A.FA_DIST_TSI, 0))
                       )
                        TOTAL_TSI,
                       SUM (NVL (A.NR_DIST_PREM, 0))
                     + SUM (NVL (A.TR_DIST_PREM, 0))
                     + SUM (NVL (A.FA_DIST_PREM, 0))
                        TOTAL_PREMIUM
              FROM   GIPI_UWREPORTS_DIST_PERIL_EXT A,
                     GIIS_LINE B,
                     GIIS_SUBLINE C
             WHERE       A.LINE_CD = B.LINE_CD
                     AND A.SUBLINE_CD = C.SUBLINE_CD
                     AND A.LINE_CD = C.LINE_CD
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                     AND a.user_id = p_user_id
                     AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                          OR (p_scope = 1 AND a.endt_seq_no = 0)
                          OR (p_scope = 2 AND a.endt_seq_no > 0))
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
          GROUP BY   B.LINE_NAME, C.SUBLINE_CD, A.POLICY_NO
          ORDER BY   B.LINE_NAME, C.SUBLINE_CD, A.POLICY_NO)
      LOOP
         v_gipir928b.line := rec.line_name;
         v_gipir928b.subline := rec.subline_cd;
         v_gipir928b.policy_no := rec.policy_no;
         v_gipir928b.net_ret_tsi := rec.net_ret_tsi;
         v_gipir928b.net_ret_prem := rec.net_ret_prem;
         v_gipir928b.treaty_tsi := rec.treaty_tsi;
         v_gipir928b.treaty_prem := rec.treaty_prem;
         v_gipir928b.facultative_tsi := rec.facultative_tsi;
         v_gipir928b.facultative_prem := rec.facultative_prem;
         v_gipir928b.total_tsi := rec.total_tsi;
         v_gipir928b.total_prem := rec.total_premium;

         PIPE ROW (v_gipir928b);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 24 ---------------------------------

   FUNCTION CSV_GIPIR928C (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928c_type
      PIPELINED
   IS
      v_gipir928c   gipir928c_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   b.LINE_NAME LINE_NAME,
                     c.SUBLINE_CD SUBLINE_CD,
                     d.peril_name PERIL_NAME,
                     DECODE (a.PERIL_TYPE,
                             'A', 0,
                             SUM (NVL (a.NR_DIST_TSI, 0)))
                        NRDISTTSI,
                     SUM (NVL (a.NR_DIST_PREM, 0)) NRDISTPREM,
                     DECODE (a.PERIL_TYPE,
                             'A', 0,
                             SUM (NVL (a.TR_DIST_TSI, 0)))
                        TRDISTTSI,
                     SUM (NVL (a.TR_DIST_PREM, 0)) TRDISTPREM,
                     DECODE (a.PERIL_TYPE,
                             'A', 0,
                             SUM (NVL (a.FA_DIST_TSI, 0)))
                        FADISTTSI,
                     SUM (NVL (a.FA_DIST_PREM, 0)) FADISTPREM,
                     DECODE (a.PERIL_TYPE,
                             'A', 0,
                             SUM (NVL (a.NR_DIST_TSI, 0)))
                     + DECODE (a.PERIL_TYPE,
                               'A', 0,
                               SUM (NVL (a.TR_DIST_TSI, 0)))
                     + DECODE (a.PERIL_TYPE,
                               'A', 0,
                               SUM (NVL (a.FA_DIST_TSI, 0)))
                        TOTALTSI,
                       SUM (NVL (a.NR_DIST_PREM, 0))
                     + SUM (NVL (a.TR_DIST_PREM, 0))
                     + SUM (NVL (a.FA_DIST_PREM, 0))
                        TOTALPREM
              FROM   GIPI_UWREPORTS_DIST_PERIL_EXT a,
                     GIIS_LINE b,
                     GIIS_SUBLINE c,
                     GIIS_PERIL d
             WHERE       a.LINE_CD = b.LINE_CD
                     AND a.LINE_CD = c.LINE_CD
                     AND a.SUBLINE_CD = c.SUBLINE_CD
                     AND a.LINE_CD = d.LINE_CD
                     AND a.PERIL_CD = d.PERIL_CD
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                     AND a.user_id = p_user_id
                     AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                          OR (p_scope = 1 AND a.endt_seq_no = 0)
                          OR (p_scope = 2 AND a.endt_seq_no > 0))
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
          GROUP BY   b.LINE_NAME,
                     c.SUBLINE_CD,
                     d.peril_name,
                     A.PERIL_TYPE
          ORDER BY   b.LINE_NAME, c.SUBLINE_CD, d.peril_name)
      LOOP
         v_gipir928c.line := rec.line_name;
         v_gipir928c.subline := rec.subline_cd;
         v_gipir928c.peril_name := rec.peril_name;
         v_gipir928c.net_ret_tsi := rec.nrdisttsi;
         v_gipir928c.net_ret_prem := rec.nrdistprem;
         v_gipir928c.treaty_tsi := rec.trdisttsi;
         v_gipir928c.treaty_prem := rec.trdistprem;
         v_gipir928c.facultative_tsi := rec.fadisttsi;
         v_gipir928c.facultative_prem := rec.fadistprem;
         v_gipir928c.total_tsi := rec.totaltsi;
         v_gipir928c.total_prem := rec.totalprem;

         PIPE ROW (v_gipir928c);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 25 ---------------------------------

   FUNCTION CSV_GIPIR928D (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928d_type
      PIPELINED
   IS
      v_gipir928d   gipir928d_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   INITCAP (B.LINE_NAME) LINE_NAME,
                     INITCAP (C.SUBLINE_NAME) SUBLINE_NAME,
                     COUNT (DISTINCT A.POLICY_NO) POLICIES,
                     SUM (
                        DECODE (a.peril_type, 'A', 0, NVL (A.NR_DIST_TSI, 0))
                     )
                        NET_RET_TSI,
                     SUM (NVL (A.NR_DIST_PREM, 0)) NET_RET_PREMIUM,
                     SUM (
                        DECODE (a.peril_type, 'A', 0, NVL (A.TR_DIST_TSI, 0))
                     )
                        TREATY_TSI,
                     SUM (NVL (A.TR_DIST_PREM, 0)) TREATY_PREMIUM,
                     SUM (
                        DECODE (a.peril_type, 'A', 0, NVL (A.FA_DIST_TSI, 0))
                     )
                        FACULTATIVE_TSI,
                     SUM (NVL (A.FA_DIST_PREM, 0)) FACULTATIVE_PREMIUM,
                     SUM (
                        DECODE (a.peril_type, 'A', 0, NVL (A.NR_DIST_TSI, 0))
                     )
                     + SUM (
                          DECODE (a.peril_type, 'A', 0, NVL (A.TR_DIST_TSI, 0))
                       )
                     + SUM (
                          DECODE (a.peril_type, 'A', 0, NVL (A.FA_DIST_TSI, 0))
                       )
                        TOTAL_SUM_SINSURED,
                       SUM (NVL (A.NR_DIST_PREM, 0))
                     + SUM (NVL (A.TR_DIST_PREM, 0))
                     + SUM (NVL (A.FA_DIST_PREM, 0))
                        TOTAL_PREMIUM
              FROM   GIPI_UWREPORTS_DIST_PERIL_EXT A,
                     GIIS_LINE B,
                     GIIS_SUBLINE C
             WHERE       A.LINE_CD = B.LINE_CD
                     AND A.SUBLINE_CD = C.SUBLINE_CD
                     AND A.LINE_CD = C.LINE_CD
                     AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd)
                           )
                     AND a.line_cd = NVL (UPPER (p_line_cd), a.line_cd)
                     AND a.user_id = p_user_id
                     AND (   (p_scope = 3 AND a.endt_seq_no = a.endt_seq_no)
                          OR (p_scope = 1 AND a.endt_seq_no = 0)
                          OR (p_scope = 2 AND a.endt_seq_no > 0))
                     AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
          GROUP BY   B.LINE_NAME, C.SUBLINE_NAME
          ORDER BY   B.LINE_NAME, C.SUBLINE_NAME)
      LOOP
         v_gipir928d.line := rec.line_name;
         v_gipir928d.subline := rec.subline_name;
         v_gipir928d.pol_count := rec.policies;
         v_gipir928d.net_ret_tsi := rec.net_ret_tsi;
         v_gipir928d.net_ret_prem := rec.net_ret_premium;
         v_gipir928d.treaty_tsi := rec.treaty_tsi;
         v_gipir928d.treaty_prem := rec.treaty_premium;
         v_gipir928d.facultative_tsi := rec.facultative_tsi;
         v_gipir928d.facultative_prem := rec.facultative_premium;
         v_gipir928d.total_tsi := rec.total_sum_sinsured;
         v_gipir928d.total_prem := rec.total_premium;

         PIPE ROW (v_gipir928d);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 26 ---------------------------------

   FUNCTION CSV_GIPIR923J (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923j_type
      PIPELINED
   IS
      v_gipir923j       gipir923j_rec_type;
      v_iss_name        VARCHAR2 (100);
      v_line            VARCHAR2 (50);
      v_subline         VARCHAR2 (30);
      v_policy_no       VARCHAR2 (100);
      v_endt_no         VARCHAR2 (30);
      v_ref_pol_no      VARCHAR2 (35) := NULL;
      v_assured         VARCHAR2 (500);
      v_param_value_v   giis_parameters.param_value_v%TYPE;
      v_testing         VARCHAR2 (50);

      v_param_v         VARCHAR2 (1);
      v_total           NUMBER (38, 2);
   BEGIN
      FOR rec
      IN (  SELECT   DECODE (spld_date,
                             NULL, DECODE (dist_flag, 3, 'D', 'U'),
                             'S')
                        "DIST_FLAG",
                     line_cd,
                     subline_cd,
                     iss_cd,
                     DECODE (p_iss_param, 1, gp.cred_branch, gp.iss_cd)
                        iss_cd_header,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no,
                     issue_date,
                     incept_date,
                     expiry_date,
                     DECODE (spld_date, NULL, total_tsi, 0) total_tsi,
                     DECODE (spld_date, NULL, total_prem, 0) total_prem,
                     DECODE (spld_date, NULL, evatprem, 0) evatprem,
                     DECODE (spld_date, NULL, lgt, 0) lgt,
                     DECODE (spld_date, NULL, doc_stamps, 0) doc_stamp,
                     DECODE (spld_date, NULL, fst, 0) fst,
                     DECODE (spld_date, NULL, other_taxes, 0) other_taxes,
                     DECODE (
                        spld_date,
                        NULL,
                        (  total_prem
                         + evatprem
                         + lgt
                         + doc_stamps
                         + fst
                         + other_taxes),
                        0
                     )
                        TOTAL_CHARGES,
                     DECODE (spld_date,
                             NULL,
                             (evatprem + lgt + doc_stamps + fst + other_taxes),
                             0)
                        total_taxes,
                     param_date,
                     from_date,
                     TO_DATE,
                     SCOPE,
                     user_id,
                     policy_id,
                     assd_no,
                     DECODE (
                        spld_date,
                        NULL,
                        NULL,
                        ' S   P  O  I  L  E  D       /       '
                        || TO_CHAR (spld_date, 'MM-DD-YYYY')
                     )
                        spld_date,
                     DECODE (spld_date, NULL, 1, 0) pol_count
              FROM   gipi_uwreports_ext gp
             WHERE   user_id = p_user_id
                     AND DECODE (p_iss_param, 1, gp.cred_branch, gp.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param,
                                      1, gp.cred_branch,
                                      gp.iss_cd)
                           )
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND p_scope = 3
                     AND pol_flag = '4'
          ORDER BY   line_cd,
                     subline_cd,
                     iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR b IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.LINE_CD)
         LOOP
            v_line := b.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get POLICY_NO
         BEGIN
            V_POLICY_NO :=
                  rec.LINE_CD
               || '-'
               || rec.SUBLINE_CD
               || '-'
               || LTRIM (rec.ISS_CD)
               || '-'
               || LTRIM (TO_CHAR (rec.ISSUE_YY, '09'))
               || '-'
               || LTRIM (TO_CHAR (rec.POL_SEQ_NO))
               || '-'
               || LTRIM (TO_CHAR (rec.RENEW_NO, '09'));

            IF rec.ENDT_SEQ_NO <> 0
            THEN
               V_ENDT_NO :=
                     rec.ENDT_ISS_CD
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_YY, '09'))
                  || '-'
                  || LTRIM (TO_CHAR (rec.ENDT_SEQ_NO));
            END IF;

            BEGIN
               SELECT   ref_pol_no
                 INTO   v_ref_pol_no
                 FROM   gipi_polbasic
                WHERE   policy_id = rec.policy_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_ref_pol_no := NULL;
            END;

            IF v_ref_pol_no IS NOT NULL
            THEN
               v_ref_pol_no := '/' || v_ref_pol_no;
            END IF;
         END;

         --get ASSURED
         FOR c IN (SELECT   SUBSTR (assd_name, 1, 50) assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         --get TOTAL
         SELECT   giacp.v ('SHOW_TOTAL_TAXES') INTO v_param_v FROM DUAL;

         IF v_param_v = 'Y'
         THEN
            v_total := rec.total_taxes;
         ELSE
            v_total := rec.total_charges;
         END IF;

         v_gipir923j.iss_name := v_iss_name;
         v_gipir923j.line := v_line;
         v_gipir923j.subline := v_subline;
         v_gipir923j.stat := rec.dist_flag;
         v_gipir923j.policy_no :=
            v_policy_no || ' ' || v_endt_no || v_ref_pol_no;
         v_gipir923j.assured := v_assured;
         v_gipir923j.issue_date := rec.issue_date;
         v_gipir923j.incept_date := rec.incept_date;
         v_gipir923j.expiry_date := rec.expiry_date;
         v_gipir923j.total_si := rec.total_tsi;
         v_gipir923j.tot_premium := rec.total_prem;
         v_gipir923j.evat := rec.evatprem;
         v_gipir923j.lgt := rec.lgt;
         v_gipir923j.doc_stamps := rec.doc_stamp;
         v_gipir923j.fire_service_tax := rec.fst;
         v_gipir923j.other_charges := rec.other_taxes;
         v_gipir923j.total := v_total;

         PIPE ROW (v_gipir923j);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 27 ---------------------------------

   FUNCTION CSV_GIPIR923D (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir923d_type
      PIPELINED
   IS
      v_gipir923d   gipir923d_rec_type;
      v_iss_name    VARCHAR2 (100);
      v_line        VARCHAR2 (50);
      v_subline     VARCHAR2 (30);
      v_assured     VARCHAR2 (500);
   BEGIN
      FOR rec
      IN (SELECT   TO_NUMBER (NVL (TO_CHAR (acct_ent_date, 'MM'), '13'))
                      acctg_seq,
                   NVL (TO_CHAR (acct_ent_date, 'FMMONTH, RRRR'),
                        'NOT TAKEN UP')
                      acct_ent_date,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd_head,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no,
                   get_policy_no (policy_id) policy_no,
                   issue_date,
                   incept_date,
                   expiry_date,
                   total_tsi total_tsi,
                   total_prem total_prem,
                   evatprem evatprem,
                   lgt lgt,
                   doc_stamps doc_stamp,
                   fst fst,
                   other_taxes other_taxes,
                   (  total_prem
                    + evatprem
                    + lgt
                    + doc_stamps
                    + fst
                    + other_taxes)
                      TOTAL_CHARGES,
                   param_date,
                   from_date,
                   TO_DATE,
                   scope,
                   user_id,
                   policy_id,
                   assd_no
            FROM   gipi_uwreports_ext gp
           WHERE   user_id = p_user_id
                   AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                         NVL (p_iss_cd,
                              DECODE (p_iss_param, 1, cred_branch, iss_cd))
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND p_scope = 3
                   AND pol_flag = '4'
          UNION
          SELECT   TO_NUMBER (NVL (TO_CHAR (spld_acct_ent_date, 'MM'), '13'))
                      acctg_seq,
                   NVL (TO_CHAR (spld_acct_ent_date, 'FMMONTH, RRRR'),
                        'NOT TAKEN UP')
                      acct_ent_date,
                   line_cd,
                   subline_cd,
                   iss_cd,
                   DECODE (p_iss_param, 1, cred_branch, iss_cd) iss_cd_head,
                   issue_yy,
                   pol_seq_no,
                   renew_no,
                   endt_iss_cd,
                   endt_yy,
                   endt_seq_no,
                   get_policy_no (policy_id) || '*' policy_no,
                   issue_date,
                   incept_date,
                   expiry_date,
                   -1 * total_tsi total_tsi,
                   -1 * total_prem total_prem,
                   -1 * evatprem evatprem,
                   -1 * lgt lgt,
                   -1 * doc_stamps doc_stamp,
                   -1 * fst fst,
                   -1 * other_taxes other_taxes,
                   -1
                   * (  total_prem
                      + evatprem
                      + lgt
                      + doc_stamps
                      + fst
                      + other_taxes)
                      TOTAL_CHARGES,
                   param_date,
                   from_date,
                   TO_DATE,
                   scope,
                   user_id,
                   policy_id,
                   assd_no
            FROM   gipi_uwreports_ext gp
           WHERE       user_id = p_user_id
                   AND iss_cd = NVL (p_iss_cd, iss_cd)
                   AND line_cd = NVL (p_line_cd, line_cd)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND p_scope = 3
                   AND pol_flag = '4'
                   AND spld_acct_ent_date IS NOT NULL
          ORDER BY   acctg_seq,
                     line_cd,
                     subline_cd,
                     iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     endt_iss_cd,
                     endt_yy,
                     endt_seq_no)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.ISS_CD;

            v_iss_name := REC.iss_cd || ' - ' || v_iss_name;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         --get LINE_NAME
         FOR b IN (SELECT   line_name
                     FROM   giis_line
                    WHERE   line_cd = rec.LINE_CD)
         LOOP
            v_line := b.line_name;
         END LOOP;

         --get SUBLINE_NAME
         FOR c
         IN (SELECT   subline_name
               FROM   giis_subline
              WHERE   line_cd = rec.LINE_CD AND subline_cd = rec.SUBLINE_CD)
         LOOP
            v_subline := c.subline_name;
         END LOOP;

         --get ASSURED
         FOR c IN (SELECT   SUBSTR (assd_name, 1, 50) assd_name
                     FROM   giis_assured
                    WHERE   assd_no = rec.assd_no)
         LOOP
            v_assured := c.assd_name;
         END LOOP;

         v_gipir923d.iss_name := v_iss_name;
         v_gipir923d.line := v_line;
         v_gipir923d.subline := v_subline;
         v_gipir923d.acct_ent_date := rec.acct_ent_date;
         v_gipir923d.policy_no := rec.policy_no;
         v_gipir923d.assured := v_assured;
         v_gipir923d.issue_date := rec.issue_date;
         v_gipir923d.incept_date := rec.incept_date;
         v_gipir923d.expiry_date := rec.expiry_date;
         v_gipir923d.total_si := rec.total_tsi;
         v_gipir923d.tot_premium := rec.total_prem;
         v_gipir923d.evat := rec.evatprem;
         v_gipir923d.lgt := rec.lgt;
         v_gipir923d.doc_stamps := rec.doc_stamp;
         v_gipir923d.fire_service_tax := rec.fst;
         v_gipir923d.other_charges := rec.other_taxes;
         v_gipir923d.total := rec.total_charges;

         PIPE ROW (v_gipir923d);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 28 ---------------------------------

   FUNCTION CSV_GIPIR928A (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928a_type
      PIPELINED
   IS
      v_gipir928a   gipir928a_rec_type;
      v_iss_name    VARCHAR2 (100);
   BEGIN
      FOR rec
      IN (  SELECT   b.iss_cd iss_cd,
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                        iss_cd_header,
                     b.line_cd line_cd,
                     INITCAP (e.line_name) line_name,
                     b.subline_cd subline_cd,
                     INITCAP (f.subline_name) subline_name,
                     b.policy_no policY_no,
                     DECODE (C.PERIL_TYPE,
                             'B', '*' || C.PERIL_SNAME,
                             ' ' || C.PERIL_SNAME)
                        peril_sname,
                     SUM (
                        DECODE (c.peril_type, 'B', NVL (b.nr_dist_tsi, 0), '0')
                     )
                        f_nr_dist_tsi,
                     SUM (
                        DECODE (c.peril_type, 'B', NVL (b.tr_dist_tsi, 0), '0')
                     )
                        f_tr_dist_tsi,
                     SUM (
                        DECODE (c.peril_type, 'B', NVL (b.fa_dist_tsi, 0), '0')
                     )
                        f_fa_dist_tsi,
                     SUM (NVL (b.nr_dist_tsi, 0)) nr_peril_tsi,
                     SUM (NVL (b.nr_dist_prem, 0)) nr_peril_prem,
                     SUM (NVL (b.tr_dist_tsi, 0)) tr_peril_tsi,
                     SUM (NVL (b.tr_dist_prem, 0)) tr_peril_prem,
                     SUM (NVL (b.fa_dist_tsi, 0)) fa_peril_tsi,
                     SUM (NVL (b.fa_dist_prem, 0)) fa_peril_prem
              FROM   gipi_uwreports_dist_peril_ext b,
                     giis_peril c,
                     giis_subline f,
                     giis_dist_share d,
                     giis_issource g,
                     giis_line e
             WHERE       1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = f.line_cd
                     AND b.subline_cd = f.subline_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                           )
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.line_cd = e.line_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           g.iss_cd
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND b.user_id = p_user_id
                     AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                          OR (p_scope = 1 AND b.endt_seq_no = 0)
                          OR (p_scope = 2 AND b.endt_seq_no > 0))
                     AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
          GROUP BY   b.iss_cd,
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                     b.line_cd,
                     e.line_name,
                     b.subline_cd,
                     f.subline_name,
                     b.policy_no,
                     c.peril_sname,
                     c.peril_type,
                     c.peril_sname
          ORDER BY   b.iss_cd,
                     e.line_name,
                     f.subline_name,
                     b.policy_no,
                     c.peril_sname)
      LOOP
         --get ISS_NAME
         BEGIN
            SELECT   iss_name
              INTO   v_iss_name
              FROM   giis_issource
             WHERE   iss_cd = rec.iss_cd_header;
         EXCEPTION
            WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
            THEN
               NULL;
         END;

         v_gipir928a.iss_name := v_iss_name;
         v_gipir928a.line := rec.line_name;
         v_gipir928a.subline := rec.subline_name;
         v_gipir928a.policy_no := rec.policy_no;
         v_gipir928a.peril_sname := rec.peril_sname;
         v_gipir928a.nr_risk := rec.nr_peril_tsi;
         v_gipir928a.nr_prem := rec.nr_peril_prem;
         v_gipir928a.t_risk := rec.tr_peril_tsi;
         v_gipir928a.t_prem := rec.tr_peril_prem;
         v_gipir928a.f_risk := rec.f_fa_dist_tsi;
         v_gipir928a.f_prem := rec.fa_peril_prem;

         PIPE ROW (v_gipir928a);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 29 ---------------------------------

   FUNCTION CSV_GIPIR928 (p_scope         NUMBER,
                          p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928_type
      PIPELINED
   IS
      v_gipir928   gipir928_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   DISTINCT
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd,
                     DECODE (c.peril_type,
                             'B', '*' || c.peril_sname,
                             ' ' || c.peril_sname)
                        peril_sname,
                     g.iss_name,
                     b.line_cd,
                     e.line_name,
                     b.subline_cd,
                     f.subline_name,
                     b.policy_id,
                     b.policy_no policy_no,
                     SUM (NVL (b.tr_dist_tsi, 0)) tr_peril_tsi,
                     SUM (NVL (b.tr_dist_prem, 0)) tr_peril_prem
              FROM   gipi_uwreports_dist_peril_ext b,
                     giis_peril c,
                     giis_subline f,
                     giis_dist_share d,
                     giis_issource g,
                     giis_line e
             WHERE       1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = f.line_cd
                     AND b.subline_cd = f.subline_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.line_cd = e.line_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           g.iss_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                           )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND b.share_type = 2
                     AND b.user_id = p_user_id
                     AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                          OR (p_scope = 1 AND b.endt_seq_no = 0)
                          OR (p_scope = 2 AND b.endt_seq_no > 0))
                     AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
          GROUP BY   DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                     DECODE (c.peril_type,
                             'B', '*' || c.peril_sname,
                             ' ' || c.peril_sname),
                     g.iss_name,
                     b.line_cd,
                     e.line_name,
                     b.subline_cd,
                     f.subline_name,
                     b.policy_id,
                     b.policy_no
          ORDER BY   g.iss_name,
                     e.line_name,
                     f.subline_name,
                     b.policy_no)
      LOOP
         v_gipir928.iss_name := rec.iss_name;
         v_gipir928.line := rec.line_name;
         v_gipir928.subline := rec.subline_name;
         v_gipir928.policy_no := rec.policy_no;
         v_gipir928.peril_sname := rec.peril_sname;
         v_gipir928.tsi_amt := rec.tr_peril_tsi;
         v_gipir928.prem_amt := rec.tr_peril_prem;

         PIPE ROW (v_gipir928);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 30 ---------------------------------

   FUNCTION CSV_GIPIR928E (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928e_type
      PIPELINED
   IS
      v_gipir928e   gipir928e_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   DISTINCT
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd,
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                        iss_cd_header,
                     g.iss_name iss_name,
                     b.line_cd line_cd,
                     e.line_name line_name,
                     b.subline_cd subline_cd,
                     f.subline_name subline_name,
                     SUM (NVL (b.nr_dist_tsi, 0)) nr_tsi,
                     SUM (NVL (b.tr_dist_tsi, 0)) tr_tsi,
                     SUM (
                        DECODE (c.peril_type, 'B', NVL (b.fa_dist_tsi, 0), 0)
                     )
                        fa_tsi,
                     SUM(DECODE (c.peril_type, 'B', NVL (b.nr_dist_tsi, 0), 0)
                         + DECODE (c.peril_type,
                                   'B', NVL (b.tr_dist_tsi, 0),
                                   0)
                         + DECODE (c.peril_type,
                                   'B', NVL (b.fa_dist_tsi, 0),
                                   0))
                        total_tsi,
                     SUM (NVL (b.nr_dist_prem, 0)) nr_prem,
                     SUM (NVL (b.tr_dist_prem, 0)) tr_prem,
                     SUM (NVL (b.fa_dist_prem, 0)) fa_prem,
                     SUM(  NVL (b.nr_dist_prem, 0)
                         + NVL (b.tr_dist_prem, 0)
                         + NVL (b.fa_dist_prem, 0))
                        total_prem
              FROM   gipi_uwreports_dist_peril_ext b,
                     giis_peril c,
                     giis_subline f,
                     giis_dist_share d,
                     giis_issource g,
                     giis_line e
             WHERE       1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = f.line_cd
                     AND b.subline_cd = f.subline_cd
                     AND b.line_cd = d.line_cd
                     AND b.share_cd = d.share_cd
                     AND b.line_cd = e.line_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           g.iss_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                           )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND b.user_id = p_user_id
                     AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                          OR (p_scope = 1 AND b.endt_seq_no = 0)
                          OR (p_scope = 2 AND b.endt_seq_no > 0))
                     AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
          GROUP BY   DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                     g.iss_name,
                     b.line_cd,
                     e.line_name,
                     b.subline_cd,
                     f.subline_name
          ORDER BY   g.iss_name, e.line_name, f.subline_name)
      LOOP
         v_gipir928e.iss_name := rec.iss_name;
         v_gipir928e.line := rec.line_name;
         v_gipir928e.subline := rec.subline_name;
         v_gipir928e.nr_tsi := rec.nr_tsi;
         v_gipir928e.tr_tsi := rec.tr_tsi;
         v_gipir928e.fa_tsi := rec.fa_tsi;
         v_gipir928e.total_tsi := rec.total_tsi;
         v_gipir928e.nr_prem := rec.nr_prem;
         v_gipir928e.tr_prem := rec.tr_prem;
         v_gipir928e.fa_prem := rec.fa_prem;
         v_gipir928e.total_prem := rec.total_prem;

         PIPE ROW (v_gipir928e);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 31 ---------------------------------

   FUNCTION CSV_GIPIR928F (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928f_type
      PIPELINED
   IS
      v_gipir928f   gipir928f_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   DISTINCT
                     b.iss_cd,
                     INITCAP (g.iss_name) iss_name,
                     b.line_cd,
                     INITCAP (e.line_name) line_name,
                     b.subline_cd,
                     INITCAP (f.subline_name) subline_name,
                     b.policy_no policy_no2,
                     b.policy_id policy_id,
                     DECODE (c.peril_type,
                             'B', '*' || c.peril_sname,
                             ' ' || c.peril_sname)
                        peril_sname,
                     SUM (DECODE (b.peril_type, 'B', NVL (nr_dist_tsi, 0), 0))
                        nr_tsi,
                     SUM (NVL (nr_dist_prem, 0)) nr_prem,
                     SUM (DECODE (b.peril_type, 'B', NVL (tr_dist_tsi, 0), 0))
                        tr_tsi,
                     SUM (NVL (tr_dist_prem, 0)) tr_prem,
                     SUM (DECODE (b.peril_type, 'B', NVL (fa_dist_tsi, 0), 0))
                        fa_tsi,
                     SUM (NVL (fa_dist_prem, 0)) fa_prem,
                     SUM(  DECODE (b.peril_type, 'B', NVL (nr_dist_tsi, 0), 0)
                         + DECODE (b.peril_type, 'B', NVL (tr_dist_tsi, 0), 0)
                         + DECODE (b.peril_type, 'B', NVL (fa_dist_tsi, 0), 0))
                        tsi_amt,
                     SUM(  NVL (nr_dist_prem, 0)
                         + NVL (tr_dist_prem, 0)
                         + NVL (fa_dist_prem, 0))
                        prem_amt
              FROM   gipi_uwreports_dist_peril_ext b,
                     giis_peril c,
                     giis_subline f,
                     giis_issource g,
                     giis_line e
             WHERE       1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = f.line_cd
                     AND b.subline_cd = f.subline_cd
                     AND b.line_cd = e.line_cd
                     AND b.iss_cd = g.iss_cd
                     AND b.iss_cd = NVL (UPPER (p_iss_cd), b.iss_cd)
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND b.user_id = p_user_id
                     AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                          OR (p_scope = 1 AND b.endt_seq_no = 0)
                          OR (p_scope = 2 AND b.endt_seq_no > 0))
                     AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
          GROUP BY   b.iss_cd,
                     g.iss_name,
                     b.line_cd,
                     e.line_name,
                     b.subline_cd,
                     f.subline_name,
                     b.policy_no,
                     b.policy_id
          ORDER BY   INITCAP (g.iss_name),
                     INITCAP (e.line_name),
                     INITCAP (f.subline_name),
                     b.policy_no)
      LOOP
         v_gipir928f.iss_name := rec.iss_name;
         v_gipir928f.line := rec.line_name;
         v_gipir928f.subline := rec.subline_name;
         v_gipir928f.policy_no := rec.policy_no2;
         v_gipir928f.peril_sname := rec.peril_sname;
         v_gipir928f.nr_tsi := rec.nr_tsi;
         v_gipir928f.nr_prem := rec.nr_prem;
         v_gipir928f.tr_tsi := rec.tr_tsi;
         v_gipir928f.tr_prem := rec.tr_prem;
         v_gipir928f.fa_tsi := rec.fa_tsi;
         v_gipir928f.fa_prem := rec.fa_prem;
         v_gipir928f.total_tsi := rec.tsi_amt;
         v_gipir928f.total_prem := rec.prem_amt;

         PIPE ROW (v_gipir928f);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 32 ---------------------------------

   FUNCTION CSV_GIPIR928G (p_scope         NUMBER,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                           p_iss_param     VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir928g_type
      PIPELINED
   IS
      v_gipir928g   gipir928g_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   DISTINCT
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd,
                     DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) iss_cd1,
                     INITCAP (g.iss_name) iss_name,
                     b.line_cd,
                     INITCAP (e.line_name) line_name,
                     b.subline_cd,
                     INITCAP (f.subline_name) subline_name,
                     b.policy_no policy_no2,
                     b.policy_id policy_id,
                     DECODE (c.peril_type,
                             'B', '*' || c.peril_sname,
                             ' ' || c.peril_sname)
                        peril_sname,
                     SUM (DECODE (b.peril_type, 'B', NVL (nr_dist_tsi, 0), 0))
                        nr_tsi,
                     SUM (NVL (nr_dist_prem, 0)) nr_prem,
                     SUM (DECODE (b.peril_type, 'B', NVL (tr_dist_tsi, 0), 0))
                        tr_tsi,
                     SUM (NVL (tr_dist_prem, 0)) tr_prem,
                     SUM (DECODE (b.peril_type, 'B', NVL (fa_dist_tsi, 0), 0))
                        fa_tsi,
                     SUM (NVL (fa_dist_prem, 0)) fa_prem,
                     SUM(  DECODE (b.peril_type, 'B', NVL (nr_dist_tsi, 0), 0)
                         + DECODE (b.peril_type, 'B', NVL (tr_dist_tsi, 0), 0)
                         + DECODE (b.peril_type, 'B', NVL (fa_dist_tsi, 0), 0))
                        tsi_amt,
                     SUM(  NVL (nr_dist_prem, 0)
                         + NVL (tr_dist_prem, 0)
                         + NVL (fa_dist_prem, 0))
                        prem_amt
              FROM   gipi_uwreports_dist_peril_ext b,
                     giis_peril c,
                     giis_subline f,
                     giis_issource g,
                     giis_line e
             WHERE       1 = 1
                     AND b.line_cd = c.line_cd
                     AND b.peril_cd = c.peril_cd
                     AND b.line_cd = f.line_cd
                     AND b.subline_cd = f.subline_cd
                     AND b.line_cd = e.line_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           g.iss_cd
                     AND DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd)
                           )
                     AND b.line_cd = NVL (UPPER (p_line_cd), b.line_cd)
                     AND b.user_id = p_user_id
                     AND (   (p_scope = 3 AND b.endt_seq_no = b.endt_seq_no)
                          OR (p_scope = 1 AND b.endt_seq_no = 0)
                          OR (p_scope = 2 AND b.endt_seq_no > 0))
                     AND b.subline_cd = NVL (p_subline_cd, b.subline_cd)
          GROUP BY   DECODE (p_iss_param, 1, b.cred_branch, b.iss_cd),
                     g.iss_name,
                     b.line_cd,
                     e.line_name,
                     b.subline_cd,
                     f.subline_name,
                     b.policy_no,
                     b.policy_id,
                     DECODE (c.peril_type,
                             'B', '*' || c.peril_sname,
                             ' ' || c.peril_sname)
          ORDER BY   INITCAP (g.iss_name),
                     INITCAP (e.line_name),
                     INITCAP (f.subline_name),
                     b.policy_no)
      LOOP
         v_gipir928g.iss_name := rec.iss_name;
         v_gipir928g.line := rec.line_name;
         v_gipir928g.subline := rec.subline_name;
         v_gipir928g.policy_no := rec.policy_no2;
         v_gipir928g.peril_sname := rec.peril_sname;
         v_gipir928g.nr_tsi := rec.nr_tsi;
         v_gipir928g.nr_prem := rec.nr_prem;
         v_gipir928g.tr_tsi := rec.tr_tsi;
         v_gipir928g.tr_prem := rec.tr_prem;
         v_gipir928g.fa_tsi := rec.fa_tsi;
         v_gipir928g.fa_prem := rec.fa_prem;
         v_gipir928g.total_tsi := rec.tsi_amt;
         v_gipir928g.total_prem := rec.prem_amt;

         PIPE ROW (v_gipir928g);
      END LOOP;

      RETURN;
   END;

   --------------------------------- 33---------------------------------
   --Alvin Tumlos May 31, 2010-----
   -- 7.1.2010 changed the datatype of p_ctpl_pol from varchar2 to number
   FUNCTION CSV_EDST (p_SCOPE           edst_param.SCOPE%TYPE,
                      p_from_date       edst_param.FROM_DATE%TYPE,
                      p_TO_DATE         edst_EXT.TO_DATE1%TYPE,
                      p_negative_amt    VARCHAR2,
                      p_ctpl_pol        NUMBER,
                      p_inc_spo         VARCHAR2,
                      p_user            edst_param.user_id%TYPE,
                      p_line_cd         VARCHAR2,
                      p_subline_cd      VARCHAR2,
                      p_iss_cd          VARCHAR2,
                      p_iss_param       NUMBER)
      RETURN EDST_type
      PIPELINED
   IS
      v_EDST   EDST_rec_type;
   --v_no_tin_reason giis_parameters.param_value_v%TYPE;
   BEGIN
      -- vin 7.8.2010 commented-out since these lines are no longer of any use
      /*SELECT param_value_v
        INTO v_no_tin_reason
        FROM giis_parameters
      WHERE param_name = 'DEFAULT_NO_TIN_REASON';*/

      FOR rec
      IN (  SELECT   gs.assd_no AS assd_no,
                     NVL (gs.assd_tin, ' ') AS tin,
                     gp.iss_cd AS branch,
                     DECODE (NVL (gs.assd_tin, 'X'), 'X', 'X', ' ') AS "NO_TIN",
                     giis.branch_tin_cd AS branch_tin_cd,
                     --vin 7.2.2010 added branch_tin_cd
                     gs.no_tin_reason AS reason,
                     DECODE (gs.corporate_tag,
                             'C', gs.assd_name,
                             'J', gs.assd_name,
                             NULL)
                        AS company,
                     DECODE (gs.corporate_tag, 'I', gs.first_name)
                        AS first_name,
                     DECODE (gs.corporate_tag, 'I', gs.middle_initial)
                        AS middle_initial,
                     DECODE (gs.corporate_tag, 'I', gs.last_name) AS last_name,
                     gpb.line_cd AS line_cd,      --added line_cd vin 7.1.2010
                     SUM (gu.total_prem) tax_base,
                     --sum of prem per assured rose
                     SUM (gu.total_tsi) tsi_amt          --vin added 7.14.2010
              FROM   edst_ext gp,
                     giis_assured gs,
                     gipi_polbasic gpb,
                     giis_issource giis,                        --vin 7.2.2010
                     giis_line gl,                           --Dean 05.28.2012
                     (SELECT   assd_no,
                               policy_id,
                               total_Prem,
                               total_tsi                --vin added 07.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND acct_ent_date BETWEEN p_FROM_date
                                                     AND  p_TO_DATE
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol = 3
                                      AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN
                                                 ('1', '2', 'X', '5', '4'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X', '5')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X')
                                        AND total_prem > 0)
                                    -- vin added 7.8.2010
                                    OR (    p_scope = 2
                                        AND total_prem < 0
                                        AND p_ctpl_pol = 3))
                      UNION ALL
                      SELECT   assd_no,
                               policy_id,
                               (DECODE (pol_flag,
                                        '5', (total_Prem * -1),
                                        total_prem))
                                  total_prem,
                               (DECODE (pol_flag,
                                        '5', (total_tsi * -1),
                                        total_tsi))
                                  total_tsi             --vin added 07.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND spld_acct_ent_date BETWEEN p_FROM_date
                                                          AND  p_TO_DATE
                               AND ( (    p_scope = 1
                                      AND p_negative_amt = 'Y'
                                      AND p_inc_spo = 'Y'
                                      AND p_ctpl_pol = 3
                                      AND pol_flag IN ('1', '2', 'X', '4', '5'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem < 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 3
                                        AND pol_flag = '5'))
                      UNION ALL                                    --WITH CTPL
                      SELECT   assd_no,
                               policy_id,
                               total_Prem,
                               total_tsi                 --vin added 7.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND acct_ent_date BETWEEN p_FROM_date
                                                     AND  p_TO_DATE
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol IN (1, 2)
                                      AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN
                                                 ('1', '2', 'X', '5', '4'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X', '5')
                                        AND total_prem > 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X')
                                        AND total_prem > 0)
                                    -- vin added 7.8.2010
                                    OR (    p_scope = 2
                                        AND p_ctpl_pol IN (1, 2)
                                        AND total_prem < 0))
                      UNION ALL
                      SELECT   assd_no,
                               policy_id,
                               (DECODE (pol_flag,
                                        '5', (total_Prem * -1),
                                        total_prem))
                                  total_prem,
                               (DECODE (pol_flag,
                                        '5', (total_tsi * -1),
                                        total_tsi))
                                  total_tsi             --vin added 07.14.2010
                        FROM   edst_ext
                       WHERE       1 = 1
                               AND user_id = p_user
                               AND line_cd = NVL (p_line_cd, line_cd)
                               AND subline_cd = NVL (p_subline_cd, subline_cd)
                               AND iss_cd = NVL (p_iss_cd, iss_cd)
                               AND DECODE (p_iss_param, 1, cred_branch, iss_cd) =
                                     NVL (
                                        p_iss_cd,
                                        DECODE (p_iss_param,
                                                1, cred_branch,
                                                iss_cd)
                                     )
                               AND DECODE (iss_cd, 'BB', 0, 'RI', 0, 1) = 1
                               AND spld_acct_ent_date BETWEEN p_FROM_date
                                                          AND  p_TO_DATE
                               AND ( (    p_scope = 1
                                      AND p_negative_amt = 'Y'
                                      AND p_inc_spo = 'Y'
                                      AND p_ctpl_pol IN (1, 2)
                                      AND pol_flag IN ('1', '2', 'X', '5', '4'))
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag IN ('1', '2', 'X', '4')
                                        AND total_prem < 0)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol IN (1, 2)
                                        AND pol_flag = '5'))
                      UNION ALL
                      --this is now for policy level CTPL policies vin 7.1.2010
                      SELECT   assd_no,
                               policy_id,
                               prem_amt * -1 AS total_prem,
                               tsi_amt * -1 AS tsi_amt
                        --vin added 7.14.2010 to match the number of columns
                        FROM   mc_pol_ext
                       WHERE   1 = 1 AND user_id = p_user
                               AND acct_ent_date BETWEEN p_from_date
                                                     AND  p_to_date
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol = 1
                                      AND   /*prem_amt>0 AND ctpl_prem_amt>0*/
                                         ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.26.2010
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.23.2010 commented out and replaced with the statement after it
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- since we will only get/compute those MC policies that have CTPL premiums
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 1
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- vin added 7.8.2010
                                    OR (p_scope = 2 AND p_ctpl_pol = 1 /*AND prem_amt<0 */
                                                                      AND ctpl_prem_amt < 0)) -- vin 7.26.2010 commented out
                      UNION ALL
                      --vin 7.1.2010 added these for peril level CTPL policies
                      SELECT   assd_no,
                               policy_id,
                               ctpl_prem_amt * -1 AS total_prem,
                               ctpl_tsi_amt * -1 AS tsi_amt
                        --vin added 7.14.2010 to match the number of columns
                        FROM   mc_pol_ext
                       WHERE   1 = 1 AND user_id = p_user
                               AND acct_ent_date BETWEEN p_from_date
                                                     AND  p_to_date
                               AND ( (    p_scope = 1
                                      AND p_ctpl_pol = 2
                                      AND   /*prem_amt>0 AND ctpl_prem_amt>0*/
                                         ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.26.2010
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    -- vin 7.23.2010 commented out
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'Y'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'Y'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL)
                                    OR (    p_scope = 1
                                        AND p_negative_amt = 'N'
                                        AND p_inc_spo = 'N'
                                        AND p_ctpl_pol = 2
                                        AND /*prem_amt>0 AND ctpl_prem_amt>0*/
                                           ctpl_prem_amt IS NOT NULL) -- vin added 7.8.2010
                                                                     --OR  (p_scope=2 AND p_ctpl_pol = 2 /*AND prem_amt<0 */ AND ctpl_prem_amt<0) -- JHING 08/10/2011 commented out since this cause incorrect amounts in the retrieval of negative amounts
                                  )) gu         -- vin 7.26.2010 commented out
             WHERE       gp.user_id = p_USER
                     AND gpb.line_cd = gl.line_cd            --Dean 05.08.2012
                     AND gp.assd_no = gs.assd_no
                     AND gpb.policy_id = gp.policy_id
                     AND gp.assd_no = gu.assd_no
                     AND gp.policy_id = gu.policy_id
                     AND giis.iss_cd = gp.iss_cd
                     AND gpb.line_cd = NVL (p_line_cd, gpb.line_cd)
          --Dean 05.28.2012
          --AND tax_base <> 0
          /*added by rose in order to group the assd*/
          GROUP BY   gs.assd_no,
                     DECODE (gl.menu_line_cd, 'AC', gpb.policy_id),
                     --Dean 05.28.2012
                     DECODE (gpb.line_cd, 'AC', gpb.policy_id),
                     --Dean 05.28.2012
                     gpb.line_cd,
                     gs.assd_tin,
                     gp.iss_cd,
                     giis.branch_tin_cd,
                     gs.assd_name,
                     gs.no_tin_reason,
                     gs.last_name,
                     gs.first_name,
                     gs.middle_initial,
                     gs.corporate_tag                                      --,
            --gp.total_tsi
            HAVING   SUM (gu.total_prem) <> SUM (gu.total_tsi)
          -- Jayson 08.03.2010
          --ORDER BY  gs.assd_no, gpb.line_cd) LOOP                      -- vin commented out 7.8.2010 and replaced by the line below
          ORDER BY   gs.corporate_tag DESC,
                     gpb.line_cd,
                     gs.assd_tin,
                     gp.iss_cd,
                     giis.branch_tin_cd,
                     gs.assd_name)
      LOOP
         v_EDST.LINE_CD := rec.LINE_CD;
         v_EDST.TIN := rec.TIN;
         v_EDST.BRANCH := rec.BRANCH;
         v_EDST.BRANCH_TIN_CD := rec.BRANCH_TIN_CD;
         v_EDST.NO_TIN := rec.NO_TIN;
         v_EDST.REASON := rec.REASON;
         v_EDST.COMPANY := rec.COMPANY;
         v_EDST.FIRST_NAME := rec.FIRST_NAME;
         V_EDST.LAST_NAME := rec.LAST_NAME;
         v_EDST.MIDDLE_NAME := rec.MIDDLE_INITIAL;
         v_EDST.TAX_BASE := rec.TAX_BASE;
         v_EDST.TSI_AMT := rec.TSI_AMT;

         PIPE ROW (v_EDST);
      END LOOP;

      RETURN;
   END;

   /* ------------------------------------------- START --------------------------------------------------
      Modified by Jhing 12.05.2012 ; added codes from 2010 enh on print to screen (Ms. Bhev's modification ) */


   -------------------- UW >> Reports Printing >> General Statistical Reports ------------------------
   /* ** input date should be in MM-DD-YYYY format ** */
   -------------------------------------------- 34 ---------------------------------------------------
   FUNCTION csv_gipir949 (p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_line_cd          VARCHAR2,
                          p_subline_cd       VARCHAR2,
                          p_all_line_tag     VARCHAR2,
                          p_param_date       VARCHAR2,
                          p_by_tarf          VARCHAR2,
                          p_user             VARCHAR2)
      RETURN gipir949_type
      PIPELINED
   IS
      v_gipir949   gipir949_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   line_cd,
                     subline_cd,
                     tarf_cd,
                     range_from,
                     range_to,
                        line_cd
                     || '-'
                     || subline_cd
                     || '-'
                     || iss_cd
                     || '-'
                     || LPAD (issue_yy, 2, '0')
                     || '-'
                     || LPAD (pol_seq_no, 7, '0')
                     || '-'
                     || LPAD (renew_no, 2, '0')
                        policy_no,
                     SUM (NVL (ann_tsi_amt, 0)) tsi_amt,
                     SUM (NVL (net_retention, 0)) net_ret,
                     SUM (NVL (quota_share, 0)) quota_shr,
                     SUM (NVL (treaty_prem, 0)) treaty,
                     SUM (NVL (facultative, 0)) facul
              FROM   gipi_risk_profile_dtl
             WHERE   user_id = p_user
                     AND all_line_tag = NVL (p_all_line_tag, 'Y')
                     AND TRUNC (date_from) =
                           TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
                     AND TRUNC (date_to) =
                           TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
                     AND line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
          GROUP BY   line_cd,
                     subline_cd,
                     iss_cd,
                     issue_yy,
                     pol_seq_no,
                     renew_no,
                     tarf_cd,
                     range_from,
                     range_to
          ORDER BY   range_from)
      LOOP
         -- LINE NAME
         SELECT   line_cd || ' - ' || line_name
           INTO   v_gipir949.line_name
           FROM   giis_line
          WHERE   line_cd = rec.line_cd AND ROWNUM = 1;

         -- SUBLINE_NAME
         SELECT   subline_cd || ' - ' || subline_name
           INTO   v_gipir949.subline_name
           FROM   giis_subline
          WHERE       line_cd = rec.line_cd
                  AND subline_cd = rec.subline_cd
                  AND ROWNUM = 1;

         -- Tariff Description:
         IF rec.tarf_cd IS NOT NULL
         THEN
            SELECT   rv_meaning
              INTO   v_gipir949.tariff
              FROM   cg_ref_codes
             WHERE       rv_low_value = rec.tarf_cd
                     AND rv_domain = 'GIIS_TARIFF.TARF_CD'
                     AND ROWNUM = 1;
         ELSE
            v_gipir949.tariff := NULL;
         END IF;

         -- Period
         v_gipir949.period := p_starting_date || ' TO ' || p_ending_date;
         v_gipir949.tsi_range :=
            TRIM (rec.range_from) || ' - ' || TRIM (rec.range_to);
         v_gipir949.policy_no := rec.policy_no;
         v_gipir949.tsi_amount := rec.tsi_amt;
         v_gipir949.net_retention := rec.net_ret;
         v_gipir949.quota_share := rec.quota_shr;
         v_gipir949.treaty := rec.treaty;
         v_gipir949.facultative := rec.facul;
         -- Total
         v_gipir949.total :=
              NVL (rec.net_ret, 0)
            + NVL (rec.quota_shr, 0)
            + NVL (rec.treaty, 0)
            + NVL (rec.facul, 0);
         PIPE ROW (v_gipir949);
      END LOOP;

      RETURN;
   END;                                                        -- CSV_GIPIR949

   -------------------------------------------- 35 ---------------------------------------------------
   FUNCTION csv_gipir949b (p_starting_date    VARCHAR2,
                           p_ending_date      VARCHAR2,
                           p_line_cd          VARCHAR2,
                           p_subline_cd       VARCHAR2,
                           p_all_line_tag     VARCHAR2,
                           p_param_date       VARCHAR2,
                           p_by_tarf          VARCHAR2,
                           p_user             VARCHAR2)
      RETURN gipir949b_type
      PIPELINED
   IS
      v_gipir949b   gipir949b_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT      LTRIM (TO_CHAR (a.range_from, '999,999,999,999,999'))
                     || ' - '
                     || LTRIM (TO_CHAR (a.range_to, '999,999,999,999,999'))
                        RANGE,
                     d.pol,
                     c.item_no,
                     c.tsi_amt,
                     c.prem_amt,
                     d.net_tsi,
                     d.net_prem,
                     d.treaty_tsi,
                     d.treaty_prem,
                     d.facul_tsi,
                     d.facul_prem
              FROM   gipi_risk_profile_item a,
                     (  SELECT      b.line_cd
                                 || '-'
                                 || b.subline_cd
                                 || '-'
                                 || b.iss_cd
                                 || '-'
                                 || b.issue_yy
                                 || '-'
                                 || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.renew_no, '09'))
                                    pol,
                                 a.item_no,
                                 SUM (a.tsi_amt) tsi_amt,
                                 SUM (a.prem_amt) prem_amt
                          FROM   gipi_polbasic b, gipi_item a
                         WHERE   a.policy_id = b.policy_id
                                 AND a.policy_id IN
                                          (SELECT   policy_id
                                             FROM   gipi_polrisk_item_ext)
                      GROUP BY      b.line_cd
                                 || '-'
                                 || b.subline_cd
                                 || '-'
                                 || b.iss_cd
                                 || '-'
                                 || b.issue_yy
                                 || '-'
                                 || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.renew_no, '09')),
                                 a.item_no) c,
                     (  SELECT   b.line_cd,
                                 b.subline_cd,
                                    b.line_cd
                                 || '-'
                                 || b.subline_cd
                                 || '-'
                                 || b.iss_cd
                                 || '-'
                                 || b.issue_yy
                                 || '-'
                                 || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.renew_no, '09'))
                                    pol,
                                 b.item_no,
                                 SUM (NVL (netret.dist_tsi, 0)) net_tsi,
                                 SUM (NVL (netret.dist_prem, 0)) net_prem,
                                 SUM (NVL (treaty.dist_tsi, 0)) treaty_tsi,
                                 SUM (NVL (treaty.dist_prem, 0)) treaty_prem,
                                 SUM (NVL (facul.dist_tsi, 0)) facul_tsi,
                                 SUM (NVL (facul.dist_prem, 0)) facul_prem
                          FROM   (SELECT   dist_no,
                                           item_no,
                                           line_cd,
                                           dist_tsi,
                                           dist_prem
                                    FROM   giuw_itemds_dtl
                                   WHERE   share_cd = 1) netret,
                                 (SELECT   dist_no,
                                           item_no,
                                           line_cd,
                                           dist_tsi,
                                           dist_prem
                                    FROM   giuw_itemds_dtl
                                   WHERE   share_cd NOT IN (1, 999)) treaty,
                                 (SELECT   dist_no,
                                           item_no,
                                           line_cd,
                                           dist_tsi,
                                           dist_prem
                                    FROM   giuw_itemds_dtl
                                   WHERE   share_cd = 999) facul,
                                 gipi_polrisk_item_ext b
                         WHERE       netret.dist_no = b.dist_no
                                 AND netret.item_no = b.item_no
                                 AND netret.line_cd = b.line_cd
                                 AND netret.dist_no = facul.dist_no(+)
                                 AND netret.item_no = facul.item_no(+)
                                 AND netret.line_cd = facul.line_cd(+)
                                 AND netret.item_no = treaty.item_no(+)
                                 AND netret.dist_no = treaty.dist_no(+)
                                 AND netret.line_cd = treaty.line_cd(+)
                                 AND b.user_id = UPPER (p_user)
                      GROUP BY   b.line_cd,
                                 b.subline_cd,
                                    b.line_cd
                                 || '-'
                                 || b.subline_cd
                                 || '-'
                                 || b.iss_cd
                                 || '-'
                                 || b.issue_yy
                                 || '-'
                                 || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                                 || '-'
                                 || LTRIM (TO_CHAR (b.renew_no, '09')),
                                 b.item_no) d
             WHERE   a.line_cd = NVL (p_line_cd, a.line_cd)
                     AND DECODE (p_subline_cd, NULL, 'x', a.subline_cd) =
                           NVL (p_subline_cd, 'x')
                     --NVL(a.subline_cd,'***') = NVL(p_subline_cd,'***')
                     AND a.user_id = UPPER (p_user)
                     AND TRUNC (a.date_from) =
                           TO_DATE (p_starting_date, 'MM-DD-YYYY')
                     AND TRUNC (a.date_to) =
                           TO_DATE (p_ending_date, 'MM-DD-YYYY')
                     AND a.all_line_tag = p_all_line_tag
                     AND d.line_cd = a.line_cd
                     AND d.subline_cd = NVL (a.subline_cd, d.subline_cd)
                     AND c.pol = d.pol
                     AND c.item_no = d.item_no
                     AND c.tsi_amt BETWEEN a.range_from AND a.range_to
          ORDER BY   a.range_from, d.pol, c.item_no)
      LOOP
         -- line name
         SELECT   line_cd || ' - ' || line_name
           INTO   v_gipir949b.line_name
           FROM   giis_line
          WHERE   line_cd = p_line_cd AND ROWNUM = 1;

         --
         v_gipir949b.tsi_range := rec.RANGE;
         v_gipir949b.date_range := p_starting_date || ' TO ' || p_ending_date;
         v_gipir949b.policy_no := rec.pol;

           -- item
           SELECT   item_no || ' ' || item_title
             INTO   v_gipir949b.item
             FROM   gipi_item a, gipi_polbasic b
            WHERE   a.policy_id = b.policy_id
                    AND   b.line_cd
                       || '-'
                       || b.subline_cd
                       || '-'
                       || b.iss_cd
                       || '-'
                       || b.issue_yy
                       || '-'
                       || LTRIM (TO_CHAR (b.pol_seq_no, '0000009'))
                       || '-'
                       || LTRIM (TO_CHAR (b.renew_no, '09')) = rec.pol
                    AND (a.policy_id, a.item_no) IN
                             (  SELECT   MAX (b.policy_id), b.item_no
                                  FROM   gipi_polrisk_item_ext b
                                 WHERE   line_cd = NVL (p_line_cd, line_cd)
                              GROUP BY      b.line_cd
                                         || '-'
                                         || b.subline_cd
                                         || '-'
                                         || b.iss_cd
                                         || '-'
                                         || b.issue_yy
                                         || '-'
                                         || LTRIM(TO_CHAR (b.pol_seq_no,
                                                           '0000009'))
                                         || '-'
                                         || LTRIM (TO_CHAR (b.renew_no, '09')),
                                         b.item_no)
                    AND a.item_no = rec.item_no
                    AND ROWNUM = 1
         ORDER BY   b.endt_seq_no DESC;

         --
         v_gipir949b.sum_insured := rec.tsi_amt;
         v_gipir949b.premium_amt := rec.prem_amt;
         v_gipir949b.net_sum_insured := rec.net_tsi;
         v_gipir949b.net_prem_amt := rec.net_prem;
         v_gipir949b.treaty_tsi := rec.treaty_tsi;
         v_gipir949b.treaty_prem_amt := rec.treaty_prem;
         v_gipir949b.facul_tsi := rec.facul_tsi;
         v_gipir949b.facul_prem_amt := rec.facul_prem;
         PIPE ROW (v_gipir949b);
      END LOOP;

      RETURN;
   END;                                                       -- CSV_GIPIR949B

   -------------------------------------------- 36 ---------------------------------------------------
   FUNCTION csv_gipir949c (p_starting_date    VARCHAR2,
                           p_ending_date      VARCHAR2,
                           p_line_cd          VARCHAR2,
                           p_subline_cd       VARCHAR2,
                           p_all_line_tag     VARCHAR2,
                           p_param_date       VARCHAR2,
                           p_by_tarf          VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir949c_type
      PIPELINED
   IS
      v_gipir949c   gipir949c_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   b.ranges,
                     a.block_risk,
                     b.range_from,
                     SUM (a.sum_insured) sum_insured,
                     SUM (a.prem_amt) prem_amt,
                     SUM (a.risk_count) risk_count
              FROM   (  SELECT   a1.line_cd,
                                 a1.subline_cd,
                                 a1.iss_cd,
                                 a1.issue_yy,
                                 a1.pol_seq_no,
                                 a1.renew_no,
                                 (DECODE (NVL (a1.risk_cd, '*'),
                                          '*', a3.block_desc,
                                             (SELECT   risk_desc
                                                FROM   giis_risks
                                               WHERE   risk_cd = a1.risk_cd)
                                          || ' / '
                                          || a3.block_desc))
                                    block_risk,
                                 SUM (a1.ann_tsi_amt) sum_insured,
                                 SUM (a2.prem_amt) prem_amt,
                                 COUNT (a1.ann_tsi_amt) risk_count
                          FROM   gipi_polrisk_item_ext a1,
                                 gipi_item a2,
                                 giis_block a3
                         WHERE       a1.policy_id = a2.policy_id
                                 AND a1.item_no = a2.item_no
                                 AND a1.line_cd = giisp.v ('LINE_CODE_FI')
                                 --'FI'
                                 AND a1.block_id = a3.block_id
                                 AND a1.user_id = p_user_id
                      GROUP BY   a1.line_cd,
                                 a1.subline_cd,
                                 a1.iss_cd,
                                 a1.issue_yy,
                                 a1.pol_seq_no,
                                 a1.renew_no,
                                 a1.risk_cd,
                                 block_desc
                      ORDER BY   block_risk, sum_insured) a,
                     (  SELECT   LTRIM (
                                    TO_CHAR (x.range_from, '999,999,999,999,999')
                                 )
                                 || ' - '
                                 || LTRIM(DECODE (
                                             (LTRIM(TO_CHAR (
                                                       x.range_to,
                                                       '999,999,999,999,999'
                                                    ))),
                                             '100,000,000,000,000',
                                             'OVER',
                                             (TO_CHAR (x.range_to,
                                                       '999,999,999,999,999'))
                                          ))
                                    AS "RANGES",
                                 x.range_from,
                                 x.range_to,
                                 x.line_cd,
                                 x.subline_cd,
                                 x.date_from,
                                 x.date_to
                          FROM   gipi_risk_profile_item x
                         WHERE   1 = 1 AND x.line_cd = giisp.v ('LINE_CODE_FI') --'FI'
                                 AND (TRUNC (x.date_from) =
                                         TRUNC(TO_DATE (p_starting_date,
                                                        'MM-DD-YYYY'))
                                      AND TRUNC (x.date_to) =
                                            TRUNC(TO_DATE (p_ending_date,
                                                           'MM-DD-YYYY')))
                      GROUP BY   x.range_from,
                                 x.range_to,
                                 x.line_cd,
                                 x.subline_cd,
                                 x.date_from,
                                 x.date_to) b
             WHERE   (a.sum_insured(+)) BETWEEN b.range_from AND b.range_to
                     AND TRUNC (b.date_from) =
                           TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
                     AND TRUNC (b.date_to) =
                           TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
          GROUP BY   b.ranges, a.block_risk, b.range_from
          ORDER BY   b.range_from, a.block_risk ASC)
      LOOP
         v_gipir949c.period := p_starting_date || ' TO ' || p_ending_date;
         v_gipir949c.ranges := rec.ranges;
         v_gipir949c.block_risk := rec.block_risk;
         v_gipir949c.risk_cnt := rec.risk_count;
         v_gipir949c.sum_insured := rec.sum_insured;
         v_gipir949c.prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir949c);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 37 ---------------------------------------------------
   FUNCTION csv_gipir940 (p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_line_cd          VARCHAR2,
                          p_subline_cd       VARCHAR2,
                          p_all_line_tag     VARCHAR2,
                          p_param_date       VARCHAR2,
                          p_by_tarf          VARCHAR2,
                          p_user             VARCHAR2)
      RETURN gipir940_type
      PIPELINED
   IS
      v_gipir940   gipir940_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   tarf_cd,
                     line_cd,
                     TO_CHAR (range_from, '99,999,999,999,999.99') range_from,
                     TO_CHAR (range_to, '99,999,999,999,999.99') range_to,
                     policy_count,
                     net_retention + sec_net_retention_prem net_retention,
                     quota_share,
                       NVL (treaty, 0)
                     + NVL (treaty2_prem, 0)
                     + NVL (treaty3_prem, 0)
                     + NVL (treaty4_prem, 0)
                     + NVL (treaty5_prem, 0)
                     + NVL (treaty6_prem, 0)
                     + NVL (treaty7_prem, 0)
                     + NVL (treaty8_prem, 0)
                     + NVL (treaty9_prem, 0)
                     + NVL (treaty10_prem, 0)
                        treaty,
                     facultative
              FROM   gipi_risk_profile
             WHERE   line_cd = NVL (p_line_cd, line_cd)
                     AND TRUNC (date_from) =
                           TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
                     AND TRUNC (date_to) =
                           TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
                     AND user_id = p_user
                     AND all_line_tag = 'Y'
                     AND subline_cd IS NULL
                     AND (NVL (p_by_tarf, 'N') <> 'Y'
                          OR (NVL (p_by_tarf, 'N') = 'Y'
                              AND tarf_cd IS NOT NULL))
          ORDER BY   tarf_cd, line_cd, range_to ASC)
      LOOP
         -- Period
         v_gipir940.period := p_starting_date || ' TO ' || p_ending_date;

         -- tariff description
         IF rec.tarf_cd IS NOT NULL
         THEN
            SELECT   rv_meaning
              INTO   v_gipir940.tariff_desc
              FROM   cg_ref_codes
             WHERE       rv_low_value = rec.tarf_cd
                     AND rv_domain = 'GIIS_TARIFF.TARF_CD'
                     AND ROWNUM = 1;
         ELSE
            v_gipir940.tariff_desc := NULL;
         END IF;

         -- line
         SELECT   line_cd || ' - ' || line_name
           INTO   v_gipir940.line_name
           FROM   giis_line
          WHERE   line_cd = p_line_cd AND ROWNUM = 1;

         --
         v_gipir940.tsi_range :=
            TRIM (rec.range_from) || ' - ' || TRIM (rec.range_to);
         v_gipir940.policy_count := rec.policy_count;
         v_gipir940.net_retention := rec.net_retention;
         v_gipir940.quota_share := rec.quota_share;
         v_gipir940.treaty := rec.treaty;
         v_gipir940.facultative := rec.facultative;
         -- Total
         v_gipir940.total :=
              NVL (rec.net_retention, 0)
            + NVL (rec.quota_share, 0)
            + NVL (rec.treaty, 0)
            + NVL (rec.facultative, 0);
         PIPE ROW (v_gipir940);
      END LOOP;

      RETURN;
   END;                                                        -- CSV_GIPIR940

   -------------------------------------------- 38 ---------------------------------------------------
   FUNCTION csv_gipir934 (p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_line_cd          VARCHAR2,
                          p_subline_cd       VARCHAR2,
                          p_all_line_tag     VARCHAR2,
                          p_param_date       VARCHAR2,
                          p_by_tarf          VARCHAR2,
                          p_user             VARCHAR2)
      RETURN gipir934_type
      PIPELINED
   IS
      v_gipir934   gipir934_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   a.line_cd,
                     (SELECT   subline_cd || ' - ' || subline_name
                        FROM   giis_subline
                       WHERE   line_cd = a.line_cd
                               AND subline_cd = a.subline_cd)
                        subline_name,
                     range_from,
                     range_to,
                     policy_count,
                     (SELECT   rv_meaning
                        FROM   cg_ref_codes
                       WHERE   rv_low_value = tarf_cd
                               AND rv_domain = 'GIIS_TARIFF.TARF_CD')
                        tariff_desc,
                     b.peril_cd,
                     b.peril_name,
                     peril_tsi,
                     peril_prem,
                     b.peril_type
              FROM   gipi_risk_profile a, giis_peril b
             WHERE       a.line_cd = b.line_cd
                     AND a.peril_cd = b.peril_cd
                     AND a.line_cd = p_line_cd
                     AND NVL (a.subline_cd, 'xx') =
                           NVL (p_subline_cd, NVL (a.subline_cd, 'xx'))
                     AND TRUNC (date_from) =
                           TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
                     AND TRUNC (date_to) =
                           TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
                     AND a.user_id = p_user
                     AND all_line_tag = 'P'
                     AND policy_count != 0
          ORDER BY   a.line_cd,
                     tarf_cd,
                     peril_cd,
                     range_from)
      LOOP
         -- Period
         v_gipir934.period := p_starting_date || ' TO ' || p_ending_date;

         -- Line Name
         SELECT   line_name
           INTO   v_gipir934.line_name
           FROM   giis_line
          WHERE   line_cd = rec.line_cd;

         --
         v_gipir934.subline_name := rec.subline_name;
         v_gipir934.tariff_desc := rec.tariff_desc;
         v_gipir934.tsi_range :=
            TRIM (rec.range_from) || ' TO ' || TRIM (rec.range_to);
         v_gipir934.peril_name := rec.peril_name;
         v_gipir934.policy_count := rec.policy_count;
         v_gipir934.sum_insured := rec.peril_tsi;
         v_gipir934.premium := rec.peril_prem;
         PIPE ROW (v_gipir934);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 39 ---------------------------------------------------
   FUNCTION csv_gipir941 (p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_line_cd          VARCHAR2,
                          p_subline_cd       VARCHAR2,
                          p_all_line_tag     VARCHAR2,
                          p_param_date       VARCHAR2,
                          p_by_tarf          VARCHAR2,
                          p_user             VARCHAR2)
      RETURN gipir941_type
      PIPELINED
   IS
      v_gipir941   gipir941_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   tarf_cd,
                     line_cd,
                     subline_cd,
                     range_from,
                     range_to,
                     policy_count,
                     net_retention,
                     quota_share,
                     facultative,
                       NVL (treaty, 0)
                     + NVL (treaty2_prem, 0)
                     + NVL (treaty3_prem, 0)
                     + NVL (treaty4_prem, 0)
                     + NVL (treaty5_prem, 0)
                     + NVL (treaty6_prem, 0)
                     + NVL (treaty7_prem, 0)
                     + NVL (treaty8_prem, 0)
                     + NVL (treaty9_prem, 0)
                     + NVL (treaty10_prem, 0)
                        treaty
              FROM   gipi_risk_profile
             WHERE   line_cd = NVL (p_line_cd, line_cd)
                     AND DECODE (p_subline_cd, NULL, 'x', subline_cd) =
                           NVL (p_subline_cd, 'x')
                     -- to make sure that all subline_cds will be retrieve if p_subline_cd is null
                     AND TRUNC (date_from) =
                           TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
                     AND TRUNC (date_to) =
                           TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
                     AND user_id = p_user
                     AND (NVL (p_by_tarf, 'N') <> 'Y'
                          OR (NVL (p_by_tarf, 'N') = 'Y'
                              AND tarf_cd IS NOT NULL))
          ORDER BY   line_cd, subline_cd, range_from)
      LOOP
         -- Period
         v_gipir941.period := p_starting_date || ' TO ' || p_ending_date;

         -- Line Name
         SELECT   line_cd || ' - ' || line_name
           INTO   v_gipir941.line_name
           FROM   giis_line
          WHERE   line_cd = rec.line_cd;

         -- Subline Name
         IF rec.subline_cd IS NOT NULL
         THEN
            SELECT   subline_cd || ' - ' || subline_name
              INTO   v_gipir941.subline_name
              FROM   giis_subline
             WHERE   line_cd = rec.line_cd AND subline_cd = rec.subline_cd;
         ELSE
            v_gipir941.subline_name := NULL;
         END IF;

         -- Tariff Description
         IF rec.tarf_cd IS NOT NULL
         THEN
            SELECT   rv_meaning
              INTO   v_gipir941.tariff_desc
              FROM   cg_ref_codes
             WHERE       rv_low_value = rec.tarf_cd
                     AND rv_domain = 'GIIS_TARIFF.TARF_CD'
                     AND ROWNUM = 1;
         ELSE
            v_gipir941.tariff_desc := NULL;
         END IF;

         -- TSI Range
         v_gipir941.tsi_range_from := rec.range_from;
         v_gipir941.tsi_range_to := rec.range_to;
         -- Policy Count
         v_gipir941.policy_count := rec.policy_count;
         --
         v_gipir941.net_retention := rec.net_retention;
         v_gipir941.quota_share := rec.quota_share;
         v_gipir941.treaty := rec.treaty;
         v_gipir941.facultative := rec.facultative;
         PIPE ROW (v_gipir941);
      END LOOP;

      RETURN;
   END;                                                        -- CSV_GIPIR941

   -------------------------------------------- 40 ---------------------------------------------------
   FUNCTION csv_gipir947b (p_starting_date    VARCHAR2,
                           p_ending_date      VARCHAR2,
                           p_line_cd          VARCHAR2,
                           p_subline_cd       VARCHAR2,
                           p_all_line_tag     VARCHAR2,
                           p_param_date       VARCHAR2,
                           p_by_tarf          VARCHAR2,
                           p_user             VARCHAR2)
      RETURN gipir947b_type
      PIPELINED
   IS
      v_gipir947b   gipir947b_rec_type;
   BEGIN
      FOR rec
      IN (  SELECT   tarf_cd,
                     (SELECT   rv_meaning
                        FROM   cg_ref_codes
                       WHERE       rv_low_value = tarf_cd
                               AND rv_domain = 'GIIS_TARIFF.TARF_CD'
                               AND ROWNUM = 1)
                        tariff_desc,
                     line_cd,
                     TO_CHAR (range_from, '99,999,999,999,999.99') range_from,
                     TO_CHAR (range_to, '99,999,999,999,999.99') range_to,
                     policy_count,
                     NVL (net_retention, 0) net_ret,
                     NVL (net_retention_tsi, 0) net_ret_tsi,
                     NVL (sec_net_retention_tsi, 0) sec_net_ret_tsi,
                     NVL (sec_net_retention_prem, 0) sec_net_ret_prem,
                     NVL (quota_share, 0) quota_share,
                     NVL (quota_share_tsi, 0) quota_share_tsi,
                     NVL (facultative, 0) facul,
                     NVL (facultative_tsi, 0) facul_tsi,
                     NVL (treaty, 0) treaty_prem,
                     NVL (treaty_tsi, 0) treaty_tsi,
                     NVL (treaty2_prem, 0) treaty2_prem,
                     NVL (treaty2_tsi, 0) treaty2_tsi,
                     NVL (treaty3_prem, 0) treaty3_prem,
                     NVL (treaty3_tsi, 0) treaty3_tsi,
                     NVL (treaty4_prem, 0) treaty4_prem,
                     NVL (treaty4_tsi, 0) treaty4_tsi,
                     NVL (treaty5_prem, 0) treaty5_prem,
                     NVL (treaty5_tsi, 0) treaty5_tsi,
                     NVL (treaty6_prem, 0) treaty6_prem,
                     NVL (treaty6_tsi, 0) treaty6_tsi,
                     NVL (treaty7_prem, 0) treaty7_prem,
                     NVL (treaty7_tsi, 0) treaty7_tsi,
                     NVL (treaty8_prem, 0) treaty8_prem,
                     NVL (treaty8_tsi, 0) treaty8_tsi,
                     NVL (treaty9_prem, 0) treaty9_prem,
                     NVL (treaty9_tsi, 0) treaty9_tsi,
                     NVL (treaty10_prem, 0) treaty10_prem,
                     NVL (treaty10_tsi, 0) treaty10_tsi
              FROM   gipi_risk_profile
             WHERE   line_cd = NVL (p_line_cd, line_cd)
                     AND TRUNC (date_from) =
                           TRUNC (TO_DATE (p_starting_date, 'MM-DD-YYYY'))
                     AND TRUNC (date_to) =
                           TRUNC (TO_DATE (p_ending_date, 'MM-DD-YYYY'))
                     AND user_id = p_user
                     AND DECODE (p_subline_cd, NULL, 'x', subline_cd) =
                           NVL (p_subline_cd, 'x')
                     --AND subline_cd IS NULL -- verify
                     AND all_line_tag = p_all_line_tag
                     AND (NVL (p_by_tarf, 'N') <> 'Y'
                          OR (NVL (p_by_tarf, 'N') = 'Y'
                              AND tarf_cd IS NOT NULL))
          ORDER BY   tarf_cd, line_cd, range_to ASC)
      LOOP
         v_gipir947b.period := p_starting_date || ' TO ' || p_ending_date;
         v_gipir947b.tariff_desc := rec.tariff_desc;

         SELECT   line_cd || ' - ' || line_name
           INTO   v_gipir947b.line_name
           FROM   giis_line
          WHERE   line_cd = rec.line_cd;

         v_gipir947b.tsi_range :=
            TRIM (rec.range_from) || ' - ' || TRIM (rec.range_to);
         v_gipir947b.policy_count := rec.policy_count;
         v_gipir947b.first_ret_tsi := rec.net_ret_tsi;
         v_gipir947b.first_ret_prem := rec.net_ret;
         v_gipir947b.sec_ret_tsi := rec.sec_net_ret_tsi;
         v_gipir947b.sec_ret_prem := rec.sec_net_ret_prem;
         v_gipir947b.quota_share_tsi := rec.quota_share_tsi;
         v_gipir947b.quota_share_prem := rec.quota_share;
         v_gipir947b.treaty1_tsi := rec.treaty_tsi;
         v_gipir947b.treaty1_prem := rec.treaty_prem;
         v_gipir947b.treaty2_tsi := rec.treaty2_tsi;
         v_gipir947b.treaty2_prem := rec.treaty2_prem;
         v_gipir947b.treaty3_tsi := rec.treaty3_tsi;
         v_gipir947b.treaty3_prem := rec.treaty3_prem;
         v_gipir947b.treaty4_tsi := rec.treaty4_tsi;
         v_gipir947b.treaty4_prem := rec.treaty4_prem;
         v_gipir947b.treaty5_tsi := rec.treaty5_tsi;
         v_gipir947b.treaty5_prem := rec.treaty5_prem;
         v_gipir947b.treaty6_tsi := rec.treaty6_tsi;
         v_gipir947b.treaty6_prem := rec.treaty6_prem;
         v_gipir947b.treaty7_tsi := rec.treaty7_tsi;
         v_gipir947b.treaty7_prem := rec.treaty7_prem;
         v_gipir947b.treaty8_tsi := rec.treaty8_tsi;
         v_gipir947b.treaty8_prem := rec.treaty8_prem;
         v_gipir947b.treaty9_tsi := rec.treaty9_tsi;
         v_gipir947b.treaty9_prem := rec.treaty9_prem;
         v_gipir947b.treaty10_tsi := rec.treaty10_tsi;
         v_gipir947b.treaty10_prem := rec.treaty10_prem;
         v_gipir947b.facultative_tsi := rec.facul_tsi;
         v_gipir947b.facultative := rec.facul;
         v_gipir947b.total_tsi :=
              NVL (rec.net_ret_tsi, 0)
            + NVL (rec.sec_net_ret_tsi, 0)
            + NVL (rec.quota_share_tsi, 0)
            + NVL (rec.treaty_tsi, 0)
            + NVL (rec.treaty2_tsi, 0)
            + NVL (rec.treaty3_tsi, 0)
            + NVL (rec.treaty4_tsi, 0)
            + NVL (rec.treaty5_tsi, 0)
            + NVL (rec.treaty6_tsi, 0)
            + NVL (rec.treaty7_tsi, 0)
            + NVL (rec.treaty8_tsi, 0)
            + NVL (rec.treaty9_tsi, 0)
            + NVL (rec.treaty10_tsi, 0)
            + NVL (rec.facul_tsi, 0);
         v_gipir947b.total_prem :=
              NVL (rec.net_ret, 0)
            + NVL (rec.sec_net_ret_prem, 0)
            + NVL (rec.quota_share, 0)
            + NVL (rec.treaty_prem, 0)
            + NVL (rec.treaty2_prem, 0)
            + NVL (rec.treaty3_prem, 0)
            + NVL (rec.treaty4_prem, 0)
            + NVL (rec.treaty5_prem, 0)
            + NVL (rec.treaty6_prem, 0)
            + NVL (rec.treaty7_prem, 0)
            + NVL (rec.treaty8_prem, 0)
            + NVL (rec.treaty9_prem, 0)
            + NVL (rec.treaty10_prem, 0)
            + NVL (rec.facul, 0);
         PIPE ROW (v_gipir947b);
      END LOOP;

      RETURN;
   END;                                                       -- CSV_GIPIR947B

   /* ** STATISTICAL ** */
   -------------------------------------------- 41 ---------------------------------------------------
   FUNCTION csv_gipir071 (p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_extract_id       VARCHAR2,
                          p_subline_cd       VARCHAR2,
                          p_vessel_cd        VARCHAR2,
                          p_user             VARCHAR2)
      RETURN gipir071_type
      PIPELINED
   IS
      v_gipir071   gipir071_rec_type;
      v_temp_tax   NUMBER (16, 2) := 0;
   BEGIN
      FOR rec
      IN (  SELECT   policy_no,
                     subline_name,
                     vessel_cd,
                     vessel_name,
                     assd_no,
                     assd_name,
                     trty_name,
                     dist_tsi,
                     dist_prem
              FROM   gixx_mrn_vessel_stat
             WHERE       extract_id = TO_NUMBER (p_extract_id)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND vessel_cd = NVL (p_vessel_cd, vessel_cd)
                     AND user_id = p_user
          /*AND TRUNC(rundate)    = TRUNC(sysdate)*/
          ORDER BY   subline_cd, vessel_cd, policy_no)
      LOOP
         -- period
         v_gipir071.period := p_starting_date || ' TO ' || p_ending_date;
         --
         v_gipir071.subline_name := NVL (rec.subline_name, ' ');
         v_gipir071.vessel_name := NVL (rec.vessel_name, ' ');
         v_gipir071.policy_no := NVL (rec.policy_no, ' ');
         v_gipir071.assd_name := NVL (rec.assd_name, ' ');
         v_gipir071.treaty_name := NVL (rec.trty_name, ' ');
         v_gipir071.dist_tsi := NVL (rec.dist_tsi, 0);
         v_gipir071.dist_prem := NVL (rec.dist_prem, 0);

         -- tax amount
         FOR tax
         IN (SELECT   tax_amt
               FROM   gipi_invoice
              WHERE   policy_id IN (SELECT   policy_id
                                      FROM   gipi_polbasic
                                     WHERE      line_cd
                                             || '-'
                                             || subline_cd
                                             || '-'
                                             || iss_cd
                                             || '-'
                                             || LTRIM(TO_CHAR (
                                                         issue_yy,
                                                         '09'
                                                      ))
                                             || '-'
                                             || LTRIM(TO_CHAR (
                                                         pol_seq_no,
                                                         '0999999'
                                                      ))
                                             || '-'
                                             || LTRIM(TO_CHAR (
                                                         renew_no,
                                                         '09'
                                                      )) = rec.policy_no))
         LOOP
            v_temp_tax := v_temp_tax + NVL (tax.tax_amt, 0);
         END LOOP;

         v_gipir071.tax_amt := v_temp_tax;
         PIPE ROW (v_gipir071);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 42 ---------------------------------------------------
   FUNCTION csv_gipir072 (p_starting_date     VARCHAR2,
                          p_ending_date       VARCHAR2,
                          p_extract_id        VARCHAR2,
                          p_subline_cd        VARCHAR2,
                          p_cargo_class_cd    VARCHAR2,
                          p_user              VARCHAR2)
      RETURN gipir072_type
      PIPELINED
   IS
      v_gipir072   gipir072_rec_type;
      v_temp_tax   NUMBER (16, 2) := 0;
   BEGIN
      FOR rec
      IN (SELECT   policy_no,
                   policy_id,
                   subline_name,
                   cargo_class_cd,
                   cargo_class_desc,
                   assd_no,
                   assd_name,
                   trty_name,
                   dist_tsi,
                   dist_prem
            FROM   gixx_mrn_cargo_stat
           WHERE   extract_id = TO_NUMBER (p_extract_id)
                   AND subline_cd = NVL (p_subline_cd, subline_cd)
                   AND cargo_class_cd =
                         NVL (p_cargo_class_cd, cargo_class_cd)
                   AND user_id = p_user /*AND TRUNC(rundate)    = TRUNC(sysdate)*/
                                       )
      LOOP
         -- period
         v_gipir072.period := p_starting_date || ' TO ' || p_ending_date;
         --
         v_gipir072.subline_name := NVL (rec.subline_name, ' ');
         v_gipir072.cargo_class_desc := NVL (rec.cargo_class_desc, ' ');
         v_gipir072.policy_no := NVL (rec.policy_no, ' ');
         v_gipir072.assd_name := NVL (rec.assd_name, ' ');
         v_gipir072.treaty_name := NVL (rec.trty_name, ' ');
         v_gipir072.dist_tsi := NVL (rec.dist_tsi, 0);
         v_gipir072.dist_prem := NVL (rec.dist_prem, 0);

         -- tax amount
         FOR tax
         IN (SELECT   tax_amt
               FROM   gipi_invoice
              WHERE   policy_id = rec.policy_id
                      AND iss_cd =
                            SUBSTR (rec.policy_no,
                                    (INSTR (rec.policy_no,
                                            '-',
                                            1,
                                            2)
                                     + 1),
                                    (INSTR (rec.policy_no,
                                            '-',
                                            1,
                                            3))
                                    - (INSTR (rec.policy_no,
                                              '-',
                                              1,
                                              2)
                                       + 1)))
         LOOP
            v_temp_tax := v_temp_tax + NVL (tax.tax_amt, 0);
         END LOOP;

         v_gipir072.tax_amt := v_temp_tax;
         v_temp_tax := 0;
         PIPE ROW (v_gipir072);
      END LOOP;

      RETURN;
   END;

   /* ** FIRE STAT ** */
   -------------------------------------------- 43 ---------------------------------------------------
   FUNCTION csv_gipir038a (p_period_start     VARCHAR2,
                           p_period_end       VARCHAR2,
                           p_user             VARCHAR2,
                           p_as_of_sw         VARCHAR2,
                           p_zone_type        VARCHAR2,
                           p_expired_as_of    VARCHAR2)
      RETURN gipir038_type
      PIPELINED
   IS
      v_gipir038a       gipir038_rec_type;
      v_period_start    DATE := TO_DATE (p_period_start, 'MM-DD-YYYY');
      v_period_end      DATE := TO_DATE (p_period_end, 'MM-DD-YYYY');
      v_expired_as_of   DATE := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
   BEGIN
      FOR rec
      IN (  SELECT   tariff_zone,
                     SUM (NVL (tsi_amt, 0)) tsi_amt,
                     SUM (NVL (prem_amt, 0)) prem_amt
              FROM   gixx_firestat_summary
             WHERE       peril_cd IN (SELECT   peril_cd
                                        FROM   giis_peril
                                       WHERE   zone_type = p_zone_type)
                     AND user_id = p_user
                     AND as_of_sw = p_as_of_sw
                     AND DECODE (p_as_of_sw,
                                 'Y', TRUNC (as_of_date),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'Y', TRUNC (v_expired_as_of),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_from),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_start),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_to),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_end),
                                   TRUNC (SYSDATE))
          GROUP BY   tariff_zone
          ORDER BY   tariff_zone)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir038a.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir038a.period := p_period_start || ' TO ' || p_period_end;
         END IF;

         -- Tariff Interpretation
         IF rec.tariff_zone IS NULL
         THEN
            v_gipir038a.tariff_int := NULL;
         ELSE
            v_gipir038a.tariff_int := '(Zone ' || rec.tariff_zone || ')';
         END IF;

         -- Number of Policies
         BEGIN
            SELECT   COUNT ( * )
              INTO   v_gipir038a.policy_cnt
              FROM   (SELECT   DISTINCT line_cd,
                                        subline_cd,
                                        iss_cd,
                                        issue_yy,
                                        pol_seq_no,
                                        renew_no
                        FROM   gixx_firestat_summary
                       WHERE   NVL (tariff_zone, 'x') =
                                  NVL (rec.tariff_zone, 'x')
                               AND peril_cd IN
                                        (SELECT   peril_cd
                                           FROM   giis_peril
                                          WHERE   zone_type = p_zone_type)
                               AND user_id = p_user
                               AND as_of_sw = p_as_of_sw
                               AND DECODE (p_as_of_sw,
                                           'Y', TRUNC (as_of_date),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'Y', TRUNC (v_expired_as_of),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_from),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_start),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_to),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_end),
                                             TRUNC (SYSDATE))
                               AND (tsi_amt <> 0 OR prem_amt != 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038a.policy_cnt := NULL;
         END;

         -- Aggregate Sum Insured
         v_gipir038a.aggr_sum_insured := rec.tsi_amt;
         -- Aggregate Premium Written
         v_gipir038a.aggr_prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir038a);
      END LOOP;

      RETURN;
   END;

   ---------------------------------------------- 44 -------------------------------------------------
   FUNCTION csv_gipir038b (p_period_start     VARCHAR2,
                           p_period_end       VARCHAR2,
                           p_user             VARCHAR2,
                           p_as_of_sw         VARCHAR2,
                           p_zone_type        VARCHAR2,
                           p_expired_as_of    VARCHAR2)
      RETURN gipir038_type
      PIPELINED
   IS
      v_gipir038b       gipir038_rec_type;
      v_period_start    DATE := TO_DATE (p_period_start, 'MM-DD-YYYY');
      v_period_end      DATE := TO_DATE (p_period_end, 'MM-DD-YYYY');
      v_expired_as_of   DATE := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
   BEGIN
      FOR rec
      IN (  SELECT   tarf_cd,
                     COUNT (
                        DISTINCT    line_cd
                                 || '-'
                                 || subline_cd
                                 || '-'
                                 || iss_cd
                                 || '-'
                                 || LTRIM (TO_CHAR (issue_yy, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                                 || '-'
                                 || LTRIM (TO_CHAR (renew_no, '09'))
                     )
                        policy_cnt,
                     SUM (NVL (tsi_amt, 0)) tsi_amt,
                     SUM (NVL (prem_amt, 0)) prem_amt
              FROM   gixx_firestat_summary
             WHERE   peril_cd IN
                           (SELECT   peril_cd
                              FROM   giis_peril
                             WHERE   zone_type = p_zone_type
                                     AND zone_type IS NOT NULL)
                     AND user_id = p_user
                     AND as_of_sw = p_as_of_sw
                     AND DECODE (p_as_of_sw,
                                 'Y', TRUNC (as_of_date),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'Y', TRUNC (v_expired_as_of),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_from),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_start),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_to),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_end),
                                   TRUNC (SYSDATE))
          GROUP BY   tarf_cd
          ORDER BY   tarf_cd)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir038b.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir038b.period := p_period_start || ' TO ' || p_period_end;
         END IF;

         -- Zone desc
         BEGIN
            SELECT   NVL (rv_meaning, ' ')
              INTO   v_gipir038b.zone_desc
              FROM   cg_ref_codes
             WHERE   rv_low_value = p_zone_type
                     AND UPPER (rv_domain) =
                           'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
                     AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038b.zone_desc := NULL;
         END;

         -- Tariff Interpretation
         v_gipir038b.tariff_int := rec.tarf_cd;
         -- Policy Count
         v_gipir038b.policy_cnt := rec.policy_cnt;
         --Aggregate TSI - Prem
         v_gipir038b.aggr_sum_insured := rec.tsi_amt;
         v_gipir038b.aggr_prem_amt := rec.prem_amt;
         PIPE ROW (v_gipir038b);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 45 ---------------------------------------------------
   FUNCTION csv_gipir038c (p_period_start     VARCHAR2,
                           p_period_end       VARCHAR2,
                           p_user             VARCHAR2,
                           p_as_of_sw         VARCHAR2,
                           p_zone_type        VARCHAR2,
                           p_expired_as_of    VARCHAR2,
                           p_zone_typea       VARCHAR2,
                           p_zone_typeb       VARCHAR2,
                           p_zone_typec       VARCHAR2,
                           p_zone_typed       VARCHAR2)
      RETURN gipir038_type
      PIPELINED
   IS
      v_gipir038c       gipir038_rec_type;
      v_period_start    DATE := TO_DATE (p_period_start, 'MM-DD-YYYY');
      v_period_end      DATE := TO_DATE (p_period_end, 'MM-DD-YYYY');
      v_expired_as_of   DATE := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
   BEGIN
      FOR rec1
      IN (  SELECT   tarf_cd                                   --, tariff_zone
                            ,
                     SUM (NVL (tsi_amt, 0)) tsi_amt,
                     SUM (NVL (prem_amt, 0)) prem_amt
              FROM   gixx_firestat_summary
             WHERE   peril_cd IN
                           (SELECT   peril_cd
                              FROM   giis_peril
                             WHERE   zone_type = p_zone_typea
                                     AND zone_type IS NOT NULL)
                     AND user_id = p_user
                     AND as_of_sw = p_as_of_sw
                     AND DECODE (p_as_of_sw,
                                 'Y', TRUNC (as_of_date),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'Y', TRUNC (v_expired_as_of),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_from),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_start),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_to),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_end),
                                   TRUNC (SYSDATE))
          GROUP BY   tarf_cd
          ORDER BY   tarf_cd)
      LOOP
         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir038c.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir038c.period := p_period_start || ' TO ' || p_period_end;
         END IF;

         --Zone Desc = p_zone_typeA
         BEGIN
            SELECT   NVL (rv_meaning, ' ')
              INTO   v_gipir038c.zone_desc
              FROM   cg_ref_codes
             WHERE   rv_low_value = p_zone_typea
                     AND UPPER (rv_domain) =
                           'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
                     AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.zone_desc := NULL;
         END;

         -- Tariff Interpretation
         v_gipir038c.tariff_int := NVL (rec1.tarf_cd, '');

         -- Policy Count
         BEGIN
            SELECT   COUNT ( * )
              INTO   v_gipir038c.policy_cnt
              FROM   (SELECT   DISTINCT line_cd,
                                        subline_cd,
                                        iss_cd,
                                        issue_yy,
                                        pol_seq_no,
                                        renew_no
                        FROM   gixx_firestat_summary
                       WHERE   NVL (tarf_cd, 'x') = NVL (rec1.tarf_cd, 'x')
                               --AND NVL(tariff_zone, 'x') = NVL(rec1.tariff_zone, 'x')
                               AND peril_cd IN
                                        (SELECT   peril_cd
                                           FROM   giis_peril
                                          WHERE   zone_type = p_zone_typea
                                                  AND zone_type IS NOT NULL)
                               AND user_id = p_user
                               AND as_of_sw = p_as_of_sw
                               AND DECODE (p_as_of_sw,
                                           'Y', TRUNC (as_of_date),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'Y', TRUNC (v_expired_as_of),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_from),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_start),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_to),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_end),
                                             TRUNC (SYSDATE))
                               AND (tsi_amt <> 0 OR prem_amt <> 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.policy_cnt := NULL;
         END;

         -- Aggregate Sum Insured
         v_gipir038c.aggr_sum_insured := rec1.tsi_amt;
         -- Aggregate Premium Amount
         v_gipir038c.aggr_prem_amt := rec1.prem_amt;
         PIPE ROW (v_gipir038c);
      END LOOP;

      FOR rec2
      IN (  SELECT   tarf_cd                                   --, tariff_zone
                            ,
                     SUM (NVL (tsi_amt, 0)) tsi_amt,
                     SUM (NVL (prem_amt, 0)) prem_amt
              FROM   gixx_firestat_summary
             WHERE   peril_cd IN
                           (SELECT   peril_cd
                              FROM   giis_peril
                             WHERE   zone_type = p_zone_typeb
                                     AND zone_type IS NOT NULL)
                     AND user_id = p_user
                     AND as_of_sw = p_as_of_sw
                     AND DECODE (p_as_of_sw,
                                 'Y', TRUNC (as_of_date),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'Y', TRUNC (v_expired_as_of),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_from),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_start),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_to),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_end),
                                   TRUNC (SYSDATE))
          GROUP BY   tarf_cd
          ORDER BY   tarf_cd)
      LOOP
         --Zone Desc = p_zone_typeB
         BEGIN
            SELECT   NVL (rv_meaning, ' ')
              INTO   v_gipir038c.zone_desc
              FROM   cg_ref_codes
             WHERE   rv_low_value = p_zone_typeb
                     AND UPPER (rv_domain) =
                           'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
                     AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.zone_desc := NULL;
         END;

         -- Tariff Interpretation
         v_gipir038c.tariff_int := NVL (rec2.tarf_cd, ' ');

         -- Policy Count
         BEGIN
            SELECT   COUNT ( * )
              INTO   v_gipir038c.policy_cnt
              FROM   (SELECT   DISTINCT line_cd,
                                        subline_cd,
                                        iss_cd,
                                        issue_yy,
                                        pol_seq_no,
                                        renew_no
                        FROM   gixx_firestat_summary
                       WHERE   NVL (tarf_cd, 'x') = NVL (rec2.tarf_cd, 'x')
                               --AND NVL(tariff_zone, 'x') = NVL(rec2.tariff_zone, 'x')
                               AND peril_cd IN
                                        (SELECT   peril_cd
                                           FROM   giis_peril
                                          WHERE   zone_type = p_zone_typeb
                                                  AND zone_type IS NOT NULL)
                               AND user_id = p_user
                               AND as_of_sw = p_as_of_sw
                               AND DECODE (p_as_of_sw,
                                           'Y', TRUNC (as_of_date),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'Y', TRUNC (v_expired_as_of),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_from),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_start),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_to),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_end),
                                             TRUNC (SYSDATE))
                               AND (tsi_amt <> 0 OR prem_amt <> 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.policy_cnt := NULL;
         END;

         -- Aggregate Sum Insured
         v_gipir038c.aggr_sum_insured := rec2.tsi_amt;
         -- Aggregate Premium Amount
         v_gipir038c.aggr_prem_amt := rec2.prem_amt;
         PIPE ROW (v_gipir038c);
      END LOOP;

      FOR rec3
      IN (  SELECT   tarf_cd                                   --, tariff_zone
                            ,
                     SUM (NVL (tsi_amt, 0)) tsi_amt,
                     SUM (NVL (prem_amt, 0)) prem_amt
              FROM   gixx_firestat_summary
             WHERE   peril_cd IN
                           (SELECT   peril_cd
                              FROM   giis_peril
                             WHERE   zone_type = p_zone_typec
                                     AND zone_type IS NOT NULL)
                     AND user_id = p_user
                     AND as_of_sw = p_as_of_sw
                     AND DECODE (p_as_of_sw,
                                 'Y', TRUNC (as_of_date),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'Y', TRUNC (v_expired_as_of),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_from),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_start),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_to),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_end),
                                   TRUNC (SYSDATE))
          GROUP BY   tarf_cd
          ORDER BY   tarf_cd)
      LOOP
         --Zone Desc = p_zone_typeC
         BEGIN
            SELECT   NVL (rv_meaning, ' ')
              INTO   v_gipir038c.zone_desc
              FROM   cg_ref_codes
             WHERE   rv_low_value = p_zone_typec
                     AND UPPER (rv_domain) =
                           'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
                     AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.zone_desc := NULL;
         END;

         -- Tariff Interpretation
         v_gipir038c.tariff_int := NVL (rec3.tarf_cd, ' ');

         -- Policy Count
         BEGIN
            SELECT   COUNT ( * )
              INTO   v_gipir038c.policy_cnt
              FROM   (SELECT   DISTINCT line_cd,
                                        subline_cd,
                                        iss_cd,
                                        issue_yy,
                                        pol_seq_no,
                                        renew_no
                        FROM   gixx_firestat_summary
                       WHERE   NVL (tarf_cd, 'x') = NVL (rec3.tarf_cd, 'x')
                               --AND NVL(tariff_zone, 'x') = NVL(rec3.tariff_zone, 'x')
                               AND peril_cd IN
                                        (SELECT   peril_cd
                                           FROM   giis_peril
                                          WHERE   zone_type = p_zone_typec
                                                  AND zone_type IS NOT NULL)
                               AND user_id = p_user
                               AND as_of_sw = p_as_of_sw
                               AND DECODE (p_as_of_sw,
                                           'Y', TRUNC (as_of_date),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'Y', TRUNC (v_expired_as_of),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_from),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_start),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_to),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_end),
                                             TRUNC (SYSDATE))
                               AND (tsi_amt <> 0 OR prem_amt <> 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.policy_cnt := NULL;
         END;

         -- Aggregate Sum Insured
         v_gipir038c.aggr_sum_insured := rec3.tsi_amt;
         -- Aggregate Premium Amount
         v_gipir038c.aggr_prem_amt := rec3.prem_amt;
         PIPE ROW (v_gipir038c);
      END LOOP;

      FOR rec4
      IN (  SELECT   tarf_cd                                   --, tariff_zone
                            ,
                     SUM (NVL (tsi_amt, 0)) tsi_amt,
                     SUM (NVL (prem_amt, 0)) prem_amt
              FROM   gixx_firestat_summary
             WHERE   peril_cd IN
                           (SELECT   peril_cd
                              FROM   giis_peril
                             WHERE   zone_type = p_zone_typed
                                     AND zone_type IS NOT NULL)
                     AND user_id = p_user
                     AND as_of_sw = p_as_of_sw
                     AND DECODE (p_as_of_sw,
                                 'Y', TRUNC (as_of_date),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'Y', TRUNC (v_expired_as_of),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_from),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_start),
                                   TRUNC (SYSDATE))
                     AND DECODE (p_as_of_sw,
                                 'N', TRUNC (date_to),
                                 TRUNC (SYSDATE)) =
                           DECODE (p_as_of_sw,
                                   'N', TRUNC (v_period_end),
                                   TRUNC (SYSDATE))
          GROUP BY   tarf_cd
          ORDER BY   tarf_cd)
      LOOP
         --Zone Desc = p_zone_typeD
         BEGIN
            SELECT   NVL (rv_meaning, ' ')
              INTO   v_gipir038c.zone_desc
              FROM   cg_ref_codes
             WHERE   rv_low_value = p_zone_typed
                     AND UPPER (rv_domain) =
                           'GIPI_FIRESTAT_EXTRACT.EQ_ZONE_TYPE'
                     AND ROWNUM = 1;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.zone_desc := NULL;
         END;

         -- Tariff Interpretation
         v_gipir038c.tariff_int := NVL (rec4.tarf_cd, ' ');

         -- Policy Count
         BEGIN
            SELECT   COUNT ( * )
              INTO   v_gipir038c.policy_cnt
              FROM   (SELECT   DISTINCT line_cd,
                                        subline_cd,
                                        iss_cd,
                                        issue_yy,
                                        pol_seq_no,
                                        renew_no
                        FROM   gixx_firestat_summary
                       WHERE   NVL (tarf_cd, 'x') = NVL (rec4.tarf_cd, 'x')
                               --AND NVL(tariff_zone, 'x') = NVL(rec4.tariff_zone, 'x')
                               AND peril_cd IN
                                        (SELECT   peril_cd
                                           FROM   giis_peril
                                          WHERE   zone_type = p_zone_typed
                                                  AND zone_type IS NOT NULL)
                               AND user_id = p_user
                               AND as_of_sw = p_as_of_sw
                               AND DECODE (p_as_of_sw,
                                           'Y', TRUNC (as_of_date),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'Y', TRUNC (v_expired_as_of),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_from),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_start),
                                             TRUNC (SYSDATE))
                               AND DECODE (p_as_of_sw,
                                           'N', TRUNC (date_to),
                                           TRUNC (SYSDATE)) =
                                     DECODE (p_as_of_sw,
                                             'N', TRUNC (v_period_end),
                                             TRUNC (SYSDATE))
                               AND (tsi_amt <> 0 OR prem_amt <> 0));
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_gipir038c.policy_cnt := NULL;
         END;

         -- Aggregate Sum Insured
         v_gipir038c.aggr_sum_insured := rec4.tsi_amt;
         -- Aggregate Premium Amount
         v_gipir038c.aggr_prem_amt := rec4.prem_amt;
         PIPE ROW (v_gipir038c);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 46 ---------------------------------------------------
   FUNCTION csv_gipir039a (p_starting_date    VARCHAR2,
                           p_ending_date      VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE,
                           p_as_of_sw         VARCHAR2,
                           p_zone_type        VARCHAR2,
                           p_expired_as_of    VARCHAR2,
                           p_table            VARCHAR2,
                           p_column           VARCHAR2)
      RETURN gipir039a_type
      PIPELINED
   IS
      v_gipir039a       gipir039a_rec_type;
      v_period_start    DATE := TO_DATE (p_starting_date, 'MM-DD-YYYY');
      v_period_end      DATE := TO_DATE (p_ending_date, 'MM-DD-YYYY');
      v_expired_as_of   DATE := TO_DATE (p_expired_as_of, 'MM-DD-YYYY');
      v_bldg_tsi        NUMBER (16, 2);
      v_bldg_prem       NUMBER (16, 2);
      v_content_tsi     NUMBER (16, 2);
      v_content_prem    NUMBER (16, 2);
      v_loss_tsi        NUMBER (16, 2);
      v_loss_prem       NUMBER (16, 2);
      v_tot_tsi         NUMBER (16, 2);
      v_tot_prem        NUMBER (16, 2);
   BEGIN
      IF TRIM (UPPER (p_table)) = 'GIIS_EQZONE'
      THEN
         FOR rec
         IN (  SELECT      a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                        || '-'
                        || LTRIM (TO_CHAR (a.renew_no, '09'))
                           policy_no,
                        TO_CHAR (b.zone_no) zone_no,
                        b.zone_type,
                        c.zone_grp,
                        b.policy_id,
                        SUM (share_tsi_amt) tot_tsi,
                        SUM (share_prem_amt) tot_prem
                 FROM   gipi_polbasic a,
                        gipi_firestat_extract_dtl b,
                        giis_eqzone c
                WHERE       a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = c.eq_zone
                        AND b.as_of_sw = p_as_of_sw
                        AND b.user_id = p_user_id
                        AND b.fi_item_grp IS NOT NULL
                        AND DECODE (p_as_of_sw,
                                    'Y', TRUNC (as_of_date),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'Y', TRUNC (v_expired_as_of),
                                      TRUNC (SYSDATE))
                        AND DECODE (p_as_of_sw,
                                    'N', TRUNC (date_from),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_start),
                                      TRUNC (SYSDATE))
                        AND DECODE (p_as_of_sw,
                                    'N', TRUNC (date_to),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_end),
                                      TRUNC (SYSDATE))
             GROUP BY   a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.zone_no,
                        b.zone_type,
                        c.zone_grp,
                        b.policy_id
             ORDER BY   c.zone_grp,
                        b.zone_no,
                        a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no)
         LOOP
            -- Period
            IF p_as_of_sw = 'Y'
            THEN
               v_gipir039a.period := 'As of ' || p_expired_as_of;
            ELSE
               v_gipir039a.period :=
                  p_starting_date || ' TO ' || p_ending_date;
            END IF;

            -- Zone Group
            IF rec.zone_grp = '1'
            THEN
               v_gipir039a.zone_grp := 'Zone A';
            ELSE
               v_gipir039a.zone_grp := 'Zone B';
            END IF;

            -- Zone Number
            v_gipir039a.zone_no := rec.zone_no;
            -- Policy Number
            v_gipir039a.policy_no := rec.policy_no;

            -- Amounts:
            FOR amt
            IN (  SELECT   DISTINCT zone_grp,
                                    zone_no,
                                    policy_id,
                                    fi_item_grp,
                                    SUM (share_tsi_amt) share_tsi,
                                    SUM (share_prem_amt) share_prem
                    FROM   gipi_firestat_extract_dtl a, giis_eqzone b
                   WHERE       a.zone_no = b.eq_zone
                           AND a.zone_type = p_zone_type
                           AND a.as_of_sw = p_as_of_sw
                           AND fi_item_grp IS NOT NULL
                           AND a.user_id = p_user_id
                           AND policy_id = rec.policy_id
                GROUP BY   zone_grp,
                           zone_no,
                           policy_id,
                           fi_item_grp)
            LOOP
               -- Building (Insured Amount - Premium Amount)
               IF amt.fi_item_grp = 'B'
               THEN
                  v_bldg_tsi := amt.share_tsi;
                  v_bldg_prem := amt.share_prem;
               -- Content (Insured Amount - Premium Amount)
               ELSIF amt.fi_item_grp = 'C'
               THEN
                  v_content_tsi := amt.share_tsi;
                  v_content_prem := amt.share_prem;
               -- Loss (Insured Amount - Premium Amount)
               ELSIF amt.fi_item_grp = 'L'
               THEN
                  v_loss_tsi := amt.share_tsi;
                  v_loss_prem := amt.share_prem;
               END IF;
            END LOOP;

            v_gipir039a.bldg_tsi := v_bldg_tsi;
            v_gipir039a.bldg_prem_amt := v_bldg_prem;
            v_gipir039a.content_tsi := v_content_tsi;
            v_gipir039a.content_prem_amt := v_content_prem;
            v_gipir039a.loss_tsi := v_loss_tsi;
            v_gipir039a.loss_prem_amt := v_loss_prem;
            --- reset variables
            v_bldg_tsi := NULL;
            v_bldg_prem := NULL;
            v_content_tsi := NULL;
            v_content_prem := NULL;
            v_loss_tsi := NULL;
            v_loss_prem := NULL;
            v_tot_tsi := NULL;
            v_tot_prem := NULL;
            -- Total (Insured Amount - Premium Amount)
            v_gipir039a.total_tsi := rec.tot_tsi;
            v_gipir039a.total_prem := rec.tot_prem;
            PIPE ROW (v_gipir039a);
         END LOOP;

         RETURN;
      ELSIF TRIM (UPPER (p_table)) = 'GIIS_TYPHOON_ZONE'
      THEN
         FOR rec
         IN (  SELECT      a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                        || '-'
                        || LTRIM (TO_CHAR (a.renew_no, '09'))
                           policy_no,
                        TO_CHAR (b.zone_no) zone_no,
                        b.zone_type,
                        c.zone_grp,
                        b.policy_id,
                        SUM (share_tsi_amt) tot_tsi,
                        SUM (share_prem_amt) tot_prem
                 FROM   gipi_polbasic a,
                        gipi_firestat_extract_dtl b,
                        giis_typhoon_zone c
                WHERE       a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = c.typhoon_zone
                        AND b.as_of_sw = p_as_of_sw
                        AND b.user_id = p_user_id
                        AND b.fi_item_grp IS NOT NULL
                        AND DECODE (p_as_of_sw,
                                    'Y', TRUNC (as_of_date),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'Y', TRUNC (v_expired_as_of),
                                      TRUNC (SYSDATE))
                        AND DECODE (p_as_of_sw,
                                    'N', TRUNC (date_from),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_start),
                                      TRUNC (SYSDATE))
                        AND DECODE (p_as_of_sw,
                                    'N', TRUNC (date_to),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_end),
                                      TRUNC (SYSDATE))
             GROUP BY   a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.zone_no,
                        b.zone_type,
                        c.zone_grp,
                        b.policy_id
             ORDER BY   c.zone_grp, b.zone_no)
         LOOP
            -- Period
            IF p_as_of_sw = 'Y'
            THEN
               v_gipir039a.period := 'As of ' || p_expired_as_of;
            ELSE
               v_gipir039a.period :=
                  p_starting_date || ' TO ' || p_ending_date;
            END IF;

            -- Zone Group
            IF rec.zone_grp = '1'
            THEN
               v_gipir039a.zone_grp := 'Zone A';
            ELSE
               v_gipir039a.zone_grp := 'Zone B';
            END IF;

            -- Zone Number
            v_gipir039a.zone_no := rec.zone_no;
            -- Policy Number
            v_gipir039a.policy_no := rec.policy_no;

            -- Amounts:
            FOR amt
            IN (  SELECT   DISTINCT zone_grp,
                                    zone_no,
                                    policy_id,
                                    fi_item_grp,
                                    SUM (share_tsi_amt) share_tsi,
                                    SUM (share_prem_amt) share_prem
                    FROM   gipi_firestat_extract_dtl a, giis_typhoon_zone b
                   WHERE       a.zone_no = b.typhoon_zone
                           AND a.zone_type = p_zone_type
                           AND a.as_of_sw = p_as_of_sw
                           AND fi_item_grp IS NOT NULL
                           AND a.user_id = p_user_id
                           AND policy_id = rec.policy_id
                GROUP BY   zone_grp,
                           zone_no,
                           policy_id,
                           fi_item_grp)
            LOOP
               -- Building (Insured Amount - Premium Amount)
               IF amt.fi_item_grp = 'B'
               THEN
                  v_bldg_tsi := amt.share_tsi;
                  v_bldg_prem := amt.share_prem;
               -- Content (Insured Amount - Premium Amount)
               ELSIF amt.fi_item_grp = 'C'
               THEN
                  v_content_tsi := amt.share_tsi;
                  v_content_prem := amt.share_prem;
               -- Loss (Insured Amount - Premium Amount)
               ELSIF amt.fi_item_grp = 'L'
               THEN
                  v_loss_tsi := amt.share_tsi;
                  v_loss_prem := amt.share_prem;
               END IF;
            END LOOP;

            v_gipir039a.bldg_tsi := v_bldg_tsi;
            v_gipir039a.bldg_prem_amt := v_bldg_prem;
            v_gipir039a.content_tsi := v_content_tsi;
            v_gipir039a.content_prem_amt := v_content_prem;
            v_gipir039a.loss_tsi := v_loss_tsi;
            v_gipir039a.loss_prem_amt := v_loss_prem;
            --- reset variables
            v_bldg_tsi := NULL;
            v_bldg_prem := NULL;
            v_content_tsi := NULL;
            v_content_prem := NULL;
            v_loss_tsi := NULL;
            v_loss_prem := NULL;
            v_tot_tsi := NULL;
            v_tot_prem := NULL;
            -- Total (Insured Amount - Premium Amount)
            v_gipir039a.total_tsi := rec.tot_tsi;
            v_gipir039a.total_prem := rec.tot_prem;
            PIPE ROW (v_gipir039a);
         END LOOP;

         RETURN;
      ELSIF TRIM (UPPER (p_table)) = 'GIIS_FLOOD_ZONE'
      THEN
         FOR rec
         IN (  SELECT      a.line_cd
                        || '-'
                        || a.subline_cd
                        || '-'
                        || a.iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (a.issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (a.pol_seq_no, '0000009'))
                        || '-'
                        || LTRIM (TO_CHAR (a.renew_no, '09'))
                           policy_no,
                        TO_CHAR (b.zone_no) zone_no,
                        b.zone_type,
                        c.zone_grp,
                        b.policy_id,
                        SUM (share_tsi_amt) tot_tsi,
                        SUM (share_prem_amt) tot_prem
                 FROM   gipi_polbasic a,
                        gipi_firestat_extract_dtl b,
                        giis_flood_zone c
                WHERE       a.policy_id = b.policy_id
                        AND b.zone_type = p_zone_type
                        AND b.zone_no = c.flood_zone
                        AND b.as_of_sw = p_as_of_sw
                        AND b.user_id = p_user_id
                        AND b.fi_item_grp IS NOT NULL
                        AND DECODE (p_as_of_sw,
                                    'Y', TRUNC (as_of_date),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'Y', TRUNC (v_expired_as_of),
                                      TRUNC (SYSDATE))
                        AND DECODE (p_as_of_sw,
                                    'N', TRUNC (date_from),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_start),
                                      TRUNC (SYSDATE))
                        AND DECODE (p_as_of_sw,
                                    'N', TRUNC (date_to),
                                    TRUNC (SYSDATE)) =
                              DECODE (p_as_of_sw,
                                      'N', TRUNC (v_period_end),
                                      TRUNC (SYSDATE))
             GROUP BY   a.line_cd,
                        a.subline_cd,
                        a.iss_cd,
                        a.issue_yy,
                        a.pol_seq_no,
                        a.renew_no,
                        b.zone_no,
                        b.zone_type,
                        c.zone_grp,
                        b.policy_id
             ORDER BY   c.zone_grp, b.zone_no)
         LOOP
            -- Period
            IF p_as_of_sw = 'Y'
            THEN
               v_gipir039a.period := 'As of ' || p_expired_as_of;
            ELSE
               v_gipir039a.period :=
                  p_starting_date || ' TO ' || p_ending_date;
            END IF;

            -- Zone Group
            IF rec.zone_grp = '1'
            THEN
               v_gipir039a.zone_grp := 'Zone A';
            ELSE
               v_gipir039a.zone_grp := 'Zone B';
            END IF;

            -- Zone Number
            v_gipir039a.zone_no := rec.zone_no;
            -- Policy Number
            v_gipir039a.policy_no := rec.policy_no;

            -- Amounts:
            FOR amt
            IN (  SELECT   DISTINCT zone_grp,
                                    zone_no,
                                    policy_id,
                                    fi_item_grp,
                                    SUM (share_tsi_amt) share_tsi,
                                    SUM (share_prem_amt) share_prem
                    FROM   gipi_firestat_extract_dtl a, giis_flood_zone b
                   WHERE       a.zone_no = b.flood_zone
                           AND a.zone_type = p_zone_type
                           AND a.as_of_sw = p_as_of_sw
                           AND fi_item_grp IS NOT NULL
                           AND a.user_id = p_user_id
                           AND policy_id = rec.policy_id
                GROUP BY   zone_grp,
                           zone_no,
                           policy_id,
                           fi_item_grp)
            LOOP
               -- Building (Insured Amount - Premium Amount)
               IF amt.fi_item_grp = 'B'
               THEN
                  v_bldg_tsi := amt.share_tsi;
                  v_bldg_prem := amt.share_prem;
               -- Content (Insured Amount - Premium Amount)
               ELSIF amt.fi_item_grp = 'C'
               THEN
                  v_content_tsi := amt.share_tsi;
                  v_content_prem := amt.share_prem;
               -- Loss (Insured Amount - Premium Amount)
               ELSIF amt.fi_item_grp = 'L'
               THEN
                  v_loss_tsi := amt.share_tsi;
                  v_loss_prem := amt.share_prem;
               END IF;
            END LOOP;

            v_gipir039a.bldg_tsi := v_bldg_tsi;
            v_gipir039a.bldg_prem_amt := v_bldg_prem;
            v_gipir039a.content_tsi := v_content_tsi;
            v_gipir039a.content_prem_amt := v_content_prem;
            v_gipir039a.loss_tsi := v_loss_tsi;
            v_gipir039a.loss_prem_amt := v_loss_prem;
            --- reset variables
            v_bldg_tsi := NULL;
            v_bldg_prem := NULL;
            v_content_tsi := NULL;
            v_content_prem := NULL;
            v_loss_tsi := NULL;
            v_loss_prem := NULL;
            v_tot_tsi := NULL;
            v_tot_prem := NULL;
            -- Total (Insured Amount - Premium Amount)
            v_gipir039a.total_tsi := rec.tot_tsi;
            v_gipir039a.total_prem := rec.tot_prem;
            PIPE ROW (v_gipir039a);
         END LOOP;

         RETURN;
      END IF;
   END;

   -------------------------------------------- 47 ---------------------------------------------------
   FUNCTION csv_gipir039b (p_starting_date    VARCHAR2,
                           p_ending_date      VARCHAR2,
                           p_user             VARCHAR2,
                           p_as_of_sw         VARCHAR2,
                           p_zone_type        VARCHAR2,
                           p_expired_as_of    VARCHAR2,
                           p_table            VARCHAR2,
                           p_column           VARCHAR2)
      RETURN gipir039b_type
      PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;

      v_gipir039b         gipir039b_rec_type;
      cur1                ref_cursor;
      cur2                ref_cursor;
      v_query             VARCHAR2 (4000);
      v_tot_cnt           NUMBER;
      v_tot_tsi           NUMBER (18, 2);
      v_tot_prem          NUMBER (18, 2);
      v_zone_no           gipi_firestat_extract_dtl.zone_no%TYPE;
      v_zone_type         gipi_firestat_extract_dtl.zone_type%TYPE;
      v_zone_grp          VARCHAR2 (5);
      v_query2            VARCHAR2 (4000);
      v_pol_cnt           NUMBER;
      v_sum_tsi           NUMBER (20, 2);
      v_sum_prem          NUMBER (18, 2);
      v_fi_item_grp       gipi_firestat_extract_dtl.fi_item_grp%TYPE;
      v_bldg_pol_cnt      NUMBER := 0;
      v_content_pol_cnt   NUMBER := 0;
      v_loss_pol_cnt      NUMBER := 0;
   BEGIN
      v_query :=
         'SELECT COUNT(DISTINCT a.line_cd||''-''||a.subline_cd||''-''||a.iss_cd||''-''||LTRIM(TO_CHAR(a.issue_yy, ''09''))||''-''||LTRIM(TO_CHAR(a.pol_seq_no, ''0000009''))||''-''||LTRIM(TO_CHAR(a.renew_no, ''09''))) policy_no
                                   , SUM(NVL(share_tsi_amt,TO_NUMBER(''0.00''))) sum_tsi
                                   , SUM(NVL(share_prem_amt,TO_NUMBER(''0.00''))) sum_prem
                                   , b.zone_no
                                   , b.zone_type
                                   , c.zone_grp
                              FROM gipi_polbasic a,
                                   gipi_firestat_extract_dtl b,
                                   '
         || p_table
         || ' c
                             WHERE a.policy_id = b.policy_id
                                AND b.zone_type = '''
         || p_zone_type
         || '''
                                AND b.zone_no = '
         || p_column
         || '
                                AND b.as_of_sw = NVL('''
         || p_as_of_sw
         || ''',''N'')
                                AND b.fi_item_grp IS NOT NULL
                                AND b.user_id = p_user
                            GROUP BY  c.zone_grp, b.zone_no, b.zone_type
                            ORDER BY c.zone_grp';

      OPEN cur1 FOR v_query;

      LOOP
         FETCH cur1
            INTO
                      v_tot_cnt, v_tot_tsi, v_tot_prem, v_zone_no, v_zone_type, v_zone_grp;

         EXIT WHEN cur1%NOTFOUND;

         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir039b.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir039b.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         -- Zone Group - Zone No
         v_gipir039b.zone_grp := v_zone_grp;
         v_gipir039b.zone_no := v_zone_no;
         -- total
         v_gipir039b.tot_pol_cnt := v_tot_cnt;
         v_gipir039b.total_tsi := v_tot_tsi;
         v_gipir039b.total_prem := v_tot_prem;
         v_query2 :=
            'SELECT COUNT(DISTINCT a.line_cd||''-''||a.subline_cd||''-''||a.iss_cd||''-''||LTRIM(TO_CHAR(a.issue_yy, ''09''))||''-''||LTRIM(TO_CHAR(a.pol_seq_no, ''0000009''))||''-''||LTRIM(TO_CHAR(a.renew_no, ''09''))) policy_no
                                           , SUM(NVL(share_tsi_amt,TO_NUMBER(''0.00''))) sum_tsi
                                           , SUM(NVL(share_prem_amt,TO_NUMBER(''0.00''))) sum_prem
                                           , b.fi_item_grp
                                      FROM gipi_polbasic a,
                                           gipi_firestat_extract_dtl b,
                                           '
            || p_table
            || ' c
                                     WHERE a.policy_id = b.policy_id
                                        AND b.zone_type = '''
            || p_zone_type
            || '''
                                        AND b.zone_no = '
            || p_column
            || '
                                        AND b.as_of_sw = NVL('''
            || p_as_of_sw
            || ''',''N'')
                                        AND b.fi_item_grp IS NOT NULL
                                        AND b.user_id = p_user
                                        AND b.zone_no = '''
            || v_zone_no
            || '''
                                        AND c.zone_grp = '''
            || v_zone_grp
            || '''
                                    GROUP BY b.fi_item_grp'; 
         OPEN cur2 FOR v_query2; --change by steven from v_query to v_query22

         LOOP
            FETCH cur2 INTO   v_pol_cnt, v_sum_tsi, v_sum_prem, v_fi_item_grp;

            EXIT WHEN cur2%NOTFOUND;

            IF UPPER (v_fi_item_grp) = 'B'
            THEN
               v_gipir039b.bldg_pol_cnt := v_pol_cnt;
               v_gipir039b.bldg_tot_tsi := v_sum_tsi;
               v_gipir039b.bldg_tot_prem := v_sum_prem;
            ELSIF UPPER (v_fi_item_grp) = 'C'
            THEN
               v_gipir039b.content_pol_cnt := v_pol_cnt;
               v_gipir039b.content_tot_tsi := v_sum_tsi;
               v_gipir039b.content_tot_prem := v_sum_prem;
            ELSIF UPPER (v_fi_item_grp) = 'L'
            THEN
               v_gipir039b.loss_pol_cnt := v_pol_cnt;
               v_gipir039b.loss_tot_tsi := v_sum_tsi;
               v_gipir039b.loss_tot_prem := v_sum_prem;
            END IF;
         END LOOP;

         PIPE ROW (v_gipir039b);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 48 ---------------------------------------------------
   FUNCTION csv_gipir039d (p_starting_date    VARCHAR2,
                           p_ending_date      VARCHAR2,
                           p_user             VARCHAR2,
                           p_as_of_sw         VARCHAR2,
                           p_zone_type        VARCHAR2,
                           p_expired_as_of    VARCHAR2,
                           p_table            VARCHAR2,
                           p_column           VARCHAR2,
                           p_by_count         VARCHAR2)
      RETURN gipir039d_type
      PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;

      v_gipir039d        gipir039d_rec_type;
      cur1               ref_cursor;
      cur2               ref_cursor;
      cur3               ref_cursor;
      v_query1           VARCHAR (5000);
      v_query2           VARCHAR (5000);
      v_query3           VARCHAR (5000);
      -- query 1
      v_zone_no1         VARCHAR2 (10);
      v_occ_cd1          VARCHAR2 (3);
      v_occupancy1       VARCHAR2 (2000);
      v_per_cnt1         NUMBER;
      --query2
      v_zone_no2         VARCHAR2 (10);
      v_occ_cd2          VARCHAR2 (3);
      v_occupancy2       VARCHAR2 (2000);
      v_per_cnt2         NUMBER;
      v_fi_itm_grp       VARCHAR2 (1);
      v_tot_tsi2         NUMBER (16, 2);
      v_tot_prem2        NUMBER (16, 2);
      --query3
      v_zone_no3         VARCHAR2 (10);
      v_occ_cd3          VARCHAR2 (3);
      v_occupancy3       VARCHAR2 (2000);
      v_per_cnt3         NUMBER;
      v_desc             VARCHAR (30);
      v_tot_tsi3         NUMBER (16, 2);
      v_tot_prem3        NUMBER (16, 2);
      -- amt
      v_bldg_exposure    NUMBER (16, 2) := NULL;
      v_bldg_prem        NUMBER (16, 2) := NULL;
      v_cont_exposure    NUMBER (16, 2) := NULL;
      v_cont_prem        NUMBER (16, 2) := NULL;
      v_loss_exposure    NUMBER (16, 2) := NULL;
      v_loss_prem        NUMBER (16, 2) := NULL;
      v_ret_exposure     NUMBER (16, 2) := NULL;
      v_ret_prem         NUMBER (16, 2) := NULL;
      v_trty_exposure    NUMBER (16, 2) := NULL;
      v_trty_prem        NUMBER (16, 2) := NULL;
      v_facul_exposure   NUMBER (16, 2) := NULL;
      v_facul_prem       NUMBER (16, 2) := NULL;
   BEGIN
      v_query1 :=
         'SELECT a.zone_no, a.occupancy_cd
                            , decode(a.occupancy_cd,null,''UNKNOWN'', d.occupancy_desc) occupancy
                            , decode('''
         || p_by_count
         || ''', ''R'', COUNT(DISTINCT(c.block_id||NVL(c.risk_cd,''*''))), COUNT(DISTINCT c.item_no)) per_cnt
                        FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
         || p_table
         || ' b,  gipi_fireitem c, giis_fire_occupancy d
                            WHERE a.zone_no = b.'
         || p_column
         || '
                                AND A.zone_type = '''
         || p_zone_type
         || '''
                                AND A.as_of_sw = '''
         || p_as_of_sw
         || '''
                                AND a.fi_item_grp IS NOT NULL
                                AND main.policy_id = a.policy_id
                                AND a.policy_id = c.policy_id
                                AND a.item_no = c.item_no
                                AND a.occupancy_cd = d.occupancy_cd(+)
                                AND a.user_id = '''
         || p_user
         || '''
                            GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
                            ORDER BY a.zone_no, d.occupancy_desc';
                            
      OPEN cur1 FOR v_query1;

      LOOP
         FETCH cur1 INTO   v_zone_no1, v_occ_cd1, v_occupancy1, v_per_cnt1;

         EXIT WHEN cur1%NOTFOUND;

         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir039d.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir039d.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         -- Zone No, Occupancy, Count
         v_gipir039d.zone_no := v_zone_no1;
         v_gipir039d.occupancy := v_occupancy1;
         v_gipir039d.risk := v_per_cnt1;
         v_query2 :=
            'SELECT a.zone_no, a.occupancy_cd
                                            , decode(a.occupancy_cd,null,''UNKNOWN'', d.occupancy_desc) occupancy
                                            , decode('''
            || p_by_count
            || ''', ''R'', COUNT(DISTINCT(c.block_id||NVL(c.risk_cd,''*''))), COUNT(DISTINCT c.item_no)) per_cnt
                                            , a.fi_item_grp, SUM(a.share_tsi_amt) total_tsi, SUM(a.share_prem_amt) total_prem
                                        FROM gipi_polbasic main, gipi_firestat_extract_dtl a, '
            || p_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d
                                    WHERE a.zone_no = b. '
            || p_column
            || '
                                        AND A.zone_type = '''
            || p_zone_type
            || '''
                                        AND A.as_of_sw = '''
            || p_as_of_sw
            || '''
                                        AND a.fi_item_grp IS NOT NULL
                                        AND main.policy_id = a.policy_id
                                        AND a.policy_id = c.policy_id
                                        AND a.item_no = c.item_no
                                        AND a.occupancy_cd = d.occupancy_cd(+)
                                        AND a.user_id = '''
            || p_user
            || '''
                                        AND a.zone_no = '''
            || v_zone_no1
            || '''
                                        AND NVL(a.occupancy_cd, ''x'') = '''
            || NVL (v_occ_cd1, 'x')
            || '''
                                    GROUP BY a.zone_no, a.occupancy_cd, a.fi_item_grp, d.occupancy_desc
                                    ORDER BY a.zone_no, d.occupancy_desc';

         OPEN cur2 FOR v_query2;

         LOOP
            FETCH cur2
               INTO
                         v_zone_no2, v_occ_cd2, v_occupancy2, v_per_cnt2, v_fi_itm_grp, v_tot_tsi2, v_tot_prem2;

            EXIT WHEN cur2%NOTFOUND;

            IF v_fi_itm_grp = 'B'
            THEN
               v_bldg_exposure :=
                  NVL (v_bldg_exposure, 0) + NVL (v_tot_tsi2, 0);
               v_bldg_prem := NVL (v_bldg_prem, 0) + NVL (v_tot_prem2, 0);
            ELSIF v_fi_itm_grp = 'C'
            THEN
               v_cont_exposure :=
                  NVL (v_cont_exposure, 0) + NVL (v_tot_tsi2, 0);
               v_cont_prem := NVL (v_cont_prem, 0) + NVL (v_tot_prem2, 0);
            ELSIF v_fi_itm_grp = 'L'
            THEN
               v_loss_exposure :=
                  NVL (v_loss_exposure, 0) + NVL (v_tot_tsi2, 0);
               v_loss_prem := NVL (v_loss_prem, 0) + NVL (v_tot_prem2, 0);
            END IF;
         END LOOP;

         CLOSE cur2;

         -- Building Exposure and Premium - Content Exposure and Premium - Loss Exposure and Content Prem - Gross Exposure and Premium
         v_gipir039d.bldg_exposure := v_bldg_exposure;
         v_gipir039d.bldg_prem := v_bldg_prem;
         v_gipir039d.content_exposure := v_cont_exposure;
         v_gipir039d.content_prem := v_cont_prem;
         v_gipir039d.loss_exposure := v_loss_exposure;
         v_gipir039d.loss_prem := v_loss_prem;
         v_gipir039d.gross_exposure :=
              NVL (v_bldg_exposure, 0)
            + NVL (v_cont_exposure, 0)
            + NVL (v_loss_exposure, 0);
         v_gipir039d.gross_prem :=
              NVL (v_bldg_prem, 0)
            + NVL (v_cont_prem, 0)
            + NVL (v_loss_prem, 0);
         -- reset variables
         v_bldg_exposure := NULL;
         v_bldg_prem := NULL;
         v_cont_exposure := NULL;
         v_cont_prem := NULL;
         v_loss_exposure := NULL;
         v_loss_prem := NULL;
         v_query3 :=
            'SELECT a.zone_no, a.occupancy_cd
                                        , DECODE(a.occupancy_cd,null,''UNKNOWN'', d.occupancy_desc) occupancy
                                        , DECODE('''
            || p_by_count
            || ''', ''R'', COUNT(DISTINCT(c.block_id||NVL(c.risk_cd,''*''))), COUNT(DISTINCT c.item_no)) per_cnt
                                        , DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'') description
                                        , SUM(a.share_tsi_amt) total_tsi
                                        , SUM(a.share_prem_amt) total_prem
                                    FROM gipi_polbasic main, gipi_firestat_extract_dtl a
                                        , '
            || p_table
            || ' b,  gipi_fireitem c, giis_fire_occupancy d
                                        , giis_dist_share e
                                    WHERE a.zone_no = b. '
            || p_column
            || '
                                        AND A.zone_type = '''
            || p_zone_type
            || '''
                                        AND A.as_of_sw = '''
            || p_as_of_sw
            || '''
                                        AND a.fi_item_grp IS NOT NULL
                                        AND main.policy_id = a.policy_id
                                        AND a.policy_id = c.policy_id
                                        AND a.item_no = c.item_no
                                        AND a.occupancy_cd = d.occupancy_cd(+)
                                        AND a.share_Cd = e.share_Cd
                                        AND main.line_cd = e.line_Cd
                                        AND a.user_id = '''
            || p_user
            || '''
                                        AND a.zone_no = '''
            || v_zone_no1
            || '''
                                        AND a.occupancy_cd = '''
            || v_occ_cd1
            || '''
                                    GROUP BY a.zone_no, a.occupancy_cd, d.occupancy_desc
                                        , DECODE(a.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')
                                    ORDER BY a.zone_no, d.occupancy_desc';

         OPEN cur3 FOR v_query3;

         LOOP
            FETCH cur3
               INTO
                         v_zone_no3, v_occ_cd3, v_occupancy3, v_per_cnt3, v_desc, v_tot_tsi3, v_tot_prem3;

            EXIT WHEN cur3%NOTFOUND;

            -- Net Retemtion, Treaty, Facultative Exposure and Premium
            IF v_desc = 'RETENTION'
            THEN
               v_ret_exposure := v_tot_tsi3;
               v_ret_prem := v_tot_prem3;
            ELSIF v_desc = 'FACULTATIVE'
            THEN
               v_facul_exposure := v_tot_tsi3;
               v_facul_prem := v_tot_prem3;
            ELSIF v_desc = 'TREATY'
            THEN
               v_trty_exposure := v_tot_tsi3;
               v_trty_prem := v_tot_prem3;
            END IF;
         END LOOP;

         CLOSE cur3;

         v_gipir039d.ret_exposure := v_ret_exposure;
         v_gipir039d.ret_prem := v_ret_prem;
         v_gipir039d.facul_exposure := v_facul_exposure;
         v_gipir039d.facul_prem := v_facul_prem;
         v_gipir039d.treaty_exposure := v_trty_exposure;
         v_gipir039d.treaty_prem := v_trty_prem;
         -- reset variables
         v_ret_exposure := NULL;
         v_ret_prem := NULL;
         v_facul_exposure := NULL;
         v_facul_prem := NULL;
         v_trty_exposure := NULL;
         v_trty_prem := NULL;
         PIPE ROW (v_gipir039d);
      END LOOP;

      CLOSE cur1;

      RETURN;
   END;

   -------------------------------------------- 49 ---------------------------------------------------
   FUNCTION csv_gipir037 (p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_user             VARCHAR2,
                          p_as_of_sw         VARCHAR2,
                          p_zone_type        VARCHAR2,
                          p_expired_as_of    VARCHAR2,
                          p_table            VARCHAR2,
                          p_column           VARCHAR2)
      RETURN gipir037_type
      PIPELINED
   IS
      TYPE ref_cursor IS REF CURSOR;

      v_gipir037      gipir037_rec_type;
      cur1            ref_cursor;
      v_query1        VARCHAR2 (4000);
      v_zone_type     NUMBER;
      v_zone_grp      VARCHAR2 (50);
      v_div           VARCHAR2 (50);
      v_zone_no       VARCHAR2 (5);
      v_tot_tsi       NUMBER (18, 2);
      v_tot_prem      NUMBER (18, 2);
      cur2            ref_cursor;
      v_query2        VARCHAR2 (4000);
      v_share_desc    VARCHAR2 (100);
      v_share_tsi     NUMBER (18, 2);
      v_share_prem    NUMBER (18, 2);
      v_ret_tsi       NUMBER (18, 2) := 0;
      v_ret_prem      NUMBER (18, 2) := 0;
      v_facul_tsi     NUMBER (18, 2) := 0;
      v_facul_prem    NUMBER (18, 2) := 0;
      v_treaty_tsi    NUMBER (18, 2) := 0;
      v_treaty_prem   NUMBER (18, 2) := 0;
   BEGIN
      v_query1 :=
         'SELECT b.zone_type, c.zone_grp
                                   , DECODE(c.zone_grp, ''1'', ''Zone A'', ''Zone B'')
                                   , b.zone_no
                                   , SUM(NVL(share_tsi_amt,TO_NUMBER(''0.00''))) sum_tsi
                                   , SUM(NVL(share_prem_amt,TO_NUMBER(''0.00''))) sum_prem
                                FROM gipi_polbasic a,
                                    gipi_firestat_extract_dtl b,
                                    '
         || p_table
         || ' c
                                WHERE a.policy_id = b.policy_id
                                    AND b.zone_type = '''
         || p_zone_type
         || '''
                                    AND b.zone_no = c.'
         || p_column
         || '
                                    AND b.as_of_sw = NVL('''
         || p_as_of_sw
         || ''',''N'')
                                    AND b.share_cd IS NOT NULL
                                    AND b.user_id = p_user
                                GROUP BY  b.zone_no,b.zone_type, c.zone_grp
                                ORDER BY TO_NUMBER(b.zone_no), c.zone_grp';

      OPEN cur1 FOR v_query1;

      LOOP
         FETCH cur1
            INTO
                      v_zone_type, v_zone_grp, v_div, v_zone_no, v_tot_tsi, v_tot_prem;

         EXIT WHEN cur1%NOTFOUND;

         -- Period
         IF p_as_of_sw = 'Y'
         THEN
            v_gipir037.period := 'As of ' || p_expired_as_of;
         ELSE
            v_gipir037.period := p_starting_date || ' TO ' || p_ending_date;
         END IF;

         -- Zone Type - Zone Group - Zone No
         SELECT   rv_meaning
           INTO   v_gipir037.zone_type
           FROM   cg_ref_codes
          WHERE   UPPER (rv_domain) = 'GIPI_FIRESTAT_EXTRACT.ZONE_TYPE'
                  AND rv_low_value = TO_CHAR (v_zone_type);

         v_gipir037.division := v_div;
         v_gipir037.zone_no := v_zone_no;
         v_gipir037.gross_tsi := v_tot_tsi;
         v_gipir037.gross_prem := v_tot_prem;
         v_query2 :=
            'SELECT DECODE(b.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')
                                                , SUM(NVL(share_tsi_amt,TO_NUMBER(''0.00''))) sum_tsi
                                                , SUM(NVL(share_prem_amt,TO_NUMBER(''0.00''))) sum_prem
                                            FROM gipi_polbasic a,
                                                gipi_firestat_extract_dtl b,
                                                '
            || p_table
            || ' c
                                            WHERE a.policy_id = b.policy_id
                                                AND b.zone_type = '''
            || p_zone_type
            || '''
                                                AND b.zone_no = c.'
            || p_column
            || '
                                                AND b.as_of_sw = NVL('''
            || p_as_of_sw
            || ''',''N'')
                                                AND b.share_cd IS NOT NULL
                                                AND b.user_id = p_user
                                                AND b.zone_no = '''
            || v_zone_no
            || '''
                                                AND c.zone_grp = '''
            || v_zone_grp
            || '''
                                            GROUP BY DECODE(b.share_cd, 1, ''RETENTION'', 999, ''FACULTATIVE'', ''TREATY'')';

         OPEN cur2 FOR v_query2;

         LOOP
            FETCH cur2 INTO   v_share_desc, v_share_tsi, v_share_prem;

            EXIT WHEN cur2%NOTFOUND;

            IF v_share_desc = 'RETENTION'
            THEN
               v_ret_tsi := v_share_tsi;
               v_ret_prem := v_share_prem;
            ELSIF v_share_desc = 'FACULTATIVE'
            THEN
               v_facul_tsi := v_share_tsi;
               v_facul_prem := v_share_prem;
            ELSIF v_share_desc = 'TREATY'
            THEN
               v_treaty_tsi := v_share_tsi;
               v_treaty_prem := v_share_prem;
            END IF;
         END LOOP;

         v_gipir037.ret_tsi := v_ret_tsi;
         v_gipir037.ret_prem := v_ret_prem;
         v_gipir037.facul_tsi := v_facul_tsi;
         v_gipir037.facul_prem := v_facul_prem;
         v_gipir037.treaty_tsi := v_treaty_tsi;
         v_gipir037.treaty_prem := v_treaty_prem;
         -- reset
         v_ret_tsi := 0;
         v_ret_prem := 0;
         v_facul_tsi := 0;
         v_facul_prem := 0;
         v_treaty_tsi := 0;
         v_treaty_prem := 0;

         CLOSE cur2;

         PIPE ROW (v_gipir037);
      END LOOP;

      CLOSE cur1;

      RETURN;
   END;

   /* ** MOTOR STAT ** */
   -------------------------------------------- 50 ---------------------------------------------------
   FUNCTION csv_girir115 (p_user             VARCHAR2,
                          p_period_param     VARCHAR2,
                          p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_year             VARCHAR2)
      RETURN girir115_type
      PIPELINED
   IS
      v_girir115   girir115_rec_type;
   BEGIN
      FOR rec
      IN (SELECT   peril_stat_name,
                   subline,
                   mla_cnt,
                   outside_mla_cnt,
                   mla_prem,
                   outside_mla_prem,
                   user_id,
                   last_update
            FROM   gixx_lto_stat
           WHERE   (mla_cnt <> 0 OR outside_mla_cnt <> 0)
                   AND user_id = p_user)
      LOOP
         IF p_period_param = 'BD'
         THEN
            v_girir115.period := p_starting_date || ' TO ' || p_ending_date;
         ELSE
            v_girir115.period := 'For Year ' || p_year;
         END IF;

         v_girir115.peril_stat_name := rec.peril_stat_name;
         v_girir115.subline_type := rec.subline;
         v_girir115.mla_vehicle_cnt := rec.mla_cnt;
         v_girir115.mla_total_prem := rec.mla_prem;
         v_girir115.outside_mla_vehicle_cnt := rec.outside_mla_cnt;
         v_girir115.outside_mla_total_prem := rec.outside_mla_prem;
         PIPE ROW (v_girir115);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 51 ---------------------------------------------------
   FUNCTION csv_girir116 (p_user             VARCHAR2,
                          p_period_param     VARCHAR2,
                          p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_year             VARCHAR2)
      RETURN girir116_type
      PIPELINED
   IS
      v_girir116   girir116_rec_type;
   BEGIN
      FOR rec IN (SELECT   coverage,
                           peril_name,
                           pc_count,
                           cv_count,
                           mc_count,
                           pc_prem,
                           cv_prem,
                           mc_prem,
                           user_id,
                           last_update
                    FROM   gixx_nlto_stat
                   WHERE   user_id = p_user)
      LOOP
         IF p_period_param = 'BD'
         THEN
            v_girir116.period := p_starting_date || ' TO ' || p_ending_date;
         ELSE
            v_girir116.period := 'For Year ' || p_year;
         END IF;

         v_girir116.coverage := rec.coverage;
         v_girir116.peril_name := rec.peril_name;
         v_girir116.pc_vehicle_cnt := rec.pc_count;
         v_girir116.pc_total_prem := rec.pc_prem;
         v_girir116.cv_vehicle_cnt := rec.cv_count;
         v_girir116.cv_total_prem := rec.cv_prem;
         v_girir116.mc_vehicle_cnt := rec.mc_count;
         v_girir116.mc_total_prem := rec.mc_prem;
         PIPE ROW (v_girir116);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 52 ---------------------------------------------------
   FUNCTION csv_girir117 (p_user             VARCHAR2,
                          p_period_param     VARCHAR2,
                          p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_year             VARCHAR2)
      RETURN girir117_type
      PIPELINED
   IS
      v_girir117   girir117_rec_type;
   BEGIN
      FOR rec IN (SELECT   peril_stat_name,
                           subline,
                           mla_clm_cnt,
                           outside_mla_cnt,
                           mla_pd_claims,
                           outside_mla_pd_claims,
                           mla_losses,
                           outside_mla_losses,
                           user_id,
                           last_update
                    FROM   gixx_lto_claim_stat
                   WHERE   user_id = p_user)
      LOOP
         IF p_period_param = 'BD'
         THEN
            v_girir117.period := p_starting_date || ' TO ' || p_ending_date;
         ELSE
            v_girir117.period := 'For Year ' || p_year;
         END IF;

         v_girir117.peril_name := rec.peril_stat_name;
         v_girir117.subline_type := rec.subline;
         v_girir117.mla_claims_cnt := rec.mla_clm_cnt;
         v_girir117.mla_paid_claims := rec.mla_pd_claims;
         v_girir117.mla_os_losses := rec.mla_losses;
         v_girir117.outside_mla_claims_cnt := rec.outside_mla_cnt;
         v_girir117.outside_mla_paid_claims := rec.outside_mla_pd_claims;
         v_girir117.outside_mla_os_losses := rec.outside_mla_losses;
         PIPE ROW (v_girir117);
      END LOOP;

      RETURN;
   END;

   -------------------------------------------- 53 ---------------------------------------------------
   FUNCTION csv_girir118 (p_user             VARCHAR2,
                          p_period_param     VARCHAR2,
                          p_starting_date    VARCHAR2,
                          p_ending_date      VARCHAR2,
                          p_year             VARCHAR2)
      RETURN girir118_type
      PIPELINED
   IS
      v_girir118   girir118_rec_type;
   BEGIN
      FOR rec IN (SELECT   coverage,
                           peril_name,
                           pc_clm_count,
                           cv_clm_count,
                           mc_clm_count,
                           pc_pd_claims,
                           cv_pd_claims,
                           mc_pd_claims,
                           pc_losses,
                           cv_losses,
                           mc_losses,
                           user_id,
                           last_update
                    FROM   gixx_nlto_claim_stat
                   WHERE   user_id = p_user)
      LOOP
         IF p_period_param = 'BD'
         THEN
            v_girir118.period := p_starting_date || ' TO ' || p_ending_date;
         ELSE
            v_girir118.period := 'For Year ' || p_year;
         END IF;

         v_girir118.coverage := rec.coverage;
         v_girir118.peril_name := rec.peril_name;
         v_girir118.pc_claims_cnt := rec.pc_clm_count;
         v_girir118.pc_paid_claims := rec.pc_pd_claims;
         v_girir118.pc_os_losses := rec.pc_losses;
         v_girir118.cv_claims_cnt := rec.cv_clm_count;
         v_girir118.cv_paid_claims := rec.cv_pd_claims;
         v_girir118.cv_os_losses := rec.cv_losses;
         v_girir118.mc_claims_cnt := rec.mc_clm_count;
         v_girir118.mc_paid_claims := rec.mc_pd_claims;
         v_girir118.mc_os_losses := rec.mc_losses;
         PIPE ROW (v_girir118);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_gipir924k_old (p_from_date     VARCHAR2,
                           p_to_date       VARCHAR2,
                           p_scope         VARCHAR2,
                           p_iss_param     VARCHAR2,
                           p_param_date    VARCHAR2,
                           p_line_cd       VARCHAR2,
                           p_subline_cd    VARCHAR2,
                           p_iss_cd        VARCHAR2,
                          p_user_id GIIS_USERS.user_id%TYPE)
      RETURN gipir924k_type
      PIPELINED
   IS
      v_gipir924k        gipir924k_rec_type;
      v_rec_cnt          NUMBER := 0;
      v_commission       NUMBER (20, 2);
      v_commission_amt   NUMBER (20, 2);
      v_comm_amt         NUMBER (20, 2);
      v_intm_no          NUMBER;
      v_from_date        DATE := TO_DATE (p_from_date, 'DD-MON-RRRR');
      v_to_date          DATE := TO_DATE (p_to_date, 'DD-MON-RRRR');
   BEGIN
      FOR rec
      IN (  SELECT   a1.policy_id policy_id,
                     get_policy_no (a1.policy_id) policy_no,
                     DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd)
                        branch_cd,
                     a5.iss_name branch_name,
                     a1.line_cd,
                     a6.line_name,
                     a1.subline_cd,
                     a1.iss_cd,
                     a1.cred_branch,
                     a1.incept_date,
                     a1.expiry_date,
                     a1.issue_date,
                     a1.spld_date,
                     a1.comm_amt,
                     a1.assd_no,
                     a3.assd_name,
                     NVL (a1.tin, a1.no_tin_reason) tin,
                     DECODE (DECODE (p_scope, 4, NULL, a1.spld_date),
                             NULL, NVL (a1.total_prem, 0),
                             0)
                        prem_amt                               --, A2.PREM_AMT
                                ,
                     a2.RETENTION,
                     a2.facultative,
                     a2.ri_comm,
                     a2.ri_comm_vat,
                     a2.treaty,
                     a2.trty_ri_comm,
                     a2.trty_ri_comm_vat --, A2.VAT_AMT VAT, A2.LGT_AMT LGT, A2.DST_AMT DST, A2.FST_AMT FST, A2.PT_AMT PT, A2.OTHER_TAX_AMT OTHER
                                        ,
                     DECODE (a1.spld_date, NULL, a1.evatprem, 0) vat,
                     DECODE (a1.spld_date, NULL, a1.doc_stamps, 0) dst,
                     DECODE (a1.spld_date, NULL, a1.lgt, 0) lgt,
                     DECODE (a1.spld_date, NULL, a1.fst, 0) fst,
                     NVL (DECODE (a1.spld_date, NULL, a1.other_taxes, 0), 0)
                     + NVL (DECODE (a1.spld_date, NULL, a1.other_charges, 0),
                            0)
                        other,
                     'Premiums'
              FROM   gipi_uwreports_ext a1,
                     gipi_uwreports_dist_ext a2,
                     giis_assured a3,
                     giis_issource a5,
                     giis_line a6
             WHERE   a1.policy_id = a2.policy_id AND a1.assd_no = a3.assd_no
                     AND DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd) =
                           a5.iss_cd
                     AND a2.branch_cd = a5.iss_cd
                     AND a2.line_cd = a6.line_cd
                     AND a1.line_cd = a6.line_cd
                     AND a1.user_id = p_user_id
                     AND a1.user_id = a2.user_id
                     AND DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd) =
                           NVL (
                              p_iss_cd,
                              DECODE (p_iss_param,
                                      1, a1.cred_branch,
                                      a1.iss_cd)
                           )
                     AND a1.line_cd = NVL (p_line_cd, a1.line_cd)
                     AND a1.subline_cd = NVL (p_subline_cd, a1.subline_cd)
                     AND (   (p_scope = 1 AND a1.endt_seq_no = 0)
                          OR (p_scope = 2 AND a1.endt_seq_no <> 0)
                          OR (p_scope = 3 AND a1.pol_flag = '4')
                          OR (p_scope = 4 AND a1.pol_flag = '5')
                          OR (p_scope = 5 AND a1.pol_flag != '5'))
                     --AND (A1.ISSUE_DATE BETWEEN DECODE(P_PARAM_DATE, 1, v_from_date, A1.ISSUE_DATE) AND DECODE(P_PARAM_DATE, 1, v_to_date, A1.ISSUE_DATE))
                     --AND (A1.INCEPT_DATE BETWEEN DECODE(P_PARAM_DATE, 2, v_from_date, A1.INCEPT_DATE) AND DECODE(P_PARAM_DATE, 2, v_to_date, A1.INCEPT_DATE))
                     --AND (A1.ACCT_ENT_DATE BETWEEN DECODE(P_PARAM_DATE, 4, v_from_date, A1.ACCT_ENT_DATE) AND DECODE(P_PARAM_DATE, 4, v_to_date, A1.ACCT_ENT_DATE))
                     AND a1.from_date = v_from_date
                     AND a1.TO_DATE = v_to_date
          ORDER BY   DECODE (p_iss_param, 1, a1.cred_branch, a1.iss_cd),
                     a1.line_cd)
      LOOP
         v_gipir924k.branch_name := rec.branch_name;
         v_gipir924k.line_name := rec.line_name;
         v_gipir924k.issue_date := TO_CHAR (rec.issue_date, 'MM/DD/RRRR');
         v_gipir924k.reference_no := rec.policy_no;

         -- Invoice No.
         FOR inv
         IN (SELECT      iss_cd
                      || ' - '
                      || TO_CHAR (prem_seq_no, '099999999999')
                         invoice
               FROM   gipi_invoice
              WHERE   policy_id = rec.policy_id)
         LOOP
            v_rec_cnt := v_rec_cnt + 1;
            v_gipir924k.invoice_no := inv.invoice;
         END LOOP;

         IF v_rec_cnt > 1
         THEN
            v_gipir924k.invoice_no := 'VARIOUS';
         END IF;

         v_rec_cnt := 0;
         v_gipir924k.pol_duration :=
               TO_CHAR (rec.incept_date, 'MM/DD/RRRR')
            || ' - '
            || TO_CHAR (rec.expiry_date, 'MM/DD/RRRR');
         v_gipir924k.assureds_tin := rec.tin;
         v_gipir924k.assured_name := rec.assd_name;
         v_gipir924k.description := 'Premiums';
         v_gipir924k.prem_amt := rec.prem_amt;
         v_gipir924k.vat := rec.vat;
         v_gipir924k.lgt := rec.lgt;
         v_gipir924k.docstamps := rec.dst;
         v_gipir924k.fst := rec.fst;
         --V_GIPIR924K.PT                       := rec.pt;
         v_gipir924k.other_charges := rec.other;
         v_gipir924k.retention_prem_amt := rec.RETENTION;
         v_gipir924k.facultative_prem_amt := rec.facultative;
         v_gipir924k.facultative_ri_comm := rec.ri_comm;
         v_gipir924k.facultative_ri_comm_vat := rec.ri_comm_vat;
         v_gipir924k.treaty_prem_amt := rec.treaty;
         v_gipir924k.treaty_ri_comm := rec.trty_ri_comm;
         v_gipir924k.treaty_ri_comm_vat := rec.trty_ri_comm_vat;

         -- commission
         FOR rc
         IN (SELECT   b.intrmdry_intm_no,
                      b.iss_cd,
                      b.prem_seq_no,
                      c.ri_comm_amt,
                      c.currency_rt,
                      b.commission_amt
               FROM   gipi_comm_invoice b,
                      gipi_invoice c,
                      gipi_uwreports_ext a
              WHERE       a.policy_id = c.policy_id
                      AND b.iss_cd = c.iss_cd
                      AND b.prem_seq_no = c.prem_seq_no
                      AND a.user_id = p_user_id
                      AND DECODE (p_iss_param, 1, a.cred_branch, a.iss_cd) =
                            rec.branch_cd
                      AND a.line_cd = rec.line_cd
                      AND a.subline_cd = rec.subline_cd
                      AND a.policy_id = rec.policy_id
                      AND ( (p_scope = 5 AND a.endt_seq_no = a.endt_seq_no)
                           OR (    p_scope = 1
                               AND a.endt_seq_no = 0
                               AND a.pol_flag <> '5')
                           OR (    p_scope = 2
                               AND a.endt_seq_no > 0
                               AND a.pol_flag <> '5')
                           OR (p_scope = 3 AND a.pol_flag = '4')))
         LOOP
            v_intm_no := rc.intrmdry_intm_no;

            IF (rc.ri_comm_amt * rc.currency_rt) = 0
            THEN
               v_commission_amt := rc.commission_amt;

               --                 v_intm_no  := rc.intrmdry_intm_no;
               FOR c1
               IN (  SELECT   acct_ent_date,
                              commission_amt,
                              comm_rec_id,
                              intm_no
                       FROM   giac_new_comm_inv
                      WHERE       iss_cd = rc.iss_cd
                              AND prem_seq_no = rc.prem_seq_no
                              AND tran_flag = 'P'
                              AND NVL (delete_sw, 'N') = 'N'
                   ORDER BY   comm_rec_id DESC)
               LOOP
                  IF c1.acct_ent_date > v_to_date
                  THEN
                     FOR c2
                     IN (SELECT   commission_amt
                           FROM   giac_prev_comm_inv
                          WHERE   comm_rec_id = c1.comm_rec_id
                                  AND intm_no = c1.intm_no)
                     LOOP
                        v_commission_amt := c2.commission_amt;
                     END LOOP;
                  ELSE
                     v_commission_amt := c1.commission_amt;
                  END IF;

                  EXIT;
               END LOOP;

               v_comm_amt := NVL (v_commission_amt * rc.currency_rt, 0);
            ELSE
               v_comm_amt := rc.ri_comm_amt * rc.currency_rt;
            END IF;

            v_commission := NVL (v_commission, 0) + v_comm_amt;

            IF rec.spld_date IS NOT NULL
            THEN
               v_commission := 0;
            END IF;
         END LOOP;

         v_gipir924k.intm_comm := v_commission;
         v_commission := 0;

         FOR intm IN (SELECT   intm_name NAME
                        FROM   giis_intermediary
                       WHERE   intm_no = v_intm_no)
         LOOP
            v_gipir924k.intm_name := intm.NAME;
            EXIT;
         END LOOP;

         v_intm_no := NULL;
         PIPE ROW (v_gipir924k);
      END LOOP;

      RETURN;
   END;

   /* -------------------------------------------END jhing 12.05.2012 ------------------------------------- */
   
    --added by mikel 11.18.2013
    FUNCTION csv_gipir924k (
       p_from_date    /*VARCHAR2*/DATE, --edgar 03/03/2015
       p_to_date      /*VARCHAR2*/DATE, --edgar 03/03/2015
       p_scope        VARCHAR2,
       p_iss_param    VARCHAR2,
       p_param_date   VARCHAR2,
       p_line_cd      VARCHAR2,
       p_subline_cd   VARCHAR2,
       p_iss_cd       VARCHAR2,
       p_user_id GIIS_USERS.user_id%TYPE
    )
       RETURN gipir924k_type PIPELINED
    IS
       v_gipir924k        gipir924k_rec_type;
       v_rec_cnt          NUMBER             := 0;
       v_commission       NUMBER (20, 2);
       v_commission_amt   NUMBER (20, 2);
       v_comm_amt         NUMBER (20, 2);
       v_intm_no          NUMBER;
       v_from_date        DATE            := /*TO_DATE (p_from_date, 'DD-MON-RRRR')*/p_from_date; --edgar 03/03/2015
       v_to_date          DATE              := /*TO_DATE (p_to_date, 'DD-MON-RRRR')*/p_to_date; --edgar 03/03/2015
       v_intm_name        VARCHAR2(240); --edgar 03/03/2015
       v_count            NUMBER; --edgar 03/03/2015
    BEGIN
       FOR rec IN (SELECT a.policy_id, get_policy_no (a.policy_id) policy_no, /*a.branch_cd,*/ --commented out edgar 03/06/2015
                          DECODE (p_iss_param,
                                 1, d.cred_branch,
                                 d.iss_cd
                                ) branch_cd, --added DECODE edgar 03/06/2015
                          b.iss_name branch_name, a.line_cd, c.line_name,
                          d.subline_cd, d.iss_cd, d.cred_branch, d.incept_date,
                          d.expiry_date, d.issue_date, d.spld_date,
                          a.comm comm_amt, d.assd_no, e.assd_name,
                          NVL (d.tin, d.no_tin_reason) tin, a.prem_amt,
                          a.RETENTION, a.facultative, a.ri_comm, a.ri_comm_vat,
                          a.treaty, a.trty_ri_comm, a.trty_ri_comm_vat,
                          d.evatprem vat, d.doc_stamps dst, d.lgt, d.fst,
                          d.other_taxes + d.other_charges other, d.param_date, d.scope, d.from_date, d.to_date --added edgar 03/09/2015
                     FROM gipi_uwreports_dist_ext a,
                          giis_issource b,
                          giis_line c,
                          gipi_uwreports_ext_cons d,
                          giis_assured e,
                          gipi_polbasic f
                    WHERE 1 = 1
                      --AND a.branch_cd = b.iss_cd --edgar 03/06/2015
                      AND DECODE (p_iss_param, 1, d.cred_branch, d.iss_cd) = b.iss_cd --edgar 03/06/2015
                      AND a.line_cd = c.line_cd
                      AND a.policy_id = d.policy_id(+)
                      AND a.user_id = d.user_id (+)
                      AND a.policy_id = f.policy_id
                      AND f.assd_no = e.assd_no
                      AND a.user_id = p_user_id
                 ORDER BY DECODE (p_iss_param, 1, d.cred_branch, d.iss_cd), c.line_name) --edgar 03/03/2015
       LOOP
          v_gipir924k.branch_name := rec.branch_name;
          v_gipir924k.line_name := rec.line_name;
          v_gipir924k.issue_date := TO_CHAR (rec.issue_date, 'MM/DD/RRRR');
          v_gipir924k.reference_no := rec.policy_no;

          -- Invoice No.
          FOR inv IN (SELECT    iss_cd
                             || ' - '
                             || TO_CHAR (prem_seq_no, '099999999999') invoice
                        FROM gipi_invoice
                       WHERE policy_id = rec.policy_id)
          LOOP
             v_rec_cnt := v_rec_cnt + 1;
             v_gipir924k.invoice_no := inv.invoice;
          END LOOP;

          IF v_rec_cnt > 1
          THEN
             v_gipir924k.invoice_no := 'VARIOUS';
          END IF;

          v_rec_cnt := 0;
          v_gipir924k.pol_duration :=
                TO_CHAR (rec.incept_date, 'MM/DD/RRRR')
             || ' - '
             || TO_CHAR (rec.expiry_date, 'MM/DD/RRRR');
          v_gipir924k.assureds_tin := rec.tin;
          v_gipir924k.assured_name := rec.assd_name;
          v_gipir924k.description := 'Premiums';
          v_gipir924k.prem_amt := rec.prem_amt;
          v_gipir924k.vat := rec.vat;
          v_gipir924k.lgt := rec.lgt;
          v_gipir924k.docstamps := rec.dst;
          v_gipir924k.fst := rec.fst;
          --V_GIPIR924K.PT                       := rec.pt;
          v_gipir924k.other_charges := rec.other;
          v_gipir924k.retention_prem_amt := rec.RETENTION;
          v_gipir924k.facultative_prem_amt := rec.facultative;
          v_gipir924k.facultative_ri_comm := rec.ri_comm;
          v_gipir924k.facultative_ri_comm_vat := rec.ri_comm_vat;
          v_gipir924k.treaty_prem_amt := rec.treaty;
          v_gipir924k.treaty_ri_comm := rec.trty_ri_comm;
          v_gipir924k.treaty_ri_comm_vat := rec.trty_ri_comm_vat;
          v_gipir924k.intm_comm := rec.comm_amt;

          /*FOR intm IN (SELECT intm_name NAME
                         FROM giis_intermediary
                        WHERE intm_no = v_intm_no)
          LOOP
             v_gipir924k.intm_name := intm.NAME;
             EXIT;
          END LOOP;*/
         /*added edgar 03/03/2015*/
         BEGIN
            v_count := 0;
            FOR rc IN (SELECT DISTINCT intm_no intm_no
                         FROM TABLE (gipi_uwreports_param_pkg.get_intermediary (rec.policy_id,
                                                                                rec.scope,
                                                                                rec.param_date,
                                                                                rec.from_date,
                                                                                rec.to_date
                                                                               )
                                    ))
            LOOP 
               
                  v_intm_no := rc.intm_no;
                  v_count := v_count + 1;  
                      
                  IF v_count > 1
                  THEN
                    EXIT;
                  END IF;        
                   
                  FOR intm IN (SELECT intm_name NAME
                                 FROM giis_intermediary
                                WHERE intm_no = v_intm_no)
                  LOOP
                     v_intm_name := intm.NAME;
                     EXIT;
                  END LOOP;               
               
            END LOOP;

            IF v_count > 1
            THEN
               v_gipir924k.intm_name := 'VARIOUS';
            ELSE
               
               v_gipir924k.intm_name := v_intm_name;
            END IF;
         END;            

          v_intm_no := NULL;
          PIPE ROW (v_gipir924k);
       END LOOP;

       RETURN;
    END;
    --end mikel 11.18.2013
    
   FUNCTION csv_gipir210 (p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_issue_yy      NUMBER,
                          p_pol_seq_no    NUMBER,
                          p_renew_no      NUMBER,
                          p_e_from       VARCHAR2,     -- jhing 04.01.2016 GENQA 5306 changed all date parameter into VARCHAR2
                          p_e_to         VARCHAR2,     
                          p_a_from       VARCHAR2,
                          p_a_to         VARCHAR2,
                          p_i_from       VARCHAR2,
                          p_i_to         VARCHAR2,
                          p_f            VARCHAR2,
                          p_t            VARCHAR2,
                          p_user_id      VARCHAR2  -- jhing 04.01.2016 GENQA 5306
                          )
      RETURN gipir210_type
      PIPELINED
   IS
      v_gipir210             gipir210_rec_type;
--      v_policy_number        VARCHAR2 (50);
--      v_assd_name            giis_assured.assd_name%TYPE;
--      v_acct_of_cd           gipi_polbasic.acct_of_cd%TYPE;
--      v_acct_of_cd_sw        gipi_polbasic.acct_of_cd_sw%TYPE;
--      v_package_cd           giis_package_benefit.package_cd%TYPE;
--      v_control_cd           gipi_grouped_items.control_cd%TYPE;
--      v_endt_no              VARCHAR2 (50);
--      v_endt_yy              VARCHAR2 (50);
--      v_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE;
--      v_grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE;
--      v_eff_date             gipi_polbasic.eff_date%TYPE;
--      v_expiry_date          gipi_polbasic.expiry_date%TYPE;
--      v_tsi_amt              gipi_grouped_items.tsi_amt%TYPE;
--      v_prem_amt             gipi_grouped_items.prem_amt%TYPE;
--      v_delete_sw            VARCHAR2 (10);
      var_assd               giis_assured.assd_name%TYPE;
      TYPE v_sec_tab IS TABLE OF NUMBER index by VARCHAR2(50 );
      v_sec_tbl v_sec_tab ; 
      v_e_from       DATE :=  TO_DATE(p_e_from, 'MM-DD-RRRR') ;    
      v_e_to         DATE :=  TO_DATE(p_e_to, 'MM-DD-RRRR') ;  
      v_a_from       DATE :=  TO_DATE(p_a_from, 'MM-DD-RRRR') ;  
      v_a_to         DATE :=  TO_DATE(p_a_to, 'MM-DD-RRRR') ;  
      v_i_from       DATE :=  TO_DATE(p_i_from, 'MM-DD-RRRR') ;  
      v_i_to         DATE :=  TO_DATE(p_i_to, 'MM-DD-RRRR') ;  
      v_f            DATE :=  TO_DATE(p_f, 'MM-DD-RRRR') ;  
      v_t            DATE :=  TO_DATE(p_t, 'MM-DD-RRRR') ;       
   BEGIN
   
      -- jhing GENQA 5306 old code for the CSV - 04.01.2016
--      FOR rec
--      IN (SELECT   DISTINCT
--                      a.line_cd
--                   || '-'
--                   || a.subline_cd
--                   || '-'
--                   || a.iss_cd
--                   || '-'
--                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
--                   || '-'
--                   || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
--                   || '-'
--                   || LTRIM (TO_CHAR (a.renew_no, '09'))
--                      policy_number,
--                   a.policy_id,
--                   a.assd_no,
--                   b.assd_name,
--                   a.acct_of_cd,
--                   a.acct_of_cd_sw,
--                   a.eff_date,
--                   a.acct_ent_date,
--                   a.issue_date,
--                   a.booking_mth || ' ' || (a.booking_year) AS "BOOKING DATE"
--            FROM   gipi_polbasic a,
--                   giis_assured b,
--                   gipi_grouped_items c,
--                   giis_package_benefit d
--           WHERE       a.assd_no = b.assd_no
--                   AND a.policy_id = c.policy_id
--                   AND c.pack_ben_cd = d.pack_ben_cd
--                   AND d.package_cd IS NOT NULL
--                   AND ( (    a.line_cd = p_line_cd
--                          AND a.subline_cd = p_subline_cd
--                          AND a.iss_cd = p_iss_cd
--                          AND a.issue_yy = p_issue_yy
--                          AND a.pol_seq_no = p_pol_seq_no
--                          AND a.renew_no = p_renew_no)
--                        OR ( (a.eff_date >= p_e_from)
--                            AND (a.eff_date <= p_e_to))
--                        OR ( (a.acct_ent_date >= p_a_from)
--                            AND (a.acct_ent_date <= p_a_to))
--                        OR ( (a.issue_date >= p_i_from)
--                            AND (a.issue_date <= p_i_to))
--                        OR ( (TO_DATE (
--                                 a.booking_mth || '-' || a.booking_year,
--                                 'MM-RRRR'
--                              ) BETWEEN TO_DATE (
--                                              TO_CHAR (p_f, 'MM')
--                                           || DECODE (p_f, NULL, NULL, '-')
--                                           || TO_CHAR (p_f, 'YYYY'),
--                                           'MM-RRRR'
--                                        )
--                                    AND  TO_DATE (
--                                               TO_CHAR (p_t, 'MM')
--                                            || DECODE (p_t, NULL, NULL, '-')
--                                            || TO_CHAR (p_t, 'YYYY'),
--                                            'MM-RRRR'
--                                         )))))
--      LOOP
--         FOR i
--         IN (SELECT   d.package_cd,
--                      c.control_cd,
--                         a.endt_iss_cd
--                      || '-'
--                      || LTRIM (TO_CHAR (a.endt_yy, '09'))
--                      || '-'
--                      || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
--                         endt_no,
--                      a.endt_yy,
--                      a.endt_seq_no,
--                      c.policy_id,
--                      c.grouped_item_title,
--                      c.grouped_item_no,
--                      a.eff_date,
--                      a.expiry_date,
--                      c.tsi_amt,
--                      c.prem_amt,
--                      c.delete_sw
--               FROM   gipi_polbasic a,
--                      giis_assured b,
--                      gipi_grouped_items c,
--                      giis_package_benefit d
--              WHERE       a.assd_no = b.assd_no
--                      AND a.policy_id = c.policy_id
--                      AND c.pack_ben_cd = d.pack_ben_cd
--                      AND a.policy_id = rec.policy_id)
--         LOOP
--            v_policy_number := rec.policy_number;
--            v_assd_name := rec.assd_name;
--            v_acct_of_cd := rec.acct_of_cd;
--            v_acct_of_cd_sw := rec.acct_of_cd_sw;
--            v_package_cd := i.package_cd;
--            v_control_cd := i.control_cd;
--            v_endt_no := i.endt_no;
--            v_endt_yy := i.endt_yy;
--            v_grouped_item_title := i.grouped_item_title;
--            v_grouped_item_no := i.grouped_item_no;
--            v_eff_date := i.eff_date;
--            v_expiry_date := i.expiry_date;
--            v_tsi_amt := i.tsi_amt;
--            v_prem_amt := i.prem_amt;
--            v_delete_sw := i.delete_sw;
--
--            IF v_acct_of_cd IS NULL
--            THEN
--               v_assd_name := v_assd_name;
--            ELSE
--               IF v_acct_of_cd_sw = 'Y'
--               THEN
--                  SELECT   DISTINCT assd_name
--                    INTO   var_assd
--                    FROM   giis_assured a, gipi_polbasic b
--                   WHERE   a.assd_no = v_acct_of_cd;
--
--                  v_assd_name := v_assd_name || ' LEASED TO ' || var_assd;
--               ELSE
--                  SELECT   DISTINCT assd_name
--                    INTO   var_assd
--                    FROM   giis_assured a, gipi_polbasic b
--                   WHERE   a.assd_no = v_acct_of_cd;
--
--                  v_assd_name := v_assd_name || ' IN ACCOUNT OF ' || var_assd;
--               END IF;
--            END IF;
--
--            IF v_delete_sw = 'Y'
--            THEN
--               v_delete_sw := 'Deleted';
--            ELSE
--               v_delete_sw := 'Active';
--            END IF;
--
--            IF v_endt_yy <> '0'
--            THEN
--               v_endt_yy := v_endt_no;
--            ELSE
--               v_endt_yy := ' ';
--            END IF;
--
--            v_gipir210.policy_number := v_policy_number;
--            v_gipir210.assd_name := v_assd_name;
--            v_gipir210.package_cd := v_package_cd;
--            v_gipir210.control_cd := v_control_cd;
--            v_gipir210.grouped_item_title := v_grouped_item_title;
--            v_gipir210.endt_no := v_endt_no;
--            v_gipir210.grouped_item_no := v_grouped_item_no;
--            v_gipir210.eff_date := v_eff_date;
--            v_gipir210.expiry_date := v_expiry_date;
--            v_gipir210.tsi_amt := v_tsi_amt;
--            v_gipir210.prem_amt := v_prem_amt;
--            v_gipir210.status_flag := v_delete_sw;
--            PIPE ROW (v_gipir210);
--         END LOOP;
--      END LOOP;                       


        -- jhing 04.01.2016 new query for the CSV
      FOR i
          IN (  SELECT    a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09'))
                          policy_number,
                       a.policy_id,
                       a.assd_no,
                       b.assd_name,
                       a.acct_of_cd,
                       a.acct_of_cd_sw,
                       a.eff_date,
                       a.acct_ent_date,
                       a.issue_date,
                       a.booking_mth || ' ' || (a.booking_year) AS "BOOKING_DATE",
                       a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,                
                       a.pol_seq_no,
                       a.renew_no,
                       a.endt_iss_cd,
                       a.endt_seq_no,
                       a.endt_yy 
                  FROM gipi_polbasic a, giis_assured b
                 WHERE     a.assd_no = b.assd_no
                       AND EXISTS
                              (SELECT 1
                                 FROM gipi_grouped_items c
                                WHERE c.policy_id = a.policy_id)
                       AND (   (    a.line_cd = p_line_cd
                                AND a.subline_cd = p_subline_cd
                                AND a.iss_cd = p_iss_cd
                                AND a.issue_yy = p_issue_yy
                                AND a.pol_seq_no = p_pol_seq_no
                                AND a.renew_no = p_renew_no)
                            OR (    (TRUNC (a.eff_date) >= v_e_from)
                                AND (TRUNC (a.eff_date) <= v_e_to))
                            OR (    (TRUNC (a.acct_ent_date) >= v_a_from)
                                AND (TRUNC (a.acct_ent_date) <= v_a_to))
                            OR (    (TRUNC (a.issue_date) >= v_i_from)
                                AND (TRUNC (a.issue_date) <= v_i_to))
                            OR ( (TO_DATE (a.booking_mth || '-' || a.booking_year,
                                           'MM-RRRR') BETWEEN TO_DATE (
                                                                    TO_CHAR (v_f,
                                                                             'MM')
                                                                 || DECODE (
                                                                       v_f,
                                                                       NULL, NULL,
                                                                       '-')
                                                                 || TO_CHAR (
                                                                       v_f,
                                                                       'YYYY'),
                                                                 'MM-RRRR')
                                                          AND TO_DATE (
                                                                    TO_CHAR (v_t,
                                                                             'MM')
                                                                 || DECODE (
                                                                       v_t,
                                                                       NULL, NULL,
                                                                       '-')
                                                                 || TO_CHAR (
                                                                       v_t,
                                                                       'YYYY'),
                                                                 'MM-RRRR'))))
              ORDER BY a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,
                       a.pol_seq_no,
                       a.renew_no,
                       a.endt_seq_no)
       LOOP
          IF NOT v_sec_tbl.exists (i.line_cd || '-' || i.iss_cd ) THEN
            v_sec_tbl(i.line_cd || '-' || i.iss_cd ) := check_user_per_iss_cd2 ( i.line_cd, i.iss_cd, 'GIPIS212', p_user_id ); 
          END IF;        
        
          IF v_sec_tbl(i.line_cd || '-' || i.iss_cd ) = 1 THEN        
              v_gipir210.policy_number := i.policy_number;
              IF i.endt_seq_no = 0 THEN
                v_gipir210.endt_no := ' ';
              ELSE
                v_gipir210.endt_no:= i.endt_iss_cd  || '-'
                                       || LTRIM (TO_CHAR (i.endt_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (i.endt_seq_no, '0999999')) ; 
              END IF;             

              BEGIN
                 v_gipir210.assd_name :=  i.assd_name;
                 IF i.acct_of_cd IS NULL
                 THEN
                   
                    v_gipir210.label_tag := '  ' ;
                    v_gipir210.in_acct_leased_to := '  ' ;
                 ELSE
                    IF i.acct_of_cd_sw = 'Y'
                    THEN
                       SELECT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;
                      
                       v_gipir210.label_tag := 'LEASED TO' ;
                       v_gipir210.in_acct_leased_to := var_assd ;    
                    ELSE
                       SELECT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;

                       v_gipir210.label_tag := 'IN ACCOUNT OF' ;
                       v_gipir210.in_acct_leased_to := var_assd ;   
                    END IF;
                 END IF;
              END;

              FOR j
                 IN (SELECT d.package_cd,
                            c.control_cd,
                               a.endt_iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (a.endt_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                               endt_no,
                            a.endt_yy,
                            a.endt_seq_no,
                            c.policy_id,
                            c.grouped_item_title,
                            c.grouped_item_no,
                            TRUNC(a.eff_date) eff_date,
                            TRUNC(a.expiry_date) expiry_date,
                            NVL (c.tsi_amt, 0) tsi_amt,
                            NVL (c.prem_amt, 0) prem_amt,
                            c.delete_sw, c.item_no
                       FROM gipi_polbasic a,
                            giis_assured b,
                            gipi_grouped_items c,
                            giis_package_benefit d
                      WHERE     a.assd_no = b.assd_no
                            AND a.policy_id = c.policy_id
                            AND c.pack_ben_cd = d.pack_ben_cd(+)
                            AND a.policy_id = i.policy_id)
              LOOP
                 v_gipir210.control_code := j.control_cd;
                 v_gipir210.enrollee_name := j.grouped_item_title;
                 v_gipir210.grouped_item_no := j.grouped_item_no;
                 v_gipir210.item_no := j.item_no;
                 v_gipir210.eff_date := j.eff_date;
                 v_gipir210.expiry_date := j.expiry_date;
                 v_gipir210.tsi_amt := j.tsi_amt;
                 v_gipir210.prem_amt := j.prem_amt;

                 IF j.package_cd IS NOT NULL
                 THEN
                    v_gipir210.plan :=  j.package_cd;
                 ELSE
                    v_gipir210.plan := ' ';
                 END IF;

                 IF j.delete_sw = 'Y'
                 THEN
                    v_gipir210.status_flag := 'Deleted';
                 ELSE
                    v_gipir210.status_flag := 'Active';
                 END IF;
                 
                 PIPE ROW (v_gipir210);
              END LOOP;
         END IF;     
       END LOOP;        
       
       RETURN ; 
        
   END csv_gipir210;

   FUNCTION csv_gipir211 (p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_issue_yy      NUMBER,
                          p_pol_seq_no    NUMBER,
                          p_renew_no      NUMBER,
                          p_e_from       VARCHAR2,     -- jhing 04.06.2016 GENQA 5306 changed all date parameter into VARCHAR2
                          p_e_to         VARCHAR2,
                          p_a_from       VARCHAR2,
                          p_a_to         VARCHAR2,
                          p_i_from       VARCHAR2,
                          p_i_to         VARCHAR2,
                          p_f            VARCHAR2,
                          p_t            VARCHAR2,
                          p_user_id      VARCHAR2  -- jhing 04.01.2016 GENQA 5306
                          )
      RETURN gipir211_type
      PIPELINED
   IS
      v_gipir211             gipir211_rec_type;
      -- jhing GENQA 5306 commented out variables 04.06.2016
--      v_policy_number        VARCHAR2 (50);
--      v_assd_name            giis_assured.assd_name%TYPE;
--      v_control_cd           gipi_grouped_items.control_cd%TYPE;
--      v_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE;
--      v_package_cd           giis_package_benefit.package_cd%TYPE;
--      v_endt_no              VARCHAR2 (50);
--      v_endt_yy              VARCHAR2 (50);
--      v_item_no              NUMBER (9);
--      v_eff_date             gipi_polbasic.eff_date%TYPE;
--      v_expiry_date          gipi_polbasic.expiry_date%TYPE;
--      v_peril_sname          giis_peril.peril_sname%TYPE;
--      v_tsi_amt              gipi_grouped_items.tsi_amt%TYPE;
--      v_prem_amt             gipi_grouped_items.prem_amt%TYPE;
--      v_delete_sw            VARCHAR2 (10);
--      var_assd               giis_assured.assd_name%TYPE;
--      v_acct_of_cd           gipi_polbasic.acct_of_cd%TYPE;
--      v_acct_of_cd_sw        gipi_polbasic.acct_of_cd_sw%TYPE;
      -- jhing GENQA 5306 added variables 04.06.2016
      TYPE v_sec_tab IS TABLE OF NUMBER index by VARCHAR2(50 );
      v_sec_tbl v_sec_tab ;       
      var_assd   giis_assured.assd_name%TYPE;
      v_e_from       DATE :=  TO_DATE(p_e_from, 'MM-DD-RRRR') ;    
      v_e_to         DATE :=  TO_DATE(p_e_to, 'MM-DD-RRRR') ;  
      v_a_from       DATE :=  TO_DATE(p_a_from, 'MM-DD-RRRR') ;  
      v_a_to         DATE :=  TO_DATE(p_a_to, 'MM-DD-RRRR') ;  
      v_i_from       DATE :=  TO_DATE(p_i_from, 'MM-DD-RRRR') ;  
      v_i_to         DATE :=  TO_DATE(p_i_to, 'MM-DD-RRRR') ;  
      v_f            DATE :=  TO_DATE(p_f, 'MM-DD-RRRR') ;  
      v_t            DATE :=  TO_DATE(p_t, 'MM-DD-RRRR') ;       
   BEGIN
      -- jhing commented out and replaced with new query GENQA 5306 
--      FOR rec
--      IN (SELECT   DISTINCT
--                      a.line_cd
--                   || '-'
--                   || a.subline_cd
--                   || '-'
--                   || a.iss_cd
--                   || '-'
--                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
--                   || '-'
--                   || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
--                   || '-'
--                   || LTRIM (TO_CHAR (a.renew_no, '09'))
--                      policy_number,
--                   a.policy_id,
--                   a.assd_no,
--                   b.assd_name,
--                   a.acct_of_cd,
--                   a.acct_of_cd_sw,
--                   a.eff_date,
--                   a.acct_ent_date,
--                   a.issue_date,
--                   f.package_cd package_cd
--            FROM   gipi_polbasic a,
--                   giis_assured b,
--                   gipi_grouped_items c,
--                   gipi_itmperil_grouped d,
--                   giis_peril e,
--                   giis_package_benefit f,
--                   giis_package_benefit_dtl g
--           WHERE       a.assd_no = b.assd_no
--                   AND a.policy_id = c.policy_id
--                   AND c.policy_id = d.policy_id
--                   AND e.peril_cd = g.peril_cd
--                   AND e.line_cd = f.line_cd
--                   AND c.pack_ben_cd = f.pack_ben_cd
--                   AND f.pack_ben_cd = g.pack_ben_cd
--                   AND c.grouped_item_title IS NOT NULL
--                   AND ( (    a.line_cd = p_line_cd
--                          AND a.subline_cd = p_subline_cd
--                          AND a.iss_cd = p_iss_cd
--                          AND a.issue_yy = p_issue_yy
--                          AND a.pol_seq_no = p_pol_seq_no
--                          AND a.renew_no = p_renew_no)
--                        OR ( (a.eff_date >= p_e_from)
--                            AND (a.eff_date <= p_e_to))
--                        OR ( (a.acct_ent_date >= p_a_from)
--                            AND (a.acct_ent_date <= p_a_to))
--                        OR ( (a.issue_date >= p_i_from)
--                            AND (a.issue_date <= p_i_to))
--                        OR ( (TO_DATE (
--                                 a.booking_mth || '-' || a.booking_year,
--                                 'MM-RRRR'
--                              ) BETWEEN TO_DATE (
--                                              TO_CHAR (p_f, 'MM')
--                                           || DECODE (p_f, NULL, NULL, '-')
--                                           || TO_CHAR (p_f, 'YYYY'),
--                                           'MM-RRRR'
--                                        )
--                                    AND  TO_DATE (
--                                               TO_CHAR (p_t, 'MM')
--                                            || DECODE (p_t, NULL, NULL, '-')
--                                            || TO_CHAR (p_t, 'YYYY'),
--                                            'MM-RRRR'
--                                         )))))
--      LOOP
--         FOR i
--         IN (SELECT   DISTINCT
--                      a.policy_id,
--                      c.control_cd,
--                      c.grouped_item_title,
--                      a.endt_iss_cd,
--                      a.endt_yy,
--                      a.endt_seq_no,
--                         a.endt_iss_cd
--                      || '-'
--                      || LTRIM (TO_CHAR (a.endt_yy, '09'))
--                      || '-'
--                      || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
--                         endt_no,
--                      d.item_no,
--                      a.eff_date,
--                      a.expiry_date,
--                      e.peril_sname,
--                      d.tsi_amt,
--                      d.prem_amt,
--                      c.delete_sw
--               FROM   gipi_polbasic a,
--                      giis_assured b,
--                      gipi_grouped_items c,
--                      gipi_itmperil_grouped d,
--                      giis_peril e
--              WHERE       a.assd_no = b.assd_no
--                      AND a.policy_id = c.policy_id
--                      AND c.policy_id = d.policy_id
--                      AND c.grouped_item_no = d.grouped_item_no
--                      AND d.peril_cd = e.peril_cd
--                      AND e.line_cd = a.line_cd
--                      AND a.policy_id = rec.policy_id)
--         LOOP
--            v_policy_number := rec.policy_number;
--            v_assd_name := rec.assd_name;
--            v_control_cd := i.control_cd;
--            v_grouped_item_title := i.grouped_item_title;
--            v_package_cd := rec.package_cd;
--            v_endt_no := i.endt_no;
--            v_endt_yy := i.endt_yy;
--            v_item_no := i.item_no;
--            v_eff_date := i.eff_date;
--            v_expiry_date := i.expiry_date;
--            v_peril_sname := i.peril_sname;
--            v_tsi_amt := i.tsi_amt;
--            v_prem_amt := i.prem_amt;
--            v_delete_sw := i.delete_sw;
--            v_acct_of_cd := rec.acct_of_cd;
--            v_acct_of_cd_sw := rec.acct_of_cd_sw;
--
--            IF v_acct_of_cd IS NULL
--            THEN
--               v_assd_name := v_assd_name;
--            ELSE
--               IF v_acct_of_cd_sw = 'Y'
--               THEN
--                  SELECT   DISTINCT assd_name
--                    INTO   var_assd
--                    FROM   giis_assured a, gipi_polbasic b
--                   WHERE   a.assd_no = v_acct_of_cd;
--
--                  v_assd_name := v_assd_name || ' LEASED TO ' || var_assd;
--               ELSE
--                  SELECT   DISTINCT assd_name
--                    INTO   var_assd
--                    FROM   giis_assured a, gipi_polbasic b
--                   WHERE   a.assd_no = v_acct_of_cd;
--
--                  v_assd_name := v_assd_name || ' IN ACCOUNT OF ' || var_assd;
--               END IF;
--            END IF;
--
--            IF v_delete_sw = 'Y'
--            THEN
--               v_delete_sw := 'Deleted';
--            ELSE
--               v_delete_sw := 'Active';
--            END IF;
--
--            IF v_endt_yy <> '0'
--            THEN
--               v_endt_yy := v_endt_no;
--            ELSE
--               v_endt_yy := ' ';
--            END IF;
--
--            v_gipir211.policy_number := v_policy_number;
--            v_gipir211.assd_name := v_assd_name;
--            v_gipir211.control_cd := v_control_cd;
--            v_gipir211.grouped_item_title := v_grouped_item_title;
--            v_gipir211.package_cd := v_package_cd;
--            v_gipir211.endt_no := v_endt_no;
--            v_gipir211.item_no := v_item_no;
--            v_gipir211.eff_date := v_eff_date;
--            v_gipir211.expiry_date := v_expiry_date;
--            v_gipir211.peril_sname := v_peril_sname;
--            v_gipir211.tsi_amt := v_tsi_amt;
--            v_gipir211.prem_amt := v_prem_amt;
--            v_gipir211.delete_sw := v_delete_sw;
--            PIPE ROW (v_gipir211);
--         END LOOP;
--      END LOOP;

        -- jhing 04.01.2016 new query 
     FOR i
          IN (SELECT a.line_cd
                     || '-'
                     || a.subline_cd
                     || '-'
                     || a.iss_cd
                     || '-'
                     || LTRIM (TO_CHAR (a.issue_yy, '09'))
                     || '-'
                     || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
                     || '-'
                     || LTRIM (TO_CHAR (a.renew_no, '09'))
                        policy_number,
                     a.policy_id,
                     a.assd_no,
                     b.assd_name,
                     a.acct_of_cd,
                     a.acct_of_cd_sw,
                     TRUNC(a.eff_date) eff_date ,
                     a.acct_ent_date,
                     a.issue_date,
                     c.pack_ben_cd,
                     d.peril_cd,
                     a.line_cd,
                     a.subline_cd,
                     a.iss_cd,
                     a.endt_iss_cd,
                     a.endt_yy,
                     a.endt_seq_no,
                     c.delete_sw ,
                     c.control_cd,
                     c.grouped_item_title,
                     c.item_no,
                     c.grouped_item_no,
                     e.peril_type,
                     e.peril_sname,
                     e.peril_name,
                     d.tsi_amt,
                     d.prem_amt,
                     TRUNC(a.expiry_date) expiry_date,
                     a.endt_type 
                FROM gipi_polbasic a,
                     giis_assured b,
                     gipi_grouped_items c,
                     gipi_itmperil_grouped d,
                     giis_peril e ,
                     giis_line f
               WHERE     a.assd_no = b.assd_no
                     AND a.policy_id = c.policy_id
                     AND c.policy_id = d.policy_id
                     AND c.item_no = d.item_no
                     AND c.grouped_item_no = d.grouped_item_no
                     AND a.line_cd = f.line_cd
                     AND d.line_cd = e.line_cd
                     AND d.peril_cd = e.peril_cd
                     AND NVL(f.menu_line_cd, f.line_cd ) = 'AC'
                     AND c.grouped_item_title IS NOT NULL
                     AND (   (    a.line_cd = p_line_cd
                              AND a.subline_cd = p_subline_cd
                              AND a.iss_cd = p_iss_cd
                              AND a.issue_yy = p_issue_yy
                              AND a.pol_seq_no = p_pol_seq_no
                              AND a.renew_no = p_renew_no)
                          OR (    (TRUNC(a.eff_date) >= v_e_from)
                              AND (TRUNC(a.eff_date) <= v_e_to))
                          OR (    (TRUNC(a.acct_ent_date) >= v_a_from)
                              AND (TRUNC(a.acct_ent_date) <= v_a_to))
                          OR (    (TRUNC(a.issue_date) >= v_i_from)
                              AND (TRUNC(a.issue_date) <= v_i_to))
                          OR ( (TO_DATE (a.booking_mth || '-' || a.booking_year,
                                         'MM-RRRR') BETWEEN TO_DATE (
                                                                  TO_CHAR (v_f,
                                                                           'MM')
                                                               || DECODE (
                                                                     v_f,
                                                                     NULL, NULL,
                                                                     '-')
                                                               || TO_CHAR (
                                                                     v_f,
                                                                     'YYYY'),
                                                               'MM-RRRR')
                                                        AND TO_DATE (
                                                                  TO_CHAR (v_t,
                                                                           'MM')
                                                               || DECODE (
                                                                     v_t,
                                                                     NULL, NULL,
                                                                     '-')
                                                               || TO_CHAR (
                                                                     v_t,
                                                                     'YYYY'),
                                                               'MM-RRRR'))))
                      ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                                a.pol_seq_no, a.renew_no, c.item_no, c.grouped_item_no, a.endt_seq_no,
                                e.peril_sname, e.peril_cd   )
       LOOP
          IF NOT v_sec_tbl.exists (i.line_cd || '-' || i.iss_cd ) THEN
            v_sec_tbl(i.line_cd || '-' || i.iss_cd ) := check_user_per_iss_cd2 ( i.line_cd, i.iss_cd, 'GIPIS212', p_user_id ); 
          END IF;
          
          IF v_sec_tbl(i.line_cd || '-' || i.iss_cd ) = 1 THEN 
          
              v_gipir211.policy_number := i.policy_number;
              v_gipir211.assd_name := i.assd_name;
              v_gipir211.eff_date := i.eff_date;
              v_gipir211.expiry_date := i.expiry_date;

              IF i.pack_ben_cd IS NOT NULL
              THEN
                 FOR t
                    IN (SELECT x.package_cd
                          FROM giis_package_benefit x, giis_package_benefit_dtl y
                         WHERE     x.line_cd = i.line_cd
                               AND x.subline_cd = i.subline_cd
                               AND x.pack_ben_cd = y.pack_ben_cd
                               AND x.pack_ben_cd = i.pack_ben_cd
                               AND y.peril_cd = i.peril_cd)
                 LOOP
                    v_gipir211.plan := t.package_cd;
                    EXIT;
                 END LOOP;
              ELSE
                 v_gipir211.plan := NULL;
              END IF;

              BEGIN
                 IF i.acct_of_cd IS NULL
                 THEN
                    v_gipir211.label_tag := NULL; 
                    v_gipir211.in_acct_leased_to :=  NULL;

                 ELSE
                    IF i.acct_of_cd_sw = 'Y'
                    THEN
                       SELECT DISTINCT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;
                       v_gipir211.label_tag := 'LEASED TO'; 
                       v_gipir211.in_acct_leased_to :=  var_assd;
                    ELSE
                       SELECT DISTINCT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;
                       v_gipir211.label_tag := 'IN ACCOUNT OF'; 
                       v_gipir211.in_acct_leased_to := var_assd;
                    END IF;
                 END IF;
              END;
              
              v_gipir211.control_code := i.control_cd;
              v_gipir211.enrollee_name := i.grouped_item_title;
              v_gipir211.grouped_item_no := i.grouped_item_no;            
              v_gipir211.item_no := i.item_no;
              v_gipir211.peril_type := i.peril_type ; 
              v_gipir211.peril_sname := i.peril_sname;
              v_gipir211.peril_name := i.peril_name;  
              v_gipir211.peril_cd := i.peril_cd;              
              v_gipir211.tsi_amt := i.tsi_amt;
              v_gipir211.prem_amt := i.prem_amt;

                    
              BEGIN
                IF i.endt_yy <> '0' AND i.endt_seq_no <> '0'
                THEN
                   v_gipir211.endt_no := i.endt_iss_cd  || '-'
                                           || LTRIM (TO_CHAR (i.endt_yy, '09'))
                                           || '-'
                                           || LTRIM (TO_CHAR (i.endt_seq_no, '0999999')) ; 
                ELSE
                   v_gipir211.endt_no := '';
                END IF;
              END;            


              IF i.delete_sw = 'Y'
              THEN
                v_gipir211.status_flag := 'Deleted';
              ELSE
                v_gipir211.status_flag := 'Active';
              END IF;     
              


              PIPE ROW (v_gipir211);             

          END IF;     
       END LOOP;
       

       RETURN;
   END csv_gipir211;

   FUNCTION csv_gipir212 (p_line_cd       VARCHAR2,
                          p_subline_cd    VARCHAR2,
                          p_iss_cd        VARCHAR2,
                          p_issue_yy      NUMBER,
                          p_pol_seq_no    NUMBER,
                          p_renew_no      NUMBER,
                          p_e_from       VARCHAR2,     -- jhing 04.06.2016 GENQA 5306 changed all date parameter into VARCHAR2
                          p_e_to         VARCHAR2,
                          p_a_from       VARCHAR2,
                          p_a_to         VARCHAR2,
                          p_i_from       VARCHAR2,
                          p_i_to         VARCHAR2,
                          p_f            VARCHAR2,
                          p_t            VARCHAR2,
                          p_user_id      VARCHAR2  -- jhing 04.01.2016 GENQA 5306
                           )
      RETURN gipir212_type
      PIPELINED
   IS
         v_gipir212             gipir212_rec_type;
--      v_policy_number        VARCHAR2 (50);
--      v_assd_name            giis_assured.assd_name%TYPE;
--      v_control_cd           gipi_grouped_items.control_cd%TYPE;
--      v_grouped_item_title   gipi_grouped_items.grouped_item_title%TYPE;
--      v_package_cd           giis_package_benefit.package_cd%TYPE;
--      v_endt_no              VARCHAR2 (50);
--      v_endt_yy              VARCHAR2 (50);
--      v_grouped_item_no      gipi_grouped_items.grouped_item_no%TYPE;
--      v_eff_date             gipi_polbasic.eff_date%TYPE;
--      v_expiry_date          gipi_polbasic.expiry_date%TYPE;
--      v_tsi_amt              gipi_grouped_items.tsi_amt%TYPE;
--      v_prem_amt             gipi_grouped_items.prem_amt%TYPE;
--      v_delete_sw            VARCHAR2 (10);
      var_assd               giis_assured.assd_name%TYPE;
      v_acct_of_cd           gipi_polbasic.acct_of_cd%TYPE;
      v_acct_of_cd_sw        gipi_polbasic.acct_of_cd_sw%TYPE;
      TYPE v_sec_tab IS TABLE OF NUMBER index by VARCHAR2(50 );
      v_sec_tbl v_sec_tab ;
      v_e_from       DATE :=  TO_DATE(p_e_from, 'MM-DD-RRRR') ;    
      v_e_to         DATE :=  TO_DATE(p_e_to, 'MM-DD-RRRR') ;  
      v_a_from       DATE :=  TO_DATE(p_a_from, 'MM-DD-RRRR') ;  
      v_a_to         DATE :=  TO_DATE(p_a_to, 'MM-DD-RRRR') ;  
      v_i_from       DATE :=  TO_DATE(p_i_from, 'MM-DD-RRRR') ;  
      v_i_to         DATE :=  TO_DATE(p_i_to, 'MM-DD-RRRR') ;  
      v_f            DATE :=  TO_DATE(p_f, 'MM-DD-RRRR') ;  
      v_t            DATE :=  TO_DATE(p_t, 'MM-DD-RRRR') ;        
   BEGIN
       -- jhing 04.01.2016 commented out original query GENQA 5306
--      FOR rec
--      IN (SELECT   DISTINCT
--                      a.line_cd
--                   || '-'
--                   || a.subline_cd
--                   || '-'
--                   || a.iss_cd
--                   || '-'
--                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
--                   || '-'
--                   || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
--                   || '-'
--                   || LTRIM (TO_CHAR (a.renew_no, '09'))
--                      policy_number,
--                   a.policy_id,
--                   a.assd_no,
--                   b.assd_name,
--                   a.eff_date,
--                   a.acct_of_cd,
--                   a.acct_of_cd_sw,
--                   a.acct_ent_date,
--                   a.issue_date,
--                   c.grouped_item_no
--            FROM   gipi_polbasic a,
--                   giis_assured b,
--                   gipi_grouped_items c,
--                   giis_package_benefit d
--           WHERE       a.assd_no = b.assd_no
--                   AND a.policy_id = c.policy_id
--                   AND c.pack_ben_cd = d.pack_ben_cd
--                   AND c.grouped_item_title IS NOT NULL
--                   AND ( (    a.line_cd = p_line_cd
--                          AND a.subline_cd = p_subline_cd
--                          AND a.iss_cd = p_iss_cd
--                          AND a.issue_yy = p_issue_yy
--                          AND a.pol_seq_no = p_pol_seq_no
--                          AND a.renew_no = p_renew_no)
--                        OR ( (a.eff_date >= p_e_from)
--                            AND (a.eff_date <= p_e_to))
--                        OR ( (a.acct_ent_date >= p_a_from)
--                            AND (a.acct_ent_date <= p_a_to))
--                        OR ( (a.issue_date >= p_i_from)
--                            AND (a.issue_date <= p_i_to))
--                        OR ( (TO_DATE (
--                                 a.booking_mth || '-' || a.booking_year,
--                                 'MM-RRRR'
--                              ) BETWEEN TO_DATE (
--                                              TO_CHAR (p_f, 'MM')
--                                           || DECODE (p_f, NULL, NULL, '-')
--                                           || TO_CHAR (p_f, 'YYYY'),
--                                           'MM-RRRR'
--                                        )
--                                    AND  TO_DATE (
--                                               TO_CHAR (p_t, 'MM')
--                                            || DECODE (p_t, NULL, NULL, '-')
--                                            || TO_CHAR (p_t, 'YYYY'),
--                                            'MM-RRRR'
--                                         )))))
--      LOOP
--         FOR i
--         IN (SELECT   DISTINCT
--                      d.package_cd,
--                      c.control_cd,
--                         a.endt_iss_cd
--                      || '-'
--                      || LTRIM (TO_CHAR (a.endt_yy, '09'))
--                      || '-'
--                      || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
--                         endt_no,
--                      a.endt_iss_cd,
--                      a.endt_yy,
--                      a.endt_seq_no,
--                      c.policy_id,
--                      c.grouped_item_title,
--                      c.grouped_item_no,
--                      a.eff_date,
--                      a.expiry_date,
--                      c.tsi_amt,
--                      c.prem_amt,
--                      c.delete_sw
--               FROM   gipi_polbasic a,
--                      giis_assured b,
--                      gipi_grouped_items c,
--                      giis_package_benefit d,
--                      giis_peril e
--              WHERE       a.assd_no = b.assd_no
--                      AND a.policy_id = c.policy_id
--                      AND c.pack_ben_cd = d.pack_ben_cd
--                      AND d.line_cd = e.line_cd
--                      AND e.peril_type = 'B'
--                      AND a.policy_id = rec.policy_id
--                      AND c.grouped_item_no = rec.grouped_item_no)
--         LOOP
--            v_policy_number := rec.policy_number;
--            v_assd_name := rec.assd_name;
--            v_control_cd := i.control_cd;
--            v_grouped_item_title := i.grouped_item_title;
--            v_package_cd := i.package_cd;
--            v_endt_no := i.endt_no;
--            v_endt_yy := i.endt_yy;
--            v_grouped_item_no := i.grouped_item_no;
--            v_eff_date := i.eff_date;
--            v_expiry_date := i.expiry_date;
--            v_tsi_amt := i.tsi_amt;
--            v_prem_amt := i.prem_amt;
--            v_delete_sw := i.delete_sw;
--            v_acct_of_cd := rec.acct_of_cd;
--            v_acct_of_cd_sw := rec.acct_of_cd_sw;
--
--            IF v_acct_of_cd IS NULL
--            THEN
--               v_assd_name := v_assd_name;
--            ELSE
--               IF v_acct_of_cd_sw = 'Y'
--               THEN
--                  SELECT   DISTINCT assd_name
--                    INTO   var_assd
--                    FROM   giis_assured a, gipi_polbasic b
--                   WHERE   a.assd_no = v_acct_of_cd;
--
--                  v_assd_name := v_assd_name || ' LEASED TO ' || var_assd;
--               ELSE
--                  SELECT   DISTINCT assd_name
--                    INTO   var_assd
--                    FROM   giis_assured a, gipi_polbasic b
--                   WHERE   a.assd_no = v_acct_of_cd;
--
--                  v_assd_name := v_assd_name || ' IN ACCOUNT OF ' || var_assd;
--               END IF;
--            END IF;
--
--            IF v_delete_sw = 'Y'
--            THEN
--               v_delete_sw := 'Deleted';
--            ELSE
--               v_delete_sw := 'Active';
--            END IF;
--
--            IF v_endt_yy <> '0'
--            THEN
--               v_endt_yy := v_endt_no;
--            ELSE
--               v_endt_yy := ' ';
--            END IF;
--
--            v_gipir212.policy_number := v_policy_number;
--            v_gipir212.assd_name := v_assd_name;
--            v_gipir212.grouped_item_title := v_grouped_item_title;
--            v_gipir212.control_cd := v_control_cd;
--            v_gipir212.package_cd := v_package_cd;
--            v_gipir212.endt_no := v_endt_no;
--            v_gipir212.grouped_item_no := v_grouped_item_no;
--            v_gipir212.eff_date := v_eff_date;
--            v_gipir212.expiry_date := v_expiry_date;
--            v_gipir212.tsi_amt := v_tsi_amt;
--            v_gipir212.prem_amt := v_prem_amt;
--            v_gipir212.delete_sw := v_delete_sw;
--            PIPE ROW (v_gipir212);
--         END LOOP;
--      END LOOP;

        -- jhing 04.01.2016 new query for the CSV
      FOR i
          IN (  SELECT    a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.issue_yy, '09'))
                       || '-'
                       || TRIM (TO_CHAR (a.pol_seq_no, '099999'))
                       || '-'
                       || LTRIM (TO_CHAR (a.renew_no, '09'))
                          policy_number,
                       a.policy_id,
                       a.assd_no,
                       b.assd_name,
                       a.acct_of_cd,
                       a.acct_of_cd_sw,
                       a.eff_date,
                       a.acct_ent_date,
                       a.issue_date,
                       a.booking_mth || ' ' || (a.booking_year) AS "BOOKING_DATE",
                       a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,                
                       a.pol_seq_no,
                       a.renew_no,
                       a.endt_iss_cd,
                       a.endt_seq_no,
                       a.endt_yy 
                  FROM gipi_polbasic a, giis_assured b
                 WHERE     a.assd_no = b.assd_no
                       AND EXISTS
                              (SELECT 1
                                 FROM gipi_grouped_items c
                                WHERE c.policy_id = a.policy_id)
                       AND (   (    a.line_cd = p_line_cd
                                AND a.subline_cd = p_subline_cd
                                AND a.iss_cd = p_iss_cd
                                AND a.issue_yy = p_issue_yy
                                AND a.pol_seq_no = p_pol_seq_no
                                AND a.renew_no = p_renew_no)
                            OR (    (TRUNC (a.eff_date) >= v_e_from)
                                AND (TRUNC (a.eff_date) <= v_e_to))
                            OR (    (TRUNC (a.acct_ent_date) >= v_a_from)
                                AND (TRUNC (a.acct_ent_date) <= v_a_to))
                            OR (    (TRUNC (a.issue_date) >= v_i_from)
                                AND (TRUNC (a.issue_date) <= v_i_to))
                            OR ( (TO_DATE (a.booking_mth || '-' || a.booking_year,
                                           'MM-RRRR') BETWEEN TO_DATE (
                                                                    TO_CHAR (v_f,
                                                                             'MM')
                                                                 || DECODE (
                                                                       v_f,
                                                                       NULL, NULL,
                                                                       '-')
                                                                 || TO_CHAR (
                                                                       v_f,
                                                                       'YYYY'),
                                                                 'MM-RRRR')
                                                          AND TO_DATE (
                                                                    TO_CHAR (v_t,
                                                                             'MM')
                                                                 || DECODE (
                                                                       v_t,
                                                                       NULL, NULL,
                                                                       '-')
                                                                 || TO_CHAR (
                                                                       v_t,
                                                                       'YYYY'),
                                                                 'MM-RRRR'))))
              ORDER BY a.line_cd,
                       a.subline_cd,
                       a.iss_cd,
                       a.issue_yy,
                       a.pol_seq_no,
                       a.renew_no,
                       a.endt_seq_no)
       LOOP
          IF NOT v_sec_tbl.exists (i.line_cd || '-' || i.iss_cd ) THEN
            v_sec_tbl(i.line_cd || '-' || i.iss_cd ) := check_user_per_iss_cd2 ( i.line_cd, i.iss_cd, 'GIPIS212', p_user_id ); 
          END IF;        
        
          IF v_sec_tbl(i.line_cd || '-' || i.iss_cd ) = 1 THEN        
              v_gipir212.policy_number := i.policy_number;
              IF i.endt_seq_no = 0 THEN
                v_gipir212.endt_no := ' ';
              ELSE
                v_gipir212.endt_no:= i.endt_iss_cd  || '-'
                                       || LTRIM (TO_CHAR (i.endt_yy, '09'))
                                       || '-'
                                       || LTRIM (TO_CHAR (i.endt_seq_no, '0999999')) ; 
              END IF;             

              BEGIN
                 v_gipir212.assd_name :=  i.assd_name;
                 IF i.acct_of_cd IS NULL
                 THEN
                   
                    v_gipir212.label_tag := '  ' ;
                    v_gipir212.in_acct_leased_to := '  ' ;
                 ELSE
                    IF i.acct_of_cd_sw = 'Y'
                    THEN
                       SELECT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;
                      
                       v_gipir212.label_tag := 'LEASED TO' ;
                       v_gipir212.in_acct_leased_to := var_assd ;    
                    ELSE
                       SELECT assd_name
                         INTO var_assd
                         FROM giis_assured a
                        WHERE a.assd_no = i.acct_of_cd;

                       v_gipir212.label_tag := 'IN ACCOUNT OF' ;
                       v_gipir212.in_acct_leased_to := var_assd ;   
                    END IF;
                 END IF;
              END;

              FOR j
                 IN (SELECT d.package_cd,
                            c.control_cd,
                               a.endt_iss_cd
                            || '-'
                            || LTRIM (TO_CHAR (a.endt_yy, '09'))
                            || '-'
                            || LTRIM (TO_CHAR (a.endt_seq_no, '099999'))
                               endt_no,
                            a.endt_yy,
                            a.endt_seq_no,
                            c.policy_id,
                            c.grouped_item_title,
                            c.grouped_item_no,
                            TRUNC(a.eff_date) eff_date,
                            TRUNC(a.expiry_date) expiry_date,
                            NVL (c.tsi_amt, 0) tsi_amt,
                            NVL (c.prem_amt, 0) prem_amt,
                            c.delete_sw, c.item_no
                       FROM gipi_polbasic a,
                            giis_assured b,
                            gipi_grouped_items c,
                            giis_package_benefit d
                      WHERE     a.assd_no = b.assd_no
                            AND a.policy_id = c.policy_id
                            AND c.pack_ben_cd = d.pack_ben_cd(+)
                            AND a.policy_id = i.policy_id)
              LOOP
                 v_gipir212.control_code := j.control_cd;
                 v_gipir212.enrollee_name := j.grouped_item_title;
                 v_gipir212.grouped_item_no := j.grouped_item_no;
                 v_gipir212.item_no := j.item_no;
                 v_gipir212.eff_date := j.eff_date;
                 v_gipir212.expiry_date := j.expiry_date;
                 v_gipir212.tsi_amt := j.tsi_amt;
                 v_gipir212.prem_amt := j.prem_amt;



                 IF j.package_cd IS NOT NULL
                 THEN
                    v_gipir212.plan :=  j.package_cd;
                 ELSE
                    v_gipir212.plan := ' ';
                 END IF;

                 IF j.delete_sw = 'Y'
                 THEN
                    v_gipir212.status_flag := 'Deleted';
                 ELSE
                    v_gipir212.status_flag := 'Active';
                 END IF;
                 
                 PIPE ROW (v_gipir212);
              END LOOP;
         END IF;     
       END LOOP;        
   END csv_gipir212;
END;
/


