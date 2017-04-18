CREATE OR REPLACE PACKAGE CPI.Gipi_Winvperl_Pkg AS

	TYPE gipi_winvperl_type IS RECORD (
		peril_cd		GIPI_WINVPERL.peril_cd%TYPE,
		peril_name		GIIS_PERIL.peril_name%TYPE,
		par_id			GIPI_WINVPERL.par_id%TYPE,
		item_grp		GIPI_WINVPERL.item_grp%TYPE,
		takeup_seq_no	GIPI_WINVPERL.takeup_seq_no%TYPE,
		tsi_amt			GIPI_WINVPERL.tsi_amt%TYPE,
		prem_amt		GIPI_WINVPERL.prem_amt%TYPE,
		line_cd			GIPI_WITEM.pack_line_cd%TYPE ); --added by cris
	 
	TYPE gipi_winvperl_tab IS TABLE OF gipi_winvperl_type;
  
	FUNCTION get_gipi_winvperl (
		p_par_id		GIPI_WINVPERL.par_id%TYPE,
		p_item_grp		GIPI_WINVPERL.item_grp%TYPE,
		p_line_cd		GIPI_WITEM.pack_line_cd%TYPE )
	RETURN gipi_winvperl_tab PIPELINED;	
	
	/**
	* Modified by: Emman 4.30.10
	* Added function for retrieving gipi_winvperl, using par_id and line_cd only
	* GIPIS085
	*/
	
	FUNCTION get_gipi_winvperl2 (
		p_par_id		GIPI_WINVPERL.par_id%TYPE,
		p_line_cd		GIPI_WITEM.pack_line_cd%TYPE )
	RETURN gipi_winvperl_tab PIPELINED;	
		
	/*
	function added by cris: 02/05/2010
	*/
	FUNCTION get_distinct_gipi_winvperl(p_par_id	GIPI_WINVPERL.par_id%TYPE)
	RETURN gipi_winvperl_tab PIPELINED;
	
	/*
	**  Modified by		: Mark JM
	**  Date Created 	: 02.11.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete record by supplying the par_id only
	*/
	PROCEDURE del_gipi_winvperl_1(p_par_id	GIPI_WINVPERL.par_id%TYPE);
    
    PROCEDURE get_prem_tsi_amt
    (p_par_id    IN     GIPI_WINVPERL.par_id%TYPE,
     p_item_grp  IN     GIPI_WINVPERL.item_grp%TYPE,
     p_peril_cd  IN     GIPI_WINVPERL.peril_cd%TYPE,
     p_tsi_amt   OUT    GIPI_WINVPERL.tsi_amt%TYPE,
     p_prem_amt  OUT    GIPI_WINVPERL.prem_amt%TYPE);
     
END Gipi_Winvperl_Pkg;
/


