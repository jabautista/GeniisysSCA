CREATE OR REPLACE PACKAGE CPI.GIIS_PERIL_CLAUSES_PKG AS

  TYPE giis_peril_clauses_type IS RECORD(
    line_cd			GIIS_PERIL_CLAUSES.line_cd%TYPE,
	peril_cd		GIIS_PERIL_CLAUSES.peril_cd%TYPE,
	main_wc_cd		GIIS_PERIL_CLAUSES.main_wc_cd%TYPE,
	print_sw		GIIS_WARRCLA.print_sw%TYPE,
	wc_title		GIIS_WARRCLA.wc_title%TYPE   
  );
  
  TYPE giis_peril_clauses_tab IS TABLE OF giis_peril_clauses_type;
  
  FUNCTION get_giis_peril_clauses(p_line_cd  GIIS_PERIL_CLAUSES.line_cd%TYPE)
    RETURN giis_peril_clauses_tab PIPELINED;

END GIIS_PERIL_CLAUSES_PKG;
/


