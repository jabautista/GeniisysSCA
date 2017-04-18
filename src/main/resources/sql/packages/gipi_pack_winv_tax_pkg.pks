CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_WINV_TAX_PKG
AS
	PROCEDURE del_gipi_pack_winv_tax(p_pack_par_id IN gipi_pack_winv_tax.pack_par_id%TYPE);
    
    PROCEDURE COPY_PACK_POL_WINV_TAX(
        p_item_grp IN gipi_winv_tax.item_grp%TYPE,
        p_pack_par_id       IN gipi_parlist.pack_par_id%TYPE,
        p_pack_prem_seq_no  IN gipi_invoice.prem_seq_no%TYPE 
        );
            
END GIPI_PACK_WINV_TAX_PKG;
/


