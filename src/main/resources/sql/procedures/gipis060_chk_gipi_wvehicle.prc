DROP PROCEDURE CPI.GIPIS060_CHK_GIPI_WVEHICLE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_CHK_GIPI_WVEHICLE(
	   p_par_id	  IN  GIPI_WPOLBAS.par_id%TYPE,
	   p_item_no  IN  GIPI_WITEM.item_no%TYPE,
	   p_towing	  IN OUT GIPI_WVEHICLE.towing%TYPE,
	   p_coc_type IN OUT GIPI_WVEHICLE.coc_type%TYPE,
	   p_plate_no IN OUT GIPI_WVEHICLE.plate_no%TYPE)
IS
  v_count  NUMBER;
  v_subline_commercial GIIS_PARAMETERS.param_value_v%TYPE;
  v_subline_lto 	   GIIS_PARAMETERS.param_value_v%TYPE;
  v_subline_motorcycle GIIS_PARAMETERS.param_value_v%TYPE;
  
  CURSOR B  IS   
        SELECT  param_name, param_value_n
          FROM  giis_parameters
         WHERE  param_name LIKE 'TOWING%';
                   
  CURSOR F  IS   
        SELECT  param_name, param_value_v
          FROM  giis_parameters
         WHERE  param_name LIKE 'PLATE NUMBER%';
BEGIN
	 v_subline_commercial := GIIS_PARAMETERS_PKG.v('COMMERCIAL VEHICLE');
	 v_subline_lto 		  := GIIS_PARAMETERS_PKG.v('LAND TRANS. OFFICE');
	 v_subline_motorcycle := GIIS_PARAMETERS_PKG.v('MOTORCYCLE');
	 
	 FOR b540 IN (
	 	 SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no
		   FROM GIPI_WPOLBAS
		  WHERE par_id = p_par_id )
	 LOOP
	 	 SELECT  COUNT(*)
		     INTO  v_count
		     FROM  gipi_vehicle a, gipi_item b, gipi_polbasic c
		    WHERE  a.policy_id  = b.policy_id
		      AND  b.policy_id  = c.policy_id
		      AND  a.item_no    = b.item_no
		      AND  c.line_cd    = b540.line_cd
		      AND  c.subline_cd = b540.subline_cd
		      AND  c.iss_cd     = b540.iss_cd  
		      AND  c.issue_yy   = b540.issue_yy
		      AND  c.pol_seq_no = b540.pol_seq_no
		      AND  a.item_no    = p_item_no;
		
		   IF v_count = 0 THEN
		      --DEFAULT_VEHICLE_VALUES;
			   FOR B_REC IN B LOOP   /* For Towing */
			      IF    b_rec.param_name = 'TOWING LIMIT - CV' 
			        AND b540.subline_cd = v_subline_commercial THEN
			         p_towing := b_rec.param_value_n;
			      ELSIF b_rec.param_name = 'TOWING LIMIT - LTO' 
			        AND b540.subline_cd = v_subline_lto THEN
			         p_towing := b_rec.param_value_n;
			      ELSIF b_rec.param_name = 'TOWING LIMIT - MCL' 
			        AND b540.subline_cd = v_subline_motorcycle THEN
			         p_towing := b_rec.param_value_n;
			      ELSIF b_rec.param_name = 'TOWING LIMIT - PC' 
			        AND b540.subline_cd = v_subline_commercial THEN
			         p_towing := b_rec.param_value_n;
			      END IF;
			   END LOOP;
			   FOR F_REC IN F LOOP   /* For Plate Number */
			      IF    f_rec.param_name = 'PLATE NUMBER' THEN
			         p_plate_no := f_rec.param_value_v;
			      END IF;
			   END LOOP;
			  
		      IF b540.subline_cd = v_subline_lto THEN
		         p_coc_type := GIIS_PARAMETERS_PKG.v('COC_TYPE_LTO');
		      ELSE
		         p_coc_type := GIIS_PARAMETERS_PKG.v('COC_TYPE_NLTO');   
		      END IF;
		   END IF;		   
	 END LOOP;
EXCEPTION 
		   	WHEN no_data_found THEN
		   		null;
END;
/


