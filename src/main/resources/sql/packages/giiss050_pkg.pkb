CREATE OR REPLACE PACKAGE BODY CPI.giiss050_pkg
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.vessel_cd, a.vessel_name, a.reg_owner, a.plate_no, a.motor_no, a.serial_no, 
                       a.origin, a.destination, a.remarks, a.user_id, a.last_update
                  FROM giis_vessel a
                 WHERE a.vessel_flag = 'I'
                 ORDER BY a.vessel_name, a.vessel_cd, a.reg_owner
                )                   
      LOOP
         v_rec.vessel_cd    := i.vessel_cd;
         v_rec.vessel_name  := i.vessel_name;
         v_rec.reg_owner    := i.reg_owner;
         v_rec.plate_no     := i.plate_no;
         v_rec.motor_no     := i.motor_no;
         v_rec.serial_no    := i.serial_no;
         v_rec.origin       := i.origin;
         v_rec.destination  := i.destination;
         v_rec.remarks      := i.remarks;
         v_rec.user_id      := i.user_id;
         v_rec.last_update  := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_vessel%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_vessel
         USING DUAL
         ON (vessel_cd = p_rec.vessel_cd)
         WHEN NOT MATCHED THEN
            INSERT (vessel_cd, vessel_name, reg_owner, plate_no, motor_no, vessel_flag, 
                    serial_no, origin, destination, remarks, user_id, last_update)
            VALUES (p_rec.vessel_cd, p_rec.vessel_name, p_rec.reg_owner, p_rec.plate_no, p_rec.motor_no, 'I',
                    p_rec.serial_no, p_rec.origin, p_rec.destination, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET vessel_name = p_rec.vessel_name,
                   reg_owner   = p_rec.reg_owner, 
                   plate_no    = p_rec.plate_no, 
                   motor_no    = p_rec.motor_no, 
                   serial_no   = p_rec.serial_no, 
                   origin      = p_rec.origin, 
                   destination = p_rec.destination, 
                   remarks     = p_rec.remarks, 
                   user_id     = p_rec.user_id, 
                   last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_vessel
            WHERE vessel_cd = p_vessel_cd;
   END;

   PROCEDURE val_del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
       BEGIN  --1
         SELECT 1
           INTO v_exists
           FROM DUAL
          WHERE EXISTS (SELECT 1
                          FROM gipi_item_ves
                         WHERE vessel_cd = p_vessel_cd);
             raise_application_error (-20001,
                                      'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_ITEM_VES exists.'
                                     );
       EXCEPTION
           WHEN NO_DATA_FOUND THEN
           BEGIN --2
             SELECT 1
               INTO v_exists
               FROM DUAL
              WHERE EXISTS (SELECT 1
                              FROM gipi_witem_ves
                             WHERE vessel_cd = p_vessel_cd);
             raise_application_error (-20001,
                                      'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WITEM_VES exists.'
                                     );
            EXCEPTION
                WHEN NO_DATA_FOUND THEN 
                BEGIN --3
                  SELECT 1
                   INTO v_exists
                   FROM DUAL
                  WHERE EXISTS (SELECT 1
                                  FROM gipi_ves_accumulation
                                 WHERE vessel_cd = p_vessel_cd);
                  raise_application_error (-20001,
                                           'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_VES_ACCUMULATION exists.'
                                          );
                EXCEPTION
                     WHEN NO_DATA_FOUND THEN
                     BEGIN --4
                        SELECT 1
                          INTO v_exists
                          FROM DUAL
                         WHERE EXISTS(SELECT 1
                                        FROM gipi_wves_accumulation
                                       WHERE vessel_cd = p_vessel_cd);
                        raise_application_error (-20001,
                                                 'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WVES_ACCUMULATION exists.'
                                                 );
                     EXCEPTION
                         WHEN NO_DATA_FOUND THEN   
                         BEGIN --5
                             SELECT 1
                               INTO v_exists
                               FROM DUAL
                              WHERE EXISTS (SELECT 1
                                              FROM gipi_ves_air
                                             WHERE vessel_cd = p_vessel_cd);
                             raise_application_error (-20001,
                                                      'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_VES_AIR exists.'
                                                      );
                         EXCEPTION
                            WHEN NO_DATA_FOUND THEN  
                            BEGIN --6
                              SELECT 1
                                INTO v_exists
                                FROM DUAL
                               WHERE EXISTS (SELECT 1
                                               FROM gipi_wves_air
                                              WHERE vessel_cd = p_vessel_cd);

                                raise_application_error (-20001,
                                                         'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WVES_AIR exists.'
                                                         );
                            EXCEPTION
                               WHEN NO_DATA_FOUND THEN  
                            --       v_exists := 0;
                                BEGIN --7
                                  SELECT 1
                                    INTO v_exists
                                    FROM DUAL
                                   WHERE EXISTS (SELECT 1
                                                   FROM gipi_cargo_carrier
                                                  WHERE vessel_cd = p_vessel_cd);

                                    raise_application_error (-20001,
                                                             'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_CARGO_CARRIER exists.'
                                                             );
                                EXCEPTION
                                   WHEN NO_DATA_FOUND THEN  
                                    BEGIN --8
                                      SELECT 1
                                        INTO v_exists
                                        FROM DUAL
                                       WHERE EXISTS (SELECT 1
                                                       FROM gipi_wcargo_carrier
                                                      WHERE vessel_cd = p_vessel_cd);

                                        raise_application_error (-20001,
                                                                 'Geniisys Exception#E#Cannot delete record from GIIS_VESSEL while dependent record(s) in GIPI_WCARGO_CARRIER exists.'
                                                                 );
                                    EXCEPTION
                                       WHEN NO_DATA_FOUND THEN   
                                           v_exists := 0;
                                    END; --8   
                                END; --7  
                            END; --6       
                         END; --5
                     END; --4       
                END; --3
           END;--2
       END;--1   
   END;
   
   PROCEDURE val_add_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_vessel a
                 WHERE a.vessel_cd = p_vessel_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same vessel_cd.'
                                 );
      END IF;
   END;
END;
/


