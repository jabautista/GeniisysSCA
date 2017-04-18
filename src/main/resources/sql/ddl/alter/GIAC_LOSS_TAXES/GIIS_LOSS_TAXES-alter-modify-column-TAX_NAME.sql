/*Created by pjsantos 01/11/2017
SR 5898 BIR2307 Enhancement, modiied table CPI.GIIS_LOSS_TAXES to update data to latest BIR FORM standard */
SET SERVEROUTPUT ON

DECLARE
   v_length   NUMBER (4) := 0;
BEGIN
   BEGIN
      SELECT data_length
        INTO v_length
        FROM all_tab_cols
       WHERE     owner = 'CPI'
             AND table_name = 'GIIS_LOSS_TAXES'
             AND column_name = 'TAX_NAME';

      IF v_length = 100
      THEN
         EXECUTE IMMEDIATE
            'ALTER TABLE CPI.GIIS_LOSS_TAXES MODIFY TAX_NAME VARCHAR2(200)';

         DBMS_OUTPUT.put_line (
            'Successfully modified CPI.GIIS_LOSS_TAXES.TAX_NAME.');
      ELSIF v_length = 200
      THEN
         DBMS_OUTPUT.put_line (
            'CPI.GIIS_LOSS_TAXES.TAX_NAME is up to date.');
      END IF;
   EXCEPTION
      WHEN NO_DATA_FOUND
      THEN
         DBMS_OUTPUT.put_line (
            'No column TAX_NAME on table CPI.GIIS_LOSS_TAXES found.');
   END;
END;