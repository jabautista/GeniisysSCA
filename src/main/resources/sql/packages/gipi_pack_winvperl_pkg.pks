CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_WINVPERL_PKG
AS
	PROCEDURE del_gipi_pack_winvperl(p_pack_par_id IN gipi_pack_winvperl.pack_par_id%TYPE);
    
    PROCEDURE COPY_PACK_POL_WINVPERL(
        p_item_grp          IN gipi_winvperl.item_grp%TYPE,
        p_pack_par_id       IN gipi_parlist.pack_par_id%TYPE,
        p_iss_cd            IN gipi_parlist.iss_cd%TYPE,
        p_pack_prem_seq_no  IN gipi_invoice.prem_seq_no%TYPE
        );
        
END GIPI_PACK_WINVPERL_PKG;
/


