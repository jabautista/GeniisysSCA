DROP PROCEDURE CPI.UPDATE_PAR_STATUS_ENDT_ITMPERL;

CREATE OR REPLACE PROCEDURE CPI.UPDATE_PAR_STATUS_ENDT_ITMPERL (p_par_id        GIPI_PARLIST.par_id%TYPE,
                                                            p_pack_par_id   GIPI_PACK_PARLIST.pack_par_id%TYPE)  
IS

/*
**  Created by    : Menandro G.C. Robes
**  Date Created  : July 1, 2010
**  Reference By  : (GIPIS097 - Endt Item Peril Information)
**  Description   : Procedure to determine and update the status of par.
*/    
 
  v_count  NUMBER(1) := 0;
  v_exist  VARCHAR2(1);
  v_status NUMBER(1);

BEGIN  
  FOR A1 IN(
    SELECT item_no
      FROM gipi_witem
     WHERE par_id   = p_par_id
       AND rec_flag = 'A') 
  LOOP
    v_count := 1;
    v_exist := 'Y'; 
    
    FOR A2 IN(
      SELECT 1 
        FROM gipi_witmperl
       WHERE par_id  = p_par_id 
         AND item_no = a1.item_no) 
    LOOP
      v_count := 0;
      EXIT;
    END LOOP;
   
    IF v_count =  1 THEN
      exit;
    END IF;
  END LOOP;
  
  IF v_exist = 'N' THEN
    FOR A1 IN(
      SELECT item_no
        FROM gipi_witem
       WHERE par_id = p_par_id
         AND rec_flag = 'C') 
    LOOP
      v_exist := 'Y';           
     
      FOR A2 IN(
        SELECT 1 
          FROM gipi_witmperl
         WHERE par_id = p_par_id 
           AND item_no = a1.item_no) 
      LOOP
        v_count := 0;
        EXIT;
      END LOOP;
    END LOOP;
  END IF;  
  
  SELECT DECODE(v_count, 0, 5, 4)
    INTO v_status
    FROM dual;

  Gipi_Parlist_Pkg.update_par_status(p_par_id, v_status);
  
  IF NVL(p_pack_par_id, 0) <> 0 THEN 
    Gipi_Pack_Parlist_Pkg.update_pack_par_status(p_par_id, v_status);
  END IF; 
  
END UPDATE_PAR_STATUS_ENDT_ITMPERL;
/


