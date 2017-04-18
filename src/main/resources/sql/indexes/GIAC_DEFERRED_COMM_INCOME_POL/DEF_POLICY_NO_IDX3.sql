SET SERVEROUTPUT ON 
BEGIN 

    EXECUTE IMMEDIATE 'CREATE INDEX  CPI.DEF_POLICY_NO_IDX3 ON CPI.GIAC_DEFERRED_COMM_INCOME_POL (policy_no)';
    
   
 DBMS_OUTPUT.PUT_LINE('index created');
EXCEPTION 
WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM || '-' || SQLCODE);
END;
 /