DROP PROCEDURE CPI.CHANGE_ITEM_GRP;

CREATE OR REPLACE PROCEDURE CPI.CHANGE_ITEM_GRP (
	p_par_id		IN GIPI_WITEM.par_id%TYPE,
	p_pack_pol_flag IN VARCHAR2)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 06.03.2010
	**  Reference By 	: (GIPIS031 - Endt Basic Information)
	**  Description 	: Updates the item grouping of the items inserted
	** 					: based on the currency rate selected.
	** 					: Since the addition of the columns pack_line_cd
	** 					: and pack_subline_cd, then the item grouping for
	** 					: packaged policy must be done accordingly, items
	** 					: for package policy must be grouped not only by
	** 					: currency_cd and currency_rt but by pack_line_cd
	** 					: and pack_subline_cd as well. (Original Description)
	*/
	v_item_grp	GIPI_WITEM.item_grp%TYPE := 1;
BEGIN
	UPDATE GIPI_WITEM
	   SET item_grp = NULL
	 WHERE par_id = p_par_id;
	 
	IF p_pack_pol_flag = 'Y' THEN
		FOR C1 IN (
			SELECT currency_cd, currency_rt, pack_line_cd, pack_subline_cd
			  FROM GIPI_WITEM
			 WHERE par_id  =  p_par_id
		  GROUP BY currency_cd, currency_rt, pack_line_cd, pack_subline_cd
		  ORDER BY currency_cd, currency_rt, pack_line_cd, pack_subline_cd)   
		LOOP
			UPDATE GIPI_WITEM
			   SET item_grp = v_item_grp
			 WHERE currency_rt = c1.currency_rt
			   AND currency_cd = c1.currency_cd
			   AND pack_line_cd = c1.pack_line_cd
			   AND pack_subline_cd = c1.pack_subline_cd
			   AND par_id = p_par_id;
			v_item_grp  :=  v_item_grp + 1;
		END LOOP;
	ELSE
		FOR C2 IN (
			SELECT currency_cd, currency_rt
			  FROM GIPI_WITEM
			 WHERE par_id  =  p_par_id
		  GROUP BY currency_cd, currency_rt
		  ORDER BY currency_cd, currency_rt)   
		LOOP
			UPDATE GIPI_WITEM
			   SET item_grp = v_item_grp
			 WHERE currency_rt = c2.currency_rt
			   AND currency_cd = c2.currency_cd
			   AND par_id = p_par_id;
			v_item_grp  :=  v_item_grp + 1;
		END LOOP;	
	END IF;
END CHANGE_ITEM_GRP;
/


