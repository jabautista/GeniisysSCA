DROP PROCEDURE CPI.GIPIS095_POST_FORMS_COMMIT_INS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS095_POST_FORMS_COMMIT_INS (
	p_pack_par_id IN gipi_wpack_line_subline.pack_par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Update the par_status of gipi_pack_parlist based on certain conditions
	*/
	v_lc_en giis_parameters.param_value_v%TYPE;
	v_lc_ca giis_parameters.param_value_v%TYPE;
	v_item_tag gipi_wpack_line_subline.item_tag%TYPE := 'N';
	v_not_exist VARCHAR2(1) := 'N';
BEGIN
	FOR A1 IN (
		SELECT a.param_value_v  a_param_value_v,
			   b.param_value_v  b_param_value_v
		  FROM giis_parameters a,
			   giis_parameters b
		 WHERE a.param_name LIKE 'LINE_CODE_CA'
		   AND b.param_name LIKE 'LINE_CODE_EN')
	LOOP
		v_lc_ca := a1.a_param_value_v;
		v_lc_en := a1.b_param_value_v;
	END LOOP;
	
	FOR B IN (
		SELECT NVL(item_tag,'N') item_tag
		  FROM gipi_wpack_line_subline
		 WHERE pack_par_id = p_pack_par_id
		   AND pack_line_cd NOT IN (v_lc_en, v_lc_ca)
		   AND item_tag = 'N')
	LOOP
		IF b.item_tag = 'N' THEN
			v_not_exist := 'Y';
		END IF;
	END LOOP;
	
	FOR i IN (
		SELECT a.pack_line_cd, a.pack_subline_cd
		  FROM gipi_witem a,
		       gipi_wpolbas b
		 WHERE a.par_id = b.par_id
		   AND b.pack_par_id = p_pack_par_id)
	LOOP
		FOR A IN (
			SELECT NVL(item_tag,'N') item_tag
			  FROM gipi_wpack_line_subline
			 WHERE pack_par_id = p_pack_par_id
			   AND pack_line_cd = i.pack_line_cd
			   AND pack_subline_cd = i.pack_subline_cd 
			   AND pack_line_cd IN (v_lc_en, v_lc_ca))
		LOOP
			v_item_tag := a.item_tag;  
			EXIT;
		END LOOP;
		
		IF v_item_tag = 'Y' AND v_not_exist = 'N' THEN
            gipi_pack_parlist_pkg.update_pack_par_status(p_pack_par_id, 4);
        ELSIF v_not_exist = 'Y' THEN                           
            gipi_pack_parlist_pkg.update_pack_par_status(p_pack_par_id, 3);
        END IF;    
    END LOOP;    
END GIPIS095_POST_FORMS_COMMIT_INS;
/


