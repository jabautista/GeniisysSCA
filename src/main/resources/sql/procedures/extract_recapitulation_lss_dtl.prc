DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_LSS_DTL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation_Lss_Dtl(p_from_date DATE, p_to_date DATE)
  AS
   v_region_cd					 GIXX_RECAPITULATION_LOSSES_DTL.region_cd%TYPE;
   v_ind_grp_cd 				 GIXX_RECAPITULATION_LOSSES_DTL.ind_grp_cd%TYPE;
   v_line_cd					 GIXX_RECAPITULATION_LOSSES_DTL.line_cd%TYPE;
   v_policy_id 	   			     GIXX_RECAPITULATION_LOSSES_DTL.policy_id%TYPE;
   v_claim_id  				     GIXX_RECAPITULATION_LOSSES_DTL.claim_id%TYPE;
   v_loss_amt 				     GIXX_RECAPITULATION_LOSSES_DTL.loss_amt%TYPE;
   v_exist                       VARCHAR2(1) := 'N';
   v_param     					 GIIS_PARAMETERS.param_value_v%TYPE;
   v_assd_no  					 GIIS_ASSURED.assd_no%TYPE;

BEGIN
  DELETE FROM GIXX_RECAPITULATION_LOSSES_DTL;
  COMMIT;
  FOR param IN (SELECT param_value_v
                  FROM GIIS_PARAMETERS
				 WHERE param_name = 'RECAP_LOSS_VALUE')
  LOOP
      v_param := param.param_value_v;
	  EXIT;
  END LOOP;
  FOR a IN (SELECT assd_no,
  	  	   		   region_cd,
  	  	   		   ind_grp_cd,
				   line_cd,
                   SUM(gross_losses_a) gross_losses_a,
				   SUM(gross_losses_b) gross_losses_b,
				   policy_id, claim_id
            FROM(SELECT a.assd_no,
  	  	   		   f.region_cd,
  	  	   		   g.ind_grp_cd,
				   a.line_cd,
                   SUM(NVL(e.losses_paid,0)  + NVL(e.expenses_paid,0)) gross_losses_a,
				   SUM(NVL(e.losses_paid,0)) gross_losses_b,
				   a.policy_id, a.claim_id
              FROM (SELECT DISTINCT x.policy_id, y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM GIPI_POLBASIC x,
					       GICL_CLAIMS y,
                           GIIS_SUBLINE z -- Added by Wilmar 04.07.2015
				     WHERE x.line_cd    = y.line_cd
                       AND x.line_cd    = z.line_cd -- Added by Wilmar 04.07.2015
					   AND x.subline_cd = y.subline_cd
                       AND x.subline_cd = z.subline_cd  -- Added by Wilmar 04.07.2015
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   --AND x.assd_no    = y.assd_no  --benjo 03.22.2016 SR-21978
                       AND ((z.micro_sw <> 'Y') OR (z.micro_sw IS NULL)) -- Added by Wilmar 04.07.2015
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                       /* jhing 02.22.2013 added  security rights control */
                       AND x.cred_branch != Giisp.v('ISS_CD_RI')
                       AND ( check_user_per_iss_cd(x.line_cd, x.iss_cd, 'GIPIS203') = 1
                            or check_user_per_iss_cd(x.line_cd, x.cred_branch, 'GIPIS203') = 1 )
                       /* jhing 02.22.2013 end added code */
                       ) a,
			       GIIS_REGION         f,
				   GIIS_INDUSTRY_GROUP g,
				   GIAC_ACCTRANS       d,
				   GICL_CLM_RES_HIST   e
		     WHERE    --exists on specified region
			   EXISTS (SELECT '1'
               		     FROM GIPI_ITEM  itm,
             			      GIPI_POLBASIC pol
           	            WHERE itm.policy_id  = pol.policy_id
    	                  AND itm.region_cd  = f.region_cd
               			  AND pol.line_cd    = a.line_cd
 		                  AND pol.subline_cd = a.subline_cd
   			              AND pol.iss_cd     = a.iss_cd
   			              AND pol.issue_yy   = a.issue_yy
   			              AND pol.pol_seq_no = a.pol_seq_no
   			              AND pol.renew_no   = a.renew_no
  						  --AND pol.endt_seq_no = 0  --benjo 03.22.2016 SR-21978
						  AND itm.item_no = e.item_no)
			   --exists on specified ind_grp_cd
   			   AND EXISTS (SELECT '1'
	           	   		  	 FROM GIIS_ASSURED         assd,
	              			 	  GIIS_INDUSTRY        ind
							WHERE assd.assd_no    = a.assd_no
							  AND ind.industry_cd = assd.industry_cd
							  AND ind.ind_grp_cd  = g.ind_grp_cd)
 			   AND a.claim_id   = e.claim_id
			   AND e.tran_id    = d.tran_id
			   AND e.tran_id IS NOT NULL
			  -- AND decode(e.cancel_tag,'Y',to_char(e.cancel_date,'YYYY'), p_year + 1)
               --       	  	  > p_year
--			   AND TO_CHAR(d.posting_date, 'YYYY') = p_year
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
			   AND d.tran_flag <> 'D'
             GROUP BY a.assd_no, f.region_cd, g.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id
      UNION
            SELECT a.assd_no,
				   f.region_cd,
                   g.ind_grp_cd,
				   a.line_cd,
                   SUM(NVL(e.losses_paid*-1,0)  + NVL(e.expenses_paid*-1,0)) gross_losses_a,
  				   SUM(NVL(e.losses_paid*-1,0)) gross_losses_b,
				   a.policy_id, a.claim_id
              FROM (SELECT DISTINCT x.policy_id, y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM GIPI_POLBASIC x,
					       GICL_CLAIMS y,
                           GIIS_SUBLINE z -- Added by Wilmar 04.07.2014
				     WHERE x.line_cd    = y.line_cd
                       AND x.line_cd    = z.line_cd -- Added by Wilmar 04.07.2015
					   AND x.subline_cd = y.subline_cd
                       AND x.subline_cd = z.subline_cd  -- Added by Wilmar 04.07.2015
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   --AND x.assd_no    = y.assd_no  --benjo 03.22.2016 SR-21978
                       AND ((z.micro_sw <> 'Y') OR (z.micro_sw IS NULL)) -- Added by Wilmar 04.07.2015
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                        /* jhing 02.22.2013 added  security rights control */
                       AND x.cred_branch != Giisp.v('ISS_CD_RI')
                       AND ( check_user_per_iss_cd(x.line_cd, x.iss_cd, 'GIPIS203') = 1
                            or check_user_per_iss_cd(x.line_cd, x.cred_branch, 'GIPIS203') = 1 )
                       /* jhing 02.22.2013 end added code */) a,
                   GIIS_REGION		   f,
				   GIIS_INDUSTRY_GROUP g,
                   GIAC_ACCTRANS       d,
                   GICL_CLM_RES_HIST   e,
                   GIAC_REVERSALS	   h
             WHERE 1=1
               --exists on specified region
               AND EXISTS (SELECT '1'
                		     FROM GIPI_ITEM  itm,
  							      GIPI_POLBASIC pol
               	            WHERE itm.policy_id  = pol.policy_id
      	                      AND itm.region_cd  = f.region_cd
               			      AND pol.line_cd    = a.line_cd
 		                      AND pol.subline_cd = a.subline_cd
   			                  AND pol.iss_cd     = a.iss_cd
   			                  AND pol.issue_yy   = a.issue_yy
   			                  AND pol.pol_seq_no = a.pol_seq_no
   			                  AND pol.renew_no   = a.renew_no
	  						  --AND pol.endt_seq_no = 0  --benjo 03.22.2016 SR-21978
							  AND itm.item_no = e.item_no)
               --exists on specified ind_grp_cd
               AND EXISTS (SELECT '1'
                             FROM GIIS_ASSURED         assd,
	                              GIIS_INDUSTRY        ind
                            WHERE assd.assd_no    = a.assd_no
							  AND ind.industry_cd = assd.industry_cd
		                      AND ind.ind_grp_cd  = g.ind_grp_cd)
               AND a.claim_id   = e.claim_id
               AND e.tran_id    = h.gacc_tran_id
               AND d.tran_id    = h.reversing_tran_id
               AND e.tran_id IS NOT NULL
--               AND TO_CHAR(d.posting_date, 'YYYY') = p_year
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
             GROUP BY a.assd_no, f.region_cd, g.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id)
             GROUP BY assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id)
   LOOP
	 v_exist := 'N';
     FOR b IN (SELECT 1
	             FROM GIXX_RECAPITULATION_LOSSES_DTL
	  		    WHERE assd_no    = a.assd_no
				  AND region_cd  = a.region_cd
				  AND ind_grp_cd = a.ind_grp_cd
				  AND policy_id = a.policy_id
				  AND claim_id = a.claim_id)
	 LOOP
	   v_exist := 'Y';
	   IF v_param = 'LOSS_EXPENSE' THEN
	      UPDATE GIXX_RECAPITULATION_LOSSES_DTL
		     SET loss_amt = a.gross_losses_a
   		   WHERE assd_no    = a.assd_no
		     AND region_cd  = a.region_cd
  		     AND ind_grp_cd = a.ind_grp_cd
			 AND policy_id = a.policy_id
			 AND claim_id = a.claim_id;
	   ELSE
	     UPDATE GIXX_RECAPITULATION_LOSSES_DTL
		     SET loss_amt = a.gross_losses_b
   		   WHERE assd_no    = a.assd_no
		     AND region_cd  = a.region_cd
  		     AND ind_grp_cd = a.ind_grp_cd
			 AND policy_id = a.policy_id
			 AND claim_id = a.claim_id;
	   END IF;
	   EXIT;
	 END LOOP;
	 IF v_exist = 'N' THEN
 	    IF v_param = 'LOSS_EXPENSE' THEN
    	   INSERT INTO GIXX_RECAPITULATION_LOSSES_DTL
   		      (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id, loss_amt)
            VALUES (a.assd_no, a.region_cd, a.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id,a.gross_losses_a);
	    ELSE
		   INSERT INTO GIXX_RECAPITULATION_LOSSES_DTL
   		               (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id, loss_amt)
			    VALUES (a.assd_no, a.region_cd, a.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id,a.gross_losses_b);
		END IF;
	 END IF;
   END LOOP;
   COMMIT;
   
   /*Start of Micro Insurance*/
   FOR a IN (SELECT a.assd_no,
  	  	   		   f.region_cd,
  	  	   		   --g.ind_grp_cd,
				   a.line_cd,
                   SUM(NVL(e.losses_paid,0)  + NVL(e.expenses_paid,0)) gross_losses_a,
				   SUM(NVL(e.losses_paid,0)) gross_losses_b,
				   a.policy_id, a.claim_id
              FROM (SELECT DISTINCT x.policy_id, y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM GIPI_POLBASIC x,
                           GIIS_SUBLINE z,
					       GICL_CLAIMS y
				     WHERE x.line_cd    = y.line_cd
					   AND x.subline_cd = y.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   --AND x.assd_no    = y.assd_no  --benjo 03.22.2016 SR-21978
                       AND x.line_cd    = z.line_cd
                       AND x.subline_cd = z.subline_cd
                       AND z.micro_sw   = 'Y'
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                       AND x.cred_branch != Giisp.v('ISS_CD_RI')
                       AND ( check_user_per_iss_cd(x.line_cd, x.iss_cd, 'GIPIS203') = 1
                            or check_user_per_iss_cd(x.line_cd, x.cred_branch, 'GIPIS203') = 1 )
                       ) a,
			       GIIS_REGION         f,
				   GIIS_INDUSTRY_GROUP g,
				   GIAC_ACCTRANS       d,
				   GICL_CLM_RES_HIST   e
		     WHERE    --exists on specified region
			   EXISTS (SELECT '1'
               		     FROM GIPI_ITEM  itm,
             			      GIPI_POLBASIC pol
           	            WHERE itm.policy_id  = pol.policy_id
    	                  AND itm.region_cd  = f.region_cd
               			  AND pol.line_cd    = a.line_cd
 		                  AND pol.subline_cd = a.subline_cd
   			              AND pol.iss_cd     = a.iss_cd
   			              AND pol.issue_yy   = a.issue_yy
   			              AND pol.pol_seq_no = a.pol_seq_no
   			              AND pol.renew_no   = a.renew_no
  						  --AND pol.endt_seq_no = 0  --benjo 03.22.2016 SR-21978
						  AND itm.item_no = e.item_no)
			   --exists on specified ind_grp_cd
   			   AND EXISTS (SELECT '1'
	           	   		  	 FROM GIIS_ASSURED         assd,
	              			 	  GIIS_INDUSTRY        ind
							WHERE assd.assd_no    = a.assd_no
							  AND ind.industry_cd = assd.industry_cd
							  AND ind.ind_grp_cd  = g.ind_grp_cd)
 			   AND a.claim_id   = e.claim_id
			   AND e.tran_id    = d.tran_id
			   AND e.tran_id IS NOT NULL
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
			   AND d.tran_flag <> 'D'
             GROUP BY a.assd_no, f.region_cd, 
             --g.ind_grp_cd, 
             a.line_cd, a.policy_id, a.claim_id
      UNION
            SELECT a.assd_no,
				   f.region_cd,
                   --g.ind_grp_cd,
				   a.line_cd,
                   SUM(NVL(e.losses_paid*-1,0)  + NVL(e.expenses_paid*-1,0)) gross_losses_a,
  				   SUM(NVL(e.losses_paid*-1,0)) gross_losses_b,
				   a.policy_id, a.claim_id
              FROM (SELECT DISTINCT x.policy_id, y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM GIPI_POLBASIC x,
                           GIIS_SUBLINE  z,
					       GICL_CLAIMS y
				     WHERE x.line_cd    = y.line_cd
					   AND x.subline_cd = y.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   --AND x.assd_no    = y.assd_no  --benjo 03.22.2016 SR-21978
                       AND x.line_cd    = z.line_cd
                       AND x.subline_cd = z.subline_cd
                       AND z.micro_sw   = 'Y'                       
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                       AND x.cred_branch != Giisp.v('ISS_CD_RI')
                       AND ( check_user_per_iss_cd(x.line_cd, x.iss_cd, 'GIPIS203') = 1
                            or check_user_per_iss_cd(x.line_cd, x.cred_branch, 'GIPIS203') = 1 )
                            ) a,
                   GIIS_REGION		   f,
				   GIIS_INDUSTRY_GROUP g,
                   GIAC_ACCTRANS       d,
                   GICL_CLM_RES_HIST   e,
                   GIAC_REVERSALS	   h
             WHERE 1=1
               --exists on specified region
               AND EXISTS (SELECT '1'
                		     FROM GIPI_ITEM  itm,
  							      GIPI_POLBASIC pol
               	            WHERE itm.policy_id  = pol.policy_id
      	                      AND itm.region_cd  = f.region_cd
               			      AND pol.line_cd    = a.line_cd
 		                      AND pol.subline_cd = a.subline_cd
   			                  AND pol.iss_cd     = a.iss_cd
   			                  AND pol.issue_yy   = a.issue_yy
   			                  AND pol.pol_seq_no = a.pol_seq_no
   			                  AND pol.renew_no   = a.renew_no
	  						  --AND pol.endt_seq_no = 0  --benjo 03.22.2016 SR-21978
							  AND itm.item_no = e.item_no)
               --exists on specified ind_grp_cd
               AND EXISTS (SELECT '1'
                             FROM GIIS_ASSURED         assd,
	                              GIIS_INDUSTRY        ind
                            WHERE assd.assd_no    = a.assd_no
							  AND ind.industry_cd = assd.industry_cd
		                      AND ind.ind_grp_cd  = g.ind_grp_cd)
               AND a.claim_id   = e.claim_id
               AND e.tran_id    = h.gacc_tran_id
               AND d.tran_id    = h.reversing_tran_id
               AND e.tran_id IS NOT NULL
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
             GROUP BY a.assd_no, f.region_cd, 
             --g.ind_grp_cd, 
             a.line_cd, a.policy_id, a.claim_id)
   LOOP
	 v_exist := 'N';
     FOR b IN (SELECT 1
	             FROM GIXX_RECAPITULATION_LOSSES_DTL
	  		    WHERE assd_no    = a.assd_no
				  AND region_cd  = a.region_cd
				  AND ind_grp_cd = 0
				  AND policy_id = a.policy_id
				  AND claim_id = a.claim_id)
	 LOOP
	   v_exist := 'Y';
	   IF v_param = 'LOSS_EXPENSE' THEN
	      UPDATE GIXX_RECAPITULATION_LOSSES_DTL
		     SET loss_amt = a.gross_losses_a
   		   WHERE assd_no    = a.assd_no
		     AND region_cd  = a.region_cd
  		     AND ind_grp_cd = 0
			AND policy_id = a.policy_id
			 AND claim_id = a.claim_id;
	   ELSE
	     UPDATE GIXX_RECAPITULATION_LOSSES_DTL
		     SET loss_amt = a.gross_losses_b
   		   WHERE assd_no    = a.assd_no
		     AND region_cd  = a.region_cd
  		     AND ind_grp_cd = 0
			 AND policy_id = a.policy_id
			 AND claim_id = a.claim_id;
	   END IF;
	   EXIT;
	 END LOOP;
	 IF v_exist = 'N' THEN
 	    IF v_param = 'LOSS_EXPENSE' THEN
    	   INSERT INTO GIXX_RECAPITULATION_LOSSES_DTL
   		      (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id, loss_amt)
            VALUES (a.assd_no, a.region_cd, 0, a.line_cd, a.policy_id, a.claim_id,a.gross_losses_a);
	    ELSE
		   INSERT INTO GIXX_RECAPITULATION_LOSSES_DTL
   		               (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id, loss_amt)
			    VALUES (a.assd_no, a.region_cd, 0, a.line_cd, a.policy_id, a.claim_id, a.gross_losses_b);
		END IF;
	 END IF;
   END LOOP;
   COMMIT;
   /*Wilmar 03.31.2015 end added code*/
END;
/


