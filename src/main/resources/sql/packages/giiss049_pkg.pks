CREATE OR REPLACE PACKAGE CPI.giiss049_pkg
AS
   TYPE rec_type IS RECORD (
      vessel_cd          giis_vessel.vessel_cd%TYPE,
      vessel_name        giis_vessel.vessel_name%TYPE,
      vessel_old_name    giis_vessel.vessel_old_name%TYPE,
      rpc_no             giis_vessel.rpc_no%TYPE,     
      year_built         giis_vessel.year_built%TYPE,
      air_type_cd        VARCHAR2(15),  
      air_desc           VARCHAR2(30), 
      no_crew            giis_vessel.no_crew%TYPE,     
      no_pass            giis_vessel.no_pass%TYPE,     
      remarks            giis_vessel.remarks%TYPE,
      user_id            giis_vessel.user_id%TYPE,
      last_update        VARCHAR2(30)
   ); 

   TYPE rec_tab IS TABLE OF rec_type;

   FUNCTION get_rec_list 
      RETURN rec_tab PIPELINED;

   PROCEDURE set_rec (p_rec giis_vessel%ROWTYPE);

   PROCEDURE del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE);

   FUNCTION val_del_rec (p_vessel_cd giis_vessel.vessel_cd%TYPE)
   RETURN VARCHAR2;
   
   PROCEDURE val_add_rec(p_vessel_cd giis_vessel.vessel_cd%TYPE);
   
   TYPE giiss049_lov_type IS RECORD (
      air_type_cd          giis_air_type.air_type_cd%TYPE,
      air_desc             giis_air_type.air_desc%TYPE
   ); 

   TYPE giiss049_lov_tab IS TABLE OF giiss049_lov_type;

   FUNCTION get_giiss049_lov (
        p_search        VARCHAR2
   ) 
      RETURN giiss049_lov_tab PIPELINED;
      
   PROCEDURE validate_air_type_cd(
      p_air_type_cd   IN OUT VARCHAR2,
      p_air_desc      IN OUT VARCHAR2
   );
   
END;
/


