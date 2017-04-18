CREATE OR REPLACE PACKAGE BODY CPI.unpaid_commissions
AS
/* created by judyann 03192013; to get amount of unpaid commissions of policies with paid or unpaid premiums */
   FUNCTION os_comm (p_rep_grp VARCHAR2, p_inc_tag VARCHAR2)
      RETURN comm_type PIPELINED
   IS
      v_comm   comm_rec_type;
   BEGIN
      IF p_inc_tag = 'N'                             /* paid premiums only */
      THEN
         FOR j1 IN
            (SELECT DECODE (p_rep_grp,
                            'ISS_CD', b.iss_cd,
                            b.cred_branch
                           ) branch_cd,
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
                AND reg_policy_sw = 'Y'
                AND g.commission_amt <> 0
                AND g.iss_cd = c.iss_cd(+)
                AND g.prem_seq_no = c.prem_seq_no(+)
                AND g.intrmdry_intm_no = c.intm_no(+)
                AND g.peril_cd = c.peril_cd(+)
                AND e.iss_cd = p.iss_cd
                AND e.prem_seq_no = p.prem_seq_no
                AND g.peril_cd = p.peril_cd
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
             SELECT DECODE (p_rep_grp,
                            'ISS_CD', b.iss_cd,
                            b.cred_branch
                           ) branch_cd,
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
                AND reg_policy_sw = 'Y'
                AND g.commission_amt = 0
                AND e.commission_amt <> 0
                AND ROUND ((e.commission_amt * a.currency_rt), 2) <>
                       (SELECT SUM (z.comm_amt)
                          FROM giac_comm_payts z
                         WHERE z.iss_cd = e.iss_cd
                           AND z.prem_seq_no = e.prem_seq_no))
         LOOP
            v_comm.branch_cd := j1.branch_cd;
            v_comm.assd_no := j1.assd_no;
            v_comm.intm_no := j1.intm_no;
            v_comm.iss_cd := j1.iss_cd;
            v_comm.prem_seq_no := j1.prem_seq_no;
            v_comm.policy_id := j1.policy_id;
            v_comm.peril_cd := j1.peril_cd;
            v_comm.premium_amt := j1.premium_amt;
            v_comm.commission_amt := j1.commission_amt;
            v_comm.wholding_tax := j1.wholding_tax;
            v_comm.input_vat := j1.input_vat;
            v_comm.commission_rt := j1.commission_rt;
            v_comm.branch_name := j1.branch_name;
            v_comm.policy_no := j1.policy_no;
            v_comm.assd_name := j1.assd_name;
            v_comm.intm_name := j1.intm_name;
            v_comm.agent_code := j1.agent_code;
            v_comm.peril_name := j1.peril_name;
            PIPE ROW (v_comm);
         END LOOP;
      ELSIF p_inc_tag = 'Y'                      /* include unpaid premiums */
      THEN
         FOR j2 IN
            (SELECT DECODE (p_rep_grp,
                            'ISS_CD', b.iss_cd,
                            b.cred_branch
                           ) branch_cd,
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
                AND g.iss_cd = c.iss_cd
                AND g.prem_seq_no = c.prem_seq_no
                AND g.intrmdry_intm_no = c.intm_no
                AND g.peril_cd = c.peril_cd
                AND a.iss_cd <> giisp.v ('ISS_CD_RI')
                AND reg_policy_sw = 'Y'
                AND g.commission_amt <> 0
             UNION                   /* to include perils with 0 commission */
             SELECT DECODE (p_rep_grp,
                            'ISS_CD', b.iss_cd,
                            b.cred_branch
                           ) branch_cd,
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
                AND reg_policy_sw = 'Y'
                AND g.commission_amt = 0
                AND e.commission_amt <> 0
                AND ROUND ((e.commission_amt * a.currency_rt), 2) <>
                       (SELECT SUM (z.comm_amt)
                          FROM giac_comm_payts z
                         WHERE z.iss_cd = e.iss_cd
                           AND z.prem_seq_no = e.prem_seq_no))
         LOOP
            v_comm.branch_cd := j2.branch_cd;
            v_comm.assd_no := j2.assd_no;
            v_comm.intm_no := j2.intm_no;
            v_comm.iss_cd := j2.iss_cd;
            v_comm.prem_seq_no := j2.prem_seq_no;
            v_comm.policy_id := j2.policy_id;
            v_comm.peril_cd := j2.peril_cd;
            v_comm.premium_amt := j2.premium_amt;
            v_comm.commission_amt := j2.commission_amt;
            v_comm.wholding_tax := j2.wholding_tax;
            v_comm.input_vat := j2.input_vat;
            v_comm.commission_rt := j2.commission_rt;
            v_comm.branch_name := j2.branch_name;
            v_comm.policy_no := j2.policy_no;
            v_comm.assd_name := j2.assd_name;
            v_comm.intm_name := j2.intm_name;
            v_comm.agent_code := j2.agent_code;
            v_comm.peril_name := j2.peril_name;
            PIPE ROW (v_comm);
         END LOOP;

         RETURN;
      END IF;
   END;
END;
/


