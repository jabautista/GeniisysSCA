CREATE OR REPLACE PACKAGE CPI.giiss065_pkg
AS
   TYPE giisdefaultdist_type IS RECORD (
      default_no         giis_default_dist.default_no%TYPE,
      line_cd            giis_default_dist.line_cd%TYPE,
      dsp_line_name      giis_line.line_name%TYPE,
      default_type       giis_default_dist.default_type%TYPE,
      dsp_default_name   cg_ref_codes.rv_meaning%TYPE,
      dist_type          giis_default_dist.dist_type%TYPE,
      dsp_dist_name      cg_ref_codes.rv_meaning%TYPE,
      subline_cd         giis_default_dist.subline_cd%TYPE,
      dsp_subline_name   giis_subline.subline_name%TYPE,
      iss_cd             giis_default_dist.iss_cd%TYPE,
      dsp_iss_name       giis_issource.iss_name%TYPE
   );

   TYPE giisdefaultdist_tab IS TABLE OF giisdefaultdist_type;

   FUNCTION get_giisdefaultdist_list (
      p_line_cd        giis_default_dist.line_cd%TYPE,
      p_subline_cd     giis_default_dist.subline_cd%TYPE,
      p_iss_cd         giis_default_dist.iss_cd%TYPE,
      p_dist_type      giis_default_dist.dist_type%TYPE,
      p_default_type   giis_default_dist.default_type%TYPE,
      p_default_no     giis_default_dist.default_no%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN giisdefaultdist_tab PIPELINED;

   TYPE linelov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE linelov_tab IS TABLE OF linelov_type;

   FUNCTION get_giiss065_line_lov (
      p_iss_cd    VARCHAR2,
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2
   )
      RETURN linelov_tab PIPELINED;

   TYPE sublinelov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE sublinelov_tab IS TABLE OF sublinelov_type;

   FUNCTION get_giiss065_subline_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN sublinelov_tab PIPELINED;

   TYPE isslov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE isslov_tab IS TABLE OF isslov_type;

   FUNCTION get_giiss065_iss_lov (
      p_line_cd   VARCHAR2,
      p_user_id   VARCHAR2,
      p_keyword   VARCHAR2
   )
      RETURN isslov_tab PIPELINED;

   TYPE disttypelov_type IS RECORD (
      dist_type   cg_ref_codes.rv_low_value%TYPE,
      dist_name   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE disttypelov_tab IS TABLE OF disttypelov_type;

   FUNCTION get_giiss065_disttype_lov (p_keyword VARCHAR2)
      RETURN disttypelov_tab PIPELINED;

   TYPE defaulttypelov_type IS RECORD (
      default_type   cg_ref_codes.rv_low_value%TYPE,
      default_name   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE defaulttypelov_tab IS TABLE OF defaulttypelov_type;

   FUNCTION get_giiss065_defaulttype_lov (p_keyword VARCHAR2)
      RETURN defaulttypelov_tab PIPELINED;

   PROCEDURE val_adddefaultdist_rec (
      p_line_cd      giis_default_dist.line_cd%TYPE,
      p_subline_cd   giis_default_dist.subline_cd%TYPE,
      p_iss_cd       giis_default_dist.iss_cd%TYPE
   );

   PROCEDURE val_deldefaultdist_rec (
      p_default_no   giis_default_dist.default_no%TYPE
   );

   PROCEDURE set_giisdefaultdist_rec (p_rec giis_default_dist%ROWTYPE);

   PROCEDURE del_giisdefaultdist_rec (
      p_default_no   giis_default_dist.default_no%TYPE
   );

   TYPE giisdefaultdistgroup_type IS RECORD (
      default_no        giis_default_dist_group.default_no%TYPE,
      line_cd           giis_default_dist_group.line_cd%TYPE,
      share_cd          giis_default_dist_dtl.share_cd%TYPE,
      dsp_treaty_name   giis_dist_share.trty_name%TYPE,
      SEQUENCE          giis_default_dist_group.SEQUENCE%TYPE,
      share_pct         giis_default_dist_group.share_pct%TYPE,
      share_amt1        giis_default_dist_group.share_amt1%TYPE,
      remarks           giis_default_dist_group.remarks%TYPE,
      user_id           giis_default_dist_group.user_id%TYPE,
      sequence_no       giis_default_dist_group.sequence%TYPE,
      last_update       VARCHAR2 (30)
   );

   TYPE giisdefaultdistgroup_tab IS TABLE OF giisdefaultdistgroup_type;

   FUNCTION get_giisdefaultdistgroup_list (
      p_default_no        giis_default_dist_dtl.default_no%TYPE,
      p_sequence          giis_default_dist_group.SEQUENCE%TYPE,
      p_dsp_treaty_name   giis_dist_share.trty_name%TYPE,
      p_share_pct         giis_default_dist_group.share_pct%TYPE,
      p_share_amt1        giis_default_dist_group.share_amt1%TYPE
   )
      RETURN giisdefaultdistgroup_tab PIPELINED;

   TYPE sharelov_type IS RECORD (
      share_cd     giis_dist_share.share_cd%TYPE,
      share_name   giis_dist_share.trty_name%TYPE
   );

   TYPE sharelov_tab IS TABLE OF sharelov_type;

   FUNCTION get_giiss065_share01_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN sharelov_tab PIPELINED;

   FUNCTION get_giiss065_share999_lov (p_line_cd VARCHAR2, p_keyword VARCHAR2)
      RETURN sharelov_tab PIPELINED;

   PROCEDURE val_existingperilrecord_rec (
      p_default_no   giis_default_dist.default_no%TYPE,
      p_line_cd      giis_default_dist.line_cd%TYPE
   );

   PROCEDURE val_adddefaultdistgroup_rec (
      p_default_no   giis_default_dist_group.default_no%TYPE,
      p_share_cd     giis_default_dist_group.share_cd%TYPE
   );

   PROCEDURE set_giisdefaultdistgroup_rec (
      p_rec   giis_default_dist_group%ROWTYPE
   );

   PROCEDURE del_giisdefaultdistgroup_rec (
      p_default_no   giis_default_dist_group.default_no%TYPE,
      p_sequence     giis_default_dist_group.SEQUENCE%TYPE
   );

   TYPE giisdefaultdistdtl_type IS RECORD (
      default_no   giis_default_dist_dtl.default_no%TYPE,
      range_from   giis_default_dist_dtl.range_from%TYPE,
      range_to     giis_default_dist_dtl.range_to%TYPE
   );

   TYPE giisdefaultdistdtl_tab IS TABLE OF giisdefaultdistdtl_type;

   FUNCTION get_giisdefaultdistdtl_list (
      p_default_no   giis_default_dist_dtl.default_no%TYPE
   )
      RETURN giisdefaultdistdtl_tab PIPELINED;

   TYPE validate_save_exist_type IS RECORD (
      v_exists   VARCHAR2 (1)
   );

   TYPE validate_save_exist_tab IS TABLE OF validate_save_exist_type;

   FUNCTION validate_save_exist (
      p_line_cd        giis_default_dist.line_cd%TYPE,
      p_subline_cd     giis_default_dist.subline_cd%TYPE,
      p_iss_cd         giis_default_dist.iss_cd%TYPE,
      p_dist_type      giis_default_dist.dist_type%TYPE,
      p_default_type   giis_default_dist.default_type%TYPE
   )
      RETURN validate_save_exist_tab PIPELINED;
    PROCEDURE set_giisdefaultdistdtl_rec (
      p_rec   giis_default_dist_dtl%ROWTYPE
    );
    PROCEDURE del_giisdefaultdistdtl_rec (
     p_default_no   giis_default_dist_dtl.default_no%TYPE,
     p_range_from   giis_default_dist_dtl.range_from%TYPE,
     p_range_to     giis_default_dist_dtl.range_to%TYPE
    );
    
    FUNCTION get_giisdefaultdistgroup_list2 (
      p_default_no        giis_default_dist_dtl.default_no%TYPE,
      p_sequence          giis_default_dist_group.SEQUENCE%TYPE,
      p_dsp_treaty_name   giis_dist_share.trty_name%TYPE,
      p_share_pct         giis_default_dist_group.share_pct%TYPE,
      p_share_amt1        giis_default_dist_group.share_amt1%TYPE,
      p_range_from        giis_default_dist_dtl.range_from%TYPE,
      p_range_to          giis_default_dist_dtl.range_to%TYPE
    )
      RETURN giisdefaultdistgroup_tab PIPELINED;
    PROCEDURE get_max_sequence_no (
      p_default_no   IN    giis_default_dist_group.default_no%TYPE,
      p_sequence     OUT   giis_default_dist_group.sequence%TYPE
    );
END;
/


