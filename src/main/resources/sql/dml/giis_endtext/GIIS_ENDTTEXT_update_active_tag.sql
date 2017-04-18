/* carlo rubenecia SR-5915 01-23-2017*/

BEGIN
   UPDATE CPI.GIIS_ENDTTEXT
      SET active_tag = 'A'
     WHERE active_tag <> 'I';
     
   COMMIT;
   DBMS_OUTPUT.PUT_LINE (
        'Successfully updated GIIS_ENDTTEXT table.');
END;
/