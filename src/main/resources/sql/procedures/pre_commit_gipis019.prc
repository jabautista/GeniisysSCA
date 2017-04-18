DROP PROCEDURE CPI.PRE_COMMIT_GIPIS019;

CREATE OR REPLACE PROCEDURE CPI.pre_commit_gipis019(
	   	  		  p_par_id		IN  GIPI_WAVIATION_ITEM.par_id%TYPE,							
	   	  		  p_item_no		IN	GIPI_WAVIATION_ITEM.item_no%TYPE,
				  p_vessel_cd	IN	GIPI_WAVIATION_ITEM.vessel_cd%TYPE,
				  p_rec_flag    OUT VARCHAR2			
				  )
	   IS
   v_line_cd	  GIPI_WPOLBAS.line_cd%TYPE;
   v_subline_cd	  GIPI_WPOLBAS.subline_cd%TYPE;
   v_iss_cd		  GIPI_WPOLBAS.iss_cd%TYPE;
   v_issue_yy	  GIPI_WPOLBAS.issue_yy%TYPE;
   v_pol_seq_no	  GIPI_WPOLBAS.pol_seq_no%TYPE;
   v_rec_flag	  gipi_item_ves_v.rec_flag%TYPE;
BEGIN
    /*
	**  Created by		: Jerome Orio 
	**  Date Created 	: 04.28.2010 
	**  Reference By 	: (GIPIS019 - Aviation Item Info) 
 	**  Description 	: FORM pre-commit trigger 
	*/
   FOR i IN (SELECT line_cd,subline_cd,iss_cd,issue_yy,pol_seq_no
       	 	   FROM gipi_wpolbas
			  WHERE par_id = p_par_id)
   LOOP
      v_line_cd     := i.line_cd;
	  v_subline_cd  := i.subline_cd;
	  v_iss_cd 		:= i.iss_cd;
	  v_pol_seq_no  := i.pol_seq_no;
   END LOOP;			  
			  	
	
   SELECT rec_flag 
     INTO v_rec_flag
     FROM gipi_item_ves_v a
    WHERE line_cd    = v_line_cd AND
          subline_cd = v_subline_cd AND
          iss_cd     = v_iss_cd AND
          issue_yy   = v_issue_yy AND
          pol_seq_no = v_pol_seq_no AND
          item_no    = p_item_no AND
          vessel_cd  = p_vessel_cd AND
          eff_date   = (SELECT MAX(eff_date)
                          FROM gipi_item_ves_v b
                         WHERE b.line_cd    = a.line_cd AND
                               b.subline_cd = a.subline_cd AND
                               b.iss_cd     = a.iss_cd AND
                               b.issue_yy   = a.issue_yy AND
                               b.pol_seq_no = a.pol_seq_no AND
                                 item_no    = p_item_no AND
                                 vessel_cd  = p_vessel_cd);
       IF v_rec_flag = 'A' OR v_rec_flag = 'C' THEN
          p_rec_flag := 'C';
       ELSIF v_rec_flag = 'D' THEN
          p_rec_flag := 'A';
       END IF;
     EXCEPTION
       WHEN NO_DATA_FOUND THEN
           p_rec_flag := 'A';
END;
/


