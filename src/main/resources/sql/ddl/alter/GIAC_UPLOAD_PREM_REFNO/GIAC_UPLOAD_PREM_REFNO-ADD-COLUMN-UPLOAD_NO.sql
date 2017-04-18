/*
**  Created by   : Dren Niebres
**  Date Created : 04.22.2015
**  Reference By : (SR-0004572 - CONVERTION OF GIACS605)
**  Description  : ALTER TABLE GIAC_UPLOAD_PREM_REFNO TO ADD UPLOAD_NO COLUMN
*/

SET serveroutput ON

DECLARE 
  v_exists NUMBER;
BEGIN

    SELECT 1
      INTO v_exists
      FROM all_tab_columns
     WHERE UPPER(table_name) = 'GIAC_UPLOAD_PREM_REFNO'
       AND UPPER(column_name) = 'UPLOAD_NO'
       AND owner = 'CPI';
       
    IF v_exists = 1 THEN   
        EXECUTE IMMEDIATE 'ALTER TABLE GIAC_UPLOAD_PREM_REFNO MODIFY UPLOAD_NO VARCHAR2(12)';
        DBMS_OUTPUT.put_line ('Column UPLOAD_NO has been modified to NUMBER(12)');
    END IF;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        EXECUTE IMMEDIATE('ALTER TABLE GIAC_UPLOAD_PREM_REFNO ADD UPLOAD_NO VARCHAR2(12)');
        DBMS_OUTPUT.put_line('Column UPLOAD_NO has been added to GIAC_UPLOAD_PREM_REFNO');
END;