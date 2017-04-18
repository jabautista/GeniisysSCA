DROP FUNCTION CPI.CHECK_IF_USER_ALLOWED_FOR_EDIT;

CREATE OR REPLACE FUNCTION CPI.check_if_user_allowed_for_edit(p_module_name giac_modules.MODULE_NAME%TYPE,
	   	  		  		   	p_user_id giac_user_functions.USER_ID%TYPE)
  RETURN VARCHAR2 IS
  
  v_update 		  VARCHAR2(1);
  v_data 		  NUMBER(1);

BEGIN								
  FOR a IN (SELECT 1 count 
	  	    FROM giac_user_functions a, giac_functions b, giac_modules c
		   WHERE b.module_id = c.module_id
		     AND a.function_code = b.function_code
			 AND a.user_id = p_user_id
			 AND c.module_name = p_module_name
		 )
		 
    LOOP 
		 v_data := a.count;
    END LOOP;
    
  
  IF v_data = 1 THEN
    v_update := 'Y';
  ELSE
    v_update := 'N';
  END IF;

  RETURN v_update;
END;
/


