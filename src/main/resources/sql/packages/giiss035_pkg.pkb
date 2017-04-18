CREATE OR REPLACE PACKAGE BODY CPI.giiss035_pkg
AS
    FUNCTION get_giis_required_docs_list (
        p_line_cd     giis_required_docs.line_cd%TYPE
    )
        RETURN giis_required_docs_tab PIPELINED
    AS
        v_required_doc  giis_required_docs_type;
    BEGIN
        FOR i IN (  SELECT *
                      FROM giis_required_docs
                     WHERE line_cd = p_line_cd  )
        LOOP
            v_required_doc.line_cd          := i.line_cd;
            v_required_doc.subline_cd       := i.subline_cd;
            v_required_doc.doc_cd           := i.doc_cd;
            v_required_doc.doc_name         := i.doc_name;
            v_required_doc.valid_flag       := i.valid_flag;
            v_required_doc.effectivity_date := i.effectivity_date;
            v_required_doc.remarks          := i.remarks;
            v_required_doc.user_id          := i.user_id;
            v_required_doc.last_update      := i.last_update;
            v_required_doc.cpi_rec_no       := i.cpi_rec_no;
            v_required_doc.cpi_branch_cd    := i.cpi_branch_cd;
            PIPE ROW (v_required_doc);
        END LOOP;
    END get_giis_required_docs_list;
    
    FUNCTION get_giis_line_list(
        p_module_id         GIIS_modules.module_id%TYPE,
        p_user_id           giis_users.user_id%TYPE
    ) RETURN line_listing_tab PIPELINED
    IS
        v_giis_line   line_listing_type;
    BEGIN
        FOR i IN (SELECT line_cd, line_name
                    FROM giis_line
                   WHERE pack_pol_flag = 'N'
                     AND check_user_per_line2(line_cd, null, p_module_id, p_user_id) = 1 --added by Kris 05.23.2013: to provide limited access based on user rights
                ORDER BY line_cd)
        LOOP
            v_giis_line.line_cd := i.line_cd;
            v_giis_line.line_name := i.line_name;
            PIPE ROW (v_giis_line);
        END LOOP;

        RETURN;
    END get_giis_line_list;
    
    PROCEDURE del_giis_required_doc(
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
    )
    IS
    BEGIN
        IF p_subline_cd IS NULL THEN
            DELETE FROM giis_required_docs
             WHERE line_cd = p_line_cd
               AND subline_cd IS NULL
               AND doc_cd = p_doc_cd;
        ELSE
            DELETE FROM giis_required_docs
             WHERE line_cd = p_line_cd
               AND subline_cd = p_subline_cd
               AND doc_cd = p_doc_cd;
        END IF;
    END del_giis_required_doc;
    
    PROCEDURE set_giis_required_doc(p_required_doc giis_required_docs%ROWTYPE)
    IS
    BEGIN
      MERGE INTO giis_required_docs
      USING DUAL ON (line_cd = p_required_doc.line_cd AND doc_cd = p_required_doc.doc_cd )
      WHEN NOT MATCHED THEN
        INSERT (line_cd, subline_cd, doc_cd, doc_name, valid_flag, effectivity_date, remarks, user_id, last_update)
        VALUES (p_required_doc.line_cd, p_required_doc.subline_cd, p_required_doc.doc_cd, p_required_doc.doc_name, 
                p_required_doc.valid_flag, p_required_doc.effectivity_date, p_required_doc.remarks,
                p_required_doc.user_id, SYSDATE)
      WHEN MATCHED THEN
        UPDATE SET subline_cd   = p_required_doc.subline_cd,
                   doc_name     = p_required_doc.doc_name, 
                   valid_flag   = p_required_doc.valid_flag, 
                   effectivity_date = p_required_doc.effectivity_date, 
                   remarks      = p_required_doc.remarks,
                   user_id      = p_required_doc.user_id, 
                   last_update  = SYSDATE;
    END set_giis_required_doc;
    
    /*
    ** Date Created : May 23, 2013
    ** Description : Validates that the deletion of the record is permitted 
    **               by checking for the existence of rows in related tables.
    **
    */
    PROCEDURE pre_delete_validation(
        p_check_both        IN VARCHAR2,
        p_doc_cd            IN GIIS_REQUIRED_DOCS.doc_cd%TYPE,
        p_line_cd           IN GIIS_REQUIRED_DOCS.line_Cd%TYPE
    ) IS
        v_dummy     VARCHAR2(1);
    BEGIN 
        IF (UPPER(P_CHECK_BOTH) = 'TRUE') THEN
            DECLARE
              CURSOR C IS
                SELECT '1'
                  FROM GIIS_REQUIRED_DOCS GRD
                      ,GIPI_REQDOCS GR
                 WHERE GR.DOC_CD = GRD.DOC_CD
                   AND GR.LINE_CD = GRD.LINE_CD
                   AND grd.doc_cd = p_doc_cd
                   AND grd.line_Cd = p_line_Cd; 
                   --AND GRD.ROWID = P_ROWID;
            BEGIN
                OPEN C;           
               FETCH C
                INTO v_dummy;
              
              IF C%FOUND THEN
                --message('Error: Cannot delete GIIS_REQUIRED_DOCS while dependent GIPI_REQDOCS exists');
                --RAISE FORM_TRIGGER_FAILURE;
                raise_application_error(-20001,'Geniisys Exception#E#Cannot delete GIIS_REQUIRED_DOCS while dependent GIPI_REQDOCS exists.');
              --ELSE
                --raise_application_error(-20001,'Geniisys Exception#I#Wala lang.');
              END IF;
              
              CLOSE C;
            END;
        END IF;    
    END pre_delete_validation;
    
    
    --added by john dolon 11.27.2013
    
    FUNCTION get_rec_list(
        p_line_cd       VARCHAR2,
        p_subline_cd    VARCHAR2
   )
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
                SELECT line_cd, subline_cd, doc_cd, doc_name, valid_flag, effectivity_date, remarks, user_id, last_update
                  FROM GIIS_REQUIRED_DOCS
                 WHERE line_cd = p_line_cd
                   AND subline_cd = p_subline_cd
                 ORDER BY doc_cd
                   )                   
      LOOP
         v_rec.line_cd            := i.line_cd;         
         v_rec.subline_cd         := i.subline_cd;      
         v_rec.doc_cd             := i.doc_cd;          
         v_rec.doc_name           := i.doc_name;        
         v_rec.valid_flag         := i.valid_flag;      
         v_rec.effectivity_date   := i.effectivity_date;
         v_rec.remarks            := i.remarks;
         v_rec.user_id            := i.user_id;
         v_rec.last_update        := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giis_required_docs%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIIS_REQUIRED_DOCS
         USING DUAL
            ON (doc_cd = p_rec.doc_cd
           AND  line_cd = p_rec.line_cd
           AND  subline_cd = p_rec.subline_cd)
         WHEN NOT MATCHED THEN
            INSERT (line_cd, subline_cd, doc_cd, doc_name, valid_flag, effectivity_date, remarks, user_id, last_update)
            VALUES (p_rec.line_cd, p_rec.subline_cd, p_rec.doc_cd, p_rec.doc_name, p_rec.valid_flag, p_rec.effectivity_date,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET doc_name = p_rec.doc_name, valid_flag = p_rec.valid_flag, effectivity_date = p_rec.effectivity_date,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
   )
   AS
   BEGIN
      DELETE FROM GIIS_REQUIRED_DOCS
            WHERE line_cd     = p_line_cd    
              AND subline_cd  = p_subline_cd 
              AND doc_cd      = p_doc_cd;     
   END;

   FUNCTION val_del_rec (
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
   )
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (20) := 'N';
   BEGIN
        FOR a IN (
              SELECT '1'
                FROM GIPI_WREQDOCS
               WHERE line_cd     = p_line_cd     
                 --AND subline_cd  = p_subline_cd  
                 AND doc_cd      = p_doc_cd     
              
        )
        LOOP
            v_exists := 'GIPI_WREQDOCS';
            EXIT;
        END LOOP;
        
        FOR a IN (
              SELECT '1'
                FROM GIPI_REQDOCS
               WHERE line_cd     = p_line_cd     
                 --AND subline_cd  = p_subline_cd  
                 AND doc_cd      = p_doc_cd     
              
        )
        LOOP
            v_exists := 'GIPI_REQDOCS';
            EXIT;
        END LOOP;
        
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (
        p_line_cd     giis_required_docs.line_cd%TYPE,
        p_subline_cd  giis_required_docs.subline_cd%TYPE,
        p_doc_cd      giis_required_docs.doc_cd%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (
              SELECT '1'
                FROM GIIS_REQUIRED_DOCS
               WHERE line_cd     = p_line_cd     
                 --AND subline_cd  = p_subline_cd  
                 AND doc_cd      = p_doc_cd
      )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same doc_cd.'
                                 );
      END IF;
   END;
   
   FUNCTION get_giiss035_line_lov(
        p_user      VARCHAR2
   )
   RETURN giiss035_line_lov_tab PIPELINED
   IS 
      v_rec   giiss035_line_lov_type;
   BEGIN
      FOR i IN (
                SELECT line_cd, line_name
                  FROM giis_line
                 WHERE pack_pol_flag = 'N'
                   AND check_user_per_line2 (line_cd, NULL, 'GIISS035', p_user) = 1
                 ORDER BY line_cd
                   )                   
      LOOP
         v_rec.line_cd           := i.line_cd;         
         v_rec.line_name         := i.line_name;      
        
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giiss035_subline_lov(
        p_line_cd    VARCHAR2,
        p_search     VARCHAR2
   )
   RETURN giiss035_subline_lov_tab PIPELINED
   IS 
      v_rec   giiss035_subline_lov_type;
   BEGIN
      FOR i IN (
                SELECT subline_cd, subline_name
                  FROM giis_subline
                 WHERE line_cd = p_line_cd
                   AND subline_cd LIKE upper(p_search)
                 ORDER BY subline_cd
      )                   
      LOOP
         v_rec.subline_cd          := i.subline_cd;         
         v_rec.subline_name        := i.subline_name;      
        
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   PROCEDURE validate_line(
        p_line_cd   IN OUT VARCHAR2,
        p_line_name    OUT VARCHAR2,
        p_user             VARCHAR2
   )
   IS
   BEGIN
       SELECT line_cd, line_name
         INTO p_line_cd, p_line_name
         FROM giis_line
        WHERE pack_pol_flag = 'N'
          AND check_user_per_line2 (line_cd, NULL, 'GIISS035', p_user) = 1
          AND line_cd LIKE p_line_cd;
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_line_cd   := 'manyrows';
           p_line_name := 'manyrows';
       WHEN OTHERS THEN
           p_line_cd   := NULL;
           p_line_name := NULL;
   END;
   
   PROCEDURE validate_subline(
        p_line_cd       IN     VARCHAR2,
        p_subline_cd    IN OUT VARCHAR2,
        p_subline_name     OUT VARCHAR2
   )
   IS
   BEGIN
       SELECT subline_cd, subline_name
         INTO p_subline_cd, p_subline_name
         FROM giis_subline
        WHERE line_cd = p_line_cd
          AND subline_cd LIKE p_subline_cd;
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_subline_cd   := 'manyrows';
           p_subline_name := 'manyrows';
       WHEN OTHERS THEN
           p_subline_cd   := NULL;
           p_subline_name := NULL;
   END;
END;
/


