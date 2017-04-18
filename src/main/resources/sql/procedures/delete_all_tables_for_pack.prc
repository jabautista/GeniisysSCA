DROP PROCEDURE CPI.DELETE_ALL_TABLES_FOR_PACK;

CREATE OR REPLACE PROCEDURE CPI.DELETE_ALL_TABLES_FOR_PACK
(p_pack_par_id     IN       GIPI_PACK_PARLIST.pack_par_id%TYPE)

IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This deletes all table records of Package PAR and its sub-policies. 
**				   		 
*/

BEGIN
    FOR i IN (SELECT par_id
              FROM gipi_parlist
              WHERE par_status NOT IN (98,99)
              AND pack_par_id = p_pack_par_id)
    LOOP
        DELETE_ALL_TABLES2(i.par_id);
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
	 
	 DELETE FROM gipi_pack_wpolnrep
	   WHERE  pack_par_id  = p_pack_par_id;
	   
	 DELETE FROM gipi_pack_wpolwc
	   WHERE  pack_par_id  = p_pack_par_id;

END;
/


