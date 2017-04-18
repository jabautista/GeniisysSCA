DROP PROCEDURE CPI.GIPIS096_POST_FORMS_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.GIPIS096_POST_FORMS_COMMIT(p_pack_par_id   IN  GIPI_PACK_WPOLBAS.pack_par_id%TYPE)

IS

/*
**  Created by   : Veronica V. Raymundo
**  Date Created : July 21, 2011
**  Reference By : (GIPIS096 - Package Endt PAR Policy Items)
**  Description  : Executes the POST-FORMS_COMMIT in GIPIS096 module
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
    
    FOR c1 IN (SELECT par_id
                 FROM gipi_witem gw
                WHERE EXISTS (SELECT 1
                              FROM gipi_parlist gp 
                              WHERE gp.par_id = gw.par_id 
                              AND gp.pack_par_id = p_pack_par_id))
    LOOP            
        CHANGE_ITEM_GRP(c1.par_id, v_pack_pol_flag);
    END LOOP;
       
    --to update the value of gipi_pack_wpolbas
    UPD_GIPI_PACK_WPOLBAS(p_pack_par_id); 
    
    --to update the bank_ref_no of gipi_wpolbas 
    UPDATE_WPOLBAS_REF_NO(p_pack_par_id);
END;
/


