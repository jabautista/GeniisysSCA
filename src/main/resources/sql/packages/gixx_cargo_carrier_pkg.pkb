CREATE OR REPLACE PACKAGE BODY CPI.GIXX_CARGO_CARRIER_PKG AS

  FUNCTION get_pol_doc_carrier(p_extract_id	  GIXX_CARGO.extract_id%TYPE,
  		   				       p_item_no	  GIXX_CARGO.item_no%TYPE)
    RETURN pol_doc_carrier_tab PIPELINED IS
	v_carrier				   pol_doc_carrier_type;
  BEGIN
    FOR i IN (SELECT  A.EXTRACT_ID     EXTRACT_ID,
        	 		  A.ITEM_NO        CCARRIER_ITEM_NO,
        			  A.VESSEL_CD      CCARRIER_VESSEL_CD,
					  B.VESSEL_NAME || ' (' || 
					  		DECODE(B.VESSEL_FLAG, 'V', 'VESSEL',
	          		  		DECODE(B.VESSEL_FLAG, 'I', 'INLAND', 'AIRCRAFT')) || ')' CCARRIER_VESSEL_NAME,
                	  B.PLATE_NO CCARRIER_PLATE_NO, 
					  B.MOTOR_NO       CCARRIER_MOTOR_NO,    				
					  B.SERIAL_NO      CCARRIER_SERIAL_NO,
                	  A.ETA 	         CCARRIER_ETA,	  
					  A.ETD 	         CCARRIER_ETD,
					  A.ORIGIN	     CCARRIER_ORIGIN, 
					  A.DESTN          CCARRIER_DESTN,	  
					  B.VESSEL_FLAG    CCARRIER_VESSEL_FLAG,
					  A.VOY_LIMIT      CCARRIER_VOY_LIMIT    
    			FROM  GIXX_CARGO_CARRIER A, GIIS_VESSEL B
 			   WHERE  A.VESSEL_CD = B.VESSEL_CD
			     AND  A.EXTRACT_ID = P_EXTRACT_ID
				 AND  A.ITEM_NO = P_ITEM_NO)
	LOOP
	  v_carrier.EXTRACT_ID 		  			:= i.EXTRACT_ID;
	  v_carrier.CCARRIER_ITEM_NO 			:= i.CCARRIER_ITEM_NO;
	  v_carrier.CCARRIER_VESSEL_CD 			:= i.CCARRIER_VESSEL_CD;
	  v_carrier.CCARRIER_VESSEL_NAME 		:= i.CCARRIER_VESSEL_NAME;
	  v_carrier.CCARRIER_PLATE_NO 			:= i.CCARRIER_PLATE_NO;
	  v_carrier.CCARRIER_MOTOR_NO 			:= i.CCARRIER_MOTOR_NO;
	  v_carrier.CCARRIER_SERIAL_NO 			:= i.CCARRIER_SERIAL_NO;
	  v_carrier.CCARRIER_ETA 				:= i.CCARRIER_ETA;
	  v_carrier.CCARRIER_ETD 				:= i.CCARRIER_ETD;
	  v_carrier.CCARRIER_ORIGIN 			:= i.CCARRIER_ORIGIN;
	  v_carrier.CCARRIER_DESTN 				:= i.CCARRIER_DESTN;
	  v_carrier.CCARRIER_VESSEL_FLAG 		:= i.CCARRIER_VESSEL_FLAG;
	  v_carrier.CCARRIER_VOY_LIMIT 			:= i.CCARRIER_VOY_LIMIT;
	  PIPE ROW(v_carrier);
	END LOOP;
	RETURN;
  END get_pol_doc_carrier;
  
  FUNCTION check_ccarrier_exist(p_extract_id   GIXX_CARGO_CARRIER.extract_id%TYPE) 
    RETURN VARCHAR2 is
	v_count			number(2) := 0;
  BEGIN
	FOR a IN (
	  SELECT count(extract_id) extract_id
	    FROM GIXX_CARGO_CARRIER A, GIIS_VESSEL B
	    WHERE A.VESSEL_CD  = B.VESSEL_CD
	      AND a.extract_id = p_extract_id)
	 LOOP
	 	 v_count := a.extract_id;
	 END LOOP;
	 
	 IF v_count = 0 THEN
	    RETURN ('N');
	 ELSE
	 	 RETURN ('Y');
	 END IF;  
  END check_ccarrier_exist;
  
  FUNCTION get_pack_pol_doc_carrier(p_extract_id   GIXX_CARGO.extract_id%TYPE,
                                    p_policy_id    GIXX_CARGO.policy_id%TYPE,
                                    p_item_no      GIXX_CARGO.item_no%TYPE)
    RETURN pol_doc_carrier_tab PIPELINED IS
    
    v_carrier                   pol_doc_carrier_type;
    
  BEGIN
     FOR i IN (SELECT   A.extract_id     EXTRACT_ID,
                        A.policy_id      POLICY_ID,
                        A.item_no        CCARRIER_ITEM_NO,
                        A.vessel_cd      CCARRIER_VESSEL_CD,
                        B.vessel_name || ' (' || 
                        DECODE(B.vessel_flag, 'V', 'VESSEL',
                        DECODE(B.vessel_flag, 'I', 'INLAND', 'AIRCRAFT')) || ')' CCARRIER_VESSEL_NAME,
                        B.plate_no CCARRIER_PLATE_NO, 
                        B.motor_no       CCARRIER_MOTOR_NO,                    
                        B.serial_no      CCARRIER_SERIAL_NO,
                        A.eta            CCARRIER_ETA,      
                        A.etd            CCARRIER_ETD,
                        A.origin         CCARRIER_ORIGIN, 
                        A.destn          CCARRIER_DESTN,      
                        B.vessel_flag    CCARRIER_VESSEL_FLAG,
                        A.voy_limit      CCARRIER_VOY_LIMIT      
                FROM  GIXX_CARGO_CARRIER A, 
                      GIIS_VESSEL B
                WHERE A.vessel_cd = B.vessel_cd
                      AND A.extract_id = p_extract_id
                      AND A.policy_id  = p_policy_id
                      AND A.item_no    = p_item_no)
    LOOP
      v_carrier.extract_id                   := i.extract_id;
      v_carrier.ccarrier_item_no             := i.ccarrier_item_no;
      v_carrier.ccarrier_vessel_cd           := i.ccarrier_vessel_cd;
      v_carrier.ccarrier_vessel_name         := i.ccarrier_vessel_name;
      v_carrier.ccarrier_plate_no            := i.ccarrier_plate_no;
      v_carrier.ccarrier_motor_no            := i.ccarrier_motor_no;
      v_carrier.ccarrier_serial_no           := i.ccarrier_serial_no;
      v_carrier.ccarrier_eta                 := i.ccarrier_eta;
      v_carrier.ccarrier_etd                 := i.ccarrier_etd;
      v_carrier.ccarrier_origin              := i.ccarrier_origin;
      v_carrier.ccarrier_destn               := i.ccarrier_destn;
      v_carrier.ccarrier_vessel_flag         := i.ccarrier_vessel_flag;
      v_carrier.ccarrier_voy_limit           := i.ccarrier_voy_limit;
      PIPE ROW(v_carrier);
      
    END LOOP;
    
    RETURN;
    
  END get_pack_pol_doc_carrier;
  
  
  
  /*
  ** Created by:    Marie Kris Felipe
  ** Date Created:  March 7, 2013
  ** Reference by:  GIPIS101 - Policy Information (Summary)
  ** Description:   Retrieves cargo carrier information
  */
  FUNCTION get_cargo_carrier_list (
    p_extract_id        gixx_cargo_carrier.extract_id%TYPE,
    p_item_no           GIXX_CARGO_CARRIER.ITEM_NO%TYPE
  ) RETURN cargo_carrier_tab PIPELINED
  IS 
    v_cargo_carrier cargo_carrier_type;
  BEGIN
    FOR rec IN (SELECT extract_id, item_no,
                       vessel_cd
                  FROM gixx_cargo_carrier
                 WHERE extract_id = p_extract_id
                   AND item_no = p_item_no)
    LOOP
        FOR a IN (SELECT vessel_name
                    FROM giis_vessel
                   WHERE vessel_cd = rec.vessel_cd)
        LOOP
            v_cargo_carrier.vessel_name := a.vessel_name;
        END LOOP;
        
        v_cargo_carrier.extract_id := rec.extract_id;
        v_cargo_carrier.item_no := rec.item_no;
        v_cargo_carrier.vessel_cd := rec.vessel_cd;
        
        PIPE ROW(v_cargo_carrier);
    END LOOP;
  END get_cargo_carrier_list;
  

END GIXX_CARGO_CARRIER_PKG;
/


