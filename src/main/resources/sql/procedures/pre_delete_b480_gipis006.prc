DROP PROCEDURE CPI.PRE_DELETE_B480_GIPIS006;

CREATE OR REPLACE PROCEDURE CPI.pre_delete_b480_gipis006(
	   	  		  p_par_id    GIPI_WCARGO.par_id%TYPE,
  				  p_item_no   GIPI_WCARGO.item_no%TYPE
	   	  		  )
		IS
BEGIN
	/*
	**  Created by		: Jerome Orio  
	**  Date Created 	: 04.14.2020  
	**  Reference By 	: (GIPIS006- Item Information - Maring Cargo)  
	**  Description 	: pre-delete in 480 block 	  
	*/
   DELETE FROM GIPI_WCARGO_CARRIER
    WHERE PAR_ID =  p_par_id
      AND ITEM_NO = p_item_no;
   
   DELETE    gipi_wcargo
    WHERE    par_id   =   p_par_id
      AND    item_no  =   p_item_no;

  FOR D1 IN (SELECT  1
               FROM  gipi_witmperl
              WHERE  par_id  = p_par_id
                AND  item_no = p_item_no)
  LOOP
    DELETE  gipi_witmperl
     WHERE  par_id  = p_par_id
       AND  item_no = p_item_no;
    EXIT;
  END LOOP;
  FOR D2 IN (SELECT  1
               FROM  gipi_wperil_discount
              WHERE  par_id  = p_par_id
                AND  item_no = p_item_no)
  LOOP
    DELETE  gipi_wperil_discount
     WHERE  par_id  = p_par_id
       AND  item_no = p_item_no;
    EXIT;
  END LOOP;
  FOR D3 IN (SELECT  1
               FROM  gipi_wdeductibles
              WHERE  par_id  = p_par_id
                AND  item_no = p_item_no)
  LOOP
    DELETE  gipi_wdeductibles
     WHERE  par_id  = p_par_id
       AND  item_no = p_item_no;
    EXIT;
  END LOOP;
END;
/


