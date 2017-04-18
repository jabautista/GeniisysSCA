CREATE OR REPLACE PACKAGE CPI.GIIS_BOND_CLASS_CLAUSE_PKG AS

  TYPE bond_class_clause_type IS RECORD
    (clause_type           GIIS_BOND_CLASS_CLAUSE.clause_type%TYPE,
     clause_desc           GIIS_BOND_CLASS_CLAUSE.clause_desc%TYPE,
	 waiver_limit          GIIS_BOND_CLASS_SUBLINE.waiver_limit%TYPE);
  
  TYPE bond_class_clause_tab IS TABLE OF bond_class_clause_type;
  
  FUNCTION get_bond_class_clause_list(p_subline_cd		  GIIS_BOND_CLASS_SUBLINE.subline_cd%TYPE)
    RETURN bond_class_clause_tab PIPELINED;

END GIIS_BOND_CLASS_CLAUSE_PKG;
/


