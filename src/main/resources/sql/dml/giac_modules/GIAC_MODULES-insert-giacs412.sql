/* Formatted on 2014/01/20 13:35 (Formatter Plus v4.8.8) */
DECLARE
   v_exists      VARCHAR2 (1)                  := 'N';
   v_module_id   giac_modules.module_id%TYPE;
   v_max         NUMBER(5); 
BEGIN
    BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM giac_modules
         WHERE module_name = 'GIACS412';
       
        IF v_exists = 'Y' THEN
            DBMS_OUTPUT.PUT_LINE('Record with module_name = GIACS412 already exists in GIAC_MODULES.');    
        END IF;
   
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            BEGIN
                SELECT MAX (module_id) + 1
                  INTO v_max
                  FROM giac_modules;
                  
                IF v_max > 999 THEN
                    FOR i IN ( SELECT min_a - 1 + LEVEL available_id
                                 FROM ( SELECT MIN(module_id) min_a
                                              , MAX(module_id) max_a
                                          FROM giac_modules
                                       )
                              CONNECT BY LEVEL <= max_a - min_a + 1
                                MINUS
                               SELECT module_id
                                 FROM giac_modules)
                    LOOP
                        v_module_id := i.available_id;
                        EXIT;
                    END LOOP;
                ELSE
                    v_module_id := v_max;
                END IF;
            END;

            BEGIN
                INSERT INTO giac_modules
                             (module_id, module_name, scrn_rep_name, scrn_rep_tag, functions_tag,
                              user_id, last_update
                             )
                     VALUES (v_module_id, 'GIACS412', 'UPDATE CANCELLED POLICY ACCOUNTS', 'S', 'Y',
                              'CPI', SYSDATE
                             );

                COMMIT;
                     
                DBMS_OUTPUT.PUT_LINE('Successfully inserted module_name = GIACS412 in GIAC_MODULES.');
            END;
    END;
END;