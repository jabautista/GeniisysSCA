CREATE OR REPLACE PACKAGE CPI.GIXX_CARGO_PKG AS

  TYPE pol_doc_cargo_type IS RECORD(
  	   	 extract_id		  	 		  GIXX_CARGO.extract_id%TYPE,
         cargo_item_no                GIXX_CARGO.item_no%TYPE,
         cargo_geog_cd				  GIXX_CARGO.geog_cd%TYPE,
         cargo_class_cd  	   		  GIXX_CARGO.cargo_class_cd%TYPE,
         cargo_vesel_cd        		  GIXX_CARGO.vessel_cd%TYPE,
		 cargo_bl_awb       		  GIXX_CARGO.bl_awb%TYPE,
		 cargo_origin		   		  GIXX_CARGO.origin%TYPE,
		 cargo_etd			   		  GIXX_CARGO.etd%TYPE,
		 cargo_destn			      GIXX_CARGO.destn%TYPE,
		 cargo_eta			   		  GIXX_CARGO.eta%TYPE,
		 cargo_deduct_text			  GIXX_CARGO.deduct_text%TYPE,
		 cargo_pack_method			  GIXX_CARGO.pack_method%TYPE,
		 cargo_print_tag			  GIXX_CARGO.print_tag%TYPE,
		 cargo_lc_no			      GIXX_CARGO.lc_no%TYPE,
		 cargo_tranship_origin		  GIXX_CARGO.tranship_origin%TYPE,
		 cargo_tranship_dest		  GIXX_CARGO.tranship_destination%TYPE,
		 cargo_voyage_no			  GIXX_CARGO.voyage_no%TYPE,
		 vessel_vessel_cd      		  GIIS_VESSEL.vessel_cd%TYPE,
		 vessel_vessel_name    		  VARCHAR2(200),
         vessel_serial_no  	   		  GIIS_VESSEL.serial_no%TYPE,
		 vessel_motor_no  	   		  GIIS_VESSEL.motor_no%TYPE,
         vessel_plate_no       		  GIIS_VESSEL.plate_no%TYPE,
		 vessel_vestype_cd     		  GIIS_VESSEL.vestype_cd%TYPE
         );
      
  TYPE pol_doc_cargo_tab IS TABLE OF pol_doc_cargo_type;
  
  FUNCTION get_pol_doc_cargo(p_extract_id	  GIXX_CARGO.extract_id%TYPE,
  		   				     p_item_no		  GIXX_CARGO.item_no%TYPE)
    RETURN pol_doc_cargo_tab PIPELINED;
	

  -- added by Kris 03.07.2013 for GIPIS101
  TYPE cargo_type IS RECORD (
    extract_id              gixx_cargo.extract_id%TYPE,
    item_no                 gixx_cargo.item_no%TYPE,
    vessel_cd               gixx_cargo.vessel_cd%TYPE,
    geog_cd                 gixx_cargo.geog_cd%TYPE,  
    cargo_class_cd          gixx_cargo.cargo_class_cd%TYPE,
    pack_method             gixx_cargo.pack_method%TYPE,
    bl_awb                  gixx_cargo.bl_awb%TYPE,
    tranship_origin         gixx_cargo.tranship_origin%TYPE,
    tranship_destination    gixx_cargo.tranship_destination%TYPE,
    deduct_text             gixx_cargo.deduct_text%TYPE,
    cargo_type              gixx_cargo.cargo_type%TYPE,
    lc_no                   gixx_cargo.lc_no%TYPE,
    etd                     gixx_cargo.etd%TYPE,
    eta                     gixx_cargo.eta%TYPE,
    origin                  gixx_cargo.origin%TYPE,
    destn                   gixx_cargo.destn%TYPE,
    print_tag               gixx_cargo.print_tag%TYPE,
    
    geog_desc               giis_geog_class.geog_desc%TYPE,
    cargo_class_desc        giis_cargo_class.cargo_class_desc%TYPE,
    vessel_name             giis_vessel.vessel_name%TYPE,
    cargo_type_desc         giis_cargo_type.cargo_type_desc%TYPE,
    multi_carrier           VARCHAR2(10), -- for multi-carrier button
    print_desc              cg_ref_codes.rv_meaning%TYPE,
    voyage_no               gipi_cargo.voyage_no%TYPE    
  );
  
  TYPE cargo_tab IS TABLE OF cargo_type;
  
  FUNCTION get_cargo_info(
        p_extract_id    gixx_cargo.extract_id%TYPE,
        p_item_no       gixx_cargo.item_no%TYPE,
        p_policy_id     gixx_cargo.policy_id%TYPE
  ) RETURN cargo_tab PIPELINED;
  -- end: for GIPIS101
	

END GIXX_CARGO_PKG;
/


