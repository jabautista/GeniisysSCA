DROP PROCEDURE CPI.GIPIS002A_PRE_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_PRE_COMMIT
(p_pack_par_id    IN    GIPI_PARLIST.pack_par_id%TYPE)
IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  :  This delete/update records of Package PAR's sub-policies
**                    with the given pack_par_id.         
*/

BEGIN
    FOR c1 IN (SELECT par_id
               FROM gipi_parlist
               WHERE par_status NOT IN (98,99)
               AND pack_par_id = p_pack_par_id) 
    LOOP              
    DELETE gipi_wcomm_inv_perils
     WHERE par_id = c1.par_id;
   
    DELETE gipi_wcomm_invoices
     WHERE par_id = c1.par_id;

    DELETE gipi_winstallment
     WHERE par_id = c1.par_id;

    DELETE gipi_winv_tax
       WHERE par_id = c1.par_id; 

    DELETE gipi_winvoice
     WHERE par_id = c1.par_id;

    DELETE gipi_witmperl
     WHERE par_id = c1.par_id; 
 
    UPDATE gipi_witem
    SET tsi_amt = NULL,
        prem_amt = NULL,
        ann_tsi_amt = NULL,
        ann_prem_amt = NULL
    WHERE par_id = c1.par_id; 
    
    UPDATE gipi_wpolbas
    SET tsi_amt = NULL,
        prem_amt = NULL,
        ann_tsi_amt = NULL,
        ann_prem_amt = NULL
    WHERE par_id = c1.par_id; 
 END LOOP;
   
END GIPIS002A_PRE_COMMIT;
/


