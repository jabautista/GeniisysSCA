DROP PROCEDURE CPI.WHEN_NEWFORM_INST_B_GIPIS038;

CREATE OR REPLACE PROCEDURE CPI.When_Newform_Inst_B_Gipis038(
	   p_par_id	  			IN GIPI_PARLIST.par_id%TYPE,
	   p_pack_par_id		IN GIPI_PARLIST.pack_par_id%TYPE,
	   p_pack_line_cd		IN GIPI_WITEM.pack_line_cd%TYPE,
	   p_pack_subline_cd	IN GIPI_WITEM.pack_subline_cd%TYPE,
	   v_pack_plan_sw		OUT GIPI_PACK_WPOLBAS.plan_sw%TYPE,
  	   v_pack_plan_cd		OUT GIPI_PACK_WPOLBAS.plan_cd%TYPE,
  	   v_plan_sw			OUT GIPI_PACK_WPOLBAS.plan_sw%TYPE
	   ) 
IS
  --v_pack_plan_sw	GIPI_PACK_WPOLBAS.plan_sw%TYPE;
  --v_pack_plan_cd	GIPI_PACK_WPOLBAS.plan_cd%TYPE;
  --v_plan_sw			GIPI_PACK_WPOLBAS.plan_sw%TYPE;		
  
BEGIN
  IF p_pack_par_id IS NOT NULL THEN
   
   BEGIN
    SELECT NVL(b.plan_sw, 'N'), a.plan_cd
	    INTO v_pack_plan_sw, v_pack_plan_cd 
	    FROM GIIS_PACK_PLAN_COVER a,GIPI_PACK_WPOLBAS b
	   WHERE b.pack_par_id = p_pack_par_id
	     AND a.plan_cd = b.plan_cd
	     AND a.pack_line_cd = p_pack_line_cd 
	     AND a.pack_subline_cd = p_pack_subline_cd;  
EXCEPTION
	  WHEN no_data_found THEN
	       v_pack_plan_sw := 'N';
	 END;   
     IF NVL(v_pack_plan_sw, 'N') = 'Y' THEN
	      UPDATE GIPI_WPOLBAS
    	     SET plan_sw = 'Y'
    	   WHERE par_id = p_par_id;
    	  
    	  UPDATE GIPI_WPOLBAS
    	     SET plan_cd = v_pack_plan_cd 
    	   WHERE par_id = p_par_id;
        commit;   
     END IF;
ELSE 
   /** For Regular Line  **/
 	SELECT NVL(plan_sw, 'N')
	  INTO v_plan_sw 
	  FROM GIPI_WPOLBAS
	 WHERE par_id = p_par_id;
END IF;
END When_Newform_Inst_B_Gipis038;
/


