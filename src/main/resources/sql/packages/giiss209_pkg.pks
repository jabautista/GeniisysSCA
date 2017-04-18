CREATE OR REPLACE PACKAGE CPI.giiss209_pkg
AS
   TYPE binder_status_type IS RECORD (
      bndr_stat_cd           giis_binder_status.bndr_stat_cd%TYPE,
      bndr_stat_desc         giis_binder_status.bndr_stat_desc%TYPE,
      bndr_tag               giis_binder_status.bndr_tag%TYPE,
      remarks                giis_binder_status.remarks%TYPE,
      user_id                giis_binder_status.user_id%TYPE,
      last_update            VARCHAR2 (30),
      dsp_bndr_tag_meaning   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE binder_status_tab IS TABLE OF binder_status_type;

   FUNCTION get_binder_status_list (
      p_bndr_stat_cd       giis_binder_status.bndr_stat_cd%TYPE,
      p_bndr_stat_desc     giis_binder_status.bndr_stat_desc%TYPE,
      p_bndr_tag_meaning   cg_ref_codes.rv_meaning%TYPE
   )
      RETURN binder_status_tab PIPELINED;

   PROCEDURE set_binder_status (p_rec giis_binder_status%ROWTYPE);

   PROCEDURE del_binder_status (
      p_bndr_stat_cd   giis_binder_status.bndr_stat_cd%TYPE
   );

   PROCEDURE val_add_rec (
      p_bndr_stat_cd     giis_binder_status.bndr_stat_cd%TYPE,
      p_bndr_stat_desc   giis_binder_status.bndr_stat_desc%TYPE
   );
   
   PROCEDURE val_del_rec (
      p_bndr_stat_cd     giis_binder_status.bndr_stat_cd%TYPE
   );
END;
/


