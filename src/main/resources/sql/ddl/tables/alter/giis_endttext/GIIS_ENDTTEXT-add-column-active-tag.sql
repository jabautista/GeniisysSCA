SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE CPI.GIIS_ENDTTEXT ADD active_tag VARCHAR2(1) DEFAULT ''A''';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_ENDTTEXT ADD CONSTRAINT giis_endttext_active_tag_chk CHECK(active_tag IN (''A'',''I''))';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_ENDTTEXT MODIFY active_tag NOT NULL';
   
   DBMS_OUTPUT.PUT_LINE (
        'Successfully added active_tag column to GIIS_ENDTTEXT table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
