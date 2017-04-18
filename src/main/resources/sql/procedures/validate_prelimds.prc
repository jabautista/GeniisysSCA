DROP PROCEDURE CPI.VALIDATE_PRELIMDS;

CREATE OR REPLACE PROCEDURE CPI.validate_prelimds(
	   	  		  p_par_id	     IN  GIPI_PARLIST.par_id%TYPE,
				  p_line_cd		 IN  GIPI_PARLIST.line_cd%TYPE,
				  p_subline_cd	 IN  GIPI_WPOLBAS.subline_cd%TYPE,
				  p_iss_cd		 IN  GIPI_WPOLBAS.iss_cd%TYPE,
				  p_par_type	 IN  GIPI_PARLIST.par_type%TYPE,
				  p_msg_alert    OUT VARCHAR2
	   	  		  )
	    IS
          v_prelim_tsi	    GIUW_POL_DIST.tsi_amt%TYPE;
          v_pol_tsi			GIPI_WPOLBAS.tsi_amt%TYPE;
          v_itm_grp			GIPI_WITEM.item_grp%TYPE;
          v_count			NUMBER;
		  v_hull_cd  		GIIS_PARAMETERS.param_value_v%TYPE;
		  v_msg_alert   	VARCHAR2(2000);
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 24, 2010
  **  Reference By : (GIPIS055 - POST PAR)
  **  Description  : validate_prelimds program unit
  */
  
  /*IF :gauge.process='Y' THEN
     :gauge.FILE := 'Validating Preliminay Distribution...';
  ELSE
     :gauge.FILE := 'passing validate policy PRELIMDS';
  END IF;
  vbx_counter;*/
  /*BETH 031099 this was replaced with a select statement which sum tsi 
  **            of all items instead of getting it from polbasic  
  SELECT NVL(tsi_amt,0)
    INTO v_pol_tsi
    FROM gipi_wpolbas
   WHERE par_id = :postpar.par_id;
  */

/*  FOR A1 IN(SELECT (NVL(tsi_amt,0)*NVL(currency_rt,0)) tsi
              FROM gipi_witem
             WHERE par_id = :postpar.par_id)LOOP
         v_pol_tsi := NVL(v_pol_tsi,0) + A1.tsi;
  END LOOP; */
  
/*  SELECT SUM((NVL(tsi_amt,0)*NVL(currency_rt,0))) tsi,
    INTO v_pol_tsi
    FROM gipi_witem
   WHERE par_id = :postpar.par_id;

  SELECT SUM(NVL(tsi_amt,0))
    INTO v_prelim_tsi
    FROM giuw_pol_dist
   WHERE par_id = :postpar.par_id;

  IF v_prelim_tsi IS NOT NULL THEN
     IF v_pol_tsi != v_prelim_tsi THEN
        msg_alert('TSI amount does not match the TSI set by Underwriting.','I',FALSE);
        :gauge.file := 'TSI amount does not match the TSI set by Underwriting.';
        recompute_items;
        error_rtn;
     END IF;
  ELSE
     IF :postpar.par_type = 'E' AND
        :postpar.line_cd  = :postpar.hull_cd AND
        :postpar.subline_cd IN (:postpar.mrn_cd,:postpar.cmi_cd) THEN
        BEGIN
          v_count:=0;
          SELECT COUNT(*)
            INTO v_count
            FROM gipi_witmperl
           WHERE par_id  =:postpar.par_id;
          IF v_count!=0 THEN
             MSG_ALERT('Underwriting must first set a preliminary distribution.','E',TRUE);
             :gauge.file := 'Underwriting must first set a preliminary distribution.';
             error_rtn;
          END IF;
        EXCEPTION 
          WHEN NO_DATA_FOUND THEN NULL;
        END;
     END IF;
  END IF;*/
  
  BEGIN
    SELECT a.param_value_v
	  INTO v_hull_cd 
	  FROM GIIS_PARAMETERS a
	 WHERE a.param_name = 'LINE_CODE_MH';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       NULL;
  END;
  
  FOR a IN (SELECT SUM((NVL(tsi_amt,0)*NVL(currency_rt,0))) tsi,
  								 item_grp
							FROM GIPI_WITEM
   					 WHERE par_id = p_par_id
   					 GROUP BY item_grp)
  LOOP
  	v_pol_tsi:= a.tsi;
  	FOR b IN (SELECT DISTINCT tsi_amt
					      FROM GIUW_POL_DIST
   						 WHERE par_id = p_par_id
   						   AND item_grp = a.item_grp)
  	LOOP
  		v_prelim_tsi:=b.tsi_amt;
		  IF v_prelim_tsi IS NOT NULL THEN
		     IF v_pol_tsi != v_prelim_tsi THEN
		        p_msg_alert := 'TSI amount does not match the TSI set by Underwriting.';
		        --:gauge.FILE := 'TSI amount does not match the TSI set by Underwriting.';
		        recompute_items(p_par_id,p_line_cd,p_iss_cd,v_msg_alert);
	 			p_msg_alert := NVL(v_msg_alert,p_msg_alert);
		        --error_rtn;
		     END IF;
		  ELSE
		     IF p_par_type = 'E' AND
		        p_line_cd  = v_hull_cd AND
				p_subline_cd IN ('MRN','') THEN
		        --p_subline_cd IN (:postpar.mrn_cd,:postpar.cmi_cd) THEN
		        BEGIN
		          v_count:=0;
		          SELECT COUNT(*)
		            INTO v_count
		            FROM GIPI_WITMPERL
		           WHERE par_id  =p_par_id;
		          IF v_count!=0 THEN
		             p_msg_alert := 'Underwriting must first set a preliminary distribution.';
		             --:gauge.FILE := 'Underwriting must first set a preliminary distribution.';
		             --error_rtn;
		          END IF;
		        EXCEPTION 
		          WHEN NO_DATA_FOUND THEN NULL;
		        END;
		     END IF;
		  END IF;  		
  	END LOOP;
  END LOOP;  
END;
/


