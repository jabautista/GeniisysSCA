DROP FUNCTION CPI.GET_MAX_ENDT_PAR_ITEM_NO;

CREATE OR REPLACE FUNCTION CPI.Get_Max_Endt_Par_Item_No (p_par_id	GIPI_WPOLBAS.par_id%TYPE)
RETURN NUMBER
IS
	/*
	**  Created by		: Emman
	**  Date Created 	: 06.02.2010
	**  Reference By 	: (GIPIS060 - Endt Par Item Information)
	**  Description 	: Get the max item_no in GIPI_WITEM for Endt Par
	*/
	v_no	GIPI_WITEM.item_no%TYPE;
	v_par_no        gipi_witem.item_no%TYPE; 
    v_pol_no        gipi_witem.item_no%TYPE;
	v_line_cd		gipi_wpolbas.line_cd%TYPE;
	v_iss_cd		gipi_wpolbas.iss_cd%TYPE;
	v_subline_cd	gipi_wpolbas.subline_cd%TYPE;
	v_issue_yy		gipi_wpolbas.issue_yy%TYPE;
	v_pol_seq_no	gipi_wpolbas.pol_seq_no%TYPE;
	v_renew_no		gipi_wpolbas.renew_no%TYPE;	  
BEGIN
	SELECT line_cd, iss_cd, subline_cd, issue_yy, pol_seq_no, renew_no
	  INTO v_line_cd, v_iss_cd, v_subline_cd, v_issue_yy, v_pol_seq_no, v_renew_no
	  FROM GIPI_WPOLBAS
	 WHERE par_id = p_par_id;
	
	v_no := 1;
	FOR N1 IN (SELECT MAX(item_no) no
	               FROM gipi_witem
	              WHERE par_id = p_par_id)
	  LOOP              
	    v_par_no := n1.no;
	    EXIT;
	  END LOOP;  
	  FOR N2 IN (SELECT MAX(b.item_no) no
	               FROM gipi_polbasic a, gipi_item b
	              WHERE a.line_cd     =  v_line_cd
	                AND a.iss_cd      =  v_iss_cd
	                AND a.subline_cd  =  v_subline_cd
	                AND a.issue_yy    =  v_issue_yy
	                AND a.pol_seq_no  =  v_pol_seq_no
	                AND a.renew_no    =  v_renew_no
	                AND a.pol_flag    IN( '1','2','3','X')
	                AND a.policy_id = b.policy_id)
	  LOOP
	    v_pol_no := n2.no;
	    EXIT;
	  END LOOP;
	  IF NVL(v_par_no,0) > NVL(v_pol_no,0) THEN
	  	 v_no := v_par_no + 1; 
	  ELSIF	NVL(v_par_no,0) <= NVL(v_pol_no,0) THEN
	  	 v_no := v_pol_no + 1;
	  END IF;
	 
	RETURN v_no;
END;
/


