CREATE OR REPLACE PACKAGE CPI.GIISS082_PKG
AS
   
   TYPE intm_rate_type IS RECORD(
      intm_no                 giis_intm_special_rate.intm_no%TYPE,
      iss_cd                  giis_intm_special_rate.iss_cd%TYPE,
      peril_cd                giis_intm_special_rate.peril_cd%TYPE,
      peril_name              giis_peril.peril_name%TYPE,
      rate                    giis_intm_special_rate.rate%TYPE,
      line_cd                 giis_intm_special_rate.line_cd%TYPE,
      override_tag            giis_intm_special_rate.override_tag%TYPE,
      user_id                 giis_intm_special_rate.user_id%TYPE,
      last_update             VARCHAR2(50),
      remarks                 giis_intm_special_rate.remarks%TYPE,
      subline_cd              giis_intm_special_rate.subline_cd%TYPE
   );
   TYPE intm_rate_tab IS TABLE OF intm_rate_type;
   
   TYPE intm_rate_hist_type IS RECORD(
      eff_date                VARCHAR2(50),
      expiry_date             VARCHAR2(50),
      peril_name              giis_peril.peril_name%TYPE,
      old_comm_rate           giis_intm_special_rate_hist.old_comm_rate%TYPE,
      new_comm_rate           giis_intm_special_rate_hist.new_comm_rate%TYPE,
      override_tag            giis_intm_special_rate_hist.override_tag%TYPE
   );
   TYPE intm_rate_hist_tab IS TABLE OF intm_rate_hist_type;
   
   TYPE intm_lov_type IS RECORD(
      intm_no                 giis_intermediary.intm_no%TYPE,
      intm_name               giis_intermediary.intm_name%TYPE
   );
   TYPE intm_lov_tab IS TABLE OF intm_lov_type;
   
   TYPE iss_cd_lov_type IS RECORD(
      iss_cd                  giis_issource.iss_cd%TYPE,
      iss_name                giis_issource.iss_name%TYPE
   );
   TYPE iss_cd_lov_tab IS TABLE OF iss_cd_lov_type;
   
   TYPE line_lov_type IS RECORD(
      line_cd                 giis_line.line_cd%TYPE,
      line_name               giis_line.line_name%TYPE
   );
   TYPE line_lov_tab IS TABLE OF line_lov_type;
   
   TYPE subline_lov_type IS RECORD(
      subline_cd              giis_subline.subline_cd%TYPE,
      subline_name            giis_subline.subline_name%TYPE
   );
   TYPE subline_lov_tab IS TABLE OF subline_lov_type;
   
   TYPE peril_lov_type IS RECORD(
      peril_cd                giis_peril.peril_cd%TYPE,
      peril_name              giis_peril.peril_name%TYPE,
      peril_type              cg_ref_codes.rv_meaning%TYPE
   );
   TYPE peril_lov_tab IS TABLE OF peril_lov_type;
   
   FUNCTION get_intm_rate_list(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_rate                  giis_intm_special_rate.rate%TYPE,
      p_override_tag          giis_intm_special_rate.override_tag%TYPE
   )
     RETURN intm_rate_tab PIPELINED;
     
   FUNCTION get_history_list(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_eff_date              VARCHAR2,
      p_expiry_date           VARCHAR2,
      p_old_comm_rt           giis_intm_special_rate_hist.old_comm_rate%TYPE,
      p_new_comm_rt           giis_intm_special_rate_hist.new_comm_rate%TYPE,
      p_override_tag          giis_intm_special_rate.override_tag%TYPE
   )
     RETURN intm_rate_hist_tab PIPELINED;
     
   FUNCTION get_intm_lov(
      p_find_text             VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED;
     
   FUNCTION get_iss_cd_lov(
      p_line_cd               giis_line.line_cd%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN iss_cd_lov_tab PIPELINED;
     
   FUNCTION get_line_cd_lov(
      p_iss_cd                giis_issource.iss_cd%TYPE,
      p_user_id               giis_users.user_id%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN line_lov_tab PIPELINED;
     
   FUNCTION get_subline_cd_lov(
      p_line_cd               giis_line.line_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED;
     
   FUNCTION get_peril_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN peril_lov_tab PIPELINED;
     
   FUNCTION get_copy_intm_lov(
      p_find_text             VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED;
     
   FUNCTION get_copy_iss_cd_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN iss_cd_lov_tab PIPELINED;
   
   FUNCTION get_copy_line_cd_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN line_lov_tab PIPELINED;
     
   FUNCTION get_copy_subline_cd_lov(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED;
     
   PROCEDURE populate_perils(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_user_id               giis_intm_special_rate.user_id%TYPE
   );
   
   PROCEDURE set_rec(
      p_rec                   giis_intm_special_rate%ROWTYPE
   );
   
   PROCEDURE del_rec(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_peril_cd              giis_intm_special_rate.peril_cd%TYPE
   );
   
   PROCEDURE copy_intm_rate_giiss082(
      p_intm_no_to            giis_intm_special_rate.intm_no%TYPE,
      p_intm_no_from          giis_intm_special_rate.intm_no%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE,
      p_user_id               giis_intm_special_rate.user_id%TYPE
   );
   
   FUNCTION get_peril_list(
      p_intm_no               giis_intm_special_rate.intm_no%TYPE,
      p_iss_cd                giis_intm_special_rate.iss_cd%TYPE,
      p_line_cd               giis_intm_special_rate.line_cd%TYPE,
      p_subline_cd            giis_intm_special_rate.subline_cd%TYPE
   )
     RETURN VARCHAR2;
   
END;
/


