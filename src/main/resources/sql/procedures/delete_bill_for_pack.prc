DROP PROCEDURE CPI.DELETE_BILL_FOR_PACK;

CREATE OR REPLACE PROCEDURE CPI.DELETE_BILL_FOR_PACK
(p_pack_par_id        IN       GIPI_PARLIST.pack_par_id%TYPE,
 p_co_insurance_sw    IN         NUMBER)

IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This deletes all bill records of Package PAR and its sub-policies. 
**                            
*/

BEGIN

    FOR i IN (SELECT par_id
              FROM gipi_parlist
              WHERE par_status NOT IN (98,99)
              AND pack_par_id = p_pack_par_id)
    LOOP
        DELETE_BILL_GIPIS002(i.par_id, p_co_insurance_sw);
    END LOOP;
    
     DELETE FROM gipi_pack_winstallment
       WHERE  pack_par_id  =  p_pack_par_id;
       
     DELETE FROM gipi_pack_winvperl
       WHERE  pack_par_id  =  p_pack_par_id;
       
     DELETE FROM gipi_pack_winv_tax
       WHERE  pack_par_id  =  p_pack_par_id;
       
     DELETE FROM gipi_pack_winvoice
       WHERE  pack_par_id  =  p_pack_par_id;
       
     DELETE FROM gipi_pack_winvperl
       WHERE  pack_par_id  = p_pack_par_id;
       
     UPDATE gipi_pack_wpolbas 
        SET prem_amt     = 0,
            ann_prem_amt = 0,
            tsi_amt      = 0,
            ann_tsi_amt  = 0,
            discount_sw  = 'N',
            surcharge_sw = 'N'
      WHERE pack_par_id = p_pack_par_id;
     
     UPDATE gipi_pack_parlist
        SET par_status = '4'
      WHERE pack_par_id = p_pack_par_id;
END;
/


