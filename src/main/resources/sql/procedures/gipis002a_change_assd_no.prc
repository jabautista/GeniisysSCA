DROP PROCEDURE CPI.GIPIS002A_CHANGE_ASSD_NO;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_CHANGE_ASSD_NO
(p_pack_par_id        GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
 p_assd_no            GIPI_PACK_WPOLBAS.assd_no%TYPE)

IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 11, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This executes WHEN-VALIDATE-ITEM trigger in B240.DSP_ASSURED_NAME of GIPIS002A. 
**                 Only executed if assured is change in Package PAR Basic Information.          
*/
 
BEGIN
    
    UPDATE gipi_parlist
      SET assd_no = p_assd_no
    WHERE pack_par_id = p_pack_par_id
    AND par_status NOT IN (98,99);

    UPDATE gipi_wpolbas
      SET assd_no = p_assd_no
    WHERE pack_par_id = p_pack_par_id;

    UPDATE gipi_witem
      SET group_cd = NULL
    WHERE EXISTS (SELECT 1
                    FROM gipi_parlist z
                   WHERE z.par_id = gipi_witem.par_id
                     AND z.pack_par_id = p_pack_par_id); 

    UPDATE gipi_wgrouped_items
      SET group_cd = NULL     
    WHERE EXISTS (SELECT 1
                    FROM gipi_parlist z
                   WHERE z.par_id = gipi_wgrouped_items.par_id
                     AND z.pack_par_id = p_pack_par_id);     
                     
    FOR A IN (SELECT '1'
              FROM gipi_witmperl
              WHERE EXISTS (SELECT 1
                            FROM gipi_parlist
                            WHERE par_id = gipi_witmperl.par_id
                            AND pack_par_id = p_pack_par_id))          
              
    LOOP                                             
        FOR c1 IN (SELECT par_id, line_cd, iss_cd
                    FROM gipi_parlist
                   WHERE pack_par_id = p_pack_par_id
                     AND par_status NOT IN (98,99))    
        LOOP                                     
           create_winvoice(0,0,0,c1.par_id,c1.line_cd,c1.iss_cd);
           UPDATE gipi_parlist
               SET par_status = 5
           WHERE par_id = c1.par_id
                AND par_status NOT IN (98,99);                 
        END LOOP;  

        UPDATE gipi_pack_parlist
          SET par_status = 5
        WHERE pack_par_id = p_pack_par_id;
    END LOOP;
END;
/


