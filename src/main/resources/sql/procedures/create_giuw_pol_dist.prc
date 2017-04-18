DROP PROCEDURE CPI.CREATE_GIUW_POL_DIST;

CREATE OR REPLACE PROCEDURE CPI.Create_Giuw_Pol_Dist(p_par_id IN NUMBER,p_line_cd IN VARCHAR2, p_msg_alert OUT VARCHAR2 ) IS
				p_dist_no   GIUW_POL_DIST.dist_no%TYPE;        
		 	  p_no_of_takeup      	  GIIS_TAKEUP_TERM.no_of_takeup%TYPE;
		 	  p_yearly_tag            GIIS_TAKEUP_TERM.yearly_tag%TYPE;
		 	  p_takeup_term       	  GIPI_WPOLBAS.takeup_term%TYPE;
			  p_eff_date			  GIPI_WPOLBAS.eff_date%TYPE;
			  p_expiry_date			  GIPI_WPOLBAS.expiry_date%TYPE;
			  p_endt_type			  GIPI_WPOLBAS.endt_type%TYPE;
			  p_policy_id 			  GIPI_POLBASIC.policy_id%TYPE;							  
		 	
		 	  v_policy_days           NUMBER:=0;
		 	  v_no_of_payment         NUMBER:=1;
		 	  v_duration_frm          DATE;
		 	  v_duration_to           DATE;			  
		 	  v_days_interval         NUMBER:=0;
		 	  v_tsi_amt								GIUW_POL_DIST.tsi_amt%TYPE;
		 	  v_prem_amt							GIUW_POL_DIST.prem_amt%TYPE;
		 	  v_ann_tsi_amt						GIUW_POL_DIST.ann_tsi_amt%TYPE;
		 	  v_notfound VARCHAR2(1) := 'N';
		 	  v_nodata   VARCHAR2(1) := 'N';
		 	  v_toomany  VARCHAR2(1) := 'N';
		 	  
		 	  CURSOR B IS
       SELECT  pol_dist_dist_no_s.NEXTVAL
         FROM  sys.dual;
BEGIN
		 		/*FOR A IN (SELECT sum(tsi_amt*NVL(currency_rt,1)) tsi,
                         sum(prem_amt*NVL(currency_rt,1)) prem,
                         sum(ann_tsi_amt*NVL(currency_rt,1)) ann_tsi
                    FROM gipi_witem
                   WHERE par_id = p_par_id) LOOP
           v_tsi_amt     := A.tsi;
           v_prem_amt    := A.prem;
           v_ann_tsi_amt := A.ann_tsi;
				END LOOP;
				  
        SELECT eff_date,
	 					   expiry_date, 
	 					   endt_type,
	 					   takeup_term
		 		  INTO p_eff_date,
			 			   p_expiry_date,
			 			   p_endt_type,
			 			   p_takeup_term
		 		  FROM gipi_wpolbas
		 		 WHERE par_id  =  p_par_id;*/   -- replaced w/ database procedure by mOn 03242009 --
				Create_Giuw_Poldist_D_Gipis002(p_par_id, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, p_eff_date, p_expiry_date, p_endt_type, p_takeup_term,
                                       v_nodata, v_toomany);
		 		IF v_toomany = 'Y' THEN
	      	      p_msg_alert := 'Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||'to rectify the matter. Check record with par_id = '||TO_CHAR(p_par_id);
		 		END IF;
		 	  IF v_nodata = 'Y' THEN
		 	    p_msg_alert := 'You have committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.';
		 	  END IF;
		 	  -- end mOn --

		 		IF ((p_eff_date IS NULL ) OR (p_expiry_date IS NULL)) THEN
		      p_msg_alert := 'Effectivity or expiry has not been updated.';
		    END IF;
		 		 
        FOR A IN (SELECT SUM(tsi_amt*NVL(currency_rt,1)) tsi_amt,
                         SUM(prem_amt*NVL(currency_rt,1)) prem_amt,
                         SUM(ann_tsi_amt*NVL(currency_rt,1)) ann_tsi_amt,
						 						 item_grp
                    FROM GIPI_WITEM
                   WHERE par_id = p_par_id
				   				 GROUP BY item_grp) 
				LOOP
			 		IF TRUNC(p_expiry_date - p_eff_date) = 31 THEN
			 		  v_policy_days      := 30;
			 		ELSE
			 		  v_policy_days      := TRUNC(p_expiry_date - p_eff_date);
			 		END IF;
			 		
			 		/*FOR b1 IN (SELECT no_of_takeup, yearly_tag
			 				         FROM giis_takeup_term
			 			          WHERE takeup_term = p_takeup_term)
			 		LOOP
			 			p_no_of_takeup := b1.no_of_takeup;
			 		  p_yearly_tag   := b1.yearly_tag;
			 		END LOOP;*/   -- replaced w/ database procedure by mOn 03242009 --
			 		Create_Giuw_Poldist_A_Gipis002(p_takeup_term, p_no_of_takeup, p_yearly_tag);
			 		
			 		IF p_yearly_tag = 'Y' THEN
			 			IF TRUNC((v_policy_days)/365,2) * p_no_of_takeup >
			 				TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) THEN
			 				v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup) + 1;
			 			ELSE
			 				v_no_of_payment   := TRUNC(TRUNC((v_policy_days)/365,2) * p_no_of_takeup);
			 			END IF;
			 		ELSE
			 			IF v_policy_days < p_no_of_takeup THEN
			 				v_no_of_payment := v_policy_days;
			 			ELSE
			 				v_no_of_payment := p_no_of_takeup;
			 			END IF;
			 		END IF;
			 		
			 		IF v_no_of_payment < 1 THEN
			 			v_no_of_payment := 1;
			 		END IF;
					
					v_days_interval := ROUND(v_policy_days/v_no_of_payment);
			 		p_policy_id := NULL;
					
			 		IF v_no_of_payment = 1 THEN -------------------------------------------------------- IF: Single takeup (x)
			 			/*OPEN B;
			            FETCH B INTO p_dist_no;
			            IF B%NOTFOUND THEN
			               msg_alert('No row in table DUAL.','W',TRUE);
			            END IF;
			            CLOSE B;
			 			
			 			INSERT INTO giuw_pol_dist(dist_no, par_id, policy_id, endt_type, tsi_amt,
												  prem_amt, ann_tsi_amt, dist_flag, redist_flag,
												  eff_date, expiry_date, create_date, user_id,
												  last_upd_date, post_flag, auto_dist,
												  -- longterm --
											    item_grp, takeup_seq_no)
								 		   VALUES(p_dist_no,p_par_id,p_policy_id,p_endt_type,NVL(v_tsi_amt,0),
												  NVL(v_prem_amt,0),NVL(v_ann_tsi_amt,0),1,1,
												  p_eff_date,p_expiry_date,sysdate,NVL(giis_users_pkg.app_user, USER),
												  sysdate, 'O', 'N',
												  -- longterm --
											  	NULL, NULL);*/   -- replaced w/ database procedure by mOn 03242009 --
			 	  	Create_Giuw_Poldist_B_Gipis002(p_dist_no, p_par_id, p_policy_id, p_endt_type, v_tsi_amt, v_prem_amt, v_ann_tsi_amt, p_eff_date,            
			 	  	                               p_expiry_date, NVL(giis_users_pkg.app_user, USER), v_notfound);
			 	  	IF v_notfound = 'Y' THEN
			 	  		p_msg_alert := 'No row in table DUAL.';
			 	  	END IF;
			 	  	-- end mOn --
						EXIT;
			 		ELSE --------------------------------------------------------------------------------- ELSE: MULTI TAKE-UP (x)
			 			------------------------------------------------------------------------------------ LONG TERM LOOP start
						v_duration_frm := NULL;
						v_duration_to  := NULL;
			 			FOR takeup_val IN 1.. v_no_of_payment LOOP
						  /*IF v_duration_frm IS NULL THEN
						     v_duration_frm := TRUNC(p_eff_date);						   	   		   
							ELSE
							   v_duration_frm := TRUNC(v_duration_frm + v_days_interval);						   
							END IF;
							v_duration_to  := TRUNC(v_duration_frm + v_days_interval) - 1;
							
							OPEN B;
				            FETCH B INTO p_dist_no;
				            IF B%NOTFOUND THEN
				               msg_alert('No row in table DUAL.','W',TRUE);
				            END IF;
				            CLOSE B;
			 				IF takeup_val = v_no_of_payment THEN --------------------------------------------- IF: last loop record (y)
			 					FOR xyz IN (SELECT SUM((NVL(DECODE(c.peril_type,'B',x.tsi_amt,0),0)* NVL(currency_rt,1))) tsi_amt, 
    								 							 SUM((NVL(x.prem_amt,0)* NVL(currency_rt,1)) - (ROUND(((NVL(x.prem_amt,0)* NVL(currency_rt,1))/v_no_of_payment),2) * (v_no_of_payment - 1))) prem_amt, 
    								 							 SUM((NVL(DECODE(c.peril_type,'B',x.ann_tsi_amt,0),0)* NVL(currency_rt,1))) ann_tsi_amt
    													FROM GIPI_WITMPERL x, GIPI_WITEM b, giis_peril c
    						   					 WHERE x.par_id = b.par_id
    							 						 AND x.item_no = b.item_no
    							 						 AND x.par_id = p_par_id
	   							 						 AND b.item_grp  = A.item_grp
	   							 						 AND x.peril_cd = c.peril_cd
	   							 						 AND c.line_cd  = :b240.line_cd)
				  			LOOP
		 							INSERT INTO GIUW_POL_DIST
					  				(dist_no, par_id, policy_id, endt_type, 
									   dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
									   last_upd_date, post_flag, auto_dist,
									   tsi_amt, 
									   prem_amt, 
									   ann_tsi_amt,
									   -- longterm --
									   item_grp, takeup_seq_no)
			 						VALUES
									  (p_dist_no,p_par_id,p_policy_id,p_endt_type,													        
							 		   1,1,v_duration_frm,v_duration_to,SYSDATE,NVL(giis_users_pkg.app_user, USER),
							 		   SYSDATE, 'O', 'N',
							 		   xyz.tsi_amt,--NVL(a.tsi_amt,0) - (ROUND((NVL(a.tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
									   xyz.prem_amt,--NVL(a.prem_amt,0) - (ROUND((NVL(a.prem_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
							 		   xyz.ann_tsi_amt,--NVL(a.ann_tsi_amt,0) - (ROUND((NVL(a.ann_tsi_amt,0)/ v_no_of_payment),2) * (v_no_of_payment - 1)),
									   -- longterm --
									   a.item_grp, takeup_val);
				  			END LOOP;
			 				ELSE ----------------------------------------------------------------------------- ELSE: other loop records (y)
			 					FOR xyz IN (SELECT SUM(ROUND(((NVL(DECODE(c.peril_type,'B',x.tsi_amt,0),0)* NVL(currency_rt,1))),2)) tsi_amt, 
							    								 SUM(ROUND(((NVL(x.prem_amt,0)* NVL(currency_rt,1))/v_no_of_payment),2)) prem_amt, 
							    								 SUM(ROUND(((NVL(DECODE(c.peril_type,'B',x.ann_tsi_amt,0),0)* NVL(currency_rt,1))),2)) ann_tsi_amt
							    						FROM GIPI_WITMPERL x, GIPI_WITEM b, giis_peril c
							    				 	 WHERE x.par_id = b.par_id
							    						 AND x.item_no = b.item_no
							    						 AND x.par_id = p_par_id
							     						 AND b.item_grp  = A.item_grp
							     						 AND x.peril_cd = c.peril_cd
							     						 AND c.line_cd  = :b240.line_cd)
				  			LOOP
									INSERT INTO GIUW_POL_DIST
									  (dist_no, par_id, policy_id, endt_type, 
						 			   dist_flag, redist_flag, eff_date, expiry_date, create_date, user_id,
						 			   last_upd_date, post_flag, auto_dist,
						 			   tsi_amt, 
						 			   prem_amt, 
						 			   ann_tsi_amt,
									   -- longterm --
									   item_grp, takeup_seq_no)
						 			VALUES
									  (p_dist_no,p_par_id,p_policy_id,p_endt_type,													        
						 			   1,1,v_duration_frm,v_duration_to,SYSDATE,NVL(giis_users_pkg.app_user, USER),
						 			   SYSDATE, 'O', 'N',
						 			   xyz.tsi_amt,--(NVL(a.tsi_amt,0)/ v_no_of_payment),
						 			   xyz.prem_amt,--(NVL(a.prem_amt,0)/ v_no_of_payment),
						 			   xyz.ann_tsi_amt,--(NVL(a.ann_tsi_amt,0)/ v_no_of_payment),
									   -- longterm --
									   a.item_grp, takeup_val);
				  			END LOOP;
			 				END IF; -------------------------------------------------------------------------- END IF: loop record (y)
			 				*/   -- replaced w/ database procedure by mOn 03242009 --
			 				Create_Giuw_Poldist_C_Gipis002(v_duration_frm, v_days_interval, v_duration_to, p_dist_no, takeup_val, v_no_of_payment, p_par_id,
                                             a.item_grp, p_line_cd, p_policy_id, p_endt_type, p_eff_date, NVL(giis_users_pkg.app_user, USER), v_notfound);
			 			END LOOP;
			 			------------------------------------------------------------------------------------ LONG TERM LOOP end	
			 				END IF; ------------------------------------------------------------------------------ END IF TAKEUPS (x)
		 		END LOOP;
/*EXCEPTION
	WHEN TOO_MANY_ROWS THEN
		msg_alert('Multiple rows were found to exist in GIPI_WPOLBAS. Please call your administrator '||
						'to rectify the matter. Check record with par_id = '||to_char(p_par_id),'W',TRUE);
	WHEN NO_DATA_FOUND THEN
		msg_alert('You have committed an illegal transaction. No records were retrieved in GIPI_WPOLBAS.','W',TRUE);*/
END;
		 	--------------------- MODIFIED BY GMI 01/23/08 upto here -----------------------------
/


