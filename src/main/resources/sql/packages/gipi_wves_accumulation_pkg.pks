CREATE OR REPLACE PACKAGE CPI.Gipi_Wves_Accumulation_Pkg AS
	TYPE gipi_wves_accumulation_type IS RECORD (
		vessel_cd	gipi_wves_accumulation.vessel_cd%TYPE,
		par_id		gipi_wves_accumulation.par_id%TYPE,
		item_no		gipi_wves_accumulation.item_no%TYPE,
		eta			gipi_wves_accumulation.eta%TYPE,
		etd			gipi_wves_accumulation.etd%TYPE,
		tsi_amt		gipi_wves_accumulation.tsi_amt%TYPE,
		rec_flag	gipi_wves_accumulation.rec_flag%TYPE,
		eff_date	gipi_wves_accumulation.eff_date%TYPE);
	
	TYPE gipi_wves_accumulation_tab IS TABLE OF gipi_wves_accumulation_type;
	
	FUNCTION get_gipi_wves_accumulation (p_par_id IN gipi_wves_accumulation.par_id%TYPE)
	RETURN gipi_wves_accumulation_tab PIPELINED;
	
	Procedure del_gipi_wves_accumulation (
		p_par_id IN	gipi_wves_accumulation.par_id%TYPE,
  		p_item_no IN gipi_wves_accumulation.item_no%TYPE);

	Procedure del_gipi_wves_accumulation (p_par_id IN GIPI_WVES_ACCUMULATION.par_id%TYPE);
END Gipi_Wves_Accumulation_Pkg;
/


