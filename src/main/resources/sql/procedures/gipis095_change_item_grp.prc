DROP PROCEDURE CPI.GIPIS095_CHANGE_ITEM_GRP;

CREATE OR REPLACE PROCEDURE CPI.GIPIS095_CHANGE_ITEM_GRP (
	p_pack_par_id IN gipi_wpack_line_subline.pack_par_id%TYPE)
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Updates the item grouping of the items inserted
	**                    based on the currency rate selected.
	**                    Since the addition of the columns pack_line_cd
	**                    and pack_subline_cd, then the item grouping for
	**               	  packaged policy must be done accordingly, items
	**               	  for package policy must be grouped not only by
	**               	  currency_cd and currency_rt but by pack_line_cd
	**               	  and pack_subline_cd as well (from module description).
    */
    v_pack_pol_flag gipi_pack_wpolbas.pack_pol_flag%TYPE := 'N';
BEGIN
    FOR i IN (
        SELECT pack_pol_flag
          FROM gipi_pack_wpolbas
         WHERE pack_par_id = p_pack_par_id)
    LOOP
        v_pack_pol_flag := i.pack_pol_flag;
        EXIT;
    END LOOP;
    
    FOR c1 IN (
        SELECT par_id
          FROM gipi_witem gw
         WHERE EXISTS (SELECT 1
                         FROM gipi_parlist gp
                        WHERE gp.par_id = gw.par_id
                          AND gp.pack_par_id = p_pack_par_id))
    LOOP
        GIPIS010_CHANGE_ITEM_GRP(c1.par_id, v_pack_pol_flag);
    END LOOP;
END GIPIS095_CHANGE_ITEM_GRP;
/


