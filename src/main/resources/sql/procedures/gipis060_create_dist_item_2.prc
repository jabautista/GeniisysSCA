DROP PROCEDURE CPI.GIPIS060_CREATE_DIST_ITEM_2;

CREATE OR REPLACE PROCEDURE CPI.GIPIS060_CREATE_DIST_ITEM_2(b_par_id  IN NUMBER,
                                   pi_dist_no IN NUMBER,								   
								   p_rec_exists_alert IN VARCHAR2,
								   p_dist_alert IN VARCHAR2,
								   p_message OUT VARCHAR2) IS
  b_exist        NUMBER;
  p_exist        NUMBER;
  p_dist_no      giuw_pol_dist.dist_no%TYPE;
  p_frps_yy      giri_wdistfrps.frps_yy%TYPE;
  p_frps_seq_no  giri_wdistfrps.frps_seq_no%TYPE;
  p2_dist_no     giuw_pol_dist.dist_no%TYPE;
  p_eff_date     gipi_polbasic.eff_date%TYPE;
  p_expiry_date  gipi_polbasic.expiry_date%TYPE;
  p_endt_type    gipi_polbasic.endt_type%TYPE;
  p_policy_id    gipi_polbasic.policy_id%TYPE;
  p_tsi_amt      gipi_witem.tsi_amt%TYPE;
  p_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE;
  p_prem_amt     gipi_witem.prem_amt%TYPE;
  v_tsi_amt      gipi_witem.tsi_amt%TYPE      := 0;
  v_ann_tsi_amt  gipi_witem.ann_tsi_amt%TYPE  := 0;
  v_prem_amt     gipi_witem.prem_amt%TYPE     := 0;
  x_but          NUMBER;
  dist_cnt 			 NUMBER:=0;
  dist_max 			 giuw_pol_dist.dist_no%TYPE;      
 
  CURSOR  C1  IS
      SELECT   distinct  frps_yy,
                         frps_seq_no
        FROM   giri_wdistfrps
       WHERE   dist_no = pi_dist_no;
  CURSOR  C2  IS
      SELECT   distinct  frps_yy,
                         frps_seq_no
        FROM   giri_distfrps
       WHERE   dist_no = pi_dist_no;
BEGIN
   SELECT    sum(tsi_amt     * currency_rt),
	            sum(ann_tsi_amt * currency_rt),
	            sum(prem_amt    * currency_rt)
	    INTO    v_tsi_amt,
	            v_ann_tsi_amt,
	            v_prem_amt
	    FROM    gipi_witem
	   WHERE    par_id = b_par_id;
	   
	  IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL)
	    OR (v_prem_amt IS NULL)) THEN
	    	GIPIS010_DELETE_RI_TABLES(pi_dist_no);
			DELETE_WORKING_DIST_TABLES(pi_dist_no);
			DELETE_MAIN_DIST_TABLES(pi_dist_no);
	    	DELETE giuw_distrel
	     	 WHERE dist_no_old = pi_dist_no;
	    	DELETE   giuw_pol_dist
	       WHERE   dist_no  =  pi_dist_no;
	  END IF;
	  
	  
	 IF p_rec_exists_alert = 'Y' THEN
        GIPIS010_DELETE_RI_TABLES(pi_dist_no);
		DELETE_WORKING_DIST_TABLES(pi_dist_no);
		DELETE_MAIN_DIST_TABLES(pi_dist_no);
        UPDATE GIUW_POL_DIST
           SET user_id       = user,
               last_upd_date = sysdate,
               dist_type     = null,
               dist_flag     = '1'
         WHERE dist_no = pi_dist_no;
   
        UPDATE GIPI_WPOLBAS
           SET user_id      = user
         WHERE par_id  = b_par_id;
     END IF;
	 
	IF p_dist_alert ='Y' THEN
	   FOR C1_rec IN C1 LOOP
	        GIPIS010_DELETE_RI_TABLES(pi_dist_no);
	        DELETE   giri_wfrperil
	         WHERE   frps_yy     =   C1_rec.frps_yy
	           AND   frps_seq_no =   C1_rec.frps_seq_no;
	        DELETE   giri_wfrps_ri
	         WHERE   frps_yy     =   C1_rec.frps_yy
	           AND   frps_seq_no =   C1_rec.frps_seq_no;
	        DELETE   giri_wdistfrps
	         WHERE   dist_no = pi_dist_no;  
	    END LOOP;
		            
	    FOR C2_rec IN C2 LOOP
	        p_message := 'This PAR has corresponding records in the posted tables for RI.'||
	          '  Could not proceed.';
			RETURN;
	    END LOOP;
	    DELETE_WORKING_DIST_TABLES(pi_dist_no);
	END IF;  
	
	--------------------------------------------------------
	FOR a IN (SELECT sum(tsi_amt     * currency_rt) tsi_amt,
					 sum(ann_tsi_amt * currency_rt) ann_tsi_amt,
					 sum(prem_amt    * currency_rt) prem_amt,
					 item_grp
						FROM gipi_witem
					   WHERE par_id = b_par_id
					GROUP BY item_grp)
	  LOOP	
	  	BEGIN
	  	  IF x_but = 1 THEN
					BEGIN
				    SELECT count(dist_no), max(dist_no)
						  INTO dist_cnt, dist_max
						  FROM giuw_pol_dist
						 WHERE par_id = b_par_id
						   AND NVL(item_grp,a.item_grp) = a.item_grp;
					END; 
					
					IF dist_cnt > 1 THEN
	        	v_tsi_amt     := a.tsi_amt;
	        	v_prem_amt    := a.prem_amt;
	        	v_ann_tsi_amt := a.ann_tsi_amt;
	        END IF;	
	         
	        IF pi_dist_no = dist_max THEN 
	        	UPDATE   giuw_pol_dist
	             SET   tsi_amt  	   = NVL(v_tsi_amt,0), 
						         prem_amt      = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
		                 ann_tsi_amt   = NVL(v_ann_tsi_amt,0),
	                   last_upd_date =  sysdate,
	                   user_id       =  user
	           WHERE   par_id  =  b_par_id
	             AND   dist_no =  pi_dist_no
	             AND   NVL(item_grp,a.item_grp) = a.item_grp;	       	      
	        
	        ELSE
	        	UPDATE   giuw_pol_dist
	             SET   tsi_amt  	   = NVL(v_tsi_amt,0)    , 
						         prem_amt      = NVL(v_prem_amt,0)    / dist_cnt,
				             ann_tsi_amt   = NVL(v_ann_tsi_amt,0),
	                   last_upd_date =  sysdate,
	                   user_id       =  user
	           WHERE   par_id  =  b_par_id
	             AND   dist_no =  pi_dist_no
	             AND   NVL(item_grp,a.item_grp) = a.item_grp;
	        END IF;	
	      END IF;
	    EXCEPTION
	      WHEN TOO_MANY_ROWS THEN
	        p_message := 'There are too many distribution numbers assigned for this item. '||
	                  'Please call your administrator to rectify the matter. Check '||
	                  'records in the policy table with par_id = '||to_char(b_par_id)||
	                  '.';
			RETURN;
	      
	      WHEN NO_DATA_FOUND THEN
	        NULL;     
	    END;    
		END LOOP;
	------------------------------------------------
	 	
	    DELETE FROM giuw_pol_dist a
				    WHERE par_id = b_par_id
				      AND dist_no = pi_dist_no
				      AND NOT EXISTS (SELECT 1 
						                    FROM gipi_witem b
										   				 WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
										     				 AND b.par_id = a.par_id);
END;
/


