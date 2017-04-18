CREATE OR REPLACE PACKAGE CPI.giiss040_pkg
AS
   PROCEDURE when_new_form_instance (
      p_restrict_gen2file_by_user OUT giis_parameters.param_value_v%TYPE
   );

   TYPE rec_type IS RECORD (
      user_id             giis_users.user_id%TYPE,
      user_name           giis_users.user_name%TYPE,
      email_address       giis_users.email_address%TYPE,
      active_flag         giis_users.active_flag%TYPE,
      comm_update_tag     giis_users.comm_update_tag%TYPE,
      all_user_sw         giis_users.all_user_sw%TYPE,
      mgr_sw              giis_users.mgr_sw%TYPE,
      mktng_sw            giis_users.mktng_sw%TYPE,
      mis_sw              giis_users.mis_sw%TYPE,
      workflow_tag        giis_users.workflow_tag%TYPE,
      temp_access_tag     giis_users.temp_access_tag%TYPE,
      allow_gen_file_sw   giis_users.allow_gen_file_sw%TYPE,
      user_grp            giis_users.user_grp%TYPE,
      dsp_user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      dsp_grp_iss_cd      giis_user_grp_hdr.grp_iss_cd%TYPE,
      remarks             giis_users.remarks%TYPE,
      last_user_id        giis_users.last_user_id%TYPE,
      last_update         VARCHAR2 (30),
      password            giis_users.password%TYPE -- apollo cruz 03.01.2016
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_user_id             giis_users.user_id%TYPE,
      p_user_name           giis_users.user_name%TYPE,
      p_active_flag         giis_users.active_flag%TYPE,
      p_comm_update_tag     giis_users.comm_update_tag%TYPE,
      p_all_user_sw         giis_users.all_user_sw%TYPE,
      p_mgr_sw              giis_users.mgr_sw%TYPE,
      p_mktng_sw            giis_users.mktng_sw%TYPE,
      p_mis_sw              giis_users.mis_sw%TYPE,
      p_workflow_tag        giis_users.workflow_tag%TYPE,
      p_temp_access_tag     giis_users.temp_access_tag%TYPE,
      p_allow_gen_file_sw   giis_users.allow_gen_file_sw%TYPE,
      p_user_grp            giis_users.user_grp%TYPE,
      p_user_grp_desc       giis_user_grp_hdr.user_grp_desc%TYPE,
      p_iss_cd              giis_user_grp_hdr.grp_iss_cd%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_users%ROWTYPE);

   PROCEDURE del_rec (p_user_id giis_users.user_id%TYPE);

   PROCEDURE val_del_rec (p_user_id giis_users.user_id%TYPE);

   PROCEDURE val_add_rec (p_user_id giis_users.user_id%TYPE);

   TYPE user_grp_lov_type IS RECORD (
      user_grp        giis_user_grp_hdr.user_grp%TYPE,
      user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      grp_iss_cd      giis_user_grp_hdr.grp_iss_cd%TYPE
   );

   TYPE user_grp_lov_tab IS TABLE OF user_grp_lov_type;

   FUNCTION get_user_grp_lov (p_find_text VARCHAR2)
      RETURN user_grp_lov_tab PIPELINED;

   TYPE user_grp_trans_type IS RECORD (
      tran_cd     giis_transaction.tran_cd%TYPE,
      tran_desc   giis_transaction.tran_desc%TYPE
   );

   TYPE user_grp_trans_tab IS TABLE OF user_grp_trans_type;

   FUNCTION get_user_grp_trans (
      p_user_grp    giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd     giis_transaction.tran_cd%TYPE,
      p_tran_desc   giis_transaction.tran_desc%TYPE
   )
      RETURN user_grp_trans_tab PIPELINED;

   TYPE user_grp_dtl_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE user_grp_dtl_tab IS TABLE OF user_grp_dtl_type;

   FUNCTION get_user_grp_dtl (
      p_user_grp   giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd    giis_transaction.tran_cd%TYPE,
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_iss_name   giis_issource.iss_name%TYPE
   )
      RETURN user_grp_dtl_tab PIPELINED;

   TYPE user_grp_line_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE user_grp_line_tab IS TABLE OF user_grp_line_type;

   FUNCTION get_user_grp_line (
      p_user_grp    giis_user_grp_tran.user_grp%TYPE,
      p_tran_cd     giis_transaction.tran_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_line_name   giis_line.line_name%TYPE
   )
      RETURN user_grp_line_tab PIPELINED;

   TYPE modules_tran_type IS RECORD (
      module_id             giis_modules.module_id%TYPE,
      module_desc           giis_modules.module_desc%TYPE,
      inc_tag               VARCHAR2 (1),
      tran_cd               giis_modules_tran.tran_cd%TYPE,
      dsp_access_tag        giis_user_grp_modules.access_tag%TYPE,
      dsp_access_tag_desc   cg_ref_codes.rv_meaning%TYPE,
      user_id               giis_modules_tran.user_id%TYPE,
      last_update           VARCHAR2 (30)
   );

   TYPE modules_tran_tab IS TABLE OF modules_tran_type;

   FUNCTION get_modules_tran (
      p_tran_cd               giis_modules_tran.tran_cd%TYPE,
      p_user_grp              giis_user_grp_tran.user_grp%TYPE,
      p_module_id             giis_modules.module_id%TYPE,
      p_module_desc           giis_modules.module_desc%TYPE,
      p_dsp_access_tag_desc   VARCHAR2
   )
      RETURN modules_tran_tab PIPELINED;

   TYPE user_tran_type IS RECORD (
      tran_cd       giis_transaction.tran_cd%TYPE,
      tran_desc     giis_transaction.tran_desc%TYPE,
      inc_all_tag   VARCHAR2 (1),
      not_in        VARCHAR2 (1000)
   );

   TYPE user_tran_tab IS TABLE OF user_tran_type;

   FUNCTION get_user_tran (
      p_userid        giis_user_tran.userid%TYPE,
      p_tran_cd       giis_transaction.tran_cd%TYPE,
      p_tran_desc     giis_transaction.tran_desc%TYPE,
      p_inc_all_tag   VARCHAR2
   )
      RETURN user_tran_tab PIPELINED;

   FUNCTION get_tran_lov (p_find_text VARCHAR2)
      RETURN user_tran_tab PIPELINED;

   TYPE user_iss_cd_type IS RECORD (
      tran_cd    giis_user_iss_cd.tran_cd%TYPE,
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE,
      not_in     VARCHAR2 (1000)
   );

   TYPE user_iss_cd_tab IS TABLE OF user_iss_cd_type;

   FUNCTION get_user_iss_cd (
      p_userid     giis_user_tran.userid%TYPE,
      p_tran_cd    giis_transaction.tran_cd%TYPE,
      p_iss_cd     giis_issource.iss_cd%TYPE,
      p_iss_name   giis_issource.iss_name%TYPE
   )
      RETURN user_iss_cd_tab PIPELINED;

   FUNCTION get_iss_lov (p_find_text VARCHAR2)
      RETURN user_iss_cd_tab PIPELINED;

   TYPE user_line_type IS RECORD (
      tran_cd     giis_user_line.tran_cd%TYPE,
      iss_cd      giis_user_line.iss_cd%TYPE,
      line_cd     giis_user_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE,
      not_in      VARCHAR2 (1000)
   );

   TYPE user_line_tab IS TABLE OF user_line_type;

   FUNCTION get_user_line (
      p_userid      giis_user_tran.userid%TYPE,
      p_tran_cd     giis_transaction.tran_cd%TYPE,
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_line_cd     giis_line.line_cd%TYPE,
      p_line_name   giis_line.line_name%TYPE
   )
      RETURN user_line_tab PIPELINED;

   FUNCTION get_line_lov (p_find_text VARCHAR2)
      RETURN user_line_tab PIPELINED;

   TYPE user_modules_type IS RECORD (
      module_id             giis_modules.module_id%TYPE,
      module_desc           giis_modules.module_desc%TYPE,
      inc_tag               VARCHAR2 (1),
      tran_cd               giis_modules_tran.tran_cd%TYPE,
      dsp_access_tag        giis_user_modules.access_tag%TYPE,
      dsp_access_tag_desc   cg_ref_codes.rv_meaning%TYPE,
      remarks               giis_user_modules.remarks%TYPE,
      user_id               giis_modules_tran.user_id%TYPE,
      last_update           VARCHAR2 (30)
   );

   TYPE user_modules_tab IS TABLE OF user_modules_type;

   FUNCTION get_user_modules (
      p_tran_cd               giis_modules_tran.tran_cd%TYPE,
      p_userid                giis_user_modules.userid%TYPE,
      p_module_id             giis_modules.module_id%TYPE,
      p_module_desc           giis_modules.module_desc%TYPE,
      p_dsp_access_tag_desc   VARCHAR2
   )
      RETURN user_modules_tab PIPELINED;

   PROCEDURE set_user_module (
      p_app_user               giis_users.user_id%TYPE,
      p_tran_cd                giis_modules_tran.tran_cd%TYPE,
      p_user_id                giis_users.user_id%TYPE,
      p_module_id              giis_modules_tran.module_id%TYPE,
      p_inc_tag                VARCHAR2,
      p_dsp_access_tag         giis_user_modules.access_tag%TYPE,
      p_remarks                giis_user_modules.remarks%TYPE,
      p_inc_all_tag      OUT   VARCHAR2
   );

   PROCEDURE check_all (
      p_tran_cd             giis_modules_tran.tran_cd%TYPE,
      p_userid              giis_user_modules.userid%TYPE,
      p_inc_all_tag   OUT   VARCHAR2
   );

   PROCEDURE uncheck_all (
      p_tran_cd             giis_modules_tran.tran_cd%TYPE,
      p_userid              giis_user_modules.userid%TYPE,
      p_inc_all_tag   OUT   VARCHAR2
   );

   PROCEDURE del_user_tran (
      p_tran_cd   giis_modules_tran.tran_cd%TYPE,
      p_userid    giis_user_modules.userid%TYPE
   );

   PROCEDURE set_user_tran (
      p_userid       giis_user_modules.userid%TYPE,
      p_tran_cd      giis_modules_tran.tran_cd%TYPE,
      p_access_tag   giis_user_tran.access_tag%TYPE
   );

   PROCEDURE del_user_iss (
      p_userid    giis_user_iss_cd.userid%TYPE,
      p_tran_cd   giis_user_iss_cd.tran_cd%TYPE,
      p_iss_cd    giis_user_iss_cd.iss_cd%TYPE
   );

   PROCEDURE set_user_iss (
      p_userid    giis_user_iss_cd.userid%TYPE,
      p_tran_cd   giis_user_iss_cd.tran_cd%TYPE,
      p_iss_cd    giis_user_iss_cd.iss_cd%TYPE
   );

   PROCEDURE del_user_line (
      p_userid    giis_user_line.userid%TYPE,
      p_tran_cd   giis_user_line.tran_cd%TYPE,
      p_iss_cd    giis_user_line.iss_cd%TYPE,
      p_line_cd   giis_user_line.line_cd%TYPE
   );

   PROCEDURE set_user_line (
      p_userid    giis_user_line.userid%TYPE,
      p_tran_cd   giis_user_line.tran_cd%TYPE,
      p_iss_cd    giis_user_line.iss_cd%TYPE,
      p_line_cd   giis_user_line.line_cd%TYPE
   );

   FUNCTION include_all_iss_codes
      RETURN user_iss_cd_tab PIPELINED;

   FUNCTION include_all_line_codes
      RETURN user_line_tab PIPELINED;
      
   PROCEDURE val_del_tran_1 (
      p_iss_cd   giis_issource.iss_cd%TYPE
   );
   
   PROCEDURE val_del_tran_1_line (
      p_iss_cd    giis_issource.iss_cd%TYPE,
      p_line_cd   giis_line.line_cd%TYPE
   );
END;
/


