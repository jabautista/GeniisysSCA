SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE CPI.GIIS_NON_RENEW_REASON ADD active_tag VARCHAR2(1) DEFAULT ''A''';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_NON_RENEW_REASON ADD CONSTRAINT giis_non_renew_active_tag_chk CHECK(active_tag IN (''A'',''I''))';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_NON_RENEW_REASON MODIFY active_tag NOT NULL';
   
   DBMS_OUTPUT.PUT_LINE (
        'Successfully added active_tag column to GIIS_NON_RENEW_REASON table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
