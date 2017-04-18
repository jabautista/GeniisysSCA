CREATE OR REPLACE PACKAGE BODY CPI.giiss048_pkg
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.air_type_cd, a.air_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_air_type a
                 ORDER BY a.air_type_cd
                   )                   
      LOOP
         v_rec.air_type_cd   := i.air_type_cd;
         v_rec.air_desc      := i.air_desc;
         v_rec.remarks       := i.remarks;
         v_rec.user_id       := i.user_id;
         v_rec.last_update   := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_air_type%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_AIR_TYPE
         USING DUAL
         ON (air_type_cd = p_rec.air_type_cd)
         WHEN NOT MATCHED THEN
            INSERT (air_type_cd, air_desc, remarks, user_id, last_update)
            VALUES (p_rec.air_type_cd, p_rec.air_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET air_desc = p_rec.air_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_air_type_cd giis_air_type.air_type_cd%TYPE)
   AS
   BEGIN
      DELETE FROM GIIS_AIR_TYPE
            WHERE air_type_cd = p_air_type_cd;
   END;

   FUNCTION val_del_rec (p_air_type_cd giis_air_type.air_type_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
          FOR a IN (
              SELECT 1
                FROM giis_vessel
               WHERE air_type_cd = p_air_type_cd
        )
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (p_air_type_cd giis_air_type.air_type_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_AIR_TYPE a
                 WHERE a.air_type_cd = p_air_type_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same air_type_cd.'
                                 );
      END IF;
   END;
END;
/


