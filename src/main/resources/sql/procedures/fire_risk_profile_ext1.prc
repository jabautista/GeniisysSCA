DROP PROCEDURE CPI.FIRE_RISK_PROFILE_EXT1;

CREATE OR REPLACE PROCEDURE CPI.fire_risk_profile_ext1
  /*created by iris bordey 02.04.2003
  **this procedure will extract records for risk_profile of FIRE policies only
  */
  (p_user           GIPI_RISK_PROFILE.user_id%TYPE,
   p_line_cd        GIPI_RISK_PROFILE.line_cd%TYPE,
   p_subline_cd     GIPI_RISK_PROFILE.subline_cd%TYPE,
   p_date_from      GIPI_RISK_PROFILE.date_from%TYPE,
   p_date_to        GIPI_RISK_PROFILE.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2)
IS
  v_exists                      VARCHAR2(1) := 'N'; --to check if rec. exists on gipi_risk_profile
  --holds share codes
  v_reten_shr_cd				giis_parameters.param_value_n%TYPE;
  v_facul_shr_cd				giis_parameters.param_value_n%TYPE;
  --holds share types
  v_reten_shr_typ				giis_dist_share.share_type%TYPE;
  v_facul_shr_typ				giis_dist_share.share_type%TYPE;
  v_trty_shr_typ				giis_dist_share.share_type%TYPE;
  --holds the old and new record during processing of extraction
  v_old_record					VARCHAR2(80);
  v_new_record					VARCHAR2(80);
  new_facul_num                 NUMBER := 11;
  --define collection types
  TYPE number_varray IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  TYPE grp_tab       IS TABLE OF GIPI_RISK_PROFILE%ROWTYPE INDEX BY BINARY_INTEGER;
  --for colleciton variables
  vv_range_to   				number_varray;
  vv_range_from					number_varray;
  tab_polrisk_ext				grp_tab;
  -- for use as temporary storage for premiums and tsi per policy_no --
  vv_temp_share_cd				number_varray;
  vv_temp_prem_amt				number_varray;
  vv_temp_tsi_amt				number_varray;
  vv_temp_count					number_varray;
  --variables used for testing only
  v_tarfcount                   NUMBER := 0;
  v_polcount                    NUMBER := 0;
BEGIN
  /*Check if records of corresponding parameters exists on gipi_risk_profile*/
  FOR exst IN (SELECT 'EXIST'
                 FROM GIPI_RISK_PROFILE
		        WHERE line_cd           = NVL(p_line_cd, line_cd)
                  AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
        	      AND all_line_tag      = p_line_tag
        	      AND user_id           = p_user
                  AND TRUNC(date_from)  = TRUNC(p_date_from)
                  AND TRUNC(date_to)    = TRUNC(p_date_to))
  LOOP
    dbms_output.put_line('EXISTS');
    v_exists := 'Y';
	EXIT;
  END LOOP;

  /*if records exists on gipi_risk_profile then perform the necessary scripts
  **to extract records OTHERWISE exit this procedure.*/
  IF v_exists = 'Y' THEN
     dbms_output.put_line('EXISTS');
     --set up the columns to be used per share code
	 FOR shrcd IN (SELECT param_value_n, param_name
                     FROM giis_parameters
                    WHERE param_name IN ('NET_RETENTION','FACULTATIVE'))
     LOOP
	   IF UPPER(shrcd.param_name) = 'NET_RETENTION' THEN
	      v_reten_shr_cd         := shrcd.param_value_n;
	   ELSIF UPPER(shrcd.param_name) = 'FACULTATIVE' THEN
	      v_facul_shr_cd             := shrcd.param_value_n;
	   ELSE
	      v_reten_shr_cd     := NULL;
		  v_facul_shr_cd     := NULL;
	   END IF;
	 END LOOP;
	   --set up the share types
	 FOR shrtyp IN (SELECT rv_low_value, rv_meaning
                      FROM cg_ref_codes
                     WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE')
	 LOOP
	   IF UPPER(shrtyp.rv_meaning)    = 'NET_RETENTION' THEN
	      v_reten_shr_typ            := SUBSTR(shrtyp.rv_low_value,1,1);
	   ELSIF UPPER(shrtyp.rv_meaning) = 'TREATY' THEN
	      v_trty_shr_typ             := SUBSTR(shrtyp.rv_low_value,1,1);
	   ELSIF UPPER(shrtyp.rv_meaning) = 'FACULTATIVE' THEN
	      v_facul_shr_typ			 := SUBSTR(shrtyp.rv_low_value,1,1);
	   ELSE
	      v_reten_shr_typ := NULL;
		  v_trty_shr_typ  := NULL;
		  v_facul_shr_typ := NULL;
	   END IF;
	 END LOOP;

	 DELETE FROM GIPI_RISK_PROFILE
	  WHERE line_cd           = 'FI'
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to)
		AND tarf_cd IS NOT NULL;
	 COMMIT;

	 --to set the range in place
	 SELECT range_from, range_to
	   BULK COLLECT INTO vv_range_from, vv_range_to
	   FROM GIPI_RISK_PROFILE
	  WHERE line_cd           = NVL(p_line_cd, line_cd)
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to)
        ORDER BY range_to ASC;

	 IF SQL%FOUND THEN
	    --this two procedure is to populate tables gipi_polrisk_ext1 and gipi_sharisk_ext2
		--gipi_polrisk_ext1 stores all policies that
		P_Risk_Profile.get_poldist_ext(NVL(p_line_cd,'%'),NVL(p_subline_cd,'%'),p_basis,p_date_from,p_date_to);
  		P_Risk_Profile.get_share_ext;

		--by iris bordey 02.05.2003
		--the ff. scripts starts the process of extraction for FIRE policies only
	 /*LOOP by tariff (or break by tariff to distinguish policy per tariff)
		 >LOOP BY query OF ALL policies that IS valid FOR the tariff fetched ON the first LOOP
		    >LOOP BY SET OF RANGE.it IS IN this LOOP that pol. fetched are evaluated whether they fall w/IN the RANGE
	  **For every processed collections per tariff, insert on gipi_risk_profile then initialize the collection
	  */
		--break by tariff
		FOR tarf IN (SELECT DISTINCT SUBSTR(tarf_cd,1,1) tarf_cd
		               FROM giis_tariff)

	    LOOP
		  v_polcount := 0;
		  --initialize first collection before proccessing the next tariff
		  FOR rec IN vv_range_to.first..vv_range_to.last LOOP
		    tab_polrisk_ext(rec).range_to   := vv_range_to(rec);
			tab_polrisk_ext(rec).range_from := vv_range_from(rec);
			--initialize collection
			tab_polrisk_ext(rec).policy_count := 0;
			tab_polrisk_ext(rec).treaty_tsi  := 0;			tab_polrisk_ext(rec).treaty2_tsi  := 0;
			tab_polrisk_ext(rec).treaty3_tsi := 0;			tab_polrisk_ext(rec).treaty4_tsi  := 0;
			tab_polrisk_ext(rec).treaty5_tsi := 0;			tab_polrisk_ext(rec).treaty6_tsi  := 0;
			tab_polrisk_ext(rec).treaty7_tsi := 0;			tab_polrisk_ext(rec).treaty8_tsi  := 0;
			tab_polrisk_ext(rec).treaty9_tsi := 0;			tab_polrisk_ext(rec).treaty10_tsi := 0;

			tab_polrisk_ext(rec).treaty      := 0;			tab_polrisk_ext(rec).treaty2_prem  := 0;
			tab_polrisk_ext(rec).treaty3_prem:= 0;			tab_polrisk_ext(rec).treaty4_prem  := 0;
			tab_polrisk_ext(rec).treaty5_prem:= 0;			tab_polrisk_ext(rec).treaty6_prem  := 0;
			tab_polrisk_ext(rec).treaty7_prem:= 0;			tab_polrisk_ext(rec).treaty8_prem  := 0;
			tab_polrisk_ext(rec).treaty9_prem:= 0;			tab_polrisk_ext(rec).treaty10_prem := 0;

			tab_polrisk_ext(rec).treaty_cnt   := 0;			tab_polrisk_ext(rec).treaty2_cnt   := 0;
			tab_polrisk_ext(rec).treaty3_cnt  := 0;			tab_polrisk_ext(rec).treaty4_cnt   := 0;
			tab_polrisk_ext(rec).treaty5_cnt  := 0;			tab_polrisk_ext(rec).treaty6_cnt   := 0;
			tab_polrisk_ext(rec).treaty7_cnt  := 0;			tab_polrisk_ext(rec).treaty8_cnt   := 0;
			tab_polrisk_ext(rec).treaty9_cnt  := 0;			tab_polrisk_ext(rec).treaty10_cnt  := 0;

			tab_polrisk_ext(rec).net_retention     := 0;	tab_polrisk_ext(rec).sec_net_retention_prem:= 0;
			tab_polrisk_ext(rec).net_retention_tsi := 0;	tab_polrisk_ext(rec).sec_net_retention_tsi := 0;
			tab_polrisk_ext(rec).net_retention_cnt := 0; 	tab_polrisk_ext(rec).sec_net_retention_cnt := 0;

			tab_polrisk_ext(rec).facultative     := 0;		tab_polrisk_ext(rec).quota_share     := 0;
			tab_polrisk_ext(rec).facultative_tsi := 0;   	tab_polrisk_ext(rec).quota_share_tsi := 0;
			tab_polrisk_ext(rec).facultative_cnt := 0;		tab_polrisk_ext(rec).quota_share_cnt := 0;
		  END LOOP; --end of loop for initialization
		  FOR pol IN --policies to be processed
			         (SELECT a.line_cd, 	  		 a.subline_cd,				a.iss_cd,
     	  	                 a.issue_yy,			 a.pol_seq_no,				a.renew_no, b.item_no,
      	                     c.share_cd,		     c.acct_trty_type,          c.share_type,
     	                     get_item_ann_tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
							                  a.renew_no, b.item_no, p_date_from, p_date_to, p_basis) item_tsi,
     	                     SUM(b.dist_prem) prem_amt,
     	                     SUM(DECODE(c.peril_type,'B',b.dist_tsi,0)) tsi_amt
                        FROM gipi_polrisk_ext1    a,
                             giuw_itemperilds_dtl b,
     	                     gipi_sharisk_ext2    c
                       WHERE a.policy_id >= 0
                         AND a.dist_no    = b.dist_no
                         AND a.line_cd    = b.line_cd
                         AND b.line_cd    = c.line_cd
                         AND b.peril_cd   = c.peril_cd
                         AND b.share_cd   = c.share_cd
			             --checking if particular item_no is valid for specified tariff
		                 AND EXISTS (SELECT 'EXIST'
		                               FROM gipi_item x,
					                        gipi_fireitem z
					                  WHERE 1=1
					                    AND x.policy_id = z.policy_id
					                    AND x.item_no   = z.item_no
					                    AND x.item_no     = b.item_no
					                    AND x.policy_id   = a.policy_id
					                    AND SUBSTR(z.tarf_cd,1,1) = tarf.tarf_cd)
                       GROUP BY a.line_cd,  	 a.subline_cd,			a.iss_cd,
     	                        a.issue_yy,	 a.pol_seq_no,			a.renew_no, b.item_no,
      	                        c.share_cd,	 c.acct_trty_type,      c.share_type,
     		                    a.ann_tsi_amt
					   --(by iob 02.06.03)dont remove the order, impt. in counting num of rec.
					   ORDER BY  a.line_cd, 	  		 a.subline_cd,				a.iss_cd,
     	  	                     a.issue_yy,			 a.pol_seq_no,				a.renew_no,
								 b.item_no)
		  LOOP
		    v_polcount := 1;
		    --for testing only
			v_tarfcount := v_tarfcount + 1;
			--loop by the SET of RANGE
			FOR rec IN vv_range_to.first..vv_range_to.last LOOP
			  tab_polrisk_ext(rec).tarf_cd := tarf.tarf_cd;
			  --evaluate if policy falls within the range
			  IF pol.item_tsi >= tab_polrisk_ext(rec).range_from AND
			     pol.item_tsi <= tab_polrisk_ext(rec).range_to THEN
				 IF p_line_tag = 'N' THEN
				    tab_polrisk_ext(rec).subline_cd := pol.subline_cd;
				 ELSE
				    tab_polrisk_ext(rec).subline_cd := NULL;
				 END IF;
				 v_new_record := pol.line_cd||pol.subline_cd||pol.iss_cd||pol.issue_yy||pol.pol_seq_no
			                    ||pol.renew_no||pol.item_no||tab_polrisk_ext(rec).range_from;
			     --computes the number of records/policies.  Increment by 1 if it is the first record
			     --or when previous record not equal to current record
			     IF v_old_record IS NULL OR v_old_record <> v_new_record THEN
			        v_old_record := v_new_record;
			        tab_polrisk_ext(rec).policy_count := tab_polrisk_ext(rec).policy_count + 1;
			     END IF;
			     --to compute the tsi,prem and no. of rec. per share_type, share_cd(net_ret, facul and each treaty)
			     --first is to compute records under net_retention share
			     IF pol.share_type  = v_reten_shr_typ THEN
			        IF pol.share_cd = v_reten_shr_cd THEN
				       tab_polrisk_ext(rec).net_retention_tsi  := tab_polrisk_ext(rec).net_retention_tsi
					                 							+ pol.tsi_amt;
					   tab_polrisk_ext(rec).net_retention      := tab_polrisk_ext(rec).net_retention + pol.prem_amt;
					   tab_polrisk_ext(rec).net_retention_cnt  := tab_polrisk_ext(rec).net_retention_cnt + 1;
				    ELSE
				       tab_polrisk_ext(rec).sec_net_retention_tsi  := tab_polrisk_ext(rec).sec_net_retention_tsi
					                                                + pol.tsi_amt;
					   tab_polrisk_ext(rec).sec_net_retention_prem := tab_polrisk_ext(rec).sec_net_retention_prem
					                                                + pol.prem_amt;
					   tab_polrisk_ext(rec).sec_net_retention_cnt  := tab_polrisk_ext(rec).sec_net_retention_cnt + 1;
			        END IF;
			     --2nd is to compute records under FACULTATIVE share
			     ELSIF pol.share_type = v_facul_shr_typ THEN
			        IF pol.share_cd = v_facul_shr_cd THEN
				       tab_polrisk_ext(rec).facultative_tsi := tab_polrisk_ext(rec).facultative_tsi + pol.tsi_amt;
					   tab_polrisk_ext(rec).facultative     := tab_polrisk_ext(rec).facultative + pol.prem_amt;
					   tab_polrisk_ext(rec).facultative_cnt := tab_polrisk_ext(rec).facultative_cnt + 1;
				    END IF;
			     --3rd is to compute records under "each" TREATY share or QUOTA_SHARE
			     ELSIF pol.share_type = v_trty_shr_typ THEN
			        IF pol.acct_trty_type = 3 THEN
				       tab_polrisk_ext(rec).quota_share_tsi := tab_polrisk_ext(rec).quota_share_tsi + pol.tsi_amt;
					   tab_polrisk_ext(rec).quota_share     := tab_polrisk_ext(rec).quota_share + pol.prem_amt;
					   tab_polrisk_ext(rec).quota_share_cnt := tab_polrisk_ext(rec).quota_share_cnt + 1;
				    ELSE
				       IF pol.share_cd = 1  THEN
					      tab_polrisk_ext(rec).treaty_tsi := tab_polrisk_ext(rec).treaty_tsi + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty     := tab_polrisk_ext(rec).treaty + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty_cnt := tab_polrisk_ext(rec).treaty_cnt + 1;
					   ELSIF pol.share_cd = 2 THEN
					      tab_polrisk_ext(rec).treaty2_tsi  := tab_polrisk_ext(rec).treaty2_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty2_prem := tab_polrisk_ext(rec).treaty2_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty2_cnt  := tab_polrisk_ext(rec).treaty2_cnt  + 1;
					   ELSIF pol.share_cd = 3 THEN
					      tab_polrisk_ext(rec).treaty3_tsi  := tab_polrisk_ext(rec).treaty3_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty3_prem := tab_polrisk_ext(rec).treaty3_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty3_cnt  := tab_polrisk_ext(rec).treaty3_cnt  + 1;
					   ELSIF pol.share_cd = 4 THEN
					      tab_polrisk_ext(rec).treaty4_tsi  := tab_polrisk_ext(rec).treaty4_tsi  + pol.tsi_amt;
  					      tab_polrisk_ext(rec).treaty4_prem := tab_polrisk_ext(rec).treaty4_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty4_cnt  := tab_polrisk_ext(rec).treaty4_cnt  + 1;
					   ELSIF pol.share_cd = 5 THEN
					      tab_polrisk_ext(rec).treaty5_tsi  := tab_polrisk_ext(rec).treaty5_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty5_prem := tab_polrisk_ext(rec).treaty5_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty5_cnt  := tab_polrisk_ext(rec).treaty5_cnt  + 1;
					   ELSIF pol.share_cd = 6 THEN
	  				      tab_polrisk_ext(rec).treaty6_tsi  := tab_polrisk_ext(rec).treaty6_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty6_prem := tab_polrisk_ext(rec).treaty6_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty6_cnt  := tab_polrisk_ext(rec).treaty6_cnt  + 1;
					   ELSIF pol.share_cd = 7 THEN
					      tab_polrisk_ext(rec).treaty7_tsi  := tab_polrisk_ext(rec).treaty7_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty7_prem := tab_polrisk_ext(rec).treaty7_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty7_cnt  := tab_polrisk_ext(rec).treaty7_cnt  + 1;
					   ELSIF pol.share_cd = 8 THEN
					      tab_polrisk_ext(rec).treaty8_tsi  := tab_polrisk_ext(rec).treaty8_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty8_prem := tab_polrisk_ext(rec).treaty8_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty8_cnt  := tab_polrisk_ext(rec).treaty8_cnt  + 1;
					   ELSIF pol.share_cd = 9 THEN
					      tab_polrisk_ext(rec).treaty9_tsi  := tab_polrisk_ext(rec).treaty9_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty9_prem := tab_polrisk_ext(rec).treaty9_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty9_cnt  := tab_polrisk_ext(rec).treaty9_cnt  + 1;
					   ELSIF pol.share_cd = 10 THEN
					      tab_polrisk_ext(rec).treaty10_tsi  := tab_polrisk_ext(rec).treaty10_tsi  + pol.tsi_amt;
					      tab_polrisk_ext(rec).treaty10_prem := tab_polrisk_ext(rec).treaty10_prem + pol.prem_amt;
					      tab_polrisk_ext(rec).treaty10_cnt  := tab_polrisk_ext(rec).treaty10_cnt  + 1;
	  				   END IF; --end of pol.share_cd = 1...10
				    END IF; --end if for acct_trty type
			     END IF; --end of if for share type
			  ELSE
			     tab_polrisk_ext(rec).policy_count := tab_polrisk_ext(rec).policy_count + 0;
			     tab_polrisk_ext(rec).treaty_tsi   := tab_polrisk_ext(rec).treaty_tsi + 0;
                 tab_polrisk_ext(rec).treaty2_tsi  := tab_polrisk_ext(rec).treaty2_tsi + 0;
		 	     tab_polrisk_ext(rec).treaty3_tsi  := tab_polrisk_ext(rec).treaty3_tsi + 0;
                 tab_polrisk_ext(rec).treaty4_tsi  := tab_polrisk_ext(rec).treaty4_tsi + 0;
			     tab_polrisk_ext(rec).treaty5_tsi  := tab_polrisk_ext(rec).treaty5_tsi + 0;
			     tab_polrisk_ext(rec).treaty6_tsi  := tab_polrisk_ext(rec).treaty6_tsi + 0;
			     tab_polrisk_ext(rec).treaty7_tsi  := tab_polrisk_ext(rec).treaty7_tsi + 0;
			     tab_polrisk_ext(rec).treaty8_tsi  := tab_polrisk_ext(rec).treaty8_tsi + 0;
			     tab_polrisk_ext(rec).treaty9_tsi  := tab_polrisk_ext(rec).treaty9_tsi + 0;
			     tab_polrisk_ext(rec).treaty10_tsi := tab_polrisk_ext(rec).treaty10_tsi + 0;

			     tab_polrisk_ext(rec).treaty       := tab_polrisk_ext(rec).treaty + 0;
			     tab_polrisk_ext(rec).treaty2_prem := tab_polrisk_ext(rec).treaty2_prem + 0;
			     tab_polrisk_ext(rec).treaty3_prem := tab_polrisk_ext(rec).treaty3_prem + 0;
			     tab_polrisk_ext(rec).treaty4_prem := tab_polrisk_ext(rec).treaty4_prem + 0;
			     tab_polrisk_ext(rec).treaty5_prem := tab_polrisk_ext(rec).treaty5_prem + 0;
			     tab_polrisk_ext(rec).treaty6_prem := tab_polrisk_ext(rec).treaty6_prem + 0;
			     tab_polrisk_ext(rec).treaty7_prem := tab_polrisk_ext(rec).treaty7_prem + 0;
			     tab_polrisk_ext(rec).treaty8_prem := tab_polrisk_ext(rec).treaty8_prem + 0;
			     tab_polrisk_ext(rec).treaty9_prem := tab_polrisk_ext(rec).treaty9_prem + 0;
			     tab_polrisk_ext(rec).treaty10_prem:= tab_polrisk_ext(rec).treaty10_prem + 0;

			     tab_polrisk_ext(rec).treaty_cnt   := tab_polrisk_ext(rec).treaty_cnt  + 0;
			     tab_polrisk_ext(rec).treaty2_cnt  := tab_polrisk_ext(rec).treaty2_cnt + 0;
			     tab_polrisk_ext(rec).treaty3_cnt  := tab_polrisk_ext(rec).treaty3_cnt + 0;
			     tab_polrisk_ext(rec).treaty4_cnt  := tab_polrisk_ext(rec).treaty4_cnt + 0;
			     tab_polrisk_ext(rec).treaty5_cnt  := tab_polrisk_ext(rec).treaty5_cnt + 0;
			     tab_polrisk_ext(rec).treaty6_cnt  := tab_polrisk_ext(rec).treaty6_cnt + 0;
			     tab_polrisk_ext(rec).treaty7_cnt  := tab_polrisk_ext(rec).treaty7_cnt + 0;
			     tab_polrisk_ext(rec).treaty8_cnt  := tab_polrisk_ext(rec).treaty8_cnt + 0;
			     tab_polrisk_ext(rec).treaty9_cnt  := tab_polrisk_ext(rec).treaty9_cnt + 0;
			     tab_polrisk_ext(rec).treaty10_cnt := tab_polrisk_ext(rec).treaty10_cnt + 0;

			     tab_polrisk_ext(rec).net_retention     := tab_polrisk_ext(rec).net_retention + 0;
			     tab_polrisk_ext(rec).net_retention_tsi := tab_polrisk_ext(rec).net_retention_tsi + 0;
			     tab_polrisk_ext(rec).net_retention_cnt := tab_polrisk_ext(rec).net_retention_cnt + 0;
			     tab_polrisk_ext(rec).sec_net_retention_prem:= tab_polrisk_ext(rec).sec_net_retention_prem + 0;
			     tab_polrisk_ext(rec).sec_net_retention_tsi := tab_polrisk_ext(rec).sec_net_retention_tsi + 0;
			     tab_polrisk_ext(rec).sec_net_retention_cnt := tab_polrisk_ext(rec).sec_net_retention_cnt + 0;

			     tab_polrisk_ext(rec).facultative     := tab_polrisk_ext(rec).facultative     + 0;
			     tab_polrisk_ext(rec).facultative_tsi := tab_polrisk_ext(rec).facultative_tsi + 0;
			     tab_polrisk_ext(rec).facultative_cnt := tab_polrisk_ext(rec).facultative_cnt + 0;
			     tab_polrisk_ext(rec).quota_share     := tab_polrisk_ext(rec).quota_share     + 0;
			     tab_polrisk_ext(rec).quota_share_tsi := tab_polrisk_ext(rec).quota_share_tsi + 0;
			     tab_polrisk_ext(rec).quota_share_cnt := tab_polrisk_ext(rec).quota_share_cnt + 0;
			  END IF; --end if for evaluating if tsi_amt is w/in the range
		    END LOOP; --end of rec (loop by RANGE)
		  END LOOP; --end of pol (extracted records)
		  dbms_output.put_line(tarf.tarf_cd||'-'||v_tarfcount);
		  v_tarfcount := 0;
		  --start insertion of collected records to gipi_risk_profile
		  --v_polcount resets per tariff.  This is to insure that there are policies queried before inserting.
		  IF v_polcount != 0 THEN
		     FOR risk IN tab_polrisk_ext.first..tab_polrisk_ext.last LOOP
		       INSERT INTO GIPI_RISK_PROFILE
		         (line_cd, subline_cd, user_id, range_from, range_to, policy_count, net_retention,quota_share,
			      treaty, facultative,date_from, date_to, all_line_tag,treaty2_tsi, treaty3_tsi,treaty4_tsi,
			      treaty5_tsi,treaty6_tsi,treaty7_tsi,treaty8_tsi,treaty9_tsi,treaty10_tsi,treaty2_prem,
  			      treaty3_prem,treaty4_prem,treaty5_prem,treaty6_prem,treaty7_prem,treaty8_prem,treaty9_prem,
                  treaty10_prem, net_retention_tsi, facultative_tsi, treaty_tsi, quota_share_tsi,
			      sec_net_retention_tsi,sec_net_retention_prem,net_retention_cnt, facultative_cnt,
			      treaty_cnt,treaty2_cnt, treaty3_cnt,treaty4_cnt, treaty5_cnt, treaty6_cnt, treaty7_cnt,
			      treaty8_cnt, treaty9_cnt, treaty10_cnt,quota_share_cnt, sec_net_retention_cnt,
			      tarf_cd)
		       VALUES
		         (p_line_cd, tab_polrisk_ext(risk).subline_cd, p_user, tab_polrisk_ext(risk).range_from,
			      tab_polrisk_ext(risk).range_to,
			      tab_polrisk_ext(risk).policy_count,tab_polrisk_ext(risk).net_retention,
			      tab_polrisk_ext(risk).quota_share, tab_polrisk_ext(risk).treaty,tab_polrisk_ext(risk).facultative,
			      p_date_from, p_date_to, p_line_tag,
	   		      tab_polrisk_ext(risk).treaty2_tsi,tab_polrisk_ext(risk).treaty3_tsi,
                  tab_polrisk_ext(risk).treaty4_tsi, tab_polrisk_ext(risk).treaty5_tsi,
			      tab_polrisk_ext(risk).treaty6_tsi,
                  tab_polrisk_ext(risk).treaty7_tsi,tab_polrisk_ext(risk).treaty8_tsi,
			      tab_polrisk_ext(risk).treaty9_tsi,
			      tab_polrisk_ext(risk).treaty10_tsi, tab_polrisk_ext(risk).treaty2_prem,
			      tab_polrisk_ext(risk).treaty3_prem,tab_polrisk_ext(risk).treaty4_prem,
			      tab_polrisk_ext(risk).treaty5_prem, tab_polrisk_ext(risk).treaty6_prem,
			      tab_polrisk_ext(risk).treaty7_prem, tab_polrisk_ext(risk).treaty8_prem,
			      tab_polrisk_ext(risk).treaty9_prem,tab_polrisk_ext(risk).treaty10_prem,
			      tab_polrisk_ext(risk).net_retention_tsi, tab_polrisk_ext(risk).facultative_tsi,
			      tab_polrisk_ext(risk).treaty_tsi, tab_polrisk_ext(risk).quota_share_tsi,
			      tab_polrisk_ext(risk).sec_net_retention_tsi, tab_polrisk_ext(risk).sec_net_retention_prem,
			      tab_polrisk_ext(risk).net_retention_cnt, tab_polrisk_ext(risk).facultative_cnt,
			      tab_polrisk_ext(risk).treaty_cnt, tab_polrisk_ext(risk).treaty2_cnt,
			      tab_polrisk_ext(risk).treaty3_cnt, tab_polrisk_ext(risk).treaty4_cnt,
			      tab_polrisk_ext(risk).treaty5_cnt, tab_polrisk_ext(risk).treaty6_cnt,
			      tab_polrisk_ext(risk).treaty7_cnt, tab_polrisk_ext(risk).treaty8_cnt,
			      tab_polrisk_ext(risk).treaty9_cnt, tab_polrisk_ext(risk).treaty10_cnt,
			      tab_polrisk_ext(risk).quota_share_cnt, tab_polrisk_ext(risk).sec_net_retention_cnt,
			      tab_polrisk_ext(risk).tarf_cd);
		     END LOOP;
		     COMMIT;
		  END IF;
		END LOOP; --end of tarf (break by tariff)
     END IF; --end of if sql%found
  ELSE
     NULL;
  END IF; --end if for "if rec. exists on gipi_risk_profile"
END;
/


