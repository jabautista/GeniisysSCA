CREATE OR REPLACE PACKAGE BODY CPI.giiss099_pkg
AS
   FUNCTION get_rec_list (
      p_clause_type     giis_bond_class_clause.clause_type%TYPE,
      p_clause_desc   giis_bond_class_clause.clause_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.clause_type, a.clause_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_bond_class_clause a
                 WHERE UPPER (a.clause_type) LIKE UPPER (NVL (p_clause_type, '%'))
                   AND UPPER (a.clause_desc) LIKE UPPER (NVL (p_clause_desc, '%'))
                 ORDER BY a.clause_type
                   )                   
      LOOP
         v_rec.clause_type := i.clause_type;
         v_rec.clause_desc := i.clause_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_bond_class_clause%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_bond_class_clause
         USING DUAL
         ON (clause_type = p_rec.clause_type)
         WHEN NOT MATCHED THEN
            INSERT (clause_type, clause_desc, remarks, user_id, last_update)
            VALUES (p_rec.clause_type, p_rec.clause_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET clause_desc = p_rec.clause_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_clause_type giis_bond_class_clause.clause_type%TYPE)
   AS
   BEGIN
      DELETE FROM giis_bond_class_clause
            WHERE clause_type = p_clause_type;
   END;

   PROCEDURE val_del_rec (p_clause_type giis_bond_class_clause.clause_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gipi_wbond_basic a
                 WHERE a.clause_type = p_clause_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_BOND_CLASS_CLAUSE while dependent record(s) in GIPI_WBOND_BASIC exists.'
                                 );
      ELSE
          FOR i IN (SELECT '1'
                      FROM giis_bond_class_subline a
                     WHERE a.clause_type = p_clause_type)
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;
          
          IF v_exists = 'Y'
          THEN
             raise_application_error (-20001,
                                      'Geniisys Exception#E#Cannot delete record from GIIS_BOND_CLASS_CLAUSE while dependent record(s) in GIIS_BOND_CLASS_SUBLINE exists.'
                                     );
          END IF;                                       
      END IF;
   END;
   
   PROCEDURE val_add_rec (p_clause_type giis_bond_class_clause.clause_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_bond_class_clause a
                 WHERE a.clause_type = p_clause_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same clause_type.'
                                 );
      END IF;
   END;
END;
/


