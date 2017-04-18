CREATE OR REPLACE PACKAGE BODY CPI.giiss212_pkg
AS
   FUNCTION get_rec_list (
      p_spoil_cd     giis_spoilage_reason.spoil_cd%TYPE,
      p_spoil_desc   giis_spoilage_reason.spoil_desc%TYPE
   )
      RETURN rec_tab PIPELINED
   IS
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT *
                  FROM giis_spoilage_reason
                 WHERE UPPER (spoil_cd) LIKE UPPER (NVL (p_spoil_cd, '%'))
                   AND UPPER (spoil_desc) LIKE UPPER (NVL (p_spoil_desc, '%')))
      LOOP
         v_rec.spoil_cd := i.spoil_cd;
         v_rec.spoil_desc := i.spoil_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update :=
                            TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.exist := 'N';
		 
		 v_rec.active_tag := i.active_tag; --carlo 01-27-2017
		 
         FOR j IN (SELECT y.spoil_cd
                     FROM giis_spoilage_reason x, gipi_polbasic y
                    WHERE x.spoil_cd = i.spoil_cd
                      AND x.spoil_cd = y.spoil_cd
                      AND ROWNUM = 1)
         LOOP
            v_rec.exist := 'Y';
            EXIT;
         END LOOP;

         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_spoilage_reason%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_spoilage_reason
         USING DUAL
         ON (spoil_cd = p_rec.spoil_cd)
         WHEN NOT MATCHED THEN
            INSERT (spoil_cd, spoil_desc, remarks, user_id, last_update, active_tag) --carlo 01-07-2017
            VALUES (p_rec.spoil_cd, p_rec.spoil_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE, p_rec.active_tag)
         WHEN MATCHED THEN
            UPDATE
               SET spoil_desc = p_rec.spoil_desc, remarks = p_rec.remarks,
                   user_id = p_rec.user_id, last_update = SYSDATE,
                   active_tag = p_rec.active_tag --carlo 01-07-2017
            ;
   END;

   PROCEDURE del_rec (p_spoil_cd giis_spoilage_reason.spoil_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_spoilage_reason
            WHERE spoil_cd = p_spoil_cd;
   END;

   PROCEDURE val_del_rec (p_spoil_cd giis_spoilage_reason.spoil_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR rec IN (SELECT '1'
                    FROM gipi_polbasic
                   WHERE spoil_cd = p_spoil_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Cannot delete record from GIIS_SPOILAGE_REASON while dependent record(s) in GIPI_POLBASIC exists.'
            );
      END IF;
   END;

   PROCEDURE val_add_rec (p_spoil_cd giis_spoilage_reason.spoil_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_spoilage_reason a
                 WHERE a.spoil_cd = p_spoil_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error
            (-20001,
             'Geniisys Exception#E#Record already exists with the same spoil_cd.'
            );
      END IF;
   END;
END;
/


