CREATE OR REPLACE PACKAGE BODY CPI.giacs600_pkg
AS
   /*
   **  Created by   :  Kenneth Mark Labrador
   **  Date Created : 08.16.2013
   **  Description  : For GIACS600 - File Source Maintenance
   */
   FUNCTION get_file_source_records
      RETURN giexs600_file_source_tab PIPELINED
   IS
      v_rec   giexs600_file_source_type;
   BEGIN
      FOR i IN (SELECT source_cd, source_name, or_tag, atm_tag, address_1,
                       address_2, address_3, tin, user_id,
                       TO_CHAR (last_update,
                                'MM-DD-YYYY HH:MI:SS AM'
                               ) last_update,
                       remarks, utility_tag,
                       DECODE (NVL (or_tag, 'I'),
                               'I', 'Individual',
                               'Group'
                              ) or_tag_desc
                  FROM giac_file_source)
      LOOP
         v_rec.source_cd := i.source_cd;
         v_rec.source_name := i.source_name;
         v_rec.or_tag := i.or_tag;
         v_rec.or_tag_desc := i.or_tag_desc;
         v_rec.atm_tag := i.atm_tag;
         v_rec.address_1 := i.address_1;
         v_rec.address_2 := i.address_2;
         v_rec.address_3 := i.address_3;
         v_rec.tin := i.tin;
         v_rec.user_id := i.user_id;
         v_rec.last_update := i.last_update;
         v_rec.remarks := i.remarks;
         v_rec.utility_tag := i.utility_tag;
         PIPE ROW (v_rec);
      END LOOP;
   END get_file_source_records;

   PROCEDURE delete_file_source (p_source_cd giac_file_source.source_cd%TYPE)
   IS
   BEGIN
      DELETE FROM giac_file_source
            WHERE source_cd = p_source_cd;
   END delete_file_source;

   PROCEDURE set_file_source (
      p_original_source   VARCHAR2,
      p_add_update        VARCHAR2,
      p_source_cd         VARCHAR2,
      p_source_name       VARCHAR2,
      p_or_tag            VARCHAR2,
      p_atm_tag           VARCHAR2,
      p_address_1         VARCHAR2,
      p_address_2         VARCHAR2,
      p_address_3         VARCHAR2,
      p_tin               VARCHAR2,
      p_remarks           VARCHAR2,
      p_utility_tag       VARCHAR2,
      p_user_id           VARCHAR2
   )
   IS
   BEGIN
      IF UPPER(p_add_update) = UPPER ('ADD')
      THEN
         INSERT INTO giac_file_source
                     (source_cd, source_name, or_tag, atm_tag,
                      address_1, address_2, address_3, tin,
                      remarks, utility_tag, user_id, last_update
                     )
              VALUES (p_source_cd, p_source_name, p_or_tag, p_atm_tag,
                      p_address_1, p_address_2, p_address_3, p_tin,
                      p_remarks, p_utility_tag, p_user_id, SYSDATE
                     );
      ELSIF UPPER(p_add_update) = UPPER ('UPDATE')
      THEN
         UPDATE giac_file_source
            SET source_cd = p_source_cd,
                source_name = p_source_name,
                or_tag = p_or_tag,
                atm_tag = p_atm_tag,
                address_1 = p_address_1,
                address_2 = p_address_2,
                address_3 = p_address_3,
                tin = p_tin,
                remarks = p_remarks,
                utility_tag = p_utility_tag,
                user_id = p_user_id,
                last_update = SYSDATE
          WHERE source_cd = p_original_source;
      END IF;
   END set_file_source;
END giacs600_pkg;
/


