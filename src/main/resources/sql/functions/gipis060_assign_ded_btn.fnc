DROP FUNCTION CPI.GIPIS060_ASSIGN_DED_BTN;

CREATE OR REPLACE FUNCTION CPI.GIPIS060_ASSIGN_DED_BTN(
	   p_par_id	  GIPI_WPOLBAS.par_id%TYPE,
	   p_item_no  GIPI_WITEM.item_no%TYPE
	   ) RETURN VARCHAR2
IS
	exists_ded       VARCHAR2(1) := 'N';
	exists_ded2      VARCHAR2(1) := 'N';
BEGIN    	  
  	 FOR A1 IN (SELECT '1'
  	              FROM gipi_wdeductibles
  	             WHERE par_id  = p_par_id
  	               AND item_no = p_item_no
  	               AND peril_cd = 0)
     LOOP
     	 exists_ded := 'Y';
     	 EXIT;
     END LOOP;
     	FOR ITEM IN (SELECT b480.item_no
	               FROM gipi_witem b480
	              WHERE b480.par_id = p_par_id
	                AND NOT EXISTS (SELECT '1'
	                                  FROM gipi_wdeductibles b350
	                                 WHERE b350.par_id  = b480.par_id
	                                   AND b350.item_no = b480.item_no
	                                   AND b350.peril_cd = 0))
	   LOOP                                
	     exists_ded2 := 'Y';
	     EXIT;
	   END LOOP;  
     IF exists_ded = 'Y'  AND exists_ded2 = 'Y' THEN
  	    RETURN 'SUCCESS';     
     ELSIF exists_ded = 'N' THEN
        RETURN 'Item '|| to_char(p_item_no, '099')||' has no existing deductible(s). '||
                  'You cannot assign a null deductible(s).';   	
     ELSIF exists_ded2 = 'N' THEN
        RETURN 'All existing items already have deductible(s).';   	
     END IF;
END;
/


