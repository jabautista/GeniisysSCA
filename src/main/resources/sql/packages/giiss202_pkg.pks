CREATE OR REPLACE PACKAGE CPI.giiss202_pkg
AS
   TYPE iss_lov_type IS RECORD (
      iss_cd     giis_issource.iss_cd%TYPE,
      iss_name   giis_issource.iss_name%TYPE
   );

   TYPE iss_lov_tab IS TABLE OF iss_lov_type;

   FUNCTION get_iss_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN iss_lov_tab PIPELINED;

   FUNCTION get_copy_iss_lov
      RETURN iss_lov_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_iss_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   TYPE subline_lov_type IS RECORD (
      subline_cd     giis_subline.subline_cd%TYPE,
      subline_name   giis_subline.subline_name%TYPE
   );

   TYPE subline_lov_tab IS TABLE OF subline_lov_type;

   FUNCTION get_subline_lov (p_line_cd VARCHAR2, p_user_id VARCHAR2)
      RETURN subline_lov_tab PIPELINED;

   TYPE rec_type IS RECORD (
      iss_cd        giis_spl_override_rt.iss_cd%TYPE,
      intm_no       giis_spl_override_rt.intm_no%TYPE,
      line_cd       giis_spl_override_rt.line_cd%TYPE,
      subline_cd    giis_spl_override_rt.subline_cd%TYPE,
      peril_cd      giis_spl_override_rt.peril_cd%TYPE,
      peril_name    giis_peril.peril_name%TYPE,
      comm_rate     giis_spl_override_rt.comm_rate%TYPE,
      user_id       giis_spl_override_rt.user_id%TYPE,
      last_update   VARCHAR2 (50),
      remarks       giis_spl_override_rt.remarks%TYPE
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN rec_tab PIPELINED;

   TYPE peril_lov_type IS RECORD (
      peril_cd        giis_peril.peril_cd%TYPE,
      peril_name      giis_peril.peril_name%TYPE,
      peril_meaning   cg_ref_codes.rv_meaning%TYPE
   );

   TYPE peril_lov_tab IS TABLE OF peril_lov_type;

   FUNCTION get_peril_lov (p_line_cd VARCHAR2, p_selected_perils VARCHAR2)
      RETURN peril_lov_tab PIPELINED;

   FUNCTION get_selected_perils (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2
   )
      RETURN VARCHAR2;

   PROCEDURE set_rec (p_rec giis_spl_override_rt%ROWTYPE);

   PROCEDURE del_rec (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_peril_cd     VARCHAR2
   );

   PROCEDURE populate (
      p_iss_cd       VARCHAR2,
      p_intm_no      VARCHAR2,
      p_line_cd      VARCHAR2,
      p_subline_cd   VARCHAR2,
      p_user_id      VARCHAR2
   );

   PROCEDURE COPY (
      p_intm_no_from   VARCHAR2,
      p_iss_cd_from    VARCHAR2,
      p_intm_no_to     VARCHAR2,
      p_iss_cd_to      VARCHAR2,
      p_line_cd        VARCHAR2,
      p_subline_cd     VARCHAR2,
      p_user_id        VARCHAR2
   );

   TYPE history_type IS RECORD (
      iss_cd          giis_spl_override_rt_hist.iss_cd%TYPE,
      intm_no         giis_spl_override_rt_hist.intm_no%TYPE,
      line_cd         giis_spl_override_rt_hist.line_cd%TYPE,
      subline_cd      giis_spl_override_rt_hist.subline_cd%TYPE,
      peril_cd        giis_spl_override_rt_hist.peril_cd%TYPE,
      peril_name      giis_peril.peril_name%TYPE,
      old_comm_rate   giis_spl_override_rt_hist.old_comm_rate%TYPE,
      new_comm_rate   giis_spl_override_rt_hist.new_comm_rate%TYPE,
      eff_date        VARCHAR2 (10),
      expiry_date     VARCHAR2 (10)
   );
   
   TYPE history_tab IS TABLE OF history_type;
   
   FUNCTION get_history(
      p_iss_cd       giis_spl_override_rt_hist.iss_cd%TYPE,
      p_intm_no      giis_spl_override_rt_hist.intm_no%TYPE,
      p_line_cd      giis_spl_override_rt_hist.line_cd%TYPE,
      p_subline_cd   giis_spl_override_rt_hist.subline_cd%TYPE,
      p_old_comm_rate giis_spl_override_rt_hist.old_comm_rate%TYPE,
      p_new_comm_rate giis_spl_override_rt_hist.new_comm_rate%TYPE
   )
      RETURN history_tab PIPELINED;
   
END;
/


