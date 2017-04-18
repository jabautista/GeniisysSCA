DROP FUNCTION CPI.ESCAPE_VALUE;

CREATE OR REPLACE FUNCTION CPI.ESCAPE_VALUE (p_value IN VARCHAR2)
RETURN VARCHAR2 -- andrew 01.09.2012 replaced with CLOB 
--RETURN CLOB
AS
    /*
    **  Created by        : Mark JM
    **  Date Created     : 12.13.2010
    **  Reference By     : (GIPIS010 - Item Information)
    **  Description     : This function is used to escape/replace certain characters (\, ') to be used in html
    */
    v_escape_chars VARCHAR2(32767); -- andrew 01.09.2012 replaced with CLOB
BEGIN
    SELECT REGEXP_REPLACE(REGEXP_REPLACE(p_value, '''', '&#039;'), '"', '&#34;')    
      INTO v_escape_chars
      FROM dual;
    
    --return blank if CHR(13) (Carriage return) is encountered to prevent error in parsing object by MAC 05/23/2013. 
    --Note: CHR(13) is saved in database using CS version
    v_escape_chars := REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(REGEXP_REPLACE(v_escape_chars, '\\', '&#92;'), '<', '&#60;'), '>', '&#62;'), CHR(10), '\\n'), CHR(13), '');    
    
    RETURN v_escape_chars;
END ESCAPE_VALUE;
/


