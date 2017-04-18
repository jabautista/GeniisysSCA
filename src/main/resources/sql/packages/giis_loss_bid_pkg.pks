CREATE OR REPLACE PACKAGE CPI.giis_loss_bid_pkg
AS
   TYPE lost_bid_reason_list_type IS RECORD (
      reason_cd     giis_lost_bid.reason_cd%TYPE,
      reason_desc   giis_lost_bid.reason_desc%TYPE,
      remarks       giis_lost_bid.remarks%TYPE,
      line_cd       giis_lost_bid.line_cd%TYPE,
      line_name     giis_line.line_name%TYPE,
      user_id       giis_line.user_id%TYPE,
      last_update   VARCHAR2 (30),
      active_tag    giis_lost_bid.active_tag%TYPE --carlo 01-27-2017 SR 5915
   );

   TYPE lost_bid_reason_list_tab IS TABLE OF lost_bid_reason_list_type;

   FUNCTION get_lost_bid_reason_list (p_line_cd giis_lost_bid.line_cd%TYPE)
      RETURN lost_bid_reason_list_tab PIPELINED;

   FUNCTION get_reason_desc (p_reason_cd NUMBER)
      RETURN VARCHAR2;

   FUNCTION get_reasons_for_denial (p_user_id VARCHAR2)
      RETURN lost_bid_reason_list_tab PIPELINED;

   PROCEDURE set_lost_bid (p_reason IN giis_lost_bid%ROWTYPE);

   PROCEDURE del_lost_bid (p_reason_cd IN giis_lost_bid.reason_cd%TYPE);

   FUNCTION val_update_rec (p_reason_cd giis_lost_bid.reason_cd%TYPE)
      RETURN VARCHAR2;

   PROCEDURE set_rec (p_rec giis_lost_bid%ROWTYPE);

   PROCEDURE del_rec (
      p_line_cd     giis_lost_bid.line_cd%TYPE,
      p_reason_cd   giis_lost_bid.reason_cd%TYPE
   );

   PROCEDURE val_del_rec (p_reason_cd giis_lost_bid.reason_cd%TYPE);

   PROCEDURE val_add_rec (p_reason_cd giis_lost_bid.reason_cd%TYPE);
END giis_loss_bid_pkg;
/


