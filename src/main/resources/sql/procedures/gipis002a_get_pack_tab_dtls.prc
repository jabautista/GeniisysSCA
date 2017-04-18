DROP PROCEDURE CPI.GIPIS002A_GET_PACK_TAB_DTLS;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_GET_PACK_TAB_DTLS
(p_pack_par_id             IN          GIPI_PARLIST.pack_par_id%TYPE,
 p_gipi_witem_exist        OUT         VARCHAR2,
 p_gipi_witmperl_exist     OUT         NUMBER,
 p_gipi_winvoice_exist     OUT         NUMBER)
 
/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 04, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  :  This determines whether Package PAR's sub-policies have 
**                    existing records in GIPI_WITEM, GIPI_WITMPERL and GIPI_WINVOICE.         
*/
 
 IS
 
 v_gipi_witmperl_exist    NUMBER := 0;
 
BEGIN
    FOR A2 IN (
           SELECT 1
             FROM gipi_witmperl
            WHERE EXISTS (SELECT 1
                          FROM gipi_parlist z
                          WHERE z.par_id = gipi_witmperl.par_id
                          AND z.par_status NOT IN (98,99)
                          AND z.pack_par_id = p_pack_par_id)) 
    LOOP
        v_gipi_witmperl_exist := 1;
    END LOOP;
    
    GIPI_WINVOICE_PKG.check_gipi_winvoice_for_pack(p_pack_par_id, p_gipi_winvoice_exist);  
    p_gipi_witem_exist := GIPI_WITEM_PKG.check_gipi_witem_for_pack(p_pack_par_id);
    p_gipi_witmperl_exist :=  v_gipi_witmperl_exist;
    
END;
/


