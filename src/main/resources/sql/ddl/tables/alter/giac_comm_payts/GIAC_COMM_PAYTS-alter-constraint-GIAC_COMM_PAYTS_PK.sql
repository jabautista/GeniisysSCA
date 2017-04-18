SET serveroutput ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT DISTINCT 1
              INTO v_exists
              FROM all_constraints
             WHERE owner = 'CPI' AND constraint_name = 'GIAC_COMM_PAYTS_PK';

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS DROP CONSTRAINT GIAC_COMM_PAYTS_PK');
      
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI'
            AND index_name = 'GIAC_COMM_PAYTS_PK';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.GIAC_COMM_PAYTS_PK';
         END IF;
      END;

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS ADD ( '
  						||	'CONSTRAINT GIAC_COMM_PAYTS_PK '
 						||  'PRIMARY KEY '
 						||  '(GACC_TRAN_ID, INTM_NO, ISS_CD, PREM_SEQ_NO, COMM_TAG, RECORD_NO, RECORD_SEQ_NO))');

      DBMS_OUTPUT.put_line('Successfully modified constraint GIAC_COMM_PAYTS_PK of GIAC_COMM_PAYTS.' );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS ADD ( '
  						||	'CONSTRAINT GIAC_COMM_PAYTS_PK '
 						||  'PRIMARY KEY '
 						||  '(GACC_TRAN_ID, INTM_NO, ISS_CD, PREM_SEQ_NO, COMM_TAG, RECORD_NO, RECORD_SEQ_NO))');

      DBMS_OUTPUT.put_line('Successfully added constraint GIAC_COMM_PAYTS_PK of GIAC_COMM_PAYTS.' );
   WHEN TOO_MANY_ROWS
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS DROP CONSTRAINT GIAC_COMM_PAYTS_PK');
      
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI'
            AND index_name = 'GIAC_COMM_PAYTS_PK';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.GIAC_COMM_PAYTS_PK';
         END IF;
      END;

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_COMM_PAYTS ADD ( '
  						||	'CONSTRAINT GIAC_COMM_PAYTS_PK '
 						||  'PRIMARY KEY '
 						||  '(GACC_TRAN_ID, INTM_NO, ISS_CD, PREM_SEQ_NO, COMM_TAG, RECORD_NO, RECORD_SEQ_NO))');

      DBMS_OUTPUT.put_line('Successfully modified constraint GIAC_COMM_PAYTS_PK of GIAC_COMM_PAYTS.' );
END;