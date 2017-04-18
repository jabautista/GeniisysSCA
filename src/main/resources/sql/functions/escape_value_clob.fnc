DROP FUNCTION CPI.ESCAPE_VALUE_CLOB;

CREATE OR REPLACE FUNCTION CPI.ESCAPE_VALUE_CLOB (p_value IN VARCHAR2)
RETURN CLOB
AS    
    /*    Date        Author            Description
    **    ==========    ===============    ============================
    **    12.14.2011    mark jm            used for escaping/replacing certain characters (\, ') to be used in html
    **                                Note: this function returns Character Large Object (CLOB) which
    **                                    has more storage capacity than VARCHAR2 and LONG/LONG RAW
    */
    v_escape_chars VARCHAR2(32767);
    v_clob CLOB;
BEGIN
    SELECT REGEXP_REPLACE(REGEXP_REPLACE(p_value, '''', '&#039;'), '"', '&#34;')    
      INTO v_clob
      FROM dual;
      
    v_clob := REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(v_clob, '<', '&#60;'), '>', '&#62;'), CHR(10), '\\n');    
    
    RETURN v_clob;
END ESCAPE_VALUE_CLOB;
/


