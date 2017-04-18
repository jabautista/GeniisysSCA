CREATE OR REPLACE PACKAGE CPI.giiss073_pkg
AS
   TYPE rec_type IS RECORD (
      status_cd     giis_ri_status.status_cd%TYPE,
      status_desc  giis_ri_status.status_desc%TYPE,
      remarks     giis_ri_status.remarks%TYPE,
      user_id     giis_ri_status.user_id%TYPE,
      last_update VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;
   
   FUNCTION get_rec_list (
      p_status_cd     giis_ri_status.status_cd%TYPE,
      p_status_desc  giis_ri_status.status_desc%TYPE
   ) RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_ri_status%ROWTYPE);

   PROCEDURE del_rec (p_status_cd giis_ri_status.status_cd%TYPE);

   PROCEDURE val_del_rec (p_status_cd giis_ri_status.status_cd%TYPE);
   
   PROCEDURE val_add_rec (
      p_status_cd giis_ri_status.status_cd%TYPE,
      p_status_desc   giis_ri_status.status_desc%TYPE
   );
   
END;
/


