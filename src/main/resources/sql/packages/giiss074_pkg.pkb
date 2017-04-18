CREATE OR REPLACE PACKAGE BODY CPI.giiss074_pkg
AS
   FUNCTION get_rec_list(p_ri_type VARCHAR2) 
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
                    SELECT ri_type, doc_cd, doc_name, remarks, user_id, last_update
                      FROM giis_ri_type_docs
                     WHERE ri_type = p_ri_type
                     ORDER BY doc_cd
               )                   
      LOOP
         v_rec.ri_type      := i.ri_type; 
         v_rec.doc_cd       := i.doc_cd;  
         v_rec.doc_name     := i.doc_name;
         v_rec.remarks      := i.remarks;
         v_rec.user_id      := i.user_id;
         v_rec.last_update  := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_ri_type_docs%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_RI_TYPE_DOCS
         USING DUAL
         ON (ri_type = p_rec.ri_type
         AND doc_cd  = p_rec.doc_cd )
         WHEN NOT MATCHED THEN
            INSERT (ri_type, doc_cd, doc_name, remarks, user_id, last_update)
            VALUES (p_rec.ri_type, p_rec.doc_cd, p_rec.doc_name, p_rec.remarks,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET doc_name = p_rec.doc_name,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_ri_type giis_ri_type_docs.ri_type%TYPE, p_doc_cd giis_ri_type_docs.doc_cd%TYPE)
   AS
   BEGIN
      DELETE FROM GIIS_RI_TYPE_DOCS
            WHERE ri_type = p_ri_type
              AND doc_cd  = p_doc_cd;
   END;

   FUNCTION val_del_rec (p_ri_type giis_ri_type_docs.ri_type%TYPE, p_doc_cd giis_ri_type_docs.doc_cd%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (1) := 'N';
   BEGIN
          FOR a IN (
              SELECT 1
                FROM GIIS_RI_TYPE_DOCS
               WHERE ri_type = p_ri_type
                 AND doc_cd  = p_doc_cd
                )
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (p_ri_type giis_ri_type_docs.ri_type%TYPE, p_doc_cd giis_ri_type_docs.doc_cd%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (
                 SELECT '1'
                   FROM GIIS_RI_TYPE_DOCS 
                  WHERE ri_type = p_ri_type
                    AND doc_cd  = p_doc_cd
               )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same ri_type and doc_cd.'
                                 );
      END IF;
   END;
   
   FUNCTION get_giiss074_lov(p_search VARCHAR2) 
      RETURN giiss074_lov_tab PIPELINED
   IS 
      v_list   giiss074_lov_type;
   BEGIN
      FOR i IN (
                    SELECT ri_type, ri_type_desc
                      FROM GIIS_REINSURER_TYPE
                     WHERE UPPER(ri_type) LIKE NVL(UPPER(p_search),'%')
                     ORDER BY ri_type
               )                   
      LOOP
         v_list.ri_type      := i.ri_type; 
         v_list.ri_type_desc := i.ri_type_desc;  
       
         PIPE ROW (v_list);
      END LOOP;

      RETURN;
   END;
   
    PROCEDURE validate_ri_type(
        p_ri_type   IN OUT VARCHAR2,
        p_ri_type_desc OUT VARCHAR2
    )
    IS
    BEGIN
        SELECT ri_type, ri_type_desc
          INTO p_ri_type, p_ri_type_desc
          FROM GIIS_REINSURER_TYPE
         WHERE UPPER(ri_type) LIKE UPPER(p_ri_type);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_ri_type := '---';
            p_ri_type := '---';
        WHEN OTHERS THEN
            p_ri_type      := NULL;
            p_ri_type_desc := NULL;
    END;
END;
/


