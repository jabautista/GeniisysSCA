CREATE OR REPLACE PACKAGE BODY CPI.GIIS_DEDUCTIBLE_LIST_PKG AS

/********************************** FUNCTION 1 ************************************
  MODULE: GIPIS004 
  RECORD GROUP NAME: CGFK$B350_DSP_DEDUCTIBLE_CD 
***********************************************************************************/

  FUNCTION get_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   		 			    p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE) 
	RETURN deductible_list_tab PIPELINED IS
  
  v_deductible		deductible_list_type;
  
  BEGIN
  	FOR i IN (
		SELECT deductible_title, line_cd, ded_type, subline_cd, REPLACE(deductible_cd, '/', 'slash') deductible_cd, deductible_text, deductible_amt, deductible_rt, min_amt, max_amt, range_sw 
		  FROM GIIS_DEDUCTIBLE_DESC 
		 WHERE line_cd = p_line_cd 
		   AND subline_cd = p_subline_cd
         ORDER BY UPPER(deductible_title))
	LOOP
	    v_deductible.deductible_title 	:= i.deductible_title;
		v_deductible.line_cd			:= i.line_cd;
		v_deductible.subline_cd			:= i.subline_cd;				
		v_deductible.deductible_cd	  	:= i.deductible_cd;
		v_deductible.deductible_text	:= i.deductible_text;		
		v_deductible.deductible_amt	  	:= i.deductible_amt;
		v_deductible.deductible_rt 		:= i.deductible_rt;
		v_deductible.ded_type 			:= i.ded_type;
        v_deductible.min_amt            := i.min_amt;
        v_deductible.max_amt            := i.max_amt;
        v_deductible.range_sw           := i.range_sw;
	  PIPE ROW(v_deductible);
	END LOOP;
	
    RETURN;
  END get_deductible_list;

/********************************** FUNCTION 2 ************************************/

  FUNCTION get_ded_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   					       p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE) 
	RETURN ded_deductible_list_tab PIPELINED IS
  
  v_deductible		ded_deductible_list_type;
  
  BEGIN
  	FOR i IN (
		SELECT REPLACE(deductible_cd, '/', 'slash') deductible_cd, 
               deductible_title,    ded_type,       rv_meaning ded_type_desc, 
			   deductible_rt,       deductible_amt, deductible_text, 
               min_amt,             max_amt,        range_sw 
		  FROM GIIS_DEDUCTIBLE_DESC, CG_REF_CODES
		 WHERE line_cd      = p_line_cd
		   AND subline_cd   = p_subline_cd  
		   AND rv_domain    = 'GIIS_DEDUCTIBLE_DESC.DED_TYPE'
		   AND rv_low_value = DED_TYPE
		ORDER BY deductible_cd)
	LOOP
	    v_deductible.deductible_cd	  	:= i.deductible_cd;
		v_deductible.deductible_title 	:= i.deductible_title;
        v_deductible.ded_type   		:= i.ded_type;
		v_deductible.ded_type_desc		:= i.ded_type_desc;
		v_deductible.deductible_rt	  	:= i.deductible_rt;
		v_deductible.deductible_amt	  	:= i.deductible_amt;
		v_deductible.deductible_text  	:= i.deductible_text;
		v_deductible.min_amt	  		:= i.min_amt;
		v_deductible.max_amt	  		:= i.max_amt;
		v_deductible.range_sw	  		:= i.range_sw;				
	  PIPE ROW(v_deductible);
	END LOOP;
	
    RETURN;
  END get_ded_deductible_list;
  
  
/********************************** FUNCTION 3 ************************************  
  MODULE: GIPIS011 
  RECORD GROUP NAME: CGFK$B350_PACK_DEDUCTIBLE_CD 
***********************************************************************************/
  
  FUNCTION get_pack_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   			 			    p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE,
									p_par_id		GIPI_WDEDUCTIBLES.par_id%TYPE) 
	RETURN pack_deductible_list_tab PIPELINED IS
  
  v_deductible		pack_deductible_list_type;
  
  BEGIN
  	FOR i IN (
		SELECT deductible_cd, deductible_title, deductible_amt 
		  FROM GIIS_DEDUCTIBLE_DESC 
		 WHERE line_cd    = p_line_cd 
		   AND subline_cd = p_subline_cd 
		   AND deductible_cd NOT IN (SELECT ded_deductible_cd 
		  	  					       FROM GIPI_WDEDUCTIBLES 
									  WHERE par_id = p_par_id))
	LOOP
	    v_deductible.deductible_cd	  	:= i.deductible_cd;
		v_deductible.deductible_title 	:= i.deductible_title;
		v_deductible.deductible_amt	  	:= i.deductible_amt;
	  PIPE ROW(v_deductible);
	END LOOP;
	
    RETURN;
  END get_pack_deductible_list;

/********************************** FUNCTION 4 ************************************
  MODULE: GIPIS004 
  RECORD GROUP NAME: CGFK$B350_DSP_DEDUCTIBLE_TITLE 
***********************************************************************************/

  FUNCTION get_item_deductible_list(p_line_cd 		GIIS_LINE.line_cd%TYPE, 
  		   			 			    p_subline_cd 	GIIS_SUBLINE.subline_cd%TYPE,
									p_par_id		GIPI_WDEDUCTIBLES.par_id%TYPE,
									p_item_no		GIPI_WDEDUCTIBLES.item_no%TYPE) 
	RETURN item_deductible_list_tab PIPELINED IS
  
  v_deductible		item_deductible_list_type;
  
  BEGIN
  	FOR i IN (
		SELECT deductible_title, line_cd, subline_cd, deductible_cd, deductible_text, deductible_amt 
		  FROM GIIS_DEDUCTIBLE_DESC 
		 WHERE line_cd    = p_line_cd 
		   AND subline_cd = p_subline_cd 
		   AND deductible_cd NOT IN (SELECT ded_deductible_cd 
		  	  					       FROM GIPI_WDEDUCTIBLES 
									  WHERE par_id  = p_par_id
									    AND item_no = p_item_no))
	LOOP
	    v_deductible.deductible_title 	:= i.deductible_title;
		v_deductible.line_cd			:= i.line_cd;
		v_deductible.subline_cd			:= i.subline_cd;				
		v_deductible.deductible_cd	  	:= i.deductible_cd;
		v_deductible.deductible_text	:= i.deductible_text;		
		v_deductible.deductible_amt	  	:= i.deductible_amt;
	  PIPE ROW(v_deductible);
	END LOOP;
	
    RETURN;
  END get_item_deductible_list;  
  
END GIIS_DEDUCTIBLE_LIST_PKG;
/


