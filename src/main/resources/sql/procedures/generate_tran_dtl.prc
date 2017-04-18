DROP PROCEDURE CPI.GENERATE_TRAN_DTL;

CREATE OR REPLACE PROCEDURE CPI.generate_tran_dtl (p_disp_column         VARCHAR2,
                                                p_table               VARCHAR2,
                                                p_validation          VARCHAR2,
                                                p_tran_dtl      OUT   VARCHAR2)
/*
**  Created by   :  Menandro G.C. Robes
**  Date Created :  January 21, 2011
**  Reference By : (WOFLO001 - Workflow)
**  Description  : Procedure to retrieve the tran_dtl column shown in event listing 
*/                                                  
IS
  v_query VARCHAR2(3200);   
BEGIN
  v_query := 'SELECT '|| p_disp_column ||' tran_dtl '
           ||  ' FROM '|| p_table || ' a'
           || ' WHERE '|| p_validation
           || ' ORDER BY 1 ';
  DBMS_OUTPUT.PUT_LINE(v_query);                                      
  EXECUTE IMMEDIATE v_query INTO p_tran_dtl;
END;
/


