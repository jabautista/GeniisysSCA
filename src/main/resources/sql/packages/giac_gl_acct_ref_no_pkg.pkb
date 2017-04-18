/* Created by   : Gzelle
 * Date Created : 11-06-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */

CREATE OR REPLACE PACKAGE BODY cpi.giac_gl_acct_ref_no_pkg
AS
   FUNCTION val_gl_acct_id (
      p_gl_acct_id   giac_gl_subaccount_types.gl_acct_id%TYPE
   )
      RETURN val_gl_tab PIPELINED
   IS
      v_rec          val_gl_type;
      v_check        BOOLEAN;
      v_sl_type_cd   giac_sl_types.sl_type_cd%TYPE;
   BEGIN
      /*--check if selected gl acct code is existing in giac_gl_subaccount_types
          retrieves ledger_cd, subledger_cd and checks sl name            --*/
      v_check := FALSE;
      v_rec.dsp_is_existing := 'N';

      BEGIN
         SELECT dr_cr_tag, gslt_sl_type_cd
           INTO v_rec.dr_cr_tag, v_sl_type_cd
           FROM giac_chart_of_accts
          WHERE gl_acct_id = p_gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.dr_cr_tag := NULL;
            v_sl_type_cd := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            v_rec.dr_cr_tag := NULL;
            v_sl_type_cd := NULL;
      END;

      BEGIN
         SELECT 'Y'
           INTO v_rec.dsp_sl_existing
           FROM giac_sl_lists
          WHERE sl_type_cd = v_sl_type_cd AND fund_cd = giacp.v ('FUND_CD');
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.dsp_sl_existing := 'N';
         WHEN TOO_MANY_ROWS
         THEN
            v_rec.dsp_sl_existing := 'Y';
      END;

      FOR i IN (SELECT ledger_cd, subledger_cd, active_tag
                  FROM giac_gl_subaccount_types
                 WHERE gl_acct_id = p_gl_acct_id)
      LOOP
         v_rec.ledger_cd := i.ledger_cd;
         v_rec.subledger_cd := i.subledger_cd;
         v_rec.dsp_is_existing := i.active_tag;

         IF i.active_tag = 'Y'
         THEN
            BEGIN
               SELECT active_tag
                 INTO v_rec.dsp_is_existing
                 FROM giac_gl_account_types
                WHERE ledger_cd = v_rec.ledger_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.dsp_is_existing := NULL;
               WHEN TOO_MANY_ROWS
               THEN
                  v_rec.dsp_is_existing := NULL;
            END;
         END IF;

         v_check := TRUE;
         PIPE ROW (v_rec);
      END LOOP;

      IF v_check <> TRUE
      THEN
         PIPE ROW (v_rec);
      END IF;
   END;

   FUNCTION get_gl_tran_type_lov (
      p_ledger_cd       giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd    giac_gl_subaccount_types.subledger_cd%TYPE,
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_tran_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_tran_type_type;
      v_sql   VARCHAR2 (10000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                    FROM (SELECT COUNT(1) OVER() count_, outersql.*
                            FROM (SELECT ROWNUM rownum_, innersql.*
                                    FROM (SELECT transaction_cd, transaction_desc                               
                                            FROM giac_gl_transaction_types
                                           WHERE ledger_cd = : p_ledger_cd 
                                             AND subledger_cd = :p_subledger_cd
                                             AND active_tag = ''Y''';

      IF p_find_text IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND (transaction_cd LIKE '''
            || p_find_text
            || ''' OR UPPER(transaction_desc) LIKE UPPER('''
            || p_find_text
            || '''))';
      END IF;

      v_sql := v_sql || ' ) innersql';

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'transactionCd'
         THEN
            v_sql := v_sql || ' ORDER BY transaction_cd ';
         ELSIF p_order_by = 'transactionDesc'
         THEN
            v_sql := v_sql || ' ORDER BY transaction_desc ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql :=
            v_sql
         || ' ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql USING p_ledger_cd, p_subledger_cd;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.transaction_cd,
               v_rec.transaction_desc;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;

   PROCEDURE val_add_gl (
      p_gacc_tran_id     giac_gl_acct_ref_no.gacc_tran_id%TYPE,
      p_gl_acct_id       giac_gl_acct_ref_no.gl_acct_id%TYPE,
      p_ledger_cd        giac_gl_acct_ref_no.ledger_cd%TYPE,
      p_subledger_cd     giac_gl_acct_ref_no.subledger_cd%TYPE,
      p_transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE,
      p_sl_cd            giac_gl_acct_ref_no.sl_cd%TYPE,
      p_acct_seq_no      giac_gl_acct_ref_no.acct_seq_no%TYPE,
      p_acct_tran_type   giac_gl_acct_ref_no.acct_tran_type%TYPE
   )
   IS
      v_exist   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_exist
           FROM giac_gl_acct_ref_no
          WHERE gacc_tran_id = p_gacc_tran_id
            AND gl_acct_id = p_gl_acct_id
            AND ledger_cd = p_ledger_cd
            AND subledger_cd = p_subledger_cd
            AND transaction_cd = p_transaction_cd
            AND sl_cd = p_sl_cd
            AND acct_seq_no = NVL(p_acct_seq_no,0)
            AND acct_tran_type = p_acct_tran_type;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_exist := 'N';
      END;

      IF v_exist = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same Account Reference No..'
            );
      END IF;
   END;

   PROCEDURE set_gl_acct_ref_no (p_rec giac_gl_acct_ref_no%ROWTYPE)
   IS
      v_check   VARCHAR2 (1);
   BEGIN
      BEGIN
         SELECT 'Y'
           INTO v_check
           FROM giac_gl_subaccount_types
          WHERE gl_acct_id = p_rec.gl_acct_id;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_check := 'N';
         WHEN TOO_MANY_ROWS
         THEN
            v_check := 'Y';
      END;

      IF v_check = 'Y'
      THEN
         INSERT INTO giac_gl_acct_ref_no
                     (gacc_tran_id, gl_acct_id, ledger_cd,
                      subledger_cd, transaction_cd, sl_cd,
                      acct_seq_no, acct_tran_type
                     )
              VALUES (p_rec.gacc_tran_id, p_rec.gl_acct_id, p_rec.ledger_cd,
                      p_rec.subledger_cd, p_rec.transaction_cd, p_rec.sl_cd,
                      p_rec.acct_seq_no, p_rec.acct_tran_type
                     );
      END IF;
   END;

   PROCEDURE del_gl_acct_ref_no (p_rec giac_gl_acct_ref_no%ROWTYPE)
   IS
   BEGIN
      DELETE FROM giac_gl_acct_ref_no
            WHERE gacc_tran_id = p_rec.gacc_tran_id
              AND gl_acct_id = p_rec.gl_acct_id
              AND ledger_cd = p_rec.ledger_cd
              AND subledger_cd = p_rec.subledger_cd
              AND transaction_cd = p_rec.transaction_cd
              AND sl_cd = p_rec.sl_cd
              AND acct_seq_no = p_rec.acct_seq_no
              AND acct_tran_type = p_rec.acct_tran_type
              AND NVL(spoil_sw,'N') <> 'Y';
   END;

   PROCEDURE upd_acct_seq_no (
      p_gacc_tran_id   giac_gl_acct_ref_no.gacc_tran_id%TYPE
   )
   IS
      v_max_seq_no        giac_gl_acct_ref_no.acct_seq_no%TYPE;
      v_ledger_cd         giac_gl_acct_ref_no.ledger_cd%TYPE;
      v_subledger_cd      giac_gl_acct_ref_no.subledger_cd%TYPE;
      v_transaction_cd    giac_gl_acct_ref_no.transaction_cd%TYPE;
      v_new_acct_ref_no   giac_acct_entries.acct_ref_no%TYPE;
      v_exist             VARCHAR2 (1)                              := 'N';
   BEGIN
      FOR a IN (SELECT DISTINCT a.gl_acct_id, a.acct_entry_id, a.sl_cd,
                                a.acct_ref_no, b.ledger_cd, b.subledger_cd,
                                b.transaction_cd
                           FROM giac_acct_entries a, giac_gl_acct_ref_no b
                          WHERE a.gacc_tran_id = p_gacc_tran_id
                            AND a.acct_ref_no IS NOT NULL
                            AND a.gacc_tran_id = b.gacc_tran_id
                            AND a.sl_cd = b.sl_cd
                            AND a.gl_acct_id = b.gl_acct_id
                            AND a.acct_ref_no =
                                      b.ledger_cd
                                   || ' - '
                                   || b.subledger_cd
                                   || ' - '
                                   || b.transaction_cd
                                   || ' - '
                                   || b.sl_cd
                                   || ' - '
                                   || b.acct_seq_no
                            AND a.acct_tran_type = 'S'
                       ORDER BY acct_entry_id)
      LOOP
         BEGIN
            SELECT 'Y' exist
              INTO v_exist
              FROM giac_gl_acct_ref_no
             WHERE ledger_cd = a.ledger_cd
               AND subledger_cd = a.subledger_cd
               AND transaction_cd = a.transaction_cd
               AND sl_cd = a.sl_cd
               AND gacc_tran_id = p_gacc_tran_id;
         EXCEPTION
            WHEN NO_DATA_FOUND
            THEN
               v_max_seq_no := 0;
         END;

         IF v_exist = 'Y'
         THEN
            BEGIN
               SELECT MAX (acct_seq_no)
                 INTO v_max_seq_no
                 FROM giac_gl_acct_ref_no
                WHERE ledger_cd = a.ledger_cd
                  AND subledger_cd = a.subledger_cd
                  AND transaction_cd = a.transaction_cd
                  AND sl_cd = a.sl_cd;
            EXCEPTION
               WHEN NO_DATA_FOUND
               THEN
                  v_max_seq_no := 0;
            END;

            v_max_seq_no := v_max_seq_no + 1;
            v_new_acct_ref_no :=
                  a.ledger_cd
               || ' - '
               || a.subledger_cd
               || ' - '
               || a.transaction_cd
               || ' - '
               || a.sl_cd
               || ' - '
               || v_max_seq_no;

            UPDATE giac_gl_acct_ref_no
               SET acct_seq_no = v_max_seq_no
             WHERE ledger_cd = a.ledger_cd
               AND subledger_cd = a.subledger_cd
               AND transaction_cd = a.transaction_cd
               AND sl_cd = a.sl_cd
               AND gacc_tran_id = p_gacc_tran_id;

            UPDATE giac_acct_entries
               SET acct_ref_no = v_new_acct_ref_no
             WHERE gacc_tran_id = p_gacc_tran_id
               AND acct_entry_id = a.acct_entry_id;
         END IF;
      END LOOP;
   END;

   FUNCTION get_remaining_balance (
      p_gl_acct_id    giac_gl_acct_ref_no.gl_acct_id%TYPE,
      p_sl_cd         giac_gl_acct_ref_no.sl_cd%TYPE,
      p_acct_ref_no   giac_acct_entries.acct_ref_no%TYPE
   )
      RETURN VARCHAR2
   IS
      v_original_balance    NUMBER                               := 0;
      v_used_amount         NUMBER                               := 0;
      v_remaining_balance   NUMBER;
      v_acct_ref_no         giac_acct_entries.acct_ref_no%TYPE;
   BEGIN
      BEGIN
         SELECT   (DECODE (b.dr_cr_tag,
                           'D', SUM (a.debit_amt),
                           'C', SUM (a.credit_amt)
                          )
                  )
             INTO v_original_balance
             FROM giac_acct_entries a, giac_chart_of_accts b
            WHERE a.acct_ref_no LIKE p_acct_ref_no
              AND a.sl_cd = p_sl_cd
              AND a.gl_acct_id = p_gl_acct_id
              AND a.gl_acct_id = b.gl_acct_id
              AND a.acct_tran_type = 'S'
         GROUP BY a.acct_tran_type, b.dr_cr_tag;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_original_balance := 0;
         WHEN TOO_MANY_ROWS
         THEN
            v_original_balance := 0;
      END;

      BEGIN
         SELECT   (DECODE (b.dr_cr_tag,
                           'C', SUM (a.debit_amt),
                           'D', SUM (a.credit_amt)
                          )
                  ) used_amt,
                  a.acct_ref_no
             INTO v_used_amount,
                  v_acct_ref_no
             FROM giac_acct_entries a, giac_chart_of_accts b
            WHERE a.sl_cd = p_sl_cd
              AND a.acct_ref_no LIKE p_acct_ref_no
              AND a.gl_acct_id = p_gl_acct_id
              AND a.gl_acct_id = b.gl_acct_id
              AND a.acct_tran_type = 'K'
         GROUP BY a.acct_tran_type, b.dr_cr_tag, a.acct_ref_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_used_amount := 0;
            v_acct_ref_no := NULL;
         WHEN TOO_MANY_ROWS
         THEN
            v_used_amount := 0;
            v_acct_ref_no := NULL;
      END;

      v_remaining_balance := v_original_balance - v_used_amount;
      RETURN v_remaining_balance;
   END get_remaining_balance;

   FUNCTION val_remaining_balance (
      p_gacc_tran_id     giac_gl_acct_ref_no.gacc_tran_id%TYPE,
      p_gl_acct_id       giac_gl_acct_ref_no.gl_acct_id%TYPE,
      p_sl_cd            giac_gl_acct_ref_no.sl_cd%TYPE,
      p_acct_tran_type   giac_gl_acct_ref_no.acct_tran_type%TYPE,
      p_acct_ref_no      giac_acct_entries.acct_ref_no%TYPE,
      p_transaction_cd   giac_gl_acct_ref_no.transaction_cd%TYPE,
      p_acct_seq_no      giac_gl_acct_ref_no.acct_seq_no%TYPE
   )
      RETURN val_rem_tab PIPELINED
   IS
      v_rec   val_rem_type;
   BEGIN
      v_rec.remaining_bal :=
         giac_gl_acct_ref_no_pkg.get_remaining_balance (p_gl_acct_id,
                                                        p_sl_cd,
                                                        p_acct_ref_no
                                                       );

      BEGIN
         SELECT 'Y'
           INTO v_rec.dsp_rec_existing
           FROM giac_gl_acct_ref_no
          WHERE gacc_tran_id = p_gacc_tran_id
            AND gl_acct_id = p_gl_acct_id
            AND sl_cd = p_sl_cd
            AND acct_tran_type = p_acct_tran_type
            AND transaction_cd = p_transaction_cd
            AND acct_seq_no = p_acct_seq_no;
      EXCEPTION
         WHEN NO_DATA_FOUND
         THEN
            v_rec.dsp_rec_existing := 'N';
      END;

      PIPE ROW (v_rec);
   END;

   FUNCTION get_rec_per_tran (
      p_gacc_tran_id   giac_gl_acct_ref_no.gacc_tran_id%TYPE
   )
      RETURN VARCHAR2
   IS
      v_setup_record   VARCHAR2 (32767);
   BEGIN
      FOR x IN (SELECT gacc_tran_id, gl_acct_id, sl_cd,
                          b.ledger_cd
                       || ' - '
                       || b.subledger_cd
                       || ' - '
                       || b.transaction_cd
                       || ' - '
                       || b.sl_cd
                       || ' - '
                       || b.acct_seq_no acct_ref_no
                  FROM giac_gl_acct_ref_no b
                 WHERE b.gacc_tran_id = p_gacc_tran_id
                   AND b.acct_tran_type = 'K')
      LOOP
         FOR y IN (SELECT gacc_tran_id, gl_acct_id, sl_cd, acct_ref_no
                     FROM giac_acct_entries a
                    WHERE a.acct_ref_no LIKE x.acct_ref_no
                      AND a.sl_cd = x.sl_cd
                      AND a.gl_acct_id = x.gl_acct_id
                      AND a.acct_tran_type = 'S')
         LOOP
            v_setup_record := y.acct_ref_no || ',' || v_setup_record;
         END LOOP;
      END LOOP;

      RETURN v_setup_record;
   END;

   FUNCTION get_rec_to_knock_off (
      p_gl_acct_id            giac_gl_subaccount_types.gl_acct_id%TYPE,
      p_sl_cd                 giac_gl_acct_ref_no.sl_cd%TYPE,
      p_transaction_cd        giac_gl_acct_ref_no.transaction_cd%TYPE,
      p_acct_ref_no           VARCHAR2,
      p_tran_cd               VARCHAR2,
      p_tran_desc             VARCHAR2,
      p_particulars           VARCHAR2,
      p_ref_no                VARCHAR2,
      p_outstanding_balance   VARCHAR2,
      p_order_by              VARCHAR2,
      p_asc_desc_flag         VARCHAR2,
      p_from                  NUMBER,
      p_to                    NUMBER,
      p_added_acct_ref_no1    VARCHAR2,
      p_added_acct_ref_no2    VARCHAR2,
      p_added_acct_ref_no3    VARCHAR2,
      p_gacc_tran_id          giac_gl_acct_ref_no.gacc_tran_id%TYPE
   )
      RETURN tran_type_k_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c                     cur_type;
      v_rec                 tran_type_k_type;
      v_sql                 VARCHAR2 (32767);
      v_added_acct_ref_no   VARCHAR2 (32767)
         :=    p_added_acct_ref_no1
            || p_added_acct_ref_no2
            || p_added_acct_ref_no3;
   BEGIN
      v_added_acct_ref_no := giac_gl_acct_ref_no_pkg.get_rec_per_tran (p_gacc_tran_id) || v_added_acct_ref_no;

      v_added_acct_ref_no := SUBSTR (v_added_acct_ref_no, 0, LENGTH (v_added_acct_ref_no) - 1);
              
      v_sql :=
         'SELECT mainsql.*
                    FROM (SELECT COUNT(1) OVER() count_, outersql.*
                            FROM (SELECT ROWNUM rownum_, innersql.*
                                    FROM (SELECT b.gl_acct_id, b.gacc_tran_id, b.ledger_cd, b.subledger_cd, e.dr_cr_tag, b.acct_seq_no,
                                                 b.ledger_cd||'' - ''||b.subledger_cd||'' - ''||b.transaction_cd||'' - ''||b.sl_cd||'' - ''||b.acct_seq_no acct_ref_no, 
                                                 c.transaction_cd, c.transaction_desc, d.particulars, d.tran_class ||'' - ''||LTRIM (TO_CHAR (d.tran_class_no, ''000000'')) ref_no,
                                                 TO_NUMBER(giac_gl_acct_ref_no_pkg.get_remaining_balance(b.gl_acct_id, b.sl_cd, f.acct_ref_no)) outstanding_bal
                                            FROM giac_gl_acct_ref_no b,
                                                 giac_gl_transaction_types c,
                                                 giac_acctrans d,
                                                 giac_chart_of_accts e,
                                                 giac_acct_entries f
                                           WHERE b.gl_acct_id = :p_gl_acct_id
                                             AND b.gl_acct_id = e.gl_acct_id
                                             AND b.gacc_tran_id = d.tran_id
                                             AND b.gacc_tran_id = f.gacc_tran_id
                                             AND b.gl_acct_id = f.gl_acct_id
                                             AND b.ledger_cd = c.ledger_cd
                                             AND b.subledger_cd = c.subledger_cd
                                             AND b.transaction_cd = c.transaction_cd
                                             AND b.sl_cd = :p_sl_cd
                                             AND f.sl_cd = b.sl_cd
                                             AND TO_NUMBER(giac_gl_acct_ref_no_pkg.get_remaining_balance(b.gl_acct_id, b.sl_cd, f.acct_ref_no)) > 0
                                             AND f.acct_ref_no = b.ledger_cd||'' - ''||b.subledger_cd||'' - ''||b.transaction_cd||'' - ''||b.sl_cd||'' - ''||b.acct_seq_no
                                             AND b.transaction_cd LIKE NVL(:p_transaction_cd,''%'')
                                             AND b.acct_tran_type = ''S''
                                             AND d.tran_flag IN (''C'', ''P'')
                                             AND b.gacc_tran_id NOT IN (SELECT gacc_tran_id
                                                                          FROM giac_reversals) ';

      IF v_added_acct_ref_no IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND (f.acct_ref_no) NOT IN (SELECT '''
            || v_added_acct_ref_no
            || ''' FROM DUAL) ';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'acctRefNo'
         THEN
            v_sql := v_sql || ' ORDER BY acct_ref_no ';
         ELSIF p_order_by = 'transactionCd'
         THEN
            v_sql := v_sql || ' ORDER BY transaction_cd ';
         ELSIF p_order_by = 'transactionDesc'
         THEN
            v_sql := v_sql || ' ORDER BY transaction_desc ';
         ELSIF p_order_by = 'particulars'
         THEN
            v_sql := v_sql || ' ORDER BY particulars ';
         ELSIF p_order_by = 'refNo'
         THEN
            v_sql := v_sql || ' ORDER BY ref_no ';
         ELSIF p_order_by = 'outstandingBal'
         THEN
            v_sql := v_sql || ' ORDER BY outstanding_bal ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      ELSE
         v_sql := v_sql || ' ORDER BY gacc_tran_id ASC ';
      END IF;

      v_sql := v_sql || ' ) innersql WHERE 1 = 1 ';

      IF p_acct_ref_no IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (acct_ref_no) LIKE '''
            || UPPER (p_acct_ref_no)
            || '''';
      END IF;

      IF p_tran_cd IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (transaction_cd) LIKE '''
            || UPPER (p_tran_cd)
            || '''';
      END IF;

      IF p_tran_desc IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (transaction_desc) LIKE '''
            || UPPER (p_tran_desc)
            || '''';
      END IF;

      IF p_particulars IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (particulars) LIKE '''
            || UPPER (p_particulars)
            || '''';
      END IF;

      IF p_ref_no IS NOT NULL
      THEN
         v_sql :=
            v_sql || ' AND UPPER (ref_no) LIKE ''' || UPPER (p_ref_no)
            || '''';
      END IF;

      IF p_ref_no IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND outstanding_bal LIKE '''
            || p_outstanding_balance
            || '''';
      END IF;

      v_sql :=
            v_sql
         || ' ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql USING p_gl_acct_id, p_sl_cd, p_transaction_cd;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.gl_acct_id,
               v_rec.gacc_tran_id, v_rec.ledger_cd, v_rec.subledger_cd,
               v_rec.dr_cr_tag, v_rec.acct_seq_no, v_rec.acct_ref_no,
               v_rec.transaction_cd, v_rec.transaction_desc,
               v_rec.particulars, v_rec.ref_no, v_rec.outstanding_bal;

            BEGIN
               SELECT NVL (a.particulars, NVL (b.particulars, c.particulars))
                 INTO v_rec.particulars
                 FROM giac_disb_vouchers a, giac_order_of_payts b, giac_acctrans c
                WHERE a.gacc_tran_id(+) = c.tran_id AND b.gacc_tran_id(+) = c.tran_id
                      AND c.tran_id = v_rec.gacc_tran_id;
            EXCEPTION
               WHEN TOO_MANY_ROWS
               THEN
                  v_rec.particulars := NULL;
               WHEN NO_DATA_FOUND
               THEN
                  v_rec.particulars := NULL;
            END;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END get_rec_to_knock_off;
END;
/