CREATE OR REPLACE PACKAGE CPI.giiss117_pkg
AS
   TYPE rec_type IS RECORD (
      type_of_body_cd     giis_type_of_body.type_of_body_cd%TYPE,
      type_of_body        giis_type_of_body.type_of_body%TYPE,
      remarks             giis_type_of_body.remarks%TYPE,
      user_id             giis_type_of_body.user_id%TYPE,
      last_update         DATE
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_type_of_body%ROWTYPE);

   PROCEDURE del_rec (p_type_of_body_cd giis_type_of_body.type_of_body_cd%TYPE);

   FUNCTION val_del_rec (p_type_of_body_cd  giis_type_of_body.type_of_body_cd%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_type_of_body  VARCHAR2);
   
END;
/


