CREATE OR REPLACE PACKAGE CPI.giiss210_pkg
AS
   TYPE rec_type IS RECORD (
      non_ren_reason_cd     giis_non_renew_reason.non_ren_reason_cd%TYPE,
      non_ren_reason_desc  giis_non_renew_reason.non_ren_reason_desc%TYPE,
	  line_cd				giis_non_renew_reason.line_cd%TYPE,
      remarks     giis_non_renew_reason.remarks%TYPE,
      user_id     giis_non_renew_reason.user_id%TYPE,
      last_update VARCHAR2 (30),
      active_tag  giis_non_renew_reason.active_tag%TYPE --carlo 01-27-2017
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   TYPE rec_line_type IS RECORD (
	  line_cd	  giis_non_renew_reason.line_cd%TYPE,
      line_name   giis_line.line_name%TYPE
   ); 

   TYPE rec_line_tab IS TABLE OF rec_line_type;

   FUNCTION get_rec_list (
      p_user_id               giis_non_renew_reason.user_id%TYPE
   )
      RETURN rec_tab PIPELINED;

   FUNCTION get_line_rec_list (
      p_user_id               giis_non_renew_reason.user_id%TYPE
   )
      RETURN rec_line_tab PIPELINED;      

   PROCEDURE set_rec (p_rec giis_non_renew_reason%ROWTYPE);

   PROCEDURE del_rec (p_non_ren_reason_cd giis_non_renew_reason.non_ren_reason_cd%TYPE);

   PROCEDURE val_del_rec (p_non_ren_reason_cd giis_non_renew_reason.non_ren_reason_cd%TYPE);
   
   PROCEDURE val_add_rec(
       p_non_ren_reason_cd   giis_non_renew_reason.non_ren_reason_cd%TYPE,
       p_non_ren_reason_desc giis_non_renew_reason.non_ren_reason_desc%TYPE
   );
   
END;
/


