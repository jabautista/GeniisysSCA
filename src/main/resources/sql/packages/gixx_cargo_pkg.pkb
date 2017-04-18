CREATE OR REPLACE PACKAGE BODY CPI.GIXX_CARGO_PKG AS

  FUNCTION get_pol_doc_cargo(p_extract_id	  GIXX_CARGO.extract_id%TYPE,
  		   				     p_item_no		  GIXX_CARGO.item_no%TYPE)
    RETURN pol_doc_cargo_tab PIPELINED IS
    v_cargo					 pol_doc_cargo_type;
  BEGIN
    FOR i IN (SELECT  C.EXTRACT_ID EXTRACT_ID,	
			          C.ITEM_NO CARGO_ITEM_NO, 
					  C.GEOG_CD CARGO_GEOG_CD,	  	
					  C.CARGO_CLASS_CD CARGO_CLASS_CD,
					  C.VESSEL_CD CARGO_VESEL_CD,		
					  C.BL_AWB CARGO_BL_AWB,
					  C.ORIGIN CARGO_ORIGIN,
					  C.ETD	CARGO_ETD,
					  C.DESTN  CARGO_DESTN,		
					  C.ETA    CARGO_ETA,
					  C.DEDUCT_TEXT CARGO_DEDUCT_TEXT,
					  C.PACK_METHOD  CARGO_PACK_METHOD,
			          C.PRINT_TAG CARGO_PRINT_TAG,            
					  C.LC_NO CARGO_LC_NO,
			          C.TRANSHIP_ORIGIN CARGO_TRANSHIP_ORIGIN,      
					  C.TRANSHIP_DESTINATION CARGO_TRANSHIP_DEST,     
					  C.VOYAGE_NO CARGO_VOYAGE_NO,
					  A.VESSEL_CD    VESSEL_VESSEL_CD,
		  	 		  DECODE(A.VESSEL_CD, 'MULTI', A.VESSEL_NAME,A.VESSEL_NAME || ' (' || 
   					  	DECODE(A.VESSEL_FLAG, 'V', 'VESSEL',
		    		  	DECODE(A.VESSEL_FLAG, 'I', 'INLAND', 'AIRCRAFT')) || ')' ) VESSEL_VESSEL_NAME,
                	  A.MOTOR_NO     VESSEL_MOTOR_NO,
					  A.SERIAL_NO    VESSEL_SERIAL_NO, 
					  A.PLATE_NO     VESSEL_PLATE_NO, 
					  A.VESTYPE_CD   VESSEL_VESTYPE_CD
 				FROM  GIXX_CARGO C, GIIS_VESSEL A
 			   WHERE C.EXTRACT_ID = P_EXTRACT_ID
 			     AND C.ITEM_NO = P_ITEM_NO
				 AND A.VESSEL_CD = C.VESSEL_CD(+))
	LOOP
	  v_cargo.EXTRACT_ID 	     := i.EXTRACT_ID;
	  v_cargo.CARGO_ITEM_NO 	 := i.CARGO_ITEM_NO;
	  v_cargo.CARGO_GEOG_CD 	 := i.CARGO_GEOG_CD;
	  v_cargo.CARGO_CLASS_CD 	 := i.CARGO_CLASS_CD;
	  v_cargo.CARGO_VESEL_CD 	 := i.CARGO_VESEL_CD;
	  v_cargo.CARGO_BL_AWB 		 := i.CARGO_BL_AWB;
	  v_cargo.CARGO_ORIGIN 		 := i.CARGO_ORIGIN;
	  v_cargo.CARGO_ETD 		 := i.CARGO_ETD;
	  v_cargo.CARGO_DESTN 		 := i.CARGO_DESTN;
	  v_cargo.CARGO_ETA 		 := i.CARGO_ETA;
	  v_cargo.CARGO_DEDUCT_TEXT  := i.CARGO_DEDUCT_TEXT;
	  v_cargo.CARGO_PACK_METHOD  := i.CARGO_PACK_METHOD;
	  v_cargo.CARGO_PRINT_TAG 	 := i.CARGO_PRINT_TAG;
	  v_cargo.CARGO_LC_NO 		 := i.CARGO_LC_NO;
	  v_cargo.CARGO_TRANSHIP_ORIGIN := i.CARGO_TRANSHIP_ORIGIN;
	  v_cargo.CARGO_TRANSHIP_DEST := i.CARGO_TRANSHIP_DEST;
	  v_cargo.CARGO_VOYAGE_NO 	  := i.CARGO_VOYAGE_NO;
	  v_cargo.VESSEL_VESSEL_CD    := i.VESSEL_VESSEL_CD;
	  v_cargo.VESSEL_VESSEL_NAME  := i.VESSEL_VESSEL_NAME;
	  v_cargo.VESSEL_MOTOR_NO 	  := i.VESSEL_MOTOR_NO;
	  v_cargo.VESSEL_SERIAL_NO    := i.VESSEL_SERIAL_NO;
	  v_cargo.VESSEL_PLATE_NO 	  := i.VESSEL_PLATE_NO;
	  v_cargo.VESSEL_VESTYPE_CD   := i.VESSEL_VESTYPE_CD;
	  PIPE ROW(v_cargo);
	END LOOP;
	RETURN;
  END get_pol_doc_cargo;
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 7, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves cargo information
  */
  FUNCTION get_cargo_info(
        p_extract_id    gixx_cargo.extract_id%TYPE,
        p_item_no       gixx_cargo.item_no%TYPE,
        p_policy_id     gixx_cargo.policy_id%TYPE
  ) RETURN cargo_tab PIPELINED
  IS
    v_cargo         cargo_type;
    v_vessel_cd     VARCHAR2(10);
  BEGIN
    FOR rec IN (SELECT extract_id, item_no, geog_cd,
                       cargo_class_cd, 
                       pack_method, bl_awb,
                       tranship_origin, tranship_destination,
                       deduct_text, vessel_cd, cargo_type,
                       eta, etd, origin, destn, lc_no,
                       print_tag
                  FROM gixx_cargo
                 WHERE extract_id = p_extract_id
                   AND item_no = p_item_no)
    LOOP
        FOR a IN (SELECT geog_desc
                    FROM giis_geog_class
                   WHERE geog_cd = rec.geog_cd)
        LOOP
            v_cargo.geog_desc := a.geog_desc;
        END LOOP;
        
        FOR b IN (SELECT cargo_class_desc
                    FROM giis_cargo_class
                   WHERE cargo_class_cd = rec.cargo_class_cd)
        LOOP    
            v_cargo.cargo_class_desc := b.cargo_class_desc;
        END LOOP;
        
        FOR c IN (SELECT vessel_name
                    FROM giis_vessel
                   WHERE vessel_cd = rec.vessel_cd)
        LOOP
            v_cargo.vessel_name := c.vessel_name;
        END LOOP;
        
        FOR d IN (SELECT cargo_type_desc
                    FROM giis_cargo_type
                   WHERE cargo_type = rec.cargo_type) 
        LOOP
            v_cargo.cargo_type_desc := d.cargo_type_desc;
        END LOOP;
        
        FOR e IN (SELECT voyage_no
                    FROM gipi_cargo
                   WHERE policy_id = p_policy_id)
        LOOP
            v_cargo.voyage_no := e.voyage_no;
            EXIT;
        END LOOP;
        
        BEGIN
            SELECT param_value_v
              INTO v_vessel_cd
              FROM giis_parameters
             WHERE param_name = 'VESSEL_CD_MULTI';
        EXCEPTION
            WHEN no_data_found THEN
                v_vessel_cd := '';
        END;
        
        IF rec.vessel_cd = v_vessel_cd THEN
            v_cargo.multi_carrier := 'yes';
        ELSE
            v_cargo.multi_carrier := 'no';
        END IF;
    
        BEGIN
            SELECT SUBSTR(rv_meaning, 1, 25) meaning
              INTO v_cargo.print_desc
              FROM cg_ref_codes
             WHERE rv_domain LIKE 'GIPI_CARGO.PRINT_TAG'
               AND rv_low_value = rec.print_tag;
        EXCEPTION
            WHEN no_data_found THEN
                v_cargo.print_desc := '';        
        END;
        
        v_cargo.extract_id := rec.extract_id;
        v_cargo.item_no := rec.item_no;
        v_cargo.geog_cd := rec.geog_cd;
        v_cargo.cargo_class_cd := rec.cargo_class_cd;
        v_cargo.pack_method := rec.pack_method;
        v_cargo.bl_awb := rec.bl_awb;
        v_cargo.tranship_origin := rec.tranship_origin;
        v_cargo.tranship_destination := rec.tranship_destination;
        v_cargo.deduct_text := rec.deduct_text;
        v_cargo.vessel_cd := rec.vessel_cd;
        v_cargo.cargo_type := rec.cargo_type;
        v_cargo.eta := TRUNC(rec.eta);
        v_cargo.etd := TRUNC(rec.etd);
        v_cargo.origin := rec.origin;
        v_cargo.destn := rec.destn;
        v_cargo.lc_no := rec.lc_no;
        v_cargo.print_tag := rec.print_tag;
        
        PIPE ROW(v_cargo);
        
    END LOOP;
        
  END get_cargo_info;

END GIXX_CARGO_PKG;
/


