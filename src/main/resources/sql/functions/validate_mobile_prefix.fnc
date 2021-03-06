DROP FUNCTION CPI.VALIDATE_MOBILE_PREFIX;

CREATE OR REPLACE FUNCTION CPI.validate_mobile_prefix (field VARCHAR2) 

RETURN NUMBER 

IS

BEGIN
    IF INSTR(SUBSTR(field,1,LENGTH(field)-7),'09') = 1 THEN
       RETURN(11);
    ELSIF INSTR(SUBSTR(field,1,LENGTH(field)-7),'639') = 1 THEN
       RETURN(12);
    ELSIF INSTR(SUBSTR(field,1,LENGTH(field)-7),'+639') = 1 THEN
       RETURN(13);
    ELSE
       RETURN(0);
  END IF;
END;
/


