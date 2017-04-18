CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_WINVOICE_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
    **  Description     : Delete records from gipi_pack_winvoice using the given pack_par_id
    */
    PROCEDURE del_gipi_pack_winvoice(p_pack_par_id IN gipi_pack_winvoice.pack_par_id%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_pack_winvoice
         WHERE pack_par_id = p_pack_par_id;
    END;
END GIPI_PACK_WINVOICE_PKG;
/


