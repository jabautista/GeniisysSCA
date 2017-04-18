/* Formatted on 3/14/2016 2:19:36 PM (QP5 v5.227.12220.39754) */
SET SERVEROUTPUT ON;

DECLARE
   v_exists   VARCHAR2 (1) := 'N';
BEGIN
   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM CPI.giis_parameters
       WHERE param_name = 'MIN_PASSWORD_LENGTH' AND param_type = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giis_parameters (param_type,
                                      param_name,
                                      user_id,
                                      last_update,
                                      param_value_n)
              VALUES ('N',
                      'MIN_PASSWORD_LENGTH',
                      USER,
                      SYSDATE,
                      8);
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM CPI.giis_parameters
       WHERE param_name = 'MIN_LETTERS_IN_PW' AND param_type = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giis_parameters (param_type,
                                      param_name,
                                      user_id,
                                      last_update,
                                      param_value_n)
              VALUES ('N',
                      'MIN_LETTERS_IN_PW',
                      USER,
                      SYSDATE,
                      1);
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM CPI.giis_parameters
       WHERE param_name = 'MIN_NUMBER_IN_PW' AND param_type = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giis_parameters (param_type,
                                      param_name,
                                      user_id,
                                      last_update,
                                      param_value_n)
              VALUES ('N',
                      'MIN_NUMBER_IN_PW',
                      USER,
                      SYSDATE,
                      1);
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM CPI.giis_parameters
       WHERE param_name = 'MIN_SPECIAL_CHARS_IN_PW' AND param_type = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giis_parameters (param_type,
                                      param_name,
                                      user_id,
                                      last_update,
                                      param_value_n)
              VALUES ('N',
                      'MIN_SPECIAL_CHARS_IN_PW',
                      USER,
                      SYSDATE,
                      1);
   END;

   BEGIN
      SELECT 'Y'
        INTO v_exists
        FROM CPI.giis_parameters
       WHERE param_name = 'NO_OF_PREV_PW_TO_STORE' AND param_type = 'N';
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         INSERT INTO giis_parameters (param_type,
                                      param_name,
                                      user_id,
                                      last_update,
                                      param_value_n)
              VALUES ('N',
                      'NO_OF_PREV_PW_TO_STORE',
                      USER,
                      SYSDATE,
                      3);
   END;

   COMMIT;
END;