CREATE OR REPLACE PACKAGE CPI.Gipi_Quote_Ves_Air_Pkg AS

  TYPE gipi_quote_ves_air_type IS RECORD
    (quote_id      GIPI_QUOTE_VES_AIR.quote_id%TYPE,
     vessel_cd     GIPI_QUOTE_VES_AIR.vessel_cd%TYPE,
     vessel_flag   GIIS_VESSEL.vessel_flag%TYPE,
     vessel_type   VARCHAR2(20),
     vessel_name   GIIS_VESSEL.vessel_name%TYPE,
     rec_flag      GIPI_QUOTE_VES_AIR.rec_flag%TYPE);
     
  TYPE gipi_quote_ves_air_tab IS TABLE OF gipi_quote_ves_air_type;
  
  FUNCTION get_gipi_quote_ves_air (p_quote_id GIPI_QUOTE_VES_AIR.quote_id%TYPE)
    RETURN gipi_quote_ves_air_tab PIPELINED; 
    

  Procedure set_gipi_quote_ves_air (p_carrier IN GIPI_QUOTE_VES_AIR%ROWTYPE);
    
  Procedure del_gipi_quote_ves_air (
    p_quote_id    IN GIPI_QUOTE_VES_AIR.quote_id%TYPE,
    p_vessel_cd   IN GIPI_QUOTE_VES_AIR.vessel_cd%TYPE);        

  Procedure del_all_gipi_quote_ves_air (p_quote_id    IN GIPI_QUOTE_VES_AIR.quote_id%TYPE);
  
  PROCEDURE check_if_quote_ves_air_exist(p_quote_id    IN  GIPI_QUOTE_VES_AIR.quote_id%TYPE,
                                         p_exist       OUT VARCHAR2);
  
END Gipi_Quote_Ves_Air_Pkg;
/


