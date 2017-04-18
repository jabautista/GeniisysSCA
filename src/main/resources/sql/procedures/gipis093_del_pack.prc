DROP PROCEDURE CPI.GIPIS093_DEL_PACK;

CREATE OR REPLACE PROCEDURE CPI.gipis093_del_pack (
   p_par_id   gipi_wpack_line_subline.par_id%TYPE,
   p_iss_cd   VARCHAR2
)
IS
BEGIN
   IF p_iss_cd = giisp.v ('ISS_CD_RI')
   THEN
      DELETE FROM giri_winpolbas
            WHERE par_id = p_par_id;
   END IF;
    
   DELETE FROM gipi_wpolbas
         WHERE par_id = p_par_id;
   
   DELETE FROM gipi_wendttext    --added by christian 12132012
		WHERE par_id = p_par_id;
END;
/


