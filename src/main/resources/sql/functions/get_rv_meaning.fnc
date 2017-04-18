DROP FUNCTION CPI.GET_RV_MEANING;

CREATE OR REPLACE FUNCTION CPI.get_rv_meaning(p_rv_domain  VARCHAR2,
                          p_rv_low_value VARCHAR2) 
    RETURN VARCHAR2 IS
    
    v_rv_meaning   VARCHAR2(100);
  BEGIN
    FOR cg IN (SELECT rv_meaning
                 FROM CG_REF_CODES
                WHERE rv_domain    = p_rv_domain
                  AND rv_low_value = p_rv_low_value
                ORDER BY upper(rv_meaning))
    LOOP
      v_rv_meaning := cg.rv_meaning;
      EXIT;
    END LOOP;
    RETURN(v_rv_meaning);
  END get_rv_meaning;
/


