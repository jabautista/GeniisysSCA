CREATE OR REPLACE PACKAGE CPI.gicls184_pkg
AS
   TYPE rec_type IS RECORD (
      nationality_cd   giis_nationality.nationality_cd%TYPE,
      nationality_desc giis_nationality.nationality_desc%TYPE,
      remarks     	   giis_nationality.remarks%TYPE,
      user_id     	   giis_nationality.user_id%TYPE,
      last_update 	   VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list (
      p_nationality_cd     giis_nationality.nationality_cd%TYPE,
      p_nationality_desc  giis_nationality.nationality_desc%TYPE
   )
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_nationality%ROWTYPE);

   PROCEDURE del_rec (p_nationality_cd giis_nationality.nationality_cd%TYPE);

   PROCEDURE val_del_rec (p_nationality_cd giis_nationality.nationality_cd%TYPE);
   
   PROCEDURE val_add_rec(p_nationality_cd giis_nationality.nationality_cd%TYPE);
   
END;
/


