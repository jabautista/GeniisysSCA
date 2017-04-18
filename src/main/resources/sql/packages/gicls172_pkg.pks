CREATE OR REPLACE PACKAGE CPI.gicls172_pkg
AS
   TYPE rec_type IS RECORD (
      repair_cd   gicl_repair_type.repair_cd%TYPE,
      repair_desc gicl_repair_type.repair_desc%TYPE,
	  required	  gicl_repair_type.required%TYPE,
      remarks     gicl_repair_type.remarks%TYPE,
      user_id     gicl_repair_type.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_repair_cd    gicl_repair_type.repair_cd%TYPE,
      p_repair_desc  gicl_repair_type.repair_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec gicl_repair_type%ROWTYPE);

   PROCEDURE del_rec (p_repair_cd gicl_repair_type.repair_cd%TYPE);
   
   PROCEDURE val_add_rec(p_repair_cd gicl_repair_type.repair_cd%TYPE);
   
   PROCEDURE val_del_rec(p_repair_cd gicl_repair_type.repair_cd%TYPE);  -- shan 08.19.2014
   
END;
/


