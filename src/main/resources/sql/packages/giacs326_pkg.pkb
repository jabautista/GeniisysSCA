CREATE OR REPLACE PACKAGE BODY CPI.GIACS326_PKG
AS
   
   PROCEDURE check_branch(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE
   )
   AS
      v_exists                BOOLEAN := FALSE;
   BEGIN
      FOR i IN(SELECT 1
                 FROM giac_branches a, giac_banks b, giac_bank_accounts c
                WHERE a.bank_cd = b.bank_cd
                  AND a.branch_cd = c.branch_cd
                  AND a.gfun_fund_cd = p_fund_cd
                  AND a.branch_cd = p_branch_cd
                  AND b.bank_cd = c.bank_cd)
      LOOP
         v_exists := TRUE;
         EXIT;
      END LOOP;

      IF NOT v_exists THEN
         raise_application_error (-20001, 'Geniisys Exception#E#There are no bank accounts listed for this branch.');
      END IF;
   END;
   
   FUNCTION get_bank_lov(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN bank_lov_tab PIPELINED
   IS
      v_row                   bank_lov_type;
      v_bank_cd               GIAC_BANKS.bank_cd%TYPE;
   BEGIN
      BEGIN
         SELECT bank_cd
           INTO v_bank_cd
           FROM GIAC_BRANCHES
          WHERE gfun_fund_cd = p_fund_cd
            AND branch_cd = p_branch_cd;
      EXCEPTION
         WHEN OTHERS THEN
            v_bank_cd := NULL;
      END;
   
      FOR i IN(SELECT bank_cd, bank_sname, bank_name
                 FROM GIAC_BANKS
                WHERE bank_cd = v_bank_cd
                  AND (UPPER(bank_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(bank_sname) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(bank_name) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.bank_cd := i.bank_cd;
         v_row.bank_sname := i.bank_sname;
         v_row.bank_name := i.bank_name;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_bank_acct_lov(
      p_bank_cd               GIAC_BANK_ACCOUNTS.bank_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN bank_acct_tab PIPELINED
   IS
      v_row                   bank_acct_type;
   BEGIN
      FOR i IN(SELECT bank_acct_cd, bank_acct_no
                 FROM GIAC_BANK_ACCOUNTS
                WHERE bank_cd = p_bank_cd
                  AND (UPPER(bank_acct_cd) LIKE UPPER(NVL(p_find_text, '%'))
                   OR UPPER(bank_acct_no) LIKE UPPER(NVL(p_find_text, '%'))))
      LOOP
         v_row.bank_acct_cd := i.bank_acct_cd;
         v_row.bank_acct_no := i.bank_acct_no;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_check_no_list(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE,
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE,
      p_check_seq_no          GIAC_CHECK_NO.check_seq_no%TYPE
   )
     RETURN check_no_tab PIPELINED
   IS
      v_row                   check_no_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM GIAC_CHECK_NO
                WHERE fund_cd = p_fund_cd
                  AND branch_cd = p_branch_cd
                  AND bank_cd = p_bank_cd
                  AND bank_acct_cd = p_bank_acct_cd
                  AND UPPER(chk_prefix) LIKE UPPER(NVL(p_chk_prefix, '%'))
                  AND check_seq_no = NVL(p_check_seq_no, check_seq_no))
      LOOP
         v_row.fund_cd := i.fund_cd;
         v_row.branch_cd := i.branch_cd;
         v_row.bank_cd := i.bank_cd;
         v_row.bank_acct_cd := i.bank_acct_cd;
         v_row.chk_prefix := i.chk_prefix;
         v_row.check_seq_no := i.check_seq_no;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_row.in_use := 'N';
         v_row.old_check_seq_no := i.check_seq_no;
         FOR a IN(SELECT MAX(check_no) check_no
                    FROM GIAC_CHK_DISBURSEMENT
                   WHERE UPPER(check_pref_suf) = UPPER(i.chk_prefix)
                     AND bank_cd = i.bank_cd
                     AND bank_acct_cd = i.bank_acct_cd)
         LOOP
            v_row.in_use := 'Y';
            v_row.old_check_seq_no := a.check_no;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_del_rec(
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM GIAC_CHK_DISBURSEMENT
                WHERE check_pref_suf = p_chk_prefix
                  AND bank_cd = p_bank_cd
                  AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIAC_CHECK_NO while dependent record(s) in GIAC_CHK_DISBURSEMENT exists.');
      END LOOP;
   END;
   
   PROCEDURE del_rec(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE,
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM GIAC_CHECK_NO
       WHERE fund_cd = p_fund_cd
         AND branch_cd = p_branch_cd
         AND bank_cd = p_bank_cd
         AND bank_acct_cd = p_bank_acct_cd
         AND chk_prefix = p_chk_prefix;
   END;
   
   PROCEDURE val_add_rec(
      p_fund_cd               GIAC_CHECK_NO.fund_cd%TYPE,
      p_branch_cd             GIAC_CHECK_NO.branch_cd%TYPE,
      p_bank_cd               GIAC_CHECK_NO.bank_cd%TYPE,
      p_bank_acct_cd          GIAC_CHECK_NO.bank_acct_cd%TYPE,
      p_chk_prefix            GIAC_CHECK_NO.chk_prefix%TYPE
   )
   IS
   BEGIN
      FOR i IN(SELECT 1
                 FROM GIAC_CHECK_NO
                WHERE fund_cd = p_fund_cd
                  AND branch_cd = p_branch_cd
                  AND bank_cd = p_bank_cd
                  AND bank_acct_cd = p_bank_acct_cd
                  AND chk_prefix = p_chk_prefix)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same fund_cd, branch_cd, bank_cd, bank_acct_cd and chk_prefix.');
      END LOOP;
   END;
   
   PROCEDURE set_rec(
      p_rec                   GIAC_CHECK_NO%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO GIAC_CHECK_NO
      USING DUAL
         ON (fund_cd = p_rec.fund_cd
        AND branch_cd = p_rec.branch_cd
        AND bank_cd = p_rec.bank_cd
        AND bank_acct_cd = p_rec.bank_acct_cd
        AND chk_prefix = p_rec.chk_prefix)
       WHEN NOT MATCHED THEN
            INSERT (fund_cd, branch_cd, bank_cd, bank_acct_cd, chk_prefix, check_seq_no, user_id, last_update, remarks)
            VALUES (p_rec.fund_cd, p_rec.branch_cd, p_rec.bank_cd, p_rec.bank_acct_cd, p_rec.chk_prefix, p_rec.check_seq_no, p_rec.user_id, SYSDATE, p_rec.remarks)
       WHEN MATCHED THEN
            UPDATE SET check_seq_no = p_rec.check_seq_no,
                       remarks = p_rec.remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE;
   END;
   
END GIACS326_PKG;
/


