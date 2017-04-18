DROP FUNCTION CPI.CREATE_DISTRIBUTION_ITEM;

CREATE OR REPLACE FUNCTION CPI.Create_Distribution_Item (
	p_par_id  IN NUMBER,
	p_dist_no IN NUMBER)
RETURN VARCHAR2
IS
	/*
	**  Created by		: Mark JM
	**  Date Created 	: 02.23.2010
	**  Reference By 	: (GIPIS010 - Item Information)
	**  Description 	: Delete all distribution tables if any affecting 
	** 					  changes have been made to the records in 
	** 					  gipi_witem. Alert about deleting records has been removed.
	** 					  Automatic delete will be implemented
	**					  (See GIPIS010 Create_Distribution_Item for the original procedure)
	*/	
	
	v_exist			NUMBER;	
	v_tsi_amt		GIPI_WITEM.tsi_amt%TYPE := 0;
	v_ann_tsi_amt	GIPI_WITEM.ann_tsi_amt%TYPE := 0;
	v_prem_amt		GIPI_WITEM.prem_amt%TYPE := 0;
	v_but			NUMBER;
	v_dist_cnt		NUMBER := 0;
	v_dist_max		GIUW_POL_DIST.dist_no%TYPE;
	v_result		VARCHAR2(180);
	CURSOR  C1  IS
		SELECT DISTINCT  frps_yy,
			   frps_seq_no
		  FROM GIRI_WDISTFRPS
		 WHERE dist_no = p_dist_no;
	CURSOR  C2  IS
		SELECT DISTINCT  frps_yy,
			   frps_seq_no
		  FROM GIRI_DISTFRPS
		 WHERE dist_no = p_dist_no;
BEGIN	
	SELECT SUM(tsi_amt     * currency_rt),
		   SUM(ann_tsi_amt * currency_rt),
		   SUM(prem_amt    * currency_rt)
	  INTO v_tsi_amt,
		   v_ann_tsi_amt,
		   v_prem_amt
	  FROM GIPI_WITEM
	 WHERE par_id = p_par_id;
       
    IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL) OR (v_prem_amt IS NULL)) THEN
		Gipis010_Delete_Ri_Tables(p_dist_no);
		Gipis010_Del_Wrkng_Dist_Tables(p_dist_no);
		Gipis010_Del_Main_Dist_Tables(p_dist_no);
		Giuw_Distrel_Pkg.del_giuw_distrel(p_dist_no);
		Giuw_Pol_Dist_Pkg.del_GIUW_POL_DIST(p_dist_no);
	END IF;
       
    BEGIN
		SELECT DISTINCT 1
		  INTO v_exist
		  FROM GIUW_POLICYDS
		 WHERE dist_no  =  p_dist_no;
	     
		IF SQL%FOUND THEN
			Gipis010_Delete_Ri_Tables(p_dist_no);
			Gipis010_Del_Wrkng_Dist_Tables(p_dist_no);
			Gipis010_Del_Main_Dist_Tables(p_dist_no);
			UPDATE GIUW_POL_DIST
			   SET user_id = USER,
				   last_upd_date = SYSDATE,
				   dist_type = NULL,
				   dist_flag = '1'
			 WHERE dist_no = p_dist_no;

			UPDATE GIPI_WPOLBAS
			   SET user_id = USER
			 WHERE par_id  = p_par_id;
		ELSE
			RAISE NO_DATA_FOUND;
		END IF; 	  
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			NULL;
	END;   
      
    BEGIN
		SELECT DISTINCT 1
		  INTO v_exist
		  FROM GIUW_WPOLICYDS
		 WHERE dist_no = p_dist_no;		
	EXCEPTION
		WHEN NO_DATA_FOUND THEN
			v_but := 1;
	END;    
    
	FOR C1_rec IN C1 LOOP
		Gipis010_Delete_Ri_Tables(p_dist_no);
		Giri_Wfrperil_Pkg.del_giri_wfrperil_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
		Giri_Wfrps_Ri_Pkg.del_giri_wfrps_ri_1(C1_rec.frps_yy, C1_rec.frps_seq_no);
		Giri_Wdistfrps_Pkg.del_GIRI_WDISTFRPS(p_dist_no);  
	END LOOP;
	  
	FOR C2_rec IN C2 LOOP		
		v_result := 'This PAR has corresponding records in the posted tables for RI. Could not proceed.';  /* RAISE FORM_TRIGGER_FAILURE */
		EXIT;
	END LOOP;
	
	IF NOT (v_result IS NULL) THEN
		RETURN v_result;
	END IF;
	
	Gipis010_Del_Wrkng_Dist_Tables(p_dist_no);		
	----------------------------------------------------------
	FOR a IN (
		SELECT SUM(tsi_amt     * currency_rt) tsi_amt,
			   SUM(ann_tsi_amt * currency_rt) ann_tsi_amt,
			   SUM(prem_amt    * currency_rt) prem_amt,
			   item_grp
		  FROM GIPI_WITEM
		 WHERE par_id = p_par_id
	  GROUP BY item_grp)
	LOOP    
		BEGIN
			IF v_but = 1 THEN
				BEGIN
					SELECT COUNT(dist_no), MAX(dist_no)
					  INTO v_dist_cnt, v_dist_max
					  FROM GIUW_POL_DIST
					 WHERE par_id = p_par_id
					   AND NVL(item_grp,a.item_grp) = a.item_grp;
				END; 
				
				IF v_dist_cnt > 1 THEN
					v_tsi_amt     := a.tsi_amt;
					v_prem_amt    := a.prem_amt;
					v_ann_tsi_amt := a.ann_tsi_amt;
				END IF;	
    
				IF p_dist_no = v_dist_max THEN 
					UPDATE GIUW_POL_DIST
					   SET tsi_amt = NVL(v_tsi_amt,0) , 
						   prem_amt = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/v_dist_cnt),2) * (v_dist_cnt - 1)),
						   ann_tsi_amt = NVL(v_ann_tsi_amt,0),
						   last_upd_date = SYSDATE,
						   user_id = USER
					 WHERE par_id = p_par_id
					   AND dist_no = p_dist_no
					   AND NVL(item_grp,a.item_grp) = a.item_grp;	        
				ELSE					
					UPDATE GIUW_POL_DIST
					   SET tsi_amt = NVL(v_tsi_amt,0), 
						   prem_amt = NVL(v_prem_amt,0) / v_dist_cnt,
						   ann_tsi_amt = NVL(v_ann_tsi_amt,0) ,
						   last_upd_date = SYSDATE,
						   user_id = USER
					 WHERE par_id = p_par_id
					   AND dist_no = p_dist_no
					   AND NVL(item_grp,a.item_grp) = a.item_grp;
				END IF;	
		    END IF;
	    
		EXCEPTION
			WHEN TOO_MANY_ROWS THEN
				v_result := 'There are too many distribution numbers assigned for this item. ' ||
							'Please call your administrator to rectify the matter. Check ' ||
							'records in the policy table with par_id = ' || TO_CHAR(p_par_id) || '.'; /* RAISE FORM_TRIGGER_FAILURE */				
			WHEN NO_DATA_FOUND THEN
				NULL;
	    END;
	END LOOP;
	
	IF NOT (v_result IS NULL) THEN
		RETURN v_result;
	END IF;
	
    DELETE FROM GIUW_POL_DIST a
	 WHERE par_id = p_par_id
	   AND dist_no = p_dist_no
	   AND NOT EXISTS (
				SELECT 1 
				  FROM GIPI_WITEM b
				 WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
				   AND b.par_id = a.par_id); 
	RETURN v_result;
EXCEPTION
	WHEN NO_DATA_FOUND THEN
		v_result := 'Pls. be adviced that there are no items for this PAR.'; /* RAISE FORM_TRIGGER_FAILURE */
		RETURN v_result;
END;
/


