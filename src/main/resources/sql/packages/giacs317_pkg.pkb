CREATE OR REPLACE PACKAGE BODY CPI.GIACS317_PKG
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
                SELECT module_id, module_name, scrn_rep_name, scrn_rep_tag, generation_type,
                       mod_entries_tag, functions_tag, remarks, user_id, last_update
                  FROM giac_modules
                 ORDER BY module_name
      )                   
      LOOP
         v_rec.module_id        := i.module_id;      
         v_rec.module_name      := i.module_name;    
         v_rec.scrn_rep_name    := i.scrn_rep_name;  
         v_rec.scrn_rep_tag     := i.scrn_rep_tag;   
         v_rec.generation_type  := i.generation_type;
         v_rec.mod_entries_tag  := i.mod_entries_tag;
         v_rec.functions_tag    := i.functions_tag;  
         v_rec.remarks          := i.remarks;
         v_rec.user_id          := i.user_id;
         v_rec.last_update      := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         
           SELECT UPPER(RV_MEANING)
             INTO v_rec.scrn_rep_tag_name
             FROM CG_REF_CODES
            WHERE RV_DOMAIN = 'GIAC_MODULES.SCRN_REP_TAG'
              AND RV_LOW_VALUE = i.scrn_rep_tag;
            
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_modules%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIAC_MODULES
         USING DUAL
         ON (module_id = p_rec.module_id)
         WHEN NOT MATCHED THEN
            INSERT (module_id, module_name, scrn_rep_name, scrn_rep_tag, generation_type, mod_entries_tag, functions_tag, 
                    remarks, user_id, last_update)
            VALUES (MODULE_ID_SEQ.NEXTVAL, p_rec.module_name, p_rec.scrn_rep_name, p_rec.scrn_rep_tag, p_rec.generation_type, p_rec.mod_entries_tag, p_rec.functions_tag, 
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET scrn_rep_name = p_rec.scrn_rep_name, scrn_rep_tag = p_rec.scrn_rep_tag, generation_type = p_rec.generation_type, mod_entries_tag = p_rec.mod_entries_tag,
                   functions_tag = p_rec.functions_tag, remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (p_module_id giac_modules.module_id%TYPE)
   AS
   BEGIN
      DELETE FROM GIAC_MODULES
            WHERE module_id = p_module_id;
   END;

   FUNCTION val_del_rec (p_module_id giac_modules.module_id%TYPE)
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (2) := 'N';
   BEGIN
        FOR a IN (
              SELECT 1
                FROM GIAC_FUNCTIONS
               WHERE module_id = p_module_id
        )
        LOOP
            v_exists := 'Y1';
            EXIT;
        END LOOP;
        
        FOR a IN (
              SELECT 1
                FROM GIAC_JE_PARAMETERS
               WHERE gmod_module_id = p_module_id
        )
        LOOP
            v_exists := 'Y2';
            EXIT;
        END LOOP;
        
        FOR a IN (
              SELECT 1
                FROM GIAC_MODULE_ENTRIES
               WHERE module_id = p_module_id
        )
        LOOP
            v_exists := 'Y3';
            EXIT;
        END LOOP;
        
        
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (p_module_name giac_modules.module_name%TYPE, p_generation_type giac_modules.generation_type%TYPE)
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIAC_MODULES 
                 WHERE module_name = p_module_name
                    OR generation_type = p_generation_type)
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same module_name.'
                                 );
      END IF;
   END;
   
   FUNCTION get_scrn_rep_tag_lov
     RETURN scrn_rep_tag_lov_tab PIPELINED
   IS
        v_list scrn_rep_tag_lov_type;
   BEGIN
        FOR i IN(
                 SELECT rv_low_value, rv_meaning
                    FROM cg_ref_codes
                   WHERE rv_domain = 'GIAC_MODULES.SCRN_REP_TAG'
                ORDER BY rv_low_value
        )
        LOOP
            v_list.rv_low_value := i.rv_low_value;
            v_list.rv_meaning   := UPPER(i.rv_meaning);
            
            PIPE ROW(v_list);
        END LOOP;
        
        RETURN;
   END;
   
   PROCEDURE val_scrn_rep_tag (
       p_scrn_rep_tag_name   IN OUT CG_REF_CODES.rv_meaning%TYPE,
       p_scrn_rep_tag           OUT CG_REF_CODES.rv_low_value%TYPE
   )
   IS
   BEGIN
       SELECT UPPER(rv_meaning), rv_low_value
         INTO p_scrn_rep_tag_name, p_scrn_rep_tag
         FROM cg_ref_codes
        WHERE rv_domain = 'GIAC_MODULES.SCRN_REP_TAG'
          AND (UPPER(rv_meaning) LIKE UPPER(p_scrn_rep_tag_name)
           OR UPPER(rv_low_value) LIKE UPPER(p_scrn_rep_tag_name));
   EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_scrn_rep_tag_name := '---';
            p_scrn_rep_tag      := '---';
        WHEN OTHERS THEN
            p_scrn_rep_tag_name := NULL;
            p_scrn_rep_tag      := NULL;
   END;
END;
/


