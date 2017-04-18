SET SERVEROUTPUT ON 
BEGIN 

    EXECUTE IMMEDIATE 'CREATE INDEX  CPI.DEF_POLICY_NO_IDX9 ON CPI.GROSS_PREM (policy_id)';
    
   
 DBMS_OUTPUT.PUT_LINE('index created');
EXCEPTION 
WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM || '-' || SQLCODE);
END;
 /