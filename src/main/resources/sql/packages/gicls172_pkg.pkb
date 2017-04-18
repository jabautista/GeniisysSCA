CREATE OR REPLACE PACKAGE BODY CPI.gicls172_pkg
AS
   FUNCTION get_rec_list (
      p_repair_cd     gicl_repair_type.repair_cd%TYPE,
      p_repair_desc   gicl_repair_type.repair_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.repair_cd, a.repair_desc, a.required, a.remarks, a.user_id,
                       a.last_update
                  FROM gicl_repair_type a
                 WHERE UPPER (a.repair_cd) LIKE UPPER (NVL (p_repair_cd, '%'))
                   AND UPPER (a.repair_desc) LIKE UPPER (NVL (p_repair_desc, '%'))
                 ORDER BY a.repair_cd
                   )                   
      LOOP
         v_rec.repair_cd := i.repair_cd;
         v_rec.repair_desc := i.repair_desc;
		 v_rec.required := i.required;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec gicl_repair_type%ROWTYPE)
   IS
   BEGIN
      MERGE INTO gicl_repair_type
         USING DUAL
         ON (repair_cd = p_rec.repair_cd)
         WHEN NOT MATCHED THEN
            INSERT (repair_cd, repair_desc, required, remarks, user_id, last_update)
            VALUES (p_rec.repair_cd, p_rec.repair_desc, p_rec.required, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET repair_desc = p_rec.repair_desc, required = p_rec.required,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_repair_cd gicl_repair_type.repair_cd%TYPE)
   AS
   BEGIN
      DELETE FROM gicl_repair_type
            WHERE repair_cd = p_repair_cd;
   END;
   
   PROCEDURE val_add_rec (p_repair_cd gicl_repair_type.repair_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gicl_repair_type a
                 WHERE a.repair_cd = p_repair_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same repair_cd.'
                                 );
      END IF;
   END;
   
   PROCEDURE val_del_rec (p_repair_cd gicl_repair_type.repair_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM gicl_repair_other_dtl a
                 WHERE a.repair_cd = p_repair_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GICL_REPAIR_TYPE while dependent records in GICL_REPAIR_OTHER_DTL exists.'
                                 );
      END IF;
   END val_del_rec;
END;
/


