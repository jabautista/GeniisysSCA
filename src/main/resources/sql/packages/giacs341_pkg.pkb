/* Created by   : Gzelle
 * Date Created : 10-29-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
CREATE OR REPLACE PACKAGE BODY cpi.giacs341_pkg
AS
   FUNCTION get_gl_subacct_type (
      p_ledger_cd          giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd       giac_gl_subaccount_types.subledger_cd%TYPE,
      p_subledger_desc     giac_gl_subaccount_types.subledger_desc%TYPE,
      p_gl_acct_category   giac_gl_subaccount_types.gl_acct_category%TYPE,
      p_gl_control_acct    giac_gl_subaccount_types.gl_control_acct%TYPE,
      p_gl_sub_acct_1      giac_gl_subaccount_types.gl_sub_acct_1%TYPE,
      p_gl_sub_acct_2      giac_gl_subaccount_types.gl_sub_acct_2%TYPE,
      p_gl_sub_acct_3      giac_gl_subaccount_types.gl_sub_acct_3%TYPE,
      p_gl_sub_acct_4      giac_gl_subaccount_types.gl_sub_acct_4%TYPE,
      p_gl_sub_acct_5      giac_gl_subaccount_types.gl_sub_acct_5%TYPE,
      p_gl_sub_acct_6      giac_gl_subaccount_types.gl_sub_acct_6%TYPE,
      p_gl_sub_acct_7      giac_gl_subaccount_types.gl_sub_acct_7%TYPE,
      p_gl_acct_name       giac_gl_subaccount_types.gl_acct_name%TYPE,
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER
   )
      RETURN gl_subacct_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_subacct_type;
      v_sql   VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                       FROM (
                        SELECT COUNT (1) OVER () count_, outersql.* 
                          FROM (
                                SELECT ROWNUM rownum_, innersql.*
                                  FROM (
                                        SELECT gl.ledger_cd, gl.subledger_cd, gl.subledger_desc, gl.gl_acct_id, gl.gl_acct_category,
                                               gl.gl_control_acct, gl.gl_sub_acct_1, gl.gl_sub_acct_2, gl.gl_sub_acct_3, gl.gl_sub_acct_4,
                                               gl.gl_sub_acct_5, gl.gl_sub_acct_6, gl.gl_sub_acct_7, gl.gl_acct_name, gl.active_tag,
                                               gl.remarks, gl.user_id, TO_CHAR (gl.last_update, ''MM-DD-YYYY HH:MI:SS AM'') last_update
                                          FROM giac_gl_subaccount_types gl
                                         WHERE UPPER(gl.ledger_cd) LIKE UPPER(''' || p_ledger_cd ||''')
                                       ) innersql WHERE 1 = 1 ';

      IF p_subledger_cd IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (subledger_cd) LIKE '''
            || UPPER (p_subledger_cd)
            || '''';
      END IF;

      IF p_subledger_desc IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (subledger_desc) LIKE '''
            || UPPER (p_subledger_desc)
            || '''';
      END IF;

      IF p_gl_acct_category IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_acct_category = ' || p_gl_acct_category;
      END IF;

      IF p_gl_control_acct IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_control_acct = ' || p_gl_control_acct;
      END IF;

      IF p_gl_sub_acct_1 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_1 = ' || p_gl_sub_acct_1;
      END IF;

      IF p_gl_sub_acct_2 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_2 = ' || p_gl_sub_acct_2;
      END IF;

      IF p_gl_sub_acct_3 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_3 = ' || p_gl_sub_acct_3;
      END IF;

      IF p_gl_sub_acct_4 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_4 = ' || p_gl_sub_acct_4;
      END IF;

      IF p_gl_sub_acct_5 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_5 = ' || p_gl_sub_acct_5;
      END IF;

      IF p_gl_sub_acct_6 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_6 = ' || p_gl_sub_acct_6;
      END IF;

      IF p_gl_sub_acct_7 IS NOT NULL
      THEN
         v_sql := v_sql || ' AND gl_sub_acct_7 = ' || p_gl_sub_acct_7;
      END IF;

      IF p_gl_acct_name IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (gl_acct_name) LIKE '''
            || UPPER (p_gl_acct_name)
            || '''';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'subLedgerCd'
         THEN
            v_sql := v_sql || ' ORDER BY subledger_cd ';
         ELSIF p_order_by = 'subLedgerDesc'
         THEN
            v_sql := v_sql || ' ORDER BY subledger_desc ';
         ELSIF p_order_by = 'glAcctCategory glControlAcct glSubAcct1 glSubAcct2 glSubAcct3 glSubAcct4 glSubAcct5 glSubAcct6 glSubAcct7'
         THEN
            v_sql := v_sql || ' ORDER BY gl_acct_category ';            
         ELSIF p_order_by = 'glAcctName'
         THEN
            v_sql := v_sql || ' ORDER BY gl_acct_name ';
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
         || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.ledger_cd,
               v_rec.subledger_cd, v_rec.subledger_desc, v_rec.gl_acct_id,
               v_rec.gl_acct_category, v_rec.gl_control_acct,
               v_rec.gl_sub_acct_1, v_rec.gl_sub_acct_2, v_rec.gl_sub_acct_3,
               v_rec.gl_sub_acct_4, v_rec.gl_sub_acct_5, v_rec.gl_sub_acct_6,
               v_rec.gl_sub_acct_7, v_rec.gl_acct_name, v_rec.active_tag,
               v_rec.remarks, v_rec.user_id, v_rec.last_update;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;

   PROCEDURE set_gl_subacct_type (
      p_orig_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE,
      p_btn_val             VARCHAR2,
      p_rec                 giac_gl_subaccount_types%ROWTYPE
   )
   IS
      v_check   VARCHAR2 (1) := 'N';
   BEGIN
      BEGIN
         FOR i IN (SELECT 'Y'
                     FROM giac_gl_subaccount_types
                    WHERE subledger_cd = p_orig_subledger_cd
                      AND ledger_cd = p_rec.ledger_cd)
         LOOP
            v_check := 'Y';
            EXIT;
         END LOOP;
      END;

      IF p_btn_val = 'Update' AND v_check = 'Y'
      THEN
         giacs341_pkg.del_gl_subacct_type (p_rec.ledger_cd, p_orig_subledger_cd);
         
         COMMIT;
      END IF;

      FOR x IN (SELECT gl_acct_category, gl_control_acct, gl_sub_acct_1,
                       gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4,
                       gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7,
                       gl_acct_name
                  FROM giac_chart_of_accts
                 WHERE gl_acct_id = p_rec.gl_acct_id)
      LOOP
         INSERT INTO giac_gl_subaccount_types
                     (ledger_cd, subledger_cd,
                      subledger_desc, gl_acct_id,
                      gl_acct_category, gl_control_acct,
                      gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3,
                      gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6,
                      gl_sub_acct_7, gl_acct_name, active_tag,
                      remarks, user_id, last_update
                     )
              VALUES (p_rec.ledger_cd, p_rec.subledger_cd,
                      p_rec.subledger_desc, p_rec.gl_acct_id,
                      x.gl_acct_category, x.gl_control_acct,
                      x.gl_sub_acct_1, x.gl_sub_acct_2, x.gl_sub_acct_3,
                      x.gl_sub_acct_4, x.gl_sub_acct_5, x.gl_sub_acct_6,
                      x.gl_sub_acct_7, x.gl_acct_name, p_rec.active_tag,
                      p_rec.remarks, p_rec.user_id, SYSDATE
                     );
      END LOOP;
   END;

   PROCEDURE val_del_rec (
      p_ledger_cd      giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_gl_transaction_types
                 WHERE ledger_cd = p_ledger_cd
                   AND subledger_cd = p_subledger_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete the record while dependent record/s exists in GIAC_GL_TRANSACTION_TYPES.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_ledger_cd      giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE,
      p_btn_val        VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_btn_val = 'Add'
      THEN
          FOR i IN (SELECT '1'
                      FROM giac_gl_subaccount_types a
                     WHERE a.ledger_cd = p_ledger_cd
                       AND a.subledger_cd = p_subledger_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error (-20001,
                                         'Geniisys Exception#E#'
                                      || p_subledger_cd
                                      || ' already exists.'
                                     );
          END IF;
      ELSIF p_btn_val = 'Update'
      THEN
          FOR i IN (SELECT 1
                      FROM giac_gl_transaction_types
                     WHERE ledger_cd = p_ledger_cd
                       AND subledger_cd = p_subledger_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Cannot update the record while dependent record/s exists in GIAC_GL_TRANSACTION_TYPES.'
                );
          END IF;
      END IF;
   END;

   PROCEDURE val_upd_rec (
      p_ledger_cd        giac_gl_subaccount_types.ledger_cd%TYPE,
      p_new_subledger_cd giac_gl_subaccount_types.subledger_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_gl_subaccount_types a
                 WHERE a.ledger_cd = p_ledger_cd
                   AND a.subledger_cd = p_new_subledger_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                     'Geniisys Exception#E#'
                                  || p_new_subledger_cd
                                  || ' already exists.'
                                 );
      END IF;
   END;    

   PROCEDURE del_gl_subacct_type (
      p_ledger_cd      giac_gl_subaccount_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_subaccount_types.subledger_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_gl_subaccount_types
            WHERE ledger_cd = p_ledger_cd AND subledger_cd = p_subledger_cd;
   END;

    FUNCTION get_giacs341_gl_acct_code (
       p_not_in1         VARCHAR2,            
       p_not_in2         VARCHAR2,
       p_not_in3         VARCHAR2,    
       p_find_text       VARCHAR2,
       p_order_by        VARCHAR2,
       p_asc_desc_flag   VARCHAR2,
       p_from            NUMBER,
       p_to              NUMBER
    )
       RETURN gl_acct_code_tab PIPELINED
    IS
       TYPE cur_type IS REF CURSOR;

       c         cur_type;
       v_rec     gl_acct_code_type;
       v_sql     VARCHAR2 (10000);
       v_not_in  VARCHAR2 (16000) := p_not_in1 || p_not_in2 || p_not_in3;
       
    BEGIN
       v_sql :=
          'SELECT mainsql.*
                    FROM (SELECT COUNT(1) OVER() count_, outersql.*
                            FROM (SELECT ROWNUM rownum_, innersql.*
                                    FROM (SELECT gl_acct_id, gl_acct_category, 
                                                 LPAD (gl_control_acct, 2, ''0'') gl_control_acct,
                                                   LPAD (gl_sub_acct_1, 2, ''0'') gl_sub_acct_1,
                                                   LPAD (gl_sub_acct_2, 2, ''0'') gl_sub_acct_2,
                                                   LPAD (gl_sub_acct_3, 2, ''0'') gl_sub_acct_3,
                                                   LPAD (gl_sub_acct_4, 2, ''0'') gl_sub_acct_4,
                                                   LPAD (gl_sub_acct_5, 2, ''0'') gl_sub_acct_5,
                                                   LPAD (gl_sub_acct_6, 2, ''0'') gl_sub_acct_6,
                                                   LPAD (gl_sub_acct_7, 2, ''0'') gl_sub_acct_7,
                                                   gl_acct_name                               
                                            FROM giac_chart_of_accts
                                           WHERE leaf_tag = ''Y'' ';
       
       IF v_not_in IS NOT NULL
       THEN
         v_sql := v_sql || ' AND gl_acct_id NOT IN (' || v_not_in || ') ';
       END IF;

       IF p_find_text IS NOT NULL
       THEN
          v_sql :=
                v_sql
             || ' AND (gl_acct_category 
             ||  LPAD (gl_control_acct, 2, ''0'') 
             ||  LPAD (gl_sub_acct_1, 2, ''0'') 
             ||  LPAD (gl_sub_acct_2, 2, ''0'') 
             ||  LPAD (gl_sub_acct_3, 2, ''0'') 
             ||  LPAD (gl_sub_acct_4, 2, ''0'') 
             ||  LPAD (gl_sub_acct_5, 2, ''0'') 
             ||  LPAD (gl_sub_acct_6, 2, ''0'') 
             ||  LPAD (gl_sub_acct_7, 2, ''0'') LIKE '''
             || p_find_text
             || ''' OR UPPER(gl_acct_name) LIKE UPPER('''
             || p_find_text
             || '''))';
       END IF;

       v_sql := v_sql || ' ) innersql';

       IF p_order_by IS NOT NULL
       THEN
          IF p_order_by = 'glAcctCode'
          THEN
             v_sql :=
                   v_sql
                || ' ORDER BY gl_acct_category, gl_control_acct, gl_sub_acct_1, gl_sub_acct_2, gl_sub_acct_3, gl_sub_acct_4, gl_sub_acct_5, gl_sub_acct_6, gl_sub_acct_7';
          ELSIF p_order_by = 'glAcctName'
          THEN
             v_sql := v_sql || ' ORDER BY gl_acct_name ';
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

       OPEN c FOR v_sql;

       LOOP
          FETCH c
           INTO v_rec.count_, v_rec.rownum_, v_rec.gl_acct_id,
                v_rec.gl_acct_category, v_rec.gl_control_acct,
                v_rec.gl_sub_acct_1, v_rec.gl_sub_acct_2, v_rec.gl_sub_acct_3,
                v_rec.gl_sub_acct_4, v_rec.gl_sub_acct_5, v_rec.gl_sub_acct_6,
                v_rec.gl_sub_acct_7, v_rec.gl_acct_name;

          EXIT WHEN c%NOTFOUND;
          PIPE ROW (v_rec);
       END LOOP;

       CLOSE c;
    END;  
    
    FUNCTION get_all_gl_acct_code
       RETURN gl_acct_id_tab PIPELINED
    IS
       v_rec   gl_acct_id_type;
    BEGIN
       FOR i IN (SELECT gl_acct_id
                   FROM giac_gl_subaccount_types)
       LOOP
          v_rec.gl_acct_id := i.gl_acct_id;
          PIPE ROW (v_rec);
       END LOOP;
    END;      
    
    /*giac_gl_transaction_types*/
   FUNCTION get_gl_transaction_type (
      p_ledger_cd          giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd       giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd     giac_gl_transaction_types.transaction_cd%TYPE,
      p_transaction_desc   giac_gl_transaction_types.transaction_desc%TYPE,
      p_active_tag         giac_gl_transaction_types.active_tag%TYPE,
      p_order_by           VARCHAR2,
      p_asc_desc_flag      VARCHAR2,
      p_from               NUMBER,
      p_to                 NUMBER
   )
      RETURN gl_transaction_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_transaction_type;
      v_sql   VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                       FROM (
                        SELECT COUNT (1) OVER () count_, outersql.* 
                          FROM (
                                SELECT ROWNUM rownum_, innersql.*
                                  FROM (
                                        SELECT gl.ledger_cd, gl.subledger_cd, gl.transaction_cd, gl.transaction_desc, 
                                               gl.active_tag, get_rv_meaning(''YES NO'', gl.active_tag) dsp_active_tag, 
                                               gl.remarks, gl.user_id, TO_CHAR (gl.last_update, ''MM-DD-YYYY HH:MI:SS AM'') last_update
                                          FROM giac_gl_transaction_types gl
                                         WHERE UPPER(gl.ledger_cd) LIKE  UPPER(''' || p_ledger_cd || ''')
                                           AND UPPER(gl.subledger_cd) LIKE UPPER('''|| p_subledger_cd || ''')
                                       ) innersql WHERE 1 = 1 ';

      IF p_transaction_cd IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (transaction_cd) LIKE '''
            || UPPER (p_transaction_cd)
            || '''';
      END IF;

      IF p_transaction_desc IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (transaction_desc) LIKE '''
            || UPPER (p_transaction_desc)
            || '''';
      END IF;

      IF p_active_tag IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (dsp_active_tag) LIKE '''
            || UPPER (p_active_tag)
            || '''';
      END IF;      

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'transactionCd'
         THEN
            v_sql := v_sql || ' ORDER BY transaction_cd ';
         ELSIF p_order_by = 'transactionDesc'
         THEN
            v_sql := v_sql || ' ORDER BY transaction_desc ';
         ELSIF p_order_by = 'dspActiveTag'
         THEN
            v_sql := v_sql || ' ORDER BY active_tag ';
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
         || '
                            ) outersql
                         ) mainsql
                    WHERE rownum_ BETWEEN '
         || p_from
         || ' AND '
         || p_to;

      OPEN c FOR v_sql;

      LOOP
         FETCH c
          INTO v_rec.count_, v_rec.rownum_, v_rec.ledger_cd,
               v_rec.subledger_cd, v_rec.transaction_cd,
               v_rec.transaction_desc, v_rec.active_tag, v_rec.dsp_active_tag, 
               v_rec.remarks, v_rec.user_id, v_rec.last_update;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;

   PROCEDURE set_gl_transaction_type (
      p_orig_transaction_cd giac_gl_transaction_types.subledger_cd%TYPE,
      p_btn_val             VARCHAR2,
      p_rec                 giac_gl_transaction_types%ROWTYPE
   )
   IS
      v_check   VARCHAR2 (1) := 'N';
   BEGIN
      BEGIN
         FOR i IN (SELECT 'Y'
                     FROM giac_gl_transaction_types
                    WHERE subledger_cd = p_rec.subledger_cd
                      AND ledger_cd = p_rec.ledger_cd
                      AND transaction_cd = p_orig_transaction_cd)
         LOOP
            v_check := 'Y';
            EXIT;
         END LOOP;
      END;

      IF p_btn_val = 'Update' AND v_check = 'Y'
      THEN
         giacs341_pkg.del_gl_transaction_type (p_rec.ledger_cd, p_rec.subledger_cd, p_orig_transaction_cd);
         
         COMMIT;
      END IF;

     INSERT INTO giac_gl_transaction_types
                 (ledger_cd, subledger_cd, transaction_cd,
                  transaction_desc, active_tag,
                  remarks, user_id, last_update
                 )
          VALUES (p_rec.ledger_cd, p_rec.subledger_cd, p_rec.transaction_cd,
                  p_rec.transaction_desc, p_rec.active_tag,
                  p_rec.remarks, p_rec.user_id, SYSDATE
                 );
   END;

   PROCEDURE val_del_rec (
      p_ledger_cd      giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd giac_gl_transaction_types.transaction_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_gl_acct_ref_no
                 WHERE ledger_cd = p_ledger_cd
                   AND subledger_cd = p_subledger_cd
                   AND transaction_cd = p_transaction_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete the record while dependent record/s exists in GIAC_GL_ACCT_REF_NO.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_ledger_cd      giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd giac_gl_transaction_types.transaction_cd%TYPE,
      p_btn_val        VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_btn_val = 'Add'
      THEN
          FOR i IN (SELECT '1'
                      FROM giac_gl_transaction_types a
                     WHERE a.ledger_cd = p_ledger_cd
                       AND a.subledger_cd = p_subledger_cd
                       AND a.transaction_cd = p_transaction_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error (-20001,
                                         'Geniisys Exception#E#'
                                      || p_transaction_cd
                                      || ' already exists.'
                                     );
          END IF;
      ELSIF p_btn_val = 'Update'
      THEN
          FOR i IN (SELECT 1
                      FROM giac_gl_acct_ref_no
                     WHERE ledger_cd = p_ledger_cd
                       AND subledger_cd = p_subledger_cd
                       AND transaction_cd = p_transaction_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Cannot update the record while dependent record/s exists in GIAC_GL_ACCT_REF_NO.'
                );
          END IF;
      END IF;
   END;
   
   PROCEDURE val_upd_tran_rec (
      p_ledger_cd           giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd        giac_gl_transaction_types.subledger_cd%TYPE,
      p_new_transaction_cd  giac_gl_transaction_types.transaction_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_gl_transaction_types a
                 WHERE a.ledger_cd = p_ledger_cd
                   AND a.subledger_cd = p_subledger_cd
                   AND a.transaction_cd = p_new_transaction_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                     'Geniisys Exception#E#'
                                  || p_new_transaction_cd
                                  || ' already exists.'
                                 );
      END IF;
   END;   

   PROCEDURE del_gl_transaction_type (
      p_ledger_cd      giac_gl_transaction_types.ledger_cd%TYPE,
      p_subledger_cd   giac_gl_transaction_types.subledger_cd%TYPE,
      p_transaction_cd giac_gl_transaction_types.transaction_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM giac_gl_transaction_types
            WHERE ledger_cd = p_ledger_cd 
              AND subledger_cd = p_subledger_cd
              AND transaction_cd = p_transaction_cd;
   END;    

    
END;
/