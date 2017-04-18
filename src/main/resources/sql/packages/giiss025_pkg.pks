CREATE OR REPLACE PACKAGE CPI.giiss025_pkg
AS
   TYPE rec_type IS RECORD (
      ri_type        giis_reinsurer_type.ri_type%TYPE,
      ri_type_desc   giis_reinsurer_type.ri_type_desc%TYPE,
      remarks        giis_reinsurer_type.remarks%TYPE,
      user_id        giis_reinsurer_type.user_id%TYPE,
      last_update    VARCHAR2 (30)
   );

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_ri_type        giis_reinsurer_type.ri_type%TYPE,
      p_ri_type_desc   giis_reinsurer_type.ri_type_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_reinsurer_type%ROWTYPE);

   PROCEDURE del_rec (p_ri_type giis_reinsurer_type.ri_type%TYPE);

   PROCEDURE val_del_rec (p_ri_type giis_reinsurer_type.ri_type%TYPE);

   PROCEDURE val_add_rec (p_ri_type giis_reinsurer_type.ri_type%TYPE);
END;
/


