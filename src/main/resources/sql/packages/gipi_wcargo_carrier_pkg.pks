CREATE OR REPLACE PACKAGE CPI.GIPI_WCARGO_CARRIER_PKG
AS

  TYPE gipi_carrier_list_type IS RECORD(
        vessel_cd                giis_vessel.vessel_cd%TYPE,
        vessel_name                giis_vessel.vessel_name%TYPE,
        serial_no                giis_vessel.serial_no%TYPE,
        motor_no                giis_vessel.motor_no%TYPE,
        plate_no                giis_vessel.plate_no%TYPE,
        par_id                    gipi_wcargo_carrier.par_id%TYPE,
        item_no                    gipi_wcargo_carrier.item_no%TYPE,
        vessel_limit_of_liab    gipi_wcargo_carrier.vessel_limit_of_liab%TYPE,
        eta                        gipi_wcargo_carrier.eta%TYPE,
        etd                        gipi_wcargo_carrier.etd%TYPE,
        origin                    gipi_wcargo_carrier.origin%TYPE,
        destn                    gipi_wcargo_carrier.destn%TYPE,
        delete_sw                gipi_wcargo_carrier.delete_sw%TYPE,
        voy_limit                gipi_wcargo_carrier.voy_limit%TYPE,
        user_id                    gipi_wcargo_carrier.user_id%TYPE);
      
  TYPE gipi_carrier_list_tab IS TABLE OF gipi_carrier_list_type;
  
  FUNCTION get_gipi_wcargo_carrier(p_par_id    GIPI_WCARGO_CARRIER.par_id%TYPE)
    RETURN gipi_carrier_list_tab PIPELINED;
  
  PROCEDURE del_gipi_wcargo_carrier(p_par_id    GIPI_WCARGO_CARRIER.par_id%TYPE,
                                      p_item_no   GIPI_WCARGO_CARRIER.item_no%TYPE);

  PROCEDURE del_gipi_wcargo_carrier2(p_par_id    GIPI_WCARGO_CARRIER.par_id%TYPE,
                                      p_item_no   GIPI_WCARGO_CARRIER.item_no%TYPE,
                                    p_vessel_cd GIPI_WCARGO_CARRIER.vessel_cd%TYPE);            
                                    
  PROCEDURE set_gipi_cargo_carrier(
           p_par_id                   GIPI_WCARGO_CARRIER.par_id%TYPE,
         p_item_no                      GIPI_WCARGO_CARRIER.item_no%TYPE,
         p_vessel_cd                GIPI_WCARGO_CARRIER.vessel_cd%TYPE, 
         p_vessel_limit_of_liab    GIPI_WCARGO_CARRIER.vessel_limit_of_liab%TYPE,
         p_eta                          GIPI_WCARGO_CARRIER.eta%TYPE,
         p_etd                          GIPI_WCARGO_CARRIER.etd%TYPE,
         p_origin                   GIPI_WCARGO_CARRIER.origin%TYPE,
         p_destn                   GIPI_WCARGO_CARRIER.destn%TYPE,
         p_delete_sw               GIPI_WCARGO_CARRIER.delete_sw%TYPE,
         p_voy_limit               GIPI_WCARGO_CARRIER.voy_limit%TYPE,
         p_user_id                   VARCHAR2);                                

    FUNCTION get_gipi_wcargo_carrier_tg(
        p_par_id IN gipi_wcargo_carrier.par_id%TYPE,
        p_item_no IN gipi_wcargo_carrier.item_no%TYPE,
        p_vessel_name IN VARCHAR2,
        p_plate_no IN VARCHAR2,
        p_motor_no IN VARCHAR2,
        p_serial_no IN VARCHAR2)
    RETURN gipi_carrier_list_tab PIPELINED;
END GIPI_WCARGO_CARRIER_PKG;
/


