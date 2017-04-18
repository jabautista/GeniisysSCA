CREATE OR REPLACE PACKAGE CPI.Populate_pack_gixx_Tables AS
PROCEDURE extract_pack_pol_record(
     p_pack_policy_id  GIPI_PACK_POLBASIC.pack_policy_id%TYPE,
           v_extract_id      GIXX_PACK_POLBASIC.extract_id%TYPE
     ) ;
PROCEDURE extract_pack_par_record(
     p_pack_par_id  GIPI_PACK_PARLIST.pack_par_id%TYPE,
           v_extract_id         GIXX_PACK_POLBASIC.extract_id%TYPE
     ) ;
END;
/


