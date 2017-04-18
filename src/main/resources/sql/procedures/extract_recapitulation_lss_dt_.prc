DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_LSS_DT_;

CREATE OR REPLACE PROCEDURE CPI.extract_recapitulation_lss_dt_(p_from_date DATE, p_to_date DATE)
  AS
   v_region_cd					 gixx_recapitulation_losses_dtl.region_cd%TYPE;
   v_ind_grp_cd 				 gixx_recapitulation_losses_dtl.ind_grp_cd%TYPE;
   v_line_cd					 gixx_recapitulation_losses_dtl.line_cd%TYPE;
   v_policy_id 	   			     gixx_recapitulation_losses_dtl.policy_id%TYPE;
   v_claim_id  				     gixx_recapitulation_losses_dtl.claim_id%TYPE;
   v_loss_amt 				     gixx_recapitulation_losses_dtl.loss_amt%TYPE;
   v_exist                       VARCHAR2(1) := 'N';
   v_param     					 giis_parameters.param_value_v%TYPE;
   v_assd_no  					 giis_assured.assd_no%TYPE;
BEGIN

  DELETE FROM gixx_recapitulation_losses_dtl;
  COMMIT;

  FOR param IN (SELECT param_value_v
                  FROM giis_parameters
				 WHERE param_name = 'RECAP_LOSS_VALUE')
  LOOP
      v_param := param.param_value_v;
	  EXIT;
  END LOOP;
  FOR a IN (SELECT a.assd_no,
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
	                  FROM gipi_polbasic x,
					       gicl_claims y
				     WHERE x.line_cd    = y.line_cd
					   AND x.subline_cd = y.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   AND x.assd_no    = y.assd_no
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
	                  FROM gipi_polbasic x,
					       gicl_claims y
				     WHERE x.line_cd    = y.line_cd
					   AND x.subline_cd = y.subline_cd
					   AND x.iss_cd     = y.pol_iss_cd
					   AND x.issue_yy   = y.issue_yy
					   AND x.pol_seq_no = y.pol_seq_no
					   AND x.renew_no   = y.renew_no
					   AND x.assd_no    = y.assd_no
					   --AND y.clm_stat_cd  NOT IN ('CC','DN','WD')
					   AND x.endt_seq_no = 0
					   AND x.iss_cd != Giisp.v('ISS_CD_RI')) a,
                   giis_region		   f,
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
             GROUP BY a.assd_no, f.region_cd, g.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id)
   LOOP
	 v_exist := 'N';
     FOR b IN (SELECT 1
	             FROM gixx_recapitulation_losses_dtl
	  		    WHERE assd_no    = a.assd_no
				  AND region_cd  = a.region_cd
				  AND ind_grp_cd = a.ind_grp_cd
				  AND policy_id = a.policy_id
				  AND claim_id = a.claim_id)
	 LOOP
	   v_exist := 'Y';
	   IF v_param = 'LOSS_EXPENSE' THEN
	      UPDATE gixx_recapitulation_losses_dtl
		     SET loss_amt = a.gross_losses_a
   		   WHERE assd_no    = a.assd_no
		     AND region_cd  = a.region_cd
  		     AND ind_grp_cd = a.ind_grp_cd
			 AND policy_id = a.policy_id
			 AND claim_id = a.claim_id;
	   ELSE
	     UPDATE gixx_recapitulation_losses_dtl
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
    	   INSERT INTO gixx_recapitulation_losses_dtl
   		      (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id, loss_amt)
            VALUES (a.assd_no, a.region_cd, a.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id,a.gross_losses_a);
	    ELSE
		   INSERT INTO gixx_recapitulation_losses_dtl
   		               (assd_no, region_cd, ind_grp_cd, line_cd, policy_id, claim_id, loss_amt)
			    VALUES (a.assd_no, a.region_cd, a.ind_grp_cd, a.line_cd, a.policy_id, a.claim_id, a.gross_losses_b);
		END IF;
	 END IF;
   END LOOP;
   COMMIT;
END;
/


