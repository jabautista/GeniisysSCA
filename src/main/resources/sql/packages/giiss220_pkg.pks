CREATE OR REPLACE PACKAGE CPI.GIISS220_PKG
AS

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
   
   TYPE peril_type IS RECORD(
      line_cd                 giis_peril.line_cd%TYPE,
      subline_cd              giis_peril.subline_cd%TYPE,
      peril_cd                giis_peril.peril_cd%TYPE,
      peril_sname             giis_peril.peril_sname%TYPE,
      peril_name              giis_peril.peril_name%TYPE,
      default_rate            giis_peril.default_rate%TYPE
   );
   TYPE peril_tab IS TABLE OF peril_type;
   
   TYPE slid_comm_type IS RECORD(
      line_cd                 giis_slid_comm.line_cd%TYPE,
      subline_cd              giis_slid_comm.subline_cd%TYPE,
      peril_cd                giis_slid_comm.peril_cd%TYPE,
      lo_prem_lim             giis_slid_comm.lo_prem_lim%TYPE,
      hi_prem_lim             giis_slid_comm.hi_prem_lim%TYPE,
      slid_comm_rt            giis_slid_comm.slid_comm_rt%TYPE,
      remarks                 giis_slid_comm.remarks%TYPE,
      user_id                 giis_slid_comm.user_id%TYPE,
      last_update             VARCHAR(50),
      old_lo_prem_lim         giis_slid_comm.lo_prem_lim%TYPE,
      old_hi_prem_lim         giis_slid_comm.hi_prem_lim%TYPE
   );
   TYPE slid_comm_tab IS TABLE OF slid_comm_type;
   
   TYPE history_type IS RECORD(
      line_cd                 giis_slid_comm_hist.line_cd%TYPE,
      subline_cd              giis_slid_comm_hist.subline_cd%TYPE,
      peril_cd                giis_slid_comm_hist.peril_cd%TYPE,
      old_lo_prem_lim         giis_slid_comm_hist.old_lo_prem_lim%TYPE,
      lo_prem_lim             giis_slid_comm_hist.lo_prem_lim%TYPE,
      old_hi_prem_lim         giis_slid_comm_hist.old_hi_prem_lim%TYPE,
      hi_prem_lim             giis_slid_comm_hist.hi_prem_lim%TYPE,
      old_slid_comm_rt        giis_slid_comm_hist.old_slid_comm_rt%TYPE,
      slid_comm_rt            giis_slid_comm_hist.slid_comm_rt%TYPE,
      user_id                 giis_slid_comm_hist.user_id%TYPE,
      last_update             VARCHAR2(50)
   );
   TYPE history_tab IS TABLE OF history_type;
   
   TYPE rate_type IS RECORD(
      lo_prem_lim             giis_slid_comm_hist.lo_prem_lim%TYPE,
      hi_prem_lim             giis_slid_comm_hist.hi_prem_lim%TYPE
   );
   TYPE rate_tab IS TABLE OF rate_type;
   
   FUNCTION get_line_lov(
      p_find_text             VARCHAR2,
      p_user_id               giis_users.user_id%TYPE
   )
     RETURN line_lov_tab PIPELINED;
     
   FUNCTION get_subline_lov(
      p_line_cd               giis_subline.line_cd%TYPE,
      p_find_text             VARCHAR2
   )
     RETURN subline_lov_tab PIPELINED;
     
   FUNCTION get_peril_listing(
      p_line_cd               giis_peril.line_cd%TYPE,
      p_peril_cd              giis_peril.peril_cd%TYPE,
      p_peril_sname           giis_peril.peril_sname%TYPE,
      p_peril_name            giis_peril.peril_name%TYPE,
      p_default_rate          giis_peril.default_rate%TYPE
   )
     RETURN peril_tab PIPELINED;
     
   FUNCTION get_slid_comm_listing(
      p_line_cd               giis_slid_comm.line_cd%TYPE,
      p_subline_cd            giis_slid_comm.subline_cd%TYPE,
      p_peril_cd              giis_slid_comm.peril_cd%TYPE,
      p_lo_prem_lim           giis_slid_comm.lo_prem_lim%TYPE,
      p_hi_prem_lim           giis_slid_comm.hi_prem_lim%TYPE,
      p_slid_comm_rt          giis_slid_comm.slid_comm_rt%TYPE
   )
     RETURN slid_comm_tab PIPELINED;
     
   FUNCTION get_history_listing(
      p_line_cd               giis_slid_comm_hist.line_cd%TYPE,
      p_subline_cd            giis_slid_comm_hist.subline_cd%TYPE,
      p_peril_cd              giis_slid_comm_hist.peril_cd%TYPE,
      p_old_lo_prem_lim       giis_slid_comm_hist.old_lo_prem_lim%TYPE,
      p_lo_prem_lim           giis_slid_comm_hist.lo_prem_lim%TYPE,
      p_old_hi_prem_lim       giis_slid_comm_hist.old_hi_prem_lim%TYPE,
      p_hi_prem_lim           giis_slid_comm_hist.hi_prem_lim%TYPE,
      p_old_slid_comm_rt      giis_slid_comm_hist.old_slid_comm_rt%TYPE,
      p_slid_comm_rt          giis_slid_comm_hist.slid_comm_rt%TYPE
   )
     RETURN history_tab PIPELINED;
     
   PROCEDURE check_rate(
      p_line_cd               giis_slid_comm.line_cd%TYPE,
      p_subline_cd            giis_slid_comm.subline_cd%TYPE,
      p_peril_cd              giis_slid_comm.peril_cd%TYPE,
      p_lo_prem_lim           giis_slid_comm.lo_prem_lim%TYPE,
      p_hi_prem_lim           giis_slid_comm.hi_prem_lim%TYPE,
      p_old_lo_prem_lim       giis_slid_comm.lo_prem_lim%TYPE,
      p_old_hi_prem_lim       giis_slid_comm.hi_prem_lim%TYPE
   );
     
   PROCEDURE set_rec(
      p_rec                   giis_slid_comm%ROWTYPE,
      p_old_lo_prem_lim       giis_slid_comm.lo_prem_lim%TYPE,
      p_old_hi_prem_lim       giis_slid_comm.hi_prem_lim%TYPE
   );
     
   PROCEDURE del_rec(
      p_line_cd               giis_slid_comm.line_cd%TYPE,
      p_subline_cd            giis_slid_comm.subline_cd%TYPE,
      p_peril_cd              giis_slid_comm.peril_cd%TYPE,
      p_lo_prem_lim           giis_slid_comm.lo_prem_lim%TYPE,
      p_hi_prem_lim           giis_slid_comm.hi_prem_lim%TYPE
   );
   
   FUNCTION get_rate_list(
      p_line_cd               giis_slid_comm.line_cd%TYPE,
      p_subline_cd            giis_slid_comm.subline_cd%TYPE,
      p_peril_cd              giis_slid_comm.peril_cd%TYPE
   )
     RETURN rate_tab PIPELINED;

END;
/


