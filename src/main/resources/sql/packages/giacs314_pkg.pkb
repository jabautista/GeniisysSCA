CREATE OR REPLACE PACKAGE BODY CPI.GIACS314_PKG
AS
   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED
   IS 
      v_rec   rec_type;
   BEGIN
      FOR i IN (
            SELECT A.module_id, a.function_code, A.function_name, A.function_desc, A.override_sw,
                   A.remarks, A.user_id, A.last_update
              FROM GIAC_FUNCTIONS A
             WHERE active_tag = 'Y'
             --ORDER BY module_id
                   )                   
      LOOP
         v_rec.module_id     := i.module_id;    
         v_rec.function_code := i.function_code;
         v_rec.function_name := i.function_name;
         v_rec.function_desc := i.function_desc;
         v_rec.override_sw   := i.override_sw;  
         v_rec.remarks       := i.remarks;
         v_rec.user_id       := i.user_id;
         v_rec.last_update   := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
         v_rec.module_name    := '';
         v_rec.scrn_rep_name  := '';
         
         FOR j IN (
            SELECT module_name, scrn_rep_name
              FROM giac_modules
             WHERE module_id = i.module_id
         )
         LOOP
             v_rec.module_name    := j.module_name;
             v_rec.scrn_rep_name  := j.scrn_rep_name;
             
          PIPE ROW (v_rec);
         END LOOP;
         
      END LOOP;

      RETURN;
   END;

   PROCEDURE set_rec (p_rec giac_functions%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIAC_FUNCTIONS
         USING DUAL
            ON (module_id = p_rec.module_id
           AND  function_code = p_rec.function_code)
         WHEN NOT MATCHED THEN
            INSERT (module_id, function_code, function_name, function_desc, override_sw, remarks, user_id, last_update, active_tag)
            VALUES (p_rec.module_id, p_rec.function_code, p_rec.function_name, p_rec.function_desc, p_rec.override_sw,
                    p_rec.remarks, p_rec.user_id, SYSDATE, 'Y')
         WHEN MATCHED THEN
            UPDATE
               SET function_name = p_rec.function_name, function_desc = p_rec.function_desc, override_sw = p_rec.override_sw,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_rec (
                p_module_id     giac_functions.module_id%TYPE,
                p_function_code giac_functions.function_code%TYPE 
   )
   AS
   BEGIN
      DELETE FROM GIAC_FUNCTIONS
            WHERE module_id = p_module_id
              AND function_code = p_function_code;
   END;

   FUNCTION val_del_rec (
        p_module_id     giac_functions.module_id%TYPE,
        p_function_code giac_functions.function_code%TYPE 
   )
    RETURN VARCHAR2
   AS
      v_exists   VARCHAR2 (30) := 'N';
   BEGIN
        FOR a IN (
              SELECT 1
                FROM GIAC_USER_FUNCTIONS
               WHERE module_id = p_module_id
                 AND function_code = p_function_code
        )
        LOOP
            v_exists := 'GIAC_USER_FUNCTIONS';
            EXIT;
        END LOOP;
        
        FOR a IN (
              SELECT 1
                FROM GIAC_FUNCTION_COLUMNS
               WHERE module_id = p_module_id
                 AND function_cd = p_function_code
        )
        LOOP
            v_exists := 'GIAC_FUNCTION_COLUMNS';
            EXIT;
        END LOOP;
        
        FOR a IN (
              SELECT 1
                FROM GIAC_FUNCTION_DISPLAY
               WHERE module_id = p_module_id
                 AND function_cd = p_function_code
        )
        LOOP
            v_exists := 'GIAC_FUNCTION_DISPLAY';
            EXIT;
        END LOOP;
        
        RETURN (v_exists);
   END;

   PROCEDURE val_add_rec (
                p_module_id     giac_functions.module_id%TYPE,
                p_function_code giac_functions.function_code%TYPE 
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIAC_FUNCTIONS a
                 WHERE module_id = p_module_id
                   AND function_code = p_function_code
      )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same module_id and function_code.'
                                 );
      END IF;
   END;
   
   FUNCTION get_giacs314_module_lov(
        p_search VARCHAR2
   )
      RETURN giacs314_module_lov_tab PIPELINED
   IS 
      v_rec   giacs314_module_lov_type;
   BEGIN
      FOR i IN (
            SELECT module_name, scrn_rep_name, module_id
              FROM giac_modules
             WHERE module_name LIKE p_search
             ORDER BY module_name, module_id
                   )                   
      LOOP
         v_rec.module_id     := i.module_id;    
         v_rec.module_name   := i.module_name;
         v_rec.scrn_rep_name := i.scrn_rep_name;
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   PROCEDURE validate_module(
        p_module_name   IN OUT VARCHAR2,
        p_module_id        OUT VARCHAR2
    )
    IS
    BEGIN
        SELECT module_name, module_id
          INTO p_module_name, p_module_id 
          FROM giac_modules
         WHERE UPPER(module_name) LIKE UPPER(p_module_name);
    EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_module_name   := '---';
            p_module_id     := '---';
        WHEN OTHERS THEN
            p_module_name := NULL;
            p_module_id   := NULL;
    END;
    
    FUNCTION get_function_column(
        p_module_id     VARCHAR2,
        p_function_cd   VARCHAR2
   ) 
      RETURN function_column_tab PIPELINED
   IS 
      v_rec   function_column_type;
   BEGIN
      FOR i IN (
            SELECT function_col_cd, table_name, column_name, remarks, user_id,
                   last_update
              FROM giac_function_columns
             WHERE p_module_id = module_id
               AND p_function_cd = function_cd
             ORDER BY table_name
             )                   
      LOOP
         v_rec.function_col_cd := i.function_col_cd;
         v_rec.table_name      := i.table_name;     
         v_rec.column_name     := i.column_name;    
         v_rec.remarks         := i.remarks;        
         v_rec.user_id         := i.user_id;        
         v_rec.last_update     := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');    
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giacs314_table_lov(
        p_search    VARCHAR2
   )
      RETURN giacs314_table_lov_tab PIPELINED
   IS 
      v_rec   giacs314_table_lov_type;
   BEGIN
      FOR i IN (
            SELECT DISTINCT table_name
              FROM ALL_TAB_COLS
             WHERE owner = 'CPI'
               AND hidden_column = 'NO'
               AND table_name LIKE p_search
      )                   
      LOOP
         v_rec.table_name     := i.table_name;    
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giacs314_column_lov(
        p_table_name    VARCHAR2,
        p_search    VARCHAR2
   )
      RETURN giacs314_column_lov_tab PIPELINED
   IS 
      v_rec   giacs314_column_lov_type;
   BEGIN
      FOR i IN (
            SELECT column_name
              FROM ALL_TAB_COLS
             WHERE owner = 'CPI'
               AND hidden_column = 'NO'
               AND table_name = p_table_name
               AND column_name LIKE p_search
             ORDER BY column_name
      )                   
      LOOP
         v_rec.column_name     := i.column_name;    
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   PROCEDURE validate_table_name(
      p_table_name   IN OUT VARCHAR2
   )
    IS
   BEGIN
        SELECT DISTINCT table_name
          INTO p_table_name
          FROM ALL_TAB_COLS
         WHERE owner = 'CPI'
           AND hidden_column = 'NO'
           AND UPPER(table_name) LIKE UPPER(p_table_name);
   EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_table_name   := '---';
        WHEN OTHERS THEN
            p_table_name := NULL;
   END;
   
   
    PROCEDURE validate_column_name(
      p_table_name    IN     VARCHAR2,
      p_column_name   IN OUT VARCHAR2
   )
    IS
   BEGIN
        SELECT column_name
          INTO p_column_name
          FROM ALL_TAB_COLS
         WHERE owner = 'CPI'
           AND hidden_column = 'NO'
           AND table_name = p_table_name
           AND UPPER(column_name) LIKE UPPER(p_column_name);
   EXCEPTION
        WHEN TOO_MANY_ROWS THEN
            p_column_name   := '---';
        WHEN OTHERS THEN
            p_column_name := NULL;
   END;
   
   PROCEDURE set_function_column (p_rec giac_function_columns%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIAC_FUNCTION_COLUMNS
         USING DUAL
            ON (function_col_cd = p_rec.function_col_cd)
         WHEN NOT MATCHED THEN
            INSERT (function_col_cd, module_id, function_cd, table_name, column_name, remarks, user_id, last_update)
            VALUES (function_col_cd_seq.nextval, p_rec.module_id, p_rec.function_cd, p_rec.table_name, p_rec.column_name,
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET table_name = p_rec.table_name, column_name = p_rec.column_name,
                   remarks = p_rec.remarks, user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_function_column(
        p_function_col_cd   giac_function_columns.function_col_cd%TYPE,
        p_module_id         giac_function_columns.module_id%TYPE,
        p_function_cd       giac_function_columns.function_cd%TYPE, 
        p_table_name        giac_function_columns.table_name%TYPE,
        p_column_name       giac_function_columns.column_name%TYPE 
   )
   AS
   BEGIN
    IF p_function_col_cd IS NULL THEN
      DELETE FROM GIAC_FUNCTION_COLUMNS
            WHERE module_id =   p_module_id
              AND function_cd = p_function_cd
              AND table_name =  p_table_name
              AND column_name = p_column_name;
           
    ELSE
      DELETE FROM GIAC_FUNCTION_COLUMNS
            WHERE function_col_cd = p_function_col_cd;
         
    END IF;
              
   END;

   PROCEDURE val_add_function_column (
        p_module_id   giac_function_columns.module_id%TYPE,
        p_function_cd giac_function_columns.function_cd%TYPE, 
        p_table_name  giac_function_columns.table_name%TYPE,
        p_column_name giac_function_columns.column_name%TYPE 
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM giac_function_columns
                 WHERE module_id = p_module_id
                   AND function_cd = p_function_cd
                   AND table_name = p_table_name
                   AND column_name = p_column_name
      )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001,
                                  'Geniisys Exception#E#Record already exists with the same table_name and column_name.'
                                 );
      END IF;
   END;
   
   FUNCTION get_function_display(
        p_module_id     VARCHAR2,
        p_function_cd   VARCHAR2
   ) 
   RETURN function_display_tab PIPELINED
   IS 
      v_rec   function_display_type;
   BEGIN
      FOR i IN (
            SELECT module_id, function_cd, display_col_id, user_id, last_update
              FROM GIAC_FUNCTION_DISPLAY
             WHERE module_id = p_module_id
               AND function_cd = p_function_cd
             ORDER BY display_col_id
             )                   
      LOOP
         v_rec.module_id      := i.module_id;     
         v_rec.function_cd    := i.function_cd;   
         v_rec.display_col_id := i.display_col_id;
         v_rec.user_id        := i.user_id;       
         v_rec.last_update    := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');   
         
         SELECT display_col_name
           INTO v_rec.display_col_name
           FROM giac_column_display_hdr
          WHERE display_col_id = i.display_col_id;   
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   FUNCTION get_giacs314_display_lov(
        p_search VARCHAR2
   )
      RETURN giacs314_display_lov_tab PIPELINED
   IS 
      v_rec   giacs314_display_lov_type;
   BEGIN
      FOR i IN (
            SELECT upper(display_col_name) display_col_name, display_col_id
              FROM giac_column_display_hdr
             WHERE upper(display_col_name) LIKE p_search
             ORDER BY display_col_id
      )                   
      LOOP
         v_rec.display_col_id     := i.display_col_id;
         v_rec.display_col_name   := i.display_col_name;     
         
         PIPE ROW (v_rec);
      END LOOP;

      RETURN;
   END;
   
   PROCEDURE validate_display_column(
      p_display_col_name    IN OUT VARCHAR2,
      p_display_col_id         OUT VARCHAR2
   )
   IS
   BEGIN
        SELECT UPPER(display_col_name) display_col_name, display_col_id
          INTO p_display_col_name, p_display_col_id
          FROM giac_column_display_hdr
         WHERE UPPER(display_col_name) LIKE UPPER(p_display_col_name); 
   EXCEPTION
       WHEN TOO_MANY_ROWS THEN
           p_display_col_name    := '---';
           p_display_col_id      := '---';
       WHEN OTHERS THEN
           p_display_col_name  := NULL;
           p_display_col_id    := NULL;
   END;
   
   PROCEDURE set_display_column (p_rec giac_function_display%ROWTYPE)
   IS
   BEGIN
      MERGE INTO GIAC_FUNCTION_DISPLAY
         USING DUAL
            ON (module_id       = p_rec.module_id     
           AND  function_cd     = p_rec.function_cd   
           AND  display_col_id  = p_rec.display_col_id)
         WHEN NOT MATCHED THEN
            INSERT (module_id, function_cd, display_col_id, user_id, last_update)
            VALUES (p_rec.module_id, p_rec.function_cd, p_rec.display_col_id,
                    p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET --display_col_id = p_rec.display_col_id, 
                   user_id = p_rec.user_id, last_update = SYSDATE
            ;
   END;

   PROCEDURE del_display_column(
      p_module_id        giac_function_display.module_id%TYPE,
      p_function_cd      giac_function_display.function_cd%TYPE, 
      p_display_col_id   giac_function_display.display_col_id%TYPE
   )
   AS
   BEGIN
           DELETE FROM GIAC_FUNCTION_DISPLAY
            WHERE module_id      =   p_module_id
              AND function_cd    = p_function_cd
              AND display_col_id =  p_display_col_id;
   END;

   PROCEDURE val_add_display_column (
       p_module_id        giac_function_display.module_id%TYPE,
       p_function_cd      giac_function_display.function_cd%TYPE, 
       p_display_col_id   giac_function_display.display_col_id%TYPE
   )
   AS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIAC_FUNCTION_DISPLAY
                 WHERE module_id      = p_module_id
                   AND function_cd    = p_function_cd
                   AND display_col_id = p_display_col_id
      )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         raise_application_error (-20001, 'Geniisys Exception#E#Record already exists with the same display_col_id.');
      END IF;
   END;
END;
/


