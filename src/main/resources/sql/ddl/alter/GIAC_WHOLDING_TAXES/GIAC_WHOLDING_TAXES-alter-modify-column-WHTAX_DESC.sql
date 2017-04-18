/*Created by pjsantos 01/11/2017
SR 5898 BIR2307 Enhancement, modiied table CPI.GIAC_WHOLDING_TAXES to update data to latest BIR FORM standard */
SET SERVEROUTPUT ON

DECLARE
   v_length   NUMBER (4) := 0;
BEGIN
   BEGIN
      SELECT data_length
        INTO v_length
        FROM all_tab_cols
       WHERE     owner = 'CPI'
             AND table_name = 'GIAC_WHOLDING_TAXES'
             AND column_name = 'WHTAX_DESC';

      IF v_length = 100
      THEN
         EXECUTE IMMEDIATE
            'ALTER TABLE CPI.GIAC_WHOLDING_TAXES MODIFY WHTAX_DESC VARCHAR2(200)';

         DBMS_OUTPUT.put_line (
            'Successfully modified CPI.GIAC_WHOLDING_TAXES.WHTAX_DESC.');
      ELSIF v_length = 200
      THEN
         DBMS_OUTPUT.put_line (
            'CPI.GIAC_WHOLDING_TAXES.WHTAX_DESC is up to date.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line (
            'No column WHTAX_DESC on table CPI.GIAC_WHOLDING_TAXES found.');
   END;
END;