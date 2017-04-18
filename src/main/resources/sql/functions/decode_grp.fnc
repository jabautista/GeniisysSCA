DROP FUNCTION CPI.DECODE_GRP;

CREATE OR REPLACE FUNCTION CPI.DECODE_GRP(
   P_VAR_EXPR       IN VARCHAR2
  ,P_SEARCHER       IN VARCHAR2
  ,P_VALUE_SEARCHED IN NUMBER
  ,P_VALUE_DEFAULT  IN NUMBER)
RETURN NUMBER 
IS  
    /*
    **  Created by     : Robert Virrey
    **  Date Created   : 03.06.2012
    **  Reference By   : (GIEXS007 - Edit Peril Information)
    **  Description    : DECODE_GRP program unit
	*/
 v_return_value NUMBER;
BEGIN  
    IF p_var_expr = p_searcher THEN
        v_return_value := p_value_searched;
    ELSE
        v_return_value := p_value_default;
    END IF;    
  RETURN v_return_value;
END;
/


