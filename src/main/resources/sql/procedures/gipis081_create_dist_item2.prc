DROP PROCEDURE CPI.GIPIS081_CREATE_DIST_ITEM2;

CREATE OR REPLACE PROCEDURE CPI.GIPIS081_CREATE_DIST_ITEM2(
	   b_par_id  IN NUMBER) IS
  /*alert_id       ALERT;
  alert_but      NUMBER;
  alert_id2       ALERT;
  alert_but2      NUMBER;*/
  pi_dist_no 	  NUMBER;
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

	 BEGIN
	   SELECT dist_no
	     INTO pi_dist_no
              FROM giuw_pol_dist
             WHERE par_id = b_par_id;
	 EXCEPTION
	   WHEN NO_DATA_FOUND THEN NULL;
	 END;

  --MESSAGE('Processing distribution information...', NO_ACKNOWLEDGE);
      SELECT    sum(tsi_amt     * currency_rt),
                sum(ann_tsi_amt * currency_rt),
                sum(prem_amt    * currency_rt)
        INTO    v_tsi_amt,
                v_ann_tsi_amt,
                v_prem_amt
        FROM    gipi_witem
       WHERE    par_id = b_par_id;
       
       /*SELECT no_of_takeup, yearly_tag
         FROM giis_takeup_term
        WHERE takeup_term = p_takeup_term*/
        
       IF ((v_tsi_amt IS NULL) OR (v_ann_tsi_amt IS NULL)
	          OR (v_prem_amt IS NULL)) THEN
	          Delete_Ri_Tables_Gipis002(pi_dist_no);
		  	  DELETE_WORKING_DIST_TABLES(pi_dist_no);
	          DELETE_MAIN_DIST_TABLES(pi_dist_no);
	          DELETE giuw_distrel
	           WHERE dist_no_old = pi_dist_no;
	          DELETE   giuw_pol_dist
	           WHERE   dist_no  =  pi_dist_no;           
	           --HIDE_VIEW('WARNING');
	           --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');	           
	     END IF;
       
       BEGIN
        SELECT    distinct 1
          INTO    b_exist
          FROM    giuw_policyds
         WHERE    dist_no  =  pi_dist_no;
        IF  sql%FOUND THEN
            --HIDE_VIEW('WARNING');
            --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
            --SHOW_VIEW('CG$STACKED_HEADER_1');
	          --alert_id2   := FIND_ALERT('REC_EXISTS_IN_POST_POL_TAB');
       		  --alert_but2  := SHOW_ALERT(ALERT_ID2);
            --IF alert_but2 = ALERT_BUTTON1 THEN
               Delete_Ri_Tables_Gipis002(pi_dist_no);
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
            --ELSE
               --HIDE_VIEW('WARNING');
               --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
               --SHOW_VIEW('CG$STACKED_HEADER_1');
               --RAISE FORM_TRIGGER_FAILURE;
            --END IF;
         ELSE
            RAISE NO_DATA_FOUND;
         END IF;
       EXCEPTION
        WHEN NO_DATA_FOUND THEN
             NULL;
       END;
       BEGIN
         SELECT   distinct 1
           INTO   p_exist
           FROM   giuw_wpolicyds
          WHERE   dist_no  =  pi_dist_no;
          --alert_id   := FIND_ALERT('DISTRIBUTION');
          --alert_but  := SHOW_ALERT(ALERT_ID);
          --IF alert_but = ALERT_BUTTON1 THEN
             x_but := 1;
          --ELSE
             --x_but := 2;
          --END IF;
       EXCEPTION
         WHEN NO_DATA_FOUND THEN
              x_but := 1;
       END;
       --IF x_but = 2 THEN
          --HIDE_VIEW('WARNING');
          --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
         -- SHOW_VIEW('CG$STACKED_HEADER_1');
         -- RAISE FORM_TRIGGER_FAILURE;
      -- ELSE
          FOR C1_rec IN C1 LOOP
              Delete_Ri_Tables_Gipis002(pi_dist_no);
              DELETE   giri_wfrperil
               WHERE   frps_yy     =   C1_rec.frps_yy
                 AND   frps_seq_no =   C1_rec.frps_seq_no;
              DELETE   giri_wfrps_ri
               WHERE   frps_yy     =   C1_rec.frps_yy
                 AND   frps_seq_no =   C1_rec.frps_seq_no;
              DELETE   giri_wdistfrps
               WHERE   dist_no = pi_dist_no;  
          END LOOP;
          FOR C2_rec IN C2 LOOP NULL;
             -- MSG_ALERT('This PAR has corresponding records in the posted tables for RI.'||
                --'  Could not proceed.','E',TRUE);
          END LOOP;
          DELETE_WORKING_DIST_TABLES(pi_dist_no);
       --END IF;   
       FOR a IN (SELECT sum(tsi_amt     * currency_rt) tsi_amt,
				                sum(ann_tsi_amt * currency_rt) ann_tsi_amt,
				                sum(prem_amt    * currency_rt) prem_amt,
				                item_grp
					         FROM gipi_witem
					        WHERE par_id = b_par_id
					        GROUP BY item_grp)
			 LOOP	       
          BEGIN
            -- commented code because it is not needed anymore, since the EXCEPTION HANDLER IS already commented out.
          	-- see :RCODEGMI030308, and the commented out codes seen on the last part of this procedure..
          	-- re-insert of record in GIUW_POL_DIST is not processed here, instead, it is processed in GIPIS038(peril creation)
            /*SELECT   distinct 1
              INTO   p_dist_no
              FROM   giuw_pol_dist
             WHERE   par_id   =   b_par_id
               AND   NVL(item_grp,a.item_grp) =   a.item_grp;*/	            		        
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
		               SET   tsi_amt  	   = NVL(v_tsi_amt,0) , 
								         prem_amt      = NVL(v_prem_amt,0) - (ROUND((NVL(v_prem_amt,0)/dist_cnt),2) * (dist_cnt - 1)),
				                 ann_tsi_amt   = NVL(v_ann_tsi_amt,0) ,
		                     last_upd_date =  sysdate,
		                     user_id       =  user
		             WHERE   par_id  =  b_par_id
		               AND   dist_no =  pi_dist_no
		               AND   NVL(item_grp,a.item_grp) = a.item_grp;
              ELSE
              	/*message(pi_dist_no||'xxx'||NVL(v_tsi_amt,0)/dist_cnt);
              	message(pi_dist_no||'xxx'||NVL(v_tsi_amt,0)/dist_cnt);*/
              	UPDATE   giuw_pol_dist
		               SET   tsi_amt  	   = NVL(v_tsi_amt,0)     , 
								         prem_amt      = NVL(v_prem_amt,0)    / dist_cnt,
						             ann_tsi_amt   = NVL(v_ann_tsi_amt,0) ,
		                     last_upd_date =  sysdate,
		                     user_id       =  user
		             WHERE   par_id  =  b_par_id
		               AND   dist_no =  pi_dist_no
		               AND   NVL(item_grp,a.item_grp) = a.item_grp;
              END IF;	
	         END IF;
         EXCEPTION
           WHEN TOO_MANY_ROWS THEN
              /*  --HIDE_VIEW('WARNING');
                --SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
                --SHOW_VIEW('CG$STACKED_HEADER_1');
                -MSG_ALERT('There are too many distribution numbers assigned for this item. '||
                        'Please call your administrator to rectify the matter. Check '||
                        'records in the policy table with par_id = '||to_char(b_par_id)||
                        '.','E',TRUE);*/ NULL;
           WHEN NO_DATA_FOUND THEN
              -- :RCODEGMI030308 --
              NULL;
        END;
    END LOOP;
    
   -- MESSAGE('Deleting non-existent item group for distribution...', NO_ACKNOWLEDGE);
    DELETE FROM giuw_pol_dist a
			    WHERE par_id = b_par_id
			      AND dist_no = pi_dist_no
			      AND NOT EXISTS (SELECT 1 
					                    FROM gipi_witem b
									   				 WHERE b.item_grp = NVL(a.item_grp,b.item_grp)
									     				 AND b.par_id = a.par_id); 
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
        /* HIDE_VIEW('WARNING');
         SET_APPLICATION_PROPERTY(CURSOR_STYLE,'DEFAULT');
         SHOW_VIEW('CG$STACKED_HEADER_1');
       MSG_ALERT('Pls. be adviced that there are no items for this PAR.','E',TRUE);*/ NULL;
END;
/


