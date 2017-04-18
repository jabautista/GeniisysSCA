CREATE OR REPLACE PACKAGE BODY CPI.giiss117_pkg
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
                  SELECT type_of_body_cd, type_of_body, remarks, user_id, last_update
                    FROM giis_type_of_body
                ORDER BY type_of_body_cd
               )                   
      LOOP
         v_rec.type_of_body_cd   := i.type_of_body_cd;
         v_rec.type_of_body      := i.type_of_body;   
         v_rec.remarks       := i.remarks;
         v_rec.user_id       := i.user_id;
         v_rec.last_update   := i.last_update; --TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MM:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_type_of_body%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_TYPE_OF_BODY
         USING DUAL
         ON (type_of_body_cd = p_rec.type_of_body_cd)
         WHEN NOT MATCHED THEN
            INSERT (type_of_body_cd, type_of_body, remarks, user_id, last_update)
            VALUES (TYPE_OF_BODY_cd_S.NEXTVAL, p_rec.type_of_body, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET type_of_body = p_rec.type_of_body,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_type_of_body_cd giis_type_of_body.type_of_body_cd%TYPE)
   AS
   BEGIN
      DELETE FROM GIIS_TYPE_OF_BODY
            WHERE type_of_body_cd = p_type_of_body_cd;
   END;

   FUNCTION val_del_rec (p_type_of_body_cd giis_type_of_body.type_of_body_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (20) := 'N';
   BEGIN
      	FOR a IN (
              SELECT 1
                FROM gipi_vehicle
               WHERE type_of_body_cd = p_type_of_body_cd
        )
        LOOP
            v_exists := 'GIPI_VEHICLE';
            EXIT;
        END LOOP;
        
        FOR a IN (
              SELECT 1
                FROM gipi_wvehicle
               WHERE type_of_body_cd = p_type_of_body_cd
        )
        LOOP
            v_exists := 'GIPI_WVEHICLE';
            EXIT;
        END LOOP;
        
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (p_type_of_body  VARCHAR2)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIIS_TYPE_OF_BODY a
                 WHERE a.type_of_body = p_type_of_body)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  --'Geniisys Exception#E#Record already exists with the same Type of Body.' -- replaced with codes below : shan 07.10.2014
                                  'Geniisys Exception#E#Record already exists with the same type_of_body.'
                                 );
      END IF;
   END;
END;
/


