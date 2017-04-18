DROP PROCEDURE CPI.POST_FORMS_COMMIT_GIPIS143;

CREATE OR REPLACE PROCEDURE CPI.Post_forms_commit_gipis143( 
	   	  		  p_par_id	     GIPI_PARLIST.par_id%TYPE,
				  p_line_cd		 GIPI_PARLIST.line_cd%TYPE,
				  p_iss_cd		 GIPI_PARLIST.iss_cd%TYPE
	   	  		  )
	   IS
 item      NUMBER;
 itmperl   NUMBER;
 v_count   NUMBER;
BEGIN
    /*
	**  Created by		: Jerome Orio
	**  Date Created 	: 03.08.2010
	**  Reference By 	: (GIPIS143 - Discount/Surcharge)
	**  Description 	: Post-forms-commit trigger
	*/
	
	 --initialize all discount_sw to 'N' / and surcharge_sw to 'N'
  UPDATE GIPI_WPOLBAS
     SET discount_sw = 'N',
         surcharge_sw = 'N'
   WHERE par_id  =  p_par_id;
 
  FOR A1 IN (SELECT item_no item
               FROM GIPI_WITEM
              WHERE par_id = p_par_id) 
  LOOP
       UPDATE GIPI_WITEM
          SET discount_sw = 'N',
              surcharge_sw = 'N'
        WHERE par_id  = p_par_id
          AND item_no = a1.item;
       FOR A2 IN (SELECT peril_cd peril
                    FROM GIPI_WITMPERL
                   WHERE par_id = p_par_id
                     AND item_no = a1.item) LOOP
              UPDATE GIPI_WITMPERL
                 SET discount_sw = 'N',
                     surcharge_sw = 'N'
               WHERE par_id   = p_par_id
                 AND item_no  = a1.item
                 AND peril_cd = a2.peril;
       END LOOP;
  END LOOP;

  --update the  discount_sw to 'Y' for all the corresponding data 
  --in tables gipi_wpolbas, gipi_witem and gipi_witmperl

  --Replaced by RBD (08162002)
  --include additional validation when updating discount_sw 
  --also, update surcharge_sw if necessary.
  --update discount_sw
  FOR A3 IN (SELECT 1
               FROM GIPI_WPOLBAS_DISCOUNT
              WHERE par_id = p_par_id
                AND disc_amt IS NOT NULL) 
  LOOP
       UPDATE GIPI_WPOLBAS
          SET discount_sw = 'Y'
        WHERE par_id  =  p_par_id;
       EXIT;
  END LOOP;
  --update surcharge_sw
  FOR A3 IN (SELECT 1
               FROM GIPI_WPOLBAS_DISCOUNT
              WHERE par_id = p_par_id
                AND surcharge_amt IS NOT NULL) 
  LOOP
       UPDATE GIPI_WPOLBAS
          SET surcharge_sw = 'Y'
        WHERE par_id  =  p_par_id;
       EXIT;
  END LOOP;              
  --

  --Replaced by RBD (08162002)
  --include additional validation when updating discount_sw 
  --also, update surcharge_sw if necessary.

  -- update gipi_witem
  -- update discount_sw
  FOR A3 IN (SELECT item_no item
               FROM GIPI_WITEM_DISCOUNT
              WHERE par_id = p_par_id
                AND disc_amt IS NOT NULL)
  LOOP
       UPDATE GIPI_WITEM
          SET discount_sw = 'Y'
        WHERE par_id  = p_par_id
          AND item_no = a3.item;
  END LOOP;

  -- update surcharge_sw
  FOR A3 IN (SELECT item_no item
               FROM GIPI_WITEM_DISCOUNT
              WHERE par_id = p_par_id
                AND surcharge_amt IS NOT NULL) 
  LOOP
       UPDATE GIPI_WITEM
          SET surcharge_sw = 'Y'
        WHERE par_id  = p_par_id
          AND item_no = a3.item;
  END LOOP;

  -- update gipi_witmperl
  -- updated discount_sw
  FOR A3 IN (SELECT item_no item, peril_cd peril
               FROM GIPI_WPERIL_DISCOUNT
              WHERE par_id = P_par_id
                AND disc_amt IS NOT NULL
                AND level_tag = '1') 
  LOOP
       UPDATE GIPI_WITMPERL
          SET discount_sw = 'Y'
        WHERE par_id   = p_par_id
          AND item_no  = a3.item
          AND peril_cd = a3.peril;
  END LOOP;

  -- updated discount_sw
  FOR A3 IN (SELECT item_no item, peril_cd peril
               FROM GIPI_WPERIL_DISCOUNT
              WHERE par_id = p_par_id
                AND surcharge_amt IS NOT NULL
                AND level_tag = '1') 
  LOOP
       UPDATE GIPI_WITMPERL
          SET surcharge_sw = 'Y'
        WHERE par_id   = p_par_id
          AND item_no  = a3.item
          AND peril_cd = a3.peril;
  END LOOP;

  /* create new invoice information whenever there are new changes made*/ 
  BEGIN
  DELETE_BILL(p_par_id);
  POPULATE_ORIG_ITMPERIL(p_par_id);   
          
  FOR A IN (SELECT   '1'
              FROM   GIPI_WITMPERL
             WHERE   par_id  = p_par_id) LOOP
    Create_Winvoice(0,0,0,p_par_id,p_line_cd,p_iss_cd); -- modified by aivhie 120301
    EXIT;
  END LOOP;
  
  cr_bill_dist.get_tsi(p_par_id);
  
     UPDATE   GIPI_PARLIST
        SET   par_status  =  5
      WHERE   par_id      =  p_par_id;
  END;
END;
/


