CREATE OR REPLACE PACKAGE CPI.giis_events_pkg
AS
   TYPE giis_events_type IS RECORD (
      event_cd             giis_events.event_cd%TYPE,
      event_desc           giis_events.event_desc%TYPE,
      event_type           giis_events.event_type%TYPE,
      event_type_desc      VARCHAR2 (300),
      multiple_assign_sw   giis_events.multiple_assign_sw%TYPE,
      remarks              giis_events.remarks%TYPE,
      receiver_tag         giis_events.receiver_tag%TYPE,
      receiver_tag_desc    VARCHAR2 (100),
      user_id              giis_events.user_id%TYPE,
      last_update          VARCHAR2 (30),
      event_module_cond    VARCHAR2 (1)
   );

   TYPE giis_events_tab IS TABLE OF giis_events_type;

   TYPE giis_events_column_type IS RECORD (
      event_cd          giis_events_column.event_cd%TYPE,
      event_col_cd      giis_events_column.event_col_cd%TYPE,
      table_name        giis_events_column.table_name%TYPE,
      column_name       giis_events_column.column_name%TYPE,
      remarks           giis_events_column.remarks%TYPE,
      user_id           giis_events_column.user_id%TYPE,
      col_module_cond   VARCHAR2 (1),
      last_update       VARCHAR2 (30)
   );

   TYPE giis_events_column_tab IS TABLE OF giis_events_column_type;

   TYPE giis_events_display_type IS RECORD (
      dsp_col_id     giis_events_display.dsp_col_id%TYPE,
      event_col_cd   giis_events_display.event_col_cd%TYPE,
      rv_meaning     cg_ref_codes.rv_meaning%TYPE
   );

   TYPE giis_events_display_tab IS TABLE OF giis_events_display_type;

   TYPE all_tab_cols_type IS RECORD (
      table_name    VARCHAR2 (30),
      column_name   VARCHAR2 (30)
   );

   TYPE all_tab_cols_tab IS TABLE OF all_tab_cols_type;

   FUNCTION get_giis_events_listing (p_find_text VARCHAR2)
      RETURN giis_events_tab PIPELINED;

   FUNCTION get_giis_events_listing2
      RETURN giis_events_tab PIPELINED;

   PROCEDURE set_giis_event (p_event giis_events%ROWTYPE);

   PROCEDURE del_giis_event (p_event_cd giis_events.event_cd%TYPE);

   PROCEDURE create_transfer_events (
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_event_desc         giis_events.event_desc%TYPE,
      p_col_value          VARCHAR2,
      p_info               VARCHAR2,
      p_delimiter          VARCHAR2,
      p_messages     OUT   VARCHAR2
   );

   PROCEDURE val_del_giis_events (p_event_cd giis_events.event_cd%TYPE);

   FUNCTION get_giis_events_column (p_event_cd giis_events.event_cd%TYPE)
      RETURN giis_events_column_tab PIPELINED;

   FUNCTION get_all_tab_cols_list (p_keyword VARCHAR2)
      RETURN all_tab_cols_tab PIPELINED;

   FUNCTION get_all_tab_cols_list2 (p_table_name VARCHAR2, p_keyword VARCHAR2)
      RETURN all_tab_cols_tab PIPELINED;

   PROCEDURE set_giis_events_column (p_rec giis_events_column%ROWTYPE);

   PROCEDURE del_giis_events_column (
      p_event_col_cd   giis_events_column.event_col_cd%TYPE
   );

   PROCEDURE val_del_giis_events_column (
      p_event_col_cd   giis_events_column.event_col_cd%TYPE
   );

   PROCEDURE val_add_giis_events_column (
      p_table_name    giis_events_column.table_name%TYPE,
      p_column_name   giis_events_column.column_name%TYPE
   );

   FUNCTION get_giis_events_display (
      p_event_col_cd   giis_events_column.event_col_cd%TYPE
   )
      RETURN giis_events_display_tab PIPELINED;

   PROCEDURE val_add_giis_events_display (
      p_event_col_cd   giis_events_display.event_col_cd%TYPE,
      p_dsp_col_id     giis_events_display.dsp_col_id%TYPE
   );

   PROCEDURE set_giis_events_display (p_rec giis_events_display%ROWTYPE);

   PROCEDURE del_giis_events_display (
      p_event_col_cd   giis_events_display.event_col_cd%TYPE,
      p_dsp_col_id     giis_events_display.dsp_col_id%TYPE
   );
END giis_events_pkg;
/


