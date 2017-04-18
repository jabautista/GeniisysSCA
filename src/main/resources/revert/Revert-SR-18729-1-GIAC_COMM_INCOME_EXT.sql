DECLARE 
   CURSOR c1 (columname VARCHAR2)
   IS
      SELECT COUNT (column_name) ctr
        FROM all_tab_cols
       WHERE owner LIKE 'CPI'
         AND table_name = 'GIAC_COMM_INCOME_EXT'
         AND column_name = columname;
BEGIN
   FOR x IN c1 ('PARAM_FROM_DATE')
   LOOP
      IF x.ctr > 0
      THEN
         EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_COMM_INCOME_EXT DROP COLUMN PARAM_FROM_DATE';
      END IF;
   END LOOP;

   FOR x IN c1 ('PARAM_TO_DATE')
   LOOP
      IF x.ctr > 0
      THEN
         EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_COMM_INCOME_EXT DROP COLUMN PARAM_TO_DATE';
      END IF;
   END LOOP;

   FOR x IN c1 ('PARAM_LINE_CD')
   LOOP
      IF x.ctr > 0
      THEN
         EXECUTE IMMEDIATE 'ALTER TABLE CPI.GIAC_COMM_INCOME_EXT DROP COLUMN PARAM_LINE_CD';
      END IF;
   END LOOP;
END;