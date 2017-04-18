SET SERVEROUTPUT ON

DECLARE
   v_exist   NUMBER := 0;
BEGIN
   SELECT 1
     INTO v_exist
     FROM all_indexes
    WHERE owner = 'CPI' AND index_name = 'IDX_UWREP_DIST_FACUL01';

   IF v_exist = 1
   THEN
      DBMS_OUTPUT.put_line ('IDX_UWREP_DIST_FACUL01 already exists.');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE ('CREATE INDEX CPI.IDX_UWREP_DIST_FACUL01 ON CPI.GIPI_UWREPORTS_DIST_FACULSHR (USER_ID) TABLESPACE INDEXES COMPUTE STATISTICS');

      DBMS_OUTPUT.put_line ('IDX_UWREP_DIST_FACUL01 created.');
END;