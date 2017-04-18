DROP PROCEDURE CPI.GIPIS060_DELETE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_DELETE_ITEM(p_par_id       gipi_wpolbas.par_id%TYPE,
	   	  		  								 p_item_no      gipi_witem.item_no%TYPE,
												 p_current_item gipi_witem.item_no%TYPE) IS
	   /*
		**  Created by		: Emman
		**  Date Created 	: 06.22.2010
		**  Reference By 	: (GIPIS060 - Endt Item Information)
		**  Description 	: Procedure DELETE_ITEM in GIPIS060
		*/
BEGIN
 DELETE   gipi_wmcacc
   WHERE   par_id   =  p_par_id
     AND   item_no  =  p_item_no;
  DELETE   gipi_wvehicle
   WHERE   par_id   =  p_par_id
     AND   item_no  =  p_item_no;
  --beth 05-08-2000 delete mortgagee of deleted item 
  FOR D3 IN (SELECT  1
               FROM  gipi_wmortgagee
              WHERE  par_id  = p_par_id
                AND  item_no = p_item_no)
  LOOP
    DELETE  gipi_wmortgagee
     WHERE  par_id  = p_par_id
       AND  item_no = p_current_item;    
    EXIT;
  END LOOP;  
  
  FOR D2 IN (SELECT  1
               FROM  gipi_wperil_discount
              WHERE  par_id  = p_par_id
                AND  item_no = p_item_no)
  LOOP
    DELETE  gipi_wperil_discount
     WHERE  par_id  = p_par_id
       AND  item_no =  p_item_no;    
    EXIT;
  END LOOP;
  FOR D1 IN (SELECT  1
               FROM  gipi_witmperl
              WHERE  par_id  = p_par_id
                AND  item_no =  p_item_no)
  LOOP
    DELETE  gipi_witmperl
     WHERE  par_id  = p_par_id
       AND  item_no = p_item_no;    
    EXIT;
  END LOOP;  
  FOR D3 IN (SELECT  1
               FROM  gipi_wdeductibles
              WHERE  par_id  = p_par_id
                AND  item_no =  p_item_no)
  LOOP
    DELETE  gipi_wdeductibles
     WHERE  par_id  = p_par_id
       AND  item_no =  p_item_no;    
    EXIT;
  END LOOP;    
  DELETE  gipi_witem
   WHERE  par_id  = p_par_id
     AND  item_no =  p_item_no;  
END;
/


