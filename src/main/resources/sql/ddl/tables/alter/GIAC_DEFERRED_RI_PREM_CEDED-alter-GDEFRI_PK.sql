/* Formatted on 2015/06/08 14:10 (Formatter Plus v4.8.8) */
SET SERVEROUTPUT ON

DECLARE
   v_exists    VARCHAR2 (1)    := 'N';
   v_exists2   VARCHAR2 (1)    := 'N';
   v_execute   VARCHAR2 (2000);
BEGIN
   FOR cur IN (SELECT 1
                 FROM all_constraints
                WHERE constraint_name = UPPER ('gdefri_pk'))
   LOOP
      v_exists := 'Y';
   END LOOP;

   FOR curly IN (SELECT 1
                   FROM all_objects
                  WHERE object_name = UPPER ('gdefri_pk')
                    AND object_type = 'INDEX')
   LOOP
      v_exists2 := 'Y';
   END LOOP;

   IF v_exists = 'N' AND v_exists2 = 'N'
   THEN
      v_execute :=
         'ALTER   TABLE cpi.GIAC_DEFERRED_RI_PREM_CEDED
          ADD CONSTRAINT gdefri_pk UNIQUE
          (YEAR,MM,ISS_CD,LINE_CD, PROCEDURE_ID,SHARE_TYPE,ACCT_TRTY_TYPE)';

      EXECUTE IMMEDIATE v_execute;

      DBMS_OUTPUT.put_line ('Successfully modified gdefri_pk.');
   ELSIF v_exists = 'N' AND v_exists2 = 'Y'
   THEN
      v_execute := 'DROP INDEX CPI.gdefri_pk';

      EXECUTE IMMEDIATE v_execute;

      v_execute :=
         'ALTER   TABLE cpi.GIAC_DEFERRED_RI_PREM_CEDED
          ADD CONSTRAINT gdefri_pk UNIQUE
          (YEAR,MM,ISS_CD,LINE_CD, PROCEDURE_ID,SHARE_TYPE,ACCT_TRTY_TYPE)';

      EXECUTE IMMEDIATE v_execute;

      DBMS_OUTPUT.put_line ('Successfully modified gdefri_pk.');
   ELSE
      v_execute :=
         ' ALTER TABLE cpi.GIAC_DEFERRED_RI_PREM_CEDED
           DROP CONSTRAINT gdefri_pk';

      EXECUTE IMMEDIATE v_execute;

      v_execute :=
         'ALTER   TABLE cpi.GIAC_DEFERRED_RI_PREM_CEDED
          ADD CONSTRAINT gdefri_pk UNIQUE
          (YEAR,MM,ISS_CD,LINE_CD, PROCEDURE_ID,SHARE_TYPE,ACCT_TRTY_TYPE)';

      EXECUTE IMMEDIATE v_execute;

      DBMS_OUTPUT.put_line ('Successfully modified gdefri_pk.');
   END IF;
END;