CREATE OR REPLACE PACKAGE CPI.giiss075_pkg
AS
   TYPE rec_type IS RECORD (
      iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      iss_name       giis_issource.iss_name%TYPE,
      co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE,
      type_name      giis_co_intrmdry_types.type_name%TYPE,
      remarks        giis_co_intrmdry_types.remarks%TYPE,
      user_id        giis_co_intrmdry_types.user_id%TYPE,
      last_update    VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   TYPE issue_source_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE issue_source_lov_tab IS TABLE OF issue_source_lov_type;

   FUNCTION get_rec_list (
      p_iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      p_iss_name       giis_issource.iss_name%TYPE,
      p_co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE,
      p_type_name      giis_co_intrmdry_types.type_name%TYPE,
      p_user_id        VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   FUNCTION show_issue_source_lov (p_user_id VARCHAR2)
      RETURN issue_source_lov_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_co_intrmdry_types%ROWTYPE);

   PROCEDURE delete_rec (p_rec giis_co_intrmdry_types%ROWTYPE);

   PROCEDURE val_del_rec (
      p_iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      p_co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE
   );

   PROCEDURE val_add_rec (
      p_iss_cd         giis_co_intrmdry_types.iss_cd%TYPE,
      p_co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE
   );
END;
/


