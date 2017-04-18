CREATE OR REPLACE PACKAGE BODY CPI.CSV_BRDRX AS
/*
** Modified by   : MAC
** Date Modified : 05/16/2013
** Modifications : Modified query of GICLR205L, GICLR205E, GICLR205LE, GICLR206L, GICLR206E, and GICLR206LE.
                   Query will be in two parts, first query is for outstanding/paid amount per grp_seq_no while
                   the second part is for the outstanding/paid amount per claim, item, peril.
                   Included CSV of GICLR208A, GICLR208B, GICLR209A, GICLR209B in the latest version of CSV_BRDRX.
                   Functions are found in PCIC database.
*/
   FUNCTION csv_giclr208a (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr208a_type PIPELINED
   IS
      v_giclr208a      giclr208a_rec_type;
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_iss_name       giis_issource.iss_name%TYPE;
      v_line_name      giis_line.line_name%TYPE;
      v_eff_date       gicl_claims.pol_eff_date%TYPE;
      v_assd_name      giis_assured.assd_name%TYPE;
      v_loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE;
      v_net_ret        NUMBER (16, 2);
      v_facultative    NUMBER (16, 2);
      v_treaty         NUMBER (16, 2);
      v_xol_treaty     NUMBER (16, 2);
   BEGIN
      /*comment out by MAC 05/21/2013
      FOR rec IN (SELECT   a.buss_source, a.iss_cd, a.line_cd, a.subline_cd,
                           a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                           TRUNC(a.clm_file_date) clm_file_date, TRUNC(a.loss_date) loss_date, a.loss_cat_cd,
                           a.intm_no,
                           SUM (  NVL (a.loss_reserve, 0)
                                - NVL (a.losses_paid, 0)
                               ) outstanding_loss
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0
                  GROUP BY a.buss_source,
                           a.iss_cd,
                           a.line_cd,
                           a.subline_cd,
                           a.claim_id,
                           a.assd_no,
                           a.claim_no,
                           a.policy_no,
                           a.clm_file_date,
                           a.loss_date,
                           a.loss_cat_cd,
                           a.intm_no
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                           DECODE (p_iss_break, 1, iss_cd, 1),
                           line_cd)*/
                           
      --modified query to include loss amount per share type by MAC 05/21/2013
      FOR rec IN (SELECT a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no,
                         TRUNC (a.clm_file_date) clm_file_date, TRUNC (a.loss_date) loss_date,
                         /*replace by loss category from Claim Item Information by MAC 10/31/2013
                         --get loss category in gicl_claims instead of the extract table since loss category in extract table is per item peril.
                         c.loss_cat_cd, */
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                         a.intm_no,
                         SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) outstanding_loss,
                         SUM (net_ret) net_ret,
                         SUM (facultative) facultative,
                         SUM (treaty) treaty,
                         SUM (xol_treaty) xol_treaty
                    FROM gicl_res_brdrx_extr a,
                         (SELECT   a.session_id, a.brdrx_record_id, a.claim_id,
                                   SUM(DECODE(b.share_type, 1, NVL(a.loss_reserve,0) - NVL(a.losses_paid,0), 0)) net_ret,
                                   SUM(DECODE(b.share_type, giacp.v('FACUL_SHARE_TYPE'), NVL(loss_reserve,0) - NVL(losses_paid,0), 0)) facultative,
                                   SUM(DECODE(b.share_type, giacp.v('TRTY_SHARE_TYPE'), NVL(loss_reserve,0) - NVL(losses_paid,0), 0)) treaty,
                                   SUM(DECODE(b.share_type, giacp.v('XOL_TRTY_SHARE_TYPE'), NVL(loss_reserve,0) - NVL(losses_paid,0), 0)) xol_treaty
                              FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                             WHERE a.line_cd = b.line_cd AND a.grp_seq_no = b.share_cd
                          GROUP BY a.session_id, a.brdrx_record_id, a.claim_id) b, gicl_claims c
                   WHERE a.session_id = b.session_id(+) -- bonok :: 1.13.2017 :: FGIC SR 23446 :: added left outer join
                     AND a.brdrx_record_id = b.brdrx_record_id(+) -- bonok :: 1.13.2017 :: FGIC SR 23446 :: added left outer join
                     AND a.claim_id = b.claim_id(+) -- bonok :: 1.13.2017 :: FGIC SR 23446 :: added left outer join
                     AND a.claim_id = c.claim_id
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     --AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0 comment out by aliza g. 03/31/2015 for SR 18809
                   GROUP BY a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         --c.loss_cat_cd, replace by loss category from Claim Item Information by MAC 10/31/2013
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                         a.intm_no
                         /*03/31/2015 added by aliza g. for SR 18809*/
                    HAVING SUM (NVL (a.loss_reserve, 0)) - SUM(NVL (a.losses_paid, 0)) > 0
                         /*END OF CODE ADDED BY ALIZA G. 03312015 FOR SR 18809*/
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                         DECODE (p_iss_break, 1, iss_cd, 1),
                         line_cd)
      LOOP
         v_net_ret := 0;
         v_facultative := 0;
         v_treaty := 0;
         v_xol_treaty := 0;

         FOR i IN (SELECT intm_name
                     FROM giis_intermediary
                    WHERE intm_no = rec.intm_no)
         LOOP
            v_intm_name := i.intm_name;
         END LOOP;

         FOR b IN (SELECT iss_name
                     FROM giis_issource
                    WHERE iss_cd = rec.iss_cd)
         LOOP
            v_iss_name := b.iss_name;
         END LOOP;

         FOR l IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = rec.line_cd)
         LOOP
            v_line_name := l.line_name;
         END LOOP;

         FOR f IN (SELECT pol_eff_date
                     FROM gicl_claims
                    WHERE claim_id = rec.claim_id)
         LOOP
            v_eff_date := f.pol_eff_date;
         END LOOP;

         FOR a IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = rec.assd_no)
         LOOP
            v_assd_name := a.assd_name;
         END LOOP;

         /*comment out by MAC 10/31/2013
         FOR c IN (SELECT loss_cat_des
                     FROM giis_loss_ctgry
                    WHERE line_cd = rec.line_cd
                      AND loss_cat_cd = rec.loss_cat_cd)
         LOOP
            v_loss_cat_des := c.loss_cat_des;
         END LOOP;*/
         
         /*comment out since it is already included in the main query by MAC 05/21/2013
         FOR i IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 1)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
         LOOP
            v_net_ret := i.outstanding_loss + v_net_ret;
         END LOOP;

         FOR i IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 3)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
         LOOP
            v_facultative := i.outstanding_loss + v_facultative;
         END LOOP;

         FOR i IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 2)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
         LOOP
            v_treaty := i.outstanding_loss + v_treaty;
         END LOOP;

         FOR i IN (SELECT (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 4)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)
         LOOP
            v_xol_treaty := i.outstanding_loss + v_xol_treaty;
         END LOOP;*/

         v_giclr208a.line_name := v_line_name;
         v_giclr208a.claim_no := rec.claim_no;
         v_giclr208a.policy_no := rec.policy_no;
         v_giclr208a.clm_file_date := rec.clm_file_date;
         v_giclr208a.eff_date := v_eff_date;
         v_giclr208a.loss_date := rec.loss_date;
         v_giclr208a.assd_name := v_assd_name;
         v_giclr208a.loss_cat_des := rec.loss_cat_des;--v_loss_cat_des; replaced by MAC 10/31/2013
         v_giclr208a.outstanding_loss := NVL (rec.outstanding_loss, 0);
         --get loss amount per share type on the main query by MAC 05/21/2013
         v_giclr208a.net_ret := rec.net_ret;
         v_giclr208a.facultative := rec.facultative;
         v_giclr208a.treaty := rec.treaty;
         v_giclr208a.xol_treaty := rec.xol_treaty;
         PIPE ROW (v_giclr208a);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_giclr208b (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr208b_type PIPELINED
   IS
      v_giclr208b      giclr208b_rec_type;
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_iss_name       giis_issource.iss_name%TYPE;
      v_line_name      giis_line.line_name%TYPE;
      v_eff_date       gicl_claims.pol_eff_date%TYPE;
      v_assd_name      giis_assured.assd_name%TYPE;
      v_loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE;
      v_net_ret        NUMBER (16, 2);
      v_facultative    NUMBER (16, 2);
      v_treaty         NUMBER (16, 2);
      v_xol_treaty     NUMBER (16, 2);
   BEGIN
      /*comment out by MAC 05/21/2013
      FOR rec IN (SELECT   a.buss_source, a.iss_cd, a.line_cd, a.subline_cd,
                           a.claim_id, a.assd_no, a.claim_no, a.policy_no,
                           a.clm_file_date, a.loss_date, a.loss_cat_cd,
                           a.intm_no,
                           SUM (  NVL (a.expense_reserve, 0)
                                - NVL (a.expenses_paid, 0)
                               ) outstanding_loss
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND (  NVL (a.expense_reserve, 0)
                            - NVL (a.expenses_paid, 0)
                           ) > 0
                  GROUP BY a.buss_source,
                           a.iss_cd,
                           a.line_cd,
                           a.subline_cd,
                           a.claim_id,
                           a.assd_no,
                           a.claim_no,
                           a.policy_no,
                           a.clm_file_date,
                           a.loss_date,
                           a.loss_cat_cd,
                           a.intm_no
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                           DECODE (p_iss_break, 1, iss_cd, 1),
                           line_cd)*/
                           
      --modified query to include expense amount per share type by MAC 05/21/2013
      FOR rec IN (SELECT a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no,
                         TRUNC (a.clm_file_date) clm_file_date, TRUNC (a.loss_date) loss_date,
                         /*replace by loss category from Claim Item Information by MAC 10/31/2013
                         --get loss category in gicl_claims instead of the extract table since loss category in extract table is per item peril.
                         c.loss_cat_cd, */
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                         a.intm_no,
                         SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_loss,
                         SUM (net_ret) net_ret,
                         SUM (facultative) facultative,
                         SUM (treaty) treaty,
                         SUM (xol_treaty) xol_treaty
                    FROM gicl_res_brdrx_extr a,
                         (SELECT   a.session_id, a.brdrx_record_id, a.claim_id,
                                   SUM(DECODE(b.share_type, 1, NVL(a.expense_reserve,0) - NVL(a.expenses_paid,0), 0)) net_ret,
                                   SUM(DECODE(b.share_type, giacp.v('FACUL_SHARE_TYPE'), NVL(expense_reserve,0) - NVL(expenses_paid,0), 0)) facultative,
                                   SUM(DECODE(b.share_type, giacp.v('TRTY_SHARE_TYPE'), NVL(expense_reserve,0) - NVL(expenses_paid,0), 0)) treaty,
                                   SUM(DECODE(b.share_type, giacp.v('XOL_TRTY_SHARE_TYPE'), NVL(expense_reserve,0) - NVL(expenses_paid,0), 0)) xol_treaty
                              FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                             WHERE a.line_cd = b.line_cd AND a.grp_seq_no = b.share_cd
                          GROUP BY a.session_id, a.brdrx_record_id, a.claim_id) b, gicl_claims c
                   WHERE a.session_id = b.session_id
                     AND a.brdrx_record_id = b.brdrx_record_id
                     AND a.claim_id = b.claim_id
                     AND a.claim_id = c.claim_id
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       --AND (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0 comment out by aliza g. 03/31/2015  for SR 18809
                   GROUP BY a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         --c.loss_cat_cd, replace by loss category from Claim Item Information by MAC 10/31/2013
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                         a.intm_no
                         /*03/31/2015 added by aliza g. for SR 18809*/
                    HAVING SUM (NVL (a.expense_reserve, 0)) - SUM(NVL (a.expenses_paid, 0)) > 0
                         /*END OF CODE ADDED BY ALIZA G. 03312015 FOR SR 18809*/
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                         DECODE (p_iss_break, 1, iss_cd, 1),
                         line_cd)
      LOOP
         v_net_ret := 0;
         v_facultative := 0;
         v_treaty := 0;
         v_xol_treaty := 0;

         FOR i IN (SELECT intm_name
                     FROM giis_intermediary
                    WHERE intm_no = rec.intm_no)
         LOOP
            v_intm_name := i.intm_name;
         END LOOP;

         FOR b IN (SELECT iss_name
                     FROM giis_issource
                    WHERE iss_cd = rec.iss_cd)
         LOOP
            v_iss_name := b.iss_name;
         END LOOP;

         FOR l IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = rec.line_cd)
         LOOP
            v_line_name := l.line_name;
         END LOOP;

         FOR f IN (SELECT pol_eff_date
                     FROM gicl_claims
                    WHERE claim_id = rec.claim_id)
         LOOP
            v_eff_date := f.pol_eff_date;
         END LOOP;

         FOR a IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = rec.assd_no)
         LOOP
            v_assd_name := a.assd_name;
         END LOOP;

         /*comment out by MAC 10/31/2013
         FOR c IN (SELECT loss_cat_des
                     FROM giis_loss_ctgry
                    WHERE line_cd = rec.line_cd
                      AND loss_cat_cd = rec.loss_cat_cd)
         LOOP
            v_loss_cat_des := c.loss_cat_des;
         END LOOP;
         */
         /*comment out since it is already included in the main query by MAC 05/21/2013
         FOR i IN (SELECT (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 1)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) > 0)
         LOOP
            v_net_ret := i.outstanding_loss + v_net_ret;
         END LOOP;

         FOR i IN (SELECT (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 3)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) > 0)
         LOOP
            v_facultative := i.outstanding_loss + v_facultative;
         END LOOP;

         FOR i IN (SELECT (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 2)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) > 0)
         LOOP
            v_treaty := i.outstanding_loss + v_treaty;
         END LOOP;

         FOR i IN (SELECT (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 4)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND (  NVL (a.expense_reserve, 0)
                           - NVL (a.expenses_paid, 0)
                          ) > 0)
         LOOP
            v_xol_treaty := i.outstanding_loss + v_xol_treaty;
         END LOOP;*/

         v_giclr208b.line_name := v_line_name;
         v_giclr208b.claim_no := rec.claim_no;
         v_giclr208b.policy_no := rec.policy_no;
         v_giclr208b.clm_file_date := rec.clm_file_date;
         v_giclr208b.eff_date := v_eff_date;
         v_giclr208b.loss_date := rec.loss_date;
         v_giclr208b.assd_name := v_assd_name;
         v_giclr208b.loss_cat_des := rec.loss_cat_des;--v_loss_cat_des; replaced by MAC 10/31/2013
         v_giclr208b.outstanding_loss := NVL (rec.outstanding_loss, 0);
         --get loss amount per share type on the main query by MAC 05/21/2013
         v_giclr208b.net_ret := rec.net_ret;
         v_giclr208b.facultative := rec.facultative;
         v_giclr208b.treaty := rec.treaty;
         v_giclr208b.xol_treaty := rec.xol_treaty;
         PIPE ROW (v_giclr208b);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_giclr209a (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr209a_type PIPELINED
   IS
      v_giclr209a      giclr209a_rec_type;
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_iss_name       giis_issource.iss_name%TYPE;
      v_line_name      giis_line.line_name%TYPE;
      v_eff_date       gicl_claims.pol_eff_date%TYPE;
      v_assd_name      giis_assured.assd_name%TYPE;
      v_loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE;
      v_net_ret        NUMBER (16, 2);
      v_facultative    NUMBER (16, 2);
      v_treaty         NUMBER (16, 2);
      v_xol_treaty     NUMBER (16, 2);
      v_tran_date      VARCHAR2 (5000); --changed from 500 Aliza G. SR 21495
      v_check_no       VARCHAR2 (10000); --changed from 1000 Aliza G. SR 21495
      v_clm_stat       VARCHAR2 (500);	--changed from 50 Aliza G. SR 21495
   BEGIN
      /*comment out by MAC 05/21/2013
      FOR rec IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                           a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                           a.claim_no, a.policy_no, a.clm_file_date,
                           a.loss_date, a.loss_cat_cd, a.intm_no,
                           a.clm_loss_id, a.pd_date_opt, a.from_date,
                           a.TO_DATE, NVL (a.losses_paid, 0) outstanding_loss
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND NVL (a.losses_paid, 0) != 0 --include cancellation payment by MAC 05/20/2013
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                           DECODE (p_iss_break, 1, iss_cd, 1),
                           line_cd)*/
                           
      --modified query to include loss amount per share type by MAC 05/21/2013
      FOR rec IN (SELECT a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no,
                         TRUNC (a.clm_file_date) clm_file_date, TRUNC (a.loss_date) loss_date,
                         /*replace by loss category from Claim Item Information by MAC 10/31/2013
                         --get loss category in gicl_claims instead of the extract table since loss category in extract table is per item peril.
                         c.loss_cat_cd, */
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                         a.intm_no, a.pd_date_opt, a.from_date, a.to_date,
                         SUM (NVL (a.losses_paid, 0)) outstanding_loss,
                         SUM (net_ret) net_ret,
                         SUM (facultative) facultative,
                         SUM (treaty) treaty,
                         SUM (xol_treaty) xol_treaty,
                         a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
                    FROM gicl_res_brdrx_extr a,
                         (SELECT   a.session_id, a.brdrx_record_id, a.claim_id,
                                   SUM(DECODE(b.share_type, 1, NVL(a.losses_paid,0), 0)) net_ret,
                                   SUM(DECODE(b.share_type, giacp.v('FACUL_SHARE_TYPE'), NVL(losses_paid,0), 0)) facultative,
                                   SUM(DECODE(b.share_type, giacp.v('TRTY_SHARE_TYPE'), NVL(losses_paid,0), 0)) treaty,
                                   SUM(DECODE(b.share_type, giacp.v('XOL_TRTY_SHARE_TYPE'), NVL(losses_paid,0), 0)) xol_treaty
                              FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                             WHERE a.line_cd = b.line_cd AND a.grp_seq_no = b.share_cd
                          GROUP BY a.session_id, a.brdrx_record_id, a.claim_id) b, gicl_claims c
                   WHERE a.session_id = b.session_id
                     AND a.brdrx_record_id = b.brdrx_record_id
                     AND a.claim_id = b.claim_id
                     AND a.claim_id = c.claim_id
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND NVL (a.losses_paid, 0) != 0
                   GROUP BY a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         --c.loss_cat_cd, replace by loss category from Claim Item Information by MAC 10/31/2013
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                         a.intm_no,
                         a.pd_date_opt,
                         a.from_date,
                         a.to_date,
                         a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                         DECODE (p_iss_break, 1, iss_cd, 1),
                         line_cd)
      LOOP
         v_tran_date := NULL;
         v_check_no := NULL;
         v_clm_stat := NULL;
         v_net_ret := 0;
         v_facultative := 0;
         v_treaty := 0;
         v_xol_treaty := 0;

         FOR i IN (SELECT intm_name
                     FROM giis_intermediary
                    WHERE intm_no = rec.intm_no)
         LOOP
            v_intm_name := i.intm_name;
         END LOOP;

         FOR b IN (SELECT iss_name
                     FROM giis_issource
                    WHERE iss_cd = rec.iss_cd)
         LOOP
            v_iss_name := b.iss_name;
         END LOOP;

         FOR l IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = rec.line_cd)
         LOOP
            v_line_name := l.line_name;
         END LOOP;

         FOR f IN (SELECT pol_eff_date
                     FROM gicl_claims
                    WHERE claim_id = rec.claim_id)
         LOOP
            v_eff_date := f.pol_eff_date;
         END LOOP;

         FOR a IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = rec.assd_no)
         LOOP
            v_assd_name := a.assd_name;
         END LOOP;

         /*comment out by MAC 10/31/2013
         FOR c IN (SELECT loss_cat_des
                     FROM giis_loss_ctgry
                    WHERE line_cd = rec.line_cd
                      AND loss_cat_cd = rec.loss_cat_cd)
         LOOP
            v_loss_cat_des := c.loss_cat_des;
         END LOOP;*/
         /*comment out since it is already included in the main query by MAC 05/21/2013
         FOR i IN (SELECT NVL (a.losses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 1)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.losses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_net_ret := i.outstanding_loss + v_net_ret;
         END LOOP;

         FOR i IN (SELECT NVL (a.losses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 3)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.losses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_facultative := i.outstanding_loss + v_facultative;
         END LOOP;

         FOR i IN (SELECT NVL (a.losses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 2)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.losses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_treaty := i.outstanding_loss + v_treaty;
         END LOOP;

         FOR i IN (SELECT NVL (a.losses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 4)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.losses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_xol_treaty := i.outstanding_loss + v_xol_treaty;
         END LOOP;

         IF SIGN (NVL (rec.outstanding_loss, 0)) < 1
         THEN
            FOR d1 IN (SELECT   TO_CHAR (a.date_paid, 'MM-DD-RRRR')
                                                                   tran_date,
                                TO_CHAR (a.cancel_date,
                                         'MM-DD-RRRR'
                                        ) cancel_date
                           FROM gicl_clm_res_hist a,
                                giac_acctrans b,
                                giac_reversals c
                          WHERE a.tran_id = c.gacc_tran_id
                            AND b.tran_id = c.reversing_tran_id
                            AND a.claim_id = rec.claim_id
                            AND a.clm_loss_id = rec.clm_loss_id
                       GROUP BY a.date_paid, a.cancel_date
                         HAVING SUM (NVL(a.losses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_tran_date IS NULL
               THEN
                  v_tran_date := d1.tran_date;
               ELSE
                  v_tran_date := d1.tran_date || '/' || v_tran_date;
               END IF;
            END LOOP;
         ELSE
            FOR d2 IN
               (SELECT   TO_CHAR (a.date_paid, 'MM-DD-RRRR') tran_date
                    FROM gicl_clm_res_hist a, giac_acctrans b
                   WHERE a.claim_id = rec.claim_id
                     AND a.clm_loss_id = rec.clm_loss_id
                     AND a.tran_id = b.tran_id
                     AND DECODE (rec.pd_date_opt,
                                 1, TRUNC (a.date_paid),
                                 2, TRUNC (b.posting_date)
                                ) BETWEEN rec.from_date AND rec.TO_DATE
                GROUP BY a.date_paid
                  HAVING SUM (NVL(a.losses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_tran_date IS NULL
               THEN
                  v_tran_date := d2.tran_date;
               ELSE
                  v_tran_date := d2.tran_date || '/' || v_tran_date;
               END IF;
            END LOOP;
         END IF;

         IF SIGN (NVL (rec.outstanding_loss, 0)) < 1
         THEN
            FOR c1 IN
               (SELECT DISTINCT    b.check_pref_suf
                                || '-'
                                || LTRIM (TO_CHAR (b.check_no, '0999999999')) check_no,
                                TO_CHAR (a.cancel_date,
                                         'MM/DD/YYYY'
                                        ) cancel_date
                           FROM gicl_clm_res_hist a,
                                giac_chk_disbursement b,
                                giac_acctrans c,
                                giac_reversals d
                          WHERE a.tran_id = b.gacc_tran_id
                            AND a.tran_id = d.gacc_tran_id
                            AND c.tran_id = d.reversing_tran_id
                            AND a.claim_id = rec.claim_id
                            AND a.clm_loss_id = rec.clm_loss_id
                       GROUP BY b.check_pref_suf, b.check_no, a.cancel_date
                         HAVING SUM (NVL(a.losses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_check_no IS NULL
               THEN
                  v_check_no :=
                         c1.check_no || '/' || 'cancelled ' || c1.cancel_date;
               ELSE
                  v_check_no :=
                        c1.check_no
                     || '/'
                     || 'cancelled '
                     || c1.cancel_date
                     || '/'
                     || v_check_no;
               END IF;
            END LOOP;
         ELSE
            FOR c2 IN
               (SELECT DISTINCT    b.check_pref_suf
                                || '-'
                                || LTRIM (TO_CHAR (b.check_no, '0999999999')) check_no
                           FROM gicl_clm_res_hist a,
                                giac_chk_disbursement b,
                                giac_disb_vouchers c,
                                giac_direct_claim_payts d,
                                giac_acctrans e
                          WHERE a.tran_id = e.tran_id
                            AND b.gacc_tran_id = c.gacc_tran_id
                            AND b.gacc_tran_id = d.gacc_tran_id(+)
                            AND b.gacc_tran_id = e.tran_id
                            AND a.claim_id = rec.claim_id
                            AND a.clm_loss_id = rec.clm_loss_id
                            AND DECODE (rec.pd_date_opt,
                                        1, TRUNC (a.date_paid),
                                        2, TRUNC (e.posting_date)
                                       ) BETWEEN rec.from_date AND rec.TO_DATE
                       GROUP BY b.check_pref_suf, b.check_no
                         HAVING SUM (NVL(a.losses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_check_no IS NULL
               THEN
                  v_check_no := c2.check_no;
               ELSE
                  v_check_no := c2.check_no || '/' || v_check_no;
               END IF;
            END LOOP;
         END IF;

         FOR f IN (SELECT a.item_stat_cd
                     FROM gicl_clm_loss_exp a,
                          gicl_item_peril b,
                          gicl_clm_res_hist c
                    WHERE a.claim_id = b.claim_id
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND a.clm_loss_id = c.clm_loss_id
                      AND a.payee_type = 'L'
                      AND a.claim_id = rec.claim_id
                      AND a.clm_loss_id = rec.clm_loss_id
                      AND b.loss_cat_cd IN (
                             SELECT loss_cat_cd
                               FROM gicl_res_brdrx_extr
                              WHERE session_id = p_session_id
                                AND claim_id = rec.claim_id
                                AND brdrx_record_id = rec.brdrx_record_id
                                AND peril_cd = a.peril_cd))
         LOOP
            IF v_clm_stat IS NULL
            THEN
               v_clm_stat := f.item_stat_cd;
            ELSE
               v_clm_stat := f.item_stat_cd || '/' || v_clm_stat;
            END IF;
         END LOOP;*/

         v_giclr209a.line_name := v_line_name;
         v_giclr209a.claim_no := rec.claim_no;
         v_giclr209a.policy_no := rec.policy_no;
         v_giclr209a.clm_file_date := rec.clm_file_date;
         v_giclr209a.eff_date := v_eff_date;
         v_giclr209a.loss_date := rec.loss_date;
         v_giclr209a.assd_name := v_assd_name;
         v_giclr209a.loss_cat_des := rec.loss_cat_des;--v_loss_cat_des; replaced by MAC 10/31/2013
         v_giclr209a.outstanding_loss := NVL (rec.outstanding_loss, 0);
         --get loss amount per share type on the main query by MAC 05/21/2013
         v_giclr209a.net_ret := rec.net_ret;
         v_giclr209a.facultative := rec.facultative;
         v_giclr209a.treaty := rec.treaty;
         v_giclr209a.xol_treaty := rec.xol_treaty;
         --display details of GICLR209 per transaction by MAC 03/28/2014
         v_giclr209a.date_paid := csv_brdrx.get_giclr209_dtl(rec.claim_id, rec.from_date, rec.to_date, rec.pd_date_opt, rec.clm_res_hist_id, 'L', 'TRAN_DATE');
         v_giclr209a.reference_no := csv_brdrx.get_giclr209_dtl(rec.claim_id, rec.from_date, rec.to_date, rec.pd_date_opt, rec.clm_res_hist_id, 'L', 'CHECK_NO');
         --v_giclr209a.clm_stat := csv_brdrx.get_giclr209_dtl(rec.claim_id, rec.from_date, rec.to_date, rec.pd_date_opt, rec.clm_res_hist_id, 'L', 'ITEM_STAT_CD');
         
         --according to SA, clm_stat should be from claim level
        SELECT b.clm_stat_desc
          INTO v_giclr209a.claim_status
          FROM gicl_claims a
              ,giis_clm_stat b
         WHERE a.claim_id = rec.claim_id
           AND b.clm_stat_cd = a.clm_stat_cd; 
         
         PIPE ROW (v_giclr209a);
      END LOOP;

      RETURN;
   END;

   FUNCTION csv_giclr209b (
      p_session_id   VARCHAR2,
      p_claim_id     VARCHAR2,
      p_intm_break   NUMBER,
      p_iss_break    NUMBER
   )
      RETURN giclr209b_type PIPELINED
   IS
      v_giclr209b      giclr209b_rec_type;
      v_intm_name      giis_intermediary.intm_name%TYPE;
      v_iss_name       giis_issource.iss_name%TYPE;
      v_line_name      giis_line.line_name%TYPE;
      v_eff_date       gicl_claims.pol_eff_date%TYPE;
      v_assd_name      giis_assured.assd_name%TYPE;
      v_loss_cat_des   giis_loss_ctgry.loss_cat_des%TYPE;
      v_net_ret        NUMBER (16, 2);
      v_facultative    NUMBER (16, 2);
      v_treaty         NUMBER (16, 2);
      v_xol_treaty     NUMBER (16, 2);
      v_tran_date      VARCHAR2 (500);
      v_check_no       VARCHAR2 (1000);
      v_clm_stat       VARCHAR2 (50);
   BEGIN
      /*comment out by MAC 05/21/2013
      FOR rec IN (SELECT   a.brdrx_record_id, a.buss_source, a.iss_cd,
                           a.line_cd, a.subline_cd, a.claim_id, a.assd_no,
                           a.claim_no, a.policy_no, a.clm_file_date,
                           a.loss_date, a.loss_cat_cd, a.intm_no,
                           a.clm_loss_id, a.pd_date_opt, a.from_date,
                           a.TO_DATE,
                           NVL (a.expenses_paid, 0) outstanding_loss
                      FROM gicl_res_brdrx_extr a
                     WHERE a.session_id = p_session_id
                       AND a.claim_id = NVL (p_claim_id, a.claim_id)
                       AND NVL (a.expenses_paid, 0) != 0 --include cancellation payment by MAC 05/20/2013
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                           DECODE (p_iss_break, 1, iss_cd, 1),
                           line_cd)*/
      
      --modified query to include loss amount per share type by MAC 05/21/2013            
      FOR rec IN (SELECT a.buss_source, a.iss_cd, a.line_cd, a.subline_cd, a.claim_id,
                         a.assd_no, a.claim_no, a.policy_no,
                         TRUNC (a.clm_file_date) clm_file_date, TRUNC (a.loss_date) loss_date,
                         /*replace by loss category from Claim Item Information by MAC 10/31/2013
                         --get loss category in gicl_claims instead of the extract table since loss category in extract table is per item peril.
                         c.loss_cat_cd, */
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                         a.intm_no, a.pd_date_opt, a.from_date, a.to_date,
                         SUM (NVL (a.expenses_paid, 0)) outstanding_loss,
                         SUM (net_ret) net_ret,
                         SUM (facultative) facultative,
                         SUM (treaty) treaty,
                         SUM (xol_treaty) xol_treaty,
                         a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
                    FROM gicl_res_brdrx_extr a,
                         (SELECT   a.session_id, a.brdrx_record_id, a.claim_id,
                                   SUM(DECODE(b.share_type, 1, NVL(a.expenses_paid,0), 0)) net_ret,
                                   SUM(DECODE(b.share_type, giacp.v('FACUL_SHARE_TYPE'), NVL(expenses_paid,0), 0)) facultative,
                                   SUM(DECODE(b.share_type, giacp.v('TRTY_SHARE_TYPE'), NVL(expenses_paid,0), 0)) treaty,
                                   SUM(DECODE(b.share_type, giacp.v('XOL_TRTY_SHARE_TYPE'), NVL(expenses_paid,0), 0)) xol_treaty
                              FROM gicl_res_brdrx_ds_extr a, giis_dist_share b
                             WHERE a.line_cd = b.line_cd AND a.grp_seq_no = b.share_cd
                          GROUP BY a.session_id, a.brdrx_record_id, a.claim_id) b, gicl_claims c
                   WHERE a.session_id = b.session_id
                     AND a.brdrx_record_id = b.brdrx_record_id
                     AND a.claim_id = b.claim_id
                     AND a.claim_id = c.claim_id
                     AND a.session_id = p_session_id
                     AND a.claim_id = NVL (p_claim_id, a.claim_id)
                     AND NVL (a.expenses_paid, 0) != 0
                   GROUP BY a.buss_source,
                         a.iss_cd,
                         a.line_cd,
                         a.subline_cd,
                         a.claim_id,
                         a.assd_no,
                         a.claim_no,
                         a.policy_no,
                         a.clm_file_date,
                         a.loss_date,
                         --c.loss_cat_cd, replace by loss category from Claim Item Information by MAC 10/31/2013
                         csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                         a.intm_no,
                         a.pd_date_opt, 
                         a.from_date, 
                         a.to_date,
                         a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
                  ORDER BY DECODE (p_intm_break, 1, intm_no, 1),
                         DECODE (p_iss_break, 1, iss_cd, 1),
                         line_cd)                     
      LOOP
         v_tran_date := NULL;
         v_check_no := NULL;
         v_clm_stat := NULL;
         v_net_ret := 0;
         v_facultative := 0;
         v_treaty := 0;
         v_xol_treaty := 0;

         FOR i IN (SELECT intm_name
                     FROM giis_intermediary
                    WHERE intm_no = rec.intm_no)
         LOOP
            v_intm_name := i.intm_name;
         END LOOP;

         FOR b IN (SELECT iss_name
                     FROM giis_issource
                    WHERE iss_cd = rec.iss_cd)
         LOOP
            v_iss_name := b.iss_name;
         END LOOP;

         FOR l IN (SELECT line_name
                     FROM giis_line
                    WHERE line_cd = rec.line_cd)
         LOOP
            v_line_name := l.line_name;
         END LOOP;

         FOR f IN (SELECT pol_eff_date
                     FROM gicl_claims
                    WHERE claim_id = rec.claim_id)
         LOOP
            v_eff_date := f.pol_eff_date;
         END LOOP;

         FOR a IN (SELECT assd_name
                     FROM giis_assured
                    WHERE assd_no = rec.assd_no)
         LOOP
            v_assd_name := a.assd_name;
         END LOOP;
         /*comment out by MAC 10/31/2013
         FOR c IN (SELECT loss_cat_des
                     FROM giis_loss_ctgry
                    WHERE line_cd = rec.line_cd
                      AND loss_cat_cd = rec.loss_cat_cd)
         LOOP
            v_loss_cat_des := c.loss_cat_des;
         END LOOP;*/
         /*comment out since it is already included in the main query by MAC 05/21/2013
         FOR i IN (SELECT NVL (a.expenses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 1)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.expenses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_net_ret := i.outstanding_loss + v_net_ret;
         END LOOP;

         FOR i IN (SELECT NVL (a.expenses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 3)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.expenses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_facultative := i.outstanding_loss + v_facultative;
         END LOOP;

         FOR i IN (SELECT NVL (a.expenses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 2)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.expenses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_treaty := i.outstanding_loss + v_treaty;
         END LOOP;

         FOR i IN (SELECT NVL (a.expenses_paid, 0) outstanding_loss
                     FROM gicl_res_brdrx_ds_extr a
                    WHERE a.session_id = p_session_id
                      AND a.loss_cat_cd = rec.loss_cat_cd
                      AND a.brdrx_record_id = rec.brdrx_record_id
                      AND a.grp_seq_no IN (
                             SELECT a.share_cd
                               FROM giis_dist_share a
                              WHERE a.line_cd = rec.line_cd
                                AND a.share_type = 4)
                      AND a.claim_id = NVL (rec.claim_id, a.claim_id)
                      AND NVL (a.expenses_paid, 0) != 0) --include cancellation payment by MAC 05/20/2013
         LOOP
            v_xol_treaty := i.outstanding_loss + v_xol_treaty;
         END LOOP;

         IF SIGN (NVL (rec.outstanding_loss, 0)) < 1
         THEN
            FOR d1 IN (SELECT   TO_CHAR (a.date_paid, 'MM-DD-RRRR')
                                                                   tran_date,
                                TO_CHAR (a.cancel_date,
                                         'MM-DD-RRRR'
                                        ) cancel_date
                           FROM gicl_clm_res_hist a,
                                giac_acctrans b,
                                giac_reversals c
                          WHERE a.tran_id = c.gacc_tran_id
                            AND b.tran_id = c.reversing_tran_id
                            AND a.claim_id = rec.claim_id
                            AND a.clm_loss_id = rec.clm_loss_id
                       GROUP BY a.date_paid, a.cancel_date
                         HAVING SUM (NVL (a.expenses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_tran_date IS NULL
               THEN
                  v_tran_date := d1.tran_date;
               ELSE
                  v_tran_date := d1.tran_date || '/' || v_tran_date;
               END IF;
            END LOOP;
         ELSE
            FOR d2 IN
               (SELECT   TO_CHAR (a.date_paid, 'MM-DD-RRRR') tran_date
                    FROM gicl_clm_res_hist a, giac_acctrans b
                   WHERE a.claim_id = rec.claim_id
                     AND a.clm_loss_id = rec.clm_loss_id
                     AND a.tran_id = b.tran_id
                     AND DECODE (rec.pd_date_opt,
                                 1, TRUNC (a.date_paid),
                                 2, TRUNC (b.posting_date)
                                ) BETWEEN rec.from_date AND rec.TO_DATE
                GROUP BY a.date_paid
                  HAVING SUM (NVL (a.expenses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_tran_date IS NULL
               THEN
                  v_tran_date := d2.tran_date;
               ELSE
                  v_tran_date := d2.tran_date || '/' || v_tran_date;
               END IF;
            END LOOP;
         END IF;

         IF SIGN (NVL (rec.outstanding_loss, 0)) < 1
         THEN
            FOR c1 IN
               (SELECT DISTINCT    b.check_pref_suf
                                || '-'
                                || LTRIM (TO_CHAR (b.check_no, '0999999999'))
                                                                    check_no,
                                TO_CHAR (a.cancel_date,
                                         'MM/DD/YYYY'
                                        ) cancel_date
                           FROM gicl_clm_res_hist a,
                                giac_chk_disbursement b,
                                giac_acctrans c,
                                giac_reversals d
                          WHERE a.tran_id = b.gacc_tran_id
                            AND a.tran_id = d.gacc_tran_id
                            AND c.tran_id = d.reversing_tran_id
                            AND a.claim_id = rec.claim_id
                            AND a.clm_loss_id = rec.clm_loss_id
                       GROUP BY b.check_pref_suf, b.check_no, a.cancel_date
                         HAVING SUM (NVL (a.expenses_paid, 0)) != 0) --include cancellation payment by MAC 05/20/2013
            LOOP
               IF v_check_no IS NULL
               THEN
                  v_check_no :=
                         c1.check_no || '/' || 'cancelled ' || c1.cancel_date;
               ELSE
                  v_check_no :=
                        c1.check_no
                     || '/'
                     || 'cancelled '
                     || c1.cancel_date
                     || '/'
                     || v_check_no;
               END IF;
            END LOOP;
         ELSE
            FOR c2 IN
               (SELECT DISTINCT    b.check_pref_suf
                                || '-'
                                || LTRIM (TO_CHAR (b.check_no, '0999999999'))
                                                                    check_no
                           FROM gicl_clm_res_hist a,
                                giac_chk_disbursement b,
                                giac_disb_vouchers c,
                                giac_direct_claim_payts d,
                                giac_acctrans e
                          WHERE a.tran_id = e.tran_id
                            AND b.gacc_tran_id = c.gacc_tran_id
                            AND b.gacc_tran_id = d.gacc_tran_id(+)
                            AND b.gacc_tran_id = e.tran_id
                            AND a.claim_id = rec.claim_id
                            AND a.clm_loss_id = rec.clm_loss_id
                            AND DECODE (rec.pd_date_opt,
                                        1, TRUNC (a.date_paid),
                                        2, TRUNC (e.posting_date)
                                       ) BETWEEN rec.from_date AND rec.TO_DATE
                       GROUP BY b.check_pref_suf, b.check_no
                         HAVING SUM (a.expenses_paid) > 0)
            LOOP
               IF v_check_no IS NULL
               THEN
                  v_check_no := c2.check_no;
               ELSE
                  v_check_no := c2.check_no || '/' || v_check_no;
               END IF;
            END LOOP;
         END IF;

         FOR f IN (SELECT a.item_stat_cd
                     FROM gicl_clm_loss_exp a,
                          gicl_item_peril b,
                          gicl_clm_res_hist c
                    WHERE a.claim_id = b.claim_id
                      AND a.item_no = b.item_no
                      AND a.peril_cd = b.peril_cd
                      AND a.claim_id = c.claim_id
                      AND a.clm_loss_id = c.clm_loss_id
                      AND a.payee_type = 'E'
                      AND a.claim_id = rec.claim_id
                      AND a.clm_loss_id = rec.clm_loss_id
                      AND b.loss_cat_cd IN (
                             SELECT loss_cat_cd
                               FROM gicl_res_brdrx_extr
                              WHERE session_id = p_session_id
                                AND claim_id = rec.claim_id
                                AND brdrx_record_id = rec.brdrx_record_id
                                AND peril_cd = a.peril_cd))
         LOOP
            IF v_clm_stat IS NULL
            THEN
               v_clm_stat := f.item_stat_cd;
            ELSE
               v_clm_stat := f.item_stat_cd || '/' || v_clm_stat;
            END IF;
         END LOOP;*/

         v_giclr209b.line_name := v_line_name;
         v_giclr209b.claim_no := rec.claim_no;
         v_giclr209b.policy_no := rec.policy_no;
         v_giclr209b.clm_file_date := rec.clm_file_date;
         v_giclr209b.eff_date := v_eff_date;
         v_giclr209b.loss_date := rec.loss_date;
         v_giclr209b.assd_name := v_assd_name;
         v_giclr209b.loss_cat_des := rec.loss_cat_des;--v_loss_cat_des; replaced by MAC 10/31/2013
         v_giclr209b.outstanding_loss := NVL (rec.outstanding_loss, 0);
         --get loss amount per share type on the main query by MAC 05/21/2013
         v_giclr209b.net_ret := rec.net_ret;
         v_giclr209b.facultative := rec.facultative;
         v_giclr209b.treaty := rec.treaty;
         v_giclr209b.xol_treaty := rec.xol_treaty;
         --display details of GICLR209 per transaction by MAC 03/28/2014
         v_giclr209b.tran_date := csv_brdrx.get_giclr209_dtl(rec.claim_id, rec.from_date, rec.to_date, rec.pd_date_opt, rec.clm_res_hist_id, 'E', 'TRAN_DATE');
         v_giclr209b.check_no := csv_brdrx.get_giclr209_dtl(rec.claim_id, rec.from_date, rec.to_date, rec.pd_date_opt, rec.clm_res_hist_id, 'E', 'CHECK_NO');
         v_giclr209b.clm_stat := csv_brdrx.get_giclr209_dtl(rec.claim_id, rec.from_date, rec.to_date, rec.pd_date_opt, rec.clm_res_hist_id, 'E', 'ITEM_STAT_CD');
         PIPE ROW (v_giclr209b);
      END LOOP;

      RETURN;
   END;
  FUNCTION CSV_GICLR205E(p_session_id    VARCHAR2,
                 p_claim_id      VARCHAR2,
                 p_intm_break    NUMBER) RETURN giclr205e_type PIPELINED
  IS
   v_giclr205e          giclr205e_rec_type;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);--GICL_CLM_ITEM.ITEM_TITLE%TYPE; Modified by Marlo 01282010
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
  BEGIN
  /* comment out by MAC 02/05/2013
  FOR rec IN(SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.GROUPED_ITEM_NO,
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     NVL(C.GRP_SEQ_NO,0) GRP_SEQ_NO, -- Added by Marlo 01282010
                    (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS,
     (NVL(C.EXPENSE_RESERVE, 0) - NVL(C.EXPENSES_PAID, 0)) DISTRIBUTION_LOSS -- Added by Marlo 01282010
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C -- Added by Marlo 01282010
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = NVL(P_SESSION_ID,A.SESSION_ID)
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01282010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01282010
    /* Added by Marlo
    ** 01282010 
   UNION
     SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.GROUPED_ITEM_NO, --EMCY da042506te
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     0 GRP_SEQ_NO,
                    (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_LOSS,
        0 DISTRIBUTION_LOSS
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
  FOR rec IN (--query to get distribution amount per grp_seq_no by MAC 02/05/2013
     SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 outstanding_loss,
                SUM (NVL (c.expense_reserve, 0) - NVL (c.expenses_paid, 0)) distribution_loss
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c 
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = NVL (p_session_id, a.session_id)
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id 
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                NVL (c.grp_seq_no, 0)
         HAVING SUM (NVL (c.expense_reserve, 0) - NVL (c.expenses_paid, 0)) > 0
  UNION
     --created a select to get only the outstanding loss and expense by MAC 02/05/2013
     SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, 0 grp_seq_no,
                SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_loss,
                0 distribution_loss
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no
         HAVING SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0)
 LOOP
     --RCD 08/31/2012
         --added condition to display NULL when user extracted the record without tagging the "Per Business Source"
         --checkbox but printed the report with tag on "Per Business Source"
         IF rec.buss_source_type IS NULL
         THEN
            v_source_type_desc := NULL;
         ELSE
            --get BUSS_SOURCE_NAME
            BEGIN
               SELECT intm_desc
                 INTO v_source_type_desc
                 FROM giis_intm_type
                WHERE intm_type = rec.buss_source_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_source_type_desc := 'REINSURER ';
               WHEN OTHERS
               THEN
                  v_source_type_desc := NULL;
            END;
         END IF;

    --get SOURCE_NAME
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    --get ISS_NAME
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    --get LINE_NAME
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    --get SUBLINE_NAME
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;    
               END IF;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
      END IF;
    END IF;

   v_giclr205e.buss_source_name := v_source_type_desc;
   v_giclr205e.source_name      := v_source_name;
   v_giclr205e.iss_name         := v_iss_name;
   v_giclr205e.line_name        := v_line_name;
   v_giclr205e.subline_name     := v_subline_name;
   v_giclr205e.loss_year        := rec.loss_year;
   v_giclr205e.claim_no         := rec.claim_no;
   v_giclr205e.policy_no        := v_policy;
   v_giclr205e.assd_name        := v_assd_name;
   v_giclr205e.incept_date      := rec.incept_date;
   v_giclr205e.expiry_date      := rec.expiry_date;
   v_giclr205e.loss_date        := rec.loss_date;
   v_giclr205e.item_title       := v_item_title;
   v_giclr205e.tsi_amt          := rec.tsi_amt;
   v_giclr205e.peril_name       := v_peril_name;
   v_giclr205e.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
   v_giclr205e.INTERMEDIARY     := v_intm_ri;
   v_giclr205e.outstanding_loss := rec.outstanding_loss;
   -- Added by Marlo 01282010
   v_giclr205e.claim_id         := rec.claim_id;
   v_giclr205e.item_no          := rec.item_no;
   v_giclr205e.peril_cd         := rec.peril_cd;
   v_giclr205e.grp_seq_no       := rec.grp_seq_no;
   v_giclr205e.line_cd          := rec.line_cd;
   v_giclr205e.ds_loss          := rec.distribution_loss;

   PIPE ROW(v_giclr205e);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
  END;
-----------------------------------------------------------------------
  FUNCTION CSV_GICLR205LE(p_session_id    VARCHAR2,
                   p_claim_id      VARCHAR2,
                   p_intm_break    NUMBER) RETURN giclr205le_type PIPELINED
  IS
   v_giclr205le         giclr205le_rec_type;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);--GICL_CLM_ITEM.ITEM_TITLE%TYPE; Modified by Marlo 01282010
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
  BEGIN
  /*
  comment out and replaced by MAC 02/01/2013
  FOR rec IN(SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.GROUPED_ITEM_NO, --EMCY da042506te
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     NVL(C.GRP_SEQ_NO,0) GRP_SEQ_NO, -- Added by Marlo 01282010
                   (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS,
                    (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_EXPENSE,
     (NVL(C.LOSS_RESERVE, 0) - NVL(C.LOSSES_PAID, 0)) DISTRIBUTION_LOSS, -- Added by Marlo 01282010
     (NVL(C.EXPENSE_RESERVE, 0) - NVL(C.EXPENSES_PAID, 0)) DISTRIBUTION_EXPENSE -- Added by Marlo 01282010
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C -- Added by Marlo 01282010
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01282010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01282010
              UNION
             SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.GROUPED_ITEM_NO,
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     NVL(C.GRP_SEQ_NO,0) GRP_SEQ_NO, -- Added by Marlo 01282010
                   (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS,
                    (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_EXPENSE,
                   (NVL(C.LOSS_RESERVE,0) - NVL(C.LOSSES_PAID,0)) DISTRIBUTION_LOSS, -- Added by Marlo 01282010
     (NVL(C.EXPENSE_RESERVE,0) - NVL(C.EXPENSES_PAID,0)) DISTRIBUTION_EXPENSE--Added by Marlo 01282010
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) > 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01282010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01282010
     /* Added by Marlo
      ** 01282010 
   UNION
     SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.GROUPED_ITEM_NO, --EMCY da042506te
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     0 GRP_SEQ_NO,
     (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_LOSS,
                    (NVL(A.EXPENSE_RESERVE,0) - NVL(A.EXPENSES_PAID,0)) OUTSTANDING_EXPENSE,
     0 DISTRIBUTION_LOSS,
        0 DISTRIBUTION_EXPENSE
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
 FOR rec IN(--query to get distribution amount per grp_seq_no by MAC 02/01/2013
     SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 outstanding_loss, 0 outstanding_expense,
                SUM (NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0)) distribution_loss,
                SUM (NVL (c.expense_reserve, 0) - NVL (c.expenses_paid, 0)) distribution_expense
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                NVL (c.grp_seq_no, 0)
         HAVING SUM (NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0)) > 0
             OR SUM (NVL (c.expense_reserve, 0) - NVL (c.expenses_paid, 0)) > 0
 UNION
    --created a select to get only the outstanding loss and expense by MAC 02/01/2013
    SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, 0 grp_seq_no,
                SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) outstanding_loss,
                SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) outstanding_expense,
                0 distribution_loss, 0 distribution_expense
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no
         HAVING SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0
             OR SUM (NVL (a.expense_reserve, 0) - NVL (a.expenses_paid, 0)) > 0)  
 LOOP
--RCD 08/31/2012
         --added condition to display NULL when user extracted the record without tagging the "Per Business Source"
         --checkbox but printed the report with tag on "Per Business Source"
         IF rec.buss_source_type IS NULL
         THEN
            v_source_type_desc := NULL;
         ELSE
            --get BUSS_SOURCE_NAME
            BEGIN
               SELECT intm_desc
                 INTO v_source_type_desc
                 FROM giis_intm_type
                WHERE intm_type = rec.buss_source_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_source_type_desc := 'REINSURER ';
               WHEN OTHERS
               THEN
                  v_source_type_desc := NULL;
            END;
         END IF;
         
    --get SOURCE_NAME
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    --get ISS_NAME
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    --get LINE_NAME
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    --get SUBLINE_NAME
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;    
               END IF;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
      END IF;
    END IF;

   v_giclr205le.buss_source_name := v_source_type_desc;
   v_giclr205le.source_name      := v_source_name;
   v_giclr205le.iss_name         := v_iss_name;
   v_giclr205le.line_name        := v_line_name;
   v_giclr205le.subline_name     := v_subline_name;
   v_giclr205le.loss_year        := rec.loss_year;
   v_giclr205le.claim_no         := rec.claim_no;
   v_giclr205le.policy_no        := v_policy;
   v_giclr205le.assd_name        := v_assd_name;
   v_giclr205le.incept_date      := rec.incept_date;
   v_giclr205le.expiry_date      := rec.expiry_date;
   v_giclr205le.loss_date        := rec.loss_date;
   v_giclr205le.item_title       := v_item_title;
   v_giclr205le.tsi_amt          := rec.tsi_amt;
   v_giclr205le.peril_name       := v_peril_name;
   v_giclr205le.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
   v_giclr205le.INTERMEDIARY     := v_intm_ri;
   v_giclr205le.outstanding_loss := rec.outstanding_loss;
   -- Added by Marlo 01282010
   v_giclr205le.outstanding_expense := rec.outstanding_expense;
   v_giclr205le.claim_id         := rec.claim_id;
   v_giclr205le.item_no          := rec.item_no;
   v_giclr205le.peril_cd         := rec.peril_cd;
   v_giclr205le.grp_seq_no       := rec.grp_seq_no;
   v_giclr205le.line_cd          := rec.line_cd;
   v_giclr205le.ds_loss          := rec.distribution_loss;
   v_giclr205le.ds_expense       := rec.distribution_expense;

   PIPE ROW(v_giclr205le);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 -----------------------------------------------------------------------
  FUNCTION CSV_GICLR205L(p_session_id    VARCHAR2,
                   p_claim_id      VARCHAR2,
                 p_intm_break    NUMBER) RETURN giclr205l_type PIPELINED
  IS
   v_giclr205l          giclr205l_rec_type;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);--GICL_CLM_ITEM.ITEM_TITLE%TYPE; Modified by Marlo 01282010
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
  BEGIN
  /* comment out and replaced by MAC 02/05/2013
  FOR rec IN(SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.grouped_item_no, --EMCY da042506te
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     NVL(C.GRP_SEQ_NO,0) grp_seq_no, -- Added by Marlo 01282010
                    (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_loss,
        (NVL(C.LOSS_RESERVE, 0) - NVL(C.LOSSES_PAID, 0)) distribution_loss -- Added by Marlo 01282010
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C -- Added by Marlo 01282010
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01282010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01282010
    /* Added by Marlo
    ** 01282010 
   UNION
     SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
                    A.ISS_CD,
                    A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
                    A.BRDRX_RECORD_ID,
                    A.CLAIM_ID,
                    A.ASSD_NO,
                    A.CLAIM_NO,
                    A.POLICY_NO,
                    A.INCEPT_DATE,
                    A.EXPIRY_DATE,
                    A.LOSS_DATE,
                    A.CLM_FILE_DATE,
                    A.ITEM_NO,
                    A.grouped_item_no, --EMCY da042506te
                    A.PERIL_CD,
                    A.LOSS_CAT_CD,
                    A.TSI_AMT,
                    A.INTM_NO,
     0 grp_seq_no,
                    (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) OUTSTANDING_loss,
        0 distribution_loss
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
 FOR rec IN (--query to get distribution amount per grp_seq_no by MAC 02/05/2013
    SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 outstanding_loss,
                SUM (NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0)) distribution_loss
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND (NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0)) > 0
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                NVL (c.grp_seq_no, 0)
         HAVING SUM (NVL (c.loss_reserve, 0) - NVL (c.losses_paid, 0)) > 0
 UNION
    --created a select to get only the outstanding loss by MAC 02/05/2013
    SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, 0 grp_seq_no,
                SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) outstanding_loss,
                0 distribution_loss
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no
         HAVING SUM (NVL (a.loss_reserve, 0) - NVL (a.losses_paid, 0)) > 0)             
 LOOP

    --RCD 08/31/2012
         --added condition to display NULL when user extracted the record without tagging the "Per Business Source"
         --checkbox but printed the report with tag on "Per Business Source"
         IF rec.buss_source_type IS NULL
         THEN
            v_source_type_desc := NULL;
         ELSE
            --get BUSS_SOURCE_NAME
            BEGIN
               SELECT intm_desc
                 INTO v_source_type_desc
                 FROM giis_intm_type
                WHERE intm_type = rec.buss_source_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_source_type_desc := 'REINSURER ';
               WHEN OTHERS
               THEN
                  v_source_type_desc := NULL;
            END;
         END IF;

    --get SOURCE_NAME
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    --get ISS_NAME
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    --get LINE_NAME
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    --get SUBLINE_NAME
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
              --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;    
               END IF;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
              --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
      END IF;
    END IF;

   v_giclr205l.buss_source_name := v_source_type_desc;
   v_giclr205l.source_name      := v_source_name;
   v_giclr205l.iss_name         := v_iss_name;
   v_giclr205l.line_name        := v_line_name;
   v_giclr205l.subline_name     := v_subline_name;
   v_giclr205l.loss_year        := rec.loss_year;
   v_giclr205l.claim_no         := rec.claim_no;
   v_giclr205l.policy_no        := v_policy;
   v_giclr205l.assd_name        := v_assd_name;
   v_giclr205l.incept_date      := rec.incept_date;
   v_giclr205l.expiry_date      := rec.expiry_date;
   v_giclr205l.loss_date        := rec.loss_date;
   v_giclr205l.item_title       := v_item_title;
   v_giclr205l.tsi_amt          := rec.tsi_amt;
   v_giclr205l.peril_name       := v_peril_name;
   v_giclr205l.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
   v_giclr205l.INTERMEDIARY     := v_intm_ri;
   v_giclr205l.outstanding_loss := rec.outstanding_loss;
   -- Added by Marlo 01282010
   v_giclr205l.claim_id         := rec.claim_id;
   v_giclr205l.item_no          := rec.item_no;
   v_giclr205l.peril_cd         := rec.peril_cd;
   v_giclr205l.grp_seq_no       := rec.grp_seq_no;
   v_giclr205l.line_cd          := rec.line_cd;
   v_giclr205l.ds_loss          := rec.distribution_loss;

   PIPE ROW(v_giclr205l);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
  FUNCTION CSV_GICLR206L(p_session_id    VARCHAR2,
              p_claim_id      VARCHAR2,
              p_intm_break    NUMBER,
         p_paid_date     VARCHAR2,
         p_from_date     VARCHAR2,
         p_to_date       VARCHAR2) RETURN giclr206l_type PIPELINED
  IS
    v_giclr206l         giclr206l_rec_type;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);--GICL_CLM_ITEM.ITEM_TITLE%TYPE; Modified by Marlo 01292010
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no           VARCHAR2(2000);
    v_dv_no             VARCHAR2(500);
  BEGIN
  /* comment out by MAC 04/01/2013
  FOR rec IN(SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,-- Added by Marlo 01292010
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(C.LOSSES_PAID,0) DS_LOSS -- Added by Marlo 01292010
             FROM GICL_RES_BRDRX_EXTR A,
                 GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C -- Added by Marlo 01292010
           WHERE A.BUSS_SOURCE = B.INTM_NO(+)
            AND A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.LOSSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01292010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01292010
    /* Added by Marlo
    ** 01292010 
   UNION
     SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
                    (NVL(A.LOSSES_PAID,0)) LOSSES_PAID,
        0 DS_LOSS
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND NVL(A.LOSSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
   FOR rec IN ( --query to get paid amount per grp_seq_no by MAC 04/01/2013
      SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, SUM (NVL (c.losses_paid, 0)) ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.losses_paid, 0)) <> 0
  UNION
    /*get losses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.losses_paid, 0)) losses_paid, 0 ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.losses_paid, 0)) <> 0)
  LOOP

    --RCD 08/31/2012
         --added condition to display NULL when user extracted the record without tagging the "Per Business Source"
         --checkbox but printed the report with tag on "Per Business Source"
         IF rec.buss_source_type IS NULL
         THEN
            v_source_type_desc := NULL;
         ELSE
            --get BUSS_SOURCE_NAME
            BEGIN
               SELECT intm_desc
                 INTO v_source_type_desc
                 FROM giis_intm_type
                WHERE intm_type = rec.buss_source_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_source_type_desc := 'REINSURER ';
               WHEN OTHERS
               THEN
                  v_source_type_desc := NULL;
            END;
         END IF;

    --get SOURCE_NAME
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    --get ISS_NAME
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    --get LINE_NAME
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    --get SUBLINE_NAME
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;    
               END IF;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
      END IF;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206L
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    ELSE
     FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
   END IF;*/

   v_giclr206l.buss_source_name := v_source_type_desc;
   v_giclr206l.source_name      := v_source_name;
   v_giclr206l.iss_name         := v_iss_name;
   v_giclr206l.line_name        := v_line_name;
   v_giclr206l.subline_name     := v_subline_name;
   v_giclr206l.loss_year        := rec.loss_year;
   v_giclr206l.claim_no         := rec.claim_no;
   v_giclr206l.policy_no        := v_policy;
   v_giclr206l.assd_name        := v_assd_name;
   v_giclr206l.incept_date      := rec.incept_date;
   v_giclr206l.expiry_date      := rec.expiry_date;
   v_giclr206l.loss_date        := rec.loss_date;
   v_giclr206l.item_title       := v_item_title;
   v_giclr206l.tsi_amt          := rec.tsi_amt;
   v_giclr206l.peril_name       := v_peril_name;
   v_giclr206l.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
   v_giclr206l.INTERMEDIARY     := v_intm_ri;
   --v_giclr206l.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
   --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
   v_giclr206l.voucher_no_check_no := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'L');
   v_giclr206l.losses_paid      := rec.losses_paid;
   -- Added by Marlo 01292010
   v_giclr206l.ds_loss          := rec.ds_loss;
   v_giclr206l.claim_id         := rec.claim_id;
   v_giclr206l.item_no          := rec.item_no;
   v_giclr206l.peril_cd         := rec.peril_cd;
   v_giclr206l.line_cd          := rec.line_cd;
   v_giclr206l.grp_seq_no       := rec.grp_seq_no;

   PIPE ROW(v_giclr206l);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
  FUNCTION CSV_GICLR206E(p_session_id    VARCHAR2,
                  p_claim_id      VARCHAR2,
                  p_intm_break    NUMBER,
           p_paid_date     VARCHAR2,
           p_from_date     VARCHAR2,
           p_to_date       VARCHAR2) RETURN giclr206E_type PIPELINED
  IS
    v_giclr206e         giclr206e_rec_type;
    v_month_grp         VARCHAR2(100);
    v_source_type_desc  GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name       GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name          GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name         GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name      GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);--GICL_CLM_ITEM.ITEM_TITLE%TYPE; Modified by Marlo  01292010
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no           VARCHAR2(2000):=' ';
    v_dv_no             VARCHAR2(500):=' ';
  BEGIN
  /* comment out by MAC 04/01/2013
  FOR rec IN(SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,-- Added by Marlo 01292010
                 NVL(A.EXPENSES_PAID,0) LOSSES_PAID,
     NVL(C.EXPENSES_PAID,0) DS_LOSS -- Added by Marlo 01292010
             FROM GICL_RES_BRDRX_EXTR A,
                 GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.BUSS_SOURCE = B.INTM_NO(+)
            AND A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.EXPENSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01292010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01292010
    /* Added by Marlo
    ** 01292010 
   UNION
     SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
                    (NVL(A.EXPENSES_PAID,0)) LOSSES_PAID,
        0 DS_LOSS
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND NVL(A.EXPENSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
 FOR rec IN (
     --query to get paid amount per grp_seq_no by MAC 04/01/2013
SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, SUM (NVL (c.expenses_paid, 0)) ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.expenses_paid, 0)) <> 0
UNION
/*get expenses paid in the second part of the select by MAC 04/01/2013*/
SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.expenses_paid, 0)) losses_paid, 0 ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.expenses_paid, 0)) <> 0)
  LOOP
    
    --RCD 08/31/2012
         --added condition to display NULL when user extracted the record without tagging the "Per Business Source"
         --checkbox but printed the report with tag on "Per Business Source"
         IF rec.buss_source_type IS NULL
         THEN
            v_source_type_desc := NULL;
         ELSE
            --get BUSS_SOURCE_NAME
            BEGIN
               SELECT intm_desc
                 INTO v_source_type_desc
                 FROM giis_intm_type
                WHERE intm_type = rec.buss_source_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_source_type_desc := 'REINSURER ';
               WHEN OTHERS
               THEN
                  v_source_type_desc := NULL;
            END;
         END IF;

    --get SOURCE_NAME
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    --get ISS_NAME
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    --get LINE_NAME
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    --get SUBLINE_NAME
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;    
               END IF;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||
                          m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||
                          m.intm_name;    
               END IF;
           END LOOP;
         END;
      END IF;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206L
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    ELSE
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
      END IF;
    END LOOP;
     END IF;*/

    v_giclr206e.buss_source_name := v_source_type_desc;
    v_giclr206e.source_name      := v_source_name;
    v_giclr206e.iss_name         := v_iss_name;
    v_giclr206e.line_name        := v_line_name;
    v_giclr206e.subline_name     := v_subline_name;
    v_giclr206e.loss_year        := rec.loss_year;
    v_giclr206e.claim_no         := rec.claim_no;
    v_giclr206e.policy_no        := v_policy;
    v_giclr206e.assd_name        := v_assd_name;
    v_giclr206e.incept_date      := rec.incept_date;
    v_giclr206e.expiry_date      := rec.expiry_date;
    v_giclr206e.loss_date        := rec.loss_date;
    v_giclr206e.item_title       := v_item_title;
    v_giclr206e.tsi_amt          := rec.tsi_amt;
    v_giclr206e.peril_name       := v_peril_name;
    v_giclr206e.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr206e.INTERMEDIARY     := v_intm_ri;
    --v_giclr206e.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr206e.voucher_no_check_no := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'E');
    v_giclr206e.losses_paid      := rec.losses_paid;
    -- Added by Marlo 01292010
    v_giclr206e.ds_loss          := rec.ds_loss;
    v_giclr206e.claim_id         := rec.claim_id;
    v_giclr206e.item_no          := rec.item_no;
    v_giclr206e.peril_cd         := rec.peril_cd;
    v_giclr206e.line_cd          := rec.line_cd;
    v_giclr206e.grp_seq_no       := rec.grp_seq_no;

   PIPE ROW(v_giclr206e);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
  FUNCTION CSV_GICLR206LE(p_session_id    VARCHAR2,
                   p_claim_id      VARCHAR2,
                   p_intm_break    NUMBER,
            p_paid_date     VARCHAR2,
            p_from_date     VARCHAR2,
            p_to_date       VARCHAR2) RETURN giclr206LE_type PIPELINED
  IS
    v_giclr206le          giclr206le_rec_type;
    v_month_grp           VARCHAR2(100);
    v_source_type_desc    GIIS_INTM_TYPE.INTM_DESC%TYPE;
    v_source_name         GIIS_INTERMEDIARY.INTM_NAME%TYPE;
    v_iss_name            GIIS_ISSOURCE.ISS_NAME%TYPE;
    v_line_name           GIIS_LINE.LINE_NAME%TYPE;
    v_subline_name        GIIS_SUBLINE.SUBLINE_NAME%TYPE;
    v_policy              VARCHAR2(60);
    v_ref_pol_no          GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name           GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title          VARCHAR2(200);--GICL_CLM_ITEM.ITEM_TITLE%TYPE;
    v_peril_name          GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri             VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no             VARCHAR2(2000):=' ';
    v_dv_no               VARCHAR2(500):=' ';
    --added variables to check previous records as reference in resetting of variables by MAC 02/11/2013
    v_prev_claim_id       gicl_claims.claim_id%TYPE;
    v_prev_item_no        gicl_clm_res_hist.item_no%TYPE;
    v_prev_peril_cd       gicl_clm_res_hist.peril_cd%TYPE;
  BEGIN
  /*comment out by MAC 04/01/2013
  FOR rec IN(SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO, -- Added by Marlo 01292010
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(A.EXPENSES_PAID, 0) EXPENSES_PAID, -- Added by Marlo 01292010
     NVL(C.LOSSES_PAID, 0) DS_LOSS, -- Added by Marlo 01292010
     NVL(C.EXPENSES_PAID, 0) DS_EXPENSE -- Added by Marlo 01292010
             FROM GICL_RES_BRDRX_EXTR A,
                 GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C -- Added by Marlo 01292010
           WHERE A.BUSS_SOURCE = B.INTM_NO(+)
            AND A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.LOSSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01292010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01292010
          UNION
          SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO, -- Added by Marlo 01292010
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(A.EXPENSES_PAID, 0) EXPENSES_PAID, -- Added by Marlo 01292010
     NVL(C.LOSSES_PAID, 0) DS_LOSS, -- Added by Marlo 01292010
     NVL(C.EXPENSES_PAID, 0) DS_EXPENSE -- Added by Marlo 01292010
             FROM GICL_RES_BRDRX_EXTR A,
                 GIIS_INTERMEDIARY B,
     GICL_RES_BRDRX_DS_EXTR C -- Added by Marlo 01292010
           WHERE A.BUSS_SOURCE = B.INTM_NO(+)
            AND A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.EXPENSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID -- Added by Marlo 01292010
    AND A.SESSION_ID = C.SESSION_ID -- Added by Marlo 01292010
   /* Added by Marlo
      ** 01282010 
   UNION
     SELECT DISTINCT DECODE(A.ISS_CD,'RI','RI','DI') ISS_TYPE,
                    DECODE(A.ISS_CD,'RI','RI',B.INTM_TYPE) BUSS_SOURCE_TYPE,
         A.ISS_CD,
         A.BUSS_SOURCE,
                    A.LINE_CD,
                    A.SUBLINE_CD,
                    A.LOSS_YEAR,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO, --EMCY da042506te
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
     NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                    NVL(A.EXPENSE_RESERVE,0) EXPENSES_PAID,
     0 DS_LOSS,
        0 DS_EXPENSE
               FROM GICL_RES_BRDRX_EXTR A,
                    GIIS_INTERMEDIARY B
              WHERE A.BUSS_SOURCE = B.INTM_NO(+)
                AND A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
 FOR rec IN (--query to get paid amount per grp_seq_no by MAC 04/01/2013
    SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, 0 expenses_paid,
                SUM (NVL (c.losses_paid, 0)) ds_loss,
                SUM (NVL (c.expenses_paid, 0)) ds_expense,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.losses_paid, 0)) <> 0
             OR SUM (NVL (c.expenses_paid, 0)) <> 0
 --UNION --Dren 11.23.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. - Start 
    /*get losses and expenses paid in the second part of the select by MAC 04/01/2013*/
    /*SELECT DISTINCT DECODE (a.iss_cd, 'RI', 'RI', 'DI') iss_type,
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type) buss_source_type,
                a.iss_cd, a.buss_source, a.line_cd, a.subline_cd, a.loss_year,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.losses_paid, 0)) losses_paid,
                SUM (NVL (a.expenses_paid, 0)) expenses_paid, 0 ds_loss,
                0 ds_expense,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY DECODE (a.iss_cd, 'RI', 'RI', 'DI'),
                DECODE (a.iss_cd, 'RI', 'RI', b.intm_type),
                a.iss_cd,
                a.buss_source,
                a.line_cd,
                a.subline_cd,
                a.loss_year,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.losses_paid, 0)) <> 0
             OR SUM (NVL (a.expenses_paid, 0)) <> 0*/) --Dren 11.23.2015 SR-0020508 : Discrepancy in Losses Paid in Brdx Report. - End     
  LOOP

    --RCD 08/31/2012
         --added condition to display NULL when user extracted the record without tagging the "Per Business Source"
         --checkbox but printed the report with tag on "Per Business Source"
         IF rec.buss_source_type IS NULL
         THEN
            v_source_type_desc := NULL;
         ELSE
            --get BUSS_SOURCE_NAME
            BEGIN
               SELECT intm_desc
                 INTO v_source_type_desc
                 FROM giis_intm_type
                WHERE intm_type = rec.buss_source_type;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_source_type_desc := 'REINSURER ';
               WHEN OTHERS
               THEN
                  v_source_type_desc := NULL;
            END;
         END IF;

    --get SOURCE_NAME
    IF rec.ISS_TYPE = 'RI' THEN
      BEGIN
         SELECT RI_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_REINSURER
          WHERE RI_CD  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    ELSE
      BEGIN
         SELECT INTM_NAME
           INTO V_SOURCE_NAME
           FROM GIIS_INTERMEDIARY
          WHERE INTM_NO  = rec.BUSS_SOURCE;
      EXCEPTION
           WHEN OTHERS THEN
                V_SOURCE_NAME  := NULL;
      END;
    END IF;

    --get ISS_NAME
    BEGIN
       SELECT ISS_NAME
         INTO V_ISS_NAME
         FROM GIIS_ISSOURCE
        WHERE ISS_CD  = rec.ISS_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_ISS_NAME  := NULL;
    END;

    --get LINE_NAME
    BEGIN
       SELECT LINE_NAME
         INTO V_LINE_NAME
         FROM GIIS_LINE
        WHERE LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_LINE_NAME  := NULL;
    END;

    --get SUBLINE_NAME
    BEGIN
       SELECT SUBLINE_NAME
         INTO V_SUBLINE_NAME
         FROM GIIS_SUBLINE
        WHERE SUBLINE_CD = rec.SUBLINE_CD
          AND LINE_CD    = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_SUBLINE_NAME  := NULL;
    END;

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
      IF p_intm_break = 1 THEN
         BEGIN
           FOR i IN (SELECT a.intm_no intm_no, b.intm_name intm_name,
                            b.ref_intm_cd ref_intm_cd
                       FROM GICL_RES_BRDRX_EXTR a, GIIS_INTERMEDIARY b
                      WHERE a.intm_no = b.intm_no
                        AND a.session_id = p_session_id
                        AND a.claim_id = rec.claim_id
                        AND a.item_no = rec.item_no
                        AND a.peril_cd = rec.peril_cd
                        AND a.intm_no = rec.intm_no)
           LOOP
              --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(i.intm_no)||'/'||i.ref_intm_cd||'/'||
                          i.intm_name;    
               END IF;
           END LOOP;
         END;
      ELSIF p_intm_break = 0 THEN
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
      END IF;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206LE
    -- EXPENSE
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    -- LOSS
    FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     --AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;

    ELSE
 --EXPENSE
 FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
      END IF;
    END LOOP;

 --LOSS
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  --AND e.item_no      = rec.item_no
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
     END IF;*/
   --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
   v_giclr206le.voucher_no_check_no_loss := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'L');
   v_giclr206le.voucher_no_check_no_exp := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'E');
 
   v_giclr206le.buss_source_name := v_source_type_desc;
   v_giclr206le.source_name      := v_source_name;
   v_giclr206le.iss_name         := v_iss_name;
   v_giclr206le.line_name        := v_line_name;
   v_giclr206le.subline_name     := v_subline_name;
   v_giclr206le.loss_year        := rec.loss_year;
   v_giclr206le.claim_no         := rec.claim_no;
   v_giclr206le.policy_no        := v_policy;
   v_giclr206le.assd_name        := v_assd_name;
   v_giclr206le.incept_date      := rec.incept_date;
   v_giclr206le.expiry_date      := rec.expiry_date;
   v_giclr206le.loss_date        := rec.loss_date;
   v_giclr206le.item_title       := v_item_title;
   v_giclr206le.tsi_amt          := rec.tsi_amt;
   v_giclr206le.peril_name       := v_peril_name;
   v_giclr206le.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
   v_giclr206le.INTERMEDIARY     := v_intm_ri;
   --v_giclr206le.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
   v_giclr206le.losses_paid    := rec.losses_paid;
   -- Added by Marlo 01282010
   v_giclr206le.expenses_paid    := rec.expenses_paid;
   v_giclr206le.claim_id         := rec.claim_id;
   v_giclr206le.item_no          := rec.item_no;
   v_giclr206le.peril_cd         := rec.peril_cd;
   v_giclr206le.grp_seq_no       := rec.grp_seq_no;
   v_giclr206le.line_cd          := rec.line_cd;
   v_giclr206le.ds_loss          := rec.ds_loss;
   v_giclr206le.ds_expense       := rec.ds_expense;

   PIPE ROW(v_giclr206le);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
 /* Added by Marlo
 ** 02082010
 ** For extraction of losses paid per policy or per enrollee*/
 FUNCTION CSV_GICLR222L(p_session_id    VARCHAR2,
                        p_claim_id      VARCHAR2,
                   p_paid_date     VARCHAR2,
                   p_from_date     VARCHAR2,
                   p_to_date       VARCHAR2) RETURN giclr222l_type PIPELINED
  IS
    v_giclr222l         giclr222l_rec_type;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no           VARCHAR2(2000);
    v_dv_no             VARCHAR2(500);
  BEGIN
  /*comment out by MAC 05/16/2013
  FOR rec IN(SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(C.LOSSES_PAID,0) DS_LOSS
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.LOSSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
        UNION
     SELECT A.ISS_CD,
                     A.LINE_CD,
                     A.SUBLINE_CD,
          A.BRDRX_RECORD_ID,
                  A.CLAIM_ID,
                  A.ASSD_NO,
                  A.CLAIM_NO,
                  A.POLICY_NO,
                  A.INCEPT_DATE,
                  A.EXPIRY_DATE,
                  A.LOSS_DATE,
                  A.CLM_FILE_DATE,
                  A.ITEM_NO,
                  A.GROUPED_ITEM_NO,
                  A.PERIL_CD,
                  A.LOSS_CAT_CD,
                  A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
                    (NVL(A.LOSSES_PAID,0)) LOSSES_PAID,
        0 DS_LOSS
               FROM GICL_RES_BRDRX_EXTR A
              WHERE A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                --AND (NVL(A.LOSS_RESERVE,0) - NVL(A.LOSSES_PAID,0)) > 0
				AND NVL(A.LOSSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
 FOR rec IN (--query to get paid amount per grp_seq_no by MAC 05/16/2013
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid,
                SUM (NVL (c.losses_paid, 0)) ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.losses_paid, 0)) <> 0
 UNION
    /*get losses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.losses_paid, 0)) losses_paid, 0 ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.losses_paid, 0)) <> 0 )       
  LOOP

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206L
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    ELSE
     FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
   END IF;*/

    v_giclr222l.claim_no         := rec.claim_no;
    v_giclr222l.policy_no        := v_policy;
    v_giclr222l.assd_name        := v_assd_name;
    v_giclr222l.incept_date      := rec.incept_date;
    v_giclr222l.expiry_date      := rec.expiry_date;
    v_giclr222l.term             := TO_CHAR(rec.incept_date,'MM-DD-YYYY') || ' - ' || TO_CHAR(rec.expiry_date,'MM-DD-YYYY');
    v_giclr222l.loss_date        := rec.loss_date;
    v_giclr222l.item_title       := v_item_title;
    v_giclr222l.tsi_amt          := rec.tsi_amt;
    v_giclr222l.peril_name       := v_peril_name;
    v_giclr222l.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr222l.INTERMEDIARY     := v_intm_ri;
    --v_giclr222l.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr222l.voucher_no_check_no := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'L');
    v_giclr222l.losses_paid      := rec.losses_paid;
    v_giclr222l.ds_loss          := rec.ds_loss;
    v_giclr222l.claim_id         := rec.claim_id;
    v_giclr222l.item_no          := rec.item_no;
    v_giclr222l.peril_cd         := rec.peril_cd;
    v_giclr222l.line_cd          := rec.line_cd;
    v_giclr222l.grp_seq_no       := rec.grp_seq_no;

   PIPE ROW(v_giclr222l);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
 FUNCTION CSV_GICLR222E(p_session_id    VARCHAR2,
                        p_claim_id      VARCHAR2,
                   p_paid_date     VARCHAR2,
                   p_from_date     VARCHAR2,
                   p_to_date       VARCHAR2) RETURN giclr222e_type PIPELINED
  IS
    v_giclr222e         giclr222e_rec_type;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no           VARCHAR2(2000);
    v_dv_no             VARCHAR2(500);
  BEGIN
  /*comment out by MAC 05/16/2013
  FOR rec IN(SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.EXPENSES_PAID,0) LOSSES_PAID,
     NVL(C.EXPENSES_PAID,0) DS_LOSS
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.EXPENSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
        UNION
     SELECT A.ISS_CD,
                     A.LINE_CD,
                     A.SUBLINE_CD,
          A.BRDRX_RECORD_ID,
                  A.CLAIM_ID,
                  A.ASSD_NO,
                  A.CLAIM_NO,
                  A.POLICY_NO,
                  A.INCEPT_DATE,
                  A.EXPIRY_DATE,
                  A.LOSS_DATE,
                  A.CLM_FILE_DATE,
                  A.ITEM_NO,
                  A.GROUPED_ITEM_NO,
                  A.PERIL_CD,
                  A.LOSS_CAT_CD,
                  A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
                    (NVL(A.EXPENSES_PAID,0)) LOSSES_PAID,
        0 DS_LOSS
               FROM GICL_RES_BRDRX_EXTR A
              WHERE A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND NVL(A.EXPENSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
 FOR rec IN (--query to get paid amount per grp_seq_no by MAC 05/16/2013
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid,
                SUM (NVL (c.expenses_paid, 0)) ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.expenses_paid, 0)) <> 0
 UNION
    /*get expenses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.expenses_paid, 0)) losses_paid, 0 ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.expenses_paid, 0)) <> 0)       
  LOOP

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
              --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206L
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    ELSE
     FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.expenses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
   END IF;*/

    v_giclr222e.claim_no         := rec.claim_no;
    v_giclr222e.policy_no        := v_policy;
    v_giclr222e.assd_name        := v_assd_name;
    v_giclr222e.incept_date      := rec.incept_date;
    v_giclr222e.expiry_date      := rec.expiry_date;
    v_giclr222e.loss_date        := rec.loss_date;
    v_giclr222e.item_title       := v_item_title;
    v_giclr222e.tsi_amt          := rec.tsi_amt;
    v_giclr222e.peril_name       := v_peril_name;
    v_giclr222e.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr222e.INTERMEDIARY     := v_intm_ri;
    --v_giclr222e.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr222e.voucher_no_check_no := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'E');
    v_giclr222e.losses_paid      := rec.losses_paid;
    v_giclr222e.ds_loss          := rec.ds_loss;
    v_giclr222e.claim_id         := rec.claim_id;
    v_giclr222e.item_no          := rec.item_no;
    v_giclr222e.peril_cd         := rec.peril_cd;
    v_giclr222e.line_cd          := rec.line_cd;
    v_giclr222e.grp_seq_no       := rec.grp_seq_no;

   PIPE ROW(v_giclr222e);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
   FUNCTION CSV_GICLR222LE(p_session_id    VARCHAR2,
                   p_claim_id      VARCHAR2,
            p_paid_date     VARCHAR2,
            p_from_date     VARCHAR2,
            p_to_date       VARCHAR2) RETURN giclr222LE_type PIPELINED
  IS
    v_giclr222le          giclr222le_rec_type;
    v_policy              VARCHAR2(60);
    v_ref_pol_no          GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name           GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title          VARCHAR2(200);
    v_peril_name          GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri             VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no             VARCHAR2(2000):=' ';
    v_dv_no               VARCHAR2(500):=' ';
  BEGIN
  /*comment out by MAC 05/16/2013
  FOR rec IN(SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(A.EXPENSES_PAID, 0) EXPENSES_PAID,
     NVL(C.LOSSES_PAID, 0) DS_LOSS,
     NVL(C.EXPENSES_PAID, 0) DS_EXPENSE
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.LOSSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
          UNION
          SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(A.EXPENSES_PAID, 0) EXPENSES_PAID,
     NVL(C.LOSSES_PAID, 0) DS_LOSS,
     NVL(C.EXPENSES_PAID, 0) DS_EXPENSE
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.EXPENSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
   UNION
     SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
     NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                    NVL(A.EXPENSE_RESERVE,0) EXPENSES_PAID,
     0 DS_LOSS,
        0 DS_EXPENSE
               FROM GICL_RES_BRDRX_EXTR A
              WHERE A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
 FOR rec IN (--query to get paid amount per grp_seq_no by MAC 05/16/2013
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, 0 expenses_paid,
                SUM (NVL (c.losses_paid, 0)) ds_loss,
                SUM (NVL (c.expenses_paid, 0)) ds_expense,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.losses_paid, 0)) <> 0 OR
                SUM (NVL (c.expenses_paid, 0)) <> 0
 UNION
    /*get losses and expenses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.losses_paid, 0)) losses_paid, 
                SUM (NVL (a.expenses_paid, 0)) expenses_paid, 
                0 ds_loss, 0 ds_expense,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.losses_paid, 0)) <> 0 OR
                SUM (NVL (a.expenses_paid, 0)) <> 0)       
  LOOP

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206LE
    -- EXPENSE
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    -- LOSS
    FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     --AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;

    ELSE
 --EXPENSE
 FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
      END IF;
    END LOOP;

 --LOSS
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  --AND e.item_no      = rec.item_no
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
     END IF;*/

    v_giclr222le.claim_no         := rec.claim_no;
    v_giclr222le.policy_no        := v_policy;
    v_giclr222le.assd_name        := v_assd_name;
    v_giclr222le.incept_date      := rec.incept_date;
    v_giclr222le.expiry_date      := rec.expiry_date;
    v_giclr222le.loss_date        := rec.loss_date;
    v_giclr222le.item_title       := v_item_title;
    v_giclr222le.tsi_amt          := rec.tsi_amt;
    v_giclr222le.peril_name       := v_peril_name;
    v_giclr222le.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr222le.INTERMEDIARY     := v_intm_ri;
    --v_giclr222le.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr222le.voucher_no_check_no_loss := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'L');
    v_giclr222le.voucher_no_check_no_exp := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'E');
    v_giclr222le.losses_paid      := rec.losses_paid;
    v_giclr222le.expenses_paid    := rec.expenses_paid;
    v_giclr222le.claim_id         := rec.claim_id;
    v_giclr222le.item_no          := rec.item_no;
    v_giclr222le.peril_cd         := rec.peril_cd;
    v_giclr222le.grp_seq_no       := rec.grp_seq_no;
    v_giclr222le.line_cd          := rec.line_cd;
    v_giclr222le.ds_loss          := rec.ds_loss;
    v_giclr222le.ds_expense       := rec.ds_expense;

   PIPE ROW(v_giclr222le);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;

 ----------------------------------------------------------------------

 FUNCTION CSV_GICLR221L(p_session_id    VARCHAR2,
                        p_claim_id      VARCHAR2,
                   		p_paid_date     VARCHAR2,
                   		p_from_date2    VARCHAR2,
                   		p_to_date2      VARCHAR2) RETURN giclr221l_type PIPELINED
  IS
    v_giclr221l         giclr221l_rec_type;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no           VARCHAR2(2000);
    v_dv_no             VARCHAR2(500);
  BEGIN
  /*comment out by MAC 05/16/2013
  FOR rec IN(SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                    A.ENROLLEE,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(C.LOSSES_PAID,0) DS_LOSS
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.LOSSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
        UNION
     SELECT A.ISS_CD,
                     A.LINE_CD,
                     A.SUBLINE_CD,
          A.BRDRX_RECORD_ID,
                  A.CLAIM_ID,
                     A.ENROLLEE,
                  A.ASSD_NO,
                  A.CLAIM_NO,
                  A.POLICY_NO,
                  A.INCEPT_DATE,
                  A.EXPIRY_DATE,
                  A.LOSS_DATE,
                  A.CLM_FILE_DATE,
                  A.ITEM_NO,
                  A.GROUPED_ITEM_NO,
                  A.PERIL_CD,
                  A.LOSS_CAT_CD,
                  A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
                    (NVL(A.LOSSES_PAID,0)) LOSSES_PAID,
        0 DS_LOSS
               FROM GICL_RES_BRDRX_EXTR A
              WHERE A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND NVL(A.LOSSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/

 FOR rec IN (--query to get paid amount per grp_seq_no by MAC 05/16/2013
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.enrollee, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, SUM (NVL (c.losses_paid, 0)) ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.enrollee,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.losses_paid, 0)) <> 0
 UNION
    /*get losses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.enrollee, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.losses_paid, 0)) losses_paid, 0 ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.enrollee,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.losses_paid, 0)) <> 0)
  LOOP

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206L
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    ELSE
     FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
   END IF;*/

    v_giclr221l.claim_no         := rec.claim_no;
    v_giclr221l.policy_no        := v_policy;
    v_giclr221l.assd_name        := v_assd_name;
    v_giclr221l.term_of_policy   := to_char(rec.incept_date, 'MM-DD-YYYY') || ' - ' || to_char(rec.expiry_date, 'MM-DD-YYYY');
    v_giclr221l.loss_date        := rec.loss_date;
    v_giclr221l.item_title       := v_item_title;
    v_giclr221l.tsi_amt          := rec.tsi_amt;
    v_giclr221l.peril_name       := v_peril_name;
    v_giclr221l.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr221l.INTERMEDIARY     := v_intm_ri;
    --v_giclr221l.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr221l.voucher_no_check_no := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date2, p_to_date2, p_paid_date, rec.clm_res_hist_id, 'L');
    v_giclr221l.losses_paid      := rec.losses_paid;
    v_giclr221l.ds_loss          := rec.ds_loss;
    v_giclr221l.claim_id         := rec.claim_id;
    v_giclr221l.item_no          := rec.item_no;
    v_giclr221l.peril_cd         := rec.peril_cd;
    v_giclr221l.line_cd          := rec.line_cd;
    v_giclr221l.grp_seq_no       := rec.grp_seq_no;
    v_giclr221l.enrollee         := rec.enrollee;

   PIPE ROW(v_giclr221l);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
 FUNCTION CSV_GICLR221E(p_session_id    VARCHAR2,
                        p_claim_id      VARCHAR2,
                   		p_paid_date     VARCHAR2,
                   		p_from_date2     VARCHAR2,
                   		p_to_date2       VARCHAR2) RETURN giclr221e_type PIPELINED
  IS
    v_giclr221e         giclr221e_rec_type;
    v_policy            VARCHAR2(60);
    v_ref_pol_no        GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name         GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title        VARCHAR2(200);
    v_peril_name        GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri           VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no           VARCHAR2(2000);
    v_dv_no             VARCHAR2(500);
  BEGIN
  /*comment out by MAC 05/16/2013
  FOR rec IN(SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                    A.ENROLLEE,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.EXPENSES_PAID,0) LOSSES_PAID,
     NVL(C.EXPENSES_PAID,0) DS_LOSS
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.EXPENSES_PAID,0) <> 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
        UNION
     SELECT A.ISS_CD,
                     A.LINE_CD,
                     A.SUBLINE_CD,
          A.BRDRX_RECORD_ID,
                  A.CLAIM_ID,
                     A.ENROLLEE,
                  A.ASSD_NO,
                  A.CLAIM_NO,
                  A.POLICY_NO,
                  A.INCEPT_DATE,
                  A.EXPIRY_DATE,
                  A.LOSS_DATE,
                  A.CLM_FILE_DATE,
                  A.ITEM_NO,
                  A.GROUPED_ITEM_NO,
                  A.PERIL_CD,
                  A.LOSS_CAT_CD,
                  A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
                    (NVL(A.EXPENSES_PAID,0)) LOSSES_PAID,
        0 DS_LOSS
               FROM GICL_RES_BRDRX_EXTR A
              WHERE A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
                AND NVL(A.EXPENSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
 FOR rec IN (--query to get paid amount per grp_seq_no by MAC 05/16/2013
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.enrollee, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, SUM (NVL (c.expenses_paid, 0)) ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.enrollee,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.expenses_paid, 0)) <> 0
 UNION
    /*get expenses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.enrollee, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.expenses_paid, 0)) losses_paid, 0 ds_loss,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.enrollee,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.expenses_paid, 0)) <> 0)       
  LOOP

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206L
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    ELSE
     FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.expenses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
   END IF;*/

    v_giclr221e.claim_no         := rec.claim_no;
    v_giclr221e.policy_no        := v_policy;
    v_giclr221e.assd_name        := v_assd_name;
    v_giclr221e.term_of_policy   := to_char(rec.incept_date, 'MM-DD-YYYY') || ' - ' || to_char(rec.expiry_date, 'MM-DD-YYYY');
    v_giclr221e.incept_date      := rec.incept_date;
    v_giclr221e.expiry_date      := rec.expiry_date;
    v_giclr221e.loss_date        := rec.loss_date;
    v_giclr221e.item_title       := v_item_title;
    v_giclr221e.tsi_amt          := rec.tsi_amt;
    v_giclr221e.peril_name       := v_peril_name;
    v_giclr221e.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr221e.INTERMEDIARY     := v_intm_ri;
    --v_giclr221e.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr221e.voucher_no_check_no := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date2, p_to_date2, p_paid_date, rec.clm_res_hist_id, 'E');
    v_giclr221e.losses_paid      := rec.losses_paid;
    v_giclr221e.ds_loss          := rec.ds_loss;
    v_giclr221e.claim_id         := rec.claim_id;
    v_giclr221e.item_no          := rec.item_no;
    v_giclr221e.peril_cd         := rec.peril_cd;
    v_giclr221e.line_cd          := rec.line_cd;
    v_giclr221e.grp_seq_no       := rec.grp_seq_no;
    v_giclr221e.enrollee         := rec.enrollee;

   PIPE ROW(v_giclr221e);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;
 ----------------------------------------------------------------------
   FUNCTION CSV_GICLR221LE(p_session_id    VARCHAR2,
                    p_claim_id      VARCHAR2,
             p_paid_date     VARCHAR2,
             p_from_date     VARCHAR2,
             p_to_date       VARCHAR2) RETURN giclr221LE_type PIPELINED
  IS
    v_giclr221le          giclr221le_rec_type;
    v_policy              VARCHAR2(60);
    v_ref_pol_no          GIPI_POLBASIC.REF_POL_NO%TYPE;
    v_assd_name           GIIS_ASSURED.ASSD_NAME%TYPE;
    v_item_title          VARCHAR2(200);
    v_peril_name          GIIS_PERIL.PERIL_NAME%TYPE;
    v_pol_iss_cd          GICL_CLAIMS.pol_iss_cd%TYPE;
    v_intm_ri             VARCHAR2(4000); --increase size for multiple intermediary by MAC 02/11/2013.
    var_dv_no             VARCHAR2(2000):=' ';
    v_dv_no               VARCHAR2(500):=' ';
  BEGIN
  /*comment out by MAC 05/16/2013
  FOR rec IN(SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                    A.ENROLLEE,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(A.EXPENSES_PAID, 0) EXPENSES_PAID,
     NVL(C.LOSSES_PAID, 0) DS_LOSS,
     NVL(C.EXPENSES_PAID, 0) DS_EXPENSE
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.LOSSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
          UNION
          SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                    A.ENROLLEE,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     NVL(C.GRP_SEQ_NO, 0) GRP_SEQ_NO,
                 NVL(A.LOSSES_PAID,0) LOSSES_PAID,
     NVL(A.EXPENSES_PAID, 0) EXPENSES_PAID,
     NVL(C.LOSSES_PAID, 0) DS_LOSS,
     NVL(C.EXPENSES_PAID, 0) DS_EXPENSE
             FROM GICL_RES_BRDRX_EXTR A,
     GICL_RES_BRDRX_DS_EXTR C
           WHERE A.SESSION_ID = P_SESSION_ID
           AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
          AND NVL(A.EXPENSES_PAID,0) > 0
    AND A.BRDRX_RECORD_ID = C.BRDRX_RECORD_ID
    AND A.SESSION_ID = C.SESSION_ID
   UNION
     SELECT DISTINCT A.ISS_CD,
                    A.LINE_CD,
                    A.SUBLINE_CD,
         A.BRDRX_RECORD_ID,
                 A.CLAIM_ID,
                    A.ENROLLEE,
                 A.ASSD_NO,
                 A.CLAIM_NO,
                 A.POLICY_NO,
                 A.INCEPT_DATE,
                 A.EXPIRY_DATE,
                 A.LOSS_DATE,
                 A.CLM_FILE_DATE,
                 A.ITEM_NO,
                 A.GROUPED_ITEM_NO,
                 A.PERIL_CD,
                 A.LOSS_CAT_CD,
                 A.TSI_AMT,
                 A.INTM_NO,
                 A.CLM_LOSS_ID,
     0 GRP_SEQ_NO,
     NVL(A.LOSSES_PAID,0) LOSSES_PAID,
                    NVL(A.EXPENSE_RESERVE,0) EXPENSES_PAID,
     0 DS_LOSS,
        0 DS_EXPENSE
               FROM GICL_RES_BRDRX_EXTR A
              WHERE A.SESSION_ID = P_SESSION_ID
                AND A.CLAIM_ID = NVL(P_CLAIM_ID,A.CLAIM_ID)
    AND A.BRDRX_RECORD_ID NOT IN (SELECT BRDRX_RECORD_ID
                   FROM GICL_RES_BRDRX_DS_EXTR
              WHERE SESSION_ID = P_SESSION_ID))*/
              
  FOR rec IN (--query to get paid amount per grp_seq_no by MAC 05/16/2013
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.enrollee, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, NVL (c.grp_seq_no, 0) grp_seq_no,
                0 losses_paid, 0 expenses_paid,
                SUM (NVL (c.losses_paid, 0)) ds_loss,
                SUM (NVL (c.expenses_paid, 0)) ds_expense,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a,
                giis_intermediary b,
                gicl_res_brdrx_ds_extr c
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
            AND a.brdrx_record_id = c.brdrx_record_id
            AND a.session_id = c.session_id
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.enrollee,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                NVL (c.grp_seq_no, 0),
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (c.losses_paid, 0)) <> 0 OR
                SUM (NVL (c.expenses_paid, 0)) <> 0
 UNION
    /*get losses and expenses paid in the second part of the select by MAC 04/01/2013*/
    SELECT DISTINCT a.iss_cd, a.line_cd, a.subline_cd,
                a.claim_id, a.enrollee, a.assd_no, a.claim_no, a.policy_no, a.incept_date,
                a.expiry_date, a.loss_date, a.clm_file_date, a.item_no,
                a.grouped_item_no, a.peril_cd, 
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd) loss_cat_des, --added by MAC 10/31/2013
                a.tsi_amt, a.intm_no, a.clm_loss_id, 0 grp_seq_no,
                SUM (NVL (a.losses_paid, 0)) losses_paid, 
                SUM (NVL (a.expenses_paid, 0)) expenses_paid, 
                0 ds_loss, 0 ds_expense,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
           FROM gicl_res_brdrx_extr a, giis_intermediary b
          WHERE a.buss_source = b.intm_no(+)
            AND a.session_id = p_session_id
            AND a.claim_id = NVL (p_claim_id, a.claim_id)
       GROUP BY a.iss_cd,
                a.line_cd,
                a.subline_cd,
                a.claim_id,
                a.enrollee,
                a.assd_no,
                a.claim_no,
                a.policy_no,
                a.incept_date,
                a.expiry_date,
                a.loss_date,
                a.clm_file_date,
                a.item_no,
                a.grouped_item_no,
                a.peril_cd,
                csv_brdrx.get_loss_category(a.line_cd, a.loss_cat_cd), --added by MAC 10/31/2013
                a.tsi_amt,
                a.intm_no,
                a.clm_loss_id,
                a.clm_res_hist_id --separate all payment history per claim, item, peril by MAC 03/28/2014.
         HAVING SUM (NVL (a.losses_paid, 0)) <> 0 OR
                SUM (NVL (a.expenses_paid, 0)) <> 0)       
  LOOP

    --get POLICY_NO
    BEGIN
       SELECT b.ref_pol_no
         INTO v_ref_pol_no
         FROM GICL_CLAIMS a, GIPI_POLBASIC b
        WHERE a.line_cd = b.line_cd
          AND a.subline_cd = b.subline_cd
          AND a.pol_iss_cd = b.iss_cd
          AND a.issue_yy = b.issue_yy
          AND a.pol_seq_no = b.pol_seq_no
          AND a.renew_no = b.renew_no
          AND b.endt_seq_no = 0
          AND a.claim_id = rec.claim_id
          AND ref_pol_no IS NOT NULL;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
             v_ref_pol_no := NULL;
    END;

    IF v_ref_pol_no IS NOT NULL THEN
      v_policy := rec.policy_no||'/'||v_ref_pol_no;
    ELSE
      v_policy := rec.policy_no;
    END IF;

    --get ASSD_NAME
    BEGIN
       SELECT ASSD_NAME
         INTO V_ASSD_NAME
         FROM GIIS_ASSURED
        WHERE ASSD_NO = rec.ASSD_NO;
    EXCEPTION
         WHEN OTHERS THEN
              V_ASSD_NAME := NULL;
    END;

    --get ITEM_TITLE
    v_item_title := Get_Gpa_Item_Title(rec.claim_id,rec.line_cd,rec.item_no,NVL(rec.grouped_item_no,0));

    --get PERIL_NAME
    BEGIN
       SELECT PERIL_NAME
         INTO V_PERIL_NAME
         FROM GIIS_PERIL
        WHERE PERIL_CD    = rec.PERIL_CD
          AND LINE_CD     = rec.LINE_CD;
    EXCEPTION
         WHEN OTHERS THEN
              V_PERIL_NAME  := NULL;
    END;

    --get INTERMEDIARY
    BEGIN
       SELECT pol_iss_cd
         INTO v_pol_iss_cd
         FROM GICL_CLAIMS
        WHERE claim_id = rec.claim_id;
    EXCEPTION
       WHEN NO_DATA_FOUND THEN
         v_pol_iss_cd := NULL;
    END;

    IF v_pol_iss_cd = Giacp.V('RI_ISS_CD') THEN
       BEGIN
         FOR r IN (SELECT a.ri_cd ri_cd, b.ri_name ri_name
                     FROM GICL_CLAIMS a, GIIS_REINSURER b
                    WHERE a.ri_cd = b.ri_cd
                      AND a.claim_id = rec.claim_id)
         LOOP
           --concat all intermediary by MAC 02/11/2013
           IF v_intm_ri IS NULL THEN
                v_intm_ri := TO_CHAR(r.ri_cd)||'/'||r.ri_name;
           ELSE
                v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(r.ri_cd)||'/'||r.ri_name;    
           END IF;
         END LOOP;
       END;
    ELSE
         BEGIN
           FOR m IN (SELECT a.intm_no, b.intm_name, b.ref_intm_cd
                      FROM GICL_INTM_ITMPERIL a, GIIS_INTERMEDIARY b
                     WHERE a.intm_no = b.intm_no
                       AND a.claim_id = rec.claim_id
                       AND a.item_no = rec.item_no
                       AND a.peril_cd = rec.peril_cd)
           LOOP
             --concat all intermediary by MAC 02/11/2013
               IF v_intm_ri IS NULL THEN
                    v_intm_ri := TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;
               ELSE
                    v_intm_ri := v_intm_ri || CHR(10) || TO_CHAR(m.intm_no)||'/'||m.ref_intm_cd||'/'||m.intm_name;   
               END IF;
           END LOOP;
         END;
    END IF;

 --GET VOUCHER NO/CHECK NO
 /*comment out by MAC 05/17/2013
 IF SIGN(rec.losses_paid) < 1 THEN  -- codes from CF_DV_NO of GICLR206LE
    -- EXPENSE
       FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))||
                                  ' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.expenses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;
    -- LOSS
    FOR v1 IN (SELECT DISTINCT b.dv_pref||'-'||
                                  LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                                  ||' /'||e.check_no dv_no,
                         TO_CHAR(a.cancel_date,'MM/DD/YYYY') cancel_date
                    FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                         giac_acctrans c, giac_reversals d,
                         giac_chk_disbursement e
                   WHERE a.tran_id    = b.gacc_tran_id
                     AND a.tran_id    = d.gacc_tran_id
                     AND c.tran_id    = d.reversing_tran_id
                     AND b.gacc_tran_id = e.gacc_tran_id
                     --AND e.item_no    = rec.item_no
                     AND a.claim_id   = rec.claim_id
                     AND a.clm_loss_id  = rec.clm_loss_id
                   GROUP BY b.dv_pref, b.dv_no, e.check_no, a.cancel_date
                  HAVING SUM(NVL(a.losses_paid,0)) > 0)
       LOOP
         v_dv_no := v1.dv_no||CHR(10)||'cancelled '||v1.cancel_date;
         IF var_dv_no IS NULL THEN
            var_dv_no := v_dv_no;
         ELSE
            var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
         END IF;
       END LOOP;

    ELSE
 --EXPENSE
 FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                              LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                              ||' /'||e.check_no dv_no
                FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                     giac_direct_claim_payts c, giac_acctrans d,
                     giac_chk_disbursement e
               WHERE a.tran_id    = d.tran_id
                 AND b.gacc_tran_id = c.gacc_tran_id
                 AND b.gacc_tran_id = d.tran_id
                 AND b.gacc_tran_id = e.gacc_tran_id
                 AND e.item_no   = rec.item_no
                 AND a.claim_id    = rec.claim_id
                 AND a.clm_loss_id  = rec.clm_loss_id
                 AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                     BETWEEN p_from_date AND p_to_date
               GROUP BY b.dv_pref, b.dv_no, e.check_no
              HAVING SUM(NVL(a.expenses_paid,0)) > 0)
    LOOP
      v_dv_no := v2.dv_no;
      IF var_dv_no IS NULL THEN
         var_dv_no := v_dv_no;
      ELSE
         var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
      END IF;
    END LOOP;

 --LOSS
    FOR v2 IN (SELECT DISTINCT b.dv_pref||'-'||
                               LTRIM(TO_CHAR(b.dv_no,'0999999999'))
                               ||' /'||e.check_no dv_no
                 FROM gicl_clm_res_hist a, giac_disb_vouchers b,
                      giac_direct_claim_payts c, giac_acctrans d,
                      giac_chk_disbursement e
                WHERE a.tran_id = d.tran_id
                  AND b.gacc_tran_id = c.gacc_tran_id
                  AND b.gacc_tran_id = d.tran_id
                  AND b.gacc_tran_id = e.gacc_tran_id
                  --AND e.item_no      = rec.item_no
                  AND a.claim_id    = rec.claim_id
                  AND a.clm_loss_id  = rec.clm_loss_id
                  AND DECODE(p_paid_date,1,TRUNC(a.date_paid),2,TRUNC(d.posting_date))
                      BETWEEN p_from_date AND p_to_date
                GROUP BY b.dv_pref, b.dv_no, e.check_no
               HAVING SUM(NVL(a.losses_paid,0)) > 0)
     LOOP
       v_dv_no := v2.dv_no;
       IF var_dv_no IS NULL THEN
          var_dv_no := v_dv_no;
       ELSE
          var_dv_no := v_dv_no;--||CHR(10)||var_dv_no;
       END IF;
     END LOOP;
     END IF;*/

    v_giclr221le.claim_no         := rec.claim_no;
    v_giclr221le.policy_no        := v_policy;
    v_giclr221le.assd_name        := v_assd_name;
    v_giclr221le.incept_date      := rec.incept_date;
    v_giclr221le.expiry_date      := rec.expiry_date;
    v_giclr221le.term             := TO_CHAR(rec.incept_date,'MM-DD-YYYY') || ' - ' || TO_CHAR(rec.expiry_date,'MM-DD-YYYY');
    v_giclr221le.loss_date        := rec.loss_date;
    v_giclr221le.item_title       := v_item_title;
    v_giclr221le.tsi_amt          := rec.tsi_amt;
    v_giclr221le.peril_name       := v_peril_name;
    v_giclr221le.loss_cat_des     := rec.loss_cat_des; --added by MAC 10/31/2013
    v_giclr221le.INTERMEDIARY     := v_intm_ri;
    --v_giclr221le.voucher_no_check_no := var_dv_no; comment out by MAC 05/17/2013
    --retrieve voucher number of Losses Paid per transaction by MAC 03/28/2014.
    v_giclr221le.voucher_no_check_no_loss := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'L');
    v_giclr221le.voucher_no_check_no_exp := csv_brdrx.get_voucher_check_no(rec.claim_id, rec.item_no, rec.peril_cd, rec.grouped_item_no, p_from_date, p_to_date, p_paid_date, rec.clm_res_hist_id, 'E');
    v_giclr221le.voucher_no_check_no_le := NVL(v_giclr221le.voucher_no_check_no_loss,v_giclr221le.voucher_no_check_no_exp);
    v_giclr221le.losses_paid      := rec.losses_paid;
    v_giclr221le.expenses_paid    := rec.expenses_paid;
    v_giclr221le.claim_id         := rec.claim_id;
    v_giclr221le.item_no          := rec.item_no;
    v_giclr221le.peril_cd         := rec.peril_cd;
    v_giclr221le.grp_seq_no       := rec.grp_seq_no;
    v_giclr221le.line_cd          := rec.line_cd;
    v_giclr221le.ds_loss          := rec.ds_loss;
    v_giclr221le.ds_expense       := rec.ds_expense;
    v_giclr221le.enrollee         := rec.enrollee;

   PIPE ROW(v_giclr221le);
   
   v_intm_ri := NULL; --reset value of variable for intermediary by MAC 02/11/2013
 END LOOP;
 RETURN;
 END;

 --created function that will display loss category by MAC 10/31/2013.
  FUNCTION get_loss_category (p_line_cd giis_loss_ctgry.line_cd%TYPE,
                              p_loss_cat_cd giis_loss_ctgry.loss_cat_cd%TYPE)
  RETURN VARCHAR2
  IS
    v_loss_cat  giis_loss_ctgry.loss_cat_des%TYPE;
  BEGIN
    SELECT a.loss_cat_des
      INTO v_loss_cat
      FROM giis_loss_ctgry a
     WHERE a.line_cd = p_line_cd 
       AND a.loss_cat_cd = p_loss_cat_cd;
       
      RETURN (v_loss_cat);
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN ('');
  END get_loss_category;
  
   --retrieve voucher and check number per transaction by MAC 03/28/2014
   --Modified kenneth SR 20583 10142015 -- added TO_DATE(date_param, 'DD-MON-YY') to date parameters
   FUNCTION get_voucher_check_no (
      p_claim_id           IN   gicl_clm_res_hist.claim_id%TYPE,
      p_item_no            IN   gicl_clm_res_hist.item_no%TYPE,
      p_peril_cd           IN   gicl_clm_res_hist.peril_cd%TYPE,
      p_grouped_item_no    IN   gicl_clm_res_hist.grouped_item_no%TYPE,
      p_dsp_from_date      IN   VARCHAR,    --DATE, --kenneth SR 20583 10142015
      p_dsp_to_date        IN   VARCHAR,    --DATE, --kenneth SR 20583 10142015
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_clm_res_hist_id    IN   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      p_payee_type         IN   VARCHAR
   )
      RETURN VARCHAR2
   IS
      var_dv_no   VARCHAR2 (4000);
   BEGIN
      FOR i IN
         (SELECT a.tran_id,
                 DECODE (c.gacc_tran_id,
                         NULL, NULL,
                            ' /'
                         || c.check_pref_suf
                         || '-'
                         || LPAD (c.check_no, 10, 0)
                        ) check_no,
                 TO_CHAR (NVL (a.cancel_date, SYSDATE),
                          'MM/DD/YYYY'
                         ) cancel_date
            FROM gicl_clm_res_hist a,
                 giac_acctrans b,
                 giac_chk_disbursement c
           WHERE a.claim_id = p_claim_id
             AND a.item_no = NVL (p_item_no, a.item_no)
             AND a.peril_cd = NVL (p_peril_cd, a.peril_cd)
             AND a.grouped_item_no =
                                    NVL (p_grouped_item_no, a.grouped_item_no)
             AND a.tran_id IS NOT NULL
             AND a.tran_id = b.tran_id
             AND a.tran_id = c.gacc_tran_id(+)
             AND b.tran_flag != 'D'
             AND a.clm_res_hist_id = p_clm_res_hist_id
             AND (   TRUNC (DECODE (p_paid_date_option,
                                    1, a.date_paid,
                                    2, b.posting_date
                                   )
                           ) BETWEEN TO_DATE(p_dsp_from_date, 'MM-DD-YYYY') AND TO_DATE(p_dsp_to_date, 'MM-DD-YYYY')
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            TO_DATE(p_dsp_from_date, 'MM-DD-YYYY'),
                                                            TO_DATE(p_dsp_to_date, 'MM-DD-YYYY'),
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND (   DECODE (a.cancel_tag,
                             'Y', TRUNC (a.cancel_date),
                             (TO_DATE(p_dsp_to_date, 'MM-DD-YYYY') + 1)
                            ) > TO_DATE(p_dsp_to_date, 'MM-DD-YYYY')
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            TO_DATE(p_dsp_from_date, 'MM-DD-YYYY'),
                                                            TO_DATE(p_dsp_to_date, 'MM-DD-YYYY'),
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND DECODE (p_payee_type,
                         'L', NVL (a.losses_paid, 0),
                         'E', NVL (a.expenses_paid, 0)
                        ) <> 0)
      LOOP
         IF gicls202_extraction_pkg.get_reversal (i.tran_id,
                                                  TO_DATE(p_dsp_from_date, 'MM-DD-YYYY'),
                                                  TO_DATE(p_dsp_to_date, 'MM-DD-YYYY'),
                                                  p_paid_date_option
                                                 ) <> 1
         THEN
            IF var_dv_no IS NULL
            THEN
               var_dv_no :=
                     get_ref_no (i.tran_id)
                  || i.check_no
                  || ' cancelled '
                  || i.cancel_date;
            ELSE
               var_dv_no :=
                     var_dv_no
                  || CHR (10)
                  || get_ref_no (i.tran_id)
                  || i.check_no
                  || ' cancelled '
                  || i.cancel_date;
            END IF;
         ELSE
            IF var_dv_no IS NULL
            THEN
               var_dv_no := get_ref_no (i.tran_id) || i.check_no;
            ELSE
               var_dv_no :=
                  var_dv_no || CHR (10) || get_ref_no (i.tran_id)
                  || i.check_no;
            END IF;
         END IF;
      END LOOP;

      RETURN (var_dv_no);
   END get_voucher_check_no;

   --retrieve details of GICLR209 per transaction by MAC 03/28/2014
   FUNCTION get_giclr209_dtl (
      p_claim_id           IN   gicl_clm_res_hist.claim_id%TYPE,
      p_dsp_from_date      IN   DATE,
      p_dsp_to_date        IN   DATE,
      p_paid_date_option   IN   gicl_res_brdrx_extr.pd_date_opt%TYPE,
      p_clm_res_hist_id    IN   gicl_clm_res_hist.clm_res_hist_id%TYPE,
      p_payee_type         IN   VARCHAR,
      p_type               IN   VARCHAR
   )
      RETURN VARCHAR2
   IS
      var_dv_no   VARCHAR2 (10000); --changed by from 4000 to 10000 aliza G. 01/28/2016 SR 0021495
   BEGIN
      FOR i IN
         (SELECT a.tran_id,
                 DECODE (c.gacc_tran_id,
                         NULL, NULL,
                         c.check_pref_suf || '-' || LPAD (c.check_no, 10, 0)
                        ) check_no,
                 TO_CHAR (NVL (a.cancel_date, SYSDATE),
                          'MM-DD-YYYY'
                         ) cancel_date,
                 TO_CHAR (a.date_paid, 'MM-DD-YYYY') tran_date,
                 a.clm_loss_id, --added by aliza G. SR 21495
                 a.claim_id --added by aliza G. SR 21495
            FROM gicl_clm_res_hist a,
                 giac_acctrans b,
                 giac_chk_disbursement c
           WHERE a.claim_id = p_claim_id
             AND a.tran_id IS NOT NULL
             AND a.tran_id = b.tran_id
             AND a.tran_id = c.gacc_tran_id(+)
             AND b.tran_flag != 'D'
             AND a.clm_res_hist_id = p_clm_res_hist_id
             AND (   TRUNC (DECODE (p_paid_date_option,
                                    1, a.date_paid,
                                    2, b.posting_date
                                   )
                           ) BETWEEN p_dsp_from_date AND p_dsp_to_date
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND (   DECODE (a.cancel_tag,
                             'Y', TRUNC (a.cancel_date),
                             (p_dsp_to_date + 1)
                            ) > p_dsp_to_date
                  OR DECODE
                        (gicls202_extraction_pkg.get_reversal
                                                           (a.tran_id,
                                                            p_dsp_from_date,
                                                            p_dsp_to_date,
                                                            p_paid_date_option
                                                           ),
                         1, 0,
                         1
                        ) = 1
                 )
             AND DECODE (p_payee_type,
                         'L', NVL (a.losses_paid, 0),
                         'E', NVL (a.expenses_paid, 0)
                        ) <> 0)
      LOOP
         IF    (p_type = 'CHECK_NO' AND i.check_no IS NOT NULL)
            OR (p_type = 'TRAN_DATE' AND i.tran_date IS NOT NULL)
            OR (p_type = 'ITEM_STAT_CD')
         THEN
            IF p_type = 'CHECK_NO'
            THEN
               IF gicls202_extraction_pkg.get_reversal (i.tran_id,
                                                        p_dsp_from_date,
                                                        p_dsp_to_date,
                                                        p_paid_date_option
                                                       ) <> 1
               THEN
                  IF var_dv_no IS NULL
                  THEN
                     var_dv_no :=
                                 i.check_no || ' cancelled ' || i.cancel_date;
                  ELSE
                     var_dv_no :=
                           var_dv_no
                        || CHR (10)
                        || i.check_no
                        || ' cancelled '
                        || i.cancel_date;
                  END IF;
               ELSE
                  IF var_dv_no IS NULL
                  THEN
                     var_dv_no := i.check_no;
                  ELSE
                     var_dv_no := var_dv_no || CHR (10) || i.check_no;
                  END IF;
               END IF;
            ELSIF p_type = 'TRAN_DATE'
            THEN
               IF var_dv_no IS NULL
               THEN
                  var_dv_no := i.tran_date;
               ELSE
                  var_dv_no := var_dv_no || CHR (10) || i.tran_date;
               END IF;
            ELSIF p_type = 'ITEM_STAT_CD'
            THEN
               FOR ii IN (SELECT item_stat_cd
                            FROM gicl_clm_loss_exp
                           WHERE payee_type = p_payee_type
                             --AND tran_id, = i.tran_id --removed by aliza G. 01/28/2015 SR 21495 to handle scenario of reversed payt (will have NULL tran_id)
                             AND claim_id = p_claim_id--added by aliza G. 01/28/2016 SR 0021495 to get stat code and avoid repeating stat code
                             AND clm_loss_id = i.clm_loss_id)--added by aliza G. 01/28/2016 SR 0021495 to get  stat code and avoid repeating stat code
               LOOP
                  IF var_dv_no IS NULL
                  THEN
                     var_dv_no := ii.item_stat_cd;
                  ELSE
                     var_dv_no := var_dv_no || CHR (10) || ii.item_stat_cd;
                  END IF;
               END LOOP;
            END IF;
         END IF;
      END LOOP;

      RETURN (var_dv_no);
   END get_giclr209_dtl;
END;
/

