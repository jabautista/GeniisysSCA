CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_WINSTALLMENT_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description     : Delete records from gipi_pack_winstallment using the given pack_par_id
    */
    PROCEDURE del_gipi_pack_winstallment(p_pack_par_id IN gipi_pack_winstallment.pack_par_id%TYPE)
    IS
    BEGIN
        DELETE FROM gipi_pack_winstallment
         WHERE pack_par_id = p_pack_par_id;
    END;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : COPY_PACK_POL_WINSTALLMENT program unit
  */
    PROCEDURE COPY_PACK_POL_WINSTALLMENT(
        p_item_grp          IN gipi_winvoice.item_grp%TYPE,
        p_pack_par_id       IN gipi_parlist.pack_par_id%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_pack_prem_seq_no  IN gipi_invoice.prem_seq_no%TYPE
        ) IS
    BEGIN
          INSERT INTO gipi_pack_installment
                     (iss_cd,prem_seq_no,item_grp,inst_no,share_pct,
                          tax_amt,prem_amt,due_date)
               SELECT p_iss_cd, p_pack_prem_seq_no,item_grp,inst_no,
                      share_pct,tax_amt,prem_amt,due_date
                 FROM gipi_pack_winstallment
                WHERE pack_par_id   =  p_pack_par_id
                  AND item_grp =  p_item_grp;
    END;

END GIPI_PACK_WINSTALLMENT_PKG;
/


