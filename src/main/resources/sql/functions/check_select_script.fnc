CREATE OR REPLACE FUNCTION cpi.check_select_script (
   p_param_select   VARCHAR2,
   p_param_script   NUMBER
)
/* mikel 03.10.2014
** check if the select script has a results or with errors.
*/

/* modified by mikel 06.10.2014
** changed return value from BOOLEAN to NUMBER
*/
   --RETURN BOOLEAN --mikel 06.10.2014
   RETURN NUMBER --mikel 06.10.2014

AS
   v_exists          BOOLEAN        := FALSE;
   v_count           NUMBER         := 0; --mikel 06.10.2014
   invalid_column    EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_column, -00904);
   string_error      EXCEPTION;
   PRAGMA EXCEPTION_INIT (string_error, -01756);
   invalid_numbers   EXCEPTION;
   PRAGMA EXCEPTION_INIT (invalid_numbers, -01722);
   v_message         VARCHAR2 (100);
BEGIN
   v_message :=
      '.  Kindly check the checking script or contact the administrator for assistance.';

   BEGIN
      EXECUTE IMMEDIATE 'SELECT COUNT(1) FROM (' || p_param_select || ')'
                   INTO v_count;

      IF v_count > 0
      THEN
         v_exists := TRUE;
      END IF;
   EXCEPTION
      WHEN invalid_column
      THEN
         raise_application_error (-20101,
                                     'Geniisys Exception#E#Invalid column in select script no. '
                                  || p_param_script
                                  || v_message
                                 );
      WHEN string_error
      THEN
         raise_application_error
              (-20102,
                  'Geniisys Exception#E#Quoted string not properly terminated in select script no. '
               || p_param_script
               || v_message
              );
      WHEN invalid_numbers
      THEN
         raise_application_error (-20103,
                                     'Geniisys Exception#E#Invalid number in select script no. '
                                  || p_param_script
                                  || v_message
                                 );
      WHEN OTHERS
      THEN
         raise_application_error (-20104,
                                     'Geniisys Exception#E#Error in select script no. '
                                  || p_param_script
                                  || v_message
                                 );
   END;

   --RETURN v_exists; --mikel 06.10.2014
   RETURN v_count; --mikel 06.10.2014
END;
/

CREATE OR REPLACE PUBLIC SYNONYM check_select_script FOR cpi.check_select_script;