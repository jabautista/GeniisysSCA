CREATE OR REPLACE PACKAGE BODY CPI.giiss053_pkg
AS
   FUNCTION get_rec_list (
      p_flood_zone          giis_flood_zone.flood_zone%TYPE,
      p_flood_zone_desc     giis_flood_zone.flood_zone_desc%TYPE,
      p_zone_grp            giis_flood_zone.zone_grp%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.flood_zone, a.flood_zone_desc, a.zone_grp, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_flood_zone a
                 WHERE UPPER (a.flood_zone) LIKE UPPER (NVL (p_flood_zone, '%'))
                   AND UPPER (a.flood_zone_desc) LIKE UPPER (NVL (p_flood_zone_desc, '%'))
                   AND UPPER (NVL(a.zone_grp, '%')) LIKE UPPER (NVL (p_zone_grp, '%'))
                 ORDER BY a.flood_zone
                   )                   
      LOOP
         v_rec.flood_zone := i.flood_zone;
         v_rec.flood_zone_desc := i.flood_zone_desc;
         v_rec.zone_grp := i.zone_grp;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_flood_zone%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_flood_zone
         USING DUAL
         ON (flood_zone = p_rec.flood_zone)
         WHEN NOT MATCHED THEN
            INSERT (flood_zone, flood_zone_desc, zone_grp, remarks, user_id, last_update)
            VALUES (p_rec.flood_zone, p_rec.flood_zone_desc, p_rec.zone_grp, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET flood_zone_desc = p_rec.flood_zone_desc, zone_grp = p_rec.zone_grp,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_flood_zone giis_flood_zone.flood_zone%TYPE)
   AS
   BEGIN
      DELETE FROM giis_flood_zone
            WHERE flood_zone = p_flood_zone;
   END;

   PROCEDURE val_del_rec (p_flood_zone    giis_flood_zone.flood_zone%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      
      /* Deletion of GIIS_FLOOD_ZONE prevented if GIPI_WFIREITM records  */
      /* Foreign key(s): FLOOD_ZONE_WFIREITM_FK                          */
      FOR i IN (SELECT '1'
                  FROM GIPI_WFIREITM a
                 WHERE a.flood_zone = p_flood_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_FLOOD_ZONE while dependent record(s) in GIPI_WFIREITM exists.'
                                 );
      END IF;      
      
      /* Deletion of GIIS_FLOOD_ZONE prevented if GIPI_FIREITEM records  */
      /* Foreign key(s): FLOOD_ZONE_FIREITEM_FK                          */
      FOR i IN (SELECT '1'
                  FROM GIPI_FIREITEM a
                 WHERE a.flood_zone = p_flood_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_FLOOD_ZONE while dependent record(s) in GIPI_FIREITEM exists.'
                                 );
      END IF;
      
   END;

   PROCEDURE val_add_rec (
        p_flood_zone        giis_flood_zone.flood_zone%TYPE,
        p_flood_zone_desc   giis_flood_zone.flood_zone_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_flood_zone a
                 WHERE a.flood_zone = p_flood_zone)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record exists already with same flood_zone.');
      END IF;
      
      FOR i IN (SELECT '1'
                  FROM giis_flood_zone a
                 WHERE a.flood_zone_desc = p_flood_zone_desc)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y' THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record exists already with same flood_zone_desc.');
      END IF;
      
   END;
   
END;
/


