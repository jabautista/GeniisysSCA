CREATE OR REPLACE PACKAGE BODY CPI.Lto_Yearly AS 
    /*created by iris bordey (11.27.2002)
    **process extraction of records
    */
  PROCEDURE EXTRACT(
    v_dt_type   VARCHAR2,
    v_iss_cd    VARCHAR2,
	v_zone_type VARCHAR2,
	v_year      NUMBER)
  AS
    TYPE peril_stat_name_tab  IS TABLE OF GIXX_LTO_STAT.peril_stat_name%TYPE;
	TYPE subline_tab		  IS TABLE OF GIXX_LTO_STAT.subline%TYPE;
	TYPE mla_cnt_tab   		  IS TABLE OF GIXX_LTO_STAT.mla_cnt%TYPE;
	TYPE outside_mla_cnt_tab  IS TABLE OF GIXX_LTO_STAT.outside_mla_cnt%TYPE;
	TYPE mla_prem_tab		  IS TABLE OF GIXX_LTO_STAT.mla_prem%TYPE;
	TYPE outside_mla_prem_tab IS TABLE OF GIXX_LTO_STAT.outside_mla_prem%TYPE;
	TYPE subline_type_tab     IS TABLE OF GIIS_MC_SUBLINE_TYPE.subline_type_cd%TYPE;
	--for gixx__lto_claim_stat
	TYPE mla_clm_cnt_tab           IS TABLE OF GIXX_LTO_CLAIM_STAT.mla_clm_cnt%TYPE;
	TYPE outside_mla_clm_cnt_tab   IS TABLE OF GIXX_LTO_CLAIM_STAT.outside_mla_cnt%TYPE;
	TYPE mla_pd_claims_tab         IS TABLE OF GIXX_LTO_CLAIM_STAT.mla_pd_claims%TYPE;
	TYPE outside_mla_pd_claims_tab IS TABLE OF GIXX_LTO_CLAIM_STAT.outside_mla_pd_claims%TYPE;
	TYPE mla_losses_tab            IS TABLE OF GIXX_LTO_CLAIM_STAT.mla_losses%TYPE;
	TYPE outside_mla_losses_tab    IS TABLE OF GIXX_LTO_CLAIM_STAT.outside_mla_losses%TYPE;
    --*--for bulk collect of gixx_lto_stat
	vv_peril_stat_name		  peril_stat_name_tab;
	vv_subline				  subline_tab;
	vv_mla_cnt				  mla_cnt_tab;
	vv_outside_mla_cnt		  outside_mla_cnt_tab;
	vv_mla_prem				  mla_prem_tab;
	vv_outside_mla_prem		  outside_mla_prem_tab;
	vv_subline_type_cd        subline_type_tab;
	--*--for bulk collect of gixx_lto_claim_stat
	vv_mla_clm_cnt		  	  mla_clm_cnt_tab;
	vv_outside_mla_clm_cnt    outside_mla_clm_cnt_tab;
	vv_mla_pd_claims          mla_pd_claims_tab;
	vv_outside_mla_pd_claims  outside_mla_pd_claims_tab;
	vv_mla_losses             mla_losses_tab;
	vv_outside_mla_losses     outside_mla_losses_tab;
	--*--
	v_line_cd        GIIS_LINE.line_cd%TYPE;
	v_subline_cd     GIIS_SUBLINE.subline_cd%TYPE;
	v_peril_cd       GIIS_PERIL.peril_cd%TYPE;
	v_peril_stat_name GIXX_LTO_STAT.peril_stat_name%TYPE;
  BEGIN
    v_line_cd    :=   Giisp.v('MOTOR CAR');
	v_subline_cd :=   Giisp.v('LAND TRANS. OFFICE');
	v_peril_stat_name := get_peril_stat_name(v_zone_type);
    FOR a IN (SELECT peril_cd
	            FROM GIIS_PERIL
			   WHERE zone_type = v_zone_type)
    LOOP
	  v_peril_cd := a.peril_cd;
	END LOOP;
	DELETE FROM GIXX_LTO_STAT
	    WHERE user_id = /*USER*/giis_users_pkg.app_user; --replaced by pjsantos 12/15/2016, GENQA 5892
	SELECT DISTINCT a.subline_type_cd, b.subline_type_desc
	  BULK COLLECT INTO vv_subline_type_cd, vv_subline
      FROM GIPI_VEHICLE a,
           GIIS_MC_SUBLINE_TYPE b
     WHERE 1=1
       AND b.subline_cd      = v_subline_cd
       AND b.subline_type_cd = a.subline_type_cd
       AND a.subline_type_cd IS NOT NULL;
	IF SQL%FOUND THEN
	   --initialize collection
	   vv_mla_prem         := mla_prem_tab();
	   vv_outside_mla_prem := outside_mla_prem_tab();
	   vv_mla_cnt          := mla_cnt_tab();
	   vv_outside_mla_cnt  := outside_mla_cnt_tab();
	   --define extension of collection
	   vv_mla_prem.EXTEND(vv_subline.LAST);
	   vv_outside_mla_prem.EXTEND(vv_subline.LAST);
	   vv_mla_cnt.EXTEND(vv_subline.LAST);
	   vv_outside_mla_cnt.EXTEND(vv_subline.LAST);
	   FOR rec IN vv_subline.FIRST..vv_subline.LAST
	   LOOP
	    SELECT SUM(DECODE(b.coverage_cd, 1, c.prem_amt * b.currency_rt, 0)) mla_prem_amt,
        	   SUM(DECODE(b.coverage_cd, 1, 0, c.prem_amt * b.currency_rt)) prem_amt,
        	   COUNT(DISTINCT(DECODE
        		             (b.coverage_cd, 1, a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy
        				                    ||a.pol_seq_no||a.renew_no, NULL))) mla_cnt,
        	   COUNT(DISTINCT(DECODE
        		              (b.coverage_cd, 1, NULL, a.line_cd||a.subline_cd||a.iss_cd||a.issue_yy
        					                    ||a.pol_seq_no||a.renew_no))) cnt
    	  INTO vv_mla_prem(rec),
		       vv_outside_mla_prem(rec),
			   vv_mla_cnt(rec),
	           vv_outside_mla_cnt(rec)
		  FROM GIPI_ITMPERIL                      c,   --to get sum of perils
    	       GIPI_POLBASIC                      a,  --for evaluation of dates
    		   GIPI_ITEM                          b,  --to link with gipi_vehicle
    		   GIPI_VEHICLE                       d   --specifies subline_type_cd
         WHERE 1=1
    	       --gipi_vehicle and gipi_item
    	   AND b.item_no    = d.item_no
    	   AND b.policy_id  = d.policy_id
    	       --gipi_item and gipi_itmperil
           AND b.policy_id = c.policy_id
           AND b.item_no   = c.item_no
    	       --polbasic and gipi_item
           AND a.policy_id  = b.policy_id
    	   ---*---
    	   AND d.subline_cd      = v_subline_cd
     	   AND d.subline_type_cd = vv_subline_type_cd(rec)
     	   AND c.peril_cd = v_peril_cd
    	   AND a.iss_cd <> DECODE(v_iss_cd, 'T', '**','RI')
           AND a.dist_flag = DECODE(a.pol_flag, '5', '4','3')
               --check if dates are valid
    	   AND date_ok(a.acct_ent_date, a.eff_date, a.issue_date, a.booking_year,
                  a.spld_acct_ent_date, a.pol_flag, v_dt_type, v_year) =  1;
	  END LOOP;
      FORALL cnt IN vv_subline_type_cd.FIRST..vv_subline_type_cd.LAST
	     INSERT INTO GIXX_LTO_STAT
		   (peril_stat_name,        subline,       mla_cnt,
		    outside_mla_cnt,        mla_prem,      outside_mla_prem,
		    user_id,                last_update)
	     VALUES
		   (v_peril_stat_name,          vv_subline(cnt),  vv_mla_cnt(cnt),
		    vv_outside_mla_cnt(cnt),    vv_mla_prem(cnt), vv_outside_mla_prem(cnt),
			/*USER*/giis_users_pkg.app_user,                       TRUNC(SYSDATE));--replaced by pjsantos 12/15/2016, GENQA 5892
      COMMIT;
	END IF;
	--iris b. (12.04.2002)
	--after populating gixx_lto_stat, will now extract records for gixx_lto_claim_stat
	--initilize collection
	DELETE FROM GIXX_LTO_CLAIM_STAT
	 WHERE user_id = /*USER*/giis_users_pkg.app_user;--replaced by pjsantos 12/15/2016, GENQA 5892
	vv_subline.DELETE;
	/*explain plan for this select
       	select statement optimizer=choose
         sort (group by)
           filter
             nested loops
               nested loops
                 nested loops
                   nested loops
                     table access (by index rowid) of gicl_claims
                       index (range scan) of claims_u1 (unique)
                     table access (by index rowid) of gicl_motor_car_dtl
                       index (unique scan) of e350_pk (unique)
                   table access (by index rowid) of gipi_polbasic
                     index (range scan) of polbasic_u1 (unique)
                 table access (by index rowid) of gipi_item
                   index (unique scan) of item_pk (unique)
               table access (by index rowid) of gicl_clm_res_hist
                 index (range scan) of clrh_pk (unique)
*/
	SELECT get_peril_stat_name(v_zone_type) peril_stat_name,
	       get_subline_type_desc(v_subline_cd, d.subline_type_cd) subline_type,
	       COUNT(DECODE(e.coverage_cd, 1, b.claim_id, NULL)) mla_cnt,
     	   COUNT(DECODE(e.coverage_cd, 1, NULL, b.claim_id)) out_mla_cnt,
     	   NVL(SUM(DECODE(e.coverage_cd, 1, c.loss_reserve, 0)),0)
     	   - NVL(SUM(DECODE(e.coverage_cd, 1, c.losses_paid, 0)),0) mla_losses,
     	   NVL(SUM(DECODE(e.coverage_cd, 1, 0, c.loss_reserve)),0)
     	   - NVL(SUM(DECODE(e.coverage_cd, 1,0, c.losses_paid)),0) out_mla_losses,
     	   NVL(SUM(DECODE(e.coverage_cd, 1, c.losses_paid, 0)),0)
     	   + NVL(SUM(DECODE(e.coverage_cd, 1, c.expenses_paid, 0)),0) mla_pd_claims,
     	   NVL(SUM(DECODE(e.coverage_cd, 1,0, c.losses_paid)),0)
     	   + NVL(SUM(DECODE(e.coverage_cd, 1,0, c.expenses_paid)),0) out_mla_pd_claims
      BULK COLLECT INTO
	       vv_peril_stat_name,
		   vv_subline,
		   vv_mla_clm_cnt,
           vv_outside_mla_clm_cnt,
           vv_mla_losses,
           vv_outside_mla_losses,
		   vv_mla_pd_claims,
           vv_outside_mla_pd_claims
      FROM GIPI_POLBASIC a,
           GIPI_ITEM     e,
           GICL_CLAIMS   b,      --to specify claims trans. as linked to polbasic
    	   GICL_CLM_RES_HIST c,  --for loss_reserve and paid claims
    	   GICL_MOTOR_CAR_DTL d  --to group by subline_type
     WHERE 1=1
           --link gipi_polbasic and gipi_item
       AND a.policy_id = e.policy_id
           --link gipi_item gicl_motor_car_dtl
       AND d.item_no   = e.item_no
           --filter gipi_polbasic
       AND a.iss_cd  <> DECODE(v_iss_cd, 'T', '**', 'RI')
       AND a.dist_flag = DECODE(a.pol_flag, '5', '4', '3')
       --check if dates are valid
	   AND date_ok(a.acct_ent_date, a.eff_date, a.issue_date, a.booking_year,
                  a.spld_acct_ent_date, a.pol_flag, v_dt_type, v_year) =  1
           --link gipi_polbasic and gicl_claims
       AND a.line_cd    = b.line_cd
       AND a.subline_cd = b.subline_cd
       AND a.iss_cd     = b.pol_iss_cd
       AND a.issue_yy   = b.issue_yy
       AND a.pol_seq_no = b.pol_seq_no
       AND a.renew_no   = b.renew_no
       AND b.line_cd    = v_line_cd
       AND b.subline_cd = v_subline_cd
           --link gicl_claims and gicl_claims_res_hist
       AND b.claim_id = c.claim_id
           --link gicl_claims and gicl_motor_car_dtl
       AND b.claim_id = d.claim_id
           --filter gicl_claims_res_hist
       AND c.peril_cd = v_peril_cd
	       --check if loss_date of gicl_claims as same as year specified
	   AND TO_NUMBER(TO_CHAR(b.loss_date, 'YYYY')) = v_year
       GROUP BY d.subline_type_cd;
	--start insertion of extracted records to gixx_lto_claim_stat
	IF SQL%FOUND THEN
	   FORALL rec IN vv_subline.FIRST..vv_subline.LAST
	   INSERT INTO GIXX_LTO_CLAIM_STAT
	     (peril_stat_name,           subline,                     mla_clm_cnt,
		  outside_mla_cnt,           mla_pd_claims,               outside_mla_pd_claims,
		  mla_losses,                outside_mla_losses,          user_id,
		  last_update)
	   VALUES
	     (vv_peril_stat_name(rec),   vv_subline(rec),             vv_mla_clm_cnt(rec),
		  vv_outside_mla_cnt(rec),   vv_mla_pd_claims(rec),       vv_outside_mla_pd_claims(rec),
		  vv_mla_losses(rec),        vv_outside_mla_losses(rec),  /*USER*/giis_users_pkg.app_user,--replaced by pjsantos 12/15/2016, GENQA 5892
		  TRUNC(SYSDATE));
	END IF;
  END;
  /*created by iris bordey 12.03.2002
  **return 1 if dates are ok*/
  FUNCTION date_ok (
    p_ad       IN DATE,   	  	  		--handles accounting entry date
    p_ed       IN DATE,                 --handles effectiviey date
    p_id       IN DATE,                 --handles issue date
    p_bk_year  IN NUMBER,               --handles booking year
    p_spld_ad  IN DATE,                 --handles spld_acct_ent_date
	p_pol_flag IN VARCHAR2,             --to check for spoiled policies (pol_flag = 5)
    p_dt_type  IN VARCHAR2,             --basis for evaluation of date if by effectivity date.. etc.
    p_year     IN NUMBER)
  RETURN NUMBER IS
    v_ad       NUMBER;    --holds year of accounting entry date
	v_ed       NUMBER;    --holds year of effectivity date
	v_id       NUMBER;    --holds year of issue date
	v_spld_ad  NUMBER;    --holds year of spld_acct_ent_date
  BEGIN
    --*--
	v_ad      := TO_NUMBER(TO_CHAR(p_ad, 'YYYY'));
	v_ed      := TO_NUMBER(TO_CHAR(p_ed, 'YYYY'));
	v_id      := TO_NUMBER(TO_CHAR(p_id, 'YYYY'));
	v_spld_ad := TO_NUMBER(TO_CHAR(p_spld_ad, 'YYYY'));
	--*--
    --iob  (11.27.2002)
    --if policy is spoiled (pol_flag = 5) and if it is by acct_ent_date then evaluate
	--spld_acct_ent_date against from and to date, otherwise disregard spoiled policies.
	IF p_pol_flag = '5' THEN
	   IF p_dt_type = 'AD' AND v_spld_ad = p_year THEN
	      RETURN (1);
	   ELSE
	      RETURN (0);
	   END IF;
	ELSE
	   IF p_dt_type    = 'AD' AND v_ad = p_year THEN
		  RETURN (1);
       ELSIF p_dt_type = 'ED' AND v_ed = p_year THEN
          RETURN (1);
       ELSIF p_dt_type = 'ID' AND v_id = p_year THEN
          RETURN (1);
       ELSIF p_dt_type = 'BD' AND p_bk_year = p_year THEN
             RETURN (1);
       ELSE
          RETURN (0);
       END IF;
	   RETURN (0);
	END IF;
  END;
  /*created by iris bordey (12.02.2002)
  **returns latest subline_type_desc/subline_type_cd  of policy
  */
  FUNCTION get_subline_type(p_line_cd     VARCHAR2,
                            p_subline_cd  VARCHAR2,
    						p_iss_cd      VARCHAR2,
    						p_issue_yy    NUMBER,
    						p_pol_seq_no  NUMBER,
    						p_renew_no    NUMBER,
    						p_item_no     NUMBER,
    						p_dt_type     VARCHAR2,
    						p_year        NUMBER)
  RETURN VARCHAR2 IS
    v_return    GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE;
  BEGIN
    FOR a IN (SELECT z.subline_type_cd,  z.subline_type_desc
	            FROM GIPI_POLBASIC         x,
				     GIPI_VEHICLE          y,
					 GIIS_MC_SUBLINE_TYPE  z
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
				 --polbasic and gipi_vehicle
				 AND x.policy_id       = y.policy_id
				 AND y.item_no         = p_item_no
				 --gipi_vehicle and giis_mc_subline_type
				 AND y.subline_type_cd = z.subline_type_cd
				 AND y.subline_cd      = z.subline_cd
				 --check if dates are valid for that particular record in polbasic
				 AND date_ok(x.acct_ent_date, x.eff_date, x.issue_date, x.booking_year,
                     x.spld_acct_ent_date, x.pol_flag, p_dt_type, p_year) =  1
				 AND y.subline_type_cd IS NOT NULL
				 AND NOT EXISTS (SELECT 'X'
				                   FROM GIPI_POLBASIC       r,
								        GIPI_VEHICLE        s
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
									AND s.subline_type_cd         IS NOT NULL
                                    --for backward endorsements
									AND r.endt_seq_no             > x.endt_seq_no
									AND NVL(r.back_stat, 5)       = 2
									--check if dates are valid for that particular record in polbasic
									AND date_ok(r.acct_ent_date, r.eff_date, r.issue_date, r.booking_year,
                                        r.spld_acct_ent_date, r.pol_flag, p_dt_type, p_year) =  1)
			 ORDER BY x.eff_date DESC)
    LOOP
	  v_return := a.subline_type_desc;
	  EXIT;
	END LOOP;
	RETURN(v_return);
  END;
  /*created by iris bordey (12.02.2002
  **returns peril_stat_name
  */
  FUNCTION get_peril_stat_name(p_zone_type VARCHAR2)
  RETURN VARCHAR2 IS
    v_peril_stat_name               VARCHAR2(100);
  BEGIN
    FOR c IN (SELECT  rv_meaning NAME
                FROM CG_REF_CODES
               WHERE rv_domain = 'GIIS_PERIL.ZONE_TYPE'
                 AND rv_low_value = p_zone_type)
    LOOP
      v_peril_stat_name := c.NAME;
	  EXIT;
    END LOOP;
	RETURN(v_peril_stat_name);
  END;
  FUNCTION get_subline_type_desc(
    p_subline_cd      VARCHAR2,
	p_subline_type_cd VARCHAR2)
  RETURN VARCHAR2 IS
    v_subline_type_desc     GIIS_MC_SUBLINE_TYPE.subline_type_desc%TYPE;
  BEGIN
    FOR a IN (SELECT subline_type_desc
	            FROM GIIS_MC_SUBLINE_TYPE
			   WHERE 1=1
			     AND subline_cd      = p_subline_cd
				 AND subline_type_cd = p_subline_type_cd)
    LOOP
      v_subline_type_desc := a.subline_type_desc;
      EXIT;
    END LOOP;
    RETURN(v_subline_type_desc);
  END;
END;
/


