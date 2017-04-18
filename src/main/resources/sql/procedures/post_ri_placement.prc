DROP PROCEDURE CPI.POST_RI_PLACEMENT;

CREATE OR REPLACE PROCEDURE CPI.POST_RI_PLACEMENT 
(
   	 p_line_cd GIRI_DISTFRPS_WDISTFRPS_V.line_cd%TYPE,
	 p_subline_cd GIRI_DISTFRPS_WDISTFRPS_V.subline_cd%TYPE,
	 p_iss_cd GIRI_DISTFRPS_WDISTFRPS_V.iss_cd%TYPE,
	 p_issue_yy GIRI_DISTFRPS_WDISTFRPS_V.ISSUE_YY%TYPE,
	 p_pol_seq_no GIRI_DISTFRPS_WDISTFRPS_V.POL_SEQ_NO%TYPE,
	 p_renew_no GIRI_DISTFRPS_WDISTFRPS_V.RENEW_NO%TYPE,
	 p_frps_yy GIRI_DISTFRPS_WDISTFRPS_V.frps_yy%TYPE,
	 p_frps_seq_no GIRI_DISTFRPS_WDISTFRPS_V.frps_seq_no%TYPE,
	 p_dist_no	 GIRI_DISTFRPS_WDISTFRPS_V.dist_no%TYPE,
	 p_dist_seq_no GIRI_DISTFRPS_WDISTFRPS_V.dist_seq_no%TYPE,
	 p_par_policy_id GIRI_DISTFRPS_WDISTFRPS_V.PAR_POLICY_ID%TYPE,
	 p_param OUT  VARCHAR2,
	 p_message OUT VARCHAR2
)
IS
  V_COUNT NUMBER;
  V_COUNT2 NUMBER;
  v_posted VARCHAR2(1):='N';
BEGIN 

  FOR A IN (SELECT 1
	            FROM giuw_pol_dist
 	           WHERE dist_no = p_dist_no)
 	LOOP            
 	  v_posted := 'Y';
  END LOOP;	  
  
  IF v_posted = 'N' THEN
  	 p_message := 'Please post the policy first before printing the binders.';
	 RETURN;
  END IF;	 
  
  --var3.dist_no := p_dist_no;
  --:gauge.comment  := 'Pls wait...';
  --:gauge.file     := 'POSTING is now in progress';
  --:gauge.recno    := 0;
  --:gauge.reccount := 150;
  --SET_ITEM_PROPERTY('GAUGE.CUSTOM_GAUGE',WIDTH,0);
  --:gauge.file := 'Creating records in giri_distfrps.';
  --vbx_counter;
  giri_frps_ri_pkg.delete_mrecords_giris026(p_line_cd, p_frps_yy, p_frps_seq_no);          
  GIRI_DISTFRPS_PKG.create_giri_distfrps_giris026(p_line_cd, p_frps_yy, p_frps_seq_no);
  --:gauge.file := 'Creating records in giri_frps_ri.';
  --vbx_counter;  
  GIRI_FRPS_PERIL_GRP_PKG.create_frps_peril_grp_giris026(p_line_cd, p_frps_yy, p_frps_seq_no);  
  giri_frps_ri_pkg.create_giri_frps_ri_binder(p_line_cd, p_frps_yy, p_frps_seq_no, p_dist_no, p_iss_cd, p_par_policy_id);  
  --:gauge.file := 'Creating records in giri_frperil.';
  --vbx_counter;  
  giri_frperil_pkg.create_giri_frperil_giris026(p_line_cd, p_frps_yy, p_frps_seq_no);  
  --:gauge.file := 'Creating records in giri_binder_peril.';
  --vbx_counter;
  giri_binder_peril_pkg.create_binder_peril_giris026(p_line_cd, p_frps_yy, p_frps_seq_no);
  giis_fbndr_seq_pkg.update_fbndr_seq_giris026(p_line_cd, p_frps_yy, p_frps_seq_no);
  giri_wfrps_ri_pkg.delete_records_giris026(p_line_cd, p_frps_yy, p_frps_seq_no, p_dist_no, p_dist_seq_no);
  
  --added by A.R.C. 08.16.2004 to delete workflow record of facultative placement.
 	FOR A IN (SELECT policy_id, par_id
	            FROM giuw_pol_dist
 	           WHERE dist_no = p_dist_no)
 	LOOP          
 		--A.R.C. 09.25.2006
 		--added to delete the facultative placement of GIUWS003 and GIUWS004  
 	  DELETE_WORKFLOW_REC(NULL,'GIUWS003',USER,a.par_id);
 	  DELETE_WORKFLOW_REC(NULL,'GIUWS004',USER,a.par_id);
 	  DELETE_WORKFLOW_REC(NULL,'GIUWS012',USER,a.policy_id);
		/* A.R.C. 06.28.2005
    ** to delete workflow records of Undistributed policies awaiting claims */
    FOR c1 IN (SELECT claim_id
                 FROM gicl_claims b, gipi_polbasic c
                WHERE 1=1
                  AND b.line_cd = c.line_cd
                  AND b.subline_cd = c.subline_cd 
                  AND b.iss_cd = c.iss_cd
                  AND b.issue_yy = c.issue_yy
                  AND b.pol_seq_no = c.pol_seq_no
                  AND b.renew_no = c.renew_no
                  AND c.policy_id = a.policy_id)
    LOOP    
      delete_workflow_rec('UNDISTRIBUTED POLICIES AWAITING CLAIMS','GICLS010',USER,c1.claim_id);  
    END LOOP;  		    	  
 	END LOOP;  
    
  GIRI_DISTFRPS_PKG.update_flag_giris026(p_line_cd, p_frps_yy, p_frps_seq_no, p_dist_no, p_dist_seq_no, p_param);
  --COMMIT;    
  --CLEAR_MESSAGE;
  --:gauge.comment := NULL;
  --:gauge.file := 'Posting complete.';
  
/*PAU 05FEB08
**UPDATE EXISTING CLAIMS WITH DISTRUBUTED RESERVE FOR THIS POLICY
*/

DECLARE																								
    V_REVERSE_DATE DATE;
BEGIN
	SELECT REVERSE_DATE
	  INTO V_REVERSE_DATE
	  FROM GIRI_BINDER
	 WHERE FNL_BINDER_ID IN (SELECT FNL_BINDER_ID
	  	   				 	   FROM GIRI_FRPS_RI
							  WHERE (FRPS_SEQ_NO, FRPS_YY, LINE_CD) IN (SELECT FRPS_SEQ_NO, FRPS_YY, LINE_CD
							  					  		   			      FROM GIRI_DISTFRPS
																		 WHERE (DIST_NO, DIST_SEQ_NO) IN (SELECT DIST_NO, DIST_SEQ_NO
																		 	   			 			  	    FROM GIUW_ITEMPERILDS
																										   WHERE DIST_NO = 61310 
																											 AND DIST_SEQ_NO =1)));
    IF V_REVERSE_DATE IS NOT NULL THEN 
		UPDATE GICL_CLM_RESERVE
		   SET REDIST_SW = 'Y'
		 WHERE (CLAIM_ID, ITEM_NO, PERIL_CD) IN (SELECT CLAIM_ID, ITEM_NO, PERIL_CD
		  	   			   	  	   			 	   FROM GICL_CLM_RES_HIST
												  WHERE CLAIM_ID IN (SELECT CLAIM_ID
												  	   			   	   FROM GICL_CLAIMS
																	  WHERE LINE_CD = p_line_cd
		    															AND SUBLINE_CD = p_subline_cd
		    															AND POL_ISS_CD = p_iss_cd
		    															AND ISSUE_YY = p_issue_yy
		    															AND POL_SEQ_NO = p_pol_seq_no
		    															AND RENEW_NO = p_renew_no)
													AND DIST_SW = 'Y')
		   AND (ITEM_NO, PERIL_CD) IN (SELECT ITEM_NO, PERIL_CD
		   	   			 		   	  	 FROM GIUW_ITEMPERILDS
										WHERE DIST_NO = p_dist_no
								  		  AND DIST_SEQ_NO = p_dist_seq_no);
    ELSE
		UPDATE GICL_CLM_RESERVE
		   SET REDIST_SW = ''
		 WHERE (CLAIM_ID, ITEM_NO, PERIL_CD) IN (SELECT CLAIM_ID, ITEM_NO, PERIL_CD
		  	   			   	  	   			 	   FROM GICL_CLM_RES_HIST
												  WHERE CLAIM_ID IN (SELECT CLAIM_ID
												  	   			   	   FROM GICL_CLAIMS
																	  WHERE LINE_CD = p_line_cd
		    															AND SUBLINE_CD = p_subline_cd
		    															AND POL_ISS_CD = p_iss_cd
		    															AND ISSUE_YY = p_issue_yy
		    															AND POL_SEQ_NO = p_pol_seq_no
		    															AND RENEW_NO = p_renew_no)
													AND DIST_SW = 'Y')
		   AND (ITEM_NO, PERIL_CD) IN (SELECT ITEM_NO, PERIL_CD
		   	   			 		   	  	 FROM GIUW_ITEMPERILDS
										WHERE DIST_NO = p_dist_no
								  		  AND DIST_SEQ_NO = p_dist_seq_no);	
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
		 NULL;
END;
/*PAU 05FEB08 END*/  
  --IF var3.param = 'Y' AND var3.policy IS NOT NULL THEN
  	-- null;
  	 --call_report;
  --END IF;	 
 -- show_window('binder');
  --go_block('D050');         
  --EXECUTE_QUERY;
END;
/


