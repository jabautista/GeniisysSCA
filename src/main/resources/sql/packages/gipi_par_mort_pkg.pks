CREATE OR REPLACE PACKAGE CPI.Gipi_Par_Mort_Pkg AS  
	TYPE gipi_par_mort_type IS RECORD
	(par_id				GIPI_WMORTGAGEE.par_id%TYPE,       
	iss_cd				GIPI_WMORTGAGEE.iss_cd%TYPE,
	item_no				GIPI_WMORTGAGEE.item_no%TYPE,
	mortg_cd			GIPI_WMORTGAGEE.mortg_cd%TYPE,
	mortg_name			GIIS_MORTGAGEE.mortg_name%TYPE,
	amount				GIPI_WMORTGAGEE.amount%TYPE,
	remarks				GIPI_WMORTGAGEE.remarks%TYPE,
	last_update			GIPI_WMORTGAGEE.last_update%TYPE,
	user_id				GIPI_WMORTGAGEE.user_id%TYPE );

	TYPE gipi_par_mort_tab IS TABLE OF gipi_par_mort_type;
  
	FUNCTION get_gipi_par_mort (p_par_id           GIPI_WMORTGAGEE.par_id%TYPE)
	RETURN gipi_par_mort_tab PIPELINED; 
	
	PROCEDURE Set_Gipi_Par_Mort ( p_gipi_par_mort   IN       GIPI_WMORTGAGEE%ROWTYPE );
	
	PROCEDURE del_gipi_par_mort_item (
		p_par_id    GIPI_WMORTGAGEE.par_id%TYPE,
		p_item_no     GIPI_WMORTGAGEE.item_no%TYPE);
		
	PROCEDURE del_gipi_par_mort (p_par_id		GIPI_WMORTGAGEE.par_id%TYPE);
	
END Gipi_Par_Mort_Pkg;
/


