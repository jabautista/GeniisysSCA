DROP PROCEDURE CPI.GIPIS081_DELETE_ITEM;

CREATE OR REPLACE PROCEDURE CPI.GIPIS081_DELETE_ITEM(
	   p_par_id	  GIPI_WITEM.par_id%TYPE,
	   p_item_no  GIPI_WITEM.par_id%TYPE
	   ) IS
BEGIN
/***************CREATED BY BRYAN JOSEPH ABULUYAN 10/05/2010**************************/
   DELETE   gipi_waviation_item
   WHERE   par_id   =  p_par_id
     AND   item_no  =  p_item_no;
  
  FOR D2 IN (SELECT  1
               FROM  gipi_wperil_discount
              WHERE  par_id   =  p_par_id
     		  	AND   item_no  =  p_item_no)
  LOOP
    DELETE  gipi_wperil_discount
     WHERE  par_id   =  p_par_id
     AND   item_no  =  p_item_no;
    EXIT;
  END LOOP;
  FOR D1 IN (SELECT  1
               FROM  gipi_witmperl
              WHERE  par_id   =  p_par_id
     AND   item_no  =  p_item_no)
  LOOP
    DELETE  gipi_witmperl
     WHERE  par_id   =  p_par_id
     AND   item_no  =  p_item_no;
    EXIT;
  END LOOP;
  FOR D3 IN (SELECT  1
               FROM  gipi_wdeductibles
              WHERE  par_id   =  p_par_id
     AND   item_no  =  p_item_no)
  LOOP
    DELETE  gipi_wdeductibles
     WHERE  par_id   =  p_par_id
     AND   item_no  =  p_item_no;
    EXIT;
  END LOOP;    
  DELETE  gipi_witem
   WHERE  par_id   =  p_par_id
     AND   item_no  =  p_item_no;
END GIPIS081_DELETE_ITEM;
/


