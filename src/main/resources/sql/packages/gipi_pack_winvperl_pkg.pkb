CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_WINVPERL_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
    **  Description     : Delete records from gipi_pack_winvperl using the given pack_par_id
    */
    PROCEDURE del_gipi_pack_winvperl(p_pack_par_id IN gipi_pack_winvperl.pack_par_id%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_pack_winvperl
         WHERE pack_par_id = p_pack_par_id;
    END;

    /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : COPY_PACK_POL_WINVPERL program unit
  */
    PROCEDURE COPY_PACK_POL_WINVPERL(
        p_item_grp          IN gipi_winvperl.item_grp%TYPE,
        p_pack_par_id       IN gipi_parlist.pack_par_id%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_pack_prem_seq_no  IN gipi_invoice.prem_seq_no%TYPE
        ) IS
    BEGIN
          INSERT INTO gipi_pack_invperl
                     (iss_cd,prem_seq_no,line_cd, peril_cd,tsi_amt,prem_amt,item_grp,ri_comm_amt,
                      ri_comm_rt)
               SELECT p_iss_cd,p_pack_prem_seq_no, line_cd, peril_cd,tsi_amt,prem_amt,
                      item_grp,ri_comm_amt,ri_comm_rt
                 FROM gipi_pack_winvperl
                WHERE pack_par_id   = p_pack_par_id
                  AND item_grp = p_item_grp;
    END;

END GIPI_PACK_WINVPERL_PKG;
/


