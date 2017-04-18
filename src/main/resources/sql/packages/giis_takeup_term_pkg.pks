CREATE OR REPLACE PACKAGE CPI.Giis_Takeup_Term_Pkg AS

/********************************** FUNCTION 1 ************************************
  MODULE:  GIPIS002 
  RECORD GROUP NAME: TAKEUP_TERM_RG  
***********************************************************************************/ 

  TYPE takeup_term_list_type IS RECORD
  	   (takeup_term 		    GIIS_TAKEUP_TERM.takeup_term%TYPE,
   	    takeup_term_desc		GIIS_TAKEUP_TERM.takeup_term_desc%TYPE,
		no_of_takeup			GIIS_TAKEUP_TERM.no_of_takeup%TYPE,
		yearly_tag				GIIS_TAKEUP_TERM.yearly_tag%TYPE);
   
  TYPE takeup_term_list_tab IS TABLE OF takeup_term_list_type;
  
  FUNCTION get_takeup_term_list RETURN takeup_term_list_tab PIPELINED;

END Giis_Takeup_Term_Pkg;
/


