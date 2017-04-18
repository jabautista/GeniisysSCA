DROP PROCEDURE CPI.POST_INS_WENDTTEXT_GIPIS031A;

CREATE OR REPLACE PROCEDURE CPI.POST_INS_WENDTTEXT_GIPIS031A(p_pack_par_id   IN    GIPI_PACK_WENDTTEXT.pack_par_id%TYPE,
                                                             p_par_id        IN    GIPI_WENDTTEXT.par_id%TYPE)
IS

    /*
    **  Created by       : Veronica V. Raymundo
    **  Date Created     :  10.25.2011
    **  Reference By     : (GIPIS031A - Package Endt Basic Information)
    **  Description     : Insert / Updates GIPI_WENDTTEXT of the sub-PARs
    **                    whenever Package PAR changes GIPI_PACK_WENDTTEXT record.
    */
BEGIN                              
    FOR i IN (SELECT endt_tax,      endt_text01,    endt_text02,   
                     endt_text03,   endt_text04,    endt_text05,   
                     endt_text06,   endt_text07,    endt_text08,   
                     endt_text09,   endt_text10,    endt_text11,   
                     endt_text12,   endt_text13,    endt_text14,   
                     endt_text15,   endt_text16,    endt_text17,   
                     endt_cd                           
              FROM GIPI_PACK_WENDTTEXT
              WHERE pack_par_id = p_pack_par_id)

    LOOP
        MERGE INTO GIPI_WENDTTEXT
        USING DUAL ON (par_id = p_par_id)
        WHEN NOT MATCHED THEN
            INSERT(par_id,        endt_text01,    endt_text02,   
                   endt_text03,   endt_text04,    endt_text05,   
                   endt_text06,   endt_text07,    endt_text08,   
                   endt_text09,   endt_text10,    endt_text11,   
                   endt_text12,   endt_text13,    endt_text14,   
                   endt_text15,   endt_text16,    endt_text17,   
                   endt_cd,       endt_tax)
            VALUES(p_par_id,      i.endt_text01,  i.endt_text02,   
                   i.endt_text03, i.endt_text04,  i.endt_text05,   
                   i.endt_text06, i.endt_text07,  i.endt_text08,   
                   i.endt_text09, i.endt_text10,  i.endt_text11,   
                   i.endt_text12, i.endt_text13,  i.endt_text14,   
                   i.endt_text15, i.endt_text16,  i.endt_text17,   
                   i.endt_cd,     i.endt_tax)
        WHEN MATCHED THEN
            UPDATE SET endt_text01  = i.endt_text01,    
                   endt_text02  = i.endt_text02,   
                   endt_text03  = i.endt_text03,   
                   endt_text04  = i.endt_text04,    
                   endt_text05  = i.endt_text05,   
                   endt_text06  = i.endt_text06,   
                   endt_text07  = i.endt_text07,    
                   endt_text08  = i.endt_text08,   
                   endt_text09  = i.endt_text09,   
                   endt_text10  = i.endt_text10,    
                   endt_text11  = i.endt_text11,   
                   endt_text12  = i.endt_text12,   
                   endt_text13  = i.endt_text13,    
                   endt_text14  = i.endt_text14,   
                   endt_text15  = i.endt_text15,   
                   endt_text16  = i.endt_text16,    
                   endt_text17  = i.endt_text17,   
                   endt_cd      = i.endt_cd,       
                   endt_tax     = i.endt_tax;
    END LOOP;
END;
/


