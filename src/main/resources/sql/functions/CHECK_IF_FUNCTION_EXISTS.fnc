/*
   **  Created by   :  Jerome Bautista
   **  Date Created :  05.28.2015
   **  Description  :  Function to check if a certain accounting function exists or not.
   **
   */
--Jerome
CREATE OR REPLACE FUNCTION CPI.check_if_function_exists(
     p_module_id     giac_functions.module_id%TYPE,
     p_function_code giac_functions.function_code%TYPE)
     
   RETURN VARCHAR2 IS
      v_exists   VARCHAR2 (1);
   BEGIN
      FOR i IN (SELECT '1'
                  FROM GIAC_FUNCTIONS a
                 WHERE module_id = p_module_id
                   AND function_code = p_function_code
      )
      LOOP
         v_exists := 'Y';
         EXIT;
      END LOOP;

      IF v_exists = 'Y'
      THEN
         RETURN('TRUE');         
      END IF;
      
      RETURN('FALSE');
   END;
/
