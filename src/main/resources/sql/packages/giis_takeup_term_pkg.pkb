CREATE OR REPLACE PACKAGE BODY CPI.Giis_Takeup_Term_Pkg AS

  FUNCTION get_takeup_term_list
  RETURN takeup_term_list_tab PIPELINED IS
     v_takeup_term takeup_term_list_type;
  BEGIN
  	   FOR i IN (
	   	   SELECT takeup_term, takeup_term_desc, no_of_takeup, yearly_tag
		     FROM GIIS_TAKEUP_TERM
			ORDER BY takeup_term_desc)
	   LOOP
	     v_takeup_term.takeup_term  	 := i.takeup_term;
		 v_takeup_term.takeup_term_desc	 := i.takeup_term_desc;
		 v_takeup_term.no_of_takeup	 	 := i.no_of_takeup;
		 v_takeup_term.yearly_tag	 	 := i.yearly_tag;

		 PIPE ROW(v_takeup_term);
	   END LOOP;
  RETURN;
  END get_takeup_term_list;

END Giis_Takeup_Term_Pkg;
/


