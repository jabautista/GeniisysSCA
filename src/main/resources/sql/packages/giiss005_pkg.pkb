CREATE OR REPLACE PACKAGE BODY CPI.GIISS005_PKG
AS

   FUNCTION get_rec_list(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE,
      p_tarf_desc             giis_tariff.tarf_desc%TYPE,
      p_tarf_rate             giis_tariff.tarf_rate%TYPE,
      p_tarf_remarks          giis_tariff.tarf_remarks%TYPE
   )
     RETURN tariff_tab PIPELINED
   IS
      v_row                   tariff_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_tariff
                WHERE UPPER(tarf_cd) LIKE UPPER(NVL(p_tarf_cd, '%'))
                  AND UPPER(NVL(tarf_desc, '%')) LIKE UPPER(NVL(p_tarf_desc, NVL(tarf_desc, '%')))
                  AND NVL(tarf_rate, -1) = NVL(p_tarf_rate, NVL(tarf_rate, -1))
                  AND UPPER(NVL(tarf_remarks, '%')) LIKE UPPER(NVL(p_tarf_remarks, NVL(tarf_remarks, '%')))
                ORDER BY tarf_cd, tarf_desc)
      LOOP
         v_row.tarf_cd := i.tarf_cd;
         v_row.tarf_desc := i.tarf_desc;
         v_row.tarf_rate := i.tarf_rate;
         v_row.tarf_remarks := i.tarf_remarks;
         v_row.occupancy_cd := i.occupancy_cd;
         v_row.tariff_zone := i.tariff_zone;
         v_row.remarks := i.remarks;
         v_row.user_id := i.user_id;
         v_row.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
         v_row.occupancy_desc := NULL;
         FOR a IN(SELECT occupancy_desc
                    FROM giis_fire_occupancy b
                   WHERE b.occupancy_cd = i.occupancy_cd)
         LOOP
            v_row.occupancy_desc := a.occupancy_desc;
            EXIT;
         END LOOP;
         
         v_row.tariff_zone_desc := NULL;
         FOR c IN(SELECT tariff_zone_desc
                    FROM giis_tariff_zone d
                   WHERE d.tariff_zone = i.tariff_zone)
         LOOP
            v_row.tariff_zone_desc := c.tariff_zone_desc;
            EXIT;
         END LOOP;
         
         PIPE ROW(v_row);
      END LOOP;
   END;

   FUNCTION get_occupancy_lov(
      p_find_text             VARCHAR2
   )
     RETURN occupancy_tab PIPELINED
   IS
      v_row                   occupancy_type;
   BEGIN
      FOR i IN(SELECT *
                 FROM giis_fire_occupancy
                WHERE (occupancy_cd LIKE NVL(p_find_text, occupancy_cd)
                   OR UPPER(occupancy_desc) LIKE UPPER(NVL(p_find_text, occupancy_desc)))
                ORDER BY occupancy_cd)
      LOOP
         v_row.occupancy_cd := i.occupancy_cd;
         v_row.occupancy_desc := i.occupancy_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   FUNCTION get_tariff_lov(
      p_find_text             VARCHAR2
   )
     RETURN tariff_zone_tab PIPELINED
   IS
      v_row                   tariff_zone_type;
   BEGIN
      FOR i IN(SELECT tariff_zone, tariff_zone_desc
                 FROM giis_tariff_zone
                WHERE (UPPER(tariff_zone) LIKE UPPER(NVL(p_find_text, tariff_zone))
                   OR UPPER(tariff_zone_desc) LIKE UPPER(NVL(p_find_text, tariff_zone_desc)))
                ORDER BY tariff_zone)
      LOOP
         v_row.tariff_zone := i.tariff_zone;
         v_row.tariff_zone_desc := i.tariff_zone_desc;
         PIPE ROW(v_row);
      END LOOP;
   END;
   
   PROCEDURE val_add_rec(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE
   )
   AS
      v_exists                VARCHAR2(1);
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_tariff a
                WHERE UPPER(a.tarf_cd) = UPPER(p_tarf_cd))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;
   
      IF v_exists = 'Y' THEN
         raise_application_error(-20001, 'Geniisys Exception#E#Record already exists with the same tariff_cd.');
      END IF;
   END;

   PROCEDURE set_rec(
      p_rec                   giis_tariff%ROWTYPE
   )
   IS
   BEGIN
      MERGE INTO giis_tariff
      USING DUAL
         ON (tarf_cd = p_rec.tarf_cd)
       WHEN NOT MATCHED THEN
            INSERT (tarf_cd, tarf_desc, tarf_rate, tarf_remarks, user_id, last_update, remarks, occupancy_cd, tariff_zone)
            VALUES (p_rec.tarf_cd, p_rec.tarf_desc, p_rec.tarf_rate, p_rec.tarf_remarks, p_rec.user_id, SYSDATE,
                    p_rec.remarks, p_rec.occupancy_cd, p_rec.tariff_zone)
       WHEN MATCHED THEN
            UPDATE SET tarf_desc = p_rec.tarf_desc,
                       tarf_rate = p_rec.tarf_rate,
                       tarf_remarks = p_rec.tarf_remarks,
                       user_id = p_rec.user_id,
                       last_update = SYSDATE,
                       remarks = p_rec.remarks,
                       occupancy_cd = p_rec.occupancy_cd,
                       tariff_zone = p_rec.tariff_zone;
   END;
   
   PROCEDURE val_del_rec(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE
   )
   IS
      v_exists                VARCHAR2(1) := 'N';
   BEGIN
      FOR i IN(SELECT 1
                 FROM giis_tariff
                WHERE UPPER(tarf_cd) = UPPER(p_tarf_cd))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'N' THEN
         RETURN;
      END IF;
   
      FOR i IN(SELECT 1
                 FROM gipi_fireitem
                WHERE tarf_cd = p_tarf_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF while dependent record(s) in GIPI_FIREITEM exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM gipi_wfireitm
                WHERE tarf_cd = p_tarf_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF while dependent record(s) in GIPI_WFIREITM exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM gipi_itmperil
                WHERE tarf_cd = p_tarf_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF while dependent record(s) in GIPI_ITMPERIL exists.');
      END LOOP;
      
      FOR i IN(SELECT 1
                 FROM gipi_witmperl
                WHERE tarf_cd = p_tarf_cd)
      LOOP
         raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_TARIFF while dependent record(s) in GIPI_WITMPERL exists.');
      END LOOP;
   END;
   
   PROCEDURE del_rec(
      p_tarf_cd               giis_tariff.tarf_cd%TYPE
   )
   IS
   BEGIN
      DELETE
        FROM giis_tariff
       WHERE tarf_cd = p_tarf_cd;
   END;

END;
/


