DROP PROCEDURE CPI.POST_INS_WPOLGENIN_GIPIS031A;

CREATE OR REPLACE PROCEDURE CPI.POST_INS_WPOLGENIN_GIPIS031A(p_pack_par_id   IN  GIPI_PACK_WPOLGENIN.pack_par_id%TYPE,
                                                             p_par_id        IN  GIPI_WPOLGENIN.par_id%TYPE)
IS

    /*
    **  Created by        : Veronica V. Raymundo
    **  Date Created     : 10.25.2011
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : Insert / Updates GIPI_WPOLGENIN of the sub-PARs
    **                    whenever Package PAR changes GIPI_PACK_WPOLGENIN record.
    */
                                          
BEGIN

    FOR i IN (SELECT gen_info01,     gen_info02,     gen_info03,     gen_info04,     
                     gen_info05,     gen_info06,     gen_info07,     gen_info08,     
                     gen_info09,     gen_info10,     gen_info11,     gen_info12, 
                     gen_info13,     gen_info14,     gen_info15,     gen_info16,     
                     gen_info17,     genin_info_cd,  agreed_tag,
                     initial_info01, initial_info02, initial_info03, 
                     initial_info04, initial_info05, initial_info06, 
                     initial_info07, initial_info08, initial_info09, 
                     initial_info10, initial_info11, initial_info12, 
                     initial_info13, initial_info14, initial_info15, 
                     initial_info16, initial_info17                        
              FROM GIPI_PACK_WPOLGENIN
              WHERE pack_par_id = p_pack_par_id)

    LOOP
        MERGE INTO GIPI_WPOLGENIN
         USING DUAL ON ( par_id = p_par_id )
           WHEN NOT MATCHED THEN
             INSERT (par_id,         gen_info01,     gen_info02,     gen_info03,          
                     gen_info04,     gen_info05,     gen_info06,     gen_info07,          
                     gen_info08,     gen_info09,     gen_info10,     gen_info11,      
                     gen_info12,     gen_info13,     gen_info14,     gen_info15,          
                     gen_info16,     gen_info17,     genin_info_cd,  agreed_tag,
                     initial_info01, initial_info02, initial_info03, 
                     initial_info04, initial_info05, initial_info06, 
                     initial_info07, initial_info08, initial_info09, 
                     initial_info10, initial_info11, initial_info12, 
                     initial_info13, initial_info14, initial_info15, 
                     initial_info16, initial_info17 )
             VALUES (p_par_id,       i.gen_info01,   i.gen_info02,   i.gen_info03,          
                     i.gen_info04,   i.gen_info05,   i.gen_info06,   i.gen_info07,          
                     i.gen_info09,   i.gen_info10,   i.gen_info11,   i.gen_info12, 
                     i.gen_info08,   i.gen_info13,   i.gen_info14,   i.gen_info15,          
                     i.gen_info16,   i.gen_info17,   i.genin_info_cd,i.agreed_tag,
                     i.initial_info01, i.initial_info02, i.initial_info03, 
                     i.initial_info04, i.initial_info05, i.initial_info06, 
                     i.initial_info07, i.initial_info08, i.initial_info09, 
                     i.initial_info10, i.initial_info11, i.initial_info12, 
                     i.initial_info13, i.initial_info14, i.initial_info15, 
                     i.initial_info16, i.initial_info17)
           WHEN MATCHED THEN
             UPDATE SET gen_info01  = i.gen_info01,     
                        gen_info02  = i.gen_info02,     
                        gen_info03  = i.gen_info03,     
                        gen_info04  = i.gen_info04,     
                        gen_info05  = i.gen_info05,     
                        gen_info06  = i.gen_info06,     
                        gen_info07  = i.gen_info07,     
                        gen_info08  = i.gen_info08,     
                        gen_info09  = i.gen_info09,     
                        gen_info10  = i.gen_info10,     
                        gen_info11  = i.gen_info11,     
                        gen_info12  = i.gen_info12, 
                        gen_info13  = i.gen_info13,     
                        gen_info14  = i.gen_info14,     
                        gen_info15  = i.gen_info15,     
                        gen_info16  = i.gen_info16,     
                        gen_info17  = i.gen_info17,     
                        genin_info_cd  = i.genin_info_cd,  
                        agreed_tag  = i.agreed_tag,
                        initial_info01 = i.initial_info01, 
                        initial_info02 = i.initial_info02, 
                        initial_info03 = i.initial_info03, 
                        initial_info04 = i.initial_info04, 
                        initial_info05 = i.initial_info05, 
                        initial_info06 = i.initial_info06, 
                        initial_info07 = i.initial_info07, 
                        initial_info08 = i.initial_info08, 
                        initial_info09 = i.initial_info09, 
                        initial_info10 = i.initial_info10, 
                        initial_info11 = i.initial_info11, 
                        initial_info12 = i.initial_info12, 
                        initial_info13 = i.initial_info13, 
                        initial_info14 = i.initial_info14, 
                        initial_info15 = i.initial_info15, 
                        initial_info16 = i.initial_info16, 
                        initial_info17 = i.initial_info17;
    END LOOP;
END;
/


