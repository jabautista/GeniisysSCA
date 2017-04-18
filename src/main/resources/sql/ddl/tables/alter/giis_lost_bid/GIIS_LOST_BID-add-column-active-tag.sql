SET SERVEROUTPUT ON

BEGIN
   EXECUTE IMMEDIATE
      'ALTER TABLE CPI.GIIS_LOST_BID ADD active_tag VARCHAR2(1) DEFAULT ''A''';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_LOST_BID ADD CONSTRAINT giis_lost_bid_active_tag_chk CHECK(active_tag IN (''A'',''I''))';
          
   EXECUTE IMMEDIATE 
      'ALTER TABLE CPI.GIIS_LOST_BID MODIFY active_tag NOT NULL';
   
   DBMS_OUTPUT.PUT_LINE (
        'Successfully added active_tag column to GIIS_LOST_BID table.');
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.PUT_LINE (SQLERRM || '-' || SQLCODE);
END;
/
