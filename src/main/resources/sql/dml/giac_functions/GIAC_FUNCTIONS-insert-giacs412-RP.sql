/* Formatted on 2014/01/20 13:35 (Formatter Plus v4.8.8) */
DECLARE
   v_exists      VARCHAR2 (1)                  := 'N';
   v_module_id   giac_modules.module_id%TYPE;
BEGIN
    BEGIN        
        SELECT module_id
          INTO v_module_id
          FROM giac_modules
         WHERE module_name = 'GIACS412';
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_module_id := NULL;
    END;
    
    BEGIN        
        SELECT 'Y'
          INTO v_exists
          FROM giac_functions
         WHERE module_id = v_module_id 
          AND function_code = 'RP';
         
        IF v_exists = 'Y' THEN
            DBMS_OUTPUT.PUT_LINE('Record with function_code ''RP'' under GIACS412 already exists in GIAC_FUNCTIONS.');    
        END IF;
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            INSERT INTO giac_functions
                     (module_id, function_code,
                      function_name, active_tag,
                      function_desc,
                      user_id, last_update
                     )
              VALUES (v_module_id, 'RP',
                      'REVERSE PROCESSED POLICIES', 'Y',
                      'User is allowed to reverse applied payments to cancelled policies.',
                      'CPI', SYSDATE
                     );

         COMMIT;
        DBMS_OUTPUT.put_line ('Function RP for GIACS412 is inserted.');
    END;
END;