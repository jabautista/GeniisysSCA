CREATE OR REPLACE PACKAGE BODY CPI.giiss073_pkg
AS
   FUNCTION get_rec_list (
      p_status_cd     giis_ri_status.status_cd%TYPE,
      p_status_desc   giis_ri_status.status_desc%TYPE
   )  RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (SELECT a.status_cd, a.status_desc, a.remarks, a.user_id,
                       a.last_update
                  FROM giis_ri_status a
                 WHERE a.status_cd = NVL (p_status_cd, a.status_cd)
                   AND UPPER (a.status_desc) LIKE UPPER (NVL (p_status_desc, '%'))
                 ORDER BY a.status_cd
                   )                   
      LOOP
         v_rec.status_cd := i.status_cd;
         v_rec.status_desc := i.status_desc;
         v_rec.remarks := i.remarks;
         v_rec.user_id := i.user_id;
         v_rec.last_update := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_ri_status%ROWTYPE)
   IS
   BEGIN
      MERGE INTO giis_ri_status
         USING DUAL
         ON (status_cd = p_rec.status_cd)
         WHEN NOT MATCHED THEN
            INSERT (status_cd, status_desc, remarks, user_id, last_update)
            VALUES (p_rec.status_cd, p_rec.status_desc, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET status_desc = p_rec.status_desc,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_status_cd giis_ri_status.status_cd%TYPE)
   AS
   BEGIN
      DELETE FROM giis_ri_status
            WHERE status_cd = p_status_cd;
   END;

   PROCEDURE val_del_rec (p_status_cd giis_ri_status.status_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      
      FOR i IN (SELECT '1'
                  FROM giis_reinsurer
                 WHERE ri_status_cd = p_status_cd)
      LOOP
        v_exists := 'Y';
        EXIT;
      END LOOP;
      
      IF v_exists = 'Y' THEN
        raise_application_error (-20001,
                                  'Geniisys Exception#E#Cannot delete record from GIIS_RI_STATUS while dependent record(s) in GIIS_REINSURER exists.'
                                 );
      END IF;
      
   END;

   PROCEDURE val_add_rec (
    p_status_cd giis_ri_status.status_cd%TYPE,
    p_status_desc   giis_ri_status.status_desc%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giis_ri_status a
                 WHERE a.status_cd = p_status_cd)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Row already exists with same status_cd.'
                                 );
      END IF;
      
      FOR i IN (SELECT '1'
                  FROM giis_ri_status a
                 WHERE UPPER(a.status_desc) = UPPER(p_status_desc))
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Row already exists with same status_desc.'
                                 );
      END IF;
   END;
END;
/


