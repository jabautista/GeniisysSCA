DROP PROCEDURE CPI.CHK_CHAR_REF_CODES;

CREATE OR REPLACE PROCEDURE CPI.CHK_CHAR_REF_CODES(
   p_value   IN OUT VARCHAR2      -- Value to be validated  
  ,p_meaning IN OUT VARCHAR2      -- Domain meaning         
  ,p_domain  IN     VARCHAR2)     -- Reference codes domain 
  
IS

/* This trigger checks that the given value exists in the REF_CODES   
   table for the given domain.  It must be either one of the distinct 
   values, or within one of the ranges (high value not null). */

new_value VARCHAR2(240);
curr_value VARCHAR2(240);

BEGIN
  
  curr_value := p_value;
  
  IF (curr_value IS NOT NULL) THEN
    SELECT  DECODE(rv_high_value, NULL, rv_low_value, curr_value)
          , rv_meaning
    INTO    new_value
          , p_meaning
    FROM    CG_REF_CODES
    WHERE  ( (rv_high_value IS NULL   AND    
             curr_value IN  (rv_low_value, rv_abbreviation) ) OR 
             (curr_value BETWEEN  rv_low_value AND     rv_high_value)
             )
    AND     ROWNUM = 1
    AND     rv_domain = p_domain;
    
    p_value := new_value;
    
  END IF;
  
END;
/


