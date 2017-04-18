CREATE OR REPLACE PACKAGE CPI.giiss201_pkg
AS
   
   TYPE rec_type IS RECORD(
      iss_cd               giis_intmdry_type_rt.iss_cd%TYPE,
      intm_type            giis_intmdry_type_rt.intm_type%TYPE,
      line_cd              giis_intmdry_type_rt.line_cd%TYPE,
      peril_cd             giis_intmdry_type_rt.peril_cd%TYPE,
      comm_rate            giis_intmdry_type_rt.comm_rate%TYPE,
      user_id              giis_intmdry_type_rt.user_id%TYPE,
      last_update          giis_intmdry_type_rt.last_update%TYPE,
      remarks              giis_intmdry_type_rt.remarks%TYPE,
      subline_cd           giis_intmdry_type_rt.subline_cd%TYPE,
      dsp_last_update      VARCHAR2(50),
      peril_name           giis_peril.peril_name%TYPE
   ); 
   TYPE rec_tab IS TABLE OF rec_type;
   
   TYPE rec_hist_type IS RECORD(
      peril_name           giis_peril.peril_name%TYPE,
      old_comm_rate        giis_intmdry_type_rt_hist.old_comm_rate%TYPE,
      new_comm_rate        giis_intmdry_type_rt_hist.old_comm_rate%TYPE,
      dsp_eff_date         VARCHAR2(50),
      dsp_expiry_date      VARCHAR2(50)
   ); 
   TYPE rec_hist_tab IS TABLE OF rec_hist_type;

   TYPE iss_cd_lov_type IS RECORD(
      iss_cd               giis_issource.iss_cd%TYPE,
      iss_name             giis_issource.iss_name%TYPE
   );
   TYPE iss_cd_lov_tab IS TABLE OF iss_cd_lov_type;
   
   TYPE intm_lov_type IS RECORD(
      intm_type            giis_intm_type.intm_type%TYPE,
      intm_name            giis_intm_type.intm_desc%TYPE
   );
   TYPE intm_lov_tab IS TABLE OF intm_lov_type;
   
   TYPE line_lov_type IS RECORD(
      line_cd              giis_line.line_cd%TYPE,
      line_name            giis_line.line_name%TYPE
   );
   TYPE line_lov_tab IS TABLE OF line_lov_type;
   
   TYPE subline_lov_type IS RECORD(
      subline_cd           giis_subline.subline_cd%TYPE,
      subline_name         giis_subline.subline_name%TYPE
   );
   TYPE subline_lov_tab IS TABLE OF subline_lov_type;
   
   TYPE peril_lov_type IS RECORD(
      peril_cd           giis_peril.peril_cd%TYPE,
      peril_name         giis_peril.peril_name%TYPE,
      peril_type         cg_ref_codes.rv_meaning%TYPE
   );
   TYPE peril_lov_tab IS TABLE OF peril_lov_type;

   FUNCTION get_iss_cd_lov(
      p_line_cd            giis_line.line_cd%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN iss_cd_lov_tab PIPELINED;
     
   FUNCTION get_intm_type_lov(
      p_find_text          VARCHAR2
   )
     RETURN intm_lov_tab PIPELINED;
     
   FUNCTION get_line_cd_lov(
      p_iss_cd             giis_issource.iss_cd%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN line_lov_tab PIPELINED;
     
   FUNCTION get_subline_cd_lov(
      p_line_cd            giis_line.line_cd%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED;
     
   FUNCTION get_peril_lov(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_find_text          VARCHAR2
   )
     RETURN peril_lov_tab PIPELINED;

   FUNCTION get_rec_list(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_user_id            giis_intmdry_type_rt.user_id%TYPE
   )
     RETURN rec_tab PIPELINED;
     
   FUNCTION get_rec_history(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE
   )
     RETURN rec_hist_tab PIPELINED;

   PROCEDURE set_rec(
      p_rec                giis_intmdry_type_rt%ROWTYPE
   );

   PROCEDURE del_rec(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_peril_cd           giis_intmdry_type_rt.peril_cd%TYPE
   );

   PROCEDURE val_del_rec(
      p_iss_cd             giis_intmdry_type_rt.iss_cd%TYPE,
      p_intm_type          giis_intmdry_type_rt.intm_type%TYPE,
      p_line_cd            giis_intmdry_type_rt.line_cd%TYPE,
      p_subline_cd         giis_intmdry_type_rt.subline_cd%TYPE,
      p_peril_cd           giis_intmdry_type_rt.peril_cd%TYPE
   );
   
END;
/


