CREATE OR REPLACE PACKAGE BODY CPI.Nlto_Fromto AS 
    /*created by iris bordey (11.27.2002)
    **process extraction of records
    */
  PROCEDURE EXTRACT(
    v_dt_type   VARCHAR2,
    v_iss_cd    VARCHAR2,
	v_zone_type NUMBER,
	v_date_from DATE,
    v_date_to   DATE)
  AS
    --type tab for gixx_nlto_stat
	TYPE coverage_tab 	 	  IS TABLE OF GIXX_NLTO_STAT.coverage%TYPE;
	TYPE peril_name_tab		  IS TABLE OF GIXX_NLTO_STAT.peril_name%TYPE;
	TYPE pc_count_tab  		  IS TABLE OF GIXX_NLTO_STAT.pc_count%TYPE;
	TYPE cv_count_tab         IS TABLE OF GIXX_NLTO_STAT.cv_count%TYPE;
	TYPE mc_count_tab         IS TABLE OF GIXX_NLTO_STAT.mc_count%TYPE;
	TYPE pc_prem_tab		  IS TABLE OF GIXX_NLTO_STAT.pc_prem%TYPE;
	TYPE cv_prem_tab          IS TABLE OF GIXX_NLTO_STAT.cv_prem%TYPE;
	TYPE mc_prem_tab          IS TABLE OF GIXX_NLTO_STAT.mc_prem%TYPE;
	--type tab for gixx_nlto_claim_stat
	TYPE pc_clm_count_tab     IS TABLE OF GIXX_NLTO_CLAIM_STAT.pc_clm_count%TYPE;
	TYPE cv_clm_count_tab     IS TABLE OF GIXX_NLTO_CLAIM_STAT.cv_clm_count%TYPE;
	TYPE mc_clm_count_tab     IS TABLE OF GIXX_NLTO_CLAIM_STAT.mc_clm_count%TYPE;
	TYPE pc_pd_claims_tab     IS TABLE OF GIXX_NLTO_CLAIM_STAT.pc_pd_claims%TYPE;
	TYPE cv_pd_claims_tab     IS TABLE OF GIXX_NLTO_CLAIM_STAT.cv_pd_claims%TYPE;
	TYPE mc_pd_claims_tab     IS TABLE OF GIXX_NLTO_CLAIM_STAT.mc_pd_claims%TYPE;
	TYPE pc_losses_tab        IS TABLE OF GIXX_NLTO_CLAIM_STAT.pc_losses%TYPE;
	TYPE cv_losses_tab        IS TABLE OF GIXX_NLTO_CLAIM_STAT.cv_losses%TYPE;
	TYPE mc_losses_tab        IS TABLE OF GIXX_NLTO_CLAIM_STAT.mc_losses%TYPE;
	--*--for bulk collect on gixx_nlto_stat
	vv_coverage	  		 coverage_tab;
	vv_peril_name		 peril_name_tab;
	vv_pc_count			 pc_count_tab;
	vv_cv_count			 cv_count_tab;
	vv_mc_count			 mc_count_tab;
	vv_pc_prem			 pc_prem_tab;
	vv_cv_prem			 cv_prem_tab;
	vv_mc_prem			 mc_prem_tab;
	--*--for bulk collect on gixx_nlto_claim_stat
	vv_pc_clm_count        pc_clm_count_tab;
	vv_cv_clm_count        cv_clm_count_tab;
	vv_mc_clm_count        mc_clm_count_tab;
	vv_pc_pd_claims        pc_pd_claims_tab;
	vv_cv_pd_claims        cv_pd_claims_tab;
	vv_mc_pd_claims        mc_pd_claims_tab;
	vv_pc_losses           pc_losses_tab;
	vv_cv_losses		   cv_losses_tab;
	vv_mc_losses           mc_losses_tab;
	--*--
	v_line_cd        GIIS_LINE.line_cd%TYPE;
	v_subline_mc     GIIS_SUBLINE.subline_cd%TYPE;
	v_subline_pc     GIIS_SUBLINE.subline_cd%TYPE;
	v_subline_cv     GIIS_SUBLINE.subline_cd%TYPE;
  BEGIN
    FOR c IN (SELECT a.param_value_v mc,
                     b.param_value_v pc,
                     c.param_value_v cv,
                     d.param_value_v   line
               FROM GIIS_PARAMETERS a,
                    GIIS_PARAMETERS b,
                    GIIS_PARAMETERS c,
                    GIIS_PARAMETERS d
               WHERE a.param_name = 'MOTORCYCLE'
                 AND b.param_name = 'PRIVATE CAR'
                 AND c.param_name = 'COMMERCIAL VEHICLE'
                 AND  d.param_name = 'MOTOR CAR')
    LOOP
         v_subline_mc  := c.mc;
         v_subline_pc  := c.pc;
         v_subline_cv  := c.cv;
         v_line_cd     := c.line;
    END LOOP;
	   DELETE FROM GIXX_NLTO_STAT
        WHERE user_id = /*USER*/giis_users_pkg.app_user;--replaced by pjsantos 12/15/2016, GENQA 5892
       COMMIT;
	--iris b. (dec. 2002)
	--start extract records for gixx_nlto_stat
	--explain plan for this select
	/*
	select statement optimizer=choose
     sort (group by)
       filter
         nested loops
           nested loops
             table access (by index rowid) of gipi_item
               index (range scan) of gipi_fki0456 (non-unique)
             table access (by index rowid) of gipi_polbasic
               index (unique scan) of polbasic_pk (unique)
           table access (by index rowid) of gipi_itmperil
             index (range scan) of itmperil_pk (unique)
  */
	SELECT get_coverage_desc(v_zone_type),
	       Get_Peril_Name(v_line_cd, c.peril_cd) peril_name,
      		--count policy with subline 'pcp'
      	   COUNT(DISTINCT(DECODE(a.subline_cd,v_subline_pc,
      		               a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no,
      		     	     NULL))) pc_count,
      		--count policy with subline 'cvp'
      	   COUNT(DISTINCT(DECODE(a.subline_cd,v_subline_cv,
      		               a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no,
      			         NULL))) cv_count,
      		--count policy with subline 'mcp'
      	   COUNT(DISTINCT(DECODE(a.subline_cd,v_subline_mc,
      		               a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy||a.pol_seq_no||a.renew_no,
      			         NULL))) mc_count,
      	   SUM(DECODE(a.subline_cd, v_subline_pc, c.prem_amt * b.currency_rt,0))pc_prem,
      	   SUM(DECODE(a.subline_cd, v_subline_cv, c.prem_amt * b.currency_rt,0))cv_prem,
		   SUM(DECODE(a.subline_cd, v_subline_mc, c.prem_amt * b.currency_rt,0))mc_prem
      BULK COLLECT INTO
	       vv_coverage, vv_peril_name,
		   vv_pc_count, vv_cv_count, vv_mc_count,
		   vv_pc_prem,  vv_cv_prem,  vv_mc_prem
      FROM GIPI_POLBASIC a,
           GIPI_ITMPERIL c,
           GIPI_ITEM b
     WHERE 1=1
       --giis_coverage and gipi_item
       AND b.coverage_cd = v_zone_type
       --gipi_item and gipi_itmperil
       AND c.item_no   = b.item_no
       AND c.policy_id = a.policy_id
       --gipi_polbasic and gipi_item
       AND a.policy_id  = b.policy_id
       --*-- filter polbasic
       AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
       AND a.line_cd    = v_line_cd
       AND (a.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                               OR (b.pack_subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
                                   AND b.pack_line_cd = v_line_cd))
       AND a.dist_flag = DECODE(a.pol_flag, '5', '4','3')
       --check if dates are correct
       AND date_ok(a.acct_ent_date, a.eff_date, a.issue_date, a.booking_mth, a.booking_year,
                   a.spld_acct_ent_date, a.pol_flag, v_dt_type, v_date_from, v_date_to) =  1
     GROUP BY c.peril_cd;
	IF SQL%FOUND THEN
	   FORALL rec IN vv_coverage.FIRST..vv_coverage.LAST
	     INSERT INTO GIXX_NLTO_STAT
		    (coverage,       peril_name,
			 pc_count,       cv_count,        mc_count,
			 pc_prem,        cv_prem,         mc_prem,
			 user_id,        last_update)
		 VALUES
		    (vv_coverage(rec), vv_peril_name(rec),
			 vv_pc_count(rec), vv_cv_count(rec),      vv_mc_count(rec),
			 vv_pc_prem(rec),  vv_cv_prem(rec),       vv_mc_prem(rec),
			 /*USER*/giis_users_pkg.app_user,             TRUNC(SYSDATE)); --replaced by pjsantos 12/15/2016, GENQA 5892
	  COMMIT;
	END IF;
	--iris b. (12.04.2002)
	--after populating gixx_nlto_stat extract rec. for gixx_nlto_claim_stat
	--initilize collection
	DELETE FROM GIXX_NLTO_CLAIM_STAT
	 WHERE user_id = /*USER*/giis_users_pkg.app_user;--replaced by pjsantos 12/15/2016, GENQA 5892
	vv_coverage.DELETE;    vv_peril_name.DELETE;
	/*explain plas for this select
           select statement optimizer=choose
       sort (group by)
         concatenation
           filter
             nested loops
               nested loops
                 nested loops
                   table access (by index rowid) of gicl_claims
                     index (range scan) of claims_u1 (unique)
                   table access (by index rowid) of gipi_polbasic
                     index (range scan) of polbasic_u1 (unique)
                 table access (by index rowid) of gipi_item
                   index (range scan) of gipi_fki0453 (non-unique)
               table access (by index rowid) of gicl_clm_res_hist
                 index (range scan) of clrh_pk (unique)
           filter
             nested loops
               nested loops
                 nested loops
                   table access (by index rowid) of gicl_claims
                     index (range scan) of claims_u1 (unique)
                   table access (by index rowid) of gipi_polbasic
                     index (range scan) of polbasic_u1 (unique)
                 table access (by index rowid) of gipi_item
                   index (range scan) of gipi_fki0453 (non-unique)
               table access (by index rowid) of gicl_clm_res_hist
                 index (range scan) of clrh_pk (unique)
           filter
             nested loops
               nested loops
                 nested loops
                   table access (by index rowid) of gicl_claims
                     index (range scan) of claims_u1 (unique)
                   table access (by index rowid) of gipi_polbasic
                     index (range scan) of polbasic_u1 (unique)
                 table access (by index rowid) of gipi_item
                   index (range scan) of gipi_fki0453 (non-unique)
               table access (by index rowid) of gicl_clm_res_hist
                 index (range scan) of clrh_pk (unique)
	*/
    SELECT get_coverage_desc(v_zone_type),
           Get_Peril_Name(v_line_cd, d.peril_cd) peril_name,
    	   COUNT(DISTINCT(DECODE(a.subline_cd, v_subline_pc, c.claim_id, NULL))) pc_count,
    	   COUNT(DISTINCT(DECODE(a.subline_cd, v_subline_cv, c.claim_id, NULL))) cv_count,
    	   COUNT(DISTINCT(DECODE(a.subline_cd, v_subline_mc, c.claim_id, NULL))) mc_count,
    	   NVL(SUM(DECODE(a.subline_cd, v_subline_pc, d.loss_reserve, 0)),0)
    	   - NVL(SUM(DECODE(a.subline_cd, v_subline_pc, d.losses_paid,0)),0) pc_losses,
    	   NVL(SUM(DECODE(a.subline_cd, v_subline_mc, d.loss_reserve, 0)),0)
    	   - NVL(SUM(DECODE(a.subline_cd, v_subline_mc, d.losses_paid,0)),0) mc_losses,
    	   NVL(SUM(DECODE(a.subline_cd, v_subline_cv, d.loss_reserve, 0)),0)
    	   - NVL(SUM(DECODE(a.subline_cd, v_subline_cv, d.losses_paid,0)),0) cv_losses,
    	   NVL(SUM(DECODE(a.subline_cd, v_subline_pc, d.losses_paid,0)),0)
    	   + NVL(SUM(DECODE(a.subline_cd, v_subline_pc, d.expenses_paid)),0) pc_pd_claims,
    	   NVL(SUM(DECODE(a.subline_cd, v_subline_mc, d.losses_paid,0)),0)
    	   + NVL(SUM(DECODE(a.subline_cd, v_subline_mc, d.expenses_paid)),0) mc_pd_claims,
    	   NVL(SUM(DECODE(a.subline_cd, v_subline_cv, d.losses_paid,0)),0)
	       + NVL(SUM(DECODE(a.subline_cd, v_subline_cv, d.expenses_paid)),0) cv_pd_claims
      BULK COLLECT INTO
	       vv_coverage,
		   vv_peril_name,
		   vv_pc_clm_count,      	   vv_cv_clm_count,       	   vv_mc_clm_count,
       	   vv_pc_losses,          	   vv_mc_losses,		       vv_cv_losses,
		   vv_pc_pd_claims,       	   vv_mc_pd_claims,		       vv_cv_pd_claims
      FROM GIPI_POLBASIC a,
           GIPI_ITEM b,
    	   GICL_CLAIMS c,
    	   GICL_CLM_RES_HIST d
     WHERE 1=1
           --link gipi_polbasic and gipi_item
       AND a.policy_id = b.policy_id
           --filter rec. from gipi_item
       AND get_coverage_cd(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
                           a.pol_seq_no, a.renew_no, b.item_no, v_dt_type,
             			   v_date_from, v_date_to) = b.coverage_cd
       AND NVL(b.coverage_cd,b.coverage_cd) = v_zone_type
           --filter polbasic
       AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
       AND a.line_cd    = v_line_cd
       AND (a.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
            OR (b.pack_subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
            AND b.pack_line_cd = v_line_cd))
       AND a.dist_flag = DECODE(a.pol_flag, '5', '4','3')
           --check if dates are correct
       AND date_ok(a.acct_ent_date, a.eff_date, a.issue_date, a.booking_mth, a.booking_year,
                   a.spld_acct_ent_date, a.pol_flag, v_dt_type, v_date_from, v_date_to) =  1
           --link gipi_polbasic and gicl_claims
       AND a.line_cd    = c.line_cd
       AND a.subline_cd = c.subline_cd
       AND a.iss_cd     = c.iss_cd
       AND a.issue_yy   = c.issue_yy
       AND a.pol_seq_no = c.pol_seq_no
       AND a.renew_no   = c.renew_no
           --link gicl_claims and gicl_clm_res_hist
       AND c.claim_id   = d.claim_id
	   AND c.line_cd    = v_line_cd
	   AND c.subline_cd IN (v_subline_pc, v_subline_mc, v_subline_cv)
	       --check of loss_date from gicl_claims is w/in specified dates
	   AND TRUNC(c.loss_date) >= v_date_from
	   AND TRUNC(c.loss_date) <= v_date_to
       GROUP BY d.peril_cd;
    IF SQL%FOUND THEN
       FORALL rec IN vv_peril_name.FIRST..vv_peril_name.LAST
	   INSERT INTO GIXX_NLTO_CLAIM_STAT
	     (coverage,           peril_name,
		  pc_clm_count,       cv_clm_count,              mc_clm_count,
		  pc_pd_claims,       cv_pd_claims,              mc_pd_claims,
 		  pc_losses,          cv_losses,                 mc_losses,
		  user_id,            last_update)
	   VALUES
	     (vv_coverage(rec),    vv_peril_name(rec),
		  vv_pc_clm_count(rec),vv_cv_clm_count(rec),     vv_mc_clm_count(rec),
		  vv_pc_pd_claims(rec),vv_cv_pd_claims(rec),     vv_mc_pd_claims(rec),
		  vv_pc_losses(rec),   vv_cv_losses(rec),        vv_mc_losses(rec),
		  /*USER*/giis_users_pkg.app_user,                TRUNC(SYSDATE));--replaced by pjsantos 12/15/2016, GENQA 5892
	   COMMIT; --aaron 062707
	END IF;
  END;

  /*  this function checks if the acct_ent_date, eff_date, issue_date or booking date
      of the policy is within the given date range
  */
  FUNCTION date_ok (
    p_ad       IN DATE,   	  	  		--handles accounting entry date
    p_ed       IN DATE,                 --handles effectiviey date
    p_id       IN DATE,                 --handles incept date
    p_mth      IN VARCHAR2,             --handles booking month
    p_year     IN NUMBER,               --handles booking year
    p_spld_ad  IN DATE,                 --handles spld_acct_ent_date
	p_pol_flag IN VARCHAR2,             --to check for spoiled policies (pol_flag = 5)
    p_dt_type  IN VARCHAR2,             --could be ac (acctng. entry date), ed (effectivit dt), id (incept dt), bd (booking dt)
    p_fmdate   IN DATE,                 --from date
    p_todate   IN DATE)                 --to date
  RETURN NUMBER IS
    v_booking_fmdate  DATE;
    v_booking_todate  DATE;
  BEGIN
    --iob  (11.27.2002)
    --if policy is spoiled (pol_flag = 5) and if it is by acct_ent_date then evaluate
	--spld_acct_ent_date against from and to date, otherwise disregard spoiled policies.
	IF p_pol_flag = '5' THEN
	   IF p_dt_type = 'AD' AND TRUNC(p_spld_ad) >= p_fmdate
	      AND TRUNC(p_spld_ad) <= p_todate THEN
	      RETURN (1);
	   ELSE
	      RETURN (0);
	   END IF;
	ELSE
	   IF p_dt_type = 'AD' AND TRUNC(p_ad) >= p_fmdate
		  AND TRUNC(p_ad) <= p_todate THEN
		  RETURN (1);
       ELSIF p_dt_type = 'ED' AND (TRUNC(p_ed)) >= p_fmdate AND (TRUNC(p_ed)) <= p_todate THEN
          RETURN (1);
       ELSIF p_dt_type = 'ID' AND (TRUNC(p_id)) >= p_fmdate AND (TRUNC(p_id)) <= p_todate THEN
          RETURN (1);
       ELSIF p_dt_type = 'BD' THEN
          v_booking_fmdate := TO_DATE('01-'||SUBSTR(p_mth,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY');
          v_booking_todate := LAST_DAY(TO_DATE('01-'||SUBSTR(p_mth,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY'));
          IF v_booking_fmdate >= p_fmdate AND v_booking_todate <= p_todate THEN
             RETURN (1);
          ELSE
             RETURN (0);
          END IF;
       ELSE
          RETURN (0);
       END IF;
	   RETURN (0);
	END IF;
  END;

  /*created by iris bordey (12.02.2002)
  **returns latest coverage_cd of policy
  */
  FUNCTION get_coverage_cd (p_line_cd     VARCHAR2,
                            p_subline_cd  VARCHAR2,
    						p_iss_cd      VARCHAR2,
    						p_issue_yy    NUMBER,
    						p_pol_seq_no  NUMBER,
    						p_renew_no    NUMBER,
    						p_item_no     NUMBER,
    						p_dt_type     VARCHAR2,
    						p_from        DATE,
    						p_to          DATE)
  RETURN NUMBER IS
    v_return    GIIS_COVERAGE.coverage_cd%TYPE;
  BEGIN
    FOR a IN (SELECT z.coverage_cd, z.coverage_desc
	            FROM GIPI_POLBASIC         x,
				     GIPI_ITEM             y,
					 GIIS_COVERAGE         z
			   WHERE 1=1
			     --polbasic and policy_no
			     AND x.line_cd         = p_line_cd
				 AND x.subline_cd      = p_subline_cd
				 AND x.iss_cd          = p_iss_cd
				 AND x.issue_yy        = p_issue_yy
				 AND x.pol_seq_no      = p_pol_seq_no
				 AND x.renew_no        = p_renew_no
				 --disregard spoiled policies/endorsements
				 AND x.pol_flag IN ('1','2', '3', 'X')
				 --polbasic and gipi_item
				 AND x.policy_id       = y.policy_id
				 AND y.item_no         = p_item_no
				 --gipi_item and giis_coverage
				 AND y.coverage_cd     = z.coverage_cd
				 --check if dates are valid for that particular record in polbasic
				 AND Lto_Fromto.date_ok(x.acct_ent_date, x.eff_date, x.issue_date, x.booking_mth, x.booking_year,
                     x.spld_acct_ent_date, x.pol_flag, p_dt_type, p_from, p_to) =  1
				 AND y.coverage_cd IS NOT NULL
				 AND NOT EXISTS (SELECT 'X'
				                   FROM GIPI_POLBASIC       r,
								        GIPI_ITEM           s
								  WHERE 1=1
									--polbasic and policy_no
									AND r.line_cd                 = p_line_cd
									AND r.subline_cd              = p_subline_cd
									AND r.iss_cd                  = p_iss_cd
									AND r.issue_yy                = p_issue_yy
									AND r.pol_seq_no              = p_pol_seq_no
									AND r.renew_no                = p_renew_no
									--disregard spoiled policies/endorsements
									AND r.pol_flag IN ('1','2', '3', 'X')
								    --polbasic and gipi_vehicle
									AND r.policy_id               = s.policy_id
									AND s.item_no                 = p_item_no
									AND s.coverage_cd         IS NOT NULL
                                    --for backward endorsements
									AND r.endt_seq_no             > x.endt_seq_no
									AND NVL(r.back_stat, 5)       = 2
									--check if dates are valid for that particular record in polbasic
									AND Lto_Fromto.date_ok(r.acct_ent_date, r.eff_date, r.issue_date, r.booking_mth, r.booking_year,
                                        r.spld_acct_ent_date, r.pol_flag, p_dt_type, p_from, p_to) =  1)
			 ORDER BY x.eff_date DESC)
    LOOP
	  v_return := a.coverage_cd;
	  EXIT;
	END LOOP;
	RETURN(v_return);
  END;

  /*created by iris bordey (12.03.2002)
  **returns coverage description*/
  FUNCTION get_coverage_desc(p_coverage_cd NUMBER)
  RETURN VARCHAR2 IS
    v_coverage_desc   GIIS_COVERAGE.coverage_desc%TYPE;
  BEGIN
    FOR a IN (SELECT coverage_desc
	            FROM GIIS_COVERAGE
			   WHERE coverage_cd = p_coverage_cd)
    LOOP
	  v_coverage_desc := a.coverage_desc;
	END LOOP;
	RETURN(v_coverage_desc);
  END;

END;
/


