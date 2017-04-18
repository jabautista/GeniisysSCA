DROP PROCEDURE CPI.EXTRACT_RECAPITULATION;

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation(p_from_date DATE, p_to_date DATE)
  AS
  	TYPE tab_region_cd 	   	      IS TABLE OF gixx_recapitulation.region_cd%TYPE;
  	TYPE tab_ind_grp_cd 	   	  IS TABLE OF gixx_recapitulation.ind_grp_cd%TYPE;
	TYPE tab_no_of_policy 	   	  IS TABLE OF gixx_recapitulation.no_of_policy%TYPE;
	TYPE tab_gross_prem 	   	  IS TABLE OF gixx_recapitulation.gross_prem%TYPE;
	TYPE tab_gross_losses 	   	  IS TABLE OF gixx_recapitulation.gross_losses%TYPE;
	v_region_cd					  tab_region_cd;
	v_ind_grp_cd 				  tab_ind_grp_cd;
    v_no_of_policy 				  tab_no_of_policy;
    v_gross_prem 				  tab_gross_prem;--gixx_recapitulation.gross_prem%TYPE;
    v_gross_losses 				  gixx_recapitulation.gross_losses%TYPE;--tab_gross_losses;
    v_exist                       VARCHAR2(1) := 'N';
    v_todate 					  DATE;
	v_fromdate 					  DATE;
	v_ricd						  giis_parameters.param_value_v%TYPE;
    v_micro_sw                    giis_subline.micro_sw%TYPE;
BEGIN
  /*Procedure created by Iris Bordey
  **Note : Kindly check the explain plan of the select-statement
  **before doing any modifiacation*/
  /* Modified by Grace
  ** Added the from-to field in the extract
  */
  DELETE FROM gixx_recapitulation;
  COMMIT;
  v_ricd := Giisp.v('ISS_CD_RI');
  v_fromdate := p_from_date;--TO_DATE('01-JAN'||p_year);
  v_todate   := p_to_date;--TO_DATE('31-DEC'||p_year);
  /*Select modified by iris bordey (10.11.2003)
  **Omitted query on claims (gicl_claims)*/
  /*Select modified by iris bordey (09.19.2002)
  **Region_cd is per item not per policy*/
    SELECT g.region_cd,
         h.ind_grp_cd,
		 SUM(DECODE((SIGN(v_fromdate - a.acct_ent_date) * 4)
              + SIGN(NVL(a.spld_acct_ent_date, v_todate+60) - v_todate),
			  1, 1,
			 -3, 1,
			  3,-1,
			  4,-1, 0) * (NVL(b.prem_amt,0) * b.currency_rt)) premium_amt,
--		 SUM(b.prem_amt) gross_prem,
         COUNT(DISTINCT a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no) no_of_policy
  BULK COLLECT INTO
         v_region_cd,
		 v_ind_grp_cd,
		 v_gross_prem,
		 v_no_of_policy
    FROM gipi_item           b,
         giis_region         g,
	     gipi_parlist        d,
	     giis_assured        c,
         giis_industry       f,
	     giis_industry_group h,
		 gipi_polbasic       a,
         giis_assured_group  i,  -- added by jayson 05.18.2010
         giis_subline        e   -- added by Wilmar 04.07.2015
   WHERE 1=1
--     AND TO_CHAR(a.acct_ent_date, 'YYYY') = p_year
	 --LINK GIPI_POLBASIC AND GIPI_ITEM
	 AND a.policy_id    = b.policy_id
	 --LINK GIPI_ITEM AND GIIS_REGION
     AND g.region_cd = NVL(b.region_cd,a.region_cd)
	 --LINK GIPI_POLBASIC AND GIPI_PARLIST
     AND a.par_id       = d.par_id
	 --LINK GIPI_PARLIST AND GIIS_ASSURED
     AND d.assd_no      = c.assd_no
	 --LINK GIIS_ASSURED AND GIIS_INDUSTRY
     AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
	 --LINK GIIS_INDUSTRY AND GIIS_INDUSTRY_GRP
     AND f.ind_grp_cd   = h.ind_grp_cd
	 AND a.iss_cd != v_ricd
     --LINK GIIS_ASSURED AND GIIS_ASSURED_GROUP
     AND c.assd_no      = i.assd_no (+)  -- added by jayson 05.18.2010
     AND i.group_cd IS NULL  -- added by jayson 05.18.2010
	 AND a.iss_cd != Giisp.v('ISS_CD_RI')
     /* jhing 02.22.2013 added  security rights control */
     --AND a.cred_branch != Giisp.v('ISS_CD_RI')  --commented out by MJ 05/06/2013, because of v_ricd
     AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1
                    or check_user_per_iss_cd(a.line_cd, a.cred_branch, 'GIPIS203') = 1 )
    /* jhing 02.22.2013 end added code */
     AND (   (    TRUNC(a.acct_ent_date) >= v_fromdate
              AND TRUNC(a.acct_ent_date) <= v_todate)
          OR (    TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= v_fromdate
              AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= v_todate))
    -- LINK GIIS_SUBLINE
     AND a.line_cd = e.line_cd
     AND a.subline_cd = e.subline_cd
     AND (e.micro_sw <> 'Y' OR e.micro_sw IS NULL)
    /* Wilmar 04.07.2015 end added code*/
   GROUP BY g.region_cd, h.ind_grp_cd;
  IF SQL%FOUND THEN
     /*QUERY FOR THE GROSS LOSSES OF RECAPITULATION*/
     FOR cnt IN  v_region_cd.FIRST..v_region_cd.LAST
	 LOOP
	   v_gross_losses := 0; 
		INSERT INTO gixx_recapitulation
   		 	     (region_cd, ind_grp_cd, no_of_policy,
			      gross_prem, gross_losses,social_gross_prem)  -- edited by Jayson 05.18.2010
        VALUES (v_region_cd(cnt), v_ind_grp_cd(cnt), v_no_of_policy(cnt),
	    	      v_gross_prem(cnt), v_gross_losses,0);  -- edited by Jayson 05.18.2010
	  END LOOP;
     COMMIT;
  END IF;
  --Start of select statement for micro insurance
      SELECT g.region_cd,
		 SUM(DECODE((SIGN(v_fromdate - a.acct_ent_date) * 4)
              + SIGN(NVL(a.spld_acct_ent_date, v_todate+60) - v_todate),
			  1, 1,
			 -3, 1,
			  3,-1,
			  4,-1, 0) * (NVL(b.prem_amt,0) * b.currency_rt)) premium_amt,
         COUNT(DISTINCT a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no) no_of_policy
  BULK COLLECT INTO
         v_region_cd,
		 v_gross_prem,
		 v_no_of_policy
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
	 AND a.policy_id    = b.policy_id
     AND g.region_cd = NVL(b.region_cd,a.region_cd)
     AND a.par_id       = d.par_id
     AND d.assd_no      = c.assd_no
     AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
     AND f.ind_grp_cd   = h.ind_grp_cd
	 AND a.iss_cd != v_ricd
     AND c.assd_no      = i.assd_no (+)
     AND i.group_cd IS NULL
	 AND a.iss_cd != Giisp.v('ISS_CD_RI')
     AND ( check_user_per_iss_cd(a.line_cd, a.iss_cd, 'GIPIS203') = 1
                    or check_user_per_iss_cd(a.line_cd, a.cred_branch, 'GIPIS203') = 1 )
     AND (   (    TRUNC(a.acct_ent_date) >= v_fromdate
              AND TRUNC(a.acct_ent_date) <= v_todate)
          OR (    TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= v_fromdate
              AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= v_todate))
    AND a.line_cd = e.line_cd
    AND a.subline_cd = e.subline_cd
    AND e.micro_sw = 'Y'
   GROUP BY g.region_cd
   --, h.ind_grp_cd
   ;
    IF SQL%FOUND THEN
     FOR cnt IN  v_region_cd.FIRST..v_region_cd.LAST
	 LOOP
	   v_gross_losses := 0; 
		INSERT INTO gixx_recapitulation
   		 	     (region_cd, ind_grp_cd, no_of_policy,
			      gross_prem, gross_losses,social_gross_prem) 
        VALUES (v_region_cd(cnt), 0, v_no_of_policy(cnt),
	    	      v_gross_prem(cnt), v_gross_losses,0); 
	  END LOOP;
     COMMIT;
  END IF;
  /*wilmar 03.26.2015 end added code*/
END;
/


