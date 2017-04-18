DROP PROCEDURE CPI.GIPIS060_PAR_STATUS_4;

CREATE OR REPLACE PROCEDURE CPI.gipis060_par_status_4(p_par_id   IN NUMBER,
                       p_pack_pol_flag IN OUT GIPI_WPOLBAS.pack_pol_flag%TYPE,
					   p_item_tag	   IN OUT VARCHAR2) IS
BEGIN
       p_pack_pol_flag := CHECK_PACK_POL_FLAG(p_par_id);
       p_item_tag 	   := CHECK_TAG(p_par_id);
       UPDATE    gipi_parlist
          SET    par_status = 4
       WHERE    par_id = p_par_id;
END;
/


