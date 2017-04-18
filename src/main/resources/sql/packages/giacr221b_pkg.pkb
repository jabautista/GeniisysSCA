CREATE OR REPLACE PACKAGE BODY CPI.giacr221b_pkg
AS
/*
**  Created by   :  Ildefonso Ellarina Jr
**  Date Created : 07.15.2013
**  Reference By : GIACR221B - UNRELEASED COMMISSIONS
*/
   FUNCTION get_details (
      p_rep_grp       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_intm_no       VARCHAR2, --vondanix 10.06.2015 SR 5019
      p_module_id     VARCHAR2,
      p_unpaid_prem   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list       get_details_type;
      v_prem_pd    giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_prem_amt   gipi_comm_invoice.premium_amt%TYPE         := 0;
      v_count      NUMBER;
   BEGIN
      BEGIN
         SELECT param_value_v
           INTO v_list.cf_company
           FROM giis_parameters
          WHERE param_name = 'COMPANY_NAME';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_company := NULL;
      END;

      BEGIN
         SELECT param_value_v
           INTO v_list.cf_com_address
           FROM giac_parameters
          WHERE param_name = 'COMPANY_ADDRESS';
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_list.cf_com_address := NULL;
      END;

      BEGIN
         FOR c1 IN (SELECT report_title
                      FROM giis_reports
                     WHERE report_id = 'GIACR221B')
         LOOP
            v_list.report_title := c1.report_title;
         END LOOP;
      END;

      --vondanix 10.06.2015 SR 5019 : replaced query based from Unpaid_Commissions package.
         /*
         SELECT   DECODE (p_rep_grp,
                           'ISS_CD', c.iss_cd,
                           c.cred_branch
                          ) branch,
                   c.assd_no, c.prem_amt, a.intrmdry_intm_no, a.iss_cd,
                   a.prem_seq_no, a.policy_id, a.peril_cd, a.premium_amt,
                   a.commission_amt, a.commission_rt,
                   get_iss_name (DECODE (p_rep_grp,
                                         'ISS_CD', c.iss_cd,
                                         c.cred_branch
                                        )
                                ) iss_name,
                   get_assd_name (c.assd_no) assd_name,
                   get_policy_no (a.policy_id) policy_no,
                   get_peril_name (c.line_cd, a.peril_cd) peril_name,
                   get_intm_name (a.intrmdry_intm_no) intm_name,
                      d.intm_type
                   || '-'
                   || TO_CHAR (a.intrmdry_intm_no, '0009') agent_code,
                   e.peril_sname
              FROM gipi_polbasic c,
                   gipi_comm_invoice b,
                   gipi_comm_inv_peril a,
                   giis_intermediary d,
                   giis_peril e
             WHERE 1 = 1
               AND c.pol_flag <> '5'
               AND d.intm_no = a.intrmdry_intm_no
               AND e.line_cd = c.line_cd
               AND a.peril_cd = e.peril_cd
               AND a.policy_id = c.policy_id
               AND c.policy_id = b.policy_id
               AND b.iss_cd = a.iss_cd
               AND b.prem_seq_no = a.prem_seq_no
               AND b.intrmdry_intm_no = a.intrmdry_intm_no
               AND NOT EXISTS (
                      SELECT 1
                        FROM giac_comm_payts z
                       WHERE 1 = 1
                         AND z.intm_no = b.intrmdry_intm_no
                         AND z.iss_cd = b.iss_cd
                         AND z.prem_seq_no = b.prem_seq_no
                         AND z.gacc_tran_id > 0
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giac_acctrans y
                                 WHERE y.tran_flag = 'D'
                                   AND y.tran_id = z.gacc_tran_id)
                         AND NOT EXISTS (
                                SELECT 1
                                  FROM giac_reversals w, giac_acctrans x
                                 WHERE x.tran_id = w.reversing_tran_id
                                   AND x.tran_flag <> 'D'
                                   AND w.gacc_tran_id = z.gacc_tran_id))
               AND (   (    c.iss_cd = NVL (p_iss_cd, c.iss_cd)
                        AND p_rep_grp = 'ISS_CD'
                       )
                    OR (    c.cred_branch = NVL (p_iss_cd, c.cred_branch)
                        AND p_rep_grp = 'CRED_BRANCH'
                       )
                   )
               AND a.commission_amt <> 0
               /*AND (   (check_user_per_iss_cd_acctg (NULL,
                                                     c.iss_cd,
                                                     p_module_id
                                                    ) = 1
                       )
                    OR (check_user_per_iss_cd_acctg (NULL,
                                                     c.cred_branch,
                                                     p_module_id
                                                    ) = 1
                       )
                   )*/
               /* AND ((   EXISTS (
                           --added by steven 11.03.2014; to replace check_user_per_iss_cd_acctg2
                           SELECT d.access_tag
                             FROM giis_users a,
                                  giis_user_iss_cd b2,
                                  giis_modules_tran c,
                                  giis_user_modules d
                            WHERE a.user_id = p_user_id
                              AND b2.iss_cd = c.cred_branch
                              AND c.module_id = p_module_id
                              AND a.user_id = b2.userid
                              AND d.userid = a.user_id
                              AND b2.tran_cd = c.tran_cd
                              AND d.tran_cd = c.tran_cd
                              AND d.module_id = c.module_id)
                     OR EXISTS (
                           SELECT d.access_tag
                             FROM giis_users a,
                                  giis_user_grp_dtl b2,
                                  giis_modules_tran c,
                                  giis_user_grp_modules d
                            WHERE a.user_id = p_user_id
                              AND b2.iss_cd = c.cred_branch
                              AND c.module_id = p_module_id
                              AND a.user_grp = b2.user_grp
                              AND d.user_grp = a.user_grp
                              AND b2.tran_cd = c.tran_cd
                              AND d.tran_cd = c.tran_cd
                              AND d.module_id = c.module_id)
                    )
                    OR
                    (   EXISTS (
                           --added by steven 10.23.2014; to replace check_user_per_iss_cd_acctg2
                           SELECT d.access_tag
                             FROM giis_users a,
                                  giis_user_iss_cd b2,
                                  giis_modules_tran c,
                                  giis_user_modules d
                            WHERE a.user_id = p_user_id
                              AND b2.iss_cd = c.iss_cd
                              AND c.module_id = p_module_id
                              AND a.user_id = b2.userid
                              AND d.userid = a.user_id
                              AND b2.tran_cd = c.tran_cd
                              AND d.tran_cd = c.tran_cd
                              AND d.module_id = c.module_id)
                     OR EXISTS (
                           SELECT d.access_tag
                             FROM giis_users a,
                                  giis_user_grp_dtl b2,
                                  giis_modules_tran c,
                                  giis_user_grp_modules d
                            WHERE a.user_id = p_user_id
                              AND b2.iss_cd = c.iss_cd
                              AND c.module_id = p_module_id
                              AND a.user_grp = b2.user_grp
                              AND d.user_grp = a.user_grp
                              AND b2.tran_cd = c.tran_cd
                              AND d.tran_cd = c.tran_cd
                              AND d.module_id = c.module_id)
                        )
                    )
          --ORDER BY iss_name, intm_name, policy_no */
      
      IF p_unpaid_prem = 'N'                             /* paid premiums only */
      THEN
          FOR i IN
             (SELECT DECODE (p_rep_grp,'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd, --added 'CRED_BRANCH' by robert SR 5019 03.30.16
                     get_iss_name (DECODE (p_rep_grp,'ISS_CD', b.iss_cd, b.cred_branch)) iss_name,
                        b.assd_no, e.intrmdry_intm_no intm_no, e.parent_intm_no,
                        e.iss_cd, e.prem_seq_no, b.policy_id, g.peril_cd,
                        ROUND (p.premium_amt, 2) premium_amt,
                          ROUND (  NVL (  f.commission_amt
                                        * (g.commission_amt / e.commission_amt),
                                        g.commission_amt
                                       )
                                 * a.currency_rt
                                 * (  p.premium_amt
                                    / (g.premium_amt * a.currency_rt)
                                   ),
                                 2
                                )
                        - NVL (c.comm_amt, 0) commission_amt,
                          ROUND ((  NVL (  f.commission_amt
                                         * (g.commission_amt / e.commission_amt),
                                         g.commission_amt
                                        )
                                  * a.currency_rt
                                  * (  p.premium_amt
                                     / (g.premium_amt * a.currency_rt)
                                    )
                                  * (i.wtax_rate / 100)
                                 ),
                                 2
                                )
                        - NVL (c.wtax_amt, 0) wholding_tax,
                          ROUND ((  NVL (  f.commission_amt
                                         * (g.commission_amt / e.commission_amt),
                                         g.commission_amt
                                        )
                                  * a.currency_rt
                                  * (  p.premium_amt
                                     / (g.premium_amt * a.currency_rt)
                                    )
                                  * (i.input_vat_rate / 100)
                                 ),
                                 2
                                )
                        - NVL (c.input_vat_amt, 0) input_vat,
                        g.commission_rt,
                        get_iss_name (DECODE (p_rep_grp,
                                              'ISS_CD', b.iss_cd,
                                              b.cred_branch
                                             )
                                     ) branch_name,
                        get_policy_no (b.policy_id) policy_no,
                        get_assd_name (b.assd_no) assd_name, i.intm_name,
                           i.intm_type
                        || '-'
                        || LPAD (e.intrmdry_intm_no, 12, '0') agent_code,
                        h.peril_name
                   FROM gipi_invoice a,
                        gipi_polbasic b,
                        gipi_comm_invoice e,
                        gipi_comm_inv_dtl f,
                        gipi_comm_inv_peril g,
                        giis_peril h,
                        giis_intermediary i,
                        (SELECT   z.b140_iss_cd iss_cd,
                                  z.b140_prem_seq_no prem_seq_no,
                                  v.intrmdry_intm_no, v.peril_cd,
                                  SUM (  z.premium_amt
                                       * (v.premium_amt / u.premium_amt)
                                       * (u.share_percentage / 100)
                                      ) premium_amt
                             FROM giac_direct_prem_collns z,
                                  giac_acctrans w,
                                  gipi_comm_inv_peril v,
                                  gipi_comm_invoice u
                            WHERE 1 = 1
                              AND z.b140_iss_cd = u.iss_cd
                              AND z.b140_prem_seq_no = u.prem_seq_no
                              AND v.iss_cd = u.iss_cd
                              AND v.prem_seq_no = u.prem_seq_no
                              AND v.intrmdry_intm_no = u.intrmdry_intm_no
                              AND z.gacc_tran_id = w.tran_id
                              AND w.tran_flag <> 'D'
                              AND NOT EXISTS (
                                     SELECT '1'
                                       FROM giac_reversals x, giac_acctrans y
                                      WHERE x.gacc_tran_id = z.gacc_tran_id
                                        AND x.reversing_tran_id = y.tran_id
                                        AND y.tran_flag <> 'D')
                              AND u.premium_amt <> 0
                              AND u.commission_amt <> 0
                         GROUP BY z.b140_iss_cd,
                                  z.b140_prem_seq_no,
                                  z.inst_no,
                                  v.intrmdry_intm_no,
                                  v.peril_cd) p,
                        (SELECT   z.iss_cd, z.prem_seq_no, z.intm_no, v.peril_cd,
                                  SUM (  z.comm_amt
                                       * (v.commission_amt / u.commission_amt)
                                      ) comm_amt,
                                  SUM (  z.wtax_amt
                                       * (v.commission_amt / u.commission_amt)
                                      ) wtax_amt,
                                  SUM (  z.input_vat_amt
                                       * (v.commission_amt / u.commission_amt)
                                      ) input_vat_amt
                             FROM giac_comm_payts z,
                                  giac_acctrans w,
                                  gipi_comm_inv_peril v,
                                  gipi_comm_invoice u
                            WHERE 1 = 1
                              AND z.iss_cd = u.iss_cd
                              AND z.prem_seq_no = u.prem_seq_no
                              AND z.intm_no = u.intrmdry_intm_no
                              AND v.iss_cd = u.iss_cd
                              AND v.prem_seq_no = u.prem_seq_no
                              AND v.intrmdry_intm_no = u.intrmdry_intm_no
                              AND z.gacc_tran_id = w.tran_id
                              AND w.tran_flag <> 'D'
                              AND NOT EXISTS (
                                     SELECT '1'
                                       FROM giac_reversals x, giac_acctrans y
                                      WHERE x.gacc_tran_id = z.gacc_tran_id
                                        AND x.reversing_tran_id = y.tran_id
                                        AND y.tran_flag <> 'D')
                              AND u.commission_amt <> 0
                         GROUP BY z.iss_cd, z.prem_seq_no, z.intm_no, v.peril_cd) c
                  WHERE a.policy_id = b.policy_id
                    AND a.iss_cd = e.iss_cd
                    AND a.prem_seq_no = e.prem_seq_no
                    AND e.iss_cd = f.iss_cd(+)
                    AND e.prem_seq_no = f.prem_seq_no(+)
                    AND e.intrmdry_intm_no = f.intrmdry_intm_no(+)
                    AND e.iss_cd = g.iss_cd
                    AND e.prem_seq_no = g.prem_seq_no
                    AND e.intrmdry_intm_no = g.intrmdry_intm_no
                    AND e.intrmdry_intm_no = i.intm_no
                    AND g.peril_cd = h.peril_cd
                    AND b.line_cd = h.line_cd
                    AND a.iss_cd <> giisp.v ('ISS_CD_RI')
                    AND b.reg_policy_sw = 'Y'
                    AND b.pol_flag <> '5' --added by robert SR 5019 03.30.16
                    AND g.commission_amt <> 0
                    AND g.iss_cd = c.iss_cd(+)
                    AND g.prem_seq_no = c.prem_seq_no(+)
                    AND g.intrmdry_intm_no = c.intm_no(+)
                    AND g.peril_cd = c.peril_cd(+)
                    AND e.iss_cd = p.iss_cd
                    AND e.prem_seq_no = p.prem_seq_no
                    AND g.peril_cd = p.peril_cd
                    AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no) --vondanix 10.06.2015
                    --added to consider p_iss_cd and security by robert SR 5019 03.30.16
                    AND (   (    b.iss_cd = NVL (p_iss_cd, b.iss_cd) 
                        AND p_rep_grp = 'ISS_CD'
                       )
                    OR (    b.cred_branch = NVL (p_iss_cd, b.cred_branch)
                        AND p_rep_grp = 'CRED_BRANCH'
                       )
                    )
                    AND DECODE (p_rep_grp,'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) IN ( 
                          SELECT branch_cd
                            FROM TABLE (security_access.get_branch_line ('AC',
                                                                         p_module_id,
                                                                         p_user_id
                                                                        )
                                       ))
                    AND ROUND (  ROUND (  NVL (  f.commission_amt
                                               * (  g.commission_amt
                                                  / e.commission_amt
                                                 ),
                                               g.commission_amt
                                              )
                                        * a.currency_rt,
                                        2
                                       )
                               - NVL (c.comm_amt, 0),
                               2
                              ) <> 0
                 UNION                   /* to include perils with 0 commission */
                 SELECT DECODE (p_rep_grp, 'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd, --added 'CRED_BRANCH' by robert SR 5019 03.30.16
                        get_iss_name (DECODE (p_rep_grp,'ISS_CD', b.iss_cd, b.cred_branch)) iss_name,
                        b.assd_no, e.intrmdry_intm_no intm_no, e.parent_intm_no,
                        e.iss_cd, e.prem_seq_no, b.policy_id, g.peril_cd,
                        g.premium_amt,
                        ROUND (  NVL (  f.commission_amt
                                      * (g.commission_amt / e.commission_amt),
                                      g.commission_amt
                                     )
                               * a.currency_rt,
                               2
                              ) commission_amt,
                        ROUND (  (  NVL (  f.commission_amt
                                         * (g.commission_amt / e.commission_amt),
                                         g.commission_amt
                                        )
                                  * a.currency_rt
                                 )
                               * (i.wtax_rate / 100),
                               2
                              ) wholding_tax,
                        ROUND (  (  NVL (  f.commission_amt
                                         * (g.commission_amt / e.commission_amt),
                                         g.commission_amt
                                        )
                                  * a.currency_rt
                                 )
                               * (i.input_vat_rate / 100),
                               2
                              ) input_vat,
                        g.commission_rt,
                        get_iss_name (DECODE (p_rep_grp,
                                              'ISS_CD', b.iss_cd,
                                              b.cred_branch
                                             )
                                     ) branch_name,
                        get_policy_no (b.policy_id) policy_no,
                        get_assd_name (b.assd_no) assd_name, i.intm_name,
                           i.intm_type
                        || '-'
                        || LPAD (e.intrmdry_intm_no, 12, '0') agent_code,
                        h.peril_name
                   FROM gipi_invoice a,
                        gipi_polbasic b,
                        gipi_comm_invoice e,
                        gipi_comm_inv_dtl f,
                        gipi_comm_inv_peril g,
                        giis_peril h,
                        giis_intermediary i
                  WHERE a.policy_id = b.policy_id
                    AND a.iss_cd = e.iss_cd
                    AND a.prem_seq_no = e.prem_seq_no
                    AND e.iss_cd = f.iss_cd(+)
                    AND e.prem_seq_no = f.prem_seq_no(+)
                    AND e.intrmdry_intm_no = f.intrmdry_intm_no(+)
                    AND e.iss_cd = g.iss_cd
                    AND e.prem_seq_no = g.prem_seq_no
                    AND e.intrmdry_intm_no = g.intrmdry_intm_no
                    AND e.intrmdry_intm_no = i.intm_no
                    AND g.peril_cd = h.peril_cd
                    AND b.line_cd = h.line_cd
                    AND a.iss_cd <> giisp.v ('ISS_CD_RI')
                    AND b.reg_policy_sw = 'Y'
                    AND b.pol_flag <> '5' --added by robert SR 5019 03.30.16
                    AND g.commission_amt = 0
                    AND e.commission_amt <> 0
                    AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no) --vondanix 10.06.2015
                    --added to consider p_iss_cd and security by robert SR 5019 03.30.16
                    AND (   (    b.iss_cd = NVL (p_iss_cd, b.iss_cd) 
                        AND p_rep_grp = 'ISS_CD'
                       )
                    OR (    b.cred_branch = NVL (p_iss_cd, b.cred_branch)
                        AND p_rep_grp = 'CRED_BRANCH'
                       )
                    )
                    AND DECODE (p_rep_grp,'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) IN ( 
                          SELECT branch_cd
                            FROM TABLE (security_access.get_branch_line ('AC',
                                                                         p_module_id,
                                                                         p_user_id
                                                                        )
                                       ))
                    AND ROUND ((e.commission_amt * a.currency_rt), 2) <>
                           (SELECT SUM (z.comm_amt)
                              FROM giac_comm_payts z
                             WHERE z.iss_cd = e.iss_cd
                               AND z.prem_seq_no = e.prem_seq_no)
              )
          LOOP
             v_list.iss_name        := i.iss_name;
             v_list.branch          := i.branch_cd;
             v_list.agent_code      := i.agent_code;
             v_list.intm_name       := i.intm_name;
             v_list.policy_no       := i.policy_no;
             v_list.assd_name       := i.assd_name;
             v_list.bill_no         := i.iss_cd || '-' || LPAD(i.prem_seq_no, 12, '0');
             v_list.commission_amt  := i.commission_amt;
             v_list.commission_rt   := i.commission_rt;
             v_list.peril_name      := i.peril_name;
             v_list.premium_amt     := i.premium_amt;
             v_list.wholding_tax    := NVL(i.wholding_tax, 0);
             v_list.input_vat1      := NVL(i.input_vat, 0);
             v_list.net_comm        := ROUND(i.commission_amt, 2) - ROUND(NVL(i.wholding_tax, 0), 2) + ROUND(NVL(i.input_vat, 0), 2);

             PIPE ROW (v_list);
             
             /*BEGIN  --comment by vondanix 10.06.2015 SR 5019
                v_prem_pd := 0;
                v_prem_amt := 0;
                v_count := NULL;

            
                IF p_unpaid_prem = 'N'
                THEN
                   BEGIN
                      SELECT NVL (SUM (NVL (premium_amt, 0)), 0)
                        INTO v_prem_pd
                        FROM giac_direct_prem_collns
                       WHERE b140_iss_cd = i.iss_cd
                         AND b140_prem_seq_no = i.prem_seq_no;
                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                         v_prem_pd := 0;
                   END;

                   BEGIN
                      SELECT NVL (SUM (NVL (premium_amt, 0)), 0)
                        INTO v_prem_amt
                        FROM gipi_comm_invoice
                       WHERE iss_cd = i.iss_cd AND prem_seq_no = i.prem_seq_no;
                   EXCEPTION
                      WHEN NO_DATA_FOUND
                      THEN
                         v_prem_amt := 0;
                   END;

                   IF NVL (v_prem_pd, 0) >= NVL (v_prem_amt, 0)
                   THEN
                      PIPE ROW (v_list);
                   END IF;
                ELSE
                   PIPE ROW (v_list);
                END IF;
                
             END;
           */
          END LOOP;
      ELSIF p_unpaid_prem = 'Y'                      /* include unpaid premiums */
      THEN
         FOR j IN
            (SELECT DECODE (p_rep_grp, 'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd, --added 'CRED_BRANCH' by robert SR 5019 03.30.16
                    get_iss_name (DECODE (p_rep_grp,'ISS_CD', b.iss_cd, b.cred_branch)) iss_name,
                    b.assd_no, e.intrmdry_intm_no intm_no, e.parent_intm_no,
                    e.iss_cd, e.prem_seq_no, b.policy_id, g.peril_cd,
                    ROUND (g.premium_amt * a.currency_rt, 2) premium_amt,
                    ROUND (  NVL (  f.commission_amt
                                  * (g.commission_amt / e.commission_amt),
                                  g.commission_amt
                                 )
                           * a.currency_rt,
                           2
                          ) - NVL(c.comm_amt,0) commission_amt,
                    ROUND (  (  NVL (  f.commission_amt
                                     * (g.commission_amt / e.commission_amt),
                                     g.commission_amt
                                    )
                              * a.currency_rt
                             )
                           * (i.wtax_rate / 100),
                           2
                          ) - NVL(c.wtax_amt,0) wholding_tax,
                    ROUND (  (  NVL (  f.commission_amt
                                     * (g.commission_amt / e.commission_amt),
                                     g.commission_amt
                                    )
                              * a.currency_rt
                             )
                           * (i.input_vat_rate / 100),
                           2
                          ) - NVL(c.input_vat_amt,0) input_vat,
                    g.commission_rt,
                    get_iss_name (DECODE (p_rep_grp,
                                          'ISS_CD', b.iss_cd,
                                          b.cred_branch
                                         )
                                 ) branch_name,
                    get_policy_no (b.policy_id) policy_no,
                    get_assd_name (b.assd_no) assd_name, i.intm_name,
                       i.intm_type
                    || '-'
                    || LPAD (e.intrmdry_intm_no, 12, '0') agent_code,
                    h.peril_name
               FROM gipi_invoice a,
                    gipi_polbasic b,
                    gipi_comm_invoice e,
                    gipi_comm_inv_dtl f,
                    gipi_comm_inv_peril g,
                    giis_peril h,
                    giis_intermediary i,
                    (SELECT   z.iss_cd, z.prem_seq_no, z.intm_no, v.peril_cd,
                              SUM (  z.comm_amt
                                   * (v.commission_amt / u.commission_amt)
                                  ) comm_amt,
                              SUM (  z.wtax_amt
                                   * (v.commission_amt / u.commission_amt)
                                  ) wtax_amt,
                              SUM (  z.input_vat_amt
                                   * (v.commission_amt / u.commission_amt)
                                  ) input_vat_amt
                         FROM giac_comm_payts z,
                              giac_acctrans w,
                              gipi_comm_inv_peril v,
                              gipi_comm_invoice u
                        WHERE 1 = 1
                          AND z.iss_cd = u.iss_cd
                          AND z.prem_seq_no = u.prem_seq_no
                          AND z.intm_no = u.intrmdry_intm_no
                          AND v.iss_cd = u.iss_cd
                          AND v.prem_seq_no = u.prem_seq_no
                          AND v.intrmdry_intm_no = u.intrmdry_intm_no
                          AND z.gacc_tran_id = w.tran_id
                          AND w.tran_flag <> 'D'
                          AND NOT EXISTS (
                                 SELECT '1'
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.gacc_tran_id = z.gacc_tran_id
                                    AND x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag <> 'D')
                          AND u.commission_amt <> 0
                     GROUP BY z.iss_cd, z.prem_seq_no, z.intm_no, v.peril_cd) c
              WHERE a.policy_id = b.policy_id
                AND a.iss_cd = e.iss_cd
                AND a.prem_seq_no = e.prem_seq_no
                AND e.iss_cd = f.iss_cd(+)
                AND e.prem_seq_no = f.prem_seq_no(+)
                AND e.intrmdry_intm_no = f.intrmdry_intm_no(+)
                AND e.iss_cd = g.iss_cd
                AND e.prem_seq_no = g.prem_seq_no
                AND e.intrmdry_intm_no = g.intrmdry_intm_no
                AND e.intrmdry_intm_no = i.intm_no
                AND g.peril_cd = h.peril_cd
                AND b.line_cd = h.line_cd
                AND g.iss_cd = c.iss_cd(+) --added outer-join by robert SR 5019 03.30.16
                AND g.prem_seq_no = c.prem_seq_no(+) --added outer-join by robert SR 5019 03.30.16
                AND g.intrmdry_intm_no = c.intm_no(+) --added outer-join by robert SR 5019 03.30.16
                AND g.peril_cd = c.peril_cd(+) --added outer-join by robert SR 5019 03.30.16
                AND a.iss_cd <> giisp.v ('ISS_CD_RI')
                AND b.reg_policy_sw = 'Y'
                AND b.pol_flag <> '5' --added by robert SR 5019 03.30.16
                AND g.commission_amt <> 0
                AND e.commission_amt != 0 --added by pjsantos to avoid ORA-01476: divisor is equal to zero, GENQA 5744 
                AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no) --vondanix 10.06.2015
                --added to consider p_iss_cd and security by robert SR 5019 03.30.16
                AND (   (    b.iss_cd = NVL (p_iss_cd, b.iss_cd) 
                        AND p_rep_grp = 'ISS_CD'
                       )
                    OR (    b.cred_branch = NVL (p_iss_cd, b.cred_branch)
                        AND p_rep_grp = 'CRED_BRANCH'
                       )
                )
                AND DECODE (p_rep_grp,'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) IN ( 
                          SELECT branch_cd
                            FROM TABLE (security_access.get_branch_line ('AC',
                                                                         p_module_id,
                                                                         p_user_id
                                                                        )
                                       ))
             UNION                   /* to include perils with 0 commission */
             SELECT DECODE (p_rep_grp, 'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd, --added 'CRED_BRANCH' by robert SR 5019 03.30.16
                    get_iss_name (DECODE (p_rep_grp,'ISS_CD', b.iss_cd, b.cred_branch)) iss_name,
                    b.assd_no, e.intrmdry_intm_no intm_no, e.parent_intm_no,
                    e.iss_cd, e.prem_seq_no, b.policy_id, g.peril_cd,
                    g.premium_amt,
                    ROUND (  NVL (  f.commission_amt
                                  * (g.commission_amt / e.commission_amt),
                                  g.commission_amt
                                 )
                           * a.currency_rt,
                           2
                          ) commission_amt,
                    ROUND (  (  NVL (  f.commission_amt
                                     * (g.commission_amt / e.commission_amt),
                                     g.commission_amt
                                    )
                              * a.currency_rt
                             )
                           * (i.wtax_rate / 100),
                           2
                          ) wholding_tax,
                    ROUND (  (  NVL (  f.commission_amt
                                     * (g.commission_amt / e.commission_amt),
                                     g.commission_amt
                                    )
                              * a.currency_rt
                             )
                           * (i.input_vat_rate / 100),
                           2
                          ) input_vat,
                    g.commission_rt,
                    get_iss_name (DECODE (p_rep_grp,
                                          'ISS_CD', b.iss_cd,
                                          b.cred_branch
                                         )
                                 ) branch_name,
                    get_policy_no (b.policy_id) policy_no,
                    get_assd_name (b.assd_no) assd_name, i.intm_name,
                       i.intm_type
                    || '-'
                    || LPAD (e.intrmdry_intm_no, 12, '0') agent_code,
                    h.peril_name
               FROM gipi_invoice a,
                    gipi_polbasic b,
                    gipi_comm_invoice e,
                    gipi_comm_inv_dtl f,
                    gipi_comm_inv_peril g,
                    giis_peril h,
                    giis_intermediary i
              WHERE a.policy_id = b.policy_id
                AND a.iss_cd = e.iss_cd
                AND a.prem_seq_no = e.prem_seq_no
                AND e.iss_cd = f.iss_cd(+)
                AND e.prem_seq_no = f.prem_seq_no(+)
                AND e.intrmdry_intm_no = f.intrmdry_intm_no(+)
                AND e.iss_cd = g.iss_cd
                AND e.prem_seq_no = g.prem_seq_no
                AND e.intrmdry_intm_no = g.intrmdry_intm_no
                AND e.intrmdry_intm_no = i.intm_no
                AND g.peril_cd = h.peril_cd
                AND b.line_cd = h.line_cd
                AND a.iss_cd <> giisp.v ('ISS_CD_RI')
                AND b.reg_policy_sw = 'Y'
                AND b.pol_flag <> '5' --added by robert SR 5019 03.30.16
                AND g.commission_amt = 0
                AND e.commission_amt <> 0
                AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no) --vondanix 10.06.2015 
                --added to consider p_iss_cd and security by robert SR 5019 03.30.16
                AND (   (    b.iss_cd = NVL (p_iss_cd, b.iss_cd) 
                        AND p_rep_grp = 'ISS_CD'
                       )
                    OR (    b.cred_branch = NVL (p_iss_cd, b.cred_branch)
                        AND p_rep_grp = 'CRED_BRANCH'
                       )
                )
                AND DECODE (p_rep_grp,'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) IN ( 
                          SELECT branch_cd
                            FROM TABLE (security_access.get_branch_line ('AC',
                                                                         p_module_id,
                                                                         p_user_id
                                                                        )
                                       ))
                AND ROUND ((e.commission_amt * a.currency_rt), 2) <>
                       NVL((SELECT SUM (z.comm_amt) --added NVL by robert SR 5019 03.30.16
                          FROM giac_comm_payts z
                         WHERE z.iss_cd = e.iss_cd
                           AND z.prem_seq_no = e.prem_seq_no),0)
             )
         LOOP
             v_list.iss_name        := j.iss_name;
             v_list.branch          := j.branch_cd;
             v_list.agent_code      := j.agent_code;
             v_list.intm_name       := j.intm_name;
             v_list.policy_no       := j.policy_no;
             v_list.assd_name       := j.assd_name;
             v_list.bill_no         := j.iss_cd || '-' || LPAD(j.prem_seq_no, 12, '0');
             v_list.commission_amt  := j.commission_amt;
             v_list.commission_rt   := j.commission_rt;
             v_list.peril_name      := j.peril_name;
             v_list.premium_amt     := j.premium_amt;
             v_list.wholding_tax    := NVL(j.wholding_tax, 0);
             v_list.input_vat1      := NVL(j.input_vat, 0);
             v_list.net_comm        := ROUND(j.commission_amt, 2) - ROUND(NVL(j.wholding_tax, 0), 2) + ROUND(NVL(j.input_vat, 0), 2);

             PIPE ROW (v_list);
         END LOOP;
      END IF;
   END get_details;
END giacr221b_pkg;
/


