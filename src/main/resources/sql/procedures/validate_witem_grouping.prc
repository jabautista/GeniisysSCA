DROP PROCEDURE CPI.VALIDATE_WITEM_GROUPING;

CREATE OR REPLACE PROCEDURE CPI.validate_witem_grouping(
	   	  		  p_par_id	     IN  GIPI_PARLIST.par_id%TYPE,
	   	  		  p_msg_alert    OUT VARCHAR2
	   	  		  )
	    IS
  CURSOR c IS SELECT DISTINCT item_grp 
                FROM GIPI_WITEM
               WHERE par_id = p_par_id;
  v_item_grp 		GIPI_WITEM.item_grp%TYPE;
  v_currency_cd 	GIPI_WITEM.currency_cd%TYPE;
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_witem_grouping program unit
  */
 -- :gauge.FILE := 'passing validate policy ITEM GROUPING';
 -- vbx_counter;
  OPEN c;
  LOOP
    FETCH c INTO v_item_grp;
       IF c%NOTFOUND THEN
          EXIT;
       ELSE
          BEGIN 
            SELECT DISTINCT currency_cd
              INTO v_currency_cd
              FROM GIPI_WITEM
             WHERE item_grp = v_item_grp AND
                   par_id   = p_par_id;
          EXCEPTION
            WHEN TOO_MANY_ROWS THEN
                 p_msg_alert := 'An item group should have a distinct currency code';
                 --:gauge.FILE := 'An item group should have a distinct currency code';
                 --error_rtn;
          END;
       END IF;
  END LOOP; 
  CLOSE c;
END;
/


