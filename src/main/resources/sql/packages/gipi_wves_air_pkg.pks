CREATE OR REPLACE PACKAGE CPI.Gipi_Wves_Air_Pkg AS

  TYPE gipi_wves_air_type IS RECORD
    (par_id      GIPI_WVES_AIR.par_id%TYPE,
     vessel_cd   GIPI_WVES_AIR.vessel_cd%TYPE,
     vessel_flag GIIS_VESSEL.vessel_flag%TYPE,
     vessel_type VARCHAR2(20),
     vessel_name GIIS_VESSEL.vessel_name%TYPE,
     rec_flag    GIPI_WVES_AIR.rec_flag%TYPE,
     multi_sw       VARCHAR2(1));
     
  TYPE gipi_wves_air_tab IS TABLE OF gipi_wves_air_type;
  
  FUNCTION get_gipi_wves_air (p_par_id GIPI_WVES_AIR.par_id%TYPE)
    RETURN gipi_wves_air_tab PIPELINED;     

  procedure val_multivessel(p_par_id gipi_wves_air.par_id%TYPE);

  Procedure set_gipi_wves_air (p_carrier IN GIPI_WVES_AIR%ROWTYPE);
    
  Procedure del_gipi_wves_air (
    p_par_id    IN GIPI_WVES_AIR.par_id%TYPE,
    p_vessel_cd IN GIPI_WVES_AIR.vessel_cd%TYPE);        

  Procedure del_all_gipi_wves_air (p_par_id    IN GIPI_WVES_AIR.par_id%TYPE); 
  
	Procedure del_gipi_wves_air(p_par_id IN GIPI_WVES_AIR.par_id%TYPE);

END Gipi_Wves_Air_Pkg;
/


