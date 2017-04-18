CREATE OR REPLACE PACKAGE BODY CPI.giacs312_pkg
AS
   FUNCTION get_giac_bank_lov (p_find_text VARCHAR2)
      RETURN giac_banks_tab PIPELINED
   IS
      v_bank   giac_banks_type;
   BEGIN
      FOR i IN (SELECT   bank_sname, bank_name, bank_cd
                    FROM giac_banks
                   WHERE UPPER (bank_sname) LIKE
                                               NVL (UPPER (p_find_text), '%')
                      OR UPPER (bank_name) LIKE NVL (UPPER (p_find_text), '%')
                ORDER BY TRIM (bank_name))
      LOOP
         v_bank.bank_name := i.bank_name;
         v_bank.bank_sname := i.bank_sname;
         v_bank.bank_cd := i.bank_cd;
         PIPE ROW (v_bank);
      END LOOP;

      RETURN;
   END;

   FUNCTION get_gl_acct_lov (p_find VARCHAR2)
      RETURN gl_acct_list_tab PIPELINED
   IS
      v_list   gl_acct_list_type;
   BEGIN
      FOR i IN
         (SELECT   gicoa.gl_acct_category,
                   LPAD (gicoa.gl_control_acct, 2, '0') gl_control_acct,
                   LPAD (gicoa.gl_sub_acct_1, 2, '0') gl_sub_acct_1,
                   LPAD (gicoa.gl_sub_acct_2, 2, '0') gl_sub_acct_2,
                   LPAD (gicoa.gl_sub_acct_3, 2, '0') gl_sub_acct_3,
                   LPAD (gicoa.gl_sub_acct_4, 2, '0') gl_sub_acct_4,
                   LPAD (gicoa.gl_sub_acct_5, 2, '0') gl_sub_acct_5,
                   LPAD (gicoa.gl_sub_acct_6, 2, '0') gl_sub_acct_6,
                   LPAD (gicoa.gl_sub_acct_7, 2, '0') gl_sub_acct_7,
                   gicoa.gl_acct_name, gicoa.gslt_sl_type_cd,
                   gicoa.gl_acct_id, b.sl_type_name
              FROM giac_chart_of_accts gicoa, giac_sl_types b
             WHERE gicoa.gslt_sl_type_cd = b.sl_type_cd(+)
               AND gicoa.leaf_tag = 'Y'
               AND (      gicoa.gl_acct_category
                       || LPAD (gicoa.gl_control_acct, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_1, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_2, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_3, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_4, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_5, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_6, 2, '0')
                       || LPAD (gicoa.gl_sub_acct_7, 2, '0') LIKE
                                                       NVL (p_find, '%')
                                                       || '%'
--                    OR gicoa.gl_acct_category LIKE NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_control_acct, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_1, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_2, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_3, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_4, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_5, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_6, 2, '0') LIKE
--                                                             NVL (p_find, '%')
--                    OR LPAD (gicoa.gl_sub_acct_7, 2, '0') LIKE
--                                                             NVL (p_find, '%')
                    OR UPPER (gicoa.gl_acct_name) LIKE
                                                     UPPER (NVL (p_find, '%'))
                   )
          ORDER BY gicoa.gl_acct_category,
                   gicoa.gl_control_acct,
                   gicoa.gl_sub_acct_1,
                   gicoa.gl_sub_acct_2,
                   gicoa.gl_sub_acct_3,
                   gicoa.gl_sub_acct_4,
                   gicoa.gl_sub_acct_5,
                   gicoa.gl_sub_acct_6,
                   gicoa.gl_sub_acct_7)
      LOOP
         v_list.gl_acct_category := i.gl_acct_category;
         v_list.gl_control_acct := i.gl_control_acct;
         v_list.gl_sub_acct_1 := i.gl_sub_acct_1;
         v_list.gl_sub_acct_2 := i.gl_sub_acct_2;
         v_list.gl_sub_acct_3 := i.gl_sub_acct_3;
         v_list.gl_sub_acct_4 := i.gl_sub_acct_4;
         v_list.gl_sub_acct_5 := i.gl_sub_acct_5;
         v_list.gl_sub_acct_6 := i.gl_sub_acct_6;
         v_list.gl_sub_acct_7 := i.gl_sub_acct_7;
         v_list.gl_acct_name := i.gl_acct_name;
         v_list.gl_acct_id := i.gl_acct_id;
         v_list.gslt_sl_type_cd := i.gslt_sl_type_cd;
         v_list.sl_type_name := i.sl_type_name;
         PIPE ROW (v_list);
      END LOOP;
   END;

   FUNCTION get_rec_list (
      p_user_id          giis_users.user_id%TYPE,
      p_bank_acct_cd     giac_bank_accounts.bank_acct_cd%TYPE,
      p_dsp_bank_sname   giac_banks.bank_sname%TYPE,
      p_dsp_bank_name    giac_banks.bank_name%TYPE,
      p_branch_bank      giac_bank_accounts.branch_bank%TYPE,
      p_bank_acct_no     giac_bank_accounts.bank_acct_no%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN
         (SELECT   a.bank_cd, a.bank_acct_cd, a.branch_bank, a.bank_acct_no,
                   a.bank_acct_type, a.remarks, a.bank_account_flag,
                   a.user_id, a.last_update, a.opening_date, a.closing_date,
                   a.sl_cd, a.gl_acct_id, b.sl_type_name, c.gl_acct_category,
                   c.gl_control_acct, c.gl_sub_acct_1, c.gl_sub_acct_2,
                   c.gl_sub_acct_3, c.gl_sub_acct_4, c.gl_sub_acct_5,
                   c.gl_sub_acct_6, c.gl_sub_acct_7, c.gl_acct_name,
                   d.bank_sname, d.bank_name, a.branch_cd
              FROM giac_bank_accounts a,
                   giac_sl_types b,
                   giac_chart_of_accts c,
                   giac_banks d,
                   giac_sl_lists e
             WHERE a.sl_cd = e.sl_cd(+)
               AND e.sl_cd(+) = a.bank_acct_cd
               AND b.sl_type_cd(+) = e.sl_type_cd
               AND a.gl_acct_id = c.gl_acct_id
               AND a.bank_cd = d.bank_cd
               --AND check_user_per_iss_cd_acctg2 (NULL, branch_cd, 'GIACS312', p_user_id) = 1
               AND UPPER (a.bank_acct_no) LIKE
                                             UPPER (NVL (p_bank_acct_no, '%'))
               AND UPPER (d.bank_sname) LIKE
                                           UPPER (NVL (p_dsp_bank_sname, '%'))
               AND UPPER (d.bank_name) LIKE UPPER (NVL (p_dsp_bank_name, '%'))
               AND UPPER (a.branch_bank) LIKE UPPER (NVL (p_branch_bank, '%'))
               AND a.bank_acct_cd = NVL (p_bank_acct_cd, a.bank_acct_cd)
          ORDER BY TO_NUMBER (a.bank_acct_cd))
      LOOP
         v_rec.bank_cd := i.bank_cd;
         v_rec.dsp_bank_sname := i.bank_sname;
         v_rec.dsp_bank_name := i.bank_name;
         v_rec.bank_acct_cd := i.bank_acct_cd;
         v_rec.branch_bank := i.branch_bank;
         v_rec.bank_acct_no := i.bank_acct_no;
         v_rec.bank_acct_type := i.bank_acct_type;
         v_rec.branch_cd := i.branch_cd;
         v_rec.remarks := i.remarks;
         v_rec.bank_account_flag := i.bank_account_flag;
         v_rec.user_id := i.user_id;
         v_rec.opening_date := TO_CHAR (i.opening_date, 'MM-DD-YYYY');
         v_rec.closing_date := TO_CHAR (i.closing_date, 'MM-DD-YYYY');
         v_rec.sl_cd := i.sl_cd;
         v_rec.gl_acct_id := i.gl_acct_id;
         v_rec.dsp_sl_type_name := i.sl_type_name;
         v_rec.dsp_gl_acct_category := i.gl_acct_category;
         v_rec.dsp_gl_control_acct := i.gl_control_acct;
         v_rec.dsp_gl_sub_acct_1 := i.gl_sub_acct_1;
         v_rec.dsp_gl_sub_acct_2 := i.gl_sub_acct_2;
         v_rec.dsp_gl_sub_acct_3 := i.gl_sub_acct_3;
         v_rec.dsp_gl_sub_acct_4 := i.gl_sub_acct_4;
         v_rec.dsp_gl_sub_acct_5 := i.gl_sub_acct_5;
         v_rec.dsp_gl_sub_acct_6 := i.gl_sub_acct_6;
         v_rec.dsp_gl_sub_acct_7 := i.gl_sub_acct_7;
         v_rec.dsp_gl_acct_name := i.gl_acct_name;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.dsp_branch_name := get_iss_name (i.branch_cd);
         v_rec.dsp_bank_acct_type :=
            get_rv_meaning ('GIAC_BANK_ACCOUNTS.BANK_ACCT_TYPE',
                            i.bank_acct_type
                           );
         v_rec.dsp_bank_account_flag :=
            get_rv_meaning ('GIAC_BANK_ACCOUNTS.BANK_ACCOUNT_FLAG',
                            i.bank_account_flag
                           );
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_bank_accounts%ROWTYPE)
   IS
      v_max_bank_acct_cd   NUMBER;
      ws_fund_cd           giac_sl_lists.fund_cd%TYPE;
      ws_sl_type_cd        giac_sl_lists.sl_type_cd%TYPE;
      v_exist              VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT MAX (TO_NUMBER (bank_acct_cd)) + 1
           INTO v_max_bank_acct_cd
           FROM giac_bank_accounts;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_max_bank_acct_cd := 0;
      END;

      ws_fund_cd := giacp.v ('FUND_CD');

      IF p_rec.bank_acct_type = 'CA'
      THEN
         ws_sl_type_cd := giacp.v ('BANK_ACCT_SL_CA');
      ELSIF p_rec.bank_acct_type = 'SA'
      THEN
         ws_sl_type_cd := giacp.v ('BANK_ACCT_SL_SA');
      ELSIF p_rec.bank_acct_type = 'TD'
      THEN
         ws_sl_type_cd := giacp.v ('BANK_ACCT_SL_TD');
      END IF;

      IF p_rec.bank_acct_cd IS NULL
      THEN
         BEGIN
            SELECT 'Y'
              INTO v_exist
              FROM giac_sl_lists
             WHERE fund_cd = ws_fund_cd
               AND sl_type_cd = ws_sl_type_cd
               AND sl_cd = v_max_bank_acct_cd;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_exist := NULL;
         END;
      END IF;

      IF v_exist IS NOT NULL
      THEN
         FOR cd IN v_max_bank_acct_cd .. 9999
         LOOP
            v_exist := 'N';

            FOR i IN (SELECT 'Y'
                        FROM giac_sl_lists
                       WHERE fund_cd = ws_fund_cd
                         AND sl_type_cd = ws_sl_type_cd
                         AND sl_cd = cd)
            LOOP
               v_exist := 'Y';
            END LOOP;

            IF v_exist = 'N'
            THEN
               v_max_bank_acct_cd := cd;
               EXIT;
            END IF;
         END LOOP;
      END IF;

      MERGE INTO giac_bank_accounts
         USING DUAL
         ON (bank_cd = p_rec.bank_cd AND bank_acct_cd = p_rec.bank_acct_cd)
         WHEN NOT MATCHED THEN
            INSERT (bank_cd, bank_acct_cd, branch_cd, branch_bank,
                    bank_acct_no, bank_acct_type, bank_account_flag,
                    opening_date, closing_date, gl_acct_id, sl_cd, remarks,
                    user_id, last_update)
            VALUES (p_rec.bank_cd, v_max_bank_acct_cd, p_rec.branch_cd,
                    p_rec.branch_bank, p_rec.bank_acct_no,
                    p_rec.bank_acct_type, p_rec.bank_account_flag,
                    p_rec.opening_date, p_rec.closing_date, p_rec.gl_acct_id,
                    p_rec.sl_cd, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET branch_bank = p_rec.branch_bank,
                   branch_cd = p_rec.branch_cd,
                   bank_acct_no = p_rec.bank_acct_no,
                   bank_acct_type = p_rec.bank_acct_type,
                   bank_account_flag = p_rec.bank_account_flag,
                   opening_date = p_rec.opening_date,
                   closing_date = p_rec.closing_date,
                   gl_acct_id = p_rec.gl_acct_id, sl_cd = p_rec.sl_cd,
                   remarks = p_rec.remarks, user_id = p_rec.user_id,
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
      p_bank_cd        giac_bank_accounts.bank_cd%TYPE,
      p_bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE
   )
   AS
      v_sl_type_cd       VARCHAR2 (500);
      v_bank_acct_type   VARCHAR2 (100);
   BEGIN
      FOR i IN (SELECT bank_acct_type
                  FROM giac_bank_accounts
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_bank_acct_type := i.bank_acct_type;
         EXIT;
      END LOOP;

      DELETE FROM giac_bank_accounts
            WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd;

      IF v_bank_acct_type = 'CA'
      THEN
         v_sl_type_cd := giacp.v ('BANK_ACCT_SL_CA');
      ELSIF v_bank_acct_type = 'SA'
      THEN
         v_sl_type_cd := giacp.v ('BANK_ACCT_SL_SA');
      ELSIF v_bank_acct_type = 'TD'
      THEN
         v_sl_type_cd := giacp.v ('BANK_ACCT_SL_TD');
      END IF;

      DELETE FROM giac_sl_lists
            WHERE fund_cd = giacp.v ('FUND_CD')
              AND sl_type_cd = v_sl_type_cd
              AND sl_cd = p_bank_acct_cd;
   END;

   PROCEDURE val_del_rec (
      p_bank_cd        giac_bank_accounts.bank_cd%TYPE,
      p_bank_acct_cd   giac_bank_accounts.bank_acct_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_check_no
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_CHECK_NO exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_chk_disbursement
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_CHK_DISBURSEMENT exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_bank_collns
                 WHERE gban_bank_cd = p_bank_cd
                   AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_BANK_COLLNS exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_bank_trans
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_BANK_TRANS exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_bank_tran_dtl
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_BANK_TRAN_DTL exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_branches
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_BRANCHES exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_dcb_bank_dep
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_DCB_BANK_DEP exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_dcb_users
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_DCB_USERS exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_reconciling_items
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_RECONCILING_ITEMS exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_restored_chk
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_RESTORED_CHK exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_spoiled_check
                 WHERE bank_cd = p_bank_cd AND bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_SPOILED_CHECK exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giis_banc_branch
                 WHERE bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIIS_BANC_BRANCH exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_collection_dtl
                 WHERE dcb_bank_cd = p_bank_cd
                   AND dcb_bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_COLLECTION_DTL exists.'
            );
      END IF;

      FOR i IN (SELECT 1
                  FROM giac_upload_colln_dtl
                 WHERE dcb_bank_cd = p_bank_cd
                   AND dcb_bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIAC_BANK_ACCOUNTS while dependent record(s) in GIAC_UPLOAD_COLLN_DTL exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_bank_acct_cd giac_bank_accounts.bank_acct_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_bank_accounts
                 WHERE bank_acct_cd = p_bank_acct_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Row already exists with the same bank_acct_cd.'
            );
      END IF;
   END;
END;
/


