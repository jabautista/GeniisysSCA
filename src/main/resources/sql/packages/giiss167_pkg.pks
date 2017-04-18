CREATE OR REPLACE PACKAGE CPI.giiss167_pkg
AS
   TYPE giisdspcolumn_type IS RECORD (
      dsp_col_id        giis_dsp_column.dsp_col_id%TYPE,
      table_name        giis_dsp_column.table_name%TYPE,
      old_table_name    giis_dsp_column.table_name%TYPE,
      column_name       giis_dsp_column.column_name%TYPE,
      old_column_name   giis_dsp_column.column_name%TYPE,
      user_id           giis_dsp_column.user_id%TYPE,
      database_tag      VARCHAR2 (1),
      last_update       VARCHAR2 (30)
   );

   TYPE giisdspcolumn_tab IS TABLE OF giisdspcolumn_type;

   FUNCTION get_giisdspcolumn_list (
      p_dsp_col_id    giis_dsp_column.dsp_col_id%TYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   )
      RETURN giisdspcolumn_tab PIPELINED;

   TYPE columnlov_type IS RECORD (
      col_id     cg_ref_codes.rv_low_value%TYPE,
      col_name   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE columnlov_tab IS TABLE OF columnlov_type;

   FUNCTION get_column_lov (p_keyword VARCHAR2)
      RETURN columnlov_tab PIPELINED;

   TYPE tablename_type IS RECORD (
      table_name   all_tab_cols.table_name%TYPE
   );

   TYPE tablename_tab IS TABLE OF tablename_type;

   FUNCTION get_tablename_lov (
      p_keyword       VARCHAR2,
      p_column_name   all_tab_cols.column_name%TYPE
   )
      RETURN tablename_tab PIPELINED;

   TYPE columnname_type IS RECORD (
      column_name   all_tab_cols.column_name%TYPE
   );

   TYPE columnname_tab IS TABLE OF columnname_type;

   FUNCTION get_columnname_lov (
      p_keyword      VARCHAR2,
      p_table_name   all_tab_cols.table_name%TYPE,
      p_dsp_col_id   giis_dsp_column.dsp_col_id%TYPE
   )
      RETURN columnname_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_dsp_col_id    giis_dsp_column.dsp_col_id%TYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   );

   PROCEDURE set_rec (
      p_rec           giis_dsp_column%ROWTYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   );

   PROCEDURE del_rec (
      p_dsp_col_id    giis_dsp_column.dsp_col_id%TYPE,
      p_table_name    giis_dsp_column.table_name%TYPE,
      p_column_name   giis_dsp_column.column_name%TYPE
   );
   
   
END;
/


