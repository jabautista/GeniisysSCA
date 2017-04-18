CREATE OR REPLACE PACKAGE BODY CPI.giacr118_pkg
AS
/*
    **  Created by   :  Ildefonso Ellarina Jr
    **  Date Created : 06.21.2013
    **  Reference By : GIACR118 -  DISBURSEMENT REGISTER
    */
   FUNCTION get_details (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_dv_check           VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_details_tab PIPELINED
   IS
      v_list   get_details_type;
      v_count  NUMBER := 0;
      v_fr_dt  DATE := TO_DATE (p_date, 'MM/DD/YYYY');  --Deo [03.13.2017]: SR-23914
      v_to_dt  DATE := TO_DATE (p_date2, 'MM/DD/YYYY'); --Deo [03.13.2017]: SR-23914
      v_wt_ae  VARCHAR2 (1) := 'N';  --Deo [03.13.2017]: SR-23914
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
            v_list.post_tran := 'Based on Posting Date';
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

      FOR i IN
         /* --Deo [03.13.2017]: comment out starts (SR-23914)
         (SELECT   LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                   b.tran_class || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                   d.ref_no, d.gibr_gfun_fund_cd, d.gibr_branch_cd,
                   gb.branch_name,
                      e.document_cd
                   || '-'
                   || e.branch_cd
                   || '-'
                   || e.doc_seq_no "REQUEST NO.",
                   a.gl_acct_category, a.gl_control_acct, d.payee "PAYEE",
                   b.posting_date, b.user_id, b.last_update,
                   d.particulars "PARTICULARS",
                   DECODE (DECODE (dv_flag,
                                   'C', DECODE (tran_flag, 'D', 0, dv_amt),
                                   dv_amt
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
                                     'C', DECODE (tran_flag, 'D', 0, dv_amt),
                                     dv_amt
                                    )
                          ) "DV_AMT",
                      a.gl_acct_category
                   || '-'
                   || LPAD (a.gl_control_acct, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_1, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_2, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_3, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_4, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_5, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_6, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_7, 2, 0) "GL_ACCOUNT",
                   c.gl_acct_name "GL_ACCOUNT_NAME", a.sl_cd,
                   NVL (DECODE (DECODE (dv_flag,
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
                               ),
                        0
                       ) debit_amt,
                   NVL (DECODE (DECODE (dv_flag,
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
                               ),
                        0
                       ) credit_amt,
                   b.tran_flag, b.tran_class, b.tran_date, d.dv_flag,
                   a.acct_entry_id,
                   TO_CHAR (h.check_date, 'MM-DD-YYYY') chk_date,
                      DECODE (h.check_pref_suf,
                              NULL, NULL,
                              h.check_pref_suf || '-'
                             )
                   || LPAD (h.check_no, 10, 0) check_no,
                   h.item_no, h.amount,
                   DECODE (p_dv_check,
                           'V', dv_no,
                           'CH', h.check_no
                          ) dv_check_order,
                   DECODE (p_dv_check,
                           'V', b.tran_class || '-' || d.dv_no,
                           'CH', DECODE (h.check_pref_suf, NULL, NULL, h.check_pref_suf || '-' ) || LPAD (h.check_no, 10, 0)
                          ) dv_check_order2,
                   gp.tin
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_disb_vouchers d,
                   giac_payt_requests e,
                   giac_payt_requests_dtl f,
                   giac_branches gb,
                   giac_chk_disbursement h,
                   giis_payees gp
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_id = d.gacc_tran_id
               AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
               AND b.tran_id = h.gacc_tran_id(+)
               AND h.check_no IS NOT NULL
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
                                               ) = 1*/
               -- replacement for function above : shan 11.05.2014
               /*AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = d.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1 
                    OR 
                    (SELECT access_tag
                       FROM giis_user_grp_modules
                      WHERE module_id = p_module_id
                        AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                       FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                      WHERE a.user_grp = b.user_grp
                                                        AND a.user_id = p_user_id
                                                        AND b.iss_cd = d.gibr_branch_cd
                                                        AND b.tran_cd = c.tran_cd
                                                        AND c.module_id = p_module_id)) = 1)*--replaced by codes below by pjsantos 11/14/2016, for optimization GENQA 5765
                      AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = d.gibr_branch_cd )  
                     --pjsantos end
               -- end of replacement : 11.05.2014
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
               AND gp.payee_no = f.payee_cd
               AND gp.payee_class_cd = f.payee_class_cd
          UNION
          SELECT   LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                   b.tran_class || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                   d.ref_no, d.gibr_gfun_fund_cd, d.gibr_branch_cd,
                   gb.branch_name,
                      e.document_cd
                   || '-'
                   || e.branch_cd
                   || '-'
                   || e.doc_seq_no "REQUEST NO.",
                   a.gl_acct_category, a.gl_control_acct,
                   DECODE (d.dv_flag, 'C', d.payee, 'SPOILED') "PAYEE",
                   b.posting_date, b.user_id, b.last_update,
                   DECODE (d.dv_flag,
                           'C', d.particulars,
                           'SPOILED'
                          ) "PARTICULARS",
                   0 "DV_AMT",
                      a.gl_acct_category
                   || '-'
                   || a.gl_control_acct
                   || '-'
                   || a.gl_sub_acct_1
                   || '-'
                   || a.gl_sub_acct_2
                   || '-'
                   || a.gl_sub_acct_3
                   || '-'
                   || a.gl_sub_acct_4
                   || '-'
                   || a.gl_sub_acct_5
                   || '-'
                   || a.gl_sub_acct_6
                   || '-'
                   || a.gl_sub_acct_7 "GL_ACCOUNT",
                   c.gl_acct_name "GL_ACCOUNT_NAME", a.sl_cd, 0 debit_amt,
                   0 credit_amt, b.tran_flag, b.tran_class, b.tran_date,
                   d.dv_flag, a.acct_entry_id,
                   TO_CHAR (gsc.check_date, 'MM-DD-YYYY') chk_date,
                      DECODE (gsc.check_pref_suf,
                              NULL, NULL,
                              gsc.check_pref_suf || '-'
                             )
                   || LPAD (gsc.check_no, 10, 0) check_no,
                   item_no, amount,
                   DECODE (p_dv_check,
                           'V', d.dv_no,
                           'CH', gsc.check_no
                          ) dv_check_order,
                   DECODE (p_dv_check,
                           'V', b.tran_class || '-' || d.dv_no,
                           'CH', DECODE (gsc.check_pref_suf, NULL, NULL, gsc.check_pref_suf || '-' ) || LPAD (gsc.check_no, 10, 0)
                          ) dv_check_order2,
                   gp.tin
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_disb_vouchers d,
                   giac_payt_requests e,
                   giac_payt_requests_dtl f,
                   giac_branches gb,
                   giac_spoiled_check gsc,
                   giis_payees gp
             WHERE b.tran_id = gsc.gacc_tran_id(+)
               AND a.gacc_tran_id = b.tran_id
               AND DECODE (d.dv_flag, 'C', f.payee, 'SPOILED') = 'SPOILED'
               AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
               AND b.tran_id = d.gacc_tran_id
               AND gsc.check_no IS NOT NULL
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
                                               ) = 1*/
               -- replacement for function above : shan 11.05.2014
               /*AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = d.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1
                    OR 
                    (SELECT access_tag
                       FROM giis_user_grp_modules
                      WHERE module_id = p_module_id
                        AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                       FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                      WHERE a.user_grp = b.user_grp
                                                        AND a.user_id = p_user_id
                                                        AND b.iss_cd = d.gibr_branch_cd
                                                        AND b.tran_cd = c.tran_cd
                                                        AND c.module_id = p_module_id)) = 1)*--replaced by pjsantos 11/14/2016, for optimization GENQA 5765
               AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = d.gibr_branch_cd) 
                --pjsantos end
               -- end of replacement : 11.05.2014
               AND (   (    TRUNC (posting_date) BETWEEN TO_DATE (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                     AND TO_DATE (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'P'
                       )
                    OR (    TRUNC (gsc.check_date) BETWEEN TO_DATE
                                                                 (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                       AND TO_DATE
                                                                 (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND gp.payee_no = f.payee_cd
               AND gp.payee_class_cd = f.payee_class_cd
          ORDER BY dv_check_order2)*/  --Deo [03.13.2017]: comment out ends (SR-23914)

         --Deo [03.13.2017]: add starts (SR-23914)
         (SELECT   main_sql.*
              FROM (SELECT LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                           d.dv_pref || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                           d.ref_no, d.gibr_gfun_fund_cd, d.gibr_branch_cd,
                           gb.branch_name, d.payee, b.posting_date, d.particulars,
                           DECODE (d.dv_flag, 'C', DECODE (b.tran_flag, 'D', 0, d.dv_amt),
                                   d.dv_amt) dv_amt,
                           b.tran_flag, d.dv_flag, h.chk_date, h.check_no,
                           h.amount, gp.tin,
                           DECODE (p_dv_check, 'V', d.dv_pref || '-' || d.dv_no,
                                   'CH', h2.min_chk_no) order_1,
                           min_chk_no
                      FROM giac_acctrans b,
                           giac_disb_vouchers d,
                           giac_branches gb,
                           (SELECT     gacc_tran_id,
                                       REPLACE (SUBSTR (SYS_CONNECT_BY_PATH (check_no, '^%$#@!'), 7), '^%$#@!',
                                                CHR (13)) check_no,
                                       REPLACE (SUBSTR (SYS_CONNECT_BY_PATH (check_date, ';'), 2), ';',
                                                CHR (13)) chk_date,
                                       REPLACE (SUBSTR (SYS_CONNECT_BY_PATH (amount, ';'), 2), ';',
                                                CHR (13)) amount
                                  FROM (SELECT h1.*, COUNT (*) OVER (PARTITION BY gacc_tran_id) cnt,
                                               ROW_NUMBER () OVER (PARTITION BY gacc_tran_id ORDER BY DECODE
                                                            (p_dv_check, 'V', TO_CHAR (item_no), check_no
                                                            )) seq
                                          FROM (SELECT   gacc_tran_id, item_no,
                                                         DECODE (check_pref_suf, NULL, NULL,
                                                                 check_pref_suf || '-'
                                                                ) || LPAD (check_no, 10, 0) check_no,
                                                         TO_CHAR (check_date, 'MM-DD-YYYY') check_date,
                                                         TO_CHAR (amount, 'fm999,999,999,990.00') amount
                                                    FROM giac_chk_disbursement
                                                   WHERE (   (    p_post_tran_toggle = 'P'
                                                              AND 1 = 1
                                                             )
                                                          OR (    p_post_tran_toggle = 'T'
                                                              AND (   (    p_dv_check_toggle = 'D'
                                                                       AND 1 = 1
                                                                      )
                                                                   OR (    p_dv_check_toggle = 'C'
                                                                       AND TRUNC (check_date)
                                                                              BETWEEN v_fr_dt
                                                                                  AND v_to_dt
                                                                      )
                                                                   OR (    p_dv_check_toggle = 'P'
                                                                       AND TRUNC (check_print_date)
                                                                              BETWEEN v_fr_dt
                                                                                  AND v_to_dt
                                                                      )
                                                                  )
                                                             )
                                                         )
                                                ORDER BY DECODE (p_dv_check, 'V', item_no, 3)) h1)
                                 WHERE seq = cnt
                            START WITH seq = 1
                            CONNECT BY PRIOR seq + 1 = seq
                                   AND PRIOR gacc_tran_id = gacc_tran_id) h,
                           (SELECT   gacc_tran_id,
                                     MIN (  DECODE (check_pref_suf, NULL, NULL, check_pref_suf || '-')
                                         || check_no) min_chk_no
                                FROM giac_chk_disbursement
                               WHERE (   (p_post_tran_toggle = 'P' AND 1 = 1
                                         )
                                      OR (    p_post_tran_toggle = 'T'
                                          AND (   (    p_dv_check_toggle = 'D'
                                                   AND 1 = 1
                                                  )
                                               OR (    p_dv_check_toggle = 'C'
                                                   AND TRUNC (check_date)
                                                          BETWEEN v_fr_dt
                                                              AND v_to_dt
                                                  )
                                               OR (    p_dv_check_toggle = 'P'
                                                   AND TRUNC (check_print_date)
                                                          BETWEEN v_fr_dt
                                                              AND v_to_dt
                                                  )
                                              )
                                         )
                                     )
                            GROUP BY gacc_tran_id) h2,
                           giis_payees gp
                     WHERE b.tran_id = d.gacc_tran_id
                       AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
                       AND b.tran_id = h.gacc_tran_id(+)
                       AND b.tran_id = h2.gacc_tran_id(+)
                       AND h.check_no IS NOT NULL
                       AND d.gibr_branch_cd = gb.branch_cd
                       AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
                       AND d.payee_no = gp.payee_no(+)
                       AND d.payee_class_cd = gp.payee_class_cd(+)
                       AND EXISTS (
                              SELECT 'X'
                                FROM TABLE (security_access.get_branch_line
                                                                  ('AC',
                                                                   p_module_id,
                                                                   p_user_id
                                                                  ))
                               WHERE branch_cd = d.gibr_branch_cd)
                       AND (   (    TRUNC (posting_date) BETWEEN v_fr_dt
                                                             AND v_to_dt
                                AND p_post_tran_toggle = 'P'
                                AND d.dv_flag IN ('C', 'P')
                               )
                            OR (    TRUNC (posting_date) BETWEEN v_fr_dt
                                                             AND v_to_dt
                                AND p_post_tran_toggle = 'P'
                                AND b.tran_flag = 'D'
                                AND d.dv_flag = 'C'
                               )
                            OR (    p_post_tran_toggle = 'T'
                                AND (   (    p_dv_check_toggle = 'D'
                                         AND TRUNC (d.dv_date) BETWEEN v_fr_dt
                                                                   AND v_to_dt
                                        )
                                     OR (    p_dv_check_toggle IN ('C', 'P')
                                         AND 1 = 1
                                        )
                                    )
                               )
                           )
                       AND (   (tran_flag = 'P' AND p_post_tran_toggle = 'P'
                               )
                            OR (    b.tran_flag IN ('C', 'P', 'D')
                                AND d.dv_flag IN ('C', 'P')
                                AND p_post_tran_toggle = 'T'
                               )
                           )
                    UNION
                    SELECT LPAD (d.gacc_tran_id, 12, 0),
                           d.dv_pref || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                           d.ref_no, d.gibr_gfun_fund_cd, d.gibr_branch_cd,
                           gb.branch_name,
                           DECODE (d.dv_flag, 'C', d.payee, 'SPOILED') payee,
                           b.posting_date,
                           DECODE (d.dv_flag, 'C', d.particulars, 'SPOILED') particulars,
                           0 dv_amt, b.tran_flag, d.dv_flag,
                           TO_CHAR (gsc.check_date, 'MM-DD-YYYY') chk_date,
                           DECODE (gsc.check_pref_suf, NULL, NULL, gsc.check_pref_suf || '-')
                                   || LPAD (gsc.check_no, 10, 0) check_no,
                           TO_CHAR (gsc.amount, 'fm999,999,999,990.00') amount, gp.tin,
                           DECODE (p_dv_check, 'V', d.dv_pref || '-' || d.dv_no,
                                   'CH', DECODE (gsc.check_pref_suf, NULL, NULL, gsc.check_pref_suf || '-')
                                   || gsc.check_no) order_1,
                           DECODE (gsc.check_pref_suf, NULL, NULL, gsc.check_pref_suf || '-')
                                   || gsc.check_no min_chk_no
                      FROM giac_acctrans b,
                           giac_disb_vouchers d,
                           giac_branches gb,
                           giac_spoiled_check gsc,
                           giis_payees gp
                     WHERE b.tran_id = gsc.gacc_tran_id(+)
                       AND DECODE (d.dv_flag, 'C', d.payee, 'SPOILED') = 'SPOILED'
                       AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
                       AND b.tran_id = d.gacc_tran_id
                       AND gsc.check_no IS NOT NULL
                       AND d.gibr_branch_cd = gb.branch_cd
                       AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
                       AND d.payee_no = gp.payee_no(+)
                       AND d.payee_class_cd = gp.payee_class_cd(+)
                       AND EXISTS (
                              SELECT 'X'
                                FROM TABLE (security_access.get_branch_line
                                                                  ('AC',
                                                                   p_module_id,
                                                                   p_user_id
                                                                  ))
                               WHERE branch_cd = d.gibr_branch_cd)
                       AND (   (    TRUNC (posting_date) BETWEEN v_fr_dt
                                                             AND v_to_dt
                                AND p_post_tran_toggle = 'P'
                               )
                            OR (    TRUNC (gsc.check_date) BETWEEN v_fr_dt
                                                               AND v_to_dt
                                AND p_post_tran_toggle = 'T'
                               )
                           )) main_sql
          ORDER BY order_1, gacc_tran_id, min_chk_no)
          --Deo [03.13.2017]: add ends (SR-23914)
      LOOP
         v_count := 1;
         v_list.dv_amt := NULL;
         v_list.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.branch_name := i.branch_name;
         /*v_list.dv_check_order := i.dv_check_order;
         v_list.dv_check_order2 := i.dv_check_order2;*/  --Deo [03.13.2017]: comment out (SR-23914)
         v_list.ref_no := i.ref_no;
         v_list.posting_date := i.posting_date;
         v_list.dv_no := i.dv_no;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.check_no := i.check_no;
         v_list.chk_date := i.chk_date;
         v_list.tin := i.tin;
         v_list.dv_flag := i.dv_flag;
         v_list.tran_flag := i.tran_flag;
         /*v_list.gl_account := i.gl_account;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_account_name := i.gl_account_name;
         v_list.sl_cd := i.sl_cd;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.gl_account := NULL;
               v_list.gl_control_acct := NULL;
               v_list.gl_account_name := NULL;
               v_list.sl_cd := NULL;
               v_list.debit_amt := NULL;
               v_list.credit_amt := NULL;
            ELSIF i.dv_flag = 'C'
            THEN
               IF i.tran_flag = 'D'
               THEN
                  v_list.gl_account := NULL;
                  v_list.gl_control_acct := NULL;
                  v_list.gl_account_name := NULL;
                  v_list.sl_cd := NULL;
                  v_list.debit_amt := NULL;
                  v_list.credit_amt := NULL;
               END IF;
            END IF;
         END;

         BEGIN
            IF i.dv_flag = 'C'
            THEN
               v_list.chk_amt := NULL;
            ELSE
               v_list.chk_amt := i.amount;
            END IF;
         END;*/  --Deo [03.13.2017]: comment out (SR-23914)

         --Deo [03.13.2017]: add starts (SR-23914)
         IF     v_list.gl_account IS NULL
            AND v_wt_ae = 'N'
            AND i.payee != 'SPOILED'
         THEN
            FOR ae IN (SELECT 1
                         FROM giac_acct_entries
                        WHERE gacc_tran_id = i.gacc_tran_id
                          AND DECODE (i.dv_flag, 'C',
                                      DECODE (i.tran_flag, 'D', 0, 1), 1) = 1)
            LOOP
               v_wt_ae := 'Y';
               EXIT;
            END LOOP;
         END IF;
         
         IF v_list.gl_account IS NULL AND v_wt_ae = 'Y'
         THEN
            v_list.gl_account := 1;
         END IF;
         
         v_list.chk_amt := i.amount;
         --Deo [03.13.2017]: add ends (SR-23914)
         
         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.payee := 'SPOILED';
            ELSIF i.dv_flag = 'C' AND i.tran_flag <> 'D'
            THEN
               v_list.payee := i.payee;
            ELSIF i.dv_flag = 'C' AND i.tran_flag = 'D'
            THEN
               v_list.payee := 'CANCELLED';
            ELSE
               v_list.payee := i.payee;
            END IF;
         END;

         BEGIN
            IF i.dv_flag = 'C'
            THEN
               IF i.tran_flag = 'D'
               THEN
                  v_list.cancelled := NULL;
               ELSIF i.tran_flag <> 'D'
               THEN
                  IF i.payee IN ('SPOILED')
                  THEN
                     v_list.cancelled := NULL;
                  ELSIF i.tran_flag = 'P'
                  THEN
                     v_list.cancelled := '(CANCELLED)';
                  ELSIF i.tran_flag <> 'P'
                  THEN
                     v_list.cancelled := NULL;
                  ELSE
                     v_list.cancelled := '(CANCELLED)';
                  END IF;
               END IF;
            ELSE
               v_list.cancelled := NULL;
            END IF;
         END;

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.dv_amt := NULL;
            ELSIF i.dv_flag = 'C' AND i.tran_flag = 'P'
            THEN
               v_list.dv_amt := i.dv_amt;
            ELSIF i.dv_flag = 'C' AND i.tran_flag <> 'P'
            THEN
               v_list.dv_amt := NULL;
            ELSE
               v_list.dv_amt := i.dv_amt;
            END IF;
         END;

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.particulars := NULL;
            END IF;

            IF i.dv_flag = 'C'
            THEN
               IF i.tran_flag = 'D'
               THEN
                  v_list.particulars := NULL;
               ELSIF i.tran_flag <> 'D'
               THEN
                  v_list.particulars := i.particulars;
               END IF;
            ELSE
               v_list.particulars := i.particulars;
            END IF;
         END;

         PIPE ROW (v_list);
      END LOOP;

      IF v_count = 0 THEN
        PIPE ROW(v_list);
      END IF;
      
      RETURN;
   END get_details;
/*Modified by pjsantos 11/14/2016, for optimization GENQA 5765*/
   FUNCTION get_gl (P_GACC_TRAN_ID VARCHAR2
      /*p_post_tran_toggle    VARCHAR2,
      p_dv_check_toggle     VARCHAR2,
      p_date                VARCHAR2,
      p_date2               VARCHAR2,
      p_dv_check            VARCHAR2,
      p_branch              VARCHAR2,
      p_module_id           VARCHAR2,
      p_gibr_gfun_fund_cd   VARCHAR2,
      p_gibr_branch_cd      VARCHAR2,
      p_dv_no               VARCHAR2,
      p_check_no            VARCHAR2,
      p_user_id             VARCHAR2*/
   )
      RETURN get_gl_tab PIPELINED
   IS
      v_list   get_gl_rec;
   BEGIN
      FOR i IN
         (/*SELECT   LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                   b.tran_class || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                   d.ref_no, d.gibr_gfun_fund_cd, d.gibr_branch_cd,
                   gb.branch_name,
                      e.document_cd
                   || '-'
                   || e.branch_cd
                   || '-'
                   || e.doc_seq_no "REQUEST NO.",
                   a.gl_acct_category, a.gl_control_acct, d.payee "PAYEE",
                   b.posting_date, b.user_id, b.last_update,
                   d.particulars "PARTICULARS",
                   DECODE (DECODE (dv_flag,
                                   'C', DECODE (tran_flag, 'D', 0, dv_amt),
                                   dv_amt
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
                                     'C', DECODE (tran_flag, 'D', 0, dv_amt),
                                     dv_amt
                                    )
                          ) "DV_AMT",
                      a.gl_acct_category
                   || '-'
                   || LPAD (a.gl_control_acct, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_1, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_2, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_3, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_4, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_5, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_6, 2, 0)
                   || '-'
                   || LPAD (a.gl_sub_acct_7, 2, 0) "GL_ACCOUNT",
                   c.gl_acct_name "GL_ACCOUNT_NAME", a.sl_cd,
                   NVL (DECODE (DECODE (dv_flag,
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
                               ),
                        0
                       ) debit_amt,
                   NVL (DECODE (DECODE (dv_flag,
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
                               ),
                        0
                       ) credit_amt,
                   b.tran_flag, b.tran_class, b.tran_date, d.dv_flag,
                   a.acct_entry_id,
                   TO_CHAR (h.check_date, 'MM-DD-YYYY') chk_date,
                      DECODE (h.check_pref_suf,
                              NULL, NULL,
                              h.check_pref_suf || '-'
                             )
                   || LPAD (h.check_no, 10, 0) check_no,
                   h.item_no, h.amount,
                   DECODE (p_dv_check,
                           'V', dv_no,
                           'CH', h.check_no
                          ) dv_check_order,
                   gp.tin*
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_disb_vouchers d,
                   giac_payt_requests e,
                   giac_payt_requests_dtl f,
                   giac_branches gb,
                   giac_chk_disbursement h,
                   giis_payees gp
             WHERE a.gacc_tran_id = b.tran_id
               AND b.tran_id = d.gacc_tran_id
               AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
               AND b.tran_id = h.gacc_tran_id(+)
               AND h.check_no IS NOT NULL
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
              -- AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                d.gibr_branch_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1*/
               -- replacement for function above : shan 11.05.2014
            /*   AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = d.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1
                    OR 
                    (SELECT access_tag
                       FROM giis_user_grp_modules
                      WHERE module_id = p_module_id
                        AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                       FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                      WHERE a.user_grp = b.user_grp
                                                        AND a.user_id = p_user_id
                                                        AND b.iss_cd = d.gibr_branch_cd
                                                        AND b.tran_cd = c.tran_cd
                                                        AND c.module_id = p_module_id)) = 1)
               -- end of replacement : 11.05.2014                                
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
               AND gp.payee_no = f.payee_cd
               AND gp.payee_class_cd = f.payee_class_cd
               AND d.gibr_gfun_fund_cd =
                                NVL (p_gibr_gfun_fund_cd, d.gibr_gfun_fund_cd)
               AND d.gibr_branch_cd = NVL (p_gibr_branch_cd, d.gibr_branch_cd)
               AND b.tran_class || '-' || LPAD (d.dv_no, 10, 0) =
                      NVL (p_dv_no,
                           b.tran_class || '-' || LPAD (d.dv_no, 10, 0)
                          )
               AND    DECODE (h.check_pref_suf,
                              NULL, NULL,
                              h.check_pref_suf || '-'
                             )
                   || LPAD (h.check_no, 10, 0) =
                      NVL (p_check_no,
                              DECODE (h.check_pref_suf,
                                      NULL, NULL,
                                      h.check_pref_suf || '-'
                                     )
                           || LPAD (h.check_no, 10, 0)
                          )
          UNION
          SELECT   LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                   b.tran_class || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                   d.ref_no, d.gibr_gfun_fund_cd, d.gibr_branch_cd,
                   gb.branch_name,
                      e.document_cd
                   || '-'
                   || e.branch_cd
                   || '-'
                   || e.doc_seq_no "REQUEST NO.",
                   a.gl_acct_category, a.gl_control_acct,
                   DECODE (d.dv_flag, 'C', d.payee, 'SPOILED') "PAYEE",
                   b.posting_date, b.user_id, b.last_update,
                   DECODE (d.dv_flag,
                           'C', d.particulars,
                           'SPOILED'
                          ) "PARTICULARS",
                   0 "DV_AMT",
                      a.gl_acct_category
                   || '-'
                   || a.gl_control_acct
                   || '-'
                   || a.gl_sub_acct_1
                   || '-'
                   || a.gl_sub_acct_2
                   || '-'
                   || a.gl_sub_acct_3
                   || '-'
                   || a.gl_sub_acct_4
                   || '-'
                   || a.gl_sub_acct_5
                   || '-'
                   || a.gl_sub_acct_6
                   || '-'
                   || a.gl_sub_acct_7 "GL_ACCOUNT",
                   c.gl_acct_name "GL_ACCOUNT_NAME", a.sl_cd, 0 debit_amt,
                   0 credit_amt, b.tran_flag, b.tran_class, b.tran_date,
                   d.dv_flag, a.acct_entry_id,
                   TO_CHAR (gsc.check_date, 'MM-DD-YYYY') chk_date,
                      DECODE (gsc.check_pref_suf,
                              NULL, NULL,
                              gsc.check_pref_suf || '-'
                             )
                   || LPAD (gsc.check_no, 10, 0) check_no,
                   item_no, amount,
                   DECODE (p_dv_check,
                           'V', d.dv_no,
                           'CH', gsc.check_no
                          ) dv_check_order,
                   gp.tin
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_disb_vouchers d,
                   giac_payt_requests e,
                   giac_payt_requests_dtl f,
                   giac_branches gb,
                   giac_spoiled_check gsc,
                   giis_payees gp
             WHERE b.tran_id = gsc.gacc_tran_id(+)
               AND a.gacc_tran_id = b.tran_id
               AND DECODE (d.dv_flag, 'C', f.payee, 'SPOILED') = 'SPOILED'
               AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
               AND b.tran_id = d.gacc_tran_id
               AND gsc.check_no IS NOT NULL
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
               --AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
               /*AND check_user_per_iss_cd_acctg2 (NULL,
                                                d.gibr_branch_cd,
                                                p_module_id,
                                                p_user_id
                                               ) = 1*/
               -- replacement for function above : shan 11.05.2014
               /*AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = d.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1
                    OR 
                    (SELECT access_tag
                       FROM giis_user_grp_modules
                      WHERE module_id = p_module_id
                        AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                       FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                      WHERE a.user_grp = b.user_grp
                                                        AND a.user_id = p_user_id
                                                        AND b.iss_cd = d.gibr_branch_cd
                                                        AND b.tran_cd = c.tran_cd
                                                        AND c.module_id = p_module_id)) = 1)
               -- end of replacement : 11.05.2014                                
               AND (   (    TRUNC (posting_date) BETWEEN TO_DATE (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                     AND TO_DATE (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'P'
                       )
                    OR (    TRUNC (gsc.check_date) BETWEEN TO_DATE
                                                                 (p_date,
                                                                  'MM/DD/YYYY'
                                                                 )
                                                       AND TO_DATE
                                                                 (p_date2,
                                                                  'MM/DD/YYYY'
                                                                 )
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND gp.payee_no = f.payee_cd
               AND gp.payee_class_cd = f.payee_class_cd
               AND d.gibr_gfun_fund_cd =
                                NVL (p_gibr_gfun_fund_cd, d.gibr_gfun_fund_cd)
               AND d.gibr_branch_cd = NVL (p_gibr_branch_cd, d.gibr_branch_cd)
               AND b.tran_class || '-' || LPAD (d.dv_no, 10, 0) =
                      NVL (p_dv_no,
                           b.tran_class || '-' || LPAD (d.dv_no, 10, 0)
                          )
               AND    DECODE (gsc.check_pref_suf,
                              NULL, NULL,
                              gsc.check_pref_suf || '-'
                             )
                   || LPAD (gsc.check_no, 10, 0) =
                      NVL (p_check_no,
                              DECODE (gsc.check_pref_suf,
                                      NULL, NULL,
                                      gsc.check_pref_suf || '-'
                                     )
                           || LPAD (gsc.check_no, 10, 0)
                          )
          ORDER BY dv_check_order*/--Replaced by codes below by pjsantos 11/14/2016 for optimization GENQA 5765
  SELECT a.sl_cd,
            TO_CHAR (b.gl_acct_category)
         || '-'
         || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09'))
            gl_acct_no,
         b.gl_acct_name,
         SUM (debit_amt) debit_amt,
         SUM (credit_amt) credit_amt
    FROM giac_acct_entries a, giac_chart_of_accts b
   WHERE gacc_tran_id = p_gacc_tran_id AND a.gl_acct_id = b.gl_acct_id
GROUP BY a.sl_cd,
            TO_CHAR (b.gl_acct_category)
         || '-'
         || LTRIM (TO_CHAR (b.gl_control_acct, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_1, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_2, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_3, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_4, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_5, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_6, '09'))
         || '-'
         || LTRIM (TO_CHAR (b.gl_sub_acct_7, '09')),
         b.gl_acct_name)          
      LOOP
         v_list.gl_account := i.gl_acct_no;
         v_list.gl_account_name := i.gl_acct_name;
         v_list.sl_cd := i.sl_cd;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         /*v_list.dv_amt := NULL;
         v_list.gibr_gfun_fund_cd := i.gibr_gfun_fund_cd;
         v_list.gibr_branch_cd := i.gibr_branch_cd;
         v_list.branch_name := i.branch_name;
         v_list.dv_check_order := i.dv_check_order;
         v_list.ref_no := i.ref_no;
         v_list.posting_date := i.posting_date;
         v_list.dv_no := i.dv_no;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.check_no := i.check_no;
         v_list.chk_date := i.chk_date;
         v_list.tin := i.tin;
         v_list.dv_flag := i.dv_flag;
         v_list.tran_flag := i.tran_flag;
         v_list.gl_account := i.gl_account;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_account_name := i.gl_account_name;
         v_list.sl_cd := i.sl_cd;
         v_list.debit_amt := i.debit_amt;
         v_list.credit_amt := i.credit_amt;
         

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.gl_account := NULL;
               v_list.gl_control_acct := NULL;
               v_list.gl_account_name := NULL;
               v_list.sl_cd := NULL;
               v_list.debit_amt := NULL;
               v_list.credit_amt := NULL;
            ELSIF i.dv_flag = 'C'
            THEN
               IF i.tran_flag = 'D'
               THEN
                  v_list.gl_account := NULL;
                  v_list.gl_control_acct := NULL;
                  v_list.gl_account_name := NULL;
                  v_list.sl_cd := NULL;
                  v_list.debit_amt := NULL;
                  v_list.credit_amt := NULL;
               END IF;
            END IF;
         END;

         BEGIN
            IF i.dv_flag = 'C'
            THEN
               v_list.chk_amt := NULL;
            ELSE
               v_list.chk_amt := i.amount;
            END IF;
         END;

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.payee := 'SPOILED';
            ELSIF i.dv_flag = 'C' AND i.tran_flag <> 'D'
            THEN
               v_list.payee := i.payee;
            ELSIF i.dv_flag = 'C' AND i.tran_flag = 'D'
            THEN
               v_list.payee := 'CANCELLED';
            ELSE
               v_list.payee := i.payee;
            END IF;
         END;

         BEGIN
            IF i.dv_flag = 'C'
            THEN
               IF i.tran_flag = 'D'
               THEN
                  v_list.cancelled := NULL;
               ELSIF i.tran_flag <> 'D'
               THEN
                  IF i.payee IN ('SPOILED')
                  THEN
                     v_list.cancelled := NULL;
                  ELSIF i.tran_flag = 'P'
                  THEN
                     v_list.cancelled := '(CANCELLED)';
                  ELSIF i.tran_flag <> 'P'
                  THEN
                     v_list.cancelled := NULL;
                  ELSE
                     v_list.cancelled := '(CANCELLED)';
                  END IF;
               END IF;
            ELSE
               v_list.cancelled := NULL;
            END IF;
         END;

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.dv_amt := NULL;
            ELSIF i.dv_flag = 'C' AND i.tran_flag = 'P'
            THEN
               v_list.dv_amt := i.dv_amt;
            ELSIF i.dv_flag = 'C' AND i.tran_flag <> 'P'
            THEN
               v_list.dv_amt := NULL;
            ELSE
               v_list.dv_amt := i.dv_amt;
            END IF;
         END;

         BEGIN
            IF i.payee IN ('SPOILED')
            THEN
               v_list.particulars := NULL;
            END IF;

            IF i.dv_flag = 'C'
            THEN
               IF i.tran_flag = 'D'
               THEN
                  v_list.particulars := NULL;
               ELSIF i.tran_flag <> 'D'
               THEN
                  v_list.particulars := i.particulars;
               END IF;
            ELSE
               v_list.particulars := i.particulars;
            END IF;
         END;*/ --Removed by pjsantos 11/14/2016 for optimization GENQA 5765

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_gl;

   FUNCTION get_gl_summary (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_branch_chk         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_gl_summary_tab PIPELINED
   IS
      v_list   get_gl_summary_type;
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
         IF p_post_tran_toggle = 'P'
         THEN
            v_list.post_tran := 'Based on Posting Date';
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
                                               ) = 1*/
               -- replacement for function above : shan 11.05.2014
               /*AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = d.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1
                    OR 
                    (SELECT access_tag
                       FROM giis_user_grp_modules
                      WHERE module_id = p_module_id
                        AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                       FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                      WHERE a.user_grp = b.user_grp
                                                        AND a.user_id = p_user_id
                                                        AND b.iss_cd = d.gibr_branch_cd
                                                        AND b.tran_cd = c.tran_cd
                                                        AND c.module_id = p_module_id)) = 1)*/--replaced by codes below by pjsantos 11/14/2016, for optimization GENQA 5765
               AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = d.gibr_branch_cd) 
                --pjsantos end
               -- end of replacement : 11.05.2014                                
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
               AND p_branch_chk = 'Y'
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
         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         v_list.gl_acct_no := i.gl_acct_no;

         IF p_branch_chk = 'Y'
         THEN
            PIPE ROW (v_list);
         END IF;
      END LOOP;
   END get_gl_summary;

   FUNCTION get_gl_all_branches (
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_date               VARCHAR2,
      p_date2              VARCHAR2,
      p_branch             VARCHAR2,
      p_module_id          VARCHAR2,
      p_branch_chk         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN get_gl_summary_tab PIPELINED
   IS
      v_list   get_gl_summary_type;
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
         IF p_post_tran_toggle = 'P'
         THEN
            v_list.post_tran := 'Based on Posting Date';
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
                                               ) = 1*/
               -- replacement for function above : shan 11.05.2014
               /*AND ((SELECT access_tag
                     FROM giis_user_modules
                    WHERE userid = p_user_id
                      AND module_id = p_module_id
                      AND tran_cd IN (SELECT b.tran_cd 
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = p_user_id
                                         AND b.iss_cd = d.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = p_module_id)) = 1
                    OR 
                    (SELECT access_tag
                       FROM giis_user_grp_modules
                      WHERE module_id = p_module_id
                        AND (user_grp, tran_cd) IN ( SELECT a.user_grp, b.tran_cd
                                                       FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                                      WHERE a.user_grp = b.user_grp
                                                        AND a.user_id = p_user_id
                                                        AND b.iss_cd = d.gibr_branch_cd 
                                                        AND b.tran_cd = c.tran_cd
                                                        AND c.module_id = p_module_id)) = 1)*/--replaced by codes below by pjsantos 11/14/2016, for optimization GENQA 5765
               AND EXISTS (SELECT 'X'
                                 FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                                WHERE branch_cd = d.gibr_branch_cd) 
                --pjsantos end
               -- end of replacement : 11.05.2014                                
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
               AND p_branch_chk = 'N'
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
         v_list.acct_name := i.acct_name;
         v_list.db_amt := i.db_amt;
         v_list.cd_amt := i.cd_amt;
         v_list.gl_acct_no := i.gl_acct_no;

         IF p_branch_chk = 'N'
         THEN
            PIPE ROW (v_list);
         END IF;
      END LOOP;
   END get_gl_all_branches;
END giacr118_pkg;
/


