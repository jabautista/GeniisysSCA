DROP FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_MC2;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_MC2 (
	p_par_id 		IN GIPI_PARLIST.par_id%TYPE,
	p_par_status	IN GIPI_PARLIST.par_status%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.23.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Checks the presence of record in the table gipi_wvehicle 
	** 					  before inserting record in gipi_witem.  Gipi_wvehicle is 
	** 					  required for all records in gipi_witem
	**					  (Original description)
	*/
	v_item_no1          GIPI_WVEHICLE.item_no%TYPE := 0;
	v_item_no2          GIPI_WVEHICLE.item_no%TYPE := 0;
	no_vehicle_info     VARCHAR2(100) := NULL;
	v_no_exist          VARCHAR2(1)   := 'N';
	v_result			VARCHAR2(200);
	v_pack_pol_flag		GIPI_WPOLBAS.pack_pol_flag%TYPE := NULL;
	CURSOR A IS
		SELECT item_no
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id
	  ORDER BY item_no;
	CURSOR P IS
		SELECT item_no
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id
		   AND UPPER(pack_line_cd) = 'MC'
	  ORDER BY item_no;
	CURSOR B (p_item_no NUMBER) IS
		SELECT item_no
		  FROM GIPI_WVEHICLE
		 WHERE par_id = p_par_id
		   AND item_no = p_item_no;
BEGIN
	v_pack_pol_flag := Check_Pack_Pol_Flag(p_par_id);
	IF v_pack_pol_flag = 'Y' THEN
		FOR p1 IN P LOOP
			v_item_no1 := p1.item_no;
			FOR b1 IN b(p1.item_no) LOOP
				v_item_no2 := b1.item_no;
			END LOOP;
			IF v_item_no1 != v_item_no2 THEN
				no_vehicle_info := no_vehicle_info || TO_CHAR(v_item_no1) ||', ';
				v_no_exist := 'Y';
			END IF;
		END LOOP;
	ELSE
		FOR a1 IN a LOOP
			v_item_no1 := a1.item_no;
			FOR b1 IN b(a1.item_no) LOOP
				v_item_no2 := b1.item_no;
			END LOOP;
			IF v_item_no1 != v_item_no2 THEN
				no_vehicle_info := no_vehicle_info || TO_CHAR(v_item_no1) ||', ';
				v_no_exist := 'Y';
			END IF;
		END LOOP;
	END IF;
	
	IF v_no_exist = 'Y' THEN		
		no_vehicle_info := SUBSTR(no_vehicle_info, 1, NVL(LENGTH(no_vehicle_info), 0)-2);		
		v_result := 'Item No. '|| no_vehicle_info || ' has no vehicle information, '|| 'please do the necessary actions.';
		
		IF p_par_status != 3 THEN
			UPDATE gipi_parlist
			   SET par_status = 3
			 WHERE par_id = p_par_id;
		END IF;
	END IF;
	
	RETURN v_result;
END VALIDATE_CHECK_ADDTL_INFO_MC2;
/


