CREATE OR REPLACE PACKAGE BODY CPI.GIIS_BOND_CLASS_CLAUSE_PKG AS

  FUNCTION get_bond_class_clause_list(p_subline_cd		  GIIS_BOND_CLASS_SUBLINE.subline_cd%TYPE)
    RETURN bond_class_clause_tab PIPELINED IS
	v_clause		bond_class_clause_type;
	
  BEGIN
    FOR i IN (
		SELECT DISTINCT a.clause_type, a.clause_desc, NVL(b.waiver_limit, 0.00) waiver_limit
  		  FROM GIIS_BOND_CLASS_CLAUSE a, GIIS_BOND_CLASS_SUBLINE b
		 WHERE b.clause_type(+) = a.clause_type
		   AND b.subline_cd(+) = p_subline_cd
		 ORDER BY a.clause_desc
		 )
	LOOP
		v_clause.clause_type		:= i.clause_type;
		v_clause.clause_desc		:= i.clause_desc;
		v_clause.waiver_limit		:= i.waiver_limit;
	  PIPE ROW(v_clause);
	END LOOP;
  
    RETURN;
  END get_bond_class_clause_list;

END GIIS_BOND_CLASS_CLAUSE_PKG;
/


