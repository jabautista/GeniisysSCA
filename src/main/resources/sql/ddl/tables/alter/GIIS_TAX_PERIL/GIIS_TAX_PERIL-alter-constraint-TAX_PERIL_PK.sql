SET serveroutput ON

DECLARE
   v_exists   INTEGER := 0;
BEGIN
   SELECT COUNT (*)
     INTO v_exists
     FROM all_indexes
    WHERE owner = 'CPI' 
      AND index_name = 'TAX_PERIL_PK';

   IF v_exists <> 0 THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIIS_TAX_PERIL DROP CONSTRAINT TAX_PERIL_PK');
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI' 
            AND index_name = 'TAX_PERIL_PK';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.TAX_PERIL_PK';
         END IF;
      END;

      EXECUTE IMMEDIATE (   'ALTER TABLE CPI.GIIS_TAX_PERIL ADD ( '
                         || 'CONSTRAINT TAX_PERIL_PK '
                         || 'PRIMARY KEY '
                         || '(ISS_CD, LINE_CD, TAX_CD, TAX_ID, PERIL_CD))'
                        );

      DBMS_OUTPUT.put_line
           ('Successfully modified constraint TAX_PERIL_PK of GIIS_TAX_PERIL.');
   ELSE
    EXECUTE IMMEDIATE (   'ALTER TABLE CPI.GIIS_TAX_PERIL ADD ( '
                         || 'CONSTRAINT TAX_PERIL_PK '
                         || 'PRIMARY KEY '
                         || '(ISS_CD, LINE_CD, TAX_CD, TAX_ID, PERIL_CD))'
                        );

      DBMS_OUTPUT.put_line
           ('Successfully modified constraint TAX_PERIL_PK of GIIS_TAX_PERIL.');
   END IF;
END;