DROP PROCEDURE CPI.GIPIS002A_B550_POST_UPDATE;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_B550_POST_UPDATE
(p_pack_par_id       IN     GIPI_PACK_WPOLGENIN.pack_par_id%TYPE)

IS

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  February 28, 2013
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : Updates the records of the sub-PARs' gipi_wpolgenin records 
**                 when GIPI_PACK_WPOLGENIN of the Package is modified           
*/

BEGIN
    FOR i IN (SELECT gen_info01,     gen_info02,     gen_info03, 
                     gen_info04,     gen_info05,     gen_info06, 
                     gen_info07,     gen_info08,     gen_info09, 
                     gen_info10,     gen_info11,     gen_info12, 
                     gen_info13,     gen_info14,     gen_info15, 
                     gen_info16,     gen_info17,     genin_info_cd, 
                     initial_info01, initial_info02, initial_info03, 
                     initial_info04, initial_info05, initial_info06, 
                     initial_info07, initial_info08, initial_info09, 
                     initial_info10, initial_info11, initial_info12, 
                     initial_info13, initial_info14, initial_info15, 
                     initial_info16, initial_info17, agreed_tag                       
                FROM GIPI_PACK_WPOLGENIN
               WHERE pack_par_id = p_pack_par_id)
    LOOP
    
        UPDATE GIPI_WPOLGENIN
           SET gen_info01       =  i.gen_info01,     
               gen_info02       =  i.gen_info02,     
               gen_info03       =  i.gen_info03, 
               gen_info04       =  i.gen_info04,     
               gen_info05       =  i.gen_info05,     
               gen_info06       =  i.gen_info06, 
               gen_info07       =  i.gen_info07,     
               gen_info08       =  i.gen_info08,     
               gen_info09       =  i.gen_info09, 
               gen_info10       =  i.gen_info10,     
               gen_info11       =  i.gen_info11,     
               gen_info12       =  i.gen_info12, 
               gen_info13       =  i.gen_info13,     
               gen_info14       =  i.gen_info14,     
               gen_info15       =  i.gen_info15, 
               gen_info16       =  i.gen_info16,     
               gen_info17       =  i.gen_info17,     
               genin_info_cd    =  i.genin_info_cd, 
               initial_info01   =  i.initial_info01, 
               initial_info02   =  i.initial_info02, 
               initial_info03   =  i.initial_info03, 
               initial_info04   =  i.initial_info04, 
               initial_info05   =  i.initial_info05, 
               initial_info06   =  i.initial_info06, 
               initial_info07   =  i.initial_info07, 
               initial_info08   =  i.initial_info08, 
               initial_info09   =  i.initial_info09, 
               initial_info10   =  i.initial_info10, 
               initial_info11   =  i.initial_info11, 
               initial_info12   =  i.initial_info12, 
               initial_info13   =  i.initial_info13, 
               initial_info14   =  i.initial_info14, 
               initial_info15   =  i.initial_info15, 
               initial_info16   =  i.initial_info16, 
               initial_info17   =  i.initial_info17, 
               agreed_tag       =  i.agreed_tag
         WHERE par_id IN (SELECT par_id
                          FROM GIPI_PARLIST
                          WHERE pack_par_id = p_pack_par_id);
                         
         RETURN; 
    
    END LOOP;
END;
/


