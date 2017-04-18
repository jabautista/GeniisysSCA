DROP PROCEDURE CPI.SET_PACKAGE_MENU;

CREATE OR REPLACE PROCEDURE CPI.SET_PACKAGE_MENU(
	   p_pack_par_id	GIPI_PARLIST.PACK_PAR_ID%TYPE) IS
/******************************************************************************
BRY simplified version for single parameter requirement. kindly include condition
 for pack_pol_flag in your methods in Java
******************************************************************************/
  v_count     NUMBER;
  v_par_status  gipi_pack_parlist.par_status%TYPE;
BEGIN
  --IF variables.v_pack_pol_flag = 'Y' THEN
	  SELECT COUNT(*)
	  INTO v_count
	  FROM gipi_wpack_line_subline
	 WHERE NOT EXISTS (SELECT 1
	                     FROM gipi_parlist z
	                    WHERE z.par_id = gipi_wpack_line_subline.par_id
	                      AND z.par_status IN (98,99))
	  AND pack_par_id = p_pack_par_id
	  AND item_tag = 'N';
     IF v_count > 0 THEN
        NULL; --set_menu_item_property('EDIT_PAR_MENU.PERIL_INFO', enabled, property_false);
     ELSE
        --set_menu_item_property('EDIT_PAR_MENU.PERIL_INFO', enabled, property_true);
        SELECT par_status
          INTO v_par_status
          FROM gipi_pack_parlist
         WHERE pack_par_id = p_pack_par_id;
        IF v_par_status = 3 THEN 
	        UPDATE gipi_pack_parlist
	           SET par_status = 4
	         WHERE pack_par_id = p_pack_par_id; 
        END IF;
     END IF;
  --END IF;
END SET_PACKAGE_MENU;
/


