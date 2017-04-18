DROP PROCEDURE CPI.GIPIS039_COPY_ADDITIONAL_INFO;

CREATE OR REPLACE PROCEDURE CPI.GIPIS039_COPY_ADDITIONAL_INFO
	   (	p_par_id		GIPI_WVEHICLE.par_id%TYPE,
		p_item_no		GIPI_WVEHICLE.item_no%TYPE,
		p_new_item_no 	GIPI_WVEHICLE.item_no%TYPE,
		p_line_cd		GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
		p_subline_cd	GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
IS
BEGIN
  FOR FIRE_INFO IN (SELECT district_no,   eq_zone,       tarf_cd,         block_no,
                           fr_item_type,  loc_risk1,     loc_risk2,       loc_risk3,
                           tariff_zone,   typhoon_zone,  construction_cd, construction_remarks,
                           front,         right,         occupancy_cd,    occupancy_remarks,
                           left,          rear,          flood_zone,      assignee,
                           block_id
                     FROM gipi_wfireitm
                    WHERE par_id  = p_par_id
                      AND item_no = p_item_no)
  LOOP 
	 INSERT INTO GIPI_WFIREITM (
	 		par_id, 		   item_no, 			   district_no, 	  eq_zone, 
			tarf_cd, 		   block_no, 			   fr_item_type,	  loc_risk1,
			loc_risk2,		   loc_risk3,			   tariff_zone,		  typhoon_zone,
			construction_cd,   construction_remarks,   front,			  right,
			occupancy_cd,	   occupancy_remarks,	   left,			  rear,
			flood_zone,		   assignee,			   block_id
	 		)
	  VALUES (
	  		p_par_id, 		   p_new_item_no, 		   fire_info.district_no,  fire_info.eq_zone, 
			fire_info.tarf_cd, 		   fire_info.block_no, 			   fire_info.fr_item_type,	  fire_info.loc_risk1,
			fire_info.loc_risk2,	   fire_info.loc_risk3,			   fire_info.tariff_zone,	  fire_info.typhoon_zone,
			fire_info.construction_cd, fire_info.construction_remarks, fire_info.front,			  fire_info.right,
			fire_info.occupancy_cd,	   fire_info.occupancy_remarks,	   fire_info.left,			  fire_info.rear,
			fire_info.flood_zone,	   fire_info.assignee,			   fire_info.block_id
	   );
  END LOOP;
    
  FOR MORTG IN (SELECT iss_cd,   mortg_cd,   amount,   remarks
                  FROM gipi_wmortgagee
                 WHERE par_id  = p_par_id
                   AND item_no = p_item_no )
  LOOP
  	INSERT INTO gipi_wmortgagee
  	            (par_id,        item_no,        user_id,      last_update,
  							 iss_cd,        mortg_cd,       amount,       remarks)
         VALUES (p_par_id,  p_new_item_no,  user,         sysdate,
                 mortg.iss_cd,  mortg.mortg_cd, mortg.amount, mortg.amount);
  END LOOP;
  FOR DED IN /*(SELECT ded_line_cd,     ded_subline_cd,  ded_deductible_cd,
                     deductible_text, deductible_amt,  peril_cd,
                     deductible_rt
                FROM gipi_wdeductibles
               WHERE par_id   = p_par_id
                 AND item_no  = p_item_no
                 AND peril_cd = 0*/--ramon, 02.20.08
             (SELECT ded_line_cd,     ded_subline_cd,  ded_deductible_cd,
                     a.deductible_text, a.deductible_amt,  peril_cd,
                     a.deductible_rt, aggregate_sw, ceiling_sw, a.min_amt, a.max_amt, a.range_sw
						    FROM GIPI_WDEDUCTIBLES a, GIIS_DEDUCTIBLE_DESC b
						   WHERE a.ded_deductible_cd = b.deductible_cd
						     AND a.ded_line_cd = b.line_cd
						     AND a.ded_subline_cd = b.subline_cd
						     AND a.par_id = p_par_id
						     AND a.ded_line_cd = p_line_cd
						     AND a.ded_subline_cd = p_subline_cd
						     AND a.item_no  = p_item_no
						     AND a.peril_cd = 0)
  LOOP
  	INSERT INTO gipi_wdeductibles
  	            (par_id,              item_no,            
  	             ded_line_cd,         ded_subline_cd,     ded_deductible_cd,
                 deductible_text,     deductible_amt,     peril_cd,
                 deductible_rt/*ramon, 02.20.08*/, aggregate_sw,
                 ceiling_sw, min_amt, max_amt, range_sw)--end r
         VALUES (p_par_id,        p_new_item_no,      
                 ded.ded_line_cd,     ded.ded_subline_cd, ded.ded_deductible_cd,
                 ded.deductible_text, ded.deductible_amt, ded.peril_cd,
                 ded.deductible_rt/*ramon, 02.20.08*/, ded.aggregate_sw,
                 ded.ceiling_sw, ded.min_amt, ded.max_amt, ded.range_sw);--end r
  END LOOP;
END;
/


