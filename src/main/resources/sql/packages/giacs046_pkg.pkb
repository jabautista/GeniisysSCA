CREATE OR REPLACE PACKAGE BODY CPI.giacs046_pkg
AS
   FUNCTION get_list_check_release_info (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE--carlo SR 23905 02-27-2017
   )
      RETURN acc_check_release_info_tab PIPELINED
   IS
      v_list   acc_check_release_info_type;
   BEGIN
      FOR i IN (SELECT   gacc_tran_id,
                            check_pref_suf
                         || '-'
                         || TO_CHAR (check_no, '0000000009') check_number,
                         check_date, payee, fcurrency_amt, currency_cd,
                         bank_cd, bank_acct_cd, amount, item_no,
                         check_pref_suf, check_no, rv_meaning
                    FROM giac_check_disbursement_v, cg_ref_codes,
                    	 (SELECT branch_cd
                                   FROM TABLE (security_access.get_branch_line ('AC',
                                                             'GIACS046',
                                                             p_user_id
                                                            )
                            )) a --carlo SR 23905 02-27-2017 
                   WHERE gibr_gfun_fund_cd LIKE p_fund_cd
                     AND gibr_branch_cd LIKE p_branch_cd
                     --AND check_stat = 2  -- '2' modified by shan 04.22.2014
                     --SR19642 lara 07082015
                     AND check_stat IN (2,3) 
                     AND check_stat LIKE rv_low_value
                     AND rv_domain ='GIAC_CHK_DISBURSEMENT.CHECK_STAT' 
                     --end SR19642
                     /*AND check_user_per_iss_cd_acctg (NULL,
                                                      gibr_branch_cd,
                                                      'GIACS046'
                                                     ) = 1 comment out by carlo SR 23905*/
                     AND gibr_branch_cd = a.branch_cd
                ORDER BY check_pref_suf, check_no)
      LOOP
         v_list.check_number := i.check_number;
         v_list.check_date := i.check_date;
         v_list.payee := i.payee;
         v_list.fcurrency_amt := i.fcurrency_amt;
         v_list.amount := i.amount;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.item_no := i.item_no;
         v_list.check_pref_suf := i.check_pref_suf;
         v_list.check_no := i.check_no;
         v_list.check_stat := i.rv_meaning; --SR19642 lara 07082015

         BEGIN
            --SR19642 lara 07082015
            /*SELECT    SUBSTR (dv_pref, 1, 2)
                   || '-'
                   || TO_CHAR (dv_no, '0000000009') dv_number,
                   particulars, dv_no
              INTO v_list.dv_number,
                   v_list.particulars, v_list.dv_no
              FROM giac_disb_vouchers
             WHERE gacc_tran_id = i.gacc_tran_id;*/
         
            SELECT    SUBSTR (dv_pref, 1, 2)
                   || '-'
                   || TO_CHAR (dv_no, '0000000009') dv_number,
                   particulars, dv_no, rv_meaning 
              INTO v_list.dv_number,
                   v_list.particulars, v_list.dv_no,
                   v_list.dv_stat
              FROM giac_disb_vouchers, cg_ref_codes 
             WHERE gacc_tran_id = i.gacc_tran_id
             AND dv_flag = rv_low_value
             and rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG';
             --end SR19642
         END;

         BEGIN
            SELECT short_name
              INTO v_list.short_name
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         END;

         BEGIN
            SELECT bank_sname, bank_acct_no
              INTO v_list.bank_sname, v_list.bank_acct_no
              FROM giac_banks a, giac_bank_accounts b
             WHERE a.bank_cd = b.bank_cd
               AND b.bank_cd = i.bank_cd
               AND b.bank_acct_cd = i.bank_acct_cd;
         END;

         v_list.check_release_date := NULL;
         v_list.or_no := NULL;
         v_list.check_released_by := NULL;
         v_list.or_date := NULL;
         v_list.check_received_by := NULL;
         v_list.user_id := NULL;
         v_list.last_update := NULL;

         BEGIN
            FOR j IN (SELECT check_release_date, or_no, check_released_by,
                             or_date, check_received_by, user_id,
                             last_update
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_list.check_release_date := j.check_release_date;
               v_list.or_no := j.or_no;
               v_list.check_released_by := j.check_released_by;
               v_list.or_date := j.or_date;
               v_list.check_received_by := j.check_received_by;
               v_list.user_id := j.user_id;
               v_list.last_update :=
                          TO_CHAR (j.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_list_check_release_info;

   FUNCTION get_list_check_release_infou (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE--carlo SR 23905 02-27-2017
   )
      RETURN acc_check_release_info_tab PIPELINED
   IS
      v_list   acc_check_release_info_type;
   BEGIN
      FOR i IN (SELECT   gacc_tran_id,
                            check_pref_suf
                         || '-'
                         || TO_CHAR (check_no, '0000000009') check_number,
                         check_date, payee, fcurrency_amt, currency_cd,
                         bank_cd, bank_acct_cd, amount, item_no,
                         check_pref_suf, check_no, rv_meaning
                    FROM giac_check_disbursement_v, cg_ref_codes,
                         (SELECT branch_cd
                                   FROM TABLE (security_access.get_branch_line ('AC',
                                                             'GIACS046',
                                                             p_user_id
                                                            )
                            )) a --carlo SR 23905 02-27-2017 
                   WHERE gibr_gfun_fund_cd LIKE p_fund_cd
                     AND gibr_branch_cd LIKE p_branch_cd
                     --AND check_stat = 2  -- '2' modified by shan 04.22.2014
                     --SR19642 lara 07082015
                     AND check_stat IN (2,3) 
                     AND check_stat LIKE rv_low_value
                     AND rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT' 
                     --end SR19642
                     /*AND check_user_per_iss_cd_acctg (NULL,
                                                      gibr_branch_cd,
                                                      'GIACS046'
                                                     ) = 1 comment out by carlo SR 23905*/
                     AND gibr_branch_cd = a.branch_cd
                     AND gacc_tran_id NOT IN (SELECT a.gacc_tran_id
                                                FROM giac_chk_release_info a)
                ORDER BY check_pref_suf, check_no)
      LOOP
         v_list.check_number := i.check_number;
         v_list.check_date := i.check_date;
         v_list.payee := i.payee;
         v_list.fcurrency_amt := i.fcurrency_amt;
         v_list.amount := i.amount;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.item_no := i.item_no;
         v_list.check_pref_suf := i.check_pref_suf;
         v_list.check_no := i.check_no;
         v_list.check_stat := i.rv_meaning; --SR19642 lara 07082015

         BEGIN
             --SR19642 lara 07082015
            /*SELECT    SUBSTR (dv_pref, 1, 2)
                   || '-'
                   || TO_CHAR (dv_no, '0000000009') dv_number,
                   particulars, dv_no
              INTO v_list.dv_number,
                   v_list.particulars, v_list.dv_no
              FROM giac_disb_vouchers
             WHERE gacc_tran_id = i.gacc_tran_id;*/
         
            SELECT    SUBSTR (dv_pref, 1, 2)
                   || '-'
                   || TO_CHAR (dv_no, '0000000009') dv_number,
                   particulars, dv_no, rv_meaning 
              INTO v_list.dv_number,
                   v_list.particulars, v_list.dv_no,
                   v_list.dv_stat
              FROM giac_disb_vouchers, cg_ref_codes 
             WHERE gacc_tran_id = i.gacc_tran_id
             AND dv_flag = rv_low_value
             and rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG';
             --end SR19642
         END;

         BEGIN
            SELECT short_name
              INTO v_list.short_name
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         END;

         BEGIN
            SELECT bank_sname, bank_acct_no
              INTO v_list.bank_sname, v_list.bank_acct_no
              FROM giac_banks a, giac_bank_accounts b
             WHERE a.bank_cd = b.bank_cd
               AND b.bank_cd = i.bank_cd
               AND b.bank_acct_cd = i.bank_acct_cd;
         END;

         v_list.check_release_date := NULL;
         v_list.or_no := NULL;
         v_list.check_released_by := NULL;
         v_list.or_date := NULL;
         v_list.check_received_by := NULL;
         v_list.user_id := NULL;
         v_list.last_update := NULL;

         BEGIN
            FOR j IN (SELECT check_release_date, or_no, check_released_by,
                             or_date, check_received_by, user_id,
                             last_update
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_list.check_release_date := j.check_release_date;
               v_list.or_no := j.or_no;
               v_list.check_released_by := j.check_released_by;
               v_list.or_date := j.or_date;
               v_list.check_received_by := j.check_received_by;
               v_list.user_id := j.user_id;
               v_list.last_update :=
                          TO_CHAR (j.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_list_check_release_infou;

   FUNCTION get_list_check_release_infor (
      p_fund_cd     giis_funds.fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE--carlo SR 23905 02-27-2017
   )
      RETURN acc_check_release_info_tab PIPELINED
   IS
      v_list   acc_check_release_info_type;
   BEGIN
      FOR i IN (SELECT   gacc_tran_id,
                            check_pref_suf
                         || '-'
                         || TO_CHAR (check_no, '0000000009') check_number,
                         check_date, payee, fcurrency_amt, currency_cd,
                         bank_cd, bank_acct_cd, amount, item_no,
                         check_pref_suf, check_no, rv_meaning
                    FROM giac_check_disbursement_v, cg_ref_codes,
                         (SELECT branch_cd
                                   FROM TABLE (security_access.get_branch_line ('AC',
                                                             'GIACS046',
                                                             p_user_id
                                                            )
                            )) a --carlo SR 23905 02-27-2017  
                   WHERE gibr_gfun_fund_cd LIKE p_fund_cd
                     AND gibr_branch_cd LIKE p_branch_cd
                     --AND check_stat = 2  -- '2' modified by shan 04.22.2014
                     --SR19642 lara 07082015
                     AND check_stat IN (2,3) 
                     AND check_stat LIKE rv_low_value
                     AND rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT' 
                     --end SR19642
                     /*AND check_user_per_iss_cd_acctg (NULL,
                                                      gibr_branch_cd,
                                                      'GIACS046'
                                                     ) = 1 comment out by carlo SR 23905*/
                     AND gibr_branch_cd = a.branch_cd
                     AND gacc_tran_id IN (SELECT a.gacc_tran_id
                                            FROM giac_chk_release_info a)
                ORDER BY check_pref_suf, check_no)
      LOOP
         v_list.check_number := i.check_number;
         v_list.check_date := i.check_date;
         v_list.payee := i.payee;
         v_list.fcurrency_amt := i.fcurrency_amt;
         v_list.amount := i.amount;
         v_list.gacc_tran_id := i.gacc_tran_id;
         v_list.item_no := i.item_no;
         v_list.check_pref_suf := i.check_pref_suf;
         v_list.check_no := i.check_no;
         v_list.check_stat := i.rv_meaning; --SR19642 lara 07082015

         BEGIN
             --SR19642 lara 07082015
            /*SELECT    SUBSTR (dv_pref, 1, 2)
                   || '-'
                   || TO_CHAR (dv_no, '0000000009') dv_number,
                   particulars, dv_no
              INTO v_list.dv_number,
                   v_list.particulars, v_list.dv_no
              FROM giac_disb_vouchers
             WHERE gacc_tran_id = i.gacc_tran_id;*/
         
            SELECT    SUBSTR (dv_pref, 1, 2)
                   || '-'
                   || TO_CHAR (dv_no, '0000000009') dv_number,
                   particulars, dv_no, rv_meaning 
              INTO v_list.dv_number,
                   v_list.particulars, v_list.dv_no,
                   v_list.dv_stat
              FROM giac_disb_vouchers, cg_ref_codes 
             WHERE gacc_tran_id = i.gacc_tran_id
             AND dv_flag = rv_low_value
             and rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG';
             --end SR19642 
         END;

         BEGIN
            SELECT short_name
              INTO v_list.short_name
              FROM giis_currency
             WHERE main_currency_cd = i.currency_cd;
         END;

         BEGIN
            SELECT bank_sname, bank_acct_no
              INTO v_list.bank_sname, v_list.bank_acct_no
              FROM giac_banks a, giac_bank_accounts b
             WHERE a.bank_cd = b.bank_cd
               AND b.bank_cd = i.bank_cd
               AND b.bank_acct_cd = i.bank_acct_cd;
         END;

         v_list.check_release_date := NULL;
         v_list.or_no := NULL;
         v_list.check_released_by := NULL;
         v_list.or_date := NULL;
         v_list.check_received_by := NULL;
         v_list.user_id := NULL;
         v_list.last_update := NULL;

         BEGIN
            FOR j IN (SELECT check_release_date, or_no, check_released_by,
                             or_date, check_received_by, user_id,
                             last_update
                        FROM giac_chk_release_info
                       WHERE gacc_tran_id = i.gacc_tran_id
                         AND item_no = i.item_no)
            LOOP
               v_list.check_release_date := j.check_release_date;
               v_list.or_no := j.or_no;
               v_list.check_released_by := j.check_released_by;
               v_list.or_date := j.or_date;
               v_list.check_received_by := j.check_received_by;
               v_list.user_id := j.user_id;
               v_list.last_update :=
                          TO_CHAR (j.last_update, 'mm-dd-yyyy HH12:MI:SS AM');
            END LOOP;
         END;

         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END get_list_check_release_infor;

   PROCEDURE set_check_release_info (
      v_tran_id              IN   giac_chk_release_info.gacc_tran_id%TYPE,
      v_item_no              IN   giac_chk_release_info.item_no%TYPE,
      v_check_no             IN   giac_chk_release_info.check_no%TYPE,
      v_check_release_date   IN   giac_chk_release_info.check_release_date%TYPE,
      v_check_release_by     IN   giac_chk_release_info.check_released_by%TYPE,
      v_check_receive_by     IN   giac_chk_release_info.check_received_by%TYPE,
      v_check_pref_suf       IN   giac_chk_release_info.check_pref_suf%TYPE,
      v_or_no                IN   giac_chk_release_info.or_no%TYPE,
      v_or_date              IN   giac_chk_release_info.or_no%TYPE,
      v_user_id              IN   giac_chk_release_info.user_id%TYPE
   )
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      FOR y IN (SELECT 'Y'
                  FROM giac_chk_release_info
                 WHERE gacc_tran_id = v_tran_id AND item_no = v_item_no)
      LOOP
         v_exist := 'Y';
      END LOOP;

      IF v_exist = 'Y'
      THEN
         DELETE FROM giac_chk_release_info
               WHERE gacc_tran_id = v_tran_id AND item_no = v_item_no;

         INSERT INTO giac_chk_release_info
              VALUES (v_tran_id, v_item_no, v_check_no, v_check_release_date,
                      v_check_release_by, v_check_receive_by,
                      v_check_pref_suf, v_or_no, v_or_date, v_user_id,
                      SYSDATE, NULL);
      ELSE
         INSERT INTO giac_chk_release_info
              VALUES (v_tran_id, v_item_no, v_check_no, v_check_release_date,
                      v_check_release_by, v_check_receive_by,
                      v_check_pref_suf, v_or_no, v_or_date, v_user_id,
                      SYSDATE, NULL);
      END IF;

      COMMIT;
   END;
   
    FUNCTION get_branch_lov (
       p_module_id      giis_modules.module_id%TYPE,
       p_user_id        giis_users.user_id%TYPE,
       p_keyword        VARCHAR2
    )
       RETURN branch_cd_lov_tab PIPELINED
    IS
       v_branch   branch_cd_lov_type;
    BEGIN
       FOR i IN (SELECT   branch_cd, branch_name
                     FROM giac_branches
                    WHERE 1 = 1 
                      AND branch_cd =
                             DECODE (check_user_per_iss_cd_acctg2 (NULL,
                                                                   branch_cd,
                                                                   p_module_id,
                                                                   p_user_id
                                                                  ),
                                     1, branch_cd,
                                     NULL
                                    )
                      AND (   UPPER (branch_cd) LIKE
                                   '%' || UPPER (NVL (p_keyword, branch_cd))
                                   || '%'
                           OR UPPER (branch_name) LIKE
                                 '%' || UPPER (NVL (p_keyword, branch_name))
                                 || '%'
                          )
                 ORDER BY 2)
       LOOP
          v_branch.branch_cd := i.branch_cd;
          v_branch.branch_name := i.branch_cd||' - '||i.branch_name;
          PIPE ROW (v_branch);
       END LOOP;
    END;
END;
/
