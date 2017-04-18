SET serveroutput on;
DECLARE
    v_exists VARCHAR2(1) := 'N';
BEGIN
    BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM CPI.giis_parameters
         WHERE param_name = 'NEW_PASSWORD_VALIDITY'
           AND param_type = 'N';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO CPI.giis_parameters
               (param_name, param_type, param_value_n, remarks, user_id, last_update)
        VALUES ('NEW_PASSWORD_VALIDITY', 'N', 24, 'Number of hours before a generated password expires.', USER, SYSDATE);             
    END;
    
    BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM CPI.giis_parameters
         WHERE param_name = 'PASSWORD_ALGORITHM'
           AND param_type = 'V';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO CPI.giis_parameters
               (param_name, param_type, param_value_v, remarks, user_id, last_update)
        VALUES ('PASSWORD_ALGORITHM', 'V', 'SHA-256', 'This parameter is used when encrypting passwords. Valid values are MD5, SHA-1 and SHA-256.', USER, SYSDATE);             
    END;
    
    BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM CPI.giis_parameters
         WHERE param_name = 'NO_OF_ITERATIONS'
           AND param_type = 'N';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO CPI.giis_parameters
               (param_name, param_type, param_value_n, remarks, user_id, last_update)
        VALUES ('NO_OF_ITERATIONS', 'N', 100, 'This parameter is used when encrypting passwords. It is an added step to increase security in password encryption. Higher value means longer time to encrypt passwords.', USER, SYSDATE);             
    END;

    BEGIN
        SELECT 'Y'
          INTO v_exists
          FROM CPI.giis_parameters
         WHERE param_name = 'SALT_BYTE_SIZE'
           AND param_type = 'N';
    EXCEPTION WHEN NO_DATA_FOUND THEN
        INSERT INTO CPI.giis_parameters
               (param_name, param_type, param_value_n, remarks, user_id, last_update)
        VALUES ('SALT_BYTE_SIZE', 'N', 256, 'This parameter is used when encrypting passwords. Minimum recommended value is 32.', USER, SYSDATE);             
    END;
    
    COMMIT;
          
END;