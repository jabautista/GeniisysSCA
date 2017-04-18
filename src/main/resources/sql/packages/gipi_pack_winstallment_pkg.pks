CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_WINSTALLMENT_PKG
AS
	PROCEDURE del_gipi_pack_winstallment(p_pack_par_id IN gipi_pack_winstallment.pack_par_id%TYPE);
    
    PROCEDURE COPY_PACK_POL_WINSTALLMENT(
        p_item_grp          IN gipi_winvoice.item_grp%TYPE,
        p_pack_par_id       IN gipi_parlist.pack_par_id%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_pack_prem_seq_no  IN gipi_invoice.prem_seq_no%TYPE
        );
            
END GIPI_PACK_WINSTALLMENT_PKG;
/


