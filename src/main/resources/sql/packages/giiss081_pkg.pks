CREATE OR REPLACE PACKAGE CPI.giiss081_pkg
AS
   TYPE rec_type IS RECORD (
      module_id              giis_modules.module_id%TYPE,
      module_desc            giis_modules.module_desc%TYPE,
      module_type            giis_modules.module_type%TYPE,
      dsp_module_type_desc   cg_ref_codes.rv_meaning%TYPE,
      module_grp             giis_modules.module_grp%TYPE,
      mod_access_tag         giis_modules.mod_access_tag%TYPE,
      web_enabled            giis_modules.web_enabled%TYPE,
      remarks                giis_modules.remarks%TYPE,
      user_id                giis_modules.user_id%TYPE,
      last_update            VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_module_id     giis_modules.module_id%TYPE,
      p_module_desc   giis_modules.module_desc%TYPE,
      p_module_type   giis_modules.module_type%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE val_del_rec (p_module_id giis_modules.module_id%TYPE);

   PROCEDURE val_add_rec (
      p_module_id     giis_modules.module_id%TYPE,
      p_module_desc   giis_modules.module_desc%TYPE
   );

   TYPE module_type_lov_type IS RECORD (
      module_type        cg_ref_codes.rv_low_value%TYPE,
      module_type_desc   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE module_type_lov_tab IS TABLE OF module_type_lov_type;

   FUNCTION get_moduletype_lov (p_keyword VARCHAR2)
      RETURN module_type_lov_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_modules%ROWTYPE);

   PROCEDURE del_rec (p_module_id giis_modules.module_id%TYPE);

   TYPE tran_rec_type IS RECORD (
      module_id     giis_modules_tran.module_id%TYPE,
      tran_cd       giis_modules_tran.tran_cd%TYPE,
      tran_desc     giis_transaction.tran_desc%TYPE,
      user_id       giis_modules_tran.user_id%TYPE,
      last_update   VARCHAR2 (30)
   );

   TYPE tran_rec_tab IS TABLE OF tran_rec_type;

   FUNCTION get_tranrec_list (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE,
      p_tran_desc   giis_transaction.tran_desc%TYPE
   )
      RETURN tran_rec_tab PIPELINED;

   TYPE tran_lov_type IS RECORD (
      tran_cd     giis_transaction.tran_cd%TYPE,
      tran_desc   giis_transaction.tran_desc%TYPE
   );

   TYPE tran_lov_tab IS TABLE OF tran_lov_type;

   FUNCTION get_tran_lov (p_keyword VARCHAR2)
      RETURN tran_lov_tab PIPELINED;

   PROCEDURE val_deltran_rec (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE
   );

   PROCEDURE val_addtran_rec (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE
   );

   PROCEDURE set_tran_rec (p_rec giis_modules_tran%ROWTYPE);

   PROCEDURE del_tran_rec (
      p_module_id   giis_modules_tran.module_id%TYPE,
      p_tran_cd     giis_modules_tran.tran_cd%TYPE
   );

   TYPE user_modules_type IS RECORD (
      userid        giis_user_modules.module_id%TYPE,
      user_name     giis_users.user_name%TYPE,
      access_tag    giis_user_modules.access_tag%TYPE,
      user_id       giis_user_modules.user_id%TYPE,
      last_update   VARCHAR2 (30)
   );

   TYPE user_modules_tab IS TABLE OF user_modules_type;

   FUNCTION get_usermodules_list (
      p_module_id    giis_user_modules.module_id%TYPE,
      p_userid       giis_user_modules.userid%TYPE,
      p_user_name    giis_users.user_name%TYPE,
      p_access_tag   giis_user_modules.access_tag%TYPE
   )
      RETURN user_modules_tab PIPELINED;

   TYPE user_grp_modules_type IS RECORD (
      user_grp        giis_user_grp_modules.user_grp%TYPE,
      access_tag      giis_user_grp_modules.access_tag%TYPE,
      tran_cd         giis_user_grp_modules.tran_cd%TYPE,
      user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      remarks         giis_user_grp_modules.remarks%TYPE,
      user_id         giis_user_grp_modules.user_id%TYPE,
      last_update     VARCHAR2 (30)
   );

   TYPE user_grp_modules_tab IS TABLE OF user_grp_modules_type;

   FUNCTION get_usergrpmodules_list (
      p_module_id       giis_user_grp_modules.module_id%TYPE,
      p_user_grp        giis_user_grp_modules.user_grp%TYPE,
      p_user_grp_desc   giis_user_grp_hdr.user_grp_desc%TYPE,
      p_access_tag      giis_user_grp_modules.access_tag%TYPE,
      p_tran_cd         giis_user_grp_modules.tran_cd%TYPE
   )
      RETURN user_grp_modules_tab PIPELINED;

   TYPE giis_users_type IS RECORD (
      user_id     giis_users.user_id%TYPE,
      user_name   giis_users.user_name%TYPE
   );

   TYPE giis_users_tab IS TABLE OF giis_users_type;

   FUNCTION get_users_list (
      p_user_grp    giis_users.user_grp%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_user_name   giis_users.user_name%TYPE
   )
      RETURN giis_users_tab PIPELINED;
END;
/


