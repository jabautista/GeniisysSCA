CREATE OR REPLACE PACKAGE BODY CPI.GIISS023_PKG
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT position_cd, position, remarks, user_id, last_update
                  FROM GIIS_POSITION
                 ORDER BY position_cd
                   )                   
      LOOP
         v_rec.position_cd   := i.position_cd;
         v_rec.position      := i.position;   
         v_rec.remarks       := i.remarks;
         v_rec.user_id       := i.user_id;
         v_rec.last_update   := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_position%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_POSITION
         USING DUAL
         ON (position_cd = p_rec.position_cd)
         WHEN NOT MATCHED THEN
            INSERT (position_cd, position, remarks, user_id, last_update)
            VALUES (POSITION_CD_S.NEXTVAL, p_rec.position, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET position = p_rec.position,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_position_cd giis_position.position_cd%TYPE)
   AS
   BEGIN
      DELETE FROM GIIS_POSITION
            WHERE position_cd = p_position_cd;
   END;

   FUNCTION val_del_rec (p_position_cd giis_position.position_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (100) := 'N';
   BEGIN
        IF v_exists = 'N' THEN
            FOR a IN (
              SELECT 1
                FROM GIPI_WACCIDENT_ITEM
               WHERE position_cd = p_position_cd
            )
            LOOP
                v_exists := 'GIPI_WACCIDENT_ITEM';
                EXIT;
            END LOOP;
        
        END IF;
        
        IF v_exists = 'N' THEN
            FOR a IN (
                  SELECT 1
                    FROM GIPI_ACCIDENT_ITEM
                   WHERE position_cd = p_position_cd
            )
            LOOP
                v_exists := 'GIPI_ACCIDENT_ITEM';
                EXIT;
            END LOOP;
            
        END IF;
        
        IF v_exists = 'N' THEN
            FOR a IN (
                  SELECT 1
                    FROM GIPI_CASUALTY_ITEM
                   WHERE capacity_cd = p_position_cd
            )
            LOOP
                v_exists := 'GIPI_CASUALTY_ITEM';
                EXIT;
            END LOOP;
        END IF;
        
        IF v_exists = 'N' THEN
            FOR a IN (
                  SELECT 1
                    FROM GIPI_CASUALTY_PERSONNEL
                   WHERE capacity_cd = p_position_cd
            )
            LOOP
                v_exists := 'GIPI_CASUALTY_PERSONNEL';
                EXIT;
            END LOOP;
        END IF;
        
        IF v_exists = 'N' THEN
            FOR a IN (
                  SELECT 1
                    FROM GIPI_WCASUALTY_ITEM
                   WHERE capacity_cd = p_position_cd
            )
            LOOP
                v_exists := 'GIPI_WCASUALTY_ITEM';
                EXIT;
            END LOOP;
        END IF;
        
        IF v_exists = 'N' THEN
            FOR a IN (
                  SELECT 1
                    FROM GIPI_WCASUALTY_PERSONNEL
                   WHERE capacity_cd = p_position_cd
            )
            LOOP
                v_exists := 'GIPI_WCASUALTY_PERSONNEL';
                EXIT;
            END LOOP;
        END IF;
        
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (p_position giis_position.position%TYPE, p_position_cd giis_position.position_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      IF p_position_cd IS NULL THEN
         FOR i IN (
                    SELECT '1'
                      FROM GIIS_POSITION 
                     WHERE position = p_position
                  )
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;
      
      ELSE
          FOR i IN (
                    SELECT '1'
                      FROM GIIS_POSITION 
                     WHERE position = p_position
                       AND position_cd <> p_position_cd
                  )
          LOOP
             v_exists := 'Y';
             EXIT;
          END LOOP;
      
      END IF; 

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same position.'
                                 );
      END IF;
   END;
END;
/


