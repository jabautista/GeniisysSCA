CREATE OR REPLACE PACKAGE CPI.giiss107_pkg
AS
   TYPE rec_type IS RECORD (
      accessory_cd     giis_accessory.accessory_cd%TYPE,
      accessory_desc   giis_accessory.accessory_desc%TYPE,
      acc_amt          giis_accessory.acc_amt%TYPE,
      remarks          giis_accessory.remarks%TYPE,
      user_id          giis_accessory.user_id%TYPE,
      last_update      VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_accessory_cd     giis_accessory.accessory_cd%TYPE,
      p_accessory_desc   giis_accessory.accessory_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_accessory%ROWTYPE);

   PROCEDURE del_rec (p_accessory_cd giis_accessory.accessory_cd%TYPE);

   PROCEDURE val_del_rec (p_accessory_cd giis_accessory.accessory_cd%TYPE);

   PROCEDURE val_add_rec (p_accessory_desc giis_accessory.accessory_desc%TYPE);
END;
/


