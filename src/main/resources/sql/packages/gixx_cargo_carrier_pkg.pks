CREATE OR REPLACE PACKAGE CPI.GIXX_CARGO_CARRIER_PKG AS

  TYPE pol_doc_carrier_type IS RECORD(
         EXTRACT_ID            GIXX_CARGO_CARRIER.EXTRACT_ID%TYPE,
         CCARRIER_ITEM_NO      GIXX_CARGO_CARRIER.ITEM_NO%TYPE,
         CCARRIER_VESSEL_CD    GIXX_CARGO_CARRIER.VESSEL_CD%TYPE,
		 CCARRIER_VESSEL_NAME  VARCHAR2(200),
         CCARRIER_PLATE_NO     GIIS_VESSEL.PLATE_NO%TYPE,
		 CCARRIER_MOTOR_NO     GIIS_VESSEL.MOTOR_NO%TYPE,
		 CCARRIER_SERIAL_NO    GIIS_VESSEL.SERIAL_NO%TYPE,
		 CCARRIER_ETA          GIXX_CARGO_CARRIER.ETA%TYPE,
		 CCARRIER_ETD          GIXX_CARGO_CARRIER.ETD%TYPE,
		 CCARRIER_ORIGIN       GIXX_CARGO_CARRIER.ORIGIN%TYPE,
		 CCARRIER_DESTN        GIXX_CARGO_CARRIER.DESTN%TYPE,
		 CCARRIER_VESSEL_FLAG  GIIS_VESSEL.VESSEL_FLAG%TYPE,
		 CCARRIER_VOY_LIMIT    GIXX_CARGO_CARRIER.VOY_LIMIT%TYPE
         );
      
  TYPE pol_doc_carrier_tab IS TABLE OF pol_doc_carrier_type;
  
  FUNCTION get_pol_doc_carrier(p_extract_id	  GIXX_CARGO.extract_id%TYPE,
  		   				       p_item_no	  GIXX_CARGO.item_no%TYPE)
    RETURN pol_doc_carrier_tab PIPELINED;
	
  FUNCTION check_ccarrier_exist(p_extract_id   GIXX_CARGO_CARRIER.extract_id%TYPE) 
    RETURN VARCHAR2;
  
  FUNCTION get_pack_pol_doc_carrier(p_extract_id   GIXX_CARGO.extract_id%TYPE,
                                    p_policy_id    GIXX_CARGO.policy_id%TYPE,
                                    p_item_no      GIXX_CARGO.item_no%TYPE)
    RETURN pol_doc_carrier_tab PIPELINED;
    
    
  -- added by Kris 03.07.2013 for GIPIS101
  TYPE cargo_carrier_type IS RECORD (
    extract_id      gixx_cargo_carrier.extract_id%TYPE,
    item_no         gixx_cargo_carrier.item_no%TYPE,
    vessel_cd       gixx_cargo_carrier.vessel_cd%TYPE,
    vessel_name     giis_vessel.vessel_name%TYPE
  );
  
  TYPE cargo_carrier_tab IS TABLE OF cargo_carrier_type;
  
  FUNCTION get_cargo_carrier_list (
    p_extract_id        gixx_cargo_carrier.extract_id%TYPE,
    p_item_no           GIXX_CARGO_CARRIER.ITEM_NO%TYPE
  ) RETURN cargo_carrier_tab PIPELINED;
  -- end 03.07.2013 for GIPIS101

END GIXX_CARGO_CARRIER_PKG;
/


