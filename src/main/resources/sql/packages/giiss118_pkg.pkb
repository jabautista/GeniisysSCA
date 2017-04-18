CREATE OR REPLACE PACKAGE BODY CPI.giiss118_pkg
AS
   FUNCTION get_rec_list (
      p_group_cd     giis_group.group_cd%TYPE,
      p_group_desc   giis_group.group_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.group_cd, a.group_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_group a
                 WHERE a.group_cd = NVL(p_group_cd, a.group_cd)
                   AND UPPER (a.group_desc) LIKE UPPER (NVL (p_group_desc, '%'))
                 ORDER BY a.group_cd
                   )                   
      LOOP
         v_rec.group_cd := i.group_cd;
         v_rec.group_desc := i.group_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_group%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_group
         USING DUAL
         ON (group_cd = p_rec.group_cd)
         WHEN NOT MATCHED THEN
            INSERT (group_cd, group_desc, remarks, user_id, last_update)
            VALUES (p_rec.group_cd, p_rec.group_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET group_desc = p_rec.group_desc, 
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_group_cd VARCHAR2)
   AS
   BEGIN
      DELETE FROM giis_group
            WHERE group_cd = p_group_cd;
   END;

   PROCEDURE val_del_rec (p_group_cd giis_group.group_cd%TYPE)
   AS
      v_exist   VARCHAR2 (1);
   BEGIN
      
      BEGIN
	   SELECT 'A'
	     INTO v_exist
		  FROM giis_assured_group
		 WHERE group_cd = p_group_cd;
      EXCEPTION
  	      WHEN no_data_found THEN
  	         v_exist := 'B';
  	      WHEN too_many_rows THEN
  	         v_exist := 'C';
      END;
      
      IF v_exist in ('A', 'C') THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from giis_group while dependent record(s) in giis_assured_group exists.');
	   END IF;
      
      BEGIN
         SELECT 'A'
           INTO v_exist
           FROM gipi_witem
          WHERE group_cd = p_group_cd;
      EXCEPTION
         WHEN no_data_found THEN
            v_exist := 'B';
         WHEN too_many_rows THEN
            v_exist := 'C';
         END;
         
      IF v_exist in ('A', 'C') THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from giis_group while dependent record(s) in gipi_witem exists.');
      END IF;
      
      BEGIN
         SELECT 'A'
           INTO v_exist
           FROM gipi_item
          WHERE group_cd = p_group_cd;
      EXCEPTION
         WHEN no_data_found THEN
            v_exist := 'B';
         WHEN too_many_rows THEN
            v_exist := 'C';
      END;
      
      IF v_exist in ('A', 'C') THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from giis_group while dependent record(s) in gipi_item exists.');
      END IF;
      
      BEGIN
         SELECT 'A'
           INTO v_exist
           FROM gipi_wgrouped_items
          WHERE group_cd = p_group_cd;
      EXCEPTION
         WHEN no_data_found THEN
            v_exist := 'B';
         WHEN too_many_rows THEN
            v_exist := 'C';
      END;
      
      IF v_exist in ('A', 'C') THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from giis_group while dependent record(s) in gipi_wgrouped_items exists.');
      END IF;
      
      BEGIN
         SELECT 'A'
         INTO v_exist
         FROM gipi_grouped_items					 
         WHERE group_cd = p_group_cd;
      EXCEPTION
         WHEN no_data_found THEN
         v_exist := 'B';
         WHEN too_many_rows THEN
         v_exist := 'C';
      END;
      
      IF v_exist in ('A', 'C') THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Cannot delete record from giis_group while dependent record(s) in gipi_grouped_items exists.');
      END IF;
   
   END;

   PROCEDURE val_add_rec (p_group_cd giis_group.group_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_group a
                 WHERE a.group_cd = p_group_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same group_cd.'
                                 );
      END IF;
   END;
END;
/


