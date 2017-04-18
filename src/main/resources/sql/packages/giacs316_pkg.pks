CREATE OR REPLACE PACKAGE CPI.giacs316_pkg
AS
   TYPE rec_type IS RECORD (
      doc_code             giac_doc_sequence_user.doc_code%TYPE,
      branch_cd            giac_doc_sequence_user.branch_cd%TYPE,
      user_cd              giac_doc_sequence_user.user_cd%TYPE,
      user_name            giac_dcb_users.dcb_user_id%TYPE,
      doc_pref             giac_doc_sequence_user.doc_pref%TYPE,
      old_doc_pref         giac_doc_sequence_user.doc_pref%TYPE,
      min_seq_no           giac_doc_sequence_user.min_seq_no%TYPE,
      old_min_seq_no       giac_doc_sequence_user.min_seq_no%TYPE,
      max_seq_no           giac_doc_sequence_user.max_seq_no%TYPE,
      old_max_seq_no       giac_doc_sequence_user.max_seq_no%TYPE,
      active_tag           giac_doc_sequence_user.active_tag%TYPE,
      old_active_tag       giac_doc_sequence_user.active_tag%TYPE,
      remarks              giac_doc_sequence_user.remarks%TYPE,
      user_id              giac_doc_sequence_user.user_id%TYPE,
      last_update          VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_doc_code           giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd          giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd            giac_doc_sequence_user.user_cd%TYPE,
      p_user_name          VARCHAR2,
      p_doc_pref           giac_doc_sequence_user.doc_pref%TYPE,
      p_min_seq_no         giac_doc_sequence_user.min_seq_no%TYPE,
      p_max_seq_no         giac_doc_sequence_user.max_seq_no%TYPE,
      p_active_tag         VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (
      --p_rec giac_doc_sequence_user%ROWTYPE
      p_doc_code          giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd         giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd           giac_doc_sequence_user.user_cd%TYPE,
      p_doc_pref          giac_doc_sequence_user.doc_pref%TYPE,
      p_old_doc_pref      giac_doc_sequence_user.doc_pref%TYPE,
      p_min_seq_no        giac_doc_sequence_user.min_seq_no%TYPE,
      p_old_min_seq_no    giac_doc_sequence_user.min_seq_no%TYPE,
      p_max_seq_no        giac_doc_sequence_user.max_seq_no%TYPE,
      p_old_max_seq_no    giac_doc_sequence_user.max_seq_no%TYPE,
      p_active_tag        giac_doc_sequence_user.active_tag%TYPE,
      p_old_active_tag    giac_doc_sequence_user.active_tag%TYPE,
      p_remarks           giac_doc_sequence_user.remarks%TYPE,
      p_user_id           giac_doc_sequence_user.user_id%TYPE
   );

   PROCEDURE del_rec (p_rec giac_doc_sequence_user%ROWTYPE
      /*p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd         giac_doc_sequence_user.user_cd%TYPE,
      p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
      p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
      p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE*/
   );

   PROCEDURE val_del_rec (
      p_doc_code         giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd        giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd          giac_doc_sequence_user.user_cd%TYPE,
      p_doc_pref         giac_doc_sequence_user.doc_pref%TYPE
   );

   PROCEDURE val_add_rec (
      p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
      p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
      p_user_cd         giac_doc_sequence_user.user_cd%TYPE,
      p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
      p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
      p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE
   );
   
   TYPE giacs316_branch_type IS RECORD (
        iss_cd           giis_issource.iss_cd%TYPE,
        iss_name         giis_issource.iss_name%TYPE,
        doc_type         cg_ref_codes.rv_low_value%TYPE,
        doc_type_mean    cg_ref_codes.rv_meaning%TYPE
   );
   
   TYPE giacs316_branch_tab IS TABLE OF giacs316_branch_type;
   
   FUNCTION get_giacs316_branch_lov(
        p_doc_code       cg_ref_codes.rv_low_value%TYPE,
        p_module_id      giis_modules.module_id%TYPE,
        p_user           giis_users.user_id%TYPE
   ) RETURN giacs316_branch_tab PIPELINED;
   
   TYPE giacs316_user_type IS RECORD (
        cashier_cd       giac_dcb_users.cashier_cd%TYPE,
        dcb_user_id      giac_dcb_users.dcb_user_id%TYPE
   );
   
   TYPE giacs316_user_tab IS TABLE OF giacs316_user_type;
   
   FUNCTION get_giacs316_user_lov(
        p_iss_cd          giac_dcb_users.gibr_branch_cd%TYPE
   ) RETURN giacs316_user_tab PIPELINED;
   
   PROCEDURE validate_min_seq_no(
        p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
        --p_user_cd         giac_doc_sequence_user.user_cd%TYPE,
        p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE,
        p_old_min_seq_no  giac_doc_sequence_user.min_seq_no%TYPE
   );
   
   PROCEDURE validate_max_seq_no(
        p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
        p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE,
        p_old_max_seq_no  giac_doc_sequence_user.max_seq_no%TYPE
   );
   
   PROCEDURE validate_active_tag(
        p_doc_code        giac_doc_sequence_user.doc_code%TYPE,
        p_branch_cd       giac_doc_sequence_user.branch_cd%TYPE,
        p_user_cd         giac_doc_sequence_user.user_cd%TYPE,
        p_doc_pref        giac_doc_sequence_user.doc_pref%TYPE,
        p_min_seq_no      giac_doc_sequence_user.min_seq_no%TYPE,
        p_max_seq_no      giac_doc_sequence_user.max_seq_no%TYPE,
        p_opt             VARCHAR2,
        p_old_min_seq_no  giac_doc_sequence_user.min_seq_no%TYPE,
        p_old_max_seq_no  giac_doc_sequence_user.max_seq_no%TYPE
   );

END;
/


