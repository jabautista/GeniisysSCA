DROP FUNCTION CPI.VALIDATE_ENDT_ADDTL_INFO_MC;

CREATE OR REPLACE FUNCTION CPI.validate_endt_addtl_info_mc(p_par_id IN NUMBER)
RETURN VARCHAR2
  /*
	**  Created by		: Emman
	**  Date Created 	: 06.23.2010
	**  Reference By 	: (GIPIS060 - Endt Item Information)
	**  Description 	: Checks the presence of information in the table gipi_wvehicle
	** 					   before proceeding.  Gipi_wvehicle is required for all items.
	*/
IS    
   CURSOR  P IS
             SELECT  item_no
               FROM  gipi_witem
              WHERE  par_id = p_par_id
                AND  ann_tsi_amt IS NULL
                AND  upper(pack_line_cd) = 'MC'
           ORDER BY  item_no;
   CURSOR  A IS
             SELECT  item_no,rec_flag
               FROM  gipi_witem
              WHERE  par_id = p_par_id
                AND  ann_tsi_amt IS NULL
           ORDER BY  item_no;
   CURSOR  B(p_item_no   gipi_witem.item_no%TYPE) IS
             SELECT  item_no
               FROM  gipi_wvehicle
              WHERE  par_id = p_par_id
                AND  item_no = p_item_no;
   p_exist             VARCHAR2(1) := 'N';
   no_vehicle_info     VARCHAR2(50):= NULL;
   v_pack_pol_flag	   GIPI_WPOLBAS.pack_pol_flag%TYPE;
BEGIN
  SELECT pack_pol_flag
    INTO v_pack_pol_flag
    FROM gipi_wpolbas
   WHERE par_id = p_par_id;
   
  IF v_pack_pol_flag = 'Y' THEN
    FOR P1 IN P LOOP
      FOR B2 IN B(p1.item_no) LOOP
         p_exist := 'Y';
         EXIT;
      END LOOP;
      IF p_exist = 'N' THEN
         no_vehicle_info := no_vehicle_info || TO_CHAR(p1.item_no)||', ';
      END IF;
      p_exist := 'N';
    END LOOP;
  ELSE
    FOR A1 IN A LOOP
      FOR B2 IN B(a1.item_no) LOOP
         p_exist := 'Y';
         EXIT;
      END LOOP;
      IF p_exist = 'N' and a1.rec_flag = 'A' THEN
         no_vehicle_info := no_vehicle_info || TO_CHAR(a1.item_no)||', ';
      END IF;
      p_exist := 'N';
    END LOOP;
  END IF;
  IF  no_vehicle_info IS NOT NULL THEN
    RETURN 'Item no(s) '|| SUBSTR(no_vehicle_info, 1, NVL(LENGTH(no_vehicle_info), 0)-2)||
              '  does not have corresponding vehicle information. '||
              'Please enter the necessary information.';
  END IF;
  
  RETURN 'SUCCESS';
END;
/


