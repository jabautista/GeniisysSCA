DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_SOCIAL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation_Social(p_from_date DATE, p_to_date DATE)
  AS
-- PROCEDURE created by Jayson 05.18.2010 --
-- copied from Extract_Recapitulation --
-- this procedure will update the value of social_gross_prem and no_of_policy in gixx_recapitulation --
    v_exist  VARCHAR2(1) := 'N';
    
BEGIN

FOR bb IN (SELECT param_value_n
               FROM giis_parameters
              WHERE param_name = 'SOCIAL_BOOKING')
  LOOP

    FOR a IN (SELECT g.region_cd,
                   h.ind_grp_cd,
                   SUM(DECODE((SIGN(p_from_date - a.acct_ent_date) * 4)
                              + SIGN(NVL(a.spld_acct_ent_date, p_to_date+60) - p_to_date),
                              1 , 1,
                              -3, 1,
                              3 ,-1,
                              4 ,-1, 0) * (NVL(b.prem_amt,0) * b.currency_rt)) premium_amt,
                   COUNT(DISTINCT a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no) no_of_policy
              FROM gipi_item           b,
                   giis_region         g,
                   gipi_parlist        d,
                   giis_assured        c,
                   giis_industry       f,
                   giis_industry_group h,
                   gipi_polbasic       a,
                   giis_assured_group  i,
                   giis_subline        e -- Added by Wilmar 04.07.2015
             WHERE 1=1
               AND a.policy_id                       = b.policy_id
               AND b.region_cd                       = g.region_cd
               AND a.par_id                          = d.par_id
               AND d.assd_no                         = c.assd_no
               AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
               AND f.ind_grp_cd                      = h.ind_grp_cd
               AND c.assd_no                         = i.assd_no
               --AND i.group_cd IS NOT NULL
               AND i.group_cd                        = bb.param_value_n  -- added by Wilmar 03.31.2015
               AND a.iss_cd != Giisp.v('ISS_CD_RI')
               /* jhing 02.22.2013 added  security rights control */
               AND a.cred_branch != Giisp.v('ISS_CD_RI')
               AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1
                    or check_user_per_iss_cd(a.line_cd, a.cred_branch, 'GIPIS203') = 1 )
               /* jhing 02.22.2013 end added code */
               AND (   (    TRUNC(a.acct_ent_date) >= p_from_date
                        AND TRUNC(a.acct_ent_date) <= p_to_date)
                   OR (    TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= p_from_date
                        AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= p_to_date))
           -- LINK GIIS_SUBLINE
               AND a.line_cd = e.line_cd
               AND a.subline_cd = e.subline_cd
               AND ((e.micro_sw <> 'Y') OR (e.micro_sw IS NULL))
              /* Wilmar 04.07.2015 end added code*/
             GROUP BY g.region_cd, h.ind_grp_cd)
   LOOP
     v_exist := 'N';
     
     FOR b IN (SELECT 1
	             FROM GIXX_RECAPITULATION
	  		    WHERE region_cd  = a.region_cd
				  AND ind_grp_cd = a.ind_grp_cd)
	 LOOP
	   v_exist := 'Y';
	   UPDATE GIXX_RECAPITULATION gr
	      SET gr.social_gross_prem = a.premium_amt,
              gr.no_of_policy = gr.no_of_policy + a.no_of_policy
   	    WHERE gr.region_cd  = a.region_cd
  	      AND gr.ind_grp_cd = a.ind_grp_cd;
	   EXIT;
	 END LOOP;
     
	 IF v_exist = 'N' THEN
       INSERT INTO GIXX_RECAPITULATION
   	               (region_cd, ind_grp_cd, no_of_policy,
	                gross_prem, gross_losses, social_gross_prem)
            VALUES (a.region_cd, a.ind_grp_cd, a.no_of_policy,
  	   	            0,0,a.premium_amt);
	 END IF;
   END LOOP;
  COMMIT;  
   
   --Start of Micro Insurance
   FOR a IN (SELECT g.region_cd,
                   h.ind_grp_cd,
                   SUM(DECODE((SIGN(p_from_date - a.acct_ent_date) * 4)
                              + SIGN(NVL(a.spld_acct_ent_date, p_to_date+60) - p_to_date),
                              1 , 1,
                              -3, 1,
                              3 ,-1,
                              4 ,-1, 0) * (NVL(b.prem_amt,0) * b.currency_rt)) premium_amt,
                   COUNT(DISTINCT a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no) no_of_policy
              FROM gipi_item           b,
                   giis_region         g,
                   gipi_parlist        d,
                   giis_assured        c,
                   giis_industry       f,
                   giis_industry_group h,
                   gipi_polbasic       a,
                   giis_assured_group  i,
                   giis_subline        e
             WHERE 1=1
               AND a.policy_id                       = b.policy_id
               AND b.region_cd                       = g.region_cd
               AND a.par_id                          = d.par_id
               AND d.assd_no                         = c.assd_no
               AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
               AND f.ind_grp_cd                      = h.ind_grp_cd
               AND c.assd_no                         = i.assd_no
               AND a.line_cd = e.line_cd
               AND a.subline_cd = e.subline_cd
               AND e.micro_sw = 'Y'
               --AND i.group_cd IS NOT NULL
               AND i.group_cd                        = bb.param_value_n  -- added by Wilmar 03.31.2015
               AND a.iss_cd != Giisp.v('ISS_CD_RI')
               AND a.cred_branch != Giisp.v('ISS_CD_RI')
               AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1
                    or check_user_per_iss_cd(a.line_cd, a.cred_branch, 'GIPIS203') = 1 )
               AND (   (    TRUNC(a.acct_ent_date) >= p_from_date
                        AND TRUNC(a.acct_ent_date) <= p_to_date)
                   OR (    TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= p_from_date
                        AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= p_to_date))
             GROUP BY g.region_cd, h.ind_grp_cd)
    LOOP
     v_exist := 'N';
     
     FOR b IN (SELECT 1
	             FROM GIXX_RECAPITULATION
	  		    WHERE region_cd  = a.region_cd
				  AND ind_grp_cd = 0)
	 LOOP
	   v_exist := 'Y';
	   UPDATE GIXX_RECAPITULATION gr
	      SET gr.social_gross_prem = a.premium_amt,
              gr.no_of_policy = gr.no_of_policy + a.no_of_policy
   	    WHERE gr.region_cd  = a.region_cd
  	      AND gr.ind_grp_cd = 0;
	   EXIT;
	 END LOOP;
     
	 IF v_exist = 'N' THEN
       INSERT INTO GIXX_RECAPITULATION
   	               (region_cd, ind_grp_cd, no_of_policy,
	                gross_prem, gross_losses, social_gross_prem)
            VALUES (a.region_cd, 0, a.no_of_policy,
  	   	            0,0,a.premium_amt);
	 END IF;
    END LOOP;
   END LOOP;
   COMMIT;
END;
/


