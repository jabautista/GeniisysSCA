DROP PROCEDURE CPI.GIPIS060_COPY_ADDITIONAL_INFO;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_COPY_ADDITIONAL_INFO
(	p_par_id		GIPI_WVEHICLE.par_id%TYPE,
	p_item_no		GIPI_WVEHICLE.item_no%TYPE,
	p_new_item_no 	GIPI_WVEHICLE.item_no%TYPE,
	p_line_cd		GIPI_WDEDUCTIBLES.ded_line_cd%TYPE,
	p_subline_cd	GIPI_WDEDUCTIBLES.ded_subline_cd%TYPE)
IS
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS060 - Endt Par Item Information)
	**  Description 	: Create a record in GIPI_WVEHICLE / GIPI_WMCACC / GIPI_WMORTGAGEE / GIPI_WDEDUCTIBLES
	**					  by copying an exisiting record based on par_id and item_no. 
	*/
BEGIN
	FOR VEHICLE_INFO IN (
		SELECT subline_cd,		motor_no,		est_value,			make,
			   mot_type,		color,			repair_lim,			coc_type,
			   assignee,		model_year,		coc_yy,				towing,
			   subline_type_cd,	no_of_pass,		tariff_zone,		ctv_tag,
			   acquired_from,	car_company_cd,	type_of_body_cd,	make_cd,
			   series_cd,		basic_color_cd,	color_cd,			unladen_wt,
			   motor_coverage
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
			color_cd,			unladen_wt, motor_coverage)
		VALUES (
			p_par_id,						p_new_item_no,			vehicle_info.subline_cd,		vehicle_info.motor_no,
			vehicle_info.est_value,			vehicle_info.make,		vehicle_info.mot_type,			vehicle_info.color,
			vehicle_info.repair_lim,		vehicle_info.coc_type,	vehicle_info.assignee,			vehicle_info.model_year,
			vehicle_info.coc_yy,			vehicle_info.towing,	vehicle_info.subline_type_cd,	vehicle_info.no_of_pass,
			vehicle_info.tariff_zone,		vehicle_info.ctv_tag,	vehicle_info.acquired_from,		vehicle_info.car_company_cd,
			vehicle_info.type_of_body_cd,	vehicle_info.make_cd,	vehicle_info.series_cd,			vehicle_info.basic_color_cd,
			vehicle_info.color_cd,			vehicle_info.unladen_wt,vehicle_info.motor_coverage);			
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


