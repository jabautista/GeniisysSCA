

SET SERVEROUTPUT ON 
BEGIN 
 EXECUTE IMMEDIATE 'create index  cpi.idx_firsetat_ext_dtl on  cpi.gipi_firestat_extract_dtl(line_cd, subline_cd, iss_cd, issue_yy ,pol_seq_no  )';
 DBMS_OUTPUT.PUT_LINE('index created');
EXCEPTION 
WHEN OTHERS THEN
     DBMS_OUTPUT.PUT_LINE(SQLERRM || '-' || SQLCODE);
END;
 /




   