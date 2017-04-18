CREATE OR REPLACE PACKAGE BODY cpi.giacs342_pkg
AS
   FUNCTION get_gl_account_type (
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_account_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_account_type;
      v_sql   VARCHAR2 (10000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                FROM (SELECT COUNT(1) OVER() count_, outersql.*
                        FROM (SELECT ROWNUM rownum_, innersql.*
                                FROM (SELECT ledger_cd, UPPER(ledger_desc) AS ledger_desc
                                      FROM giac_gl_account_types ';
      
      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'ledgerCd'
         THEN
            v_sql := v_sql || ' ORDER BY ledger_cd ';
         ELSIF p_order_by = 'ledgerDesc'
         THEN
            v_sql := v_sql || ' ORDER BY ledger_desc ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;      

      v_sql := v_sql || ' ) innersql ';

      IF p_find_text IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' WHERE 1=1 AND UPPER(ledger_cd) LIKE UPPER('''
            || p_find_text
            || ''') OR UPPER(ledger_desc) LIKE UPPER('''
            || p_find_text
            || ''')';
      END IF;      

      v_sql :=
            v_sql
         || ' ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.ledger_cd,
               v_rec.ledger_desc;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;

   FUNCTION get_gl_subacct_type (
      p_find_text       VARCHAR2,
      p_ledger_cd       giac_gl_subaccount_types.ledger_cd%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_subacct_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_subacct_type;
      v_sql   VARCHAR2 (10000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
            FROM (SELECT COUNT(1) OVER() count_, outersql.*
                FROM (SELECT ROWNUM rownum_, innersql.*
                    FROM (SELECT subledger_cd, UPPER(subledger_desc) AS subledger_desc
                            FROM giac_gl_subaccount_types
                           WHERE UPPER(ledger_cd) = UPPER(:p_ledger_cd)';

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'subLedgerCd'
         THEN
            v_sql := v_sql || ' ORDER BY subledger_cd ';
         ELSIF p_order_by = 'subLedgerDesc'
         THEN
            v_sql := v_sql || ' ORDER BY subledger_desc ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql := v_sql || ' ) innersql ';

      IF p_find_text IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' WHERE UPPER(subledger_cd) LIKE UPPER('''
            || p_find_text
            || ''') OR UPPER(subledger_desc) LIKE UPPER('''
            || p_find_text
            || ''')';
      END IF;

      v_sql :=
            v_sql
         || ' ) outersql) mainsql WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql USING p_ledger_cd;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.subledger_cd,
               v_rec.subledger_desc;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;

   FUNCTION get_gl_trans_type (
      p_find_text       VARCHAR2,
      p_ledger_cd       giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd    giac_gl_transaction_types.subledger_cd%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_transaction_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_transaction_type;
      v_sql   VARCHAR2 (10000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                FROM (SELECT COUNT(1) OVER() count_, outersql.*
                    FROM (SELECT ROWNUM rownum_, innersql.*
                        FROM (SELECT transaction_cd, UPPER(transaction_desc) AS transaction_desc
                                 FROM giac_gl_transaction_types
                                WHERE UPPER(ledger_cd) = UPPER(:p_ledger_cd)
                                AND UPPER(subledger_cd) = UPPER(:p_subledger_cd)';

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

      v_sql := v_sql || ' ) innersql ';

      IF p_find_text IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' WHERE UPPER(transaction_cd) LIKE UPPER('''
            || p_find_text
            || ''') OR UPPER(transaction_desc) LIKE UPPER('''
            || p_find_text
            || ''')';
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

   FUNCTION get_sl_name (
      p_find_text       VARCHAR2,
      p_ledger_cd       giac_gl_account_types.ledger_cd%TYPE,
      p_subledger_cd    giac_gl_subaccount_types.subledger_cd%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN sl_name_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   sl_name;
      v_sql   VARCHAR2 (10000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                FROM (SELECT COUNT(1) OVER() count_, outersql.*
                    FROM (SELECT ROWNUM rownum_, innersql.*
                        FROM (SELECT sl_cd, UPPER(sl_name) AS sl_name
                                FROM giac_sl_lists
                              WHERE sl_type_cd = (SELECT b.gslt_sl_type_cd
                                                    FROM giac_gl_subaccount_types a, giac_chart_of_accts b
                                                   WHERE UPPER(ledger_cd) = UPPER(:p_ledger_cd)
                                                   AND UPPER(subledger_cd) = UPPER(:p_subledger_cd)
                                                   AND a.gl_acct_id = b.gl_acct_id)
                                                  AND fund_cd = giisp.v (''ACCTG_FOR_FUND_CODE'')';

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'slCd'
         THEN
            v_sql := v_sql || ' ORDER BY sl_cd ';
         ELSIF p_order_by = 'slName'
         THEN
            v_sql := v_sql || ' ORDER BY sl_name ';
         END IF;

         IF p_asc_desc_flag IS NOT NULL
         THEN
            v_sql := v_sql || p_asc_desc_flag;
         ELSE
            v_sql := v_sql || ' ASC';
         END IF;
      END IF;

      v_sql := v_sql || ' ) innersql ';
      
      IF p_find_text IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' WHERE UPPER(sl_cd) LIKE UPPER('''
            || p_find_text
            || ''') OR UPPER(sl_name) LIKE UPPER('''
            || p_find_text
            || ''')';
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
          INTO v_rec.count_, v_rec.rownum_, v_rec.sl_cd, v_rec.sl_name;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;
END;
/