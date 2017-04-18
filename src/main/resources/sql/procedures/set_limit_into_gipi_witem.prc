DROP PROCEDURE CPI.SET_LIMIT_INTO_GIPI_WITEM;

CREATE OR REPLACE PROCEDURE CPI.SET_LIMIT_INTO_GIPI_WITEM(p_wopen_liab IN GIPI_WOPEN_LIAB%ROWTYPE)
IS
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  March 22, 2010
**  Reference By : (GIPIS005 - Cargo Limits of Liability,
                    GIPIS172 - Limits of Liability)
**  Description  : Procedure to update witem record or insert if not existing. 
*/  
p_item_no    GIPI_WITEM.item_no%TYPE;
BEGIN
  FOR A IN (SELECT item_no
              FROM gipi_witem
             WHERE par_id = p_wopen_liab.par_id) 
  LOOP
    p_item_no  :=  A.item_no;
  
    DELETE gipi_witem
     WHERE par_id   =  p_wopen_liab.par_id
       AND item_no !=  1;
 
    GIPI_WITEM_PKG.update_tsi_and_currency(p_wopen_liab, 1);
    EXIT;
  END LOOP;

  IF p_item_no IS NULL THEN
    GIPI_WITEM_PKG.insert_limit(p_wopen_liab);
  END IF;
 
END SET_LIMIT_INTO_GIPI_WITEM;
/


