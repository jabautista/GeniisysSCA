--DROP FUNCTION CPI.SPLIT_COMMA_SEPARATED_STRING;

CREATE OR REPLACE FUNCTION CPI.SPLIT_COMMA_SEPARATED_STRING (p_string VARCHAR2)
   RETURN varchar2_list PIPELINED
IS
/* Created by: Robert 09.11.2015
** Description: Split comma separated string into varchar2 columns  
*/
   v_string   VARCHAR2 (32767) := p_string;
BEGIN
   FOR r
      IN (    SELECT REGEXP_SUBSTR (v_string, '[^,]+', 1, LEVEL) ELEMENT
                FROM DUAL
          CONNECT BY LEVEL <= LENGTH (REGEXP_REPLACE (v_string, '[^,]+')) + 1)
   LOOP
      PIPE ROW (r.ELEMENT);
   END LOOP;
END;
/
