CREATE OR REPLACE PACKAGE BODY CPI.giacr118b_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 07.03.2013
    **  Reference By : GIACR118B -  DISBURSEMENT REGISTER
    */
   FUNCTION get_details (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
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
      
      v_list.company_tin := 'VAT REG TIN ' || giisp.v('COMPANY_TIN'); -- bonok :: 3.22.2017 :: SR 5964
      v_list.gen_version := giisp.v('GEN_VERSION'); -- bonok :: 3.22.2017 :: SR 5964

      BEGIN
         IF p_post_tran_toggle = 'P'
         THEN
            v_list.post_tran := 'Based on Date Posted';
         ELSE
            IF p_dv_check_toggle = 'D'
            THEN
               v_list.post_tran := 'Based on Transaction Date (DV Date)';
            ELSIF p_dv_check_toggle = 'C'
            THEN
               v_list.post_tran := 'Based on Transaction Date (Check Date)';
            ELSE
               v_list.post_tran :=
                               'Based on Transaction Date (Check Print Date)';
            END IF;
         END IF;
      END;

      BEGIN
         IF p_date = p_date2
         THEN
            v_list.top_date :=
                 TO_CHAR (TO_DATE (p_date, 'MM/DD/YYYY'), 'fmMonth DD, YYYY');
         ELSE
            v_list.top_date :=
                  'From '
               || TO_CHAR (TO_DATE (p_date, 'MM/DD/YYYY'), 'fmMonth DD, YYYY')
               || ' to '
               || TO_CHAR (TO_DATE (p_date2, 'MM/DD/YYYY'),
                           'fmMonth DD, YYYY');
         END IF;
      END;

      PIPE ROW (v_list);
      RETURN;
   END get_details;

   FUNCTION get_all_branches (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_all_branches_tab PIPELINED
   IS
      v_list   get_all_branches_type;
   BEGIN
      FOR i IN
         (SELECT   d.gibr_gfun_fund_cd acct_gibr_gfun_fund_cd,
                      LTRIM (TO_CHAR (c.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')) "GL_ACCT_NO",
                   c.gl_acct_name "ACCT_NAME",
                   NVL (SUM (DECODE (DECODE (dv_flag,
                                             'C', DECODE (tran_flag,
                                                          'D', 0,
                                                          a.debit_amt
                                                         ),
                                             a.debit_amt
                                            ),
                                     0, 0,
                                       (  h.amount
                                        / DECODE (dv_flag,
                                                  'C', DECODE (tran_flag,
                                                               'D', 0,
                                                               dv_amt
                                                              ),
                                                  dv_amt
                                                 )
                                       )
                                     * DECODE (dv_flag,
                                               'C', DECODE (tran_flag,
                                                            'D', 0,
                                                            a.debit_amt
                                                           ),
                                               a.debit_amt
                                              )
                                    )
                            ),
                        0
                       ) "DB_AMT",
                   NVL (SUM (DECODE (DECODE (dv_flag,
                                             'C', DECODE (tran_flag,
                                                          'D', 0,
                                                          a.credit_amt
                                                         ),
                                             a.credit_amt
                                            ),
                                     0, 0,
                                       (  h.amount
                                        / DECODE (dv_flag,
                                                  'C', DECODE (tran_flag,
                                                               'D', 0,
                                                               dv_amt
                                                              ),
                                                  dv_amt
                                                 )
                                       )
                                     * DECODE (dv_flag,
                                               'C', DECODE (tran_flag,
                                                            'D', 0,
                                                            a.credit_amt
                                                           ),
                                               a.credit_amt
                                              )
                                    )
                            ),
                        0
                       ) "CD_AMT",
                   NVL
                      (  (NVL (SUM (DECODE (DECODE (dv_flag,
                                                    'C', DECODE (tran_flag,
                                                                 'D', 0,
                                                                 a.debit_amt
                                                                ),
                                                    a.debit_amt
                                                   ),
                                            0, 0,
                                              (  h.amount
                                               / DECODE (dv_flag,
                                                         'C', DECODE
                                                                   (tran_flag,
                                                                    'D', 0,
                                                                    dv_amt
                                                                   ),
                                                         dv_amt
                                                        )
                                              )
                                            * DECODE (dv_flag,
                                                      'C', DECODE (tran_flag,
                                                                   'D', 0,
                                                                   a.debit_amt
                                                                  ),
                                                      a.debit_amt
                                                     )
                                           )
                                   ),
                               0
                              )
                         )
                       - (NVL (SUM (DECODE (DECODE (dv_flag,
                                                    'C', DECODE (tran_flag,
                                                                 'D', 0,
                                                                 a.credit_amt
                                                                ),
                                                    a.credit_amt
                                                   ),
                                            0, 0,
                                              (  h.amount
                                               / DECODE (dv_flag,
                                                         'C', DECODE
                                                                   (tran_flag,
                                                                    'D', 0,
                                                                    dv_amt
                                                                   ),
                                                         dv_amt
                                                        )
                                              )
                                            * DECODE (dv_flag,
                                                      'C', DECODE
                                                                 (tran_flag,
                                                                  'D', 0,
                                                                  a.credit_amt
                                                                 ),
                                                      a.credit_amt
                                                     )
                                           )
                                   ),
                               0
                              )
                         ),
                       0
                      ) "BAL_AMT"
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_disb_vouchers d,
                   giac_payt_requests e,
                   giac_payt_requests_dtl f,
                   giac_branches gb,
                   giac_chk_disbursement h
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_id = d.gacc_tran_id
               AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
               AND d.gacc_tran_id = f.tran_id
               AND b.tran_id = h.gacc_tran_id(+)
               AND h.check_no IS NOT NULL
               AND f.gprq_ref_id = e.ref_id
               AND a.gl_acct_category = c.gl_acct_category
               AND a.gl_control_acct = c.gl_control_acct
               AND a.gl_sub_acct_1 = c.gl_sub_acct_1
               AND a.gl_sub_acct_2 = c.gl_sub_acct_2
               AND a.gl_sub_acct_3 = c.gl_sub_acct_3
               AND a.gl_sub_acct_4 = c.gl_sub_acct_4
               AND a.gl_sub_acct_5 = c.gl_sub_acct_5
               AND a.gl_sub_acct_6 = c.gl_sub_acct_6
               AND a.gl_sub_acct_7 = c.gl_sub_acct_7
               AND d.gibr_branch_cd = gb.branch_cd
               AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                d.gibr_branch_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1*/ --replaced by codes below by pjsantos 11/14/2016 for optimization
               AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = d.gibr_branch_cd) 
                --pjsantos end
               AND (   (    TRUNC (posting_date) BETWEEN TO_DATE (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                     AND TO_DATE (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'P'
                        AND d.dv_flag IN ('C', 'P')
                       )
                    OR (    TRUNC (posting_date) BETWEEN TO_DATE (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                     AND TO_DATE (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'P'
                        AND b.tran_flag = 'D'
                        AND d.dv_flag = 'C'
                       )
                    OR (    p_post_tran_toggle = 'T'
                        AND (   (    p_dv_check_toggle = 'D'
                                 AND TRUNC (d.dv_date)
                                        BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                                            AND TO_DATE (p_date2,
                                                         'MM/DD/YYYY')
                                )
                             OR (    p_dv_check_toggle = 'C'
                                 AND TRUNC (h.check_date)
                                        BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                                            AND TO_DATE (p_date2,
                                                         'MM/DD/YYYY')
                                )
                             OR (    p_dv_check_toggle = 'P'
                                 AND TRUNC (h.check_print_date)
                                        BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                                            AND TO_DATE (p_date2,
                                                         'MM/DD/YYYY')
                                )
                            )
                       )
                   )
               AND (   (tran_flag = 'P' AND p_post_tran_toggle = 'P')
                    OR (    b.tran_flag IN ('C', 'P', 'D')
                        AND d.dv_flag IN ('C', 'P')
                        AND p_post_tran_toggle = 'T'
                       )
                   )
          GROUP BY d.gibr_gfun_fund_cd,
                      LTRIM (TO_CHAR (c.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')),
                   c.gl_acct_name
          ORDER BY 1)
      LOOP
         v_list.acct_gibr_gfun_fund_cd := i.acct_gibr_gfun_fund_cd;
         v_list.bal_amt := i.bal_amt;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;

         IF p_branch IS NULL
         THEN
            v_list.branch := 'ALL BRANCHES';
         ELSE
            FOR c IN (SELECT a.branch_name branch
                        FROM giac_branches a
                       WHERE a.branch_cd = p_branch)
            LOOP
               v_list.branch := c.branch;
            END LOOP;
         END IF;

         PIPE ROW (v_list);
      END LOOP;
   END get_all_branches;

   FUNCTION get_by_branches (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_branch_check       VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_by_branches_tab PIPELINED
   IS
      v_list   get_by_branches_type;
   BEGIN
      FOR i IN
         (SELECT   d.gibr_gfun_fund_cd acct_gibr_gfun_fund_cd,
                   d.gibr_branch_cd acct_gibr_branch_cd,
                   gb.branch_name acct_branch_name,
                      LTRIM (TO_CHAR (c.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')) "GL_ACCT_NO",
                   c.gl_acct_name "ACCT_NAME",
                   NVL (SUM (DECODE (DECODE (dv_flag,
                                             'C', DECODE (tran_flag,
                                                          'D', 0,
                                                          a.debit_amt
                                                         ),
                                             a.debit_amt
                                            ),
                                     0, 0,
                                       (  h.amount
                                        / DECODE (dv_flag,
                                                  'C', DECODE (tran_flag,
                                                               'D', 0,
                                                               dv_amt
                                                              ),
                                                  dv_amt
                                                 )
                                       )
                                     * DECODE (dv_flag,
                                               'C', DECODE (tran_flag,
                                                            'D', 0,
                                                            a.debit_amt
                                                           ),
                                               a.debit_amt
                                              )
                                    )
                            ),
                        0
                       ) "DB_AMT",
                   NVL (SUM (DECODE (DECODE (dv_flag,
                                             'C', DECODE (tran_flag,
                                                          'D', 0,
                                                          a.credit_amt
                                                         ),
                                             a.credit_amt
                                            ),
                                     0, 0,
                                       (  h.amount
                                        / DECODE (dv_flag,
                                                  'C', DECODE (tran_flag,
                                                               'D', 0,
                                                               dv_amt
                                                              ),
                                                  dv_amt
                                                 )
                                       )
                                     * DECODE (dv_flag,
                                               'C', DECODE (tran_flag,
                                                            'D', 0,
                                                            a.credit_amt
                                                           ),
                                               a.credit_amt
                                              )
                                    )
                            ),
                        0
                       ) "CD_AMT",
                   NVL
                      (  (NVL (SUM (DECODE (DECODE (dv_flag,
                                                    'C', DECODE (tran_flag,
                                                                 'D', 0,
                                                                 a.debit_amt
                                                                ),
                                                    a.debit_amt
                                                   ),
                                            0, 0,
                                              (  h.amount
                                               / DECODE (dv_flag,
                                                         'C', DECODE
                                                                   (tran_flag,
                                                                    'D', 0,
                                                                    dv_amt
                                                                   ),
                                                         dv_amt
                                                        )
                                              )
                                            * DECODE (dv_flag,
                                                      'C', DECODE (tran_flag,
                                                                   'D', 0,
                                                                   a.debit_amt
                                                                  ),
                                                      a.debit_amt
                                                     )
                                           )
                                   ),
                               0
                              )
                         )
                       - (NVL (SUM (DECODE (DECODE (dv_flag,
                                                    'C', DECODE (tran_flag,
                                                                 'D', 0,
                                                                 a.credit_amt
                                                                ),
                                                    a.credit_amt
                                                   ),
                                            0, 0,
                                              (  h.amount
                                               / DECODE (dv_flag,
                                                         'C', DECODE
                                                                   (tran_flag,
                                                                    'D', 0,
                                                                    dv_amt
                                                                   ),
                                                         dv_amt
                                                        )
                                              )
                                            * DECODE (dv_flag,
                                                      'C', DECODE
                                                                 (tran_flag,
                                                                  'D', 0,
                                                                  a.credit_amt
                                                                 ),
                                                      a.credit_amt
                                                     )
                                           )
                                   ),
                               0
                              )
                         ),
                       0
                      ) "BAL_AMT"
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_disb_vouchers d,
                   giac_payt_requests e,
                   giac_payt_requests_dtl f,
                   giac_branches gb,
                   giac_chk_disbursement h
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_id = d.gacc_tran_id
               AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
               AND h.check_no IS NOT NULL
               AND b.tran_id = h.gacc_tran_id(+)
               AND d.gacc_tran_id = f.tran_id
               AND f.gprq_ref_id = e.ref_id
               AND a.gl_acct_category = c.gl_acct_category 
               AND a.gl_control_acct = c.gl_control_acct
               AND a.gl_sub_acct_1 = c.gl_sub_acct_1
               AND a.gl_sub_acct_2 = c.gl_sub_acct_2
               AND a.gl_sub_acct_3 = c.gl_sub_acct_3
               AND a.gl_sub_acct_4 = c.gl_sub_acct_4
               AND a.gl_sub_acct_5 = c.gl_sub_acct_5
               AND a.gl_sub_acct_6 = c.gl_sub_acct_6
               AND a.gl_sub_acct_7 = c.gl_sub_acct_7
               AND d.gibr_branch_cd = gb.branch_cd
               AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                d.gibr_branch_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1*/--replaced by codes below by pjsantos 11/14/2016 for optimization
               AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = d.gibr_branch_cd) 
                --pjsantos end
               AND (   (    TRUNC (posting_date) BETWEEN TO_DATE (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                     AND TO_DATE (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'P'
                        AND d.dv_flag IN ('C', 'P')
                       )
                    OR (    TRUNC (posting_date) BETWEEN TO_DATE (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                     AND TO_DATE (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'P'
                        AND b.tran_flag = 'D'
                        AND d.dv_flag = 'C'
                       )
                    OR (    p_post_tran_toggle = 'T'
                        AND (   (    p_dv_check_toggle = 'D'
                                 AND TRUNC (d.dv_date)
                                        BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                                            AND TO_DATE (p_date2,
                                                         'MM/DD/YYYY')
                                )
                             OR (    p_dv_check_toggle = 'C'
                                 AND TRUNC (h.check_date)
                                        BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                                            AND TO_DATE (p_date2,
                                                         'MM/DD/YYYY')
                                )
                             OR (    p_dv_check_toggle = 'P'
                                 AND TRUNC (h.check_print_date)
                                        BETWEEN TO_DATE (p_date, 'MM/DD/YYYY')
                                            AND TO_DATE (p_date2,
                                                         'MM/DD/YYYY')
                                )
                            )
                       )
                   )
               AND (   (tran_flag = 'P' AND p_post_tran_toggle = 'P')
                    OR (tran_flag IN ('C', 'P') AND p_post_tran_toggle = 'T')
                   )
               AND p_branch_check = 'Y'
          GROUP BY d.gibr_gfun_fund_cd,
                   d.gibr_branch_cd,
                   gb.branch_name,
                      LTRIM (TO_CHAR (c.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09')),
                   c.gl_acct_name
          ORDER BY 1)
      LOOP
         v_list.acct_gibr_gfun_fund_cd := i.acct_gibr_gfun_fund_cd;
         v_list.acct_gibr_branch_cd := i.acct_gibr_branch_cd;
         v_list.acct_branch_name := i.acct_branch_name;
         v_list.bal_amt := i.bal_amt;
         v_list.gl_acct_no := i.gl_acct_no;
         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         PIPE ROW(v_list);
      END LOOP;
   END get_by_branches;
END giacr118b_pkg;
/


