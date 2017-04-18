CREATE OR REPLACE PACKAGE BODY CPI.csv_acctg
AS
   FUNCTION cashreceiptsregister_d (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN crr_type PIPELINED
   IS
      v_crr           crr_rec_type;
      v_currency      giac_order_of_payts.currency_cd%TYPE;
      v_foreign_amt   giac_order_of_payts.collection_amt%TYPE;
   BEGIN
      FOR c1 IN
         (SELECT   d.intm_no, b.gfun_fund_cd, b.gibr_branch_cd,
                   gb.branch_name,
                   
                   --decode(d.or_pref_suf,NULL,NULL,d.or_pref_suf||'-')||d.or_no or_no,
                   DECODE (b.tran_class,
                           'COL', DECODE (d.or_pref_suf,
                                          NULL, NULL,
                                          d.or_pref_suf || '-'
                                         )
                            || LPAD (d.or_no, 10, 0),
                           'CDC', DECODE (b.tran_class,
                                          NULL, NULL,
                                          b.tran_class || '-'
                                         )
                            || LPAD (b.tran_class_no, 10, 0)
                          ) or_no,
                   d.or_pref_suf, b.tran_class, d.or_no "OR",
                   TO_CHAR (b.tran_class_no),
                   a.gl_control_acct gl_control_acct, a.gl_acct_category,
                   
                   --d.or_date OR_DATE,
                   DECODE (b.tran_class,
                           'COL', d.or_date,
                           'CDC', b.tran_date
                          ) or_date,
                   TO_CHAR (d.dcb_no) dcb_no, b.posting_date,
                   
                   --decode(b.tran_class, 'COL', decode(d.or_flag,'P',d.payor,'C','CANCELLED'), 'CDC',  decode(b.tran_flag, 'C', 'CANCELLED')) "payor",
                   DECODE (d.or_flag, 
                                      --'P', d.payor, --mikel 04.16.2012
                           'C', 'CANCELLED', d.payor
                                                    -- mikel 04.16.2012; added "d.particulars" if from reversals
                   ) payor,
                   DECODE (b.tran_class,
                           'COL', DECODE (d.or_flag,
                                          
                                          --'P', d.particulars, --mikel 04.16.2012
                                          'C', NULL,
                                          d.particulars
                                         -- mikel 04.16.2012; added "d.particulars" if from reversals
                                         ),
                           'CDC', b.particulars
                          ) particulars,
                   
                   --decode(d.or_flag,'P',d.particulars,'C',NULL) PARTICULARS,
                   DECODE
                      (d.or_flag,
                       NULL, (d.gross_amt * -1),
                       d.gross_amt
                      )
        --mikel 04.16.2012; added "ecode (d.or_flag, null, (d.gross_amt * -1)"
                                                                 "Gross Amt",
                   d.currency_cd, gc.short_name,
                   DECODE (d.or_flag,
                           NULL, 0,
                           --mikel 04.16.2012; added " DECODE (d.or_flag, NULL, 0"
                           DECODE (d.currency_cd,
                                   gp.param_value_n, 0,
                                   d.collection_amt
                                  )
                          ) foreign_amt,
                   DECODE (d.or_flag,
                           NULL, (d.collection_amt * -1),
                           d.collection_amt
                          ) collection_amt,
                      LTRIM (TO_CHAR (a.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) gl_account,
                   c.gl_acct_name gl_account_name,
                   
                   /*DECODE (d.or_flag,
                           'C', DECODE(
                                           (SELECT DISTINCT 1 v_exist
                                                      FROM giac_acctrans aa, giac_reversals bb
                                                     WHERE aa.tran_id = bb.reversing_tran_id
                                                       AND bb.gacc_tran_id = b.tran_id
                                                       AND (   (    TRUNC (aa.tran_date) BETWEEN p_date AND p_date2
                                                                AND p_post_tran_toggle = 'T'
                                                               )
                                                            OR (    TRUNC (aa.posting_date) BETWEEN p_date AND p_date2
                                                                AND p_post_tran_toggle = 'P'
                                                               )
                                                           ))
                                            , 1, 0, NVL (a.debit_amt, 0)),
                           NVL (a.debit_amt, 0)
                          ) debit_amt,
                   DECODE (d.or_flag,
                           'C', DECODE(
                                           (SELECT DISTINCT 1 v_exist
                                                      FROM giac_acctrans aa, giac_reversals bb
                                                     WHERE aa.tran_id = bb.reversing_tran_id
                                                       AND bb.gacc_tran_id = b.tran_id
                                                       AND (   (    TRUNC (aa.tran_date) BETWEEN p_date AND p_date2
                                                                AND p_post_tran_toggle = 'T'
                                                               )
                                                            OR (    TRUNC (aa.posting_date) BETWEEN p_date AND p_date2
                                                                AND p_post_tran_toggle = 'P'
                                                               )
                                                           ))
                                            , 1, 0, NVL (a.credit_amt, 0)),
                           NVL (a.credit_amt, 0)
                          ) credit_amt,*/ --commented out by mikel; replaced by codes below
                   NVL (a.debit_amt, 0) debit_amt,
                   NVL (a.credit_amt, 0) credit_amt,
                   
                   --end mikel 04.16.2012
                   LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id, a.sl_cd,
                   e.or_type, d.tin
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_order_of_payts d,
                   giac_or_pref e,
                   giac_branches gb,
                   giis_currency gc,
                   giac_parameters gp
             WHERE gc.main_currency_cd(+) = d.currency_cd
               AND b.gfun_fund_cd = gb.gfun_fund_cd
               AND b.gibr_branch_cd = gb.branch_cd
               --  and d.gibr_gfun_fund_cd=gb.gfun_fund_cd(+)
               --  and d.gibr_branch_cd=gb.branch_cd (+)
               AND b.tran_id >= 1
               AND a.gacc_tran_id = b.tran_id
               AND b.tran_id = d.gacc_tran_id(+)
               AND a.gl_acct_category = c.gl_acct_category
               AND a.gl_control_acct = c.gl_control_acct
               AND a.gl_sub_acct_1 = c.gl_sub_acct_1
               AND a.gl_sub_acct_2 = c.gl_sub_acct_2
               AND a.gl_sub_acct_3 = c.gl_sub_acct_3
               AND a.gl_sub_acct_4 = c.gl_sub_acct_4
               AND a.gl_sub_acct_5 = c.gl_sub_acct_5
               AND a.gl_sub_acct_6 = c.gl_sub_acct_6
               AND a.gl_sub_acct_7 = c.gl_sub_acct_7
               ---and b.gfun_fund_cd = e.fund_cd
               --- and b.gibr_branch_cd = e.branch_cd
               AND d.gibr_gfun_fund_cd = e.fund_cd(+)
               AND d.gibr_branch_cd = e.branch_cd(+)
               AND d.or_pref_suf = e.or_pref_suf(+)
               AND (   (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') =
                                                                           'Y'
                        AND b.tran_class IN ('CDC', 'COL')
                       )
                    OR (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') =
                                                                           'N'
                        AND b.tran_class = 'COL'
                       )
                   )
               AND 
                   --  and  b.tran_class in ('COL', 'CDC') and
                  /* (       (TRUNC (d.or_date) BETWEEN p_date AND p_date2)
                       AND */ --mikel 09.06.2012 
                      ( (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                            AND p_post_tran_toggle = 'P'
                            AND (   d.or_flag IN ('C', 'P', 'R') --mikel 04.05.2013; added R
                                 OR d.or_cancel_tag = 'Y'
                                )
                           ---mikel 04.16.2012; added OR d.or_cancel_tag to include reversing entries
                           )
                    OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'P'
                        AND b.tran_flag IN ('C', 'P')
                        AND d.or_flag IN ('C', 'P','R')
                       )
                    OR (    TRUNC (tran_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'T'
                       )
                    OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                        AND tran_flag IN ('C', 'P')
                        AND p_post_tran_toggle = 'P'
                        AND b.tran_class = 'CDC'
                       )
                   )
               AND (   (tran_flag IN ('C', 'P') AND p_post_tran_toggle = 'P')
                    OR (    b.tran_flag IN ('C', 'P')
                        AND b.tran_class = 'CDC'
                        AND p_post_tran_toggle = 'T'
                       )
                    OR (    b.tran_flag IN ('C', 'P')
                        AND d.or_flag IN ('C', 'P', 'R') --mikel 04.05.2013; added R
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               /*AND ((tran_flag IN ('C','P','D','O') AND p_post_tran_toggle='P')
                       OR (b.tran_flag IN ('C','P','D','O') AND b.tran_class = 'CDC' AND p_post_tran_toggle='T')
                       OR (b.tran_flag IN ('C','P','D','O') AND d.or_flag IN ('C','P') AND p_post_tran_toggle='T')) */---and b.gibr_branch_cd=nvl(p_BRANCH, NVL(d.gibr_branch_cd,b.gibr_branch_cd ))
               AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
               AND param_name = 'CURRENCY_CD'
               AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_iss_cd b2,
                                 giis_modules_tran c,
                                 giis_user_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b.gibr_branch_cd
                             AND c.module_id = 'GIACS117'
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
                             AND b2.iss_cd = b.gibr_branch_cd
                             AND c.module_id = 'GIACS117'
                             AND a.user_grp = b2.user_grp
                             AND d.user_grp = a.user_grp
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                   )
          --BY JAYR 090303
          --to include cancelled OR's in the report
          /*((TRUNC(posting_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='P'
                AND d.or_flag IN ('C','P'))
            OR (TRUNC(posting_date) BETWEEN p_date AND p_date2
                 AND p_post_tran_toggle='P' AND
              b.tran_flag IN ('C','P') AND d.or_flag IN ('C','P'))
            OR (TRUNC(tran_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='T')
            OR (TRUNC(posting_date) BETWEEN p_date AND p_date2 AND tran_flag IN ('C','P') AND p_post_tran_toggle='P' AND b.tran_class='CDC'))
          AND ((tran_flag IN ('C','P') AND p_post_tran_toggle='P')
                  OR (b.tran_flag IN ('C','P') AND b.tran_class = 'CDC' AND p_post_tran_toggle='T')
                  OR (b.tran_flag IN ('C','P') AND d.or_flag IN ('C','P') AND p_post_tran_toggle='T'))
            ---and b.gibr_branch_cd=nvl(p_BRANCH, NVL(d.gibr_branch_cd,b.gibr_branch_cd ))
              and b.gibr_branch_cd=nvl(p_BRANCH, b.gibr_branch_cd)
          and param_name='CURRENCY_CD'
          */
          UNION ALL
          SELECT   d.intm_no, b.gfun_fund_cd, b.gibr_branch_cd,
                   gb.branch_name,
                      DECODE (gso.or_pref,
                              NULL, NULL,
                              gso.or_pref || '-'
                             )
                   || LPAD (gso.or_no, 10, 0) or_no,
                   gso.or_pref, '', gso.or_no "OR", '',
                   a.gl_control_acct gl_control_acct, a.gl_acct_category,
                   gso.or_date or_date, '', b.posting_date, 'SPOILED' payor,
                   'SPOILED' particulars, d.gross_amt "Gross Amt", 0, NULL, 0,
                   0 collection_amt,
                      LTRIM (TO_CHAR (a.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) gl_account,
                   c.gl_acct_name gl_account_name, 0 debit_amt, 0 credit_amt,
                   LPAD (NVL (gso.tran_id, NULL), 12, 0), a.sl_cd, e.or_type,
                   d.tin
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_order_of_payts d,
                   giac_or_pref e,
                   giac_branches gb,
                   giac_spoiled_or gso
             WHERE (   (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') =
                                                                           'Y'
                        AND b.tran_class IN ('CDC', 'COL')
                       )
                    OR (    DECODE (NVL (p_tran_class, 'Y'), 'Y', 'Y', 'N') =
                                                                           'N'
                        AND b.tran_class = 'COL'
                       )
                   )
               AND TRUNC (spoil_date) BETWEEN p_date AND p_date2
               AND b.gfun_fund_cd = gb.gfun_fund_cd
               AND b.gibr_branch_cd = gb.branch_cd
               AND d.gibr_gfun_fund_cd = gb.gfun_fund_cd(+)
               AND d.gibr_branch_cd = gb.branch_cd(+)
               AND a.gacc_tran_id = b.tran_id
               AND gso.tran_id(+) = d.gacc_tran_id
               AND b.tran_id = d.gacc_tran_id(+)
               AND a.gl_acct_category = c.gl_acct_category
               AND a.gl_control_acct = c.gl_control_acct
               AND a.gl_sub_acct_1 = c.gl_sub_acct_1
               AND a.gl_sub_acct_2 = c.gl_sub_acct_2
               AND a.gl_sub_acct_3 = c.gl_sub_acct_3
               AND a.gl_sub_acct_4 = c.gl_sub_acct_4
               AND a.gl_sub_acct_5 = c.gl_sub_acct_5
               AND a.gl_sub_acct_6 = c.gl_sub_acct_6
               AND a.gl_sub_acct_7 = c.gl_sub_acct_7
               ----and b.gfun_fund_cd = e.fund_cd
                ---and b.gibr_branch_cd = e.branch_cd
               AND d.gibr_gfun_fund_cd = e.fund_cd(+)
               AND d.gibr_branch_cd = e.branch_cd(+)
               AND d.or_pref_suf = e.or_pref_suf(+)
               -- and  b.tran_class in ('COL', 'CDC')
               AND TRUNC (gso.or_date) BETWEEN p_date AND p_date2
               ---and b.gibr_branch_cd=nvl(p_BRANCH, NVL(d.gibr_branch_cd,b.gibr_branch_cd ))
               AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
               AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_iss_cd b2,
                                 giis_modules_tran c,
                                 giis_user_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b.gibr_branch_cd
                             AND c.module_id = 'GIACS117'
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
                             AND b2.iss_cd = b.gibr_branch_cd
                             AND c.module_id = 'GIACS117'
                             AND a.user_grp = b2.user_grp
                             AND d.user_grp = a.user_grp
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                   )
          ORDER BY 5, 6, 7, 8, 9, 10, 11)
      LOOP
         v_crr.gibr_branch_cd := c1.gibr_branch_cd;
         v_crr.branch_name := c1.branch_name;
         v_crr.or_no := c1.or_no;
         v_crr.tran_id := c1.gacc_tran_id;
         v_crr.dcb_no := c1.dcb_no;
         v_crr.or_date := c1.or_date;
         v_crr.posting_date := c1.posting_date;

         --v_crr.intm_cd := c1.intm_cd;
         FOR c2 IN (SELECT    intm_no
                           || DECODE (ref_intm_cd,
                                      NULL, ' ',
                                      '/' || ref_intm_cd
                                     ) intm_cd
                      FROM giis_intermediary
                     WHERE intm_no = c1.intm_no)
         LOOP
            v_crr.intm_cd := c2.intm_cd;
         END LOOP;

         v_crr.payor := c1.payor;
         v_crr.tin := c1.tin;

         --v_crr.collection_amt := c1.coll_amt;
         SELECT param_value_n
           INTO v_currency
           FROM giac_parameters
          WHERE param_name = 'CURRENCY_CD';

         IF v_currency = c1.currency_cd
         THEN
            v_foreign_amt := 0;
         ELSE
            v_foreign_amt := c1.collection_amt;
         END IF;

         IF v_foreign_amt IS NULL OR v_foreign_amt = 0
         THEN
            v_crr.collection_amt := c1.collection_amt;
         ELSE
            BEGIN
               SELECT SUM (amount)
                 INTO v_crr.collection_amt
                 FROM giac_collection_dtl
                WHERE gacc_tran_id = c1.gacc_tran_id;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  NULL;
            END;
         END IF;

         v_crr.particulars := c1.particulars;
         v_crr.gl_account := c1.gl_account;
         v_crr.gl_account_name := c1.gl_account_name;
         v_crr.sl_cd := c1.sl_cd;
         v_crr.debit_amt := c1.debit_amt;
         v_crr.credit_amt := c1.credit_amt;
         PIPE ROW (v_crr);
      END LOOP;

      RETURN;
   END;

   FUNCTION cashreceiptsregister_s (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_user_id            VARCHAR2
   )
      RETURN crr_type2 PIPELINED
   IS
      v_crr   crr_rec_type2;
   BEGIN
      FOR c1 IN (SELECT   b.gfun_fund_cd acct_gibr_gfun_fund_cd,
                          b.gibr_branch_cd acct_gibr_branch_cd,
                          gb.branch_name acct_branch_name,
                             LTRIM (TO_CHAR (a.gl_acct_category))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09'))
                                                                  gl_acct_no,
                          c.gl_acct_name acct_name,
                          
                          /*SUM (DECODE (d.or_flag,
                                       'C', DECODE(
                                                  (SELECT DISTINCT 1 v_exist
                                                             FROM giac_acctrans aa, giac_reversals bb
                                                            WHERE aa.tran_id = bb.reversing_tran_id
                                                              AND bb.gacc_tran_id = b.tran_id
                                                              AND (   (    TRUNC (aa.tran_date) BETWEEN p_date AND p_date2
                                                                       AND p_post_tran_toggle = 'T'
                                                                      )
                                                                   OR (    TRUNC (aa.posting_date) BETWEEN p_date AND p_date2
                                                                       AND p_post_tran_toggle = 'P'
                                                                      )
                                                                  ))
                                                   , 1, 0, NVL(a.debit_amt,0)),
                                       NVL (a.debit_amt, 0)
                                      )
                              ) db_amt,
                          SUM (DECODE (d.or_flag,
                                       'C', DECODE(
                                                  (SELECT DISTINCT 1 v_exist
                                                             FROM giac_acctrans aa, giac_reversals bb
                                                            WHERE aa.tran_id = bb.reversing_tran_id
                                                              AND bb.gacc_tran_id = b.tran_id
                                                              AND (   (    TRUNC (aa.tran_date) BETWEEN p_date AND p_date2
                                                                       AND p_post_tran_toggle = 'T'
                                                                      )
                                                                   OR (    TRUNC (aa.posting_date) BETWEEN p_date AND p_date2
                                                                       AND p_post_tran_toggle = 'P'
                                                                      )
                                                                  ))
                                                   , 1, 0, NVL(a.credit_amt,0)),
                                       NVL (a.credit_amt, 0)
                                      )
                              ) cd_amt,
                          SUM (DECODE (d.or_flag,
                                       'C', DECODE(
                                                  (SELECT DISTINCT 1 v_exist
                                                             FROM giac_acctrans aa, giac_reversals bb
                                                            WHERE aa.tran_id = bb.reversing_tran_id
                                                              AND bb.gacc_tran_id = b.tran_id
                                                              AND (   (    TRUNC (aa.tran_date) BETWEEN p_date AND p_date2
                                                                       AND p_post_tran_toggle = 'T'
                                                                      )
                                                                   OR (    TRUNC (aa.posting_date) BETWEEN p_date AND p_date2
                                                                       AND p_post_tran_toggle = 'P'
                                                                      )
                                                                  ))
                                                   , 1, 0, NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)),
                                         NVL (a.debit_amt, 0)
                                       - NVL (a.credit_amt, 0)
                                      )
                              ) bal_amt*/--commented out by mikel; replaced by codes below
                          SUM (NVL (a.debit_amt, 0)) db_amt,
                          SUM (NVL (a.credit_amt, 0)) cd_amt,
                          SUM (NVL (a.debit_amt, 0) - NVL (a.credit_amt, 0)
                              ) bal_amt
                                 --end mikel 04.16.2012
                     --  sum(a.debit_amt) "DB_AMT"
                     -- ,sum(a.credit_amt) "CD_AMT"
                 FROM     giac_acct_entries a,
                          giac_acctrans b,
                          giac_chart_of_accts c,
                          giac_order_of_payts d,
                          giac_branches gb,
                          giis_currency gc,
                          giac_parameters gp
                    WHERE
                          --p_PER_BRANCH = 'Y' and
                          gc.main_currency_cd(+) = d.currency_cd
                      AND b.gfun_fund_cd = gb.gfun_fund_cd
                      AND b.gibr_branch_cd = gb.branch_cd
                      --  and d.gibr_gfun_fund_cd=gb.gfun_fund_cd(+)
                      --  and d.gibr_branch_cd=gb.branch_cd (+)
                      AND a.gacc_tran_id = b.tran_id
                      AND b.tran_id = d.gacc_tran_id(+)
                      AND a.gl_acct_category = c.gl_acct_category
                      AND a.gl_control_acct = c.gl_control_acct
                      AND a.gl_sub_acct_1 = c.gl_sub_acct_1
                      AND a.gl_sub_acct_2 = c.gl_sub_acct_2
                      AND a.gl_sub_acct_3 = c.gl_sub_acct_3
                      AND a.gl_sub_acct_4 = c.gl_sub_acct_4
                      AND a.gl_sub_acct_5 = c.gl_sub_acct_5
                      AND a.gl_sub_acct_6 = c.gl_sub_acct_6
                      AND a.gl_sub_acct_7 = c.gl_sub_acct_7
                      AND (   (    DECODE (NVL (p_tran_class, 'Y'),
                                           'Y', 'Y',
                                           'N'
                                          ) = 'Y'
                               AND b.tran_class IN ('CDC', 'COL')
                              )
                           OR (    DECODE (NVL (p_tran_class, 'Y'),
                                           'Y', 'Y',
                                           'N'
                                          ) = 'N'
                               AND b.tran_class = 'COL'
                              )
                          )
                      --and  b.tran_class in ('COL', 'CDC')
                      AND (      /* (TRUNC (d.or_date) BETWEEN p_date AND p_date2
                                  )
                              AND */ --mikel 09.06.2012
                              (    TRUNC (posting_date) BETWEEN p_date
                                                                AND p_date2
                                   AND p_post_tran_toggle = 'P'
                                   AND (   d.or_flag IN ('C', 'P','R') --Ladz added R 07152013
                                        OR d.or_cancel_tag = 'Y'
                                       )
                                  ---mikel 04.16.2012; added OR d.or_cancel_tag to include reversing entries
                                  )
                           OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                               AND p_post_tran_toggle = 'P'
                               AND b.tran_flag IN ('C', 'P')
                               AND d.or_flag IN ('C', 'P','R') --Ladz added R 07152013
                              )
                           OR (    TRUNC (tran_date) BETWEEN p_date AND p_date2
                               AND p_post_tran_toggle = 'T'
                              )
                           OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                               AND tran_flag IN ('C', 'P')
                               AND p_post_tran_toggle = 'P'
                               AND b.tran_class = 'CDC'
                              )
                          )
                      AND (   (    tran_flag IN ('C', 'P')
                               AND p_post_tran_toggle = 'P'
                              )
                           OR (    b.tran_flag IN ('C', 'P')
                               AND b.tran_class = 'CDC'
                               AND p_post_tran_toggle = 'T'
                              )
                           OR (    b.tran_flag IN ('C', 'P')
                               AND d.or_flag IN ('C', 'P','R') --Ladz added R 07152013
                               AND p_post_tran_toggle = 'T'
                              )
                          )
                      /*AND ((tran_flag IN ('C','P','O','D') AND p_post_tran_toggle='P')
                              OR (b.tran_flag IN ('C','P','O','D') AND b.tran_class = 'CDC' AND p_post_tran_toggle='T')
                              OR (b.tran_flag IN ('C','P','O','D') AND d.or_flag IN ('C','P') AND p_post_tran_toggle='T'))*/
                      AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
                      AND param_name = 'CURRENCY_CD'
                      AND (   EXISTS ( --added by steven 09.05.2014; to replace check_user_per_iss_cd_acctg2
                          SELECT d.access_tag
                            FROM giis_users a,
                                 giis_user_iss_cd b2,
                                 giis_modules_tran c,
                                 giis_user_modules d
                           WHERE a.user_id = p_user_id
                             AND b2.iss_cd = b.gibr_branch_cd
                             AND c.module_id = 'GIACS117'
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
                             AND b2.iss_cd = b.gibr_branch_cd
                             AND c.module_id = 'GIACS117'
                             AND a.user_grp = b2.user_grp
                             AND d.user_grp = a.user_grp
                             AND b2.tran_cd = c.tran_cd
                             AND d.tran_cd = c.tran_cd
                             AND d.module_id = c.module_id)
                   )
                 GROUP BY b.gfun_fund_cd,
                          b.gibr_branch_cd,
                          gb.branch_name,
                             LTRIM (TO_CHAR (a.gl_acct_category))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                          || '-'
                          || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')),
                          c.gl_acct_name
                 ORDER BY 1)
      LOOP
         v_crr.gibr_branch_cd := c1.acct_gibr_branch_cd;
         v_crr.branch_name := c1.acct_branch_name;
         v_crr.gl_account := c1.gl_acct_no;
         v_crr.gl_account_name := c1.acct_name;
         v_crr.debit_amt := c1.db_amt;
         v_crr.credit_amt := c1.cd_amt;
         v_crr.balance_amt := c1.bal_amt;
         PIPE ROW (v_crr);
      END LOOP;

      RETURN;
   END;

   FUNCTION cashdisbregister_d (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_dv_check           VARCHAR2,
      p_dv_check_toggle    VARCHAR2,
      p_user_id            VARCHAR2  --Deo [03.13.2017]: SR-23914
   )
      RETURN cdr_type PIPELINED
   IS
      v_cdr           cdr_rec_type;
      v_currency      giac_order_of_payts.currency_cd%TYPE;
      v_foreign_amt   giac_order_of_payts.collection_amt%TYPE;
      v_ae_exist      VARCHAR2(1); --Deo [03.13.2017]: SR-23914
   BEGIN
   	  /* --Deo [03.13.2017]: comment out starts (SR-23914)
      FOR c1 IN
         (SELECT   LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                   LPAD (d.dv_no, 10, 0) dv_no, d.ref_no,
                   d.gibr_gfun_fund_cd, d.gibr_branch_cd, gb.branch_name,
                      e.document_cd
                   || '-'
                   || e.branch_cd
                   || '-'
                   || e.doc_seq_no "REQUEST NO.",
                   a.gl_acct_category, a.gl_control_acct, d.payee payee,
                   b.posting_date, b.user_id, b.last_update,
                   d.particulars particulars,
                   DECODE (dv_flag,
                           'C', DECODE (tran_flag, 'D', 0, dv_amt),
                           dv_amt
                          ) dv_amt,
                 
                        /* a.gl_acct_category
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
                      || a.gl_sub_acct_7 commented out and replace by the next lines..abie 04162012*
                      LTRIM (TO_CHAR (a.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) gl_account,
                   c.gl_acct_name gl_account_name, a.sl_cd,
                   DECODE (dv_flag,
                           'C', DECODE (tran_flag, 'D', 0, a.debit_amt),
                           a.debit_amt
                          ) debit_amt,
                   DECODE (dv_flag,
                           'C', DECODE (tran_flag, 'D', 0, a.credit_amt),
                           a.credit_amt
                          ) credit_amt,
                   b.tran_flag, b.tran_class, b.tran_date, d.dv_flag,
                   a.acct_entry_id,
                   TO_CHAR (h.check_date, 'MM-DD-YYYY') chk_date,
                      DECODE (h.check_pref_suf,
                              NULL, NULL,
                              h.check_pref_suf || '-'
                             )
                   || h.check_no check_no,
                   h.item_no, h.amount,
                   DECODE (p_dv_check, 'V', dv_no, 'CH', h.check_no) "ORDER",
                   d.dv_pref, gp.tin
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
               AND (   (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'P'
                        AND d.dv_flag IN ('C', 'P')
                       )
                    OR (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'P'
                        AND b.tran_flag = 'D'
                        AND d.dv_flag = 'C'
                       )
                    OR 
                       /*(TRUNC(tran_date) BETWEEN p_date AND p_date2 AND p_post_tran_toggle='T')) */ --commented by jason 03.29.2007
                       /*DIANNE.03092007.START.add consideration by dv_date and check_date*
                       (    p_post_tran_toggle = 'T'
                        AND (   (    p_dv_check_toggle = 'D'
                                 AND TRUNC (d.dv_date) BETWEEN p_date AND p_date2
                                )
                             OR (    p_dv_check_toggle = 'C'
                                 AND TRUNC (h.check_date) BETWEEN p_date
                                                              AND p_date2
                                )
                             OR (    p_dv_check_toggle = 'P'
                                 AND TRUNC (h.check_print_date) BETWEEN p_date
                                                                    AND p_date2
                                )
                            --02/12/2008 added by jeff added parameter check print date
                            )
                       )
                   --OR p_post_tran_toggle='P' --commented by cris 08/13/08
                   )                                            /*DIANNE.end*
               AND (   (tran_flag = 'P' AND p_post_tran_toggle = 'P')
                    OR (    b.tran_flag IN ('C', 'P', 'D')
                        AND d.dv_flag IN ('C', 'P')
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND gp.payee_no = f.payee_cd
               AND gp.payee_class_cd = f.payee_class_cd
          UNION
          SELECT   LPAD (d.gacc_tran_id, 12, 0), LPAD (d.dv_no, 10, 0) dv_no,
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
                 
                        /* a.gl_acct_category
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
                      || a.gl_sub_acct_7 commented out and replace by the next lines..abie 04162012*
                      LTRIM (TO_CHAR (a.gl_acct_category))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                   || '-'
                   || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) gl_account,
                   c.gl_acct_name gl_account_name, a.sl_cd, 0 debit_amt,
                   0 credit_amt, b.tran_flag, b.tran_class, b.tran_date,
                   d.dv_flag, a.acct_entry_id,
                   TO_CHAR (gsc.check_date, 'MM-DD-YYYY') chk_date,
                      DECODE (gsc.check_pref_suf,
                              NULL, NULL,
                              gsc.check_pref_suf || '-'
                             )
                   || gsc.check_no check_no,
                   item_no, amount,
                   DECODE (p_dv_check,
                           'V', d.dv_no,
                           'CH', gsc.check_no
                          ) "ORDER",
                   d.dv_pref, gp.tin
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
               --ADDED
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
               /* AND TRUNC(gsc.check_date) BETWEEN p_date AND p_date2  --adrel 01272009 replaced with*
               AND (   (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'P'
                       )
                    OR (    TRUNC (gsc.check_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND gp.payee_no = f.payee_cd
               AND gp.payee_class_cd = f.payee_class_cd
          ORDER BY "ORDER")
      LOOP
         v_cdr.gibr_branch_cd := c1.gibr_branch_cd;
         v_cdr.branch_name := c1.branch_name;
         v_cdr.posting_date := c1.posting_date;
         v_cdr.dv_no := c1.dv_pref || '-' || c1.dv_no;
         v_cdr.tran_id := c1.gacc_tran_id;
         v_cdr.ref_no := c1.ref_no;
         v_cdr.check_no := c1.check_no;
         v_cdr.chk_date := c1.chk_date;
         v_cdr.check_amount := c1.amount;
         v_cdr.particulars := c1.particulars;

         IF c1.dv_flag = 'C' AND c1.tran_flag = 'D'
         THEN
            v_cdr.payee := 'CANCELLED';
         ELSE
            v_cdr.payee := c1.payee;
         END IF;

         v_cdr.tin := c1.tin;
         v_cdr.dv_amt := c1.dv_amt;
         v_cdr.gl_account := c1.gl_account;
         v_cdr.gl_account_name := c1.gl_account_name;
         v_cdr.sl_cd := c1.sl_cd;
         v_cdr.debit_amt := c1.debit_amt;
         v_cdr.credit_amt := c1.credit_amt;
         v_cdr.balance_amt := (NVL (c1.debit_amt, 0) - NVL (c1.credit_amt, 0));
         --added by april as of 07/08/2009
         PIPE ROW (v_cdr);
      END LOOP;*/   --Deo [03.13.2017]: comment out ends (SR-23914)

      --Deo [03.13.2017]: add starts (SR-23914)
      FOR c1 IN
         (SELECT   main_sql.*,
                   ROW_NUMBER () OVER (PARTITION BY    gacc_tran_id
                                                    || '-'
                                                    || order_1 ORDER BY order_1,
                    gacc_tran_id, DECODE (p_dv_check, 'V', TO_NUMBER (order_2), 17),
                    check_no) dv_row
              FROM (SELECT LPAD (d.gacc_tran_id, 12, 0) gacc_tran_id,
                           d.dv_pref || '-' || LPAD (d.dv_no, 10, 0) dv_no,
                           d.ref_no, d.gibr_branch_cd, gb.branch_name, d.payee,
                           TO_CHAR (b.posting_date, 'MM-DD-YYYY') posting_date,
                           d.particulars particulars,
                           DECODE (d.dv_flag,
                                   'C', DECODE (b.tran_flag,
                                                'D', 0,
                                                d.dv_amt
                                               ),
                                   d.dv_amt
                                  ) dv_amt,
                           b.tran_flag, d.dv_flag,
                           TO_CHAR (h.check_date, 'MM-DD-YYYY') chk_date,
                              DECODE (h.check_pref_suf,
                                      NULL, NULL,
                                      h.check_pref_suf || '-'
                                     )
                           || LPAD (h.check_no, 10, 0) check_no,
                           h.amount, gp.tin,
                           DECODE
                              (p_dv_check,
                               'V', d.dv_pref || '-' || d.dv_no,
                               'CH', (SELECT MIN
                                                (   DECODE (check_pref_suf,
                                                            NULL, NULL,
                                                               check_pref_suf
                                                            || '-'
                                                           )
                                                 || check_no
                                                ) chk_no
                                        FROM giac_chk_disbursement
                                       WHERE gacc_tran_id = b.tran_id
                                         AND (   (    p_post_tran_toggle = 'P'
                                                  AND 1 = 1
                                                 )
                                              OR (    p_post_tran_toggle = 'T'
                                                  AND (   (    p_dv_check_toggle = 'D'
                                                           AND 1 = 1
                                                          )
                                                       OR (    p_dv_check_toggle = 'C'
                                                           AND TRUNC
                                                                   (check_date)
                                                                  BETWEEN p_date
                                                                      AND p_date2
                                                          )
                                                       OR (    p_dv_check_toggle = 'P'
                                                           AND TRUNC
                                                                  (check_print_date
                                                                  )
                                                                  BETWEEN p_date
                                                                      AND p_date2
                                                          )
                                                      )
                                                 )
                                             ))
                              ) order_1,
                           DECODE (p_dv_check,
                                   'V', TO_CHAR (h.item_no),
                                   'CH', DECODE (h.check_pref_suf,
                                                 NULL, NULL,
                                                 h.check_pref_suf || '-'
                                                )
                                    || h.check_no
                                  ) order_2,
                           COUNT (1) OVER (PARTITION BY d.gacc_tran_id) dv_cnt
                      FROM giac_acctrans b,
                           giac_disb_vouchers d,
                           giac_branches gb,
                           giac_chk_disbursement h,
                           giis_payees gp
                     WHERE b.tran_id = d.gacc_tran_id
                       AND gb.gfun_fund_cd = d.gibr_gfun_fund_cd
                       AND b.tran_id = h.gacc_tran_id(+)
                       AND h.check_no IS NOT NULL
                       AND d.gibr_branch_cd = gb.branch_cd
                       AND d.gibr_branch_cd = NVL (p_branch, d.gibr_branch_cd)
                       AND d.payee_no = gp.payee_no(+)
                       AND d.payee_class_cd = gp.payee_class_cd(+)
                       AND EXISTS (
                              SELECT 'X'
                                FROM TABLE
                                        (security_access.get_branch_line
                                                                  ('AC',
                                                                   'GIACS118',
                                                                   p_user_id
                                                                  )
                                        )
                               WHERE branch_cd = d.gibr_branch_cd)
                       AND (   (    TRUNC (posting_date) BETWEEN p_date
                                                             AND p_date2
                                AND p_post_tran_toggle = 'P'
                                AND d.dv_flag IN ('C', 'P')
                               )
                            OR (    TRUNC (posting_date) BETWEEN p_date
                                                             AND p_date2
                                AND p_post_tran_toggle = 'P'
                                AND b.tran_flag = 'D'
                                AND d.dv_flag = 'C'
                               )
                            OR (    p_post_tran_toggle = 'T'
                                AND (   (    p_dv_check_toggle = 'D'
                                         AND TRUNC (d.dv_date)
                                                BETWEEN p_date
                                                    AND p_date2
                                        )
                                     OR (    p_dv_check_toggle = 'C'
                                         AND TRUNC (h.check_date)
                                                BETWEEN p_date
                                                    AND p_date2
                                        )
                                     OR (    p_dv_check_toggle = 'P'
                                         AND TRUNC (h.check_print_date)
                                                BETWEEN p_date
                                                    AND p_date2
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
                           d.ref_no, d.gibr_branch_cd, gb.branch_name,
                           DECODE (d.dv_flag, 'C', d.payee, 'SPOILED') payee,
                           TO_CHAR (b.posting_date,
                                    'MM-DD-YYYY') posting_date,
                           DECODE (d.dv_flag,
                                   'C', d.particulars,
                                   'SPOILED'
                                  ) particulars,
                           0 dv_amt, b.tran_flag, d.dv_flag,
                           TO_CHAR (gsc.check_date, 'MM-DD-YYYY') chk_date,
                              DECODE (gsc.check_pref_suf,
                                      NULL, NULL,
                                      gsc.check_pref_suf || '-'
                                     )
                           || LPAD (gsc.check_no, 10, 0) check_no,
                           gsc.amount, gp.tin,
                           DECODE (p_dv_check,
                                   'V', d.dv_pref || '-' || d.dv_no,
                                   'CH', DECODE (gsc.check_pref_suf,
                                                 NULL, NULL,
                                                 gsc.check_pref_suf || '-'
                                                )
                                    || gsc.check_no
                                  ) order_1,
                           DECODE (p_dv_check,
                                   'V', TO_CHAR (gsc.item_no),
                                   'CH', DECODE (gsc.check_pref_suf,
                                                 NULL, NULL,
                                                 gsc.check_pref_suf || '-'
                                                )
                                    || gsc.check_no
                                  ) order_2,
                           1 dv_cnt
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
                                FROM TABLE
                                        (security_access.get_branch_line
                                                                  ('AC',
                                                                   'GIACS118',
                                                                   p_user_id
                                                                  )
                                        )
                               WHERE branch_cd = d.gibr_branch_cd)
                       AND (   (    TRUNC (posting_date) BETWEEN p_date
                                                             AND p_date2
                                AND p_post_tran_toggle = 'P'
                               )
                            OR (    TRUNC (gsc.check_date) BETWEEN p_date
                                                               AND p_date2
                                AND p_post_tran_toggle = 'T'
                               )
                           )) main_sql
          ORDER BY order_1, gacc_tran_id,
                   DECODE (p_dv_check, 'V', TO_NUMBER (order_2), 17),
                   check_no)
      LOOP
         v_ae_exist := 'N';
         
         FOR c2 IN
            (SELECT *
               FROM (SELECT ROWNUM row_num, ae.*
                       FROM (SELECT      LTRIM (TO_CHAR (a.gl_acct_category))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')) gl_account,
                                      c.gl_acct_name gl_account_name, a.sl_cd,
                                      SUM (NVL (a.debit_amt, 0)) debit_amt,
                                      SUM (NVL (a.credit_amt, 0)) credit_amt
                                 FROM giac_acct_entries a,
                                      giac_chart_of_accts c
                                WHERE a.gacc_tran_id = c1.gacc_tran_id
                                  AND a.gl_acct_id = c.gl_acct_id
                             GROUP BY    LTRIM (TO_CHAR (a.gl_acct_category))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_control_acct, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_1, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_2, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_3, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_4, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_5, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_6, '09'))
                                      || '-'
                                      || LTRIM (TO_CHAR (a.gl_sub_acct_7, '09')),
                                      c.gl_acct_name, a.sl_cd
                             ORDER BY 4 DESC, 5) ae)
              WHERE c1.payee != 'SPOILED'
                AND DECODE (c1.dv_flag, 'C', DECODE (c1.tran_flag, 'D', 0, 1), 1) = 1
                AND (   (c1.dv_row = c1.dv_cnt AND row_num >= c1.dv_row)
                     OR (c1.dv_row < c1.dv_cnt AND row_num = c1.dv_row)
                    ))
         LOOP
            v_ae_exist := 'Y';
            
            IF c1.dv_row = 1 AND c2.row_num = 1
            THEN
               v_cdr.gibr_branch_cd := c1.gibr_branch_cd;
               v_cdr.branch_name := c1.branch_name;
               v_cdr.posting_date := c1.posting_date;
               v_cdr.dv_no := c1.dv_no;
               v_cdr.tran_id := c1.gacc_tran_id;
               v_cdr.ref_no := c1.ref_no;
               v_cdr.particulars := c1.particulars;
               v_cdr.payee := c1.payee;
               v_cdr.tin := c1.tin;
               v_cdr.dv_amt := c1.dv_amt;
            ELSE
               v_cdr.gibr_branch_cd := NULL;
               v_cdr.branch_name := NULL;
               v_cdr.posting_date := NULL;
               v_cdr.dv_no := NULL;
               v_cdr.tran_id := NULL;
               v_cdr.ref_no := NULL;
               v_cdr.particulars := NULL;
               v_cdr.payee := NULL;
               v_cdr.tin := NULL;
               v_cdr.dv_amt := NULL;
            END IF;

            IF c1.dv_row <= c1.dv_cnt AND c1.dv_row >= c2.row_num
            THEN
               v_cdr.check_no := c1.check_no;
               v_cdr.chk_date := c1.chk_date;
               v_cdr.check_amount := c1.amount;
            ELSE
               v_cdr.check_no := NULL;
               v_cdr.chk_date := NULL;
               v_cdr.check_amount := NULL;
            END IF;

            v_cdr.gl_account := c2.gl_account;
            v_cdr.gl_account_name := c2.gl_account_name;
            v_cdr.sl_cd := c2.sl_cd;
            v_cdr.debit_amt := c2.debit_amt;
            v_cdr.credit_amt := c2.credit_amt;
            v_cdr.balance_amt := (NVL (c2.debit_amt, 0) - NVL (c2.credit_amt, 0));
            PIPE ROW (v_cdr);
         END LOOP;
         
         IF v_ae_exist = 'N'
         THEN
            IF c1.dv_row = 1
            THEN
               v_cdr.gibr_branch_cd := c1.gibr_branch_cd;
               v_cdr.branch_name := c1.branch_name;
               v_cdr.posting_date := c1.posting_date;
               v_cdr.dv_no := c1.dv_no;
               v_cdr.tran_id := c1.gacc_tran_id;
               v_cdr.ref_no := c1.ref_no;
               
               IF c1.payee = 'SPOILED'
               THEN
                  v_cdr.payee := 'SPOILED';
                  v_cdr.dv_amt := NULL;
                  v_cdr.particulars := NULL;
                  v_cdr.tin := NULL;
               ELSIF c1.dv_flag = 'C' AND c1.tran_flag = 'D'
               THEN
                  v_cdr.payee := 'CANCELLED';
                  v_cdr.dv_amt := NULL;
                  v_cdr.particulars := NULL;
                  v_cdr.tin := NULL;
               ELSE
                  v_cdr.payee := c1.payee;
                  v_cdr.dv_amt := c1.dv_amt;
                  v_cdr.particulars := c1.particulars;
                  v_cdr.tin := c1.tin;
               END IF;
            ELSE
               v_cdr.gibr_branch_cd := NULL;
               v_cdr.branch_name := NULL;
               v_cdr.posting_date := NULL;
               v_cdr.dv_no := NULL;
               v_cdr.tran_id := NULL;
               v_cdr.ref_no := NULL;
               v_cdr.particulars := NULL;
               v_cdr.payee := NULL;
               v_cdr.tin := NULL;
               v_cdr.dv_amt := NULL;
            END IF;
            
            v_cdr.check_no := c1.check_no;
            v_cdr.chk_date := c1.chk_date;
            v_cdr.check_amount := c1.amount;
            v_cdr.gl_account := NULL;
            v_cdr.gl_account_name := NULL;
            v_cdr.sl_cd := NULL;
            v_cdr.debit_amt := NULL;
            v_cdr.credit_amt := NULL;
            v_cdr.balance_amt := NULL;
            
            PIPE ROW (v_cdr);
         END IF;
      END LOOP;
      --Deo [03.13.2017]: add ends (SR-23914)
      
      RETURN;
   END;

   FUNCTION cashdisbregister_s (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2
   )
      RETURN crr_type2 PIPELINED
   IS
      v_cdr   crr_rec_type2;
   BEGIN
      FOR c1 IN (SELECT   d.gibr_gfun_fund_cd acct_gibr_gfun_fund_cd,
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
                          || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09'))
                                                                  gl_acct_no,
                          c.gl_acct_name acct_name,
                          SUM (DECODE (dv_flag,
                                       'C', DECODE (tran_flag,
                                                    'D', 0,
                                                    a.debit_amt
                                                   ),
                                       a.debit_amt
                                      )
                              ) "DB_AMT",
                          SUM (DECODE (dv_flag,
                                       'C', DECODE (tran_flag,
                                                    'D', 0,
                                                    a.credit_amt
                                                   ),
                                       a.credit_amt
                                      )
                              ) "CD_AMT",
                          
                          --sum(decode(dv_flag,'C',((DECODE(TRAN_FLAG,'D',0,A.DEBIT_AMT))-(DECODE(TRAN_FLAG,'D',0,A.CREDIT_AMT))),(A.DEBIT_AMT-A.CREDIT_AMT)))
                          (  SUM (DECODE (dv_flag,
                                          'C', DECODE (tran_flag,
                                                       'D', 0,
                                                       a.debit_amt
                                                      ),
                                          a.debit_amt
                                         )
                                 )
                           - SUM (DECODE (dv_flag,
                                          'C', DECODE (tran_flag,
                                                       'D', 0,
                                                       a.credit_amt
                                                      ),
                                          a.credit_amt
                                         )
                                 )
                          ) "BAL_AMT"
                     --  sum(a.debit_amt) "DB_AMT"
                     -- ,sum(a.credit_amt) "CD_AMT"
                 FROM     giac_acct_entries a,
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
                      ---  and H.check_no is not null
                      /*DIANNE.03092007.added for optimization*/
                      AND b.tran_id = h.gacc_tran_id(+)
                      --  and d.dv_flag = 'P'
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
                      AND (   (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                               AND p_post_tran_toggle = 'P'
                              )
                           OR (    TRUNC (tran_date) BETWEEN p_date AND p_date2
                               AND p_post_tran_toggle = 'T'
                              )
                          )
                      /*DIANNE.03092007.START.add consideration by dv_date and check_date*/
                      AND (   (    p_post_tran_toggle = 'T'
                               AND (   (    p_dv_check_toggle = 'D'
                                        AND TRUNC (d.dv_date) BETWEEN p_date
                                                                  AND p_date2
                                       )
                                    OR (    p_dv_check_toggle = 'C'
                                        AND TRUNC (h.check_date) BETWEEN p_date
                                                                     AND p_date2
                                       )
                                    OR (    p_dv_check_toggle = 'P'
                                        AND TRUNC (h.check_print_date)
                                               BETWEEN p_date
                                                   AND p_date2
                                       )
                                   --02/12/2008 added by jeff added parameter check print date
                                   )
                              )
                           OR p_post_tran_toggle = 'P'
                          )
                      /*DIANNE.end*/
                      AND (   (tran_flag = 'P' AND p_post_tran_toggle = 'P')
                           OR (    tran_flag IN ('C', 'P')
                               AND p_post_tran_toggle = 'T'
                              )
                          )
                 --and decode(tran_flag,'C',to_char(tran_date,'MM'),'P',to_char(posting_date,'MM')) = to_char(to_date( p_date, 'mm-dd-yyyy'), 'MM')
                 --and  b.tran_flag in ('C','P')
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
         v_cdr.gibr_branch_cd := c1.acct_gibr_branch_cd;
         v_cdr.branch_name := c1.acct_branch_name;
         v_cdr.gl_account := c1.gl_acct_no;
         v_cdr.gl_account_name := c1.acct_name;
         v_cdr.debit_amt := c1.db_amt;
         v_cdr.credit_amt := c1.cd_amt;
         v_cdr.balance_amt := c1.bal_amt;
         PIPE ROW (v_cdr);
      END LOOP;

      RETURN;
   END;

   -- START added by Jayson 10.25.2011 --
   -- For print to CSV of Purchase Register --
   FUNCTION cashdisbregister_pr (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_dv_check_toggle    VARCHAR2
   )
      RETURN cpr_table PIPELINED
   IS
      v_cdrpr_rec   cdrpr_rec_type;
      v_branch      giis_issource.iss_name%TYPE;
      v_input_vat   giac_acct_entries.debit_amt%TYPE;
      v_net_amt     giac_acct_entries.debit_amt%TYPE;
   BEGIN
      FOR rec1 IN
         (SELECT   TRUNC (DECODE (p_post_tran_toggle,
                                  'P', b.posting_date,
                                  'T', DECODE (p_dv_check_toggle,
                                               'D', a.dv_date,
                                               'C', g.check_date,
                                               'P', g.check_print_date
                                              )
                                 )
                         ) pdc_date,
                   a.gacc_tran_id, a.gibr_branch_cd,
                   a.dv_pref || '-' || LPAD (a.dv_no, 10, '0') ref_no, f.tin,
                   a.payee vendor, a.particulars,
                   SUM (e.debit_amt - e.credit_amt) amount, 0 discount
              FROM giac_disb_vouchers a,
                   giac_acctrans b,
                   giac_payt_requests_dtl c,
                   giac_payt_requests d,
                   giac_acct_entries e,
                   giis_payees f,
                   giac_chk_disbursement g
             WHERE a.gacc_tran_id = b.tran_id
               AND a.gacc_tran_id = c.tran_id
               AND c.gprq_ref_id = d.ref_id
               AND a.gacc_tran_id = e.gacc_tran_id
               AND c.payee_class_cd = f.payee_class_cd
               AND c.payee_cd = f.payee_no
               AND a.gacc_tran_id = g.gacc_tran_id
               AND b.tran_flag <> 'D'
               AND a.gibr_branch_cd = NVL (p_branch, a.gibr_branch_cd)
               AND TRUNC (DECODE (p_post_tran_toggle,
                                  'P', b.posting_date,
                                  'T', DECODE (p_dv_check_toggle,
                                               'D', a.dv_date,
                                               'C', g.check_date,
                                               'P', g.check_print_date
                                              )
                                 )
                         ) BETWEEN p_date AND p_date2
               AND EXISTS (
                      SELECT 1
                        FROM giac_eom_rep_dtl z
                       WHERE z.rep_cd = 'GIACR118C'
                         AND z.gl_acct_id = e.gl_acct_id)
               AND EXISTS (
                      SELECT 1
                        FROM giac_payt_req_docs x
                       WHERE x.document_cd = d.document_cd
                         AND x.gibr_branch_cd = d.branch_cd
                         AND x.purchase_tag = 'Y')
          GROUP BY TRUNC (DECODE (p_post_tran_toggle,
                                  'P', b.posting_date,
                                  'T', DECODE (p_dv_check_toggle,
                                               'D', a.dv_date,
                                               'C', g.check_date,
                                               'P', g.check_print_date
                                              )
                                 )
                         ),
                   a.gacc_tran_id,
                   a.gibr_branch_cd,
                   a.dv_pref || '-' || LPAD (a.dv_no, 10, '0'),
                   f.tin,
                   a.payee,
                   a.particulars
          ORDER BY 3, 1)
      LOOP
         -- get branch_name
         SELECT iss_name
           INTO v_branch
           FROM giis_issource
          WHERE iss_cd = rec1.gibr_branch_cd;

         -- get input_vat
         BEGIN
            SELECT   SUM (debit_amt - credit_amt) input_vat
                INTO v_input_vat
                FROM giac_modules a,
                     giac_module_entries b,
                     giac_acct_entries c
               WHERE a.module_id = b.module_id
                 AND a.module_name = 'GIACS039'
                 AND b.gl_acct_category = c.gl_acct_category
                 AND b.gl_control_acct = c.gl_control_acct
                 AND b.gl_sub_acct_1 = c.gl_sub_acct_1
                 AND b.gl_sub_acct_2 = c.gl_sub_acct_2
                 AND b.gl_sub_acct_3 = c.gl_sub_acct_3
                 AND b.gl_sub_acct_4 = c.gl_sub_acct_4
                 AND b.gl_sub_acct_5 = c.gl_sub_acct_5
                 AND b.gl_sub_acct_6 = c.gl_sub_acct_6
                 AND b.gl_sub_acct_7 = c.gl_sub_acct_7
                 AND c.gacc_tran_id = rec1.gacc_tran_id
            GROUP BY c.gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_input_vat := 0;
         END;

         -- get net_amt
         v_net_amt := rec1.amount + v_input_vat;
         --changed from - to + by Jayson 11.21.2011
         v_cdrpr_rec.branch := v_branch;
         v_cdrpr_rec.date_ := rec1.pdc_date;
         v_cdrpr_rec.ref_no := rec1.ref_no;
         v_cdrpr_rec.tin := rec1.tin;
         v_cdrpr_rec.payee := rec1.vendor;
         v_cdrpr_rec.particulars := rec1.particulars;
         v_cdrpr_rec.amount := NVL (rec1.amount, 0);
         v_cdrpr_rec.discount := 0;
         v_cdrpr_rec.input_vat := NVL (v_input_vat, 0);
         v_cdrpr_rec.net_amt := NVL (v_net_amt, 0);
         PIPE ROW (v_cdrpr_rec);
      END LOOP;

      RETURN;
   END;

   -- END added by Jayson 10.25.2011 --
   /* journalvoucherregister_d Modified by Vondanix 5/10/2013
   ** for AC-SPECS-2013-034
   */
   FUNCTION journalvoucherregister_d (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_jv_tran_cd         VARCHAR2,
      p_coldv               VARCHAR2
   )
      RETURN jvr_type PIPELINED
   IS
      v_jvr    jvr_rec_type;
      v_memo   VARCHAR2 (100);
      
      /* Variables for LR_OR_NO and LR_OR_DATE conditions. -Vondanix */
      v_exist   			NUMBER;
      v_acct_tran_id	    NUMBER;
      v_col_yes				NUMBER;
      v_lr_or_no            VARCHAR2(25);
      v_lr_or_date          VARCHAR2(25);
   BEGIN
      FOR c1 IN (SELECT   b.gfun_fund_cd, 
                          b.gibr_branch_cd, 
                          gb.branch_name,
                          b.tran_date, 
                          b.posting_date,
                          --B.TRAN_CLASS||'-'||TO_CHAR(B.TRAN_CLASS_NO) "TRAN CLASS",  --commented out by ging  100505
                          b.tran_class,
                          --added by ging  100505,
                          LPAD (b.jv_no, 6, 0) jv_no, 
                          b.ref_jv_no,
                          --issa@cic 02.15.2007
                          LPAD (b.tran_id, 12, 0) tran_id, 
                          b.tran_year,
                          LPAD(B.tran_month,2,0) tran_month,  
                          LPAD(B.tran_seq_no,6,0) tran_seq_no,
                          --end of addition ging 100505
                          b.jv_tran_type,
                          b.particulars,
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
                          || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09'))
                             gl_acct_no,
                          c.gl_acct_name acct_name, 
                          SUM (a.debit_amt) db_amt,
                          SUM (a.credit_amt) cd_amt, 
                          b.sap_inc_tag, 
                          b.jv_pref, b.jv_seq_no
                     FROM giac_acct_entries a,
                          giac_acctrans b,
                          giac_chart_of_accts c,
                          giac_branches gb
                    WHERE a.gacc_tran_id = b.tran_id
                  --  AND b.tran_id=d.gacc_tran_id
/* vondanix 050713*/  AND a.gl_acct_id = c.gl_acct_id 
/*                     
                      AND a.gl_acct_category = c.gl_acct_category
                      AND a.gl_control_acct = c.gl_control_acct
                      AND a.gl_sub_acct_1 = c.gl_sub_acct_1
                      AND a.gl_sub_acct_2 = c.gl_sub_acct_2
                      AND a.gl_sub_acct_3 = c.gl_sub_acct_3
                      AND a.gl_sub_acct_4 = c.gl_sub_acct_4
                      AND a.gl_sub_acct_5 = c.gl_sub_acct_5
                      AND a.gl_sub_acct_6 = c.gl_sub_acct_6
                      AND a.gl_sub_acct_7 = c.gl_sub_acct_7
*/
                     AND b.gfun_fund_cd = gb.gfun_fund_cd
                     AND b.gibr_branch_cd = gb.branch_cd
                     AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
                     AND b.tran_class = NVL (p_tran_class, b.tran_class)
                     AND ( (TRUNC (posting_date) BETWEEN p_date AND p_date2
                            AND p_post_tran_toggle = 'P')
                          OR (TRUNC (tran_date) BETWEEN p_date AND p_date2
                              AND p_post_tran_toggle = 'T'))
                     AND ( (tran_flag = 'P' AND p_post_tran_toggle = 'P')
                          OR (tran_flag IN ('C', 'P')
                              AND p_post_tran_toggle = 'T'))
                     AND b.tran_class NOT IN (DECODE(p_coldv, 'Y', 'XX', 'COL'),  DECODE(p_coldv, 'Y', 'XX', 'DV'))
                     AND b.tran_flag != 'D'
                   --AND b.jv_tran_type = NVL(p_jv_tran_cd,b.jv_tran_type) --issa@cic 02.14.2007
                     AND NVL (b.jv_tran_type, 'XXX') =
                               NVL (p_jv_tran_cd, NVL (b.jv_tran_type, 'XXX'))
                     AND NVL(p_branch, b.gibr_branch_cd) IN (
                                SELECT iss_cd
                                  FROM giis_issource
                                 WHERE iss_cd =
                                          DECODE (check_user_per_iss_cd_acctg (NULL,
                                                                               iss_cd,
                                                                               'GIACS127'
                                                                              ),
                                                  1, iss_cd,
                                                  NULL
                                                 ))
-- aaron 05272008 to synchronize with report GIACR138
--decode(b.tran_flag,'C',b.tran_date,'P',b.posting_date) BETWEEN p_DATE AND p_DATE2 and
--  and b.tran_flag in ('C','P')
                 GROUP BY b.gfun_fund_cd,
                          b.gibr_branch_cd,
                          gb.branch_name,
                          b.tran_date,
                          b.posting_date,
--B.TRAN_CLASS||'-'||TO_CHAR(B.TRAN_CLASS_NO), --commented out by ging 100505
                          b.tran_class,                 --added by ging 100505
                          b.jv_no,                      --added by ging 100505
                          b.ref_jv_no,                   --issa@cic 02.15.2007
                          b.tran_id,
                          b.tran_year,
                          b.tran_month,
                          b.tran_seq_no,         --end of addition ging 100505
                          b.jv_tran_type,
                          b.particulars,
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
                          c.gl_acct_name,
                          b.sap_inc_tag,
                          b.jv_pref,
                          b.jv_seq_no)                   
      LOOP
         v_jvr.gibr_branch_cd := c1.gibr_branch_cd;
         v_jvr.branch_name := c1.branch_name;
         v_jvr.tran_date := c1.tran_date;
         v_jvr.posting_date := c1.posting_date;
         --v_jvr.ref_no := c1.ref_no;
         v_jvr.tran_id := c1.tran_id;
         v_jvr.jv_ref_no := c1.jv_pref || ' ' || LPAD (TO_CHAR(c1.jv_seq_no), 12, '0'); -- added by gab 09.14.2015
         v_jvr.ref_no := get_ref_no(c1.tran_id); --added to correct display of ref_no below by robert SR 5201 02.05.2016
--         IF c1.tran_class = 'JV' AND c1.ref_jv_no IS NOT NULL
--         THEN
--            v_jvr.ref_no :=
--                  c1.ref_jv_no
--               || CHR (10)
--               || c1.tran_year
--               || '-'
--               || c1.tran_month
--               || '-'
--               || c1.tran_seq_no
--               || '/'
--               || c1.tran_class
--               || '-'
--               || c1.jv_no
--               || ' '
--               || LPAD(c1.tran_id,12,0); --vondanix 05/10/13
--         ELSIF c1.tran_class = 'JV' AND c1.ref_jv_no IS NULL
--         THEN
--            v_jvr.ref_no :=
--                  c1.tran_year
--               || '-'
--               || c1.tran_month
--               || '-'
--               || c1.tran_seq_no
--               || '/'
--               || c1.tran_class
--               || ' '
--               || c1.jv_no
--               || CHR (10)
--               || LPAD(c1.tran_id,12,0); --vondanix 05/10/13
--         --issa--
--         ELSIF c1.tran_class IN ('CM', 'DM')
--         THEN
--            FOR x IN (SELECT a.memo_year || '-' || a.memo_seq_no memo
--                        FROM giac_cm_dm a
--                       WHERE a.gacc_tran_id = c1.tran_id)
--            LOOP
--               v_memo := x.memo;
--               EXIT;
--            END LOOP;

--            v_jvr.ref_no := c1.tran_class || '-' || v_memo;
--         ELSE
--            v_jvr.ref_no :=
--                  c1.tran_class
--               || '-'
--               || c1.tran_year
--               || '-'
--               || c1.tran_month
--               || '-'
--               || c1.tran_seq_no
--               || ' '
--               || LPAD(c1.tran_id,12,0); --vondanix 05/10/13
--         END IF;

         --Vondanix LR_OR_NO and LR_OR_Date conditions.
         BEGIN 
          SELECT DISTINCT(1)
            INTO v_exist
            FROM GICL_RECOVERY_PAYT
           WHERE acct_tran_id2 = c1.tran_id;
         EXCEPTION
            WHEN no_data_found THEN
                v_jvr.lr_OR_NO         := null;
                v_jvr.lr_OR_Date       := null;
         END;
 
         IF v_exist = 1 THEN
             v_lr_or_no     := NULL;
             v_lr_or_date   := NULL;
             FOR x IN ( SELECT (or_pref_suf || '-' || or_no) LR_OR_NO, TO_CHAR(or_date, 'MM-DD-YYYY') LR_OR_DATE
                          FROM giac_order_of_payts
                         WHERE GACC_TRAN_ID IN (SELECT tran_id
                                                  FROM (SELECT tran_id, tran_class
                                                          FROM giac_acctrans
                                                         WHERE tran_id IN (SELECT acct_tran_id
                                                                             FROM gicl_recovery_payt
                                                                            WHERE acct_tran_id2 = c1.tran_id))
                                                 WHERE tran_class = 'COL')
                   )
             LOOP
                IF v_lr_or_no IS NULL AND v_lr_or_date IS NULL THEN
                   v_lr_or_no    := x.LR_OR_NO;
                   v_lr_or_date  := x.LR_OR_DATE;
                ELSE 
                    v_lr_or_no   := v_lr_or_no   || CHR(10) || x.LR_OR_NO;
                    v_lr_or_date := v_lr_or_date || CHR(10) || x.LR_OR_DATE;
  	            END IF;
             END LOOP;
                v_jvr.lr_OR_NO   := v_lr_or_no;
                v_jvr.lr_OR_Date := v_lr_or_date;  
         ELSE
            v_jvr.lr_OR_NO       := null;
            v_jvr.lr_OR_Date     := null;
         END IF;
         --vondanix END
         
         v_jvr.jv_tran_type     := c1.jv_tran_type;
         v_jvr.particulars      := c1.particulars;
         v_jvr.gl_account       := c1.gl_acct_no;
         v_jvr.gl_account_name  := c1.acct_name;
         v_jvr.debit_amt        := c1.db_amt;
         v_jvr.credit_amt       := c1.cd_amt;
         PIPE ROW (v_jvr);
      END LOOP;

      RETURN;
   END;

   FUNCTION journalvoucherregister_s (
      p_branch             VARCHAR2,
      p_date               DATE,
      p_date2              DATE,
      p_post_tran_toggle   VARCHAR2,
      p_tran_class         VARCHAR2,
      p_jv_tran_cd         VARCHAR2
   )
      RETURN jvr_type2 PIPELINED
   IS
      v_jvr   jvr_rec_type2;
   BEGIN
      FOR c1 IN
         (SELECT   b.gfun_fund_cd acct_fund_cd,
                   
                      --B.GIBR_BRANCH_CD ACCT_BRANCH_CD,
                      --GB.BRANCH_NAME ACCT_BRANCH_NAME,
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
                   || LTRIM (TO_CHAR (c.gl_sub_acct_7, '09'))
                                                             acct_gl_acct_no,
                   c.gl_acct_name acct_acct_name,
                   SUM (a.debit_amt) acct_db_amt,
                   SUM (a.credit_amt) acct_cd_amt
              FROM giac_acct_entries a,
                   giac_acctrans b,
                   giac_chart_of_accts c,
                   giac_branches gb
             WHERE a.gacc_tran_id = b.tran_id
               --  and b.tran_id=d.gacc_tran_id
               AND a.gl_acct_category = c.gl_acct_category
               AND a.gl_control_acct = c.gl_control_acct
               AND a.gl_sub_acct_1 = c.gl_sub_acct_1
               AND a.gl_sub_acct_2 = c.gl_sub_acct_2
               AND a.gl_sub_acct_3 = c.gl_sub_acct_3
               AND a.gl_sub_acct_4 = c.gl_sub_acct_4
               AND a.gl_sub_acct_5 = c.gl_sub_acct_5
               AND a.gl_sub_acct_6 = c.gl_sub_acct_6
               AND a.gl_sub_acct_7 = c.gl_sub_acct_7
               AND b.gfun_fund_cd = gb.gfun_fund_cd
               AND b.gibr_branch_cd = gb.branch_cd
               AND b.gibr_branch_cd = NVL (p_branch, b.gibr_branch_cd)
               AND b.tran_class = NVL (p_tran_class, b.tran_class)
               AND (   (    TRUNC (posting_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'P'
                       )
                    OR (    TRUNC (tran_date) BETWEEN p_date AND p_date2
                        AND p_post_tran_toggle = 'T'
                       )
                   )
               AND (   (tran_flag = 'P' AND p_post_tran_toggle = 'P')
                    OR (tran_flag IN ('C', 'P') AND p_post_tran_toggle = 'T')
                   )
               AND b.tran_class NOT IN ('COL', 'DV')
               AND b.tran_flag != 'D'
               --AND b.jv_tran_type = NVL(p_jv_tran_cd, b.jv_tran_type) --issa@cic 02.14.2007
               AND NVL (b.jv_tran_type, 'XXX') =
                               NVL (p_jv_tran_cd, NVL (b.jv_tran_type, 'XXX'))
                         -- aaron 05272008 to synchronize with report GIACR138
          --  decode(tran_flag,'C',to_char(tran_date,'MM'),'P',to_char(posting_date,'MM')) = TO_CHAR(to_date(p_DATE, 'mm/dd/yyyy'), 'MM')
          --  and b.tran_flag in ('C','P')
          --  and
          GROUP BY b.gfun_fund_cd,
                        --b.gibr_branch_cd,
                      --gb.branch_name,
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
         v_jvr.gl_account := c1.acct_gl_acct_no;
         v_jvr.gl_account_name := c1.acct_acct_name;
         /* v_jvr.debit_balance := c1.acct_db_amt;
         v_jvr.credit_balance := c1.acct_cd_amt; */
         
         --added by MarkS 8.5.2016 SR5599
         IF c1.acct_db_amt > c1.acct_cd_amt THEN
            v_jvr.debit_balance := c1.acct_db_amt - c1.acct_cd_amt;
         ELSE
            v_jvr.debit_balance :=   0;
         END IF;

         IF c1.acct_cd_amt > c1.acct_db_amt  THEN
            v_jvr.credit_balance := c1.acct_cd_amt - c1.acct_db_amt;
         ELSE
            v_jvr.credit_balance := 0;
         END IF;
         --END 8.5.2016 SR5599
         PIPE ROW (v_jvr);
      END LOOP;

      RETURN;
   END;

   -- jhing 01.08.2015 commented out whole code.Major revision on queries/code.  GENQA 5269
  /*
   FUNCTION infacrisubsledger (
      p_from_date   DATE,
      p_to_date     DATE,
      p_ri_cd       NUMBER,
      p_line_cd     VARCHAR2,
      p_date_type   VARCHAR2
   )
      RETURN ifrsl_type PIPELINED
   IS
      v_ifrsl        ifrsl_rec_type;
      v_tran_class   giac_acctrans.tran_class%TYPE;
   BEGIN
      FOR c1 IN
         (SELECT   gp.pol_flag, gr.ri_name, gl.line_name,
                   (gp.eff_date) eff_dt,
                      gp.line_cd
                   || '-'
                   || gp.subline_cd
                   || '-'
                   || gp.iss_cd
                   || '-'
                   || gp.issue_yy
                   || '-'
                   || LTRIM (TO_CHAR (gp.pol_seq_no, '0000000'))
                   || '-'
                   || LTRIM (TO_CHAR (gp.renew_no, '00'))
                   || DECODE (gp.endt_seq_no,
                              0, NULL,
                                 '/'
                              || gp.endt_iss_cd
                              || '-'
                              || gp.endt_yy
                              || '-'
                              || LTRIM (TO_CHAR (gp.endt_seq_no, '000000'))
                             ) policy_no,
                   DECODE (gp.ref_pol_no,
                           NULL, NULL,
                           gp.ref_pol_no
                          ) ref_pol_no,
                   giv.iss_cd || '-' || giv.prem_seq_no invoice_no,
                   gi.ri_policy_no, gi.ri_binder_no, gia.assd_name,   --april
                   gp.tsi_amt,
                   
                   /*(NVL(GIV.PREM_AMT,0)+NVL(GIV.TAX_AMT,0)+NVL(GIV.NOTARIAL_FEE,0)+NVL(GIV.OTHER_CHARGES,0))*GIV.CURRENCY_RT GROSS_PREMIUM, */
                                  --NVL(GIV.PREM_AMT,0) GROSS_PREMIUM,
 /*                  ROUND (NVL (giv.prem_amt, 0) * NVL (currency_rt, 1),
                          2
                         ) gross_premium,
                   NVL (giv.ri_comm_amt, 0) * giv.currency_rt ri_commission,
                   
   /* (NVL(GIV.PREM_AMT,0)+NVL(GIV.TAX_AMT,0)+NVL(GIV.NOTARIAL_FEE,0)+NVL(GIV.OTHER_CHARGES,0)-NVL(GIV.RI_COMM_AMT,0))*GIV.CURRENCY_RT NET_PREMIUM, */
/*(NVL(GIV.PREM_AMT,0) + NVL(GIV.TAX_AMT,0) - NVL(GIV.RI_COMM_AMT,0) - NVL(GIV.RI_COMM_AMT*(GR.INPUT_VAT_RATE/100),0)) NET_PREMIUM,*/
                   /*(NVL(GIV.PREM_AMT,0) + NVL(GIV.TAX_AMT,0) - NVL(GIV.RI_COMM_AMT,0) - NVL(GIV.RI_COMM_VAT,0)) NET_PREMIUM,*/
  /*                 (  ROUND (NVL (giv.prem_amt, 0) * NVL (giv.currency_rt, 1),
                             2
                            )
                    + ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                             2)
                    - ROUND (  NVL (giv.ri_comm_amt, 0)
                             * NVL (giv.currency_rt, 1),
                             2
                            )
                    - ROUND (  NVL (giv.ri_comm_vat, 0)
                             * NVL (giv.currency_rt, 1),
                             2
                            )
                   ) net_premium,
                   garsd.prem_seq_no, garsd.a180_ri_cd, garsd.inst_no,
                   gipc.collection_amt gipc_collection_amt,
                   gipc.gacc_tran_id gacc_tran_id,
                   
                   --GIV.TAX_AMT EVAT,
                   ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                          2
                         ) evat,
                   
--(GIV.RI_COMM_AMT*(GR.INPUT_VAT_RATE/100)) VAT
                    --GIV.RI_COMM_VAT VAT
                   ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                          2
                         ) vat,
                   
--(NVL(NET_PREMIUM,0)-NVL(CS_GIPC_AMT,0)) d
                   gp.issue_date
              FROM giac_aging_ri_soa_details garsd,
                   giis_line gl,
                   giis_reinsurer gr,
                   giri_inpolbas gi,
                   gipi_invoice giv,
                   gipi_polbasic gp,
                   giis_assured gia,                                   --april
                   giac_inwfacul_prem_collns gipc
--,
--GIUW_POL_DIST GPD
          WHERE    garsd.a180_ri_cd = gr.ri_cd
               AND garsd.prem_seq_no = giv.prem_seq_no
               AND garsd.a150_line_cd = gl.line_cd
               AND garsd.a180_ri_cd = gi.ri_cd
               AND gia.assd_no = gp.assd_no                            --april
               AND gi.policy_id = giv.policy_id
               AND gi.policy_id = gp.policy_id
               AND garsd.prem_seq_no = gipc.b140_prem_seq_no(+)
               AND garsd.a180_ri_cd = gipc.a180_ri_cd(+)
               AND garsd.inst_no = gipc.inst_no(+)
               AND gipc.b140_iss_cd(+) = 'RI'
               AND giv.iss_cd = 'RI'
               AND garsd.a180_ri_cd = NVL (p_ri_cd, garsd.a180_ri_cd)
               AND garsd.a150_line_cd = NVL (p_line_cd, garsd.a150_line_cd)
               AND NOT EXISTS (
                      SELECT 'X'
                        FROM giac_reversals gr, giac_acctrans ga
                       WHERE gr.reversing_tran_id = ga.tran_id
                         AND gipc.gacc_tran_id = ga.tran_id
                         AND ga.tran_flag = 'D')
               AND gp.pol_flag <> 5
--AND GPD.DIST_FLAG NOT IN (4,5)
               AND DECODE (p_date_type,
                           '1', TRUNC (gp.issue_date),
                           '2', TRUNC (gp.eff_date),
                           '3', TRUNC (gp.acct_ent_date),
                           '4', LAST_DAY (TO_DATE (   booking_mth
                                                   || ','
                                                   || TO_CHAR (booking_year),
                                                   'FMMONTH,YYYY'
                                                  )
                                         )
                          ) BETWEEN p_from_date AND p_to_date
          UNION
          SELECT   gp.pol_flag, gr.ri_name, gl.line_name,
                   (gp.eff_date) eff_dt,
                      gp.line_cd
                   || '-'
                   || gp.subline_cd
                   || '-'
                   || gp.iss_cd
                   || '-'
                   || gp.issue_yy
                   || '-'
                   || LTRIM (TO_CHAR (gp.pol_seq_no, '0000000'))
                   || '-'
                   || LTRIM (TO_CHAR (gp.renew_no, '00'))
                   || DECODE (gp.endt_seq_no,
                              0, NULL,
                                 '/'
                              || gp.endt_iss_cd
                              || '-'
                              || gp.endt_yy
                              || '-'
                              || LTRIM (TO_CHAR (gp.endt_seq_no, '000000'))
                             ) policy_no,
                   DECODE (gp.ref_pol_no,
                           NULL, NULL,
                           gp.ref_pol_no
                          ) ref_pol_no,
                   giv.iss_cd || '-' || giv.prem_seq_no invoice_no,
                   gi.ri_policy_no, gi.ri_binder_no, gia.assd_name,    --april
                   gp.tsi_amt,
                   
                   /* (NVL(GIV.PREM_AMT,0)+NVL(GIV.TAX_AMT,0)+NVL(GIV.NOTARIAL_FEE,0)+NVL(GIV.OTHER_CHARGES,0))*GIV.CURRENCY_RT GROSS_PREMIUM, */
                                   --NVL(GIV.PREM_AMT,0) GROSS_PREMIUM,
   /*                ROUND (NVL (giv.prem_amt, 0) * NVL (currency_rt, 1),
                          2
                         ) gross_premium,
                   NVL (giv.ri_comm_amt, 0) * giv.currency_rt ri_commission,
                   
                   /*(NVL(GIV.PREM_AMT,0)+NVL(GIV.TAX_AMT,0)+NVL(GIV.NOTARIAL_FEE,0)+NVL(GIV.OTHER_CHARGES,0)-NVL(GIV.RI_COMM_AMT,0))*GIV.CURRENCY_RT NET_PREMIUM, */
                   /*(NVL(GIV.PREM_AMT,0) + NVL(GIV.TAX_AMT,0) - NVL(GIV.RI_COMM_AMT,0) - NVL(GIV.RI_COMM_AMT*(GR.INPUT_VAT_RATE/100),0)) NET_PREMIUM,*/
                                  /*(NVL(GIV.PREM_AMT,0) + NVL(GIV.TAX_AMT,0) - NVL(GIV.RI_COMM_AMT,0) - NVL(GIV.RI_COMM_VAT,0)) NET_PREMIUM,*/
   /*                (  ROUND (NVL (giv.prem_amt, 0) * NVL (giv.currency_rt, 1),
                             2
                            )
                    + ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                             2)
                    - ROUND (  NVL (giv.ri_comm_amt, 0)
                             * NVL (giv.currency_rt, 1),
                             2
                            )
                    - ROUND (  NVL (giv.ri_comm_vat, 0)
                             * NVL (giv.currency_rt, 1),
                             2
                            )
                   ) net_premium,
                   garsd.prem_seq_no, garsd.a180_ri_cd, garsd.inst_no,
                   - (gipc.collection_amt) gipc_collection_amt,
                   gipc.gacc_tran_id gacc_tran_id,
                   
--    GIV.TAX_AMT EVAT,
                   ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                          2
                         ) evat,
                   
--    (GIV.RI_COMM_AMT*(GR.INPUT_VAT_RATE/100)) VAT
--                    GIV.RI_COMM_VAT
                   ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                          2
                         ) vat,
                   
--    ga.tran_class
--(NVL(NET_PREMIUM,0)-NVL(CS_GIPC_AMT,0)) d
                   gp.issue_date
              FROM giac_aging_ri_soa_details garsd,
                   giis_line gl,
                   giis_reinsurer gr,
                   giri_inpolbas gi,
                   gipi_invoice giv,
                   gipi_polbasic gp,
                   giac_inwfacul_prem_collns gipc,
                   giac_order_of_payts gop,
--    giac_acctrans ga
                   giis_assured gia                                    --april
--,
--GIUW_POL_DIST GPD
          WHERE    garsd.a180_ri_cd = gr.ri_cd
               AND garsd.prem_seq_no = giv.prem_seq_no
               AND garsd.a150_line_cd = gl.line_cd
               AND garsd.a180_ri_cd = gi.ri_cd
               AND gi.policy_id = giv.policy_id
               AND gi.policy_id = gp.policy_id
               AND gia.assd_no = gp.assd_no                            --april
               AND garsd.prem_seq_no = gipc.b140_prem_seq_no                 --
               AND garsd.a180_ri_cd = gipc.a180_ri_cd                        --
               AND garsd.inst_no = gipc.inst_no
               AND gipc.b140_iss_cd = 'RI'                                   --
               AND giv.iss_cd = 'RI'
               AND garsd.a180_ri_cd = NVL (p_ri_cd, garsd.a180_ri_cd)
               AND garsd.a150_line_cd = NVL (p_line_cd, garsd.a150_line_cd)
               AND gipc.gacc_tran_id = gop.gacc_tran_id
               AND gop.or_flag = 'C'
--   AND gipc.gacc_tran_id=ga.tran_id
--   AND ga.TRAN_FLAG = 'D'
               AND NOT EXISTS (
                      SELECT 'X'
                        FROM giac_reversals gr, giac_acctrans ga
                       WHERE gr.reversing_tran_id = ga.tran_id
                         AND gipc.gacc_tran_id = ga.tran_id                  --
                         AND ga.tran_flag = 'D')
               AND gp.pol_flag <> 5
--AND GPD.DIST_FLAG NOT IN (4,5)
               AND DECODE (p_date_type,
                           '1', TRUNC (gp.issue_date),
                           '2', TRUNC (gp.eff_date),
                           '3', TRUNC (gp.acct_ent_date),
                           '4', LAST_DAY (TO_DATE (   booking_mth
                                                   || ','
                                                   || TO_CHAR (booking_year),
                                                   'FMMONTH,YYYY'
                                                  )
                                         )
                          ) BETWEEN p_from_date AND p_to_date
          ORDER BY eff_dt,
                   policy_no,
                   ref_pol_no,
                   ri_policy_no,
                   gacc_tran_id,
                   gipc_collection_amt DESC)
      LOOP
         v_ifrsl.reinsurer := c1.ri_name;
         v_ifrsl.line_name := c1.line_name;
         v_ifrsl.policy_no := c1.policy_no;
         v_ifrsl.ref_pol_no := c1.ref_pol_no;
         v_ifrsl.incept_date := c1.eff_dt;
         v_ifrsl.invoice_no := c1.invoice_no;
         v_ifrsl.ri_policy_no := c1.ri_policy_no;
         v_ifrsl.ri_binder_no := c1.ri_binder_no;
         v_ifrsl.assd_name := c1.assd_name;                           --APRIL
         v_ifrsl.amount_insured := c1.tsi_amt;
         v_ifrsl.premium := c1.gross_premium;
         v_ifrsl.vat := c1.evat;
         v_ifrsl.ri_commission := c1.ri_commission;
         v_ifrsl.vat_on_commission := c1.vat;
         v_ifrsl.net_due := NVL (c1.net_premium, 0);

         --v_ifrsl.ref_date := c1.ref_date;
         IF c1.gacc_tran_id IS NOT NULL
         THEN
            SELECT tran_class
              INTO v_tran_class
              FROM giac_acctrans
             WHERE tran_id = c1.gacc_tran_id;

            IF v_tran_class = 'DV'
            THEN
               SELECT dv_print_date, dv_pref || '-' || TO_CHAR (dv_no)
                 INTO v_ifrsl.ref_date, v_ifrsl.ref_no
                 FROM giac_disb_vouchers
                WHERE gacc_tran_id = c1.gacc_tran_id;
            END IF;

            IF v_tran_class = 'COL'
            THEN
               SELECT or_date, or_pref_suf || '-' || TO_CHAR (or_no)
                 INTO v_ifrsl.ref_date, v_ifrsl.ref_no
                 FROM giac_order_of_payts
                WHERE gacc_tran_id = c1.gacc_tran_id;
            END IF;

            IF v_tran_class = 'JV'
            THEN
               SELECT tran_date,
                         DECODE (jv_pref_suff, NULL, NULL, jv_pref_suff)
                      || DECODE (jv_pref_suff, NULL, NULL, '-')
                      || TO_CHAR (tran_class_no)
                 INTO v_ifrsl.ref_date,
                      v_ifrsl.ref_no
                 FROM giac_acctrans
                WHERE tran_id = c1.gacc_tran_id;
            END IF;
         END IF;

         --v_ifrsl.ref_no := c1.ref_no;
         v_ifrsl.collection_amt := NVL (c1.gipc_collection_amt, 0);
         v_ifrsl.balance :=
                      NVL (c1.net_premium, 0)
                      - NVL (c1.gipc_collection_amt, 0);
         PIPE ROW (v_ifrsl);
      END LOOP;

      RETURN;
   END;   */
   
   -- jhing end of commented out codes 01.08.2015
      
   -- jhing 01.29.2015 GENQA 5269 new codes for infacrisubsledger.
   FUNCTION infacrisubsledger (p_from_date    DATE,
                                p_to_date      DATE,
                                p_ri_cd        NUMBER,
                                p_line_cd      VARCHAR2,
                                p_date_type    VARCHAR2,
                                p_module_id   VARCHAR2,  
                                p_user_id     VARCHAR2 )
       RETURN ifrsl_type
       PIPELINED
   IS
       v_ifrsl        ifrsl_rec_type;
       v_tran_class   giac_acctrans.tran_class%TYPE;
       v_ref_date     VARCHAR2(2000);
       v_tran_ref_no  VARCHAR2(2000);
       v_collection_amt giac_inwfacul_prem_collns.collection_amt%TYPE; 
       v_balance_due    NUMBER (16, 2);
       v_totalPayt_due    NUMBER (16, 2);
       v_tsi_amt        gipi_polbasic.tsi_amt%TYPE; 
       v_cntPayt        NUMBER ; 
   BEGIN
       FOR c1
          IN (SELECT gp.pol_flag,
                     gr.ri_name,
                     gl.line_name,
                     (gp.eff_date) eff_dt,
                        gp.line_cd
                     || '-'
                     || gp.subline_cd
                     || '-'
                     || gp.iss_cd
                     || '-'
                     || gp.issue_yy
                     || '-'
                     || LTRIM (TO_CHAR (gp.pol_seq_no, '0000000'))
                     || '-'
                     || LTRIM (TO_CHAR (gp.renew_no, '00'))
                     || DECODE (
                           gp.endt_seq_no,
                           0, NULL,
                              '/'
                           || gp.endt_iss_cd
                           || '-'
                           || gp.endt_yy
                           || '-'
                           || LTRIM (TO_CHAR (gp.endt_seq_no, '000000')))
                        policy_no,
                     DECODE (gp.ref_pol_no, NULL, NULL, gp.ref_pol_no) ref_pol_no,
                     giv.iss_cd || '-' || giv.prem_seq_no invoice_no,
                     gi.ri_policy_no,
                     gi.ri_binder_no,
                     gia.assd_name,
                     gp.tsi_amt,
                     ROUND (NVL (giv.prem_amt, 0) * NVL (currency_rt, 1), 2)
                        gross_premium,
                     NVL (giv.ri_comm_amt, 0) * giv.currency_rt ri_commission,
                     (  ROUND (NVL (giv.prem_amt, 0) * NVL (giv.currency_rt, 1),
                               2)
                      + ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1),
                               2)
                      - ROUND (
                           NVL (giv.ri_comm_amt, 0) * NVL (giv.currency_rt, 1),
                           2)
                      - ROUND (
                           NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                           2))
                        net_premium,
                     ROUND (NVL (giv.tax_amt, 0) * NVL (giv.currency_rt, 1), 2)
                        evat,
                     ROUND (NVL (giv.ri_comm_vat, 0) * NVL (giv.currency_rt, 1),
                            2)
                        vat,
                     gp.issue_date,
                     giv.iss_cd,
                     giv.prem_seq_no, 
                     gp.line_cd 
                FROM giis_line gl,
                     giis_reinsurer gr,
                     giri_inpolbas gi,
                     gipi_invoice giv,
                     gipi_polbasic gp,
                     giis_assured gia
               WHERE     gi.ri_cd = gr.ri_cd
                     AND gp.line_cd = gl.line_cd
                     AND gia.assd_no = gp.assd_no
                     AND gi.policy_id = giv.policy_id
                     AND gi.policy_id = gp.policy_id
                     AND giv.iss_cd = giisp.v ('ISS_CD_RI')
                     --AND gp.pol_flag <> '5' --Deo [08.10.2016]: modified condition for including spoiled policies
                     AND (   gp.pol_flag <> '5'
                          OR (    gp.pol_flag = '5'
                              AND NVL (gp.spld_acct_ent_date, gp.spld_date) >
                                                                             p_to_date
                             )
                         )
                     --end Deo [08.10.2016]
                     AND gi.ri_cd = NVL (p_ri_cd, gi.ri_cd)
                     AND gp.line_cd = NVL (p_line_cd, gp.line_cd)                  
                     AND (  DECODE (
                            p_date_type,
                            '1', TRUNC (gp.issue_date),
                            '2', TRUNC (gp.eff_date),
                            '3', TRUNC (gp.acct_ent_date),
                            '4', LAST_DAY (
                                    TO_DATE (
                                          booking_mth
                                       || ','
                                       || TO_CHAR (booking_year),
                                       'FMMONTH,YYYY'))) BETWEEN p_from_date
                                                             AND p_to_date )
                    AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                             WHERE branch_cd =  giisp.v ('ISS_CD_RI') )                                          
                              )
       LOOP
          --Deo [08.10.2016]: added to consider update of ri commission (SR-22308)
          IF p_date_type = '3'
          THEN
             FOR j IN (SELECT   ROUND (a.old_ri_comm_amt * b.currency_rt,
                                       2
                                      ) old_ri_comm_amt,
                                ROUND (a.old_ri_comm_vat * b.currency_rt,
                                       2
                                      ) old_ri_comm_vat
                           FROM giac_ri_comm_hist a, gipi_invoice b
                          WHERE a.policy_id = b.policy_id
                            AND b.iss_cd = giisp.v ('ISS_CD_RI')
                            AND b.prem_seq_no = c1.prem_seq_no
                            AND a.acct_ent_date <= p_to_date
                            AND TRUNC (a.post_date) > p_to_date
                       ORDER BY a.tran_id)
             LOOP
                c1.ri_commission := j.old_ri_comm_amt;
                c1.vat := j.old_ri_comm_vat;
                c1.net_premium :=
                        c1.gross_premium + c1.evat - c1.ri_commission - c1.vat;
                EXIT;
             END LOOP;
          END IF;
          --end Deo [08.10.2016]
          
          v_ifrsl.reinsurer := c1.ri_name;
          v_ifrsl.line_name := c1.line_name;
          v_ifrsl.policy_no := c1.policy_no;
          v_ifrsl.ref_pol_no := c1.ref_pol_no;
          v_ifrsl.incept_date := c1.eff_dt;
          v_ifrsl.invoice_no := c1.invoice_no;
          v_ifrsl.ri_policy_no := c1.ri_policy_no;
          v_ifrsl.ri_binder_no := c1.ri_binder_no;
          v_ifrsl.assd_name := c1.assd_name;                              
          v_ifrsl.premium := c1.gross_premium;
          v_ifrsl.vat := c1.evat;
          v_ifrsl.ri_commission := c1.ri_commission;
          v_ifrsl.vat_on_commission := c1.vat;
          v_ifrsl.net_due := NVL (c1.net_premium, 0);
          v_ifrsl.issue_date := c1.issue_date;
          v_cntPayt := 0 ;           
          
          -- get  tsi amount per bill
          v_tsi_amt := 0 ;
          FOR tx IN (SELECT NVL(SUM (NVL (A.TSI_AMT, 0) * NVL (B.CURRENCY_RT, 1)),0) sum_insured
                          FROM GIPI_INVPERIL A, GIPI_INVOICE B, GIIS_PERIL C
                         WHERE     A.ISS_CD = c1.iss_cd
                               AND A.PREM_SEQ_NO = c1.prem_seq_no
                               AND A.ISS_CD = B.ISS_CD
                               AND A.PREM_SEQ_NO = B.PREM_SEQ_NO
                               AND A.PERIL_CD = C.PERIL_CD
                               AND C.LINE_CD = c1.line_cd
                               AND C.PERIL_TYPE = 'B')
          LOOP
             v_tsi_amt := tx.sum_insured ;          
          END LOOP; 
          
          v_ifrsl.amount_insured := v_tsi_amt;
          
          
          -- get total collection amt           
          v_collection_amt := 0;
          FOR c2 IN (SELECT sum(nvl(a.collection_amt,0)) coll_amt
                          FROM giac_inwfacul_prem_collns a,
                               giac_acctrans d
                         WHERE d.tran_flag <> 'D'
                           AND a.gacc_tran_id = d.tran_id
                           AND NOT EXISTS (
                                  SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                     AND x.gacc_tran_id = d.tran_id)
                           AND a.b140_iss_cd = c1.iss_cd 
                           AND a.b140_prem_seq_no = c1.prem_seq_no )
          LOOP          
                v_collection_amt := c2.coll_amt;
                v_balance_due := NVL (c1.net_premium, 0) - NVL (v_collection_amt, 0);  
                EXIT;
          END LOOP;          
          
          v_balance_due := NVL (c1.net_premium, 0) - NVL (v_collection_amt, 0); 
          v_ifrsl.balance := v_balance_due ;           
          

                  
          -- collection 
          FOR c2 IN (SELECT d.tran_date ref_date,
                               a.gacc_tran_id g_tran_id,
                               a.collection_amt coll_amt, d.tran_class t_class
                          FROM giac_inwfacul_prem_collns a,
                               giac_acctrans d
                         WHERE d.tran_flag <> 'D'
                           AND a.gacc_tran_id = d.tran_id
                           AND NOT EXISTS (
                                  SELECT x.gacc_tran_id
                                    FROM giac_reversals x, giac_acctrans y
                                   WHERE x.reversing_tran_id = y.tran_id
                                     AND y.tran_flag <> 'D'
                                     AND x.gacc_tran_id = d.tran_id)
                           AND a.b140_iss_cd = c1.iss_cd 
                           AND a.b140_prem_seq_no = c1.prem_seq_no
                           ORDER BY a.gacc_tran_id )
          LOOP
              v_ifrsl.ref_date := c2.ref_date;
              v_ifrsl.ref_no := get_ref_no(c2.g_tran_id);
              v_ifrsl.collection_amt := NVL(c2.coll_amt,0);  
              
              IF v_cntPayt > 0 THEN 
                  v_ifrsl.premium := 0 ;
                  v_ifrsl.vat := 0 ;
                  v_ifrsl.ri_commission := 0 ;
                  v_ifrsl.vat_on_commission := 0 ;
                  v_ifrsl.net_due := 0 ;
                  v_ifrsl.amount_insured := 0 ;
                  v_ifrsl.balance := 0  ;           
          
              END IF; 
              
              
              PIPE ROW (v_ifrsl);    
              v_cntPayt := v_cntPayt + 1; 
                                                         
          END LOOP;                                               

          -- if there are no payments for the bill, output the record as is 
          IF v_cntPayt = 0 THEN
          
              v_ifrsl.ref_date := NULL ;
              v_ifrsl.ref_no := NULL ;
              v_ifrsl.collection_amt := 0 ;  
              PIPE ROW (v_ifrsl);    
          END IF; 
 

       END LOOP;

       RETURN;
   END;

   FUNCTION outrisubsledger_old (  -- jhing 01.28.2016 renamed function to old - for GENQA 5270 - will need to redesign CSV output
      p_date_from   DATE, 
      p_date_to     DATE,
      p_ri_cd       NUMBER,
      p_line_cd     VARCHAR2,
      p_date_type   VARCHAR2,
      p_module_id   VARCHAR2, --mikel 11.23.2015; UCPBGEN 20878
      p_user_id     VARCHAR2 --mikel 11.23.2015; UCPBGEN 20878
   )
      RETURN orsl_type PIPELINED
   IS
      v_orsl             orsl_rec_type;
      v_tran_class       giac_acctrans.tran_class%TYPE;
      v_withpay          VARCHAR2 (1);
      v_ref_date         VARCHAR2 (300);
      --v_ref_date DATE;
      v_ref_no           VARCHAR2 (100);
      v_disb             NUMBER;
      v_net_prem         NUMBER;
      v_if_xxxx          VARCHAR2 (1)                    := 'N';
      --alfie 06022009
      v_the_ri           VARCHAR2 (1000)                 := 'A';
      v_the_current_ri   VARCHAR2 (1000)                 := 'B';
      v_the_total_bal    NUMBER                          := 0;
   BEGIN
      FOR c1 IN
         (SELECT k.ri_name,
               i.line_name,
               c.eff_date,
               get_binder_no (b.fnl_binder_id) binder,
               get_policy_no (g.policy_id) policy_no,
               g.policy_id,
               m.assd_name assured,
               NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0) amt_insured,
               NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0) prem,
               NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0) comm,
                 (  (NVL (c.ri_prem_amt, 0) + NVL (c.ri_prem_vat, 0))
                  - (NVL (c.ri_comm_amt, 0) + NVL (c.ri_comm_vat, 0)))
               * NVL (d.currency_rt, 0)
                  net_prem,
               c.fnl_binder_id binder_id,
               c.replaced_flag,
               NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0) ri_prem_vat,
               NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0) ri_comm_vat,
               NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0) ri_wholding_vat,
               1 constant,
               b.frps_yy,
               b.frps_seq_no,
               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
          FROM giri_frps_ri b,
               giri_binder c,
               giri_distfrps d,
               giuw_policyds e,
               giuw_pol_dist f,
               gipi_polbasic g,
               giis_line i,
               giis_subline j,
               giis_reinsurer k,
               gipi_parlist l,
               giis_assured m
         WHERE     1 = 1
               AND c.ri_cd = k.ri_cd
               AND b.fnl_binder_id = c.fnl_binder_id
               AND b.line_cd = d.line_cd
               AND b.frps_yy = d.frps_yy
               AND b.frps_seq_no = d.frps_seq_no
               AND d.dist_no = e.dist_no
               AND d.dist_seq_no = e.dist_seq_no
               AND e.dist_no = f.dist_no
               AND f.policy_id = g.policy_id
               AND f.par_id = l.par_id
               AND l.assd_no = m.assd_no
               AND ((p_date_type = '3'
                   AND g.acct_ent_date IS NOT NULL
                   AND LAST_DAY (g.acct_ent_date) <= LAST_DAY (p_date_to)
                   AND LAST_DAY (TRUNC (f.acct_ent_date)) <= LAST_DAY (p_date_to))
                   OR p_date_type != '3'
                   )
               AND DECODE (p_date_type,
                         '1', TRUNC (c.eff_date),
                         '2', TRUNC (c.binder_date),
                         '3', TRUNC (c.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
               AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                            WHERE branch_cd = g.iss_cd)                                        
               AND g.line_cd = i.line_cd
               AND g.line_cd = j.line_cd
               AND g.subline_cd = j.subline_cd
               AND g.reg_policy_sw = 'Y'
        UNION
        SELECT k.ri_name,
               i.line_name,
               c.eff_date,
               get_binder_no (b.fnl_binder_id) binder,
               get_policy_no (g.policy_id) policy_no,
               g.policy_id,
               m.assd_name assured,
               NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0) * -1 amt_insured,
               NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0) * -1 prem,
               NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0) * -1 comm,
                 (  (NVL (c.ri_prem_amt, 0) + NVL (c.ri_prem_vat, 0))
                  - (NVL (c.ri_comm_amt, 0) + NVL (c.ri_comm_vat, 0)))
               * NVL (d.currency_rt, 0)
               * -1
                  net_prem,
               c.fnl_binder_id binder_id,
               c.replaced_flag,
               NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0) * -1 ri_prem_vat,
               NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0) * -1 ri_comm_vat,
               NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0) * -1
                  ri_wholding_vat,
               2 constant,
               b.frps_yy,
               b.frps_seq_no,
               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
          FROM giri_frps_ri b,
               giri_binder c,
               giri_distfrps d,
               giuw_policyds e,
               giuw_pol_dist f,
               gipi_polbasic g,
               giis_line i,
               giis_subline j,
               giis_reinsurer k,
               gipi_parlist l,
               giis_assured m
         WHERE     1 = 1
               AND c.ri_cd = k.ri_cd
               AND b.fnl_binder_id = c.fnl_binder_id
               AND b.line_cd = d.line_cd
               AND b.frps_yy = d.frps_yy
               AND b.frps_seq_no = d.frps_seq_no
               AND d.dist_no = e.dist_no
               AND d.dist_seq_no = e.dist_seq_no
               AND e.dist_no = f.dist_no
               AND f.policy_id = g.policy_id
               AND f.par_id = l.par_id
               AND l.assd_no = m.assd_no
               AND ((p_date_type = '3'
               AND g.acct_ent_date IS NOT NULL
               AND LAST_DAY (g.acct_ent_date) <= LAST_DAY (p_date_to)
               AND (   (    f.dist_flag = '4'
                        AND LAST_DAY (TRUNC (f.acct_neg_date)) <=
                               LAST_DAY (p_date_to))           --negated distribution
                    OR (b.reverse_sw = 'Y')                          --reversed binder
                    OR f.dist_flag = '5'                               --redistributed
                                        ))
                    OR p_date_type != '3'
                   )
               AND DECODE (p_date_type,
                         '1', TRUNC (c.eff_date),
                         '2', TRUNC (c.binder_date),
                         '3', TRUNC (c.acc_rev_date),
                         '4', LAST_DAY (TO_DATE (   g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to 
               AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                            WHERE branch_cd = g.iss_cd)                                           
               AND g.line_cd = i.line_cd
               AND g.line_cd = j.line_cd
               AND g.subline_cd = j.subline_cd
               AND g.reg_policy_sw = 'Y'
         --mikel 11.23.2015 UCPBGEN 20878, ORIGINAL QUERY replaced with above query
         /*         -- NEW query copied from 11.14.2011 version of GIACR106 --
                   -- by Jayson 11.14.2011 --
          SELECT b.ri_name, c.line_name, a.eff_date eff_date,
                 a.line_cd || '-' || a.binder_yy || '-'
                 || a.binder_seq_no binder,
                 DECODE (d.endt_seq_no,
                         0, (   d.line_cd
                             || '-'
                             || d.subline_cd
                             || '-'
                             || d.iss_cd
                             || '-'
                             || d.issue_yy
                             || '-'
                             || d.pol_seq_no
                             || '-'
                             || d.renew_no
                          ),
                         (   d.line_cd
                          || '-'
                          || d.subline_cd
                          || '-'
                          || d.iss_cd
                          || '-'
                          || d.issue_yy
                          || '-'
                          || d.pol_seq_no
                          || '-'
                          || d.renew_no
                          || '-'
                          || d.endt_iss_cd
                          || '-'
                          || d.endt_yy
                          || '-'
                          || d.endt_seq_no
                         )
                        ) policy_no,
                 d.policy_id, e.assd_name assured,
                 a.ri_tsi_amt * g.currency_rt amt_insured,
                 a.ri_prem_amt * g.currency_rt prem,
                 a.ri_comm_amt * g.currency_rt comm,
                   (  (a.ri_prem_amt + NVL (a.ri_prem_vat, 0))
                    - (a.ri_comm_amt + NVL (a.ri_comm_vat, 0))
                   )
                 * g.currency_rt net_prem,
                 a.fnl_binder_id binder_id, a.replaced_flag,
                 a.ri_prem_vat * g.currency_rt ri_prem_vat,
                 a.ri_comm_vat * g.currency_rt ri_comm_vat,
                 a.ri_wholding_vat * g.currency_rt ri_wholding_vat,
                 1 CONSTANT, f.frps_yy, f.frps_seq_no,
                 --TRUNC (a.binder_date) + NVL (f.prem_warr_days, 0) ppw -- Commented out by Jerome Bautista 09.10.2015 SR 17598
                 TRUNC (a.eff_date) + NVL (f.prem_warr_days, 0) ppw -- Added by Jerome Bautista 09.10.2015 SR 17598
            -- added by Jayson 11.14.2011
          FROM   giri_binder a,
                 giis_reinsurer b,
                 giis_line c,
                 gipi_polbasic d,
                 giis_assured e,
                 giri_frps_ri f,
                 giri_distfrps g,
                 giuw_policyds h,
                 giuw_pol_dist i,
                 gipi_parlist j
           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
             AND a.line_cd = NVL (p_line_cd, a.line_cd)
             AND DECODE (p_date_type,
                         '1', TRUNC (a.eff_date),
                         '2', TRUNC (a.binder_date),
                         '3', TRUNC (a.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   d.booking_mth
                                                 || ','
                                                 || TO_CHAR (d.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
             AND a.ri_cd = b.ri_cd
             AND a.line_cd = c.line_cd
             AND a.fnl_binder_id = f.fnl_binder_id
             AND f.frps_yy = g.frps_yy
             AND f.frps_seq_no = g.frps_seq_no
             AND f.line_cd = g.line_cd
             AND g.dist_no = h.dist_no
             AND g.dist_seq_no = h.dist_seq_no
             AND h.dist_no = i.dist_no
             AND i.par_id = j.par_id
             AND j.assd_no = e.assd_no
             AND i.policy_id = d.policy_id
             AND d.pol_flag <> '5'
             AND (   (    p_date_type = '3'
                      AND (   TRUNC (i.acct_ent_date) BETWEEN p_date_from
                                                          AND p_date_to
                           OR NVL (TRUNC (i.acct_neg_date), p_date_to + 1)
                                 BETWEEN p_date_from
                                     AND p_date_to
                          )
                     )
                  OR p_date_type <> '3'
                 )
             AND DECODE
                    (i.dist_flag,
                     '4', DECODE
                        (UPPER (NVL (f.reverse_sw, 'N')),
                         'N', DECODE
                            (UPPER (NVL (a.replaced_flag, 'N')),
                             'Y', 1,
                             (CASE
                                 WHEN NVL (TRUNC (a.acc_rev_date),
                                           p_date_to + 1
                                          ) BETWEEN p_date_from AND p_date_to
                                    THEN 1
                                 ELSE 0
                              END
                             )
                            ),
                         1
                        ),
                     '5', DECODE
                        (UPPER (NVL (f.reverse_sw, 'N')),
                         'N', DECODE
                            (UPPER (NVL (a.replaced_flag, 'N')),
                             'Y', 1,
                             (CASE
                                 WHEN NVL (TRUNC (a.acc_rev_date),
                                           p_date_to + 1
                                          ) BETWEEN p_date_from AND p_date_to
                                    THEN 1
                                 ELSE 0
                              END
                             )
                            ),
                         1
                        ),
                     1
                    ) = 1
          UNION
          --Jhing (Jennifer) 06/02/2011 reversal for negated distribution
          SELECT b.ri_name, c.line_name, a.eff_date eff_date,
                 a.line_cd || '-' || a.binder_yy || '-'
                 || a.binder_seq_no binder,
                 DECODE (d.endt_seq_no,
                         0, (   d.line_cd
                             || '-'
                             || d.subline_cd
                             || '-'
                             || d.iss_cd
                             || '-'
                             || d.issue_yy
                             || '-'
                             || d.pol_seq_no
                             || '-'
                             || d.renew_no
                          ),
                         (   d.line_cd
                          || '-'
                          || d.subline_cd
                          || '-'
                          || d.iss_cd
                          || '-'
                          || d.issue_yy
                          || '-'
                          || d.pol_seq_no
                          || '-'
                          || d.renew_no
                          || '-'
                          || d.endt_iss_cd
                          || '-'
                          || d.endt_yy
                          || '-'
                          || d.endt_seq_no
                         )
                        ) policy_no,
                 d.policy_id, e.assd_name assured,
                 a.ri_tsi_amt * g.currency_rt * -1 amt_insured,
                 a.ri_prem_amt * g.currency_rt * -1 prem,
                 a.ri_comm_amt * g.currency_rt * -1 comm,
                   (  (a.ri_prem_amt + NVL (a.ri_prem_vat, 0))
                    - (a.ri_comm_amt + NVL (a.ri_comm_vat, 0))
                   )
                 * g.currency_rt
                 * -1 net_prem,
                 a.fnl_binder_id binder_id, a.replaced_flag,
                 a.ri_prem_vat * g.currency_rt * -1 ri_prem_vat,
                 a.ri_comm_vat * g.currency_rt * -1 ri_comm_vat,
                 a.ri_wholding_vat * g.currency_rt * -1 ri_wholding_vat,
                 2 dummy2, f.frps_yy, f.frps_seq_no,
                 TRUNC (a.binder_date) + NVL (f.prem_warr_days, 0) ppw
            -- added by Jayson 11.14.2011
          FROM   giri_binder a,
                 giis_reinsurer b,
                 giis_line c,
                 gipi_polbasic d,
                 giis_assured e,
                 giri_frps_ri f,
                 giri_distfrps g,
                 giuw_policyds h,
                 giuw_pol_dist i,
                 gipi_parlist j
           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
             AND a.line_cd = NVL (p_line_cd, a.line_cd)
             AND a.ri_cd = b.ri_cd
             AND a.line_cd = c.line_cd
             AND a.fnl_binder_id = f.fnl_binder_id
             AND f.frps_yy = g.frps_yy
             AND f.frps_seq_no = g.frps_seq_no
             AND f.line_cd = g.line_cd
             AND g.dist_no = h.dist_no
             AND g.dist_seq_no = h.dist_seq_no
             AND h.dist_no = i.dist_no
             AND i.par_id = j.par_id
             AND j.assd_no = e.assd_no
             AND i.policy_id = d.policy_id
             AND d.pol_flag <> '5'
             AND i.dist_flag IN ('4', '5')
             AND NVL (TRUNC (i.acct_neg_date), p_date_to + 1)
                    BETWEEN p_date_from
                        AND p_date_to
             AND (   TRUNC (a.acc_rev_date) BETWEEN p_date_from AND p_date_to
                  OR NVL (UPPER (a.replaced_flag), 'X') = 'Y'
                 )
          UNION
          -- jhing 06/02/2011 reversal for non-negated distribution
          SELECT b.ri_name, c.line_name, a.eff_date eff_date,
                 a.line_cd || '-' || a.binder_yy || '-'
                 || a.binder_seq_no binder,
                 DECODE (d.endt_seq_no,
                         0, (   d.line_cd
                             || '-'
                             || d.subline_cd
                             || '-'
                             || d.iss_cd
                             || '-'
                             || d.issue_yy
                             || '-'
                             || d.pol_seq_no
                             || '-'
                             || d.renew_no
                          ),
                         (   d.line_cd
                          || '-'
                          || d.subline_cd
                          || '-'
                          || d.iss_cd
                          || '-'
                          || d.issue_yy
                          || '-'
                          || d.pol_seq_no
                          || '-'
                          || d.renew_no
                          || '-'
                          || d.endt_iss_cd
                          || '-'
                          || d.endt_yy
                          || '-'
                          || d.endt_seq_no
                         )
                        ) policy_no,
                 d.policy_id, e.assd_name assured,
                 a.ri_tsi_amt * g.currency_rt * -1 amt_insured,
                 a.ri_prem_amt * g.currency_rt * -1 prem,
                 a.ri_comm_amt * g.currency_rt * -1 comm,
                   (  (a.ri_prem_amt + NVL (a.ri_prem_vat, 0))
                    - (a.ri_comm_amt + NVL (a.ri_comm_vat, 0))
                   )
                 * g.currency_rt
                 * -1 net_prem,
                 a.fnl_binder_id binder_id, a.replaced_flag,
                 a.ri_prem_vat * g.currency_rt * -1 ri_prem_vat,
                 a.ri_comm_vat * g.currency_rt * -1 ri_comm_vat,
                 a.ri_wholding_vat * g.currency_rt * -1 ri_wholding_vat,
                 3 dummy2, f.frps_yy, f.frps_seq_no,
                 TRUNC (a.binder_date) + NVL (f.prem_warr_days, 0) ppw
            -- added by Jayson 11.14.2011
          FROM   giri_binder a,
                 giis_reinsurer b,
                 giis_line c,
                 gipi_polbasic d,
                 giis_assured e,
                 giri_frps_ri f,
                 giri_distfrps g,
                 giuw_policyds h,
                 giuw_pol_dist i,
                 gipi_parlist j
           WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
             AND a.line_cd = NVL (p_line_cd, a.line_cd)
             AND a.ri_cd = b.ri_cd
             AND a.line_cd = c.line_cd
             AND a.fnl_binder_id = f.fnl_binder_id
             AND f.frps_yy = g.frps_yy
             AND f.frps_seq_no = g.frps_seq_no
             AND f.line_cd = g.line_cd
             AND g.dist_no = h.dist_no
             AND g.dist_seq_no = h.dist_seq_no
             AND h.dist_no = i.dist_no
             AND i.par_id = j.par_id
             AND j.assd_no = e.assd_no
             AND i.policy_id = d.policy_id
             AND d.pol_flag <> '5'
             AND i.dist_flag NOT IN ('4', '5')
             AND NVL (UPPER (f.reverse_sw), 'X') = 'Y'
             AND DECODE (p_date_type,
                         '1', TRUNC (a.eff_date),
                         '2', TRUNC (a.binder_date),
                         '3', TRUNC (a.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   d.booking_mth
                                                 || ','
                                                 || TO_CHAR (d.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
             AND (   (    p_date_type = '3'
                      AND TRUNC (i.acct_ent_date) BETWEEN p_date_from
                                                      AND p_date_to
                     )
                  OR p_date_type <> '3'
                 )*/
                     -- ORIGINAL QUERY replaced with above query by Jayson 11.14.2011 --
                     /*SELECT  b.ri_name, c.line_name,
                             A.eff_date eff_date,
                             A.line_cd || '-' ||A.binder_yy || '-' || A.binder_seq_no binder,
                             DECODE (d.endt_seq_no,0,(d.line_cd ||'-'|| d.subline_cd ||'-'|| d.iss_cd ||'-'|| d.issue_yy    ||'-'||d.pol_seq_no ||'-'|| d.renew_no),
                              (d.line_cd ||'-'|| d.subline_cd ||'-'|| d.iss_cd ||'-'|| d.issue_yy ||'-'|| d.pol_seq_no ||'-'||    d.renew_no ||'-'|| d.endt_iss_cd ||'-'|| d.endt_yy ||'-'|| d.endt_seq_no)) policy_no,                 d.policy_id,
                             e.assd_name assured,
                             A.ri_tsi_amt * g.currency_rt amt_insured,
                             A.ri_prem_amt * g.currency_rt prem,
                             A.ri_comm_amt * g.currency_rt comm,
                             ( (A.ri_prem_amt+(NVL(A.ri_prem_vat,0))) - (A.ri_comm_amt+NVL(a.ri_comm_vat,0))) * g.currency_rt net_prem, --aaron aug 06, 2008 to correct net prem
                             --( A.ri_prem_amt - A.ri_comm_amt) * g.currency_rt net_prem,
                             A.fnl_binder_id binder_id,
                             A.replaced_flag,
                             --added BY ging010906
                             A.ri_prem_vat * g.currency_rt ri_prem_vat, --Vincent 10062006: added currency_rt
                             A.ri_comm_vat * g.currency_rt ri_comm_vat, --Vincent 10062006: added currency_rt
                             A.ri_wholding_vat * g.currency_rt ri_wholding_vat,
                             1 CONSTANT --Vincent 10062006: added currency_rt
                             --ging 010906
                      FROM GIRI_BINDER A,
                           GIIS_REINSURER b,
                           GIIS_LINE c,
                           GIPI_POLBASIC d,
                           GIIS_ASSURED e,
                           GIRI_FRPS_RI f,
                           GIRI_DISTFRPS g,
                           GIUW_POLICYDS h,
                            GIUW_POL_DIST i,
                           GIPI_PARLIST j
                  WHERE  A.ri_cd = NVL( p_ri_cd, A.ri_cd )
                        AND A.line_cd = NVL( p_line_cd, A.line_cd )
                        AND DECODE(p_date_type,'1', TRUNC(A.eff_date),
                                                                    '2', TRUNC(A.binder_date),
                                                                    '3', TRUNC(A.acc_ent_date),
                                                                    '4',LAST_DAY (TO_DATE (d.booking_mth || ',' || TO_CHAR (d.booking_year),'FMMONTH,YYYY'))) BETWEEN  p_date_from  AND p_date_to
                         AND A.ri_cd = b.ri_cd
                         AND A.line_cd = c.line_cd
                         AND A.fnl_binder_id = f.fnl_binder_id
                         AND f.frps_yy = g.frps_yy
                         AND f.frps_seq_no = g.frps_seq_no
                         AND f.line_cd = g.line_cd
                         AND g.dist_no = h.dist_no
                         AND g.dist_seq_no = h.dist_seq_no
                         AND h.dist_no = i.dist_no
                         AND i.par_id = j.par_id
                         AND j.assd_no = e.assd_no
                         AND i.policy_id = d.policy_id
                         AND d.pol_flag <>'5'
                        --AND  i.dist_flag NOT IN('4','5') --Vincent 10062006: comment out
                        AND (p_date_type = '4' AND A.reverse_date IS NULL OR p_date_type <> '4')
                        --Vincent 10062006: added the ff condition
                        AND ((p_date_type = '3' AND (TRUNC (i.acct_ent_date) BETWEEN p_date_from AND p_date_to
                                                                          OR NVL (TRUNC (i.acct_neg_date), p_date_to + 1) BETWEEN p_date_from AND p_date_to))
                                  OR p_date_type <> '3')
                  UNION
                  --this part is used to select the reversals for binders whose replaced_flag=Y
                  --Aids 01/16/2004
                  SELECT  b.ri_name, c.line_name,
                   A.eff_date eff_date,
                   A.line_cd || '-' || A.binder_yy || '-' || A.binder_seq_no binder,
                   DECODE (d.endt_seq_no,0,(d.line_cd ||'-'|| d.subline_cd ||'-'|| d.iss_cd ||'-'|| d.issue_yy    ||'-'||d.pol_seq_no ||'-'|| d.renew_no),
                    (d.line_cd ||'-'|| d.subline_cd ||'-'|| d.iss_cd ||'-'|| d.issue_yy ||'-'|| d.pol_seq_no ||'-'||    d.renew_no ||'-'|| d.endt_iss_cd ||'-'|| d.endt_yy ||'-'|| d.endt_seq_no)) policy_no,                 d.policy_id,
                   e.assd_name assured,
                   DECODE(A.replaced_flag,'N', (A.ri_tsi_amt * g.currency_rt), ((A.ri_tsi_amt * g.currency_rt)*(-1))) amt_insured,
                                  DECODE(A.replaced_flag,'N', (A.ri_prem_amt * g.currency_rt), ((A.ri_prem_amt * g.currency_rt)*(-1))) prem,
                   DECODE(A.replaced_flag,'N', (A.ri_comm_amt * g.currency_rt), ((A.ri_comm_amt * g.currency_rt)*(-1))) comm,
                   DECODE(A.replaced_flag,'Y',  (((A.ri_prem_amt+NVL(a.ri_prem_vat,0)) - (A.ri_comm_amt+NVL(a.ri_comm_vat,0))) * g.currency_rt*-1))  net_prem, --aaron aug 06, 2008 to correct net prem
                   --DECODE(A.replaced_flag,'Y',  ((A.ri_prem_amt - A.ri_comm_amt) * g.currency_rt*-1))  net_prem,
                   A.fnl_binder_id binder_id,A.replaced_flag,
                                   --added by ging010906
                                  A.ri_prem_vat * g.currency_rt  * -1 ri_prem_vat, --Vincent 10062006: added currency_rt
                                  A.ri_comm_vat * g.currency_rt  * -1 ri_comm_vat, --Vincent 10062006: added currency_rt
                                  A.ri_wholding_vat * g.currency_rt * -1 ri_wholding_vat ,
                      2 CONSTANT --Vincent 10062006: added currency_rt
                   FROM GIRI_BINDER A,
                   GIIS_REINSURER b,
                   GIIS_LINE c,
                   GIPI_POLBASIC d,
                   GIIS_ASSURED e,
                   GIRI_FRPS_RI f,
                   GIRI_DISTFRPS g,
                   GIUW_POLICYDS h,
                    GIUW_POL_DIST i,
                   GIPI_PARLIST j
                  WHERE  A.ri_cd = NVL( p_ri_cd, A.ri_cd )
                        AND A.line_cd = NVL( p_line_cd, A.line_cd )
                        AND DECODE(p_date_type,'1', TRUNC(A.eff_date),
                                                                    '2', TRUNC(A.binder_date),
                                                                    '3', TRUNC(A.acc_ent_date),
                                                                    '4',LAST_DAY (TO_DATE (d.booking_mth || ',' || TO_CHAR (d.booking_year),'FMMONTH,YYYY'))) BETWEEN  p_date_from  AND p_date_to
                   --     AND DECODE(p_replaced_flag,'Y', TRUNC(a.acc_rev_date)) BETWEEN  p_date_from  AND p_date_to
                         AND A.replaced_flag =UPPER('Y')
                         AND A.ri_cd = b.ri_cd
                         AND A.line_cd = c.line_cd
                         AND A.fnl_binder_id = f.fnl_binder_id
                         AND f.frps_yy = g.frps_yy
                         AND f.frps_seq_no = g.frps_seq_no
                         AND f.line_cd = g.line_cd
                         AND g.dist_no = h.dist_no
                         AND g.dist_seq_no = h.dist_seq_no
                         AND h.dist_no = i.dist_no
                         AND i.par_id = j.par_id
                         AND j.assd_no = e.assd_no
                         AND i.policy_id = d.policy_id
                         AND d.pol_flag <>'5'
                        --AND  i.dist_flag NOT IN('4','5') --Vincent 10062006: comment out
                        AND (p_date_type = '4' AND A.reverse_date IS NULL OR p_date_type <> '4')
                        --Vincent 10062006: added the ff condition
                        AND ((p_date_type = '3' AND (TRUNC (i.acct_ent_date) BETWEEN p_date_from AND p_date_to
                                                                         OR NVL (TRUNC (i.acct_neg_date), p_date_to + 1) BETWEEN p_date_from AND p_date_to))
                                  OR p_date_type <> '3')
                  UNION
                  --Vincent 10062006: added the ff select stmnt to include reversed binders
                  SELECT  b.ri_name, c.line_name,
                   A.eff_date eff_date,
                   A.line_cd || '-' || A.binder_yy || '-' || A.binder_seq_no binder,
                   DECODE (d.endt_seq_no,0,(d.line_cd ||'-'|| d.subline_cd ||'-'|| d.iss_cd ||'-'|| d.issue_yy    ||'-'||d.pol_seq_no ||'-'|| d.renew_no),
                    (d.line_cd ||'-'|| d.subline_cd ||'-'|| d.iss_cd ||'-'|| d.issue_yy ||'-'|| d.pol_seq_no ||'-'||    d.renew_no ||'-'|| d.endt_iss_cd ||'-'|| d.endt_yy ||'-'|| d.endt_seq_no)) policy_no,                 d.policy_id,
                   e.assd_name assured,
                   A.ri_tsi_amt * g.currency_rt * -1 amt_insured,
                   A.ri_prem_amt * g.currency_rt * -1 prem,
                   A.ri_comm_amt * g.currency_rt * -1 comm,
                   ( (A.ri_prem_amt+NVL(a.ri_prem_vat,0)) - (A.ri_comm_amt+NVL(a.ri_comm_vat,0))) * g.currency_rt * -1 net_prem,
                   A.fnl_binder_id binder_id,
                                  A.replaced_flag,
                                  A.ri_prem_vat * g.currency_rt * -1 ri_prem_vat,
                                  A.ri_comm_vat * g.currency_rt * -1 ri_comm_vat,
                                  A.ri_wholding_vat * g.currency_rt * -1 ri_wholding_vat,
                      3 CONSTANT
                      FROM GIRI_BINDER A,
                   GIIS_REINSURER b,
                   GIIS_LINE c,
                   GIPI_POLBASIC d,
                   GIIS_ASSURED e,
                   GIRI_FRPS_RI f,
                   GIRI_DISTFRPS g,
                   GIUW_POLICYDS h,
                    GIUW_POL_DIST i,
                   GIPI_PARLIST j
                  WHERE  A.ri_cd = NVL( p_ri_cd, A.ri_cd )
                        AND A.line_cd = NVL( p_line_cd, A.line_cd )
                         AND A.ri_cd = b.ri_cd
                         AND A.line_cd = c.line_cd
                         AND A.fnl_binder_id = f.fnl_binder_id
                         AND f.frps_yy = g.frps_yy
                         AND f.frps_seq_no = g.frps_seq_no
                         AND f.line_cd = g.line_cd
                         AND g.dist_no = h.dist_no
                         AND g.dist_seq_no = h.dist_seq_no
                         AND h.dist_no = i.dist_no
                         AND i.par_id = j.par_id
                         AND j.assd_no = e.assd_no
                         AND i.policy_id = d.policy_id
                         AND d.pol_flag <>'5'
                         AND TRUNC(A.acc_rev_date) BETWEEN  p_date_from  AND p_date_to
                         AND (TRUNC (i.acct_ent_date) BETWEEN p_date_from AND p_date_to
                                   OR
                                   NVL (TRUNC (i.acct_neg_date), p_date_to + 1) BETWEEN p_date_from AND p_date_to)
                        AND p_date_type = '3'
                     AND (a.replaced_flag =UPPER('N') OR a.replaced_flag IS NULL) --edited by april 071510*/
         )
      LOOP
         /*  the codes below were modified by aaron aug 6, 2008
         **  to synchronize values with GIACR106. Instead of using UNION for the select
         **  statements, individual for loops were used.
         */
         v_ref_date := NULL;
         v_ref_no := NULL;
         v_disb := 0;
         v_orsl.bal_amt := 0;
         v_net_prem := 0;
         v_if_xxxx := 'N';

         FOR c2 IN (SELECT b.or_date ref_date,
                           b.or_pref_suf || ' ' || TO_CHAR (or_no) ref_no,
                           a.gacc_tran_id g_tran_id,
                           a.disbursement_amt disb_amt, d.tran_class t_class,
                           a.d010_fnl_binder_id binder_id, '1' dummy
                      FROM giac_outfacul_prem_payts a,
                           giac_order_of_payts b,
                           giac_acctrans d
                     WHERE d.tran_flag <> 'D'
                       AND a.gacc_tran_id = b.gacc_tran_id
                       AND a.gacc_tran_id = d.tran_id
                       AND d.tran_class = 'COL'
                       AND NOT EXISTS (
                              SELECT x.gacc_tran_id
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.reversing_tran_id = y.tran_id
                                 AND y.tran_flag <> 'D'
                                 AND x.gacc_tran_id = d.tran_id)
                       AND a.d010_fnl_binder_id = c1.binder_id)
         LOOP
            IF c1.CONSTANT = 1
            THEN
               v_ref_date := v_ref_date || ' ' || c2.ref_date;
               v_ref_no := v_ref_no || ' ' || c2.ref_no;
               v_disb := v_disb + c2.disb_amt;
            ELSE                                                       --[Deo] 12.20.2013
               v_ref_date := v_ref_date || ' ' || c2.ref_date;
               v_ref_no := v_ref_no || ' ' || c2.ref_no;
               v_disb:= v_disb + c2.disb_amt * -1;
            END IF;                                                    --APRIL
         END LOOP;                                                        --c2

         --UNION
         FOR d3 IN (SELECT c.dv_date ref_date,
                           c.dv_pref || ' ' || TO_CHAR (c.dv_no) ref_no,
                           a.gacc_tran_id g_tran_id,
                           a.disbursement_amt disb_amt, d.tran_class t_class,
                           a.d010_fnl_binder_id binder_id, '2' dummy
                      FROM giac_outfacul_prem_payts a,
                           giac_disb_vouchers c,
                           giac_acctrans d
                     WHERE d.tran_flag <> 'D'
                       AND a.gacc_tran_id = c.gacc_tran_id
                       AND a.gacc_tran_id = d.tran_id
                       AND d.tran_class = 'DV'
                       AND NOT EXISTS (
                              SELECT x.gacc_tran_id
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.reversing_tran_id = y.tran_id
                                 AND y.tran_flag <> 'D'
                                 AND x.gacc_tran_id = d.tran_id)
                       AND a.d010_fnl_binder_id = c1.binder_id)
         LOOP
            IF c1.CONSTANT = 1
            THEN
               v_ref_date := v_ref_date || ' ' || d3.ref_date;
               v_ref_no := v_ref_no || ' ' || d3.ref_no;
               v_disb := v_disb + d3.disb_amt;
            ELSE                                                       --[Deo] 12.20.2013
               v_ref_date := v_ref_date || ' ' || d3.ref_date;
               v_ref_no := v_ref_no || ' ' || d3.ref_no;
               v_disb := v_disb + d3.disb_amt * -1;
            END IF;                                                    --APRIL
         END LOOP;

         --UNION
         FOR d4 IN (SELECT d.tran_date ref_date,
                              d.tran_class
                           || ' '
                           || TO_CHAR (d.tran_class_no) ref_no,
                           a.gacc_tran_id g_tran_id,
                           a.disbursement_amt disb_amt, d.tran_class t_class,
                           a.d010_fnl_binder_id binder_id, '3' dummy
                      FROM giac_outfacul_prem_payts a, giac_acctrans d
                     WHERE d.tran_flag <> 'D'
                       AND a.gacc_tran_id = d.tran_id
                       AND d.tran_class = 'JV'
                       AND NOT EXISTS (
                              SELECT x.gacc_tran_id
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.reversing_tran_id = y.tran_id
                                 AND y.tran_flag <> 'D'
                                 AND x.gacc_tran_id = d.tran_id)
                       AND a.d010_fnl_binder_id = c1.binder_id)
         LOOP
            IF c1.CONSTANT = 1
            THEN
               v_ref_date := v_ref_date || ' ' || d4.ref_date;
               v_ref_no := v_ref_no || ' ' || d4.ref_no;
               v_disb := v_disb + d4.disb_amt;
            ELSE                                                       --[Deo] 12.20.2013         
               v_ref_date := v_ref_date || ' ' || d4.ref_date;
               v_ref_no := v_ref_no || ' ' || d4.ref_no;
               v_disb := v_disb + d4.disb_amt * -1;
            END IF;                                                    --APRIL
         END LOOP;

         --UNION
           -- FOR d5 in (SELECT SYSDATE ref_date, ' ' ref_no, 0 g_tran_id, 0 disb_amt, ' ' t_class,
           --     0 binder_id,'4' dummy
           --FROM DUAL
         --UNION
         FOR d5 IN (SELECT e.request_date ref_date,
                           e.document_cd || '-' || e.doc_seq_no ref_no,
                           a.gacc_tran_id g_tran_id,
                           a.disbursement_amt disb_amt, d.tran_class t_class,
                           a.d010_fnl_binder_id binder_id, '5' dummy
                      FROM giac_outfacul_prem_payts a,
                           giac_payt_requests e,
                           giac_payt_requests_dtl s,
                           giac_acctrans d
                     WHERE d.tran_flag <> 'D'
                       AND e.ref_id = s.gprq_ref_id
                       AND e.with_dv = 'N'
                       AND a.gacc_tran_id = d.tran_id
                       AND d.tran_class = 'DV'
                       AND d.tran_id = s.tran_id
                       AND NOT EXISTS (
                              SELECT x.gacc_tran_id
                                FROM giac_reversals x, giac_acctrans y
                               WHERE x.reversing_tran_id = y.tran_id
                                 AND y.tran_flag <> 'D'
                                 AND x.gacc_tran_id = d.tran_id)
                       AND a.d010_fnl_binder_id = c1.binder_id)
         LOOP
            IF c1.CONSTANT = 1
            THEN
               v_ref_date := v_ref_date || ' ' || d5.ref_date;
               v_ref_no := v_ref_no || ' ' || d5.ref_no;
               v_disb := v_disb + d5.disb_amt;
            ELSE                                                       --[Deo] 12.20.2013
               v_ref_date := v_ref_date || ' ' || d5.ref_date;
               v_ref_no := v_ref_no || ' ' || d5.ref_no;
               v_disb := v_disb + d5.disb_amt * -1;
            END IF;                                                    --APRIL
         END LOOP;

         ---UNION
         --this part is used to select the balance due for binders with still no payments made
         --without this part, balances cannot be displayed for records with no payments
         --ref_no = XXXX is used to distinguish the records from this select to the records above
         --terrence 11/07/2002
         FOR d6 IN
            (SELECT TO_DATE ('01-JAN-01','DD-MON-YY'), 'XXXX', 9999, --added format mask by albert 10.09.2015 (SR 20594)
                      ((  (NVL (a.ri_prem_amt, 0) + NVL (a.ri_prem_vat, 0))
                        - (  NVL (a.ri_comm_amt, 0)
                           + NVL (a.ri_comm_vat, 0)
                           + NVL (a.ri_wholding_vat, 0)
                          )
                       )
                      )
                    * g.currency_rt,
                    
                    --modified by ging011006 (changed the formula for net prem)
                    NULL, a.fnl_binder_id binder_id, '6' dummy
               FROM giri_binder a, giri_frps_ri f, giri_distfrps g
              WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                AND DECODE (p_date_type,
                            '1', TRUNC (a.eff_date),
                            '2', TRUNC (a.binder_date),
                            '3', TRUNC (a.acc_ent_date)
                           ) BETWEEN p_date_from AND p_date_to
                AND a.fnl_binder_id = f.fnl_binder_id
                AND f.frps_yy = g.frps_yy
                AND f.frps_seq_no = g.frps_seq_no
                AND f.line_cd = g.line_cd
                AND NOT EXISTS (
                       SELECT e.d010_fnl_binder_id binder_id
                         FROM giac_outfacul_prem_payts e, giac_acctrans d
                        WHERE d.tran_flag <> 'D'
                          AND a.fnl_binder_id = e.d010_fnl_binder_id
                          AND e.gacc_tran_id = d.tran_id
                          AND NOT EXISTS (
                                 SELECT x.gacc_tran_id
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag <> 'D'
                                    AND x.gacc_tran_id = d.tran_id))
                AND a.fnl_binder_id = c1.binder_id)
         LOOP
            IF c1.CONSTANT = 1
            THEN
               v_ref_date := NULL;
               v_ref_no := NULL;
               v_disb := NULL;
               v_if_xxxx := 'Y';
            END IF;                                                    --APRIL
         END LOOP;

         --UNION
         --Vincent 10062006: added the ff select stmnt to include reversed binders
         FOR d10 IN
            (SELECT TO_DATE ('01-JAN-01', 'DD-MON-YY'), 'XXXX', 9999, --added format mask by albert 10.09.2015 (SR 20594)
                      ((  (NVL (a.ri_prem_amt, 0) + NVL (a.ri_prem_vat, 0))
                        - (  NVL (a.ri_comm_amt, 0)
                           + NVL (a.ri_comm_vat, 0)
                           + NVL (a.ri_wholding_vat, 0)
                          )
                       )
                      )
                    * g.currency_rt
                    * -1,
                    NULL, a.fnl_binder_id binder_id, '6' dummy
               FROM giri_binder a, giri_frps_ri f, giri_distfrps g
              WHERE a.ri_cd = NVL (p_ri_cd, a.ri_cd)
                AND a.line_cd = NVL (p_line_cd, a.line_cd)
                AND p_date_type = '3'
                AND TRUNC (a.acc_rev_date) BETWEEN p_date_from AND p_date_to
                AND a.fnl_binder_id = f.fnl_binder_id
                AND f.frps_yy = g.frps_yy
                AND f.frps_seq_no = g.frps_seq_no
                AND f.line_cd = g.line_cd
                AND NOT EXISTS (
                       SELECT e.d010_fnl_binder_id binder_id
                         FROM giac_outfacul_prem_payts e, giac_acctrans d
                        WHERE d.tran_flag <> 'D'
                          AND a.fnl_binder_id = e.d010_fnl_binder_id
                          AND e.gacc_tran_id = d.tran_id
                          AND NOT EXISTS (
                                 SELECT x.gacc_tran_id
                                   FROM giac_reversals x, giac_acctrans y
                                  WHERE x.reversing_tran_id = y.tran_id
                                    AND y.tran_flag <> 'D'
                                    AND x.gacc_tran_id = d.tran_id))
                AND a.fnl_binder_id = c1.binder_id)
         LOOP
            IF c1.CONSTANT = 1
            THEN
               v_ref_date := NULL;
               v_ref_no := NULL;
               v_disb := NULL;
               v_if_xxxx := 'Y';
            END IF;                                                    --APRIL
         END LOOP;

         -- IF NVL(c2.ref_no,'O') <> 'XXXX' THEN
         v_orsl.ri_name := c1.ri_name;
         v_orsl.line_name := c1.line_name;
         v_orsl.eff_date := c1.eff_date;
         v_orsl.ppw := c1.ppw;                             --Jayson 11.14.2011
         v_orsl.binder := c1.binder;
         v_orsl.policy_no := c1.policy_no;
         v_orsl.assured := c1.assured;

         --v_orsl.intm := c2.intm;
         FOR c3 IN (SELECT intrmdry_intm_no
                      FROM gipi_comm_invoice b
                     WHERE b.policy_id = c1.policy_id)
         LOOP
            v_orsl.intm := c3.intrmdry_intm_no;
         END LOOP;

         v_orsl.amt_insured := c1.amt_insured;
         v_orsl.prem := c1.prem;
         v_orsl.ri_prem_vat := c1.ri_prem_vat;
         v_orsl.comm := c1.comm;
         v_orsl.ri_comm_vat := c1.ri_comm_vat;
         v_orsl.ri_wholding_vat := c1.ri_wholding_vat;
         v_net_prem :=
              (NVL (c1.prem, 0) + NVL (c1.ri_prem_vat, 0))
            - ((  NVL (c1.comm, 0)
                + NVL (c1.ri_comm_vat, 0)
                + NVL (c1.ri_wholding_vat, 0)
               )
              );                                              --alfie 06052009
         v_orsl.net_prem := v_net_prem;
         v_orsl.ref_date := v_ref_date;                         --c2.ref_date;
         v_orsl.ref_no := v_ref_no;                               --c2.ref_no;
         v_orsl.disb_amt := NVL (v_disb, 0);                    --c2.disb_amt;

         IF v_if_xxxx = 'Y' AND c1.replaced_flag = 'Y'
         THEN
            v_orsl.bal_amt := NVL (v_net_prem, 0);
         ELSIF v_if_xxxx = 'Y' AND c1.replaced_flag IS NULL
         THEN
            v_orsl.bal_amt := NVL (v_net_prem, 0);
         ELSIF v_if_xxxx = 'Y' AND c1.replaced_flag = 'N'
         THEN
            v_orsl.bal_amt := NVL (v_net_prem, 0);
         ELSIF v_if_xxxx = 'N'
         THEN
            v_orsl.bal_amt := NVL (v_net_prem, 0) - NVL (v_disb, 0);
         END IF;                                                    --:) alfie

         PIPE ROW (v_orsl);
       --END IF;
       --END IF;-- a if
      -- END LOOP;
      END LOOP;

      RETURN;
   END;
   
   
   -- jhing GENQA 5270, redesigned function for the CSV output of GIACR106
   FUNCTION outrisubsledger (
      p_date_from   DATE,
      p_date_to     DATE,
      p_ri_cd       NUMBER,
      p_line_cd     VARCHAR2,
      p_date_type   VARCHAR2,
      p_module_id   VARCHAR2, --mikel 11.23.2015; UCPBGEN 20878
      p_user_id     VARCHAR2 --mikel 11.23.2015; UCPBGEN 20878
   )
      RETURN orsl_type_v2 PIPELINED
   IS
      v_orsl             orsl_rec_type_v2;
      v_tran_class       giac_acctrans.tran_class%TYPE;
      v_withpay          VARCHAR2 (1);
      v_ref_date DATE;
      v_ref_no           VARCHAR2 (100);
      v_disb             NUMBER;
      v_net_prem         NUMBER;
      v_if_xxxx          VARCHAR2 (1)                    := 'N';
      v_the_ri           VARCHAR2 (1000)                 := 'A';
      v_the_current_ri   VARCHAR2 (1000)                 := 'B';
      v_the_total_bal    NUMBER                          := 0;
      v_currBndr         VARCHAR2 (20)   := NULL; 
      v_cntRecPayt       NUMBER ;
      v_total_paid_amt   NUMBER (20,2); 
   BEGIN
      FOR c1 IN 
      -- jhing 01.08.2015 added outer query to be able to sort records ( taken up , reversal next ) 
      ( SELECT * FROM 
         (SELECT k.ri_name,
               i.line_name,
               c.eff_date,
               get_binder_no (b.fnl_binder_id) binder,
               get_policy_no (g.policy_id) policy_no,
               g.policy_id,
               m.assd_name assured,
               ROUND(NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0),2) amt_insured,
               ROUND(NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0),2) prem,
               ROUND(NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0),2) comm,
                 (  (NVL (c.ri_prem_amt, 0) + NVL (c.ri_prem_vat, 0))
                  - (NVL (c.ri_comm_amt, 0) + NVL (c.ri_comm_vat, 0)))
               * NVL (d.currency_rt, 0)
                  net_prem,
               c.fnl_binder_id binder_id,
               c.replaced_flag,
               ROUND(NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0),2) ri_prem_vat,
               ROUND(NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0),2)  ri_comm_vat,
               ROUND(NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0),2) ri_wholding_vat,
               1 constant,
               b.frps_yy,
               b.frps_seq_no,
               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
          FROM giri_frps_ri b,
               giri_binder c,
               giri_distfrps d,
               giuw_policyds e,
               giuw_pol_dist f,
               gipi_polbasic g,
               giis_line i,
               giis_subline j,
               giis_reinsurer k,
               gipi_parlist l,
               giis_assured m
         WHERE     1 = 1
               AND c.ri_cd = NVL (p_ri_cd, c.ri_cd)         -- added by robert 01.05.2016
               AND c.line_cd = NVL(p_line_cd, c.line_cd)    -- added by robert 01.05.2016
               AND c.ri_cd = k.ri_cd
               AND b.fnl_binder_id = c.fnl_binder_id
               AND b.line_cd = d.line_cd
               AND b.frps_yy = d.frps_yy
               AND b.frps_seq_no = d.frps_seq_no
               AND d.dist_no = e.dist_no
               AND d.dist_seq_no = e.dist_seq_no
               AND e.dist_no = f.dist_no
               AND f.policy_id = g.policy_id
               AND f.par_id = l.par_id
               AND l.assd_no = m.assd_no
               AND ((p_date_type = '3'
                   AND g.acct_ent_date IS NOT NULL
                   AND LAST_DAY (g.acct_ent_date) <= LAST_DAY (p_date_to)
                   AND LAST_DAY (TRUNC (f.acct_ent_date)) <= LAST_DAY (p_date_to))
                   OR p_date_type != '3'
                   )
               AND DECODE (p_date_type,
                         '1', TRUNC (c.eff_date),
                         '2', TRUNC (c.binder_date),
                         '3', TRUNC (c.acc_ent_date),
                         '4', LAST_DAY (TO_DATE (   g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to
               AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                            WHERE branch_cd = g.iss_cd)                                        
               AND g.line_cd = i.line_cd
               AND g.line_cd = j.line_cd
               AND g.subline_cd = j.subline_cd
               AND g.reg_policy_sw = 'Y'
               -- jhing 01.08.2016  include condition to retrieve valid binders only ( if parameter is not accounting entry date to prevent duplicate display of reused binder)
               AND (DECODE (p_date_type, 3, 1, 0) = 1 OR f.dist_flag = '3')
               AND (   DECODE (p_date_type, 3, 1, 0) = 1
                     OR (NVL (b.reverse_sw, 'N') = 'N'
                     AND c.reverse_date IS NULL
                     AND d.ri_flag = '2' ) )
               -- jhing 01.08.2016 added condition to prevent duplicate display of reused binders 
               AND (  p_date_type != '3'
                    OR  (NVL ( (  SELECT COUNT (1)
                                    FROM giri_frps_ri tg
                                   WHERE tg.fnl_binder_id = c.fnl_binder_id
                                GROUP BY tg.fnl_binder_id),
                              0) < 2)    
                    OR ( (TRUNC (NVL (c.acc_ent_date, p_date_to + 60)) BETWEEN p_date_from
                                                                                               AND p_date_to)
                                         AND f.dist_no IN
                                                (SELECT MIN (tc.dist_no)
                                                   FROM giri_distfrps tc, giri_frps_ri td, giuw_pol_dist tf
                                                  WHERE     tc.line_cd = td.line_cd
                                                        AND tc.frps_yy = td.frps_yy
                                                        AND tc.frps_seq_no = td.frps_seq_no
                                                        AND td.fnl_binder_id = c.fnl_binder_id
                                                        AND tc.dist_no = tf.dist_no
                                                        AND LAST_DAY (TRUNC (tf.acct_ent_date)) <= LAST_DAY (p_date_to)
                                                        )
                                         AND (NVL (
                                                 (  SELECT COUNT (1)
                                                      FROM giri_frps_ri tg
                                                     WHERE tg.fnl_binder_id = c.fnl_binder_id
                                                  GROUP BY tg.fnl_binder_id),
                                                 0) > 1))                       
               )     
        UNION
        SELECT k.ri_name,
               i.line_name,
               c.eff_date,
               get_binder_no (b.fnl_binder_id) binder,
               get_policy_no (g.policy_id) policy_no,
               g.policy_id,
               m.assd_name assured,
              ROUND( NVL (c.ri_tsi_amt, 0) * NVL (d.currency_rt, 0),2) * -1 amt_insured,
              ROUND( NVL (c.ri_prem_amt, 0) * NVL (d.currency_rt, 0),2)  * -1 prem,
              ROUND( NVL (c.ri_comm_amt, 0) * NVL (d.currency_rt, 0) ,2 ) * -1 comm,
                 (  (NVL (c.ri_prem_amt, 0) + NVL (c.ri_prem_vat, 0))
                  - (NVL (c.ri_comm_amt, 0) + NVL (c.ri_comm_vat, 0)))
               * NVL (d.currency_rt, 0)
               * -1
                  net_prem,
               c.fnl_binder_id binder_id,
               c.replaced_flag,
               ROUND(NVL (c.ri_prem_vat, 0) * NVL (d.currency_rt, 0) ,2 ) * -1 ri_prem_vat,
               ROUND( NVL (c.ri_comm_vat, 0) * NVL (d.currency_rt, 0), 2 )  * -1 ri_comm_vat,
               ROUND(NVL (c.ri_wholding_vat, 0) * NVL (d.currency_rt, 0),2) * -1
                  ri_wholding_vat,
               2 constant,
               b.frps_yy,
               b.frps_seq_no,
               TRUNC (c.eff_date) + NVL (b.prem_warr_days, 0) ppw
          FROM giri_frps_ri b,
               giri_binder c,
               giri_distfrps d,
               giuw_policyds e,
               giuw_pol_dist f,
               gipi_polbasic g,
               giis_line i,
               giis_subline j,
               giis_reinsurer k,
               gipi_parlist l,
               giis_assured m
         WHERE     1 = 1
               AND c.ri_cd = NVL (p_ri_cd, c.ri_cd)         -- added by robert 01.05.2016
               AND c.line_cd = NVL(p_line_cd, c.line_cd)    -- added by robert 01.05.2016
               AND c.ri_cd = k.ri_cd
               AND b.fnl_binder_id = c.fnl_binder_id
               AND b.line_cd = d.line_cd
               AND b.frps_yy = d.frps_yy
               AND b.frps_seq_no = d.frps_seq_no
               AND d.dist_no = e.dist_no
               AND d.dist_seq_no = e.dist_seq_no
               AND e.dist_no = f.dist_no
               AND f.policy_id = g.policy_id
               AND f.par_id = l.par_id
               AND l.assd_no = m.assd_no               
               AND p_date_type = '3' -- jhing 11.08.2015 added condition to prevent retrieval of records in this query if the parameter is not based on accounting entry date
               AND ((p_date_type = '3'
               AND g.acct_ent_date IS NOT NULL
               AND LAST_DAY (g.acct_ent_date) <= LAST_DAY (p_date_to)
               AND (   (    f.dist_flag = '4'
                        AND LAST_DAY (TRUNC (f.acct_neg_date)) <=
                               LAST_DAY (p_date_to))           --negated distribution
                    OR (b.reverse_sw = 'Y')                          --reversed binder
                    OR f.dist_flag = '5'                               --redistributed
                                        ))
                    OR p_date_type != '3'
                   )
               AND DECODE (p_date_type,
                         '1', TRUNC (c.eff_date),
                         '2', TRUNC (c.binder_date),
                         '3', TRUNC (c.acc_rev_date),
                         '4', LAST_DAY (TO_DATE (   g.booking_mth
                                                 || ','
                                                 || TO_CHAR (g.booking_year),
                                                 'FMMONTH,YYYY'
                                                )
                                       )
                        ) BETWEEN p_date_from AND p_date_to 
               AND EXISTS (SELECT 'X'
                             FROM TABLE (security_access.get_branch_line ('AC', p_module_id, p_user_id))
                            WHERE branch_cd = g.iss_cd)                                           
               AND g.line_cd = i.line_cd
               AND g.line_cd = j.line_cd
               AND g.subline_cd = j.subline_cd
               AND g.reg_policy_sw = 'Y'
               -- jhing 01.08.2016 added condition to prevent duplicate display of reused binders 
               AND (  p_date_type != '3'
                    OR  (NVL ( (  SELECT COUNT (1)
                                    FROM giri_frps_ri tg
                                   WHERE tg.fnl_binder_id = c.fnl_binder_id
                                GROUP BY tg.fnl_binder_id),
                              0) < 2)    
                    OR ( (TRUNC (NVL (c.acc_rev_date, p_date_to + 60)) BETWEEN p_date_from
                                                                                               AND p_date_to)
                                         AND f.dist_no IN
                                                (SELECT MAX (tc.dist_no)
                                                   FROM giri_distfrps tc, giri_frps_ri td, giuw_pol_dist tf
                                                  WHERE     tc.line_cd = td.line_cd
                                                        AND tc.frps_yy = td.frps_yy
                                                        AND tc.frps_seq_no = td.frps_seq_no
                                                        AND td.fnl_binder_id = c.fnl_binder_id
                                                        AND tc.dist_no = tf.dist_no
                                                        AND LAST_DAY (TRUNC (tf.acct_ent_date)) <= LAST_DAY (p_date_to))
                                         AND (NVL (
                                                 (  SELECT COUNT (1)
                                                      FROM giri_frps_ri tg
                                                     WHERE tg.fnl_binder_id = c.fnl_binder_id
                                                  GROUP BY tg.fnl_binder_id),
                                                 0) > 1))                       
               )                  
         ) ta001 ORDER BY ta001.ri_name, ta001.binder, ta001.constant ) 
      LOOP
         /*  the codes below were modified by aaron aug 6, 2008
         **  to synchronize values with GIACR106. Instead of using UNION for the select
         **  statements, individual for loops were used.
         */
         v_ref_date := NULL;
         v_ref_no := NULL;
         v_disb := 0;
         v_orsl.bal_amt := 0;
         v_net_prem := 0;
         v_if_xxxx := 'N';
         v_total_paid_amt := 0 ;
         v_the_total_bal := 0 ; 
         
         v_orsl.intm := NULL ; 
         FOR c3 IN (SELECT intrmdry_intm_no
                      FROM gipi_comm_invoice b
                     WHERE b.policy_id = c1.policy_id)
         LOOP
            v_orsl.intm := c3.intrmdry_intm_no;
         END LOOP;
         
         v_orsl.ri_name := c1.ri_name;
         v_orsl.line_name := c1.line_name;
         v_orsl.eff_date := c1.eff_date;
         v_orsl.ppw := c1.ppw;                             
         v_orsl.binder := c1.binder;
         v_orsl.policy_no := c1.policy_no;
         v_orsl.assured := c1.assured;
         
         
         
         v_orsl.amt_insured := c1.amt_insured;
         v_orsl.prem := c1.prem;
         v_orsl.ri_prem_vat := c1.ri_prem_vat;
         v_orsl.comm := c1.comm;
         v_orsl.ri_comm_vat := c1.ri_comm_vat;
         v_orsl.ri_wholding_vat := c1.ri_wholding_vat;
         v_net_prem :=
              (NVL (c1.prem, 0) + NVL (c1.ri_prem_vat, 0))
            - ((  NVL (c1.comm, 0)
                + NVL (c1.ri_comm_vat, 0)
                + NVL (c1.ri_wholding_vat, 0)
               )
              );                                              
         v_orsl.net_prem := v_net_prem;  
         v_orsl.bal_amt :=  v_net_prem ; 
         v_orsl.disb_amt := 0; 
         v_orsl.ref_date := NULL;                       
         v_orsl.ref_no := NULL;          
         
         
         FOR payt IN (SELECT SUM(NVL(a.disbursement_amt,0)) disb_amt
                          FROM giac_outfacul_prem_payts a, giac_acctrans d
                         WHERE     d.tran_flag <> 'D'
                               AND a.gacc_tran_id = d.tran_id
                               AND NOT EXISTS
                                          (SELECT x.gacc_tran_id
                                             FROM giac_reversals x, giac_acctrans y
                                            WHERE     x.reversing_tran_id = y.tran_id
                                                  AND y.tran_flag <> 'D'
                                                  AND x.gacc_tran_id = d.tran_id)
                               AND a.d010_fnl_binder_id = c1.binder_id)
         LOOP
         
            v_total_paid_amt := payt.disb_amt; 
            v_the_total_bal  := NVL(v_net_prem,0) - v_total_paid_amt ;
            
         END LOOP; 
         
         v_cntRecPayt := 0 ;
         IF c1.constant = 1 THEN   -- only retrieve payments for taken up policies and not for reversal/negation
             FOR cur2 IN (SELECT d.tran_id, NVL (a.disbursement_amt, 0) disb_amt
                         FROM giac_outfacul_prem_payts a, giac_acctrans d
                        WHERE     d.tran_flag <> 'D'
                              AND a.gacc_tran_id = d.tran_id
                              AND a.d010_fnl_binder_id = c1.binder_id
                              AND NOT EXISTS
                                         (SELECT x.gacc_tran_id
                                            FROM giac_reversals x,
                                                 giac_acctrans y
                                           WHERE     x.reversing_tran_id =
                                                        y.tran_id
                                                 AND y.tran_flag <> 'D'
                                                 AND x.gacc_tran_id = d.tran_id)
                                          ORDER BY  d.tran_date, d.tran_id    )
             LOOP
             
                       v_orsl.ref_date := get_ref_date(cur2.tran_id);                       
                       v_orsl.ref_no := get_ref_no(cur2.tran_id);                           
                       v_orsl.disb_amt := cur2.disb_amt; 
                       v_orsl.bal_amt := v_the_total_bal ;  

                       IF v_cntRecPayt > 0 THEN
                         v_orsl.amt_insured := 0;
                         v_orsl.prem := 0;
                         v_orsl.ri_prem_vat := 0 ;
                         v_orsl.comm := 0 ;
                         v_orsl.ri_comm_vat := 0 ;
                         v_orsl.ri_wholding_vat := 0 ;                   
                         v_orsl.net_prem := 0 ;    
                         v_orsl.bal_amt := 0 ;                                        
                       END IF;
                        
                       PIPE ROW (v_orsl);
                       v_cntRecPayt := v_cntRecPayt + 1 ; 
             END LOOP; 
         END IF;
         
         -- for records with no payments
         IF v_cntRecPayt = 0 THEN
             PIPE ROW (v_orsl);
         
         END IF; 
         
      END LOOP;

      RETURN;         
   END;   


   FUNCTION officialreceiptsregister_ap (
      p_date        DATE,
      p_date2       DATE,
      p_branch_cd   VARCHAR2,
      p_tran_flag   NUMBER,
      p_user_id     VARCHAR2
   )
      RETURN orr_type PIPELINED
   IS
      v_orr      orr_rec_type;
      v_payor    giac_order_of_payts.payor%TYPE;
      v_amount   giac_collection_dtl.amount%TYPE;
   BEGIN
      FOR c1 IN (SELECT   f.branch_cd || ' - ' || f.branch_name "BRANCH",
                          a.or_pref_suf, a.or_no, a.or_flag, a.particulars,
                          a.last_update,
                          a.or_pref_suf || '-'
                          || LPAD (a.or_no, 9, '0') or_no1,
                          a.or_date or_date, a.cancel_date cancel_date,
                          TO_CHAR (a.dcb_no) dcb_no,
                          TO_CHAR (a.cancel_dcb_no) cancel_dcb_no,
                          b.tran_date tran_date, b.posting_date posting_date,
                          DECODE (a.or_flag,
                                  'C', 'CANCELLED',
                                  'R', 'REPLACED',
                                  a.payor
                                 ) payor,
                          SUM (c.amount) "AMOUNT", d.short_name "CURRENCY",
                          SUM (DECODE (c.currency_cd,
                                       1, NULL,
                                       c.fcurrency_amt
                                      )
                              ) foreign_currency,
                          DECODE (g.or_type, NULL, 'Z', g.or_type) or_type
                     FROM giac_order_of_payts a,
                          giac_acctrans b,
                          giac_collection_dtl c,
                          giis_currency d,
                          giac_branches f,
                          giac_or_pref g
                    WHERE a.gacc_tran_id = b.tran_id
                      AND a.gibr_gfun_fund_cd = b.gfun_fund_cd
                      AND a.gibr_branch_cd = b.gibr_branch_cd
                      AND b.tran_id = c.gacc_tran_id
                      AND b.gibr_branch_cd = f.branch_cd
                      AND a.gibr_branch_cd = f.branch_cd
                      AND b.gfun_fund_cd = f.gfun_fund_cd
                      AND a.gibr_gfun_fund_cd = f.gfun_fund_cd
                      AND c.currency_cd = d.main_currency_cd
                      AND a.gibr_branch_cd = g.branch_cd(+)
                      AND a.or_pref_suf = g.or_pref_suf(+)
                      AND TRUNC (a.or_date) BETWEEN p_date AND p_date2
                      AND ((SELECT access_tag  --john 10.9.2014 for checking user access (check_user_per_iss_cd_acctg2)
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS160'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = a.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS160'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = a.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                   )
                      AND f.branch_cd =
                             DECODE (p_branch_cd,
                                     NULL, f.branch_cd,
                                     p_branch_cd
                                    )
                      AND (   (1 = p_tran_flag AND tran_flag = 'P')
                           OR (2 = p_tran_flag)
                          )
                      AND or_flag != 'N'
                      AND (   (    (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                           OR (a.cancel_date IS NULL)
                           OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                          )
                      AND (   (a.or_flag NOT IN ('C', 'R'))
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                          )
                 GROUP BY f.branch_cd || ' - ' || f.branch_name,
                          a.or_pref_suf,
                          a.or_no,
                          a.or_flag,
                          a.particulars,
                          a.last_update,
                          a.or_pref_suf || '-' || LPAD (a.or_no, 9, '0'),
                          a.or_date,
                          a.cancel_date,
                          a.dcb_no,
                          a.cancel_dcb_no,
                          b.tran_date,
                          b.posting_date,
                          DECODE (a.or_flag,
                                  'C', 'CANCELLED',
                                  'R', 'REPLACED',
                                  a.payor
                                 ),
                          DECODE (g.or_type, NULL, 'Z', g.or_type),
                          d.short_name
                 UNION
                 SELECT   f.branch_cd || ' - ' || f.branch_name "BRANCH",
                          e.or_pref, e.or_no, '', '', SYSDATE,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0') or_no1,
                          e.or_date or_date, SYSDATE, '      ', '',
                          b.tran_date tran_date, b.posting_date posting_date,
                          'SPOILED' payor, TO_NUMBER (NULL) "AMOUNT",
                          NULL "CURRENCY", TO_NUMBER (NULL) foreign_currency,
                          DECODE (g.or_type, NULL, 'Z', g.or_type) or_type
                     FROM giac_acctrans b,
                          --giac_collection_dtl c, --Commented out by Jerome 11.09.2016 SR 23223
                          --giis_currency d, --Commented out by Jerome 11.09.2016 SR 23223
                          giac_spoiled_or e,
                          giac_branches f,
                          giac_or_pref g
                    WHERE b.tran_id = e.tran_id
                      --AND b.tran_id = c.gacc_tran_id --Commented out by Jerome 11.09.2016 SR 23223
                      AND b.gibr_branch_cd = f.branch_cd
                      --AND c.currency_cd = d.main_currency_cd --Commented out by Jerome 11.09.2016 SR 23223
                      AND e.branch_cd = g.branch_cd(+)
                      AND e.or_pref = g.or_pref_suf(+)
                      AND TRUNC (e.or_date) BETWEEN p_date AND p_date2
                      AND ((SELECT access_tag  --john 10.9.2014 for checking user access (check_user_per_iss_cd_acctg2)
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS160'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = e.branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS160'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = e.branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                   )
                      AND f.branch_cd =
                             DECODE (p_branch_cd,
                                     NULL, f.branch_cd,
                                     p_branch_cd
                                    )
                 GROUP BY f.branch_cd || ' - ' || f.branch_name,
                          e.or_pref,
                          e.or_no,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0'),
                          e.or_date,
                          b.tran_date,
                          b.posting_date,
                          'SPOILED',
                          DECODE (g.or_type, NULL, 'Z', g.or_type)
                 UNION
                 SELECT   f.branch_cd || ' - ' || f.branch_name "BRANCH",
                          e.or_pref, e.or_no, '', '', SYSDATE,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0') or_no1,
                          e.or_date or_date, SYSDATE, '      ', '',
                          TO_DATE (NULL) tran_date,
                          TO_DATE (NULL) posting_date, 'SPOILED' payor,
                          TO_NUMBER (NULL) "AMOUNT", NULL "CURRENCY",
                          TO_NUMBER (NULL) foreign_currency,
                          DECODE (g.or_type, NULL, 'Z', g.or_type) or_type
                     FROM giac_spoiled_or e, giac_branches f, giac_or_pref g
                    WHERE e.fund_cd = f.gfun_fund_cd
                      AND e.branch_cd = f.branch_cd
                      AND e.branch_cd = g.branch_cd(+)
                      AND e.or_pref = g.or_pref_suf(+)
                      AND e.tran_id IS NULL
                      AND ((SELECT access_tag  --john 10.9.2014 for checking user access (check_user_per_iss_cd_acctg2)
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS160'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = e.branch_cd 
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS160'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = e.branch_cd 
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                   )
                      AND DECODE (e.or_date, NULL, e.spoil_date, e.or_date)
                             BETWEEN p_date
                                 AND p_date2
                      AND f.branch_cd =
                             DECODE (p_branch_cd,
                                     NULL, f.branch_cd,
                                     p_branch_cd
                                    )
                 GROUP BY f.branch_cd || ' - ' || f.branch_name,
                          e.or_pref,
                          e.or_no,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0'),
                          e.or_date,
                          'SPOILED',
                          DECODE (g.or_type, NULL, 'Z', g.or_type)
                 ORDER BY 2, 3)
      LOOP
         v_orr.branch := c1.branch;
         v_orr.or_no := c1.or_no1;
         v_orr.or_date := c1.or_date;
         v_orr.tran_date := c1.tran_date;
         v_orr.posting_date := c1.posting_date;
         v_orr.currency := c1.currency;
         v_orr.foreign_currency := c1.foreign_currency;

         IF     c1.cancel_date IS NOT NULL
            AND c1.payor <> 'SPOILED'
            AND c1.payor <> 'REPLACED'
         THEN
            IF TRUNC (c1.cancel_date) <> TRUNC (c1.or_date)
            THEN
               v_payor :=
                     c1.payor
                  || ' ON '
                  || TO_CHAR (c1.cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || c1.cancel_dcb_no;
            ELSIF     TRUNC (c1.cancel_date) = TRUNC (c1.or_date)
                  AND c1.dcb_no <> c1.cancel_dcb_no
            THEN
               v_payor :=
                     c1.payor
                  || ' ON '
                  || TO_CHAR (c1.cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || c1.cancel_dcb_no;
            ELSE
               v_payor := c1.payor;
            END IF;
         ELSIF     c1.cancel_date IS NOT NULL
               AND c1.payor <> 'SPOILED'
               AND c1.payor = 'REPLACED'
         THEN
            v_payor :=
                  c1.payor
               || ' ON '
               || TO_CHAR (c1.last_update, 'MM-DD-RRRR')
               || ' WITH OR DATE '
               || TO_CHAR (c1.or_date, 'MM-DD-RRRR');
         ELSE
            v_payor := c1.payor;
         END IF;

         v_orr.payor := v_payor;

         IF c1.payor IN ('CANCELLED', 'REPLACED')
         THEN
            IF     c1.payor IN ('CANCELLED', 'REPLACED')
               AND TRUNC (c1.or_date) <> TRUNC (c1.cancel_date)
            THEN
               v_amount := c1.amount;
            ELSIF     c1.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (c1.or_date) = TRUNC (c1.cancel_date))
                  AND (c1.dcb_no <> c1.cancel_dcb_no)
            THEN
               v_amount := c1.amount;
            ELSIF     c1.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (c1.or_date) = TRUNC (c1.cancel_date))
                  AND (c1.dcb_no = c1.cancel_dcb_no)
            THEN
               v_amount := 0;
            ELSIF     c1.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (c1.or_date) = TRUNC (c1.cancel_date))
            THEN
               v_amount := 0;
            ELSE
               v_amount := c1.amount;
            END IF;
         ELSE
            v_amount := c1.amount;
         END IF;

         v_orr.amount_received := v_amount;
         PIPE ROW (v_orr);
      END LOOP;

      RETURN;
   END;

   FUNCTION officialreceiptsregister_u (
      p_date        DATE,
      p_date2       DATE,
      p_branch_cd   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN orr_type2 PIPELINED
   IS
      v_orr      orr_rec_type2;
      v_payor    giac_order_of_payts.payor%TYPE;
      v_amount   giac_collection_dtl.amount%TYPE;
   BEGIN
      FOR c1 IN (SELECT   f.branch_cd || ' - ' || f.branch_name "BRANCH",
                          a.or_pref_suf, a.or_no, a.or_flag, a.particulars,
                          a.last_update,
                          a.or_pref_suf || '-'
                          || LPAD (a.or_no, 9, '0') or_no1,
                          a.or_date or_date, a.cancel_date cancel_date,
                          TO_CHAR (a.dcb_no) dcb_no,
                          TO_CHAR (a.cancel_dcb_no) cancel_dcb_no,
                          b.tran_date tran_date, b.posting_date posting_date,
                          DECODE (a.or_flag,
                                  'C', 'CANCELLED',
                                  'R', 'REPLACED',
                                  a.payor
                                 ) payor,
                          SUM (c.amount) "AMOUNT", d.short_name "CURRENCY",
                          SUM (DECODE (c.currency_cd,
                                       1, NULL,
                                       c.fcurrency_amt
                                      )
                              ) "FOREIGN_CURRENCY",
                          DECODE (a.or_pref_suf,
                                  NULL, 'Z',
                                  SUBSTR (a.or_pref_suf, 1, 1)
                                 ) AS or_type
                     FROM giac_order_of_payts a,
                          giac_acctrans b,
                          giac_collection_dtl c,
                          giis_currency d,
                          giac_branches f
                    WHERE a.gacc_tran_id = b.tran_id
                      AND a.gibr_gfun_fund_cd = b.gfun_fund_cd
                      AND a.gibr_branch_cd = b.gibr_branch_cd
                      AND b.tran_id = c.gacc_tran_id
                      AND b.gibr_branch_cd = f.branch_cd
                      AND a.gibr_branch_cd = f.branch_cd
                      AND b.gfun_fund_cd = f.gfun_fund_cd
                      AND a.gibr_gfun_fund_cd = f.gfun_fund_cd
                      AND c.currency_cd = d.main_currency_cd
                      AND a.or_date BETWEEN p_date AND p_date2
                      AND ((SELECT access_tag --john 10.9.2014 for checking user access (check_user_per_iss_cd_acctg2)
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS160'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = a.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS160'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = a.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                   )
                      AND f.branch_cd =
                             DECODE (p_branch_cd,
                                     NULL, f.branch_cd,
                                     p_branch_cd
                                    )
                      AND tran_flag != 'P'
                      AND or_flag != 'N'
                      AND (   (    (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                           OR (a.cancel_date IS NULL)
                           OR (    (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                          )
                      AND (   (a.or_flag NOT IN ('C', 'R'))
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) <>
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no = a.cancel_dcb_no)
                              )
                           OR (    (a.or_flag IN ('C', 'R'))
                               AND (TRUNC (NVL (a.cancel_date, b.tran_date)) =
                                                           TRUNC (b.tran_date)
                                   )
                               AND (a.dcb_no <> a.cancel_dcb_no)
                              )
                          )
                 GROUP BY f.branch_cd || ' - ' || f.branch_name,
                          a.or_pref_suf,
                          a.or_no,
                          a.or_flag,
                          a.particulars,
                          a.last_update,
                          a.or_pref_suf || '-' || LPAD (a.or_no, 9, '0'),
                          a.or_date,
                          a.cancel_date,
                          a.dcb_no,
                          a.cancel_dcb_no,
                          b.tran_date,
                          b.posting_date,
                          DECODE (a.or_flag,
                                  'C', 'CANCELLED',
                                  'R', 'REPLACED',
                                  a.payor
                                 ),
                          d.short_name,
                          DECODE (a.or_pref_suf,
                                  NULL, 'Z',
                                  SUBSTR (a.or_pref_suf, 1, 1)
                                 )
                 UNION
                 SELECT   f.branch_cd || ' - ' || f.branch_name "BRANCH",
                          e.or_pref, e.or_no, '', '', SYSDATE,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0') or_no1,
                          e.or_date or_date, SYSDATE, '      ', '',
                          b.tran_date tran_date, b.posting_date posting_date,
                          'SPOILED' payor, TO_NUMBER (NULL) "AMOUNT",
                          NULL "CURRENCY", TO_NUMBER (NULL)
                                                           "FOREIGN_CURRENCY",
                          DECODE (e.or_pref,
                                  NULL, 'Z',
                                  SUBSTR (e.or_pref, 1, 1)
                                 ) AS or_type
                     FROM giac_acctrans b,
                          giac_collection_dtl c,
                          giis_currency d,
                          giac_spoiled_or e,
                          giac_branches f
                    WHERE e.tran_id = b.tran_id
                      AND b.tran_id = c.gacc_tran_id
                      AND b.gibr_branch_cd = f.branch_cd
                      AND c.currency_cd = d.main_currency_cd
                      AND e.or_date BETWEEN p_date AND p_date2
                      AND ((SELECT access_tag --john 10.9.2014 for checking user access (check_user_per_iss_cd_acctg2)
                              FROM giis_user_modules
                             WHERE userid = NVL (p_user_id, USER)   
                               AND module_id = 'GIACS160'
                               AND tran_cd IN (
                                      SELECT b.tran_cd         
                                        FROM giis_users a, giis_user_iss_cd b, giis_modules_tran c
                                       WHERE a.user_id = b.userid
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = b.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                     OR (SELECT access_tag
                              FROM giis_user_grp_modules
                             WHERE module_id = 'GIACS160'
                               AND (user_grp, tran_cd) IN (
                                      SELECT a.user_grp, b.tran_cd
                                        FROM giis_users a, giis_user_grp_dtl b, giis_modules_tran c
                                       WHERE a.user_grp = b.user_grp
                                         AND a.user_id = NVL (p_user_id, USER)
                                         AND b.iss_cd = b.gibr_branch_cd
                                         AND b.tran_cd = c.tran_cd
                                         AND c.module_id = 'GIACS160')) = 1
                   )
                      AND f.branch_cd =
                             DECODE (p_branch_cd,
                                     NULL, f.branch_cd,
                                     p_branch_cd
                                    )
                 GROUP BY f.branch_cd || ' - ' || f.branch_name,
                          e.or_pref,
                          e.or_no,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0'),
                          e.or_date,
                          b.tran_date,
                          b.posting_date,
                          'SPOILED',
                          DECODE (e.or_pref,
                                  NULL, 'Z',
                                  SUBSTR (e.or_pref, 1, 1)
                                 )
                 UNION
                 SELECT   f.branch_cd || ' - ' || f.branch_name "BRANCH",
                          e.or_pref, e.or_no, '', '', SYSDATE,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0') or_no1,
                          e.or_date or_date, SYSDATE, '      ', '',
                          TO_DATE (NULL) tran_date,
                          TO_DATE (NULL) posting_date, 'SPOILED' payor,
                          TO_NUMBER (NULL) "AMOUNT", NULL "CURRENCY",
                          TO_NUMBER (NULL) "FOREIGN_CURRENCY",
                          DECODE (e.or_pref,
                                  NULL, 'Z',
                                  SUBSTR (e.or_pref, 1, 1)
                                 ) AS or_type
                     FROM giac_spoiled_or e, giac_branches f
                    WHERE e.fund_cd = f.gfun_fund_cd
                      AND e.branch_cd = f.branch_cd
                      AND e.tran_id IS NULL
                      AND DECODE (e.or_date, NULL, e.spoil_date, e.or_date)
                             BETWEEN p_date
                                 AND p_date2
                      AND f.branch_cd =
                             DECODE (p_branch_cd,
                                     NULL, f.branch_cd,
                                     p_branch_cd
                                    )
                 GROUP BY f.branch_cd || ' - ' || f.branch_name,
                          e.or_pref,
                          e.or_no,
                          e.or_pref || '-' || LPAD (e.or_no, 9, '0'),
                          e.or_date,
                          'SPOILED',
                          DECODE (e.or_pref,
                                  NULL, 'Z',
                                  SUBSTR (e.or_pref, 1, 1)
                                 )
                 ORDER BY 2, 3)
      LOOP
         v_orr.branch := c1.branch;
         v_orr.or_no := c1.or_no1;
         v_orr.or_date := c1.or_date;
         v_orr.tran_date := c1.tran_date;
         v_orr.posting_date := c1.posting_date;
         v_orr.currency := c1.currency;
         v_orr.foreign_currency := c1.foreign_currency;

         IF     c1.cancel_date IS NOT NULL
            AND c1.payor <> 'SPOILED'
            AND c1.payor <> 'REPLACED'
         THEN
            IF TRUNC (c1.cancel_date) <> TRUNC (c1.or_date)
            THEN
               v_payor :=
                     c1.payor
                  || ' ON '
                  || TO_CHAR (c1.cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || c1.cancel_dcb_no;
            ELSIF     TRUNC (c1.cancel_date) = TRUNC (c1.or_date)
                  AND c1.dcb_no <> c1.cancel_dcb_no
            THEN
               v_payor :=
                     c1.payor
                  || ' ON '
                  || TO_CHAR (c1.cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || c1.cancel_dcb_no;
            ELSE
               v_payor := c1.payor;
            END IF;
         ELSIF     c1.cancel_date IS NOT NULL
               AND c1.payor <> 'SPOILED'
               AND c1.payor = 'REPLACED'
         THEN
            v_payor :=
                  c1.payor
               || ' ON '
               || TO_CHAR (c1.last_update, 'MM-DD-RRRR')
               || ' WITH OR DATE '
               || TO_CHAR (c1.or_date, 'MM-DD-RRRR');
         ELSE
            v_payor := c1.payor;
         END IF;

         v_orr.payor := v_payor;

         IF c1.payor IN ('CANCELLED', 'REPLACED')
         THEN
            IF     c1.payor IN ('CANCELLED', 'REPLACED')
               AND TRUNC (c1.or_date) <> TRUNC (c1.cancel_date)
            THEN
               v_amount := c1.amount;
            ELSIF     c1.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (c1.or_date) = TRUNC (c1.cancel_date))
                  AND (c1.dcb_no <> c1.cancel_dcb_no)
            THEN
               v_amount := c1.amount;
            ELSIF     c1.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (c1.or_date) = TRUNC (c1.cancel_date))
                  AND (c1.dcb_no = c1.cancel_dcb_no)
            THEN
               v_amount := 0;
            ELSIF     c1.payor IN ('CANCELLED', 'REPLACED')
                  AND (TRUNC (c1.or_date) = TRUNC (c1.cancel_date))
            THEN
               v_amount := 0;
            ELSE
               v_amount := c1.amount;
            END IF;
         ELSE
            v_amount := c1.amount;
         END IF;

         v_orr.amount_received := v_amount;
         PIPE ROW (v_orr);
      END LOOP;

      RETURN;
   END;

   /* Added by reymon 02282012
   ** For AC-SPECS-2012-013
   ** Added report GIACR135 (CHECK REGISTER)
   */
   FUNCTION checkregister (
      p_post_tran_toggle   VARCHAR2,
      p_branch             VARCHAR2,
      p_begin_date         DATE,
      p_end_date           DATE,
      p_bank_cd            VARCHAR2,
      p_bank_acct_no       VARCHAR2
   )
      RETURN cr_type PIPELINED
   IS
      rec_cr   cr_rec_type;
   BEGIN
      FOR rec1 IN
         (SELECT gdv.currency_cd,
                 DECODE (gcd.check_stat,
                         2, DECODE (gcri.check_released_by, NULL, amount, 0),
                         3, DECODE (ga.tran_flag,
                                    'P', DECODE (p_post_tran_toggle,
                                                 'P', amount,
                                                 0
                                                ),
                                    0
                                   )
                        ) unreleased_amt,
                 DECODE (gcd.check_stat,
                         2, amount,
                         3, DECODE (ga.tran_flag,
                                    'P', DECODE (p_post_tran_toggle,
                                                 'P', amount,
                                                 0
                                                ),
                                    0
                                   )
                        ) check_amt,
                 gdv.dv_date dv_date, gdv.gibr_gfun_fund_cd,
                 gdv.gibr_branch_cd, gb.branch_name, gcd.bank_cd,
                 gba.bank_name, gcd.bank_acct_cd, gbac.bank_acct_no,
                 gcd.check_date check_date,
                 TO_CHAR (gcd.check_date, 'YYYY-MM-DD') view_check_date,
                    DECODE (gcd.check_pref_suf,
                            NULL, NULL,
                            gcd.check_pref_suf || '-'
                           )
                 || gcd.check_no dsp_check_no,
                    gcd.check_pref_suf
                 || '-'
                 || TO_CHAR (gcd.check_no, '0000000000') view_check_no,
                    DECODE (gdv.dv_pref,
                            NULL, NULL,
                            gdv.dv_pref || '-'
                           )
                 || gdv.dv_no dv_no,
                 gdv.ref_no ref_no,
                    gdv.dv_pref
                 || '-'
                 || TO_CHAR (gdv.dv_no, '0000000000') view_dv_no,
                 ga.posting_date posting_date,
                 DECODE (gdv.dv_flag,
                         'C', 0,
                         DECODE (gcd.item_no,
                                 1, gdv.dv_amt,
                                 DECODE (ga.tran_flag, 'P', gdv.dv_amt, 0)
                                )
                        ) dv_amt,
                 DECODE
                    (gcd.check_stat,
                     2, gcd.payee,
                     3, DECODE (ga.tran_flag,
                                'P', DECODE (p_post_tran_toggle,
                                             'P', gcd.payee
                                              || '*** CANCELLED '
                                              || TO_CHAR (gprd.cancel_date,
                                                          'MM-DD-YYYY'
                                                         )
                                              || '***',
                                             'CANCELLED'
                                            ),
                                'CANCELLED'
                               )
                    ) particulars,
                 gcri.check_release_date release_date,
                 gcri.check_released_by released_by, gdv.dv_flag,
                 gcd.check_pref_suf, gcd.check_no, ga.tran_id, gcd.batch_tag,
                 NVL (gcd.disb_mode, 'C') disb_mode,
                 gdv.particulars gdv_particulars
            FROM giac_disb_vouchers gdv,
                 giac_acctrans ga,
                 giac_branches gb,
                 giac_chk_disbursement gcd,
                 giac_banks gba,
                 giac_bank_accounts gbac,
                 giac_chk_release_info gcri,
                 giac_payt_requests_dtl gprd
           WHERE gcd.check_stat IN (2, 3)
             AND gcd.item_no = gcri.item_no(+)
             AND gdv.gacc_tran_id = ga.tran_id
             AND gdv.gacc_tran_id = gprd.tran_id
             AND gdv.gacc_tran_id = gcd.gacc_tran_id
             AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
             AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
             AND gdv.gibr_branch_cd = gb.branch_cd
             AND gcd.bank_cd = gba.bank_cd(+)
             AND gcd.bank_acct_cd = gbac.bank_acct_cd
             AND gba.bank_cd = gbac.bank_cd
             AND gdv.gibr_branch_cd = NVL (p_branch, gdv.gibr_branch_cd)
             AND (   (    TRUNC (ga.posting_date) BETWEEN p_begin_date
                                                      AND p_end_date
                      AND p_post_tran_toggle = 'P'
                     )
                  OR (    TRUNC (gcd.check_date) BETWEEN p_begin_date
                                                     AND p_end_date
                      AND p_post_tran_toggle = 'T'
                     )
                 )
             AND gcd.bank_cd = NVL (p_bank_cd, gcd.bank_cd)
             AND gbac.bank_acct_no = NVL (p_bank_acct_no, gbac.bank_acct_no)
          UNION
          SELECT gdv.currency_cd, 0 unreleased_amt, 0 check_amt,
                 gdv.dv_date dv_date, ga.gfun_fund_cd, ga.gibr_branch_cd,
                 gb.branch_name, gsc.bank_cd, gba.bank_name, gsc.bank_acct_cd,
                 gbac.bank_acct_no, gsc.check_date check_date,
                 TO_CHAR (gsc.check_date, 'YYYY-MM-DD') view_check_date,
                    DECODE (gsc.check_pref_suf,
                            NULL, NULL,
                            gsc.check_pref_suf || '-'
                           )
                 || gsc.check_no dsp_check_no,
                    gsc.check_pref_suf
                 || '-'
                 || TO_CHAR (gsc.check_no, '0000000000') view_check_no,
                 gdv.dv_pref || '-' || gdv.dv_no dv_no, gdv.ref_no ref_no,
                    gdv.dv_pref
                 || '-'
                 || TO_CHAR (gdv.dv_no, '0000000000') view_dv_no,
                 ga.posting_date posting_date, 0 dv_amt,
                 DECODE (   gsc.check_pref_suf
                         || gsc.check_no
                         || TO_CHAR (gsc.gacc_tran_id),
                            gcd.check_pref_suf
                         || gcd.check_no
                         || TO_CHAR (gdv.gacc_tran_id), 'CANCELLED',
                         'SPOILED'
                        ) particulars,
                 TO_DATE ('01-JAN-00') release_date, 'DUMMY' released_by,
                 gdv.dv_flag, gsc.check_pref_suf, gsc.check_no, ga.tran_id,
                 gcd.batch_tag, NVL (gcd.disb_mode, 'C') disb_mode,
                 gdv.particulars gdv_particulars
            FROM giac_disb_vouchers gdv,
                 giac_acctrans ga,
                 giac_spoiled_check gsc,
                 giac_branches gb,
                 giac_chk_disbursement gcd,
                 giac_banks gba,
                 giac_bank_accounts gbac
           WHERE gsc.gacc_tran_id = ga.tran_id
             AND gsc.gacc_tran_id = gdv.gacc_tran_id
             AND gcd.gacc_tran_id = gdv.gacc_tran_id
             AND ga.gfun_fund_cd = gb.gfun_fund_cd
             AND ga.gibr_branch_cd = gb.branch_cd
             AND gsc.bank_cd = gba.bank_cd
             AND gsc.bank_acct_cd = gbac.bank_acct_cd
             AND gba.bank_cd = gbac.bank_cd
             AND ga.gibr_branch_cd = NVL (p_branch, ga.gibr_branch_cd)
             AND (   (    TRUNC (ga.posting_date) BETWEEN p_begin_date
                                                      AND p_end_date
                      AND p_post_tran_toggle = 'P'
                     )
                  OR (    TRUNC (gsc.check_date) BETWEEN p_begin_date
                                                     AND p_end_date
                      AND p_post_tran_toggle = 'T'
                     )
                 )
             AND gsc.bank_cd = NVL (p_bank_cd, gsc.bank_cd)
             AND gbac.bank_acct_no = NVL (p_bank_acct_no, gbac.bank_acct_no))
      LOOP
         rec_cr.branch := rec1.branch_name;
         rec_cr.bank := rec1.bank_name;
         rec_cr.bank_account_no := rec1.bank_acct_no;
         rec_cr.payee := rec1.particulars;
         rec_cr.particulars := rec1.gdv_particulars;
         rec_cr.date_posted := rec1.posting_date;
         rec_cr.dv_date := rec1.dv_date;
         rec_cr.dv_number := rec1.dv_no;
         rec_cr.check_date := rec1.check_date;
         rec_cr.check_no := rec1.dsp_check_no;
         rec_cr.check_amount := rec1.check_amt;
         rec_cr.date_released := rec1.release_date;
         rec_cr.unreleased_amount := rec1.unreleased_amt;
         rec_cr.ref_no := rec1.ref_no;
         rec_cr.gibr_branch_cd := rec1.gibr_branch_cd; --erma02012013

         IF rec1.disb_mode = 'B'
         THEN
            rec_cr.disbursement := 'BANK TRANSFER';
         ELSE
            rec_cr.disbursement := 'CHECK';
         END IF;

         IF rec1.batch_tag = 'Y'
         THEN
            rec_cr.batch_tag := '*';
         ELSE
            rec_cr.batch_tag := NULL;
         END IF;

         PIPE ROW (rec_cr);
      END LOOP;

      RETURN;
   END;
--end of 02282012

   --added by steven from web version GIACR135
   FUNCTION get_giacr135_include_part (p_post_tran_toggle    VARCHAR2,
                                       p_branch              VARCHAR2,
                                       p_begin_date          DATE,
                                       p_end_date            DATE,
                                       p_bank_cd             VARCHAR2,
                                       p_bank_acct_no        VARCHAR2,
                                       p_order_by            VARCHAR2, --Added by Robert SR 5197 03.01.2016
                                       p_user_id             VARCHAR2) --Added by Jerome Bautista 01.13.2016 SR 21299
                                       
      RETURN giacr135_include_part_tab PIPELINED
   IS
      rec_cr   giacr135_include_part_type;
      --Added by Robert SR 5197 03.01.2016
      rec1     v_giacr135_tab;
      v_select VARCHAR2(32767);
   BEGIN
        --changed to dynamic query by Robert SR 5197 03.01.2016
--      FOR rec1
--      IN (SELECT   gdv.currency_cd,
--                   DECODE (
--                      gcd.check_stat,
--                      2,
--                      DECODE (gcri.check_released_by, NULL, amount, 0),
--                      3,
--                      DECODE (ga.tran_flag,
--                              'P',
--                              DECODE (p_post_tran_toggle, 'P', amount, 0),
--                              0)
--                   )
--                      unreleased_amt,
--                   DECODE (
--                      gcd.check_stat,
--                      2,
--                      amount,
--                      3,
--                      DECODE (ga.tran_flag,
--                              'P',
--                              DECODE (p_post_tran_toggle, 'P', amount, 0),
--                              0)
--                   )
--                      check_amt,
--                   gdv.dv_date dv_date,
--                   gdv.gibr_gfun_fund_cd,
--                   gdv.gibr_branch_cd,
--                   gb.branch_name,
--                   gcd.bank_cd,
--                   gba.bank_name,
--                   gcd.bank_acct_cd,
--                   gbac.bank_acct_no,
--                   gcd.check_date check_date,
--                   TO_CHAR (gcd.check_date, 'YYYY-MM-DD') view_check_date,
--                   DECODE (gcd.check_pref_suf,
--                           NULL, NULL,
--                           gcd.check_pref_suf || '-')
--                   || gcd.check_no
--                      dsp_check_no,
--                      gcd.check_pref_suf
--                   || '-'
--                   || TO_CHAR (gcd.check_no, '0000000000')
--                      view_check_no,
--                   DECODE (gdv.dv_pref, NULL, NULL, gdv.dv_pref || '-')
--                   || gdv.dv_no
--                      dv_no,
--                   gdv.ref_no ref_no,
--                   gdv.dv_pref || '-' || TO_CHAR (gdv.dv_no, '0000000000')
--                      view_dv_no,
--                   ga.posting_date posting_date,
--                   DECODE (
--                      gdv.dv_flag,
--                      'C',
--                      0,
--                      DECODE (gcd.item_no,
--                              1, gdv.dv_amt,
--                              DECODE (ga.tran_flag, 'P', gdv.dv_amt, 0))
--                   )
--                      dv_amt,
--                   DECODE (
--                      gcd.check_stat,
--                      2,
--                      gcd.payee,
--                      3,
--                      DECODE (
--                         ga.tran_flag,
--                         'P',
--                         DECODE (
--                            p_post_tran_toggle,
--                            'P',
--                               gcd.payee
--                            || '*** CANCELLED '
--                            || TO_CHAR (gprd.cancel_date, 'MM-DD-YYYY')
--                            || '***',
--                            'CANCELLED'
--                         ),
--                         'CANCELLED'
--                      )
--                   )
--                      particulars,
--                   gcri.check_release_date release_date,
--                   gcri.check_released_by released_by,
--                   gdv.dv_flag,
--                   gcd.check_pref_suf,
--                   gcd.check_no,
--                   ga.tran_id,
--                   gcd.batch_tag,
--                   NVL (gcd.disb_mode, 'C') disb_mode,
--                   gdv.particulars gdv_particulars
--            FROM   giac_disb_vouchers gdv,
--                   giac_acctrans ga,
--                   giac_branches gb,
--                   giac_chk_disbursement gcd,
--                   giac_banks gba,
--                   giac_bank_accounts gbac,
--                   giac_chk_release_info gcri,
--                   giac_payt_requests_dtl gprd
--           WHERE       gcd.check_stat IN (2, 3)
--                   AND gcd.item_no = gcri.item_no(+)
--                   AND gdv.gacc_tran_id = ga.tran_id
--                   AND gdv.gacc_tran_id = gprd.tran_id
--                   AND gdv.gacc_tran_id = gcd.gacc_tran_id
--                   AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
--                   AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
--                   AND gdv.gibr_branch_cd = gb.branch_cd
--                   AND gcd.bank_cd = gba.bank_cd(+)
--                   AND gcd.bank_acct_cd = gbac.bank_acct_cd
--                   AND gba.bank_cd = gbac.bank_cd
--                   AND gdv.gibr_branch_cd =
--                         NVL (p_branch, gdv.gibr_branch_cd)
----                   AND check_user_per_iss_cd_acctg (NULL, --Commented out by Jerome Bautista SR 21299 01.20.2016
----                                                    ga.gibr_branch_cd,
----                                                    'GIACS135') = 1 -- added by mikel 07.03.2012
--                   AND EXISTS (SELECT 'X' --Added by Jerome Bautista SR 21299 01.20.2016
--                                 FROM TABLE (security_access.get_branch_line ('AC', 'GIACS135', p_user_id))
--                                WHERE branch_cd = ga.gibr_branch_cd)
--                   AND ( (TRUNC (ga.posting_date) BETWEEN p_begin_date
--                                                      AND  p_end_date
--                          AND p_post_tran_toggle = 'P')
--                        OR (TRUNC (gcd.check_date) BETWEEN p_begin_date
--                                                       AND  p_end_date
--                            AND p_post_tran_toggle = 'T'))
--                   AND gcd.bank_cd = NVL (p_bank_cd, gcd.bank_cd)
--                   AND gbac.bank_acct_no =
--                         NVL (p_bank_acct_no, gbac.bank_acct_no)
--          UNION
--          SELECT   gdv.currency_cd,
--                   0 unreleased_amt,
--                   0 check_amt,
--                   gdv.dv_date dv_date,
--                   ga.gfun_fund_cd,
--                   ga.gibr_branch_cd,
--                   gb.branch_name,
--                   gsc.bank_cd,
--                   gba.bank_name,
--                   gsc.bank_acct_cd,
--                   gbac.bank_acct_no,
--                   gsc.check_date check_date,
--                   TO_CHAR (gsc.check_date, 'YYYY-MM-DD') view_check_date,
--                   DECODE (gsc.check_pref_suf,
--                           NULL, NULL,
--                           gsc.check_pref_suf || '-')
--                   || gsc.check_no
--                      dsp_check_no,
--                      gsc.check_pref_suf
--                   || '-'
--                   || TO_CHAR (gsc.check_no, '0000000000')
--                      view_check_no,
--                   gdv.dv_pref || '-' || gdv.dv_no dv_no,
--                   gdv.ref_no ref_no,
--                   gdv.dv_pref || '-' || TO_CHAR (gdv.dv_no, '0000000000')
--                      view_dv_no,
--                   ga.posting_date posting_date,
--                   0 dv_amt,
--                   DECODE (
--                         gsc.check_pref_suf
--                      || gsc.check_no
--                      || TO_CHAR (gsc.gacc_tran_id),
--                         gcd.check_pref_suf
--                      || gcd.check_no
--                      || TO_CHAR (gdv.gacc_tran_id),
--                      'CANCELLED',
--                      'SPOILED'
--                   )
--                      particulars,
--                   TO_DATE ('01-JAN-00') release_date,
--                   'DUMMY' released_by,
--                   gdv.dv_flag,
--                   gsc.check_pref_suf,
--                   gsc.check_no,
--                   ga.tran_id,
--                   gcd.batch_tag,
--                   NVL (gcd.disb_mode, 'C') disb_mode,
--                   gdv.particulars gdv_particulars
--            FROM   giac_disb_vouchers gdv,
--                   giac_acctrans ga,
--                   giac_spoiled_check gsc,
--                   giac_branches gb,
--                   giac_chk_disbursement gcd,
--                   giac_banks gba,
--                   giac_bank_accounts gbac
--           WHERE       gsc.gacc_tran_id = ga.tran_id
--                   AND gsc.gacc_tran_id = gdv.gacc_tran_id
--                   AND gcd.gacc_tran_id = gdv.gacc_tran_id
--                   AND ga.gfun_fund_cd = gb.gfun_fund_cd
--                   AND ga.gibr_branch_cd = gb.branch_cd
--                   AND gsc.bank_cd = gba.bank_cd
--                   AND gsc.bank_acct_cd = gbac.bank_acct_cd
--                   AND gba.bank_cd = gbac.bank_cd
--                   AND ga.gibr_branch_cd = NVL (p_branch, ga.gibr_branch_cd)
----                   AND check_user_per_iss_cd_acctg (NULL, --Commented out by Jerome Bautista SR 21299 01.20.2016
----                                                    ga.gibr_branch_cd,
----                                                    'GIACS135') = 1 -- added by mikel 07.03.2012
--                   AND EXISTS (SELECT 'X' -- Added by Jerome Bautista SR 21299 01.20.2016
--                                 FROM TABLE (security_access.get_branch_line ('AC', 'GIACS135', p_user_id))
--                                WHERE branch_cd = ga.gibr_branch_cd)
--                   AND ( (TRUNC (ga.posting_date) BETWEEN p_begin_date
--                                                      AND  p_end_date
--                          AND p_post_tran_toggle = 'P')
--                        OR (TRUNC (gsc.check_date) BETWEEN p_begin_date
--                                                       AND  p_end_date
--                            AND p_post_tran_toggle = 'T'))
--                   AND gsc.bank_cd = NVL (p_bank_cd, gsc.bank_cd)
--                   AND gbac.bank_acct_no =
--                         NVL (p_bank_acct_no, gbac.bank_acct_no))

      v_select := ' SELECT gdv.currency_cd,
                           DECODE (gcd.check_stat,
                                   2, DECODE (gcri.check_released_by, NULL, amount, 0),
                                   3, DECODE (ga.tran_flag,
                                              ''P'', DECODE ('''||p_post_tran_toggle||''', ''P'', amount, 0),
                                              0
                                             )
                                  ) unreleased_amt,
                           DECODE (gcd.check_stat,
                                   2, amount,
                                   3, DECODE (ga.tran_flag,
                                              ''P'', DECODE ('''||p_post_tran_toggle||''', ''P'', amount, 0),
                                              0
                                             )
                                  ) check_amt,
                           gdv.dv_date dv_date, gdv.gibr_gfun_fund_cd, gdv.gibr_branch_cd,
                           gb.branch_name, gcd.bank_cd, gba.bank_name, gcd.bank_acct_cd,
                           gbac.bank_acct_no, gcd.check_date check_date,
                           TO_CHAR (gcd.check_date, ''YYYY-MM-DD'') view_check_date,
                              DECODE (gcd.check_pref_suf,
                                      NULL, NULL,
                                      gcd.check_pref_suf || ''-''
                                     )
                           || gcd.check_no dsp_check_no,
                              gcd.check_pref_suf
                           || ''-''
                           || TO_CHAR (gcd.check_no, ''0000000000'') view_check_no,
                           DECODE (gdv.dv_pref, NULL, NULL, gdv.dv_pref || ''-'')
                           || gdv.dv_no dv_no, gdv.ref_no ref_no,
                           gdv.dv_pref || ''-'' || TO_CHAR (gdv.dv_no, ''0000000000'') view_dv_no,
                           ga.posting_date posting_date,
                           DECODE (gdv.dv_flag,
                                   ''C'', 0,
                                   DECODE (gcd.item_no,
                                           1, gdv.dv_amt,
                                           DECODE (ga.tran_flag, ''P'', gdv.dv_amt, 0)
                                          )
                                  ) dv_amt,
                           DECODE (gcd.check_stat,
                                   2, gcd.payee,
                                   3, DECODE (ga.tran_flag,
                                              ''P'', DECODE ('''||p_post_tran_toggle||''',
                                                           ''P'', gcd.payee
                                                            || ''*** CANCELLED ''
                                                            || TO_CHAR (gprd.cancel_date,
                                                                        ''MM-DD-YYYY''
                                                                       )
                                                            || ''***'',
                                                           ''CANCELLED''
                                                          ),
                                              ''CANCELLED''
                                             )
                                  ) particulars,
                           gcri.check_release_date release_date,
                           gcri.check_released_by released_by, gdv.dv_flag, gcd.check_pref_suf,
                           gcd.check_no, ga.tran_id, gcd.batch_tag,
                           NVL (gcd.disb_mode, ''C'') disb_mode, gdv.particulars gdv_particulars
                      FROM giac_disb_vouchers gdv,
                           giac_acctrans ga,
                           giac_branches gb,
                           giac_chk_disbursement gcd,
                           giac_banks gba,
                           giac_bank_accounts gbac,
                           giac_chk_release_info gcri,
                           giac_payt_requests_dtl gprd
                     WHERE gcd.check_stat IN (2, 3)
                       AND gcd.item_no = gcri.item_no(+)
                       AND gdv.gacc_tran_id = ga.tran_id
                       AND gdv.gacc_tran_id = gprd.tran_id
                       AND gdv.gacc_tran_id = gcd.gacc_tran_id
                       AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
                       AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
                       AND gdv.gibr_branch_cd = gb.branch_cd
                       AND gcd.bank_cd = gba.bank_cd(+)
                       AND gcd.bank_acct_cd = gbac.bank_acct_cd
                       AND gba.bank_cd = gbac.bank_cd
                       AND gdv.gibr_branch_cd = NVL ('''||p_branch||''', gdv.gibr_branch_cd)
                       AND EXISTS (
                              SELECT ''X''
                                FROM TABLE (security_access.get_branch_line (''AC'',
                                                                             ''GIACS135'',
                                                                             '''||p_user_id||'''
                                                                            )
                                           )
                               WHERE branch_cd = ga.gibr_branch_cd)
                       AND (   (    TRUNC (ga.posting_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''P''
                               )
                            OR (    TRUNC (gcd.check_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''T''
                               )
                           )
                       AND gcd.bank_cd = NVL ('''||p_bank_cd||''', gcd.bank_cd)
                       AND gbac.bank_acct_no = NVL ('''||p_bank_acct_no||''', gbac.bank_acct_no)
                    UNION
                    SELECT gdv.currency_cd, 0 unreleased_amt, 0 check_amt, gdv.dv_date dv_date,
                           ga.gfun_fund_cd, ga.gibr_branch_cd, gb.branch_name, gsc.bank_cd,
                           gba.bank_name, gsc.bank_acct_cd, gbac.bank_acct_no,
                           gsc.check_date check_date,
                           TO_CHAR (gsc.check_date, ''YYYY-MM-DD'') view_check_date,
                              DECODE (gsc.check_pref_suf,
                                      NULL, NULL,
                                      gsc.check_pref_suf || ''-''
                                     )
                           || gsc.check_no dsp_check_no,
                              gsc.check_pref_suf
                           || ''-''
                           || TO_CHAR (gsc.check_no, ''0000000000'') view_check_no,
                           gdv.dv_pref || ''-'' || gdv.dv_no dv_no, gdv.ref_no ref_no,
                           gdv.dv_pref || ''-'' || TO_CHAR (gdv.dv_no, ''0000000000'') view_dv_no,
                           ga.posting_date posting_date, 0 dv_amt,
                           DECODE (gsc.check_pref_suf || gsc.check_no
                                   || TO_CHAR (gsc.gacc_tran_id),
                                   gcd.check_pref_suf || gcd.check_no
                                   || TO_CHAR (gdv.gacc_tran_id), ''CANCELLED'',
                                   ''SPOILED''
                                  ) particulars,
                           TO_DATE(''01-01-2000'', ''MM-DD-YYYY'') release_date, '-- Edited By MArkS 05.04.2016 SR-5197 error in changing when inserting the record into the table_type
                           ||'''DUMMY'' released_by, gdv.dv_flag,
                           gsc.check_pref_suf, gsc.check_no, ga.tran_id, gcd.batch_tag,
                           NVL (gcd.disb_mode, ''C'') disb_mode, gdv.particulars gdv_particulars
                      FROM giac_disb_vouchers gdv,
                           giac_acctrans ga,
                           giac_spoiled_check gsc,
                           giac_branches gb,
                           giac_chk_disbursement gcd,
                           giac_banks gba,
                           giac_bank_accounts gbac
                     WHERE gsc.gacc_tran_id = ga.tran_id
                       AND gsc.gacc_tran_id = gdv.gacc_tran_id
                       AND gcd.gacc_tran_id = gdv.gacc_tran_id
                       AND ga.gfun_fund_cd = gb.gfun_fund_cd
                       AND ga.gibr_branch_cd = gb.branch_cd
                       AND gsc.bank_cd = gba.bank_cd
                       AND gsc.bank_acct_cd = gbac.bank_acct_cd
                       AND gba.bank_cd = gbac.bank_cd
                       AND ga.gibr_branch_cd = NVL ('''||p_branch||''', ga.gibr_branch_cd)
                       AND EXISTS (
                              SELECT ''X''
                                FROM TABLE (security_access.get_branch_line (''AC'',
                                                                             ''GIACS135'',
                                                                             '''||p_user_id||'''
                                                                            )
                                           )
                               WHERE branch_cd = ga.gibr_branch_cd)
                       AND (   (    TRUNC (ga.posting_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''P''
                               )
                            OR (    TRUNC (gsc.check_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''T''
                               )
                           )
                       AND gsc.bank_cd = NVL ('''||p_bank_cd||''', gsc.bank_cd)
                       AND gbac.bank_acct_no = NVL ('''||p_bank_acct_no||''', gbac.bank_acct_no) 
                     ORDER BY GIBR_BRANCH_CD, BANK_CD, BANK_ACCT_NO, DISB_MODE, '|| p_order_by;
                       
      EXECUTE IMMEDIATE v_select BULK COLLECT INTO rec1;
      IF rec1.LAST > 0 THEN
          FOR i IN rec1.FIRST .. rec1.LAST
          LOOP
             rec_cr.branch := rec1(i).branch_name;
             rec_cr.bank := rec1(i).bank_name;
             rec_cr.bank_account_no := rec1(i).bank_acct_no;
             rec_cr.payee := rec1(i).particulars;
             rec_cr.particulars := rec1(i).gdv_particulars;
             rec_cr.date_posted := rec1(i).posting_date;
             rec_cr.dv_date := rec1(i).dv_date;
             rec_cr.dv_number := rec1(i).dv_no;
             rec_cr.check_date := rec1(i).check_date;
             rec_cr.check_no := rec1(i).dsp_check_no;
             rec_cr.check_amount := rec1(i).check_amt;
             rec_cr.date_released := rec1(i).release_date;
             rec_cr.unreleased_amount := rec1(i).unreleased_amt;

             IF rec1(i).disb_mode = 'B'
             THEN
                rec_cr.disbursement := 'BANK TRANSFER';
             ELSE
                rec_cr.disbursement := 'CHECK';
             END IF;

             IF rec1(i).batch_tag = 'Y'
             THEN
                rec_cr.batch_tag := '*';
             ELSE
                rec_cr.batch_tag := NULL;
             END IF;
             --added by robert SR 5197 02.02.2016
             IF rec1(i).check_amt = 0
             THEN
                rec_cr.date_released := NULL;
             ELSE
                rec_cr.date_released := rec1(i).release_date;
             END IF;
             --end robert
             PIPE ROW (rec_cr);
          END LOOP;
      END IF;

      RETURN;
   END;
   
   FUNCTION get_giacr135_exclude_part (p_post_tran_toggle    VARCHAR2,
                                       p_branch              VARCHAR2,
                                       p_begin_date          DATE,
                                       p_end_date            DATE,
                                       p_bank_cd             VARCHAR2,
                                       p_bank_acct_no        VARCHAR2,
                                       p_order_by            VARCHAR2, --Added by Robert SR 5197 03.01.2016
                                       p_user_id             VARCHAR2) --Added by Jerome Bautista 01.13.2016 SR 21299
      RETURN giacr135_exclude_part_tab PIPELINED
   IS
      rec_cr   giacr135_exclude_part_type;
      --Added by Robert SR 5197 03.01.2016
      rec1     v_giacr135_tab;
      v_select VARCHAR2(32767);
   BEGIN
        --changed to dynamic query by Robert SR 5197 03.01.2016
--      FOR rec1
--      IN (SELECT   gdv.currency_cd,
--                   DECODE (
--                      gcd.check_stat,
--                      2,
--                      DECODE (gcri.check_released_by, NULL, amount, 0),
--                      3,
--                      DECODE (ga.tran_flag,
--                              'P',
--                              DECODE (p_post_tran_toggle, 'P', amount, 0),
--                              0)
--                   )
--                      unreleased_amt,
--                   DECODE (
--                      gcd.check_stat,
--                      2,
--                      amount,
--                      3,
--                      DECODE (ga.tran_flag,
--                              'P',
--                              DECODE (p_post_tran_toggle, 'P', amount, 0),
--                              0)
--                   )
--                      check_amt,
--                   gdv.dv_date dv_date,
--                   gdv.gibr_gfun_fund_cd,
--                   gdv.gibr_branch_cd,
--                   gb.branch_name,
--                   gcd.bank_cd,
--                   gba.bank_name,
--                   gcd.bank_acct_cd,
--                   gbac.bank_acct_no,
--                   gcd.check_date check_date,
--                   TO_CHAR (gcd.check_date, 'YYYY-MM-DD') view_check_date,
--                   DECODE (gcd.check_pref_suf,
--                           NULL, NULL,
--                           gcd.check_pref_suf || '-')
--                   || gcd.check_no
--                      dsp_check_no,
--                      gcd.check_pref_suf
--                   || '-'
--                   || TO_CHAR (gcd.check_no, '0000000000')
--                      view_check_no,
--                   DECODE (gdv.dv_pref, NULL, NULL, gdv.dv_pref || '-')
--                   || gdv.dv_no
--                      dv_no,
--                   gdv.ref_no ref_no,
--                   gdv.dv_pref || '-' || TO_CHAR (gdv.dv_no, '0000000000')
--                      view_dv_no,
--                   ga.posting_date posting_date,
--                   DECODE (
--                      gdv.dv_flag,
--                      'C',
--                      0,
--                      DECODE (gcd.item_no,
--                              1, gdv.dv_amt,
--                              DECODE (ga.tran_flag, 'P', gdv.dv_amt, 0))
--                   )
--                      dv_amt,
--                   DECODE (
--                      gcd.check_stat,
--                      2,
--                      gcd.payee,
--                      3,
--                      DECODE (
--                         ga.tran_flag,
--                         'P',
--                         DECODE (
--                            p_post_tran_toggle,
--                            'P',
--                               gcd.payee
--                            || '*** CANCELLED '
--                            || TO_CHAR (gprd.cancel_date, 'MM-DD-YYYY')
--                            || '***',
--                            'CANCELLED'
--                         ),
--                         'CANCELLED'
--                      )
--                   )
--                      particulars,
--                   gcri.check_release_date release_date,
--                   gcri.check_released_by released_by,
--                   gdv.dv_flag,
--                   gcd.check_pref_suf,
--                   gcd.check_no,
--                   ga.tran_id,
--                   gcd.batch_tag,
--                   NVL (gcd.disb_mode, 'C') disb_mode,
--                   gdv.particulars gdv_particulars
--            FROM   giac_disb_vouchers gdv,
--                   giac_acctrans ga,
--                   giac_branches gb,
--                   giac_chk_disbursement gcd,
--                   giac_banks gba,
--                   giac_bank_accounts gbac,
--                   giac_chk_release_info gcri,
--                   giac_payt_requests_dtl gprd
--           WHERE       gcd.check_stat IN (2, 3)
--                   AND gcd.item_no = gcri.item_no(+)
--                   AND gdv.gacc_tran_id = ga.tran_id
--                   AND gdv.gacc_tran_id = gprd.tran_id
--                   AND gdv.gacc_tran_id = gcd.gacc_tran_id
--                   AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
--                   AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
--                   AND gdv.gibr_branch_cd = gb.branch_cd
--                   AND gcd.bank_cd = gba.bank_cd(+)
--                   AND gcd.bank_acct_cd = gbac.bank_acct_cd
--                   AND gba.bank_cd = gbac.bank_cd
--                   AND gdv.gibr_branch_cd =
--                         NVL (p_branch, gdv.gibr_branch_cd)
----                   AND check_user_per_iss_cd_acctg (NULL, --Commented out by Jerome Bautista SR 21299 01.20.2016
----                                                    ga.gibr_branch_cd,
----                                                    'GIACS135') = 1 -- added by mikel 07.03.2012
--                   AND EXISTS (SELECT 'X' --Added by Jerome Bautista SR 21299 01.20.2016
--                                 FROM TABLE (security_access.get_branch_line ('AC', 'GIACS135', p_user_id))
--                                WHERE branch_cd = ga.gibr_branch_cd)
--                   AND ( (TRUNC (ga.posting_date) BETWEEN p_begin_date
--                                                      AND  p_end_date
--                          AND p_post_tran_toggle = 'P')
--                        OR (TRUNC (gcd.check_date) BETWEEN p_begin_date
--                                                       AND  p_end_date
--                            AND p_post_tran_toggle = 'T'))
--                   AND gcd.bank_cd = NVL (p_bank_cd, gcd.bank_cd)
--                   AND gbac.bank_acct_no =
--                         NVL (p_bank_acct_no, gbac.bank_acct_no)
--          UNION
--          SELECT   gdv.currency_cd,
--                   0 unreleased_amt,
--                   0 check_amt,
--                   gdv.dv_date dv_date,
--                   ga.gfun_fund_cd,
--                   ga.gibr_branch_cd,
--                   gb.branch_name,
--                   gsc.bank_cd,
--                   gba.bank_name,
--                   gsc.bank_acct_cd,
--                   gbac.bank_acct_no,
--                   gsc.check_date check_date,
--                   TO_CHAR (gsc.check_date, 'YYYY-MM-DD') view_check_date,
--                   DECODE (gsc.check_pref_suf,
--                           NULL, NULL,
--                           gsc.check_pref_suf || '-')
--                   || gsc.check_no
--                      dsp_check_no,
--                      gsc.check_pref_suf
--                   || '-'
--                   || TO_CHAR (gsc.check_no, '0000000000')
--                      view_check_no,
--                   gdv.dv_pref || '-' || gdv.dv_no dv_no,
--                   gdv.ref_no ref_no,
--                   gdv.dv_pref || '-' || TO_CHAR (gdv.dv_no, '0000000000')
--                      view_dv_no,
--                   ga.posting_date posting_date,
--                   0 dv_amt,
--                   DECODE (
--                         gsc.check_pref_suf
--                      || gsc.check_no
--                      || TO_CHAR (gsc.gacc_tran_id),
--                         gcd.check_pref_suf
--                      || gcd.check_no
--                      || TO_CHAR (gdv.gacc_tran_id),
--                      'CANCELLED',
--                      'SPOILED'
--                   )
--                      particulars,
--                   TO_DATE ('01-JAN-00') release_date,
--                   'DUMMY' released_by,
--                   gdv.dv_flag,
--                   gsc.check_pref_suf,
--                   gsc.check_no,
--                   ga.tran_id,
--                   gcd.batch_tag,
--                   NVL (gcd.disb_mode, 'C') disb_mode,
--                   gdv.particulars gdv_particulars
--            FROM   giac_disb_vouchers gdv,
--                   giac_acctrans ga,
--                   giac_spoiled_check gsc,
--                   giac_branches gb,
--                   giac_chk_disbursement gcd,
--                   giac_banks gba,
--                   giac_bank_accounts gbac
--           WHERE       gsc.gacc_tran_id = ga.tran_id
--                   AND gsc.gacc_tran_id = gdv.gacc_tran_id
--                   AND gcd.gacc_tran_id = gdv.gacc_tran_id
--                   AND ga.gfun_fund_cd = gb.gfun_fund_cd
--                   AND ga.gibr_branch_cd = gb.branch_cd
--                   AND gsc.bank_cd = gba.bank_cd
--                   AND gsc.bank_acct_cd = gbac.bank_acct_cd
--                   AND gba.bank_cd = gbac.bank_cd
--                   AND ga.gibr_branch_cd = NVL (p_branch, ga.gibr_branch_cd)
----                   AND check_user_per_iss_cd_acctg (NULL, --Commented out by Jerome Bautista SR 21299 01.20.2016
----                                                    ga.gibr_branch_cd,
----                                                    'GIACS135') = 1 -- added by mikel 07.03.2012
--                   AND EXISTS (SELECT 'X' --Added by Jerome Bautista SR 21299 01.20.2016
--                                 FROM TABLE (security_access.get_branch_line ('AC', 'GIACS135', p_user_id))
--                                WHERE branch_cd = ga.gibr_branch_cd)
--                   AND ( (TRUNC (ga.posting_date) BETWEEN p_begin_date
--                                                      AND  p_end_date
--                          AND p_post_tran_toggle = 'P')
--                        OR (TRUNC (gsc.check_date) BETWEEN p_begin_date
--                                                       AND  p_end_date
--                            AND p_post_tran_toggle = 'T'))
--                   AND gsc.bank_cd = NVL (p_bank_cd, gsc.bank_cd)
--                   AND gbac.bank_acct_no =
--                         NVL (p_bank_acct_no, gbac.bank_acct_no))
      v_select := ' SELECT gdv.currency_cd,
                           DECODE (gcd.check_stat,
                                   2, DECODE (gcri.check_released_by, NULL, amount, 0),
                                   3, DECODE (ga.tran_flag,
                                              ''P'', DECODE ('''||p_post_tran_toggle||''', ''P'', amount, 0),
                                              0
                                             )
                                  ) unreleased_amt,
                           DECODE (gcd.check_stat,
                                   2, amount,
                                   3, DECODE (ga.tran_flag,
                                              ''P'', DECODE ('''||p_post_tran_toggle||''', ''P'', amount, 0),
                                              0
                                             )
                                  ) check_amt,
                           gdv.dv_date dv_date, gdv.gibr_gfun_fund_cd, gdv.gibr_branch_cd,
                           gb.branch_name, gcd.bank_cd, gba.bank_name, gcd.bank_acct_cd,
                           gbac.bank_acct_no, gcd.check_date check_date,
                           TO_CHAR (gcd.check_date, ''YYYY-MM-DD'') view_check_date,
                              DECODE (gcd.check_pref_suf,
                                      NULL, NULL,
                                      gcd.check_pref_suf || ''-''
                                     )
                           || gcd.check_no dsp_check_no,
                              gcd.check_pref_suf
                           || ''-''
                           || TO_CHAR (gcd.check_no, ''0000000000'') view_check_no,
                           DECODE (gdv.dv_pref, NULL, NULL, gdv.dv_pref || ''-'')
                           || gdv.dv_no dv_no, gdv.ref_no ref_no,
                           gdv.dv_pref || ''-'' || TO_CHAR (gdv.dv_no, ''0000000000'') view_dv_no,
                           ga.posting_date posting_date,
                           DECODE (gdv.dv_flag,
                                   ''C'', 0,
                                   DECODE (gcd.item_no,
                                           1, gdv.dv_amt,
                                           DECODE (ga.tran_flag, ''P'', gdv.dv_amt, 0)
                                          )
                                  ) dv_amt,
                           DECODE (gcd.check_stat,
                                   2, gcd.payee,
                                   3, DECODE (ga.tran_flag,
                                              ''P'', DECODE ('''||p_post_tran_toggle||''',
                                                           ''P'', gcd.payee
                                                            || ''*** CANCELLED ''
                                                            || TO_CHAR (gprd.cancel_date,
                                                                        ''MM-DD-YYYY''
                                                                       )
                                                            || ''***'',
                                                           ''CANCELLED''
                                                          ),
                                              ''CANCELLED''
                                             )
                                  ) particulars,
                           gcri.check_release_date release_date,
                           gcri.check_released_by released_by, gdv.dv_flag, gcd.check_pref_suf,
                           gcd.check_no, ga.tran_id, gcd.batch_tag,
                           NVL (gcd.disb_mode, ''C'') disb_mode, gdv.particulars gdv_particulars
                      FROM giac_disb_vouchers gdv,
                           giac_acctrans ga,
                           giac_branches gb,
                           giac_chk_disbursement gcd,
                           giac_banks gba,
                           giac_bank_accounts gbac,
                           giac_chk_release_info gcri,
                           giac_payt_requests_dtl gprd
                     WHERE gcd.check_stat IN (2, 3)
                       AND gcd.item_no = gcri.item_no(+)
                       AND gdv.gacc_tran_id = ga.tran_id
                       AND gdv.gacc_tran_id = gprd.tran_id
                       AND gdv.gacc_tran_id = gcd.gacc_tran_id
                       AND gcd.gacc_tran_id = gcri.gacc_tran_id(+)
                       AND gdv.gibr_gfun_fund_cd = gb.gfun_fund_cd
                       AND gdv.gibr_branch_cd = gb.branch_cd
                       AND gcd.bank_cd = gba.bank_cd(+)
                       AND gcd.bank_acct_cd = gbac.bank_acct_cd
                       AND gba.bank_cd = gbac.bank_cd
                       AND gdv.gibr_branch_cd = NVL ('''||p_branch||''', gdv.gibr_branch_cd)
                       AND EXISTS (
                              SELECT ''X''
                                FROM TABLE (security_access.get_branch_line (''AC'',
                                                                             ''GIACS135'',
                                                                             '''||p_user_id||'''
                                                                            )
                                           )
                               WHERE branch_cd = ga.gibr_branch_cd)
                       AND (   (    TRUNC (ga.posting_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''P''
                               )
                            OR (    TRUNC (gcd.check_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''T''
                               )
                           )
                       AND gcd.bank_cd = NVL ('''||p_bank_cd||''', gcd.bank_cd)
                       AND gbac.bank_acct_no = NVL ('''||p_bank_acct_no||''', gbac.bank_acct_no)
                    UNION
                    SELECT gdv.currency_cd, 0 unreleased_amt, 0 check_amt, gdv.dv_date dv_date,
                           ga.gfun_fund_cd, ga.gibr_branch_cd, gb.branch_name, gsc.bank_cd,
                           gba.bank_name, gsc.bank_acct_cd, gbac.bank_acct_no,
                           gsc.check_date check_date,
                           TO_CHAR (gsc.check_date, ''YYYY-MM-DD'') view_check_date,
                              DECODE (gsc.check_pref_suf,
                                      NULL, NULL,
                                      gsc.check_pref_suf || ''-''
                                     )
                           || gsc.check_no dsp_check_no,
                              gsc.check_pref_suf
                           || ''-''
                           || TO_CHAR (gsc.check_no, ''0000000000'') view_check_no,
                           gdv.dv_pref || ''-'' || gdv.dv_no dv_no, gdv.ref_no ref_no,
                           gdv.dv_pref || ''-'' || TO_CHAR (gdv.dv_no, ''0000000000'') view_dv_no,
                           ga.posting_date posting_date, 0 dv_amt,
                           DECODE (gsc.check_pref_suf || gsc.check_no
                                   || TO_CHAR (gsc.gacc_tran_id),
                                   gcd.check_pref_suf || gcd.check_no
                                   || TO_CHAR (gdv.gacc_tran_id), ''CANCELLED'',
                                   ''SPOILED''
                                  ) particulars,
                           TO_DATE(''01-01-2000'', ''MM-DD-YYYY'') release_date, '-- Edited By MArkS 05.04.2016 SR-5197 error in changing when inserting the record into the table_type
                           ||'''DUMMY'' released_by, gdv.dv_flag,
                           gsc.check_pref_suf, gsc.check_no, ga.tran_id, gcd.batch_tag,
                           NVL (gcd.disb_mode, ''C'') disb_mode, gdv.particulars gdv_particulars
                      FROM giac_disb_vouchers gdv,
                           giac_acctrans ga,
                           giac_spoiled_check gsc,
                           giac_branches gb,
                           giac_chk_disbursement gcd,
                           giac_banks gba,
                           giac_bank_accounts gbac
                     WHERE gsc.gacc_tran_id = ga.tran_id
                       AND gsc.gacc_tran_id = gdv.gacc_tran_id
                       AND gcd.gacc_tran_id = gdv.gacc_tran_id
                       AND ga.gfun_fund_cd = gb.gfun_fund_cd
                       AND ga.gibr_branch_cd = gb.branch_cd
                       AND gsc.bank_cd = gba.bank_cd
                       AND gsc.bank_acct_cd = gbac.bank_acct_cd
                       AND gba.bank_cd = gbac.bank_cd
                       AND ga.gibr_branch_cd = NVL ('''||p_branch||''', ga.gibr_branch_cd)
                       AND EXISTS (
                              SELECT ''X''
                                FROM TABLE (security_access.get_branch_line (''AC'',
                                                                             ''GIACS135'',
                                                                             '''||p_user_id||'''
                                                                            )
                                           )
                               WHERE branch_cd = ga.gibr_branch_cd)
                       AND (   (    TRUNC (ga.posting_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''P''
                               )
                            OR (    TRUNC (gsc.check_date) BETWEEN '''||p_begin_date||''' AND '''||p_end_date||'''
                                AND '''||p_post_tran_toggle||''' = ''T''
                               )
                           )
                       AND gsc.bank_cd = NVL ('''||p_bank_cd||''', gsc.bank_cd)
                       AND gbac.bank_acct_no = NVL ('''||p_bank_acct_no||''', gbac.bank_acct_no) 
                     ORDER BY GIBR_BRANCH_CD, BANK_CD, BANK_ACCT_NO, DISB_MODE, '|| p_order_by;
                       
      EXECUTE IMMEDIATE v_select BULK COLLECT INTO rec1;
      IF rec1.LAST > 0 THEN
          FOR i IN rec1.FIRST .. rec1.LAST
          LOOP
             rec_cr.branch := rec1(i).branch_name;
             rec_cr.bank := rec1(i).bank_name;
             rec_cr.bank_account_no := rec1(i).bank_acct_no;
             rec_cr.payee := rec1(i).particulars;
             rec_cr.date_posted := rec1(i).posting_date;
             rec_cr.dv_date := rec1(i).dv_date;
             rec_cr.dv_number := rec1(i).dv_no;
             rec_cr.check_date := rec1(i).check_date;
             rec_cr.check_no := rec1(i).dsp_check_no;
             rec_cr.check_amount := rec1(i).check_amt;
             rec_cr.date_released := rec1(i).release_date;
             rec_cr.unreleased_amount := rec1(i).unreleased_amt;

             IF rec1(i).disb_mode = 'B'
             THEN
                rec_cr.disbursement := 'BANK TRANSFER';
             ELSE
                rec_cr.disbursement := 'CHECK';
             END IF;

             IF rec1(i).batch_tag = 'Y'
             THEN
                rec_cr.batch_tag := '*';
             ELSE
                rec_cr.batch_tag := NULL;
             END IF;
             --added by robert SR 5197 02.02.2016
             IF rec1(i).check_amt = 0
             THEN
                rec_cr.date_released := NULL;
             ELSE
                rec_cr.date_released := rec1(i).release_date;
             END IF;
             --end robert
             PIPE ROW (rec_cr);
          END LOOP;
      END IF;

      RETURN;
   END;

    /* start - Gzelle 12022015 SR19822 CSV for GIACR168A */ 
    FUNCTION officialreceiptsregister_ap_a (
       p_date        VARCHAR2,
       p_date2       VARCHAR2,
       p_branch_cd   VARCHAR2,
       p_posted      VARCHAR2,
       p_user_id     VARCHAR2,
       p_or_tag      VARCHAR2
    )
       RETURN orr_type3 PIPELINED
    IS
       rec_or   orr_rec_type3;
    BEGIN
       FOR x IN (SELECT *
                   FROM TABLE (giacr168a_pkg.get_giacr168a_all_rec (p_date,
                                                                    p_date2,
                                                                    p_branch_cd,
                                                                    p_user_id,
                                                                    p_posted,
                                                                    p_or_tag
                                                                   )
                              ))
       LOOP
          rec_or.branch           := x.branch;
          rec_or.or_no            := x.or_number;
          rec_or.or_date          := x.or_date;
          rec_or.tran_date        := x.tran_date;
          rec_or.posting_date     := x.posting_date;
          rec_or.payor            := x.payor;
          rec_or.amount_received  := x.amt_received;
          rec_or.premium          := x.prem_amt;
          rec_or.vat_tax_amt      := x.vat_tax_amt;
          rec_or.lgt_tax_amt      := x.lgt_tax_amt;
          rec_or.dst_tax_amt      := x.dst_tax_amt;
          rec_or.fst_tax_amt      := x.fst_tax_amt;
          rec_or.other_tax_amt    := x.other_tax_amt;
          rec_or.currency         := x.currency;
          rec_or.foreign_currency := x.foreign_curr_amt;
          
          PIPE ROW (rec_or);
       END LOOP;
    END;
   /* end - Gzelle 12022015 SR19822 CSV for GIACR168A */
    
END;
/
