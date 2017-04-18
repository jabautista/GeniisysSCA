SET SERVEROUTPUT ON 
BEGIN 

    EXECUTE IMMEDIATE 'CREATE INDEX  CPI.DEF_POLICY_NO_IDX7 ON CPI.GIAC_DEFERRED_RI_PREM_CEDED (YEAR,mm,iss_cd,line_cd,acct_trty_type)';
    
   
 DBMS_OUTPUT.PUT_LINE('index created');
EXCEPTION 
WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM || '-' || SQLCODE);
END;
 /