DROP PROCEDURE CPI.GIPIS010_COPY_ADDITIONAL_INFO;

CREATE OR REPLACE PROCEDURE CPI.GIPIS010_COPY_ADDITIONAL_INFO
(	p_par_id		GIPI_WVEHICLE.par_id%TYPE,
	p_item_no		GIPI_WVEHICLE.item_no%TYPE,
	p_new_item_no 	GIPI_WVEHICLE.item_no%TYPE,
	p_line_cd		GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
	p_subline_cd	GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.08.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Create a record in GIPI_WVEHICLE / GIPI_WMCACC / GIPI_WMORTGAGEE / GIPI_WDEDUCTIBLES
	**					  by copying an exisiting record based on par_id and item_no. 
	*/
BEGIN
  IF p_line_cd = 'MC' THEN
	FOR VEHICLE_INFO IN (
		SELECT subline_cd,		motor_no,		est_value,			make,
			   mot_type,		color,			repair_lim,			coc_type,
			   assignee,		model_year,		coc_yy,				towing,
			   subline_type_cd,	no_of_pass,		tariff_zone,		ctv_tag,
			   acquired_from,	car_company_cd,	type_of_body_cd,	make_cd,
			   series_cd,		basic_color_cd,	color_cd,			unladen_wt
		  FROM GIPI_WVEHICLE
		 WHERE par_id  = p_par_id
		   AND item_no = p_item_no)
	LOOP
		INSERT INTO GIPI_WVEHICLE (
			par_id,				item_no,	subline_cd,			motor_no,
			est_value,			make,		mot_type,			color,
			repair_lim,			coc_type,	assignee,			model_year,
			coc_yy,				towing,		subline_type_cd,	no_of_pass,
			tariff_zone,		ctv_tag,	acquired_from,		car_company_cd,
			type_of_body_cd,	make_cd,	series_cd,			basic_color_cd,
			color_cd,			unladen_wt)
		VALUES (
			p_par_id,						p_new_item_no,			vehicle_info.subline_cd,		vehicle_info.motor_no,
			vehicle_info.est_value,			vehicle_info.make,		vehicle_info.mot_type,			vehicle_info.color,
			vehicle_info.repair_lim,		vehicle_info.coc_type,	vehicle_info.assignee,			vehicle_info.model_year,
			vehicle_info.coc_yy,			vehicle_info.towing,	vehicle_info.subline_type_cd,	vehicle_info.no_of_pass,
			vehicle_info.tariff_zone,		vehicle_info.ctv_tag,	vehicle_info.acquired_from,		vehicle_info.car_company_cd,
			vehicle_info.type_of_body_cd,	vehicle_info.make_cd,	vehicle_info.series_cd,			vehicle_info.basic_color_cd,
			vehicle_info.color_cd,			vehicle_info.unladen_wt);    
	END LOOP;
  
	FOR ACC IN (
		SELECT accessory_cd, acc_amt
		  FROM GIPI_WMCACC
		 WHERE par_id = p_par_id
		   AND item_no = p_item_no)
	LOOP
		INSERT INTO GIPI_WMCACC (
			par_id,        accessory_cd,      acc_amt,
			item_no,       user_id,           last_update)    
		VALUES (
			p_par_id,  		acc.accessory_cd,  acc.acc_amt,
			p_new_item_no, 	NVL(giis_users_pkg.app_user, USER),              SYSDATE);
	END LOOP;
	
  ELSIF p_line_cd = 'MN' THEN
	FOR wcargo IN (SELECT c.print_tag,				c.vessel_cd,			c.geog_cd,				c.cargo_class_cd,
						  c.voyage_no,				c.bl_awb,				c.origin,				c.destn,
						  c.etd,					c.eta,					c.cargo_type,			c.deduct_text,
						  c.pack_method,			c.tranship_origin,		c.tranship_destination,	c.lc_no,
						  c.invoice_value,			c.inv_curr_cd,			c.inv_curr_rt,			c.markup_rate,
						  c.rec_flag,				c.cpi_rec_no,			c.cpi_branch_cd
					 FROM GIPI_WCARGO c
					WHERE par_id  = p_par_id
		   			  AND item_no = p_item_no)				  
	LOOP
	  INSERT INTO GIPI_WCARGO(
				   par_id, 	 	  item_no, 			  print_tag, 	       vessel_cd,
		 		   geog_cd, 	  cargo_class_cd,     voyage_no, 		   bl_awb,
		 		   origin, 		  destn, 			  etd, 				   eta,
		 		   cargo_type, 	  deduct_text, 		  pack_method, 		   tranship_origin,
		 		   tranship_destination, 			  lc_no, 			   invoice_value,
		 		   inv_curr_cd,   inv_curr_rt, 		  markup_rate, 		   rec_flag,
		 		   cpi_rec_no, 	  cpi_branch_cd
				   )
			VALUES (
				   p_par_id,	  		       p_new_item_no,	       wcargo.print_tag,   	    wcargo.vessel_cd,
		 		   wcargo.geog_cd,	  		   wcargo.cargo_class_cd,  wcargo.voyage_no, 		wcargo.bl_awb,			    
				   wcargo.origin, 	  		   wcargo.destn, 	  	   wcargo.etd, 			    wcargo.eta, 			    
				   wcargo.cargo_type,  		   wcargo.deduct_text, 	   wcargo.pack_method, 	    wcargo.tranship_origin,   
				   wcargo.tranship_destination,wcargo.lc_no, 	  	   wcargo.invoice_value, 	   
				   wcargo.inv_curr_cd, 		   wcargo.inv_curr_rt, 	   wcargo.markup_rate, 		wcargo.rec_flag,   
				   wcargo.cpi_rec_no,  		   wcargo.cpi_branch_cd
				   );
	END LOOP;
	
	FOR CARRIER IN (SELECT vessel_cd,   voy_limit
                    FROM gipi_wcargo_carrier
                   WHERE par_id  = p_par_id
                     AND item_no = p_item_no )
    LOOP
  	  INSERT INTO gipi_wcargo_carrier
  	            (par_id,      item_no,        user_id,      last_update,    vessel_cd,         voy_limit)
         VALUES (p_par_id,    p_new_item_no,  user,         sysdate,        carrier.vessel_cd, carrier.voy_limit);
    END LOOP;
	
  ELSIF p_line_cd = 'CA' THEN
    FOR CASUALTY_INFO IN (SELECT c.section_line_cd,		c.section_subline_cd,	c.section_or_hazard_cd,   c.property_no_type,
						 		 c.capacity_cd,			c.property_no,			c.LOCATION,				  c.conveyance_info,
						 		 c.limit_of_liability,	c.interest_on_premises,	c.section_or_hazard_info, c.location_cd
                           FROM gipi_wcasualty_item c
                          WHERE par_id  = p_par_id
                            AND item_no = p_item_no)                        
    LOOP
       INSERT INTO gipi_wcasualty_item(
	   		  	    par_id,	 	  			item_no,				 section_line_cd,		
				    section_subline_cd,	 	section_or_hazard_cd,    property_no_type,
					capacity_cd,			property_no,			 LOCATION,				
					conveyance_info, 		limit_of_liability,		 interest_on_premises,	 
					section_or_hazard_info, location_cd)
			VALUES (p_par_id,	 	  					    p_new_item_no,				   	       CASUALTY_INFO.section_line_cd,		
				    CASUALTY_INFO.section_subline_cd,	 	CASUALTY_INFO.section_or_hazard_cd,    CASUALTY_INFO.property_no_type,
					CASUALTY_INFO.capacity_cd,				CASUALTY_INFO.property_no,			   CASUALTY_INFO.location,				
					CASUALTY_INFO.conveyance_info, 			CASUALTY_INFO.limit_of_liability,	   CASUALTY_INFO.interest_on_premises,	 
					CASUALTY_INFO.section_or_hazard_info, 	CASUALTY_INFO.location_cd);
    END LOOP;
	
  	FOR PERS IN (SELECT personnel_no,   name,    include_tag,
                      amount_covered, remarks, capacity_cd
                    FROM gipi_wcasualty_personnel
                   WHERE par_id  = p_par_id
                     AND item_no = p_item_no)
    LOOP
  	  INSERT INTO gipi_wcasualty_personnel
  	            (par_id,           item_no,          personnel_no,      name, 
                 include_tag,      capacity_cd,      remarks,           amount_covered)
         VALUES (p_par_id,         p_new_item_no,    pers.personnel_no, pers.name, 
                 pers.include_tag, pers.capacity_cd, pers.remarks,      pers.amount_covered);
    END LOOP;
    FOR GRP IN (SELECT line_cd, subline_cd,    include_tag,  grouped_item_no,
                     sex,     position_cd,   civil_status, grouped_item_title,
                     age,     date_of_birth, salary,       salary_grade,
                     remarks, amount_covered
                    FROM gipi_wgrouped_items
                   WHERE par_id  = p_par_id
                     AND item_no = p_item_no)
    LOOP
  	  INSERT INTO gipi_wgrouped_items
  	            (par_id,       item_no,           remarks,          amount_covered,
                 line_cd,      subline_cd,        include_tag,      grouped_item_no,
                 sex,          position_cd,       civil_status,     grouped_item_title,
                 age,          date_of_birth,     salary,           salary_grade)
         VALUES (p_par_id,     p_new_item_no,     grp.remarks,      grp.amount_covered,
                 grp.line_cd,  grp.subline_cd,    grp.include_tag,  grp.grouped_item_no,
                 grp.sex,      grp.position_cd,   grp.civil_status, grp.grouped_item_title,
                 grp.age,      grp.date_of_birth, grp.salary,       grp.salary_grade);
    END LOOP;
	
  ELSIF p_line_cd = 'AH' THEN
  	FOR ACC IN (SELECT par_id, 	 	     item_no,			no_of_persons,
				       position_cd,		 destination,		monthly_salary,
				       salary_grade,	 date_of_birth,	    age,
				       civil_status,	 height,			weight,
				       sex,				 group_print_sw, 	ac_class_cd,
				       level_cd, 		 parent_level_cd
                  FROM gipi_waccident_item
                 WHERE par_id = p_par_id
                   AND item_no = p_item_no)
    LOOP  
      INSERT INTO gipi_waccident_item(
	  		 	   par_id, 	 	     item_no,			no_of_persons,
				   position_cd,		 destination,		monthly_salary,
				   salary_grade,	 date_of_birth,	    age,
				   civil_status,	 height,			weight,
				   sex,				 group_print_sw, 	ac_class_cd,
				   level_cd, 		 parent_level_cd
	  		 	   )
			VALUES(p_par_id, 	 	     p_new_item_no,			ACC.no_of_persons,
				   ACC.position_cd,		 ACC.destination,		ACC.monthly_salary,
				   ACC.salary_grade,	 ACC.date_of_birth,	    ACC.age,
				   ACC.civil_status,	 ACC.height,			ACC.weight,
				   ACC.sex,				 ACC.group_print_sw, 	ACC.ac_class_cd,
				   ACC.level_cd, 		 ACC.parent_level_cd
				   );	  
    END LOOP;                      
    --*--
    /*Modified by Iris Bordey (08.22.2002)
    **Added remarks to be copied to the new item.*/
    FOR BEN IN (SELECT beneficiary_name, beneficiary_addr,
                     relation,         beneficiary_no, remarks
                FROM gipi_wbeneficiary
               WHERE par_id  = p_par_id
                 AND item_no = p_item_no)
    LOOP
  	  INSERT INTO gipi_wbeneficiary
  	            (par_id,               item_no,            
  	             beneficiary_name,     beneficiary_addr,
                 relation,             beneficiary_no, remarks)                 
         VALUES (p_par_id,         p_new_item_no,      
                 ben.beneficiary_name, ben.beneficiary_addr,
                 ben.relation,         ben.beneficiary_no, ben.remarks);
    END LOOP;
    --*--
    FOR DATA IN (SELECT include_tag,      grouped_item_title,
                      civil_status,     date_of_birth,
                      grouped_item_no,  age,
                      position_cd,      sex,
                      salary,           salary_grade,
                      line_cd,          subline_cd,
                      amount_covered,   remarks
                 FROM gipi_wgrouped_items
                WHERE par_id  = p_par_id
                  AND item_no = p_item_no)
    LOOP
  	  INSERT INTO gipi_wgrouped_items
  	            (par_id,                item_no,            
  	             include_tag,           grouped_item_title,
                 civil_status,          date_of_birth,
                 grouped_item_no,       age,
                 position_cd,           sex,
                 salary,                salary_grade,
                 line_cd,               subline_cd,
                 amount_covered,        remarks)                 
         VALUES (p_par_id,              p_new_item_no,      
                 data.include_tag,      data.grouped_item_title,
                 data.civil_status,     data.date_of_birth,
                 data.grouped_item_no,  data.age,
                 data.position_cd,      data.sex,
                 data.salary,           data.salary_grade,
                 data.line_cd,          data.subline_cd,
                 data.amount_covered,   data.remarks);
    END LOOP;
    FOR BEN2 IN (SELECT beneficiary_name, beneficiary_addr,
                      civil_status,     date_of_birth,
                      grouped_item_no,  age,
                      relation,         sex,
                      beneficiary_no
                 FROM gipi_wgrp_items_beneficiary
                WHERE par_id  = p_par_id
                  AND item_no = p_item_no)
    LOOP
  	  INSERT INTO gipi_wgrp_items_beneficiary
  	            (par_id,                item_no,            
  	             beneficiary_name,      beneficiary_addr,
                 civil_status,          date_of_birth,
                 grouped_item_no,       age,
                 relation,           sex,
                 beneficiary_no)                 
         VALUES (p_par_id,              p_new_item_no,      
                 ben2.beneficiary_name, ben2.beneficiary_addr,
                 ben2.civil_status,     ben2.date_of_birth,
                 ben2.grouped_item_no,  ben2.age,
                 ben2.relation,         ben2.sex,
                 ben2.beneficiary_no);
    END LOOP;
  END IF;	
	
  /* if LINE CODE has a mortgagee please insert the line here */	
  IF p_line_cd = 'MC' THEN
	FOR MORTG IN (
		SELECT iss_cd,   mortg_cd,   amount,   remarks
		  FROM GIPI_WMORTGAGEE
		 WHERE par_id  = p_par_id
		   AND item_no = p_item_no )
	LOOP
		INSERT INTO GIPI_WMORTGAGEE (
			par_id,        item_no,        user_id,      last_update,
			iss_cd,        mortg_cd,       amount,       remarks)
		VALUES (
			p_par_id,  		p_new_item_no,  NVL(giis_users_pkg.app_user, USER),         SYSDATE,
			mortg.iss_cd,	mortg.mortg_cd, mortg.amount, mortg.amount);
	END LOOP;
  END IF;
  
	FOR DED IN (
		SELECT ded_line_cd,     ded_subline_cd,  ded_deductible_cd,
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
		INSERT INTO GIPI_WDEDUCTIBLES (
			par_id,             item_no,            
			ded_line_cd,        ded_subline_cd,     ded_deductible_cd,
			deductible_text,    deductible_amt,     peril_cd,
			deductible_rt, 		aggregate_sw,		ceiling_sw,
			min_amt, 			max_amt, 			range_sw)
		VALUES (
			p_par_id,				p_new_item_no,      
			ded.ded_line_cd,		ded.ded_subline_cd, ded.ded_deductible_cd,
			ded.deductible_text,	ded.deductible_amt, ded.peril_cd,
			ded.deductible_rt, 		ded.aggregate_sw,	ded.ceiling_sw,
			ded.min_amt, 			ded.max_amt, 		ded.range_sw);
	END LOOP;	
END;
/


