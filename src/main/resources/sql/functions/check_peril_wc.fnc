DROP FUNCTION CPI.CHECK_PERIL_WC;

CREATE OR REPLACE FUNCTION CPI.CHECK_PERIL_WC(
    p_peril_cd GIIS_PERIL.peril_cd%TYPE, 
    p_line GIIS_PERIL.line_cd%TYPE, 
    p_quote_id GIPI_QUOTE.quote_id%TYPE) 
RETURN VARCHAR2 IS
    /*
    **  Created by      : D.Alcantara
    **  Date Created 	: 12.27.2010
	**  Reference By 	: (GIIMM002 - Quotation Informaton)
	**  Description 	: This function checks if a peril has an attached
	**  				: default warranty	
	*/
    
    v_exist VARCHAR2(2);
    v_wc_found VARCHAR2(2);
    v_wc_exist VARCHAR2(2);
BEGIN
     v_wc_found := 'N';
     v_wc_exist := 'N';
     FOR rec1 IN ( SELECT 1
                     FROM giis_peril a170, giis_peril_clauses b  
                    WHERE a170.LINE_CD = b.LINE_CD
                      AND a170.peril_cd = b.peril_cd
                      AND a170.line_cd = p_line 
                      AND a170.peril_cd = p_peril_cd)
     LOOP
       v_wc_found := 'Y';
     END LOOP;
     
     FOR rec2 IN ( SELECT 1
                     FROM giis_peril a170, 
                          giis_peril_clauses b,  
                          gipi_quote_wc c
                    WHERE a170.LINE_CD = b.LINE_CD
                      AND a170.peril_cd = b.peril_cd
                      AND b.main_wc_cd = c.wc_cd
                      AND a170.line_cd = p_line 
                      AND a170.peril_cd = p_peril_cd
                      AND quote_id = p_quote_id)
     LOOP
       v_wc_exist := 'Y';
     END LOOP;
     
     IF v_wc_found = 'Y' AND v_wc_exist = 'N' THEN
        v_exist := 'Y';
     ELSE
        v_exist := 'N';
     END IF;                 
     RETURN v_exist;
END CHECK_PERIL_WC;
/


