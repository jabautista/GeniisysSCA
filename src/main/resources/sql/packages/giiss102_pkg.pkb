CREATE OR REPLACE PACKAGE BODY CPI.GIISS102_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   10.22.2013
     ** Referenced By:  GIISS102 - Collateral Type Maintenance
     **/
     
   FUNCTION get_rec_list (
      p_coll_type     GIIS_COLLATERAL_TYPE.COLL_TYPE%type,
      p_coll_name     GIIS_COLLATERAL_TYPE.COLL_NAME%type
   ) RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.coll_type, a.coll_name, a.remarks, a.user_id,a.last_update
                  FROM GIIS_COLLATERAL_TYPE a
                 WHERE UPPER (a.coll_type) LIKE UPPER (NVL (p_coll_type, '%'))
                   AND UPPER (a.coll_name) LIKE UPPER (NVL (p_coll_name, '%'))
                 ORDER BY a.coll_type
                   )                   
      LOOP
         v_rec.coll_type    := i.coll_type;
         v_rec.coll_name    := i.coll_name;
         v_rec.remarks      := i.remarks;
         v_rec.user_id      := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec GIIS_COLLATERAL_TYPE%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_COLLATERAL_TYPE
         USING DUAL
         ON (coll_type = p_rec.coll_type)
         WHEN NOT MATCHED THEN
            INSERT (coll_type, coll_name, remarks, user_id, last_update)
            VALUES (p_rec.coll_type, p_rec.coll_name, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET coll_name = p_rec.coll_name, 
                   remarks = p_rec.remarks, 
				   user_id = p_rec.user_id, 
				   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_coll_type GIIS_COLLATERAL_TYPE.coll_type%TYPE)
   AS
   BEGIN
      DELETE FROM GIIS_COLLATERAL_TYPE
            WHERE coll_type = p_coll_type;
   END;

   PROCEDURE val_del_rec (p_coll_type GIIS_COLLATERAL_TYPE.coll_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      NULL;
   END;

   PROCEDURE val_add_rec (p_coll_type GIIS_COLLATERAL_TYPE.coll_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_COLLATERAL_TYPE a
                 WHERE a.coll_type = p_coll_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same coll_type.'
                                 );
      END IF;
   END;
   
END GIISS102_PKG;
/


