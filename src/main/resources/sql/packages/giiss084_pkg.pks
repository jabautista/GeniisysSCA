CREATE OR REPLACE PACKAGE CPI.giiss084_pkg
AS
   TYPE rec_type IS RECORD (
      iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      line_cd          giis_intm_type_comrt.line_cd%TYPE,
      peril_cd         giis_intm_type_comrt.peril_cd%TYPE,
      comm_rate        giis_intm_type_comrt.comm_rate%TYPE,
      subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      dsp_peril_name   giis_peril.peril_name%TYPE,
      remarks          giis_policy_type.remarks%TYPE,
      user_id          giis_policy_type.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_dsp_peril_name   giis_peril.peril_name%TYPE,
      p_comm_rate        giis_intm_type_comrt.comm_rate%TYPE
   )
      RETURN rec_tab PIPELINED;

   TYPE iss_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE iss_lov_tab IS TABLE OF iss_lov_type;

   FUNCTION get_iss_lov (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN iss_lov_tab PIPELINED;

   TYPE cointmtype_lov_type IS RECORD (
      co_intm_type   giis_co_intrmdry_types.co_intm_type%TYPE,
      type_name      giis_co_intrmdry_types.type_name%TYPE
   );

   TYPE cointmtype_lov_tab IS TABLE OF cointmtype_lov_type;

   FUNCTION get_cointmtype_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN cointmtype_lov_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (
      p_iss_cd      giis_issource.iss_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN line_lov_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_subline_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN subline_lov_tab PIPELINED;

   TYPE peril_lov_type IS RECORD (
      peril_cd          giis_peril.peril_cd%TYPE,
      peril_name        giis_peril.peril_name%TYPE,
      peril_type        cg_ref_codes.rv_low_value%TYPE,
      peril_type_desc   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE peril_lov_tab IS TABLE OF peril_lov_type;

   FUNCTION get_peril_lov (
      p_line_cd     giis_line.line_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_keyword     VARCHAR2
   )
      RETURN peril_lov_tab PIPELINED;

   PROCEDURE set_rec (
      p_rec              giis_intm_type_comrt%ROWTYPE
   );

   PROCEDURE del_rec (
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_peril_cd         giis_intm_type_comrt.peril_cd%TYPE
   );

   TYPE histrec_type IS RECORD (
      iss_cd           giis_intm_type_comrt_hist.iss_cd%TYPE,
      co_intm_type     giis_intm_type_comrt_hist.co_intm_type%TYPE,
      line_cd          giis_intm_type_comrt_hist.line_cd%TYPE,
      peril_cd         giis_intm_type_comrt_hist.peril_cd%TYPE,
      old_comm_rate    giis_intm_type_comrt_hist.old_comm_rate%TYPE,
      new_comm_rate    giis_intm_type_comrt_hist.new_comm_rate%TYPE,
      subline_cd       giis_intm_type_comrt_hist.subline_cd%TYPE,
      dsp_peril_name   giis_peril.peril_name%TYPE,
      eff_date         VARCHAR2 (50),
      expiry_date      VARCHAR2 (50)
   );

   TYPE histrec_tab IS TABLE OF histrec_type;

   FUNCTION get_histrec_list (
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_eff_date         VARCHAR2,
      p_expiry_date      VARCHAR2
   )
      RETURN histrec_tab PIPELINED;
      
   PROCEDURE val_add_rec(
      p_iss_cd           giis_intm_type_comrt.iss_cd%TYPE,
      p_co_intm_type     giis_intm_type_comrt.co_intm_type%TYPE,
      p_line_cd          giis_intm_type_comrt.line_cd%TYPE,
      p_subline_cd       giis_intm_type_comrt.subline_cd%TYPE,
      p_peril_cd         giis_peril.peril_cd%TYPE
   );
   
END;
/


