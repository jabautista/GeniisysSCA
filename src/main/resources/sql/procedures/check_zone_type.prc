DROP PROCEDURE CPI.CHECK_ZONE_TYPE;

CREATE OR REPLACE PROCEDURE CPI.Check_Zone_Type(
	   	  		  p_par_id		IN  GIPI_PARLIST.par_id%TYPE,
				  p_line_cd		IN  GIPI_PARLIST.line_cd%TYPE,
				  p_msg_alert   OUT VARCHAR2
	   	  		  )
	    IS
  v_exist1       VARCHAR2(1) := 'N'; 
  v_exist2       VARCHAR2(1) := 'N'; 
  v_exist3       VARCHAR2(1) := 'N'; 
  v_item         GIPI_ITEM.item_no%TYPE;
BEGIN  
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 30, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : CHECK_ZONE_TYPE program unit
  */
  
  FOR A IN (SELECT item_no 
              FROM GIPI_WITEM
             WHERE par_id = p_par_id) LOOP
    FOR B IN (SELECT zone_type
                FROM GIIS_PERIL
               WHERE zone_type IS NOT NULL
                 AND zone_type != '4'
                 AND line_cd = p_line_cd
                 AND peril_cd IN (SELECT peril_cd
                                    FROM GIPI_WITMPERL
                                   WHERE par_id  = p_par_id
                                     AND item_no = a.item_no)) LOOP
      IF b.zone_type = '1' THEN
      	 FOR B IN (SELECT flood_zone
      	             FROM GIPI_WFIREITM                          
      	            WHERE par_id = p_par_id
                      AND item_no = a.item_no
                      AND flood_zone IS NULL) LOOP         	   
               v_exist1 := 'Y';
               v_item   := a.item_no;
               EXIT;
         END LOOP;
      ELSIF b.zone_type = '2' THEN
      	 FOR B IN (SELECT typhoon_zone
      	             FROM GIPI_WFIREITM                          
      	            WHERE par_id = p_par_id
                      AND item_no = a.item_no
                      AND typhoon_zone IS NULL) LOOP         	   
               v_exist2 := 'Y';
               v_item   := a.item_no;
               EXIT;
         END LOOP;
      ELSE 
      	 FOR C IN (SELECT eq_zone
      	             FROM GIPI_WFIREITM                          
      	            WHERE par_id = p_par_id
                      AND item_no = a.item_no
                      AND eq_zone IS NULL) LOOP         	   
               v_exist3 := 'Y';
               v_item   := a.item_no;
               EXIT;
         END LOOP;         
      END IF;               
      IF v_exist1 = 'Y' OR v_exist2 = 'Y' OR v_exist3 = 'Y' THEN
      	 EXIT;
      END IF;	 
    END LOOP;    
    IF v_exist1 = 'Y' OR v_exist2 = 'Y' OR v_exist3 = 'Y' THEN
     	 EXIT;
    END IF;	 
  END LOOP;                                  
  IF v_exist1 = 'Y' THEN
     p_msg_alert := 'Flood zone must be entered for item no '||v_item;                     
     --SET_APPLICATION_PROPERTY(CURSOR_STYLE, 'DEFAULT');
     --CURSOR_NORMAL;
     --EXIT_FORM;
  END IF;
  IF v_exist2 = 'Y' THEN
     p_msg_alert := 'Typhoon zone must be entered for item no '||v_item;          
     --SET_APPLICATION_PROPERTY(CURSOR_STYLE, 'DEFAULT');
     -- CURSOR_NORMAL;
     --EXIT_FORM;
  END IF;   
  IF v_exist3 = 'Y' THEN  
     p_msg_alert := 'Earthquake zone must be entered for item no '||v_item;       
     --SET_APPLICATION_PROPERTY(CURSOR_STYLE, 'DEFAULT');
  --   CURSOR_NORMAL;
     --EXIT_FORM;
  END IF;    
END;
/


