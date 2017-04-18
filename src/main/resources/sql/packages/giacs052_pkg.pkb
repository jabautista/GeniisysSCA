CREATE OR REPLACE PACKAGE BODY CPI.giacs052_pkg
AS
   PROCEDURE on_load_giacs052 (
      p_gacc_tran_id        IN       giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no             OUT      giac_chk_disbursement.item_no%TYPE,
      p_bank_cd             OUT      giac_chk_disbursement.bank_cd%TYPE,
      p_bank_sname          OUT      giac_banks.bank_sname%TYPE,
      p_bank_acct_cd        OUT      giac_chk_disbursement.bank_acct_cd%TYPE,
      p_bank_acct_no        OUT      giac_bank_accounts.bank_acct_no%TYPE,
      p_check_stat          OUT      giac_chk_disbursement.check_stat%TYPE,
      p_check_stat_mean     OUT      VARCHAR2,
      p_payee               OUT      giac_chk_disbursement.payee%TYPE,
      p_check_date          OUT      VARCHAR2,
      p_disb_mode           OUT      giac_chk_disbursement.disb_mode%TYPE,
      p_still_with_check    OUT      VARCHAR2,
      p_gen_transfer_no     OUT      VARCHAR2,
      p_edit_check_no       OUT      VARCHAR2,
      p_allow_dv_printing   OUT      VARCHAR2,
      p_dv_approved_by      OUT      giac_disb_vouchers.dv_approved_by%TYPE,
      p_dv_flag             OUT      giac_disb_vouchers.dv_flag%TYPE,
      p_dv_flag_mean        OUT      cg_ref_codes.rv_meaning%TYPE
   )
   IS
   BEGIN
      FOR i IN (SELECT NVL (disb_mode, 'C') disb_mode
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = p_gacc_tran_id)
      LOOP
         p_disb_mode := i.disb_mode;
         EXIT;
      END LOOP;
      SELECT gcdb.item_no item_no, gcdb.bank_cd bank_cd, gban.bank_sname bank_sname,
             gcdb.bank_acct_cd bank_acct_cd, gbac.bank_acct_no bank_acct_no,
             gcdb.check_stat check_stat, SUBSTR (crc.rv_meaning, 1, 10) check_stat_mean, gcdb.payee,
             gcdb.check_date
        INTO p_item_no, p_bank_cd, p_bank_sname,
             p_bank_acct_cd, p_bank_acct_no,
             p_check_stat, p_check_stat_mean, p_payee,
             p_check_date
        FROM giis_currency gcur,
             cg_ref_codes crc,
             giac_banks gban,
             giac_bank_accounts gbac,
             giac_chk_disbursement gcdb
       WHERE gcdb.gacc_tran_id = p_gacc_tran_id
         AND gcdb.item_no =
                (SELECT MIN (gcdb_2.item_no)
                   FROM giac_chk_disbursement gcdb_2
                  WHERE gcdb_2.gacc_tran_id = gcdb.gacc_tran_id
                    AND gcdb_2.check_stat =
                           DECODE (p_disb_mode,
                                   'B', DECODE (giacp.v ('GEN_BANK_TRANSFER_NO'), 'M', 2, 1),
                                   1
                                  ))
         AND gcdb.check_stat =
                  DECODE (p_disb_mode,
                          'B', DECODE (giacp.v ('GEN_BANK_TRANSFER_NO'), 'M', 2, 1),
                          1
                         )
         AND gcdb.currency_cd = gcur.main_currency_cd
         AND gcdb.bank_cd = gban.bank_cd
         AND gcdb.bank_acct_cd = gbac.bank_acct_cd
         AND gcdb.check_stat LIKE crc.rv_low_value
         AND crc.rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT'
         AND gban.bank_cd = gbac.bank_cd;
      IF p_check_date IS NULL AND p_item_no IS NOT NULL
      THEN
         p_check_date := TO_CHAR (SYSDATE, 'MM-DD-YYYY');
      END IF;
      FOR c IN (SELECT 1
                  FROM giac_chk_disbursement gcdb
                 WHERE gcdb.gacc_tran_id = p_gacc_tran_id AND gcdb.check_stat LIKE '1')
      LOOP
         p_still_with_check := 'Y';
      END LOOP;
      BEGIN
         SELECT a.dv_approved_by, a.dv_flag, b.rv_meaning dv_flag_mean
           INTO p_dv_approved_by, p_dv_flag, p_dv_flag_mean
           FROM giac_disb_vouchers a
               ,cg_ref_codes b
          WHERE a.gacc_tran_id = p_gacc_tran_id
            AND b.rv_domain = 'GIAC_DISB_VOUCHERS.DV_FLAG'
            AND b.rv_low_value = a.dv_flag;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            p_dv_approved_by := NULL;
      END;
      p_gen_transfer_no := NVL (giacp.v ('GEN_BANK_TRANSFER_NO'), 'M');
      p_edit_check_no := NVL (giacp.v ('EDIT_CHECK_NO'), 'Y');
      p_allow_dv_printing := NVL (giacp.v ('ALLOW_DV_PRINTING'), 'N');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         NULL;
   END;
   FUNCTION get_checks_lov (p_tran_id giac_chk_disbursement.gacc_tran_id%TYPE, p_find_text VARCHAR2)
      RETURN check_tab PIPELINED
   AS
      v_rec   check_type;
   BEGIN
      FOR i IN (SELECT gcdb.item_no item_no, gcdb.payee, gcdb.bank_cd bank_cd,
                       gban.bank_sname bank_sname, gcdb.bank_acct_cd bank_acct_cd,
                       gbac.bank_acct_no bank_acct_no, gcdb.check_stat check_stat,
                       crc.rv_meaning check_stat_mean, gcdb.amount amount, gcdb.check_date,
                       gcur.short_name short_name
                  FROM giis_currency gcur,
                       cg_ref_codes crc,
                       giac_banks gban,
                       giac_bank_accounts gbac,
                       giac_chk_disbursement gcdb
                 WHERE gcdb.gacc_tran_id = p_tran_id
                   AND gcdb.check_stat LIKE '1'
                   AND gcdb.currency_cd = gcur.main_currency_cd
                   AND gcdb.bank_cd = gban.bank_cd
                   AND gcdb.bank_acct_cd = gbac.bank_acct_cd
                   AND gcdb.check_stat LIKE crc.rv_low_value
                   AND crc.rv_domain = 'GIAC_CHK_DISBURSEMENT.CHECK_STAT'
                   AND gban.bank_cd = gbac.bank_cd
                   AND (   TO_CHAR (gcdb.item_no) LIKE NVL (p_find_text, TO_CHAR (gcdb.item_no))
                        OR UPPER (gcdb.payee) LIKE UPPER (NVL (p_find_text, gcdb.payee))
                        OR UPPER (gban.bank_sname) LIKE UPPER (NVL (p_find_text, gban.bank_sname))
                        OR UPPER (gbac.bank_acct_no) LIKE
                                                        UPPER (NVL (p_find_text, gbac.bank_acct_no))
                        OR UPPER (crc.rv_meaning) LIKE UPPER (NVL (p_find_text, crc.rv_meaning))
                       ))
      LOOP
         v_rec.item_no := i.item_no;
         v_rec.payee := i.payee;
         v_rec.bank_cd := i.bank_cd;
         v_rec.bank_sname := i.bank_sname;
         v_rec.bank_acct_cd := i.bank_acct_cd;
         v_rec.bank_acct_no := i.bank_acct_no;
         v_rec.check_stat := i.check_stat;
         v_rec.check_stat_mean := i.check_stat_mean;
         v_rec.amount := i.amount;
         v_rec.short_name := i.short_name;
         IF i.check_date IS NULL AND i.item_no IS NOT NULL
         THEN
            v_rec.check_date := TO_CHAR (SYSDATE, 'MM-DD-YYYY');
         END IF;
         PIPE ROW (v_rec);
      END LOOP;
      RETURN;
   END;
   PROCEDURE default_check (
      p_print_prsd          IN       VARCHAR2,
      p_disb_mode           IN       giac_chk_disbursement.disb_mode%TYPE,
      p_bank_cd             IN       giac_chk_disbursement.bank_cd%TYPE,
      p_bank_sname          IN       giac_banks.bank_sname%TYPE,
      p_bank_acct_cd        IN       giac_chk_disbursement.bank_acct_cd%TYPE,
      p_print_check         IN       VARCHAR2,
      p_branch_cd           IN       giac_branches.branch_cd%TYPE,
      p_fund_cd             IN       giac_branches.gfun_fund_cd%TYPE,
      p_check_pref          OUT      VARCHAR2,
      p_check_no            OUT      VARCHAR2,
      p_check_no_required   OUT      VARCHAR2
   )
   IS
      v_sel_ctr         NUMBER (2);
      v_dflt_chk_pref   VARCHAR2 (2) := NVL (giacp.v ('DEFAULT_CHECK_PREF'), 'P');
      v_dflt_bt_pref    VARCHAR2 (2) := NVL (giacp.v ('DEFAULT_BANK_TRANSFER_PREF'), 'P');
      v_check_exist     VARCHAR2(1) := 'Y'; --added by steven 09.24.2014
   BEGIN
      p_check_no_required := 'N';
      --SET_ITEM_PROPERTY ('a940.check_no', required, property_false);              --jason 07/24/2007
      --get the next check number only when print button is pressed (jason 04/24/2007)
      IF    (p_print_prsd = 'Y' AND p_print_check = 'Y')                  -- for check disbursement
         OR (p_print_prsd = 'Y' AND p_print_check = 'N' AND p_disb_mode = 'B')
      THEN
            -- SET_ITEM_PROPERTY('a940.check_no',REQUIRED,PROPERTY_TRUE); --jason 07/24/2007
            /*
         **  Created by   : Jonathan Dy
         **  Date Created :  09/07/2012
         **  Description : Comment out the setting of required property to the condition
          IF variables.disb_mode = 'C'; to set required property ONLY during processing check disbursement
         */
         v_sel_ctr := 1;
         --Vincent 10042006: added condition for 'DEFAULT_CHECK_PREF' parameter
         IF p_disb_mode = 'C'
         THEN                                                                 -- check disbursement
            --SET_ITEM_PROPERTY ('a940.check_no', required, property_true);        --jason 07/24/2007
            p_check_no_required := 'Y';
            IF v_dflt_chk_pref = 'B'
            THEN                                                                 -- bank short name
               p_check_pref := SUBSTR (p_bank_sname, 1, 5);
            ELSIF v_dflt_chk_pref = 'C'
            THEN                                 -- concat branch of transaction and bank short name
               p_check_pref := p_branch_cd || '' || SUBSTR (p_bank_sname, 1, 3);
            ELSIF v_dflt_chk_pref = 'P'
            THEN                                                                        -- parameter
               SELECT param_value_v
                 INTO p_check_pref
                 FROM giac_parameters
                WHERE UPPER (param_name) = 'CHECK_PREF';
            END IF;
         ELSIF p_disb_mode = 'B'
         THEN
-- bank transfer   /* judyann 05302011; separate default prefix for bank transfer DV transactions */
            IF v_dflt_bt_pref = 'B'
            THEN                                                                 -- bank short name
               p_check_pref := 'T' || SUBSTR (p_bank_sname, 1, 4);
            ELSIF v_dflt_bt_pref = 'C'
            THEN                                 -- concat branch of transaction and bank short name
               p_check_pref := 'T' || p_branch_cd || '' || SUBSTR (p_bank_sname, 1, 2);
            ELSIF v_dflt_bt_pref = 'P'
            THEN                                                                        -- parameter
               SELECT param_value_v
                 INTO p_check_pref
                 FROM giac_parameters
                WHERE UPPER (param_name) = 'BANK_TRANSFER_PREF';
            END IF;
         END IF;
         v_sel_ctr := 2;
         SELECT        check_seq_no + 1
                  INTO p_check_no
                  FROM giac_check_no
                 WHERE fund_cd = p_fund_cd
                   AND branch_cd = p_branch_cd
                   AND bank_cd = p_bank_cd                                                       --/
                   AND bank_acct_cd = p_bank_acct_cd                                             --/
                   AND NVL (chk_prefix, '-') = NVL (p_check_pref, NVL (chk_prefix, '-'))
         FOR UPDATE OF check_seq_no;
         --added by steven 09.24.2014; validation para di mag-constraint pag nag-spoil ka.
        WHILE v_check_exist = 'Y'
        LOOP
          v_check_exist := 'N';
          FOR chk IN (SELECT 'Y'
                        FROM giac_chk_disbursement
                       WHERE check_no = p_check_no
                         AND NVL (check_pref_suf, '-') = NVL (p_check_pref, '-')
                         AND bank_cd = p_bank_cd
                         AND bank_acct_cd = p_bank_acct_cd)
          LOOP
             v_check_exist := 'Y';
             EXIT;
          END LOOP;
          IF v_check_exist = 'N'
          THEN
             FOR chk IN (SELECT 'Y'
                           FROM giac_spoiled_check
                          WHERE check_no = p_check_no
                            AND NVL (check_pref_suf, '-') =
                                                           NVL (p_check_pref, '-')
                            AND bank_cd = p_bank_cd
                            AND bank_acct_cd = p_bank_acct_cd)
             LOOP
                v_check_exist := 'Y';
                EXIT;
             END LOOP;
          END IF;
          IF v_check_exist = 'Y'
          THEN
             p_check_no := p_check_no + 1;
          END IF;
        END LOOP;
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         IF v_sel_ctr = 1
         THEN
            raise_application_error
                                 (-20001,
                                  'Geniisys Exception#E#Check Prefix not found in giac_parameters.'
                                 );
         ELSIF v_sel_ctr = 2
         THEN
            p_check_no := 1;
         END IF;
   END;
   PROCEDURE ins_upd_chk_no (
      p_gacc_tran_id            giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no                 giac_chk_disbursement.item_no%TYPE,
      p_bank_acct_cd            giac_chk_disbursement.bank_acct_cd%TYPE,
      p_bank_cd                 giac_chk_disbursement.bank_cd%TYPE,
      p_branch_cd               giac_branches.branch_cd%TYPE,
      p_fund_cd                 giac_branches.gfun_fund_cd%TYPE,
      p_user_id                 giis_users.user_id%TYPE,
      p_print_dv                VARCHAR2,
      p_print_check             VARCHAR2,
      p_chk_prefix     IN OUT   VARCHAR2,
      p_check_no       IN OUT   VARCHAR2
   )
   IS
      v_chk   VARCHAR2 (1);
   BEGIN
      --MSG_ALERT('1','I',FALSE);
      BEGIN
/*
**  Created by   : Jonathan Dy
**  Date Created :  08/30/2012
**  Description : To prevent ORA-01407 error (PNG-SR 10470) during printing of DV;
                                       GEN_BANK_TRANSFER_NO parameter is set to 'M'
*/
         IF p_print_dv = 'Y' AND p_print_check = 'N'
         THEN
            IF giacp.v ('GEN_BANK_TRANSFER_NO') = 'M'
            THEN
               SELECT check_pref_suf, check_no
                 INTO p_chk_prefix, p_check_no
                 FROM giac_chk_disbursement
                WHERE gacc_tran_id = p_gacc_tran_id;
            END IF;
         END IF;
--end jcDY 08/30/2012
         UPDATE giac_check_no
            SET check_seq_no = p_check_no
          WHERE fund_cd = p_fund_cd
            AND branch_cd = p_branch_cd
            AND bank_cd = p_bank_cd                           --/ applied also to sql%notfound below
            AND bank_acct_cd = p_bank_acct_cd                 --/ applied also to sql%notfound below
            AND NVL (chk_prefix, '-') = NVL (p_chk_prefix, NVL (chk_prefix, '-'));
         --MSG_ALERT('2','I',FALSE);
         IF SQL%NOTFOUND
         THEN
            INSERT INTO giac_check_no
                        (fund_cd, branch_cd, bank_cd, bank_acct_cd, check_seq_no, user_id,
                         last_update, chk_prefix
                        )
                 VALUES (p_fund_cd, p_branch_cd, p_bank_cd, p_bank_acct_cd, p_check_no, p_user_id,
                         SYSDATE, p_chk_prefix
                        );
--MSG_ALERT('3','I',FALSE);
            IF SQL%NOTFOUND
            THEN
               --FORMS_DDL ('ROLLBACK');
               raise_application_error (-20001,
                                        'Geniisys Exception#E#Error updating giac_check_no.'
                                       );
            END IF;
         END IF;
      END;
--MSG_ALERT('4','I',FALSE);
   END;
   PROCEDURE update_gcdb (
      p_tran_id               giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no               giac_chk_disbursement.item_no%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_chk_prefix   IN OUT   VARCHAR2,
      p_check_no     IN OUT   VARCHAR2,
      p_check_date            giac_chk_disbursement.check_date%TYPE
   )
   IS
   BEGIN
      UPDATE giac_chk_disbursement
         SET check_date = p_check_date,
             check_pref_suf = p_chk_prefix,
             check_no = p_check_no,
             check_stat = '2',
             user_id = p_user_id,
             check_print_date = SYSDATE,
             last_update = SYSDATE
       WHERE gacc_tran_id = p_tran_id AND item_no = p_item_no;
      IF SQL%NOTFOUND
      THEN
         --FORMS_DDL ('ROLLBACK');
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Error updating giac_chk_disbursement.'
                                 );
      END IF;
   END;
   PROCEDURE update_gidv (
      p_tran_id          giac_chk_disbursement.gacc_tran_id%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_check_dv_print   VARCHAR2,
      p_dv_flag          VARCHAR2,
      p_prt_chk          VARCHAR2,
      p_prt_dv           VARCHAR2,
      p_check_cnt        VARCHAR2,
      p_document_cd      giac_payt_requests.document_cd%TYPE -- added by: Nica 06.11.2013 AC-SPECS-2012-153
   )
   IS
      v_print_tag     giac_disb_vouchers.print_tag%TYPE;
      v_chk_exists    VARCHAR2 (1)                        := 'N';
      v_cnt           NUMBER;
      v_allow_print   VARCHAR2 (1);
      v_msg_alert VARCHAR2(20);
      v_workflow_msgr VARCHAR2(20);
   BEGIN
      IF p_check_dv_print IN ('1', '4')
      THEN
         v_print_tag := 6;
         UPDATE giac_disb_vouchers
            SET dv_flag = 'P',
                dv_print_date = SYSDATE,
                print_tag = v_print_tag,
                user_id = p_user_id,
                last_update = SYSDATE
          WHERE gacc_tran_id = p_tran_id;
         IF SQL%NOTFOUND
         THEN
            --FORMS_DDL ('ROLLBACK');
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Error updating giac_disb_vouchers.'
                                    );
         ELSE
             /* AC-SPECS-2012-153
             ** Call the procedure for credit/debit memo generation
             */
             IF p_document_cd = giacp.v('FACUL_RI_PREM_PAYT_DOC') AND v_print_tag = 6 THEN --change by steven 09.24.2014; 'OFPPR'
                 GIACS052_PKG.insert_into_cm_dm(p_tran_id, p_user_id);
             END IF;
             --end
         END IF;
      ELSIF p_check_dv_print = '2'
      THEN
         FOR a IN (SELECT '1'
                     FROM giac_chk_disbursement
                    WHERE gacc_tran_id = p_tran_id
                                                  --AND check_stat = '1') LOOP
                          AND check_stat LIKE '1')
         LOOP
            v_chk_exists := 'Y';
            EXIT;
         END LOOP;
         IF p_prt_chk = 'Y'
         --AND variables.prt_dv = 'N'
         THEN
            IF v_chk_exists = 'Y' AND p_dv_flag = 'P'
            THEN
               v_print_tag := 5;
            ELSIF v_chk_exists = 'Y' AND p_dv_flag = 'A'
            THEN
               v_print_tag := 2;
            ELSIF v_chk_exists = 'N' AND p_dv_flag = 'P'
            THEN
               v_print_tag := 6;
            ELSIF v_chk_exists = 'N' AND p_dv_flag = 'A'
            THEN
               v_print_tag := 3;
            END IF;
            UPDATE giac_disb_vouchers
               SET print_tag = v_print_tag,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = p_tran_id;
            IF SQL%NOTFOUND
            THEN
               --FORMS_DDL ('ROLLBACK');
               raise_application_error (-20001,
                                        'Geniisys Exception#E#Error updating giac_disb_vouchers.'
                                       );
            ELSE
                /* AC-SPECS-2012-153
                ** Call the procedure for credit/debit memo generation
                */
                IF p_document_cd = giacp.v('FACUL_RI_PREM_PAYT_DOC') AND v_print_tag = 6 THEN --change by steven 09.24.2014; 'OFPPR'
                    GIACS052_PKG.insert_into_cm_dm(p_tran_id, p_user_id);
                END IF;
                --end
            END IF;
         --p_prt_chk := 'N';
         ELSIF NVL(p_prt_chk, 'N') = 'N' AND p_prt_dv = 'Y'
         THEN
            IF v_chk_exists = 'Y'
            THEN
               FOR a IN (SELECT COUNT (*) cnt
                           FROM giac_chk_disbursement
                          WHERE gacc_tran_id = p_tran_id AND check_stat LIKE '1')
               LOOP
                  v_cnt := a.cnt;
                  EXIT;
               END LOOP;
               IF v_cnt = TO_NUMBER (p_check_cnt)
               THEN
                  v_print_tag := 4;
               ELSIF v_cnt < TO_NUMBER (p_check_cnt)
               THEN
                  v_print_tag := 5;
               END IF;
            ELSIF v_chk_exists = 'N'
            THEN
               BEGIN            --added by lina to correct dv_print tag if there is no check record
                  SELECT param_value_v
                    INTO v_allow_print
                    FROM giac_parameters
                   WHERE param_name LIKE 'ALLOW_DV_PRINTING';
               EXCEPTION
                  WHEN NO_DATA_FOUND
                  THEN
                     v_allow_print := 'N';
               END;
               IF v_allow_print = 'Y'
               THEN
                  FOR a IN (SELECT COUNT (*) cnt
                              FROM giac_chk_disbursement
                             WHERE gacc_tran_id = p_tran_id)
                  LOOP
                     v_cnt := a.cnt;
                     EXIT;
                  END LOOP;
                  IF v_cnt = 0
                  THEN
                     v_print_tag := 4;
                  ELSE
                     FOR a IN (SELECT COUNT (*) cnt
                                 FROM giac_chk_disbursement
                                WHERE gacc_tran_id = p_tran_id AND check_stat LIKE '1')
                     LOOP
                        v_cnt := a.cnt;
                        EXIT;
                     END LOOP;
                     IF v_cnt = 0
                     THEN
                        v_print_tag := 6;
                     ELSE
                        v_print_tag := 5;
                     END IF;
                  END IF;
               ELSE                                                           ---end of modification
                  v_print_tag := 6;
               END IF;
            END IF;
            UPDATE giac_disb_vouchers
               SET dv_flag = 'P',
                   dv_print_date = SYSDATE,
                   print_tag = v_print_tag,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = p_tran_id;
            IF SQL%NOTFOUND
            THEN
               --FORMS_DDL ('ROLLBACK');
               raise_application_error (-20001,
                                        'Geniisys Exception#E#Error updating giac_disb_vouchers.'
                                       );
            ELSE
                /* AC-SPECS-2012-153
                ** Call the procedure for credit/debit memo generation
                */
                IF p_document_cd = giacp.v('FACUL_RI_PREM_PAYT_DOC') AND v_print_tag = 6 THEN --change by steven 09.24.2014; 'OFPPR'
                    GIACS052_PKG.insert_into_cm_dm(p_tran_id, p_user_id);
                END IF;
                --end
            END IF;
         --p_prt_dv := 'N';
         END IF;
      ELSIF p_check_dv_print = '3'
      THEN
         FOR a IN (SELECT '1'
                     FROM giac_chk_disbursement
                    WHERE gacc_tran_id = p_tran_id AND check_stat LIKE '1')
         LOOP
            v_chk_exists := 'Y';
            EXIT;
         END LOOP;
         IF v_chk_exists = 'Y'
         THEN
            v_print_tag := 5;
         ELSE
            v_print_tag := 6;
         END IF;
         UPDATE giac_disb_vouchers
            SET print_tag = v_print_tag,
                user_id = p_user_id,
                last_update = SYSDATE
          WHERE gacc_tran_id = p_tran_id;
         IF SQL%NOTFOUND
         THEN
            --FORMS_DDL ('ROLLBACK');
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Error updating giac_disb_vouchers.'
                                    );
         ELSE
             /* AC-SPECS-2012-153
             ** Call the procedure for credit/debit memo generation
             */
             IF p_document_cd = giacp.v('FACUL_RI_PREM_PAYT_DOC') AND v_print_tag = 6 THEN --change by steven 09.24.2014; 'OFPPR'
                 GIACS052_PKG.insert_into_cm_dm(p_tran_id, p_user_id);
             END IF;
             --end
         END IF;
      END IF;
       /* A.R.C. 04.12.2006
      ** to create workflow records of CLAIM PAYMENTS */
      FOR c1 IN (SELECT claim_id
                   FROM giac_direct_claim_payts a
                  WHERE 1 = 1
                    AND a.gacc_tran_id = p_tran_id
                    AND EXISTS (SELECT 1
                                  FROM giac_disb_vouchers z
                                 WHERE z.gacc_tran_id = a.gacc_tran_id AND z.print_tag = 6))
      LOOP
         FOR c2 IN (SELECT b.userid, d.event_desc
                      FROM giis_events_column c,
                           giis_event_mod_users b,
                           giis_event_modules a,
                           giis_events d
                     WHERE 1 = 1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       --AND b.userid <> USER  --A.R.C. 02.06.2006
                       AND b.passing_userid = p_user_id                               --A.R.C. 02.06.2006
                       AND a.module_id = 'GIACS030'
                       AND a.event_cd = d.event_cd
                       AND UPPER (d.event_desc) = 'CLAIM PAYMENTS')
         LOOP
            create_transfer_workflow_rec ('CLAIM PAYMENTS',
                                          'GIACS030',
                                          c2.userid,
                                          c1.claim_id,
                                          c2.event_desc || ' ' || get_clm_no (c1.claim_id),
                                          v_msg_alert,
                                          v_workflow_msgr,
                                          p_user_id
                                         );
         END LOOP;
      END LOOP;
       /* A.R.C. 04.12.2006
      ** to create workflow records of CLAIM PAYMENTS */
      FOR c1 IN (SELECT claim_id
                   FROM giac_inw_claim_payts a
                  WHERE 1 = 1
                    AND a.gacc_tran_id = p_tran_id
                    AND EXISTS (SELECT 1
                                  FROM giac_disb_vouchers z
                                 WHERE z.gacc_tran_id = a.gacc_tran_id AND z.print_tag = 6))
      LOOP
         FOR c2 IN (SELECT b.userid, d.event_desc
                      FROM giis_events_column c,
                           giis_event_mod_users b,
                           giis_event_modules a,
                           giis_events d
                     WHERE 1 = 1
                       AND c.event_cd = a.event_cd
                       AND c.event_mod_cd = a.event_mod_cd
                       AND b.event_mod_cd = a.event_mod_cd
                       --AND b.userid <> USER  --A.R.C. 02.06.2006
                       AND b.passing_userid = p_user_id                               --A.R.C. 02.06.2006
                       AND a.module_id = 'GIACS030'
                       AND a.event_cd = d.event_cd
                       AND UPPER (d.event_desc) = 'CLAIM PAYMENTS')
         LOOP
            create_transfer_workflow_rec ('CLAIM PAYMENTS',
                                          'GIACS030',
                                          c2.userid,
                                          c1.claim_id,
                                          c2.event_desc || ' ' || get_clm_no (c1.claim_id),
                                          v_msg_alert,
                                          v_workflow_msgr,
                                          p_user_id
                                         );
         END LOOP;
      END LOOP;
   END;
/* RCDatz 12-17-2012
** Update the tran month, tran year and tran seq no of GIAC_ACCTRANS
** only if printing of check was sucessful
*/
   PROCEDURE update_giac_tran_mm_yy_seq (
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      v_tran_id     giac_batch_dv.tran_id%TYPE,
      v_tran_date   giac_acctrans.tran_date%TYPE
   )
   IS
      v_tran_year     giac_acctrans.tran_year%TYPE     := TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY'));
      v_tran_month    giac_acctrans.tran_month%TYPE    := TO_NUMBER (TO_CHAR (v_tran_date, 'MM'));
      v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
   BEGIN
      v_tran_seq_no :=
         giac_sequence_generation (p_fund_cd,
                                   p_branch_cd,
                                   'ACCTRAN_TRAN_SEQ_NO',
                                   v_tran_year,
                                   v_tran_month
                                  );
      UPDATE giac_acctrans
         SET tran_year = v_tran_year,
             tran_month = v_tran_month,
             tran_seq_no = v_tran_seq_no
       WHERE tran_id = v_tran_id;
      IF SQL%NOTFOUND
      THEN
         raise_application_error (-20001,
                                     'Geniisys Exception#E#Unable to update giac_acctrans in '
                                  || 'update_giac program units.'
                                 );
      END IF;
   END;
/* Modified By         : RCDatz
** Date Modified   : 12-26-2012
** Remarks         : Comment out the old code and replaced with the one below.
**                                     Added tran_month and tran_seq_no on the update only when
**                                     the check was successfully printed.
*/
   PROCEDURE update_batch_dv (
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      v_tran_id     giac_batch_dv.tran_id%TYPE,
      v_tran_flag   giac_acctrans.tran_flag%TYPE,
      v_tran_date   giac_acctrans.tran_date%TYPE
   )
   IS
      v_tran_year     giac_acctrans.tran_year%TYPE     := TO_NUMBER (TO_CHAR (v_tran_date, 'YYYY'));
      v_tran_month    giac_acctrans.tran_month%TYPE    := TO_NUMBER (TO_CHAR (v_tran_date, 'MM'));
      v_tran_seq_no   giac_acctrans.tran_seq_no%TYPE;
   BEGIN
      FOR chk_bdv IN (SELECT tran_id, tran_year, tran_month, tran_seq_no, gibr_branch_cd
                        FROM giac_acctrans
                       WHERE tran_id IN (SELECT jv_tran_id
                                           FROM giac_batch_dv_dtl
                                          WHERE batch_dv_id IN (SELECT batch_dv_id
                                                                  FROM giac_batch_dv
                                                                 WHERE tran_id = v_tran_id)))
      LOOP
         -- judyann 09192007; to coincide with the tran_date of the corresponding SCSR
         IF chk_bdv.tran_year IS NULL AND chk_bdv.tran_month IS NULL
            AND chk_bdv.tran_seq_no IS NULL
         THEN
            v_tran_seq_no :=
               giac_sequence_generation (p_fund_cd,
                                         p_branch_cd,
                                         'ACCTRAN_TRAN_SEQ_NO',
                                         v_tran_year,
                                         v_tran_month
                                        );
            UPDATE giac_acctrans
               SET tran_flag = v_tran_flag,
                   tran_date = v_tran_date,
                   tran_year = v_tran_year,
                   tran_month = v_tran_month,
                   tran_seq_no = v_tran_seq_no
             WHERE tran_id = chk_bdv.tran_id;
         ELSE
            UPDATE giac_acctrans
               SET tran_flag = v_tran_flag,
                   tran_date = v_tran_date
             WHERE tran_id = chk_bdv.tran_id;
         END IF;
      END LOOP;
   END;
/* Modified by : RCD
** Date : 12.17.2012
** Desc : Call procedures update_giac_tran_mm_yy_seq to update the tran_month, tran_year, tran_seq_no
**          only when check was succesfully printed.
*/
   PROCEDURE update_giac (
      p_gacc_tran_id   giac_chk_disbursement.gacc_tran_id%TYPE,
      p_branch_cd      giac_branches.branch_cd%TYPE,
      p_fund_cd        giac_branches.gfun_fund_cd%TYPE
   )
   IS
      v_exists             VARCHAR2 (1)                   := 'N';
      v_exists2            VARCHAR2 (1)                   := 'N';
      v_check_date         DATE;
      v_check_print_date   DATE;
      v_param_value        NUMBER;
      v_tran_date          giac_acctrans.tran_date%TYPE;
   BEGIN
      --msg_alert('missed none '||:GLOBAL.CG$GIOP_GACC_TRAN_ID,'i',false);
      FOR a IN (SELECT '1'
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = p_gacc_tran_id AND check_stat LIKE '1')
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
      IF v_exists = 'N'
      THEN
         FOR b IN (SELECT '1'
                     FROM giac_disb_vouchers
                    WHERE gacc_tran_id = p_gacc_tran_id AND dv_flag LIKE 'A')
         LOOP
            v_exists := 'Y';
            EXIT;
         END LOOP;
      END IF;
      IF v_exists = 'N'
      THEN
--added by lina
--02/14/2007
--to check if there are existing checks in giac_chk_disbursement
--if none then do not update
         FOR a IN (SELECT '1', TRUNC (check_date) check_date,
                          TRUNC (check_print_date) check_print_date
                     FROM giac_chk_disbursement
                    WHERE gacc_tran_id = p_gacc_tran_id)
         LOOP
            v_exists2 := 'Y';
            v_check_date := a.check_date;                                        --jason 04/12/2007
            v_check_print_date := a.check_print_date;                            --jason 04/12/2007
            EXIT;
         END LOOP;
--end of modification 02/14/2007
         IF v_exists2 = 'Y'
         THEN
         --changed location by gab 06.29.2016 SR 5556
--            UPDATE giac_acctrans
--               SET tran_flag = 'C'
--             WHERE tran_id = p_gacc_tran_id;
            --update_batch_dv(:GLOBAL.CG$GIOP_GACC_TRAN_ID, 'C');
            --added by jason 04/12/2007 start--
            --updates the value of tran_date in giac_acctrans
            BEGIN
               SELECT param_value_v
                 INTO v_param_value
                 FROM giac_parameters
                WHERE param_name LIKE 'DISB_TRAN_DATE';
               IF v_param_value = 2
               THEN
                  UPDATE giac_acctrans
                     SET tran_date = v_check_date
                   WHERE tran_id = p_gacc_tran_id;
                  v_tran_date := v_check_date;
               ELSIF v_param_value = 3
               THEN
                  UPDATE giac_acctrans
                     SET tran_date = v_check_print_date
                   WHERE tran_id = p_gacc_tran_id;
                  v_tran_date := v_check_print_date;
               ELSE
                  BEGIN
                     SELECT TRUNC (tran_date)
                       INTO v_tran_date
                       FROM giac_acctrans
                      WHERE tran_id = p_gacc_tran_id;
                  EXCEPTION
                     WHEN NO_DATA_FOUND
                     THEN
                        raise_application_error (-20001,
                                                 'Geniisys Exception#E#No value for TRAN_DATE'
                                                );
                  END;
               END IF;
               BEGIN                                                       --RCDatz 12.17.2012 Begin
                  FOR exist IN (SELECT tran_id, tran_year, tran_month, tran_seq_no
                                  FROM giac_acctrans
                                 WHERE tran_id = p_gacc_tran_id)
                  LOOP
                     IF     exist.tran_seq_no IS NULL
                        AND exist.tran_year IS NULL
                        AND exist.tran_month IS NULL
                     THEN
                        update_giac_tran_mm_yy_seq (p_branch_cd,
                                                    p_fund_cd,
                                                    p_gacc_tran_id,
                                                    v_tran_date
                                                   );
                     END IF;
                  END LOOP;
               END;                                                          --RCDatz 12.17.2012 End
               update_batch_dv (p_branch_cd, p_fund_cd, p_gacc_tran_id, 'C', v_tran_date);
               IF SQL%NOTFOUND
               THEN
                  --FORMS_DDL ('ROLLBACK');
                  raise_application_error (-20001,
                                           'Geniisys Exception#E#Error updating giac_acctrans.'
                                          );
               END IF;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  raise_application_error
                     (-20001,
                      'Geniisys Exception#E#Parameter DISB_TRAN_DATE does not exist in GIAC_PARAMETERS'
                     );
            END;
         --added by jason 04/12/2007 end--
            
--           changed location by gab 06.29.2016 SR 5556
            UPDATE giac_acctrans
               SET tran_flag = 'C'
             WHERE tran_id = p_gacc_tran_id;
         END IF;
      END IF;
   END;
   PROCEDURE process_aft_print (
      p_gacc_tran_id                giac_chk_disbursement.gacc_tran_id%TYPE,
      p_fund_cd                     giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd                   giac_branches.branch_cd%TYPE,
      p_item_no                     giac_chk_disbursement.item_no%TYPE,
      p_bank_cd                     giac_chk_disbursement.bank_cd%TYPE,
      p_bank_acct_cd                giac_chk_disbursement.bank_acct_cd%TYPE,
      p_user_id                     giis_users.user_id%TYPE,
      p_check_dv_print              VARCHAR2,
      p_print_dv                    VARCHAR2,
      p_print_check                 VARCHAR2,
      p_check_date                  giac_chk_disbursement.check_date%TYPE,
      p_disb_mode                   giac_chk_disbursement.disb_mode%TYPE,
      p_dv_flag            IN OUT   VARCHAR2,
      p_check_cnt                   VARCHAR2,
      p_prt_dv                      VARCHAR2,
      p_prt_chk                     VARCHAR2,
      p_document_cd                 giac_payt_requests.document_cd%TYPE, -- added by: Nica 06.11.2013 AC-SPECS-2012-153
      p_chk_prefix         IN OUT   VARCHAR2,
      p_check_no           IN OUT   VARCHAR2,
      p_still_with_check   OUT      VARCHAR2,
      p_dv_flag_mean       OUT      VARCHAR2
   )
   IS
   v_exist_chk_dv   VARCHAR2(1) := 'N';
   v_print_tag      giac_disb_vouchers.print_tag%TYPE;
   v_tran_flag      giac_acctrans.tran_flag%TYPE    := get_tran_flag(p_gacc_tran_id);  --added by robert SR 5469 03.15.16
/*Modified by:    Vincent
**Date Modified:  072605
**Modification:      commented out update_giac and placed it in program unit is_printing_ok
         so that giac_acctrans will be updated only if the check has been printed successfully
         to avoid the unnecessary firing of db trigger GIAC_ACCTRANS_TAIUD
*/
   BEGIN
      p_still_with_check := 'N';
--      DECLARE
--         may_check_pa_ba   BOOLEAN := FALSE;
      BEGIN
--         IF FORM_SUCCESS
--         THEN
         IF p_check_dv_print = '1'
         THEN
            ins_upd_chk_no (p_gacc_tran_id,
                            p_item_no,
                            p_bank_acct_cd,
                            p_bank_cd,
                            p_branch_cd,
                            p_fund_cd,
                            p_user_id,
                            p_print_dv,
                            p_print_check,
                            p_chk_prefix,
                            p_check_no
                           );
            update_gcdb (p_gacc_tran_id,
                         p_item_no,
                         p_user_id,
                         p_chk_prefix,
                         p_check_no,
                         p_check_date
                        );                      -- update check_no, prmefix, check_date, check_stat.
            update_gidv (p_gacc_tran_id,
                         p_user_id,
                         p_check_dv_print,
                         p_dv_flag,
                         p_prt_chk,
                         p_prt_dv,
                         p_check_cnt,
                         p_document_cd -- added by: Nica 06.11.2013 - AC-SPECS-2012-153
                        );                                 -- update dv_flag, print_date, print_tag.
            --update_giac;  -- update tran_flag. --Vincent 072605
            --FORMS_DDL ('COMMIT');
            --is_printing_ok;                                                        --jason 08092007
            --clear_a940;
         --is_printing_ok; --commented by jason 08092007 and transferred above to fix restoring of check
         ELSIF p_check_dv_print = '2'
         THEN
            IF p_print_check = 'Y'
            THEN
               ins_upd_chk_no (p_gacc_tran_id,
                               p_item_no,
                               p_bank_acct_cd,
                               p_bank_cd,
                               p_branch_cd,
                               p_fund_cd,
                               p_user_id,
                               p_print_dv,
                               p_print_check,
                               p_chk_prefix,
                               p_check_no
                              );
               update_gcdb (p_gacc_tran_id,
                            p_item_no,
                            p_user_id,
                            p_chk_prefix,
                            p_check_no,
                            p_check_date
                           );
            ELSIF p_print_check = 'N' AND p_disb_mode = 'B'
                  AND v_tran_flag NOT IN ('C','P') --added tran_flag by robert SR 5469 03.15.16
            THEN                              -- judyann 05302011; for bank transfer DV transactions
               ins_upd_chk_no (p_gacc_tran_id,
                               p_item_no,
                               p_bank_acct_cd,
                               p_bank_cd,
                               p_branch_cd,
                               p_fund_cd,
                               p_user_id,
                               p_print_dv,
                               p_print_check,
                               p_chk_prefix,
                               p_check_no
                              );
               update_gcdb (p_gacc_tran_id,
                            p_item_no,
                            p_user_id,
                            p_chk_prefix,
                            p_check_no,
                            p_check_date
                           );
               update_giac (p_gacc_tran_id, p_branch_cd, p_fund_cd);
--               clear_some_items;
            END IF;
            IF v_tran_flag NOT IN ('C','P') THEN --added tran_flag by robert SR 5469 03.15.16
            update_gidv (p_gacc_tran_id,
                         p_user_id,
                         p_check_dv_print,
                         p_dv_flag,
                         p_prt_chk,
                         p_prt_dv,
                         p_check_cnt,
                         p_document_cd -- added by: Nica 06.11.2013 - AC-SPECS-2012-153
                        );                                        -- update some fields depending on
            END IF; --added by robert SR 5469 03.15.16
            -- whether a chk or DV was printed
            --  an unprinted chk still exists.
            --update_giac;--Vincent 072605
            --FORMS_DDL('COMMIT');--Vincent 092205: comment out
            IF p_print_check = 'N'
               AND v_tran_flag NOT IN ('C','P') --added tran_flag by robert SR 5469 03.15.16
            THEN
               update_giac (p_gacc_tran_id, p_branch_cd, p_fund_cd);
                                   --Vincent 092205: added to update acctrans if dv is printed last
               --p_print_dv := 'N';
               --:a940.dv_printer := NULL;
--               SET_ITEM_PROPERTY ('A940.check_printer', enabled, property_off);
--               SET_ITEM_PROPERTY ('A940.dv_printer', enabled, property_off);
            END IF;
         --FORMS_DDL ('COMMIT');
                             --Vincent 092205: issue commit after processing all program units
         ELSIF p_check_dv_print = '3'
         THEN
            ins_upd_chk_no (p_gacc_tran_id,
                            p_item_no,
                            p_bank_acct_cd,
                            p_bank_cd,
                            p_branch_cd,
                            p_fund_cd,
                            p_user_id,
                            p_print_dv,
                            p_print_check,
                            p_chk_prefix,
                            p_check_no
                           );
            update_gcdb (p_gacc_tran_id,
                         p_item_no,
                         p_user_id,
                         p_chk_prefix,
                         p_check_no,
                         p_check_date
                        );
            --added by steven 09.15.2014
            FOR chk IN (SELECT '1'
                          FROM giac_chk_disbursement
                         WHERE gacc_tran_id = p_gacc_tran_id
                         AND check_stat = 1)
            LOOP
                v_exist_chk_dv := 'Y';
            END LOOP;
            IF v_exist_chk_dv = 'Y' THEN
                v_print_tag := 5;
            ELSE
                v_print_tag := 6;
            END IF;
            -- START added by jayson 03.24.2010 --
            -- to update print_tag in GIAC_DISB_VOUCHER after printing the check
            UPDATE giac_disb_vouchers
               SET print_tag = v_print_tag,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = p_gacc_tran_id;
            IF SQL%NOTFOUND
            THEN
               raise_application_error (-20001,
                                        'Geniisys Exception#E#Error updating giac_disb_vouchers.'
                                       );
            END IF;
            IF p_document_cd = giacp.v('FACUL_RI_PREM_PAYT_DOC') THEN -- added by: Nica 06.11.2013 AC-SPECS-2012-153 --change by steven 09.24.2014; 'OFPPR'
                GIACS052_pkg.insert_into_cm_dm(p_gacc_tran_id, p_user_id);
            END IF;
         -- END added by jayson 03.24.2010 --
         --FORMS_DDL ('COMMIT');
         --is_printing_ok;
         --clear_a940;
         ELSIF p_check_dv_print = '4'
               AND v_tran_flag NOT IN ('C','P')
         THEN
            update_gidv (p_gacc_tran_id,
                         p_user_id,
                         p_check_dv_print,
                         p_dv_flag,
                         p_prt_chk,
                         p_prt_dv,
                         p_check_cnt,
                         p_document_cd -- added by: Nica 06.11.2013 - AC-SPECS-2012-153
                        );                                 -- update dv_flag, print_date, print_tag.
         --update_giac; --Vincent 072605
         --FORMS_DDL ('COMMIT');
         END IF;
         FOR c IN (SELECT 1
                     FROM giac_chk_disbursement gcdb
                    WHERE gcdb.gacc_tran_id = p_gacc_tran_id AND gcdb.check_stat = 1)
         LOOP
            p_still_with_check := 'Y';
         END LOOP;
--         IF may_check_pa_ba = FALSE
--         THEN
--            SET_ITEM_PROPERTY ('A940.print_check', enabled, property_off);
--            SET_ITEM_PROPERTY ('A940.item_no', required, property_off);
--            --SET_ITEM_PROPERTY('A940.item_no', navigable, PROPERTY_OFF);
--            SET_ITEM_PROPERTY ('A940.item_no', enabled, property_off);
--            SET_ITEM_PROPERTY ('A940.check_printer', enabled, property_off);
--            SET_ITEM_PROPERTY ('A940.check_no', required, property_off);
--            --SET_ITEM_PROPERTY('A940.check_no', navigable, PROPERTY_OFF);
--            SET_ITEM_PROPERTY ('A940.check_no', enabled, property_off);
--            --SET_ITEM_PROPERTY('A940.chk_prefix', navigable, PROPERTY_OFF);
--            SET_ITEM_PROPERTY ('A940.chk_prefix', enabled, property_off);
--            SET_ITEM_PROPERTY ('A940.check_date', required, property_off);
--            --SET_ITEM_PROPERTY('A940.check_date', navigable, PROPERTY_OFF);
--            SET_ITEM_PROPERTY ('A940.check_date', enabled, property_off);
--            a940.payee := NULL;
      --            IF :GLOBAL.check_dv_print IN ('1', '3')
--            THEN
--               SET_ITEM_PROPERTY ('A940.print', enabled, property_off);
--            END IF;
--         END IF;
----------------------------------------------------- Terrence
      END;
      -- added by Kris to return DV Flag and mean
      BEGIN
        SELECT dv_flag
          INTO p_dv_flag
          FROM giac_disb_vouchers
         WHERE gacc_tran_id = p_gacc_tran_id;
        SELECT rv_meaning
          INTO p_dv_flag_mean
          FROM cg_ref_codes
         WHERE rv_domain LIKE 'GIAC_DISB_VOUCHERS.DV_FLAG'
           AND rv_low_value = p_dv_flag;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
            NULL;
      END;
   END;
   FUNCTION get_check_stat (
      p_gacc_tran_id   giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no        giac_chk_disbursement.item_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_check_stat   giac_chk_disbursement.check_stat%TYPE;
   BEGIN
      FOR a IN (SELECT check_stat
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no)
      LOOP
         v_check_stat := a.check_stat;
         EXIT;
      END LOOP;
      RETURN (v_check_stat);
   END;
-- transfer the gcdb record to giac_spoiled_check
-- print_dt is the gcdb.last_update;
   PROCEDURE spoil_check (
      p_gacc_tran_id     giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no          giac_chk_disbursement.item_no%TYPE,
      p_fund_cd          giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_check_dv_print   VARCHAR2,
      p_check_cnt        VARCHAR2
   )
   IS
      v_check_stat   giac_chk_disbursement.check_stat%TYPE;
      v_tran_flag    giac_acctrans.tran_flag%TYPE;
      v_dv_flag      giac_disb_vouchers.dv_flag%TYPE;
      v_print_tag    giac_disb_vouchers.print_tag%TYPE;
      v_prtd_chk     NUMBER                                  := 0;
   BEGIN
      v_check_stat := get_check_stat (p_gacc_tran_id, p_item_no);
      IF v_check_stat <> '2'
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Check spoiling not allowed.');
      ELSE
         v_tran_flag := get_tran_flag (p_gacc_tran_id);
         IF v_tran_flag IN ('O', 'C')
         THEN
            DECLARE
               CURSOR chk_rec
               IS
                  SELECT bank_cd, bank_acct_cd, check_date, check_pref_suf, check_no, check_stat,
                         check_class, currency_cd, fcurrency_amt, currency_rt, amount, last_update
                    FROM giac_chk_disbursement
                   WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no;
               v_chk_rec   chk_rec%ROWTYPE;
            BEGIN
               OPEN chk_rec;
               FETCH chk_rec
                INTO v_chk_rec;
               IF chk_rec%FOUND
               THEN
                  INSERT INTO giac_spoiled_check
                              (gacc_tran_id, item_no, bank_cd,
                               bank_acct_cd, check_date,
                               check_pref_suf, check_no, check_stat,
                               check_class, currency_cd,
                               fcurrency_amt, currency_rt, amount,
                               print_dt, user_id, last_update
                              )
                       VALUES (p_gacc_tran_id, p_item_no, v_chk_rec.bank_cd,
                               v_chk_rec.bank_acct_cd, v_chk_rec.check_date,
                               v_chk_rec.check_pref_suf, v_chk_rec.check_no, v_chk_rec.check_stat,
                               v_chk_rec.check_class, v_chk_rec.currency_cd,
                               v_chk_rec.fcurrency_amt, v_chk_rec.currency_rt, v_chk_rec.amount,
                               v_chk_rec.last_update, p_user_id, SYSDATE
                              );
                  IF SQL%NOTFOUND
                  THEN
                     raise_application_error
                          (-20001,
                           'Geniisys Exception#E#Spoil check: Unable to insert into spoiled_check.'
                          );
                  END IF;
               END IF;
               CLOSE chk_rec;
            END;
            FOR b IN (SELECT COUNT (*) prt
                        FROM giac_chk_disbursement
                       WHERE gacc_tran_id = p_gacc_tran_id AND check_stat LIKE '2')
            LOOP
               v_prtd_chk := b.prt;
               EXIT;
            END LOOP;
            IF p_check_dv_print = '1'
            THEN
               UPDATE giac_disb_vouchers
                  SET dv_print_date = NULL,
                      dv_flag = 'A',
                      print_tag = 1,
                      user_id = p_user_id,
                      last_update = SYSDATE
                WHERE gacc_tran_id = p_gacc_tran_id;
               IF SQL%NOTFOUND
               THEN
                  raise_application_error
                               (-20001,
                                'Geniisys Exception#E#Spoil check: Unable to update disb_vouchers.'
                               );
               END IF;
            ELSIF p_check_dv_print = '2'
            THEN
               FOR a IN (SELECT dv_flag
                           FROM giac_disb_vouchers
                          WHERE gacc_tran_id = p_gacc_tran_id)
               LOOP
                  v_dv_flag := a.dv_flag;
                  EXIT;
               END LOOP;
               IF p_check_cnt = 1
               THEN
                  IF v_dv_flag = 'A'
                  THEN
                     v_print_tag := 1;
                  ELSIF v_dv_flag = 'P'
                  THEN
                     v_print_tag := 4;
                  END IF;
               ELSIF p_check_cnt > 1
               THEN
                  IF v_dv_flag = 'A'
                  THEN
                     IF v_prtd_chk = 1
                     THEN
                        v_print_tag := 1;
                     ELSIF v_prtd_chk > 1
                     THEN
                        v_print_tag := 2;
                     END IF;
                  ELSIF v_dv_flag = 'P'
                  THEN
                     IF v_prtd_chk = 1
                     THEN
                        v_print_tag := 4;
                     ELSIF v_prtd_chk > 1
                     THEN
                        v_print_tag := 5;
                     END IF;
                  END IF;                                                              -- v_dv_flag.
               END IF;                                                          -- GLOBAL.check_cnt.
               UPDATE giac_disb_vouchers
                  SET print_tag = v_print_tag,
                      user_id = p_user_id,
                      last_update = SYSDATE
                WHERE gacc_tran_id = p_gacc_tran_id;
               IF SQL%NOTFOUND
               THEN
                  raise_application_error
                               (-20001,
                                'Geniisys Exception#E#Spoil check: Unable to update disb_vouchers.'
                               );
               END IF;
            ELSIF p_check_dv_print = '3'
            THEN
               IF p_check_cnt = 1
               THEN
                  v_print_tag := 4;
               ELSIF p_check_cnt > 1
               THEN
                  IF v_prtd_chk = 1
                  THEN
                     v_print_tag := 4;
                  ELSIF v_prtd_chk > 1
                  THEN
                     v_print_tag := 5;
                  END IF;
               END IF;
               UPDATE giac_disb_vouchers
                  SET print_tag = v_print_tag,
                      user_id = p_user_id,
                      last_update = SYSDATE
                WHERE gacc_tran_id = p_gacc_tran_id;
               IF SQL%NOTFOUND
               THEN
                  raise_application_error
                               (-20001,
                                'Geniisys Exception#E#Spoil check: Unable to update disb_vouchers.'
                               );
               END IF;
            END IF;
---------
            UPDATE giac_chk_disbursement
               SET check_pref_suf = NULL,
                   check_no = NULL,
                   check_stat = '1',
                   check_date = NULL,
                   user_id = p_user_id,
                   last_update = SYSDATE
             WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no;
            IF SQL%NOTFOUND
            THEN
               raise_application_error
                            (-20001,
                             'Geniisys Exception#E#Spoil check: Unable to update chk_disbursement.'
                            );
            END IF;
         ELSIF v_tran_flag = 'D'
         THEN
            raise_application_error
                                (-20001,
                                    'Geniisys Exception#E#Spoiling not allowed. This is a deleted '
                                 || 'transaction.'
                                );
         ELSIF v_tran_flag = 'P'
         THEN
            raise_application_error
                                 (-20001,
                                     'Geniisys Exception#E#Spoiling not allowed. This is a posted '
                                  || 'transaction.'
                                 );
         END IF;
      END IF;
   END;
   PROCEDURE restore_check (
      p_gacc_tran_id     giac_chk_disbursement.gacc_tran_id%TYPE,
      p_item_no          giac_chk_disbursement.item_no%TYPE,
      p_fund_cd          giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd        giac_branches.branch_cd%TYPE,
      p_user_id          giis_users.user_id%TYPE,
      p_bank_cd          giac_chk_disbursement.bank_cd%TYPE,
      p_bank_acct_cd     giac_chk_disbursement.bank_acct_cd%TYPE,
      p_check_date       giac_chk_disbursement.check_date%TYPE,
      p_check_dv_print   VARCHAR2,
      p_check_cnt        VARCHAR2,
      p_chk_prefix       VARCHAR2,
      p_check_no         VARCHAR2
   )
   IS
      v_hist_seq_no   giac_restored_chk.hist_seq_no%TYPE;
      v_print_tag     giac_disb_vouchers.print_tag%TYPE;
      v_chk_exists    VARCHAR2 (1)                         := 'N';
      v_dv_flag       giac_disb_vouchers.dv_flag%TYPE;
      v_tran_flag     giac_acctrans.tran_flag%TYPE;
      v_prtd_chk      NUMBER                               := 0;
   BEGIN
      BEGIN
         SELECT restored_chk_hist_seq_no_s.NEXTVAL
           INTO v_hist_seq_no
           FROM DUAL;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Error fetching restored_chk_hist_s.'
                                    );
      END;
      INSERT INTO giac_restored_chk
                  (fund_cd, branch_cd, tran_id, hist_seq_no, bank_cd,
                   bank_acct_cd, check_pref_suf, check_no, check_date, user_id, last_update
                  )
           VALUES (p_fund_cd, p_branch_cd, p_gacc_tran_id, v_hist_seq_no, p_bank_cd,
                   p_bank_acct_cd, p_chk_prefix, p_check_no, p_check_date, p_user_id, SYSDATE
                  );
      IF SQL%NOTFOUND
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Unable to insert into giac_restored_chk.'
                                 );
      END IF;
      FOR b IN (SELECT COUNT (*) prt
                  FROM giac_chk_disbursement
                 WHERE gacc_tran_id = p_gacc_tran_id AND check_stat LIKE '2')
      LOOP
         v_prtd_chk := b.prt;
         EXIT;
      END LOOP;
      IF p_check_dv_print = '1'
      THEN
         UPDATE giac_disb_vouchers
            SET print_tag = 1,
                dv_print_date = NULL,
                dv_flag = 'A',
                user_id = p_user_id,
                last_update = SYSDATE
          WHERE gacc_tran_id = p_gacc_tran_id;
         IF SQL%NOTFOUND
         THEN
            raise_application_error
                        (-20001,
                         'Geniisys Exception#E#Restore check: Unable to update giac_disb_vouchers.'
                        );
         END IF;
      ELSIF p_check_dv_print = '2'
      THEN
         FOR a IN (SELECT dv_flag
                     FROM giac_disb_vouchers
                    WHERE gacc_tran_id = p_gacc_tran_id)
         LOOP
            v_dv_flag := a.dv_flag;
            EXIT;
         END LOOP;
         IF p_check_cnt = 1
         THEN
            IF v_dv_flag = 'A'
            THEN
               v_print_tag := 1;
            ELSIF v_dv_flag = 'P'
            THEN
               v_print_tag := 4;
            END IF;
         ELSIF p_check_cnt > 1
         THEN
            IF v_dv_flag = 'A'
            THEN
               IF v_prtd_chk = 1
               THEN
                  v_print_tag := 1;
               ELSIF v_prtd_chk > 1
               THEN
                  v_print_tag := 2;
               END IF;
            ELSIF v_dv_flag = 'P'
            THEN
               IF v_prtd_chk = 1
               THEN
                  v_print_tag := 4;
               ELSIF v_prtd_chk > 1
               THEN
                  v_print_tag := 5;
               END IF;
            END IF;                                                                    -- v_dv_flag.
         END IF;                                                                -- GLOBAL.check_cnt.
         UPDATE giac_disb_vouchers
            SET print_tag = v_print_tag,
                user_id = p_user_id,
                last_update = SYSDATE
          WHERE gacc_tran_id = p_gacc_tran_id;
         IF SQL%NOTFOUND
         THEN
            raise_application_error
                             (-20001,
                              'Geniisys Exception#E#Restore check: Unable to update disb_vouchers.'
                             );
         END IF;
      ELSIF p_check_dv_print = '3'
      THEN
         IF p_check_cnt = 1
         THEN
            v_print_tag := 4;
         ELSIF p_check_cnt > 1
         THEN
            IF v_prtd_chk = 1
            THEN
               v_print_tag := 4;
            ELSIF v_prtd_chk > 1
            THEN
               v_print_tag := 5;
            END IF;
         END IF;
         UPDATE giac_disb_vouchers
            SET print_tag = v_print_tag,
                user_id = p_user_id,
                last_update = SYSDATE
          WHERE gacc_tran_id = p_gacc_tran_id;
         IF SQL%NOTFOUND
         THEN
            raise_application_error
                             (-20001,
                              'Geniisys Exception#E#Restore check: Unable to update disb_vouchers.'
                             );
         END IF;
      END IF;
---------
      UPDATE giac_chk_disbursement
         SET check_pref_suf = NULL,
             check_no = NULL,
             check_date = NULL,
             check_stat = '1',
             user_id = p_user_id,
             last_update = SYSDATE
       WHERE gacc_tran_id = p_gacc_tran_id AND item_no = p_item_no;
      IF SQL%NOTFOUND
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Unable to update giac_chk_disbursement.'
                                 );
      END IF;
      UPDATE giac_check_no
         SET check_seq_no = check_seq_no - 1
       WHERE NVL (chk_prefix, '-') = NVL (p_chk_prefix, NVL (chk_prefix, '-'))
         AND fund_cd = p_fund_cd
         AND branch_cd = p_branch_cd
         AND bank_cd = p_bank_cd
         AND bank_acct_cd = p_bank_acct_cd;
      IF SQL%NOTFOUND
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Unable to update giac_check_no.');
      END IF;
   END;
   PROCEDURE check_dup_or (
      p_bank_cd        giac_chk_disbursement.bank_cd%TYPE,
      p_bank_acct_cd   giac_chk_disbursement.bank_acct_cd%TYPE,
      p_chk_prefix     VARCHAR2,
      p_check_no       VARCHAR2
   )
   IS
      v_check_pref    giac_chk_disbursement.check_pref_suf%TYPE;
      v_check_no      giac_chk_disbursement.check_no%TYPE;
      v_check_pref2   giac_spoiled_check.check_pref_suf%TYPE;
      v_check_no2     giac_spoiled_check.check_no%TYPE;
   BEGIN
      SELECT check_pref_suf, check_no
        INTO v_check_pref, v_check_no
        FROM giac_chk_disbursement gcdb
       WHERE gcdb.bank_cd = p_bank_cd                                                            --/
         AND gcdb.bank_acct_cd = p_bank_acct_cd                                                  --/
         AND gcdb.check_pref_suf = p_chk_prefix
         AND gcdb.check_no = p_check_no;
--      :a940.check_no := variables.prev_check_no;                                  --jason 07/23/2007
--      :a940.chk_prefix := variables.prev_chk_prefix;                              --jason 07/23/2007
      raise_application_error (-20001, 'Geniisys Exception#I#This Check No. already exists.');
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         BEGIN
            SELECT check_pref_suf, check_no
              INTO v_check_pref2, v_check_no2
              FROM giac_spoiled_check
             WHERE bank_cd = p_bank_cd                                                           --/
               AND bank_acct_cd = p_bank_acct_cd                                                 --/
               AND check_pref_suf = p_chk_prefix
               AND check_no = p_check_no;
            raise_application_error (-20001,
                                     'Geniisys Exception#I#This Check No. has been spoiled.');
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
--               SET_ITEM_PROPERTY ('a940.chk_prefix', item_is_valid, property_on);
--               SET_ITEM_PROPERTY ('a940.check_no', item_is_valid, property_on);
               NULL;
         END;
   END;
   /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : 06.11.2013
    **  Reference By : GIACS052 - DV / Check Printing
    **  Description  : For AC-SPECS-2012-153
    **                This procedure checks the existence of
    **                GL codes in GIAC_CHART_OF_ACCTS.
    */
    PROCEDURE aeg_check_chart_of_accts
        (cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE ) IS
    BEGIN
      SELECT DISTINCT(gl_acct_id)
        INTO cca_gl_acct_id
        FROM GIAC_CHART_OF_ACCTS
       WHERE gl_acct_category  = cca_gl_acct_category
         AND gl_control_acct   = cca_gl_control_acct
         AND gl_sub_acct_1     = cca_gl_sub_acct_1
         AND gl_sub_acct_2     = cca_gl_sub_acct_2
         AND gl_sub_acct_3     = cca_gl_sub_acct_3
         AND gl_sub_acct_4     = cca_gl_sub_acct_4
         AND gl_sub_acct_5     = cca_gl_sub_acct_5
         AND gl_sub_acct_6     = cca_gl_sub_acct_6
         AND gl_sub_acct_7     = cca_gl_sub_acct_7;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#GL account code '
                       ||TO_CHAR(cca_gl_acct_category)
                  ||'-'||TO_CHAR(cca_gl_control_acct,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_1,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_2,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_3,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_4,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_5,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_6,'09')
                  ||'-'||TO_CHAR(cca_gl_sub_acct_7,'09')
                  ||' does not exist in Chart of Accounts (Giac_Acctrans).' );
    END;
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.11.2013
    **  Reference By  : GIACS052 - DV / Check Printing
    **  Description   : For AC-SPECS-2012-153
    **                  This procedure determines whether the records will be updated
    **                  or inserted in GIAC_ACCT_ENTRIES.
    */
    PROCEDURE aeg_insert_update_acct_entries
        (p_fund_cd                GIIS_FUNDS.fund_cd%TYPE,
         p_branch_cd             GIAC_BRANCHES.branch_cd%TYPE,
         p_tran_id                GIAC_ACCTRANS.tran_id%TYPE,
         p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
         iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
         iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
         iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
         iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
         iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
         iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
         iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
         iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
         iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
         iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
         iuae_generation_type   GIAC_ACCT_ENTRIES.generation_type%TYPE,
         iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%TYPE,
         iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,
         iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%TYPE,
         iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%TYPE) IS
         iuae_acct_entry_id     giac_acct_entries.acct_entry_id%TYPE;
    BEGIN
      SELECT NVL(MAX(acct_entry_id),0) acct_entry_id
        INTO iuae_acct_entry_id
        FROM giac_acct_entries
       WHERE gacc_gibr_branch_cd = p_branch_cd
         AND gacc_gfun_fund_cd   = p_fund_cd
         AND gacc_tran_id        = p_tran_id
         AND gl_acct_id          = iuae_gl_acct_id
         AND generation_type     = iuae_generation_type
         AND NVL(sl_cd,0) = NVL(iuae_sl_cd,0); --mikel 09.30.2013 --mikel 09.24.2015; added NVL GENQA RSIC 4984
      IF NVL(iuae_acct_entry_id,0) = 0 THEN
        iuae_acct_entry_id := NVL(iuae_acct_entry_id,0) + 1;
        INSERT INTO GIAC_ACCT_ENTRIES(gacc_tran_id       , gacc_gfun_fund_cd,
                                      gacc_gibr_branch_cd, acct_entry_id    ,
                                      gl_acct_id         , gl_acct_category ,
                                      gl_control_acct    , gl_sub_acct_1    ,
                                      gl_sub_acct_2      , gl_sub_acct_3    ,
                                      gl_sub_acct_4      , gl_sub_acct_5    ,
                                      gl_sub_acct_6      , gl_sub_acct_7    ,
                                      sl_cd              , generation_type  ,
                                      sl_type_cd         , credit_amt       ,
                                      debit_amt          , user_id          ,
                                      last_update)
           VALUES (p_tran_id                  , p_fund_cd                   ,
                   p_branch_cd                , iuae_acct_entry_id          ,
                   iuae_gl_acct_id            , iuae_gl_acct_category       ,
                   iuae_gl_control_acct       , iuae_gl_sub_acct_1          ,
                   iuae_gl_sub_acct_2         , iuae_gl_sub_acct_3          ,
                   iuae_gl_sub_acct_4         , iuae_gl_sub_acct_5          ,
                   iuae_gl_sub_acct_6         , iuae_gl_sub_acct_7          ,
                   iuae_sl_cd                 , iuae_generation_type        ,
                   iuae_sl_type_cd            , iuae_credit_amt             ,
                   iuae_debit_amt             , p_user_id                   ,
                   SYSDATE);
      ELSE
        UPDATE GIAC_ACCT_ENTRIES
           SET debit_amt  = debit_amt  + iuae_debit_amt,
               credit_amt = credit_amt + iuae_credit_amt
         WHERE generation_type     = iuae_generation_type
           AND gl_acct_id          = iuae_gl_acct_id
           AND gacc_gibr_branch_cd = p_branch_cd
           AND gacc_gfun_fund_cd   = p_fund_cd
           AND gacc_tran_id        = p_tran_id
           AND NVL(sl_cd, 0)       = NVL(iuae_sl_cd, 0);  --mikel 09.30.2013 --mikel 09.09.2015; added NVL GENQA RSIC 4984
      END IF;
    END;
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.11.2013
    **  Reference By  : GIACS052 - DV / Check Printing
    **  Description  : For AC-SPECS-2012-153
    **                This procedure handles the creation of accounting entries per transaction.
    */
    PROCEDURE aeg_create_acct_entries
      (p_fund_cd              GIIS_FUNDS.fund_cd%TYPE,
       p_branch_cd               GIAC_BRANCHES.branch_cd%TYPE,
       p_tran_id              GIAC_ACCTRANS.tran_id%TYPE,
       p_user_id              GIAC_ACCT_ENTRIES.user_id%TYPE,
       aeg_module_id          GIAC_MODULE_ENTRIES.module_id%TYPE,
       aeg_item_no            GIAC_MODULE_ENTRIES.item_no%TYPE,
       aeg_acct_amt           GIAC_CM_DM.local_amt%TYPE,
       aeg_gen_type           GIAC_ACCT_ENTRIES.generation_type%TYPE,
       aeg_line_cd            GIIS_LINE.line_cd%TYPE, --mikel 09.30.2013
       aeg_sl_cd              GIAC_ACCT_ENTRIES.sl_cd%TYPE) IS
      ws_gl_acct_category              GIAC_ACCT_ENTRIES.gl_acct_category%TYPE;
      ws_gl_control_acct               GIAC_ACCT_ENTRIES.gl_control_acct%TYPE;
      ws_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
      ws_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      ws_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
      ws_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
      ws_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
      ws_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
      ws_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
      ws_sl_type_cd                    GIAC_ACCT_ENTRIES.sl_type_cd%TYPE;
      ws_pol_type_tag                  GIAC_MODULE_ENTRIES.pol_type_tag%TYPE;
      ws_intm_type_level               GIAC_MODULE_ENTRIES.intm_type_level%TYPE;
      ws_old_new_acct_level            GIAC_MODULE_ENTRIES.old_new_acct_level%TYPE;
      ws_line_dep_level                GIAC_MODULE_ENTRIES.line_dependency_level%TYPE;
      ws_dr_cr_tag                     GIAC_MODULE_ENTRIES.dr_cr_tag%TYPE;
      ws_acct_intm_cd                  GIIS_INTM_TYPE.acct_intm_cd%TYPE;
      ws_line_cd                       GIIS_LINE.line_cd%TYPE;
      ws_iss_cd                        GIPI_POLBASIC.iss_cd%TYPE;
      ws_old_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      ws_new_acct_cd                   GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_1                 GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE;
      pt_gl_sub_acct_2                 GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE;
      pt_gl_sub_acct_3                 GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE;
      pt_gl_sub_acct_4                 GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE;
      pt_gl_sub_acct_5                 GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE;
      pt_gl_sub_acct_6                 GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE;
      pt_gl_sub_acct_7                 GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE;
      ws_debit_amt                     GIAC_ACCT_ENTRIES.debit_amt%TYPE;
      ws_credit_amt                    GIAC_ACCT_ENTRIES.credit_amt%TYPE;
      ws_gl_acct_id                    GIAC_ACCT_ENTRIES.gl_acct_id%TYPE;
      
    BEGIN
      /**************************************************************************
      *                                                                         *
      * Populate the GL Account Code used in every transactions.                *
      *                                                                         *
      **************************************************************************/
          BEGIN
            SELECT gl_acct_category        , gl_control_acct    ,
                   gl_sub_acct_1           , gl_sub_acct_2      ,
                   gl_sub_acct_3           , gl_sub_acct_4      ,
                   gl_sub_acct_5           , gl_sub_acct_6     ,
                   gl_sub_acct_7           , sl_type_cd            ,
                   pol_type_tag            , intm_type_level    ,
                   old_new_acct_level    ,    dr_cr_tag         ,
                   line_dependency_level
              INTO ws_gl_acct_category        , ws_gl_control_acct,
                   ws_gl_sub_acct_1           , ws_gl_sub_acct_2  ,
                   ws_gl_sub_acct_3           , ws_gl_sub_acct_4  ,
                   ws_gl_sub_acct_5           , ws_gl_sub_acct_6  ,
                   ws_gl_sub_acct_7           , ws_sl_type_cd            ,
                   ws_pol_type_tag               , ws_intm_type_level,
                   ws_old_new_acct_level    ,    ws_dr_cr_tag      ,
                   ws_line_dep_level
              FROM GIAC_MODULE_ENTRIES
             WHERE module_id = aeg_module_id
               AND item_no   = aeg_item_no
            FOR UPDATE of gl_sub_acct_1;
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              --msg_alert('No data found in giac_module_entries: GIACS071 - Credit/Debit Memo','E',TRUE);
              RAISE_APPLICATION_ERROR(-20001,'Geniisys Exception#E#No data found in giac_module_entries: GIACS071 - Credit/Debit Memo.');
          END;
       --added by mikel 09.30.2013;
      /**************************************************************************
      *                                                                         *
      * Validate the LINE_DEPENDENCY_LEVEL value which indicates the segment of *
      * the GL account code that holds the line number.                         *
      *                                                                         *
      **************************************************************************/
      IF ws_line_dep_level != 0
      THEN
         BEGIN
            SELECT acct_line_cd
              INTO ws_line_cd
              FROM giis_line
             WHERE line_cd = aeg_line_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               RAISE_APPLICATION_ERROR(-20001, 'Geniisys Exception#E#No data found in giis_line.');
               RETURN;
         END;
         aeg_check_level (ws_line_dep_level,
                          ws_line_cd,
                          ws_gl_sub_acct_1,
                          ws_gl_sub_acct_2,
                          ws_gl_sub_acct_3,
                          ws_gl_sub_acct_4,
                          ws_gl_sub_acct_5,
                          ws_gl_sub_acct_6,
                          ws_gl_sub_acct_7
                         );
      END IF;
      --end mikel 09.30.2013
      /**************************************************************************
      *                                                                         *
      * Check if the accounting code exists in GIAC_CHART_OF_ACCTS table.       *
      *                                                                         *
      **************************************************************************/
        giacs052_pkg.aeg_check_chart_of_accts(ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                              ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                              ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                              ws_gl_acct_id);
      /****************************************************************************
      *                                                                           *
      * If the accounting code exists in GIAC_CHART_OF_ACCTS table, validate the  *
      * debit-credit tag to determine whether the positive amount will be debited *
      * or credited.                                                              *
      *                                                                           *
      ****************************************************************************/
        IF ws_dr_cr_tag = 'D' THEN
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := abs(aeg_acct_amt);
            ws_credit_amt := 0;
          ELSE
            ws_debit_amt  := 0;
            ws_credit_amt := abs(aeg_acct_amt);
          END IF;
        ELSE
          IF aeg_acct_amt > 0 THEN
            ws_debit_amt  := 0;
            ws_credit_amt := abs(aeg_acct_amt);
          ELSE
            ws_debit_amt  := abs(aeg_acct_amt);
            ws_credit_amt := 0;
          END IF;
        END IF;
      /****************************************************************************
      *                                                                           *
      * Check if the derived GL code exists in GIAC_ACCT_ENTRIES table for the    *
      * same transaction id.  Insert the record if it does not exists else update *
      * the existing record.                                                      *
      *                                                                           *
      ****************************************************************************/
       IF ws_sl_type_cd IS NOT NULL THEN
           giacs052_pkg.aeg_insert_update_acct_entries
                                         (p_fund_cd          , p_branch_cd       , p_tran_id       , p_user_id,
                                          ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                          ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                          ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                          aeg_sl_cd          , aeg_gen_type      , ws_sl_type_cd   ,
                                          ws_gl_acct_id      , ws_debit_amt      , ws_credit_amt);
       ELSE
           giacs052_pkg.aeg_insert_update_acct_entries
                                         (p_fund_cd          , p_branch_cd       , p_tran_id       , p_user_id,
                                          ws_gl_acct_category, ws_gl_control_acct, ws_gl_sub_acct_1,
                                          ws_gl_sub_acct_2   , ws_gl_sub_acct_3  , ws_gl_sub_acct_4,
                                          ws_gl_sub_acct_5   , ws_gl_sub_acct_6  , ws_gl_sub_acct_7,
                                          NULL               , aeg_gen_type      , ws_sl_type_cd     ,
                                          ws_gl_acct_id      , ws_debit_amt      , ws_credit_amt);
       END IF;
    END;
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.11.2013
    **  Reference By  : GIACS052 - DV / Check Printing
    **  Description  : For AC-SPECS-2012-153
    **                Generation of accounting entries of credit/debit memo
    */
    /*
    ** Modified by :    Mikel
    ** Date modified :  09.28.2013
    ** Modificiations : AC-SPECS-2013-090, AC-SPECS-2013-091 and AC-SPECS-2013-092
    */
    PROCEDURE aeg_parameters
    (p_fund_cd       GIIS_FUNDS.fund_cd%TYPE,
     p_branch_cd     GIAC_BRANCHES.branch_cd%TYPE,
     p_user_id       GIAC_ACCT_ENTRIES.user_id%TYPE,
     aeg_tran_id     GIAC_ACCTRANS.tran_id%TYPE,
     aeg_module_nm   GIAC_MODULES.module_name%TYPE,
     aeg_sl_cd       GIAC_ACCT_ENTRIES.sl_cd%TYPE) IS
     v_module_id     GIAC_MODULES.module_id%TYPE;
     v_module_name   GIAC_MODULES.module_name%TYPE := 'GIACS071';
     v_gen_type      GIAC_MODULES.generation_type%TYPE;
     --mikel 09.28.2013
     v_comm_amt      GIAC_OUTFACUL_PREM_PAYTS.comm_amt%TYPE;
     v_comm_vat      GIAC_OUTFACUL_PREM_PAYTS.comm_vat%TYPE;
     v_comm_rec_batch_takeup  GIAC_PARAMETERS.param_value_v%TYPE := NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N');
     v_outfaul_comm_vat_entry GIAC_PARAMETERS.param_value_v%TYPE := NVL (giacp.v ('OUTFACUL_COMM_VAT_ENTRY'), 'DV');
     v_ri_comm_rec_gross_tag GIAC_PARAMETERS.param_value_v%TYPE  := NVL (giacp.v ('RI_COMM_REC_GROSS_TAG'), 'N'); --mikel 09.23.2015 GENQA 4984     
     
        CURSOR cur_rcm IS
        SELECT NVL(local_amt,0) local_amt
          FROM GIAC_CM_DM
         WHERE gacc_tran_id = aeg_tran_id
           AND memo_type = 'RCM';
       --mikel 09.30.2013
       CURSOR cur_ent IS
       --SELECT NVL (b.comm_amt, 0) comm_amt, NVL (b.comm_vat, 0)comm_vat, c.line_cd, b.a180_ri_cd
       SELECT SUM(NVL(b.comm_amt,0)) comm_amt, SUM(NVL(b.comm_vat,0)) comm_vat, --added SUM function by albert 09.26.2016
              c.line_cd, b.a180_ri_cd
         FROM giac_cm_dm a, giac_outfacul_prem_payts b, giri_binder c
        WHERE a.dv_tran_id = b.gacc_tran_id
          AND b.d010_fnl_binder_id = c.fnl_binder_id
          AND a.gacc_tran_id = aeg_tran_id
          AND b.a180_ri_cd = aeg_sl_cd      --added by albert 09.26.2016; only include records for specific reinsurer 
          AND memo_type = 'RCM'
     GROUP BY c.line_cd, b.a180_ri_cd;      --added by albert 09.26.2016; entries should be grouped per line and per RI
          --added by MArkS 5.25.2016 SR-5484
          /*AND (comm_amt+comm_vat) =(SELECT NVL(local_amt,0) local_amt
          FROM GIAC_CM_DM
         WHERE gacc_tran_id = aeg_tran_id
           AND memo_type = 'RCM');*/--commented out by albert 09.26.2016
          --end SR-5484
    BEGIN
      BEGIN
        SELECT module_id,
               generation_type
          INTO v_module_id,
               v_gen_type
          FROM GIAC_MODULES
         WHERE module_name  = v_module_name;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          --msg_alert('No data found in GIAC MODULES.', 'I', TRUE);
          RAISE_APPLICATION_ERROR (-20001,'Geniisys Exception#I#No data found in GIAC MODULES.');
      END;
--      --mikel 09.28.2013
--      SELECT SUM(NVL (b.comm_amt, 0)) comm_amt, SUM(NVL (b.comm_vat, 0)) comm_vat
--        INTO v_comm_amt, v_comm_vat
--        FROM giac_cm_dm a, giac_outfacul_prem_payts b
--       WHERE a.dv_tran_id = b.gacc_tran_id
--         AND a.gacc_tran_id = aeg_tran_id
--         AND memo_type = 'RCM';
        /*
        ** Call the accounting entry generation procedure.
        */
        --
        FOR rec_cm IN cur_rcm
        LOOP
               /*GIACS052_PKG.aeg_create_acct_entries(
                                      p_fund_cd,
                                      p_branch_cd,
                                      aeg_tran_id,
                                      p_user_id,
                                      v_module_id  ,
                                      1,
                                      rec_cm.local_amt,
                                      v_gen_type,
                                      NULL, --mikel 09.30.2013
                                      --aeg_sl_cd);
                                      NULL); --mikel 09.30.2013*/ --comment out benjo 11.25.2015 AFPGEN-SR-21038
                /*GIACS052_PKG.aeg_create_acct_entries(
                                               p_fund_cd,
                                               p_branch_cd,
                                               aeg_tran_id,
                                               p_user_id,
                                               v_module_id  ,
                                               3,
                                               rec_cm.local_amt,
                                               v_gen_type,
                                               aeg_sl_cd); */ --comment out by mikel 09.28.2013
           --added by mikel 09.28.2013
           FOR rec_ent IN cur_ent
           LOOP
                --benjo 11.25.2015 AFPGEN-SR-21038
                GIACS052_PKG.aeg_create_acct_entries(
                                      p_fund_cd,
                                      p_branch_cd,
                                      aeg_tran_id,
                                      p_user_id,
                                      v_module_id  ,
                                      1,
                                      rec_ent.comm_amt + rec_ent.comm_vat,
                                      v_gen_type,
                                      rec_ent.line_cd,
                                      NULL);
                --benjo end
                
                IF v_outfaul_comm_vat_entry = 'CO' THEN
                    GIACS052_PKG.aeg_create_acct_entries(
                                           p_fund_cd,
                                           p_branch_cd,
                                           aeg_tran_id,
                                           p_user_id,
                                           v_module_id  ,
                                           3,
                                           rec_ent.comm_amt,
                                           v_gen_type,
                                           rec_ent.line_cd,
                                           rec_ent.a180_ri_cd);
                    GIACS052_PKG.aeg_create_acct_entries(
                                           p_fund_cd,
                                           p_branch_cd,
                                           aeg_tran_id,
                                           p_user_id,
                                           v_module_id  ,
                                           4,
                                           rec_ent.comm_vat,
                                           v_gen_type,
                                           rec_ent.line_cd,
                                           rec_ent.a180_ri_cd);
                ELSIF v_outfaul_comm_vat_entry IN ('DV', 'OR') THEN
                    GIACS052_PKG.aeg_create_acct_entries(
                                           p_fund_cd,
                                           p_branch_cd,
                                           aeg_tran_id,
                                           p_user_id,
                                           v_module_id,
                                           3,
                                           --rec_cm.local_amt,
                                           rec_ent.comm_amt + rec_ent.comm_vat, --mikel 09.24.2015; GENQA 4984
                                           v_gen_type,
                                           rec_ent.line_cd,
                                           rec_ent.a180_ri_cd);
                ELSE
                    RAISE_APPLICATION_ERROR (-20010,'Geniisys Exception#I#Invalid parameter value for OUTFACUL_COMM_VAT_ENTRY.');
                END IF;
           END LOOP;
            --end here mikel 09.28.2013
        END LOOP;
    END;
    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : 06.11.2013
    **  Reference By : GIACS052 - DV / Check Printing
    **  Description  : For AC-SPECS-2012-153
    */
    FUNCTION INSERT_INTO_ACCTRANS (
       p_fund_cd     GIIS_FUNDS.fund_cd%TYPE,
       p_branch_cd   GIAC_BRANCHES.branch_cd%TYPE,
       p_memo_date   GIAC_ACCTRANS.tran_date%TYPE,
       p_user_id     GIAC_ACCTRANS.user_id%TYPE
    )
       RETURN NUMBER
    IS
       v_gacc_tran_id   GIAC_ACCTRANS.tran_id%TYPE;
    BEGIN
       BEGIN
          SELECT acctran_tran_id_s.NEXTVAL
            INTO v_gacc_tran_id
            FROM DUAL;
       EXCEPTION
          WHEN NO_DATA_FOUND THEN
             RAISE_APPLICATION_ERROR (-20001,'Geniisys Exception#E#ACCTRAN_TRAN_ID sequence not found.');
             --msg_alert ('ACCTRAN_TRAN_ID sequence not found.', 'E', TRUE);
       END;
       BEGIN
          INSERT INTO GIAC_ACCTRANS
                      (tran_id, gfun_fund_cd, gibr_branch_cd, tran_date,
                       tran_year, tran_month,
                       tran_seq_no,
                       tran_flag, tran_class,
                       particulars, user_id, last_update
                      )
               VALUES (v_gacc_tran_id, p_fund_cd, p_branch_cd, p_memo_date,
                       TO_CHAR (SYSDATE, 'YYYY'), TO_NUMBER (TO_CHAR (SYSDATE, 'MM')),
                       giac_sequence_generation(p_fund_cd, p_branch_cd, 'ACCTRAN_TRAN_SEQ_NO', TO_CHAR (SYSDATE, 'YYYY'), TO_NUMBER (TO_CHAR (SYSDATE, 'MM'))),
                       'C', 'RCM',
                       'To record Binder RI Commissions', p_user_id, SYSDATE
                      );
                RETURN v_gacc_tran_id;
       EXCEPTION
          WHEN OTHERS THEN
             RAISE_APPLICATION_ERROR (-20001,'Geniisys Exception#E#Error occurred.');
       END;
    END;
    /*
    **  Created by   : Veronica V. Raymundo
    **  Date Created : 06.11.2013
    **  Reference By : GIACS052 - DV / Check Printing
    **  Description  : For AC-SPECS-2012-153
    **
    */
    PROCEDURE insert_into_cm_dm (p_gopp_tran_id giac_acctrans.tran_id%TYPE,
                                 p_user_id      giac_acctrans.user_id%TYPE)
    IS
       v_recipient       giac_cm_dm.recipient%TYPE;
       v_dv_tran_date    giac_acctrans.tran_date%TYPE;
       v_local_amt       giac_cm_dm.amount%TYPE                     := 0;
       v_comm_amt        giac_cm_dm.amount%TYPE                        := 0; --Added by Nica 06.27.2013 as per AC-SPECS-2013-072 - to store only comm_vat for COMM_REC_BATCH_TAKEUP with N value
       v_foreign_amt     giac_cm_dm.amount%TYPE                     := 0;
       v_foreign_amt2    giac_cm_dm.amount%TYPE                     := 0; --Added by Nica 06.27.2013 as per AC-SPECS-2013-072 - to store only comm_vat for COMM_REC_BATCH_TAKEUP with N value
       v_currency_cd     gipi_invoice.currency_cd%TYPE;
       v_currency_rt     gipi_invoice.currency_rt%TYPE;
       v_ri_cd           giac_outfacul_prem_payts.a180_ri_cd%TYPE;
       --store only comm_vat for COMM_REC_BATCH_TAKEUP with N value --added by steven 09.26.2014
       v_comm_vat        giac_cm_dm.amount%TYPE                        := 0;
       v_document_cd      giac_payt_requests.document_cd%TYPE;
       v_cm_dm_tran_id     giac_cm_dm.gacc_tran_id%TYPE;
       v_memo_status     giac_cm_dm.memo_status%TYPE;
       v_fund_cd         giis_funds.fund_cd%TYPE;
       v_branch_cd          giac_branches.branch_cd%TYPE;
       v_tran_id         giac_acctrans.tran_id%TYPE;
       v_module_name     giac_modules.module_name%TYPE := 'GIACS071';
       --mikel 09.30.2013; AC-SPECS-2013-090, AC-SPECS-2013-091 and AC-SPECS-2013-092
       v_comm_rec_batch_takeup  GIAC_PARAMETERS.param_value_v%TYPE := NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N');
       v_outfaul_comm_vat_entry GIAC_PARAMETERS.param_value_v%TYPE := NVL (giacp.v ('OUTFACUL_COMM_VAT_ENTRY'), 'DV');
       v_ri_comm_rec_gross_tag  GIAC_PARAMETERS.param_value_v%TYPE := NVL(giacp.v('RI_COMM_REC_GROSS_TAG'),'N'); --added by steven 09.26.2014
    BEGIN
       IF NOT is_cmdm_found (p_gopp_tran_id) --RCD  05.09.2013
        THEN
           BEGIN
              SELECT gibr_gfun_fund_cd fund_cd, gibr_branch_cd branch_cd, payee
                INTO v_fund_cd, v_branch_cd, v_recipient
                FROM giac_disb_vouchers
               WHERE gacc_tran_id = p_gopp_tran_id;
           EXCEPTION
              WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
              THEN
                 --FORMS_DDL ('ROLLBACK');
                 --msg_alert ('Error in fetching fund/branch code.', 'E', TRUE);
                 RAISE_APPLICATION_ERROR (-20001,'Geniisys Exception#E#Error in fetching fund/branch code.');
           END;
           BEGIN
              SELECT tran_date
                INTO v_dv_tran_date
                FROM giac_acctrans
               WHERE tran_id = p_gopp_tran_id;
           EXCEPTION
              WHEN NO_DATA_FOUND OR TOO_MANY_ROWS
              THEN
                 --FORMS_DDL ('ROLLBACK');
                 --msg_alert ('Error in fetching DV tran date.', 'E', TRUE);
                 RAISE_APPLICATION_ERROR (-20001,'Geniisys Exception#E#Error in fetching DV tran date.');
           END;
           BEGIN
           -- Edited by MarkS 5.16.2016 SR-5484
           -- TO insert multiple binders with different reinsurers in giac_cm_dm
           --EDITED by MarkS 9.23.2016 SR23107
		   FOR rec IN
               (SELECT   --a.a180_ri_cd, --comment out by mikel 09.30.2013
                       a.a180_ri_cd,     --added by albert 09.26.2016; obtain ri code to be used as SL
               		   c.ri_name, --added by MarkS sr5484 7.14.2016 to get recipient
                       SUM(NVL (a.comm_amt, 0)) + SUM(NVL(a.comm_vat, 0)) amount,
                       SUM(NVL (a.comm_amt, 0)) comm_amt, --Added by Nica 06.27.2013 as per AC-SPECS-2013-072 - For COMM_REC_BATCH_TAKEUP with Y value
                       SUM(NVL (a.comm_vat, 0)) comm_vat, --added by steve 09.26.2014
                       DECODE (b.currency_cd,
                               1, SUM(NVL (a.comm_amt, 0)) + SUM(NVL (a.comm_vat, 0)),
                                  SUM(NVL(a.comm_amt, 0)) / SUM(NVL (b.currency_rt, 1))
                               + (SUM(NVL(a.comm_vat, 0)) / SUM(NVL (b.currency_rt, 1)))
                               ) foreign_amt,
                       DECODE (b.currency_cd,
                              1, SUM(NVL(a.comm_amt, 0)),
                                 SUM(NVL(a.comm_amt, 0)) / SUM(NVL(b.currency_rt, 1))      
                              ) foreign_amt2, --Added by Nica 06.27.2013 as per AC-SPECS-2013-072 - For COMM_REC_BATCH_TAKEUP with Y value
                       b.currency_cd, b.currency_rt --comment out by mikel 09.30.2013
                  FROM giac_outfacul_prem_payts a, giac_payt_requests_dtl b,giis_reinsurer c
                 WHERE a.gacc_tran_id = b.tran_id
                   AND a.gacc_tran_id = p_gopp_tran_id
                   AND a.a180_ri_cd =c.ri_cd --added by MarkS sr5484 7.14.2016 to get recipient
                   AND a.cm_tag = 'Y'
                 GROUP BY a.a180_ri_cd, c.ri_name, b.currency_cd, b.currency_rt --added by MarkS 9.23.2016 SR23107 --added a180_ri_cd by albert 09.26.2016
                )
            LOOP
            v_tran_id := GIACS052_PKG.insert_into_acctrans (v_fund_cd,       v_branch_cd,
                                                             v_dv_tran_date,  p_user_id);
                                                             
            v_ri_cd := rec.a180_ri_cd; --added by albert 09.26.2016; assign value to v_ri_cd to identify RI upon creation of accounting entries in RCM 
            
            INSERT INTO GIAC_CM_DM
                         (gacc_tran_id, fund_cd,
                          branch_cd, memo_type, memo_date,
                          memo_year,
                          memo_seq_no,
                          recipient, amount, currency_cd,
                          currency_rt, local_amt,
                          particulars, memo_status, user_id, last_update,
                          dv_tran_id
                          ,ri_comm_amt, ri_comm_vat --mikel 09.24.2015; GENQA RSIC 4984
                         )
                  VALUES (v_tran_id, v_fund_cd,
                          v_branch_cd, 'RCM', v_dv_tran_date,
                          TO_CHAR (SYSDATE, 'YYYY'),
                          giac_sequence_generation (v_fund_cd,
                                                    v_branch_cd,
                                                    'RCM',
                                                    TO_CHAR (SYSDATE, 'YYYY'),
                                                    0
                                                   ),
                          --v_recipient
                          rec.ri_name, rec.foreign_amt, rec.currency_cd,
                          rec.currency_rt, rec.amount,
                          'To record Binder RI Commissions', 'U', p_user_id, SYSDATE,
                          p_gopp_tran_id
                          ,rec.comm_amt, rec.comm_vat 
                         );
             GIACS052_PKG.aeg_parameters (v_fund_cd, v_branch_cd, p_user_id, v_tran_id, v_module_name, v_ri_cd);           
             END LOOP;
           --END SR-5484
           END;
           
             /*Added by Nica 06.27.2013 as per AC-SPECS-2013-072 - For COMM_REC_BATCH_TAKEUP with Y value*/
             --IF NVL(giacp.v('COMM_REC_BATCH_TAKEUP'),'N') = 'Y' THEN
             /*IF v_comm_rec_batch_takeup = 'Y' AND v_outfaul_comm_vat_entry IN ('DV', 'OR') THEN --mikel 09.30.2013
               IF v_ri_comm_rec_gross_tag = 'N' --added by steven 09.26.2014
               THEN
                  INSERT INTO giac_cm_dm
                              (gacc_tran_id, fund_cd, branch_cd, memo_type, memo_date,
                               memo_year,
                               memo_seq_no,
                               recipient, amount, currency_cd,
                               currency_rt, local_amt,
                               particulars, memo_status, user_id,
                               last_update, dv_tran_id
                              )
                       VALUES (v_tran_id, v_fund_cd, v_branch_cd, 'RCM', v_dv_tran_date,
                               TO_CHAR (SYSDATE, 'YYYY'),
                               giac_sequence_generation (v_fund_cd,
                                                         v_branch_cd,
                                                         'RCM',
                                                         TO_CHAR (SYSDATE, 'YYYY'),
                                                         0
                                                        ),
                               v_recipient, v_foreign_amt2, v_currency_cd,
                               v_currency_rt, v_comm_amt,
                               'To record Binder RI Commissions', 'U', p_user_id,
                               SYSDATE, p_gopp_tran_id
                              );
               ELSE
                  INSERT INTO giac_cm_dm
                              (gacc_tran_id, fund_cd, branch_cd, memo_type, memo_date,
                               memo_year,
                               memo_seq_no,
                               recipient, amount, currency_cd,
                               currency_rt, local_amt,
                               particulars, memo_status, user_id,
                               last_update, dv_tran_id
                              )
                       VALUES (v_tran_id, v_fund_cd, v_branch_cd, 'RCM', v_dv_tran_date,
                               TO_CHAR (SYSDATE, 'YYYY'),
                               giac_sequence_generation (v_fund_cd,
                                                         v_branch_cd,
                                                         'RCM',
                                                         TO_CHAR (SYSDATE, 'YYYY'),
                                                         0
                                                        ),
                               v_recipient, v_foreign_amt2, v_currency_cd,
                               v_currency_rt, v_comm_amt + v_comm_vat,
                               'To record Binder RI Commissions', 'U', p_user_id,
                               SYSDATE, p_gopp_tran_id
                              );
               END IF;
             ELSE */--mikel 09.24.2015; GENQA RSIC 4984 - amount inserted should be comm plus comm vat
--                  INSERT INTO GIAC_CM_DM
--                         (gacc_tran_id, fund_cd,
--                          branch_cd, memo_type, memo_date,
--                          memo_year,
--                          memo_seq_no,
--                          recipient, amount, currency_cd,
--                          currency_rt, local_amt,
--                          particulars, memo_status, user_id, last_update,
--                          dv_tran_id
--                          ,ri_comm_amt, ri_comm_vat --mikel 09.24.2015; GENQA RSIC 4984
--                         )
--                  VALUES (v_tran_id, v_fund_cd,
--                          v_branch_cd, 'RCM', v_dv_tran_date,
--                          TO_CHAR (SYSDATE, 'YYYY'),
--                          giac_sequence_generation (v_fund_cd,
--                                                    v_branch_cd,
--                                                    'RCM',
--                                                    TO_CHAR (SYSDATE, 'YYYY'),
--                                                    0
--                                                   ),
--                          v_recipient, v_foreign_amt, v_currency_cd,
--                          v_currency_rt, v_local_amt,
--                          'To record Binder RI Commissions', 'U', p_user_id, SYSDATE,
--                          p_gopp_tran_id
--                          ,v_comm_amt, v_comm_vat --mikel 09.24.2015; GENQA RSIC 4984
--                         );
--             --END IF; --mikel 09.24.2015; GENQA RSIC 4984 - amount inserted should be comm plus comm vat
--             GIACS052_PKG.aeg_parameters (v_fund_cd, v_branch_cd, p_user_id, v_tran_id, v_module_name, v_ri_cd);
             --set_cm_dm_print_btn;
             --msg_alert
             /*   ('DV/Check printing is successful. You may now print the Credit Memo for RI Commissions. Simply press the Print CM/DM button.',
                 'I',
                 FALSE
                );*/
          
       END IF;
    END;
    /*
    **  Created by    : Veronica V. Raymundo
    **  Date Created  : 06.11.2013
    **  Reference By  : GIACS052 - DV / Check Printing
    **  Description   : For AC-SPECS-2012-153
    **                  Procedure to validate if dv is OFFPR and has 6 print status
    */
    PROCEDURE set_cm_dm_print_btn
    (p_tran_id          IN    GIAC_ACCTRANS.tran_id%TYPE,
     p_document_cd      OUT   GIAC_PAYT_REQUESTS.document_cd%TYPE,
     p_cm_dm_tran_id    OUT   GIAC_CM_DM.gacc_tran_id%TYPE,
     p_memo_status      OUT   GIAC_CM_DM.memo_status%TYPE,
     p_print_tag        OUT   GIAC_DISB_VOUCHERS.print_tag%TYPE,
     p_cm_tag           OUT   NUMBER,
     p_enable_print     OUT   VARCHAR2)
    IS
        v_cm_tag              NUMBER := 0;
        v_print_tag           GIAC_DISB_VOUCHERS.print_tag%TYPE;
        v_enable_print        VARCHAR2(1) := 'N';
    BEGIN
      BEGIN
          SELECT b.document_cd, a.print_tag
            INTO p_document_cd, v_print_tag
            FROM GIAC_DISB_VOUCHERS a, GIAC_PAYT_REQUESTS b
           WHERE a.gprq_ref_id = b.ref_id
             AND gacc_tran_id = p_tran_id;
      EXCEPTION
          WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
              p_document_cd := NULL;
              v_print_tag   := NULL;
      END;
      BEGIN
          SELECT DISTINCT 1
              INTO v_cm_tag
              FROM giac_outfacul_prem_payts
             WHERE cm_tag = 'Y'
               AND gacc_tran_id = p_tran_id;
      EXCEPTION
          WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
              v_cm_tag := NULL;
      END;
      BEGIN
           -- Edited by MarkS 5.23.2016 SR-5484
           SELECT *
           INTO p_cm_dm_tran_id, p_memo_status
           FROM (
                SELECT gacc_tran_id, memo_status
                    FROM giac_cm_dm
                    WHERE dv_tran_id = p_tran_id) 
           WHERE ROWNUM = 1;
           -- END SR-5484
--           SELECT gacc_tran_id, memo_status
--            INTO p_cm_dm_tran_id, p_memo_status
--          FROM giac_cm_dm
--         WHERE dv_tran_id = p_tran_id;  
      EXCEPTION
          WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
              p_cm_dm_tran_id := NULL;
      END;
      IF p_document_cd = giacp.v('FACUL_RI_PREM_PAYT_DOC') --added by steven 09.19.2014;'OFPPR'
           AND v_print_tag = 6
           AND v_cm_tag = 1 AND p_cm_dm_tran_id IS NOT NULL THEN
          v_enable_print := 'Y';
      END IF;
      p_print_tag    := v_print_tag;
      p_cm_tag       := v_cm_tag;
      p_enable_print := v_enable_print;
    END;
END giacs052_pkg;
/
