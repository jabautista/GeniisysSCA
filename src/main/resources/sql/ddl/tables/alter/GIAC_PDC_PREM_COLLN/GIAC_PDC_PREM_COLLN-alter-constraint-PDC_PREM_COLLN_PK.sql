SET serveroutput ON

DECLARE
   v_exists   NUMBER := 0;
BEGIN
    SELECT DISTINCT 1
      INTO v_exists
      FROM all_constraints
     WHERE owner = 'CPI' 
       AND constraint_name = 'PDC_PREM_COLLN_PK';

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_PDC_PREM_COLLN DROP CONSTRAINT PDC_PREM_COLLN_PK');
      
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI'
            AND index_name = 'PDC_PREM_COLLN_PK';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.PDC_PREM_COLLN_PK';
         END IF;
      END;

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_PDC_PREM_COLLN ADD ( '
                          ||    'CONSTRAINT PDC_PREM_COLLN_PK '
                         ||  'PRIMARY KEY '
                         ||  '(PDC_ID, ISS_CD, PREM_SEQ_NO, INST_NO))');

      DBMS_OUTPUT.put_line('Successfully modified constraint PDC_PREM_COLLN_PK of GIAC_PDC_PREM_COLLN.' );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.PDC_PREM_COLLN_PK ADD ( '
                          ||    'CONSTRAINT PDC_PREM_COLLN_PK '
                         ||  'PRIMARY KEY '
                         ||  '(PDC_ID, ISS_CD, PREM_SEQ_NO, INST_NO))');

      DBMS_OUTPUT.put_line('Successfully added constraint PDC_PREM_COLLN_PK of GIAC_PDC_PREM_COLLN.' );
   WHEN TOO_MANY_ROWS THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_PDC_PREM_COLLN DROP CONSTRAINT PDC_PREM_COLLN_PK');
      
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI'
            AND index_name = 'PDC_PREM_COLLN_PK';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.PDC_PREM_COLLN_PK';
         END IF;
      END;

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIAC_PDC_PREM_COLLN ADD ( '
                          ||    'CONSTRAINT PDC_PREM_COLLN_PK '
                         ||  'PRIMARY KEY '
                         ||  '(PDC_ID, ISS_CD, PREM_SEQ_NO, INST_NO))');

      DBMS_OUTPUT.put_line('Successfully modified constraint PDC_PREM_COLLN_PK of GIAC_PDC_PREM_COLLN.' );
END;