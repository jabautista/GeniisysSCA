CREATE OR REPLACE PACKAGE BODY CPI.GIPI_PACK_WINV_TAX_PKG
AS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 03.24.2011
	**  Reference By 	: (GIPIS095 - Package Policy Items)
	**  Description 	: Delete records from gipi_pack_winv_tax using the given pack_par_id
	*/
	PROCEDURE del_gipi_pack_winv_tax(p_pack_par_id IN gipi_pack_winv_tax.pack_par_id%TYPE)
	IS
	BEGIN
		DELETE FROM gipi_pack_winv_tax
		 WHERE pack_par_id = p_pack_par_id;
	END;

  /*
  **  Created by   : Jerome Orio
  **  Date Created : 07-12-2011
  **  Reference By : (GIPIS055a - POST PACKAGE PAR)
  **  Description  : COPY_PACK_POL_WINV_TAX program unit
  */
    PROCEDURE COPY_PACK_POL_WINV_TAX(
        p_item_grp IN gipi_winv_tax.item_grp%TYPE,
        p_pack_par_id       IN gipi_parlist.pack_par_id%TYPE,
        p_pack_prem_seq_no  IN gipi_invoice.prem_seq_no%TYPE
        ) IS
    BEGIN
      INSERT INTO gipi_pack_inv_tax
                 (prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
                  tax_allocation,fixed_tax_allocation,rate)
           SELECT p_pack_prem_seq_no,iss_cd,tax_cd,tax_amt,line_cd,item_grp,tax_id,
                  tax_allocation,fixed_tax_allocation,rate
             FROM gipi_pack_winv_tax
            WHERE item_grp = p_item_grp AND
                  pack_par_id  = p_pack_par_id;
    END;

END GIPI_PACK_WINV_TAX_PKG;
/


