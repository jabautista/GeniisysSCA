DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_LOSSES;

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation_Losses(p_from_date DATE, p_to_date DATE)
  AS
   v_region_cd					 GIXX_RECAPITULATION.region_cd%TYPE;
   v_ind_grp_cd 				 GIXX_RECAPITULATION.ind_grp_cd%TYPE;
   v_no_of_policy 				 GIXX_RECAPITULATION.no_of_policy%TYPE;
   v_gross_prem 				 GIXX_RECAPITULATION.gross_prem%TYPE;
   v_gross_losses 				 GIXX_RECAPITULATION.gross_losses%TYPE;--tab_gross_losses;
   v_exist                       VARCHAR2(1) := 'N';
   v_param     					 giis_parameters.param_value_v%TYPE;

BEGIN
  FOR param IN (SELECT param_value_v
                  FROM giis_parameters
				 WHERE param_name = 'RECAP_LOSS_VALUE')
  LOOP
      v_param := param.param_value_v;
	  EXIT;
  END LOOP;
  /**Note : Kindly check the explain plan of the select-statement
  **before doing any modifiacation*/
  FOR a IN (SELECT region_cd, 
                   ind_grp_cd,
                   SUM(gross_losses_a) gross_losses_a, 
                   SUM(gross_losses_b) gross_losses_b
            FROM (SELECT f.region_cd,
  	  	   		        g.ind_grp_cd,
                   SUM(NVL(e.losses_paid,0) + NVL(e.expenses_paid,0)) gross_losses_a,
				   SUM(NVL(e.losses_paid,0)) gross_losses_b
              FROM (SELECT DISTINCT y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM gipi_polbasic x,
					       GICL_CLAIMS y,
                           giis_subline z -- added by Wilmar 04.07.2015
				     WHERE x.line_cd    = y.line_cd
                       AND x.line_cd    = z.line_cd -- Added by Wilmar 04.07.2015
					   AND x.subline_cd = y.subline_cd
                       AND x.subline_cd = z.subline_cd  -- Added by Wilmar 04.07.2015
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
                       AND x.assd_no    = y.assd_no -- Added by Wilmar 04.07.2015
                       AND ((z.micro_sw <> 'Y') OR (z.micro_sw IS NULL)) -- Added by Wilmar 04.07.2015
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                       /*jhing 02.22.2013 added security rights control */
                       AND x.cred_branch !=  Giisp.v('ISS_CD_RI') 
                       AND ( check_user_per_iss_cd (x.line_cd, x.iss_cd, 'GIPIS203') = 1 
                            or check_user_per_iss_cd (x.line_cd, x.cred_branch, 'GIPIS203' ) = 1 )
                       /* jhing end added condition 02.22.2013 */
                       ) a,
			       giis_region         f,
				   giis_industry_group g,
				   giac_acctrans       d,
				   GICL_CLM_RES_HIST   e
		     WHERE    --exists on specified region
			   EXISTS (SELECT '1'
               		     FROM gipi_item  itm,
             			      gipi_polbasic pol
           	            WHERE itm.policy_id  = pol.policy_id
    	                  AND itm.region_cd  = f.region_cd
               			  AND pol.line_cd    = a.line_cd
 		                  AND pol.subline_cd = a.subline_cd
   			              AND pol.iss_cd     = a.iss_cd
   			              AND pol.issue_yy   = a.issue_yy
   			              AND pol.pol_seq_no = a.pol_seq_no
   			              AND pol.renew_no   = a.renew_no
  						  AND pol.endt_seq_no = 0
						  AND itm.item_no = e.item_no)
               --exists on specified ind_grp_cd
   			   AND EXISTS (SELECT '1'
	           	   		  	 FROM giis_assured         assd,
	              			 	  giis_industry        ind
							WHERE assd.assd_no    = a.assd_no
							  AND ind.industry_cd = assd.industry_cd
							  AND ind.ind_grp_cd  = g.ind_grp_cd)
 			   AND a.claim_id   = e.claim_id
			   AND e.tran_id    = d.tran_id
			   AND e.tran_id IS NOT NULL
			  -- AND decode(e.cancel_tag,'Y',to_char(e.cancel_date,'YYYY'), p_year + 1)
               --       	  	  > p_year
			   --AND TO_CHAR(d.posting_date, 'YYYY') = p_year
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
			   AND d.tran_flag <> 'D'
               GROUP BY f.region_cd, g.ind_grp_cd
      UNION
            SELECT f.region_cd,
  	  	   		   g.ind_grp_cd,
                   SUM(NVL(e.losses_paid*-1,0) + NVL(e.expenses_paid*-1,0)) gross_losses_a,
				   SUM(NVL(e.losses_paid*-1,0)) gross_losses_b
              FROM (SELECT DISTINCT y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM gipi_polbasic x,
					       GICL_CLAIMS y,
                           giis_subline z -- Added by Wilmar 04.07.2015
				     WHERE x.line_cd    = y.line_cd
                       AND x.line_cd    = z.line_cd -- Added by Wilmar 04.07.2015
					   AND x.subline_cd = y.subline_cd
                       AND x.subline_cd = z.subline_cd  -- Added by Wilmar 04.07.2015
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
                       AND x.assd_no    = y.assd_no -- Added by Wilmar 04.07.2015
                       AND ((z.micro_sw <> 'Y') OR (z.micro_sw IS NULL)) -- Added by Wilmar 04.07.2015
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                        /*jhing 02.22.2013 added security rights control */
                       AND x.cred_branch !=  Giisp.v('ISS_CD_RI') 
                       AND ( check_user_per_iss_cd (x.line_cd, x.iss_cd, 'GIPIS203') = 1 
                            or check_user_per_iss_cd (x.line_cd, x.cred_branch, 'GIPIS203' ) = 1 )
                       /* jhing end added condition 02.22.2013 */
                       ) a,
                   giis_region         f,
                   giis_industry_group g,
                   giac_acctrans       d,
                   GICL_CLM_RES_HIST   e,
                   giac_reversals	   h
             WHERE 1=1
               --exists on specified region
               AND EXISTS (SELECT '1'
                		     FROM gipi_item  itm,
  							      gipi_polbasic pol
               	            WHERE itm.policy_id  = pol.policy_id
      	                      AND itm.region_cd  = f.region_cd
               			      AND pol.line_cd    = a.line_cd
 		                      AND pol.subline_cd = a.subline_cd
   			                  AND pol.iss_cd     = a.iss_cd
   			                  AND pol.issue_yy   = a.issue_yy
   			                  AND pol.pol_seq_no = a.pol_seq_no
   			                  AND pol.renew_no   = a.renew_no
	  						  AND pol.endt_seq_no = 0
							  AND itm.item_no = e.item_no)
               --exists on specified ind_grp_cd
               AND EXISTS (SELECT '1'
                             FROM giis_assured         assd,
	                              giis_industry        ind
                            WHERE assd.assd_no    = a.assd_no
	                          AND ind.industry_cd = assd.industry_cd
		                      AND ind.ind_grp_cd  = g.ind_grp_cd)
               AND a.claim_id   = e.claim_id
               AND e.tran_id    = h.gacc_tran_id
               AND d.tran_id    = h.reversing_tran_id
               AND e.tran_id IS NOT NULL
--               AND TO_CHAR(d.posting_date, 'YYYY') = p_year
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
               GROUP BY f.region_cd, g.ind_grp_cd)
               GROUP BY region_cd, ind_grp_cd)
   LOOP
     v_exist := 'N';
     v_gross_prem := 0;
     FOR b IN (SELECT 1
	             FROM GIXX_RECAPITULATION
	  		    WHERE region_cd  = a.region_cd
				  AND ind_grp_cd = a.ind_grp_cd)
	 LOOP
	   v_exist := 'Y';
	   IF v_param = 'LOSS_EXPENSE' THEN
	      UPDATE GIXX_RECAPITULATION
		     SET gross_losses = a.gross_losses_a
   		   WHERE region_cd  = a.region_cd
			 AND ind_grp_cd = a.ind_grp_cd;
	   ELSE
	     UPDATE GIXX_RECAPITULATION
		     SET gross_losses = a.gross_losses_b
   		   WHERE region_cd  = a.region_cd
		     AND ind_grp_cd = a.ind_grp_cd;
	   END IF;
	   EXIT;
	 END LOOP;
	 IF v_exist = 'N' THEN
 	    IF v_param = 'LOSS_EXPENSE' THEN
    	   INSERT INTO GIXX_RECAPITULATION
   		      (region_cd, ind_grp_cd, no_of_policy,
		       gross_prem, gross_losses, social_gross_prem)  -- edited by Jayson 05.18.2010
            VALUES (a.region_cd, a.ind_grp_cd, 0,
	     	      0, a.gross_losses_a,0); -- edited by Jayson 05.18.2010
	    ELSE
		   INSERT INTO GIXX_RECAPITULATION
   		      (region_cd, ind_grp_cd, no_of_policy,
		       gross_prem, gross_losses, social_gross_prem)  -- edited by Jayson 05.18.2010
            VALUES (a.region_cd, a.ind_grp_cd, 0,
	     	      0, a.gross_losses_b,0);  -- edited by Jayson 05.18.2010
		END IF;
	 END IF;
   END LOOP;
   COMMIT;
   
   --Start of Micro Insurance
   FOR a IN (SELECT region_cd, 
                   SUM(gross_losses_a) gross_losses_a, 
                   SUM(gross_losses_b) gross_losses_b
            FROM (SELECT f.region_cd,
                   SUM(NVL(e.losses_paid,0) + NVL(e.expenses_paid,0)) gross_losses_a,
				   SUM(NVL(e.losses_paid,0)) gross_losses_b
              FROM (SELECT DISTINCT y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM gipi_polbasic x,
					       GICL_CLAIMS y,
                           giis_subline z
				     WHERE x.line_cd    = y.line_cd
                       AND x.line_cd    = z.line_cd
					   AND x.subline_cd = y.subline_cd
                       AND x.subline_cd = z.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
                       AND x.assd_no    = y.assd_no
                       AND z.micro_sw = 'Y'
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                       AND x.cred_branch !=  Giisp.v('ISS_CD_RI') 
                       AND ( check_user_per_iss_cd (x.line_cd, x.iss_cd, 'GIPIS203') = 1 
                            or check_user_per_iss_cd (x.line_cd, x.cred_branch, 'GIPIS203' ) = 1 )
                       ) a,
			       giis_region         f,
				   giis_industry_group g,
				   giac_acctrans       d,
				   GICL_CLM_RES_HIST   e
		     WHERE    --exists on specified region
			   EXISTS (SELECT '1'
               		     FROM gipi_item  itm,
             			      gipi_polbasic pol
           	            WHERE itm.policy_id  = pol.policy_id
    	                  AND itm.region_cd  = f.region_cd
               			  AND pol.line_cd    = a.line_cd
 		                  AND pol.subline_cd = a.subline_cd
   			              AND pol.iss_cd     = a.iss_cd
   			              AND pol.issue_yy   = a.issue_yy
   			              AND pol.pol_seq_no = a.pol_seq_no
   			              AND pol.renew_no   = a.renew_no
  						  AND pol.endt_seq_no = 0
						  AND itm.item_no = e.item_no)
               --exists on specified ind_grp_cd
   			   AND EXISTS (SELECT '1'
	           	   		  	 FROM giis_assured         assd,
	              			 	  giis_industry        ind
							WHERE assd.assd_no    = a.assd_no
							  AND ind.industry_cd = assd.industry_cd
							  AND ind.ind_grp_cd  = g.ind_grp_cd)
 			   AND a.claim_id   = e.claim_id
			   AND e.tran_id    = d.tran_id
			   AND e.tran_id IS NOT NULL
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
			   AND d.tran_flag <> 'D'
             GROUP BY f.region_cd, g.ind_grp_cd
      UNION
            SELECT f.region_cd,
                   SUM(NVL(e.losses_paid*-1,0) + NVL(e.expenses_paid*-1,0)) gross_losses_a,
  				   SUM(NVL(e.losses_paid*-1,0)) gross_losses_b
              FROM (SELECT DISTINCT y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM gipi_polbasic x,
					       GICL_CLAIMS y,
                           giis_subline z
				     WHERE x.line_cd    = y.line_cd
                       AND x.line_cd    = z.line_cd
					   AND x.subline_cd = y.subline_cd
                       AND x.subline_cd = z.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
                       AND x.assd_no    = y.assd_no
                       AND z.micro_sw = 'Y'
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')
                       AND x.cred_branch !=  Giisp.v('ISS_CD_RI') 
                       AND ( check_user_per_iss_cd (x.line_cd, x.iss_cd, 'GIPIS203') = 1 
                            or check_user_per_iss_cd (x.line_cd, x.cred_branch, 'GIPIS203' ) = 1 )
                       ) a,
                   giis_region         f,
                   giis_industry_group g,
                   giac_acctrans       d,
                   GICL_CLM_RES_HIST   e,
                   giac_reversals	   h
             WHERE 1=1
               --exists on specified region
               AND EXISTS (SELECT '1'
                		     FROM gipi_item  itm,
  							      gipi_polbasic pol
               	            WHERE itm.policy_id  = pol.policy_id
      	                      AND itm.region_cd  = f.region_cd
               			      AND pol.line_cd    = a.line_cd
 		                      AND pol.subline_cd = a.subline_cd
   			                  AND pol.iss_cd     = a.iss_cd
   			                  AND pol.issue_yy   = a.issue_yy
   			                  AND pol.pol_seq_no = a.pol_seq_no
   			                  AND pol.renew_no   = a.renew_no
	  						  AND pol.endt_seq_no = 0
							  AND itm.item_no = e.item_no)
               --exists on specified ind_grp_cd
               AND EXISTS (SELECT '1'
                             FROM giis_assured         assd,
	                              giis_industry        ind
                            WHERE assd.assd_no    = a.assd_no
	                          AND ind.industry_cd = assd.industry_cd
		                      AND ind.ind_grp_cd  = g.ind_grp_cd)
               AND a.claim_id   = e.claim_id
               AND e.tran_id    = h.gacc_tran_id
               AND d.tran_id    = h.reversing_tran_id
               AND e.tran_id IS NOT NULL
			   AND (d.posting_date >= p_from_date AND d.posting_date <= p_to_date)
             GROUP BY f.region_cd)
             GROUP BY region_cd)
   LOOP
     v_exist := 'N';
     v_gross_prem := 0;
     FOR b IN (SELECT 1
	             FROM GIXX_RECAPITULATION
	  		      WHERE region_cd  = a.region_cd
				  AND ind_grp_cd = 0)

	 LOOP
	   v_exist := 'Y';
	   IF v_param = 'LOSS_EXPENSE' THEN
	      UPDATE GIXX_RECAPITULATION
          SET gross_losses = a.gross_losses_a
		     WHERE region_cd  = a.region_cd
  		     AND ind_grp_cd = 0;

	   ELSE
	     UPDATE GIXX_RECAPITULATION
		     SET gross_losses = a.gross_losses_b
   		     WHERE region_cd  = a.region_cd
  		     AND ind_grp_cd = 0;

	   END IF;
	   EXIT;
	 END LOOP;
	 IF v_exist = 'N' THEN
 	    IF v_param = 'LOSS_EXPENSE' THEN
    	   INSERT INTO GIXX_RECAPITULATION
   		      (region_cd, ind_grp_cd, no_of_policy,
		       gross_prem, gross_losses, social_gross_prem)
            VALUES (a.region_cd, 0, 0,
	     	      0, a.gross_losses_a,0);
	    ELSE
		   INSERT INTO GIXX_RECAPITULATION
   		      (region_cd, ind_grp_cd, no_of_policy,
		       gross_prem, gross_losses, social_gross_prem)
            VALUES (a.region_cd, 0, 0,
	     	      0, a.gross_losses_b,0);
		END IF;
	 END IF;
   END LOOP;
   COMMIT;
   /*Wilmar 03.31.2015 end added code*/
END;
/


