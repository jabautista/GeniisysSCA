DROP PROCEDURE CPI.GIPIS010_ASSIGN_DEDUCTIBLES;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Assign_Deductibles (
	p_par_id	GIPI_WITEM.par_id%TYPE,
	p_item_no	GIPI_WITEM.item_no%TYPE)
IS
	/*
	**  Created by	: Mark JM
	**  Date Created : 02.03.2010
	**  Reference By : (GIPIS010 ? Item Information)
	**  Description : Insert records into GIPI_WDEDUCTIBLES
	*/
BEGIN
	FOR ITEM IN (SELECT b480.item_no
				   FROM GIPI_WITEM b480
				  WHERE b480.par_id = p_par_id
					AND NOT EXISTS (SELECT '1'
									  FROM GIPI_WDEDUCTIBLES b350
									 WHERE b350.par_id = b480.par_id
									   AND b350.item_no = b480.item_no
									   AND b350.peril_cd = 0))
	LOOP
		FOR DED IN (SELECT ded_line_cd,		ded_subline_cd,		ded_deductible_cd,
						   deductible_text,	deductible_amt,		peril_cd,
						   deductible_rt,	aggregate_sw,		ceiling_sw,
						   min_amt,			max_amt,			range_sw
					  FROM GIPI_WDEDUCTIBLES
					 WHERE par_id = p_par_id
					   AND item_no = p_item_no
					   AND peril_cd = 0)
		LOOP
			INSERT INTO GIPI_WDEDUCTIBLES
				(par_id,			item_no,			ded_line_cd,		ded_subline_cd,
				 ded_deductible_cd,	deductible_text,	deductible_amt,		peril_cd,
				 deductible_rt,		aggregate_sw,		ceiling_sw,			min_amt,
				 max_amt,			range_sw)
			VALUES
				(p_par_id,				item.item_no,			ded.ded_line_cd,	ded.ded_subline_cd,
				 ded.ded_deductible_cd,	ded.deductible_text,	ded.deductible_amt,	ded.peril_cd,
				 ded.deductible_rt,		ded.aggregate_sw,		ded.ceiling_sw,		ded.min_amt,
				 ded.max_amt,			ded.range_sw);
		END LOOP;
	END LOOP;
	--COMMIT;
END Gipis010_Assign_Deductibles;
/


