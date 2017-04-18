SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   v_id      NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.GIAC_MODULES
    WHERE MODULE_NAME = 'GIACS035';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('Record with MODULE_NAME = GIACS035 is already existing in GIAC_MODULES.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    
    SELECT MIN(M1.MODULE_ID + 1) 
      INTO v_id
      FROM GIAC_MODULES M1
      LEFT OUTER JOIN GIAC_MODULES M2 ON M1.MODULE_ID + 1 = M2.MODULE_ID
     WHERE M2.MODULE_ID IS NULL;

         INSERT INTO GIAC_MODULES 
              (MODULE_ID, MODULE_NAME, SCRN_REP_NAME, SCRN_REP_TAG, GENERATION_TYPE)
         VALUES 
              (v_id, 'GIACS035', 'CLOSE DCB', 'S', 'W');
         COMMIT ;

        DBMS_OUTPUT.PUT_LINE('Successfully inserted MODULE_NAME = GIACS035 in GIAC_MODULES.');
END;