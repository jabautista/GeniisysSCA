DROP FUNCTION CPI.SPLIT_COMMA_SEPARATED;

CREATE OR REPLACE FUNCTION CPI.SPLIT_COMMA_SEPARATED (p_string VARCHAR2)
   RETURN number_list PIPELINED
IS
/* Created by: Mikel 04.23.2014
** Description: Split comma separated string into columns  
*/
   v_string   VARCHAR2 (2000) := p_string;
BEGIN
   FOR r IN (SELECT     REGEXP_SUBSTR (v_string, '[^,]+', 1, LEVEL) ELEMENT
                   FROM DUAL
             CONNECT BY LEVEL <=
                               LENGTH (REGEXP_REPLACE (v_string, '[^,]+'))
                               + 1)
   LOOP
      PIPE ROW (TO_NUMBER (r.ELEMENT, '999999.99'));
   END LOOP;
END;
/


