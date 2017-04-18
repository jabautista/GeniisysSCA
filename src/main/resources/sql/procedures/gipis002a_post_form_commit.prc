DROP PROCEDURE CPI.GIPIS002A_POST_FORM_COMMIT;

CREATE OR REPLACE PROCEDURE CPI.GIPIS002A_POST_FORM_COMMIT
(p_pack_par_id       IN     GIPI_PARLIST.pack_par_id%TYPE)
IS

BEGIN
  FOR c1 IN (SELECT par_id, line_cd, iss_cd
               FROM gipi_parlist
              WHERE par_status NOT IN (98,99)
                AND pack_par_id = p_pack_par_id)
  LOOP
    create_winvoice(0,0,0,c1.par_id,c1.line_cd,c1.iss_cd);
  END LOOP;
  
  UPDATE gipi_pack_parlist
     SET par_status = 5
   WHERE pack_par_id = p_pack_par_id; 
  UPDATE gipi_parlist
     SET par_status = 5
   WHERE pack_par_id = p_pack_par_id
     AND par_status NOT IN (98,99);

END GIPIS002A_POST_FORM_COMMIT;
/


