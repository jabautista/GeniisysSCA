CREATE OR REPLACE PACKAGE BODY CPI.GIISS169_PKG
AS
   FUNCTION get_inspector_list
   RETURN inspector_tab PIPELINED AS
      v_list            inspector_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_inspector
                 ORDER BY insp_cd)
      LOOP
         v_list.insp_cd := i.insp_cd;
         v_list.insp_name := i.insp_name;
         v_list.remarks := i.remarks;
         v_list.user_id := i.user_id;
         v_list.last_update := TO_CHAR(i.last_update,'MM-DD-YYYY HH:MI:SS AM');
         
         PIPE ROW(v_list);
      END LOOP;
   END;
   
   PROCEDURE set_rec (p_rec giis_inspector%ROWTYPE)
   IS
      v_insp_cd            giis_inspector.insp_cd%TYPE;
   BEGIN
      IF p_rec.insp_cd IS NULL THEN
         SELECT giis_insp_cd_seq.NEXTVAL
           INTO v_insp_cd
           FROM dual;
      ELSE
         v_insp_cd := p_rec.insp_cd; 
      END IF;
   
      MERGE INTO giis_inspector
         USING DUAL
         ON (insp_cd = p_rec.insp_cd)
         WHEN NOT MATCHED THEN
            INSERT (insp_cd, insp_name, remarks, user_id, last_update)
            VALUES (v_insp_cd, p_rec.insp_name, p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET insp_name = p_rec.insp_name, remarks = p_rec.remarks, 
                   user_id = p_rec.user_id, last_update = SYSDATE;
   END;

   PROCEDURE del_rec (p_insp_cd giis_inspector.insp_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_inspector
            WHERE insp_cd = p_insp_cd;
   END;

   PROCEDURE val_del_rec (p_insp_cd giis_inspector.insp_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR a IN (SELECT a.insp_cd
	               FROM giis_inspector a, gipi_insp_data b
	              WHERE a.insp_cd = b.insp_cd)
	   LOOP
         IF p_insp_cd = a.insp_cd THEN
            raise_application_error(-20001, 'Geniisys Exception#E#Cannot delete record from GIIS_INSPECTOR while dependent record(s) in GIPI_INSP_DATA exists.');
         END IF;
	   END LOOP;
   END;

   PROCEDURE val_add_rec (
      p_insp_name    giis_inspector.insp_name%TYPE
   ) AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_inspector a
                 WHERE a.insp_name = p_insp_name)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same insp_name.'
                                 );
      END IF;
   END;
END;
/


