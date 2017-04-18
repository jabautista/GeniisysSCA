DROP PROCEDURE CPI.GIPIS010_DEL_POL_DED;

CREATE OR REPLACE PROCEDURE CPI.Gipis010_Del_Pol_Ded (
    p_par_id        IN GIPI_WDEDUCTIBLES.par_id%TYPE,
    p_line_cd        IN GIIS_DEDUCTIBLE_DESC.line_cd%TYPE,
    p_subline_cd    IN GIIS_DEDUCTIBLE_DESC.subline_cd%TYPE)
IS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 03.01.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : Delete record/s on GIPI_WDEDUCTIBLES based on par_id, line_cd, and subline_cd
    */
BEGIN
    DELETE
      FROM GIPI_WDEDUCTIBLES
     WHERE (par_id, ded_deductible_cd) IN 
           (SELECT par_id, ded_deductible_cd
              FROM GIPI_WDEDUCTIBLES, GIIS_DEDUCTIBLE_DESC
             WHERE ded_deductible_cd = deductible_cd
               AND ded_line_cd = line_cd
               AND ded_subline_cd = subline_cd
               AND par_id = p_par_id
               AND ded_line_cd = p_line_cd
               AND ded_subline_cd = p_subline_cd
               AND ded_type = 'T')
       AND item_no = 0;    
END Gipis010_Del_Pol_Ded;
/


