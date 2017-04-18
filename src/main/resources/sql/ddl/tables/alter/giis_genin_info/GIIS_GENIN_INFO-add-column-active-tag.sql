SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE CPI.GIIS_GENIN_INFO ADD active_tag VARCHAR2(1) DEFAULT ''A''';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_GENIN_INFO ADD CONSTRAINT giis_genin_info_active_tag_chk CHECK(active_tag IN (''A'',''I''))';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_GENIN_INFO MODIFY active_tag NOT NULL';
   
   DBMS_OUTPUT.PUT_LINE (
        'Successfully added active_tag column to GIIS_GENIN_INFO table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
