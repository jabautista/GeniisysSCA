DROP PROCEDURE CPI.GIPIS003_UPDATE_WPACK_LINE_SUB;

CREATE OR REPLACE PROCEDURE CPI.GIPIS003_Update_Wpack_Line_Sub (
    p_par_id            IN   GIPI_WPACK_LINE_SUBLINE.par_id%TYPE,
    p_pack_line_cd      IN   GIPI_WPACK_LINE_SUBLINE.pack_line_cd%TYPE,
    p_pack_subline_cd   IN   GIPI_PACK_LINE_SUBLINE.pack_subline_cd%TYPE) 
IS
    v_count_a    NUMBER;
    v_count_b    NUMBER;

   /*
   **   Created by:     Veronica Raymundo
   **   Date Created:   09.14.2010
   **   Reference by:   (GIPIS003 - Item Information FI)
   **   Description:    Update GIPI_WPACK_LINE_SUBLINE 
   **                   (used for post-forms-commit trigger for FI Item Information)
   */ 
      
    CURSOR A IS
        SELECT item_no
          FROM gipi_witem
         WHERE par_id = p_par_id
           AND pack_line_cd = p_pack_line_cd
           AND pack_subline_cd = p_pack_subline_cd;
    
    CURSOR B (p_item_no NUMBER) IS
        SELECT '1'
          FROM gipi_wfireitm
         WHERE par_id = p_par_id
           AND item_no = p_item_no;

BEGIN
    IF Check_Pack_Pol_Flag(p_par_id) = 'Y'THEN
        FOR A1 IN A
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
           AND pack_line_cd = p_pack_line_cd
           AND pack_subline_cd = p_pack_subline_cd;        
    END IF;  
  
END GIPIS003_UPDATE_WPACK_LINE_SUB;
/


