CREATE OR REPLACE PACKAGE BODY CPI.GIIS_PERIL_CLAUSES_PKG AS

  FUNCTION get_giis_peril_clauses(p_line_cd  GIIS_PERIL_CLAUSES.line_cd%TYPE)
    RETURN giis_peril_clauses_tab PIPELINED
	IS
	v_pc   giis_peril_clauses_type;
  BEGIN
    FOR i IN (SELECT a.line_cd, a.peril_cd, a.main_wc_cd, b.print_sw, b.wc_title
	            FROM giis_peril_clauses a, giis_warrcla b
	           WHERE a.line_cd  = p_line_cd
			     AND b.line_cd = a.line_cd
				 AND b.main_wc_cd = a.main_wc_cd)
	LOOP
	  v_pc.line_cd	 		  := i.line_cd;
	  v_pc.peril_cd	 		  := i.peril_cd;
	  v_pc.main_wc_cd		  := i.main_wc_cd;
	  v_pc.print_sw			  := i.print_sw;
	  v_pc.wc_title			  := i.wc_title;
	  PIPE ROW(v_pc);
	END LOOP;
	RETURN;
  END get_giis_peril_clauses;

END GIIS_PERIL_CLAUSES_PKG;
/


