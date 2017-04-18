/* Formatted on 2017/02/07 10:58 (Formatter Plus v4.8.8) */
SET serveroutput ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT DISTINCT 1
              INTO v_exists
              FROM all_constraints
             WHERE owner = 'CPI' AND constraint_name = 'GIEX_PACK_EXPIRY_PK';

   IF v_exists = 1
   THEN
      DBMS_OUTPUT.put_line ('GIEX_PACK_EXPIRY_PK already exist');
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE (   'ALTER TABLE CPI.GIEX_PACK_EXPIRY ADD ( '
                         || 'CONSTRAINT GIEX_PACK_EXPIRY_PK '
                         || 'PRIMARY KEY '
                         || '(PACK_POLICY_ID))'
                        );

      DBMS_OUTPUT.put_line
         ('Successfully modified constraint GIEX_PACK_EXPIRY_PK of GIEX_PACK_EXPIRY.'
         );
END;