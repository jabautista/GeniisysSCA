/* Created by   : Gzelle
 * Date Created : 10-27-2015
 * Remarks		: KB#132 - Accounting - AP/AR Enhancement
 */
CREATE OR REPLACE PACKAGE BODY cpi.giacs340_pkg
AS
   FUNCTION get_gl_acct_type (
      p_ledger_cd       giac_gl_account_types.ledger_cd%TYPE,
      p_ledger_desc     giac_gl_account_types.ledger_desc%TYPE,
      p_dsp_active_tag  giac_gl_account_types.active_tag%TYPE,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN gl_acct_type_tab PIPELINED
   IS
      TYPE cur_type IS REF CURSOR;

      c       cur_type;
      v_rec   gl_acct_type;
      v_sql   VARCHAR2 (9000);
   BEGIN
      v_sql :=
         'SELECT mainsql.*
                       FROM (
                        SELECT COUNT (1) OVER () count_, outersql.* 
                          FROM (
                                SELECT ROWNUM rownum_, innersql.*
                                  FROM (
                                        SELECT gl.ledger_cd, gl.ledger_desc, gl.active_tag, get_rv_meaning(''YES NO'', gl.active_tag) dsp_active_tag, 
                                               gl.remarks, gl.user_id, TO_CHAR (gl.last_update, ''MM-DD-YYYY HH:MI:SS AM'') last_update
                                          FROM giac_gl_account_types gl ';
                                      

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'dspActiveTag'
         THEN
            v_sql := v_sql || ' ORDER BY gl.active_tag ';
                               
             IF p_asc_desc_flag IS NOT NULL
             THEN
                v_sql := v_sql || p_asc_desc_flag;
             ELSE
                v_sql := v_sql || ' ASC';
             END IF;
         END IF;         
      END IF;

      v_sql := v_sql || ' ) innersql WHERE 1 = 1 '; 
      
      IF p_ledger_cd IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (ledger_cd) LIKE '''
            || UPPER (p_ledger_cd)
            || '''';
      END IF;

      IF p_ledger_desc IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (ledger_desc) LIKE '''
            || UPPER (p_ledger_desc)
            || '''';
      END IF;

      IF p_dsp_active_tag IS NOT NULL
      THEN
         v_sql :=
               v_sql
            || ' AND UPPER (dsp_active_tag) LIKE '''
            || UPPER (p_dsp_active_tag)
            || '''';
      END IF;

      IF p_order_by IS NOT NULL
      THEN
         IF p_order_by = 'ledgerCd'
         THEN
            v_sql := v_sql || ' ORDER BY ledger_cd ';
         ELSIF p_order_by = 'ledgerDesc'
         THEN
            v_sql := v_sql || ' ORDER BY ledger_desc ';
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
          INTO v_rec.count_, 
               v_rec.rownum_, 
               v_rec.ledger_cd,
               v_rec.ledger_desc, 
               v_rec.active_tag, 
               v_rec.dsp_active_tag,
               v_rec.remarks, 
               v_rec.user_id,
               v_rec.last_update;

         EXIT WHEN c%NOTFOUND;
         PIPE ROW (v_rec);
      END LOOP;

      CLOSE c;
   END;

    PROCEDURE set_gl_acct_type (
       p_orig_ledger_cd   giac_gl_account_types.ledger_cd%TYPE,
       p_btn_val          VARCHAR2,
       p_rec              giac_gl_account_types%ROWTYPE
    )
    IS
       v_check   VARCHAR2 (1) := 'N';
    BEGIN
       BEGIN
          FOR i IN (SELECT 'Y'
                      FROM giac_gl_account_types
                     WHERE ledger_cd = p_orig_ledger_cd)
          LOOP
             v_check := 'Y';
             EXIT;
          END LOOP;
       END;

       IF p_btn_val = 'Update' AND v_check = 'Y'
       THEN
          giacs340_pkg.del_gl_acct_type(p_orig_ledger_cd);
          
          COMMIT;
       END IF;

      INSERT INTO giac_gl_account_types
                  (ledger_cd, ledger_desc, active_tag,
                   remarks, user_id, last_update
                  )
           VALUES (p_rec.ledger_cd, p_rec.ledger_desc, p_rec.active_tag,
                   p_rec.remarks, p_rec.user_id, SYSDATE
                  );       
    END;

   PROCEDURE val_del_rec (
      p_ledger_cd   giac_gl_account_types.ledger_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT 1
                  FROM giac_gl_subaccount_types
                 WHERE ledger_cd = p_ledger_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete the record while dependent record/s exists in GIAC_GL_SUBACCOUNT_TYPES.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (
      p_ledger_cd      giac_gl_account_types.ledger_cd%TYPE,
      p_btn_val        VARCHAR2
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_btn_val = 'Add'
      THEN
          FOR i IN (SELECT '1'
                      FROM giac_gl_account_types a
                     WHERE a.ledger_cd = p_ledger_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error (-20001,
                                         'Geniisys Exception#E#'
                                      || p_ledger_cd
                                      || ' already exists.'
                                     );
          END IF;
      ELSIF p_btn_val = 'Update'
      THEN
          FOR i IN (SELECT 1
                      FROM giac_gl_subaccount_types
                     WHERE ledger_cd = p_ledger_cd)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;

          IF v_exists = 'Y'
          THEN
             raise_application_error
                (-20001,
                 'Geniisys Exception#E#Cannot update the record while dependent record/s exists in GIAC_GL_SUBACCOUNT_TYPES.'
                );       
          END IF; 
      END IF;      
   END;

   PROCEDURE val_upd_rec (
      p_curr_ledger_cd giac_gl_account_types.ledger_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      /*check if new ledger_cd is already existing--*/
      FOR i IN (SELECT '1'
                  FROM giac_gl_account_types a
                 WHERE a.ledger_cd = p_curr_ledger_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                     'Geniisys Exception#E#'
                                  || p_curr_ledger_cd
                                  || ' already exists1.'
                                 );
      END IF;          
   END;   

   PROCEDURE del_gl_acct_type (p_ledger_cd giac_gl_account_types.ledger_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giac_gl_account_types
            WHERE ledger_cd = p_ledger_cd;
   END;
END;
/