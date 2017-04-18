DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM cpi.giis_parameters
    WHERE param_name = 'TEXT_EDITOR_FONT';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line
                       ('TEXT_EDITOR_FONT parameter already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
	INSERT INTO CPI.GIIS_PARAMETERS
	   (PARAM_TYPE, PARAM_NAME, PARAM_VALUE_N, PARAM_VALUE_V, PARAM_VALUE_D, 
	    PARAM_LENGTH, REMARKS, USER_ID, LAST_UPDATE, CPI_REC_NO, 
	    CPI_BRANCH_CD)
	 VALUES
	   ('V', 'TEXT_EDITOR_FONT', NULL, 'Sans-Serif', NULL, 
	    NULL, 'Font which the system will use for text editors, this should ideally match your report fonts. Valid values: Microsoft Sans Serif, Times New Roman, Arial, Comic Sans MS, Courier New, Georgia, Verdana, Tahoma, Serif, Sans-Serif, Monospace', 'CPI', TO_DATE('04/07/2016 14:07:00', 'MM/DD/YYYY HH24:MI:SS'), NULL, 
	    NULL);

      COMMIT;
      DBMS_OUTPUT.put_line
                ('Successfully added TEXT_EDITOR_FONT in parameters.');
END;