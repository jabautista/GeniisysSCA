/*
** Created by   : Ferdinand Angeles
** Date Created : 09/16/2014
** Descriptions : Created a script to add parameter 24TH_METHOD_DEF_COMP.
*/
SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
    SELECT 1
      INTO v_exist
      FROM cpi.giac_parameters
     WHERE param_name = '24TH_METHOD_DEF_COMP';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Parameter 24TH_METHOD_DEF_COMP already exists.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO cpi.giac_parameters
            (param_type, param_name, param_value_v, user_id, last_update,
             remarks
            )
         VALUES ('V', '24TH_METHOD_DEF_COMP', 'Y', USER, SYSDATE,
                 'Y - Computation using months between as denominator; '||
                 'N - Computation using 24 as denominator; '
                );
    COMMIT;
    
        DBMS_OUTPUT.PUT_LINE('Successfully added parameter 24TH_METHOD_DEF_COMP.');
END;

