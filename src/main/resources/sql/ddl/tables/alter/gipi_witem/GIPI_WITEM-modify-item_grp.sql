/* Created by   : Gab
 * Date Created : 10-13-2016
 * Remarks		: GIPI_WITEM
 */
SET serveroutput ON

DECLARE
   v_count   NUMBER;
BEGIN
   SELECT COUNT (*)
     INTO v_count
     FROM gipi_witem
    WHERE item_grp IS NULL;

   IF v_count = 0
   THEN
      EXECUTE IMMEDIATE 'ALTER TABLE gipi_witem MODIFY (item_grp NOT NULL)';

      DBMS_OUTPUT.put_line ('item_grp successfully set to NOT NULLABLE.');
   ELSE
      EXECUTE IMMEDIATE 'UPDATE gipi_witem SET item_grp=1 WHERE item_grp IS NULL';
   
      DBMS_OUTPUT.put_line ('Records updated');
              
       EXECUTE IMMEDIATE 'ALTER TABLE gipi_witem MODIFY (item_grp NOT NULL)';

      DBMS_OUTPUT.put_line ('item_grp successfully set to NOT NULLABLE.');
   END IF;
EXCEPTION
   WHEN OTHERS
   THEN
      DBMS_OUTPUT.put_line ('ERROR: ' || SQLERRM);
END;