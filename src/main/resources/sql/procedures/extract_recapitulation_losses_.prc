DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_LOSSES_;

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation_Losses_(p_from_date DATE, p_to_date DATE)
  AS
   v_region_cd					 gixx_recapitulation.region_cd%TYPE;
   v_ind_grp_cd 				 gixx_recapitulation.ind_grp_cd%TYPE;
   v_no_of_policy 				 gixx_recapitulation.no_of_policy%TYPE;
   v_gross_prem 				 gixx_recapitulation.gross_prem%TYPE;
   v_gross_losses 				 gixx_recapitulation.gross_losses%TYPE;--tab_gross_losses;
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
  FOR a IN (SELECT f.region_cd,
  	  	   		   g.ind_grp_cd,
                   SUM(NVL(e.losses_paid,0)  + NVL(e.expenses_paid,0)) gross_losses_a,
				   SUM(NVL(e.losses_paid,0)) gross_losses_b
              FROM (SELECT DISTINCT y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM gipi_polbasic x,
					       gicl_claims y
				     WHERE x.line_cd    = y.line_cd
					   AND x.subline_cd = y.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')) a,
			       giis_region         f,
				   giis_industry_group g,
				   giac_acctrans       d,
				   gicl_clm_res_hist   e
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
                   SUM(NVL(e.losses_paid*-1,0)  + NVL(e.expenses_paid*-1,0)) gross_losses_a,
  				   SUM(NVL(e.losses_paid*-1,0)) gross_losses_b
              FROM (SELECT DISTINCT y.claim_id, y.line_cd line_cd,
				           y.subline_cd subline_cd, y.pol_iss_cd iss_cd,
						   y.issue_yy issue_yy, y.pol_seq_no pol_seq_no,
						   y.renew_no renew_no,
						   y.assd_no
	                  FROM gipi_polbasic x,
					       gicl_claims y
				     WHERE x.line_cd    = y.line_cd
					   AND x.subline_cd = y.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')) a,
                   giis_region         f,
                   giis_industry_group g,
                   giac_acctrans       d,
                   gicl_clm_res_hist   e,
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
   LOOP
     v_exist := 'N';
     v_gross_prem := 0;
     FOR b IN (SELECT 1
	             FROM gixx_recapitulation
	  		    WHERE region_cd  = a.region_cd
				  AND ind_grp_cd = a.ind_grp_cd)
	 LOOP
	   v_exist := 'Y';
	   IF v_param = 'LOSS_EXPENSE' THEN
	      UPDATE gixx_recapitulation
		     SET gross_losses = a.gross_losses_a
   		   WHERE region_cd  = a.region_cd
  		     AND ind_grp_cd = a.ind_grp_cd;
	   ELSE
	     UPDATE gixx_recapitulation
		     SET gross_losses = a.gross_losses_b
   		   WHERE region_cd  = a.region_cd
  		     AND ind_grp_cd = a.ind_grp_cd;
	   END IF;
	   EXIT;
	 END LOOP;
	 IF v_exist = 'N' THEN
 	    IF v_param = 'LOSS_EXPENSE' THEN
    	   INSERT INTO gixx_recapitulation
   		      (region_cd, ind_grp_cd, no_of_policy,
		       gross_prem, gross_losses)
            VALUES (a.region_cd, a.ind_grp_cd, 0,
	     	      0, a.gross_losses_a);
	    ELSE
		   INSERT INTO gixx_recapitulation
   		      (region_cd, ind_grp_cd, no_of_policy,
		       gross_prem, gross_losses)
            VALUES (a.region_cd, a.ind_grp_cd, 0,
	     	      0, a.gross_losses_b);
		END IF;
	 END IF;
   END LOOP;
   COMMIT;
END;
/


