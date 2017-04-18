DROP PROCEDURE CPI.PREINSERT_GIPIS038_B490;

CREATE OR REPLACE PROCEDURE CPI.PREINSERT_GIPIS038_B490(
    p_par_id		    GIPI_WITMPERL.par_id%TYPE,
    p_line_cd		    GIPI_WITMPERL.line_cd%TYPE,
    p_peril_cd	        GIPI_WITMPERL.peril_cd%TYPE
) 
IS
    v_print_seq_no      GIPI_WPOLWC.print_seq_no%TYPE;
BEGIN
    -- marco - 04.10.2013 - added block to retrieve max print_seq_no
    BEGIN
        SELECT NVL(MAX(print_seq_no), 0)
          INTO v_print_seq_no
          FROM GIPI_WPOLWC
         WHERE par_id = p_par_id
           AND line_cd = p_line_cd;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            v_print_seq_no := 0;
    END;

    FOR A1 IN (SELECT  a.line_cd, a.main_wc_cd
                 FROM giis_peril_clauses a
                WHERE a.line_cd  = p_line_cd
                  AND a.peril_cd = p_peril_cd
                  AND NOT EXISTS (SELECT '1'
                                    FROM gipi_wpolwc b
                                   WHERE b.par_id = p_par_id
                                     AND b.line_cd = a.line_cd
                                     AND b.wc_cd   = a.main_wc_cd))                                    
    LOOP
        FOR B IN (SELECT line_cd, main_wc_cd, print_sw,wc_title
   	                FROM giis_warrcla
   	               WHERE line_cd = a1.line_cd
   	                 AND main_wc_cd = a1.main_wc_cd)
        LOOP
    	 	--A.R.C. 07.18.2006    	 	
    	 	/*IF :GLOBAL.PACK_PAR_ID IS NOT NULL THEN
    	 	 	 SELECT line_cd pack_line_cd
    	 	 	   INTO v_pack_line_cd
	           FROM gipi_pack_parlist
	          WHERE pack_par_id = :b240.pack_par_id;	          
	    	 	 INSERT INTO gipi_pack_wpolwc
	    	 	        (pack_par_id,       line_cd,    wc_cd,        swc_seq_no,    print_seq_no,
	    	 	         wc_title,     rec_flag,   print_sw,     change_tag)
	   	  	  VALUES(:b240.pack_par_id, v_pack_line_cd,  b.main_wc_cd, 0,  1,
	   	  	         b.wc_title,   'A',        b.print_sw,   'N');
            END IF;     */ 
            
            v_print_seq_no := v_print_seq_no + 1; -- marco - added
            
            INSERT INTO gipi_wpolwc
    	 	        (par_id,       line_cd,    wc_cd,        swc_seq_no,    print_seq_no,
    	 	         wc_title,     rec_flag,   print_sw,     change_tag)
            VALUES (p_par_id, b.line_cd,  b.main_wc_cd, 0,  v_print_seq_no, -- marco - 04.10.2013 - changed from hard-coded "1" to v_print_seq_no
   	  	            b.wc_title,   'A',        b.print_sw,   'N');
   	   END LOOP;
    END LOOP;
END PREINSERT_GIPIS038_B490;
/


