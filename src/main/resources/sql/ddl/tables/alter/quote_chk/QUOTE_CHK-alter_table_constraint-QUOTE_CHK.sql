/* Added by dren 09.22.2015
** For SR 0020388 
** ALTER CONSTRAINT QUOTE_CHK OF GIPI_QUOTE
*/   

SET serveroutput ON
DECLARE
   v_exists   NUMBER := 0;
BEGIN
   SELECT DISTINCT 1
              INTO v_exists
              FROM all_constraints
             WHERE owner = 'CPI' AND constraint_name = 'QUOTE_CHK';

   IF v_exists = 1
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIPI_QUOTE DROP CONSTRAINT QUOTE_CHK');
      
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI'
            AND index_name = 'QUOTE_CHK';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.QUOTE_CHK';
         END IF;
      END;

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIPI_QUOTE ADD ( '
                         ||  'CONSTRAINT QUOTE_CHK '
                         ||  'CHECK (STATUS IN (''N'',''W'',''P'',''D'',''X'',''L'')))');

      DBMS_OUTPUT.put_line('Successfully modified constraint QUOTE_CHK of GIPI_QUOTE.' );
   END IF;
EXCEPTION
   WHEN NO_DATA_FOUND
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIPI_QUOTE ADD ( '
                         ||  'CONSTRAINT QUOTE_CHK '
                         ||  'CHECK (STATUS IN (''N'',''W'',''P'',''D'',''X'',''L'')))');

      DBMS_OUTPUT.put_line('Successfully added constraint QUOTE_CHK of GIPI_QUOTE.' );
   WHEN TOO_MANY_ROWS
   THEN
      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIPI_QUOTE DROP CONSTRAINT GIPI_QUOTE');
      
      DECLARE
         i   INTEGER;
      BEGIN
         SELECT COUNT (*)
           INTO i
           FROM user_indexes
          WHERE table_owner = 'CPI'
            AND index_name = 'GIPI_QUOTE';

         IF i <> 0
         THEN
            EXECUTE IMMEDIATE 'DROP INDEX CPI.GIPI_QUOTE';
         END IF;
      END;

      EXECUTE IMMEDIATE ('ALTER TABLE CPI.GIPI_QUOTE ADD ( '
                         ||  'CONSTRAINT QUOTE_CHK '
                         ||  'CHECK (STATUS IN (''N'',''W'',''P'',''D'',''X'',''L'')))');

      DBMS_OUTPUT.put_line('Successfully modified constraint QUOTE_CHK of GIPI_QUOTE.' );
END;