CREATE OR REPLACE PACKAGE CPI.giacs334_pkg
AS
   TYPE rec_type IS RECORD (
      intm_no          giac_intm_pcomm_rt.intm_no%TYPE,
      line_cd          giac_intm_pcomm_rt.line_cd%TYPE,
      line_name        giis_line.line_name%TYPE,
      mgt_exp_rt       giac_intm_pcomm_rt.mgt_exp_rt%TYPE,
      prem_res_rt      giac_intm_pcomm_rt.prem_res_rt%TYPE,
      ln_comm_rt       giac_intm_pcomm_rt.ln_comm_rt%TYPE,
      profit_comm_rt   giac_intm_pcomm_rt.profit_comm_rt%TYPE,
      remarks          giac_intm_pcomm_rt.remarks%TYPE,
      user_id          giac_intm_pcomm_rt.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_intm_no          giac_intm_pcomm_rt.intm_no%TYPE,
      p_line_cd          giac_intm_pcomm_rt.line_cd%TYPE,
      p_mgt_exp_rt       giac_intm_pcomm_rt.mgt_exp_rt%TYPE,
      p_prem_res_rt      giac_intm_pcomm_rt.prem_res_rt%TYPE,
      p_ln_comm_rt       giac_intm_pcomm_rt.ln_comm_rt%TYPE,
      p_profit_comm_rt   giac_intm_pcomm_rt.profit_comm_rt%TYPE
   )
      RETURN rec_tab PIPELINED;

   TYPE intm_lov_type IS RECORD (
      intm_no     giis_intermediary.intm_no%TYPE,
      intm_name   giis_intermediary.intm_name%TYPE
   );

   TYPE intm_lov_tab IS TABLE OF intm_lov_type;

   FUNCTION get_intm_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN intm_lov_tab PIPELINED;

   TYPE line_lov_type IS RECORD (
      line_cd     giis_line.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   );

   TYPE line_lov_tab IS TABLE OF line_lov_type;

   FUNCTION get_line_lov (p_user_id VARCHAR2, p_keyword VARCHAR2)
      RETURN line_lov_tab PIPELINED;

   PROCEDURE val_add_rec (
      p_intm_no   giac_intm_pcomm_rt.intm_no%TYPE,
      p_line_cd   giac_intm_pcomm_rt.line_cd%TYPE
   );

   PROCEDURE set_rec (p_rec giac_intm_pcomm_rt%ROWTYPE);

   PROCEDURE del_rec (
      p_intm_no   giac_intm_pcomm_rt.intm_no%TYPE,
      p_line_cd   giac_intm_pcomm_rt.line_cd%TYPE
   );
END;
/


