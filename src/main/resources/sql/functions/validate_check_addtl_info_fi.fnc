DROP FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_FI;

CREATE OR REPLACE FUNCTION CPI.VALIDATE_CHECK_ADDTL_INFO_FI (p_par_id 			GIPI_WITEM.par_id%TYPE)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.09.2010
	**  Reference By 	: (GIPIS003 - Item Information)
	**  Description 	: To check if all items created has additional
	** 					  information in gipi_wfireitm, gipi_wfire_occupancy
	** 					  gipi_wfire_boundary, gipi_wfire_construction
	** 					           * * * I M P O R T A N T * * *
	** 					  construction_cd, construction_remarks as well as
	** 					  occupancy_cd and occupancy_remarks is required only 
	** 					  if fire item type is "BUILDING"
	** 					  This procedure is valid only when the item dos not
	** 					  exist in the original policy being endorsed
	** 					  
	** 					  Since the addition of the fields pack_line_cd
	** 					  and pack_subline_cd, then we must check the additional
	** 					  information accordingly.
	**					  (Original Description)
	*/
	a_exist     		VARCHAR2(1) :='Y';
	a_no_exist  		VARCHAR2(1000):= '';
	v_result			VARCHAR2(200);
	v_pack_pol_flag		GIPI_WPOLBAS.pack_pol_flag%TYPE := NULL;
	CURSOR A IS (
		SELECT a.item_no          a1_item_no,
			   NVL(b.item_no, 0)  a2_item_no
		  FROM GIPI_WITEM a, GIPI_WFIREITM b
		 WHERE a.item_no = b.item_no(+)
		   AND a.par_id = b.par_id (+)
		  AND a.par_id = p_par_id);
   CURSOR B IS (
		SELECT a.item_no          a1_item_no,
			   NVL(b.item_no, 0)  a2_item_no
		  FROM GIPI_WITEM a, GIPI_WFIREITM b
		 WHERE a.item_no = b.item_no(+)
		   AND a.par_id = b.par_id (+)
		   AND UPPER(a.pack_line_cd) = 'FI'
		   AND a.par_id = p_par_id);	
BEGIN
	v_pack_pol_flag := Check_Pack_Pol_Flag(p_par_id);
	IF v_pack_pol_flag = 'Y' THEN
		FOR B1 IN B LOOP
			IF b1.a1_item_no != b1.a2_item_no THEN
				a_exist := 'N';
				a_no_exist := a_no_exist || TO_CHAR(b1.a1_item_no)|| ', ';
			END IF;
		END LOOP;
	ELSE
		FOR A1 IN A LOOP
			IF a1.a1_item_no != a1.a2_item_no THEN
				a_exist := 'N';
				a_no_exist := a_no_exist || TO_CHAR(a1.a1_item_no)|| ', ';
			END IF;
		END LOOP;
	END IF;
	
	IF a_exist = 'N' THEN		
		v_result := 'Item no ' || SUBSTR(a_no_exist,1, NVL(LENGTH(a_no_exist), 0)-2)|| '  has no additional information.' ||
					' Please do the necessary changes.';
		/*Gipis010_Par_Status_3(p_par_id);*/
        
	END IF;
	
	RETURN v_result;
END;
/


