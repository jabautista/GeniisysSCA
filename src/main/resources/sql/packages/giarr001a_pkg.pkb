CREATE OR REPLACE PACKAGE BODY CPI.giarr001a_pkg     
AS
   /*
   Created by: John Carlo M. Brigino
   September 26, 2012
   */
   FUNCTION get_giarr001a_details2 (
      p_fund_cd      giac_colln_batch.fund_cd%TYPE,
      p_branch_cd    giac_colln_batch.branch_cd%TYPE,
      p_cashier_cd   giac_order_of_payts.cashier_cd%TYPE,
      p_dcb_no       giac_colln_batch.dcb_no%TYPE,
      p_tran_dt      giac_colln_batch.tran_date%TYPE
   )
      RETURN giarr001a_daily_coll_rep_tab2 PIPELINED
   IS
      v_giarr001a          giarr001a_daily_coll_rep_type;
      --for title
      v_fund_cd            giac_colln_batch.fund_cd%TYPE;
      v_branch_cd          giac_colln_batch.branch_cd%TYPE;
      v_dcb_year           giac_colln_batch.dcb_year%TYPE;
      v_dcb_no             giac_colln_batch.dcb_no%TYPE;
      --for main2
      v_or_no_b            VARCHAR (2000);
      v_or_flag_b          giac_order_of_payts.or_flag%TYPE;
      v_particulars_b      VARCHAR2 (2000);
      v_payor_b            giac_order_of_payts.payor%TYPE;
      v_gacc_tran_id_b     giac_order_of_payts.gacc_tran_id%TYPE;
      v_intm_no_b          giac_order_of_payts.intm_no%TYPE;
      v_or_date_b          giac_order_of_payts.or_date%TYPE;
      v_or_type_b          giac_or_pref.or_type%TYPE;
      --detail2
      v_gacc_tran_id_b1    giac_collection_dtl.gacc_tran_id%TYPE;
      v_gross_amt_b        giac_collection_dtl.gross_amt%TYPE;
      v_amount_b1          giac_collection_dtl.amount%TYPE;
      v_chk_no_b           VARCHAR2 (2000);
      v_commission_amt_b   giac_collection_dtl.commission_amt%TYPE;
      v_vat_amt_b          giac_collection_dtl.vat_amt%TYPE;
      v_currency_cd_b      giac_collection_dtl.currency_cd%TYPE;
      v_fcurrency_amt_b    giac_collection_dtl.fcurrency_amt%TYPE;
      v_pay_mode_b         giac_collection_dtl.pay_mode%TYPE;
   BEGIN
      FOR x IN (SELECT fund_cd, branch_cd, dcb_year, dcb_no
                  FROM giac_colln_batch
                 WHERE TRUNC (tran_date) = NVL (p_tran_dt, tran_date)
                   AND dcb_no = NVL (p_dcb_no, dcb_no)
                   AND fund_cd = NVL (p_fund_cd, fund_cd)
                   AND branch_cd = NVL (p_branch_cd, branch_cd))
      LOOP
         v_fund_cd := x.fund_cd;
         v_branch_cd := x.branch_cd;
         v_dcb_year := x.dcb_year;
         v_dcb_no := x.dcb_no;
      END LOOP;
      v_giarr001a.dcb_no := v_dcb_no;
      
      --main2/footer
      FOR x IN (SELECT      A.or_pref_suf
                         || TO_CHAR (A.or_no, '0999999999')
                         || A.or_tag or_no_b,
                         A.or_flag or_flag_b,
                         DECODE (A.or_flag,
                                 'C', 'CANCELLED',
                                 A.particulars
                                ) particulars_b,
                         payor payor_b, A.gacc_tran_id, A.intm_no intm_no_b,
                         A.or_date or_date_b, b.or_type or_type_b,
                         c.gacc_tran_id gacc_tran_id_b1,
                         c.gross_amt gross_amt_b, c.amount amount_b1,
                         DECODE (d.bank_sname,
                                 NULL, NULL,
                                    d.bank_sname
                                 || DECODE (c.check_no,
                                            NULL, NULL,
                                            '-' || c.check_no
                                           )
                                ) chk_no_b,
                         c.commission_amt commission_amt_b,
                         c.vat_amt vat_amt_b, c.currency_cd currency_cd_b,
                         c.fcurrency_amt fcurrency_amt_b,
                         c.pay_mode pay_mode_b
                    FROM giac_order_of_payts A,
                         giac_or_pref b,
                         giac_collection_dtl c,
                         giac_banks d
                   WHERE A.gibr_gfun_fund_cd = b.fund_cd(+)
                     AND A.gibr_branch_cd = b.branch_cd(+)
                     AND A.or_pref_suf = b.or_pref_suf(+)
                     AND c.bank_cd = d.bank_cd(+)
                     AND or_flag IS NOT NULL
                     AND cancel_dcb_no = NVL (p_dcb_no, dcb_no)
                     AND TRUNC (or_date) = TRUNC (NVL (p_tran_dt, or_date))
                     AND gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                     AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                     AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
                     AND c.gacc_tran_id = A.gacc_tran_id
                     AND DECODE(a.or_flag, 'C', DECODE(TRUNC(p_tran_dt), TRUNC(a.cancel_date), 'Y', 'N'), 'N') = 'Y' --marco - 02.11.2015 - SR 3298
                ORDER BY or_no)
      LOOP
         v_or_no_b := x.or_no_b;
         v_or_flag_b := x.or_flag_b;
         v_particulars_b := x.particulars_b;
         v_gacc_tran_id_b := x.gacc_tran_id;
         v_intm_no_b := x.intm_no_b;
         v_or_date_b := x.or_date_b;
         v_or_type_b := x.or_type_b;
         v_payor_b := x.payor_b;
         v_fcurrency_amt_b := x.fcurrency_amt_b;
         v_gross_amt_b := x.gross_amt_b;
         v_currency_cd_b := x.currency_cd_b;
         v_commission_amt_b := x.commission_amt_b;
         v_vat_amt_b := x.vat_amt_b;
         v_giarr001a.or_no_b1 := v_or_no_b;
         v_giarr001a.particulars_b1 := v_particulars_b;
         v_giarr001a.or_date_b := v_or_date_b;
         v_giarr001a.payor_b1 := v_payor_b;
         v_giarr001a.intm_no_b1 := v_intm_no_b;
         v_giarr001a.gross_amt_b1 := NVL (v_gross_amt_b, 0);
         v_giarr001a.comm_amt_b1 := NVL (v_commission_amt_b, 0);
         v_giarr001a.vat_amt_b1 := NVL (v_vat_amt_b, 0);
         v_giarr001a.amount_recvd_b1 := NVL (v_amount_b1, 0);
         v_giarr001a.pay_mode_b1 := v_pay_mode_b;
         v_giarr001a.fcurrency_b1_amt := NVL (v_fcurrency_amt_b, 0);
         v_giarr001a.fcurrency_recvd_ab1 := NVL (v_fcurrency_amt_b, 0);

         SELECT short_name
           INTO v_giarr001a.fcurrency_b1
           FROM giis_currency
          WHERE main_currency_cd = v_currency_cd_b;

         PIPE ROW (v_giarr001a);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_giarr001a_details (
      p_fund_cd      giac_colln_batch.fund_cd%TYPE,
      p_branch_cd    giac_colln_batch.branch_cd%TYPE,
      p_cashier_cd   giac_order_of_payts.cashier_cd%TYPE,
      p_dcb_no       giac_colln_batch.dcb_no%TYPE,
      p_dcb_year              giac_colln_batch.dcb_year%TYPE,
      p_tran_dt      giac_colln_batch.tran_date%TYPE,
      p_user_id      giis_users.user_id%TYPE
   )
      RETURN giarr001a_daily_coll_rep_tab PIPELINED
   IS
      v_giarr001a               giarr001a_daily_coll_rep_type;
      v_address                 VARCHAR2 (2000);
      --for title
      v_fund_cd                 giac_colln_batch.fund_cd%TYPE;
      v_branch_cd               giac_colln_batch.branch_cd%TYPE;
      v_dcb_year                giac_colln_batch.dcb_year%TYPE;
      v_dcb_no                  giac_colln_batch.dcb_no%TYPE;
      --for paymode_cc
      v_pay_mode_cc             giac_collection_dtl.pay_mode%TYPE;
      v_sum_total_amt_cc        giac_collection_dtl.amount%TYPE;
      v_p_mode_cc               VARCHAR2 (2000);
      --for paymode
      v_pay_mode_pm             giac_collection_dtl.pay_mode%TYPE;
      v_sum_total_amt           VARCHAR2 (2000);
      v_p_mode                  VARCHAR2 (2000);
      --for main2
      v_or_no_b                 giac_order_of_payts.or_tag%TYPE;
      v_or_flag_b               giac_order_of_payts.or_flag%TYPE;
      v_particulars_b           VARCHAR2 (2000);
      v_payor_b                 giac_order_of_payts.payor%TYPE;
      v_gacc_tran_id_b          giac_order_of_payts.gacc_tran_id%TYPE;
      v_intm_no_b               giac_order_of_payts.intm_no%TYPE;
      v_or_date_b               giac_order_of_payts.or_date%TYPE;
      v_or_type_b               giac_or_pref.or_type%TYPE;
      --for main
      v_exist                   VARCHAR (2000);
      v_or_no                   VARCHAR2 (2000);
      v_or_no_temp              VARCHAR2 (2000) := NULL;-- added by steven 5.22.2013
      v_or_no_temp2             VARCHAR2 (2000) := NULL;-- added by steven 5.22.2013
      v_or_no_temp3             VARCHAR2 (2000) := NULL;-- added by steven 5.22.2013
      v_or_no_temp4             VARCHAR2 (2000) := NULL;-- added by steven 5.22.2013
      v_or_flag                 giac_order_of_payts.or_flag%TYPE;
      v_particulars             VARCHAR2 (2000);
      v_particulars_temp        VARCHAR2 (2000) := NULL;-- added by steven 5.22.2013
      v_payor                   giac_order_of_payts.payor%TYPE;
      v_payor_temp              giac_order_of_payts.payor%TYPE := NULL;-- added by steven 5.22.2013
      v_gacc_tran_id            giac_order_of_payts.gacc_tran_id%TYPE;
      v_intm_no                 giac_order_of_payts.intm_no%TYPE;
      v_cancel_date             giac_order_of_payts.cancel_date%TYPE;
      v_dcb_no_b                giac_order_of_payts.dcb_no%TYPE;
      v_or_date                 giac_order_of_payts.or_date%TYPE;
      v_cancel_dcb_no           giac_order_of_payts.cancel_dcb_no%TYPE;
      v_or_type                 giac_or_pref.or_type%TYPE;
      v_cs_no                   VARCHAR (2000);
      --detail2
      v_gacc_tran_id_b1         giac_collection_dtl.gacc_tran_id%TYPE;
      v_gross_amt_b             giac_collection_dtl.gross_amt%TYPE;
      v_amount_b1               giac_collection_dtl.amount%TYPE;
      v_chk_no_b                VARCHAR2 (2000);
      v_commission_amt_b        giac_collection_dtl.commission_amt%TYPE;
      v_vat_amt_b               giac_collection_dtl.vat_amt%TYPE;
      v_currency_cd_b           giac_collection_dtl.currency_cd%TYPE;
      v_fcurrency_amt_b         giac_collection_dtl.fcurrency_amt%TYPE;
      v_pay_mode_b              giac_collection_dtl.pay_mode%TYPE;
      --detail
      v_gacc_tran_id_det        giac_collection_dtl.gacc_tran_id%TYPE;
      v_gross_amt1              giac_collection_dtl.gross_amt%TYPE;
      v_amount                  giac_collection_dtl.amount%TYPE;
      v_chk_no                  VARCHAR2 (2000);
      v_commission_amt          giac_collection_dtl.commission_amt%TYPE;
      v_vat_amt                 giac_collection_dtl.vat_amt%TYPE;
      v_currency_cd             giac_collection_dtl.currency_cd%TYPE;
      v_fcurrency_amt           giac_collection_dtl.fcurrency_amt%TYPE;
      v_pay_mode                giac_collection_dtl.pay_mode%TYPE;
      v_check_date              giac_collection_dtl.check_date%TYPE;
      --for currency
      v_fcurr_tot               giac_collection_dtl.fcurrency_amt%TYPE;
      v_currency_desc           giis_currency.currency_desc%TYPE;
      --for accts
      v_acct_no                 VARCHAR2 (2000);
      v_acct_no_temp            VARCHAR2 (2000)                       := NULL; --added by steven 5.22.2013
      v_pay_mode_desc           VARCHAR2 (2000);
      v_branch_bank             giac_bank_accounts.branch_bank%TYPE;
      v_sum_deposit_amt         VARCHAR2 (2000);
      --label
      v_label                   giac_rep_signatory.LABEL%TYPE;
      v_signatory               giis_signatory_names.signatory%TYPE;
      --v_designation       GIIS_SIGNATORY_NAMES.DESIGNATION%TYPE;
      v_item_no                 giac_rep_signatory.item_no%TYPE;
      v_temp                    NUMBER;
      v_num_vat                 NUMBER;
      v_num_non_vat             NUMBER;
      v_num_misc                NUMBER;
      v_num_spoiled             NUMBER;
      v_num_cancelled           NUMBER;
      v_num_unprinted           NUMBER;
      v_num_spoiled_cancelled   NUMBER;
   --v_fcurrency1        VARCHAR(2000);
   BEGIN
      v_giarr001a.exist_cond := 'N';
      --FOR TITLE
      FOR x IN (SELECT fund_cd, branch_cd, dcb_year, dcb_no
                  FROM giac_colln_batch
                 WHERE TRUNC (tran_date) = NVL (p_tran_dt, tran_date)
                   AND dcb_no = NVL (p_dcb_no, dcb_no)
                   AND fund_cd = NVL (p_fund_cd, fund_cd)
                   AND branch_cd = NVL (p_branch_cd, branch_cd))
      LOOP
         v_fund_cd := x.fund_cd;
         v_branch_cd := x.branch_cd;
         v_dcb_year := x.dcb_year;
         v_dcb_no := x.dcb_no;
      END LOOP;
      
      --added by steven 07.24.2014
--       FOR c IN -- bonok :: 10.17.2014 :: para sa print all cashier
--          (SELECT dcb_user_id
--             FROM giac_dcb_users
--            WHERE cashier_cd = NVL(p_cashier_cd, cashier_cd)
--              AND gibr_fund_cd = p_fund_cd         
--              AND gibr_branch_cd = p_branch_cd)     
--       LOOP
--          v_giarr001a.dcb_user_id := c.dcb_user_id;
--       END LOOP;

      v_giarr001a.fund_cd := v_fund_cd;
      v_giarr001a.branch_cd := v_branch_cd;
      v_giarr001a.dcb_year := v_dcb_year;
      v_sum_deposit_amt := '';
      v_temp := 0;
      v_giarr001a.dcb_no := LPAD(v_dcb_no, 4, '0');
      --v_giarr001a.tran_date := p_tran_dt;                           -- Start dren 06.15.2015 : SR 0018479
      v_giarr001a.tran_date := TO_CHAR(p_tran_dt,'Fm Month DD, YYYY');
      v_giarr001a.run_date  := TO_CHAR(SYSDATE,'Fm Month DD, YYYY');
      v_giarr001a.run_time  := TO_CHAR(SYSDATE,'HH12:MI:SS AM');      -- End dren 06.15.2015
      v_pay_mode_desc := NULL;
      v_sum_deposit_amt := NULL;
      --Moved codes here by pjsantos 12/16/2016, GENQA 5827      
      IF v_branch_cd IS NULL OR v_branch_cd = ''
      THEN
         v_branch_cd := p_branch_cd;
      END IF;

      IF v_fund_cd IS NULL OR v_fund_cd = ''
      THEN
         v_fund_cd := p_fund_cd;
      END IF;
      
      SELECT branch_name
        INTO v_giarr001a.branch
        FROM giac_branches
       WHERE branch_cd = NVL (v_branch_cd, p_branch_cd)
         AND gfun_fund_cd = NVL (v_fund_cd, p_fund_cd);

      SELECT param_value_v
        INTO v_giarr001a.comp_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      SELECT param_value_v
        INTO v_giarr001a.comp_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';
      

      FOR U IN (SELECT designation, user_name
                  FROM giac_users
                 WHERE user_id = p_user_id)
      LOOP
         v_giarr001a.cf_designation := U.designation;
         v_giarr001a.user_name := U.user_name;
      END LOOP;
      FOR c IN (SELECT dcb_user_id 
                     FROM giac_dcb_users
                    WHERE cashier_cd = p_cashier_cd 
                      AND gibr_fund_cd = p_fund_cd         
                      AND gibr_branch_cd = p_branch_cd)     
         LOOP
            v_giarr001a.dcb_user_id := c.dcb_user_id;
         END LOOP;
         
        SELECT COUNT (*)
           INTO v_giarr001a.cancelled_count
           FROM (SELECT      A.or_pref_suf
                          || TO_CHAR (A.or_no, '0999999999')
                          || A.or_tag or_no_b,
                          A.or_flag or_flag_b,
                          DECODE (A.or_flag,
                                  'C', 'CANCELLED',
                                  A.particulars
                                 ) particulars_b,
                          payor payor_b, A.gacc_tran_id, A.intm_no intm_no_b,
                          A.or_date or_date_b, b.or_type or_type_b,
                          c.gacc_tran_id gacc_tran_id_b1,
                          c.gross_amt gross_amt_b, c.amount amount_b1,
                          DECODE (d.bank_sname,
                                  NULL, NULL,
                                     d.bank_sname
                                  || DECODE (c.check_no,
                                             NULL, NULL,
                                             '-' || c.check_no
                                            )
                                 ) chk_no_b,
                          c.commission_amt commission_amt_b,
                          c.vat_amt vat_amt_b, c.currency_cd currency_cd_b,
                          c.fcurrency_amt fcurrency_amt_b,
                          c.pay_mode pay_mode_b
                     FROM giac_order_of_payts A,
                          giac_or_pref b,
                          giac_collection_dtl c,
                          giac_banks d
                    WHERE A.gibr_gfun_fund_cd = b.fund_cd(+)
                      AND A.gibr_branch_cd = b.branch_cd(+)
                      AND A.or_pref_suf = b.or_pref_suf(+)
                      AND c.bank_cd = d.bank_cd(+)
                      AND or_flag IS NOT NULL
                      AND cancel_dcb_no = NVL (p_dcb_no, dcb_no)
                      AND TRUNC (or_date) = TRUNC (NVL (p_tran_dt, or_date))
                      AND gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                      AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                      AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
                      AND c.gacc_tran_id = A.gacc_tran_id
                 ORDER BY or_no);
      --pjsantos end
      
      
      -- FOR ACCT_NO/PAY_MODE_B1
      FOR x IN (SELECT      d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no acct_no,
                         E.pay_mode || ' - ' || f.rv_meaning pay_mode_desc,
                         c.branch_bank, SUM (E.amount) deposit
                    FROM giac_acctrans A,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_dcb_bank_dep E,
                         cg_ref_codes f
                   WHERE A.tran_id = E.gacc_tran_id
                     AND A.tran_flag <> 'D'                  --roset, 07212010
                     AND c.bank_cd = E.bank_cd
                     AND c.bank_acct_cd = E.bank_acct_cd
                     AND d.bank_cd = c.bank_cd
                     AND E.pay_mode = f.rv_low_value
                     AND UPPER (f.rv_domain) = 'GIAC_DCB_BANK_DEP.PAY_MODE'
                     AND A.gfun_fund_cd = NVL (p_fund_cd, A.gfun_fund_cd)
                     AND A.gibr_branch_cd =
                                           NVL (p_branch_cd, A.gibr_branch_cd)
                     AND A.tran_class_no = NVL (p_dcb_no, A.tran_class_no)
--                   AND TRUNC (a.tran_date) = TRUNC(p_tran_dt) -- comment out by rai SR 23177
                     AND TRUNC (E.dcb_date) = p_tran_dt -- added by rai SR23177
                     AND E.dcb_no = NVL (p_dcb_no, E.dcb_no)
                GROUP BY    d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no,
                         E.pay_mode || ' - ' || f.rv_meaning,
                         c.branch_bank                    --added by VJ 092106
                ORDER BY    d.bank_sname --added by steven 5.22.2013 
                         || '-'
                         || c.branch_bank 
                         || '-'
                         || c.bank_acct_no) 
      LOOP
         IF v_acct_no_temp IS NOT NULL
         THEN                                     --added by steven 5.22.2013
            IF v_acct_no_temp <> x.acct_no
            THEN
               v_acct_no_temp := x.acct_no;
               v_acct_no := v_acct_no || CHR (10) || x.acct_no;
            END IF;
         ELSE
            v_acct_no_temp := x.acct_no;
            v_acct_no := x.acct_no;
         END IF;
         
         IF v_pay_mode_desc IS NULL THEN
            v_pay_mode_desc := x.pay_mode_desc;
         ELSE
            v_pay_mode_desc := v_pay_mode_desc || CHR (10) || x.pay_mode_desc;
         END IF;
         
         IF v_sum_deposit_amt IS NULL THEN
            v_sum_deposit_amt := TO_CHAR (x.deposit, '999,999,999.99');
         ELSE
            v_sum_deposit_amt := v_sum_deposit_amt || CHR (10) || TO_CHAR (x.deposit, '999,999,999.99');
         END IF;

         v_branch_bank := x.branch_bank;
         v_temp := v_temp + x.deposit;
      END LOOP;

      v_giarr001a.pay_mode_b1 := v_pay_mode_desc;
      v_giarr001a.deposit1 := v_sum_deposit_amt;
      v_giarr001a.deposit1_total := v_temp;
      v_giarr001a.acct_no := v_acct_no;

      --CURRENCY
      v_giarr001a.fcurr_tot := NULL;
      v_giarr001a.curr_desc := NULL;
      FOR x IN (SELECT   SUM (c.fcurrency_amt) fcurr_tot, d.currency_desc
                    FROM giac_order_of_payts A,
                         giac_collection_dtl c,
                         giis_currency d
                   WHERE dcb_no = DECODE (cancel_dcb_no,
                                          NULL, dcb_no,
                                          dcb_no
                                         )
                     AND A.gacc_tran_id = c.gacc_tran_id
                     AND A.currency_cd = d.main_currency_cd
                     AND or_flag IS NOT NULL
                     AND (   (    TRUNC (or_date) = NVL (p_tran_dt, or_date)
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (    TRUNC (c.due_dcb_date) =
                                               NVL (p_tran_dt, c.due_dcb_date)
                              AND with_pdc = 'Y'
                             )
                         )
                     AND (   (    dcb_no = NVL (p_dcb_no, dcb_no)
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (    c.due_dcb_no = NVL (p_dcb_no, c.due_dcb_no)
                              AND with_pdc = 'Y'
                             )
                         )
                     AND gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                     AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                     AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
                     AND A.or_flag <> 'C'
                     AND c.pay_mode != 'CW'
                GROUP BY d.currency_desc)
      LOOP
          IF v_giarr001a.fcurr_tot IS NULL THEN
            v_giarr001a.fcurr_tot := TO_CHAR (x.fcurr_tot, '999,999,999.99');
          ELSE
            v_giarr001a.fcurr_tot := v_giarr001a.fcurr_tot|| CHR (10)|| TO_CHAR (x.fcurr_tot, '999,999,999.99');
          END IF;
          
          IF v_giarr001a.curr_desc IS NULL  THEN
            v_giarr001a.curr_desc := x.currency_desc;
          ELSE
            v_giarr001a.curr_desc := v_giarr001a.curr_desc || CHR (10) || x.currency_desc;
          END IF;
      END LOOP;

     /* IF v_branch_cd IS NULL OR v_branch_cd = ''
      THEN
         v_branch_cd := p_branch_cd;
      END IF;

      IF v_fund_cd IS NULL OR v_fund_cd = ''
      THEN
         v_fund_cd := p_fund_cd;
      END IF;

      SELECT branch_name
        INTO v_giarr001a.branch
        FROM giac_branches
       WHERE branch_cd = NVL (v_branch_cd, p_branch_cd)
         AND gfun_fund_cd = NVL (v_fund_cd, p_fund_cd);

      SELECT param_value_v
        INTO v_giarr001a.comp_address
        FROM giis_parameters
       WHERE param_name = 'COMPANY_ADDRESS';

      SELECT param_value_v
        INTO v_giarr001a.comp_name
        FROM giis_parameters
       WHERE param_name = 'COMPANY_NAME';

      FOR U IN (SELECT designation
                  FROM giac_users
                 WHERE user_id = p_user_id)
      LOOP
         v_giarr001a.cf_designation := U.designation;
      END LOOP;
      
      FOR USER IN (SELECT user_name
                  FROM giac_users
                 WHERE user_id = p_user_id)
      LOOP
        v_giarr001a.user_name := USER.user_name;
      END LOOP;*/ --Moved to top by pjsantos 12/16/2016, GENQA 5827

      v_temp := 0;

      --PAYMODE
      FOR x IN
         (SELECT   b.pay_mode, SUM (b.amount) total_amt,
                   b.pay_mode || ' - ' || c.rv_meaning p_mode
              FROM giac_order_of_payts A,
                   giac_collection_dtl b,
                   cg_ref_codes c,
                   giac_colln_batch d
             WHERE A.gacc_tran_id = b.gacc_tran_id
               AND b.pay_mode = c.rv_low_value
               AND UPPER (c.rv_domain) = 'GIAC_COLLECTION_DTL.PAY_MODE'
               AND A.gibr_gfun_fund_cd = d.fund_cd
               AND A.gibr_branch_cd = d.branch_cd
               AND TRUNC (d.tran_date) = p_tran_dt
               AND d.dcb_year = p_dcb_year    -- SR-4927 : shan 09.09.2015
               AND (   (    (TRUNC (NVL (A.cancel_date, d.tran_date)) <>
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no = A.cancel_dcb_no)
                       )
                    OR (    (TRUNC (NVL (A.cancel_date, d.tran_date)) =
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no = A.cancel_dcb_no)
                       )
                    OR (    (TRUNC (NVL (A.cancel_date, d.tran_date)) <>
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no <> A.cancel_dcb_no)
                       )
                    OR (A.cancel_date IS NULL)
                    OR (A.or_flag <> 'C')
                    OR (    (TRUNC (NVL (A.cancel_date, d.tran_date)) =
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no <> A.cancel_dcb_no)
                       )
                   )
               AND (   (A.or_flag NOT IN ('C', 'R'))
                    OR (    (A.or_flag IN ('C', 'R'))
                        AND (TRUNC (NVL (A.cancel_date, d.tran_date)) <>
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no = A.cancel_dcb_no)
                       )
                    OR (    (A.or_flag IN ('C', 'R'))
                        AND (TRUNC (NVL (A.cancel_date, d.tran_date)) <>
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no <> A.cancel_dcb_no)
                       )
                    OR (    (A.or_flag IN ('C', 'R'))
                        AND (TRUNC (NVL (A.cancel_date, d.tran_date)) =
                                                           TRUNC (d.tran_date)
                            )
                        AND (A.dcb_no <> A.cancel_dcb_no)
                       )
                   )
               AND b.pay_mode IN
                      ('CA', 'CHK', 'CM', 'PDC', 'CC') -- bonok :: 10.17.2014 :: binalik ang CC para sa FGIC
                               --issa@cic 01.24.2007 removed 'CC' to solve PRF
               AND (   (    TRUNC (A.or_date) = TRUNC (d.tran_date)
                        AND NVL (with_pdc, 'N') <> 'Y'
                       )
                    OR (    TRUNC (b.due_dcb_date) = TRUNC (d.tran_date)
                        AND with_pdc = 'Y'
                       )
                   )
               AND (   (    d.dcb_no = NVL (p_dcb_no, d.dcb_no)
                        AND NVL (with_pdc, 'N') <> 'Y'
                       )
                    OR (    b.due_dcb_no = NVL (p_dcb_no, b.due_dcb_no)
                        AND with_pdc = 'Y'
                       )
                   )
               AND (   (    TRUNC (d.tran_date) = p_tran_dt
                        AND NVL (with_pdc, 'N') <> 'Y'
                       )
                    OR (TRUNC (b.due_dcb_date) = p_tran_dt AND with_pdc = 'Y'
                       )
                   )
               AND (   (A.dcb_no = d.dcb_no AND NVL (with_pdc, 'N') <> 'Y')
                    OR (b.due_dcb_no = d.dcb_no AND with_pdc = 'Y')
                   )
               AND gibr_gfun_fund_cd = NVL (p_fund_cd, gibr_gfun_fund_cd)
               AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
               AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
               AND A.or_flag NOT IN ('C')
          GROUP BY b.pay_mode, b.pay_mode || ' - ' || c.rv_meaning)
      LOOP
         v_sum_total_amt := v_sum_total_amt || CHR (10) || TO_CHAR (x.total_amt, '999,999,999,999.99');
         v_p_mode := v_p_mode || CHR (10) || x.p_mode;
         v_temp := v_temp + x.total_amt;
      END LOOP;

      v_giarr001a.p_mode1 := v_p_mode;
      v_giarr001a.tot_cash1 := v_sum_total_amt;
      v_giarr001a.vtemp := v_temp;

      --PAYMODE_CC
      FOR x IN (SELECT   b.pay_mode, SUM (b.amount) total_amt,
                         DECODE (pay_mode,
                                 'CW', SUM (NVL (b.amount, 0))
                                  - (SUM (NVL (b.amount, 0)) * 2),
                                 SUM (NVL (b.amount, 0))
                                ),
                         b.pay_mode || ' - ' || c.rv_meaning p_mode
                    FROM giac_order_of_payts A,
                         giac_collection_dtl b,
                         cg_ref_codes c,
                         giac_colln_batch d
                   WHERE A.gacc_tran_id = b.gacc_tran_id
                     AND b.pay_mode = c.rv_low_value
                     AND UPPER (c.rv_domain) = 'GIAC_COLLECTION_DTL.PAY_MODE'
                     AND A.dcb_no = d.dcb_no
                     AND A.gibr_gfun_fund_cd = d.fund_cd
                     AND A.gibr_branch_cd = d.branch_cd
                     AND (   TRUNC (NVL (A.cancel_date, d.tran_date)) <>
                                                           TRUNC (d.tran_date)
                          OR A.cancel_date IS NULL
                         )
                     AND NVL (A.or_flag, 'C') != 'C'
                     AND TRUNC (A.or_date) = TRUNC (d.tran_date)
                     AND b.pay_mode NOT IN ('CA', 'CHK', 'CM', 'PDC')
                     AND d.dcb_no = NVL (p_dcb_no, d.dcb_no)
                     AND TRUNC (d.tran_date) = NVL (p_tran_dt, d.tran_date)
                     AND gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                     AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                     AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
                     AND TRUNC (d.tran_date) = p_tran_dt
                GROUP BY b.pay_mode, b.pay_mode || ' - ' || c.rv_meaning) 
      LOOP
         v_pay_mode_cc := x.pay_mode;
         v_giarr001a.tot_cash2/*v_sum_total_amt_cc*/ := x.total_amt; --Modified by pjsantos 12/16/2016, GENQA 5827
         v_giarr001a.p_mode2/*v_p_mode_cc*/ := x.p_mode;--Modified by pjsantos 12/16/2016, GENQA 5827
      END LOOP;

      /*v_giarr001a.p_mode2 := v_p_mode_cc;
      v_giarr001a.tot_cash2 := v_sum_total_amt_cc;*/--Moved to loop by pjsantos 12/16/2016, GENQA 5827

      /*--accts remove by steven 5.22.2013 same query in line 253
      FOR x IN (SELECT      d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no acct_no,
                         e.pay_mode || ' - ' || f.rv_meaning pay_mode_desc,
                         c.branch_bank, SUM (e.amount) deposit
                    FROM giac_acctrans a,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_dcb_bank_dep e,
                         cg_ref_codes f
                   WHERE a.tran_id = e.gacc_tran_id
                     AND a.tran_flag <> 'D'                  --roset, 07212010
                     AND c.bank_cd = e.bank_cd
                     AND c.bank_acct_cd = e.bank_acct_cd
                     AND d.bank_cd = c.bank_cd
                     AND e.pay_mode = f.rv_low_value
                     AND UPPER (f.rv_domain) = 'GIAC_DCB_BANK_DEP.PAY_MODE'
                     AND a.gfun_fund_cd = NVL (p_fund_cd, a.gfun_fund_cd)
                     AND a.gibr_branch_cd =
                                           NVL (p_branch_cd, a.gibr_branch_cd)
                     AND a.tran_class_no = NVL (p_dcb_no, a.tran_class_no)
                     AND TRUNC (a.tran_date) = p_tran_dt
                     AND e.dcb_no = NVL (p_dcb_no, e.dcb_no)
                GROUP BY    d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no,
                         e.pay_mode || ' - ' || f.rv_meaning,
                         c.branch_bank                    --added by VJ 092106
                                      )
      LOOP
         v_acct_no := x.acct_no;
         v_pay_mode_desc := v_pay_mode_desc || CHR (10) || x.pay_mode_desc;
         v_branch_bank := x.branch_bank;
         v_sum_deposit_amt := x.deposit;
      END LOOP;

      v_giarr001a.pay_mode_b1 := v_pay_mode_desc;*/

      --label
      FOR x IN (SELECT   b.LABEL, INITCAP (c.signatory) signatory,
                         INITCAP (c.designation) designation, b.item_no
                    FROM giac_documents A,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE A.report_no = b.report_no
                     AND A.report_id = b.report_id
                     AND A.report_id = 'GIARR01A'               --:p_report_id
                     AND NVL (A.branch_cd, NVL (p_branch_cd, '**')) =
                                                       NVL (p_branch_cd, '**')
                     AND b.signatory_id = c.signatory_id
                MINUS
                SELECT   b.LABEL, INITCAP (c.signatory) signatory,
                         INITCAP (c.designation) designation, b.item_no
                    FROM giac_documents A,
                         giac_rep_signatory b,
                         giis_signatory_names c
                   WHERE A.report_no = b.report_no
                     AND A.report_id = b.report_id
                     AND A.report_id = 'GIARR01A'               --:p_report_id
                     AND A.branch_cd IS NULL
                     AND EXISTS (
                            SELECT 1
                              FROM giac_documents
                             WHERE report_id = 'GIARR01A'       --:p_report_id
                               AND branch_cd = p_branch_cd)
                     AND b.signatory_id = c.signatory_id
                ORDER BY item_no        --issa@cic, added initcap and order by
                                )
      LOOP
         v_giarr001a.prep_label := x.LABEL;
         v_giarr001a.signatory := x.signatory;
         v_giarr001a.designation := x.designation;
         v_item_no := x.item_no;
      END LOOP;

      v_temp := 0;
      v_num_vat := 0;
      v_num_non_vat := 0;
      v_num_misc := 0;
      v_num_spoiled := 0;
      v_num_cancelled := 0;
      v_num_unprinted := 0;
      v_num_spoiled_cancelled := 0;

      --main
      FOR x IN (SELECT      RPAD (A.or_pref_suf, 5)
                         || LPAD (A.or_no, 10, '0')
                         || A.or_tag or_no,
                         A.or_flag,
                         DECODE (A.with_pdc,
                                 'Y', DECODE (A.or_flag,
                                              'C', 'CANCELLED',
                                              'R', 'REPLACED',
                                                 TO_CHAR (A.or_date,
                                                          'mm-dd-yyyy'
                                                         )
                                              || '/'
                                              || A.particulars
                                             ),
                                 DECODE (A.or_flag,
                                         'C', 'CANCELLED',
                                         'R', 'REPLACED',
                                         A.particulars
                                        )
                                ) particulars,
                         A.payor payor, A.gacc_tran_id gacc_tran_id,
                         TO_CHAR (A.intm_no) intm_no, A.cancel_date,
                         A.or_date, TO_CHAR (A.dcb_no) dcb_no,
                         TO_CHAR (A.cancel_dcb_no) cancel_dcb_no, b.or_type,
                         TO_CHAR (c.gacc_tran_id) gacc_tran_id2,
                         TO_CHAR (c.gross_amt) gross_amt,
                         TO_CHAR (c.amount) amount,
                         DECODE (d.bank_sname,
                                 NULL, c.check_no,
                                    d.bank_sname
                                 || DECODE (c.check_no,
                                            NULL, NULL,
                                            '-' || c.check_no
                                           )
                                ) chk_no,
                         TO_CHAR (c.commission_amt) commission_amt,
                         TO_CHAR (c.vat_amt) vat_amt,
                         TO_CHAR (c.currency_cd) currency_cd,
                         TO_CHAR (c.fcurrency_amt) fcurrency_amt, c.pay_mode,
                         c.check_date, A.op_flag, A.cashier_cd -- bonok :: 10.17.2014 :: print all cashier - FGIC
                    FROM giac_order_of_payts A,
                         giac_or_pref b,
                         giac_collection_dtl c,
                         giac_banks d
                   WHERE dcb_no = DECODE (cancel_dcb_no,
                                          NULL, dcb_no,
                                          dcb_no
                                         )
                     AND A.gacc_tran_id = c.gacc_tran_id
                     AND A.gibr_gfun_fund_cd = b.fund_cd(+)
                     AND A.gibr_branch_cd = b.branch_cd(+)
                     AND A.or_pref_suf = b.or_pref_suf(+)
                     AND or_flag IS NOT NULL
                     AND (   (    TRUNC (or_date) = NVL (p_tran_dt, or_date)
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (    TRUNC (c.due_dcb_date) =
                                               NVL (p_tran_dt, c.due_dcb_date)
                              AND with_pdc = 'Y'
                             )
                         )
                     AND (   (    dcb_no = NVL (p_dcb_no, dcb_no)
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (    c.due_dcb_no = NVL (p_dcb_no, c.due_dcb_no)
                              AND with_pdc = 'Y'
                             )
                         )
                     AND gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                     AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                     AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
                     AND c.bank_cd = d.bank_cd(+)
                     AND A.gacc_tran_id = A.gacc_tran_id
                     --MJ Fabroa 2014-11-20: To include missing OR with PDC
                     /*AND (   (    TRUNC (or_date) = NVL (p_tran_dt, or_date) 
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (    TRUNC (A.due_dcb_date) =
                                               NVL (p_tran_dt, A.due_dcb_date)
                              AND with_pdc = 'Y'
                             )
                         )
                     AND (   (    dcb_no = NVL (p_dcb_no, dcb_no)
                              AND NVL (with_pdc, 'N') <> 'Y'
                             )
                          OR (    A.due_dcb_no = NVL (p_dcb_no, A.due_dcb_no)
                              AND with_pdc = 'Y'
                             )
                         )*/
                     AND A.gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                     AND A.gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                     AND A.cashier_cd = NVL (p_cashier_cd, cashier_cd)
--                     AND DECODE(a.or_flag, 'C', DECODE(TRUNC(p_tran_dt), TRUNC(a.cancel_date), 'N', 'Y'), 'Y') = 'Y' --marco - 02.11.2015 -  SR --commented out by gab SR 23059 09.14.2016
                UNION ALL
                SELECT      RPAD (a.or_pref, 5)
                         || LPAD (a.or_no, 10, '0')
                         || a.spoil_tag or_no,
                         '', 'SPOILED', '', a.tran_id, '', SYSDATE, a.or_date, '',
                         '', '', '', '', '', '', '', '', '', '', '', SYSDATE, '', NULL
                    FROM giac_spoiled_or a,
                         giac_order_of_payts b --marco - 02.10.2015
                   WHERE NVL (TRUNC (a.or_date), TRUNC (a.spoil_date)) =
                                                      NVL (p_tran_dt, a.or_date)
                     AND fund_cd = p_fund_cd
                     AND branch_cd = p_branch_cd
                     AND a.tran_id = b.gacc_tran_id
                     AND b.cashier_cd = NVL(p_cashier_cd, b.cashier_cd) --marco - 02.10.2015                     
                ORDER BY or_no)
      LOOP 
         v_giarr001a.exist_cond := 'Y';
         v_giarr001a.gross_amt1 := NULL; --added by steven 5.22.2013
         v_giarr001a.comm_amt1 := NULL;
         v_giarr001a.fcurrency_amt := NULL;
         v_giarr001a.intm_no := NULL;
         v_giarr001a.pay_mode := NULL;
         v_giarr001a.comm_amt1 := NULL;
         v_giarr001a.misc_other_amt := NULL;
         v_giarr001a.gross_amt1 := NULL;
         v_giarr001a.cred_whtax_amt := NULL;
         v_giarr001a.vat_amt1 := NULL;
         v_giarr001a.amount_recvd2 := NULL;
         v_giarr001a.check_no1 := NULL;
         v_giarr001a.check_date := NULL;
         v_giarr001a.cs_no := NULL;
         v_giarr001a.vat_total := NULL;
         v_giarr001a.non_vat_total := NULL;
         v_giarr001a.unprinted_amt_total := NULL;
         v_giarr001a.misc_or_total := NULL;
         v_giarr001a.fcurrency1 := NULL;
         v_exist := 'N'; --Deo [08.24.2016]: SR-22978
         
         /*FOR c IN (SELECT dcb_user_id -- bonok :: 10.17.2014 :: for print all cashiers - FGIC
                     FROM giac_dcb_users
                    WHERE cashier_cd = p_cashier_cd --NVL(p_cashier_cd, x.cashier_cd) --Commented out and changed by Jerome Bautista 10.20.2015 SR 20162
                      AND gibr_fund_cd = p_fund_cd         
                      AND gibr_branch_cd = p_branch_cd)     
         LOOP
            v_giarr001a.dcb_user_id := c.dcb_user_id;
         END LOOP;*/--Moved to top by pjsantos 12/16/2016, GENQA 5827

         v_or_no := x.or_no;
         v_or_flag := x.or_flag;
         v_particulars := x.particulars;
         v_payor := x.payor;
         v_gacc_tran_id := x.gacc_tran_id;
         v_intm_no := x.intm_no;
         v_cancel_date := x.cancel_date;
         v_or_date := x.or_date;
         v_dcb_no_b := x.dcb_no;
         v_cancel_dcb_no := x.cancel_dcb_no;
         v_or_type := x.or_type;
         v_pay_mode := x.pay_mode;
         v_fcurrency_amt := x.fcurrency_amt;
         v_gacc_tran_id_det := x.gacc_tran_id;
         v_gross_amt1 := x.gross_amt;
             IF v_or_flag ='C'          -- dren 09.01.2015 SR 0018063: removed cancelled amounts - Start
                THEN v_amount := 0;
             ELSE 
                v_amount := x.amount;   
             END IF; -- dren 09.01.2015 SR 0018063: removed cancelled amounts - End
         v_chk_no := x.chk_no;
         v_commission_amt := x.commission_amt;
         v_vat_amt := x.vat_amt;
         v_currency_cd := x.currency_cd;
         v_fcurrency_amt := x.fcurrency_amt;
         v_pay_mode := x.pay_mode;
         v_check_date := x.check_date;
         
         IF v_or_no_temp IS NOT NULL
            THEN                                     --added by steven 5.22.2013
                IF v_or_no_temp <> x.or_no
                THEN
                   v_or_no_temp := x.or_no;
                   v_giarr001a.or_no1 := x.or_no;
                ELSE
                    v_giarr001a.or_no1 := NULL;
                END IF;
            
         ELSE
                v_or_no_temp := x.or_no;
                v_giarr001a.or_no1 := x.or_no;
         END IF;
         
--         IF v_particulars_temp IS NOT NULL
--            THEN                                     --added by steven 5.22.2013
--                IF v_particulars_temp <> x.particulars OR v_or_no_temp3 <> x.or_no
--                THEN
--                   v_particulars_temp := x.particulars;
--                   v_or_no_temp3 := x.or_no;
--                   v_giarr001a.particulars2 := x.particulars;
--                ELSE
--                    v_giarr001a.particulars2 := NULL;
--                END IF;
--            
--         ELSE
                v_particulars_temp := x.particulars;
                v_or_no_temp3 := x.or_no;
                v_giarr001a.particulars2 := x.particulars;
--         END IF;
         
--         IF v_payor_temp IS NOT NULL
--            THEN                                     --added by steven 5.22.2013
--                IF v_payor_temp <> x.payor OR v_or_no_temp4 <> x.or_no
--                THEN
--                   v_payor_temp := x.payor;
--                   v_or_no_temp4 := x.or_no;
--                   v_giarr001a.payor1 := x.payor;
--                ELSE
--                    v_giarr001a.payor1 := NULL;
--                END IF;  
--            
--         ELSE
                v_payor_temp := x.payor;
                v_or_no_temp4 := x.or_no;
                v_giarr001a.payor1 := x.payor;
--         END IF;

         IF v_or_flag IN ('C', 'R') AND v_particulars <> 'SPOILED'
         THEN
            IF TRUNC (v_cancel_date) <> TRUNC (v_or_date)
            THEN
               v_giarr001a.particulars2 :=
                     v_particulars
                  || ' ON '
                  || TO_CHAR (v_cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || v_cancel_dcb_no;
            ELSIF     TRUNC (v_cancel_date) = TRUNC (v_or_date)
                  AND v_dcb_no <> v_cancel_dcb_no
            THEN
               v_giarr001a.particulars2 :=
                     v_particulars
                  || ' ON '
                  || TO_CHAR (v_cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || v_cancel_dcb_no;
--            added by gab SR23059 09.14.2016
            ELSIF     TRUNC (v_cancel_date) = TRUNC (v_or_date)
                  AND v_dcb_no = v_cancel_dcb_no
            THEN
               v_giarr001a.particulars2 :=
                     v_particulars
                  || ' ON '
                  || TO_CHAR (v_cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || v_cancel_dcb_no;
            END IF;
--            end gab
         END IF;
         
         IF v_particulars NOT IN ('SPOILED')
         THEN
            v_giarr001a.gross_amt1 := NVL (v_gross_amt1, 0);
            v_giarr001a.comm_amt1 := NVL (v_commission_amt_b, 0);
            v_giarr001a.fcurrency_amt := v_fcurrency_amt;
            v_giarr001a.intm_no := LPAD(v_intm_no, 4, '0');
            v_giarr001a.pay_mode := v_pay_mode;

            -- for comm amt
            FOR A IN (SELECT gacc_tran_id
                        FROM giac_comm_payts
                       WHERE gacc_tran_id = v_gacc_tran_id)
            LOOP
               v_exist := 'Y';
            END LOOP;

            IF v_exist = 'Y'
            THEN
               IF v_or_flag IN ('C', 'R')
               THEN
                  v_giarr001a.comm_amt1 := 0.00;
               ELSE
                  v_giarr001a.comm_amt1 := NVL (v_commission_amt, 0);
               END IF;
            ELSIF v_exist = 'N'
            THEN
               IF v_or_flag IN ('C', 'R')
               THEN
                  v_giarr001a.misc_other_amt := 0.00;
               ELSE
                  v_giarr001a.misc_other_amt := NVL(v_commission_amt, 0); --Modified by pjsantos 12/16/2016, added NVL GENQA 5827 
               END IF;
            END IF;

            SELECT short_name
              INTO v_giarr001a.fcurrency1
              FROM giis_currency
             WHERE main_currency_cd = v_currency_cd;
         END IF;
         
         IF v_particulars NOT IN ('SPOILED')
         THEN
            -- for credit whtax amount
            IF v_pay_mode = 'CW' AND v_or_flag NOT IN ('C', 'R')
            THEN
               v_giarr001a.gross_amt1 := v_gross_amt1;
               v_giarr001a.cred_whtax_amt := v_gross_amt1;
            ELSE
               v_giarr001a.cred_whtax_amt := 0.00;
            END IF;

            -- for vat amt
            IF v_or_flag IN ('C', 'R')
            THEN
               v_giarr001a.vat_amt1 := 0.00;
            ELSE
               v_giarr001a.vat_amt1 := NVL (v_vat_amt, 0);
            END IF;

            IF     v_or_flag IN ('C', 'R')--added by steven 5.21.2013
               AND TRUNC (v_or_date) <> TRUNC (v_cancel_date)
            THEN                                   
               v_amount := v_amount;
            ELSIF     v_or_flag IN ('C', 'R')
                  AND (TRUNC (v_or_date) = TRUNC (v_cancel_date))
                  AND (v_dcb_no_b <> v_cancel_dcb_no)
            THEN
               v_amount := v_amount;
            ELSIF     v_or_flag IN ('C', 'R')
                  AND (TRUNC (v_or_date) = TRUNC (v_cancel_date))
                  AND (v_dcb_no_b = v_cancel_dcb_no)
            THEN
               v_amount := 0;
            ELSIF     v_or_flag IN ('C', 'R')
                  AND (TRUNC (v_or_date) = TRUNC (v_cancel_date))
            THEN
               v_amount := 0;
            ELSIF v_pay_mode = 'CW'
            THEN
               v_amount := v_giarr001a.gross_amt1 - v_giarr001a.cred_whtax_amt;
            ELSE
               v_amount := v_amount;
            END IF;
            v_giarr001a.amount_recvd2 := v_amount;
         END IF;

         IF v_particulars NOT IN ('SPOILED')
         THEN
            v_giarr001a.check_no1 := v_chk_no;
            v_giarr001a.check_date := v_check_date;
         END IF;

         -- total number of vat
         IF     (v_or_type = 'V')
            AND (v_particulars NOT IN ('SPOILED'))
            AND (v_or_flag <> 'C')
            AND (v_or_flag <> 'N')
            AND (v_or_flag <> 'R')
         THEN
         
            IF v_or_no_temp2 IS NOT NULL
            THEN                                     --added by steven 5.22.2013
                IF v_or_no_temp2 <> x.or_no
                THEN
                   v_or_no_temp2 := x.or_no;
                   v_num_vat := v_num_vat + 1;
                END IF;
            
            ELSE
                v_or_no_temp2 := x.or_no;
                v_num_vat := v_num_vat + 1;
             END IF;
         END IF;

         -- total number of non vat
         IF     (v_or_type = 'N')
            AND (v_particulars NOT IN ('SPOILED'))
            AND (v_or_flag <> 'C')
            AND (v_or_flag <> 'N')
            AND (v_or_flag <> 'R')
         THEN
            --edited by MarkS 9.2.2016 SR23000
            If v_giarr001a.or_no1 IS NOT NULL THEN
                v_num_non_vat := v_num_non_vat + 1;
            END IF;
            --END SR23000
         END IF;

         -- for number of misc
         IF     (v_or_type = 'M')
            AND (v_particulars NOT IN ('SPOILED'))
            AND (v_or_flag <> 'C')
            AND (v_or_flag <> 'N')
            AND (v_or_flag <> 'R')
         THEN
            --edited by MarkS 9.2.2016 SR23000
            If v_giarr001a.or_no1 IS NOT NULL THEN
                v_num_misc := v_num_misc + 1;
            END IF;
            --END SR23000
         END IF;

         -- for number pf spoiled
         IF v_particulars = 'SPOILED'
         THEN
            ---     RETURN :gacc_tran_id;
            --edited by MarkS 9.2.2016 SR23000
            If v_giarr001a.or_no1 IS NOT NULL THEN
                v_num_spoiled := v_num_spoiled + 1;
            END IF;
            --END SR23000
         END IF;

         -- for number of spoiled/cancelled
         IF v_or_flag IN ('C','R')
         THEN
            --RETURN :gacc_tran_id;
            --edited by MarkS 9.2.2016 SR23000
            If v_giarr001a.or_no1 IS NOT NULL THEN
                v_num_cancelled := v_num_cancelled + 1;
            END IF;
            --END SR23000
         END IF;

         -- for number of unprinted
         IF (v_or_flag = 'N') AND (v_particulars NOT IN ('SPOILED'))
         THEN
            --commented out by gab 10.3.2016 SR 23059
            --edited by MarkS 9.2.2016 SR23000
--            If v_giarr001a.or_no1 IS NOT NULL THEN
                v_num_unprinted := v_num_unprinted + 1;
--            END IF;
            --END SR23000
            --end gab
         END IF;

         -- for spoiled/cancelled
         IF v_or_flag = 'C' OR v_particulars = 'SPOILED'
         THEN
            --commented out by gab 10.3.2016 SR 23059
            --edited by MarkS 9.2.2016 SR23000
--            If v_giarr001a.or_no1 IS NOT NULL THEN
                v_num_spoiled_cancelled := v_num_spoiled_cancelled + 1;
--            END IF;
            --END SR23000
            --end gab
         END IF;

         IF v_particulars NOT IN ('SPOILED')
         THEN
            -- for misc amt
            IF     (v_or_type = 'M')
               AND (v_particulars NOT IN ('SPOILED'))
               AND (v_or_flag <> 'N')
            THEN
               v_giarr001a.misc_other_amt := NVL(x.amount,0);--Modified by pjsantos 12/16/2016, added NVL GENQA 5827
            /*ELSE
               IF v_pay_mode = 'CC' AND v_or_flag NOT IN ('C', 'R') THEN
                  v_giarr001a.comm_amt1 := 0.00;
                  v_giarr001a.misc_other_amt := v_commission_amt;
               ELSE    
                  v_giarr001a.misc_other_amt := 0;
              END IF;*/ --Deo [08.24.2016]: commented out, already handled above (SR-22978)
            END IF;

            -- for CS No
            FOR A IN (SELECT comm_slip_pref, comm_slip_no
                        FROM giac_comm_slip_ext
                       WHERE gacc_tran_id = v_gacc_tran_id)
            --AND to_char(intm_no, '0999') = :intm_no) --issa, comment-out, 03.15.2005,
                                                                             --to return the cfs pref and cfs no. if the intm_no is modified after an OR was issued
            LOOP
               v_cs_no := A.comm_slip_pref || '-' || A.comm_slip_no;
            END LOOP;

            IF v_cs_no IS NOT NULL
            THEN
               v_giarr001a.cs_no := v_cs_no;
            ELSE
               v_giarr001a.cs_no := NULL;
            END IF;
         END IF;

         -- computation for total amount received
         IF v_particulars NOT IN ('SPOILED')
         THEN
            -- for vat OR amount
            IF     (v_or_type = 'V')
               AND (v_particulars NOT IN ('SPOILED'))
               AND (v_or_flag <> 'N')
            THEN
               v_giarr001a.vat_total := v_amount;
            ELSE
               v_giarr001a.vat_total := 0;
            END IF;

            -- for non vat OR amount
            IF     (v_or_type = 'N')
               AND (v_particulars NOT IN ('SPOILED'))
               AND (v_or_flag <> 'N')
            THEN
               v_giarr001a.non_vat_total := v_amount;
            ELSE
               v_giarr001a.non_vat_total := 0;
            END IF;

            -- for misc OR amount
            IF     (v_or_type = 'M')
               AND (v_particulars NOT IN ('SPOILED'))
               AND (v_or_flag <> 'N')
            THEN
               v_giarr001a.misc_or_total := v_amount;
            ELSE
               v_giarr001a.misc_or_total := 0;
            END IF;

            -- for unprinted formula
            IF (v_or_flag = 'N') AND (v_particulars NOT IN ('SPOILED'))
            THEN
               v_giarr001a.unprinted_amt_total := v_amount;
            ELSE
               v_giarr001a.unprinted_amt_total := 0;
            END IF;
         END IF;

         v_giarr001a.num_vat := v_num_vat;
         v_giarr001a.num_non_vat := v_num_non_vat;
         v_giarr001a.num_misc := v_num_misc;
         v_giarr001a.num_spoiled := v_num_spoiled;
         v_giarr001a.num_cancelled := v_num_cancelled;
         v_giarr001a.num_unprinted := v_num_unprinted;
         v_giarr001a.num_spoiled_cancelled := v_num_spoiled_cancelled;
         
         IF v_particulars IN ('CANCELLED') OR v_or_flag IN ('C') THEN -- bonok :: 10.17.2014 :: set amounts to 0 if cancelled
            v_giarr001a.gross_amt1 := 0;
            v_giarr001a.fcurrency_amt := 0;
            v_giarr001a.amount_recvd2 := 0;
         END IF;

         -- for cancelled records
        /* SELECT COUNT (*)
           INTO v_giarr001a.cancelled_count
           FROM (SELECT      A.or_pref_suf
                          || TO_CHAR (A.or_no, '0999999999')
                          || A.or_tag or_no_b,
                          A.or_flag or_flag_b,
                          DECODE (A.or_flag,
                                  'C', 'CANCELLED',
                                  A.particulars
                                 ) particulars_b,
                          payor payor_b, A.gacc_tran_id, A.intm_no intm_no_b,
                          A.or_date or_date_b, b.or_type or_type_b,
                          c.gacc_tran_id gacc_tran_id_b1,
                          c.gross_amt gross_amt_b, c.amount amount_b1,
                          DECODE (d.bank_sname,
                                  NULL, NULL,
                                     d.bank_sname
                                  || DECODE (c.check_no,
                                             NULL, NULL,
                                             '-' || c.check_no
                                            )
                                 ) chk_no_b,
                          c.commission_amt commission_amt_b,
                          c.vat_amt vat_amt_b, c.currency_cd currency_cd_b,
                          c.fcurrency_amt fcurrency_amt_b,
                          c.pay_mode pay_mode_b
                     FROM giac_order_of_payts A,
                          giac_or_pref b,
                          giac_collection_dtl c,
                          giac_banks d
                    WHERE A.gibr_gfun_fund_cd = b.fund_cd(+)
                      AND A.gibr_branch_cd = b.branch_cd(+)
                      AND A.or_pref_suf = b.or_pref_suf(+)
                      AND c.bank_cd = d.bank_cd(+)
                      AND or_flag IS NOT NULL
                      AND cancel_dcb_no = NVL (p_dcb_no, dcb_no)
                      AND TRUNC (or_date) = TRUNC (NVL (p_tran_dt, or_date))
                      AND gibr_gfun_fund_cd =
                                            NVL (p_fund_cd, gibr_gfun_fund_cd)
                      AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
                      AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
                      AND c.gacc_tran_id = A.gacc_tran_id
                 ORDER BY or_no);*/--Moved to top by pjsantos 12/16/2016, for optimization GENQA 5827
         
--         v_or_flag := x.or_flag;
--         v_op_flag := x.op_flag;
         
         IF v_giarr001a.or_no1 IS NOT NULL THEN -- bonok :: 10.17.2014 :: tag to display amounts
            v_giarr001a.print_amt := 'Y';
         ELSE
            IF v_giarr001a.or_flag = 'C' AND v_giarr001a.op_flag != 'P' THEN
               v_giarr001a.print_amt := 'N';
            END IF; 
         END IF;

         PIPE ROW (v_giarr001a);
      END LOOP;
      
      IF v_giarr001a.exist_cond = 'N' THEN
         PIPE ROW (v_giarr001a);
      END IF;

      RETURN;
   END;
   
    /* Added by dren 03.10.2015
   ** For SR 0004141
   ** Added CSV Report for GIARR01A
   */ 
   FUNCTION CSV_GIARR01A (
      p_fund_cd                 VARCHAR2,
      p_branch_cd               VARCHAR2,
      p_cashier_cd              VARCHAR2,
      p_dcb_no                  NUMBER,
      p_tran_dt                 DATE,
      p_user_id                 VARCHAR2
   )
      RETURN GIARR01A_TABLE PIPELINED
   AS
      rec                       GIARR01A_RECORD;    
      v_or_flag                 giac_order_of_payts.or_flag%TYPE;
      v_particulars             VARCHAR2 (2000);
      v_cancel_date             giac_order_of_payts.cancel_date%TYPE;
      v_or_date                 giac_order_of_payts.or_date%TYPE;
      v_cancel_dcb_no           giac_order_of_payts.cancel_dcb_no%TYPE;
      v_dcb_no                  giac_colln_batch.dcb_no%TYPE;
      v_gross_amt1              giac_collection_dtl.gross_amt%TYPE;
      v_commission_amt_b        giac_collection_dtl.commission_amt%TYPE;
      v_commission_amt          giac_collection_dtl.commission_amt%TYPE;
      v_gacc_tran_id            giac_order_of_payts.gacc_tran_id%TYPE;
      v_exist                   VARCHAR (2000);
      v_or_type                 giac_or_pref.or_type%TYPE;
      v_pay_mode                giac_collection_dtl.pay_mode%TYPE;
      v_vat_amt                 giac_collection_dtl.vat_amt%TYPE;
      v_amount                  giac_collection_dtl.amount%TYPE;
      v_dcb_no_b                giac_order_of_payts.dcb_no%TYPE;
      v_fcurrency_amt           giac_collection_dtl.fcurrency_amt%TYPE;
      v_chk_no                  VARCHAR2 (2000);
      v_check_date              giac_collection_dtl.check_date%TYPE;
      v_cs_no                   VARCHAR (2000);
      v_intm_no                 giac_order_of_payts.intm_no%TYPE;       
   BEGIN
      FOR x IN (SELECT dcb_no
                  FROM giac_colln_batch
                 WHERE TRUNC (tran_date) = NVL (p_tran_dt, tran_date)
                   AND dcb_no = NVL (p_dcb_no, dcb_no)
                   AND fund_cd = NVL (p_fund_cd, fund_cd)
                   AND branch_cd = NVL (p_branch_cd, branch_cd))
      LOOP
         v_dcb_no := x.dcb_no;
      END LOOP;   

      FOR i IN (SELECT RPAD (a.or_pref_suf, 5) || LPAD (a.or_no, 10, '0') || a.or_tag or_no,                       
                DECODE (a.with_pdc,'Y', DECODE (a.or_flag,'C', 'CANCELLED','R', 'REPLACED',TO_CHAR (a.or_date,'mm-dd-yyyy') || '/' || a.particulars),
                DECODE (a.or_flag,'C', 'CANCELLED','R', 'REPLACED',a.particulars)) particulars,
                a.payor payor,               
                TO_CHAR (c.gross_amt) gross_amt,
                TO_CHAR (NVL(c.commission_amt,0)) commission_amt,
                TO_CHAR (NVL(c.commission_amt,0)) misc_other_amt,--Modified by pjsantos 12/16/2016, added NVL GENQA5827
                TO_CHAR (c.vat_amt) vat_amt,
                TO_CHAR (c.gross_amt) cred_whtax_amt,
                TO_CHAR (c.amount) amount_rcvd,
                c.pay_mode,  
                e.short_name currency_sname,
                TO_CHAR (c.fcurrency_amt) amount, 
                DECODE (d.bank_sname,NULL, c.check_no,d.bank_sname || 
                DECODE (c.check_no,NULL, NULL,'-' || c.check_no)) check_cr_no,   
                c.check_date,     
                TO_CHAR (a.intm_no) intm_no,
                a.or_flag,
                a.cancel_date,
                a.or_date,
                TO_CHAR (a.cancel_dcb_no) cancel_dcb_no,
                a.gacc_tran_id gacc_tran_id,
                b.or_type,
                TO_CHAR (a.dcb_no) dcb_no
           FROM giac_order_of_payts a,
                giac_or_pref b,
                giac_collection_dtl c,
                giac_banks d,
                giis_currency E
          WHERE dcb_no = DECODE (cancel_dcb_no, NULL, dcb_no, dcb_no)
            AND a.gacc_tran_id = c.gacc_tran_id
            AND a.gibr_gfun_fund_cd = b.fund_cd(+)
            AND a.gibr_branch_cd = b.branch_cd(+)
            AND a.or_pref_suf = b.or_pref_suf(+)
            AND or_flag IS NOT NULL
            AND ((TRUNC (or_date) = NVL (p_tran_dt, or_date)
                AND NVL (with_pdc, 'N') <> 'Y')
                OR (    TRUNC (c.due_dcb_date) = NVL (p_tran_dt, c.due_dcb_date)
                AND with_pdc = 'Y'))
            AND ((dcb_no = NVL (p_dcb_no, dcb_no) AND NVL (with_pdc, 'N') <> 'Y') OR (    c.due_dcb_no = NVL (p_dcb_no, c.due_dcb_no) AND with_pdc = 'Y'))
            AND gibr_gfun_fund_cd = NVL (p_fund_cd, gibr_gfun_fund_cd)
            AND gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
            AND cashier_cd = NVL (p_cashier_cd, cashier_cd)
            AND c.bank_cd = d.bank_cd(+)
            AND a.gacc_tran_id = a.gacc_tran_id
            AND ((TRUNC (or_date) = NVL (p_tran_dt, or_date) 
                AND NVL (with_pdc, 'N') <> 'Y') 
                OR (TRUNC (a.due_dcb_date) = NVL (p_tran_dt, a.due_dcb_date) 
                AND with_pdc = 'Y'))
            AND ((dcb_no = NVL (p_dcb_no, dcb_no) 
                AND NVL (with_pdc, 'N') <> 'Y') 
                OR (a.due_dcb_no = NVL (p_dcb_no, a.due_dcb_no) 
                AND with_pdc = 'Y'))
            AND a.gibr_gfun_fund_cd = NVL (p_fund_cd, gibr_gfun_fund_cd)
            AND a.gibr_branch_cd = NVL (p_branch_cd, gibr_branch_cd)
            AND a.cashier_cd = NVL (p_cashier_cd, cashier_cd)
--            AND DECODE(a.or_flag, 'C', DECODE(TRUNC(p_tran_dt), TRUNC(a.cancel_date), 'N', 'Y'), 'Y') = 'Y' --commented out by gab SR 23059 09.15.2016
            AND c.currency_cd = e.main_currency_cd
       ORDER BY or_no)
      LOOP
         rec.or_no              := i.or_no;
         rec.particulars        := i.particulars;
         rec.payor              := i.payor;
         rec.currency_sname     := i.currency_sname;        
         v_or_flag              := i.or_flag;
         v_particulars          := i.particulars;
         v_cancel_date          := i.cancel_date;
         v_or_date              := i.or_date;
         v_cancel_dcb_no        := i.cancel_dcb_no;
         v_gross_amt1           := i.gross_amt;
         v_commission_amt       := i.commission_amt;
         v_gacc_tran_id         := i.gacc_tran_id;
         v_or_type              := i.or_type;
         v_pay_mode             := i.pay_mode;
         v_vat_amt              := i.vat_amt;
         v_amount               := i.amount_rcvd;
         v_dcb_no_b             := i.dcb_no;
         v_fcurrency_amt        := i.amount;
         v_chk_no               := i.check_cr_no;
         v_check_date           := i.check_date;
         v_intm_no              := i.intm_no;      
         v_exist                := 'N'; --Deo [08.24.2016]: SR-22978               
                  
         IF v_or_flag IN ('C', 'R') AND v_particulars <> 'SPOILED'
         THEN
            IF TRUNC (v_cancel_date) <> TRUNC (v_or_date)
            THEN
               rec.particulars :=
                     v_particulars
                  || ' ON '
                  || TO_CHAR (v_cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || v_cancel_dcb_no;
            ELSIF     TRUNC (v_cancel_date) = TRUNC (v_or_date)
                  AND v_dcb_no <> v_cancel_dcb_no
            THEN
               rec.particulars :=
                     v_particulars
                  || ' ON '
                  || TO_CHAR (v_cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || v_cancel_dcb_no;
--          added by gab SR23059 09.14.2016
            ELSIF     TRUNC (v_cancel_date) = TRUNC (v_or_date)
                  AND v_dcb_no = v_cancel_dcb_no
            THEN
               rec.particulars :=
                     v_particulars
                  || ' ON '
                  || TO_CHAR (v_cancel_date, 'MM-DD-RRRR')
                  || ' WITH DCB NO. '
                  || v_cancel_dcb_no;
            END IF;
         END IF;               
         
         IF v_particulars NOT IN ('SPOILED')
         THEN
            rec.gross_amt           := NVL (v_gross_amt1, 0);
            rec.commission_amt      := NVL (v_commission_amt_b, 0);
            rec.amount              := v_fcurrency_amt;
            rec.intm_no             := LPAD(v_intm_no, 4, '0');
            rec.pay_mode            := v_pay_mode;
            --for comm amt
            FOR a IN (SELECT gacc_tran_id
                        FROM giac_comm_payts
                       WHERE gacc_tran_id = v_gacc_tran_id)
            LOOP
               v_exist := 'Y';
            END LOOP;

            IF v_exist = 'Y'
            THEN
               IF v_or_flag IN ('C', 'R')
               THEN
                  rec.commission_amt := 0.00;
               ELSE
                  rec.commission_amt := NVL (v_commission_amt, 0);
               END IF;
            ELSIF v_exist = 'N'
            THEN
               IF v_or_flag IN ('C', 'R')
               THEN
                  rec.misc_other_amt := 0.00;
               ELSE
                  rec.misc_other_amt := NVL(v_commission_amt, 0);--Modified by pjsantos 12/16/2016, added NVL GENQA 5827
               END IF;
            END IF;
         END IF;                   
         
         IF v_particulars NOT IN ('SPOILED')
         THEN
            --for misc amt
            IF     (v_or_type = 'M')
               AND (v_particulars NOT IN ('SPOILED'))
               AND (v_or_flag <> 'N')
            THEN
               rec.misc_other_amt := NVL(i.amount_rcvd, 0);--Modified by pjsantos 12/16/2016, added NVL GENQA 5827 
            /*ELSE    
               IF v_pay_mode = 'CC' AND v_or_flag NOT IN ('C', 'R') THEN
                  rec.misc_other_amt := v_commission_amt;
               ELSE    
                  rec.misc_other_amt := 0;
               END IF;*/ --Deo [08.24.2016]: commented out, already handled above (SR-22978)
            END IF;
            --for CS No
            FOR a IN (SELECT comm_slip_pref, comm_slip_no
                        FROM giac_comm_slip_ext
                       WHERE gacc_tran_id = v_gacc_tran_id)
            LOOP
               v_cs_no := a.comm_slip_pref || '-' || a.comm_slip_no;
            END LOOP;

            IF v_cs_no IS NOT NULL
            THEN
               rec.cs_no := v_cs_no;
            ELSE
               rec.cs_no := NULL;
            END IF;
         END IF;         
                  
         IF v_particulars NOT IN ('SPOILED')
         THEN
            --for credit whtax amount
            IF v_pay_mode = 'CW' AND v_or_flag NOT IN ('C', 'R')
            THEN
               rec.gross_amt        := v_gross_amt1;
               rec.cred_whtax_amt   := v_gross_amt1;
            ELSE
               rec.cred_whtax_amt   := 0.00;
            END IF;
            --for vat amt
            IF v_or_flag IN ('C', 'R')
            THEN
               rec.vat_amt := 0.00;
            ELSE
               rec.vat_amt := NVL (v_vat_amt, 0);
            END IF;
            --for amt received
            IF v_or_flag IN ('C', 'R')
               AND TRUNC (v_or_date) <> TRUNC (v_cancel_date)
            THEN                                   
               v_amount := v_amount;
            ELSIF v_or_flag IN ('C', 'R')
               AND (TRUNC (v_or_date) = TRUNC (v_cancel_date))
               AND (v_dcb_no_b <> v_cancel_dcb_no)
            THEN
               v_amount := v_amount;
            ELSIF     v_or_flag IN ('C', 'R')
               AND (TRUNC (v_or_date) = TRUNC (v_cancel_date))
               AND (v_dcb_no_b = v_cancel_dcb_no)
            THEN
               v_amount := 0;
            ELSIF     v_or_flag IN ('C', 'R')
               AND (TRUNC (v_or_date) = TRUNC (v_cancel_date))
            THEN
               v_amount := 0;
            ELSIF v_pay_mode = 'CW'
            THEN
               v_amount := rec.gross_amt - rec.cred_whtax_amt;
            ELSE
               v_amount := v_amount;
            END IF;
            rec.amount_rcvd := v_amount;
         END IF;         
         
         IF v_particulars IN ('CANCELLED') OR v_or_flag IN ('C') 
         THEN 
            rec.gross_amt       := 0;
            rec.amount          := 0;
            rec.amount_rcvd     := 0;
         END IF;      
         
         IF v_particulars NOT IN ('SPOILED')
         THEN
            rec.check_cr_no     := v_chk_no;
            rec.check_date      := v_check_date;
         END IF;            
         PIPE ROW (rec);
      END LOOP;
      RETURN;
   END CSV_GIARR01A;
   --end dren       
   
   --marco - 03.10.2015 - added for GIARR01_ACCOUNTS subreport
   FUNCTION get_accounts(
        p_fund_cd               GIAC_COLLN_BATCH.fund_cd%TYPE,
        p_branch_cd             GIAC_COLLN_BATCH.branch_cd%TYPE,
        p_dcb_no                GIAC_COLLN_BATCH.dcb_no%TYPE,
        p_tran_dt               GIAC_COLLN_BATCH.tran_date%TYPE
    )
      RETURN account_tab PIPELINED
    IS
        v_row                   account_type;
    BEGIN
        FOR i IN(SELECT      d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no acct_no,
                         e.pay_mode || ' - ' || f.rv_meaning pay_mode_desc,
                         c.branch_bank, SUM (e.amount) deposit
                    FROM giac_acctrans a,
                         giac_bank_accounts c,
                         giac_banks d,
                         giac_dcb_bank_dep e,
                         cg_ref_codes f
                   WHERE a.tran_id = e.gacc_tran_id
                     AND a.tran_flag <> 'D'
                     AND c.bank_cd = e.bank_cd
                     AND c.bank_acct_cd = e.bank_acct_cd
                     AND d.bank_cd = c.bank_cd
                     AND e.pay_mode = f.rv_low_value
                     AND UPPER (f.rv_domain) = 'GIAC_DCB_BANK_DEP.PAY_MODE'
                     AND a.gfun_fund_cd = NVL (p_fund_cd, a.gfun_fund_cd)
                     AND a.gibr_branch_cd = NVL (p_branch_cd, a.gibr_branch_cd)
                     AND a.tran_class_no = NVL (p_dcb_no, a.tran_class_no)
--                   AND TRUNC (a.tran_date) = TRUNC(p_tran_dt) -- comment out by rai SR 23177
                     AND TRUNC (E.dcb_date) = p_tran_dt -- added by rai SR23177
                     AND e.dcb_no = NVL (p_dcb_no, e.dcb_no)
                GROUP BY    d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no,
                         e.pay_mode || ' - ' || f.rv_meaning,
                         c.branch_bank
                ORDER BY    d.bank_sname
                         || '-'
                         || c.branch_bank
                         || '-'
                         || c.bank_acct_no)
        LOOP
            v_row.acct_no := i.acct_no;                 
            v_row.pay_mode_desc := i.pay_mode_desc;
            v_row.branch_bank_deposit := TO_CHAR(i.deposit, '999,999,999.99');
            PIPE ROW(v_row);
        END LOOP;        
    END;   
END;
/


