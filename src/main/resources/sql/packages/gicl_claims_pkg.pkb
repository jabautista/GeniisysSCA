CREATE OR REPLACE PACKAGE BODY CPI.gicl_claims_pkg
AS
/*
**  Created by   :  Andrew Robes
**  Date Created :  February 03, 2010
**  Reference By : (CHECK_POLICY_FOR_RENEWAL)
**  Description : This is used to check if the policy has claims.
*/
   FUNCTION policy_has_claims (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,    --to limit the query
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE, --to limit the query
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,     --to limit the query
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,   --to limit the query
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE, --to limit the query
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )                                                     --to limit the query
      RETURN BOOLEAN
   IS
      v_result   BOOLEAN;
   BEGIN
      v_result := FALSE;

      FOR a IN (SELECT claim_id
                  FROM gicl_claims
                 WHERE renew_no = p_renew_no
                   AND pol_seq_no = p_pol_seq_no
                   AND issue_yy = p_issue_yy
                   AND iss_cd = p_iss_cd
                   AND subline_cd = p_subline_cd
                   AND line_cd = p_line_cd
                   --AND clm_stat_cd <> 'CC') comment out by MAC 03/21/2013
                   --allow renewal of policy with pending claim which status is either CANCELLED, WITHDRAWN, or DENIED by MAC 03/21/2013
                   AND clm_stat_cd NOT IN (giacp.v('CANCELLED'), giacp.v('WITHDRAWN'), giacp.v('DENIED')))
      LOOP
         v_result := TRUE;
      END LOOP;

      RETURN v_result;
   END policy_has_claims;

/*
**  Created by   :  Jerome Orio
**  Date Created :  April 06, 2010
**  Reference By : function get_clm_no in GEN10G
**  Description : returns the claim number.
*/
   FUNCTION get_clm_no (p_claim_id VARCHAR2)
      RETURN VARCHAR
   AS
      v_clm_no   VARCHAR2 (50);
   BEGIN
      FOR rec IN (SELECT    line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (clm_seq_no, '0000009')) claim
                    FROM gicl_claims
                   WHERE claim_id = p_claim_id)
      LOOP
         v_clm_no := rec.claim;
         EXIT;
      END LOOP;

      RETURN (v_clm_no);
   END;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 05.28.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This procedure checks if a policy_no has a pending claims
   */
   FUNCTION chk_for_pending_claims (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN gicl_claims.claim_id%TYPE
   IS
      v_claim_id   gicl_claims.claim_id%TYPE   := 0;
   BEGIN
      FOR a1 IN (SELECT b.claim_id
                   FROM gipi_polbasic a, gicl_claims b
                  WHERE a.line_cd = b.line_cd
                    AND a.subline_cd = b.subline_cd
                    AND a.iss_cd = b.pol_iss_cd
                    AND a.issue_yy = b.issue_yy
                    AND a.pol_seq_no = b.pol_seq_no
                    AND a.renew_no = b.renew_no
                    AND NVL (a.endt_seq_no, 0) = 0
                    AND clm_stat_cd NOT IN ('CC', 'DN', 'WD', 'CD')
                    AND a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no)
      LOOP
         v_claim_id := a1.claim_id;
      END LOOP;

      RETURN v_claim_id;
   END chk_for_pending_claims;

   /*
   **  Created by        : Mark JM
   **  Date Created     : 06.24.2010
   **  Reference By     : (GIPIS031 - Endt Basic Information)
   **  Description     : This function retrieves the claim_id of the given policy_no
   */
   FUNCTION get_claim_id (
      p_line_cd      IN   gicl_claims.line_cd%TYPE,
      p_subline_cd   IN   gicl_claims.subline_cd%TYPE,
      p_iss_cd       IN   gicl_claims.iss_cd%TYPE,
      p_issue_yy     IN   gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   IN   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     IN   gicl_claims.renew_no%TYPE
   )
      RETURN NUMBER
   IS
      v_claim_id   NUMBER;
   BEGIN
      FOR a1 IN (SELECT claim_id
                   FROM gicl_claims
                  WHERE line_cd = p_line_cd
                    AND subline_cd = p_subline_cd
                    AND pol_iss_cd = p_iss_cd
                    AND issue_yy = p_issue_yy
                    AND pol_seq_no = p_pol_seq_no
                    AND renew_no = p_renew_no
                    AND clm_stat_cd NOT IN ('CC', 'WD', 'DN', 'CD'))
      LOOP
         v_claim_id := a1.claim_id;
         EXIT;
      END LOOP;

      RETURN v_claim_id;
   END get_claim_id;

   /*
    **  Created by        : Emman
    **  Date Created     : 11.22.2010
    **  Reference By     : (GIPIS031A - Endt Basic Information)
    **  Description     : This procedure checks if a policy_no has a pending claims
    */
   FUNCTION chk_pending_claims_for_pack (
      p_line_cd      IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN   gipi_polbasic.subline_cd%TYPE,
      p_iss_cd       IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN   gipi_polbasic.renew_no%TYPE
   )
      RETURN gicl_claims.claim_id%TYPE
   IS
      v_claim_id   gicl_claims.claim_id%TYPE   := 0;
   BEGIN
      FOR a1 IN (SELECT b.claim_id
                   FROM gipi_pack_polbasic a, gicl_claims b
                  WHERE a.line_cd = b.line_cd
                    AND a.subline_cd = b.subline_cd
                    AND a.iss_cd = b.pol_iss_cd
                    AND a.issue_yy = b.issue_yy
                    AND a.pol_seq_no = b.pol_seq_no
                    AND a.renew_no = b.renew_no
                    AND NVL (a.endt_seq_no, 0) = 0
                    AND clm_stat_cd NOT IN ('CC', 'DN', 'WD', 'CD')
                    AND a.line_cd = p_line_cd
                    AND a.subline_cd = p_subline_cd
                    AND a.iss_cd = p_iss_cd
                    AND a.issue_yy = p_issue_yy
                    AND a.pol_seq_no = p_pol_seq_no
                    AND a.renew_no = p_renew_no)
      LOOP
         v_claim_id := a1.claim_id;
      END LOOP;

      RETURN v_claim_id;
   END chk_pending_claims_for_pack;

   FUNCTION get_related_claims (p_policy_id gipi_polbasic.policy_id%TYPE)
      RETURN gipi_related_claims_tab PIPELINED
   IS
      v_claims   gipi_related_claims_type;
   BEGIN
      FOR i IN (SELECT a.claim_id, TRUNC (a.clm_file_date) clm_file_date,
                       TO_CHAR (a.clm_file_date, 'MM-dd-rrrr') str_clm_file_date,
                       a.clm_setl_date, a.line_cd,
                          a.line_cd
                       || '-'
                       || a.subline_cd
                       || '-'
                       || a.iss_cd
                       || '-'
                       || LTRIM (TO_CHAR (a.clm_yy, '09'))
                       || '-'
                       || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                       (NVL (a.loss_res_amt, 0) + NVL (a.exp_res_amt, 0)
                       ) claim_amt,
                       (NVL (a.loss_pd_amt, 0) + NVL (a.exp_pd_amt, 0)
                       ) paid_amt,
                       b.clm_stat_desc, c.policy_id
                  FROM gicl_claims a, giis_clm_stat b, gipi_polbasic c
                 WHERE a.clm_stat_cd = b.clm_stat_cd
                   AND a.line_cd = c.line_cd
                   AND a.subline_cd = c.subline_cd
                   AND a.pol_iss_cd = c.iss_cd--a.iss_cd = c.iss_cd Gzelle 06.15.2013
                   AND a.issue_yy = c.issue_yy
                   AND a.pol_seq_no = c.pol_seq_no
                   AND a.renew_no = c.renew_no
                   AND c.policy_id = NVL (p_policy_id, c.policy_id))
      LOOP
         v_claims.claim_id := i.claim_id; -- Nica 05.11.2013
         v_claims.line_cd := i.line_cd;
         v_claims.claim_no := i.claim_no;
         v_claims.clm_file_date := i.clm_file_date;
         v_claims.str_clm_file_date := i.str_clm_file_date; -- added by: Angelo 04.22.2014
         v_claims.clm_setl_date := i.clm_setl_date;
         v_claims.claim_amt := i.claim_amt;
         v_claims.paid_amt := i.paid_amt;
         v_claims.clm_stat_desc := i.clm_stat_desc;
         PIPE ROW (v_claims);
      END LOOP;
   END get_related_claims;                                    --MOSES 03292011

   /*
      **  Created by        : Tonio
      **  Date Created     : 6.17.2011
      **  Reference By     : (GICLS002 - Claims Listing)
      */
   FUNCTION get_claim_listing (
      p_assured_name      gicl_claims.assured_name%TYPE,
      p_plate_number      gicl_claims.plate_no%TYPE,
      p_claim_stat_desc   VARCHAR2,
      p_claim_processor   gicl_claims.in_hou_adj%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_subline_cd        gicl_claims.subline_cd%TYPE,
      p_iss_cd            gicl_claims.iss_cd%TYPE,
      p_clm_yy            gicl_claims.clm_yy%TYPE,
      p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      p_renew_no          gicl_claims.pol_iss_cd%TYPE,
      p_module_id         giis_modules.module_id%TYPE,
      p_user_id           giis_users.user_id%TYPE
   )
      RETURN gicl_claims_listing_tab PIPELINED
   IS
      v_claims   gicl_claims_listing_type;
   BEGIN
      FOR i IN (SELECT   a.claim_id,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM(TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09')) -- andrew - 02.13.2012 - changed from clm_yy to issue_yy
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                         b.clm_stat_desc, a.in_hou_adj, a.assured_name,
                         a.plate_no, a.line_cd, a.subline_cd, a.iss_cd,
                         a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.pol_seq_no,
                         a.renew_no, a.dsp_loss_date, a.loss_cat_cd, a.pack_policy_id,
                         (SELECT DECODE (pack_policy_id,
                                         NULL, NULL,
                                         '1'
                                        )
                            FROM gipi_pack_polbasic
                           WHERE pack_policy_id = a.pack_policy_id)
                                                                 pack_policy,
                         -- c.loss_cat_des, c.peril_cd,    commented out by Christian 04.27.2012
                                                    -- added by irwin
                                                    a.expiry_date,
                         a.pol_eff_date, a.catastrophic_cd, d.incept_date,
                         a.issue_yy, a.loss_date, a.district_no, a.block_id
                    FROM gicl_claims a,
                         giis_clm_stat b,
                       --  giis_loss_ctgry c, commented out by Christian 04.27.2012
                         gipi_polbasic d
                   WHERE 1=1
                     AND (a.line_cd, a.iss_cd) IN (
                                                    SELECT line_cd, branch_cd
                                                      FROM TABLE (security_access.get_branch_line('CL', p_module_id, p_user_id))
                                                   )
                     AND a.clm_stat_cd = b.clm_stat_cd
                    -- AND c.loss_cat_cd = a.loss_cat_cd commented out by Christian 04.27.2012
                    -- AND c.line_cd = a.line_cd
                     AND d.line_cd = a.line_cd
                     AND d.subline_cd = a.subline_cd
                     AND d.iss_cd = a.pol_iss_cd
                     AND d.issue_yy = a.issue_yy
                     AND d.pol_seq_no = a.pol_seq_no
                     AND d.renew_no = a.renew_no
                     AND NVL (d.endt_seq_no, 0) = NVL (a.max_endt_seq_no, 0)
                     --AND d.eff_date <= SYSDATE
                     --AND d.eff_date <=
                     --      NVL (a.clm_file_date,
                     --            TO_DATE ('010190', 'MMDDYYYY')
                     --           ) --Rey - To view new Claims
                     AND claim_id IN (SELECT a.claim_id                     --christian - added to match the records in CS
                                        FROM gicl_claims a, giis_clm_stat b
                                       WHERE a.clm_stat_cd = b.clm_stat_cd
                                         AND b.clm_stat_type = 'N')
                     AND NVL(a.assured_name, '@') LIKE
                             NVL (p_assured_name, NVL(a.assured_name, '@'))
                     AND NVL (a.plate_no, '-') LIKE
                               NVL (p_plate_number, NVL (a.plate_no, '-'))
                     AND b.clm_stat_desc LIKE
                               NVL (p_claim_stat_desc, b.clm_stat_desc)
                     AND a.in_hou_adj LIKE
                               NVL (p_claim_processor, a.in_hou_adj)
                     AND a.line_cd LIKE
                               NVL (p_line_cd, a.line_cd)
                     AND a.subline_cd LIKE
                               NVL (p_subline_cd, a.subline_cd)
                     AND a.iss_cd LIKE NVL (p_iss_cd, a.iss_cd)
                     AND a.clm_yy LIKE NVL (p_clm_yy, a.clm_yy)
                     AND a.clm_seq_no LIKE
                               NVL (p_clm_seq_no, a.clm_seq_no)
                     AND a.pol_seq_no LIKE
                               NVL (p_pol_seq_no, a.pol_seq_no)
                     AND a.pol_iss_cd LIKE
                               NVL (p_pol_iss_cd, a.pol_iss_cd)
                     AND a.renew_no LIKE
                               NVL (p_renew_no, a.renew_no)
                ORDER BY claim_no)
      LOOP
         v_claims.claim_id := i.claim_id;
         v_claims.claim_no := i.claim_no;
         v_claims.policy_no := i.policy_no;
         v_claims.claim_stat_desc := i.clm_stat_desc;
         v_claims.in_house_adjustment := i.in_hou_adj;
         v_claims.assured_name := i.assured_name;
         v_claims.plate_no := i.plate_no;
         v_claims.pack_policy := i.pack_policy;
         v_claims.line_cd := i.line_cd;
         v_claims.subline_cd := i.subline_cd;
         v_claims.iss_cd := i.iss_cd;
         v_claims.issue_yy := i.issue_yy;
         v_claims.clm_yy := i.clm_yy;
         v_claims.clm_seq_no := i.clm_seq_no;
         v_claims.pol_iss_cd := i.pol_iss_cd;
         v_claims.pol_seq_no := i.pol_seq_no;
         v_claims.renew_no := i.renew_no;
         v_claims.loss_date := i.loss_date;
         v_claims.dsp_loss_date := i.dsp_loss_date;
         v_claims.loss_cat_cd := i.loss_cat_cd;
         --v_claims.loss_cat_des := i.loss_cat_des;           -- added by irwin
         v_claims.expiry_date := i.expiry_date;
         v_claims.pol_eff_date := i.pol_eff_date;
         v_claims.catastrophic_cd := i.catastrophic_cd;
         --v_claims.peril_cd := i.peril_cd;
         v_claims.incept_date := i.incept_date;
         v_claims.district_no := i.district_no;
         v_claims.block_id := i.block_id;

         IF v_claims.expiry_date IS NULL
         THEN
            extract_expiry3 (v_claims.line_cd,
                             v_claims.subline_cd,
                             v_claims.pol_iss_cd,
                             v_claims.issue_yy,
                             v_claims.pol_seq_no,
                             v_claims.renew_no,
                             v_claims.loss_date,
                             v_claims.expiry_date
                            );
         END IF;

         SELECT COUNT (b.item_no)
           INTO v_claims.item_limit
           FROM gipi_polbasic a, gipi_item b
          WHERE a.line_cd = v_claims.line_cd
            AND a.subline_cd = v_claims.subline_cd
            AND a.iss_cd = v_claims.pol_iss_cd
            AND a.issue_yy = v_claims.issue_yy
            AND a.pol_seq_no = v_claims.pol_seq_no
            AND a.renew_no = v_claims.renew_no
            AND a.pol_flag IN ('1', '2', '3', 'X')
            AND TRUNC (a.eff_date) <= v_claims.loss_date
            AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                               a.expiry_date, v_claims.expiry_date,
                               a.endt_expiry_date
                              )
                      ) >= v_claims.loss_date
            AND a.policy_id = b.policy_id;

         --added by: Christian 04.26.2012
         FOR j IN (select loss_cat_des, peril_cd
                     FROM giis_loss_ctgry
                    where line_cd = i.line_cd
                      and loss_cat_cd = i.loss_cat_cd )
         LOOP
           v_claims.peril_cd := j.peril_cd;
           v_claims.loss_cat_des := j.loss_cat_des;
         END LOOP;

         FOR a IN (SELECT line_cd||'-'||subline_cd||'-'||iss_cd||'-'||TO_CHAR(issue_yy,'09')||'-'||TO_CHAR(pol_seq_no,'0000009')||'-'||TO_CHAR(renew_no,'09') AS policy
                     FROM gipi_pack_polbasic
                    WHERE pack_policy_id = i.pack_policy_id)
         LOOP
            v_claims.package_policy := a.policy;
         END LOOP;

         FOR x IN (SELECT a.claim_id, b.grouped_item_title, c.assignee
                     FROM gicl_claims a, giis_clm_stat d, gicl_accident_dtl b, gicl_motor_car_dtl c
                    WHERE a.claim_id = i.claim_id
                      AND a.clm_stat_cd = d.clm_stat_cd
                      AND a.claim_id = b.claim_id(+)
                      AND a.claim_id = c.claim_id(+))
         LOOP
            v_claims.grouped_item_title := x.grouped_item_title;
            v_claims.assignee := x.assignee;
         END LOOP;

         PIPE ROW (v_claims);
      END LOOP;
   END get_claim_listing;

   /*
      **  Created by        : Tonio
      **  Date Created     : 7.29.2011
      **  Reference By     : (GICLS052 - Loss Recovery Listisng)
      */
  /*Modified by pjsantos 11/1/2016, for optimization GENQA 5825*/
   FUNCTION get_lost_recovery_listing (
      p_module_id      giis_modules.module_id%TYPE,
      p_claim_no       VARCHAR2,
      p_policy_no      VARCHAR2,
      p_recovery_no    VARCHAR2,
      p_assured_name   VARCHAR2,
      p_file_date      VARCHAR2,
      p_loss_date      VARCHAR2,
      p_user_id        VARCHAR2,
      p_line_cd        VARCHAR2, -- added by christian 07.06.2012
      p_rec_stat_desc  VARCHAR2,
      p_order_by       VARCHAR2,
      p_asc_desc_flag  VARCHAR2,
      p_first_row      NUMBER, 
      p_last_row       NUMBER
   )
      RETURN gicl_claims_listing_tab2 PIPELINED
   IS
      v_claims       gicl_claims_listing_type2;
      v_cancel_tag   VARCHAR2 (5);
      v_dist         VARCHAR2 (1);
      v_entry        VARCHAR2 (1);
      TYPE cur_type IS REF CURSOR;      
      c        cur_type;                
      v_sql    VARCHAR2(32767); 
   BEGIN
/*      FOR i IN (
      SELECT   b.recovery_id, a.claim_id, b.line_cd  line_cd2, b.rec_year,
                   b.rec_seq_no, a.line_cd, a.subline_cd, a.iss_cd,
                   b.iss_cd iss_cd2, a.clm_yy, a.clm_seq_no,
                   a.line_cd line_cd3, a.subline_cd subline_cd2,
                   a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                   a.clm_stat_cd, a.loss_cat_cd, a.assd_no,
                   --a.assured_name || ' ' || a.assd_name2 assured_name, modified by christian 01242013
                   DECODE(a.assd_name2, null, a.assured_name, a.assured_name || ' ' || a.assd_name2) assured_name,
                   TO_CHAR (a.loss_date, 'mm-dd-rrrr') loss_date,
                   a.clm_file_date, b.cancel_tag, a.dsp_loss_date,
                      b.line_cd
                   || '-'
                   || b.iss_cd
                   || '-'
                   || b.rec_year
                   || '-'
                   || LTRIM(TO_CHAR (b.rec_seq_no, '099')) recovery_no,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.clm_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                      a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09')) --pol cruz, 10.17.2013, changed clm_yy to issue_yy
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (renew_no, '09')) policy_no,
                   c.loss_cat_des
              FROM gicl_claims a, gicl_clm_recovery b, giis_loss_ctgry c
             WHERE a.clm_stat_cd NOT IN ('CC', 'WD', 'DN')
               AND a.recovery_sw = 'Y'
               AND a.claim_id = b.claim_id(+)
               AND NVL (b.cancel_tag, '*') NOT IN ('CD', 'WO', 'CC') --Christian 04.18.2012
             --AND check_user_per_line (b.line_cd, a.iss_cd, p_module_id) = 1
               AND check_user_per_line2 (b.line_cd, a.iss_cd, p_module_id, p_user_id) = 1
               AND    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM(TO_CHAR (a.clm_yy, '09'))
                   || '-'
                   || LTRIM(TO_CHAR (a.clm_seq_no, '0999999')) LIKE
                      UPPER(NVL (p_claim_no,
                                 a.line_cd
                              || '-'
                              || a.subline_cd
                              || '-'
                              || a.iss_cd
                              || '-'
                              || LTRIM(TO_CHAR (a.clm_yy, '09'))
                              || '-'
                              || LTRIM(TO_CHAR (a.clm_seq_no, '0999999'))
                             ))
               AND    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09')) --pol cruz, 10.17.2013, changed clm_yy to issue_yy
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (renew_no, '09')) LIKE
                         UPPER(NVL (p_policy_no,
                                 a.line_cd
                              || '-'
                              || a.subline_cd
                              || '-'
                              || a.pol_iss_cd
                              || '-'
                              || LTRIM (TO_CHAR (a.issue_yy, '09')) --pol cruz, 10.17.2013, changed clm_yy to issue_yy
                              || '-'
                              || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                              || '-'
                              || LTRIM (TO_CHAR (renew_no, '09'))
                             ))
               AND    b.line_cd
                   || '-'
                   || b.iss_cd
                   || '-'
                   || b.rec_year
                   || '-'
                   || LTRIM(TO_CHAR (b.rec_seq_no, '099')) LIKE
                         UPPER(NVL (p_recovery_no,
                                 b.line_cd
                              || '-'
                              || b.iss_cd
                              || '-'
                              || b.rec_year
                              || '-'
                              || LTRIM(TO_CHAR (b.rec_seq_no, '099'))
                             ))*/
               /*AND UPPER(a.assured_name || ' ' || a.assd_name2) LIKE
                      UPPER(NVL (p_assured_name,
                              a.assured_name || ' ' || a.assd_name2
                             )) modified by christian 01242013*/
               /*AND UPPER(DECODE(a.assd_name2, null, a.assured_name, a.assured_name || ' ' || a.assd_name2)) LIKE
                      UPPER(NVL (p_assured_name,
                              DECODE(a.assd_name2, null, a.assured_name, a.assured_name || ' ' || a.assd_name2)
                             ))
               AND TO_CHAR (a.clm_file_date, 'mm-dd-rrrr') LIKE
                      NVL (p_file_date, TO_CHAR (a.clm_file_date, 'mm-dd-rrrr'))
               AND TO_CHAR (a.loss_date, 'mm-dd-rrrr') LIKE
                      NVL (p_loss_date, TO_CHAR (a.loss_date, 'mm-dd-rrrr'))
               AND c.loss_cat_cd = a.loss_cat_cd
               AND c.line_cd = a.line_cd
               AND a.line_cd = p_line_cd
          ORDER BY a.line_cd, iss_cd2, b.rec_year, b.rec_seq_no)*/
           v_sql := 'SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT   b.recovery_id, a.claim_id, b.line_cd  line_cd2, b.rec_year,
                   b.rec_seq_no, a.line_cd, a.subline_cd, a.iss_cd,
                   b.iss_cd iss_cd2, a.clm_yy, a.clm_seq_no,
                   a.line_cd line_cd3, a.subline_cd subline_cd2,
                   a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                   a.clm_stat_cd, a.loss_cat_cd, a.assd_no,
                   DECODE(a.assd_name2, null, a.assured_name, a.assured_name || '' '' || a.assd_name2) assured_name,
                   TO_CHAR (a.loss_date, ''mm-dd-rrrr'') loss_date,
                   a.clm_file_date, b.cancel_tag, a.dsp_loss_date,
                      b.line_cd
                   || ''-''
                   || b.iss_cd
                   || ''-''
                   || b.rec_year
                   || ''-''
                   || LTRIM(TO_CHAR (b.rec_seq_no, ''099'')) recovery_no,
                      a.line_cd
                   || ''-''
                   || a.subline_cd
                   || ''-''
                   || a.iss_cd
                   || ''-''
                   || LTRIM(TO_CHAR (a.clm_yy, ''09''))
                   || ''-''
                   || LTRIM(TO_CHAR (a.clm_seq_no, ''0999999'')) claim_no,
                      a.line_cd
                   || ''-''
                   || a.subline_cd
                   || ''-''
                   || a.pol_iss_cd
                   || ''-''
                   || LTRIM (TO_CHAR (a.issue_yy, ''09'')) 
                   || ''-''
                   || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                   || ''-''
                   || LTRIM (TO_CHAR (renew_no, ''09'')) policy_no,
                   c.loss_cat_des, (SELECT z.clm_stat_desc
                                     FROM giis_clm_stat z
                                    WHERE z.clm_stat_cd = a.clm_stat_cd
                                      AND ROWNUM = 1) claim_stat_desc,
                                   (SELECT DECODE(NVL (A.cancel_tag, ''N''), ''N'', ''true'', ''Y'', ''false'', ''false'') xtag
                                      FROM gicl_recovery_payt A
                                     WHERE A.recovery_id = b.recovery_id
                                       AND ROWNUM = 1) wra, (SELECT UPPER(rec_stat_desc)
                                                                FROM giis_recovery_status z
                                                               WHERE EXISTS (SELECT 1
                                                                               FROM gicl_rec_hist
                                                                              WHERE recovery_id = b.recovery_id
                                                                                AND rec_stat_cd = z.rec_stat_cd
                                                                                AND rec_hist_no = (SELECT MAX(rec_hist_no)
                                                                               FROM gicl_rec_hist
                                                                              WHERE recovery_id = b.recovery_id)
                                                                 AND ROWNUM = 1)) rec_stat_desc,
                                                              (SELECT rec_stat_cd
                                                                 FROM giis_recovery_status z
                                                                WHERE EXISTS (SELECT 1
                                                                               FROM gicl_rec_hist
                                                                              WHERE recovery_id = b.recovery_id
                                                                                AND rec_stat_cd = z.rec_stat_cd
                                                                                AND rec_hist_no = (SELECT MAX(rec_hist_no)
                                                                               FROM gicl_rec_hist
                                                                              WHERE recovery_id = b.recovery_id)
                                                                  AND ROWNUM = 1)) rec_stat_cd, NULL recovery_acct_id, NULL dist, NULL entry
              FROM gicl_claims a, gicl_clm_recovery b, giis_loss_ctgry c
             WHERE a.clm_stat_cd NOT IN (''CC'', ''WD'', ''DN'')
               AND a.recovery_sw = ''Y''
               AND a.claim_id = b.claim_id(+)
               AND NVL (b.cancel_tag, ''*'') NOT IN (''CD'', ''WO'', ''CC'')
               AND  EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''CL'', '''||p_module_id ||''','''|| p_user_id||'''))
                                WHERE branch_cd = a.iss_cd AND line_cd = a.line_cd) 
               AND c.loss_cat_cd = a.loss_cat_cd
               AND c.line_cd = a.line_cd ';
            IF p_line_cd IS NOT NULL 
                THEN
                    v_sql := v_sql || ' AND a.line_cd = '''||p_line_cd||''' ';
            END IF;
            IF p_claim_no IS NOT NULL
                THEN
                    v_sql := v_sql || ' AND a.line_cd || ''-'' || a.subline_cd || ''-'' || a.iss_cd || ''-'' || LTRIM(TO_CHAR (a.clm_yy, ''09''))
                                        || ''-'' || LTRIM(TO_CHAR (a.clm_seq_no, ''0999999'')) LIKE '''||UPPER(p_claim_no)||''' ';
            END IF;
            IF  p_policy_no IS NOT NULL
                THEN
                    v_sql := v_sql || ' AND    a.line_cd || ''-'' || a.subline_cd || ''-'' || a.pol_iss_cd || ''-'' || LTRIM (TO_CHAR (a.issue_yy, ''09'')) 
                                               || ''-'' || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999'')) || ''-'' || LTRIM (TO_CHAR (renew_no, ''09'')) LIKE
                                               '''||UPPER(p_policy_no)||''' ';
            END IF;
            IF  p_recovery_no IS NOT NULL
                THEN
                    v_sql := v_sql || ' AND  b.line_cd|| ''-''|| b.iss_cd|| ''-''|| b.rec_year|| ''-''|| LTRIM(TO_CHAR (b.rec_seq_no, ''099''))
                                             LIKE '''||UPPER(p_recovery_no)||'''  ';
            END IF;
            IF  p_assured_name IS NOT NULL
                THEN
                    v_sql := v_sql || ' AND UPPER(DECODE(a.assd_name2, null, a.assured_name, a.assured_name || '' '' || a.assd_name2))
                                            LIKE '''|| UPPER(REPLACE(p_assured_name,'''','''''')) ||''' ';
            END IF;
            IF  p_file_date IS NOT NULL
                THEN
                    v_sql := v_sql || ' AND TO_CHAR (a.clm_file_date, ''mm-dd-rrrr'') LIKE '''||p_file_date||''' ';
            END IF;                 
            IF  p_loss_date IS NOT NULL
                THEN
                    v_sql := v_sql || ' AND TO_CHAR (a.loss_date, ''mm-dd-rrrr'') LIKE '''||p_loss_date||''' ';
            END IF;  
            
        IF p_order_by IS NOT NULL
          THEN
            IF p_order_by = 'assuredName'
             THEN        
              v_sql := v_sql || ' ORDER BY assured_name ';
            ELSIF  p_order_by = 'claimNo'
             THEN
              v_sql := v_sql || ' ORDER BY claim_no ';
            ELSIF  p_order_by = 'policyNo'
             THEN
              v_sql := v_sql || ' ORDER BY policy_no ';
            ELSIF  p_order_by = 'recoveryNo'
             THEN
              v_sql := v_sql || ' ORDER BY recovery_no '; 
            ELSIF  p_order_by = 'recStatDesc'
             THEN
              v_sql := v_sql || ' ORDER BY rec_stat_desc ';         
            END IF;
            
            IF p_asc_desc_flag IS NOT NULL
            THEN
               v_sql := v_sql || p_asc_desc_flag;
            ELSE
               v_sql := v_sql || ' ASC';
            END IF; 
        ELSE
          v_sql := v_sql || ' ORDER BY a.line_cd, iss_cd2, b.rec_year, b.rec_seq_no ';
        END IF;
    
        v_sql := v_sql || ') innersql) outersql) mainsql  WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;
    
   
 
 
    OPEN c FOR v_sql;   
      LOOP
      FETCH c INTO 
      v_claims.count_                , 
      v_claims.rownum_               ,
      v_claims.recovery_id           ,      
      v_claims.claim_id              ,
      v_claims.line_cd2              ,
      v_claims.rec_year              ,
      v_claims.rec_seq_no            ,
      v_claims.line_cd               ,
      v_claims.subline_cd            ,
      v_claims.iss_cd                ,
      v_claims.iss_cd2               ,
      v_claims.clm_yy                ,
      v_claims.clm_seq_no            ,
      v_claims.line_cd3              ,
      v_claims.subline_cd2           ,
      v_claims.pol_iss_cd            ,
      v_claims.issue_yy              ,
      v_claims.pol_seq_no            ,
      v_claims.renew_no              ,
      v_claims.clm_stat_cd           ,
      v_claims.loss_cat_cd           ,
      v_claims.assd_no               ,
      v_claims.assured_name          ,
      v_claims.loss_date             ,
      v_claims.clm_file_date         ,
      v_claims.cancel_tag            ,
      v_claims.dsp_loss_date         ,
      v_claims.recovery_no           ,
      v_claims.claim_no              ,
      v_claims.policy_no             ,
      v_claims.loss_cat_des          ,
      v_claims.clm_stat_desc         ,
      v_claims.wra                   ,
      v_claims.rec_stat_desc         ,
      v_claims.rec_stat_cd           ,
      v_claims.recovery_acct_id      ,
      v_claims.dist                  ,
      v_claims.entry                 ;
     IF v_claims.rec_stat_desc  IS NULL
        THEN
         v_claims.rec_stat_desc := 'IN PROGRESS';
     END IF;
     IF v_claims.rec_stat_cd  IS NULL
        THEN
         v_claims.rec_stat_cd := 'IP';
     END IF;
         /*v_cancel_tag := NULL;
         v_dist := NULL;
         v_entry := NULL;
         v_claims.claim_id := i.claim_id;
         v_claims.recovery_id := i.recovery_id;
         v_claims.rec_year := i.rec_year;
         v_claims.rec_seq_no := i.rec_seq_no;
         v_claims.line_cd2 := i.line_cd2;
         v_claims.iss_cd2 := i.iss_cd2;
         v_claims.line_cd3 := i.line_cd3;
         v_claims.subline_cd2 := i.subline_cd2;
         v_claims.issue_yy := i.issue_yy;
         v_claims.clm_stat_cd := i.clm_stat_cd;
         v_claims.loss_cat_cd := i.loss_cat_cd;
         v_claims.assd_no := i.assd_no;
         v_claims.loss_date := i.loss_date;
         v_claims.clm_file_date := i.clm_file_date;
         v_claims.cancel_tag := i.cancel_tag;
         v_claims.dsp_loss_date := i.dsp_loss_date;
         v_claims.line_cd := i.line_cd;
         v_claims.clm_yy := i.clm_yy;
         v_claims.clm_seq_no := i.clm_seq_no;
         v_claims.iss_cd := i.iss_cd;
         v_claims.issue_yy := i.issue_yy;
         v_claims.pol_iss_cd := i.pol_iss_cd;
         v_claims.pol_seq_no := i.pol_seq_no;
         v_claims.renew_no := i.renew_no;
         v_claims.assured_name := i.assured_name;
         v_claims.recovery_no := i.recovery_no;
         v_claims.policy_no := i.policy_no;
         v_claims.claim_no := i.claim_no;
         v_claims.loss_cat_des := i.loss_cat_des;
         v_claims.clm_stat_desc := Get_Clm_Stat_Desc(v_claims.clm_stat_cd);

         FOR chk IN (SELECT NVL (cancel_tag, 'N') xtag
                       FROM gicl_recovery_payt
                      WHERE recovery_id = i.recovery_id)
         LOOP
            IF NVL (chk.xtag, 'N') = 'N'
            THEN
               v_cancel_tag := 'true';
            ELSE
               v_cancel_tag := 'false';
            END IF;

            EXIT;
         END LOOP;

         v_claims.wra := NVL (v_cancel_tag, 'false');*/

         /*FOR j IN (SELECT UPPER (rec_stat_desc) rec_stat_desc, rec_stat_cd
                     FROM giis_recovery_status a
                    WHERE EXISTS (
                             SELECT 1
                               FROM gicl_rec_hist
                              WHERE recovery_id = i.recovery_id
                                AND rec_stat_cd = a.rec_stat_cd
                                AND rec_hist_no =
                                          (SELECT MAX (rec_hist_no)
                                             FROM gicl_rec_hist
                                            WHERE recovery_id = i.recovery_id)))
         LOOP
            v_claims.rec_stat_cd := j.rec_stat_cd;
            v_claims.rec_stat_desc := j.rec_stat_desc;
         END LOOP;

/         BEGIN --added by steven 02.07.2013;replace the old code use,it causes an error when there is no data found.
             SELECT UPPER(rec_stat_desc),rec_stat_cd
             INTO v_claims.rec_stat_desc , v_claims.rec_stat_cd
             FROM giis_recovery_status a
                WHERE EXISTS (SELECT 1
                              FROM gicl_rec_hist
                                 WHERE recovery_id = v_claims.recovery_id
                                     AND rec_stat_cd = a.rec_stat_cd
                                     AND rec_hist_no = (SELECT MAX(rec_hist_no)
                                                          FROM gicl_rec_hist
                                                             WHERE recovery_id = v_claims.recovery_id));
             EXCEPTION
               WHEN NO_DATA_FOUND THEN
                   v_claims.rec_stat_desc := 'IN PROGRESS';
                   v_claims.rec_stat_cd := 'IP';
         END;*/

         FOR payt IN (SELECT DISTINCT 'x' dist
                                 FROM gicl_recovery_payt
                                WHERE claim_id = v_claims.claim_id
                                  AND recovery_id = v_claims.recovery_id
                                  AND stat_sw = 'Y'
                                  AND NVL (cancel_tag, 'N') = 'N')
         LOOP
            v_dist := payt.dist;

            FOR payt2 IN (SELECT DISTINCT 'x' entry
                                     FROM gicl_recovery_payt
                                    WHERE claim_id = v_claims.claim_id
                                      AND recovery_id = v_claims.recovery_id
                                      AND dist_sw = 'Y')
            LOOP
               v_entry := payt2.entry;
            END LOOP;

            FOR x IN (SELECT recovery_acct_id
                       FROM GICL_RECOVERY_PAYT
                      WHERE recovery_id = v_claims.recovery_id)
             LOOP
                v_claims.recovery_acct_id := x.recovery_acct_id;
            END LOOP;
         END LOOP;



         v_claims.dist := v_dist;
         v_claims.entry := v_entry;
        EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_claims);
      END LOOP;      
     CLOSE c; 
    RETURN;
   END;
 --pjsantos end

   FUNCTION get_basic_info (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN gicl_claims_tab PIPELINED
   IS
      v_basic   gicl_claims_type;
   BEGIN
      FOR i IN (SELECT claim_id, line_cd, subline_cd, issue_yy, pol_seq_no,
                       renew_no, pol_iss_cd, clm_yy, clm_seq_no, iss_cd,
                       clm_control, clm_coop, assd_no, recovery_sw,
                       clm_file_date, loss_date, entry_date, dsp_loss_date,
                       clm_stat_cd, clm_setl_date, loss_pd_amt, loss_res_amt,
                       exp_pd_amt, loss_loc1, loss_loc2, loss_loc3,
                       in_hou_adj, pol_eff_date, csr_no, loss_cat_cd,
                       intm_no, clm_amt, loss_dtls, obligee_no, exp_res_amt,
                       ri_cd, plate_no, clm_dist_tag, assured_name,
                       assd_name2, old_stat_cd, close_date, expiry_date,
                       acct_of_cd, max_endt_seq_no, remarks, catastrophic_cd,
                       cred_branch, net_pd_loss, net_pd_exp, refresh_sw,
                       NVL (total_tag, 'N') total_tag, reason_cd,
                       province_cd, city_cd, zip_cd, pack_policy_id,
                       motor_no, serial_no, settling_agent_cd,
                       survey_agent_cd, tran_no, contact_no, email_address,
                       special_instructions, def_processor, location_cd,
                       block_id, district_no, reported_by, user_id,
                       last_update,
                       line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (clm_seq_no, '0000009')) claim_no,
                       line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09')) policy_no
                  FROM gicl_claims
                 WHERE claim_id = p_claim_id
                   AND claim_id IN (
                          SELECT a.claim_id
                            FROM gicl_claims a, giis_clm_stat b
                           WHERE a.clm_stat_cd = b.clm_stat_cd
                             AND b.clm_stat_type = 'N'))
      LOOP
         FOR clm_desc IN (SELECT clm_stat_desc
                            FROM giis_clm_stat
                           WHERE clm_stat_cd = i.clm_stat_cd)
         LOOP
            v_basic.clm_stat_desc := clm_desc.clm_stat_desc;
            EXIT;
         END LOOP;

         FOR a1 IN (SELECT d070.ri_cd ri
                      FROM giri_inpolbas d070, gipi_polbasic a
                     WHERE d070.policy_id = a.policy_id
                       AND a.renew_no = i.renew_no
                       AND a.pol_seq_no = i.pol_seq_no
                       AND a.issue_yy = i.issue_yy
                       AND a.iss_cd = i.pol_iss_cd
                       AND a.subline_cd = i.subline_cd
                       AND a.line_cd = i.line_cd)
         LOOP
            --:C003.ri_cd := a1.ri;
            FOR ri IN (SELECT ri_name
                         FROM giis_reinsurer
                        WHERE ri_cd = a1.ri)
            LOOP
               v_basic.dsp_ri_name := ri.ri_name;
            END LOOP;

            EXIT;
         END LOOP;

         FOR ad IN (SELECT a.province_desc, city
                      FROM giis_province a, giis_city b
                     WHERE a.province_cd = i.province_cd
                       AND b.city_cd = i.city_cd
                       AND b.province_cd = i.province_cd)
         LOOP
            v_basic.dsp_province_desc := ad.province_desc;
            v_basic.dsp_city_desc := ad.city;
         END LOOP;

         FOR cat IN (SELECT catastrophic_desc
                       FROM gicl_cat_dtl
                      WHERE catastrophic_cd = i.catastrophic_cd)
         LOOP
            v_basic.dsp_cat_desc := cat.catastrophic_desc;
            EXIT;
         END LOOP;

         FOR c_loss IN (SELECT loss_cat_des, peril_cd
                          FROM giis_loss_ctgry
                         WHERE loss_cat_cd = i.loss_cat_cd
                           AND line_cd = i.line_cd)
         LOOP
            v_basic.dsp_loss_cat_desc := c_loss.loss_cat_des;
            v_basic.peril_cd := c_loss.peril_cd;
            EXIT;
         END LOOP;

         FOR a1 IN (SELECT user_name
                      FROM giis_users
                     WHERE user_id = i.in_hou_adj)
         LOOP
            v_basic.dsp_in_hou_adj_name := a1.user_name;
            EXIT;
         END LOOP;

         FOR pk IN (SELECT pack_pol_flag
                      FROM giis_line
                     WHERE line_cd = i.line_cd)
         LOOP
            v_basic.pack_pol_flag := pk.pack_pol_flag;
         END LOOP;

         FOR iss IN (SELECT iss_name NAME
                       FROM giis_issource
                      WHERE iss_cd = i.cred_branch)
         LOOP
            v_basic.dsp_cred_br_desc := iss.NAME;
            EXIT;
         END LOOP;

         FOR blk IN (SELECT block_no
                       FROM giis_block
                      WHERE block_id = i.block_id)
         LOOP
            v_basic.block_no := blk.block_no;
            EXIT;
         END LOOP;

         FOR loc IN (SELECT location_desc
                       FROM giis_ca_location
                      WHERE location_cd = i.location_cd)
         LOOP
            v_basic.location_desc := loc.location_desc;
         END LOOP;

         BEGIN
            SELECT    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.renew_no, '09')),
                   a.pack_pol_flag
              INTO v_basic.pack_pol_no,
                   v_basic.pack_pol_flag
              FROM gipi_pack_polbasic a, gipi_polbasic b
             WHERE a.pack_policy_id = b.pack_policy_id
               AND a.pack_pol_flag = 'Y'
               AND b.line_cd = i.line_cd
               AND b.subline_cd = i.subline_cd
               AND b.iss_cd = i.pol_iss_cd
               AND b.issue_yy = i.issue_yy
               AND b.pol_seq_no = i.pol_seq_no
               AND b.renew_no = i.renew_no
               AND b.endt_seq_no = 0;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         BEGIN
            SELECT distinct a.assd_name -- added distinct to prevent multiple rows returned if the Policy has an endt. - irwin - 7.3.2-12
              INTO v_basic.dsp_acct_of
              FROM giis_assured a --, gipi_polbasic b
             WHERE a.assd_no = i.acct_of_cd;
--             commented out by christian 09.06.2012
--              AND b.line_cd = i.line_cd
--              AND b.iss_cd = i.pol_iss_cd
--              AND b.subline_cd = i.subline_cd
--              AND b.issue_yy = i.issue_yy
--              AND b.pol_seq_no = i.pol_seq_no
--              AND b.renew_no = i.renew_no;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_basic.dsp_acct_of := '';
         END;


         FOR iss IN (SELECT issue_date, policy_id
                       FROM gipi_polbasic
                      WHERE line_cd = i.line_cd
                        AND subline_cd = i.subline_cd
                        AND iss_cd = i.pol_iss_cd
                        AND issue_yy = i.issue_yy
                        AND pol_seq_no = i.pol_seq_no
                        AND renew_no = i.renew_no)
         LOOP
            v_basic.issue_date := iss.issue_date;
            v_basic.policy_id  := iss.policy_id;
            EXIT;
         END LOOP;


         FOR p IN (SELECT redist_sw
                     FROM gicl_clm_reserve
                    WHERE claim_id = p_claim_id)
         LOOP
            IF p.redist_sw = 'Y'
            THEN
               v_basic.redist_sw := 'Y';
            ELSE
               v_basic.redist_sw := '';
            END IF;
         END LOOP;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (p_claim_id)
           INTO v_basic.gicl_mortgagee_exist
           FROM DUAL;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist (p_claim_id)
           INTO v_basic.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_clm_item_pkg.get_gicl_clm_item_exist (p_claim_id)
           INTO v_basic.gicl_clm_item_exist
           FROM DUAL;

         SELECT gicl_clm_reserve_pkg.get_gicl_clm_reserve_exist (p_claim_id)
           INTO v_basic.gicl_clm_reserve_exist
           FROM DUAL;

         BEGIN
            SELECT    a.line_cd
                   || '-'
                   || a.op_subline_cd
                   || '-'
                   || a.op_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.op_issue_yy, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.op_pol_seqno, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (a.op_renew_no, '09'))
              INTO v_basic.op_number
              FROM gipi_open_policy a, gicl_clm_polbas b
             WHERE a.policy_id = b.policy_id AND b.claim_id = v_basic.claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_basic.op_number := NULL;
         END;


         FOR rec IN (SELECT gv.item_no
                       FROM gipi_vehicle gv, gipi_polbasic gp
                      WHERE gp.policy_id = gv.policy_id
                        AND gp.line_cd = i.line_cd
                        AND gp.subline_cd = i.subline_cd
                        AND gp.iss_cd = i.pol_iss_cd
                        AND gp.issue_yy = i.issue_yy
                        AND gp.pol_seq_no = i.pol_seq_no
                        AND gp.renew_no = i.renew_no
                        AND gv.plate_no = i.plate_no)
         LOOP
            v_basic.item_no := rec.item_no;
         END LOOP;

         v_basic.dsp_settling_name :=
            get_payee_name (i.settling_agent_cd,
                            giisp.v ('SETTLING_PAYEE_CLASS')
                           );
         v_basic.dsp_survey_name :=
            get_payee_name (i.survey_agent_cd, giisp.v ('SURVEY_PAYEE_CLASS'));
         v_basic.claim_id := i.claim_id;
         v_basic.line_cd := i.line_cd;
         v_basic.line_name := get_line_name(i.line_cd);
         v_basic.subline_cd := i.subline_cd;
         v_basic.issue_yy := i.issue_yy;
         v_basic.pol_seq_no := i.pol_seq_no;
         v_basic.renew_no := i.renew_no;
         v_basic.pol_iss_cd := i.pol_iss_cd;
         v_basic.clm_yy := i.clm_yy;
         v_basic.clm_seq_no := i.clm_seq_no;
         v_basic.iss_cd := i.iss_cd;
         v_basic.clm_control := i.clm_control;
         v_basic.clm_coop := i.clm_coop;
         v_basic.assd_no := i.assd_no;
         v_basic.recovery_sw := i.recovery_sw;
         v_basic.clm_file_date := i.clm_file_date;
         v_basic.loss_date := i.loss_date;
         v_basic.entry_date := i.entry_date;
         v_basic.dsp_loss_date := i.dsp_loss_date;
         v_basic.clm_stat_cd := i.clm_stat_cd;
         v_basic.clm_setl_date := i.clm_setl_date;
         v_basic.loss_pd_amt := i.loss_pd_amt;
         v_basic.loss_res_amt := i.loss_res_amt;
         v_basic.exp_pd_amt := i.exp_pd_amt;
         v_basic.loss_loc1 := i.loss_loc1;
         v_basic.loss_loc2 := i.loss_loc2;
         v_basic.loss_loc3 := i.loss_loc3;
         v_basic.in_hou_adj := i.in_hou_adj;
         v_basic.csr_no := i.csr_no;
         v_basic.intm_no := i.intm_no;
         v_basic.clm_amt := i.clm_amt;
         v_basic.loss_dtls := i.loss_dtls;
         v_basic.obligee_no := i.obligee_no;
         v_basic.exp_res_amt := i.exp_res_amt;
         v_basic.assured_name := i.assured_name;
         v_basic.assd_name2 := i.assd_name2;
         v_basic.ri_cd := i.ri_cd;
         v_basic.plate_no := i.plate_no;
         v_basic.clm_dist_tag := i.clm_dist_tag;
         v_basic.old_stat_cd := i.old_stat_cd;
         v_basic.close_date := i.close_date;
         v_basic.expiry_date := i.expiry_date;
         v_basic.acct_of_cd := i.acct_of_cd;
         v_basic.max_endt_seq_no := i.max_endt_seq_no;
         v_basic.remarks := i.remarks;
         v_basic.catastrophic_cd := i.catastrophic_cd;
         v_basic.cred_branch := i.cred_branch;
         v_basic.net_pd_loss := i.net_pd_loss;
         v_basic.refresh_sw := i.refresh_sw;
         v_basic.net_pd_exp := i.net_pd_exp;
         v_basic.total_tag := i.total_tag;
         v_basic.reason_cd := i.reason_cd;
         v_basic.province_cd := i.province_cd;
         v_basic.city_cd := i.city_cd;
         v_basic.zip_cd := i.zip_cd;
         v_basic.pack_policy_id := i.pack_policy_id;
         v_basic.motor_no := i.motor_no;
         v_basic.serial_no := i.serial_no;
         v_basic.settling_agent_cd := i.settling_agent_cd;
         v_basic.survey_agent_cd := i.survey_agent_cd;
         v_basic.tran_no := i.tran_no;
         v_basic.contact_no := i.contact_no;
         v_basic.email_address := i.email_address;
         v_basic.special_instructions := i.special_instructions;
         v_basic.def_processor := i.def_processor;
         v_basic.location_cd := i.location_cd;
         v_basic.block_id := i.block_id;
         v_basic.district_no := i.district_no;
         v_basic.reported_by := i.reported_by;
         v_basic.user_id := i.user_id;
         v_basic.last_update := i.last_update;
         v_basic.pol_eff_date := i.pol_eff_date;
         v_basic.loss_cat_cd := i.loss_cat_cd;
         v_basic.dsp_claim_no := i.claim_no;
         v_basic.dsp_policy_no := i.policy_no;

         SELECT COUNT(DISTINCT b.item_no)
           INTO v_basic.item_limit
           FROM gipi_polbasic a, gipi_item b
          WHERE a.line_cd = i.line_cd
            AND a.subline_cd = i.subline_cd
            AND a.iss_cd = i.pol_iss_cd
            AND a.issue_yy = i.issue_yy
            AND a.pol_seq_no = i.pol_seq_no
            AND a.renew_no = i.renew_no
            AND a.pol_flag IN ('1', '2', '3', '4', 'X')	--kenneth SR 4855 10.07.2015
            --AND TRUNC (a.eff_date) <= TRUNC(i.loss_date) replaced condition by robert 04.11.2013 sr 12745
            AND TRUNC (DECODE (TRUNC (a.eff_date),
                      TRUNC (a.incept_date), TRUNC (i.pol_eff_date),
                      TRUNC (a.eff_date)
                     )
             ) <= TRUNC (i.loss_date)
            --end robert
            AND TRUNC (DECODE (NVL (a.endt_expiry_date, a.expiry_date),
                               a.expiry_date, i.expiry_date,
                               a.endt_expiry_date
                              )
                      ) >= TRUNC(i.loss_date)
            AND a.policy_id = b.policy_id;

         PIPE ROW (v_basic);
      END LOOP;
   END;

   FUNCTION get_clm_assured (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_renew_no     gicl_claims.line_cd%TYPE
   )
      RETURN gicl_claims_listing_tab PIPELINED
   IS
      v_assd   gicl_claims_listing_type;
   BEGIN
      FOR i IN (SELECT   assured_name, assd_no
                    FROM gicl_claims
                   WHERE line_cd = NVL (p_line_cd, line_cd)
                     AND subline_cd = NVL (p_subline_cd, subline_cd)
                     AND iss_cd = NVL (p_pol_iss_cd, iss_cd)
                     AND issue_yy = NVL (p_issue_yy, issue_yy)
                     AND renew_no = NVL (p_renew_no, renew_no)
                GROUP BY assured_name, assd_no)
      LOOP
         v_assd.assured_name := i.assured_name;
         v_assd.assd_no := i.assd_no;
         PIPE ROW (v_assd);
      END LOOP;
   END get_clm_assured;

   PROCEDURE update_gicl_claims_gicls010 (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_clm_stat_cd     gicl_claims.clm_stat_cd%TYPE,
      p_clm_control     gicl_claims.clm_control%TYPE,
      p_clm_coop        gicl_claims.clm_coop%TYPE,
      p_unpaid_prem     VARCHAR2,
      p_upd_user_flag   VARCHAR2
   )
   IS
   BEGIN
      IF p_upd_user_flag = 'Y'
      THEN
         UPDATE gicl_claims
            SET clm_control = p_clm_control,
                clm_coop = p_clm_coop,
                clm_stat_cd = p_clm_stat_cd,
                last_update = SYSDATE,
                user_id = NVL (giis_users_pkg.app_user, USER)
          WHERE claim_id = p_claim_id;
      ELSE
         UPDATE gicl_claims
            SET clm_control = p_clm_control,
                clm_coop = p_clm_coop,
                clm_stat_cd = p_clm_stat_cd
          WHERE claim_id = p_claim_id;
      END IF;

      IF p_unpaid_prem = 'Y'
      THEN
         gipi_user_events_pkg.set_workflow_gicls010 (p_claim_id,
                                                     p_clm_stat_cd
                                                    );
      END IF;
   END;

   FUNCTION get_basic_intm_dtls (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN basic_intm_tab PIPELINED
   IS
      v_basic   basic_intm_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM gicl_basic_intm_v1
                 WHERE claim_id = p_claim_id)
      LOOP
         v_basic.claim_id := i.claim_id;
         v_basic.policy_no := i.policy_no;
         v_basic.intm_no := i.intrmdry_intm_no;
         v_basic.parent_intm_no := i.parent_intm_no;
         v_basic.intm_type := i.intm_type;
         v_basic.intm_name := i.intm_name;
         PIPE ROW (v_basic);
      END LOOP;
   END;

   /**
   * Rey Jadlocon
   * 09-01-2011
   * Casuanty Item Info
   **/
   FUNCTION get_casualty_item_info (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN get_casualty_item_info_tab PIPELINED
   IS
      v_casualty_item_info   get_casualty_item_info_type;
   BEGIN
      FOR i IN (SELECT DISTINCT    a.line_cd
                                || '-'
                                || subline_cd
                                || '-'
                                || iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (clm_yy, '00'))
                                || '-'
                                || LTRIM (TO_CHAR (clm_seq_no, '0000009'))
                                                                    claim_no,
                                   a.line_cd
                                || '-'
                                || subline_cd
                                || '-'
                                || pol_iss_cd
                                || '-'
                                || LTRIM (TO_CHAR (issue_yy, '00'))
                                || '-'
                                || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                                || '-'
                                || LTRIM (TO_CHAR (renew_no, '00'))
                                                                   policy_no,
                                a.line_cd, a.dsp_loss_date, a.loss_date,
                                assured_name,
                                   b.loss_cat_cd
                                || '-'
                                || b.loss_cat_des loss_ctgry,
                                a.renew_no, a.pol_seq_no, a.issue_yy,
                                a.pol_iss_cd, a.subline_cd, a.expiry_date,
                                a.pol_eff_date, a.claim_id, c.clm_stat_desc,
                                a.catastrophic_cd, clm_file_date,
                                a.loss_cat_cd, d.item_no, d.peril_cd,
                                d.close_flag, f.item_title,
                                f.grouped_item_no, f.grouped_item_title,
                                f.currency_cd, g.currency_desc,
                                f.currency_rate, f.section_or_hazard_info,
                                f.section_or_hazard_cd, h.item_desc,
                                h.item_desc2, f.property_no,
                                f.property_no_type, f.LOCATION,
                                f.conveyance_info, f.interest_on_premises,
                                f.amount_coverage, f.limit_of_liability,
                                f.capacity_cd
                           FROM gicl_claims a,
                                giis_loss_ctgry b,
                                giis_clm_stat c,
                                gicl_item_peril d,
                                gicl_casualty_dtl f,
                                giis_currency g,
                                gicl_clm_item h
                          WHERE a.loss_cat_cd = b.loss_cat_cd(+)
                            AND a.claim_id = f.claim_id
                            AND d.claim_id = h.claim_id(+)
                            AND d.item_no = h.item_no(+)
                            AND d.grouped_item_no = h.grouped_item_no(+)
                            AND f.currency_cd = g.main_currency_cd(+)
                            AND d.item_no = f.item_no(+)
                            AND a.line_cd = b.line_cd(+)
                            AND a.clm_stat_cd = c.clm_stat_cd(+)
                            AND a.claim_id = d.claim_id(+)
                            AND a.claim_id = p_claim_id)
      LOOP
         FOR itm IN (SELECT 1
                       FROM gicl_item_peril
                      WHERE item_no = i.item_no
                        AND grouped_item_no = i.grouped_item_no
                        AND claim_id = i.claim_id)
         LOOP
            v_casualty_item_info.itm := 'X';
         END LOOP;

         v_casualty_item_info.claim_no := i.claim_no;
         v_casualty_item_info.policy_no := i.policy_no;
         v_casualty_item_info.line_cd := i.line_cd;
         v_casualty_item_info.dsp_loss_date := i.dsp_loss_date;
         v_casualty_item_info.loss_date := i.loss_date;
         v_casualty_item_info.assured_name := i.assured_name;
         v_casualty_item_info.renew_no := i.renew_no;
         v_casualty_item_info.loss_ctgry := i.loss_ctgry;
         v_casualty_item_info.pol_seq_no := i.pol_seq_no;
         v_casualty_item_info.issue_yy := i.issue_yy;
         v_casualty_item_info.pol_iss_cd := i.pol_iss_cd;
         v_casualty_item_info.subline_cd := i.subline_cd;
         v_casualty_item_info.expiry_date := i.expiry_date;
         v_casualty_item_info.pol_eff_date := i.pol_eff_date;
         v_casualty_item_info.claim_id := i.claim_id;
         v_casualty_item_info.clm_stat_desc := i.clm_stat_desc;
         v_casualty_item_info.catastrophic_cd := i.catastrophic_cd;
         v_casualty_item_info.clm_file_date := i.clm_file_date;
         v_casualty_item_info.loss_cat_cd := i.loss_cat_cd;
         v_casualty_item_info.item_no := i.item_no;
         v_casualty_item_info.peril_cd := i.peril_cd;
         v_casualty_item_info.close_flag := i.close_flag;
         v_casualty_item_info.item_title := i.item_title;
         v_casualty_item_info.grouped_item_no := i.grouped_item_no;
         v_casualty_item_info.grouped_item_title := i.grouped_item_title;
         v_casualty_item_info.currency_cd := i.currency_cd;
         v_casualty_item_info.currency_desc := i.currency_desc;
         v_casualty_item_info.currency_rate := i.currency_rate;
         v_casualty_item_info.section_or_hazard_info :=
                                                      i.section_or_hazard_info;
         v_casualty_item_info.section_or_hazard_cd := i.section_or_hazard_cd;
         v_casualty_item_info.item_desc := i.item_desc;
         v_casualty_item_info.item_desc2 := i.item_desc2;
         v_casualty_item_info.property_no := i.property_no;
         v_casualty_item_info.property_no_type := i.property_no_type;
         v_casualty_item_info.LOCATION := i.LOCATION;
         v_casualty_item_info.conveyance_info := i.conveyance_info;
         v_casualty_item_info.interest_on_premises := i.interest_on_premises;
         v_casualty_item_info.amount_coverage := i.amount_coverage;
         v_casualty_item_info.limit_of_liability := i.limit_of_liability;

         IF i.capacity_cd IS NULL
         THEN
            v_casualty_item_info.capacity_cd := NULL;
         ELSE
            v_casualty_item_info.capacity_cd := i.capacity_cd;
         END IF;

         SELECT gicl_item_peril_pkg.get_gicl_item_peril_exist
                                                (v_casualty_item_info.item_no,
                                                 v_casualty_item_info.claim_id
                                                )
           INTO v_casualty_item_info.gicl_item_peril_exist
           FROM DUAL;

         SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist
                                                (v_casualty_item_info.item_no,
                                                 v_casualty_item_info.claim_id
                                                )
           INTO v_casualty_item_info.gicl_mortgagee_exist
           FROM DUAL;

         gicl_item_peril_pkg.validate_peril_reserve
                                     (v_casualty_item_info.item_no,
                                      v_casualty_item_info.claim_id,
                                      0, --belle grouped item no 02.13.2012
                                      v_casualty_item_info.gicl_item_peril_msg
                                     );
         PIPE ROW (v_casualty_item_info);
      END LOOP;

      RETURN;
   END get_casualty_item_info;

   /*
   **  Created by    : Jerome Orio
   **  Date Created  : 09.16.2011
   **  Reference By  : (GICLS015 - Fire Item Information)
   **  Description   :  post-form-commit in Claims Item Information
   */
   PROCEDURE clm_item_post_form_commit (p_claim_id gicl_claims.claim_id%TYPE)
   IS
      v_exp_amt    gicl_claims.exp_res_amt%TYPE;
      v_loss_amt   gicl_claims.loss_res_amt%TYPE;
   BEGIN
      /* first select summation of amounts in gicl_clm_reserve
      ** amount of reserve should only be from valid item peril
      ** those that are not withdrawn, cancelled or denied */
      FOR sum_amt IN (SELECT SUM (loss_reserve) loss_reserve,
                             SUM (expense_reserve) exp_reserve
                        FROM gicl_clm_reserve a, gicl_item_peril b
                       WHERE a.claim_id = b.claim_id
                         AND a.item_no = b.item_no
                         AND a.grouped_item_no = b.grouped_item_no
                         --added by gmi
                         AND a.peril_cd = b.peril_cd
                         AND a.claim_id = p_claim_id
                         AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP'))
      LOOP
         v_loss_amt := sum_amt.loss_reserve;
         v_exp_amt := sum_amt.exp_reserve;
         EXIT;
      END LOOP;

      --update gicl_claims
      UPDATE gicl_claims
         SET loss_res_amt = v_loss_amt,
             exp_res_amt = v_exp_amt
       WHERE claim_id = p_claim_id;
   END;

   PROCEDURE check_plate_no (
      p_plate_no        IN OUT   gicl_claims.plate_no%TYPE,
      p_dsp_loss_date   IN OUT   VARCHAR2,
      claim_no          OUT      VARCHAR2,
      RESULT            OUT      VARCHAR2
   )
   IS
   BEGIN
      RESULT := 'N';

      FOR i IN
         (SELECT loss_date,
                    line_cd
                 || '-'
                 || subline_cd
                 || '-'
                 || iss_cd
                 || '-'
                 || issue_yy
                 || '-'
                 || clm_seq_no claim_no
            FROM gicl_claims
           WHERE plate_no = p_plate_no
             AND TRUNC (dsp_loss_date) =
                                       TO_DATE (p_dsp_loss_date, 'MM-DD-YYYY')
             AND clm_stat_cd NOT IN (
                    SELECT clm_stat_cd
                      FROM giis_clm_stat
                     WHERE clm_stat_desc IN
                                         ('CANCELLED', 'DENIED', 'WITHDRAWN')))
      LOOP
         RESULT := 'Y';
         claim_no := i.claim_no;
         p_dsp_loss_date := p_dsp_loss_date;
      END LOOP;
   END;

   PROCEDURE check_motor_no (
      p_motor_no        IN OUT   gicl_claims.motor_no%TYPE,
      p_dsp_loss_date   IN OUT   VARCHAR2,
      claim_no          OUT      VARCHAR2,
      RESULT            OUT      VARCHAR2
   )
   IS
   BEGIN
      RESULT := 'N';

      FOR i IN (SELECT claim_id
                  FROM gicl_motor_car_dtl
                 WHERE motor_no = p_motor_no
                   AND TRUNC (loss_date) =
                                       TO_DATE (p_dsp_loss_date, 'MM-DD-YYYY'))
      LOOP
         FOR j IN (SELECT loss_date,
                             line_cd
                          || '-'
                          || subline_cd
                          || '-'
                          || iss_cd
                          || '-'
                          || issue_yy
                          || '-'
                          || clm_seq_no claim_no
                     FROM gicl_claims
                    WHERE claim_id = i.claim_id)
         LOOP
            claim_no := j.claim_no;
            p_dsp_loss_date := j.loss_date;
            RESULT := 'Y';
--means that there's an existing claim that has same motor number and loss date
         END LOOP;
      END LOOP;
   END;

   PROCEDURE check_serial_no (
      p_serial_no       IN OUT   gicl_claims.motor_no%TYPE,
      p_dsp_loss_date   IN OUT   VARCHAR2,
      claim_no          OUT      VARCHAR2,
      RESULT            OUT      VARCHAR2
   )
   IS
   BEGIN
      RESULT := 'N';

      FOR i IN (SELECT claim_id
                  FROM gicl_motor_car_dtl
                 WHERE serial_no = p_serial_no
                   AND TRUNC (loss_date) =
                                       TO_DATE (p_dsp_loss_date, 'MM-DD-YYYY'))
      LOOP
         --msg_alert(i.count,'I',false);--++
         FOR j IN (SELECT loss_date,
                             line_cd
                          || '-'
                          || subline_cd
                          || '-'
                          || iss_cd
                          || '-'
                          || issue_yy
                          || '-'
                          || clm_seq_no claim_no
                     FROM gicl_claims
                    WHERE claim_id = i.claim_id)
         LOOP
            claim_no := j.claim_no;
            p_dsp_loss_date := j.loss_date;
            RESULT := 'Y';
         END LOOP;
      END LOOP;
   END;

   /*
   **  Created by    : Belle Bebing
   **  Date Created  : 09.20.2011
   **  Reference By  : GICLS041 - Print Claims Documents
   */
   FUNCTION get_claim_info_gicls041 (p_claim_id gicl_claims.claim_id%TYPE)
      RETURN gicl_claims_tab PIPELINED
   IS
      v_claim_info   gicl_claims_type;
   BEGIN
      FOR i IN (SELECT   assd_no, assured_name, loss_date, line_cd,
                            line_cd
                         || '-'
                         || subline_cd
                         || '-'
                         || iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (renew_no, '09')) policy_no
                    FROM gicl_claims
                   WHERE claim_id = p_claim_id
                ORDER BY line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no)
      LOOP
         v_claim_info.claim_no := get_clm_no (p_claim_id);
         v_claim_info.policy_no := i.policy_no;
         v_claim_info.assured_name := i.assured_name;
         v_claim_info.dsp_loss_date := i.loss_date;
         v_claim_info.line_cd := i.line_cd;

         BEGIN
            SELECT a.loss_cat_cd || '-' || b.loss_cat_des loss_cat
              INTO v_claim_info.loss_ctgry
              FROM gicl_claims a, giis_loss_ctgry b
             WHERE a.line_cd = b.line_cd
               AND a.loss_cat_cd = b.loss_cat_cd
               AND a.claim_id = p_claim_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         PIPE ROW (v_claim_info);
      END LOOP;
   END get_claim_info_gicls041;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 09.22.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : Checks claim status from gicl_clm_stat_hist
    **/
   PROCEDURE check_claim_status (
      p_line_cd            gicl_claims.line_cd%TYPE,
      p_subline_cd         gicl_claims.subline_cd%TYPE,
      p_iss_cd             gicl_claims.iss_cd%TYPE,
      p_clm_yy             gicl_claims.clm_yy%TYPE,
      p_clm_seq_no         gicl_claims.clm_seq_no%TYPE,
      p_msg_alert    OUT   VARCHAR2
   )
   IS
      v_clm_stat_cd      gicl_clm_stat_hist.clm_stat_cd%TYPE;
      cancelled_before   NUMBER (1)                            := 0;
      clm_stat_cd        gicl_clm_stat_hist.clm_stat_cd%TYPE;
      clm_stat_type      giis_clm_stat.clm_stat_type%TYPE;
      v_claim_id         gicl_claims.claim_id%TYPE;

      CURSOR claims
      IS
         SELECT claim_id
           FROM gicl_claims
          WHERE line_cd = p_line_cd
            AND subline_cd = p_subline_cd
            AND iss_cd = p_iss_cd
            AND clm_yy = p_clm_yy
            AND clm_seq_no = p_clm_seq_no;
   BEGIN
      IF p_clm_seq_no IS NOT NULL
      THEN
         OPEN claims;

         FETCH claims
          INTO v_claim_id;

         IF claims%FOUND
         THEN
            FOR al IN (SELECT b.clm_stat_type clm_stat_type
                         FROM gicl_claims a, giis_clm_stat b
                        WHERE a.claim_id = v_claim_id
                          AND a.clm_stat_cd = b.clm_stat_cd)
            LOOP
               clm_stat_type := al.clm_stat_type;
               --variable.v_stat_type := clm_stat_type;
               EXIT;
            END LOOP;

            IF clm_stat_type IN ('N', 'X')
            THEN
               FOR al IN (SELECT clm_stat_cd
                            FROM gicl_clm_stat_hist
                           WHERE claim_id = v_claim_id)
               LOOP
                  cancelled_before := 1;
                  clm_stat_cd := al.clm_stat_cd;
                  EXIT;
               END LOOP;

               BEGIN
                  SELECT param_value_v
                    INTO v_clm_stat_cd
                    FROM giac_parameters
                   WHERE param_name = 'CANCELLED';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert :=
                        'CANCELLED not found in giac_parameters. Please contact your DBA.';
                     RETURN;
               END;

               BEGIN
                  SELECT param_value_v
                    INTO v_clm_stat_cd
                    FROM giac_parameters
                   WHERE param_name = 'WITHDRAWN';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert :=
                        'WITHDRAWN not found in giac_parameters. Please contact your DBA.';
                     RETURN;
               END;

               BEGIN
                  SELECT param_value_v
                    INTO v_clm_stat_cd
                    FROM giac_parameters
                   WHERE param_name = 'DENIED';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert :=
                        'DENIED not found in giac_parameters. Please contact your DBA.';
                     RETURN;
               END;

               BEGIN
                  SELECT param_value_v
                    INTO v_clm_stat_cd
                    FROM giac_parameters
                   WHERE param_name = 'CLOSED CLAIM';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert :=
                        'CLOSED CLAIM not found in giac_parameters. Please contact your DBA.';
                     RETURN;
               END;

               /*variable.v_claim_id := v_claim_id;
               IF variable.motor_canvas = 0 AND variable.item_canvas = 0 THEN
                  allow_IDU('C003',TRUE);
               END IF;*/
               NULL;
            ELSE
               --allow_IDU('C003',false);
               /*set_block_property('C003',insert_allowed,property_false);
               set_block_property('C003',delete_allowed,property_false);    */
               NULL;
            END IF;
         END IF;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 09.29.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : assign values to acct_of_cd, assd_no and assured_name (and obligee_no for Surety).
    **/
   PROCEDURE get_assured_obligee (
      p_assd_no       IN OUT   gipi_wpolbas.assd_no%TYPE,
      p_assd_name     IN OUT   giis_assured.assd_name%TYPE,
      p_acct_of_cd    IN OUT   gicl_claims.acct_of_cd%TYPE,
      p_obligee_no    IN OUT   gicl_claims.obligee_no%TYPE,
      p_line_cd                gipi_polbasic.line_cd%TYPE,
      p_subline_cd             gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd             gipi_polbasic.iss_cd%TYPE,
      p_issue_yy               gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no             gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no               gipi_polbasic.renew_no%TYPE,
      p_loss_date              gipi_polbasic.eff_date%TYPE,
      p_expiry_date            gipi_polbasic.expiry_date%TYPE
   )
   IS
   BEGIN
      search_for_assured4 (p_assd_no,   --kenneth SR 4855 10.07.2015
                           p_assd_name,
                           p_line_cd,
                           p_subline_cd,
                           p_pol_iss_cd,
                           p_issue_yy,
                           p_pol_seq_no,
                           p_renew_no,
                           p_loss_date,
                           p_expiry_date
                          );
      search_for_acct_cd2 (p_acct_of_cd,    --kenneth SR 4855 10.07.2015
                          p_line_cd,
                          p_subline_cd,
                          p_pol_iss_cd,
                          p_issue_yy,
                          p_pol_seq_no,
                          p_renew_no,
                          p_loss_date,
                          p_expiry_date
                         );

      IF p_line_cd = giisp.v ('SURETYSHIP')
      THEN
         FOR c1 IN (SELECT   b.obligee_no
                        FROM gipi_polbasic a, gipi_bond_basic b
                       WHERE b.policy_id = a.policy_id
                         AND a.line_cd = p_line_cd
                         AND a.subline_cd = p_subline_cd
                         AND a.iss_cd = p_pol_iss_cd
                         AND a.issue_yy = p_issue_yy
                         AND a.pol_seq_no = p_pol_seq_no
                         AND a.renew_no = p_renew_no
                    ORDER BY a.endt_seq_no DESC)
         LOOP
            IF c1.obligee_no IS NOT NULL
            THEN
               p_obligee_no := c1.obligee_no;
               EXIT;
            ELSE
               NULL;
            END IF;
         END LOOP;
      END IF;
   END get_assured_obligee;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 09.29.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : validate policy no. in claims basic info
    **/
   PROCEDURE validate_policy_no (
      p_line_cd          IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd       IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd       IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy         IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no       IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no         IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date        IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date     OUT      VARCHAR2,   --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date      OUT      VARCHAR2,  --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date       OUT      VARCHAR2,   --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no          OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name        OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd       OUT      gicl_claims.acct_of_cd%TYPE,
      p_acct_of_name     OUT      giis_assured.assd_name%TYPE, --added by christian
      p_obligee_no       OUT      gicl_claims.obligee_no%TYPE,
      p_nbt_pk_pol       OUT      VARCHAR2,
      p_nbt_pack_pol     OUT      gipi_polbasic.pack_pol_flag%TYPE,
      p_pack_policy_id   OUT      gipi_polbasic.pack_policy_id%TYPE,
      p_msg_alert        OUT      VARCHAR2,
      p_msg_alert2       OUT      VARCHAR2,
      p_msg_alert3       OUT      VARCHAR2,
      p_exp_date_sw      OUT      VARCHAR2,
      p_item_no          OUT      gipi_vehicle.item_no%TYPE,
      p_plate_no         OUT      gipi_vehicle.plate_no%TYPE,
      p_motor_no         OUT      gipi_vehicle.motor_no%TYPE,
      p_serial_no        OUT      gipi_vehicle.serial_no%TYPE,
      p_plate_sw         OUT      VARCHAR2,
      p_package_sw       OUT      VARCHAR2,
      p_menu_line_cd     OUT      giis_line.menu_line_cd%TYPE --added by jeffdojello 10.01.2013
   )
   IS
      validate_flag     BOOLEAN                        := TRUE;
      polflag           BOOLEAN                        := TRUE;
      v_pack_pol_flag   giis_line.pack_pol_flag%TYPE;
      v_expiry_date     DATE;
      v_pol_eff_date    DATE;
      v_plate_ctr       NUMBER                         := 0;
   BEGIN
      /*will check if all items of the policy was tagged as total loss
       ** if yes, disallow user to continue creating claim.
       */
      IF     p_line_cd IS NOT NULL
         AND p_subline_cd IS NOT NULL
         AND p_pol_iss_cd IS NOT NULL
         AND p_issue_yy IS NOT NULL
         AND p_pol_seq_no IS NOT NULL
         AND p_renew_no IS NOT NULL
      THEN
         check_total_loss (p_line_cd,
                           p_subline_cd,
                           p_pol_iss_cd,
                           p_issue_yy,
                           p_pol_seq_no,
                           p_renew_no,
                           p_msg_alert
                          );

         IF p_msg_alert IS NOT NULL
         THEN
            RETURN;
         END IF;
      END IF;
      
      
      IF p_line_cd IS NOT NULL THEN --added by jeffdojello 10.01.2013
        SELECT menu_line_cd
          INTO p_menu_line_cd
          FROM giis_line
         WHERE line_cd = p_line_cd; 
      END IF;

      IF validate_flag
      THEN
         /** will skip validation if claim is created by entering the plate no.
         */
         BEGIN
            /* allow user to continue processing claim even if policy is Undistributed. */
            /* modified validation of policy distribution of claim.*/
            DECLARE
               v_dist_param   giis_parameters.param_value_v%TYPE;
               v_exists       VARCHAR2 (1)                         := NULL;
               v_exist2       VARCHAR2 (1)                         := 'N';
               v_exist3       VARCHAR2 (1)                         := 'N';
               v_flag         VARCHAR2 (1)                         := NULL;
               love           BOOLEAN;
               v_count        NUMBER (5);
               v_allow        VARCHAR2 (1);
               v_prorate_flag VARCHAR2 (1)                         := NULL; --kenneth SR 4855 10.07.2015
            BEGIN
               /* validate policy number being processed for CLAIMS so that
               ** validation from other items will not be needed
               */
               IF p_renew_no IS NULL
               THEN
                  p_msg_alert :=
                     'Policy not valid for Claim. Please verify your policy number. Policy must be Existing.';
                  --,'I',FALSE);
                  polflag := FALSE;
                  RETURN;
               END IF;

               IF p_renew_no IS NOT NULL
               THEN
                  FOR rec IN (SELECT param_value_v
                                FROM giis_parameters
                               WHERE param_name = 'DISTRIBUTED')
                  LOOP
                     v_dist_param := rec.param_value_v;
                     EXIT;
                  END LOOP;

                  /* Added query for package policy
                  ** this is to handle non-existing policies
                  */
                  FOR pol IN (SELECT policy_id
                                FROM gipi_polbasic a
                               WHERE a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_cd
                                 AND a.iss_cd = p_pol_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.renew_no = p_renew_no
                              UNION
                              SELECT pack_policy_id
                                FROM gipi_pack_polbasic
                               WHERE line_cd = p_line_cd
                                 AND subline_cd = p_subline_cd
                                 AND iss_cd = p_pol_iss_cd
                                 AND issue_yy = p_issue_yy
                                 AND pol_seq_no = p_pol_seq_no
                                 AND renew_no = p_renew_no)
                  LOOP
                     v_exist2 := 'Y';
                  END LOOP;

                  IF v_exist2 = 'N'
                  THEN
                     p_renew_no := NULL;
                     p_msg_alert :=
                        'Policy not valid for Claim. Please verify your policy number. Policy must be Existing.';
                     --,'I',FALSE);
                     polflag := FALSE;
                     RETURN;
                  END IF;

                  /* This is to handle policies that are cancelled or spoiled.
                  ** Added query for package policy
                  */
                  FOR cncld IN (SELECT pol_flag
                                  FROM gipi_polbasic a
                                 WHERE a.line_cd = p_line_cd
                                   AND a.subline_cd = p_subline_cd
                                   AND a.iss_cd = p_pol_iss_cd
                                   AND a.issue_yy = p_issue_yy
                                   AND a.pol_seq_no = p_pol_seq_no
                                   AND a.renew_no = p_renew_no
                                   AND a.endt_seq_no = 0
                                UNION
                                SELECT pol_flag
                                  FROM gipi_pack_polbasic
                                 WHERE line_cd = p_line_cd
                                   AND subline_cd = p_subline_cd
                                   AND iss_cd = p_pol_iss_cd
                                   AND issue_yy = p_issue_yy
                                   AND pol_seq_no = p_pol_seq_no
                                   AND renew_no = p_renew_no
                                   AND endt_seq_no = 0)
                  LOOP
                     v_flag := cncld.pol_flag;
                  END LOOP;
                  
                  --start kenneth SR 4855 10.07.2015
                  FOR pro IN (SELECT prorate_flag
                                FROM gipi_polbasic a
                               WHERE a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_cd
                                 AND a.iss_cd = p_pol_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.renew_no = p_renew_no
                                 AND a.endt_seq_no = (SELECT MAX (b.endt_seq_no) endt_seq_no
                                                        FROM gipi_polbasic b
                                                       WHERE b.line_cd = p_line_cd
                                                         AND b.subline_cd = p_subline_cd
                                                         AND b.iss_cd = p_pol_iss_cd
                                                         AND b.issue_yy = p_issue_yy
                                                         AND b.pol_seq_no = p_pol_seq_no
                                                         AND b.renew_no = p_renew_no))
                  LOOP
                    v_prorate_flag := pro.prorate_flag;
                    EXIT;
                  END LOOP;
                  --end kenneth SR 4855 10.07.2015
                  
                  IF v_flag = '4' AND v_prorate_flag = '2'  --kenneth SR 4855 10.07.2015
                  THEN
                     p_renew_no := NULL;
                     p_msg_alert :=
                        'Policy not valid for Claim. Please verify your policy number. Policy must not be Cancelled.';
                     --,'I',FALSE);
                     polflag := FALSE;
                     RETURN;
                  END IF;

                  IF v_flag = '5'
                  THEN
                     p_renew_no := NULL;
                     p_msg_alert :=
                        'Policy not valid for Claim. Please verify your policy number. Policy must not be Spoiled.';
                     --,'I',FALSE);
                     polflag := FALSE;
                     RETURN;
                  END IF;

                  -- for policy that are already expired ask the user if he still want to
                  -- process the claim
                  IF v_flag = 'X'
                  THEN
                     p_exp_date_sw := 'EXPIRED_DATE_ALERT';
                  END IF;

                  /* Will automatically display list of policies if
                  ** line is package.
                  */
                  FOR pk IN (SELECT pack_pol_flag
                               FROM giis_line
                              WHERE line_cd = p_line_cd)
                  LOOP
                     v_pack_pol_flag := pk.pack_pol_flag;
                  END LOOP;

                  IF NVL (v_pack_pol_flag, 'N') = 'Y'
                  THEN
                     p_nbt_pk_pol :=
                           p_line_cd
                        || '-'
                        || p_subline_cd
                        || '-'
                        || p_pol_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (p_issue_yy, '09'))
                        || '-'
                        || LTRIM (TO_CHAR (p_pol_seq_no, '0999999'))
                        || '-'
                        || LTRIM (TO_CHAR (p_renew_no, '09'));
                     /*p_nbt_pk_lbl := 'Package Policy         :';
                     v_dsp_lov := show_lov('PACKAGE_LOV');
                     IF NOT v_dsp_lov THEN
                        :c003.renew_no := NULL;
                        raise form_trigger_failure;
                     END IF;*/
                     p_package_sw := 'Y';
                     RETURN;
                  END IF;

                  --if policy is a dtl of a pack policy dispay field nbt_pk_pol and nbt_pk_lbl
                  FOR i IN (SELECT a.pack_pol_flag pack_pol_flag,
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
                                                                     pack_pol,
                                   a.pack_policy_id pack_policy_id
                              FROM gipi_polbasic a, gipi_pack_polbasic b
                             WHERE a.line_cd = p_line_cd
                               AND a.subline_cd = p_subline_cd
                               AND a.iss_cd = p_pol_iss_cd
                               AND a.issue_yy = p_issue_yy
                               AND a.pol_seq_no = p_pol_seq_no
                               AND a.renew_no = p_renew_no
                               AND a.pack_policy_id = b.pack_policy_id)
                  LOOP
                     p_nbt_pack_pol := i.pack_pol_flag;
                     p_nbt_pk_pol := i.pack_pol;
                     --p_nbt_pk_lbl   := 'Package Policy';
                     p_pack_policy_id := i.pack_policy_id;
                  END LOOP;

                  /*IF nvl(:c003.nbt_pack_pol,'N') = 'Y' THEN
                      set_item_property('c003.nbt_pk_pol',DISPLAYED,property_true);
                      set_item_property('c003.nbt_pk_lbl',DISPLAYED,property_true);
                  ELSIF nvl(:c003.nbt_pack_pol,'N') = 'N' THEN
                      set_item_property('c003.nbt_pk_pol',DISPLAYED,property_false);
                      set_item_property('c003.nbt_pk_lbl',DISPLAYED,property_false);
                  END IF;*/

                  -- modified the select stamt below. added validation of policy in gipi_endttext.
                  BEGIN
                     SELECT DISTINCT 'X'
                                INTO v_exists
                                FROM gipi_polbasic a, giuw_pol_dist b
                               WHERE a.line_cd = p_line_cd
                                 AND a.subline_cd = p_subline_cd
                                 AND a.iss_cd = p_pol_iss_cd
                                 AND a.issue_yy = p_issue_yy
                                 AND a.pol_seq_no = p_pol_seq_no
                                 AND a.renew_no = p_renew_no
                                 AND a.policy_id = b.policy_id
                                 AND a.pol_flag IN ('1', '2', '3', 'X')
                                 --AND b.dist_flag NOT IN
                                              --(v_dist_param, '5') --jen.062006
                                 --AND b.dist_flag   <> v_dist_param
                                 AND (b.dist_flag NOT IN (v_dist_param, '5') OR v_dist_param IS NULL)--kenneth 11.27.2014
                                 AND b.negate_date IS NULL
                                 AND NOT EXISTS (
                                        SELECT c.policy_id
                                          FROM gipi_endttext c
                                         WHERE c.endt_tax = 'Y'
                                           AND c.policy_id = a.policy_id);

                     NULL;

                     IF v_exists = 'X'
                     THEN
                        -- allow user to proceed with generating claim number.
                        FOR i IN
                           (SELECT param_value_v
                              FROM giac_parameters
                             WHERE param_name LIKE 'ALLOW_CLM_FOR_UNDIST_POL')
                        LOOP
                           v_allow := i.param_value_v;
                           EXIT;
                        END LOOP;

                        IF v_allow = 'Y'
                        THEN
                            --adpascual 5.7.2013 added a condition for Line Code Bond (SU)
                            IF p_line_cd = giisp.v('LINE_CODE_SU') THEN
                                p_msg_alert2 :=
                                 'Policy is Undistributed. '
                              || 'User may file the claim only. ';
                            ELSE
                               p_msg_alert2 :=
                                     'Policy is Undistributed. '
                                  || 'User may continue processing the claim but until '
                                  || 'Item Information Only.';    --, 'I', FALSE);
                            END IF;
                        ELSIF v_allow = 'N'
                        THEN
                           p_msg_alert :=
                              'Policy not valid for Claim. Please verify your policy number. Policy must be Existing and Distributed';
                           --,'E',FALSE);
                           polflag := FALSE;
                           RETURN;
                        END IF;
                     END IF;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        validate_existing_dist (p_line_cd,
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_msg_alert
                                               );

                        IF p_msg_alert IS NOT NULL
                        THEN
                           RETURN;
                        END IF;
                  END;
               END IF;                               --end of renew is no null
               
               --start kenneth SR 4855 10.07.2015
               IF v_flag = '4' AND v_prorate_flag != '2'    
               THEN
                p_msg_alert := 'This policy is cancelled pro-rate/short-rate. What would you like to do?.';
               END IF;
               --end kenneth SR 4855 10.07.2015
               
               IF NOT polflag
               THEN
                  /* set_item_property('c003.loss_cat_cd',required,property_false);
                     clear_block(no_commit);
                       RAISE form_trigger_failure; */
                  RETURN;
               ELSIF polflag
               THEN
                  get_min_max_date2 (p_line_cd, --kenneth SR 4855 10.07.2015
                                    p_subline_cd,
                                    p_pol_iss_cd,
                                    p_issue_yy,
                                    p_pol_seq_no,
                                    p_renew_no,
                                    p_loss_date,
                                    p_pol_eff_date,
                                    v_pol_eff_date,
                                    p_expiry_date,
                                    v_expiry_date,
                                    p_issue_date,
                                    p_msg_alert3
                                   );
                  gicl_claims_pkg.get_assured_obligee (p_assd_no,
                                                       p_assd_name,
                                                       p_acct_of_cd,
                                                       p_obligee_no,
                                                       p_line_cd,
                                                       p_subline_cd,
                                                       p_pol_iss_cd,
                                                       p_issue_yy,
                                                       p_pol_seq_no,
                                                       p_renew_no,
                                                       p_loss_date,
                                                       v_expiry_date
                                                      );
                BEGIN
                  SELECT DISTINCT assd_name
                    INTO p_acct_of_name
                    FROM giis_assured
                   WHERE assd_no = NVL(p_acct_of_cd, 0);
                EXCEPTION
                    WHEN NO_DATA_FOUND
                    THEN p_acct_of_name := '';
                END;

                  SELECT COUNT (*)
                    INTO v_plate_ctr
                    FROM TABLE
                            (gipi_vehicle_pkg.get_valid_plate_nos
                                                                (p_line_cd,
                                                                 p_subline_cd,
                                                                 p_pol_iss_cd,
                                                                 p_issue_yy,
                                                                 p_pol_seq_no,
                                                                 p_renew_no
                                                                )
                            );

                  IF v_plate_ctr = 1
                  THEN
                     SELECT item_no, plate_no, motor_no, serial_no
                       INTO p_item_no, p_plate_no, p_motor_no, p_serial_no
                       FROM TABLE
                               (gipi_vehicle_pkg.get_valid_plate_nos
                                                                (p_line_cd,
                                                                 p_subline_cd,
                                                                 p_pol_iss_cd,
                                                                 p_issue_yy,
                                                                 p_pol_seq_no,
                                                                 p_renew_no
                                                                )
                               );
                  ELSIF v_plate_ctr > 1
                  THEN
                     p_plate_sw := 'Y';
                  END IF;
               --DISPLAY_VALID_PLATE_NOS;
               --chk_item_for_total_loss;
               END IF;
            END;
         END;
      END IF;
   END;

     /*
   **  Created by        : Robert Virrey
   **  Date Created     : 09.29.2011
   **  Reference By     : (GIEXS004 - TAG EXPIRED POLICIES FOR RENEWAL)
   **  Description     : get claim details for the selected policy
   */
   FUNCTION get_basic_claim_dtls (
      p_pack_policy_id   gipi_polbasic.pack_policy_id%TYPE,
      p_policy_id        gipi_polbasic.policy_id%TYPE
   )
      RETURN basic_claim_dtls_tab PIPELINED
   IS
      v_claims       basic_claim_dtls_type;
      v_line_cd      gipi_polbasic.line_cd%TYPE;
      v_subline_cd   gipi_polbasic.subline_cd%TYPE;
      v_iss_cd       gipi_polbasic.iss_cd%TYPE;
      v_issue_yy     gipi_polbasic.issue_yy%TYPE;
      v_pol_seq_no   gipi_polbasic.pol_seq_no%TYPE;
      v_renew_no     gipi_polbasic.renew_no%TYPE;
   BEGIN
      IF p_pack_policy_id > 0
      THEN
         FOR cur IN (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                            pol_seq_no, renew_no
                       FROM gipi_polbasic
                      WHERE pack_policy_id = p_pack_policy_id)
         LOOP
            v_line_cd := cur.line_cd;
            v_subline_cd := cur.subline_cd;
            v_iss_cd := cur.iss_cd;
            v_issue_yy := cur.issue_yy;
            v_pol_seq_no := cur.pol_seq_no;
            v_renew_no := cur.renew_no;
            EXIT;
         END LOOP;
      ELSE
         FOR cur IN (SELECT line_cd, subline_cd, iss_cd, issue_yy,
                            pol_seq_no, renew_no
                       FROM gipi_polbasic
                      WHERE policy_id = p_policy_id)
         LOOP
            v_line_cd := cur.line_cd;
            v_subline_cd := cur.subline_cd;
            v_iss_cd := cur.iss_cd;
            v_issue_yy := cur.issue_yy;
            v_pol_seq_no := cur.pol_seq_no;
            v_renew_no := cur.renew_no;
            EXIT;
         END LOOP;
      END IF;

      FOR i IN (SELECT    a.iss_cd
                       || ' - '
                       || a.clm_yy
                       || ' - '
                       || TO_CHAR (a.clm_seq_no, '0999999') claim_no,
                       a.claim_id, a.clm_stat_cd, a.clm_file_date,
                       a.loss_res_amt, a.loss_pd_amt
                  FROM gicl_claims a
                 WHERE line_cd = v_line_cd
                   AND subline_cd = v_subline_cd
                   --AND iss_cd = v_iss_cd --marco - 04.20.2013 - changed to pol_iss_cd
                   AND pol_iss_cd = v_iss_cd
                   AND issue_yy = v_issue_yy
                   AND pol_seq_no = v_pol_seq_no
                   AND renew_no = v_renew_no
                   AND clm_stat_cd NOT IN ('CC', 'DN', 'WD'))
      LOOP
         v_claims.claim_no := i.claim_no;
         v_claims.claim_id := i.claim_id;
         v_claims.clm_stat_cd := i.clm_stat_cd;
         v_claims.clm_file_date := i.clm_file_date;
         v_claims.loss_res_amt := i.loss_res_amt;
         v_claims.loss_pd_amt := i.loss_pd_amt;

         BEGIN
            FOR a IN (SELECT clm_stat_desc
                        FROM giis_clm_stat
                       WHERE clm_stat_cd = i.clm_stat_cd)
            LOOP
               v_claims.clm_stat_desc := a.clm_stat_desc;
            END LOOP;
         END;

         PIPE ROW (v_claims);
      END LOOP;
   END get_basic_claim_dtls;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 09.29.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : check if any claims exists
    **/
   PROCEDURE check_existing_claim (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no     IN       gicl_claims.plate_no%TYPE,
      p_msg_alert    OUT      VARCHAR2,
      p_status_cd    OUT      VARCHAR2,
      p_total_tag    OUT      VARCHAR2
   )
   IS
      existing_claim   VARCHAR2 (200);
      filedate         DATE;
      status           giis_clm_stat.clm_stat_desc%TYPE;
      endorse          VARCHAR2 (1);
      v_plateno        gicl_claims.plate_no%TYPE;
      v_count          NUMBER (5);
   BEGIN
      SELECT      a.line_cd
               || '-'
               || a.subline_cd
               || '-'
               || a.iss_cd
               || '-'
               || LTRIM (TO_CHAR (a.clm_yy, '00'))
               || '-'
               || LTRIM (TO_CHAR (a.clm_seq_no, '0000009')),
               a.clm_file_date, b.clm_stat_desc, b.clm_stat_cd,
               NVL (a.total_tag, 'N'), a.plate_no
          INTO existing_claim,
               filedate, status, p_status_cd,
               p_total_tag, v_plateno
          FROM gicl_claims a,
               giis_clm_stat b,
               gipi_polbasic c,
               giuw_pol_dist d
         WHERE a.line_cd = p_line_cd
           AND a.subline_cd = p_subline_cd
           AND a.pol_iss_cd = p_pol_iss_cd
           AND a.issue_yy = p_issue_yy
           AND a.pol_seq_no = p_pol_seq_no
           AND a.renew_no = p_renew_no
           AND NVL (a.plate_no, '*') = NVL (p_plate_no, '*')
           AND a.clm_stat_cd = b.clm_stat_cd
           AND claim_id =
                  (SELECT MAX (claim_id)
                     FROM gicl_claims
                    WHERE line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND pol_iss_cd = p_pol_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND NVL (plate_no, '*') = NVL (p_plate_no, '*'))
           AND c.line_cd = a.line_cd
           AND c.subline_cd = a.subline_cd
           AND c.iss_cd = a.pol_iss_cd
           AND c.issue_yy = a.issue_yy
           AND c.renew_no = a.renew_no
           AND c.pol_seq_no = a.pol_seq_no
           AND c.policy_id = d.policy_id
           AND d.dist_flag = '3'
      GROUP BY    a.line_cd
               || '-'
               || a.subline_cd
               || '-'
               || a.iss_cd
               || '-'
               || LTRIM (TO_CHAR (a.clm_yy, '00'))
               || '-'
               || LTRIM (TO_CHAR (a.clm_seq_no, '0000009')),
               a.clm_file_date,
               b.clm_stat_desc,
               b.clm_stat_cd,
               a.total_tag,
               a.plate_no;

      p_msg_alert :=
            'Policy has an existing claim record:  '
         || existing_claim
         || ' Date filed: '
         || TO_CHAR (filedate)
         || ' Status: '
         || status
         || '.  Do you wish to continue?';
      RETURN;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg_alert := '';
   END;

   PROCEDURE validate_policy (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2
   )
   IS
      v_dist_param     giis_parameters.param_value_v%TYPE;
      v_exists         VARCHAR2 (1)                         := NULL;
      v_exist2         VARCHAR2 (1)                         := 'N';
      v_exist3         VARCHAR2 (1)                         := 'N';
      v_flag           VARCHAR2 (1)                         := NULL;
      v_allow          VARCHAR2 (1);
      v_expiry_date    DATE;
      v_pol_eff_date   DATE;
   BEGIN
      -- validate policy number being processed for CLAIMS so that
      -- validation from other items will not be needed
      IF p_renew_no IS NOT NULL
      THEN
         FOR rec IN (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'DISTRIBUTED')
         LOOP
            v_dist_param := rec.param_value_v;
            EXIT;
         END LOOP;

         -- This is to handle non-existing policies
         FOR pol IN (SELECT policy_id
                       FROM gipi_polbasic a
                      WHERE a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.iss_cd = p_pol_iss_cd
                        AND a.issue_yy = p_issue_yy
                        AND a.pol_seq_no = p_pol_seq_no
                        AND a.renew_no = p_renew_no)
         LOOP
            v_exist2 := 'Y';
         END LOOP;

         IF v_exist2 = 'N'
         THEN
            p_renew_no := NULL;
            p_msg_alert :=
               'Policy not valid for Claim. Please verify your policy number. Policy must be Existing.';
         --,'I',true);
         END IF;

         -- This is to handle policies that are cancelled or spoiled.
         FOR cncld IN (SELECT pol_flag
                         FROM gipi_polbasic a
                        WHERE a.line_cd = p_line_cd
                          AND a.subline_cd = p_subline_cd
                          AND a.iss_cd = p_pol_iss_cd
                          AND a.issue_yy = p_issue_yy
                          AND a.pol_seq_no = p_pol_seq_no
                          AND a.renew_no = p_renew_no
                          AND a.endt_seq_no = 0)
         LOOP
            v_flag := cncld.pol_flag;
         END LOOP;

         IF v_flag = '4'
         THEN
            p_renew_no := NULL;
            p_msg_alert :=
               'Policy not valid for Claim. Please verify your policy number. Policy must not be Cancelled.';
            --,'I',FALSE);
            RETURN;
         END IF;

         IF v_flag = '5'
         THEN
            p_renew_no := NULL;
            p_msg_alert :=
               'Policy not valid for Claim. Please verify your policy number. Policy must not be Spoiled.';
            --,'I',FALSE);
            RETURN;
         END IF;

         IF v_flag = 'X'
         THEN
            p_exp_date_sw := 'EXPIRED_DATE_ALERT';
         END IF;

         BEGIN
            SELECT DISTINCT 'X'
                       INTO v_exists
                       FROM gipi_polbasic a, giuw_pol_dist b
                      WHERE a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.iss_cd = p_pol_iss_cd
                        AND a.issue_yy = p_issue_yy
                        AND a.pol_seq_no = p_pol_seq_no
                        AND a.renew_no = p_renew_no
                        AND a.policy_id = b.policy_id
                        AND a.pol_flag IN ('1', '2', '3', 'X')
                        AND b.dist_flag NOT IN (v_dist_param, '5')
                        --AND b.dist_flag   <> v_dist_param --modified by: jen.062006
                        AND b.negate_date IS NULL
                        AND NOT EXISTS (
                               SELECT c.policy_id
                                 FROM gipi_endttext c
                                WHERE c.endt_tax = 'Y'
                                  AND c.policy_id = a.policy_id);

            NULL;

            IF v_exists = 'X'
            THEN
               FOR i IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name LIKE 'ALLOW_CLM_FOR_UNDIST_POL')
               LOOP
                  v_allow := i.param_value_v;
                  EXIT;
               END LOOP;

               IF v_allow = 'Y'
               THEN
                  p_msg_alert2 :=
                        'Policy is Undistributed. '
                     || 'User may continue processing the claim but until '
                     || 'Item Information Only.';             --, 'I', FALSE);
               ELSIF v_allow = 'N'
               THEN
                  p_msg_alert :=
                     'Policy not valid for Claim. Please verify your policy number. Policy must be Existing and Distributed';
                  --,'E',FALSE);
                  RETURN;
               END IF;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               validate_existing_dist (p_line_cd,
                                       p_subline_cd,
                                       p_pol_iss_cd,
                                       p_issue_yy,
                                       p_pol_seq_no,
                                       p_renew_no,
                                       p_msg_alert
                                      );

               IF p_msg_alert IS NOT NULL
               THEN
                  RETURN;
               END IF;
         END;
      END IF;

      get_min_max_date (p_line_cd,
                        p_subline_cd,
                        p_pol_iss_cd,
                        p_issue_yy,
                        p_pol_seq_no,
                        p_renew_no,
                        p_loss_date,
                        p_pol_eff_date,
                        v_pol_eff_date,
                        p_expiry_date,
                        v_expiry_date,
                        p_issue_date,
                        p_msg_alert3
                       );
      gicl_claims_pkg.get_assured_obligee (p_assd_no,
                                           p_assd_name,
                                           p_acct_of_cd,
                                           p_obligee_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_loss_date,
                                           v_expiry_date
                                          );
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.05.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : validate plate no. in claims basic info
    **/
   PROCEDURE validate_plate_no (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_item_no        IN OUT   gipi_vehicle.item_no%TYPE,
      p_plate_no       IN OUT   gipi_vehicle.plate_no%TYPE,
      p_motor_no       IN OUT   gipi_vehicle.motor_no%TYPE,
      p_serial_no      IN OUT   gipi_vehicle.serial_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2,
      p_plate_sw2      OUT      VARCHAR2,
      p_validate_pol   IN       VARCHAR2
   )
   IS
      v_valid   BOOLEAN := FALSE;
   BEGIN
      IF p_validate_pol = 'Y'
      THEN
         IF    p_line_cd IS NULL
            OR p_subline_cd IS NULL
            OR p_pol_iss_cd IS NULL
            OR p_issue_yy IS NULL
            OR p_pol_seq_no IS NULL
            OR p_renew_no IS NULL
         THEN
            IF p_plate_no IS NOT NULL
            THEN
               FOR rec IN (SELECT DISTINCT a.plate_no, c.assd_name
                                      FROM gipi_vehicle a,
                                           gipi_polbasic b,
                                           giis_assured c,
                                           gipi_parlist d
                                     WHERE plate_no IS NOT NULL
                                       AND b.par_id = d.par_id
                                       AND d.assd_no = c.assd_no
                                       AND a.policy_id = b.policy_id
                                       AND b.endt_seq_no =
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic
                                                WHERE line_cd = b.line_cd
                                                  AND subline_cd =
                                                                  b.subline_cd
                                                  AND iss_cd = b.iss_cd
                                                  AND issue_yy = b.issue_yy
                                                  AND pol_seq_no =
                                                                  b.pol_seq_no
                                                  AND renew_no = b.renew_no)
                                       AND NOT EXISTS (
                                              SELECT '1'
                                                FROM gicl_claims
                                               WHERE line_cd = b.line_cd
                                                 AND subline_cd = b.subline_cd
                                                 AND pol_iss_cd = b.iss_cd
                                                 AND issue_yy = b.issue_yy
                                                 AND pol_seq_no = b.pol_seq_no
                                                 AND renew_no = b.renew_no
                                                 AND total_tag = 'Y')
                                       AND a.plate_no = p_plate_no
                                  ORDER BY plate_no)
               LOOP
                  v_valid := TRUE;                        --plate_no is valid
                  EXIT;
               END LOOP;

               FOR a IN (SELECT a.plate_no, a.item_no
                           FROM gipi_vehicle a, gipi_polbasic b
                          WHERE a.policy_id = b.policy_id
                            AND b.line_cd = p_line_cd
                            AND b.subline_cd = p_subline_cd
                            AND b.iss_cd = p_pol_iss_cd
                            AND b.issue_yy = p_issue_yy
                            AND b.pol_seq_no = p_pol_seq_no
                            AND b.renew_no = p_renew_no
                            AND b.pol_flag IN ('1', '2', '3', '4')
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM gicl_claims
                                    WHERE line_cd = b.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND pol_iss_cd = b.iss_cd
                                      AND issue_yy = b.issue_yy
                                      AND pol_seq_no = b.pol_seq_no
                                      AND renew_no = b.renew_no
                                      AND total_tag = 'Y')
                            AND a.item_no = p_item_no)
               LOOP
                  IF a.plate_no IS NULL AND p_plate_no IS NOT NULL
                  THEN
                     v_valid := TRUE;
                  END IF;
               END LOOP;

               IF NOT v_valid
               THEN
                  p_msg_alert :=
                     'The plate number you entered is not valid. Please check the list of values for valid plate numbers.';
                  --,'E',TRUE);
                  RETURN;
               END IF;
            END IF;
         ELSE
            FOR a IN (SELECT a.plate_no, a.item_no
                        FROM gipi_vehicle a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id
                         AND b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_pol_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND b.pol_flag IN ('1', '2', '3', '4')
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM gicl_claims
                                 WHERE line_cd = b.line_cd
                                   AND subline_cd = b.subline_cd
                                   AND pol_iss_cd = b.iss_cd
                                   AND issue_yy = b.issue_yy
                                   AND pol_seq_no = b.pol_seq_no
                                   AND renew_no = b.renew_no
                                   AND total_tag = 'Y')
                         AND a.plate_no = p_plate_no)
            LOOP
               v_valid := TRUE;                           --plate_no is valid
               EXIT;
            END LOOP;

            FOR a IN (SELECT a.plate_no, a.item_no
                        FROM gipi_vehicle a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id
                         AND b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_pol_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND b.pol_flag IN ('1', '2', '3', '4')
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM gicl_claims
                                 WHERE line_cd = b.line_cd
                                   AND subline_cd = b.subline_cd
                                   AND pol_iss_cd = b.iss_cd
                                   AND issue_yy = b.issue_yy
                                   AND pol_seq_no = b.pol_seq_no
                                   AND renew_no = b.renew_no
                                   AND total_tag = 'Y')
                         AND a.item_no = p_item_no)
            LOOP
               IF a.plate_no IS NULL AND p_plate_no IS NOT NULL
               THEN
                  v_valid := TRUE;
               END IF;
            END LOOP;

            IF NOT v_valid
            THEN
               p_msg_alert :=
                  'The plate number you entered is not valid. Please check the list of values for valid plate numbers.';
               --,'E',TRUE);
               RETURN;
            END IF;
         END IF;

         BEGIN
            IF p_plate_no IS NOT NULL
            THEN
               DECLARE
                  v_exist   NUMBER := 0;
               BEGIN
                  SELECT 1
                    INTO v_exist
                    FROM gipi_vehicle
                   WHERE plate_no = UPPER (p_plate_no);
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert := 'Not a valid plate No.';  --, 'E', TRUE);
                     RETURN;
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_exist := 2;
               END;

               --CHECK if more than one policy is available for the plate no.
               DECLARE
                  v_count   NUMBER := 0;
               BEGIN
                  FOR a IN (SELECT y.item_no, y.plate_no, x.policy_id,
                                   x.endt_seq_no                          --6
                              FROM gipi_polbasic x, gipi_vehicle y
                             WHERE 1 = 1
                               AND x.policy_id = y.policy_id
                               AND NVL (x.endt_seq_no, 0) =
                                      (SELECT MAX (NVL (endt_seq_no, 0))
                                         FROM gipi_polbasic
                                        WHERE line_cd = x.line_cd
                                          AND subline_cd = x.subline_cd
                                          AND iss_cd = x.iss_cd
                                          AND issue_yy = x.issue_yy
                                          AND pol_seq_no = x.pol_seq_no
                                          AND renew_no = x.renew_no)
                               AND x.pol_flag IN ('1', '2', '3', '4')
                               AND y.plate_no = UPPER (p_plate_no)
                               AND y.plate_no =
                                      get_latest_plate_no3 (x.policy_id,
                                                            y.item_no
                                                           ))
                  LOOP
                     v_count := v_count + 1;
                  END LOOP;

                  p_plate_sw2 := 'N';

                  IF v_count > 1
                  THEN
                     p_plate_sw2 := 'Y';
                     RETURN;
                  ELSE
                     FOR rec IN (SELECT a.line_cd, a.subline_cd, a.iss_cd,
                                        a.issue_yy, a.pol_seq_no, a.renew_no,
                                        b.item_no, b.motor_no, b.serial_no
                                   FROM gipi_polbasic a, gipi_vehicle b
                                  WHERE a.policy_id = b.policy_id
                                    AND b.plate_no = UPPER (p_plate_no))
                     LOOP
                        p_line_cd := rec.line_cd;
                        p_subline_cd := rec.subline_cd;
                        p_pol_iss_cd := rec.iss_cd;
                        p_issue_yy := rec.issue_yy;
                        p_pol_seq_no := rec.pol_seq_no;
                        p_renew_no := rec.renew_no;
                        p_item_no := rec.item_no;
                        p_motor_no := rec.motor_no;
                        p_serial_no := rec.serial_no;
                     END LOOP;
                  END IF;
               END;
            END IF;
         END;
      END IF;

      gicl_claims_pkg.validate_policy (p_line_cd,
                                       p_subline_cd,
                                       p_pol_iss_cd,
                                       p_issue_yy,
                                       p_pol_seq_no,
                                       p_renew_no,
                                       p_loss_date,
                                       p_pol_eff_date,
                                       p_expiry_date,
                                       p_issue_date,
                                       p_assd_no,
                                       p_assd_name,
                                       p_acct_of_cd,
                                       p_obligee_no,
                                       p_msg_alert,
                                       p_msg_alert2,
                                       p_msg_alert3,
                                       p_exp_date_sw
                                      );
   END;

   /**
   **  Created by      : Niknok Orio
   **  Date Created    : 10.05.2011
   **  Reference By    : (GICLS010 - Claims Basic Information)
   **  Description     : validate motor no. in claims basic info
   **/
   PROCEDURE validate_motor_no (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_item_no        IN OUT   gipi_vehicle.item_no%TYPE,
      p_plate_no       IN OUT   gipi_vehicle.plate_no%TYPE,
      p_motor_no       IN OUT   gipi_vehicle.motor_no%TYPE,
      p_serial_no      IN OUT   gipi_vehicle.serial_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2,
      p_plate_sw2      OUT      VARCHAR2,
      p_validate_pol   IN       VARCHAR2
   )
   IS
      v_valid   BOOLEAN := FALSE;
   BEGIN
      IF p_validate_pol = 'Y'
      THEN
         IF    p_line_cd IS NULL
            OR p_subline_cd IS NULL
            OR p_pol_iss_cd IS NULL
            OR p_issue_yy IS NULL
            OR p_pol_seq_no IS NULL
            OR p_renew_no IS NULL
         THEN
            IF p_motor_no IS NOT NULL
            THEN
               FOR rec IN (SELECT DISTINCT a.motor_no, c.assd_name
                                      FROM gipi_vehicle a,
                                           gipi_polbasic b,
                                           giis_assured c,
                                           gipi_parlist d
                                     WHERE motor_no IS NOT NULL
                                       AND b.par_id = d.par_id
                                       AND d.assd_no = c.assd_no
                                       AND a.policy_id = b.policy_id
                                       AND b.endt_seq_no =
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic
                                                WHERE line_cd = b.line_cd
                                                  AND subline_cd =
                                                                  b.subline_cd
                                                  AND iss_cd = b.iss_cd
                                                  AND issue_yy = b.issue_yy
                                                  AND pol_seq_no =
                                                                  b.pol_seq_no
                                                  AND renew_no = b.renew_no)
                                       AND NOT EXISTS (
                                              SELECT '1'
                                                FROM gicl_claims
                                               WHERE line_cd = b.line_cd
                                                 AND subline_cd = b.subline_cd
                                                 AND pol_iss_cd = b.iss_cd
                                                 AND issue_yy = b.issue_yy
                                                 AND pol_seq_no = b.pol_seq_no
                                                 AND renew_no = b.renew_no
                                                 AND total_tag = 'Y')
                                       AND a.motor_no = p_motor_no
                                  ORDER BY motor_no)
               LOOP
                  v_valid := TRUE;                        --motor_no is valid
                  EXIT;
               END LOOP;

               FOR a IN (SELECT a.motor_no, a.item_no
                           FROM gipi_vehicle a, gipi_polbasic b
                          WHERE a.policy_id = b.policy_id
                            AND b.line_cd = p_line_cd
                            AND b.subline_cd = p_subline_cd
                            AND b.iss_cd = p_pol_iss_cd
                            AND b.issue_yy = p_issue_yy
                            AND b.pol_seq_no = p_pol_seq_no
                            AND b.renew_no = p_renew_no
                            AND b.pol_flag IN ('1', '2', '3', '4')
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM gicl_claims
                                    WHERE line_cd = b.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND pol_iss_cd = b.iss_cd
                                      AND issue_yy = b.issue_yy
                                      AND pol_seq_no = b.pol_seq_no
                                      AND renew_no = b.renew_no
                                      AND total_tag = 'Y')
                            AND a.item_no = p_item_no)
               LOOP
                  IF a.motor_no IS NULL AND p_motor_no IS NOT NULL
                  THEN
                     v_valid := TRUE;
                  END IF;
               END LOOP;

               IF NOT v_valid
               THEN
                  p_msg_alert :=
                     'The motor number you entered is not valid.  Please check the list of values for valid motor numbers.';
                  --,'E',TRUE);
                  RETURN;
               END IF;
            END IF;
         ELSE
            FOR a IN (SELECT a.motor_no, a.item_no
                        FROM gipi_vehicle a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id
                         AND b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_pol_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND b.pol_flag IN ('1', '2', '3', '4')
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM gicl_claims
                                 WHERE line_cd = b.line_cd
                                   AND subline_cd = b.subline_cd
                                   AND pol_iss_cd = b.iss_cd
                                   AND issue_yy = b.issue_yy
                                   AND pol_seq_no = b.pol_seq_no
                                   AND renew_no = b.renew_no
                                   AND total_tag = 'Y')
                         AND a.motor_no = p_motor_no)
            LOOP
               v_valid := TRUE;                           --motor_no is valid
               EXIT;
            END LOOP;

            FOR a IN (SELECT a.motor_no, a.item_no
                        FROM gipi_vehicle a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id
                         AND b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_pol_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND b.pol_flag IN ('1', '2', '3', '4')
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM gicl_claims
                                 WHERE line_cd = b.line_cd
                                   AND subline_cd = b.subline_cd
                                   AND pol_iss_cd = b.iss_cd
                                   AND issue_yy = b.issue_yy
                                   AND pol_seq_no = b.pol_seq_no
                                   AND renew_no = b.renew_no
                                   AND total_tag = 'Y')
                         AND a.item_no = p_item_no)
            LOOP
               IF a.motor_no IS NULL AND p_motor_no IS NOT NULL
               THEN
                  v_valid := TRUE;
               END IF;
            END LOOP;

            IF NOT v_valid
            THEN
               p_msg_alert :=
                  'The motor number you entered is not valid.  Please check the list of values for valid motor numbers.';
               --,'E',TRUE);
               RETURN;
            END IF;
         END IF;

         BEGIN
            IF p_motor_no IS NOT NULL
            THEN
               DECLARE
                  v_exist   NUMBER := 0;
               BEGIN
                  SELECT 1
                    INTO v_exist
                    FROM gipi_vehicle
                   WHERE motor_no = UPPER (p_motor_no);
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert := 'Not a valid motor No.';  --, 'E', TRUE);
                     RETURN;
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_exist := 2;
               END;

               --CHECK if more than one policy is available for the motor no.
               DECLARE
                  v_count   NUMBER := 0;
               BEGIN
                  FOR a IN (SELECT y.item_no, y.motor_no, x.policy_id,
                                   x.endt_seq_no                          --6
                              FROM gipi_polbasic x, gipi_vehicle y
                             WHERE 1 = 1
                               AND x.policy_id = y.policy_id
                               AND NVL (x.endt_seq_no, 0) =
                                      (SELECT MAX (NVL (endt_seq_no, 0))
                                         FROM gipi_polbasic
                                        WHERE line_cd = x.line_cd
                                          AND subline_cd = x.subline_cd
                                          AND iss_cd = x.iss_cd
                                          AND issue_yy = x.issue_yy
                                          AND pol_seq_no = x.pol_seq_no
                                          AND renew_no = x.renew_no)
                               AND x.pol_flag IN ('1', '2', '3', '4')
                               AND y.motor_no = UPPER (p_motor_no)
                               AND y.motor_no =
                                      get_latest_motor_no (x.policy_id,
                                                           y.item_no
                                                          ))
                  LOOP
                     v_count := v_count + 1;
                  END LOOP;

                  p_plate_sw2 := 'N';

                  IF v_count > 1
                  THEN
                     p_plate_sw2 := 'Y';
                     RETURN;
                  ELSE
                     FOR rec IN (SELECT a.line_cd, a.subline_cd, a.iss_cd,
                                        a.issue_yy, a.pol_seq_no, a.renew_no,
                                        b.item_no, b.plate_no, b.serial_no
                                   FROM gipi_polbasic a, gipi_vehicle b
                                  WHERE a.policy_id = b.policy_id
                                    AND b.motor_no = UPPER (p_motor_no))
                     LOOP
                        p_line_cd := rec.line_cd;
                        p_subline_cd := rec.subline_cd;
                        p_pol_iss_cd := rec.iss_cd;
                        p_issue_yy := rec.issue_yy;
                        p_pol_seq_no := rec.pol_seq_no;
                        p_renew_no := rec.renew_no;
                        p_item_no := rec.item_no;
                        p_plate_no := rec.plate_no;
                        p_serial_no := rec.serial_no;
                     END LOOP;
                  END IF;
               END;
            END IF;
         END;
      END IF;

      gicl_claims_pkg.validate_policy (p_line_cd,
                                       p_subline_cd,
                                       p_pol_iss_cd,
                                       p_issue_yy,
                                       p_pol_seq_no,
                                       p_renew_no,
                                       p_loss_date,
                                       p_pol_eff_date,
                                       p_expiry_date,
                                       p_issue_date,
                                       p_assd_no,
                                       p_assd_name,
                                       p_acct_of_cd,
                                       p_obligee_no,
                                       p_msg_alert,
                                       p_msg_alert2,
                                       p_msg_alert3,
                                       p_exp_date_sw
                                      );
   END;

   /**
   **  Created by      : Niknok Orio
   **  Date Created    : 10.05.2011
   **  Reference By    : (GICLS010 - Claims Basic Information)
   **  Description     : validate serial no. in claims basic info
   **/
   PROCEDURE validate_serial_no (
      p_line_cd        IN OUT   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN OUT   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN OUT   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN OUT   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN OUT   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN OUT   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN OUT   gipi_polbasic.eff_date%TYPE,
      p_pol_eff_date   OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_expiry_date    OUT      VARCHAR2,    --GIPI_POLBASIC.expiry_date%TYPE,
      p_issue_date     OUT      VARCHAR2,     --GIPI_POLBASIC.issue_date%TYPE,
      p_assd_no        OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name      OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd     OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no     OUT      gicl_claims.obligee_no%TYPE,
      p_item_no        IN OUT   gipi_vehicle.item_no%TYPE,
      p_plate_no       IN OUT   gipi_vehicle.plate_no%TYPE,
      p_motor_no       IN OUT   gipi_vehicle.motor_no%TYPE,
      p_serial_no      IN OUT   gipi_vehicle.serial_no%TYPE,
      p_msg_alert      OUT      VARCHAR2,
      p_msg_alert2     OUT      VARCHAR2,
      p_msg_alert3     OUT      VARCHAR2,
      p_exp_date_sw    OUT      VARCHAR2,
      p_plate_sw2      OUT      VARCHAR2,
      p_validate_pol   IN       VARCHAR2
   )
   IS
      v_valid   BOOLEAN := FALSE;
   BEGIN
      IF p_validate_pol = 'Y'
      THEN
         IF    p_line_cd IS NULL
            OR p_subline_cd IS NULL
            OR p_pol_iss_cd IS NULL
            OR p_issue_yy IS NULL
            OR p_pol_seq_no IS NULL
            OR p_renew_no IS NULL
         THEN
            IF p_serial_no IS NOT NULL
            THEN
               FOR rec IN (SELECT DISTINCT a.serial_no, c.assd_name
                                      FROM gipi_vehicle a,
                                           gipi_polbasic b,
                                           giis_assured c,
                                           gipi_parlist d
                                     WHERE serial_no IS NOT NULL
                                       AND b.par_id = d.par_id
                                       AND d.assd_no = c.assd_no
                                       AND a.policy_id = b.policy_id
                                       AND b.endt_seq_no =
                                              (SELECT MAX (endt_seq_no)
                                                 FROM gipi_polbasic
                                                WHERE line_cd = b.line_cd
                                                  AND subline_cd =
                                                                  b.subline_cd
                                                  AND iss_cd = b.iss_cd
                                                  AND issue_yy = b.issue_yy
                                                  AND pol_seq_no =
                                                                  b.pol_seq_no
                                                  AND renew_no = b.renew_no)
                                       AND NOT EXISTS (
                                              SELECT '1'
                                                FROM gicl_claims
                                               WHERE line_cd = b.line_cd
                                                 AND subline_cd = b.subline_cd
                                                 AND pol_iss_cd = b.iss_cd
                                                 AND issue_yy = b.issue_yy
                                                 AND pol_seq_no = b.pol_seq_no
                                                 AND renew_no = b.renew_no
                                                 AND total_tag = 'Y')
                                       AND a.serial_no = p_serial_no
                                  ORDER BY serial_no)
               LOOP
                  v_valid := TRUE;                       --serial_no is valid
                  EXIT;
               END LOOP;

               FOR a IN (SELECT a.serial_no, a.item_no
                           FROM gipi_vehicle a, gipi_polbasic b
                          WHERE a.policy_id = b.policy_id
                            AND b.line_cd = p_line_cd
                            AND b.subline_cd = p_subline_cd
                            AND b.iss_cd = p_pol_iss_cd
                            AND b.issue_yy = p_issue_yy
                            AND b.pol_seq_no = p_pol_seq_no
                            AND b.renew_no = p_renew_no
                            AND b.pol_flag IN ('1', '2', '3', '4')
                            AND NOT EXISTS (
                                   SELECT '1'
                                     FROM gicl_claims
                                    WHERE line_cd = b.line_cd
                                      AND subline_cd = b.subline_cd
                                      AND pol_iss_cd = b.iss_cd
                                      AND issue_yy = b.issue_yy
                                      AND pol_seq_no = b.pol_seq_no
                                      AND renew_no = b.renew_no
                                      AND total_tag = 'Y')
                            AND a.item_no = p_item_no)
               LOOP
                  IF a.serial_no IS NULL AND p_serial_no IS NOT NULL
                  THEN
                     v_valid := TRUE;
                  END IF;
               END LOOP;

               IF NOT v_valid
               THEN
                  p_msg_alert :=
                     'The serial number you entered is not valid.  Please check the list of values for valid serial numbers.';
                  --,'E',TRUE);
                  RETURN;
               END IF;
            END IF;
         ELSE
            FOR a IN (SELECT a.serial_no, a.item_no
                        FROM gipi_vehicle a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id
                         AND b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_pol_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND b.pol_flag IN ('1', '2', '3', '4')
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM gicl_claims
                                 WHERE line_cd = b.line_cd
                                   AND subline_cd = b.subline_cd
                                   AND pol_iss_cd = b.iss_cd
                                   AND issue_yy = b.issue_yy
                                   AND pol_seq_no = b.pol_seq_no
                                   AND renew_no = b.renew_no
                                   AND total_tag = 'Y')
                         AND a.serial_no = p_serial_no)
            LOOP
               v_valid := TRUE;                          --serial_no is valid
               EXIT;
            END LOOP;

            FOR a IN (SELECT a.serial_no, a.item_no
                        FROM gipi_vehicle a, gipi_polbasic b
                       WHERE a.policy_id = b.policy_id
                         AND b.line_cd = p_line_cd
                         AND b.subline_cd = p_subline_cd
                         AND b.iss_cd = p_pol_iss_cd
                         AND b.issue_yy = p_issue_yy
                         AND b.pol_seq_no = p_pol_seq_no
                         AND b.renew_no = p_renew_no
                         AND b.pol_flag IN ('1', '2', '3', '4')
                         AND NOT EXISTS (
                                SELECT '1'
                                  FROM gicl_claims
                                 WHERE line_cd = b.line_cd
                                   AND subline_cd = b.subline_cd
                                   AND pol_iss_cd = b.iss_cd
                                   AND issue_yy = b.issue_yy
                                   AND pol_seq_no = b.pol_seq_no
                                   AND renew_no = b.renew_no
                                   AND total_tag = 'Y')
                         AND a.item_no = p_item_no)
            LOOP
               IF a.serial_no IS NULL AND p_serial_no IS NOT NULL
               THEN
                  v_valid := TRUE;
               END IF;
            END LOOP;

            IF NOT v_valid
            THEN
               p_msg_alert :=
                  'The serial number you entered is not valid.  Please check the list of values for valid serial numbers.';
               --,'E',TRUE);
               RETURN;
            END IF;
         END IF;

         BEGIN
            IF p_serial_no IS NOT NULL
            THEN
               DECLARE
                  v_exist   NUMBER := 0;
               BEGIN
                  SELECT 1
                    INTO v_exist
                    FROM gipi_vehicle
                   WHERE serial_no = UPPER (p_serial_no);
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     p_msg_alert := 'Not a valid serial No.'; --, 'E', TRUE);
                     RETURN;
                  WHEN TOO_MANY_ROWS
                  THEN
                     v_exist := 2;
               END;

               --CHECK if more than one policy is available for the serial no.
               DECLARE
                  v_count   NUMBER := 0;
               BEGIN
                  FOR a IN (SELECT y.item_no, y.serial_no, x.policy_id,
                                   x.endt_seq_no                          --6
                              FROM gipi_polbasic x, gipi_vehicle y
                             WHERE 1 = 1
                               AND x.policy_id = y.policy_id
                               AND NVL (x.endt_seq_no, 0) =
                                      (SELECT MAX (NVL (endt_seq_no, 0))
                                         FROM gipi_polbasic
                                        WHERE line_cd = x.line_cd
                                          AND subline_cd = x.subline_cd
                                          AND iss_cd = x.iss_cd
                                          AND issue_yy = x.issue_yy
                                          AND pol_seq_no = x.pol_seq_no
                                          AND renew_no = x.renew_no)
                               AND x.pol_flag IN ('1', '2', '3', '4')
                               AND y.serial_no = UPPER (p_serial_no)
                               AND y.serial_no =
                                      get_latest_serial_no (x.policy_id,
                                                            y.item_no
                                                           ))
                  LOOP
                     v_count := v_count + 1;
                  END LOOP;

                  p_plate_sw2 := 'N';

                  IF v_count > 1
                  THEN
                     p_plate_sw2 := 'Y';
                     RETURN;
                  ELSE
                     FOR rec IN (SELECT a.line_cd, a.subline_cd, a.iss_cd,
                                        a.issue_yy, a.pol_seq_no, a.renew_no,
                                        b.item_no, b.plate_no, b.motor_no
                                   FROM gipi_polbasic a, gipi_vehicle b
                                  WHERE a.policy_id = b.policy_id
                                    AND b.serial_no = UPPER (p_serial_no))
                     LOOP
                        p_line_cd := rec.line_cd;
                        p_subline_cd := rec.subline_cd;
                        p_pol_iss_cd := rec.iss_cd;
                        p_issue_yy := rec.issue_yy;
                        p_pol_seq_no := rec.pol_seq_no;
                        p_renew_no := rec.renew_no;
                        p_item_no := rec.item_no;
                        p_plate_no := rec.plate_no;
                        p_motor_no := rec.motor_no;
                     END LOOP;
                  END IF;
               END;
            END IF;
         END;
      END IF;

      gicl_claims_pkg.validate_policy (p_line_cd,
                                       p_subline_cd,
                                       p_pol_iss_cd,
                                       p_issue_yy,
                                       p_pol_seq_no,
                                       p_renew_no,
                                       p_loss_date,
                                       p_pol_eff_date,
                                       p_expiry_date,
                                       p_issue_date,
                                       p_assd_no,
                                       p_assd_name,
                                       p_acct_of_cd,
                                       p_obligee_no,
                                       p_msg_alert,
                                       p_msg_alert2,
                                       p_msg_alert3,
                                       p_exp_date_sw
                                      );
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.05.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : getting PLATE_NO_LOV, MOTOR_NO_LOV, and SERIAL_NO_LOV
    **/
   FUNCTION get_policy_list (p_param VARCHAR2, p_param2 VARCHAR2)
      RETURN policy_lov_tab PIPELINED
   IS
      TYPE cur_typ IS REF CURSOR;

      c          cur_typ;
      v_pol      policy_lov_type;
      stmt_str   VARCHAR2 (32000);
      v_where    VARCHAR2 (32000) := ' AND ';
   BEGIN
      IF p_param = 'PLATE_NO'
      THEN
         v_where :=
               v_where
            || ' gv.plate_no = UPPER (:plate_no)
                AND gv.plate_no = get_latest_plate_no3 (gp.policy_id, gv.item_no)';
      ELSIF p_param = 'MOTOR_NO'
      THEN
         v_where :=
               v_where
            || ' gv.motor_no = UPPER (:motor_no)
                AND gv.motor_no = get_latest_motor_no (gp.policy_id, gv.item_no)';
      ELSIF p_param = 'SERIAL_NO'
      THEN
         v_where :=
               v_where
            || ' gv.serial_no = UPPER (:serial_no)
                AND gv.serial_no = get_latest_serial_no (gp.policy_id, gv.item_no)';
      END IF;

      stmt_str :=
            'SELECT DISTINCT    gp.line_cd
                                        || ''-''
                                        || gp.subline_cd
                                        || ''-''
                                        || gp.iss_cd
                                        || ''-''
                                        || TO_CHAR (gp.issue_yy, ''09'')
                                        || ''-''
                                        || TO_CHAR (gp.pol_seq_no, ''0999999'')
                                        || ''-''
                                        || TO_CHAR (gp.renew_no, ''09'') policy_no,
                                        ga.assd_name assd_name, gp.line_cd line_cd,
                                        gp.subline_cd subline_cd, gp.iss_cd iss_cd,
                                        gp.issue_yy issue_yy, gp.pol_seq_no pol_seq_no,
                                        gp.renew_no renew_no, gp.incept_date incept_date,
                                        gp.expiry_date expiry_date, gv.motor_no,
                                        gv.serial_no, gv.plate_no
                                   FROM gipi_polbasic gp,
                                        gipi_vehicle gv,
                                        giis_assured ga,
                                        gipi_parlist gl
                                  WHERE 1 = 1
                                    AND gp.pol_flag IN (''1'', ''2'', ''3'', ''4'')
                                    AND gp.policy_id = gv.policy_id
                                    AND NVL (gp.endt_seq_no, 0) =
                                           (SELECT MAX (NVL (endt_seq_no, 0))
                                              FROM gipi_polbasic
                                             WHERE line_cd = gp.line_cd
                                               AND subline_cd = gp.subline_cd
                                               AND iss_cd = gp.iss_cd
                                               AND issue_yy = gp.issue_yy
                                               AND pol_seq_no = gp.pol_seq_no
                                               AND renew_no = gp.renew_no)
                                    AND gp.par_id = gl.par_id
                                    AND gl.assd_no = ga.assd_no
                                    '
         || v_where;
      stmt_str := stmt_str;

      OPEN c FOR stmt_str USING p_param2;

      LOOP
         FETCH c
          INTO v_pol.policy_no, v_pol.assd_name, v_pol.line_cd,
               v_pol.subline_cd, v_pol.iss_cd, v_pol.issue_yy,
               v_pol.pol_seq_no, v_pol.renew_no, v_pol.incept_date,
               v_pol.expiry_date, v_pol.motor_no, v_pol.serial_no,
               v_pol.plate_no;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_pol);
      END LOOP;

      CLOSE c;

      RETURN;
   EXCEPTION
      WHEN OTHERS
      THEN
         NULL;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.07.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : check_loss_date_time program unit
    **/
   PROCEDURE check_loss_date_time (
      p_line_cd             IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd          IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd          IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy            IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no          IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no            IN       gipi_polbasic.renew_no%TYPE,
      p_dsp_loss_date       IN       gicl_claims.dsp_loss_date%TYPE,
      p_subline_time        OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2,
      p_alert_accept_date   OUT      VARCHAR2,
      p_alert_override      OUT      VARCHAR2,
      p_allowed             OUT      VARCHAR2
   )
   IS
      v_accept_date         DATE;
      v_allow_accept_date   giis_parameters.param_value_v%TYPE;
      v_func_cd             giac_functions.function_code%TYPE    := 'EP';
   BEGIN
      SELECT get_subline_time (p_line_cd, p_subline_cd)
        INTO p_subline_time
        FROM DUAL;

      IF p_pol_iss_cd = giisp.v ('ISS_CD_RI')
      THEN
         SELECT accept_date
           INTO v_accept_date
           FROM giri_inpolbas
          WHERE policy_id IN (
                   SELECT policy_id
                     FROM gipi_polbasic
                    WHERE 1 = 1
                      AND line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_pol_iss_cd
                      AND issue_yy = p_issue_yy
                      AND pol_seq_no = p_pol_seq_no
                      AND renew_no = p_renew_no
                      AND endt_seq_no = 0); -- UCPBGEN-8873

         v_allow_accept_date := giisp.v ('ALLOW_LOSS_BEFORE_ACCEPT_DATE');

         IF v_allow_accept_date IS NULL
         THEN
            p_msg_alert :=
               'ALLOW_LOSS_DATE_BEYOND_ACCEPT_DATE does not exist in GIIS_PARAMETERS.';
            --,'E',TRUE);
            RETURN;
         ELSIF TRUNC (p_dsp_loss_date) < TRUNC (v_accept_date)
         THEN
            IF v_allow_accept_date = 'Y'
            THEN
               /*p_alert_accept_date :=
                     'User is not allowed to process a claim for policy with acceptance date, '
                  || TO_CHAR (v_accept_date, 'MM-DD-YYYY')
                  || ', later than the loss date.'
                  || ' Do you wish to continue?';*/
               p_alert_accept_date := 'Policy''s acceptance date, '||TO_CHAR (v_accept_date, 'MM-DD-YYYY')||
               ' is later than the loss date. Do you wish to continue?';
            ELSIF v_allow_accept_date = 'N'
            THEN
               p_msg_alert :=
                     'User is not allowed to process a claim for policy with acceptance date, '
                  || TO_CHAR (v_accept_date, 'MM-DD-YYYY')
                  || ', later than the loss date.';            --, 'E', TRUE);
               RETURN;
            ELSIF v_allow_accept_date = 'O'
            THEN
               IF NOT check_user_override_function (giis_users_pkg.app_user,
                                                    'GICLS010',
                                                    'AD'
                                                   )
               THEN
                  p_alert_override :=
                        'User is not allowed to process a claim for policy with acceptance date, '
                     || TO_CHAR (v_accept_date, 'MM-DD-YYYY')
                     || ', later than the loss date.'
                     || ' Would you like to override?';
               END IF;
            END IF;
         END IF;
      END IF;

      IF NOT check_user_override_function (giis_users_pkg.app_user,
                                           'GICLS010',
                                           v_func_cd
                                          )
      THEN
         p_allowed := 'N';
      ELSE
         p_allowed := 'Y';
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.10.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE check_last_endt_plate_no (
      p_line_cd      IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd   IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd   IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy     IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no   IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no     IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no     IN OUT   gicl_claims.plate_no%TYPE,
      p_item_no      IN       gipi_vehicle.item_no%TYPE,
      p_loss_date    IN       gicl_claims.dsp_loss_date%TYPE, --benjo 10.20.2016 SR-23261
      p_pol_eff_date IN       gicl_claims.pol_eff_date%TYPE, --benjo 10.20.2016 SR-23261
      p_expiry_date  IN       gicl_claims.expiry_date%TYPE, --benjo 10.20.2016 SR-23261
      p_msg_alert    OUT      VARCHAR2,
      p_count        OUT      NUMBER
   )
   IS
      v_plate_no   gipi_vehicle.plate_no%TYPE;
   BEGIN
      p_count := 0;
      
      /* benjo 10.20.2016 SR-23261 added condition for loss date */
      FOR a IN (SELECT COUNT (DISTINCT a.item_no) item_count
                  FROM gipi_vehicle a, gipi_polbasic b
                 WHERE a.policy_id = b.policy_id
                   AND b.line_cd = p_line_cd
                   AND b.subline_cd = p_subline_cd
                   AND b.iss_cd = p_pol_iss_cd
                   AND b.issue_yy = p_issue_yy
                   AND b.pol_seq_no = p_pol_seq_no
                   AND b.renew_no = p_renew_no
                   AND b.pol_flag IN ('1', '2', '3', '4')
                   AND TRUNC (DECODE (TRUNC (b.eff_date),
                                      TRUNC (b.incept_date), p_pol_eff_date,
                                      b.eff_date
                                     )
                             ) <= TRUNC (p_loss_date)
                   AND TRUNC (DECODE (NVL (b.endt_expiry_date, b.expiry_date),
                                      b.expiry_date, p_expiry_date,
                                      b.endt_expiry_date
                                     )
                             ) >= TRUNC (p_loss_date))
      LOOP
         p_count := a.item_count;
      END LOOP;

      IF p_count = 1
      THEN
         v_plate_no :=
            get_plate_no (p_line_cd,
                          p_subline_cd,
                          p_pol_iss_cd,
                          p_issue_yy,
                          p_pol_seq_no,
                          p_renew_no,
                          p_loss_date, --benjo 10.20.2016 SR-23261
                          p_pol_eff_date, --benjo 10.20.2016 SR-23261
                          p_expiry_date, --benjo 10.20.2016 SR-23261
                          NULL
                         );
      ELSIF p_count > 1
      THEN
         v_plate_no :=
            get_plate_no (p_line_cd,
                          p_subline_cd,
                          p_pol_iss_cd,
                          p_issue_yy,
                          p_pol_seq_no,
                          p_renew_no,
                          p_loss_date, --benjo 10.20.2016 SR-23261
                          p_pol_eff_date, --benjo 10.20.2016 SR-23261
                          p_expiry_date, --benjo 10.20.2016 SR-23261
                          p_item_no
                         );
      END IF;
      
      IF NVL(p_plate_no, '!@#$%^') != NVL(v_plate_no, '!@#$%^') --benjo 10.20.2016 SR-23261
      THEN
         p_msg_alert :=
            'Plate No. has change as of the last endorsement. Necessary changes will now be applied.';
         --,'I',FALSE);
         p_plate_no := v_plate_no;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.10.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE check_loss_date_with_plate_no (
      p_line_cd           IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd        IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no          IN OUT   gicl_claims.plate_no%TYPE,
      p_item_no           IN OUT   gipi_vehicle.item_no%TYPE,
      p_dsp_loss_date     IN       gicl_claims.dsp_loss_date%TYPE,
      p_pol_eff_date      IN       gicl_claims.pol_eff_date%TYPE,
      p_expiry_date       IN       gicl_claims.expiry_date%TYPE,
      p_time              IN       VARCHAR2,
      p_check_loss_date   OUT      VARCHAR2,
      p_plate_sw          OUT      VARCHAR2,
      p_serial_no         OUT      gicl_claims.serial_no%TYPE,
      p_motor_no          OUT      gicl_claims.motor_no%TYPE
   )
   IS
      v_datevalid      BOOLEAN := FALSE;
      v_subline_time   DATE;
      v_time           DATE;
      v_plate_ctr      NUMBER;
   BEGIN
      SELECT TO_DATE (p_time, 'HH:MI AM')
        INTO v_time
        FROM DUAL;

      BEGIN
         SELECT TO_DATE (TO_CHAR (TO_DATE (subline_time, 'SSSSS'), 'HH:MI AM'),
                         'HH:MI AM'
                        )
           INTO v_subline_time
           FROM giis_subline
          WHERE line_cd = p_line_cd AND subline_cd = p_subline_cd;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_subline_time := NULL;
      END;

      IF p_plate_no IS NOT NULL
      THEN
         FOR i IN
            (SELECT   1
                 FROM gipi_vehicle gv, gipi_polbasic gp
                WHERE gp.policy_id = gv.policy_id
                  AND gp.line_cd = p_line_cd
                  AND gp.subline_cd = p_subline_cd
                  AND gp.iss_cd = p_pol_iss_cd
                  AND gp.issue_yy = p_issue_yy
                  AND gp.pol_seq_no = p_pol_seq_no
                  AND gp.renew_no = p_renew_no
                  AND gv.plate_no = p_plate_no
                  AND TRUNC (DECODE (TRUNC (eff_date),
                                     TRUNC (incept_date), TRUNC
                                                               (p_pol_eff_date),
                                     eff_date
                                    )
                            ) <= TRUNC (p_dsp_loss_date)
                  AND TRUNC (DECODE (NVL (endt_expiry_date, expiry_date),
                                     expiry_date, TRUNC (p_expiry_date),
                                     endt_expiry_date
                                    )
                            ) >= TRUNC (p_dsp_loss_date)
                  AND DECODE (SIGN (  TRUNC (DECODE (TRUNC (eff_date),
                                                     TRUNC (incept_date), TRUNC
                                                               (p_pol_eff_date),
                                                     eff_date
                                                    )
                                            )
                                    - TRUNC (p_dsp_loss_date)
                                   ),
                              0, TO_DATE (TO_CHAR (NVL (v_time,
                                                        v_subline_time),
                                                   'HH:MI AM'
                                                  ),
                                          'HH:MI AM'
                                         ),
                              SYSDATE + 1
                             ) >=
                         DECODE (SIGN (  TRUNC (DECODE (TRUNC (eff_date),
                                                        TRUNC (incept_date), TRUNC
                                                               (p_pol_eff_date),
                                                        eff_date
                                                       )
                                               )
                                       - TRUNC (p_dsp_loss_date)
                                      ),
                                 0, TO_DATE (TO_CHAR (NVL (v_time,
                                                           v_subline_time
                                                          ),
                                                      'HH:MI AM'
                                                     ),
                                             'HH:MI AM'
                                            ),
                                 SYSDATE
                                )
                  AND DECODE (SIGN (  TRUNC (DECODE (NVL (endt_expiry_date,
                                                          expiry_date
                                                         ),
                                                     expiry_date, TRUNC
                                                                (p_expiry_date),
                                                     endt_expiry_date
                                                    )
                                            )
                                    - TRUNC (p_dsp_loss_date)
                                   ),
                              0, TO_DATE (TO_CHAR (NVL (v_time,
                                                        v_subline_time),
                                                   'HH:MI AM'
                                                  ),
                                          'HH:MI AM'
                                         ),
                              SYSDATE
                             ) <=
                         DECODE
                               (SIGN (  TRUNC (DECODE (NVL (endt_expiry_date,
                                                            expiry_date
                                                           ),
                                                       expiry_date, TRUNC
                                                                (p_expiry_date),
                                                       endt_expiry_date
                                                      )
                                              )
                                      - TRUNC (p_dsp_loss_date)
                                     ),
                                0, TO_DATE (TO_CHAR (NVL (v_time,
                                                          v_subline_time
                                                         ),
                                                     'HH:MI AM'
                                                    ),
                                            'HH:MI AM'
                                           ),
                                SYSDATE + 1
                               )
                  AND NOT EXISTS (
                         SELECT 1
                           FROM gipi_item gi
                          WHERE gi.policy_id = gp.policy_id
                            AND gi.ann_tsi_amt = 0
                            AND gi.item_no = gv.item_no)
             --add by Jess 01/08/10  to solve FPAC PRF 4328
             ORDER BY gp.policy_id DESC)
         LOOP
            v_datevalid := TRUE;
            EXIT;
         END LOOP;

         FOR a IN (SELECT a.plate_no, a.item_no
                     FROM gipi_vehicle a, gipi_polbasic b
                    WHERE a.policy_id = b.policy_id
                      AND b.line_cd = p_line_cd
                      AND b.subline_cd = p_subline_cd
                      AND b.iss_cd = p_pol_iss_cd
                      AND b.issue_yy = p_issue_yy
                      AND b.pol_seq_no = p_pol_seq_no
                      AND b.renew_no = p_renew_no
                      AND b.pol_flag IN ('1', '2', '3', '4')
                      AND NOT EXISTS (
                             SELECT '1'
                               FROM gicl_claims
                              WHERE line_cd = b.line_cd
                                AND subline_cd = b.subline_cd
                                AND pol_iss_cd = b.iss_cd
                                AND issue_yy = b.issue_yy
                                AND pol_seq_no = b.pol_seq_no
                                AND renew_no = b.renew_no
                                AND total_tag = 'Y')
                      AND a.item_no = p_item_no)
         LOOP
            IF a.plate_no IS NULL AND p_plate_no IS NOT NULL
            THEN
               v_datevalid := TRUE;
            END IF;
         END LOOP;

         p_check_loss_date := 'N';

         IF NOT v_datevalid
         THEN
            p_check_loss_date := 'Y';

            SELECT COUNT (*)
              INTO v_plate_ctr
              FROM TABLE (gipi_vehicle_pkg.get_valid_plate_nos (p_line_cd,
                                                                p_subline_cd,
                                                                p_pol_iss_cd,
                                                                p_issue_yy,
                                                                p_pol_seq_no,
                                                                p_renew_no
                                                               )
                         );

            IF v_plate_ctr = 1
            THEN
               p_plate_sw := 'N';

               SELECT item_no, plate_no, motor_no, serial_no
                 INTO p_item_no, p_plate_no, p_motor_no, p_serial_no
                 FROM TABLE
                          (gipi_vehicle_pkg.get_valid_plate_nos (p_line_cd,
                                                                 p_subline_cd,
                                                                 p_pol_iss_cd,
                                                                 p_issue_yy,
                                                                 p_pol_seq_no,
                                                                 p_renew_no
                                                                )
                          );
            ELSIF (v_plate_ctr > 1 OR v_plate_ctr = 0)
            THEN
               p_plate_sw := 'Y';
            END IF;
         END IF;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.10.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE validate_loss_date_plate_no (
      p_line_cd           IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd        IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd        IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy          IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no        IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no          IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no          IN OUT   gicl_claims.plate_no%TYPE,
      p_item_no           IN OUT   gipi_vehicle.item_no%TYPE,
      p_dsp_loss_date     IN       gicl_claims.dsp_loss_date%TYPE,
      p_pol_eff_date      IN       gicl_claims.pol_eff_date%TYPE,
      p_expiry_date       IN       gicl_claims.expiry_date%TYPE,
      p_time              IN       VARCHAR2,
      p_msg_alert         OUT      VARCHAR2,
      p_count             OUT      NUMBER,
      p_check_loss_date   OUT      VARCHAR2,
      p_plate_sw          OUT      VARCHAR2,
      p_serial_no         OUT      gicl_claims.serial_no%TYPE,
      p_motor_no          OUT      gicl_claims.motor_no%TYPE
   )
   IS
   BEGIN
      gicl_claims_pkg.check_last_endt_plate_no (p_line_cd,
                                                p_subline_cd,
                                                p_pol_iss_cd,
                                                p_issue_yy,
                                                p_pol_seq_no,
                                                p_renew_no,
                                                p_plate_no,
                                                p_item_no,
                                                p_dsp_loss_date, --benjo 10.20.2016 SR-23261
                                                p_pol_eff_date, --benjo 10.20.2016 SR-23261
                                                p_expiry_date, --benjo 10.20.2016 SR-23261
                                                p_msg_alert,
                                                p_count
                                               );

      IF p_count > 1
      THEN
         IF     p_dsp_loss_date IS NOT NULL
            AND p_plate_no IS NOT NULL
            AND p_line_cd = giisp.v ('MOTOR CAR LINE CODE')
         THEN
            gicl_claims_pkg.check_loss_date_with_plate_no (p_line_cd,
                                                           p_subline_cd,
                                                           p_pol_iss_cd,
                                                           p_issue_yy,
                                                           p_pol_seq_no,
                                                           p_renew_no,
                                                           p_plate_no,
                                                           p_item_no,
                                                           p_dsp_loss_date,
                                                           p_pol_eff_date,
                                                           p_expiry_date,
                                                           p_time,
                                                           p_check_loss_date,
                                                           p_plate_sw,
                                                           p_serial_no,
                                                           p_motor_no
                                                          );
         END IF;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.11.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE validate_loss_time (
      p_line_cd               IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd            IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd            IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy              IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no            IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no              IN       gipi_polbasic.renew_no%TYPE,
      p_loss_date             IN       gicl_claims.dsp_loss_date%TYPE,
      p_expiry_date           IN       gipi_polbasic.expiry_date%TYPE,
      p_user_level            IN       giis_users.user_level%TYPE,
      p_in_hou_adj            OUT      giis_users.user_id%TYPE,
      p_nbt_in_hou_adj_name   OUT      giis_users.user_name%TYPE,
      p_clm_file_date         OUT      VARCHAR2,
      p_ri_cd                 OUT      giri_inpolbas.ri_cd%TYPE,
      p_dsp_ri_name           OUT      giis_reinsurer.ri_name%TYPE,
      p_assd_no               OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name             OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd            OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no            OUT      gicl_claims.obligee_no%TYPE
   )
   IS
   BEGIN
      FOR rec IN (SELECT user_id, user_name
                    FROM giis_users
                   WHERE user_id = giis_users_pkg.app_user
                     AND user_level >= p_user_level)
      LOOP
         p_in_hou_adj := rec.user_id;
         p_nbt_in_hou_adj_name := rec.user_name;
      END LOOP;

      SELECT TO_CHAR (SYSDATE, 'MM-DD-YYYY')
        INTO p_clm_file_date
        FROM DUAL;

      giri_inpolbas_pkg.get_cedant (p_line_cd,
                                    p_subline_cd,
                                    p_pol_iss_cd,
                                    p_issue_yy,
                                    p_pol_seq_no,
                                    p_renew_no,
                                    p_ri_cd,
                                    p_dsp_ri_name
                                   );
      gicl_claims_pkg.get_assured_obligee (p_assd_no,
                                           p_assd_name,
                                           p_acct_of_cd,
                                           p_obligee_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_loss_date,
                                           p_expiry_date
                                          );
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.13.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE check_claim (
      p_line_cd         IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN       gipi_polbasic.renew_no%TYPE,
      p_plate_no        IN       gicl_claims.plate_no%TYPE,
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_dsp_loss_date   IN       gicl_claims.dsp_loss_date%TYPE,
      p_time            IN       VARCHAR2,
      p_expiry_date     IN       gipi_polbasic.expiry_date%TYPE,
      p_time_flag       OUT      VARCHAR2,
      p_override        OUT      VARCHAR2,
      p_msg_alert       OUT      VARCHAR2,
      p_user_flag       OUT      VARCHAR2,
      p_ri_cd           OUT      giri_inpolbas.ri_cd%TYPE,
      p_dsp_ri_name     OUT      giis_reinsurer.ri_name%TYPE,
      p_assd_no         OUT      gipi_wpolbas.assd_no%TYPE,
      p_assd_name       OUT      giis_assured.assd_name%TYPE,
      p_acct_of_cd      OUT      gicl_claims.acct_of_cd%TYPE,
      p_obligee_no      OUT      gicl_claims.obligee_no%TYPE
   )
   IS
      v_time   DATE;
   BEGIN
      SELECT TO_DATE (NVL (p_time, '12:00 AM'), 'HH:MI AM')
        INTO v_time
        FROM DUAL;

      p_time_flag := 'TRUE';

      BEGIN
         SELECT DECODE(param_value_v, 'O', 'Y', param_value_v) as param_value_v --adpascual 5.7.13 to consider param_value_v of O
           INTO p_override
           FROM giis_parameters
          WHERE param_name = 'DUPLICATE_CLM_OVERRIDE';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg_alert :=
               'DUPLICATE_CLM_OVERRIDE parameter not found in giis_parameters!';
      --,'E',TRUE);
      END;

      FOR i IN (SELECT 'x'
                  FROM gicl_claims a
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                   AND pol_iss_cd = p_pol_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no
                   AND dsp_loss_date =
                          TO_DATE (   TO_CHAR (p_dsp_loss_date, 'MM-DD-RRRR ')
                                   || TO_CHAR (v_time, 'HH:MI AM'),
                                   'MM-DD-RRRR HH:MI AM'
                                  )
                   AND NVL (plate_no, '*') = NVL (p_plate_no, '*')
                   AND claim_id <> NVL (p_claim_id, -1))
      LOOP
         p_time_flag := 'FALSE';
      END LOOP;

      IF NOT check_user_override_function (giis_users_pkg.app_user,
                                           'GICLS010',
                                           'DC'
                                          )
      THEN
         p_user_flag := 'FALSE';
      ELSE
         p_user_flag := 'TRUE';
      END IF;

      giri_inpolbas_pkg.get_cedant (p_line_cd,
                                    p_subline_cd,
                                    p_pol_iss_cd,
                                    p_issue_yy,
                                    p_pol_seq_no,
                                    p_renew_no,
                                    p_ri_cd,
                                    p_dsp_ri_name
                                   );
      gicl_claims_pkg.get_assured_obligee (p_assd_no,
                                           p_assd_name,
                                           p_acct_of_cd,
                                           p_obligee_no,
                                           p_line_cd,
                                           p_subline_cd,
                                           p_pol_iss_cd,
                                           p_issue_yy,
                                           p_pol_seq_no,
                                           p_renew_no,
                                           p_dsp_loss_date,
                                           p_expiry_date
                                          );
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.17.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : will check if the previous event, currently selected event
    **                    and claim record has already computed for the XOL.
    **/
   PROCEDURE validate_catastrophic_code (
      p_line_cd             IN       gicl_claims.line_cd%TYPE,
      p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
      p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
      p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
      p_claim_id            IN       gicl_claims.claim_id%TYPE,
      p_catastrophic_cd     IN OUT   gicl_claims.catastrophic_cd%TYPE,
      p_catastrophic_desc   OUT      VARCHAR2,
      p_msg_alert           OUT      VARCHAR2
   )
   IS
      v_catastrophic     NUMBER (5);
      v_cat_desc_old     gicl_cat_dtl.catastrophic_desc%TYPE;
      v_cat_desc_new     gicl_cat_dtl.catastrophic_desc%TYPE;
      v_dist             VARCHAR2 (1)                          := 'N';
      v_dist2            VARCHAR2 (1)                          := 'N';
      v_exist_res_old    VARCHAR2 (1)                          := 'N';
      v_exist_res_new    VARCHAR2 (1)                          := 'N';
      v_exist_payt_old   VARCHAR2 (1)                          := 'N';
      v_exist_payt_new   VARCHAR2 (1)                          := 'N';
      TEST               VARCHAR2 (30)                     := 'CATASTROPHIC2';
      --test_alert        ALERT;
      test_no            NUMBER;
      v_res_net          VARCHAR2 (1)                          := 'N';
      v_res_xol          VARCHAR2 (1)                          := 'N';
      v_payt_net         VARCHAR2 (1)                          := 'N';
      v_payt_xol         VARCHAR2 (1)                          := 'N';
      v_res_net_old      VARCHAR2 (1)                          := 'N';
      v_res_xol_old      VARCHAR2 (1)                          := 'N';
      v_payt_net_old     VARCHAR2 (1)                          := 'N';
      v_payt_xol_old     VARCHAR2 (1)                          := 'N';
      v_res_net_curr     VARCHAR2 (1)                          := 'N';
      v_res_xol_curr     VARCHAR2 (1)                          := 'N';
      v_payt_net_curr    VARCHAR2 (1)                          := 'N';
      v_payt_xol_curr    VARCHAR2 (1)                          := 'N';
      v_text             VARCHAR2 (500);
      v_xol_share_type   giac_parameters.param_value_v%TYPE
                                           := giacp.v ('XOL_TRTY_SHARE_TYPE');
   BEGIN
      --test_alert := FIND_ALERT(TEST);
      -- check if current claim is distributed
      FOR dist IN (SELECT 'X'
                     FROM gicl_claims a, gicl_clm_res_hist b
                    WHERE 1 = 1
                      AND a.claim_id = b.claim_id
                      AND line_cd = p_line_cd
                      AND subline_cd = p_subline_cd
                      AND iss_cd = p_iss_cd
                      AND clm_yy = p_clm_yy
                      AND clm_seq_no = p_clm_seq_no
                      AND b.dist_sw = 'Y')
      LOOP
         v_dist := 'Y';
         EXIT;
      END LOOP;

      IF v_dist = 'Y'
      THEN                           --AND :SYSTEM.RECORD_STATUS != 'NEW' THEN
         -- check loss expense history
         FOR curr_xol IN (SELECT DISTINCT a.share_type share_type
                                     FROM gicl_loss_exp_ds a,
                                          gicl_clm_loss_exp b
                                    WHERE a.claim_id = b.claim_id
                                      AND a.clm_loss_id = b.clm_loss_id
                                      AND NVL (b.cancel_sw, 'N') = 'N'
                                      AND NVL (a.negate_tag, 'N') = 'N'
                                      AND a.claim_id = p_claim_id
                                      AND a.share_type IN
                                                        (v_xol_share_type, 1))
         LOOP
            IF curr_xol.share_type = 1
            THEN
               v_payt_net := 'Y';
            END IF;

            IF curr_xol.share_type = v_xol_share_type
            THEN
               v_payt_xol := 'Y';
            END IF;
         END LOOP;

         FOR get_all_xol IN (SELECT DISTINCT a.share_type share_type
                                        FROM gicl_reserve_ds a
                                       WHERE NVL (a.negate_tag, 'N') = 'N'
                                         AND claim_id = p_claim_id
                                         AND a.share_type IN
                                                        (v_xol_share_type, 1))
         LOOP
            IF get_all_xol.share_type = 1
            THEN
               v_res_net := 'Y';
            END IF;

            IF get_all_xol.share_type = v_xol_share_type
            THEN
               v_res_xol := 'Y';
            END IF;
         END LOOP;

         FOR cat IN (SELECT catastrophic_cd
                       FROM gicl_claims
                      WHERE line_cd = p_line_cd
                        AND subline_cd = p_subline_cd
                        AND iss_cd = p_iss_cd
                        AND clm_yy = p_clm_yy
                        AND clm_seq_no = p_clm_seq_no)
         LOOP
            v_catastrophic := cat.catastrophic_cd;
         END LOOP;

         IF NVL (p_catastrophic_cd, 0) != NVL (v_catastrophic, 0)
         THEN
            -- check if there are records having share_type = 4 in the NEW catastrophic event
            IF p_catastrophic_cd IS NOT NULL
            THEN
               FOR get_desc IN (SELECT catastrophic_desc
                                  FROM gicl_cat_dtl
                                 WHERE catastrophic_cd = p_catastrophic_cd)
               LOOP
                  v_cat_desc_new := get_desc.catastrophic_desc;
               END LOOP;

               chk_cat_xol (v_res_net_curr,
                            v_res_xol_curr,
                            v_payt_net_curr,
                            v_payt_xol_curr,
                            p_catastrophic_cd,
                            p_claim_id
                           );

               IF     (NVL (v_res_net, 'N') = 'Y' OR NVL (v_res_xol, 'N') =
                                                                           'Y'
                      )
                  AND v_res_xol_curr = 'Y'
               THEN
                  v_exist_res_new := 'Y';
               END IF;

               IF     (NVL (v_payt_net, 'N') = 'Y'
                       OR NVL (v_payt_xol, 'N') = 'Y'
                      )
                  AND v_payt_xol_curr = 'Y'
               THEN
                  v_exist_payt_new := 'Y';
               END IF;
            END IF;

            -- check if there are records having share_type = 4 in the old catastrophic event
            IF v_catastrophic IS NOT NULL
            THEN
               FOR get_desc IN (SELECT catastrophic_desc
                                  FROM gicl_cat_dtl
                                 WHERE catastrophic_cd = v_catastrophic)
               LOOP
                  v_cat_desc_old := get_desc.catastrophic_desc;
               END LOOP;

               chk_cat_xol (v_res_net_old,
                            v_res_xol_old,
                            v_payt_net_old,
                            v_payt_xol_old,
                            v_catastrophic,
                            p_claim_id
                           );

               IF     (NVL (v_res_net, 'N') = 'Y' OR NVL (v_res_xol, 'N') =
                                                                           'Y'
                      )
                  AND v_res_xol_old = 'Y'
               THEN
                  v_exist_res_old := 'Y';
               END IF;

               IF     (NVL (v_payt_net, 'N') = 'Y'
                       OR NVL (v_payt_xol, 'N') = 'Y'
                      )
                  AND v_payt_xol_old = 'Y'
               THEN
                  v_exist_payt_old := 'Y';
               END IF;
            END IF;

            IF    v_exist_payt_old = 'Y'
               OR v_exist_payt_new = 'Y'
               OR v_exist_res_old = 'Y'
               OR v_exist_res_new = 'Y'
               OR (    (v_res_xol = 'Y' OR v_payt_xol = 'Y')
                   AND p_catastrophic_cd IS NOT NULL
                  )
            THEN
               v_text :=
                  'There are records that are distributed for XOL, please redistribute all claims distribution records ';

               IF     (v_exist_payt_old = 'Y' OR v_exist_res_old = 'Y')
                  AND (v_exist_payt_new = 'Y' OR v_exist_res_new = 'Y')
               THEN
                  v_text :=
                        v_text
                     || ' and all records under catastrophic events '
                     || v_cat_desc_old
                     || ' and '
                     || v_cat_desc_new
                     || '.';
               ELSIF (v_exist_payt_old = 'Y' OR v_exist_res_old = 'Y')
               THEN
                  v_text :=
                        v_text
                     || ' and all records under catastrophic event '
                     || v_cat_desc_old
                     || '.';
               ELSIF (v_exist_payt_new = 'Y' OR v_exist_res_new = 'Y')
               THEN
                  v_text :=
                        v_text
                     || ' and all records under catastrophic event '
                     || v_cat_desc_new
                     || '.';
               END IF;

               /*SET_ALERT_PROPERTY(TEST_ALERT,ALERT_MESSAGE_TEXT, v_text);
               TEST_NO := SHOW_ALERT(TEST_ALERT);
               IF test_no = alert_button2 THEN
                  :c003.catastrophic_cd := v_catastrophic ;
                  RAISE FORM_TRIGGER_FAILURE;
               END IF;*/
               p_msg_alert := v_text;
               p_catastrophic_cd := v_catastrophic;
               p_catastrophic_desc := v_cat_desc_old;
            END IF;
         END IF;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.19.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE validate_unpaid_prem (
      p_claim_id                gicl_claims.claim_id%TYPE,
      p_nbt_clm_stat_cd         VARCHAR2,
      p_msg_alert         OUT   VARCHAR2,
      p_workflow_msgr     OUT   VARCHAR2
   )
   IS
      v_count   NUMBER := 0;
   BEGIN
      FOR c1 IN (SELECT b.userid, d.event_desc
                   FROM giis_events_column c,
                        giis_event_mod_users b,
                        giis_event_modules a,
                        giis_events d
                  WHERE 1 = 1
                    AND c.event_cd = a.event_cd
                    AND c.event_mod_cd = a.event_mod_cd
                    AND b.event_mod_cd = a.event_mod_cd
                    AND b.passing_userid = giis_users_pkg.app_user
                    AND a.module_id = 'GICLS010'
                    AND a.event_cd = d.event_cd
                    AND UPPER (d.event_desc) = 'UNPAID PREMIUMS WITH CLAIMS')
      LOOP
         BEGIN
            SELECT 1
              INTO v_count
              FROM gicl_claims
             WHERE claim_id = p_claim_id AND clm_stat_cd = 'NO';
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;

         IF v_count <> 0 AND p_nbt_clm_stat_cd = 'Y'
         THEN
            create_transfer_workflow_rec ('UNPAID PREMIUMS WITH CLAIMS',
                                          'GICLS010',
                                          c1.userid,
                                          p_claim_id,
                                             c1.event_desc
                                          || ' '
                                          || get_clm_no (p_claim_id),
                                          p_msg_alert,
                                          p_workflow_msgr,
                                          giis_users_pkg.app_user
                                         );
         END IF;
      END LOOP;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.19.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :  getting details for check_location program unit
    **/
   PROCEDURE get_check_location_dtl (
      p_claim_id                        gicl_claims.claim_id%TYPE,
      p_gicl_fire_dtl_exist       OUT   VARCHAR2,
      p_gicl_casualty_dtl_exist   OUT   VARCHAR2,
      p_block_id                  OUT   gicl_fire_dtl.block_id%TYPE,
      p_district_no               OUT   gicl_fire_dtl.district_no%TYPE,
      p_block_no                  OUT   gicl_fire_dtl.block_no%TYPE,
      p_location                        gicl_casualty_dtl.location%TYPE,
      p_val_loc                   OUT   VARCHAR2
   )
   IS
   BEGIN
      p_val_loc := 'N';
      
      SELECT gicl_fire_dtl_pkg.get_gicl_fire_dtl_exist (p_claim_id)
        INTO p_gicl_fire_dtl_exist
        FROM DUAL;

      SELECT gicl_casualty_dtl_pkg.get_gicl_casualty_dtl_exist (p_claim_id)
        INTO p_gicl_casualty_dtl_exist
        FROM DUAL;

      IF p_gicl_fire_dtl_exist = 'Y'
      THEN
         FOR fi IN (SELECT NVL (block_id, 0) block_id,
                           NVL (district_no, '0') district_no,
                           NVL (block_no, '0') block_no
                      FROM gicl_fire_dtl
                     WHERE claim_id = p_claim_id)
         LOOP
            p_block_id := fi.block_id;
            p_district_no := fi.district_no;
            p_block_no := fi.block_no;
            EXIT;
         END LOOP;
      END IF;

      IF p_gicl_casualty_dtl_exist = 'Y'
      THEN
         FOR ca IN (SELECT 'Y'
                      FROM gicl_casualty_dtl
                     WHERE claim_id = p_claim_id
                       AND location = p_location)
         LOOP
            p_val_loc := 'Y';
            EXIT;
         END LOOP;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.24.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :  create and assign a claim sequence number.
    **/
   PROCEDURE get_clm_seq_no (
      p_line_cd            giis_line.line_cd%TYPE,
      p_subline_cd         giis_subline.subline_cd%TYPE,
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_clm_yy             gicl_claims.clm_yy%TYPE,
      p_clm_seq_no   OUT   giis_clm_seq.clm_seq_no%TYPE
   )
   IS
      v_line_cd      giis_line.line_cd%TYPE;
      v_subline_cd   giis_subline.subline_cd%TYPE;
      v_iss_cd       giis_issource.iss_cd%TYPE;
      v_clm_yy       gicl_claims.clm_yy%TYPE;
      v_max_GC_cln	 gicl_claims.clm_seq_no%type; --robert  10.13.14
	  v_max_GCS_cln	 giis_clm_seq.clm_seq_no%type; --robert  10.13.14
      v_issue_yy     VARCHAR2(1);  --robert  10.13.14
   BEGIN
      BEGIN
         SELECT DECODE (line_cd, 'Y', p_line_cd, '**') line_cd,
                DECODE (subline_cd, 'Y', p_subline_cd, '**') subline_cd,
                DECODE (iss_cd, 'Y', p_iss_cd, '**') iss_cd,
                DECODE (issue_yy, 'Y', p_clm_yy, -1) issue_yy,
                DECODE(issue_yy, 'Y', 'Y', 'N') iss_yy --robert  10.13.14
           INTO v_line_cd,
                v_subline_cd,
                v_iss_cd,
                v_clm_yy,
                v_issue_yy --robert  10.13.14
           FROM giis_company_seq
          WHERE pol_clm_seq = 'C';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_line_cd := p_line_cd;
            v_subline_cd := p_subline_cd;
            v_iss_cd := p_iss_cd;
            v_clm_yy := p_clm_yy;
      END;
     --robert  10.13.14
     SELECT NVL (MAX (clm_seq_no), 0)
       INTO v_max_gc_cln
       FROM gicl_claims a
      WHERE a.line_cd = DECODE (v_line_cd, '**', a.line_cd, v_line_cd)
        AND a.subline_cd = DECODE (v_subline_cd, '**', a.subline_cd, v_subline_cd)
        AND a.iss_cd = DECODE (v_iss_cd, '**', a.iss_cd, v_iss_cd)
        AND a.clm_yy =
                   DECODE (v_issue_yy,
                           'N', a.clm_yy,
                           v_clm_yy
                          );
     --robert  10.13.14                     
     SELECT clm_seq_no
       INTO v_max_GCS_cln
       FROM giis_clm_seq
      WHERE line_cd    = v_line_cd
        AND subline_cd = v_subline_cd
        AND iss_cd     = v_iss_cd
        AND clm_yy     = DECODE (v_issue_yy,
                               'N', clm_yy,
                               v_clm_yy
                              );
                              
      IF v_max_GCS_cln <> v_max_GC_cln THEN  
		  UPDATE giis_clm_seq a
       		 SET clm_seq_no   = v_max_GC_cln
           WHERE a.line_cd    = v_line_cd
             AND a.subline_cd = v_subline_cd
             AND a.iss_cd     = v_iss_cd
             AND a.clm_yy     = DECODE (v_issue_yy,
			                       'N', a.clm_yy,
			                       v_clm_yy
			                      );  
      END IF;

      SELECT clm_seq_no + 1
        INTO p_clm_seq_no
        FROM giis_clm_seq a
       WHERE a.line_cd = v_line_cd
         AND a.subline_cd = v_subline_cd
         AND a.iss_cd = v_iss_cd
         --AND a.clm_yy = v_clm_yy; 
         AND a.clm_yy     = DECODE (v_issue_yy, 'N', a.clm_yy, v_clm_yy); --robert  10.13.14

      UPDATE giis_clm_seq a
         SET clm_seq_no = clm_seq_no + 1
       WHERE a.line_cd = v_line_cd
         AND a.subline_cd = v_subline_cd
         AND a.iss_cd = v_iss_cd
         --AND a.clm_yy = v_clm_yy;
         AND a.clm_yy     = DECODE (v_issue_yy, 'N', a.clm_yy, v_clm_yy); --robert  10.13.14
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giis_clm_seq
                     (line_cd, subline_cd, iss_cd, clm_yy, clm_seq_no
                     )
              --VALUES (v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy, 1 
              VALUES (v_line_cd, v_subline_cd, v_iss_cd, v_clm_yy, v_max_GC_cln + 1 --robert  10.13.14
                     );

         --p_clm_seq_no := 1;
         p_clm_seq_no := v_max_GC_cln + 1; --robert  10.13.14
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.24.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : inserting/updating gicl_claims record
    **/
   PROCEDURE set_gicl_claims (
      p_claim_id               gicl_claims.claim_id%TYPE,
      p_line_cd                gicl_claims.line_cd%TYPE,
      p_subline_cd             gicl_claims.subline_cd%TYPE,
      p_issue_yy               gicl_claims.issue_yy%TYPE,
      p_pol_seq_no             gicl_claims.pol_seq_no%TYPE,
      p_renew_no               gicl_claims.renew_no%TYPE,
      p_pol_iss_cd             gicl_claims.pol_iss_cd%TYPE,
      p_clm_yy                 gicl_claims.clm_yy%TYPE,
      p_clm_seq_no             gicl_claims.clm_seq_no%TYPE,
      p_iss_cd                 gicl_claims.iss_cd%TYPE,
      p_clm_control            gicl_claims.clm_control%TYPE,
      p_clm_coop               gicl_claims.clm_coop%TYPE,
      p_assd_no                gicl_claims.assd_no%TYPE,
      p_recovery_sw            gicl_claims.recovery_sw%TYPE,
      p_clm_file_date          gicl_claims.clm_file_date%TYPE,
      p_loss_date              gicl_claims.loss_date%TYPE,
      p_entry_date             gicl_claims.entry_date%TYPE,
      p_user_id                gicl_claims.user_id%TYPE,
      p_last_update            gicl_claims.last_update%TYPE,
      p_dsp_loss_date          gicl_claims.dsp_loss_date%TYPE,
      p_clm_stat_cd            gicl_claims.clm_stat_cd%TYPE,
      p_clm_setl_date          gicl_claims.clm_setl_date%TYPE,
      p_loss_pd_amt            gicl_claims.loss_pd_amt%TYPE,
      p_loss_res_amt           gicl_claims.loss_res_amt%TYPE,
      p_exp_pd_amt             gicl_claims.exp_pd_amt%TYPE,
      p_loss_loc1              gicl_claims.loss_loc1%TYPE,
      p_loss_loc2              gicl_claims.loss_loc2%TYPE,
      p_loss_loc3              gicl_claims.loss_loc3%TYPE,
      p_in_hou_adj             gicl_claims.in_hou_adj%TYPE,
      p_pol_eff_date           gicl_claims.pol_eff_date%TYPE,
      p_csr_no                 gicl_claims.csr_no%TYPE,
      p_loss_cat_cd            gicl_claims.loss_cat_cd%TYPE,
      p_intm_no                gicl_claims.intm_no%TYPE,
      p_clm_amt                gicl_claims.clm_amt%TYPE,
      p_loss_dtls              gicl_claims.loss_dtls%TYPE,
      p_obligee_no             gicl_claims.obligee_no%TYPE,
      p_exp_res_amt            gicl_claims.exp_res_amt%TYPE,
      p_assured_name           gicl_claims.assured_name%TYPE,
      p_ri_cd                  gicl_claims.ri_cd%TYPE,
      p_plate_no               gicl_claims.plate_no%TYPE,
      p_cpi_rec_no             gicl_claims.cpi_rec_no%TYPE,
      p_cpi_branch_cd          gicl_claims.cpi_branch_cd%TYPE,
      p_clm_dist_tag           gicl_claims.clm_dist_tag%TYPE,
      p_assd_name2             gicl_claims.assd_name2%TYPE,
      p_old_stat_cd            gicl_claims.old_stat_cd%TYPE,
      p_close_date             gicl_claims.close_date%TYPE,
      p_expiry_date            gicl_claims.expiry_date%TYPE,
      p_acct_of_cd             gicl_claims.acct_of_cd%TYPE,
      p_max_endt_seq_no        gicl_claims.max_endt_seq_no%TYPE,
      p_remarks                gicl_claims.remarks%TYPE,
      p_catastrophic_cd        gicl_claims.catastrophic_cd%TYPE,
      p_cred_branch            gicl_claims.cred_branch%TYPE,
      p_net_pd_loss            gicl_claims.net_pd_loss%TYPE,
      p_net_pd_exp             gicl_claims.net_pd_exp%TYPE,
      p_refresh_sw             gicl_claims.refresh_sw%TYPE,
      p_total_tag              gicl_claims.total_tag%TYPE,
      p_reason_cd              gicl_claims.reason_cd%TYPE,
      p_province_cd            gicl_claims.province_cd%TYPE,
      p_city_cd                gicl_claims.city_cd%TYPE,
      p_zip_cd                 gicl_claims.zip_cd%TYPE,
      p_pack_policy_id         gicl_claims.pack_policy_id%TYPE,
      p_motor_no               gicl_claims.motor_no%TYPE,
      p_serial_no              gicl_claims.serial_no%TYPE,
      p_settling_agent_cd      gicl_claims.settling_agent_cd%TYPE,
      p_survey_agent_cd        gicl_claims.survey_agent_cd%TYPE,
      p_tran_no                gicl_claims.tran_no%TYPE,
      p_contact_no             gicl_claims.contact_no%TYPE,
      p_email_address          gicl_claims.email_address%TYPE,
      p_special_instructions   gicl_claims.special_instructions%TYPE,
      p_def_processor          gicl_claims.def_processor%TYPE,
      p_location_cd            gicl_claims.location_cd%TYPE,
      p_block_id               gicl_claims.block_id%TYPE,
      p_district_no            gicl_claims.district_no%TYPE,
      p_reported_by            gicl_claims.reported_by%TYPE
   )
   IS
   BEGIN
      MERGE INTO gicl_claims
         USING DUAL
         ON (claim_id = p_claim_id)
         WHEN NOT MATCHED THEN
            INSERT (claim_id, line_cd, subline_cd, issue_yy, pol_seq_no,
                    renew_no, pol_iss_cd, clm_yy, clm_seq_no, iss_cd,
                    clm_control, clm_coop, assd_no, recovery_sw,
                    clm_file_date, loss_date, entry_date, user_id,
                    last_update, dsp_loss_date, clm_stat_cd, clm_setl_date,
                    loss_pd_amt, loss_res_amt, exp_pd_amt, loss_loc1,
                    loss_loc2, loss_loc3, in_hou_adj, pol_eff_date, csr_no,
                    loss_cat_cd, intm_no, clm_amt, loss_dtls, obligee_no,
                    exp_res_amt, assured_name, ri_cd, plate_no, cpi_rec_no,
                    cpi_branch_cd, clm_dist_tag, assd_name2, old_stat_cd,
                    close_date, expiry_date, acct_of_cd, max_endt_seq_no,
                    remarks, catastrophic_cd, cred_branch, net_pd_loss,
                    net_pd_exp, refresh_sw, total_tag, reason_cd,
                    province_cd, city_cd, zip_cd, pack_policy_id, motor_no,
                    serial_no, settling_agent_cd, survey_agent_cd, tran_no,
                    contact_no, email_address, special_instructions,
                    def_processor, location_cd, block_id, district_no,
                    reported_by)
            VALUES (p_claim_id, p_line_cd, p_subline_cd, p_issue_yy,
                    p_pol_seq_no, p_renew_no, p_pol_iss_cd, p_clm_yy,
                    p_clm_seq_no, p_iss_cd, p_clm_control, p_clm_coop,
                    p_assd_no, p_recovery_sw, p_clm_file_date, p_loss_date,
                    p_entry_date, p_user_id, SYSDATE, p_dsp_loss_date,
                    p_clm_stat_cd, p_clm_setl_date, p_loss_pd_amt,
                    p_loss_res_amt, p_exp_pd_amt, p_loss_loc1, p_loss_loc2,
                    p_loss_loc3, p_in_hou_adj, p_pol_eff_date, p_csr_no,
                    p_loss_cat_cd, p_intm_no, p_clm_amt, p_loss_dtls,
                    p_obligee_no, p_exp_res_amt, p_assured_name, p_ri_cd,
                    p_plate_no, p_cpi_rec_no, p_cpi_branch_cd,
                    p_clm_dist_tag, p_assd_name2, p_old_stat_cd,
                    p_close_date, p_expiry_date, p_acct_of_cd,
                    p_max_endt_seq_no, p_remarks, p_catastrophic_cd,
                    p_cred_branch, p_net_pd_loss, p_net_pd_exp, p_refresh_sw,
                    p_total_tag, p_reason_cd, p_province_cd, p_city_cd,
                    p_zip_cd, p_pack_policy_id, p_motor_no, p_serial_no,
                    p_settling_agent_cd, p_survey_agent_cd, p_tran_no,
                    p_contact_no, p_email_address, p_special_instructions,
                    p_def_processor, p_location_cd, p_block_id,
                    p_district_no, p_reported_by)
         WHEN MATCHED THEN
            UPDATE
               SET line_cd = p_line_cd, subline_cd = p_subline_cd,
                   issue_yy = p_issue_yy, pol_seq_no = p_pol_seq_no,
                   renew_no = p_renew_no, pol_iss_cd = p_pol_iss_cd,
                   clm_yy = p_clm_yy, clm_seq_no = p_clm_seq_no,
                   iss_cd = p_iss_cd, clm_control = p_clm_control,
                   clm_coop = p_clm_coop, assd_no = p_assd_no,
                   recovery_sw = p_recovery_sw,
                   clm_file_date = p_clm_file_date, loss_date = p_loss_date,
                   entry_date = p_entry_date, user_id = p_user_id,
                   last_update = SYSDATE, dsp_loss_date = p_dsp_loss_date,
                   clm_stat_cd = p_clm_stat_cd,
                   clm_setl_date = p_clm_setl_date,
                   loss_pd_amt = p_loss_pd_amt,
                   loss_res_amt = p_loss_res_amt, exp_pd_amt = p_exp_pd_amt,
                   loss_loc1 = p_loss_loc1, loss_loc2 = p_loss_loc2,
                   loss_loc3 = p_loss_loc3, in_hou_adj = p_in_hou_adj,
                   pol_eff_date = p_pol_eff_date, csr_no = p_csr_no,
                   loss_cat_cd = p_loss_cat_cd, intm_no = p_intm_no,
                   clm_amt = p_clm_amt, loss_dtls = p_loss_dtls,
                   obligee_no = p_obligee_no, exp_res_amt = p_exp_res_amt,
                   assured_name = p_assured_name, ri_cd = p_ri_cd,
                   plate_no = p_plate_no, cpi_rec_no = p_cpi_rec_no,
                   cpi_branch_cd = p_cpi_branch_cd,
                   clm_dist_tag = p_clm_dist_tag, assd_name2 = p_assd_name2,
                   old_stat_cd = p_old_stat_cd, close_date = p_close_date,
                   expiry_date = p_expiry_date, acct_of_cd = p_acct_of_cd,
                   max_endt_seq_no = p_max_endt_seq_no, remarks = p_remarks,
                   catastrophic_cd = p_catastrophic_cd,
                   cred_branch = p_cred_branch, net_pd_loss = p_net_pd_loss,
                   net_pd_exp = p_net_pd_exp, refresh_sw = p_refresh_sw,
                   total_tag = p_total_tag, reason_cd = p_reason_cd,
                   province_cd = p_province_cd, city_cd = p_city_cd,
                   zip_cd = p_zip_cd, pack_policy_id = p_pack_policy_id,
                   motor_no = p_motor_no, serial_no = p_serial_no,
                   settling_agent_cd = p_settling_agent_cd,
                   survey_agent_cd = p_survey_agent_cd, tran_no = p_tran_no,
                   contact_no = p_contact_no,
                   email_address = p_email_address,
                   special_instructions = p_special_instructions,
                   def_processor = p_def_processor,
                   location_cd = p_location_cd, block_id = p_block_id,
                   district_no = p_district_no, reported_by = p_reported_by
            ;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.24.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : pre-insert trigger in gicl_claims
    **/
   PROCEDURE pre_ins_gicl_claims (
      p_claim_id               IN OUT   gicl_claims.claim_id%TYPE,
      p_line_cd                         gicl_claims.line_cd%TYPE,
      p_subline_cd                      gicl_claims.subline_cd%TYPE,
      p_issue_yy                        gicl_claims.issue_yy%TYPE,
      p_pol_seq_no                      gicl_claims.pol_seq_no%TYPE,
      p_renew_no                        gicl_claims.renew_no%TYPE,
      p_pol_iss_cd                      gicl_claims.pol_iss_cd%TYPE,
      p_clm_yy                 IN OUT   gicl_claims.clm_yy%TYPE,
      p_clm_seq_no             IN OUT   gicl_claims.clm_seq_no%TYPE,
      p_iss_cd                 IN OUT   gicl_claims.iss_cd%TYPE,
      p_clm_control                     gicl_claims.clm_control%TYPE,
      p_clm_coop                        gicl_claims.clm_coop%TYPE,
      p_assd_no                         gicl_claims.assd_no%TYPE,
      p_recovery_sw                     gicl_claims.recovery_sw%TYPE,
      p_clm_file_date                   gicl_claims.clm_file_date%TYPE,
      p_loss_date                       gicl_claims.loss_date%TYPE,
      p_entry_date             IN OUT   gicl_claims.entry_date%TYPE,
      p_user_id                         gicl_claims.user_id%TYPE,
      p_last_update                     gicl_claims.last_update%TYPE,
      p_dsp_loss_date                   gicl_claims.dsp_loss_date%TYPE,
      p_clm_stat_cd            IN OUT   gicl_claims.clm_stat_cd%TYPE,
      p_clm_setl_date                   gicl_claims.clm_setl_date%TYPE,
      p_loss_pd_amt                     gicl_claims.loss_pd_amt%TYPE,
      p_loss_res_amt                    gicl_claims.loss_res_amt%TYPE,
      p_exp_pd_amt                      gicl_claims.exp_pd_amt%TYPE,
      p_loss_loc1                       gicl_claims.loss_loc1%TYPE,
      p_loss_loc2                       gicl_claims.loss_loc2%TYPE,
      p_loss_loc3                       gicl_claims.loss_loc3%TYPE,
      p_in_hou_adj             IN OUT   gicl_claims.in_hou_adj%TYPE,
      p_pol_eff_date                    gicl_claims.pol_eff_date%TYPE,
      p_csr_no                          gicl_claims.csr_no%TYPE,
      p_loss_cat_cd                     gicl_claims.loss_cat_cd%TYPE,
      p_intm_no                         gicl_claims.intm_no%TYPE,
      p_clm_amt                         gicl_claims.clm_amt%TYPE,
      p_loss_dtls                       gicl_claims.loss_dtls%TYPE,
      p_obligee_no                      gicl_claims.obligee_no%TYPE,
      p_exp_res_amt                     gicl_claims.exp_res_amt%TYPE,
      p_assured_name                    gicl_claims.assured_name%TYPE,
      p_ri_cd                           gicl_claims.ri_cd%TYPE,
      p_plate_no                        gicl_claims.plate_no%TYPE,
      p_cpi_rec_no                      gicl_claims.cpi_rec_no%TYPE,
      p_cpi_branch_cd                   gicl_claims.cpi_branch_cd%TYPE,
      p_clm_dist_tag                    gicl_claims.clm_dist_tag%TYPE,
      p_assd_name2                      gicl_claims.assd_name2%TYPE,
      p_old_stat_cd                     gicl_claims.old_stat_cd%TYPE,
      p_close_date                      gicl_claims.close_date%TYPE,
      p_expiry_date                     gicl_claims.expiry_date%TYPE,
      p_acct_of_cd                      gicl_claims.acct_of_cd%TYPE,
      p_max_endt_seq_no                 gicl_claims.max_endt_seq_no%TYPE,
      p_remarks                         gicl_claims.remarks%TYPE,
      p_catastrophic_cd                 gicl_claims.catastrophic_cd%TYPE,
      p_cred_branch            IN OUT   gicl_claims.cred_branch%TYPE,
      p_net_pd_loss                     gicl_claims.net_pd_loss%TYPE,
      p_net_pd_exp                      gicl_claims.net_pd_exp%TYPE,
      p_refresh_sw                      gicl_claims.refresh_sw%TYPE,
      p_total_tag                       gicl_claims.total_tag%TYPE,
      p_reason_cd                       gicl_claims.reason_cd%TYPE,
      p_province_cd                     gicl_claims.province_cd%TYPE,
      p_city_cd                         gicl_claims.city_cd%TYPE,
      p_zip_cd                          gicl_claims.zip_cd%TYPE,
      p_pack_policy_id                  gicl_claims.pack_policy_id%TYPE,
      p_motor_no                        gicl_claims.motor_no%TYPE,
      p_serial_no                       gicl_claims.serial_no%TYPE,
      p_settling_agent_cd      IN OUT   gicl_claims.settling_agent_cd%TYPE,
      p_survey_agent_cd        IN OUT   gicl_claims.survey_agent_cd%TYPE,
      p_tran_no                         gicl_claims.tran_no%TYPE,
      p_contact_no                      gicl_claims.contact_no%TYPE,
      p_email_address                   gicl_claims.email_address%TYPE,
      p_special_instructions            gicl_claims.special_instructions%TYPE,
      p_def_processor                   gicl_claims.def_processor%TYPE,
      p_location_cd                     gicl_claims.location_cd%TYPE,
      p_block_id                        gicl_claims.block_id%TYPE,
      p_district_no                     gicl_claims.district_no%TYPE,
      p_reported_by                     gicl_claims.reported_by%TYPE,
      p_nbt_clm_stat_cd                 VARCHAR2
   )
   IS
   BEGIN
      FOR cred IN (SELECT a.cred_branch branch, b.iss_name br_name
                     FROM gipi_polbasic a, giis_issource b
                    WHERE a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_pol_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND a.cred_branch = b.iss_cd)
      LOOP
         p_cred_branch := cred.branch;
      END LOOP;

      IF p_cred_branch IS NULL
      THEN
         p_cred_branch := p_pol_iss_cd;
      END IF;

      IF p_iss_cd IS NULL
      THEN
         IF p_pol_iss_cd = 'RI'
         THEN
            p_iss_cd := p_pol_iss_cd;
         ELSE
            IF giacp.v ('USE_BRANCH_CODE') = 'Y'
            THEN
               p_iss_cd := giacp.v ('BRANCH_CD');     --variable.v_branch_cd;
            ELSE
               IF giacp.v ('BRANCH_CD') = giisp.v ('ISS_CD_HO')
               THEN       --variable.v_branch_cd = variable.v_iss_cd_ho  THEN
                  FOR get_claim_cd IN
                     (SELECT NVL (claim_branch_cd, iss_cd) branch_cd
                        FROM giis_issource
                       WHERE iss_cd = NVL (p_cred_branch, p_pol_iss_cd))
                  LOOP
                     p_iss_cd := get_claim_cd.branch_cd;
                  END LOOP;
               ELSE
                  p_iss_cd := NVL (p_cred_branch, p_pol_iss_cd);
               END IF;
            END IF;
         END IF;
      END IF;

      IF p_clm_yy IS NULL
      THEN
         p_clm_yy := TO_NUMBER (TO_CHAR (SYSDATE, 'YY'));
      END IF;

      IF (p_clm_stat_cd IS NULL) OR (p_nbt_clm_stat_cd = 'N')
      THEN
         FOR clm IN (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'NOT OK')
         LOOP
            --variables.v_skip := 'Y';
            p_clm_stat_cd := clm.param_value_v;
            EXIT;
         END LOOP;
      END IF;

      /*SELECT claims_claim_id_s.NEXTVAL
        INTO p_claim_id
        FROM DUAL;*/
      IF p_entry_date IS NULL
      THEN
         p_entry_date := SYSDATE;
      END IF;

      IF p_in_hou_adj IS NULL
      THEN
         p_in_hou_adj := p_user_id;
      END IF;

      IF p_clm_seq_no IS NULL
      THEN
         gicl_claims_pkg.get_clm_seq_no (p_line_cd,
                                         p_subline_cd,
                                         p_iss_cd,
                                         p_clm_yy,
                                         p_clm_seq_no
                                        );
      END IF;

      IF p_line_cd = giisp.v ('MARINE CARGO LINE CODE')
      THEN
         get_settling_agent (p_line_cd,
                             p_subline_cd,
                             p_pol_iss_cd,
                             p_issue_yy,
                             p_pol_seq_no,
                             p_renew_no,
                             p_loss_date,
                             p_expiry_date,
                             p_settling_agent_cd
                            );
         get_survey_agent (p_line_cd,
                           p_subline_cd,
                           p_pol_iss_cd,
                           p_issue_yy,
                           p_pol_seq_no,
                           p_renew_no,
                           p_loss_date,
                           p_expiry_date,
                           p_survey_agent_cd
                          );
      END IF;

      gicl_claims_pkg.set_gicl_claims (p_claim_id,
                                       p_line_cd,
                                       p_subline_cd,
                                       p_issue_yy,
                                       p_pol_seq_no,
                                       p_renew_no,
                                       p_pol_iss_cd,
                                       p_clm_yy,
                                       p_clm_seq_no,
                                       p_iss_cd,
                                       p_clm_control,
                                       p_clm_coop,
                                       p_assd_no,
                                       p_recovery_sw,
                                       p_clm_file_date,
                                       p_loss_date,
                                       p_entry_date,
                                       p_user_id,
                                       p_last_update,
                                       p_dsp_loss_date,
                                       p_clm_stat_cd,
                                       p_clm_setl_date,
                                       p_loss_pd_amt,
                                       p_loss_res_amt,
                                       p_exp_pd_amt,
                                       p_loss_loc1,
                                       p_loss_loc2,
                                       p_loss_loc3,
                                       p_in_hou_adj,
                                       p_pol_eff_date,
                                       p_csr_no,
                                       p_loss_cat_cd,
                                       p_intm_no,
                                       p_clm_amt,
                                       p_loss_dtls,
                                       p_obligee_no,
                                       p_exp_res_amt,
                                       p_assured_name,
                                       p_ri_cd,
                                       p_plate_no,
                                       p_cpi_rec_no,
                                       p_cpi_branch_cd,
                                       p_clm_dist_tag,
                                       p_assd_name2,
                                       p_old_stat_cd,
                                       p_close_date,
                                       p_expiry_date,
                                       p_acct_of_cd,
                                       p_max_endt_seq_no,
                                       p_remarks,
                                       p_catastrophic_cd,
                                       p_cred_branch,
                                       p_net_pd_loss,
                                       p_net_pd_exp,
                                       p_refresh_sw,
                                       p_total_tag,
                                       p_reason_cd,
                                       p_province_cd,
                                       p_city_cd,
                                       p_zip_cd,
                                       p_pack_policy_id,
                                       p_motor_no,
                                       p_serial_no,
                                       p_settling_agent_cd,
                                       p_survey_agent_cd,
                                       p_tran_no,
                                       p_contact_no,
                                       p_email_address,
                                       p_special_instructions,
                                       p_def_processor,
                                       p_location_cd,
                                       p_block_id,
                                       p_district_no,
                                       p_reported_by
                                      );
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.26.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :
    **/
   PROCEDURE ins_clm_item_and_peril (
      p_line_cd        IN   gipi_polbasic.line_cd%TYPE,
      p_subline_cd     IN   gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd     IN   gipi_polbasic.iss_cd%TYPE,
      p_issue_yy       IN   gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no     IN   gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no       IN   gipi_polbasic.renew_no%TYPE,
      p_loss_date      IN   gicl_claims.dsp_loss_date%TYPE,
      p_expiry_date    IN   gipi_polbasic.expiry_date%TYPE,
      p_pol_eff_date   IN   gicl_claims.pol_eff_date%TYPE,
      p_loss_cat_cd    IN   gicl_claims.loss_cat_cd%TYPE,
      p_claim_id       IN   gicl_claims.claim_id%TYPE
   )
   IS
      v_itm         gipi_item.item_no%TYPE;
      v_prl         gipi_itmperil.peril_cd%TYPE;
      v_amt         gipi_itmperil.tsi_amt%TYPE;
      v_title       gicl_clm_item.item_title%TYPE;
      v_curr_cd     gicl_clm_item.currency_cd%TYPE;
      v_curr_rt     gicl_clm_item.currency_rate%TYPE;
      v_checkitem   BOOLEAN                            := FALSE;
   BEGIN
      IF p_line_cd = giisp.v ('LINE_CODE_SU')
      THEN
         FOR amt IN
            (SELECT SUM (c.tsi_amt) tsi
               FROM gipi_polbasic a,
                    (SELECT policy_id, item_no
                       FROM gipi_item) b,
                    gipi_itmperil c
              WHERE a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND a.policy_id = b.policy_id
                AND b.policy_id = c.policy_id
                AND b.item_no = c.item_no
                AND a.pol_flag IN ('1', '2', '3', 'X')
                AND TRUNC (DECODE (TRUNC (a.eff_date),
                                   TRUNC (a.incept_date), TRUNC
                                                               (p_pol_eff_date),
                                   TRUNC (a.eff_date)
                                  )
                          ) <= TRUNC (p_loss_date)
                AND TRUNC (DECODE (NVL (TRUNC (a.endt_expiry_date),
                                        TRUNC (a.expiry_date)
                                       ),
                                   TRUNC (a.expiry_date), TRUNC (p_expiry_date),
                                   TRUNC (a.endt_expiry_date)
                                  )
                          ) >= TRUNC (p_loss_date))
         LOOP
            v_amt := amt.tsi;
         END LOOP;

         FOR itm IN (SELECT b.item_no, c.peril_cd, b.currency_cd,
                            b.currency_rt, b.item_title
                       FROM gipi_polbasic a, gipi_item b, gipi_itmperil c
                      WHERE a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.iss_cd = p_pol_iss_cd
                        AND a.issue_yy = p_issue_yy
                        AND a.pol_seq_no = p_pol_seq_no
                        AND a.renew_no = p_renew_no
                        AND a.policy_id = b.policy_id
                        AND b.policy_id = c.policy_id
                        AND b.item_no = c.item_no
                        AND a.pol_flag IN ('1', '2', '3', 'X')
                        AND TRUNC (DECODE (TRUNC (a.eff_date),
                                           TRUNC (a.incept_date), TRUNC
                                                               (p_pol_eff_date),
                                           TRUNC (a.eff_date)
                                          )
                                  ) <= TRUNC (p_loss_date)
                        AND TRUNC (DECODE (NVL (TRUNC (a.endt_expiry_date),
                                                TRUNC (a.expiry_date)
                                               ),
                                           TRUNC (a.expiry_date), TRUNC
                                                                (p_expiry_date),
                                           TRUNC (a.endt_expiry_date)
                                          )
                                  ) >= TRUNC (p_loss_date))
         LOOP
            v_itm := itm.item_no;
            v_prl := itm.peril_cd;
            v_title := itm.item_title;
            v_curr_cd := itm.currency_cd;
            v_curr_rt := itm.currency_rt;
         END LOOP;

         -- JEN:04262011-will insert records only if claim has no item yet; to avoid ora-00001.
         FOR i IN (SELECT 1
                     FROM gicl_clm_item
                    WHERE claim_id = p_claim_id)
         LOOP
            v_checkitem := TRUE;
         END LOOP;

         IF NOT v_checkitem
         THEN
            INSERT INTO gicl_clm_item
                        (claim_id, item_no, item_title, loss_date,
                         currency_cd, currency_rate, user_id,
                         last_update, grouped_item_no
                        )
-- added grouped_item_no (not null in dbase) default to 0 if SU accrdng to mam beth - adrel
            VALUES      (p_claim_id, v_itm, v_title, p_loss_date,
                         v_curr_cd, v_curr_rt, giis_users_pkg.app_user,
                         SYSDATE, 0
                        );

            INSERT INTO gicl_item_peril
                        (claim_id, item_no, peril_cd, ann_tsi_amt,
                         loss_cat_cd, line_cd, close_flag, close_flag2,
                         user_id, last_update, grouped_item_no
                        )
-- added grouped_item_no (not null in dbase) default to 0 if SU accrdng to mam beth - adrel
-- added default value 'AP' for close_flag2, line SU - marco - 8.24.2012
            VALUES      (p_claim_id, v_itm, v_prl, v_amt,
                         p_loss_cat_cd, p_line_cd, 'AP', 'AP',
                         giis_users_pkg.app_user, SYSDATE, 0
                        );
         END IF;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 10.26.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     :  post-insert in :c003 block
    **/
   PROCEDURE post_ins_gicls010 (
      p_line_cd         IN       gipi_polbasic.line_cd%TYPE,
      p_subline_cd      IN       gipi_polbasic.subline_cd%TYPE,
      p_pol_iss_cd      IN       gipi_polbasic.iss_cd%TYPE,
      p_issue_yy        IN       gipi_polbasic.issue_yy%TYPE,
      p_pol_seq_no      IN       gipi_polbasic.pol_seq_no%TYPE,
      p_renew_no        IN       gipi_polbasic.renew_no%TYPE,
      p_claim_id        IN       gicl_claims.claim_id%TYPE,
      p_msg_alert       OUT      VARCHAR2,
      p_workflow_msgr   OUT      VARCHAR2
   )
   IS
      v_dist_param   giis_parameters.param_value_v%TYPE;
      v_exists       VARCHAR2 (1)                         := NULL;
      v_allow        VARCHAR2 (1);
      v_count        NUMBER;
   BEGIN
      IF p_renew_no IS NOT NULL
      THEN
         FOR rec IN (SELECT param_value_v
                       FROM giis_parameters
                      WHERE param_name = 'DISTRIBUTED')
         LOOP
            v_dist_param := rec.param_value_v;
            EXIT;
         END LOOP;

         BEGIN
            SELECT DISTINCT 'X'
                       INTO v_exists
                       FROM gipi_polbasic a, giuw_pol_dist b
                      WHERE a.line_cd = p_line_cd
                        AND a.subline_cd = p_subline_cd
                        AND a.iss_cd = p_pol_iss_cd
                        AND a.issue_yy = p_issue_yy
                        AND a.pol_seq_no = p_pol_seq_no
                        AND a.renew_no = p_renew_no
                        AND a.policy_id = b.policy_id
                        AND a.pol_flag IN ('1', '2', '3', 'X')
                        AND b.dist_flag NOT IN (v_dist_param, '5')
                        --AND b.dist_flag   <> v_dist_param
                        AND b.negate_date IS NULL
                        AND NOT EXISTS (
                               SELECT c.policy_id
                                 FROM gipi_endttext c
                                WHERE c.endt_tax = 'Y'
                                  AND c.policy_id = a.policy_id);

            IF v_exists = 'X'
            THEN
               FOR i IN (SELECT param_value_v
                           FROM giac_parameters
                          WHERE param_name LIKE 'ALLOW_CLM_FOR_UNDIST_POL')
               LOOP
                  v_allow := i.param_value_v;
                  EXIT;
               END LOOP;

               IF v_allow = 'Y'
               THEN
                  --added by A.R.C. 04.12.2005
                  FOR c1 IN (SELECT b.userid, d.event_desc
                               FROM giis_events_column c,
                                    giis_event_mod_users b,
                                    giis_event_modules a,
                                    giis_events d
                              WHERE 1 = 1
                                AND c.event_cd = a.event_cd
                                AND c.event_mod_cd = a.event_mod_cd
                                AND b.event_mod_cd = a.event_mod_cd
                                --AND b.userid <> USER  --A.R.C. 01.31.2006
                                AND b.passing_userid = USER
                                --A.R.C. 01.31.2006
                                AND a.module_id = 'GICLS010'
                                AND a.event_cd = d.event_cd
                                AND UPPER (d.event_desc) =
                                       'UNDISTRIBUTED POLICIES AWAITING CLAIMS')
                  LOOP
                     create_transfer_workflow_rec
                                   ('UNDISTRIBUTED POLICIES AWAITING CLAIMS',
                                    'GICLS010',
                                    c1.userid,
                                    p_claim_id,
                                       c1.event_desc
                                    || ' '
                                    || get_clm_no (p_claim_id),
                                    p_msg_alert,
                                    p_workflow_msgr,
                                    giis_users_pkg.app_user
                                   );
                  END LOOP;
               END IF;
            END IF;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               NULL;
         END;
      END IF;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 11.16.2011
    **  Reference By    : (GICLS010 - Claims Basic Information)
    **  Description     : for REFRESH button
    **/
   PROCEDURE refresh_claims (
      p_claim_id        gicl_claims.claim_id%TYPE,
      p_line_cd         gicl_claims.line_cd%TYPE,
      p_subline_cd      gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd      gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy        gicl_claims.issue_yy%TYPE,
      p_pol_seq_no      gicl_claims.pol_seq_no%TYPE,
      p_renew_no        gicl_claims.renew_no%TYPE,
      p_expiry_date     gicl_claims.expiry_date%TYPE,
      p_pol_eff_date    gicl_claims.pol_eff_date%TYPE,
      p_dsp_loss_date   gicl_claims.dsp_loss_date%TYPE
   )
   IS
      v_expiry_date          gipi_polbasic.expiry_date%TYPE;
      v_incept_date          gipi_polbasic.incept_date%TYPE;
      v_vessel_cd            gipi_cargo.vessel_cd%TYPE;
      v_pol_vessel           gipi_cargo.vessel_cd%TYPE;
      v_exist                VARCHAR2 (1)                             := 'N';
      v_ah_grouped_item_no   gicl_accident_dtl.grouped_item_no%TYPE;
      v_flag                 VARCHAR2 (1)                             := NULL;
   BEGIN
      FOR rec IN (SELECT max_endt_seq_no, line_cd, subline_cd, pol_iss_cd,
                         issue_yy, pol_seq_no, renew_no
                    FROM gicl_claims
                   WHERE claim_id = p_claim_id)
      LOOP
         DELETE FROM gicl_mortgagee
               WHERE claim_id = p_claim_id AND item_no = 0;

         insert_claim_mortgagee (0,
                                 p_claim_id,
                                 p_line_cd,
                                 p_subline_cd,
                                 p_pol_iss_cd,
                                 p_issue_yy,
                                 p_pol_seq_no,
                                 p_renew_no,
                                 p_dsp_loss_date,
                                 p_pol_eff_date,
                                 p_expiry_date
                                );
         -- Modified by Jess 03.05.2010 change :c003.iss_cd to :c003.pol_iss_cd
         v_expiry_date := p_expiry_date;
         v_incept_date := p_pol_eff_date;
         --modified by robert 12.11.2013 --retrieve correct incept and expiry date by MAC 10/09/2013
         extract_expiry_incept (v_expiry_date,
                                v_incept_date,
                                p_dsp_loss_date,
                                --NVL (rec.max_endt_seq_no, -1), removed by robert 12.11.2013
                                rec.line_cd,
                                rec.subline_cd,
                                rec.pol_iss_cd,
                                rec.issue_yy,
                                rec.pol_seq_no,
                                rec.renew_no--,removed by robert 12.11.2013
                                --p_claim_id removed by robert 12.11.2013
                               );
         extract_assured_acct_cd (v_incept_date,
                                  v_expiry_date,
                                  p_dsp_loss_date,
                                  NVL (rec.max_endt_seq_no, -1),
                                  rec.line_cd,
                                  rec.subline_cd,
                                  rec.pol_iss_cd,
                                  rec.issue_yy,
                                  rec.pol_seq_no,
                                  rec.renew_no,
                                  p_claim_id
                                 );

         FOR itm IN (SELECT DISTINCT (item_no) item_no
                                FROM gicl_clm_item
                               WHERE claim_id = p_claim_id)
         LOOP
            --jen.113005--
            DELETE FROM gicl_mortgagee
                  WHERE claim_id = p_claim_id AND item_no = itm.item_no;

            /* modified by Marlo
            ** 04222010
            ** added modifications made by mam jen to resolve error ora-00001
            ** change 0 to itm.item_no */
            insert_claim_mortgagee (itm.item_no,
                                    p_claim_id,
                                    p_line_cd,
                                    p_subline_cd,
                                    p_pol_iss_cd,
                                    p_issue_yy,
                                    p_pol_seq_no,
                                    p_renew_no,
                                    p_dsp_loss_date,
                                    p_pol_eff_date,
                                    p_expiry_date
                                   );

            -- Modified by Jess 03.05.2010 change :c003.iss_cd to :c003.pol_iss_cd

            --jen.113005--
            IF rec.line_cd = giisp.v ('LINE_CODE_MC')
            THEN
               extract_latest_mc_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_FI')
            THEN
               extract_latest_fi_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_AV')
            THEN
               extract_latest_av_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_MN')
            THEN
               extract_latest_mn_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );

               FOR ves IN (SELECT param_value_v
                             FROM giis_parameters
                            WHERE param_name = 'VESSEL_CD_MULTI')
               LOOP
                  v_vessel_cd := ves.param_value_v;
               END LOOP;

               FOR c IN (SELECT a.vessel_cd
                           FROM gipi_cargo a, gipi_item b, gipi_polbasic c
                          WHERE a.policy_id = b.policy_id
                            AND a.item_no = b.item_no
                            AND b.policy_id = c.policy_id
                            AND a.item_no = itm.item_no
                            AND c.line_cd = rec.line_cd
                            AND c.subline_cd = rec.subline_cd
                            AND c.iss_cd = rec.pol_iss_cd
                            AND c.issue_yy = rec.issue_yy
                            AND c.pol_seq_no = rec.pol_seq_no
                            AND c.renew_no = rec.renew_no)
               LOOP
                  v_pol_vessel := c.vessel_cd;
               END LOOP;

               IF v_pol_vessel = v_vessel_cd
               THEN
                  extract_latest_mn_multi (v_expiry_date,
                                           v_incept_date,
                                           p_dsp_loss_date,
                                           NVL (rec.max_endt_seq_no, -1),
                                           rec.line_cd,
                                           rec.subline_cd,
                                           rec.pol_iss_cd,
                                           rec.issue_yy,
                                           rec.pol_seq_no,
                                           rec.renew_no,
                                           p_claim_id,
                                           itm.item_no,
                                           v_pol_vessel
                                          );
               END IF;
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_MH')
            THEN
               extract_latest_mh_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_CA')
            THEN
               extract_latest_ca_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
               extract_latest_ca_prnl (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
               extract_latest_ca_benf (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );

               FOR grp IN (SELECT grouped_item_no
                             FROM gicl_casualty_dtl
                            WHERE claim_id = p_claim_id
                              AND item_no = itm.item_no)
               LOOP
                  IF     (grp.grouped_item_no != 0)
                     AND (grp.grouped_item_no IS NOT NULL)
                  THEN
                     extract_latest_ca_grouped (v_expiry_date,
                                                v_incept_date,
                                                p_dsp_loss_date,
                                                NVL (rec.max_endt_seq_no, -1),
                                                rec.line_cd,
                                                rec.subline_cd,
                                                rec.pol_iss_cd,
                                                rec.issue_yy,
                                                rec.pol_seq_no,
                                                rec.renew_no,
                                                p_claim_id,
                                                itm.item_no,
                                                grp.grouped_item_no
                                               );
                  END IF;
               END LOOP;
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_AC')
            THEN
               FOR grp IN (SELECT grouped_item_no
                             FROM gicl_accident_dtl
                            WHERE claim_id = p_claim_id
                              AND item_no = itm.item_no)
               LOOP
                  IF     (grp.grouped_item_no != 0)
                     AND (grp.grouped_item_no IS NOT NULL)
                  THEN
                     v_exist := 'Y';
                     v_ah_grouped_item_no := grp.grouped_item_no;
                  END IF;
               END LOOP;

               IF v_exist = 'N'
               THEN
                  extract_latest_ah_data (v_expiry_date,
                                          v_incept_date,
                                          p_dsp_loss_date,
                                          NVL (rec.max_endt_seq_no, -1),
                                          rec.line_cd,
                                          rec.subline_cd,
                                          rec.pol_iss_cd,
                                          rec.issue_yy,
                                          rec.pol_seq_no,
                                          rec.renew_no,
                                          p_claim_id,
                                          itm.item_no
                                         );
                  extract_latest_ah_ben (v_expiry_date,
                                         v_incept_date,
                                         p_dsp_loss_date,
                                         NVL (rec.max_endt_seq_no, -1),
                                         rec.line_cd,
                                         rec.subline_cd,
                                         rec.pol_iss_cd,
                                         rec.issue_yy,
                                         rec.pol_seq_no,
                                         rec.renew_no,
                                         p_claim_id,
                                         itm.item_no
                                        );
               ELSE
                  extract_latest_ah_grp (v_expiry_date,
                                         v_incept_date,
                                         p_dsp_loss_date,
                                         NVL (rec.max_endt_seq_no, -1),
                                         rec.line_cd,
                                         rec.subline_cd,
                                         rec.pol_iss_cd,
                                         rec.issue_yy,
                                         rec.pol_seq_no,
                                         rec.renew_no,
                                         p_claim_id,
                                         itm.item_no,
                                         v_ah_grouped_item_no
                                        );
                  extract_latest_ah_ben_grp (v_expiry_date,
                                             v_incept_date,
                                             p_dsp_loss_date,
                                             NVL (rec.max_endt_seq_no, -1),
                                             rec.line_cd,
                                             rec.subline_cd,
                                             rec.pol_iss_cd,
                                             rec.issue_yy,
                                             rec.pol_seq_no,
                                             rec.renew_no,
                                             p_claim_id,
                                             itm.item_no,
                                             v_ah_grouped_item_no
                                            );
               END IF;
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_EN')
            THEN
               extract_latest_en_data (v_expiry_date,
                                       v_incept_date,
                                       p_dsp_loss_date,
                                       NVL (rec.max_endt_seq_no, -1),
                                       rec.line_cd,
                                       rec.subline_cd,
                                       rec.pol_iss_cd,
                                       rec.issue_yy,
                                       rec.pol_seq_no,
                                       rec.renew_no,
                                       p_claim_id,
                                       itm.item_no
                                      );
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_MD')
            THEN
               NULL;
            ELSIF rec.line_cd = giisp.v ('LINE_CODE_SU')
            THEN
               NULL;
            ELSE
               extract_other_dtl (v_expiry_date,
                                  v_incept_date,
                                  p_dsp_loss_date,
                                  NVL (rec.max_endt_seq_no, -1),
                                  rec.line_cd,
                                  rec.subline_cd,
                                  rec.pol_iss_cd,
                                  rec.issue_yy,
                                  rec.pol_seq_no,
                                  rec.renew_no,
                                  p_claim_id,
                                  itm.item_no
                                 );
            END IF;

            FOR prl IN (SELECT peril_cd, grouped_item_no
                          FROM gicl_item_peril
                         WHERE claim_id = p_claim_id AND item_no = itm.item_no)
            LOOP
               IF prl.grouped_item_no = 0
               THEN
                  extract_latest_peril (v_expiry_date,
                                        v_incept_date,
                                        p_dsp_loss_date,
                                        NVL (rec.max_endt_seq_no, -1),
                                        rec.line_cd,
                                        rec.subline_cd,
                                        rec.pol_iss_cd,
                                        rec.issue_yy,
                                        rec.pol_seq_no,
                                        rec.renew_no,
                                        p_claim_id,
                                        itm.item_no,
                                        prl.peril_cd
                                       );
               ELSE
                  -- codes added by gmi 03/27/07
                  -- this handles additional updates of allow_tsi_amt, and no_of_days for GPA records
                  extract_latest_peril_grp (v_expiry_date,
                                            v_incept_date,
                                            p_dsp_loss_date,
                                            NVL (rec.max_endt_seq_no, -1),
                                            rec.line_cd,
                                            rec.subline_cd,
                                            rec.pol_iss_cd,
                                            rec.issue_yy,
                                            rec.pol_seq_no,
                                            rec.renew_no,
                                            p_claim_id,
                                            itm.item_no,
                                            prl.peril_cd,
                                            prl.grouped_item_no
                                           );
               END IF;
            END LOOP;
         END LOOP;

         FOR endt IN (SELECT MAX (endt_seq_no) endt_seq_no
                        FROM gipi_polbasic
                       WHERE line_cd = rec.line_cd
                         AND subline_cd = rec.subline_cd
                         AND iss_cd = rec.pol_iss_cd
                         AND issue_yy = rec.issue_yy
                         AND pol_seq_no = rec.pol_seq_no
                         AND renew_no = rec.renew_no
                         AND endt_seq_no > NVL (rec.max_endt_seq_no, -1)
                         AND pol_flag IN ('1', '2', '3', 'X'))
         LOOP
            UPDATE gicl_claims
               SET max_endt_seq_no = NVL (endt.endt_seq_no, max_endt_seq_no),
                   refresh_sw = 'N',
                   expiry_date = NVL (v_expiry_date, expiry_date),
                   pol_eff_date = NVL (v_incept_date, pol_eff_date)
             WHERE claim_id = p_claim_id;

            EXIT;
         END LOOP;
      END LOOP;
   END;

   FUNCTION get_loss_cat_tag_listing (
      p_claim_no          VARCHAR2,
      p_policy_no         VARCHAR2,
      p_loss_cat          VARCHAR2,
      p_claim_stat_desc   VARCHAR2,
      p_claim_processor   gicl_claims.in_hou_adj%TYPE,
      p_line_cd           gicl_claims.line_cd%TYPE,
      p_dsp_loss_date     VARCHAR2,
      p_assured_name      gicl_claims.assured_name%TYPE,
      p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
      p_renew_no          gicl_claims.renew_no%TYPE,
      p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
      p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
      p_clm_yy            gicl_claims.clm_yy%TYPE,
      p_iss_cd            gicl_claims.iss_cd%TYPE,
      p_subline_cd        gicl_claims.subline_cd%TYPE,
      p_user_id           gicl_claims.user_id%TYPE
   )
      RETURN loss_cat_tag_tab PIPELINED
   IS
      v_claims    loss_cat_tag_type;
      dist_sw     VARCHAR2 (1);
      entry_tag   VARCHAR2 (1);
      stat_sw     VARCHAR2 (1);
      v_chk       VARCHAR (1);
   BEGIN
      FOR i IN
         (SELECT   a.*
              FROM (SELECT a.claim_id, a.line_cd, a.subline_cd, a.iss_cd,
                           a.clm_yy, a.clm_seq_no, a.pol_iss_cd, a.pol_seq_no,
                           a.renew_no, a.issue_yy,
                              a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.clm_yy, '09'))
                           || '-'
                           || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no,
                              a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.pol_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.issue_yy, '09')) -- andrew - 02.13.2012 - changed from clm_yy to issue_yy
                           || '-'
                           || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                           || '-'
                           || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                           a.dsp_loss_date, a.loss_cat_cd, a.loss_date,
                           a.assured_name, a.in_hou_adj, a.recovery_sw,
                           a.clm_stat_cd,
                           (SELECT clm_stat_desc
                              FROM giis_clm_stat
                             WHERE clm_stat_cd = a.clm_stat_cd) clm_stat_desc,
                           (SELECT loss_cat_des
                              FROM giis_loss_ctgry
                             WHERE line_cd = p_line_cd
                               AND loss_cat_cd = a.loss_cat_cd) loss_cat_des
                      FROM gicl_claims a) a
             WHERE UPPER (a.line_cd) LIKE UPPER (p_line_cd)
               AND    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.iss_cd
                   || '-'
                   || TO_CHAR (a.clm_yy, '09')
                   || '-'
                   || TO_CHAR (a.clm_seq_no, '0999999') LIKE
                      NVL (p_claim_no,
                              a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.iss_cd
                           || '-'
                           || TO_CHAR (a.clm_yy, '09')
                           || '-'
                           || TO_CHAR (a.clm_seq_no, '0999999')
                          )
               AND    a.line_cd
                   || '-'
                   || a.subline_cd
                   || '-'
                   || a.pol_iss_cd
                   || '-'
                   || LTRIM (TO_CHAR (a.issue_yy, '09')) -- andrew - 02.13.2012 - changed from clm_yy to issue_yy
                   || '-'
                   || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                   || '-'
                   || LTRIM (TO_CHAR (renew_no, '09')) LIKE
                      NVL (p_policy_no,
                              a.line_cd
                           || '-'
                           || a.subline_cd
                           || '-'
                           || a.pol_iss_cd
                           || '-'
                           || LTRIM (TO_CHAR (a.issue_yy, '09')) -- andrew - 02.13.2012 - changed from clm_yy to issue_yy
                           || '-'
                           || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                           || '-'
                           || LTRIM (TO_CHAR (renew_no, '09'))
                          )
               AND UPPER (a.clm_stat_desc) LIKE
                              UPPER (NVL (p_claim_stat_desc, a.clm_stat_desc))
               AND UPPER (NVL (a.assured_name, '*')) LIKE
                      UPPER (NVL (p_assured_name,
                                  DECODE (a.assured_name,
                                          NULL, '*',
                                          a.assured_name
                                         )
                                 )
                            )
               AND TRUNC (a.dsp_loss_date) =
                      TRUNC (NVL (TO_DATE (p_dsp_loss_date, 'MM-DD-YYYY'),
                                  a.dsp_loss_date
                                 )
                            )
               AND UPPER (a.loss_cat_des) LIKE
                                      UPPER (NVL (p_loss_cat, a.loss_cat_des))
               AND a.clm_seq_no LIKE NVL (p_clm_seq_no, a.clm_seq_no)
               AND a.renew_no LIKE NVL (p_renew_no, a.renew_no)
               AND a.pol_seq_no LIKE NVL (p_pol_seq_no, a.pol_seq_no)
               AND a.pol_iss_cd LIKE NVL (p_pol_iss_cd, a.pol_iss_cd)
               AND a.clm_yy LIKE NVL (p_clm_yy, a.clm_yy)
               AND UPPER (a.iss_cd) LIKE UPPER (NVL (p_iss_cd, a.iss_cd))
               AND a.subline_cd LIKE UPPER (NVL (p_subline_cd, a.subline_cd))
          --filters ends here
-- remove because of block c003 KEY-ENTQRY trigger that sets the where clause to blank 18.01.2012 - irwin
               AND a.iss_cd = DECODE(CHECK_USER_PER_ISS_CD2(UPPER(a.line_cd), a.iss_cd, 'GICLS053', p_user_id), 1, a.iss_cd, NULL)
               -- marco - 01.23.2012 - added CHECK_USER_PER_ISS_CD2
               AND a.claim_id NOT IN (SELECT b.claim_id
                                        FROM gicl_clm_recovery_dtl b)
               AND a.claim_id IN (
                      SELECT c.claim_id
                        FROM gicl_clm_res_hist c, gicl_item_peril d
                       WHERE c.dist_sw = 'Y'
                         AND c.claim_id = d.claim_id
                         AND c.item_no = d.item_no
                         AND c.peril_cd = d.peril_cd
                         AND (  DECODE (NVL (close_flag, 'AP'),
                                        'AP', NVL (loss_reserve, 0),
                                        'CP', NVL (loss_reserve, 0),
                                        'CC', NVL (loss_reserve, 0),
                                        0
                                       )
                              + DECODE (NVL (close_flag2, 'AP'),
                                        'AP', NVL (expense_reserve, 0),
                                        'CP', NVL (expense_reserve, 0),
                                        'CC', NVL (expense_reserve, 0),
                                        0
                                       ) > 0
                             ))
          ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.clm_yy, a.clm_seq_no)
      LOOP
         dist_sw := NULL;
         entry_tag := NULL;
         stat_sw := NULL;
         v_chk := NULL;

         FOR chk IN (SELECT 'Y' yes
                       FROM gicl_clm_recovery
                      WHERE claim_id = i.claim_id)
         LOOP
            v_chk := chk.yes;
         END LOOP;

         FOR chk IN (SELECT dist_sw dist, entry_tag etag, stat_sw stat
                       FROM gicl_recovery_payt
                      WHERE claim_id = i.claim_id)
         LOOP
            dist_sw := chk.dist;
            entry_tag := chk.etag;
            stat_sw := chk.stat;
         END LOOP;

         v_claims.dist_sw := NVL (dist_sw, 'N');
         v_claims.entry_tag := NVL (entry_tag, 'N');
         v_claims.stat_sw := NVL (stat_sw, 'N');
         v_claims.claim_id := i.claim_id;
         v_claims.claim_no := i.claim_no;
         v_claims.policy_no := i.policy_no;
         v_claims.clm_stat_cd := i.clm_stat_cd;
         v_claims.claim_stat_desc := i.clm_stat_desc;
         v_claims.dsp_loss_date := TO_CHAR (i.dsp_loss_date, 'MM-DD-YYYY');
         v_claims.loss_cat_cd := i.loss_cat_cd;
         v_claims.loss_date :=
                   TO_DATE (TO_CHAR (i.loss_date, 'MM-DD-YYYY'), 'MM-DD-YYYY');
         v_claims.loss_cat_des := i.loss_cat_des;
         v_claims.assured_name := i.assured_name;
         v_claims.in_house_adjustment := i.in_hou_adj;
         v_claims.recovery_sw := i.recovery_sw;
         v_claims.recovery_exist := NVL (v_chk, 'N');
         v_claims.line_cd := i.line_cd;
         v_claims.subline_cd := i.subline_cd;
         v_claims.iss_cd := i.iss_cd;
         v_claims.clm_yy := i.clm_yy;
         v_claims.clm_seq_no := i.clm_seq_no;
         v_claims.pol_iss_cd := i.pol_iss_cd;
         v_claims.pol_seq_no := i.pol_seq_no;
         v_claims.renew_no := i.renew_no;
         PIPE ROW (v_claims);
      END LOOP;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 12.02.2011
    **  Reference By    : (GICLS250 - Claim Listing Per Policy)
    **  Description     :
    **/
   FUNCTION get_claims_per_policy (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE,
      p_module       VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN gicl_claims_tab PIPELINED
   IS
      v_list   gicl_claims_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, a.subline_cd, a.pol_iss_cd,
                                a.iss_cd, a.issue_yy, a.pol_seq_no,
                                a.renew_no, a.assd_no, a.assured_name
                           FROM gicl_claims a
                          --WHERE a.line_cd = NVL (p_line_cd, a.line_cd)
                          WHERE a.line_cd = p_line_cd
                            --AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                            AND a.subline_cd = p_subline_cd
                            AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd) --change by steven 11.16.2012 from: iss_cd     to: pol_iss_cd
                            AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                            AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                            AND a.renew_no = NVL (p_renew_no, a.renew_no)
                            AND check_user_per_line2 (line_cd, pol_iss_cd,  --change by steven 11.16.2012 from:iss_cd     to:pol_iss_cd
                                                     p_module, p_user_id) = 1) -- changed check_user_per_line to check_user_per_line2, pol cruz
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.assd_no := i.assd_no;
         v_list.assured_name := i.assured_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**
     **  Created by      : Niknok Orio
     **  Date Created    : 12.02.2011
     **  Reference By    : (GICLS250 - Claim Listing Per Policy)
     **  Description     : main
     **/
   FUNCTION get_claims_per_policy2 (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd   gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   gicl_claims.pol_seq_no%TYPE,
      p_renew_no     gicl_claims.renew_no%TYPE,
      p_module       VARCHAR2,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN gicl_claims_tab PIPELINED
   IS
      v_list     gicl_claims_type;
      v_count    NUMBER           := 0;
      v_count1   NUMBER           := 0;
   BEGIN
      FOR i IN (SELECT   a.line_cd, a.subline_cd, a.pol_iss_cd, a.iss_cd,
                         a.issue_yy, a.pol_seq_no, a.renew_no, a.assd_no,
                         a.assured_name, a.clm_yy, a.clm_seq_no,
                         NVL (a.loss_res_amt, 0) loss_res_amt,
                         NVL (a.loss_pd_amt, 0) loss_pd_amt,
                         NVL (a.exp_res_amt, 0) exp_res_amt,
                         NVL (a.exp_pd_amt, 0) exp_pd_amt, a.clm_stat_cd,
                         a.claim_id, TRUNC (a.entry_date) entry_date,
                         TRUNC (a.dsp_loss_date) dsp_loss_date,
                         TRUNC (a.clm_file_date) clm_file_date
                    FROM gicl_claims a
                   WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.pol_iss_cd = p_pol_iss_cd --change by steven 11.16.2012 from: iss_cd     to: pol_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND check_user_per_line2 (line_cd, pol_iss_cd, p_module, p_user_id) = 1  --change by steven 11.16.2012 from:iss_cd     to:pol_iss_cd
                ORDER BY a.clm_seq_no)
      LOOP
         v_list.line_cd := i.line_cd;
         v_list.subline_cd := i.subline_cd;
         v_list.pol_iss_cd := i.pol_iss_cd;
         v_list.iss_cd := i.iss_cd;
         v_list.issue_yy := i.issue_yy;
         v_list.pol_seq_no := i.pol_seq_no;
         v_list.renew_no := i.renew_no;
         v_list.assd_no := i.assd_no;
         v_list.assured_name := i.assured_name;
         v_list.clm_yy := i.clm_yy;
         v_list.clm_seq_no := i.clm_seq_no;
         v_list.loss_res_amt := i.loss_res_amt;
         v_list.loss_pd_amt := i.loss_pd_amt;
         v_list.exp_res_amt := i.exp_res_amt;
         v_list.exp_pd_amt := i.exp_pd_amt;
         v_list.claim_id := i.claim_id;
         v_list.entry_date := i.entry_date;
         v_list.dsp_loss_date := i.dsp_loss_date;
         v_list.clm_file_date := i.clm_file_date;
         v_list.clm_stat_desc := '';
         v_list.plate_no := '';
         v_list.serial_no := '';

         FOR clm_desc IN (SELECT clm_stat_desc
                            FROM giis_clm_stat
                           WHERE clm_stat_cd = i.clm_stat_cd)
         LOOP
            v_list.clm_stat_desc := clm_desc.clm_stat_desc;
            EXIT;
         END LOOP;

         FOR rec IN (SELECT plate_no, serial_no
                       FROM gicl_motor_car_dtl
                      WHERE claim_id = i.claim_id)
         LOOP
            v_list.plate_no := rec.plate_no;
            v_list.serial_no := rec.serial_no;
         END LOOP;

         BEGIN
            SELECT COUNT (*)
              INTO v_count
              FROM gicl_claims a, gicl_clm_recovery b
             WHERE b.claim_id = a.claim_id
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.pol_iss_cd = p_pol_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no;

            IF v_count <> 0
            THEN
               v_list.gicl_clm_item_exist := 'Y';
            ELSE
               v_list.gicl_clm_item_exist := 'N';
            END IF;
         END;

         BEGIN
            SELECT COUNT (*)
              INTO v_count1
              FROM gicl_clm_recovery
             WHERE claim_id = i.claim_id;

            IF v_count1 <> 0
            THEN
               v_list.gicl_clm_reserve_exist := 'Y';
            ELSE
               v_list.gicl_clm_reserve_exist := 'N';
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   PROCEDURE update_loss_tag_recovery (
      p_claim_id      gicl_claims.claim_id%TYPE,
      p_recovery_sw   gicl_claims.recovery_sw%TYPE
   )
   IS
   BEGIN
      UPDATE gicl_claims
         SET recovery_sw = p_recovery_sw
       WHERE claim_id = p_claim_id;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 12.09.2011
    **  Reference By    : (GICLS250 - Claims Listing Per Policy)
    **  Description     : get line code LOV
    **/
   FUNCTION get_clm_line_list (p_module_id giis_modules.module_id%TYPE)
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, b.line_name
                           FROM gicl_claims a, giis_line b
                          WHERE a.line_cd = b.line_cd
                            AND check_user_per_line (a.line_cd,
                                                     a.iss_cd,
                                                     p_module_id
                                                    ) = 1
                       ORDER BY 1)
      LOOP
         v_list.code := i.line_cd;
         v_list.code_desc := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**Created by pol, used check_user_per_line2*
   *  5.15.2013
   */

    FUNCTION get_clm_line_list2 (
        p_module_id   GIIS_MODULES.module_id%TYPE,
        p_user_id     GIIS_USERS.user_id%TYPE
   )
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.line_cd, b.line_name
                           FROM gicl_claims a, giis_line b
                          WHERE a.line_cd = b.line_cd
                            AND EXISTS (SELECT 'X' FROM TABLE (security_access.get_branch_line ('CL',p_module_id ,p_user_id ))
                                                                WHERE LINE_CD= a.line_cd and BRANCH_CD = a.iss_cd) --Added by MarkS SR5832 11.9.2016 optimization
                            --AND check_user_per_line2 (a.line_cd, a.iss_cd, p_module_id, p_user_id) = 1 --commented out by MarkS SR5832 11.9.2016 optimization
                       ORDER BY 1)
      LOOP
         v_list.code := i.line_cd;
         v_list.code_desc := i.line_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_line_list2;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 12.09.2011
    **  Reference By    : (GICLS250 - Claims Listing Per Policy)
    **  Description     : get subline code LOV
    **/
   FUNCTION get_clm_subline_list (p_line_cd gicl_claims.line_cd%TYPE)
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.subline_cd, b.subline_name
                           FROM gicl_claims a, giis_subline b
                          WHERE a.line_cd = b.line_cd
                            AND a.subline_cd = b.subline_cd
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                       GROUP BY a.subline_cd, b.subline_name
                       ORDER BY 1)
      LOOP
         v_list.code := i.subline_cd;
         v_list.code_desc := i.subline_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 12.09.2011
    **  Reference By    : (GICLS250 - Claims Listing Per Policy)
    **  Description     : get issue code LOV
    **/
   FUNCTION get_clm_iss_list (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, b.iss_name
                           FROM gicl_claims a, giis_issource b
                          WHERE a.iss_cd = b.iss_cd
                            AND a.subline_cd =
                                              NVL (p_subline_cd, a.subline_cd)
                            AND a.line_cd = NVL (p_line_cd, a.line_cd)
                            AND a.iss_cd =
                                   DECODE (check_user_per_iss_cd (p_line_cd,
                                                                  a.iss_cd,
                                                                  'GICLS250'
                                                                 ),
                                           1, a.iss_cd,
                                           NULL
                                          )
                       GROUP BY a.iss_cd, b.iss_name
                       ORDER BY 1)
      LOOP
         v_list.code := i.iss_cd;
         v_list.code_desc := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*added by : pol, used check_user_per_iss_cd2
     5.15.2013
   */

   FUNCTION get_clm_iss_list2 (
        p_line_cd       gicl_claims.line_cd%TYPE,
        p_subline_cd    gicl_claims.subline_cd%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
   )
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT a.iss_cd, b.iss_name
                           FROM gicl_claims a, giis_issource b
                          WHERE a.iss_cd = b.iss_cd
                            --AND a.subline_cd = NVL (p_subline_cd, a.subline_cd)
                            --AND a.line_cd = NVL (p_line_cd, a.line_cd)
                            --AND a.iss_cd = DECODE (check_user_per_iss_cd2 (a.line_cd, a.iss_cd, p_module_id, p_user_id), 1, a.iss_cd, NULL)
                       GROUP BY a.iss_cd, b.iss_name
                       ORDER BY 1)
      LOOP
         v_list.code := i.iss_cd;
         v_list.code_desc := i.iss_name;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_clm_iss_list2;

   /**
    **  Created by      : Niknok Orio
    **  Date Created    : 12.09.2011
    **  Reference By    : (GICLS250 - Claims Listing Per Policy)
    **  Description     : get issue year LOV
    **/
   FUNCTION get_clm_issue_yy_list (
      p_line_cd      gicl_claims.line_cd%TYPE,
      p_subline_cd   gicl_claims.subline_cd%TYPE
   )
      RETURN lov_listing_tab PIPELINED
   IS
      v_list   lov_listing_type;
   BEGIN
      FOR i IN (SELECT DISTINCT issue_yy
                           FROM gicl_claims
                          WHERE line_cd = p_line_cd
                            AND subline_cd = p_subline_cd
                       ORDER BY 1)
      LOOP
         v_list.code := i.issue_yy;
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;

   /*
   **  Created by      : Robert Virrey
   **  Date Created    : 12.13.2011
   **  Reference By    : (GICLS026 - No Claim Listing)
   **  Description     :  check_claims program unit
   */
   PROCEDURE check_claims_gicls026 (
      p_line_cd      IN       gicl_claims.line_cd%TYPE,
      p_subline_cd   IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd       IN       gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy     IN       gicl_claims.issue_yy%TYPE,
      p_pol_seq_no   IN       gicl_claims.pol_seq_no%TYPE,
      p_renew_no     IN       gicl_claims.renew_no%TYPE,
      p_msg          OUT      VARCHAR2
   )
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      SELECT DISTINCT 'x'
                 INTO v_exist
                 FROM gicl_claims
                WHERE line_cd = p_line_cd
                  AND subline_cd = p_subline_cd
                  AND pol_iss_cd = p_iss_cd
                  AND issue_yy = p_issue_yy
                  AND pol_seq_no = p_pol_seq_no
                  AND renew_no = p_renew_no;

      IF v_exist IS NOT NULL
      THEN
         p_msg := 'POLICY_EXIST';
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         p_msg := 'GET_DETAILS';
   END;

   /*
   **  Created by      : Robert Virrey
   **  Date Created    : 12.15.2011
   **  Reference By    : (GICLS026 - No Claim Listing)
   **  Description     :  check_item program unit
   */
   PROCEDURE check_item_gicls026 (
      p_line_cd        IN       gicl_claims.line_cd%TYPE,
      p_subline_cd     IN       gicl_claims.subline_cd%TYPE,
      p_iss_cd         IN       gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy       IN       gicl_claims.issue_yy%TYPE,
      p_pol_seq_no     IN       gicl_claims.pol_seq_no%TYPE,
      p_renew_no       IN       gicl_claims.renew_no%TYPE,
      p_item_no        IN       gicl_clm_item.item_no%TYPE,
      p_nc_loss_date   IN       gicl_clm_item.loss_date%TYPE,
      p_msg            OUT      VARCHAR2
   )
   IS
      v_exist      VARCHAR2 (1);
      v_clm_stat   VARCHAR2 (50);
      v_claim_no   VARCHAR2 (30);
   BEGIN
      BEGIN
         SELECT    a.line_cd
                || '-'
                || a.subline_cd
                || '-'
                || a.iss_cd
                || '-'
                || LTRIM (TO_CHAR (a.clm_yy, '09'))
                || '-'
                || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')),
                b.clm_stat_desc
           INTO v_claim_no,
                v_clm_stat
           FROM gicl_claims a, giis_clm_stat b
          WHERE a.clm_stat_cd = b.clm_stat_cd
            AND a.claim_id IN (
                   SELECT c.claim_id
                     FROM gipi_polbasic a, gicl_claims b, gicl_clm_item c
                    WHERE a.line_cd = b.line_cd
                      AND a.subline_cd = b.subline_cd
                      AND a.iss_cd = b.pol_iss_cd
                      AND a.issue_yy = b.issue_yy
                      AND a.pol_seq_no = b.pol_seq_no
                      AND a.renew_no = b.renew_no
                      AND b.claim_id = c.claim_id
                      AND a.line_cd = p_line_cd
                      AND a.subline_cd = p_subline_cd
                      AND a.iss_cd = p_iss_cd
                      AND a.issue_yy = p_issue_yy
                      AND a.pol_seq_no = p_pol_seq_no
                      AND a.renew_no = p_renew_no
                      AND c.item_no = p_item_no
                      AND c.loss_date = p_nc_loss_date);
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            NULL;
      END;

      BEGIN
         SELECT DISTINCT 'x'
                    INTO v_exist
                    FROM gicl_claims a, gicl_clm_item b
                   WHERE a.line_cd = p_line_cd
                     AND a.subline_cd = p_subline_cd
                     AND a.pol_iss_cd = p_iss_cd
                     AND a.issue_yy = p_issue_yy
                     AND a.pol_seq_no = p_pol_seq_no
                     AND a.renew_no = p_renew_no
                     AND b.item_no = p_item_no
                     AND b.loss_date = p_nc_loss_date
                     AND a.clm_stat_cd NOT IN ('DN', 'WD', 'CC')
                     AND a.claim_id = b.claim_id;    -- added by Pia, 11.18.03

         IF v_exist IS NOT NULL
         THEN
            p_msg :=
                  'A claim for this particular policy and event that occurred '
               || 'had already been filed. (Status: '
               || v_clm_stat
               || ' with Claim No. '
               || v_claim_no
               || ')';
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_msg := 'amount enterable';
      --set_item_property('c038.amount',enterable,property_true);
      END;
   END;

    /*
    **  Created by   :  Jerome Orio
    **  Date Created :  05.09.2012
    **  Reference By :  GICLS010 - Basic Information
    **  Description  :  getting recovery amounts
    */
    PROCEDURE get_recovery_amount(
        p_claim_id                  IN    gicl_claims.claim_id%TYPE,
        p_recoverable_amt        IN OUT gicl_clm_recovery.recoverable_amt%TYPE,
        p_recovered_amt          IN OUT gicl_clm_recovery.recovered_amt%TYPE
        ) IS
    BEGIN
      FOR i IN (SELECT recoverable_amt, recovered_amt
                    FROM GICL_CLM_RECOVERY a
                   where claim_id = p_claim_id
                     and recoverable_amt > 0
                     and exists (select 1
                                   from gicl_rec_hist b
                                  where b.recovery_id = a.recovery_id
                                    and rec_hist_no = (select max(rec_hist_no)
                                                       from gicl_rec_hist c
                                                      where c.recovery_id = b.recovery_id)
                                    and rec_stat_cd not in ('CC','WO')))
      LOOP
        p_recoverable_amt := nvl(p_recoverable_amt,0)+i.recoverable_amt;
        p_recovered_amt := nvl(p_recovered_amt,0)+i.recovered_amt;
      END LOOP;
    END;

    PROCEDURE CHECK_CLAIM_REQ_DOCS(
        P_CLAIM_ID in gicl_claims.claim_id%TYPE,
        p_has_docs out varchar2,
        p_has_completed_dates out varchar2
    )

    is
        v_doc_cmpltd_dt    gicl_reqd_docs.doc_cmpltd_dt%TYPE;
    begin
        begin
         SELECT DISTINCT 'Y'
                          INTO p_has_docs
                          FROM gicl_reqd_docs
                         WHERE claim_id = p_claim_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                   p_has_docs:= 'N';
            end;
            p_has_completed_dates := 'Y';
        begin
             FOR b IN (SELECT doc_cmpltd_dt
                        FROM gicl_reqd_docs
                       WHERE claim_id = p_claim_id)
            LOOP
               v_doc_cmpltd_dt := b.doc_cmpltd_dt;

                if v_doc_cmpltd_dt is null then
                    p_has_completed_dates := 'N';
                    exit;
                end if;

        end loop;

        end;

    end;

    FUNCTION get_related_claims2 (p_claim_id gicl_claims.claim_id%TYPE)
       RETURN gicl_claims_tab PIPELINED
    IS
       v_claims   gicl_claims_type;
    BEGIN
       FOR i IN (SELECT    a.line_cd
                        || '-'
                        || subline_cd
                        || '-'
                        || iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (clm_yy, '00'))
                        || '-'
                        || LTRIM (TO_CHAR (clm_seq_no, '0000009')) claim_no,
                           a.line_cd
                        || '-'
                        || subline_cd
                        || '-'
                        || pol_iss_cd
                        || '-'
                        || LTRIM (TO_CHAR (issue_yy, '00'))
                        || '-'
                        || LTRIM (TO_CHAR (pol_seq_no, '0000009'))
                        || '-'
                        || LTRIM (TO_CHAR (renew_no, '00')) policy_no,
                        a.line_cd, a.dsp_loss_date, a.loss_date, assured_name,
                        b.loss_cat_cd || '-' || b.loss_cat_des loss_ctgry, a.subline_cd,
                        a.pol_iss_cd, a.issue_yy, a.pol_seq_no, a.renew_no,
                        a.claim_id, a.iss_cd, a.pol_eff_date, a.expiry_date,
                        a.clm_file_date, c.clm_stat_desc, a.catastrophic_cd,
                        a.clm_yy
                   FROM gicl_claims a, giis_loss_ctgry b, giis_clm_stat c
                  WHERE a.loss_cat_cd = b.loss_cat_cd
                    AND a.line_cd = b.line_cd
                    AND a.claim_id = p_claim_id
                    AND c.clm_stat_cd = a.clm_stat_cd)
       LOOP
          v_claims.claim_no         := i.claim_no;
          v_claims.policy_no        := i.policy_no;
          v_claims.line_cd          := i.line_cd;
          v_claims.dsp_loss_date    := i.dsp_loss_date;
          v_claims.loss_date        := i.loss_date;
          v_claims.assured_name     := i.assured_name;
          v_claims.loss_ctgry       := i.loss_ctgry;
          v_claims.subline_cd       := i.subline_cd;
          v_claims.pol_iss_cd       := i.pol_iss_cd;
          v_claims.issue_yy         := i.issue_yy;
          v_claims.pol_seq_no       := i.pol_seq_no;
          v_claims.renew_no         := i.renew_no;
          v_claims.claim_id         := i.claim_id;
          v_claims.iss_cd           := i.iss_cd;
          v_claims.pol_eff_date     := i.pol_eff_date;
          v_claims.expiry_date      := i.expiry_date;
          v_claims.clm_file_date    := i.clm_file_date;
          v_claims.clm_stat_desc    := i.clm_stat_desc;
          v_claims.catastrophic_cd  := i.catastrophic_cd;
          v_claims.clm_yy           := i.clm_yy;

          IF v_claims.expiry_date IS NULL
          THEN
             v_claims.expiry_date := extract_expiry2(v_claims.line_cd, v_claims.subline_cd,
                            v_claims.iss_cd, v_claims.issue_yy, v_claims.pol_seq_no, v_claims.renew_no);
          END IF;

          PIPE ROW (v_claims);
       END LOOP;
    END get_related_claims2;

   FUNCTION get_claim_closing_listing(
       p_clm_line_cd       gicl_claims.line_cd%TYPE,
       p_clm_subline_cd    gicl_claims.subline_cd%TYPE,
       p_clm_iss_cd        gicl_claims.iss_cd%TYPE,
       p_clm_yy            gicl_claims.clm_yy%TYPE,
       p_clm_seq_no        gicl_claims.clm_seq_no%TYPE,
       p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
       p_pol_issue_yy      gicl_claims.issue_yy%TYPE,
       p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
       p_pol_renew_no      gicl_claims.renew_no%TYPE,
       p_assd_no           gicl_claims.assd_no%TYPE, 
       p_search_by         NUMBER,
       p_as_of_date        VARCHAR2,
       p_from_date         VARCHAR2,
       p_to_date           VARCHAR2,          
       p_status_control    VARCHAR2
       )
       RETURN gicl_claim_closing_tab PIPELINED
   IS
          v_claims                gicl_claim_closing_type;
       v_record                gicl_claims%ROWTYPE;
       v_cancelled_status      gicl_claims.clm_stat_cd%type;
       v_denied_status         gicl_claims.clm_stat_cd%type;
       v_closed_status         gicl_claims.clm_stat_cd%type;
       v_withdrawn_status      gicl_claims.clm_stat_cd%type;
       v_stmt_str              VARCHAR2 (2000);
       v_clm_setld             VARCHAR2 (1) := 'Y'; --true
       --v_advice_exist          NUMBER;              --VARCHAR2 (1) := 'N';

       --CHK_CLAIM_CLOSING
       v_item_payt_sw          VARCHAR2 (1) := 'N';
       v_res_net_cc            VARCHAR2 (1) := 'N';
       v_res_xol_cc            VARCHAR2 (1) := 'N';
       v_payt_net_cc           VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_cc           VARCHAR2 (1) := 'N';
       v_res_net_2cd           VARCHAR2 (1) := 'N';                                --**
       v_res_xol_2cd           VARCHAR2 (1) := 'N';                                --**
       v_payt_net_2cd          VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_2cd          VARCHAR2 (1) := 'N';
       v_paid_net_2cd          VARCHAR2 (1) := 'N';                                --**
       v_paid_xol_2cd          VARCHAR2 (1) := 'N';                                --**
       v_res_net_cd            VARCHAR2 (1) := 'N';                                --**
       v_res_xol_cd            VARCHAR2 (1) := 'N';
       v_payt_net_cd           VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_cd           VARCHAR2 (1) := 'N';

       v_losses_paid           NUMBER       := 0;
       v_expenses_paid         NUMBER       := 0;
       v_loss_res              NUMBER       := 0;
       v_exp_res               NUMBER       := 0;
       v_payt_sw               VARCHAR2 (1) := 'N';

       v_advice_exist          VARCHAR2 (1) := 'N';
       v_checked_payment       VARCHAR2 (1) := 'N';
       v_with_recovery         VARCHAR2 (1) := 'N';

       TYPE v_cur_type IS REF CURSOR;

       v_cursor   v_cur_type;

   BEGIN
      BEGIN  
        SELECT param_value_v
          INTO v_cancelled_status
          FROM giac_parameters
         WHERE param_name LIKE 'CANCELLED';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'CANCELLED parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      BEGIN
        SELECT param_value_v
          INTO v_withdrawn_status
          FROM giac_parameters
         WHERE param_name LIKE 'WITHDRAWN';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'WITHDRAWN parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      BEGIN
        SELECT param_value_v
          INTO v_denied_status
          FROM giac_parameters
         WHERE param_name LIKE 'DENIED';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'DENIED parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      BEGIN
        SELECT param_value_v
          INTO v_closed_status
          FROM giac_parameters
         WHERE param_name LIKE 'CLOSED CLAIM';
      EXCEPTION
        WHEN NO_DATA_FOUND THEN NULL;
          --RAISE_APPLICATION_ERROR(-20001,'CLOSED CLAIM parameter does not exist in GIAC_PARAMETERS. Please contact your system administrator.');
      END;

      v_stmt_str :=  'SELECT *'
                 ||  '  FROM gicl_claims a'
                 ||  ' WHERE 1=1'
                 ||  '   AND clm_yy = NVL(:p_clm_yy, clm_yy)'
                 ||  '   AND clm_seq_no = NVL(:p_clm_seq_no, clm_seq_no)'
                 ||  '   AND iss_cd = NVL(:p_clm_iss_cd, iss_cd)'
                 ||  '   AND subline_cd = NVL(:p_clm_subline_cd, subline_cd)'
                 ||  '   AND line_cd = NVL(:p_clm_line_cd, line_cd)'
                 ||  '   AND pol_iss_cd = NVL(:p_pol_iss_cd, pol_iss_cd)'
                 ||  '   AND issue_yy = NVL(:p_pol_issue_yy, issue_yy)'
                 ||  '   AND pol_seq_no = NVL(:p_pol_seq_no, pol_seq_no)'
                 ||  '   AND renew_no = NVL(:p_pol_renew_no, renew_no)'
                 ||  '   AND assd_no = NVL(:p_assd_no, assd_no)';                     
      
      IF p_search_by <> '0' THEN
        IF p_search_by = '1' THEN
          v_stmt_str := v_stmt_str || ' AND TRUNC(clm_file_date)';
        ELSIF p_search_by = '2' THEN
          v_stmt_str := v_stmt_str || ' AND TRUNC(loss_date)';
        END IF;
        
        IF p_as_of_date IS NOT NULL THEN
          v_stmt_str := v_stmt_str || ' < TO_DATE('''||p_as_of_date||''', ''MM-DD-YYYY'')';
        ELSIF p_from_date IS NOT NULL AND p_to_date IS NOT NULL THEN
          v_stmt_str := v_stmt_str || ' BETWEEN TO_DATE('''||p_from_date||''', ''MM-DD-YYYY'') AND TO_DATE('''||p_to_date||''', ''MM-DD-YYYY'')';
        END IF;
      END IF;
      
      IF p_status_control = '1' THEN

      v_stmt_str := v_stmt_str
                    || ' AND clm_stat_cd in(''' || v_cancelled_status || ''',
                                             ''' || v_closed_status || ''',
                                             ''' || v_withdrawn_status || ''',
                                             ''' || v_denied_status || ''')'||' 
                         ORDER BY get_claim_number(claim_id)';

      ELSIF p_status_control = '2' THEN

      v_stmt_str := v_stmt_str
                    || ' AND claim_id in (SELECT b.claim_id
                                             FROM gicl_clm_res_hist b,gicl_item_peril c
                                             WHERE b.claim_id = c.claim_id
                                              AND b.item_no = c.item_no
                                              AND tran_id IS NOT NULL
                                              AND nvl(b.grouped_item_no,0) = nvl(c.grouped_item_no,0)
                                              AND b.peril_cd = c.peril_cd
                                              AND NVL(cancel_tag, ''N'') = ''N'')
                           AND clm_stat_cd not in (''CD'',''WD'',''DN'',''CC'')
                         ORDER BY get_claim_number(claim_id)';
      ELSIF p_status_control IN ('3', '4', '5') THEN
      v_stmt_str := v_stmt_str
                    || ' AND clm_stat_cd not in (''CD'',''WD'',''DN'',''CC'')
                         ORDER BY get_claim_number(claim_id)';
      /*ELSIF p_status_control IN ('4','5') THEN

      v_stmt_str := v_stmt_str
                    || ' WHERE check_user_per_iss_Cd2(LINE_CD,iss_cd,:controlmodule, :user_id)=1
                          AND claim_id in (SELECT b.claim_id
                                             FROM gicl_clm_res_hist b,gicl_item_peril c
                                            WHERE B.claim_id = c.claim_id
                                              AND b.item_no = c.item_no
                                              AND nvl(b.grouped_item_no,0) = nvl(c.grouped_item_no,0)
                                              AND b.peril_cd = c.peril_cd
                                              AND tran_id IS NULL
                                              AND NVL(cancel_tag, ''N'') = ''N'')
                           AND clm_stat_cd not in (''CD'',''WD'',''DN'',''CC'')';*/
      END IF;

      OPEN v_cursor FOR v_stmt_str
         USING p_clm_yy, p_clm_seq_no, p_clm_iss_cd, p_clm_subline_cd, p_clm_line_cd, p_pol_iss_cd, p_pol_issue_yy, p_pol_seq_no, p_pol_renew_no, p_assd_no;             

      LOOP
          FETCH v_cursor INTO v_record;

          v_claims.claim_no         := v_record.line_cd || '-' || v_record.subline_cd || '-' || v_record.iss_cd || '-' ||
                                        LTRIM (TO_CHAR (v_record.clm_yy, '00')) || '-' || LTRIM (TO_CHAR (v_record.clm_seq_no, '0000009'));
          v_claims.policy_no        := v_record.line_cd || '-' || v_record.subline_cd || '-' || v_record.pol_iss_cd || '-' || LTRIM (TO_CHAR (v_record.issue_yy, '00')) || '-' ||
                                        LTRIM (TO_CHAR (v_record.pol_seq_no, '0000009')) || '-' || LTRIM (TO_CHAR (v_record.renew_no, '00'));
          v_claims.line_cd          := v_record.line_cd;
          v_claims.subline_cd       := v_record.subline_cd;
          v_claims.iss_cd           := v_record.iss_cd;
          v_claims.clm_yy           := v_record.clm_yy;
          v_claims.clm_seq_no       := v_record.clm_seq_no;
          v_claims.pol_iss_cd       := v_record.pol_iss_cd;
          v_claims.issue_yy         := v_record.issue_yy;
          v_claims.pol_seq_no       := v_record.pol_seq_no;
          v_claims.renew_no         := v_record.renew_no;
          v_claims.assd_no          := v_record.assd_no;
          v_claims.assured_name     := v_record.assured_name;
          v_claims.claim_id         := v_record.claim_id;
          v_claims.dsp_loss_date    := v_record.dsp_loss_date;
          v_claims.clm_file_date    := v_record.clm_file_date;
          v_claims.remarks          := v_record.remarks;
          v_claims.close_date       := v_record.close_date;
          v_claims.entry_date       := v_record.entry_date;
          v_claims.last_update      := v_record.last_update;
          v_claims.in_hou_adj       := v_record.in_hou_adj;
          v_claims.user_id          := v_record.user_id;
          v_claims.loss_res_amt     := v_record.loss_res_amt;
          v_claims.exp_res_amt      := v_record.exp_res_amt;
          v_claims.loss_pd_amt      := v_record.loss_pd_amt;
          v_claims.exp_pd_amt       := v_record.exp_pd_amt;
          v_claims.clm_control      := v_record.clm_control;
          v_claims.clm_coop         := v_record.clm_coop;
          v_claims.recovery_sw      := v_record.recovery_sw;
          v_claims.refresh_sw       := v_record.refresh_sw;
          v_claims.max_endt_seq_no  := v_record.max_endt_seq_no;
          v_claims.loss_date        := v_record.loss_date;
          v_claims.clm_setl_date    := v_record.clm_setl_date;
          v_claims.loss_loc1        := v_record.loss_loc1;
          v_claims.loss_loc2        := v_record.loss_loc2;
          v_claims.loss_loc3        := v_record.loss_loc3;
          v_claims.pol_eff_date     := v_record.pol_eff_date;
          v_claims.expiry_date      := v_record.expiry_date;
          v_claims.csr_no           := v_record.csr_no;
          v_claims.loss_cat_cd      := v_record.loss_cat_cd;
          v_claims.intm_no          := v_record.intm_no;
          v_claims.clm_amt          := v_record.clm_amt;
          v_claims.loss_dtls        := v_record.loss_dtls;
          v_claims.obligee_no       := v_record.obligee_no;
          v_claims.ri_cd            := v_record.ri_cd;
          v_claims.plate_no         := v_record.plate_no;
          v_claims.cpi_rec_no       := v_record.cpi_rec_no;
          v_claims.cpi_branch_cd    := v_record.cpi_branch_cd;
          v_claims.old_stat_cd      := v_record.old_stat_cd;
          v_claims.catastrophic_cd  := v_record.catastrophic_cd;
          v_claims.acct_of_cd       := v_record.acct_of_cd;
          v_claims.clm_stat_cd      := v_record.clm_stat_cd;

          BEGIN
          v_claims.clm_stat_desc := '';

            SELECT clm_stat_desc
              INTO v_claims.clm_stat_desc
              FROM giis_clm_stat
             WHERE clm_stat_cd = v_record.clm_stat_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.clm_stat_desc := '';
          END;
          
          BEGIN
          v_claims.dsp_cat_desc := '';

            SELECT catastrophic_desc
              INTO v_claims.dsp_cat_desc
              FROM gicl_cat_dtl
             WHERE catastrophic_cd = v_record.catastrophic_cd;
           EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.dsp_cat_desc := 'INVALID';
          END;

          BEGIN
          v_claims.pol_flag := '';

            SELECT a.pol_flag
              INTO v_claims.pol_flag
              FROM gipi_polbasic a, gicl_claims b
             WHERE b.claim_id = v_record.claim_id
               AND a.line_cd = b.line_cd
               AND a.subline_cd = b.subline_cd
               AND a.iss_cd = b.pol_iss_cd
               AND a.issue_yy = b.issue_yy
               AND a.pol_seq_no = b.pol_seq_no
               AND a.renew_no = b.renew_no
               AND NVL(a.endt_seq_no,0) = 0;
          EXCEPTION
              WHEN NO_DATA_FOUND
              THEN v_claims.pol_flag := '';
          END;


          v_clm_setld := 'Y';

          FOR i IN (SELECT 1
                      FROM gicl_clm_res_hist
                     WHERE claim_id = v_record.claim_id
                       AND date_paid IS NOT NULL
                       AND tran_id IS NOT NULL
                       AND NVL (cancel_tag, 'N') = 'N'
                     GROUP BY claim_id
                    HAVING NVL (SUM (losses_paid), 0) <> 0
                        OR NVL (SUM (expenses_paid), 0) <> 0)
          LOOP
             v_clm_setld := 'N'; --false
             EXIT;
          END LOOP;

          v_claims.clm_setld  :=  v_clm_setld;

          v_advice_exist := 'N'; --to clear previous value
          v_checked_payment := 'N';

          IF p_status_control = '2' THEN
            FOR chk_adv IN (SELECT advice_id
                              FROM gicl_advice
                             WHERE claim_id = v_record.claim_id
                               AND advice_flag = 'Y'
                               AND (apprvd_tag = 'Y'
                                    OR batch_csr_id IS NOT NULL
                                    OR batch_dv_id IS NOT NULL
                                   ))
            LOOP
                v_advice_exist := 'Y';
                FOR chk_payment IN (SELECT '1'
                               FROM gicl_clm_loss_exp
                              WHERE advice_id = chk_adv.advice_id
                                AND tran_id IS NULL
                                AND tran_date IS NULL)
                LOOP
                    v_checked_payment := 'Y';
                END LOOP;

            END LOOP;

          ELSE
              IF  v_clm_setld = 'Y' THEN
                FOR chk_adv IN (SELECT advice_id
                                  FROM gicl_advice
                                 WHERE claim_id = v_record.claim_id
                                   AND advice_flag = 'Y'
                                   AND apprvd_tag = 'Y')
                LOOP
                    v_advice_exist := 'Y';
                    EXIT;
                END LOOP;
              END IF;
          END IF;

          v_claims.advice_exist := v_advice_exist;
          v_claims.chk_payment := v_checked_payment;

         -- CHECK CLAIM CLOSING

          v_payt_sw := 'N';

          FOR item_perl IN (SELECT item_no, peril_cd, close_flag, close_flag2,
                            grouped_item_no            --EMCY da091406te: GPA
                       FROM gicl_item_peril a
                      --WHERE claim_id = :c003.claim_id    --   EMCHANG
                     WHERE  claim_id = v_record.claim_id
                        --modified closed flag condition by Edison 09.05.2012, added closed_flag2
                        AND (   NVL (close_flag, 'AP') IN ('AP', 'CP', 'CC')
                             OR NVL (close_flag2, 'AP') IN ('AP', 'CP', 'CC')
                            ))
          LOOP
              v_item_payt_sw := 'N';                              --Edison 09.05.2012

              --check if payment has been made for active item peril
              FOR payt IN (SELECT '1'
                             FROM gicl_clm_res_hist
                            WHERE claim_id = v_record.claim_id
                              --WHERE claim_id = :c003.claim_id
                              AND item_no = item_perl.item_no
                              AND NVL (grouped_item_no, 0) =
                                                    NVL (item_perl.grouped_item_no, 0)
                              --EMCY da091406te:GPA
                              AND peril_cd = item_perl.peril_cd
                              AND tran_id IS NOT NULL
                              AND NVL (cancel_tag, 'N') = 'N')
              LOOP
                 v_item_payt_sw := 'Y';
                 --variables.v_goflag := TRUE;
                 --EXIT;

                 --to check the value of reserve and payments.
                 SELECT SUM (NVL (losses_paid, 0)) loss_paid,
                        SUM (NVL (expenses_paid, 0)) exp_paid
                   INTO v_losses_paid,
                        v_expenses_paid
                   FROM gicl_clm_res_hist
                  WHERE claim_id = v_record.claim_id
                    AND item_no = item_perl.item_no
                    AND peril_cd = item_perl.peril_cd
                    AND tran_id IS NOT NULL
                    AND NVL (cancel_tag, 'N') = 'N';

                 SELECT SUM (NVL (loss_reserve, 0)) loss,
                        SUM (NVL (expense_reserve, 0)) expense
                   INTO v_loss_res,
                        v_exp_res
                   FROM gicl_clm_res_hist
                  WHERE claim_id = v_record.claim_id
                    AND item_no = item_perl.item_no
                    AND peril_cd = item_perl.peril_cd
                    AND tran_id IS NULL
                    AND NVL (cancel_tag, 'N') = 'N'
                    AND clm_res_hist_id IN (
                           SELECT MAX (clm_res_hist_id)
                             FROM gicl_clm_res_hist
                            WHERE claim_id = v_record.claim_id
                              AND item_no = item_perl.item_no
                              AND peril_cd = item_perl.peril_cd
                              AND tran_id IS NULL
                              AND NVL (cancel_tag, 'N') = 'N');

                 IF     NVL (item_perl.close_flag, 'AP') = 'AP'
                    AND NVL (item_perl.close_flag2, 'AP') = 'AP'
                 THEN                            --if both (loss and expense) are open
                    IF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) <> 0
                    THEN                                       --if both have reserve
                       IF v_losses_paid <> 0 AND v_expenses_paid <> 0
                       THEN                                    --if both have payment
                          IF     v_loss_res = v_losses_paid
                             AND v_exp_res = v_expenses_paid
                          THEN                        --if both reserve are fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    ELSIF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) = 0
                    THEN                  --if has loss reserve but no expense reserve
                       IF NVL (v_losses_paid, 0) <> 0
                       THEN                                     --if loss has payment
                          IF v_loss_res = v_losses_paid
                          THEN                        --if loss reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    ELSIF NVL (v_exp_res, 0) <> 0 AND NVL (v_loss_res, 0) = 0
                    THEN                  --if has expense reserve but no loss reserve
                       IF NVL (v_expenses_paid, 0) <> 0
                       THEN                                  --if expense has payment
                          IF v_exp_res = v_expenses_paid
                          THEN                     --if expense reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END IF;
                 ELSIF     NVL (item_perl.close_flag, 'AP') = 'AP'
                       AND NVL (item_perl.close_flag2, 'AP') != 'AP'
                 THEN                                   --if only loss reserve is open
                    IF NVL (v_loss_res, 0) <> 0
                    THEN                                        --if has loss reserve
                       IF NVL (v_losses_paid, 0) <> 0
                       THEN                                     --if loss has payment
                          IF v_loss_res = v_losses_paid
                          THEN                        --if loss reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END IF;
                 ELSIF     NVL (item_perl.close_flag2, 'AP') = 'AP'
                       AND NVL (item_perl.close_flag, 'AP') != 'AP'
                 THEN                                    --if only expense res is open
                    IF NVL (v_exp_res, 0) <> 0
                    THEN                                     --if has expense reserve
                       IF NVL (v_expenses_paid, 0) <> 0
                       THEN                                  --if expense has payment
                          IF v_exp_res = v_expenses_paid
                          THEN                     --if expense reserve is fully paid
                             v_item_payt_sw := 'Y';
                             v_payt_sw := 'Y';
                             EXIT;
                          END IF;
                       END IF;
                    END IF;
                 ELSIF     NVL (item_perl.close_flag2, 'AP') != 'AP'
                       AND NVL (item_perl.close_flag, 'AP') != 'AP'
                 THEN                        --if both (loss and reserve) are not open
                    v_item_payt_sw := 'Y';
                    v_payt_sw := 'Y';
                 END IF;
              END LOOP;                                               -- end loop payt

              --if loss reserve has no payment
              IF v_item_payt_sw = 'N'
              THEN
                 IF item_perl.close_flag = 'AP'
                 THEN
                    gicl_claims_pkg.chk_cancelled_xol_res(
                                        v_res_net_cc,
                                        v_res_xol_cc,
                                        item_perl.item_no,
                                        item_perl.grouped_item_no,
                                        item_perl.peril_cd,
                                        v_record.claim_id
                                        );
                    gicl_claims_pkg.chk_cancelled_xol_payt (
                                        v_payt_net_cc,
                                        v_payt_xol_cc,
                                        item_perl.item_no,
                                        item_perl.grouped_item_no,
                                        item_perl.peril_cd,
                                        v_record.claim_id
                                        );
                 END IF;
              END IF;

              --IF LOSS RESERVE HAS PAYMENT AND ACTIVE
              IF     (item_perl.close_flag = 'AP' OR item_perl.close_flag2 = 'AP')
                 AND v_item_payt_sw = 'Y'
              THEN
                 gicl_claims_pkg.chk_cancelled_xol_res(
                                     v_res_net_2cd,
                                     v_res_xol_2cd,
                                     item_perl.item_no,
                                     item_perl.grouped_item_no,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
                 gicl_claims_pkg.chk_cancelled_xol_payt(
                                     v_payt_net_2cd,
                                     v_payt_xol_2cd,
                                     item_perl.item_no,
                                     item_perl.grouped_item_no,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
                 gicl_claims_pkg.chk_paid_xol_payt(
                                     v_paid_net_2cd,
                                     v_paid_xol_2cd,
                                     item_perl.item_no,
                                     NVL (item_perl.grouped_item_no, 0),
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
              END IF;

              --IF LOSS RESERVE IS CLOSED
              IF    item_perl.close_flag IN ('CP', 'CC')
                 OR item_perl.close_flag2 IN ('CP', 'CC')
              THEN
                 gicl_claims_pkg.chk_cancelled_xol_res (
                                     v_res_net_cd,
                                     v_res_xol_cd,
                                     item_perl.item_no,
                                     2,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
                 gicl_claims_pkg.chk_paid_xol_payt (
                                     v_payt_net_cd,
                                     v_payt_xol_cd,
                                     item_perl.item_no,
                                     2,
                                     item_perl.peril_cd,
                                     v_record.claim_id
                                     );
              END IF;
          END LOOP;

          v_claims.payt_sw := v_payt_sw;

          v_with_recovery := 'N';
          FOR i IN
               (SELECT 1
                  FROM gicl_clm_recovery
                 WHERE claim_id = v_record.claim_id
                   AND NVL(cancel_tag, 'N') NOT IN ('C', 'Y'))
          LOOP
           v_with_recovery := 'Y';
          END LOOP;

          v_claims.with_recovery := v_with_recovery;

          EXIT WHEN v_cursor%NOTFOUND;
          PIPE ROW (v_claims);
      END LOOP;

      CLOSE v_cursor;
   END get_claim_closing_listing;

   PROCEDURE CHECK_USER_FUNCTION(
    p_user_id          IN       GIIS_USERS.user_id%TYPE,
    p_module_id        OUT      GIAC_MODULES.module_id%TYPE,
    p_function_cd      IN       GIAC_FUNCTIONS.function_code%TYPE,
    p_function_name    OUT      VARCHAR2,
    p_function_exist   OUT      VARCHAR2,
    p_user_valid       OUT      giac_user_functions.valid_tag%TYPE
    )

    AS

    /*
    **  Created by    : Christian Santos
    **  Date Created  : 10.09.2012
    **  Reference By  : GICLS039 - Batch Claim Closing
    **  Description   : Check if user has authority and if the module is available
    **
    */

    v_func_exist  VARCHAR2(1) := 'N';   --is Y if function (Open,Close,Withdraw,Deny,Cancel claim) exists in giac_functions
    v_user_valid  giac_user_functions.valid_tag%TYPE := 'N';

    BEGIN
      FOR module IN (SELECT module_id id
                       FROM giac_modules
                      WHERE module_name = 'GICLS039')
      LOOP
        p_module_id := module.id;
        EXIT;
      END LOOP;

      IF p_module_id IS NOT NULL THEN
      -- module exists
      -- if module exists in giac_modules, check if function exists in giac_functions
         FOR func IN (SELECT 'Y' exist, INITCAP(function_name) name
                        FROM giac_functions
                       WHERE module_id   = p_module_id
                         AND function_code = p_function_cd)
         LOOP
           v_func_exist := func.exist;
           p_function_name := func.name;
           EXIT;
         END LOOP;

         IF v_func_exist = 'Y' THEN
         -- functions exists
         -- check if user is allowed to perform function (valid_tag = Y)
            FOR usr IN (SELECT valid_tag valid, validity_dt, termination_dt
                          FROM giac_user_functions
                         WHERE user_id = p_user_id
                           AND module_id = p_module_id
                           AND function_code = p_function_cd)
            LOOP
              IF usr.termination_dt IS NULL THEN
                 IF TRUNC(SYSDATE) >= NVL(TRUNC(usr.validity_dt), TRUNC(SYSDATE)) THEN
                    v_user_valid := usr.valid;
                 END IF;
              ELSIF usr.termination_dt IS NOT NULL THEN
                 IF TRUNC(SYSDATE) >= NVL(TRUNC(usr.validity_dt), TRUNC(SYSDATE)) AND TRUNC(SYSDATE) <= TRUNC(usr.termination_dt) THEN
                    v_user_valid := usr.valid;
                 END IF;
              END IF;
              EXIT;
            END LOOP;
         END IF;
      END IF;

      p_function_exist := v_func_exist;
      p_user_valid := v_user_valid;
    END;

    PROCEDURE UPDATE_BATCH_CLAIM_CLOSING(
     p_claim_id         IN       GICL_CLAIMS.claim_id%TYPE,
     p_user_id          IN       GICL_CLAIMS.user_id%TYPE,
     p_last_update      IN       GICL_CLAIMS.last_update%TYPE,
     p_remarks          IN       GICL_CLAIMS.remarks%TYPE
     )
    IS
    BEGIN

      UPDATE gicl_claims
         SET user_id = p_user_id,
             last_update = p_last_update,
             remarks = p_remarks
       WHERE claim_id = p_claim_id;

    END;

    PROCEDURE CHK_CANCELLED_XOL_RES (p_curr_net  IN OUT    VARCHAR2,
                                     p_curr_xol  IN OUT    VARCHAR2,
                                     p_item_no             gicl_reserve_ds.item_no%TYPE,
                                     p_grouped_item_no     gicl_reserve_ds.grouped_item_no%TYPE,
                                     p_peril_cd            gicl_reserve_ds.peril_cd%TYPE,
                                     p_claim_id            gicl_claims.claim_id%TYPE)
    IS
        v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
    BEGIN
        --check first if peril have net retention or XOL share
        FOR get_all_xol IN(SELECT DISTINCT a.share_type share_type
                             FROM gicl_reserve_ds a
                            WHERE NVL(a.negate_tag, 'N') = 'N'
                              AND claim_id = p_claim_id  --cxc dagdag parameter nlng
                              AND item_no  = p_item_no
                              AND nvl(grouped_item_no,0) = nvl(p_grouped_item_no,0)
                              AND a.share_type IN(v_xol_share_type, 1))
      LOOP
        IF get_all_xol.share_type = 1 THEN
           p_curr_net := 'Y';
        END IF;
        IF get_all_xol.share_type = v_xol_share_type THEN
           p_curr_xol := 'Y';
        END IF;
      END LOOP;
    END;

    PROCEDURE CHK_CANCELLED_XOL_PAYT (p_curr_net  IN OUT    VARCHAR2,
                                      p_curr_xol  IN OUT    varchar2,
                                      p_item_no             gicl_loss_exp_ds.item_no%TYPE,
                                      p_grouped_item_no     gicl_loss_Exp_ds.grouped_item_no%TYPE,
                                      p_peril_cd            gicl_loss_exp_ds.peril_cd%TYPE,
                                      p_claim_id            gicl_claims.claim_id%TYPE)
    IS
        v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
    BEGIN
        --check first if peril have net retention or XOL share
        FOR get_all_xol IN(SELECT DISTINCT a.share_type share_type
                             FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                            WHERE a.claim_id = b.claim_id
                              AND a.clm_loss_id = b.clm_loss_id
                              AND NVL(b.cancel_sw, 'N') = 'N'
                              AND NVL(a.negate_tag, 'N') = 'N'
                              AND a.claim_id = p_claim_id
                              AND a.item_no = p_item_no
                              AND nvl(a.grouped_item_no,0) = NVL(p_grouped_item_no,0)
                              AND a.peril_cd = p_peril_cd
                              AND b.tran_id IS NULL
                              AND a.share_type IN(v_xol_share_type, 1))
      LOOP
        IF get_all_xol.share_type = 1 THEN
           p_curr_net := 'Y';
        END IF;
        IF get_all_xol.share_type = v_xol_share_type THEN
           p_curr_xol := 'Y';
        END IF;
      END LOOP;
    END;

    PROCEDURE CHK_PAID_XOL_PAYT (p_curr_net  IN OUT    VARCHAR2,
                                 p_curr_xol  IN OUT    varchar2,
                                 p_item_no             gicl_loss_exp_ds.item_no%TYPE,
                                 p_grouped_item_no     gicl_loss_exp_ds.grouped_item_no%TYPE,
                                 p_peril_cd            gicl_loss_exp_ds.peril_cd%TYPE,
                                 p_claim_id            gicl_claims.claim_id%TYPE)
    IS
        v_xol_share_type    giac_parameters.param_value_v%TYPE := giacp.v('XOL_TRTY_SHARE_TYPE');
    BEGIN
        --check first if peril have net retention or XOL share
        FOR get_all_xol IN(SELECT DISTINCT a.share_type share_type
                             FROM gicl_loss_exp_ds a, gicl_clm_loss_exp b
                            WHERE a.claim_id = b.claim_id
                              AND a.clm_loss_id = b.clm_loss_id
                              AND NVL(b.cancel_sw, 'N') = 'N'
                              AND NVL(a.negate_tag, 'N') = 'N'
                              AND a.claim_id = p_claim_id
                              AND a.item_no = p_item_no
                              AND nvl(a.grouped_item_no,0) = nvl(p_grouped_item_no,0)
                              AND a.peril_cd = p_peril_cd
                              AND b.tran_id IS NOT NULL
                              AND a.share_type IN(v_xol_share_type, 1))
      LOOP
        IF get_all_xol.share_type = 1 THEN
           p_curr_net := 'Y';
        END IF;
        IF get_all_xol.share_type = v_xol_share_type THEN
           p_curr_xol := 'Y';
        END IF;
      END LOOP;
    END;

    PROCEDURE OPEN_CLAIMS (p_claim_id        IN        gicl_claims.claim_id%TYPE,
                           p_loss_date       IN        gicl_claims.loss_date%TYPE,
                           p_chk_reserve     IN OUT    VARCHAR2,
                           p_chk_spld        IN OUT    VARCHAR2)
    IS
        v_chk_reserve   VARCHAR2 (1)                      := 'N';
        v_chk_spld      VARCHAR2 (1)                      := 'N';
    BEGIN
        --check for existing records that will be redistributed
        FOR chk_res IN
            (SELECT 1
               FROM gicl_clm_res_hist a, gicl_item_peril b
              WHERE a.claim_id = p_claim_id
                AND a.claim_id = b.claim_id
                AND a.item_no = b.item_no
                AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                AND a.peril_cd = b.peril_cd
                AND (   b.close_flag IN ('DC', 'CC')
                     OR b.close_flag2 IN ('DC', 'CC')
                    ))
        LOOP
            v_chk_reserve := 'Y';
            EXIT;
        END LOOP;

        --check for endorsement spoilage
        FOR pol_flag IN (SELECT a.pol_flag
                           FROM gipi_polbasic a, gicl_claims b
                          WHERE b.claim_id = p_claim_id
                            AND a.line_cd = b.line_cd
                            AND a.subline_cd = b.subline_cd
                            AND a.iss_cd = b.pol_iss_cd
                            AND a.issue_yy = b.issue_yy
                            AND a.pol_seq_no = b.pol_seq_no
                            AND a.renew_no = b.renew_no
                            AND NVL (a.endt_seq_no, 0) > 0
                            AND a.pol_flag = '5'
                            AND TRUNC (a.eff_date) <= TRUNC (p_loss_date))
        LOOP
            v_chk_spld := 'Y';
            EXIT;
        END LOOP;

        p_chk_reserve := v_chk_reserve;
        p_chk_spld    := v_chk_spld;

    END;

    PROCEDURE redistribute_reserve_gicls039(p_claim_id                  gicl_claims.claim_id%TYPE,
                                            p_line_cd                   gicl_claims.line_cd%TYPE,
                                            p_subline_cd                gicl_claims.subline_cd%TYPE,
                                            p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
                                            p_issue_yy                  gicl_claims.issue_yy%TYPE,
                                            p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
                                            p_renew_no                  gicl_claims.renew_no%TYPE,
                                            p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
                                            p_expiry_date               gicl_claims.expiry_date%TYPE,
                                            p_dsp_loss_date             gicl_claims.loss_date%TYPE,
                                            p_clm_file_date             gicl_claims.clm_file_date%TYPE,
                                            p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
                                            p_user_id                   giis_users.user_id%TYPE)
    IS
    BEGIN
       FOR get_res IN
            (SELECT b.item_no, b.peril_cd, b.grouped_item_no, line_cd
               FROM gicl_item_peril b
              WHERE b.claim_id = p_claim_id
                AND EXISTS (
                       SELECT '1'
                         FROM gicl_clm_res_hist a
                        WHERE a.claim_id = b.claim_id
                          AND a.item_no = b.item_no
                          AND NVL (a.grouped_item_no, 0) = NVL (b.grouped_item_no, 0)
                          AND a.peril_cd = b.peril_cd)
                AND (   b.close_flag IN ('DC', 'CC')
                     OR b.close_flag2 IN ('DC', 'CC')
                    ))
       LOOP
          create_new_reserve_gicls039 (p_claim_id, get_res.item_no, get_res.peril_cd, NVL (get_res.grouped_item_no, 0), p_dsp_loss_date, p_clm_file_date,
                                       get_res.line_cd, p_subline_cd, p_pol_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_pol_eff_date, p_expiry_date, p_catastrophic_cd, p_user_id); --p_user_id Added by Jerome Bautista SR 21233 01.21.2016
       END LOOP;
    END;


    PROCEDURE create_new_reserve_gicls039 (
                                          p_claim_id                  gicl_claims.claim_id%TYPE,
                                          p_item_no                   gicl_item_peril.item_no%TYPE,
                                          p_peril_cd                  gicl_item_peril.peril_cd%TYPE,
                                          p_grouped_item_no           gicl_item_peril.grouped_Item_no%TYPE,
                                          p_dsp_loss_date             gicl_claims.dsp_loss_date%TYPE,
                                          p_clm_file_date             gicl_claims.clm_file_date%TYPE,
                                          p_line_cd                   gicl_claims.line_cd%TYPE,  --for distribute_reserve
                                          p_subline_cd                gicl_claims.subline_cd%TYPE,
                                          p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
                                          p_issue_yy                  gicl_claims.issue_yy%TYPE,
                                          p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
                                          p_renew_no                  gicl_claims.renew_no%TYPE,
                                          p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
                                          p_expiry_date               gicl_claims.expiry_date%TYPE,
                                         -- p_loss_date                 gicl_claims.loss_date%TYPE,
                                          p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
                                          p_user_id                   VARCHAR2) --Added by Jerome Bautista SR 21233 01.21.2016
    IS
        -- variable to be use for storing hist_seq_no to be used by new reserve record
        v_hist_seq_no            gicl_clm_res_hist.hist_seq_no%TYPE := 1;
        -- variable to be use for storing old hist_seq_no to be used for update of prev reserve and payments
        v_hist_seq_no_old        gicl_clm_res_hist.hist_seq_no%TYPE := 0;
        -- variable to be use for storing clm_res_hist_id to be used by new reserve record
        v_clm_res_hist          gicl_clm_res_hist.clm_res_hist_id%TYPE := 1;
        -- variable to be use for storing previous loss reseve to be used by new reserve record
        v_prev_loss_res       gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        -- variable to be use for storing previous exp. reseve to be used by new reserve record
        v_prev_exp_res        gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        -- variable to be use for storing previous loss paid to be used by new reserve record
        v_prev_loss_paid      gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        -- variable to be use for storing previous exp.paid to be used by new reserve record
        v_prev_exp_paid       gicl_clm_res_hist.prev_loss_res%TYPE :=0;
        v_month               gicl_clm_res_hist.booking_month%TYPE;
        v_year                gicl_clm_res_hist.booking_year%TYPE;

    BEGIN
       FOR hist IN (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) + 1 seq_no
                         FROM gicl_clm_res_hist
                        WHERE claim_id = p_claim_id
                        AND item_no  = p_item_no
                        AND NVL(grouped_item_no,0) = NVL(p_grouped_item_no,0)
                        AND peril_cd = p_peril_cd)
       LOOP
          v_hist_seq_no := hist.seq_no;
          EXIT;
       END LOOP;
       
       FOR old_hist IN (SELECT NVL(MAX(NVL(hist_seq_no,0)),0) seq_no
                             FROM gicl_clm_res_hist
                            WHERE claim_id = p_claim_id
                            AND item_no  = p_item_no
                            AND NVL(grouped_item_no,0) = NVL(p_grouped_item_no,0)
                            AND peril_cd = p_peril_cd
                            AND NVL(dist_sw,'N') = 'Y')
       LOOP
          v_hist_seq_no_old := old_hist.seq_no;
          EXIT;
       END LOOP;
       
       FOR hist_id IN (SELECT NVL(MAX(NVL(clm_res_hist_id,0)),0) + 1 hist_id
                            FROM gicl_clm_res_hist
                           WHERE claim_id = p_claim_id)
       LOOP
          v_clm_res_hist := hist_id.hist_id;
          EXIT;
       END LOOP;
       
       FOR prev_amt IN (SELECT NVL(loss_reserve,0) loss_reserve,
                               NVL(expense_reserve,0) expense_reserve,
                               NVL(losses_paid,0)  losses_paid,
                               NVL(expenses_paid,0) expenses_paid,
                               currency_cd,
                               convert_rate, dist_no
                             FROM gicl_clm_res_hist
                           WHERE claim_id = p_claim_id
                           AND item_no = p_item_no
                           AND NVL(grouped_item_no,0) = NVL(p_grouped_item_no,0)
                           AND peril_cd = p_peril_cd
                           AND hist_seq_no = v_hist_seq_no_old)
       LOOP
          v_prev_loss_res  := prev_amt.loss_reserve;
          v_prev_exp_res   := prev_amt.expense_reserve;
          v_prev_loss_paid := prev_amt.losses_paid;
          v_prev_exp_paid  := prev_amt.expenses_paid;
          
          cpi.get_booking_date(p_claim_id, v_month, v_year);
          
          INSERT INTO gicl_clm_res_hist
                 (claim_id, clm_res_hist_id, hist_seq_no, item_no,
                  peril_cd, user_id, last_update, loss_reserve, expense_reserve,
                  dist_sw, booking_month, booking_year, currency_cd,
                  convert_rate, prev_loss_res, prev_loss_paid,
                  prev_exp_res, prev_exp_paid, distribution_date, dist_no, grouped_item_no --added grouped_item_no kenneth SR 4758/19818 07202015
                 )
          VALUES (p_claim_id, v_clm_res_hist, v_hist_seq_no, p_item_no,
                  p_peril_cd, /*USER,*/ p_user_id,SYSDATE, v_prev_loss_res, v_prev_exp_res, --USER changed to p_user_id by Jerome Bautista SR 21233 01.21.2016
                  'Y', v_month, v_year, prev_amt.currency_cd,
                  prev_amt.convert_rate, v_prev_loss_res, v_prev_loss_paid,
                  v_prev_exp_res, v_prev_exp_paid, SYSDATE, prev_amt.dist_no, p_grouped_item_no --added p_grouped_item_no kenneth SR 4758/19818 07202015
                 );
       END LOOP;
       
       UPDATE gicl_clm_res_hist
          SET dist_sw = 'N',
               negate_date = SYSDATE
        WHERE claim_id = p_claim_id
          AND item_no  = p_item_no
          AND NVL(grouped_item_no,0) = NVL(p_grouped_item_no,0)
          AND peril_cd = p_peril_cd
          AND NVL(dist_sw, 'N') = 'Y'
          AND hist_seq_no <> v_hist_seq_no;
       
       process_distribution_gicls039(p_claim_id, v_clm_res_hist, v_hist_seq_no, p_item_no, p_grouped_item_no,
                                     p_peril_cd, p_line_cd, p_subline_cd, p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                     p_renew_no, p_pol_eff_date, p_expiry_date, p_dsp_loss_date, p_catastrophic_cd, p_user_id); --p_user_id Added by Jerome Bautista SR 21233 01.21.2016
    END;

    /*PROCEDURE get_booking_date(p_loss_date      IN          gicl_claims.loss_date%TYPE,
                               p_clm_file_date  IN          gicl_claims.clm_file_date%TYPE,
                               p_month          IN OUT      gicl_clm_res_hist.booking_month%TYPE,
                               p_year           IN OUT      gicl_clm_res_hist.booking_year%TYPE)
    IS
      v_max_acct_date  date;
      v_max_post_date  date;
      --this variable will be used to store the branch code from giis_parameters
      v_book_param      giac_parameters.param_value_v%TYPE := giacp.v('RESERVE BOOKING');
      --this variable will be used to store the branch code from giis_parameters
      v_branch_code     giac_parameters.param_value_v%TYPE := giacp.v('BRANCH_CD');
    BEGIN
      -- get booking month and date from giac_tran_mm
      -- which is not later than the maximum acct_date for OL transactions
      -- and which is not yet closed in giac_tran_mm

      -- retrieve maximum acct_date from giac_acctrans for outstanding loss
      -- transactions
      FOR MAX_ACCT_DATE  IN (SELECT trunc(max(acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag not in ('D','P')
                                AND d.claim_id > 0)
      LOOP
        v_max_acct_date   := max_acct_date.acct_date;
      END LOOP;

      -- retrieve maximum acct_date from giac_acctrans for outstanding loss
      -- transactions
      FOR MAX_POST_DATE  IN (SELECT trunc(max(acct_date), 'MONTH') acct_date
                               FROM gicl_take_up_hist d, giac_acctrans e
                              WHERE d.acct_tran_id = e.tran_id
                                AND e.tran_class = 'OL'
                                AND e.tran_flag = 'P'
                                AND d.claim_id > 0)
      LOOP
        v_max_post_date   := max_post_date.acct_date;
      END LOOP;

      IF v_max_post_date IS NOT NULL THEN
         FOR booking_date IN (SELECT decode(a.tran_mm,1, 'JANUARY',    2, 'FEBRUARY',
                                                                        3, 'MARCH',      4, 'APRIL',
                                                                        5, 'MAY',        6, 'JUNE',
                                                                        7, 'JULY',       8, 'AUGUST',
                                                                        9, 'SEPTEMBER', 10, 'OCTOBER',
                                                                     11, 'NOVEMBER',  12,'DECEMBER') booking_month,
                                                     a.tran_yr booking_year, a.tran_mm
                                                    FROM giac_tran_mm a
                                                 WHERE rownum <= 1
                                                 AND a.closed_tag = 'N'
                                                 AND a.branch_cd = v_branch_code
                                                 AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY') >=
                                                     TRUNC(DECODE(v_book_param,'L',p_loss_date,p_clm_file_date), 'MONTH')
                                                 AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY')
                                                     >= NVL( v_max_acct_date,
                                                     TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY'))
                                                 AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY')
                                                     >  v_max_post_date
                                                 ORDER BY a.tran_yr ASC, a.tran_mm ASC)
         LOOP
           p_month := booking_date.booking_month;
           p_year  := booking_date.booking_year;
           EXIT;
         END LOOP; -- end loop booking_date
      ELSE
         FOR booking_date IN (SELECT decode(a.tran_mm,1, 'JANUARY',    2,'FEBRUARY',
                                                                        3, 'MARCH',      4,'APRIL',
                                                                        5, 'MAY',        6,'JUNE',
                                                                        7, 'JULY',       8,'AUGUST',
                                                                        9, 'SEPTEMBER', 10, 'OCTOBER',
                                                                     11, 'NOVEMBER',  12,'DECEMBER') booking_month,
                                                     a.tran_yr booking_year, a.tran_mm
                                                    FROM giac_tran_mm a
                                                 WHERE rownum <= 1
                                                 AND a.closed_tag = 'N'
                                                 AND a.branch_cd = v_branch_code
                                                 AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY') >=
                                                     TRUNC(DECODE(v_book_param,'L',p_loss_date,p_clm_file_date), 'MONTH')
                                                 AND TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY')
                                                     >= NVL( v_max_acct_date,
                                                     TO_DATE('01-'||to_char(a.tran_mm)||'-'||to_char(a.tran_yr),'DD-MM-YYYY'))
                                                 ORDER BY a.tran_yr ASC, a.tran_mm ASC)
         LOOP
           p_month := booking_date.booking_month;
           p_year  := booking_date.booking_year;
           EXIT;
         END LOOP; -- end loop booking_date
      END IF;
    END;*/

    PROCEDURE process_distribution_gicls039 (p_claim_id                  gicl_claims.claim_id%TYPE,
                                             p_clm_res_hist              gicl_clm_res_hist.clm_res_hist_id%TYPE,
                                             p_hist_seq_no               gicl_clm_res_hist.hist_seq_no%TYPE,
                                             p_item_no                   gicl_item_peril.item_no%TYPE,
                                             p_grouped_item_no           gicl_item_peril.grouped_item_no%TYPE, --EMCY da091406te:  gpa
                                             p_peril_cd                  gicl_item_peril.peril_cd%TYPE,
                                             p_line_cd                   gicl_claims.line_cd%TYPE,  --for distribute_reserve
                                             p_subline_cd                gicl_claims.subline_cd%TYPE,
                                             p_pol_iss_cd                gicl_claims.pol_iss_cd%TYPE,
                                             p_issue_yy                  gicl_claims.issue_yy%TYPE,
                                             p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
                                             p_renew_no                  gicl_claims.renew_no%TYPE,
                                             p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
                                             p_expiry_date               gicl_claims.expiry_date%TYPE,
                                             p_loss_date                 gicl_claims.loss_date%TYPE,
                                             p_catastrophic_cd           gicl_claims.catastrophic_cd%TYPE,
                                             p_user_id                   VARCHAR2) --Added by Jerome Bautista SR 21233 01.21.2016

    IS
      v_prtf_sw         NUMBER := 0;   --indicate if distribution is portfolio or natural expiry
      v_loss_amt        gicl_claims.loss_res_amt%TYPE;  --temp. storage of loss_reserve amount for gicl_claims update
      v_exp_amt             gicl_claims.exp_res_amt%TYPE;   --temp. storage of exp_reserve amount for gicl_claims update
    BEGIN
       
      UPDATE gicl_reserve_ds
         SET negate_tag = 'Y'
       WHERE claim_id = p_claim_id
         AND hist_seq_no < p_hist_seq_no
         AND item_no = p_item_no
         AND NVL(grouped_item_no,0) = NVL(p_grouped_item_no,0)
         AND peril_cd = p_peril_cd;
         
      
      distribute_reserve_gicls039(p_claim_id, p_clm_res_hist, p_item_no, p_peril_cd, p_line_cd, p_subline_cd, 
                                  p_pol_iss_cd, p_issue_yy, p_pol_seq_no,p_renew_no, p_pol_eff_date, p_expiry_date, 
                                  p_loss_date, p_catastrophic_cd,p_grouped_item_no, p_user_id); --p_grouped_item_no, p_user_id Added by Jerome Bautista 01.13.2016 SR 21233
    END;
    --popo
    PROCEDURE distribute_reserve_gicls039 (
       p_claim_id          gicl_clm_res_hist.claim_id%TYPE,
       p_clm_res_hist_id   gicl_clm_res_hist.clm_res_hist_id%TYPE,
       p_item_no           gicl_item_peril.item_no%TYPE,
       p_peril_cd          gicl_item_peril.peril_cd%TYPE,
       p_line_cd           gicl_claims.line_cd%TYPE,
       p_subline_cd        gicl_claims.subline_cd%TYPE,
       p_pol_iss_cd        gicl_claims.pol_iss_cd%TYPE,
       p_issue_yy          gicl_claims.issue_yy%TYPE,
       p_pol_seq_no        gicl_claims.pol_seq_no%TYPE,
       p_renew_no          gicl_claims.renew_no%TYPE,
       p_pol_eff_date      gicl_claims.pol_eff_date%TYPE,
       p_expiry_date       gicl_claims.expiry_date%TYPE,
       p_loss_date         gicl_claims.loss_date%TYPE,
       p_catastrophic_cd   gicl_claims.catastrophic_cd%TYPE,
       p_grouped_item_no   gicl_item_peril.grouped_item_no%TYPE, --Added by Jerome Bautista 01.13.2016 SR 21233
       p_user_id           VARCHAR2 --Added by Jerome Bautista SR 21233 01.21.2016
    )
    IS
       CURSOR cur_clm_res
       IS
          SELECT        claim_id, clm_res_hist_id, hist_seq_no, item_no,
                        peril_cd, loss_reserve, expense_reserve, convert_rate
                   FROM gicl_clm_res_hist
                  WHERE claim_id = p_claim_id
                    AND clm_res_hist_id = p_clm_res_hist_id
          FOR UPDATE OF dist_sw;

       CURSOR cur_perilds (
          p_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
          p_item_no    giri_ri_dist_item_v.item_no%TYPE
       )
       IS
          SELECT   d.share_cd, f.share_type, f.trty_yy, f.prtfolio_sw,
                   f.acct_trty_type, SUM (d.dist_tsi) ann_dist_tsi, f.expiry_date
              FROM gipi_polbasic a,
                   gipi_item b,
                   giuw_pol_dist c,
                   giuw_itemperilds_dtl d,
                   giis_dist_share f,
                   giis_parameters e
             WHERE f.share_cd = d.share_cd
               AND f.line_cd = d.line_cd
               AND d.peril_cd = p_peril_cd
               AND d.item_no = p_item_no
               AND d.item_no = b.item_no
               AND d.dist_no = c.dist_no
               AND e.param_type = 'V'
               AND c.dist_flag = e.param_value_v
               AND e.param_name = 'DISTRIBUTED'
               AND c.policy_id = b.policy_id
               AND TRUNC (DECODE (TRUNC (c.eff_date),
                                  TRUNC (a.eff_date), DECODE
                                                            (TRUNC (a.eff_date),
                                                             TRUNC (a.incept_date), p_pol_eff_date,
                                                             a.eff_date
                                                            ),
                                  c.eff_date
                                 )
                         ) <= p_loss_date
               AND TRUNC (DECODE (TRUNC (c.expiry_date),
                                  TRUNC (a.expiry_date), DECODE
                                                        (NVL (a.endt_expiry_date,
                                                              a.expiry_date
                                                             ),
                                                         a.expiry_date, p_expiry_date,
                                                         a.endt_expiry_date
                                                        ),
                                  c.expiry_date
                                 )
                         ) >= p_loss_date
               AND b.policy_id = a.policy_id
               AND a.pol_flag IN ('1', '2', '3', 'X')
               AND a.line_cd = p_line_cd
               AND a.subline_cd = p_subline_cd
               AND a.iss_cd = p_pol_iss_cd
               AND a.issue_yy = p_issue_yy
               AND a.pol_seq_no = p_pol_seq_no
               AND a.renew_no = p_renew_no
          GROUP BY a.line_cd,
                   a.subline_cd,
                   a.iss_cd,
                   a.issue_yy,
                   a.pol_seq_no,
                   a.renew_no,
                   d.share_cd,
                   f.share_type,
                   f.trty_yy,
                   f.acct_trty_type,
                   d.item_no,
                   d.peril_cd,
                   f.prtfolio_sw,
                   f.expiry_date;

       CURSOR cur_trty (
          v_share_cd   giis_dist_share.share_cd%TYPE,
          v_trty_yy    giis_dist_share.trty_yy%TYPE
       )
       IS
          SELECT ri_cd, trty_shr_pct, prnt_ri_cd
            FROM giis_trty_panel
           WHERE line_cd = p_line_cd
             AND trty_yy = v_trty_yy
             AND trty_seq_no = v_share_cd;

       CURSOR cur_frperil (
          p_peril_cd   giri_ri_dist_item_v.peril_cd%TYPE,
          p_item_no    giri_ri_dist_item_v.item_no%TYPE
       )
       IS
          SELECT   t2.ri_cd,
                   SUM (NVL ((t2.ri_shr_pct / 100) * t8.tsi_amt, 0)
                       ) sum_ri_tsi_amt
              FROM gipi_polbasic t5,
                   gipi_itmperil t8,
                   giuw_pol_dist t4,
                   giuw_itemperilds t6,
                   giri_distfrps t3,
                   giri_frps_ri t2
             WHERE 1 = 1
               AND t5.line_cd = p_line_cd
               AND t5.subline_cd = p_subline_cd
               AND t5.iss_cd = p_pol_iss_cd
               AND t5.issue_yy = p_issue_yy
               AND t5.pol_seq_no = p_pol_seq_no
               AND t5.renew_no = p_renew_no
               AND t5.pol_flag IN ('1', '2', '3', 'X')
               AND t5.policy_id = t8.policy_id
               AND t8.peril_cd = p_peril_cd
               AND t8.item_no = p_item_no
               AND t5.policy_id = t4.policy_id
               AND TRUNC (DECODE (TRUNC (t4.eff_date),
                                  TRUNC (t5.eff_date), DECODE
                                                           (TRUNC (t5.eff_date),
                                                            TRUNC (t5.incept_date), p_pol_eff_date,
                                                            t5.eff_date
                                                           ),
                                  t4.eff_date
                                 )
                         ) <= p_loss_date
               AND TRUNC (DECODE (TRUNC (t4.expiry_date),
                                  TRUNC (t5.expiry_date), DECODE
                                                       (NVL (t5.endt_expiry_date,
                                                             t5.expiry_date
                                                            ),
                                                        t5.expiry_date, p_expiry_date,
                                                        t5.endt_expiry_date
                                                       ),
                                  t4.expiry_date
                                 )
                         ) >= p_loss_date
               AND t4.dist_flag = '3'
               AND t4.dist_no = t6.dist_no
               AND t8.item_no = t6.item_no
               AND t8.peril_cd = t6.peril_cd
               AND t4.dist_no = t3.dist_no
               AND t6.dist_seq_no = t3.dist_seq_no
               AND t3.line_cd = t2.line_cd
               AND t3.frps_yy = t2.frps_yy
               AND t3.frps_seq_no = t2.frps_seq_no
               AND NVL (t2.reverse_sw, 'N') = 'N'
               AND NVL (t2.delete_sw, 'N') = 'N'
               AND t3.ri_flag = '2'
          GROUP BY t2.ri_cd;

       sum_tsi_amt          giri_basic_info_item_sum_v.tsi_amt%TYPE;
       ann_ri_pct           gicl_reserve_rids.shr_ri_pct%TYPE;
       ann_dist_spct        gicl_reserve_ds.shr_pct%TYPE              := 0;
       me                   NUMBER                                    := 0;
       v_facul_share_cd     giuw_perilds_dtl.share_cd%TYPE;
       v_trty_share_type    giis_dist_share.share_type%TYPE;
       v_facul_share_type   giis_dist_share.share_type%TYPE;
       v_loss_res_amt       gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_exp_res_amt        gicl_reserve_ds.shr_exp_res_amt%TYPE;
       v_trty_limit         giis_dist_share.trty_limit%TYPE;
       v_facul_amt          gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_net_amt            gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_treaty_amt         gicl_reserve_ds.shr_loss_res_amt%TYPE;
       v_qs_shr_pct         giis_dist_share.qs_shr_pct%TYPE;
       v_acct_trty_type     giis_dist_share.acct_trty_type%TYPE;
       v_share_cd           giis_dist_share.share_cd%TYPE;
       v_policy             VARCHAR2 (2000);
       counter              NUMBER                                    := 0;
       v_switch             NUMBER                                    := 0;
       v_policy_id          NUMBER;
       v_clm_dist_no        NUMBER                                    := 0;
       v_peril_sname        giis_peril.peril_sname%TYPE;
       v_trty_peril         giis_peril.peril_sname%TYPE;
       v_share_exist        VARCHAR2 (1);
       var_clm_dist_no      gicl_reserve_ds.clm_dist_no%TYPE;
    BEGIN
       var_clm_dist_no := NVL (var_clm_dist_no, 0) + 1;
       v_clm_dist_no := var_clm_dist_no;

       FOR c1 IN cur_clm_res
       LOOP
          BEGIN
             SELECT param_value_n
               INTO v_facul_share_cd
               FROM giis_parameters
              WHERE param_name = 'FACULTATIVE';
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                raise_application_error
                   (-20001,
                    'There is no existing FACULTATIVE parameter in GIIS_PARAMETERS table.'
                   );
          END;

          BEGIN
             SELECT param_value_v
               INTO v_trty_share_type
               FROM giac_parameters
              WHERE param_name = 'TRTY_SHARE_TYPE';
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                raise_application_error
                   (-20001,
                    'There is no existing TRTY_SHARE_TYPE parameter in GIAC_PARAMETERS table.'
                   );
          END;

          BEGIN
             SELECT param_value_v
               INTO v_facul_share_type
               FROM giac_parameters
              WHERE param_name = 'FACUL_SHARE_TYPE';
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                raise_application_error
                   (-20001,
                    'There is no existing FACUL_SHARE_TYPE parameter in GIAC_PARAMETERS table.'
                   );
          END;

          BEGIN
             SELECT param_value_n
               INTO v_acct_trty_type
               FROM giac_parameters
              WHERE param_name = 'QS_ACCT_TRTY_TYPE';
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                raise_application_error
                   (-20001,
                    'There is no existing QS_ACCT_TRTY_TYPE parameter in GIAC_PARAMETERS table.'
                   );
          END;

          BEGIN
             SELECT SUM (a.tsi_amt)
               INTO sum_tsi_amt
               FROM giri_basic_info_item_sum_v a, giuw_pol_dist b
              WHERE a.policy_id = b.policy_id
                AND TRUNC (DECODE (TRUNC (b.eff_date),
                                   TRUNC (a.eff_date), DECODE
                                                            (TRUNC (a.eff_date),
                                                             TRUNC (a.incept_date), p_pol_eff_date,
                                                             a.eff_date
                                                            ),
                                   b.eff_date
                                  )
                          ) <= p_loss_date
                AND TRUNC (DECODE (TRUNC (b.expiry_date),
                                   TRUNC (a.expiry_date), DECODE
                                                        (NVL (a.endt_expiry_date,
                                                              a.expiry_date
                                                             ),
                                                         a.expiry_date, p_expiry_date,
                                                         a.endt_expiry_date
                                                        ),
                                   b.expiry_date
                                  )
                          ) >= p_loss_date
                AND a.item_no = c1.item_no
                AND a.peril_cd = c1.peril_cd
                AND a.line_cd = p_line_cd
                AND a.subline_cd = p_subline_cd
                AND a.iss_cd = p_pol_iss_cd
                AND a.issue_yy = p_issue_yy
                AND a.pol_seq_no = p_pol_seq_no
                AND a.renew_no = p_renew_no
                AND b.dist_flag = (SELECT param_value_v
                                     FROM giis_parameters
                                    WHERE param_name = 'DISTRIBUTED');
          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                raise_application_error (-20001,
                                         'The TSI for this policy is Zero.'
                                        );
          END;

          DECLARE
             CURSOR quota_share_treaties
             IS
                SELECT trty_limit, qs_shr_pct, share_cd
                  FROM giis_dist_share
                 WHERE line_cd = p_line_cd
                   AND eff_date <= SYSDATE
                   AND expiry_date >= SYSDATE
                   AND acct_trty_type = v_acct_trty_type
                   AND qs_shr_pct IS NOT NULL;
          BEGIN
             FOR quota_share_rec IN quota_share_treaties
             LOOP
                BEGIN
                   SELECT quota_share_rec.trty_limit,
                          quota_share_rec.qs_shr_pct, quota_share_rec.share_cd
                     INTO v_trty_limit,
                          v_qs_shr_pct, v_share_cd
                     FROM DUAL;
                EXCEPTION
                   WHEN OTHERS
                   THEN
                      NULL;
                END;
             END LOOP;
          END;

          FOR me IN cur_perilds (c1.peril_cd, c1.item_no)
          LOOP
             IF me.acct_trty_type = v_acct_trty_type
             THEN
                v_switch := 1;
             ELSIF     (   (me.acct_trty_type = v_acct_trty_type)
                        OR (me.acct_trty_type IS NULL)
                       )
                   AND (v_switch <> 1)
             THEN
                v_switch := 0;
             END IF;
          END LOOP;

          SELECT peril_sname
            INTO v_peril_sname
            FROM giis_peril
           WHERE peril_cd = c1.peril_cd AND line_cd = p_line_cd;

          SELECT param_value_v
            INTO v_trty_peril
            FROM giac_parameters
           WHERE param_name = 'TRTY_PERIL';

          IF v_peril_sname = v_trty_peril
          THEN
             SELECT param_value_n
               INTO v_trty_limit
               FROM giac_parameters
              WHERE param_name = 'TRTY_PERIL_LIMIT';
          END IF;

          IF sum_tsi_amt > v_trty_limit
          THEN
             FOR i IN cur_perilds (c1.peril_cd, c1.item_no)
             LOOP
                IF i.share_type = v_facul_share_type
                THEN
                   v_facul_amt := sum_tsi_amt * (i.ann_dist_tsi / sum_tsi_amt);
                END IF;
             END LOOP;

             v_net_amt :=
                  (sum_tsi_amt - NVL (v_facul_amt, 0))
                * ((100 - v_qs_shr_pct) / 100);
             v_treaty_amt :=
                         (sum_tsi_amt - NVL (v_facul_amt, 0))
                       * (v_qs_shr_pct / 100);
          ELSE
             v_net_amt := sum_tsi_amt * ((100 - v_qs_shr_pct) / 100);
             v_treaty_amt := sum_tsi_amt * (v_qs_shr_pct / 100);
          END IF;

          FOR c2 IN cur_perilds (c1.peril_cd, c1.item_no)
          LOOP
             IF c2.share_type = v_trty_share_type
             THEN
                DECLARE
                   v_share_cd      giis_dist_share.share_cd%TYPE   := c2.share_cd;
                   v_treaty_yy2    giis_dist_share.trty_yy%TYPE     := c2.trty_yy;
                   v_prtf_sw       giis_dist_share.prtfolio_sw%TYPE;
                   v_acct_trty     giis_dist_share.acct_trty_type%TYPE;
                   v_share_type    giis_dist_share.share_type%TYPE;
                   v_expiry_date   giis_dist_share.expiry_date%TYPE;
                BEGIN
                   IF     NVL (c2.prtfolio_sw, 'N') = 'P'
                      AND TRUNC (c2.expiry_date) < TRUNC (SYSDATE)
                   THEN
                      WHILE TRUNC (c2.expiry_date) < TRUNC (SYSDATE)
                      LOOP
                         BEGIN
                            SELECT share_cd, trty_yy, NVL (prtfolio_sw, 'N'),
                                   acct_trty_type, share_type, expiry_date
                              INTO v_share_cd, v_treaty_yy2, v_prtf_sw,
                                   v_acct_trty, v_share_type, v_expiry_date
                              FROM giis_dist_share
                             WHERE line_cd = p_line_cd
                               AND old_trty_seq_no = c2.share_cd;
                         EXCEPTION
                            WHEN NO_DATA_FOUND
                            THEN
                               raise_application_error
                                             (-20001,
                                                 'No new treaty set-up for year '
                                              || TO_CHAR (SYSDATE, 'YYYY')
                                             );
                            WHEN TOO_MANY_ROWS
                            THEN
                               raise_application_error
                                           (-20001,
                                               'Too many treaty set-up for year '
                                            || TO_CHAR (SYSDATE, 'YYYY')
                                           );
                         END;

                         c2.share_cd := v_share_cd;
                         c2.share_type := v_share_type;
                         c2.acct_trty_type := v_acct_trty;
                         c2.trty_yy := v_treaty_yy2;
                         c2.expiry_date := v_expiry_date;

                         IF v_prtf_sw = 'N'
                         THEN
                            EXIT;
                         END IF;
                      END LOOP;
                   END IF;
                END;
             END IF;

             ann_dist_spct := 0;

             IF     (   (c2.acct_trty_type <> v_acct_trty_type)
                     OR (c2.acct_trty_type IS NULL)
                    )
                AND v_switch = 0
             THEN
                ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
                v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
                v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
             ELSE
                IF     (c2.share_type = v_trty_share_type)
                   AND (c2.share_cd = v_share_cd)
                THEN
                   ann_dist_spct := (v_treaty_amt / sum_tsi_amt) * 100;
                   v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
                   v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
                ELSIF     (c2.share_type != v_trty_share_type)
                      AND (c2.share_type != v_facul_share_type)
                      AND (v_net_amt IS NOT NULL)
                THEN
                   ann_dist_spct := (v_net_amt / sum_tsi_amt) * 100;
                   v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
                   v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
                ELSE
                   ann_dist_spct := (c2.ann_dist_tsi / sum_tsi_amt) * 100;
                   v_loss_res_amt := c1.loss_reserve * ann_dist_spct / 100;
                   v_exp_res_amt := c1.expense_reserve * ann_dist_spct / 100;
                END IF;
             END IF;

             v_share_exist := 'N';

             FOR i IN (SELECT '1'
                         FROM gicl_reserve_ds
                        WHERE claim_id = c1.claim_id
                          AND hist_seq_no = c1.hist_seq_no
                          AND item_no = c1.item_no
                          AND peril_cd = c1.peril_cd
                          AND grp_seq_no = c2.share_cd
                          AND line_cd = p_line_cd)
             LOOP
                v_share_exist := 'Y';
             END LOOP;

             IF ann_dist_spct <> 0
             THEN
                IF v_share_exist = 'N'
                THEN
                   INSERT INTO gicl_reserve_ds
                               (claim_id, clm_res_hist_id,
                                dist_year, clm_dist_no,
                                item_no, peril_cd, grp_seq_no,
                                share_type, shr_pct, shr_loss_res_amt,
                                shr_exp_res_amt, line_cd, acct_trty_type,
                                user_id, last_update, hist_seq_no, grouped_item_no --GROUPED_ITEM_NO Added by Jerome Bautista SR 21233 01.13.2016
                               )
                        VALUES (c1.claim_id, c1.clm_res_hist_id,
                                TO_CHAR (SYSDATE, 'YYYY'), v_clm_dist_no,
                                c1.item_no, c1.peril_cd, c2.share_cd,
                                c2.share_type, ann_dist_spct, v_loss_res_amt,
                                v_exp_res_amt, p_line_cd, c2.acct_trty_type,
                                /*USER,*/ p_user_id, SYSDATE, c1.hist_seq_no, p_grouped_item_no --Added GROUPED_ITEM_NO, USER changed to p_user_id - Jerome Bautista SR 21233 01.13.2016
                               );
                ELSE
                   UPDATE gicl_reserve_ds
                      SET shr_pct = NVL (shr_pct, 0) + NVL (ann_dist_spct, 0),
                          shr_loss_res_amt =
                                NVL (shr_loss_res_amt, 0)
                                + NVL (v_loss_res_amt, 0),
                          shr_exp_res_amt =
                                  NVL (shr_exp_res_amt, 0)
                                  + NVL (v_exp_res_amt, 0)
                    WHERE claim_id = c1.claim_id
                      AND hist_seq_no = c1.hist_seq_no
                      AND item_no = c1.item_no
                      AND peril_cd = c1.peril_cd
                      AND grp_seq_no = c2.share_cd
                      AND line_cd = p_line_cd;
                END IF;

                me := TO_NUMBER (c2.share_type) - TO_NUMBER (v_trty_share_type);

                IF me = 0
                THEN
                   FOR c_trty IN cur_trty (c2.share_cd, c2.trty_yy)
                   LOOP
                      IF v_share_exist = 'N'
                      THEN
                         INSERT INTO gicl_reserve_rids
                                     (claim_id, clm_res_hist_id,
                                      dist_year, clm_dist_no,
                                      item_no, peril_cd, grp_seq_no,
                                      share_type, ri_cd,
                                      shr_ri_pct,
                                      shr_ri_pct_real,
                                      shr_loss_ri_res_amt,
                                      shr_exp_ri_res_amt,
                                      line_cd, acct_trty_type,
                                      prnt_ri_cd, hist_seq_no
                                     )
                              VALUES (c1.claim_id, c1.clm_res_hist_id,
                                      TO_CHAR (SYSDATE, 'YYYY'), v_clm_dist_no,
                                      c1.item_no, c1.peril_cd, c2.share_cd,
                                      v_trty_share_type, c_trty.ri_cd,
                                      (ann_dist_spct * c_trty.trty_shr_pct / 100
                                      ),
                                      c_trty.trty_shr_pct,
                                      (v_loss_res_amt * c_trty.trty_shr_pct / 100
                                      ),
                                      (v_exp_res_amt * c_trty.trty_shr_pct / 100
                                      ),
                                      p_line_cd, c2.acct_trty_type,
                                      c_trty.prnt_ri_cd, c1.hist_seq_no
                                     );
                      ELSE
                         UPDATE gicl_reserve_rids
                            SET shr_exp_ri_res_amt =
                                     NVL (shr_exp_ri_res_amt, 0)
                                   + (  NVL (v_exp_res_amt, 0)
                                      * c_trty.trty_shr_pct
                                      / 100
                                     ),
                                shr_loss_ri_res_amt =
                                     NVL (shr_loss_ri_res_amt, 0)
                                   + (  NVL (v_loss_res_amt, 0)
                                      * c_trty.trty_shr_pct
                                      / 100
                                     ),
                                shr_ri_pct =
                                     NVL (shr_ri_pct, 0)
                                   + (  NVL (ann_dist_spct, 0)
                                      * c_trty.trty_shr_pct
                                      / 100
                                     )
                          WHERE claim_id = c1.claim_id
                            AND hist_seq_no = c1.hist_seq_no
                            AND item_no = c1.item_no
                            AND peril_cd = c1.peril_cd
                            AND grp_seq_no = c2.share_cd
                            AND ri_cd = c_trty.ri_cd
                            AND line_cd = p_line_cd;
                      END IF;
                   END LOOP;
                ELSIF c2.share_type = v_facul_share_type
                THEN
                   FOR c3 IN cur_frperil (c1.peril_cd, c1.item_no)
                   LOOP
                      IF    (c2.acct_trty_type <> v_acct_trty_type)
                         OR (c2.acct_trty_type IS NULL)
                      THEN
                         ann_ri_pct := (c3.sum_ri_tsi_amt / sum_tsi_amt) * 100;
                      ELSE
                         ann_ri_pct := (v_facul_amt / sum_tsi_amt) * 100;
                      END IF;

                      INSERT INTO gicl_reserve_rids
                                  (claim_id, clm_res_hist_id,
                                   dist_year, clm_dist_no,
                                   item_no, peril_cd, grp_seq_no,
                                   share_type, ri_cd, shr_ri_pct,
                                   shr_ri_pct_real,
                                   shr_loss_ri_res_amt,
                                   shr_exp_ri_res_amt,
                                   line_cd, acct_trty_type, prnt_ri_cd,
                                   hist_seq_no
                                  )
                           VALUES (c1.claim_id, c1.clm_res_hist_id,
                                   TO_CHAR (SYSDATE, 'YYYY'), v_clm_dist_no,
                                   c1.item_no, c1.peril_cd, c2.share_cd,
                                   v_facul_share_type, c3.ri_cd, ann_ri_pct,
                                   ann_ri_pct * 100 / ann_dist_spct,
                                   (c1.loss_reserve * ann_ri_pct / 100
                                   ),
                                   (c1.expense_reserve * ann_ri_pct / 100),
                                   p_line_cd, c2.acct_trty_type, c3.ri_cd,
                                   c1.hist_seq_no
                                  );
                   END LOOP;
                END IF;
             ELSE
                NULL;
             END IF;
          END LOOP;

          DECLARE
             v_retention               gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_retention_orig          gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_running_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_total_retention         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_allowed_retention       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_total_xol_share         gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_overall_xol_share       gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_overall_allowed_share   gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_old_xol_share           gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_allowed_ret             gicl_reserve_ds.shr_loss_res_amt%TYPE := 0;
             v_shr_pct                 gicl_reserve_ds.shr_pct%TYPE;
          BEGIN
             IF p_catastrophic_cd IS NULL
             THEN
                FOR net_shr IN (SELECT (shr_loss_res_amt * c1.convert_rate
                                       ) loss_reserve,
                                       (shr_exp_res_amt * c1.convert_rate
                                       ) exp_reserve,
                                       shr_pct
                                  FROM gicl_reserve_ds
                                 WHERE claim_id = c1.claim_id
                                   AND hist_seq_no = c1.hist_seq_no
                                   AND item_no = c1.item_no
                                   AND peril_cd = c1.peril_cd
                                   AND share_type = '1')
                LOOP
                   v_retention :=
                      NVL (net_shr.loss_reserve, 0)
                      + NVL (net_shr.exp_reserve, 0);
                   v_retention_orig :=
                      NVL (net_shr.loss_reserve, 0)
                      + NVL (net_shr.exp_reserve, 0);

                   FOR tot_net IN (SELECT SUM (  NVL (a.shr_loss_res_amt, 0)
                                               + NVL (a.shr_exp_res_amt, 0)
                                              ) ret_amt
                                     FROM gicl_reserve_ds a, gicl_item_peril b
                                    WHERE a.claim_id = c1.claim_id
                                      AND a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no
                                      AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                                      AND a.peril_cd = b.peril_cd
                                      AND NVL (b.close_flag, 'AP') IN
                                                               ('AP', 'CC', 'CP')
                                      AND NVL (a.negate_tag, 'N') = 'N'
                                      AND a.share_type = '1'
                                      AND (   a.item_no <> c1.item_no
                                           OR a.peril_cd <> c1.peril_cd
                                          ))
                   LOOP
                      v_total_retention := v_retention + NVL (tot_net.ret_amt, 0);
                   END LOOP;

                   FOR chk_xol IN (SELECT   a.share_cd, acct_trty_type,
                                            xol_allowed_amount, xol_base_amount,
                                            xol_reserve_amount, trty_yy,
                                            xol_aggregate_sum, a.line_cd,
                                            a.share_type
                                       FROM giis_dist_share a, giis_trty_peril b
                                      WHERE a.line_cd = b.line_cd
                                        AND a.share_cd = b.trty_seq_no
                                        AND a.share_type = '4'
                                        AND TRUNC (a.eff_date) <=
                                                               TRUNC (p_loss_date)
                                        AND TRUNC (a.expiry_date) >=
                                                               TRUNC (p_loss_date)
                                        AND b.peril_cd = c1.peril_cd
                                        AND a.line_cd = p_line_cd
                                   ORDER BY xol_base_amount ASC)
                   LOOP
                      v_allowed_retention :=
                                      v_total_retention - chk_xol.xol_base_amount;

                      IF v_allowed_retention < 1
                      THEN
                         EXIT;
                      END IF;

                      FOR get_all_xol IN
                         (SELECT SUM (  NVL (a.shr_loss_res_amt, 0)
                                      + NVL (a.shr_exp_res_amt, 0)
                                     ) ret_amt
                            FROM gicl_reserve_ds a, gicl_item_peril b
                           WHERE NVL (a.negate_tag, 'N') = 'N'
                             AND a.item_no = b.item_no
                             AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                             AND a.peril_cd = b.peril_cd
                             AND a.claim_id = b.claim_id
                             AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                             AND a.grp_seq_no = chk_xol.share_cd
                             AND a.line_cd = chk_xol.line_cd)
                      LOOP
                         v_overall_xol_share :=
                                  chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
                      END LOOP;

                      IF v_allowed_retention > v_overall_xol_share
                      THEN
                         v_allowed_retention := v_overall_xol_share;
                      END IF;

                      IF v_allowed_retention > v_retention
                      THEN
                         v_allowed_retention := v_retention;
                      END IF;

                      v_total_xol_share := 0;
                      v_old_xol_share := 0;

                      FOR total_xol IN
                         (SELECT SUM (  NVL (a.shr_loss_res_amt, 0)
                                      + NVL (a.shr_exp_res_amt, 0)
                                     ) ret_amt
                            FROM gicl_reserve_ds a, gicl_item_peril b
                           WHERE a.claim_id = c1.claim_id
                             AND a.claim_id = b.claim_id
                             AND a.item_no = b.item_no
                             AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                             AND a.peril_cd = b.peril_cd
                             AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                             AND NVL (a.negate_tag, 'N') = 'N'
                             AND a.grp_seq_no = chk_xol.share_cd)
                      LOOP
                         v_total_xol_share := NVL (total_xol.ret_amt, 0);
                         v_old_xol_share := NVL (total_xol.ret_amt, 0);
                      END LOOP;

                      IF v_total_xol_share <= chk_xol.xol_allowed_amount
                      THEN
                         v_total_xol_share :=
                                   chk_xol.xol_allowed_amount - v_total_xol_share;
                      END IF;

                      IF v_total_xol_share >= v_allowed_retention
                      THEN
                         v_total_xol_share := v_allowed_retention;
                      END IF;

                      IF v_total_xol_share <> 0
                      THEN
                         v_shr_pct := v_total_xol_share / v_retention_orig;
                         v_running_retention :=
                                          v_running_retention + v_total_xol_share;

                         INSERT INTO gicl_reserve_ds
                                     (claim_id, clm_res_hist_id,
                                      dist_year, clm_dist_no,
                                      item_no, peril_cd, grp_seq_no,
                                      share_type,
                                      shr_pct,
                                      shr_loss_res_amt,
                                      shr_exp_res_amt,
                                      line_cd, acct_trty_type, user_id,
                                      last_update, hist_seq_no
                                     )
                              VALUES (c1.claim_id, c1.clm_res_hist_id,
                                      TO_CHAR (SYSDATE, 'YYYY'), v_clm_dist_no,
                                      c1.item_no, c1.peril_cd, chk_xol.share_cd,
                                      chk_xol.share_type,
                                      net_shr.shr_pct * v_shr_pct,
                                      net_shr.loss_reserve * v_shr_pct,
                                      net_shr.exp_reserve * v_shr_pct,
                                      p_line_cd, chk_xol.acct_trty_type, /*USER,*/ p_user_id, --USER changed to p_user_id by Jerome Bautista SR 21233 01.21.2016
                                      SYSDATE, c1.hist_seq_no
                                     );

                         FOR update_xol_trty IN
                            (SELECT SUM (  (  NVL (a.shr_loss_res_amt, 0)
                                            * b.convert_rate
                                           )
                                         + (  NVL (shr_exp_res_amt, 0)
                                            * b.convert_rate
                                           )
                                        ) ret_amt
                               FROM gicl_reserve_ds a,
                                    gicl_clm_res_hist b,
                                    gicl_item_peril c
                              WHERE NVL (a.negate_tag, 'N') = 'N'
                                AND a.claim_id = b.claim_id
                                AND a.clm_res_hist_id = b.clm_res_hist_id
                                AND a.claim_id = c.claim_id
                                AND a.item_no = c.item_no
                                AND NVL (a.grouped_item_no, 0) =
                                                        NVL (c.grouped_item_no, 0)
                                AND a.peril_cd = c.peril_cd
                                AND DECODE (c.claim_id,
                                            p_claim_id, DECODE
                                                              (NVL (c.close_flag,
                                                                    'AP'
                                                                   ),
                                                               'DC', 'AP',
                                                               NVL (c.close_flag,
                                                                    'AP'
                                                                   )
                                                              ),
                                            NVL (c.close_flag, 'AP')
                                           ) IN ('AP', 'CC', 'CP')
                                AND a.grp_seq_no = chk_xol.share_cd
                                AND a.line_cd = chk_xol.line_cd)
                         LOOP
                            UPDATE giis_dist_share
                               SET xol_reserve_amount = update_xol_trty.ret_amt
                             WHERE share_cd = chk_xol.share_cd
                               AND line_cd = chk_xol.line_cd;
                         END LOOP;

                         FOR xol_trty IN cur_trty (chk_xol.share_cd,
                                                   chk_xol.trty_yy
                                                  )
                         LOOP
                            INSERT INTO gicl_reserve_rids
                                        (claim_id, clm_res_hist_id,
                                         dist_year,
                                         clm_dist_no, item_no, peril_cd,
                                         grp_seq_no, share_type,
                                         ri_cd,
                                         shr_ri_pct,
                                         shr_ri_pct_real,
                                         shr_loss_ri_res_amt,
                                         shr_exp_ri_res_amt,
                                         line_cd, acct_trty_type,
                                         prnt_ri_cd, hist_seq_no
                                        )
                                 VALUES (c1.claim_id, c1.clm_res_hist_id,
                                         TO_CHAR (SYSDATE, 'YYYY'),
                                         v_clm_dist_no, c1.item_no, c1.peril_cd,
                                         chk_xol.share_cd, chk_xol.share_type,
                                         xol_trty.ri_cd,
                                         (  (net_shr.shr_pct * v_shr_pct)
                                          * (xol_trty.trty_shr_pct / 100)
                                         ),
                                         xol_trty.trty_shr_pct,
                                         (  (net_shr.loss_reserve * v_shr_pct)
                                          * (xol_trty.trty_shr_pct / 100)
                                         ),
                                         (  (net_shr.exp_reserve * v_shr_pct)
                                          * (xol_trty.trty_shr_pct / 100)
                                         ),
                                         p_line_cd, chk_xol.acct_trty_type,
                                         xol_trty.prnt_ri_cd, c1.hist_seq_no
                                        );
                         END LOOP;
                      END IF;

                      v_retention := v_retention - v_total_xol_share;
                      v_total_retention := v_total_retention + v_old_xol_share;
                   END LOOP;                                             --CHK_XOL
                END LOOP;                                               -- NET_SHR
             ELSE
                FOR net_shr IN (SELECT (shr_loss_res_amt * c1.convert_rate
                                       ) loss_reserve,
                                       (shr_exp_res_amt * c1.convert_rate
                                       ) exp_reserve,
                                       shr_pct
                                  FROM gicl_reserve_ds
                                 WHERE claim_id = c1.claim_id
                                   AND hist_seq_no = c1.hist_seq_no
                                   AND item_no = c1.item_no
                                   AND peril_cd = c1.peril_cd
                                   AND share_type = '1')
                LOOP
                   v_retention :=
                      NVL (net_shr.loss_reserve, 0)
                      + NVL (net_shr.exp_reserve, 0);
                   v_retention_orig :=
                      NVL (net_shr.loss_reserve, 0)
                      + NVL (net_shr.exp_reserve, 0);

                   FOR tot_net IN (SELECT SUM (  NVL (shr_loss_res_amt, 0)
                                               + NVL (shr_exp_res_amt, 0)
                                              ) ret_amt
                                     FROM gicl_reserve_ds a,
                                          gicl_claims c,
                                          gicl_item_peril b
                                    WHERE a.claim_id = c.claim_id
                                      AND a.claim_id = b.claim_id
                                      AND a.item_no = b.item_no
                                      AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                                      AND a.peril_cd = b.peril_cd
                                      AND NVL (b.close_flag, 'AP') IN
                                                               ('AP', 'CC', 'CP')
                                      AND c.catastrophic_cd = p_catastrophic_cd
                                      AND NVL (negate_tag, 'N') = 'N'
                                      AND share_type = '1'
                                      AND (   a.claim_id <> p_claim_id
                                           OR a.item_no <> c1.item_no
                                           OR a.peril_cd <> c1.peril_cd
                                          ))
                   LOOP
                      v_total_retention := v_retention + NVL (tot_net.ret_amt, 0);
                   END LOOP;

                   FOR chk_xol IN (SELECT   a.share_cd, acct_trty_type,
                                            xol_allowed_amount, xol_base_amount,
                                            xol_reserve_amount, trty_yy,
                                            xol_aggregate_sum, a.line_cd,
                                            a.share_type
                                       FROM giis_dist_share a, giis_trty_peril b
                                      WHERE a.line_cd = b.line_cd
                                        AND a.share_cd = b.trty_seq_no
                                        AND a.share_type = '4'
                                        AND TRUNC (a.eff_date) <=
                                                               TRUNC (p_loss_date)
                                        AND TRUNC (a.expiry_date) >=
                                                               TRUNC (p_loss_date)
                                        AND b.peril_cd = c1.peril_cd
                                        AND a.line_cd = p_line_cd
                                   ORDER BY xol_base_amount ASC)
                   LOOP
                      v_allowed_retention :=
                                      v_total_retention - chk_xol.xol_base_amount;

                      IF v_allowed_retention < 1
                      THEN
                         EXIT;
                      END IF;

                      FOR get_all_xol IN
                         (SELECT SUM (  NVL (shr_loss_res_amt, 0)
                                      + NVL (shr_exp_res_amt, 0)
                                     ) ret_amt
                            FROM gicl_reserve_ds a, gicl_item_peril b
                           WHERE NVL (negate_tag, 'N') = 'N'
                             AND a.claim_id = b.claim_id
                             AND a.item_no = b.item_no
                             AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                             AND a.peril_cd = b.peril_cd
                             AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                             AND grp_seq_no = chk_xol.share_cd
                             AND a.line_cd = chk_xol.line_cd)
                      LOOP
                         v_overall_xol_share :=
                                  chk_xol.xol_aggregate_sum - get_all_xol.ret_amt;
                      END LOOP;

                      IF v_allowed_retention > v_overall_xol_share
                      THEN
                         v_allowed_retention := v_overall_xol_share;
                      END IF;

                      IF v_allowed_retention > v_retention
                      THEN
                         v_allowed_retention := v_retention;
                      END IF;

                      v_total_xol_share := 0;
                      v_old_xol_share := 0;

                      FOR total_xol IN
                         (SELECT SUM (  NVL (shr_loss_res_amt, 0)
                                      + NVL (shr_exp_res_amt, 0)
                                     ) ret_amt
                            FROM gicl_reserve_ds a,
                                 gicl_claims c,
                                 gicl_item_peril b
                           WHERE c.claim_id = a.claim_id
                             AND a.claim_id = b.claim_id
                             AND a.item_no = b.item_no
                             AND NVL (a.grouped_item_no, 0) =
                                                        NVL (b.grouped_item_no, 0)
                             AND a.peril_cd = b.peril_cd
                             AND NVL (b.close_flag, 'AP') IN ('AP', 'CC', 'CP')
                             AND c.catastrophic_cd = p_catastrophic_cd
                             AND NVL (negate_tag, 'N') = 'N'
                             AND grp_seq_no = chk_xol.share_cd)
                      LOOP
                         v_total_xol_share := NVL (total_xol.ret_amt, 0);
                         v_old_xol_share := NVL (total_xol.ret_amt, 0);
                      END LOOP;

                      IF v_total_xol_share <= chk_xol.xol_allowed_amount
                      THEN
                         v_total_xol_share :=
                                   chk_xol.xol_allowed_amount - v_total_xol_share;
                      END IF;

                      IF v_total_xol_share >= v_allowed_retention
                      THEN
                         v_total_xol_share := v_allowed_retention;
                      END IF;

                      IF v_total_xol_share <> 0
                      THEN
                         v_shr_pct := v_total_xol_share / v_retention_orig;
                         v_running_retention :=
                                          v_running_retention + v_total_xol_share;

                         INSERT INTO gicl_reserve_ds
                                     (claim_id, clm_res_hist_id,
                                      dist_year, clm_dist_no,
                                      item_no, peril_cd, grp_seq_no,
                                      share_type,
                                      shr_pct,
                                      shr_loss_res_amt,
                                      shr_exp_res_amt,
                                      line_cd, acct_trty_type, user_id,
                                      last_update, hist_seq_no
                                     )
                              VALUES (c1.claim_id, c1.clm_res_hist_id,
                                      TO_CHAR (SYSDATE, 'YYYY'), v_clm_dist_no,
                                      c1.item_no, c1.peril_cd, chk_xol.share_cd,
                                      chk_xol.share_type,
                                      net_shr.shr_pct * v_shr_pct,
                                      net_shr.loss_reserve * v_shr_pct,
                                      net_shr.exp_reserve * v_shr_pct,
                                      p_line_cd, chk_xol.acct_trty_type, /*USER,*/ p_user_id, --USER changed to p_user_id by Jerome Bautista SR 21233 01.21.2016
                                      SYSDATE, c1.hist_seq_no
                                     );

                         FOR update_xol_trty IN
                            (SELECT SUM (  (  NVL (a.shr_loss_res_amt, 0)
                                            * b.convert_rate
                                           )
                                         + (  NVL (shr_exp_res_amt, 0)
                                            * b.convert_rate
                                           )
                                        ) ret_amt
                               FROM gicl_reserve_ds a,
                                    gicl_clm_res_hist b,
                                    gicl_item_peril c
                              WHERE NVL (a.negate_tag, 'N') = 'N'
                                AND a.claim_id = b.claim_id
                                AND a.clm_res_hist_id = b.clm_res_hist_id
                                AND a.claim_id = c.claim_id
                                AND a.item_no = c.item_no
                                AND NVL (a.grouped_item_no, 0) =
                                                        NVL (c.grouped_item_no, 0)
                                AND a.peril_cd = c.peril_cd
                                AND DECODE (c.claim_id,
                                            p_claim_id, DECODE
                                                              (NVL (c.close_flag,
                                                                    'AP'
                                                                   ),
                                                               'DC', 'AP',
                                                               NVL (c.close_flag,
                                                                    'AP'
                                                                   )
                                                              ),
                                            NVL (c.close_flag, 'AP')
                                           ) IN ('AP', 'CC', 'CP')
                                AND a.grp_seq_no = chk_xol.share_cd
                                AND a.line_cd = chk_xol.line_cd)
                         LOOP
                            UPDATE giis_dist_share
                               SET xol_reserve_amount = update_xol_trty.ret_amt
                             WHERE share_cd = chk_xol.share_cd
                               AND line_cd = chk_xol.line_cd;
                         END LOOP;

                         FOR xol_trty IN cur_trty (chk_xol.share_cd,
                                                   chk_xol.trty_yy
                                                  )
                         LOOP
                            INSERT INTO gicl_reserve_rids
                                        (claim_id, clm_res_hist_id,
                                         dist_year,
                                         clm_dist_no, item_no, peril_cd,
                                         grp_seq_no, share_type,
                                         ri_cd,
                                         shr_ri_pct,
                                         shr_ri_pct_real,
                                         shr_loss_ri_res_amt,
                                         shr_exp_ri_res_amt,
                                         line_cd, acct_trty_type,
                                         prnt_ri_cd, hist_seq_no
                                        )
                                 VALUES (c1.claim_id, c1.clm_res_hist_id,
                                         TO_CHAR (SYSDATE, 'YYYY'),
                                         v_clm_dist_no, c1.item_no, c1.peril_cd,
                                         chk_xol.share_cd, chk_xol.share_type,
                                         xol_trty.ri_cd,
                                         (  (net_shr.shr_pct * v_shr_pct)
                                          * (xol_trty.trty_shr_pct / 100)
                                         ),
                                         xol_trty.trty_shr_pct,
                                         (  (net_shr.loss_reserve * v_shr_pct)
                                          * (xol_trty.trty_shr_pct / 100)
                                         ),
                                         (  (net_shr.exp_reserve * v_shr_pct)
                                          * (xol_trty.trty_shr_pct / 100)
                                         ),
                                         p_line_cd, chk_xol.acct_trty_type,
                                         xol_trty.prnt_ri_cd, c1.hist_seq_no
                                        );
                         END LOOP;
                      END IF;

                      v_retention := v_retention - v_total_xol_share;
                      v_total_retention := v_total_retention + v_old_xol_share;
                   END LOOP;
                END LOOP;
             END IF;

             IF v_retention = 0
             THEN
                DELETE FROM gicl_reserve_ds
                      WHERE claim_id = c1.claim_id
                        AND hist_seq_no = c1.hist_seq_no
                        AND item_no = c1.item_no
                        AND peril_cd = c1.peril_cd
                        AND share_type = '1';
             ELSIF v_retention <> v_retention_orig
             THEN
                UPDATE gicl_reserve_ds
                   SET shr_loss_res_amt =
                            shr_loss_res_amt
                          * (v_retention_orig - v_running_retention)
                          / v_retention_orig,
                       shr_exp_res_amt =
                            shr_exp_res_amt
                          * (v_retention_orig - v_running_retention)
                          / v_retention_orig,
                       shr_pct =
                            shr_pct
                          * (v_retention_orig - v_running_retention)
                          / v_retention_orig
                 WHERE claim_id = c1.claim_id
                   AND hist_seq_no = c1.hist_seq_no
                   AND item_no = c1.item_no
                   AND peril_cd = c1.peril_cd
                   AND share_type = '1';
             END IF;
          END;

          UPDATE gicl_clm_res_hist
             SET dist_sw = 'Y'
           WHERE CURRENT OF cur_clm_res;

          UPDATE gicl_clm_res_hist
             SET dist_sw = 'Y'
           WHERE CURRENT OF cur_clm_res;
       END LOOP;

       offset_amt (v_clm_dist_no, p_claim_id, p_clm_res_hist_id);
    END;

    PROCEDURE REOPEN_CLAIMS(
     p_claim_id                     gicl_clm_res_hist.claim_id%type,
     p_refresh_sw                gicl_claims.refresh_sw%type,
     p_max_endt_seq_no           gicl_claims.max_endt_seq_no%TYPE,
     p_dsp_loss_date             gicl_claims.dsp_loss_date%TYPE,
     p_pol_eff_date              gicl_claims.pol_eff_date%TYPE,
     p_line_cd                   gicl_claims.line_cd%TYPE,
     p_subline_cd                gicl_claims.subline_cd%TYPE,
     p_pol_iss_cd                gicl_claims.iss_cd%TYPE,
     p_issue_yy                  gicl_claims.issue_yy%TYPE,
     p_pol_seq_no                gicl_claims.pol_seq_no%TYPE,
     p_renew_no                  gicl_claims.renew_no%TYPE,
     p_assd_no                   gicl_claims.assd_no%TYPE,      -- FOR EXTRACT_LATEST_ASSURED
     p_acct_of_cd                gicl_claims.acct_of_cd%TYPE,
     p_assured_name              gicl_claims.assured_name%TYPE,
     p_assd_name2                gicl_claims.assd_name2%TYPE,
     p_user_id                   gicl_claims.user_id%TYPE
     )

    IS
        v_old_stat_cd     VARCHAR2(2);
        v_chk_spld       VARCHAR2(1) := 'N';
        v_line_cd        gicl_claims.line_cd%TYPE;
    BEGIN
        
    
        BEGIN
           SELECT clm_stat_cd, line_cd
             INTO v_old_stat_cd, v_line_cd
             FROM gicl_claims
            WHERE claim_id = p_claim_id;
        EXCEPTION
            WHEN OTHERS THEN
               v_old_stat_cd := 'NW';
        END;
        
        FOR pol_flag IN (SELECT a.pol_flag
                           FROM gipi_polbasic a, gicl_claims b
                          WHERE b.claim_id = p_claim_id
                            AND a.line_cd = b.line_cd
                            AND a.subline_cd = b.subline_cd
                            AND a.iss_cd = b.pol_iss_cd
                            AND a.issue_yy = b.issue_yy
                            AND a.pol_seq_no = b.pol_seq_no
                            AND a.renew_no = b.renew_no
                            AND NVL(a.endt_seq_no,0) > 0
                            AND a.pol_flag = '5'
                            AND TRUNC(a.eff_date) <= TRUNC(p_dsp_loss_date))
        LOOP
            v_chk_spld := 'Y';
            EXIT;
        END LOOP;
        
        -- Updates close_flag and close_date of gicl_item_peril upon re-opening of claim.
        UPDATE GICL_ITEM_PERIL
           SET close_flag = 'AP',
               close_date = NULL
        WHERE  claim_id = p_claim_id
          AND  close_flag IN ('CC', 'DC');

        UPDATE GICL_ITEM_PERIL
           SET close_flag2 = 'AP',
               close_date2 = NULL
         WHERE claim_id = p_claim_id
           AND close_flag2 IN ('CC', 'DC');
         -- End
         
         --   update reserve amounts of claim by summing its reserve
         --   amount form gicl_reserve table
         --   amount of reserve should only be from valid item peril
         --   those that are not withdrawn cancelled or denied
         FOR sum_res IN (SELECT SUM(loss_reserve) loss_reserve,
                                SUM(expense_reserve) exp_reserve
                           FROM gicl_clm_reserve a, gicl_item_peril b
                          WHERE a.claim_id = b.claim_id
                            AND a.item_no  = b.item_no
                            AND nvl(a.grouped_item_no,0) = nvl(b.grouped_item_no,0)
                            AND a.peril_cd = b.peril_cd
                            AND a.claim_id = p_claim_id
                            AND NVL(b.close_flag, 'AP') IN ('AP','CC','CP'))
         LOOP
           UPDATE gicl_claims
              SET loss_res_amt = sum_res.loss_reserve,
                  exp_res_amt  = sum_res.exp_reserve
            WHERE claim_id = p_claim_id;
             EXIT;
         END LOOP; --end loop sum_res
         
         IF NVL(v_chk_spld, 'N') = 'Y' AND NVL(p_refresh_sw, 'N') = 'Y'  THEN
            GICL_CLAIMS_PKG.UPDATE_SPOILED(p_claim_id, p_max_endt_seq_no, p_dsp_loss_date, p_pol_eff_date, 
                                           NVL(p_line_cd, v_line_cd), p_subline_cd, p_pol_iss_cd, p_issue_yy,
                                           p_pol_seq_no, p_renew_no, p_assd_no ,p_acct_of_cd, p_assured_name, 
                                           p_assd_name2);
         ELSIF NVL(p_refresh_sw, 'N') = 'Y' THEN
            GICL_CLAIMS_PKG.UPDATE_ENDT_INFO(p_claim_id, p_max_endt_seq_no, p_dsp_loss_date, p_pol_eff_date, 
                                             NVL(p_line_cd, v_line_cd),  p_subline_cd,  p_pol_iss_cd, p_issue_yy, 
                                             p_pol_seq_no, p_renew_no, p_assd_no ,p_acct_of_cd, p_assured_name, 
                                             p_assd_name2);
         END IF;
         
         UPDATE gicl_claims
            SET user_id =  p_user_id,
                last_update = SYSDATE,
                clm_setl_date = NULL,
                close_date = NULL,
                clm_stat_cd = NVL (v_old_stat_cd, 'NW'),
                old_stat_cd = v_old_stat_cd
          WHERE claim_id = p_claim_id;
    END;

    PROCEDURE UPDATE_SPOILED (
     p_claim_id              gicl_claims.claim_id%TYPE,
     p_max_endt_seq_no       gicl_claims.max_endt_seq_no%TYPE,
     p_dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
     p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,  -- FOR UPDATE_EXPIRY
     p_line_cd               gicl_claims.line_cd%TYPE,
     p_subline_cd            gicl_claims.subline_cd%TYPE,
     p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
     p_issue_yy              gicl_claims.issue_yy%TYPE,
     p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
     p_renew_no              gicl_claims.renew_no%TYPE,
     p_assd_no               gicl_claims.assd_no%TYPE,      -- FOR EXTRACT_LATEST_ASSURED
     p_acct_of_cd            gicl_claims.acct_of_cd%TYPE,
     p_assured_name          gicl_claims.assured_name%TYPE,
     p_assd_name2            gicl_claims.assd_name2%TYPE
     )

    IS

    v_expiry_date        gipi_polbasic.expiry_date%TYPE;
    v_incept_date        gipi_polbasic.incept_date%TYPE;
    v_vessel_cd          gipi_cargo.vessel_cd%TYPE;
    v_pol_vessel         gipi_cargo.vessel_cd%TYPE;
    v_exist              VARCHAR2(1) := 'N';
    al_button            NUMBER;
    v_ah_grouped_item_no gicl_accident_dtl.grouped_item_no%TYPE;

    BEGIN

    UPDATE_EXPIRY (v_expiry_date, v_incept_date, p_dsp_loss_date, p_pol_eff_date,
                      p_line_cd, p_subline_cd, p_pol_iss_cd,
                      p_issue_yy, p_pol_seq_no, p_renew_no,
                      p_claim_id);



    EXTRACT_LATEST_ASSURED (v_incept_date, v_expiry_date, p_dsp_loss_date,
                            NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                            p_pol_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_claim_id,
                            p_assd_no ,p_acct_of_cd, p_assured_name, p_assd_name2);

    FOR itm IN (SELECT DISTINCT item_no, grouped_item_no
                        FROM gicl_clm_item
                         WHERE claim_id = p_claim_id)
    LOOP
    IF p_line_cd = GIISP.V('LINE_CODE_MC') THEN
         extract_latest_mc_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

    ELSIF p_line_cd = GIISP.V('LINE_CODE_FI') THEN
       extract_latest_fi_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

    ELSIF p_line_cd = GIISP.V('LINE_CODE_AV') THEN
       extract_latest_av_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

    ELSIF p_line_cd = GIISP.V('LINE_CODE_MN') THEN
         extract_latest_mn_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

       FOR ves IN (SELECT param_value_v
                             FROM giis_parameters
                          WHERE param_name = 'VESSEL_CD_MULTI')
       LOOP
         v_vessel_cd := ves.param_value_v;
       END LOOP;

       FOR c IN (SELECT a.vessel_cd
                         FROM gipi_cargo a, gipi_item b, gipi_polbasic c
                      WHERE a.policy_id = b.policy_id
                            AND a.item_no = b.item_no
                            AND b.policy_id = c.policy_id
                            AND a.item_no = itm.item_no
                            AND c.line_cd = p_line_cd
                          AND c.subline_cd = p_subline_cd
                          AND c.iss_cd = p_pol_iss_cd
                          AND c.issue_yy = p_issue_yy
                            AND c.pol_seq_no = p_pol_seq_no
                            AND c.renew_no = p_renew_no)
       LOOP
         v_pol_vessel := c.vessel_cd;
       END LOOP;

       IF v_pol_vessel = v_vessel_cd THEN
          extract_latest_mn_multi (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                   -1, p_line_cd, p_subline_cd,
                                   p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                   p_renew_no, p_claim_id, itm.item_no, v_pol_vessel);
       END IF;

    ELSIF p_line_cd = GIISP.V('LINE_CODE_MH') THEN
         extract_latest_mh_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                 -1, p_line_cd, p_subline_cd,
                                 p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

    ELSIF p_line_cd = GIISP.V('LINE_CODE_CA') THEN
         extract_latest_ca_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                 -1, p_line_cd, p_subline_cd,
                                 p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

       extract_latest_ca_prnl (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

       extract_latest_ca_benf (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

       FOR grp IN (SELECT grouped_item_no
                             FROM gicl_casualty_dtl
                            WHERE claim_id = p_claim_id
                                AND item_no = itm.item_no)
       LOOP
         IF (grp.grouped_item_no != 0) AND (grp.grouped_item_no IS NOT NULL) THEN
            extract_latest_ca_grouped (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                       -1, p_line_cd, p_subline_cd,
                                       p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                       p_renew_no, p_claim_id, itm.item_no, grp.grouped_item_no);
         END IF;
       END LOOP;

    ELSIF p_line_cd = GIISP.V('LINE_CODE_AC') THEN
       FOR grp IN (SELECT grouped_item_no
                             FROM GICL_ACCIDENT_DTL
                            WHERE claim_id = p_claim_id
                                AND item_no = itm.item_no)
       LOOP
         IF (grp.grouped_item_no != 0) AND (grp.grouped_item_no IS NOT NULL) THEN
            v_exist := 'Y';
            v_ah_grouped_item_no := grp.grouped_item_no;
         END IF;
       END LOOP;

       IF v_exist = 'N' THEN
          extract_latest_ah_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                  -1, p_line_cd, p_subline_cd,
                                    p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                  p_renew_no, p_claim_id, itm.item_no);
          extract_latest_ah_ben (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                 -1, p_line_cd, p_subline_cd,
                                 p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                 p_renew_no, p_claim_id, itm.item_no);
       ELSE
          extract_latest_ah_grp (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                 -1, p_line_cd, p_subline_cd,
                                   p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                 p_renew_no, p_claim_id, itm.item_no, v_ah_grouped_item_no);

          extract_latest_ah_ben_grp (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                     -1, p_line_cd, p_subline_cd,
                                     p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                     p_renew_no, p_claim_id, itm.item_no,
                                     v_ah_grouped_item_no);

       END IF;

    ELSIF p_line_cd = GIISP.V('LINE_CODE_EN') THEN
       extract_latest_en_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                               -1, p_line_cd, p_subline_cd,
                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                               p_renew_no, p_claim_id, itm.item_no);

    ELSE
         EXTRACT_OTHER_DTL (v_expiry_date, v_incept_date, p_dsp_loss_date,
                          -1, p_line_cd, p_subline_cd,
                          p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                          p_renew_no, p_claim_id, itm.item_no);
    END IF;

        FOR prl IN (SELECT peril_cd
                                FROM gicl_item_peril
                                 WHERE claim_id = p_claim_id
                                 AND item_no = itm.item_no
                                 AND nvl(grouped_item_no,0) = nvl(Itm.grouped_item_no,0))
        LOOP
            EXTRACT_LATEST_PERIL (v_expiry_date, v_incept_date, p_dsp_loss_date,-1,
                                  p_line_cd, p_subline_cd, p_pol_iss_cd,
                                  p_issue_yy, p_pol_seq_no,
                                p_renew_no, p_claim_id, itm.item_no, prl.peril_cd);

        END LOOP;
    END LOOP;

    UPDATE gicl_claims
     SET refresh_sw = 'N'
    WHERE claim_id = p_claim_id;

    END;

    PROCEDURE UPDATE_ENDT_INFO(
     p_claim_id              gicl_claims.claim_id%TYPE,
     p_max_endt_seq_no       gicl_claims.max_endt_seq_no%TYPE,
     p_dsp_loss_date         gicl_claims.dsp_loss_date%TYPE,
     p_pol_eff_date          gicl_claims.pol_eff_date%TYPE,
     p_line_cd               gicl_claims.line_cd%TYPE,
     p_subline_cd            gicl_claims.subline_cd%TYPE,
     p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
     p_issue_yy              gicl_claims.issue_yy%TYPE,
     p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
     p_renew_no              gicl_claims.renew_no%TYPE,
     p_assd_no               gicl_claims.assd_no%TYPE,
     p_acct_of_cd            gicl_claims.acct_of_cd%TYPE,
     p_assured_name          gicl_claims.assured_name%TYPE,
     p_assd_name2            gicl_claims.assd_name2%TYPE
     )

    IS

    v_expiry_date        gipi_polbasic.expiry_date%TYPE;
    v_incept_date        gipi_polbasic.incept_date%TYPE;
    v_vessel_cd          gipi_cargo.vessel_cd%TYPE;
    v_pol_vessel         gipi_cargo.vessel_cd%TYPE;
    v_exist              VARCHAR2(1) := 'N';
    al_button            NUMBER;
    v_ah_grouped_item_no gicl_accident_dtl.grouped_item_no%TYPE;

    BEGIN
      EXTRACT_LATEST_POLICY_TERM(v_expiry_date, v_incept_date, p_dsp_loss_date, p_pol_eff_date, NVL(p_max_endt_seq_no,-1),
                                 p_line_cd, p_subline_cd, p_pol_iss_cd, p_issue_yy,
                                 p_pol_seq_no, p_renew_no, p_claim_id);



      EXTRACT_LATEST_ASSURED (v_incept_date, v_expiry_date, p_dsp_loss_date,
                              NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                              p_pol_iss_cd, p_issue_yy, p_pol_seq_no, p_renew_no, p_claim_id,
                              p_assd_no ,p_acct_of_cd, p_assured_name, p_assd_name2);




      FOR itm IN (SELECT DISTINCT(item_no) item_no
                    FROM gicl_clm_item
                   WHERE claim_id = p_claim_id)
      LOOP
        IF p_line_cd = GIISP.V('LINE_CODE_MC') THEN
             extract_latest_mc_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                   NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                   p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                   p_renew_no, p_claim_id, itm.item_no);

        ELSIF p_line_cd = GIISP.V('LINE_CODE_FI') THEN
                 extract_latest_fi_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                   NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                     p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                   p_renew_no, p_claim_id, itm.item_no);

        ELSIF p_line_cd = GIISP.V('LINE_CODE_AV') THEN

           extract_latest_av_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                   NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                   p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                   p_renew_no, p_claim_id, itm.item_no);

        ELSIF p_line_cd = GIISP.V('LINE_CODE_MN') THEN

             extract_latest_mn_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                     NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                     p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                   p_renew_no, p_claim_id, itm.item_no);

           FOR ves IN (SELECT param_value_v
                         FROM giis_parameters
                        WHERE param_name = 'VESSEL_CD_MULTI')
           LOOP
             v_vessel_cd := ves.param_value_v;
           END LOOP;

           FOR c IN (SELECT a.vessel_cd
                       FROM gipi_cargo a, gipi_item b, gipi_polbasic c
                      WHERE a.policy_id = b.policy_id
                        AND a.item_no = b.item_no
                        AND b.policy_id = c.policy_id
                        AND a.item_no = itm.item_no
                        AND c.line_cd = p_line_cd
                        AND c.subline_cd = p_subline_cd
                        AND c.iss_cd = p_pol_iss_cd
                        AND c.issue_yy = p_issue_yy
                        AND c.pol_seq_no = p_pol_seq_no
                        AND c.renew_no = p_renew_no)
           LOOP
                     v_pol_vessel := c.vessel_cd;
           END LOOP;

           IF v_pol_vessel = v_vessel_cd THEN

              extract_latest_mn_multi (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                       NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                       p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                       p_renew_no, p_claim_id, itm.item_no, v_pol_vessel);
            END IF;

         ELSIF p_line_cd = GIISP.V('LINE_CODE_MH') THEN

            extract_latest_mh_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                      NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                      p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                    p_renew_no, p_claim_id, itm.item_no);

         ELSIF p_line_cd = GIISP.V('LINE_CODE_CA') THEN

            extract_latest_ca_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                    NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                    p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                    p_renew_no, p_claim_id, itm.item_no);

            extract_latest_ca_prnl (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                     NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                     p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                     p_renew_no, p_claim_id, itm.item_no);

            extract_latest_ca_benf (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                     NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                     p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                     p_renew_no, p_claim_id, itm.item_no);

            FOR grp IN (SELECT grouped_item_no
                          FROM gicl_casualty_dtl
                         WHERE claim_id = p_claim_id
                           AND item_no = itm.item_no)
            LOOP
              IF (grp.grouped_item_no != 0) AND (grp.grouped_item_no IS NOT NULL) THEN

                  extract_latest_ca_grouped (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                             NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                             p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                             p_renew_no, p_claim_id, itm.item_no, grp.grouped_item_no);
              END IF;

            END LOOP;

         ELSIF p_line_cd = GIISP.V('LINE_CODE_AC') THEN

            FOR grp IN (SELECT grouped_item_no
                          FROM GICL_ACCIDENT_DTL
                         WHERE claim_id = p_claim_id
                           AND item_no = itm.item_no)
            LOOP
                IF (grp.grouped_item_no != 0) AND (grp.grouped_item_no IS NOT NULL) THEN
                  v_exist := 'Y';
                  v_ah_grouped_item_no := grp.grouped_item_no;
              END IF;
            END LOOP;

            IF v_exist = 'N' THEN
                extract_latest_ah_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                          NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                          p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                        p_renew_no, p_claim_id, itm.item_no);

                extract_latest_ah_ben (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                       NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                       p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                       p_renew_no, p_claim_id, itm.item_no);

            ELSE

                extract_latest_ah_grp (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                                  NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                                  p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                                p_renew_no, p_claim_id, itm.item_no, v_ah_grouped_item_no);

                        extract_latest_ah_ben_grp (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                               NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                               p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                               p_renew_no, p_claim_id, itm.item_no,
                                               v_ah_grouped_item_no);

                     END IF;

                ELSIF p_line_cd = GIISP.V('LINE_CODE_EN') THEN

                   extract_latest_en_data (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                             NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                             p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                           p_renew_no, p_claim_id, itm.item_no);

                ELSE

                     EXTRACT_OTHER_DTL (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                        NVL(p_max_endt_seq_no,-1), p_line_cd, p_subline_cd,
                                        p_pol_iss_cd, p_issue_yy, p_pol_seq_no,
                                      p_renew_no, p_claim_id, itm.item_no);

                END IF;

      FOR prl IN (SELECT peril_cd
                    FROM gicl_item_peril
                   WHERE claim_id = p_claim_id
                     AND item_no = itm.item_no
                     AND nvl(grouped_item_no,0) = nvl(v_ah_grouped_item_no,0))--EMCY da091306te: added GPA
      LOOP

        EXTRACT_LATEST_PERIL (v_expiry_date, v_incept_date, p_dsp_loss_date,
                                                    NVL(p_max_endt_seq_no,-1), p_line_cd,
                                                    p_subline_cd, p_pol_iss_cd, p_issue_yy,
                                                    p_pol_seq_no, p_renew_no, p_claim_id,
                                                    itm.item_no, prl.peril_cd);

      END LOOP;
              END LOOP;
              FOR endt IN (SELECT MAX(endt_seq_no) endt_seq_no
                             FROM gipi_polbasic
                            WHERE line_cd = p_line_cd
                              AND subline_cd = p_subline_cd
                              AND iss_cd = p_pol_iss_cd
                              AND issue_yy = p_issue_yy
                              AND pol_seq_no = p_pol_seq_no
                              AND renew_no = p_renew_no
                              AND endt_seq_no > NVL(p_max_endt_seq_no,-1)
                              AND pol_flag in ('1','2','3','X'))
              LOOP

                UPDATE GICL_CLAIMS
                   SET max_endt_seq_no = endt.endt_seq_no
                 WHERE claim_id = p_claim_id;
                EXIT;
              END LOOP;
    END;

    PROCEDURE CONFIRM_USER_GICLS039(p_type                IN        VARCHAR2,
                                    p_claim_id            IN        gicl_claims.claim_id%TYPE,
                                    p_line_cd             IN        gicl_claims.line_cd%TYPE,
                                    p_subline_cd          IN        gicl_claims.subline_cd%TYPE,
                                    p_iss_cd              IN        gicl_claims.iss_cd%TYPE,
                                    p_clm_yy              IN        gicl_claims.clm_yy%TYPE,
                                    p_clm_seq_no          IN        gicl_claims.clm_seq_no%TYPE,
                                    p_catastrophic_cd     IN        gicl_claims.catastrophic_cd%TYPE,
                                    p_select_type         IN        VARCHAR2,
                                    p_status_control      IN        NUMBER,
                                    p_cat_payt_res_flag   IN OUT    VARCHAR2,
                                    p_cat_desc               OUT    VARCHAR2,
                                    p_message_text           OUT    VARCHAR2)  --itest: pag null ang return value

    IS
      v_cat_res                  VARCHAR2(1) := 'N';
      v_cat_payt                 VARCHAR2(1) := 'N';
      v_res_net                 VARCHAR2(1) := 'N';
      v_res_xol                 VARCHAR2(1) := 'N';
      v_payt_net                 VARCHAR2(1) := 'N';
      v_payt_xol                 VARCHAR2(1) := 'N';
      v_temp              VARCHAR2(10) := substr(p_type,1,instr(p_type,'ing',1,1)-1);

    BEGIN
      chk_xol_res(v_res_net, v_res_xol, p_claim_id);
      chk_xol_payt(v_payt_net, v_payt_xol, p_claim_id);

      IF p_catastrophic_cd IS NOT NULL THEN
          IF v_res_net = 'Y' or v_res_xol = 'Y' THEN
           chk_cat_xol_res(v_cat_res, v_res_net, v_res_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
         IF v_payt_net = 'Y' or v_payt_xol = 'Y' THEN
           chk_cat_xol_payt(v_cat_payt, v_payt_net, v_payt_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
      END IF;

      IF p_cat_payt_res_flag = 'Y' THEN
         FOR get_cat_desc IN (SELECT catastrophic_desc
                                FROM gicl_cat_dtl
                               WHERE catastrophic_cd = p_catastrophic_cd
                                 AND NVL(line_cd, p_line_cd) = p_line_cd)
         LOOP
           p_cat_desc := to_char(p_catastrophic_cd) ||'-'||get_cat_desc.catastrophic_desc;
         END LOOP;

         IF p_status_control = 5 THEN
             v_temp := substr(v_temp,1,instr(v_temp,'l',1,1));
          END IF;
         -- S for selective - checkbox
         -- X for selective - btnProcess
         -- T for tagAll
         IF p_select_type = 'S' THEN
            p_message_text := 'Claim''s catastrophic event is distributed for '||
                                'Excess of Loss, '||p_type||' this will mean redistributing all claim under the event. '||
                                 'Are you sure you want to '||v_temp||' this claim ' ||
                               '(' || p_line_cd ||
                                '-' || p_subline_cd ||
                                '-' || p_iss_cd ||
                                '-' || lpad(to_char(p_clm_yy),2,'0') ||
                                '-' || lpad(to_char(p_clm_seq_no),7,'0') ||
                                ')?';
         ELSE
            p_message_text := 'Claim''s catastrophic event is distributed for '||
                                'Excess of Loss, ' ||p_type||' this will mean redistributing all claim(s) under the event. '||
                                'Are you sure you want to ' ||v_temp|| ' the claim(s)?';
         END IF;

      END IF;

    END;

    PROCEDURE DENY_CLAIMS_GICLS039(p_claim_id            IN       gicl_claims.claim_id%TYPE,
                                   p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
                                   p_line_cd             IN       gicl_claims.line_cd%TYPE,
                                   p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
                                   p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
                                   p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
                                   p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
                                   p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
                                   p_cat_payt_res_flag   IN OUT   VARCHAR2,
                                   p_cat_desc               OUT   VARCHAR2,
                                   p_msg_txt                OUT   VARCHAR2)

    IS

    v_cat_res       VARCHAR2 (1)   := 'N';
    v_cat_payt      VARCHAR2 (1)   := 'N';
    v_res_net       VARCHAR2 (1)   := 'N';
    v_res_xol       VARCHAR2 (1)   := 'N';
    v_payt_net      VARCHAR2 (1)   := 'N';
    v_payt_xol      VARCHAR2 (1)   := 'N';
    v_cat_desc      VARCHAR2 (100);

    BEGIN
      chk_xol_res(v_res_net, v_res_xol, p_claim_id);
      chk_xol_payt(v_payt_net, v_payt_xol, p_claim_id);

      IF p_catastrophic_cd IS NOT NULL THEN
          IF v_res_net = 'Y' or v_res_xol = 'Y' THEN
           chk_cat_xol_res(v_cat_res, v_res_net, v_res_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
         IF v_payt_net = 'Y' or v_payt_xol = 'Y' THEN
           chk_cat_xol_payt(v_cat_payt, v_payt_net, v_payt_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
      END IF;

      IF p_cat_payt_res_flag = 'Y' THEN
         FOR get_cat_desc IN (SELECT catastrophic_desc
                                FROM gicl_cat_dtl
                               WHERE catastrophic_cd = p_catastrophic_cd
                                 AND NVL(line_cd, p_line_cd) = p_line_cd)
         LOOP
           p_cat_desc := to_char(p_catastrophic_cd) ||'-'||get_cat_desc.catastrophic_desc;
         END LOOP;
      END IF;

      UPDATE gicl_clm_loss_exp
        SET dist_sw = 'N'
      WHERE claim_id = p_claim_id AND dist_sw = 'Y';

     UPDATE gicl_loss_exp_ds
        SET negate_tag = 'Y'
      WHERE claim_id = p_claim_id
        AND NVL (negate_tag, 'N') = 'N';

     UPDATE gicl_item_peril
        --SET close_flag = 'CC',
     SET close_flag = 'DC',
         close_date = SYSDATE,
         close_flag2 = 'DC',
         close_date2 = SYSDATE
      WHERE claim_id = p_claim_id
        AND NVL (close_flag, 'AP') = 'AP';

     IF v_cat_res = 'Y' OR v_res_xol = 'Y'
     THEN
        update_xol_res (p_line_cd);
     END IF;

     IF v_cat_payt = 'Y' OR v_payt_xol = 'Y'
     THEN
        update_xol_payt (p_line_cd);
     END IF;

     --*** Also, added close_date (082701)
     --set values for fields that need to be updated
     UPDATE gicl_claims
        SET old_stat_cd = p_old_stat_cd,
            close_date = SYSDATE,
            clm_stat_cd = 'DN',
            user_id = USER,
            last_update = SYSDATE
      WHERE claim_id = p_claim_id;

      IF v_cat_res = 'Y' OR v_cat_payt = 'Y'
      THEN
         p_msg_txt := 'Claim(s) has(have) just been denied. Please redistribute all records under catastrophic event '
             || v_cat_desc;
      ELSE
         p_msg_txt := 'Claim(s) has(have) just been denied.';
      END IF;
    END;

    PROCEDURE WITHDRAW_CLAIMS_GICLS039(p_claim_id            IN       gicl_claims.claim_id%TYPE,
                                   p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
                                   p_line_cd             IN       gicl_claims.line_cd%TYPE,
                                   p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
                                   p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
                                   p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
                                   p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
                                   p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
                                   p_cat_payt_res_flag   IN OUT   VARCHAR2,
                                   p_cat_desc               OUT   VARCHAR2,
                                   p_msg_txt                OUT   VARCHAR2)

    IS

    v_cat_res       VARCHAR2 (1)   := 'N';
    v_cat_payt      VARCHAR2 (1)   := 'N';
    v_res_net       VARCHAR2 (1)   := 'N';
    v_res_xol       VARCHAR2 (1)   := 'N';
    v_payt_net      VARCHAR2 (1)   := 'N';
    v_payt_xol      VARCHAR2 (1)   := 'N';
    v_cat_desc      VARCHAR2 (100);

    BEGIN
      chk_xol_res(v_res_net, v_res_xol, p_claim_id);
      chk_xol_payt(v_payt_net, v_payt_xol, p_claim_id);

      IF p_catastrophic_cd IS NOT NULL THEN
          IF v_res_net = 'Y' or v_res_xol = 'Y' THEN
           chk_cat_xol_res(v_cat_res, v_res_net, v_res_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
         IF v_payt_net = 'Y' or v_payt_xol = 'Y' THEN
           chk_cat_xol_payt(v_cat_payt, v_payt_net, v_payt_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
      END IF;

      IF p_cat_payt_res_flag = 'Y' THEN
         FOR get_cat_desc IN (SELECT catastrophic_desc
                                FROM gicl_cat_dtl
                               WHERE catastrophic_cd = p_catastrophic_cd
                                 AND NVL(line_cd, p_line_cd) = p_line_cd)
         LOOP
           p_cat_desc := to_char(p_catastrophic_cd) ||'-'||get_cat_desc.catastrophic_desc;
         END LOOP;
      END IF;

      UPDATE gicl_clm_loss_exp
        SET dist_sw = 'N'
      WHERE claim_id = p_claim_id AND dist_sw = 'Y';

     UPDATE gicl_loss_exp_ds
        SET negate_tag = 'Y'
      WHERE claim_id = p_claim_id
        AND NVL (negate_tag, 'N') = 'N';

     UPDATE gicl_item_peril
        --SET close_flag = 'CC',
     SET close_flag = 'DC',
         close_date = SYSDATE,
         close_flag2 = 'DC',
         close_date2 = SYSDATE
      WHERE claim_id = p_claim_id
        AND NVL (close_flag, 'AP') = 'AP';

     IF v_cat_res = 'Y' OR v_res_xol = 'Y'
     THEN
        update_xol_res (p_line_cd);
     END IF;

     IF v_cat_payt = 'Y' OR v_payt_xol = 'Y'
     THEN
        update_xol_payt (p_line_cd);
     END IF;

     --*** Also, added close_date (082701)
     --set values for fields that need to be updated
     UPDATE gicl_claims
        SET old_stat_cd = p_old_stat_cd,
            close_date = SYSDATE,
            clm_stat_cd = 'WD',
            user_id = USER,
            last_update = SYSDATE
      WHERE claim_id = p_claim_id;

      IF v_cat_res = 'Y' OR v_cat_payt = 'Y'
      THEN
         p_msg_txt := 'Claim(s) has(have) just been withdrawn. Please redistribute all records under catastrophic event '
             || v_cat_desc || '.';
      ELSE
         p_msg_txt := 'Claim(s) has(have) just been withdrawn.';
      END IF;
    END;

    PROCEDURE CANCEL_CLAIMS_GICLS039(p_claim_id            IN       gicl_claims.claim_id%TYPE,
                                   p_catastrophic_cd     IN       gicl_claims.catastrophic_cd%TYPE,
                                   p_line_cd             IN       gicl_claims.line_cd%TYPE,
                                   p_subline_cd          IN       gicl_claims.subline_cd%TYPE,
                                   p_iss_cd              IN       gicl_claims.iss_cd%TYPE,
                                   p_clm_yy              IN       gicl_claims.clm_yy%TYPE,
                                   p_clm_seq_no          IN       gicl_claims.clm_seq_no%TYPE,
                                   p_old_stat_cd         IN       gicl_claims.clm_stat_cd%TYPE,
                                   p_cat_payt_res_flag   IN OUT   VARCHAR2,
                                   p_cat_desc               OUT   VARCHAR2,
                                   p_msg_txt                OUT   VARCHAR2)

    IS

    v_cat_res       VARCHAR2 (1)   := 'N';
    v_cat_payt      VARCHAR2 (1)   := 'N';
    v_res_net       VARCHAR2 (1)   := 'N';
    v_res_xol       VARCHAR2 (1)   := 'N';
    v_payt_net      VARCHAR2 (1)   := 'N';
    v_payt_xol      VARCHAR2 (1)   := 'N';
    v_cat_desc      VARCHAR2 (100);

    BEGIN
      chk_xol_res(v_res_net, v_res_xol, p_claim_id);
      chk_xol_payt(v_payt_net, v_payt_xol, p_claim_id);

      IF p_catastrophic_cd IS NOT NULL THEN
          IF v_res_net = 'Y' or v_res_xol = 'Y' THEN
           chk_cat_xol_res(v_cat_res, v_res_net, v_res_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
         IF v_payt_net = 'Y' or v_payt_xol = 'Y' THEN
           chk_cat_xol_payt(v_cat_payt, v_payt_net, v_payt_xol, p_claim_id, p_catastrophic_cd, p_cat_payt_res_flag);
         END IF;
      END IF;

      IF p_cat_payt_res_flag = 'Y' THEN
         FOR get_cat_desc IN (SELECT catastrophic_desc
                                FROM gicl_cat_dtl
                               WHERE catastrophic_cd = p_catastrophic_cd
                                 AND NVL(line_cd, p_line_cd) = p_line_cd)
         LOOP
           p_cat_desc := to_char(p_catastrophic_cd) ||'-'||get_cat_desc.catastrophic_desc;
         END LOOP;
      END IF;

      UPDATE gicl_clm_loss_exp
        SET dist_sw = 'N'
      WHERE claim_id = p_claim_id AND dist_sw = 'Y';

     UPDATE gicl_loss_exp_ds
        SET negate_tag = 'Y'
      WHERE claim_id = p_claim_id
        AND NVL (negate_tag, 'N') = 'N';

     UPDATE gicl_item_peril
        --SET close_flag = 'CC',
     SET close_flag = 'DC',
         close_date = SYSDATE,
         close_flag2 = 'DC',
         close_date2 = SYSDATE
      WHERE claim_id = p_claim_id
        AND NVL (close_flag, 'AP') = 'AP';

     IF v_cat_res = 'Y' OR v_res_xol = 'Y'
     THEN
        update_xol_res (p_line_cd);
     END IF;

     IF v_cat_payt = 'Y' OR v_payt_xol = 'Y'
     THEN
        update_xol_payt (p_line_cd);
     END IF;

     --*** Also, added close_date (082701)
     --set values for fields that need to be updated
     UPDATE gicl_claims
        SET old_stat_cd = p_old_stat_cd,
            close_date = SYSDATE,
            clm_stat_cd = 'CC',
            user_id = USER,
            last_update = SYSDATE
      WHERE claim_id = p_claim_id;

      IF v_cat_res = 'Y' OR v_cat_payt = 'Y'
      THEN
         p_msg_txt := 'Claim has just been cancelled. Please redistribute all records under catastrophic event '
             || v_cat_desc || '.';
      ELSE
         p_msg_txt := 'Claim has just been cancelled.';
      END IF;
    END;


    PROCEDURE CHK_CLM_CLOSING_GICLS039(v_claim_id       IN      gicl_claims.claim_id%TYPE,
                                       v_prntd_fla      IN      VARCHAR2,
                                       v_chk_tag        IN      VARCHAR2,
                                       --v_payt_sw        OUT     VARCHAR2,
                                       v_batch_chkbx    OUT     VARCHAR2,
                                       v_tag_allow      OUT     VARCHAR2,
                                       v_param          OUT     VARCHAR2,
                                       v_msg_alert      OUT     VARCHAR2)
    IS
       --param             VARCHAR2 (1);
       v_item_payt_sw    VARCHAR2 (1) := 'N';
       v_res_net_cc      VARCHAR2 (1) := 'N';
       v_res_xol_cc      VARCHAR2 (1) := 'N';
       v_payt_net_cc     VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_cc     VARCHAR2 (1) := 'N';
       v_res_net_2cd     VARCHAR2 (1) := 'N';                                --**
       v_res_xol_2cd     VARCHAR2 (1) := 'N';                                --**
       v_payt_net_2cd    VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_2cd    VARCHAR2 (1) := 'N';
       v_paid_net_2cd    VARCHAR2 (1) := 'N';                                --**
       v_paid_xol_2cd    VARCHAR2 (1) := 'N';                                --**
       v_res_net_cd      VARCHAR2 (1) := 'N';                                --**
       v_res_xol_cd      VARCHAR2 (1) := 'N';
       v_payt_net_cd     VARCHAR2 (1) := 'N';                                --**
       v_payt_xol_cd     VARCHAR2 (1) := 'N';


       v_losses_paid     NUMBER       := 0;
       v_expenses_paid   NUMBER       := 0;
       v_loss_res        NUMBER       := 0;
       v_exp_res         NUMBER       := 0;
       v_payt_sw         varchar2(1):= 'N';

    BEGIN
       ---variables.v_goflag := FALSE;

       v_batch_chkbx     := 'Y';

       FOR item_perl IN (SELECT item_no, peril_cd, close_flag, close_flag2,
                                grouped_item_no
                           FROM gicl_item_peril a
                         WHERE  claim_id = v_claim_id
                            AND (   NVL (close_flag, 'AP') IN ('AP', 'CP', 'CC')
                                 OR NVL (close_flag2, 'AP') IN ('AP', 'CP', 'CC')
                                ))
       LOOP
          v_item_payt_sw := 'N';

          --check if payment has been made for active item peril
          FOR payt IN (SELECT '1'
                         FROM gicl_clm_res_hist
                        WHERE claim_id = v_claim_id
                          AND item_no = item_perl.item_no
                          AND NVL (grouped_item_no, 0) =
                                                NVL (item_perl.grouped_item_no, 0)
                          --EMCY da091406te:GPA
                          AND peril_cd = item_perl.peril_cd
                          AND tran_id IS NOT NULL
                          AND NVL (cancel_tag, 'N') = 'N')
          LOOP
             v_item_payt_sw := 'Y';

             --to check the value of reserve and payments.
             SELECT SUM (NVL (losses_paid, 0)) loss_paid,
                    SUM (NVL (expenses_paid, 0)) exp_paid
               INTO v_losses_paid,
                    v_expenses_paid
               FROM gicl_clm_res_hist
              WHERE claim_id = v_claim_id
                AND item_no = item_perl.item_no
                AND peril_cd = item_perl.peril_cd
                AND tran_id IS NOT NULL
                AND NVL (cancel_tag, 'N') = 'N';

             SELECT SUM (NVL (loss_reserve, 0)) loss,
                    SUM (NVL (expense_reserve, 0)) expense
               INTO v_loss_res,
                    v_exp_res
               FROM gicl_clm_res_hist
              WHERE claim_id = v_claim_id
                AND item_no = item_perl.item_no
                AND peril_cd = item_perl.peril_cd
                AND tran_id IS NULL
                AND NVL (cancel_tag, 'N') = 'N'
                AND clm_res_hist_id IN (
                       SELECT MAX (clm_res_hist_id)
                         FROM gicl_clm_res_hist
                        WHERE claim_id = v_claim_id
                          AND item_no = item_perl.item_no
                          AND peril_cd = item_perl.peril_cd
                          AND tran_id IS NULL
                          AND NVL (cancel_tag, 'N') = 'N');

             IF     NVL (item_perl.close_flag, 'AP') = 'AP'
                AND NVL (item_perl.close_flag2, 'AP') = 'AP'
             THEN                            --if both (loss and expense) are open
                IF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) <> 0
                THEN                                       --if both have reserve
                   IF v_losses_paid <> 0 AND v_expenses_paid <> 0
                   THEN                                    --if both have payment
                      IF     v_loss_res = v_losses_paid
                         AND v_exp_res = v_expenses_paid
                      THEN                        --if both reserve are fully paid
                         v_item_payt_sw := 'Y';
                         v_payt_sw := 'Y';
                         EXIT;
                      END IF;
                   END IF;
                ELSIF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) = 0
                THEN                  --if has loss reserve but no expense reserve
                   IF NVL (v_losses_paid, 0) <> 0
                   THEN                                     --if loss has payment
                      IF v_loss_res = v_losses_paid
                      THEN                        --if loss reserve is fully paid
                         v_item_payt_sw := 'Y';
                         v_payt_sw := 'Y';
                         EXIT;
                      END IF;
                   END IF;
                ELSIF NVL (v_exp_res, 0) <> 0 AND NVL (v_loss_res, 0) = 0
                THEN                  --if has expense reserve but no loss reserve
                   IF NVL (v_expenses_paid, 0) <> 0
                   THEN                                  --if expense has payment
                      IF v_exp_res = v_expenses_paid
                      THEN                     --if expense reserve is fully paid
                         v_item_payt_sw := 'Y';
                         v_payt_sw := 'Y';
                         EXIT;
                      END IF;
                   END IF;
                END IF;
             ELSIF     NVL (item_perl.close_flag, 'AP') = 'AP'
                   AND NVL (item_perl.close_flag2, 'AP') != 'AP'
             THEN                                   --if only loss reserve is open
                IF NVL (v_loss_res, 0) <> 0
                THEN                                        --if has loss reserve
                   IF NVL (v_losses_paid, 0) <> 0
                   THEN                                     --if loss has payment
                      IF v_loss_res = v_losses_paid
                      THEN                        --if loss reserve is fully paid
                         v_item_payt_sw := 'Y';
                         v_payt_sw := 'Y';
                         EXIT;
                      END IF;
                   END IF;
                END IF;
             ELSIF     NVL (item_perl.close_flag2, 'AP') = 'AP'
                   AND NVL (item_perl.close_flag, 'AP') != 'AP'
             THEN                                    --if only expense res is open
                IF NVL (v_exp_res, 0) <> 0
                THEN                                     --if has expense reserve
                   IF NVL (v_expenses_paid, 0) <> 0
                   THEN                                  --if expense has payment
                      IF v_exp_res = v_expenses_paid
                      THEN                     --if expense reserve is fully paid
                         v_item_payt_sw := 'Y';
                         v_payt_sw := 'Y';
                         EXIT;
                      END IF;
                   END IF;
                END IF;
             ELSIF     NVL (item_perl.close_flag2, 'AP') != 'AP'
                   AND NVL (item_perl.close_flag, 'AP') != 'AP'
             THEN                        --if both (loss and reserve) are not open
                v_item_payt_sw := 'Y';
                v_payt_sw := 'Y';
             END IF;
          END LOOP;                                               -- end loop payt

          --if loss reserve has no payment
          IF v_item_payt_sw = 'N'
          THEN
             IF item_perl.close_flag = 'AP'
             THEN
                gicl_claims_pkg.chk_cancelled_xol_res
                                (v_res_net_cc,
                                 v_res_xol_cc,
                                 item_perl.item_no,
                                 item_perl.grouped_item_no,
                                 item_perl.peril_cd,
                                 v_claim_id
                                );
                gicl_claims_pkg.chk_cancelled_xol_payt (v_payt_net_cc,
                                        v_payt_xol_cc,
                                        item_perl.item_no,
                                        item_perl.grouped_item_no,
                                        item_perl.peril_cd,
                                        v_claim_id
                                       );
             END IF;
          END IF;

          --IF LOSS RESERVE HAS PAYMENT AND ACTIVE
          IF     (item_perl.close_flag = 'AP' OR item_perl.close_flag2 = 'AP')
             AND v_item_payt_sw = 'Y'
          THEN
             gicl_claims_pkg.chk_cancelled_xol_res
                                (v_res_net_2cd,
                                 v_res_xol_2cd,
                                 item_perl.item_no,
                                 item_perl.grouped_item_no,
                                 item_perl.peril_cd,
                                 v_claim_id
                                );
             gicl_claims_pkg.chk_cancelled_xol_payt (v_payt_net_2cd,
                                     v_payt_xol_2cd,
                                     item_perl.item_no,
                                     item_perl.grouped_item_no,
                                     item_perl.peril_cd,
                                     v_claim_id
                                    );
             gicl_claims_pkg.chk_paid_xol_payt (v_paid_net_2cd,
                                v_paid_xol_2cd,
                                item_perl.item_no,
                                NVL (item_perl.grouped_item_no, 0),
                                item_perl.peril_cd,
                                v_claim_id
                               );
          END IF;

          --IF LOSS RESERVE IS CLOSED
          IF    item_perl.close_flag IN ('CP', 'CC')
             OR item_perl.close_flag2 IN ('CP', 'CC')
          THEN
              gicl_claims_pkg.chk_cancelled_xol_res (v_res_net_cd,
                                    v_res_xol_cd,
                                    item_perl.item_no,
                                    2,
                                    item_perl.peril_cd,
                                    v_claim_id
                                   );
              gicl_claims_pkg.chk_paid_xol_payt (v_payt_net_cd,
                                v_payt_xol_cd,
                                item_perl.item_no,
                                2,
                                item_perl.peril_cd,
                                v_claim_id
                               );
          END IF;
       END LOOP;

       IF v_payt_sw = 'N'
       THEN
          v_batch_chkbx := 'N';
          IF v_chk_tag = 'N' THEN
            v_msg_alert := 'Claim cannot be closed. Loss/Expense payment(s) has(have) not yet been made.';
          ELSE
            v_tag_allow := 'Y'; --cxc kapag tagall
          END IF;

       ELSE
          --check for existence of advice without payment before closing
          FOR chk_adv IN (SELECT advice_id
                            FROM gicl_advice
                           WHERE claim_id = v_claim_id
                             AND advice_flag = 'Y'
                             AND (   apprvd_tag = 'Y'
                                  OR batch_csr_id IS NOT NULL
                                  OR batch_dv_id IS NOT NULL
                                 ))
          LOOP

             FOR chk_payment IN (SELECT '1'
                                   FROM gicl_clm_loss_exp
                                  WHERE advice_id = chk_adv.advice_id
                                    AND tran_id IS NULL
                                    AND tran_date IS NULL)
             LOOP
                --disallow closing if advice without payments exists

                v_batch_chkbx := 'N';

                IF v_chk_tag = 'N' THEN
                    v_msg_alert := 'Unable to close claim. Advice without payment exists.';
                ELSE
                    v_tag_allow := 'Y';
                END IF;
             END LOOP;
          END LOOP;
       END IF;

       IF NVL (v_prntd_fla, 0) = 1
          AND v_payt_sw = 'Y' -- it will not validate the FLA anymore if the claim still has o/s advice payment
       THEN
          BEGIN
             SELECT LTRIM (RTRIM (param_value_v)) param
               INTO v_param
               FROM giac_parameters
              WHERE param_name = 'CHECK_FLA';

--             IF param = 'Y'
--             THEN
--                validate_fla;
--             END IF;

          EXCEPTION
             WHEN NO_DATA_FOUND
             THEN
                v_batch_chkbx := 'N';
                v_msg_alert := 'Parameter CHECK_FLA not set. There will be no FLA validation';

             WHEN TOO_MANY_ROWS
             THEN
                v_batch_chkbx := 'N';
                v_msg_alert := 'Multiple instance of CHECK_FLA parameter found. There will be no FLA Validation';
          END;
       END IF;
    END;

    PROCEDURE CLOSE_CLAIMS(p_claim_id       IN  gicl_claims.claim_id%TYPE,
                           p_line_cd        IN  gicl_claims.line_cd%TYPE,
                           p_remarks        IN  gicl_claims.remarks%TYPE,
                           p_recovery_sw    IN  gicl_claims.recovery_sw%TYPE,
                           p_closed_status  IN  VARCHAR2,
                           p_msg_txt        OUT VARCHAR2)

    IS

    v_old_stat_cd       VARCHAR2 (2);
    v_line_cd           VARCHAR2 (5);
    v_subline_cd        VARCHAR2 (5);
    v_iss_cd            VARCHAR2 (5);
    v_clm_yy            NUMBER;
    v_clm_seq_no        NUMBER;
    v_item_payt_sw      VARCHAR2 (1);
    v_update_sw         VARCHAR2 (1);
    v_claims            VARCHAR2 (20);
    --beth  05052004 added new variable for XOL validation
    v_cat_res           VARCHAR2 (1)   := 'N';
    v_cat_payt          VARCHAR2 (1)   := 'N';
    v_payt_xol_2cd      VARCHAR2 (1)   := 'N';
    v_res_xol_cc        VARCHAR2 (1)   := 'N';
    v_payt_xol_cc       VARCHAR2 (1)   := 'N';
    v_cat_desc          VARCHAR2 (100);
    -- additional variables for XOL Validation -- Edison 09.04.2012
    v_cat_res_xol       VARCHAR2 (1)   := 'N';
    v_cat_payt_xol      VARCHAR2 (1)   := 'N';
    v_cat_res_net       VARCHAR2 (1)   := 'N';
    v_cat_payt_net      VARCHAR2 (1)   := 'N';
    v_res_net_cd        VARCHAR2 (1)   := 'N';
    v_res_xol_cd        VARCHAR2 (1)   := 'N';
    v_payt_net_cd       VARCHAR2 (1)   := 'N';
    v_payt_xol_cd       VARCHAR2 (1)   := 'N';
    v_res_net_2cd       VARCHAR2 (1)   := 'N';
    v_res_xol_2cd       VARCHAR2 (1)   := 'N';
    v_payt_net_2cd      VARCHAR2 (1)   := 'N';
    v_paid_net_2cd      VARCHAR2 (1)   := 'N';
    v_paid_xol_2cd      VARCHAR2 (1)   := 'N';
    v_res_net_cc        VARCHAR2 (1)   := 'N';
    v_payt_net_cc       VARCHAR2 (1)   := 'N';

    v_payt_sw           VARCHAR2 (1)   := 'N';
    vclaim              VARCHAR2 (500);

    v_recovery_id       NUMBER;
    v_recovery_no       VARCHAR2 (30);
    v_lawyer_cd         NUMBER;
    v_lawyer_class_cd   VARCHAR2 (30);
    v_rec_stat_cd       VARCHAR2 (30);
    v_rec_stat_desc     VARCHAR2 (30);
    v_lawyer_name       VARCHAR2 (30);

    v_flag              BOOLEAN        := TRUE;

    v_claim_id          VARCHAR2 (500) := NULL;
    v_claim_id_new      VARCHAR2 (500);
    v_cnt               NUMBER         := 0;
    v_cnt1              NUMBER         := 0;

    v_item_payt_sw2     VARCHAR2 (1)   := 'N';
    v_losses_paid       NUMBER         := 0;
    v_expenses_paid     NUMBER         := 0;
    v_loss_res          NUMBER         := 0;
    v_exp_res           NUMBER         := 0;

    BEGIN
        FOR item_perl IN (SELECT item_no, peril_cd, close_flag, close_flag2,
                                  grouped_item_no
                             FROM gicl_item_peril a
                            WHERE claim_id = p_claim_id
                              AND (   NVL (close_flag, 'AP') IN
                                                           ('AP', 'CP', 'CC')
                                   OR NVL (close_flag2, 'AP') IN
                                                           ('AP', 'CP', 'CC')
                                  ))
         LOOP
            v_item_payt_sw2 := 'N';

            --check if payment has been made for active item peril
            FOR payt IN (SELECT '1'
                           FROM gicl_clm_res_hist
                          WHERE claim_id = p_claim_id
                            AND item_no = item_perl.item_no
                            AND peril_cd = item_perl.peril_cd
                            AND tran_id IS NOT NULL
                            AND NVL (cancel_tag, 'N') = 'N')
            LOOP
               IF 1 = 1
               THEN
                  SELECT SUM (NVL (losses_paid, 0)) loss_paid,
                         SUM (NVL (expenses_paid, 0)) exp_paid
                    INTO v_losses_paid,
                         v_expenses_paid
                    FROM gicl_clm_res_hist
                   WHERE claim_id = p_claim_id
                     AND item_no = item_perl.item_no
                     AND peril_cd = item_perl.peril_cd
                     AND tran_id IS NOT NULL
                     AND NVL (cancel_tag, 'N') = 'N';

                  SELECT SUM (NVL (loss_reserve, 0)) loss,
                         SUM (NVL (expense_reserve, 0)) expense
                    INTO v_loss_res,
                         v_exp_res
                    FROM gicl_clm_res_hist
                   WHERE claim_id = p_claim_id
                     AND item_no = item_perl.item_no
                     AND peril_cd = item_perl.peril_cd
                     AND tran_id IS NULL
                     AND NVL (cancel_tag, 'N') = 'N'
                     AND clm_res_hist_id IN (
                            SELECT MAX (clm_res_hist_id)
                              FROM gicl_clm_res_hist
                             WHERE claim_id = p_claim_id
                               AND item_no = item_perl.item_no
                               AND peril_cd = item_perl.peril_cd
                               AND tran_id IS NULL
                               AND NVL (cancel_tag, 'N') = 'N');

                  IF     NVL (item_perl.close_flag, 'AP') = 'AP'
                     AND NVL (item_perl.close_flag2, 'AP') = 'AP'
                  THEN                   --if both (loss and expense) are open
                     IF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) <> 0
                     THEN                              --if both have reserve
                        IF v_losses_paid <> 0 AND v_expenses_paid <> 0
                        THEN                           --if both have payment
                           IF     v_loss_res = v_losses_paid
                              AND v_exp_res = v_expenses_paid
                           THEN               --if both reserve are fully paid
                              v_item_payt_sw2 := 'Y';
                              v_payt_sw := 'Y';
                              EXIT;
                           END IF;
                        END IF;
                     ELSIF NVL (v_loss_res, 0) <> 0 AND NVL (v_exp_res, 0) = 0
                     THEN         --if has loss reserve but no expense reserve
                        IF NVL (v_losses_paid, 0) <> 0
                        THEN                            --if loss has payment
                           IF v_loss_res = v_losses_paid
                           THEN               --if loss reserve is fully paid
                              v_item_payt_sw2 := 'Y';
                              v_payt_sw := 'Y';
                              EXIT;
                           END IF;
                        END IF;
                     ELSIF NVL (v_exp_res, 0) <> 0 AND NVL (v_loss_res, 0) = 0
                     THEN         --if has expense reserve but no loss reserve
                        IF NVL (v_expenses_paid, 0) <> 0
                        THEN                         --if expense has payment
                           IF v_exp_res = v_expenses_paid
                           THEN            --if expense reserve is fully paid
                              v_item_payt_sw2 := 'Y';
                              v_payt_sw := 'Y';
                              EXIT;
                           END IF;
                        END IF;
                     END IF;
                  ELSIF     NVL (item_perl.close_flag, 'AP') = 'AP'
                        AND NVL (item_perl.close_flag2, 'AP') != 'AP'
                  THEN                          --if only loss reserve is open
                     IF NVL (v_loss_res, 0) <> 0
                     THEN                               --if has loss reserve
                        IF NVL (v_losses_paid, 0) <> 0
                        THEN                            --if loss has payment
                           IF v_loss_res = v_losses_paid
                           THEN               --if loss reserve is fully paid
                              v_item_payt_sw2 := 'Y';
                              v_payt_sw := 'Y';
                              EXIT;
                           END IF;
                        END IF;
                     END IF;
                  ELSIF     NVL (item_perl.close_flag2, 'AP') = 'AP'
                        AND NVL (item_perl.close_flag, 'AP') != 'AP'
                  THEN                           --if only expense res is open
                     IF NVL (v_exp_res, 0) <> 0
                     THEN                            --if has expense reserve
                        IF NVL (v_expenses_paid, 0) <> 0
                        THEN                         --if expense has payment
                           IF v_exp_res = v_expenses_paid
                           THEN            --if expense reserve is fully paid
                              v_item_payt_sw2 := 'Y';
                              v_payt_sw := 'Y';
                              EXIT;
                           END IF;
                        END IF;
                     END IF;
                  ELSIF     NVL (item_perl.close_flag2, 'AP') != 'AP'
                        AND NVL (item_perl.close_flag, 'AP') != 'AP'
                  THEN               --if both (loss and reserve) are not open
                     v_item_payt_sw2 := 'Y';
                     v_payt_sw := 'Y';
                  END IF;
               END IF;
            END LOOP;                                         -- end loop payt
         END LOOP;

         --continue other validation for claims with advice and payments
         IF v_item_payt_sw2 = 'N'
         THEN                         --if item peril w/o payment still exists
            -- select all records in gicl_item_peril that are still active
            FOR item_perl IN
               (SELECT item_no, peril_cd, close_flag,
                       grouped_item_no                  --EMCY da091406te:GPA
                  FROM gicl_item_peril a
                 WHERE claim_id = p_claim_id         --jen.122205
                   AND NVL (close_flag, 'AP') = 'AP'
                   AND NVL (close_flag2, 'AP') = 'AP')                --joey18
            LOOP
               --set v_update_sw to N so (this will help determine if updates are
               --already made for the record
               v_update_sw := 'N';

               --check if payment exists for that item peril
               FOR payt IN (SELECT '1'
                              FROM gicl_clm_res_hist
                             WHERE claim_id = p_claim_id
                               AND item_no = item_perl.item_no
                               AND NVL (grouped_item_no, 0) =
                                            NVL (item_perl.grouped_item_no, 0)
                               --EMCY da091406te:GPA
                               AND peril_cd = item_perl.peril_cd
                               AND tran_id IS NOT NULL
                               AND NVL (cancel_tag, 'N') = 'N')
               LOOP
                  --set the flag v_update_sw to 'Y' which will indicate that updates
                  --are already made to its close flag
                  v_update_sw := 'Y';

                  --update its close flag to 'CC', meaning, it is closed
                  UPDATE gicl_item_peril
                     SET close_flag = 'CC',
                         close_date = SYSDATE,
                         close_flag2 = 'CC',
                         close_date2 = SYSDATE
                   WHERE claim_id = p_claim_id
                     AND item_no = item_perl.item_no
                     AND NVL (grouped_item_no, 0) =
                                            NVL (item_perl.grouped_item_no, 0)
                     --EMCY da091406te:GPA
                     AND peril_cd = item_perl.peril_cd;

                  EXIT;
               END LOOP;

               -- if updates are not yet made for the current record then update its
               -- close_flag to 'DC', meaning, the peril has no payments
               -- and therefore cancelled
               IF v_update_sw = 'N'
               THEN
                  UPDATE gicl_item_peril
                     SET close_flag = 'DC',
                         close_date = SYSDATE,
                         close_flag2 = 'DC',
                         close_date2 = SYSDATE
                   WHERE claim_id = p_claim_id
                     AND item_no = item_perl.item_no
                     AND peril_cd = item_perl.peril_cd;
               END IF;
            END LOOP;
         ELSE
            --if all item peril for this claim have payments, update its close_flag to 'CC'
            --Modified by Edison 09.04.2012, create another update to separate close_flag and close_flag2
            UPDATE gicl_item_peril
               SET close_flag = 'CC',
                   close_date = SYSDATE
             WHERE claim_id = p_claim_id
               AND NVL (close_flag, 'AP') = 'AP';

            UPDATE gicl_item_peril
               SET close_flag2 = 'CC',
                   close_date2 = SYSDATE
             WHERE claim_id = p_claim_id
               AND NVL (close_flag2, 'AP') = 'AP';
         END IF;

         --     update negate_tag in table gicl_loss_exp_ds for
         --     loss expense history without payments
         FOR get_loss_id IN (SELECT clm_loss_id
                               FROM gicl_clm_loss_exp
                              WHERE claim_id = p_claim_id
                                AND tran_id IS NULL
                                AND dist_sw = 'Y'
                                AND NVL (cancel_sw, 'N') = 'N')
         LOOP
            UPDATE gicl_loss_exp_ds
               SET negate_tag = 'Y'
             WHERE claim_id = p_claim_id
               AND clm_loss_id = get_loss_id.clm_loss_id
               AND NVL (negate_tag, 'N') = 'N';
         END LOOP;

         --     update negate_tag in table gicl_loss_exp_ds for
         --     loss expense history without payments
         UPDATE gicl_clm_loss_exp
            SET dist_sw = 'N'
          WHERE claim_id = p_claim_id
            AND NVL (cancel_sw, 'N') = 'N'
            AND tran_id IS NULL
            AND dist_sw = 'Y';

         UPDATE gicl_reserve_ds
            SET negate_tag = 'Y'
          WHERE claim_id = p_claim_id;

         --CLEAR_MESSAGE;

         IF v_cat_res = 'Y' OR v_res_xol_cc = 'Y'
         THEN
            update_xol_res (p_line_cd);
         END IF;

         IF v_cat_payt = 'Y' OR v_payt_xol_cc = 'Y' OR v_payt_xol_2cd = 'Y'
         THEN
            update_xol_payt (p_line_cd);
         END IF;

         --set values for fields that need to be updated
         UPDATE gicl_claims
            SET old_stat_cd = v_old_stat_cd,
                close_date = SYSDATE,
                clm_setl_date = SYSDATE,
                clm_stat_cd = p_closed_status,
                user_id = USER,
                last_update = SYSDATE
          WHERE claim_id = p_claim_id;

         --   update reserve amounts of claim by summing its reserve
         --   amount from gicl_reserve table
         --   amount of reserve should only be from valid item peril
         --   those that are not withdrawn, cancelled, or denied
         FOR sum_res IN (SELECT SUM (loss_reserve) loss_reserve,
                                SUM (expense_reserve) exp_reserve
                           FROM gicl_clm_reserve a, gicl_item_peril b
                          WHERE a.claim_id = b.claim_id
                            AND a.item_no = b.item_no
                            AND NVL (a.grouped_item_no, 0) =
                                                    NVL (b.grouped_item_no, 0)
                            --EMCY da091306te: GPA
                            AND a.peril_cd = b.peril_cd
                            AND a.claim_id = p_claim_id
                            AND NVL (b.close_flag, 'AP') IN
                                                           ('AP', 'CC', 'CP'))
         LOOP
            --equate amounts retrieve to its corresponding base table fields
            UPDATE gicl_claims
               SET loss_res_amt = sum_res.loss_reserve,
                   exp_res_amt = sum_res.exp_reserve
             WHERE claim_id = p_claim_id;

            EXIT;
         END LOOP;                                          --end loop sum_res

         --  for claims with recoveries and have null remarks
         --  update remarks field to indicate that claim still has pending
         --  loss recoveries
         IF p_remarks IS NULL
            AND p_recovery_sw = 'N'
         THEN
            --get the maximum history for the recovery
            FOR max_rec_id IN (SELECT MAX (recovery_id) rec_id
                                 FROM gicl_clm_recovery
                                WHERE claim_id = p_claim_id)
            LOOP
               v_recovery_id := max_rec_id.rec_id;
            END LOOP;                                    --end loop max_rec_id

            --get info for the maximum recovery hist
            FOR rec_info IN (SELECT line_cd, rec_year, rec_seq_no, lawyer_cd,
                                    lawyer_class_cd
                               FROM gicl_clm_recovery
                              WHERE claim_id = p_claim_id
                                AND recovery_id = v_recovery_id)
            LOOP
               v_recovery_no :=
                     rec_info.line_cd
                  || '-'
                  || TO_CHAR (rec_info.rec_year)
                  || '-'
                  || TO_CHAR (rec_info.rec_seq_no, '009');
               v_lawyer_cd := rec_info.lawyer_cd;
               v_lawyer_class_cd := rec_info.lawyer_class_cd;
            END LOOP;                                      --end loop rec_info

            --get the status for the maximum recovery history
            FOR rec_stat IN (SELECT a.rec_stat_cd, b.rec_stat_desc
                               FROM gicl_rec_hist a, giis_recovery_status b
                              WHERE a.recovery_id = v_recovery_id
                                AND a.rec_stat_cd = b.rec_stat_cd)
            LOOP
               v_rec_stat_cd := rec_stat.rec_stat_cd;
               v_rec_stat_desc := rec_stat.rec_stat_desc;
            END LOOP;                                      --end loop rec_stat

            -- retrieve the lawyer name
            FOR lawyer IN (SELECT    payee_first_name
                                  || ' '
                                  || payee_middle_name
                                  || ' '
                                  || payee_last_name lawyer_name
                             FROM giis_payees
                            WHERE payee_no = v_lawyer_cd
                              AND payee_class_cd = v_lawyer_class_cd)
            LOOP
               v_lawyer_name := lawyer.lawyer_name;
            END LOOP;                                       -- end loop lawyer

            --assign remarks value
            UPDATE gicl_claims
               SET remarks =
                         'Claims with pending recovery record '
                      || v_recovery_no
                      || ' with '
                      || NVL (v_rec_stat_desc, 'ACTIVE')
                      || ' status.'
             WHERE claim_id = p_claim_id;

            IF v_lawyer_cd IS NOT NULL
            THEN
               UPDATE gicl_claims
                  SET remarks =
                            'Claims with pending recovery record '
                         || v_recovery_no
                         || ' with '
                         || NVL (v_rec_stat_desc, 'ACTIVE')
                         || ' status assigned to '
                         || v_lawyer_name
                WHERE claim_id = p_claim_id;
            END IF;
         END IF;

      IF v_cat_res = 'Y' OR v_cat_payt = 'Y'
      THEN
        p_msg_txt :=  'Claim(s) has(have) just been closed. Please redistribute all records under catastrophic event '
        || v_cat_desc||'.';
      ELSE
        p_msg_txt := 'Claim(s) has(have) just been closed.';
      END IF;
    END;

    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : March 14, 2013
    **  Reference By  : GICLS260 - Claims Information
    **  Description   : Function returns list of claims for GICLS260 listing
    */
    --Modified by pjsantos 11/08/2016, for optimization GENQA 5818 added p_order_by, p_asc_desc_flag, p_first_row, p_last_row.
    FUNCTION get_claims_information_listing( 
          p_line_cd           GICL_CLAIMS.line_cd%TYPE,
          p_subline_cd        GICL_CLAIMS.subline_cd%TYPE,
          p_iss_cd            GICL_CLAIMS.iss_cd%TYPE,
          p_clm_yy            GICL_CLAIMS.clm_yy%TYPE,
          p_clm_seq_no        GICL_CLAIMS.clm_seq_no%TYPE,
          p_pol_iss_cd        GICL_CLAIMS.pol_iss_cd%TYPE,
          p_pol_issue_yy      GICL_CLAIMS.issue_yy%TYPE,
          p_pol_seq_no        GICL_CLAIMS.pol_seq_no%TYPE,
          p_renew_no          GICL_CLAIMS.pol_iss_cd%TYPE,
          p_assured_name      VARCHAR2,
          p_plate_number      GICL_CLAIMS.plate_no%TYPE,
          p_claim_stat_desc   VARCHAR2,
          p_clm_file_date     VARCHAR2,
          p_loss_date         VARCHAR2,
          p_claim_id          GICL_CLAIMS.claim_id%TYPE, --added by robert SR 21694 03.28.16
          p_module_id         VARCHAR2,
          p_user_id           GIIS_USERS.user_id%TYPE,
          p_order_by          VARCHAR2,      
          p_asc_desc_flag     VARCHAR2,      
          p_first_row         NUMBER,        
          p_last_row          NUMBER )

    RETURN claims_information_tab2 PIPELINED AS

        v_claims_info       claims_information_type2;
        v_clm_file_date     DATE;
        v_loss_date         DATE;
        --Added by pjsantos 11/08/2016, for optimization GENQA 5818
        TYPE cur_type IS REF CURSOR;      
        c        cur_type;                
        v_sql    VARCHAR2(32767);   
        --pjsantos end      

    BEGIN
        BEGIN
             v_clm_file_date := TO_DATE (p_clm_file_date, 'MM-DD-RRRR');
        EXCEPTION
           WHEN OTHERS THEN
             v_clm_file_date := NULL;
        END;

        BEGIN
             v_loss_date := TO_DATE (p_loss_date, 'MM-DD-RRRR');
        EXCEPTION
           WHEN OTHERS THEN
             v_loss_date := NULL;
        END;

       -- FOR i IN (
       v_sql := ' SELECT mainsql.*
                   FROM (
                    SELECT COUNT (1) OVER () count_, outersql.* 
                      FROM (
                            SELECT ROWNUM rownum_, innersql.*
                              FROM (SELECT a.claim_id,
                         a.line_cd
                         || ''-''
                         || a.subline_cd
                         || ''-''
                         || a.iss_cd
                         || ''-''
                         || LTRIM (TO_CHAR (a.clm_yy, ''09''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.clm_seq_no, ''0999999'')) claim_no, 
                          a.line_cd
                         || ''-''
                         || a.subline_cd
                         || ''-''
                         || a.pol_iss_cd
                         || ''-''
                         || LTRIM (TO_CHAR (a.issue_yy, ''09''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.pol_seq_no, ''0999999''))
                         || ''-''
                         || LTRIM (TO_CHAR (a.renew_no, ''09'')) policy_no,
                         a.line_cd,       a.subline_cd,     a.issue_yy,
                         a.pol_seq_no,    a.renew_no,       a.pol_iss_cd,
                         a.clm_yy,        a.clm_seq_no,     a.iss_cd,
                         a.assd_no,       DECODE(a.assd_name2, NULL, a.assured_name,
                                a.assured_name || '' '' ||a.assd_name2) dsp_assured,
                         a.assured_name,   a.assd_name2,                         
                         a.recovery_sw,   a.user_id,        a.last_update,
                         a.loss_date,     a.dsp_loss_date,  a.acct_of_cd,
                         a.clm_file_date, a.entry_date,     a.obligee_no,
                         a.clm_stat_cd,   b.clm_stat_desc,  a.clm_setl_date,
                         a.loss_pd_amt,   a.loss_res_amt,   a.exp_pd_amt,
                         a.in_hou_adj,    a.intm_no,        a.loss_cat_cd,
                         a.loss_loc1,     a.loss_loc2,      a.loss_loc3,
                         a.pol_eff_date,  a.csr_no,         a.clm_amt,
                         a.loss_dtls,     a.exp_res_amt,    a.ri_cd,
                         a.plate_no,      a.clm_dist_tag,   a.old_stat_cd,
                         a.close_date,    a.expiry_date,    a.max_endt_seq_no,
                         a.pack_policy_id, (SELECT    line_cd
                                                      || ''-''
                                                      || subline_cd
                                                      || ''-''
                                                      || iss_cd
                                                      || ''-''
                                                      || LTRIM (TO_CHAR (issue_yy, ''09''))
                                                      || ''-''
                                                      || LTRIM (TO_CHAR (pol_seq_no, ''0999999''))
                                                      || ''-''
                                                      || LTRIM (TO_CHAR (renew_no, ''09''))
                                                      || DECODE (
                                                            NVL (endt_seq_no, 0),
                                                            0, '''',
                                                               '' / ''
                                                            || endt_iss_cd
                                                            || ''-''
                                                            || LTRIM (TO_CHAR (endt_yy, ''09''))
                                                            || ''-''
                                                            || LTRIM (TO_CHAR (endt_seq_no, ''9999999''))
                                                         ) policy
                                                 FROM gipi_pack_polbasic
                                                WHERE pack_policy_id = a.pack_policy_id
                                                AND ROWNUM = 1) pack_pol_no, 
                         NULL assignee,
                         TO_CHAR(a.loss_date,''MM-DD-YYYY'') sdf_loss_date,
                         TO_CHAR(a.clm_file_date,''MM-DD-YYYY'') sdf_clm_file_date,
                         (SELECT z.line_name
                            FROM giis_line z
                           WHERE z.line_cd = a.line_cd
                             AND ROWNUM =1) line_name
                 FROM GICL_CLAIMS a,
                      GIIS_CLM_STAT b
                WHERE a.clm_stat_cd = b.clm_stat_cd                  
                  AND EXISTS (SELECT ''X''
                                 FROM TABLE (security_access.get_branch_line (''CL'', '''||p_module_id||''', '''||p_user_id||'''))
                                WHERE branch_cd = a.iss_cd) ';
                  
                  IF p_line_cd IS NOT NULL
                    THEN
                      v_sql := v_sql || ' AND UPPER(a.line_cd) = UPPER('''||p_line_cd||''') ';
                  END IF;
                  IF p_subline_cd IS NOT NULL
                    THEN
                      v_sql := v_sql || ' AND UPPER(a.subline_cd) LIKE UPPER('''||p_subline_cd||''') ';
                  END IF;
                  IF p_iss_cd IS NOT NULL
                    THEN
                      v_sql := v_sql || ' AND UPPER(a.iss_cd) LIKE UPPER('''||p_iss_cd||''') ';
                  END IF;
                  IF p_clm_yy IS NOT NULL
                    THEN
                      v_sql := v_sql || ' AND a.clm_yy LIKE '''||p_clm_yy||''' ';
                  END IF;
                  IF p_clm_seq_no IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND a.clm_seq_no LIKE '''||p_clm_seq_no||''' ';
                  END IF;
                  IF p_pol_seq_no IS NOT NULL 
                    THEN
                      v_sql := v_sql || '  AND a.pol_seq_no LIKE '''||p_pol_seq_no||''' ';
                  END IF;
                  IF p_renew_no IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND a.renew_no LIKE '''||p_renew_no||''' ';
                  END IF;
                  IF p_assured_name IS NOT NULL
                    THEN
                      --v_sql := v_sql || '  AND UPPER(NVL(a.assured_name, ''@'')) LIKE DECODE(a.assured_name, NULL,''@'',UPPER('''||REPLACE(p_assured_name,'''','''''')||''')) ';
                      v_sql := v_sql || '  AND UPPER(NVL(a.assured_name, ''@#$^&'')) LIKE UPPER('''||REPLACE(p_assured_name,'''','''''')||''') '; --benjo 01.18.2017 SR-23636
                  END IF;
                  IF p_plate_number IS NOT NULL
                    THEN
                      --v_sql := v_sql || '  AND UPPER(NVL (a.plate_no, ''-'')) LIKE DECODE(a.plate_no, NULL, ''-'',UPPER('''||p_plate_number||''')) ';
                      v_sql := v_sql || '  AND UPPER(NVL (a.plate_no, ''@#$^&'')) LIKE UPPER('''||p_plate_number||''') '; --benjo 01.18.2017 SR-23636
                  END IF;
                  IF p_claim_stat_desc IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND UPPER(b.clm_stat_desc) LIKE UPPER('''||p_claim_stat_desc||''') ';
                  END IF;
                  IF p_clm_file_date IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND TRUNC (a.clm_file_date) = '''||v_clm_file_date||''' ';
                  END IF;
                  IF p_loss_date IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND TRUNC (a.loss_date) = '''||v_loss_date||''' ';
                  END IF;
                  IF p_claim_id IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND a.claim_id = '''||p_claim_id||''' ';
                  END IF;   
                  IF p_pol_iss_cd IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND UPPER(a.pol_iss_cd) = '''||UPPER(p_pol_iss_cd)||''' ';
                  END IF;  
                  IF p_pol_issue_yy IS NOT NULL
                    THEN
                      v_sql := v_sql || '  AND UPPER(a.issue_yy) = '''||p_pol_issue_yy||''' ';
                  END IF;    
                    
           IF p_order_by IS NOT NULL
              THEN
                IF p_order_by = 'claimNo'
                 THEN        
                  v_sql := v_sql || ' ORDER BY claim_no ';
                ELSIF  p_order_by = 'policyNo'
                 THEN
                  v_sql := v_sql || ' ORDER BY policy_no ';
                ELSIF  p_order_by = 'plateNumber'
                 THEN
                  v_sql := v_sql || ' ORDER BY plate_no  ';
                ELSIF  p_order_by = 'clmStatDesc'
                 THEN
                  v_sql := v_sql || ' ORDER BY clm_stat_desc '; 
                ELSIF  p_order_by = 'sdfClaimFileDate'
                 THEN
                  IF p_asc_desc_flag = 'ASC'
                   THEN 
                    v_sql := v_sql || ' ORDER BY TO_CHAR(a.clm_file_date,''YYYY'') ASC, TO_CHAR(a.clm_file_date,''MM'') ASC, TO_CHAR(a.clm_file_date,''DD'') ';  
                  ELSE
                    v_sql := v_sql || ' ORDER BY TO_CHAR(a.clm_file_date,''YYYY'') DESC, TO_CHAR(a.clm_file_date,''MM'') DESC, TO_CHAR(a.clm_file_date,''DD'') '; 
                  END IF;
                ELSIF  p_order_by = 'sdfLossDate'
                 THEN
                  IF p_asc_desc_flag = 'ASC'
                   THEN 
                    v_sql := v_sql || ' ORDER BY TO_CHAR(a.loss_date,''YYYY'') ASC, TO_CHAR(a.loss_date,''MM'') ASC, TO_CHAR(a.loss_date,''DD'') ';  
                  ELSE
                    v_sql := v_sql || ' ORDER BY TO_CHAR(a.loss_date,''YYYY'') DESC, TO_CHAR(a.loss_date,''MM'') DESC, TO_CHAR(a.loss_date,''DD'') '; 
                  END IF;         
                END IF;
                
                IF p_asc_desc_flag IS NOT NULL
                THEN
                   v_sql := v_sql || p_asc_desc_flag;
                ELSE
                   v_sql := v_sql || ' ASC ';
                END IF; 
                IF p_order_by = 'plateNumber' 
                 THEN
                  v_sql := v_sql || ' NULLS LAST '; 
                END IF;
                
            ELSE
            v_sql := v_sql || 'ORDER BY claim_no  '; 
            END IF;
            
            v_sql := v_sql || ' ) innersql ) outersql) mainsql WHERE rownum_ BETWEEN '|| p_first_row ||' AND ' || p_last_row;    
        
  OPEN c FOR v_sql;
     LOOP
      FETCH c INTO 
        v_claims_info.count_,
        v_claims_info.rownum_,
        v_claims_info.claim_id,
        v_claims_info.claim_no,
        v_claims_info.policy_no,
        v_claims_info.line_cd,
        v_claims_info.subline_cd,
        v_claims_info.issue_yy,
        v_claims_info.pol_seq_no,
        v_claims_info.renew_no,
        v_claims_info.pol_iss_cd,
        v_claims_info.clm_yy,
        v_claims_info.clm_seq_no,
        v_claims_info.iss_cd,
        v_claims_info.assd_no,
        v_claims_info.dsp_assured,
        v_claims_info.assured_name,
        v_claims_info.assd_name2,
        v_claims_info.recovery_sw,
        v_claims_info.user_id,
        v_claims_info.last_update,
        v_claims_info.loss_date,
        v_claims_info.dsp_loss_date,
        v_claims_info.acct_of_cd,
        v_claims_info.clm_file_date,
        v_claims_info.entry_date,
        v_claims_info.obligee_no,
        v_claims_info.clm_stat_cd,
        v_claims_info.clm_stat_desc,
        v_claims_info.clm_setl_date,
        v_claims_info.loss_pd_amt,
        v_claims_info.loss_res_amt,
        v_claims_info.exp_pd_amt,
        v_claims_info.in_hou_adj,
        v_claims_info.intm_no,
        v_claims_info.loss_cat_cd,
        v_claims_info.loss_loc1,
        v_claims_info.loss_loc2,
        v_claims_info.loss_loc3,
        v_claims_info.pol_eff_date,
        v_claims_info.csr_no,
        v_claims_info.clm_amt,
        v_claims_info.loss_dtls,
        v_claims_info.exp_res_amt,
        v_claims_info.ri_cd,
        v_claims_info.plate_no,
        v_claims_info.clm_dist_tag,
        v_claims_info.old_stat_cd,
        v_claims_info.close_date,
        v_claims_info.expiry_date,
        v_claims_info.max_endt_seq_no,
        v_claims_info.pack_policy_id,
        v_claims_info.pack_pol_no,
        v_claims_info.assignee,
        v_claims_info.sdf_loss_date,
        v_claims_info.sdf_clm_file_date,
        v_claims_info.line_name;
        
        
        
        
                         
                           
                        
              /*v_claims_info.claim_id       := i.claim_id;
              v_claims_info.claim_no       := i.claim_no;
              v_claims_info.policy_no      := i.policy_no;
              v_claims_info.line_cd        := i.line_cd;
              v_claims_info.subline_cd     := i.subline_cd;
              v_claims_info.issue_yy       := i.issue_yy;
              v_claims_info.pol_seq_no     := i.pol_seq_no;
              v_claims_info.renew_no       := i.renew_no;
              v_claims_info.pol_iss_cd     := i.pol_iss_cd;
              v_claims_info.clm_yy         := i.clm_yy;
              v_claims_info.clm_seq_no     := i.clm_seq_no;
              v_claims_info.iss_cd         := i.iss_cd;
              v_claims_info.assd_no        := i.assd_no;
              v_claims_info.assured_name   := i.assured_name;
              v_claims_info.assd_name2     := i.assd_name2;
              v_claims_info.dsp_assured    := i.dsp_assured;
              v_claims_info.recovery_sw    := i.recovery_sw;
              v_claims_info.user_id        := i.user_id;
              v_claims_info.last_update    := i.last_update;
              v_claims_info.loss_date      := i.loss_date;
              v_claims_info.dsp_loss_date  := i.dsp_loss_date;
              v_claims_info.clm_file_date  := i.clm_file_date;
              v_claims_info.entry_date     := i.entry_date;
              v_claims_info.clm_stat_cd    := i.clm_stat_cd;
              v_claims_info.clm_stat_desc  := i.clm_stat_desc;
              v_claims_info.clm_setl_date  := i.clm_setl_date;
              v_claims_info.loss_pd_amt    := i.loss_pd_amt;
              v_claims_info.loss_res_amt   := i.loss_res_amt;
              v_claims_info.exp_pd_amt     := i.exp_pd_amt;
              v_claims_info.in_hou_adj     := i.in_hou_adj;
              v_claims_info.intm_no        := i.intm_no;
              v_claims_info.loss_cat_cd    := i.loss_cat_cd;
              v_claims_info.loss_loc1      := i.loss_loc1;
              v_claims_info.loss_loc2      := i.loss_loc2;
              v_claims_info.loss_loc3      := i.loss_loc3;
              v_claims_info.pol_eff_date   := i.pol_eff_date;
              v_claims_info.csr_no         := i.csr_no;
              v_claims_info.clm_amt        := i.clm_amt;
              v_claims_info.loss_dtls      := i.loss_dtls;
              v_claims_info.obligee_no     := i.obligee_no;
              v_claims_info.exp_res_amt    := i.exp_res_amt;
              v_claims_info.ri_cd          := i.ri_cd;
              v_claims_info.plate_no       := i.plate_no;
              v_claims_info.clm_dist_tag   := i.clm_dist_tag;
              v_claims_info.old_stat_cd    := i.old_stat_cd;
              v_claims_info.close_date     := i.close_date;
              v_claims_info.expiry_date    := i.expiry_date;
              v_claims_info.acct_of_cd     := i.acct_of_cd;
              v_claims_info.pack_policy_id := i.pack_policy_id;
              v_claims_info.pack_pol_no    := i.pack_pol_no;
              v_claims_info.max_endt_seq_no:= i.max_endt_seq_no;
              v_claims_info.assignee       := NULL;
              v_claims_info.sdf_loss_date  := TO_CHAR(i.loss_date,'MM-DD-YYYY');--added by steven  06.03.2013
              v_claims_info.sdf_clm_file_date:= TO_CHAR(i.clm_file_date,'MM-DD-YYYY');--added by steven  06.03.2013*/

              IF NVL(GIISP.v('ORA2010_SW'),'N') = 'Y' THEN
                 FOR assgn IN (SELECT assignee
                                 FROM GICL_MOTOR_CAR_DTL
                                WHERE claim_id = v_claims_info.claim_id)
                 LOOP
                     v_claims_info.assignee := assgn.assignee;
                     EXIT;
                 END LOOP;

                 FOR enlee IN (SELECT grouped_item_title enrollee
                                 FROM GICL_ACCIDENT_DTL
                                WHERE claim_id = v_claims_info.claim_id)
                 LOOP
                     v_claims_info.assignee := enlee.enrollee;
                  EXIT;
                 END LOOP;
              END IF;
              
            /*  --added by gab 05.23.2016 SR 21694
              IF i.line_cd IS NOT NULL
              THEN
                SELECT line_name
                INTO v_claims_info.line_name
                FROM giis_line
                WHERE line_cd = i.line_cd;
              ELSE
                v_claims_info.line_name := '';
              END IF;*/

             EXIT WHEN c%NOTFOUND;              
         PIPE ROW (v_claims_info);
      END LOOP;      
     CLOSE c;   

    END get_claims_information_listing;

    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : March 18, 2013
    **  Reference By  : GICLS260 - Claims Information
    **  Description   : Function returns details of claims for Basic Information tab of GICLS260
    */

    FUNCTION get_claims_info_basic_details(p_claim_id    GICL_CLAIMS.claim_id%TYPE)
    RETURN claims_information_tab PIPELINED AS

        v_basic_info       claims_information_type;

    BEGIN
        FOR i IN (SELECT a.claim_id,
                         a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.clm_seq_no, '0999999')) claim_no, --editted the format;steven 06.04.2013
                            a.line_cd
                         || '-'
                         || a.subline_cd
                         || '-'
                         || a.pol_iss_cd
                         || '-'
                         || LTRIM (TO_CHAR (a.issue_yy, '09'))
                         || '-'
                         || LTRIM (TO_CHAR (a.pol_seq_no, '0999999'))
                         || '-'
                         || LTRIM (TO_CHAR (a.renew_no, '09')) policy_no,
                        a.line_cd,       a.subline_cd,           a.issue_yy,
                        a.pol_seq_no,    a.renew_no,             a.pol_iss_cd,
                        a.clm_yy,        a.clm_seq_no,           a.iss_cd,
                        a.assd_no,       a.assured_name,         a.assd_name2,
                        DECODE(a.assd_name2, NULL, a.assured_name,
                                a.assured_name || ' ' ||a.assd_name2) dsp_assured,
                        a.recovery_sw,   a.clm_file_date,
                        a.loss_date,     a.entry_date,           a.user_id,
                        a.last_update,   a.dsp_loss_date,        a.obligee_no,
                        DECODE(a.dsp_loss_date, NULL, '', TO_CHAR(a.dsp_loss_date, 'HH:MI AM')) dsp_loss_time,
                        a.clm_stat_cd,   b.clm_stat_desc,        a.clm_setl_date,
                        a.loss_pd_amt,   a.loss_res_amt,         a.exp_pd_amt,
                        a.loss_loc1,     a.loss_loc2,            a.loss_loc3,
                        a.pol_eff_date,  a.in_hou_adj,           a.plate_no,
                        a.ri_cd,         a.csr_no,                 a.loss_cat_cd,
                        a.intm_no,       a.clm_amt,              a.loss_dtls,
                        a.exp_res_amt,   a.clm_dist_tag,         a.old_stat_cd,
                        a.close_date,    a.expiry_date,          a.max_endt_seq_no,
                        a.pack_policy_id,get_pack_policy_no(a.pack_policy_id) pack_pol_no,
                        a.acct_of_cd,    a.remarks,              a.catastrophic_cd,
                        a.survey_agent_cd, a.settling_agent_cd,
                        a.cred_branch,   NVL(a.total_tag, 'N') total_tag    --unpaid_premium,
                    FROM GICL_CLAIMS a,
                         GIIS_CLM_STAT b
                    WHERE a.claim_id = p_claim_id
                      AND a.clm_stat_cd = b.clm_stat_cd)
        LOOP
              v_basic_info.claim_id       := i.claim_id;
              v_basic_info.claim_no       := i.claim_no;
              v_basic_info.policy_no      := i.policy_no;
              v_basic_info.line_cd        := i.line_cd;
              v_basic_info.subline_cd     := i.subline_cd;
              v_basic_info.issue_yy       := i.issue_yy;
              v_basic_info.pol_seq_no     := i.pol_seq_no;
              v_basic_info.renew_no       := i.renew_no;
              v_basic_info.pol_iss_cd     := i.pol_iss_cd;
              v_basic_info.clm_yy         := i.clm_yy;
              v_basic_info.clm_seq_no     := i.clm_seq_no;
              v_basic_info.iss_cd         := i.iss_cd;
              v_basic_info.assd_no        := i.assd_no;
              v_basic_info.assured_name   := i.assured_name;
              v_basic_info.assd_name2     := i.assd_name2;
              v_basic_info.dsp_assured    := i.dsp_assured;
              v_basic_info.recovery_sw    := i.recovery_sw;
              v_basic_info.user_id        := i.user_id;
              v_basic_info.last_update    := i.last_update;
              v_basic_info.loss_date      := i.loss_date;
              v_basic_info.dsp_loss_date  := i.dsp_loss_date;
              v_basic_info.dsp_loss_time  := i.dsp_loss_time;
              v_basic_info.clm_file_date  := i.clm_file_date;
              v_basic_info.entry_date     := i.entry_date;
              v_basic_info.clm_stat_cd    := i.clm_stat_cd;
              v_basic_info.clm_stat_desc  := i.clm_stat_desc;
              v_basic_info.clm_setl_date  := i.clm_setl_date;
              v_basic_info.loss_pd_amt    := i.loss_pd_amt;
              v_basic_info.loss_res_amt   := i.loss_res_amt;
              v_basic_info.exp_pd_amt     := i.exp_pd_amt;
              v_basic_info.in_hou_adj     := i.in_hou_adj;
              v_basic_info.intm_no        := i.intm_no;
              v_basic_info.loss_cat_cd    := i.loss_cat_cd;
              v_basic_info.loss_loc1      := i.loss_loc1;
              v_basic_info.loss_loc2      := i.loss_loc2;
              v_basic_info.loss_loc3      := i.loss_loc3;
              v_basic_info.pol_eff_date   := i.pol_eff_date;
              v_basic_info.csr_no         := i.csr_no;
              v_basic_info.clm_amt        := i.clm_amt;
              v_basic_info.loss_dtls      := i.loss_dtls;
              v_basic_info.obligee_no     := i.obligee_no;
              v_basic_info.exp_res_amt    := i.exp_res_amt;
              v_basic_info.ri_cd          := i.ri_cd;
              v_basic_info.plate_no       := i.plate_no;
              v_basic_info.clm_dist_tag   := i.clm_dist_tag;
              v_basic_info.old_stat_cd    := i.old_stat_cd;
              v_basic_info.close_date     := i.close_date;
              v_basic_info.expiry_date    := i.expiry_date;
              v_basic_info.acct_of_cd     := i.acct_of_cd;
              v_basic_info.pack_policy_id := i.pack_policy_id;
              v_basic_info.pack_pol_no    := i.pack_pol_no;
              v_basic_info.max_endt_seq_no:= i.max_endt_seq_no;
              v_basic_info.total_tag      := i.total_tag;
              v_basic_info.remarks            := i.remarks;
              v_basic_info.cred_branch      := i.cred_branch;
              v_basic_info.catastrophic_cd:= i.catastrophic_cd;
              v_basic_info.settling_agent_cd := i.settling_agent_cd;
               v_basic_info.survey_agent_cd   := i.survey_agent_cd;
              v_basic_info.dsp_settling_name := get_payee_name (i.settling_agent_cd, giisp.v ('SETTLING_PAYEE_CLASS'));
               v_basic_info.dsp_survey_name      := get_payee_name (i.survey_agent_cd, giisp.v ('SURVEY_PAYEE_CLASS'));

              BEGIN
                FOR usr IN(SELECT user_name
                             FROM giis_users
                            WHERE user_id = v_basic_info.in_hou_adj)
                LOOP
                  v_basic_info.in_hou_adj_name := usr.user_name;
                  EXIT;
                END LOOP;
              END;

              v_basic_info.ri_name := NULL;

              IF i.pol_iss_cd = 'RI' THEN
                   BEGIN
                     FOR ri IN(SELECT ri_name
                                FROM giis_reinsurer
                                  WHERE ri_cd = v_basic_info.ri_cd)
                    LOOP
                          v_basic_info.ri_name := ri.ri_name;
                          EXIT;
                    END LOOP;
               END;
               END IF;

             FOR name IN (SELECT iss_name
                            FROM giis_issource
                           WHERE iss_cd = v_basic_info.cred_branch)
             LOOP
                v_basic_info.cred_branch_name := name.iss_name;
                EXIT;
             END LOOP;

             v_basic_info.dsp_op_number := NULL;

               BEGIN
                FOR op IN(SELECT a.line_cd||'-'||a.op_subline_cd||'-'||a.op_iss_cd||'-'||
                                 ltrim(to_char(a.op_issue_yy,'09'))||'-'||
                                 ltrim(to_char(a.op_pol_seqno,'0999999'))||'-'||
                                 ltrim(to_char(a.op_renew_no,'09')) OP
                            FROM gipi_open_policy a, gicl_clm_polbas b
                           WHERE a.policy_id = b.policy_id
                             AND b.claim_id = p_claim_id)
                LOOP
                  v_basic_info.dsp_op_number := op.OP;
                  EXIT;
                END LOOP;
             END;

             v_basic_info.loss_cat_desc := 'no specified description';

             FOR a IN (SELECT loss_cat_des
                          FROM giis_loss_ctgry
                         WHERE loss_cat_cd = i.loss_cat_cd
                             AND line_cd = i.line_cd)
             LOOP
                v_basic_info.loss_cat_desc := a.loss_cat_des;
                EXIT;
               END LOOP;

             FOR assd IN(SELECT assd_name
                          FROM giis_assured
                         WHERE assd_no = v_basic_info.acct_of_cd)
             LOOP
                v_basic_info.acct_of_cd_name := assd.assd_name;
                EXIT;
             END LOOP;

             IF v_basic_info.catastrophic_cd IS NOT NULL THEN
                FOR cat IN
                  (SELECT catastrophic_desc
                     FROM gicl_cat_dtl
                    WHERE catastrophic_cd = v_basic_info.catastrophic_cd)
                LOOP
                  v_basic_info.catastrophic_desc := cat.catastrophic_desc;
                  EXIT;
                END LOOP;
            END IF;

            SELECT gicl_mortgagee_pkg.get_gicl_mortgagee_exist (p_claim_id)
              INTO v_basic_info.gicl_mortgagee_exist
              FROM DUAL;

             v_basic_info.recovery_exist := 'N';

             FOR rec IN (SELECT b.claim_id
                         FROM gicl_claims b,
                              gicl_clm_recovery c
                         WHERE b.claim_id = c.claim_id
                         AND b.claim_id = p_claim_id)
             LOOP
                 v_basic_info.recovery_exist := 'Y';
                EXIT;
              END LOOP;

             v_basic_info.basic_intm_exist := 'N';

             FOR rec IN (SELECT claim_id
                            FROM gicl_basic_intm_v1
                          WHERE claim_id = p_claim_id)
             LOOP
                 v_basic_info.basic_intm_exist := 'Y';
                EXIT;
              END LOOP;

             PIPE ROW(v_basic_info);

        END LOOP;
        
    END get_claims_info_basic_details;    

   /** Added by adpascual
   **  07.2013
   **/
   FUNCTION get_claim_list_lov (
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
      p_user_id          GIIS_USERS.USER_ID%TYPE
   )
      RETURN gicl_claims_v2_tab PIPELINED
   IS
      v_claims   gicl_claims_v2_type;
   BEGIN
      FOR gc IN (SELECT claim_id, line_cd, line_cd AS clm_line_cd,
                        subline_cd, subline_cd AS clm_subline_cd, iss_cd,
                        pol_iss_cd, clm_yy, issue_yy, clm_seq_no, pol_seq_no,
                        renew_no, assured_name, loss_date, loss_cat_cd,
                        clm_stat_cd
                   FROM gicl_claims a
                  WHERE a.line_cd = NVL (p_clm_line_cd, a.line_cd)
                    AND a.line_cd = NVL (p_line_cd, a.line_cd)
                    AND a.subline_cd = NVL(p_subline_cd, a.subline_cd)
                    AND a.subline_cd = NVL (p_clm_subline_cd, a.subline_cd)
                    AND a.iss_cd = NVL (p_iss_cd, a.iss_cd)
                    AND a.clm_yy = NVL (p_clm_yy, a.clm_yy)
                    AND a.clm_seq_no = NVL (p_clm_seq_no, a.clm_seq_no)
                    AND a.pol_iss_cd = NVL (p_pol_iss_cd, a.pol_iss_cd)
                    AND a.issue_yy = NVL (p_issue_yy, a.issue_yy)
                    AND a.pol_seq_no = NVL (p_pol_seq_no, a.pol_seq_no)
                    AND a.renew_no = NVL (p_renew_no, a.renew_no)
                    --AND check_user_per_line2 (line_cd, pol_iss_cd, p_module, p_user_id) = 1
                    --AND check_user_per_iss_cd2 (line_cd, NULL, p_module, p_user_id) = 1
                    AND check_user_per_iss_cd2 (line_cd, iss_cd, p_module, p_user_id) = 1 --modified by john dolon 9.2.2013
                    )
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
   END get_claim_list_lov;     
   
   
   PROCEDURE validate_giac_param_stat
   IS
      v_cancelled        VARCHAR2(100);
      v_withdrawn        VARCHAR2(100);
      v_denied           VARCHAR2(100);
      v_closed           VARCHAR2(100);
      v_list_temp        VARCHAR2(1000);
      v_missing_tag      VARCHAR2(1) := 'N';
   BEGIN
      v_list_temp := '';
      BEGIN
         SELECT param_value_v
           INTO v_cancelled
           FROM giac_parameters
          WHERE param_name LIKE 'CANCELLED';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
            v_missing_tag := 'Y';
            v_list_temp := v_list_temp||'<br> - CANCELLED';
      END;
      
      BEGIN
         SELECT param_value_v
           INTO v_withdrawn
           FROM giac_parameters
          WHERE param_name LIKE 'WITHDRAWN';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
            v_missing_tag := 'Y';
            v_list_temp := v_list_temp||'<br> - WITHDRAWN';
      END;
      
      BEGIN
         SELECT param_value_v
           INTO v_withdrawn
           FROM giac_parameters
          WHERE param_name LIKE 'DENIED';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
            v_missing_tag := 'Y';
            v_list_temp := v_list_temp||'<br> - DENIED';
      END;
      
      BEGIN
         SELECT param_value_v
           INTO v_withdrawn
           FROM giac_parameters
          WHERE param_name LIKE 'CLOSED CLAIM';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN NULL;
            v_missing_tag := 'Y';
            v_list_temp := v_list_temp||'<br> - CLOSED CLAIM';
      END;
      
      IF v_missing_tag = 'Y' THEN
         RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#The following claim status are missing in GIAC_PARAMETERS :'
         ||v_list_temp||
         '<br>Please contact your system administrator.');
      END IF;
   END;
END gicl_claims_pkg;
/


