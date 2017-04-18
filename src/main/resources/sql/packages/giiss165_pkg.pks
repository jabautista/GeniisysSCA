CREATE OR REPLACE PACKAGE CPI.GIISS165_PKG
AS

   TYPE def_dist_type IS RECORD(
      default_no                 giis_default_dist.default_no%TYPE,
      line_cd                    giis_default_dist.line_cd%TYPE,
      line_name                  giis_line.line_name%TYPE,
      default_type               giis_default_dist.default_type%TYPE,
      default_type_desc          cg_ref_codes.rv_meaning%TYPE,
      dist_type                  giis_default_dist.dist_type%TYPE,
      dist_type_desc             cg_ref_codes.rv_meaning%TYPE,
      subline_cd                 giis_default_dist.subline_cd%TYPE,
      subline_name               giis_subline.subline_name%TYPE,
      iss_cd                     giis_default_dist.iss_cd%TYPE,
      iss_name                   giis_issource.iss_name%TYPE,
      dflt_netret_pct            giis_default_dist.dflt_netret_pct%TYPE,
      user_id                    giis_default_dist.user_id%TYPE,
      last_update                VARCHAR2(50),
      remarks                    giis_default_dist.remarks%TYPE
   );
   TYPE def_dist_tab IS TABLE OF def_dist_type;
   
   TYPE def_dist_dtl_type IS RECORD(
      default_no                 giis_default_dist_dtl.default_no%TYPE,
      line_cd                    giis_default_dist_dtl.line_cd%TYPE,
      subline_cd                 giis_default_dist_dtl.subline_cd%TYPE,
      iss_cd                     giis_default_dist_dtl.iss_cd%TYPE,
      range_from                 giis_default_dist_dtl.range_from%TYPE,
      range_to                   giis_default_dist_dtl.range_to%TYPE
   );
   TYPE def_dist_dtl_tab IS TABLE OF def_dist_dtl_type;
   
   TYPE peril_type IS RECORD(
      line_cd                    giis_peril.line_cd%TYPE,
      peril_cd                   giis_peril.peril_cd%TYPE,
      peril_name                 giis_peril.peril_name%TYPE
   );
   TYPE peril_tab IS TABLE OF peril_type;
   
   TYPE def_dist_peril_type IS RECORD(
      default_no                 giis_default_dist_peril.default_no%TYPE,
      line_cd                    giis_default_dist_peril.line_cd%TYPE,
      peril_cd                   giis_default_dist_peril.peril_cd%TYPE,
      share_cd                   giis_default_dist_peril.share_cd%TYPE,
      trty_name                  giis_dist_share.trty_name%TYPE,
      sequence                   giis_default_dist_peril.sequence%TYPE,
      share_pct                  giis_default_dist_peril.share_pct%TYPE,
      share_amt1                 giis_default_dist_peril.share_amt1%TYPE,
      share_amt2                 giis_default_dist_peril.share_amt2%TYPE,
      user_id                    giis_default_dist_peril.user_id%TYPE,
      last_update                VARCHAR2(50),
      remarks                    giis_default_dist_peril.remarks%TYPE
   );
   TYPE def_dist_peril_tab IS TABLE OF def_dist_peril_type;
   
   TYPE line_lov_type IS RECORD(
      line_cd                    giis_line.line_cd%TYPE,
      line_name                  giis_line.line_name%TYPE
   );
   TYPE line_lov_tab IS TABLE OF line_lov_type;
   
   TYPE subline_lov_type IS RECORD(
      line_cd                    giis_subline.line_cd%TYPE,
      subline_cd                 giis_subline.subline_cd%TYPE,
      subline_name               giis_subline.subline_name%TYPE
   );
   TYPE subline_lov_tab IS TABLE OF subline_lov_type;
   
   TYPE issource_lov_type IS RECORD(
      iss_cd                     giis_issource.iss_cd%TYPE,
      iss_name                   giis_issource.iss_name%TYPE
   );
   TYPE issource_lov_tab IS TABLE OF issource_lov_type;
   
   TYPE dist_type IS RECORD(
      type                       cg_ref_codes.rv_low_value%TYPE,
      meaning                    cg_ref_codes.rv_meaning%TYPE
   );
   TYPE dist_tab IS TABLE OF dist_type;
   
   TYPE share_type IS RECORD(
      line_cd                       giis_dist_share.line_cd%TYPE,
      share_cd                      giis_dist_share.share_cd%TYPE,
      trty_name                     giis_dist_share.trty_name%TYPE
   );
   TYPE share_tab IS TABLE OF share_type;
   
   FUNCTION get_line_lov(
      p_iss_cd                   giis_issource.iss_cd%TYPE,
      p_user_id                  giis_users.user_id%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN line_lov_tab PIPELINED;
     
   FUNCTION get_subline_lov(
      p_line_cd                  giis_subline.line_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED;
     
   FUNCTION get_issource_lov(
      p_line_cd                  giis_line.line_cd%TYPE,
      p_user_id                  giis_users.user_id%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN issource_lov_tab PIPELINED;
     
   FUNCTION get_type_lov(
      p_rv_domain                VARCHAR2,
      p_find_text                VARCHAR2
   )
     RETURN dist_tab PIPELINED;
     
   FUNCTION get_share_lov(
      p_line_cd                  giis_dist_share.line_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN share_tab PIPELINED;
     
   FUNCTION get_share_lov2(
      p_line_cd                  giis_dist_share.line_cd%TYPE,
      p_find_text                VARCHAR2
   )
     RETURN share_tab PIPELINED;
   
   FUNCTION get_def_dist_listing(
      p_user_id                  giis_default_dist.user_id%TYPE,
      p_default_no               giis_default_dist.default_no%TYPE
   )
     RETURN def_dist_tab PIPELINED;
     
   FUNCTION get_def_dist_dtl_listing(
      p_default_no               giis_default_dist_dtl.default_no%TYPE,
      p_range_from               giis_default_dist_dtl.range_from%TYPE,
      p_range_to                 giis_default_dist_dtl.range_from%TYPE
   )
     RETURN def_dist_dtl_tab PIPELINED;
     
   FUNCTION get_peril_listing(
      p_line_cd                  giis_peril.line_cd%TYPE,
      p_peril_name               giis_peril.peril_name%TYPE
   )
     RETURN peril_tab PIPELINED;
     
   FUNCTION get_def_dist_peril_listing(
      p_default_no               giis_default_dist_peril.default_no%TYPE,
      p_line_cd                  giis_default_dist_peril.line_cd%TYPE,
      p_peril_cd                 giis_default_dist_peril.peril_cd%TYPE,
      p_sequence                 giis_default_dist_peril.sequence%TYPE,
      p_share_pct                giis_default_dist_peril.share_pct%TYPE,
      p_share_amt1               giis_default_dist_peril.share_amt1%TYPE
   )
     RETURN def_dist_peril_tab PIPELINED;
     
   PROCEDURE val_del_rec(
      p_default_no               giis_default_dist.default_no%TYPE
   );
   
   PROCEDURE delete_rec(
      p_default_no               giis_default_dist.default_no%TYPE
   );
   
   PROCEDURE val_add_rec(
      p_default_no               giis_default_dist.default_no%TYPE,
      p_line_cd                  giis_default_dist.line_cd%TYPE,
      p_subline_cd               giis_default_dist.subline_cd%TYPE,
      p_iss_cd                   giis_default_dist.iss_cd%TYPE
   );
   
   PROCEDURE add_rec(
      p_rec                      giis_default_dist%ROWTYPE
   );
   
   PROCEDURE get_dist_peril_variables(
      p_default_no         IN    giis_default_dist_peril.default_no%TYPE,
      p_line_cd            IN    giis_default_dist_peril.line_cd%TYPE,
      p_peril_cd           IN    giis_default_dist_peril.peril_cd%TYPE,
      p_max_sequence       OUT   giis_default_dist_peril.sequence%TYPE,
      p_total_share_pct    OUT   giis_default_dist_peril.share_pct%TYPE
   );
     
   PROCEDURE check_dist_records(
      p_default_no               giis_default_dist_peril.default_no%TYPE,
      p_line_cd                  giis_default_dist_peril.line_cd%TYPE
   );
   
   PROCEDURE add_peril(
      p_rec                      giis_default_dist_peril%ROWTYPE
   );
   
   PROCEDURE delete_peril(
      p_default_no               giis_default_dist_peril.default_no%TYPE,
      p_line_cd                  giis_default_dist_peril.line_cd%TYPE,
      p_peril_cd                 giis_default_dist_peril.peril_cd%TYPE,
      p_share_cd                 giis_default_dist_peril.share_cd%TYPE
   );

END;
/


