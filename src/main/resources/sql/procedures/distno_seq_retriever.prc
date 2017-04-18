DROP PROCEDURE CPI.DISTNO_SEQ_RETRIEVER;

CREATE OR REPLACE PROCEDURE CPI.DISTNO_SEQ_RETRIEVER(p_temp_distno OUT NUMBER,
                                                     p_msg         OUT VARCHAR2) 
IS
  /*
  **  Created by   : Robert John Virrey
  **  Date Created : August 4, 2011
  **  Reference By : (GIUTS002 - Distribution Negation)
  **  Description  : Generates a new distribution number based on
  **                 the value of oracle sequence POL_DIST_DIST_NO_S.
  */
BEGIN
  FOR c1 IN (SELECT POL_DIST_DIST_NO_S.NEXTVAL dist_no
               FROM dual)
  LOOP
    p_temp_distno := c1.dist_no;
    EXIT;
  END LOOP;
  IF p_temp_distno IS NULL THEN
     p_msg := 'Cannot generate a new distribution number, please contact your DBA.';
  END IF;
END;
/


