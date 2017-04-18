CREATE OR REPLACE PACKAGE CPI.giiss212_pkg
AS
   TYPE rec_type IS RECORD (
      exist         VARCHAR2 (1),
      spoil_cd      giis_spoilage_reason.spoil_cd%TYPE,
      spoil_desc    giis_spoilage_reason.spoil_desc%TYPE,
      remarks       giis_spoilage_reason.remarks%TYPE,
      user_id       giis_spoilage_reason.user_id%TYPE,
      last_update   VARCHAR2 (30),
      active_tag    giis_spoilage_reason.active_tag%TYPE --carlo 01-27-2017
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_spoil_cd     giis_spoilage_reason.spoil_cd%TYPE,
      p_spoil_desc   giis_spoilage_reason.spoil_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_spoilage_reason%ROWTYPE);

   PROCEDURE del_rec (p_spoil_cd giis_spoilage_reason.spoil_cd%TYPE);

   PROCEDURE val_del_rec (p_spoil_cd giis_spoilage_reason.spoil_cd%TYPE);

   PROCEDURE val_add_rec (p_spoil_cd giis_spoilage_reason.spoil_cd%TYPE);
END;
/


