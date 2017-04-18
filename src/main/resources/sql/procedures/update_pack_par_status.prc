DROP PROCEDURE CPI.UPDATE_PACK_PAR_STATUS;

CREATE OR REPLACE PROCEDURE CPI.update_pack_par_status(p_pack_par_id     GIPI_PACK_PARLIST.pack_par_id%TYPE) 
IS
   v_exist          NUMBER;
   v_count          NUMBER;
   v_par_status     GIPI_PACK_PARLIST.par_status%TYPE;

/*
**  Created by   :  Veronica V. Raymundo
**  Date Created :  March 03, 2011
**  Reference By : (GIPIS002A - Package PAR Basic Information)
**  Description  : This updates par status of Package PAR. 
*/
   
BEGIN
  SELECT     count(*)
    INTO     v_count
    FROM     gipi_witem
  WHERE EXISTS (SELECT 1
                  FROM gipi_parlist z
                 WHERE z.par_id = gipi_witem.par_id
                   AND z.par_status NOT IN (98,99)
                   AND z.pack_par_id = p_pack_par_id);
  IF v_count = 0 THEN
     v_par_status := 3;
  ELSE
      NULL;
  END IF;
  
  FOR A1 IN (
   SELECT     distinct 1
    FROM      gipi_pack_wpolbas  
   WHERE      pack_par_id    =    p_pack_par_id) 
  LOOP
     v_exist  := 1;
   EXIT;
  END LOOP;
  
  IF v_exist IS NULL THEN
     v_par_status := 2;
  END IF;
  
  FOR B IN (SELECT  pack_par_id, par_status
            FROM  gipi_pack_parlist
            WHERE  pack_par_id  =  p_pack_par_id) 
  LOOP
     
      IF B.par_status = 2 THEN
         v_par_status := 3;
      END IF;
      
      IF v_par_status IS NOT NULL AND
         v_par_status != B.par_status THEN
        
        UPDATE  gipi_pack_parlist
           SET  par_status  =  v_par_status
         WHERE  pack_par_id =  p_pack_par_id;
        
        UPDATE  gipi_parlist
           SET  par_status  =  v_par_status
         WHERE  par_status NOT IN (98,99)
           AND pack_par_id  =  p_pack_par_id;
        
        EXIT;
      END IF;
      
  END LOOP;
  
END update_pack_par_status;
/


