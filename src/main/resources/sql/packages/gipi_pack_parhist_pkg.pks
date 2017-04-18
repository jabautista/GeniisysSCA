CREATE OR REPLACE PACKAGE CPI.Gipi_Pack_Parhist_Pkg AS

    PROCEDURE check_pack_parhist(p_pack_par_id      GIPI_PACK_PARHIST.pack_par_id%TYPE,
                                 p_underwriter      GIPI_PACK_PARLIST.underwriter%TYPE);

    PROCEDURE set_gipi_pack_parhist(p_pack_par_id   GIPI_PACK_PARHIST.pack_par_id%TYPE,
                                    p_user_id       GIPI_PACK_PARHIST.user_id%TYPE,
                                    p_entry_source  GIPI_PACK_PARHIST.entry_source%TYPE,
                                    p_parstat_cd    GIPI_PACK_PARHIST.parstat_cd%TYPE);
        
    PROCEDURE INSERT_PACK_PARHIST(p_pack_par_id        IN gipi_parlist.pack_par_id%TYPE);
                            
END Gipi_Pack_Parhist_Pkg;
/


