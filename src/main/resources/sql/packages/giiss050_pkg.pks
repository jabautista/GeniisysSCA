CREATE OR REPLACE PACKAGE CPI.giiss050_pkg
AS
   TYPE rec_type IS RECORD (
      vessel_cd    giis_vessel.vessel_cd%TYPE,
      vessel_name  giis_vessel.vessel_name%TYPE,
      reg_owner    giis_vessel.reg_owner%TYPE,
      plate_no     giis_vessel.plate_no%TYPE,
      motor_no     giis_vessel.motor_no%TYPE,
      serial_no    giis_vessel.serial_no%TYPE,
      origin       giis_vessel.origin%TYPE,
      destination  giis_vessel.destination%TYPE,
      remarks      giis_vessel.remarks%TYPE,
      user_id      giis_vessel.user_id%TYPE,
      last_update  VARCHAR2 (30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_vessel%ROWTYPE);

   PROCEDURE del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE);

   PROCEDURE val_del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE);
   
   PROCEDURE val_add_rec(p_vessel_cd giis_vessel.vessel_cd%TYPE);
   
END;
/


