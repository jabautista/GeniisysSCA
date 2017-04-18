DROP PROCEDURE CPI.POST_DIST_GIUWS013;

CREATE OR REPLACE PROCEDURE CPI.post_dist_giuws013 (
   p_policy_id           giuw_pol_dist.policy_id%TYPE,
   p_dist_no             giuw_pol_dist.dist_no%TYPE,
   p_endt_seq_no         gipi_polbasic_pol_dist_v1.endt_seq_no%TYPE,
   p_eff_date            gipi_polbasic_pol_dist_v1.eff_date%TYPE,
   p_batch_id		OUT	 giuw_pol_dist.batch_id%TYPE,
   p_line_cd			 gipi_polbasic_pol_dist_v1.line_cd%TYPE,
   p_subline_cd			 gipi_polbasic_pol_dist_v1.subline_cd%TYPE,
   p_iss_cd			     gipi_polbasic_pol_dist_v1.iss_cd%TYPE,
   p_issue_yy			 gipi_polbasic_pol_dist_v1.issue_yy%TYPE,
   p_pol_seq_no			 gipi_polbasic_pol_dist_v1.pol_seq_no%TYPE,
   p_renew_no			 gipi_polbasic_pol_dist_v1.renew_no%TYPE,
   p_dist_seq_no	 		 GIUW_WPOLICYDS.dist_seq_no%TYPE,
   p_facul_sw			 VARCHAR2,
   p_workflow_msgr OUT	 VARCHAR2,
   p_message       OUT   VARCHAR2
)
IS
  v_eff_date			GIUW_POL_DIST.eff_date%TYPE;		
  v_expiry_date		GIUW_POL_DIST.expiry_date%TYPE;	
BEGIN
   delete_dist_master_tables (p_dist_no);
   giuw_policyds_pkg.post_wpolicyds_dtl (p_dist_no,
                                         p_endt_seq_no,
                                         p_eff_date,
                                         p_message
                                        );
   GIUW_WITEMDS_PKG.post_witemds_dtl(p_dist_no);	
   
   giuw_itemperilds_dtl_pkg.post_witemperilds_dtl(p_dist_no);
   
   GIUW_WPERILDS_DTL_PKG.post_wperilds_dtl(p_dist_no);		
   
   /* Remove the current distribution from the batch
  ** to which it originally belongs to. */
  /* Added RBD - 09/27/99 - Update on GIUW_POL_DIST */
  FOR c1 IN (SELECT dist_flag, batch_id
               FROM giuw_pol_dist
              WHERE policy_id  = p_policy_id
                AND dist_no    = p_dist_no)
  LOOP
    p_batch_id  := c1.batch_id;
    EXIT;
  END LOOP;
  
  IF p_batch_id IS NOT NULL THEN
     FOR c1 IN (SELECT ROWID, batch_qty
                  FROM giuw_dist_batch
                 WHERE batch_id = p_batch_id)
     LOOP
       IF c1.batch_qty > 1 THEN
          UPDATE giuw_dist_batch
             SET batch_qty = c1.batch_qty - 1
           WHERE rowid     = c1.ROWID;
       ELSE
       	  UPDATE GIUW_POL_DIST
       	     SET batch_id = NULL
       	   WHERE batch_id = p_batch_id;
       	   
          DELETE giuw_dist_batch_dtl
           WHERE batch_id = p_batch_id;
          DELETE giuw_dist_batch
           WHERE ROWID = c1.ROWID;
       END IF;
       p_batch_id := NULL;
       EXIT;
     END LOOP;
  END IF;		
  
  delete_workflow_rec('Final Distribution','GIPIS055',USER,p_policy_id);	
  
  
  /* If a facultative share does not exist in any of
  ** the distribution records, records in the working
  ** tables will be deleted. */ 
  /* Edited by RBD 09/27/99 */
  /* Updated by RBD 10/04/99 - on USER AND LAST UPDATE */
  IF p_facul_sw = 'N' THEN
     -- SET_ITEM_PROPERTY('c1306.but_post_dist', ENABLED, PROPERTY_FALSE);
     UPDATE gipi_polbasic
        SET dist_flag  		= 3,
            user_id    		= NVL (giis_users_pkg.app_user, USER),
            last_upd_date = SYSDATE
      WHERE policy_id = p_policy_id;

     UPDATE giuw_pol_dist
        SET dist_flag 		= 3,
            post_flag 		= 'O',
            batch_id  		= NULL,
            post_date     = SYSDATE,
	          user_id   		= NVL (giis_users_pkg.app_user, USER),
         		last_upd_date = SYSDATE
      WHERE policy_id = p_policy_id
        AND dist_no   = p_dist_no;

		/* A.R.C. 02.02.2006
    ** to create workflow records of Policy/Endt.  Redistribution */        
 	  FOR a1 IN (SELECT DISTINCT claim_id
 	               FROM gicl_claims b,
 	                    gipi_polbasic a
 	              WHERE b.line_cd = a.line_cd
 	                AND b.subline_cd = a.subline_cd
 	                AND b.iss_cd = a.iss_cd 	                
 	                AND b.issue_yy = a.issue_yy 
 	                AND b.pol_seq_no = a.pol_seq_no
 	                AND b.renew_no = a.renew_no
 	                AND b.clm_stat_cd NOT IN ('CC','WD','DN')
 	                AND a.policy_id = p_policy_id)
 	  LOOP    
	     FOR c1 IN (SELECT b.userid, d.event_desc  
		                FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
		               WHERE 1=1
	                   AND c.event_cd = a.event_cd
	                   AND c.event_mod_cd = a.event_mod_cd
	                   AND b.event_mod_cd = a.event_mod_cd
	                   AND b.passing_userid = NVL (giis_users_pkg.app_user, USER)
	                   AND a.module_id = 'GIUWS012'
	                   AND a.event_cd = d.event_cd
	                   AND UPPER(d.event_desc) = 'POLICY/ENDT.  REDISTRIBUTION')
	     LOOP
	       CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, a1.claim_id, c1.event_desc||' '||get_clm_no(a1.claim_id), p_message, p_workflow_msgr, NVL (giis_users_pkg.app_user, USER));
	     END LOOP; 
 	  END LOOP;
 	  
     /* 11052000 BETH 
     **    posted policy distribution with eim_flag = '2' should be
     **    updated with eim_flag ='6' and undist_sw = 'Y' in eim_takeup_info
     **    table.
     */
     FOR A IN (SELECT '1'
                 FROM eim_takeup_info
                WHERE policy_id = p_policy_id
                  AND eim_flag = '2')
     LOOP
     	 UPDATE eim_takeup_info 
     	    SET eim_flag  = '6',
     	        undist_sw = 'Y'
        WHERE policy_id = p_policy_id;
       EXIT;
     END LOOP;
     
		/* mark jm 10.12.2009 UW-SPECS-2009-00067 starts here */
		/* for updating GICL_CLM_RESERVE.REDIST_SW */
		BEGIN		   
			SELECT eff_date, expiry_date
				INTO v_eff_date, v_expiry_date
				FROM giuw_pol_dist
			 WHERE policy_id = p_policy_id
				 AND dist_no = p_dist_no;
		END;
	
		FOR a IN (SELECT claim_id, loss_date		  
								FROM gicl_claims
							 WHERE line_cd = p_line_cd
								 AND subline_cd = p_subline_cd
								 AND pol_iss_cd = p_iss_cd
								 AND issue_yy = p_issue_yy
								 AND pol_seq_no = p_pol_seq_no
								 AND renew_no = p_renew_no) LOOP		
			FOR b IN (SELECT item_no, peril_cd  
									FROM giuw_witemperilds
								 WHERE dist_no = p_dist_no
									 AND dist_seq_no = p_dist_seq_no) LOOP			
				FOR c IN (SELECT 1
										FROM gicl_clm_reserve
									 WHERE claim_id = a.claim_id
										 AND item_no = b.item_no
										 AND peril_cd = b.peril_cd) LOOP									
					IF p_facul_sw = 'N' AND (a.loss_date BETWEEN v_eff_date AND v_expiry_date) THEN					
						UPDATE gicl_clm_reserve
							 SET redist_sw = 'Y'
						 WHERE claim_id = a.claim_id
							 AND item_no = b.item_no
							 AND peril_cd = b.peril_cd;				
					END IF;				
			END LOOP;			
		END LOOP;			
	END LOOP;
	/* mark jm 10.12.09 UW-SPECS-2009-00067 ends here */
 	  
     /* Delete all data related to the current
     ** DIST_NO from the distribution and RI
     ** working tables. */
     DELETE_DIST_WORKING_TABLES(p_dist_no);
	   /* A.R.C. 06.27.2005
     ** to delete workflow records of Undistributed policies awaiting claims */
     FOR c1 IN (SELECT claim_id
	                FROM gicl_claims
	               WHERE 1=1
	                 AND line_cd = p_line_cd
                   AND subline_cd = p_subline_cd 
                   AND iss_cd = p_iss_cd
                   AND issue_yy = p_issue_yy
                   AND pol_seq_no = p_pol_seq_no
                   AND renew_no = p_renew_no)
     LOOP    
       delete_workflow_rec('Undistributed policies awaiting claims','GICLS010',NVL (giis_users_pkg.app_user, USER),c1.claim_id);  
     END LOOP;
    --A.R.C. 02.07.2007
 		--added to delete the workflow facultative placement of GIUWS012 if not facul
 	  DELETE_WORKFLOW_REC('Facultative Placement','GIUWS012',NVL (giis_users_pkg.app_user, USER),p_policy_id);
 	  
  ELSIF p_facul_sw    = 'Y' THEN
     UPDATE gipi_polbasic
        SET dist_flag 		= 2,
            user_id   		= NVL (giis_users_pkg.app_user, USER),
            last_upd_date = SYSDATE
      WHERE policy_id = p_policy_id;
  
     UPDATE giuw_pol_dist
        SET dist_flag 		= 2,
            post_flag 		= 'O',
            batch_id  		= NULL,
            user_id   		= NVL (giis_users_pkg.app_user, USER),
            last_upd_date = SYSDATE
      WHERE policy_id = p_policy_id
        AND dist_no   = p_dist_no;
        
		/* A.R.C. 08.16.2004
    ** to create workflow records of Facultative Placement */        
     FOR c1 IN (SELECT b.userid, d.event_desc  
	                FROM giis_events_column c, giis_event_mod_users b, giis_event_modules a, giis_events d
	               WHERE 1=1
                   AND c.event_cd = a.event_cd
                   AND c.event_mod_cd = a.event_mod_cd
                   AND b.event_mod_cd = a.event_mod_cd
                   --AND b.userid <> USER  --A.R.C. 01.26.2006
                   AND b.passing_userid = NVL (giis_users_pkg.app_user, USER)  --A.R.C. 01.26.2006
                   AND a.module_id = 'GIUWS012'
                   AND a.event_cd = d.event_cd
                   AND UPPER(d.event_desc) = 'FACULTATIVE PLACEMENT')
     LOOP
       CREATE_TRANSFER_WORKFLOW_REC(c1.event_desc,'GIUWS012', c1.userid, p_policy_id, c1.event_desc||' '||get_policy_no(p_policy_id), p_message, p_workflow_msgr, NVL (giis_users_pkg.app_user, USER));
     END LOOP;    
     
  END IF;
  				
END;
/


