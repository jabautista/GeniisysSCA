CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_POLNREP_PKG AS

  FUNCTION get_pack_polnrep_count (p_pack_policy_id     GIPI_PACK_POLBASIC.pack_policy_id%TYPE)
    RETURN NUMBER;

    PROCEDURE COPY_PACK_POL_WPOLNREP(
        p_pack_par_id           gipi_parlist.pack_par_id%TYPE,
        p_pack_policy_id        gipi_pack_polgenin.pack_policy_id%TYPE
        );
        
END GIPI_PACK_POLNREP_PKG;
/


