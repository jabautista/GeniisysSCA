DROP PROCEDURE CPI.UPD8_GIPI_WPACK_LINE_SUBLINE;

CREATE OR REPLACE PROCEDURE CPI.UPD8_GIPI_WPACK_LINE_SUBLINE (p_par_id IN GIPI_WPACK_LINE_SUBLINE.par_id%TYPE)
AS
    /*
    **  Created by		: Mark JM
    **  Date Created	: 12.20.2010
    **  Reference By	: (GIPIS010 - Item Information)
    **  Description     : Update GIPI_WPACK_LINE_SUBLINE
    */
    v_count_a    NUMBER;
    v_count_b    NUMBER;
    
    CURSOR A (
		p_pack_line_cd gipi_witem.pack_line_cd%TYPE,
		p_pack_subline_cd gipi_witem.pack_subline_cd%TYPE) IS
        SELECT item_no
          FROM gipi_witem
         WHERE par_id = p_par_id
		   AND pack_line_cd = p_pack_line_cd
		   AND pack_subline_cd = p_pack_subline_cd;
    
    CURSOR B (p_item_no NUMBER) IS
        SELECT '1'
          FROM gipi_wvehicle
         WHERE par_id = p_par_id
           AND item_no = p_item_no;
BEGIN
    IF Check_Pack_Pol_Flag(p_par_id) = 'Y'THEN
		FOR i IN (
			SELECT item_no, pack_line_cd, pack_subline_cd
			  FROM gipi_witem
			 WHERE par_id = p_par_id)
		LOOP
			FOR A1 IN A(i.pack_line_cd, i.pack_subline_cd)
			LOOP
				v_count_a := NVL(v_count_a, 0) + 1;
				FOR B1 IN B(A1.item_no)
				LOOP
					v_count_b := NVL(v_count_b, 0) + 1;
                END LOOP;
            END LOOP;
            
            UPDATE gipi_wpack_line_subline
               SET item_tag = DECODE(v_count_a, v_count_b, 'Y', 'N')
             WHERE par_id = p_par_id
               AND pack_line_cd = i.pack_line_cd
               AND pack_subline_cd = i.pack_subline_cd;
        END LOOP;
    END IF;
END UPD8_GIPI_WPACK_LINE_SUBLINE;
/


