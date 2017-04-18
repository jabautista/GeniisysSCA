DROP PROCEDURE CPI.GIPIS060_SET_PACKAGE_MENU;

CREATE OR REPLACE PROCEDURE CPI.gipis060_set_package_menu(
	   p_par_id	  			GIPI_WPOLBAS.par_id%TYPE,
	   p_pack_par_id		GIPI_WPOLBAS.pack_par_id%TYPE)
IS
  v_count     NUMBER;
  v_par_status  gipi_pack_parlist.par_status%TYPE;
  v_pack_pol_flag	 GIPI_WPOLBAS.pack_pol_flag%TYPE;
BEGIN
  FOR TEMP IN(SELECT PACK_POL_FLAG
   	      FROM GIPI_WPOLBAS
	      WHERE PAR_ID = p_par_id) LOOP
      V_PACK_POL_FLAG := TEMP.PACK_POL_FLAG;
	      EXIT;
  END LOOP;
	
  IF v_pack_pol_flag = 'Y' THEN
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
        --set_menu_item_property('EDIT_PAR_MENU.PERIL_INFO', enabled, property_false);
		NULL;
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
  END IF;
END;
/


