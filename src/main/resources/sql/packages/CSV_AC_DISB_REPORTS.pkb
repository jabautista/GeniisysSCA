CREATE OR REPLACE PACKAGE BODY CPI.CSV_AC_DISB_REPORTS
AS
/*
**  Created by   :  Carlo de guzman
**  Date Created : 03.01.2016
**  Reference By : GIACR221B - UNRELEASED COMMISSIONS
*/
   FUNCTION csv_giacr221B (
      p_rep_grp       VARCHAR2,
      p_iss_cd        VARCHAR2,
      p_intm_no       VARCHAR2,
      p_module_id     VARCHAR2,
      p_unpaid_prem   VARCHAR2,
      p_user_id       VARCHAR2
   )
      RETURN get_giacr221B_tab PIPELINED
   IS
      v_list       get_giacr221B_type;
      v_prem_pd    giac_direct_prem_collns.premium_amt%TYPE   := 0;
      v_prem_amt   gipi_comm_invoice.premium_amt%TYPE         := 0;
      v_count      NUMBER;
   BEGIN

      IF p_unpaid_prem = 'N'                             /* paid premiums only */
      THEN
          FOR i IN
             (SELECT DECODE (p_rep_grp,'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd, 
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
                    AND b.pol_flag <> '5'
                    AND g.commission_amt <> 0
                    AND g.iss_cd = c.iss_cd(+)
                    AND g.prem_seq_no = c.prem_seq_no(+)
                    AND g.intrmdry_intm_no = c.intm_no(+)
                    AND g.peril_cd = c.peril_cd(+)
                    AND e.iss_cd = p.iss_cd
                    AND e.prem_seq_no = p.prem_seq_no
                    AND g.peril_cd = p.peril_cd
                    AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no) 
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
                 SELECT DECODE (p_rep_grp, 'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd,
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
                    AND b.pol_flag <> '5'
                    AND g.commission_amt = 0
                    AND e.commission_amt <> 0
                    AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no)
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
             v_list.branch_name        := i.iss_name;
             v_list.branch_code          := i.branch_cd;
             v_list.intermediary_name       := i.intm_name;
             v_list.intermediary_no   := i.intm_no;
             v_list.policy_no       := i.policy_no;
             v_list.issue_code       := i.iss_cd;
             v_list.assured_name       := i.assd_name;
             v_list.assured_no := i.assd_no;
             v_list.peril_code := i.peril_cd;        
             v_list.agent_code      := i.agent_code;     
             v_list.bill_number         := i.iss_cd || '-' || LPAD(i.prem_seq_no, 12, '0');
             v_list.premium_seq_no := i.prem_seq_no;
             v_list.commission_amount  := i.commission_amt;
             v_list.commission_rate   := i.commission_rt;
             v_list.premium_amount     := i.premium_amt;
             v_list.withholding_tax    := NVL(i.wholding_tax, 0);
             v_list.input_vat_amount      := NVL(i.input_vat, 0);
             v_list.net_commission        := ROUND(i.commission_amt, 2) - ROUND(NVL(i.wholding_tax, 0), 2) + ROUND(NVL(i.input_vat, 0), 2);

                BEGIN 
                     SELECT distinct intm_type
                       INTO v_list.intermediary_type
                       FROM giis_intermediary
                      WHERE intm_name = v_list.intermediary_name;
                END;

             PIPE ROW (v_list);         
          END LOOP;
      ELSIF p_unpaid_prem = 'Y'                      /* include unpaid premiums */
      THEN
         FOR j IN
            (SELECT DECODE (p_rep_grp, 'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd,
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
                AND g.iss_cd = c.iss_cd(+) 
                AND g.prem_seq_no = c.prem_seq_no(+) 
                AND g.intrmdry_intm_no = c.intm_no(+)
                AND g.peril_cd = c.peril_cd(+) 
                AND a.iss_cd <> giisp.v ('ISS_CD_RI')
                AND b.reg_policy_sw = 'Y'
                AND b.pol_flag <> '5'
                AND g.commission_amt <> 0
                AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no)
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
             SELECT DECODE (p_rep_grp, 'ISS_CD', b.iss_cd, 'CRED_BRANCH', b.cred_branch) branch_cd, 
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
                AND b.pol_flag <> '5' 
                AND g.commission_amt = 0
                AND e.commission_amt <> 0
                AND e.intrmdry_intm_no = NVL(p_intm_no, e.intrmdry_intm_no) 
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
                       NVL((SELECT SUM (z.comm_amt) 
                          FROM giac_comm_payts z
                         WHERE z.iss_cd = e.iss_cd
                           AND z.prem_seq_no = e.prem_seq_no),0)
             )
         LOOP
             v_list.branch_name        := j.iss_name;
             v_list.branch_code          := j.branch_cd;
             v_list.intermediary_name       := j.intm_name;
             v_list.agent_code      := j.agent_code;
             v_list.policy_no       := j.policy_no;
             v_list.assured_name       := j.assd_name;
             v_list.bill_number         := j.iss_cd || '-' || LPAD(j.prem_seq_no, 12, '0');
             v_list.commission_amount  := j.commission_amt;
             v_list.commission_rate   := j.commission_rt;
             v_list.withholding_tax    := NVL(j.wholding_tax, 0);
             v_list.input_vat_amount      := NVL(j.input_vat, 0);
             v_list.net_commission        := ROUND(j.commission_amt, 2) - ROUND(NVL(j.wholding_tax, 0), 2) + ROUND(NVL(j.input_vat, 0), 2);
             v_list.intermediary_no   := j.intm_no;
             v_list.issue_code       := j.iss_cd;
             v_list.premium_seq_no := j.prem_seq_no;
             v_list.assured_no := j.assd_no;
             v_list.peril_code := j.peril_cd;
             v_list.premium_amount     := j.premium_amt;
             
               BEGIN 
                 SELECT distinct intm_type
                 INTO v_list.intermediary_type
                 FROM giis_intermediary
                 WHERE intm_name = v_list.intermediary_name;
               END;             

             PIPE ROW (v_list);
         END LOOP;
      END IF;
   END csv_giacr221B;
END CSV_AC_DISB_REPORTS;
/
