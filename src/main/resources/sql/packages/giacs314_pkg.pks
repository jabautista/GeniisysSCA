CREATE OR REPLACE PACKAGE CPI.GIACS314_PKG
AS
   
   TYPE rec_type IS RECORD (
      module_id       giac_functions.module_id%TYPE,
      module_name     giac_modules.module_name%TYPE,
      scrn_rep_name   giac_modules.scrn_rep_name%TYPE,
      function_code   giac_functions.function_code%TYPE,
      function_name   giac_functions.function_name%TYPE,
      function_desc   giac_functions.function_desc%TYPE,
      override_sw     giac_functions.override_sw%TYPE,
      remarks         giac_functions.remarks%TYPE,
      user_id         giac_functions.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giac_functions%ROWTYPE);

   PROCEDURE del_rec (
                p_module_id     giac_functions.module_id%TYPE,
                p_function_code giac_functions.function_code%TYPE 
   );

   FUNCTION val_del_rec (
                p_module_id     giac_functions.module_id%TYPE,
                p_function_code giac_functions.function_code%TYPE 
   )
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(
                p_module_id     giac_functions.module_id%TYPE,
                p_function_code giac_functions.function_code%TYPE 
   );
   
   TYPE giacs314_module_lov_type IS RECORD (
      module_id       giac_modules.module_id%TYPE,
      module_name     giac_modules.module_name%TYPE,
      scrn_rep_name   giac_modules.scrn_rep_name%TYPE
   ); 

   TYPE giacs314_module_lov_tab IS TABLE OF giacs314_module_lov_type;

   FUNCTION get_giacs314_module_lov(
        p_search VARCHAR2
   )
      RETURN giacs314_module_lov_tab PIPELINED;
      
   PROCEDURE validate_module(
      p_module_name   IN OUT VARCHAR2,
      p_module_id        OUT VARCHAR2
   );
   
   TYPE function_column_type IS RECORD (
      function_col_cd giac_function_columns.function_col_cd%TYPE,
      table_name      giac_function_columns.table_name%TYPE,
      column_name     giac_function_columns.column_name%TYPE,
      remarks         giac_function_columns.remarks%TYPE,
      user_id         giac_function_columns.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE function_column_tab IS TABLE OF function_column_type;

   FUNCTION get_function_column(
        p_module_id     VARCHAR2,
        p_function_cd   VARCHAR2
   ) 
      RETURN function_column_tab PIPELINED;
   
   TYPE giacs314_table_lov_type IS RECORD (
      table_name      ALL_TAB_COLS.table_name%TYPE
   ); 

   TYPE giacs314_table_lov_tab IS TABLE OF giacs314_table_lov_type;

   FUNCTION get_giacs314_table_lov(
        p_search    VARCHAR2
   )
      RETURN giacs314_table_lov_tab PIPELINED;
      
   TYPE giacs314_column_lov_type IS RECORD (
      column_name      ALL_TAB_COLS.column_name%TYPE
   ); 

   TYPE giacs314_column_lov_tab IS TABLE OF giacs314_column_lov_type;

   FUNCTION get_giacs314_column_lov(
        p_table_name    VARCHAR2,
        p_search    VARCHAR2
   )
      RETURN giacs314_column_lov_tab PIPELINED;
      
   PROCEDURE validate_table_name(
      p_table_name   IN OUT VARCHAR2
   );
   
   PROCEDURE validate_column_name(
      p_table_name    IN     VARCHAR2,
      p_column_name   IN OUT VARCHAR2
   );
   
   PROCEDURE set_function_column (p_rec giac_function_columns%ROWTYPE);

   PROCEDURE del_function_column (
      p_function_col_cd  giac_function_columns.function_col_cd%TYPE,
      p_module_id        giac_function_columns.module_id%TYPE,
      p_function_cd      giac_function_columns.function_cd%TYPE, 
      p_table_name       giac_function_columns.table_name%TYPE,
      p_column_name      giac_function_columns.column_name%TYPE 
   );

   PROCEDURE val_add_function_column(
        p_module_id   giac_function_columns.module_id%TYPE,
        p_function_cd giac_function_columns.function_cd%TYPE, 
        p_table_name  giac_function_columns.table_name%TYPE,
        p_column_name giac_function_columns.column_name%TYPE 
   );
   
   TYPE function_display_type IS RECORD (
      module_id       giac_function_display.module_id%TYPE,
      function_cd     giac_function_display.function_cd%TYPE,
      display_col_id  giac_function_display.display_col_id%TYPE,
      display_col_name giac_column_display_hdr.display_col_name%TYPE,
      user_id         giac_function_display.user_id%TYPE,
      last_update     VARCHAR2 (30)
   ); 

   TYPE function_display_tab IS TABLE OF function_display_type;

   FUNCTION get_function_display(
        p_module_id     VARCHAR2,
        p_function_cd   VARCHAR2
   ) 
   RETURN function_display_tab PIPELINED;
   
   TYPE giacs314_display_lov_type IS RECORD (
      display_col_id      giac_column_display_hdr.display_col_id%TYPE,
      display_col_name    giac_column_display_hdr.display_col_name%TYPE
   ); 

   TYPE giacs314_display_lov_tab IS TABLE OF giacs314_display_lov_type;

   FUNCTION get_giacs314_display_lov(
        p_search VARCHAR2
   )
      RETURN giacs314_display_lov_tab PIPELINED;
      
   PROCEDURE validate_display_column(
      p_display_col_name    IN OUT VARCHAR2,
      p_display_col_id         OUT VARCHAR2
   );
   
   PROCEDURE set_display_column (p_rec giac_function_display%ROWTYPE);

   PROCEDURE del_display_column (
      p_module_id        giac_function_display.module_id%TYPE,
      p_function_cd      giac_function_display.function_cd%TYPE, 
      p_display_col_id   giac_function_display.display_col_id%TYPE
   );

   PROCEDURE val_add_display_column(
       p_module_id        giac_function_display.module_id%TYPE,
       p_function_cd      giac_function_display.function_cd%TYPE, 
       p_display_col_id   giac_function_display.display_col_id%TYPE
   );
   
END;
/


