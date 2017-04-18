CREATE OR REPLACE PACKAGE BODY CPI.p_risk_profile_07dec2005 AS
  /*Modified by : Iris Bordey
  **Date        : 11.27.2003
  **Added the procedure extract_risk_profile and risk_profile_per_peril
  **For spec # UW-SPECS-GIPIS901-2003-0031 and UW-SPECS-GIPIR934-2003-0032
  */
  /*MODIFIED BY:  Iris Bordey
  **DATE   : (01.08.2003)
  **   Added evaluation on booking date.  See function date_risk
  **DATE   : (02.06.2003)
  **   Created procedure fire_risk_profile_ext for risk_profile exclusively for FIRE policies only
  **   Created function Get_item_ann_tsi that return the summarized tsi_amt of an item.
  */
  /*
    this package is used by the risk profile extract module.
	it uses the tables :
	   gipi_risk_profile,
	   gipi_polrisk_ext1 and
	   gipi_sharisk_ext2.
  */

  /* modfified by rollie 15sep2005
  ** to prevent error ora-06502 in statement
  ** FOR rec IN arrayvariables.FIRST...arrayvariables.LAST
  ** added marks if arrayvariables is null
  */
PROCEDURE extract_risk_profile
  /*created by iris bordey 11.27.2003
  **There are three types of extraction procedure used by risk_profile depending
  **on line_cd and all_line_tag used ('Y' - by line, 'N' - by line/subline, 'P' - by peril)
  **FIRE_RISK_PROFILE_EXT  --> the procedure is for FIRE policies only (per tariff)
                           --> where all_line_tag <> 'P'. Summation is per share_cd
  **RISK_PROFILE_EXT       --> the original procedure ONLY it exclude FIRE policies.
                           --> where all_line_tag <> 'P'.  Summation is per share_cd.
  **RISK_PROFILE_PER_PERIL --> it extracts for ALL polices  only it is per peril.
                           --> where all_line_tag = 'P'.  Summation is per peril.
  **The procedure categorizes to which risk_profile extract procedure
  **the parameters provided should fall.
  */
  (p_user           gipi_risk_profile.user_id%TYPE,
   p_line_cd        gipi_risk_profile.line_cd%TYPE,
   p_subline_cd     gipi_risk_profile.subline_cd%TYPE,
   p_date_from      gipi_risk_profile.date_from%TYPE,
   p_date_to        gipi_risk_profile.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2,
   p_by_tarf        VARCHAR2)
IS
BEGIN
  IF p_line_tag = 'P' THEN
     risk_profile_per_peril(p_user,      p_line_cd,   p_subline_cd,
	                        p_date_from, p_date_to,   p_basis,      p_line_tag);
  ELSE
     IF NVL(p_by_tarf,'N') = 'Y' THEN
	    fire_risk_profile_ext(p_user,      p_line_cd,   p_subline_cd,
  	                          p_date_from, p_date_to,   p_basis,      p_line_tag);
     ELSE
	    risk_profile_ext(p_user,      p_line_cd,   p_subline_cd,
	                     p_date_from, p_date_to,   p_basis,      p_line_tag);
	 END IF;
  END IF;
END;

PROCEDURE risk_profile_per_peril
  /*created by iris bordey 11.27.2003
  **this procedure will extract records for risk_profile per peril
  */
  (p_user           gipi_risk_profile.user_id%TYPE,
   p_line_cd        gipi_risk_profile.line_cd%TYPE,
   p_subline_cd     gipi_risk_profile.subline_cd%TYPE,
   p_date_from      gipi_risk_profile.date_from%TYPE,
   p_date_to        gipi_risk_profile.date_to%TYPE,
   p_basis          VARCHAR2,
   p_line_tag  	    VARCHAR2)
IS
  v_exists                 VARCHAR2(1)   := 'N';
  v_new_record			   VARCHAR2(500);
  v_old_record			   VARCHAR2(500);
  v_range_tsi			   NUMBER(16,2)   := 0;
  v_fi_line                giis_line.line_cd%TYPE := Giisp.v('LINE_CODE_FI');
  --identifies if there exists a policy to be inserted to gipi_risk_profile
  v_polcount               NUMBER(1)     := 0;
  v_test				   NUMBER(14)     := 0;
  --define collection types
  TYPE number_varray IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  TYPE grp_tab       IS TABLE OF gipi_risk_profile%ROWTYPE INDEX BY BINARY_INTEGER;
  --for colleciton variables
  vv_range_to   				number_varray;
  vv_range_from					number_varray;
  tab_polrisk_ext				grp_tab;
  q1_exists						VARCHAR2(1);
BEGIN
  q1_exists := 'N';
  /*Check if records of corresponding parameters exists on gipi_risk_profile*/
  FOR exst IN (SELECT 'EXIST'
                 FROM gipi_risk_profile
		        WHERE line_cd           = NVL(p_line_cd, line_cd)
                  AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
        	      AND all_line_tag      = p_line_tag
        	      AND user_id           = p_user
                  AND TRUNC(date_from)  = TRUNC(p_date_from)
                  AND TRUNC(date_to)    = TRUNC(p_date_to))
  LOOP
    v_exists := 'Y';
	EXIT;
  END LOOP;
  IF v_exists = 'Y' THEN
     DBMS_OUTPUT.PUT_LINE(p_line_cd||'-'||p_subline_cd||'-'||p_line_tag||'-'||
	                      p_user||'-'||TRUNC(p_date_from)||'-'||TRUNC(p_date_to));
     DELETE gipi_risk_profile
	    WHERE line_cd           = NVL(p_line_cd, line_cd)
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to)
		AND peril_cd IS NOT NULL;
	 COMMIT;
     --to set the range in place
	 /* rollie 15sep2005
	 ** marked this bulk collect as Q1
	 ** columns vv_range_from, vv_range_to
	 */
	 SELECT range_from, range_to
	   BULK COLLECT INTO vv_range_from, vv_range_to
	   FROM gipi_risk_profile
	  WHERE line_cd           = NVL(p_line_cd, line_cd)
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to)
        ORDER BY range_to ASC;
     IF SQL%FOUND THEN
	    --this two procedure is to populate tables gipi_polrisk_ext1 and gipi_sharisk_ext2
		--gipi_polrisk_ext1 stores all policies that falls within the parameter date.
		get_poldist_ext(NVL(p_line_cd,'%'),NVL(p_subline_cd,'%'),p_basis,p_date_from,p_date_to);
  		get_share_ext;
		/*by Iris Bordey 11.27.2003
		** 1. The next scirpt will start summation of tsi and prem amounts that falls
		**    within the range.  Insertion is grouped by tarf_cd, peril.
		** 2. On this procedure 'X' is the tarf_cd for non-fire policies thus
		**    serving as a dummy tarf_cd only.
		*/
		FOR tarf IN (SELECT DISTINCT SUBSTR(tarf_cd,1,1) tarf_cd
		               FROM giis_tariff
					  WHERE p_line_cd = v_fi_line
					  UNION
					 SELECT 'X' tarf_cd
					   FROM dual
					  WHERE p_line_cd <> v_fi_line) LOOP
		  FOR prl IN (SELECT peril_cd
		                FROM giis_peril
					   WHERE line_cd = p_line_cd) LOOP
		    v_polcount := 0;
			--reset collection per peril
			FOR rec IN vv_range_from.FIRST..vv_range_to.LAST LOOP
			  --initialize collection
			  tab_polrisk_ext(rec).range_from    := vv_range_from(rec);
			  tab_polrisk_ext(rec).range_to      := vv_range_to(rec);
			  tab_polrisk_ext(rec).peril_tsi       := 0;
			  tab_polrisk_ext(rec).peril_prem      := 0;
			  tab_polrisk_ext(rec).policy_count  := 0;
			END LOOP;
			FOR pol IN (SELECT c.peril_cd, a.line_cd, a.subline_cd, a.iss_cd,
			                   a.issue_yy, a.pol_seq_no, a.renew_no,
			                   b.tsi_amt peril_tsi,
                               b.prem_amt peril_prem,
							   DECODE(a.line_cd, v_fi_line, b.item_no,1) item_no,
							   a.ann_tsi_amt
                          FROM gipi_itmperil     b,
                               giis_peril        c,
                               gipi_polrisk_ext1 a
                         WHERE 1=1
                           AND a.policy_id = b.policy_id
      	                   AND a.line_cd   = b.line_cd
 	                       AND NVL(b.peril_cd,b.peril_cd)  = prl.peril_cd
	                       AND b.peril_cd  = c.peril_cd
	                       AND b.line_cd   = c.line_cd
	                       AND ((p_line_cd  <> v_fi_line)
	                         OR (p_line_cd = v_fi_line
  	                         AND EXISTS (SELECT 'EXIST'
		                                   FROM gipi_item x,
					                            gipi_fireitem z
					                      WHERE 1=1
 					                        AND x.policy_id = z.policy_id
					                        AND x.item_no   = z.item_no
					                        AND x.item_no     = b.item_no
					                        AND x.policy_id   = a.policy_id
					                        AND SUBSTR(z.tarf_cd,1,1) = tarf.tarf_cd)))
 					       AND a.user_id = USER
                      ORDER BY a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy,
					           a.pol_seq_no, a.renew_no, b.peril_cd,
							   DECODE(a.line_cd, v_fi_line, b.item_no,1))
		    LOOP
			  v_polcount := 1;
			  IF pol.line_cd = v_fi_line THEN
			     v_range_tsi := Get_Item_Ann_Tsi
				                  (pol.line_cd, pol.subline_cd, pol.iss_cd, pol.issue_yy,
								   pol.pol_seq_no, pol.renew_no, pol.item_no, p_date_from,
								   p_date_to, p_basis);
			  ELSE
				 v_range_tsi  := pol.ann_tsi_amt;
			  END IF;
			  FOR rec IN vv_range_to.FIRST..vv_range_to.LAST LOOP
			    tab_polrisk_ext(rec).tarf_cd       := tarf.tarf_cd;
			    tab_polrisk_ext(rec).peril_cd      := prl.peril_cd;
				IF p_subline_cd IS NOT NULL THEN
				   tab_polrisk_ext(rec).subline_cd := pol.subline_cd;
				END IF;
				--evaluate if policy falls within the range
			    IF v_range_tsi >= tab_polrisk_ext(rec).range_from AND
			       v_range_tsi <= tab_polrisk_ext(rec).range_to THEN
				   v_new_record := pol.line_cd||pol.subline_cd||pol.iss_cd||pol.issue_yy||pol.pol_seq_no
			                       ||pol.renew_no||pol.item_no||pol.peril_cd;
			       --computes the number of records/policies.  Increment by 1 if it is the first record
			       --or when previous record not equal to current record
			       IF v_old_record IS NULL OR v_old_record <> v_new_record THEN
			          v_old_record := v_new_record;
			          tab_polrisk_ext(rec).policy_count := tab_polrisk_ext(rec).policy_count + 1;
			       END IF;
				   tab_polrisk_ext(rec).peril_tsi  := tab_polrisk_ext(rec).peril_tsi  + pol.peril_tsi;
				   tab_polrisk_ext(rec).peril_prem := tab_polrisk_ext(rec).peril_prem + pol.peril_prem;
				ELSE
				   tab_polrisk_ext(rec).peril_tsi      := tab_polrisk_ext(rec).peril_tsi      + 0;
				   tab_polrisk_ext(rec).peril_prem     := tab_polrisk_ext(rec).peril_prem     + 0;
				   tab_polrisk_ext(rec).policy_count := tab_polrisk_ext(rec).policy_count + 0;
				END IF;
			  END LOOP; --> PER RANGE
			END LOOP; --> PER POL LOOP
		    IF v_polcount <> 0 THEN
			   FOR risk IN tab_polrisk_ext.FIRST..tab_polrisk_ext.LAST LOOP
			     INSERT INTO gipi_risk_profile
				   (line_cd, subline_cd, user_id, range_from, range_to, policy_count,
				    net_retention, facultative, quota_share,treaty,
					date_from,date_to, peril_tsi, peril_prem, peril_cd, tarf_cd,
					all_line_tag)
				 VALUES
				   (p_line_cd, tab_polrisk_ext(risk).subline_cd,
				    p_user, tab_polrisk_ext(risk).range_from, tab_polrisk_ext(risk).range_to,
					tab_polrisk_ext(risk).policy_count,0,0,0,0,
					p_date_from, p_date_to, tab_polrisk_ext(risk).peril_tsi,
					tab_polrisk_ext(risk).peril_prem,tab_polrisk_ext(risk).peril_cd,
					tab_polrisk_ext(risk).tarf_cd, p_line_tag);
			   END LOOP;
			END IF;
			COMMIT;
		  END LOOP; -->PER PERIL LOOP
		END LOOP; --> PERL TARIFF LOOP
	 END IF;    --> IF SQL%FOUND
  END IF; --> IF V_EXISTS = 'Y'
END;

PROCEDURE fire_risk_profile_ext
  /*created by iris bordey 02.04.2003
  **this procedure will extract records for risk_profile of FIRE policies only
  */
  (p_user           gipi_risk_profile.user_id%TYPE,
   p_line_cd        gipi_risk_profile.line_cd%TYPE,
   p_subline_cd     gipi_risk_profile.subline_cd%TYPE,
   p_date_from      gipi_risk_profile.date_from%TYPE,
   p_date_to        gipi_risk_profile.date_to%TYPE,
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
  TYPE grp_tab       IS TABLE OF gipi_risk_profile%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE varchar_varray IS TABLE OF giis_dist_share.trty_name%TYPE;
  --for colleciton variables
  vv_range_to   				number_varray;
  vv_range_from					number_varray;
  tab_polrisk_ext				grp_tab;
  --*-- iris b. 12.12.2003
  --collection to keep premium and tsi per range and share_cd
  vv_index_range    number_varray;
  vv_index_share    number_varray;
  vv_index_prem_amt number_varray;
  vv_index_tsi_amt  number_varray;
  vv_index_count    number_varray;
  vv_index_trty_name varchar_varray;
  v_acct_trty_tp   cg_ref_codes.rv_low_value%TYPE;
  --added by Iris Bordey 12.11.2003
  --To be utilized in inserting amounts to treaty
  vv_trty_share_cd number_varray;
  vv_count		   number_varray;
  vv_trty_name     varchar_varray;
  rec_counter      NUMBER := 0;

  --variables used for testing only
  v_tarfcount                   NUMBER := 0;
  v_polcount                    NUMBER := 0;
  q2_exists						VARCHAR2(1);
BEGIN
  q2_exists := 'N';
  /*Check if records of corresponding parameters exists on gipi_risk_profile*/
  FOR exst IN (SELECT 'EXIST'
                 FROM gipi_risk_profile
		        WHERE line_cd           = NVL(p_line_cd, line_cd)
                  AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
        	      AND all_line_tag      = p_line_tag
        	      AND user_id           = p_user
                  AND TRUNC(date_from)  = TRUNC(p_date_from)
                  AND TRUNC(date_to)    = TRUNC(p_date_to))
  LOOP
    v_exists := 'Y';
	EXIT;
  END LOOP;

  /*if records exists on gipi_risk_profile then perform the necessary scripts
  **to extract records OTHERWISE exit this procedure.*/
  IF v_exists = 'Y' THEN
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
	   IF UPPER(shrtyp.rv_meaning)    = 'RETENTION' THEN
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

	 --by Iris Bordey 12.12.2003
	 --To set up acct_trty type of quota share
	 FOR indx IN (SELECT rv_low_value
                    FROM cg_ref_codes
				   WHERE UPPER(rv_meaning) = 'QUOTA SHARE'
					 AND UPPER(rv_domain)  =  'GIIS_DIST_SHARE.SHARE_TRTY_TYPE')
	 LOOP
	   v_acct_trty_tp := indx.rv_low_value;
	   EXIT;
	 END LOOP;

	 /*Added by iris Bordey 12.11.2003
	 **To initialize vv_share_cd and vv_count
	 **the collection keeps all share_cd of treaty exept quota share
	 */
	 /* rollie 15sep2005
	 ** marked this bulk collect as Q2*/

	 SELECT share_cd, 0, trty_name
	   BULK COLLECT INTO
	        vv_trty_share_cd, vv_count, vv_trty_name
	   FROM giis_dist_share
	  WHERE line_cd = p_line_cd
        AND share_type      = (SELECT rv_low_value
                                 FROM cg_ref_codes
				    	        WHERE UPPER(rv_meaning) = 'TREATY'
					              AND UPPER(rv_domain)  = 'GIIS_DIST_SHARE.SHARE_TYPE')
        AND acct_trty_type <> (SELECT rv_low_value
                                 FROM cg_ref_codes
						        WHERE UPPER(rv_meaning) = 'QUOTA SHARE'
						          AND UPPER(rv_domain)  =  'GIIS_DIST_SHARE.SHARE_TRTY_TYPE');
	 IF SQL%FOUND THEN
	    q2_exists := 'Y';
	 END IF;

	 DELETE FROM gipi_risk_profile
	  WHERE line_cd           = p_line_cd
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to)
		AND tarf_cd IS NOT NULL;

	 UPDATE gipi_risk_profile
	    SET policy_count  = 0,
		    net_retention = 0,
			quota_share   = 0,
			treaty        = 0,
			facultative   = 0,
			treaty2_tsi   = NULL, treaty3_tsi  = NULL,
			treaty4_tsi   = NULL, treaty5_tsi  = NULL,
			treaty6_tsi   = NULL, treaty7_tsi  = NULL,
			treaty8_tsi   = NULL, treaty9_tsi  = NULL,
			treaty10_tsi  = NULL, treaty2_prem = NULL,
			treaty3_prem  = NULL, treaty4_prem = NULL,
			treaty5_prem  = NULL, treaty6_prem = NULL,
			treaty7_prem  = NULL, treaty8_prem = NULL,
			treaty9_prem  = NULL, treaty10_prem= NULL,
			net_retention_tsi = NULL,
			facultative_tsi   = NULL, treaty_tsi = NULL,
			quota_share_tsi   = NULL,
			sec_net_retention_tsi = NULL,
			sec_net_retention_prem = NULL,
			net_retention_cnt      = NULL,
			facultative_cnt        = NULL,
			treaty_cnt    = NULL, treaty2_cnt  = NULL,
			treaty3_cnt   = NULL, treaty4_cnt  = NULL,
			treaty5_cnt   = NULL, treaty6_cnt  = NULL,
			treaty7_cnt   = NULL, treaty8_cnt  = NULL,
			treaty9_cnt   = NULL, treaty10_cnt = NULL,
			quota_share_cnt = NULL,
			sec_net_retention_cnt = NULL,
			trty_name     = NULL, trty6_name     = NULL,
			trty2_name    = NULL, trty7_name     = NULL,
			trty3_name    = NULL, trty8_name     = NULL,
			trty4_name    = NULL, trty9_name     = NULL,
			trty5_name    = NULL, trty10_name    = NULL
	  WHERE line_cd           = p_line_cd
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to);
	 COMMIT;

	 --to set the range in place

	 /* rollie 15sep2005
	 ** marked this bulk collect as Q3
	 ** vv_range_from, vv_range_to
	 */
	 SELECT range_from, range_to
	   BULK COLLECT INTO vv_range_from, vv_range_to
	   FROM gipi_risk_profile
	  WHERE line_cd           = NVL(p_line_cd, line_cd)
        AND NVL(subline_cd,1) = NVL(p_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = p_line_tag
	    AND user_id           = p_user
        AND TRUNC(date_from)  = TRUNC(p_date_from)
        AND TRUNC(date_to)    = TRUNC(p_date_to)
        ORDER BY range_to ASC;
     vv_index_trty_name := varchar_varray();
	 IF SQL%FOUND THEN
	    --this two procedure is to populate tables gipi_polrisk_ext1 and gipi_sharisk_ext2
		--gipi_polrisk_ext1 stores all policies that
		get_poldist_ext(NVL(p_line_cd,'%'),NVL(p_subline_cd,'%'),p_basis,p_date_from,p_date_to);
  		get_share_ext;

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
		  rec_counter := 0;
		  FOR rec IN vv_range_to.FIRST..vv_range_to.LAST LOOP
		    /*Added by Iris Bordey 12.12.2003
     	    **To initialize the collection that will keep the tsi and premum
	        **per range and share_cd. To be utilized in populating treaty collection
	        */
			/* rollie 15sep2005
			** validate if array vv_trty_share_cd is not null
			**
	        */
			IF q2_exists = 'Y' THEN
		       FOR indx2 IN vv_trty_share_cd.FIRST..vv_trty_share_cd.LAST LOOP
		          rec_counter                    := rec_counter + 1;
			      vv_index_range(rec_counter)    := rec;
			      vv_index_share(rec_counter)    := vv_trty_share_cd(indx2);
			      vv_index_prem_amt(rec_counter) := 0;
			      vv_index_tsi_amt(rec_counter)  := 0;
			      vv_index_count(rec_counter)    := 0;
				  vv_index_trty_name.EXTEND(1);
				  vv_index_trty_name(rec_counter):= vv_trty_name(indx2);
		       END LOOP;
			END IF;

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

			tab_polrisk_ext(rec).trty_name       := NULL;   tab_polrisk_ext(rec).trty2_name      := NULL;
			tab_polrisk_ext(rec).trty3_name      := NULL;   tab_polrisk_ext(rec).trty4_name      := NULL;
			tab_polrisk_ext(rec).trty5_name      := NULL;   tab_polrisk_ext(rec).trty6_name      := NULL;
			tab_polrisk_ext(rec).trty7_name      := NULL;   tab_polrisk_ext(rec).trty8_name      := NULL;
			tab_polrisk_ext(rec).trty9_name      := NULL;   tab_polrisk_ext(rec).trty10_name     := NULL;
		  END LOOP; --end of loop for initialization
		  FOR pol IN --policies to be processed
			         (SELECT a.line_cd, 	  		 a.subline_cd,				a.iss_cd,
     	  	                 a.issue_yy,			 a.pol_seq_no,				a.renew_no, b.item_no,
      	                     c.share_cd,		     c.acct_trty_type,          c.share_type,
     	                     Get_Item_Ann_Tsi(a.line_cd, a.subline_cd, a.iss_cd, a.issue_yy, a.pol_seq_no,
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
						 AND a.user_id    = c.user_id
						 AND a.user_id    = USER
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
			FOR rec IN vv_range_to.FIRST..vv_range_to.LAST LOOP
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
				       /*Added by Iris Bordey 12.12.2003
				       **Loop for each vv_share_cd.  vv_share_cd holds share_cd from giis_dist_share
				       **of treaty only (trty_type = 2) -- excluding quota_share.
				       **Purpose of the script is to collect/determine used treaty share_cd cd.
				       */
					   /* rollie 15sep2005
					   ** validate if array vv_trty_share_cd is not null
					   **
	 				   */
					   IF q2_exists = 'Y' THEN
					      FOR trty IN vv_trty_share_cd.FIRST..vv_trty_share_cd.LAST LOOP
					          IF pol.share_cd = vv_trty_share_cd(trty) THEN
						         vv_count(trty)    := vv_count(trty)    + 1;
						      END IF;
					       END LOOP;
					   END IF;

				       /*to keep tsi amd prem summation for each range and trty share_cd*/
				       FOR x IN vv_index_range.FIRST..vv_index_range.LAST LOOP
				         IF vv_index_range(x) = rec AND
					        vv_index_share(x) = pol.share_cd THEN
					        vv_index_prem_amt(x) := vv_index_prem_amt(x) + NVL(pol.prem_amt,0);
					        vv_index_tsi_amt(x)  := vv_index_tsi_amt(x)  + NVL(pol.tsi_amt,0);
	 				        vv_index_count(x)    := vv_index_count(x)    + 1;
					     END IF;
				       END LOOP;
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

		  /*Added by Iris Bordey 12.12.2003
	      **1. The ff. script will populate the collection that will keep the value
	      **   to update treaty tsi and treaty premium on gipi_risk_profile.
  	      **2. Rec_counter identifies the column to populate. For ex. rec_counter = 1 will
	      **   populate treaty_tsi, rec_counter = 2 to populate treaty2_tsi and so on...
	      **3. vv_index_range(grp) determines the rec. num to populate or to which
	      **   range it will be populated.
	      */
	      rec_counter := 0;
	      IF q2_exists = 'Y' THEN
				  FOR rec IN vv_trty_share_cd.FIRST..vv_trty_share_cd.LAST LOOP
		            IF vv_count(rec) <> 0 THEN
			           rec_counter := rec_counter + 1;
				       FOR grp IN vv_index_range.FIRST..vv_index_range.LAST LOOP
				         IF vv_trty_share_cd(rec) = vv_index_share(grp) THEN
					        IF rec_counter = 1 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty
						          := tab_polrisk_ext(vv_index_range(grp)).treaty + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 2 THEN
		   			           tab_polrisk_ext(vv_index_range(grp)).treaty2_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty2_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty2_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty2_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty2_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty2_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty2_name := vv_index_trty_name(grp);
		                    ELSIF  rec_counter = 3 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty3_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty3_prem + vv_index_prem_amt(grp);
		  				       tab_polrisk_ext(vv_index_range(grp)).treaty3_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty3_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty3_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty3_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty3_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 4 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty4_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty4_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty4_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty4_cnt + vv_index_count(grp);
					           tab_polrisk_ext(vv_index_range(grp)).treaty4_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty4_tsi + vv_index_tsi_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).trty_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 5 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty5_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty5_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty5_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty5_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty5_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty5_tsi + vv_index_tsi_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).trty5_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 6 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty6_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty6_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty6_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty6_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty6_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty6_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty6_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 7 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty7_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty7_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty7_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty7_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty7_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty7_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty7_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 8 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty8_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty8_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty8_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty8_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty8_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty8_tsi + vv_index_tsi_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).trty8_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 9 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty9_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty9_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty9_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty9_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty9_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty9_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty9_name := vv_index_trty_name(grp);
					        ELSIF  rec_counter = 10 THEN
					           tab_polrisk_ext(vv_index_range(grp)).treaty10_prem
						          := tab_polrisk_ext(vv_index_range(grp)).treaty10_prem + vv_index_prem_amt(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty10_cnt
						          := tab_polrisk_ext(vv_index_range(grp)).treaty10_cnt + vv_index_count(grp);
						       tab_polrisk_ext(vv_index_range(grp)).treaty10_tsi
						          := tab_polrisk_ext(vv_index_range(grp)).treaty10_tsi + vv_index_tsi_amt(grp);
							   tab_polrisk_ext(vv_index_range(grp)).trty10_name := vv_index_trty_name(grp);
					        END IF;
					     END IF;
				       END LOOP;
				     END IF;
			      END LOOP;
			END IF;

		  DBMS_OUTPUT.PUT_LINE(tarf.tarf_cd||'-'||v_tarfcount);
		  v_tarfcount := 0;
		  --start insertion of collected records to gipi_risk_profile
		  --v_polcount resets per tariff.  This is to insure that there are policies queried before inserting.
		  IF v_polcount != 0 THEN
		     FOR risk IN tab_polrisk_ext.FIRST..tab_polrisk_ext.LAST LOOP
		       INSERT INTO gipi_risk_profile
		         (line_cd, subline_cd, user_id, range_from, range_to, policy_count, net_retention,quota_share,
			      treaty, facultative,date_from, date_to, all_line_tag,treaty2_tsi, treaty3_tsi,treaty4_tsi,
			      treaty5_tsi,treaty6_tsi,treaty7_tsi,treaty8_tsi,treaty9_tsi,treaty10_tsi,treaty2_prem,
  			      treaty3_prem,treaty4_prem,treaty5_prem,treaty6_prem,treaty7_prem,treaty8_prem,treaty9_prem,
                  treaty10_prem, net_retention_tsi, facultative_tsi, treaty_tsi, quota_share_tsi,
			      sec_net_retention_tsi,sec_net_retention_prem,net_retention_cnt, facultative_cnt,
			      treaty_cnt,treaty2_cnt, treaty3_cnt,treaty4_cnt, treaty5_cnt, treaty6_cnt, treaty7_cnt,
			      treaty8_cnt, treaty9_cnt, treaty10_cnt,quota_share_cnt, sec_net_retention_cnt,
			      tarf_cd, trty_name,trty2_name,trty3_name,trty4_name,trty5_name,trty6_name,
				  trty7_name,trty8_name,trty9_name,trty10_name)
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
			      tab_polrisk_ext(risk).tarf_cd, tab_polrisk_ext(risk).trty_name,tab_polrisk_ext(risk).trty2_name,
				  tab_polrisk_ext(risk).trty3_name,tab_polrisk_ext(risk).trty4_name,tab_polrisk_ext(risk).trty5_name,
				  tab_polrisk_ext(risk).trty6_name,tab_polrisk_ext(risk).trty7_name,tab_polrisk_ext(risk).trty8_name,
				  tab_polrisk_ext(risk).trty9_name,tab_polrisk_ext(risk).trty10_name);
		     END LOOP;
		     COMMIT;
		  END IF;
		END LOOP; --end of tarf (break by tariff)
     END IF; --end of if sql%found
  ELSE
     NULL;
  END IF; --end if for "if rec. exists on gipi_risk_profile"
END;

PROCEDURE risk_profile_ext
 /*  this procedure extracts the tsi and prem amts of all policies
     per line/subline. result is grouped by the range
	 from gipi_risk_profile table.
 */
 (v_user           gipi_risk_profile.user_id%TYPE,
  v_line_cd        gipi_risk_profile.line_cd%TYPE,
  v_subline_cd     gipi_risk_profile.subline_cd%TYPE,
  v_date_from      gipi_risk_profile.date_from%TYPE,
  v_date_to        gipi_risk_profile.date_to%TYPE,
  v_basis          VARCHAR2,
  v_line_tag	   VARCHAR2)
  IS
  counter 	   	   NUMBER:=0;
  v_policy_count   NUMBER := 0;
  rec_counter      NUMBER := 0;
  v_exist          VARCHAR2(1) := 'N';
  v_policy_no      VARCHAR2(50);
  TYPE grp_tab       IS TABLE OF gipi_risk_profile%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE number_varray IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  TYPE varchar_varray IS TABLE OF giis_dist_share.trty_name%TYPE;
  ext_risk_row     grp_tab;
  range_to         number_varray;
  range_from       number_varray;
  share_cd         number_varray;
  tsi_amt          number_varray;
  prem_amt         number_varray;
  POLICY           number_varray;
  --added by Iris Bordey 12.11.2003
  --To be utilized in inserting amounts to treaty
  vv_trty_share_cd number_varray;
  vv_count		   number_varray;
  vv_trty_name	   varchar_varray;
  --*-- iris b. 12.12.2003
  --collection to keep premium and tsi per range and share_cd
  vv_index_range    number_varray;
  vv_index_share    number_varray;
  vv_index_prem_amt number_varray;
  vv_index_tsi_amt  number_varray;
  vv_index_count    number_varray;
  vv_index_trty_name varchar_varray;
  v_acct_trty_tp   cg_ref_codes.rv_low_value%TYPE;

  TYPE rc_type  IS REF CURSOR;
  rc               rc_type;
  v_policy_id      gipi_polbasic.policy_id%TYPE;
  v_pol_tsi        gipi_polbasic.tsi_amt%TYPE;
  v_share_cd       giis_dist_share.share_cd%TYPE;
  v_prem_amt       gipi_polbasic.prem_amt%TYPE;
  v_tsi_amt        gipi_polbasic.tsi_amt%TYPE;
  v_acct_trty_type giis_dist_share.acct_trty_type%TYPE;
  v_share_type	   giis_dist_share.share_type%TYPE;
  v_reten_shr_cd   giis_parameters.param_value_n%TYPE;
  v_facul_shr_cd   giis_parameters.param_value_n%TYPE;
  v_reten_shr_tp   giis_dist_share.share_type%TYPE;--
  v_facul_shr_tp   giis_dist_share.share_type%TYPE;--
  v_trty_shr_tp	   giis_dist_share.share_type%TYPE;--
  -- USED FOR COMPARISON WITH V_POLICY_NO --
  var_policy_no    VARCHAR2(50);
  v_pol_cntr	   NUMBER;
  CURSOR net_ret_facul IS
    SELECT param_value_n, param_name
      FROM giis_parameters
     WHERE param_name IN ('NET_RETENTION','FACULTATIVE');
  CURSOR share_type_cd IS
    SELECT rv_low_value, rv_meaning
      FROM cg_ref_codes
     WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE';

  q4_exists			 VARCHAR2(1);
  q5_exists			 VARCHAR2(1);
BEGIN
  q4_exists := 'N';
  q5_exists	:= 'N';
  DBMS_OUTPUT.PUT_LINE('START  : '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
  FOR a IN (SELECT 1
              FROM gipi_risk_profile
             WHERE line_cd           = NVL(v_line_cd, line_cd)
               AND NVL(subline_cd,1) = NVL(v_subline_cd,NVL(subline_cd,1))
        	   AND all_line_tag = v_line_tag
        	   AND user_id = v_user
               AND TRUNC(date_from) = TRUNC(v_date_from)
               AND TRUNC(date_to) = TRUNC(v_date_to)
  )LOOP
    v_exist := 'Y';
    EXIT;
  END LOOP;
  DBMS_OUTPUT.PUT_LINE('CHECK EXISTS: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
  IF v_exist = 'Y' THEN
    /* SET UP THE COLUMNS TO BE USED PER SHARE_CD */
	 FOR indx IN net_ret_facul LOOP
       IF indx.param_name = 'NET_RETENTION' THEN
	      v_reten_shr_cd := indx.param_value_n;
	   ELSIF indx.param_name = 'FACULTATIVE' THEN
	      v_facul_shr_cd := indx.param_value_n;
	   ELSE v_reten_shr_cd := NULL;
            v_facul_shr_cd := NULL;
	   END IF;
	 END LOOP;
	 /*SET UP THE SHARE TYPE CODES USED */  --BDARUSIN
	 FOR indx2 IN share_type_cd LOOP
       IF UPPER(indx2.rv_meaning) = 'RETENTION' THEN
	      v_reten_shr_tp := SUBSTR(indx2.rv_low_value,1,1);
	   ELSIF UPPER(indx2.rv_meaning) = 'TREATY' THEN
	      v_trty_shr_tp := SUBSTR(indx2.rv_low_value,1,1);
	   ELSIF UPPER(indx2.rv_meaning) = 'FACULTATIVE' THEN
	      v_facul_shr_tp := SUBSTR(indx2.rv_low_value,1,1);
	   ELSE v_reten_shr_tp := NULL;
	        v_trty_shr_tp  := NULL;
            v_facul_shr_tp := NULL;
	   END IF;
	 END LOOP;
	 --by Iris Bordey 12.12.2003
	 --To set up acct_trty type of quota share
	 FOR indx IN (SELECT rv_low_value
                    FROM cg_ref_codes
				   WHERE UPPER(rv_meaning) = 'QUOTA SHARE'
					 AND UPPER(rv_domain)  =  'GIIS_DIST_SHARE.SHARE_TRTY_TYPE')
	 LOOP
	   v_acct_trty_tp := indx.rv_low_value;
	   EXIT;
	 END LOOP;
	 /* by Iris Bordey  12.12.2003
	 ** TO SET THE RANGE IN PLACE */
	 /* rollie 15sep2005
	 ** marked this bulk collect as Q4*/
	 SELECT range_from, range_to
	   BULK COLLECT INTO
	        range_from, range_to
       FROM gipi_risk_profile a
      WHERE a.line_cd           = NVL(v_line_cd, a.line_cd)
        AND NVL(a.subline_cd,1) = NVL(v_subline_cd,NVL(a.subline_cd,1))
	    AND a.all_line_tag = v_line_tag
	    AND a.user_id = v_user
        AND TRUNC(a.date_from) = TRUNC(v_date_from)
        AND TRUNC(a.date_to) = TRUNC(v_date_to)
      ORDER BY range_from ASC;
	 IF SQL%FOUND THEN
	    q4_exists := 'Y';
     END IF;

	 /*Added by iris Bordey 12.11.2003
	 **To initialize vv_share_cd and vv_count
	 **the collection keeps all share_cd of treaty exept quota share
	 */
	 /* rollie 15sep2005
	 ** marked this bulk collect as Q5*/
	 SELECT share_cd, 0, trty_name
	   BULK COLLECT INTO
	        vv_trty_share_cd, vv_count, vv_trty_name
	   FROM giis_dist_share
	  WHERE line_cd = v_line_cd
        AND share_type      = (SELECT rv_low_value
                                 FROM cg_ref_codes
				    	        WHERE UPPER(rv_meaning) = 'TREATY'
					              AND UPPER(rv_domain)  = 'GIIS_DIST_SHARE.SHARE_TYPE')
        AND acct_trty_type <> (SELECT rv_low_value
                                 FROM cg_ref_codes
						        WHERE UPPER(rv_meaning) = 'QUOTA SHARE'
						          AND UPPER(rv_domain)  =  'GIIS_DIST_SHARE.SHARE_TRTY_TYPE');
	 IF SQL%FOUND THEN
	    q5_exists := 'Y';
     END IF;

     rec_counter := 0;

	 DELETE FROM gipi_risk_profile
	  WHERE line_cd           = v_line_cd
        AND NVL(subline_cd,1) = NVL(v_subline_cd,NVL(subline_cd,1))
	    AND all_line_tag      = v_line_tag
	    AND user_id           = v_user
        AND TRUNC(date_from)  = TRUNC(v_date_from)
        AND TRUNC(date_to)    = TRUNC(v_date_to)
		AND tarf_cd IS NOT NULL;
	 COMMIT;
	 /* TRANSFER RANGE TO COLLECTION TO ROWTYPE BECAUSE BULK COLLECT DOES NOT WORK ON RECORD TYPES */
     DBMS_OUTPUT.PUT_LINE('TRANSFER FROM BULK: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
     vv_index_trty_name   := varchar_varray();

	 IF q4_exists = 'Y' THEN
		 FOR indx IN range_to.FIRST..range_to.LAST LOOP
		   /*Added by Iris Bordey 12.12.2003
		   **To initialize the collection that will keep the tsi and premum
		   **per range and share_cd. To be utilized in populating treaty collection
		   */

		   IF q5_exists = 'Y' THEN
			  FOR indx2 IN vv_trty_share_cd.FIRST..vv_trty_share_cd.LAST LOOP
			     rec_counter := rec_counter + 1;
				 vv_index_range(rec_counter)    := indx;
				 vv_index_share(rec_counter)    := vv_trty_share_cd(indx2);
				 vv_index_trty_name.EXTEND(1);
				 vv_index_trty_name(rec_counter) := vv_trty_name(indx2);
				 vv_index_prem_amt(rec_counter) := 0;
				 vv_index_tsi_amt(rec_counter)  := 0;
				 vv_index_count(rec_counter)    := 0;
			  END LOOP;
		   END IF;

	       ext_risk_row(indx).range_to := range_to(indx);
		   ext_risk_row(indx).range_from := range_from(indx);
	      -- INITIALIZATION OF COLLECTIONS --
	       ext_risk_row(indx).policy_count  :=0;	     ext_risk_row(indx).treaty_tsi  :=0;
	       ext_risk_row(indx).treaty2_tsi   :=0;      ext_risk_row(indx).treaty3_tsi :=0;
	       ext_risk_row(indx).treaty4_tsi   :=0;      ext_risk_row(indx).treaty5_tsi :=0;
	       ext_risk_row(indx).treaty6_tsi   :=0;      ext_risk_row(indx).treaty7_tsi :=0;
	       ext_risk_row(indx).treaty8_tsi   :=0;      ext_risk_row(indx).treaty9_tsi :=0;
	       ext_risk_row(indx).treaty10_tsi  :=0;      ext_risk_row(indx).treaty      :=0;
	       ext_risk_row(indx).treaty2_prem  :=0;      ext_risk_row(indx).treaty3_prem:=0;
	       ext_risk_row(indx).treaty4_prem  :=0;      ext_risk_row(indx).treaty5_prem:=0;
	       ext_risk_row(indx).treaty6_prem  :=0;      ext_risk_row(indx).treaty7_prem:=0;
	       ext_risk_row(indx).treaty8_prem  :=0;      ext_risk_row(indx).treaty9_prem:=0;
	       ext_risk_row(indx).treaty10_prem :=0;      ext_risk_row(indx).treaty_cnt  :=0;
	       ext_risk_row(indx).treaty2_cnt   :=0;      ext_risk_row(indx).treaty3_cnt :=0;
	       ext_risk_row(indx).treaty4_cnt   :=0;      ext_risk_row(indx).treaty5_cnt :=0;
	       ext_risk_row(indx).treaty6_cnt   :=0;      ext_risk_row(indx).treaty7_cnt :=0;
	       ext_risk_row(indx).treaty8_cnt   :=0;      ext_risk_row(indx).treaty9_cnt :=0;
	       ext_risk_row(indx).treaty10_cnt  :=0;      ext_risk_row(indx).net_retention     :=0;
	       ext_risk_row(indx).net_retention_tsi:=0;   ext_risk_row(indx).net_retention_cnt :=0;
	       ext_risk_row(indx).facultative   :=0;      ext_risk_row(indx).facultative_tsi   :=0;
	       ext_risk_row(indx).facultative_cnt:=0;	  ext_risk_row(indx).quota_share	   :=0;
		   ext_risk_row(indx).quota_share_tsi :=0;	  ext_risk_row(indx).quota_share_cnt :=0;
		   ext_risk_row(indx).sec_net_retention_tsi := 0;
		   ext_risk_row(indx).sec_net_retention_prem := 0;
		   ext_risk_row(indx).sec_net_retention_cnt := 0;
		   ext_risk_row(indx).trty_name := NULL;      ext_risk_row(indx).trty2_name := NULL;
		   ext_risk_row(indx).trty3_name := NULL;     ext_risk_row(indx).trty4_name := NULL;
		   ext_risk_row(indx).trty5_name := NULL;     ext_risk_row(indx).trty6_name := NULL;
		   ext_risk_row(indx).trty7_name := NULL;     ext_risk_row(indx).trty8_name := NULL;
		   ext_risk_row(indx).trty9_name := NULL;     ext_risk_row(indx).trty10_name := NULL;
	     END LOOP;
	 END IF;

     get_poldist_ext(NVL(v_line_cd,'%'),NVL(v_subline_cd,'%'),v_basis,v_date_from,v_date_to);
     get_share_ext;

     FOR rc IN
       (SELECT a.line_cd, 	  		 a.subline_cd,				a.iss_cd,
     	       a.issue_yy,			 a.pol_seq_no,				a.renew_no,
      	       c.share_cd,		     c.acct_trty_type,          c.share_type,
     	       a.ann_tsi_amt pol_tsi,
     	       SUM(b.dist_prem) prem_amt,
     	       SUM(DECODE(c.peril_type,'B',b.dist_tsi,0)) tsi_amt
          FROM gipi_polrisk_ext1 a,
               giuw_itemperilds_dtl b,
     	       gipi_sharisk_ext2 c
         WHERE a.policy_id >= 0
           AND a.dist_no = b.dist_no
           AND a.line_cd = b.line_cd
           AND b.line_cd = c.line_cd
           AND b.peril_cd = c.peril_cd
           AND b.share_cd = c.share_cd
		   AND a.user_id  = c.user_id
		   AND a.user_id  = USER
         GROUP BY a.line_cd,  	 a.subline_cd,			a.iss_cd,
      	       a.issue_yy,	 a.pol_seq_no,			a.renew_no,
      	       c.share_cd,	 c.acct_trty_type,      c.share_type,
     		   a.ann_tsi_amt)
	 LOOP
	   v_policy_no      := rc.line_cd||rc.subline_cd||rc.iss_cd||rc.issue_yy||rc.pol_seq_no||rc.renew_no;
	   v_share_cd       := rc.share_cd;
	   v_acct_trty_type := rc.acct_trty_type;
	   v_share_type     := rc.share_type;
	   v_pol_tsi        := rc.pol_tsi;
	   v_prem_amt       := rc.prem_amt;
	   v_tsi_amt        := rc.tsi_amt;
       counter          := counter + 1;  --JUST WANT TO CHECK HOW MANY RECORDS WERE PROCESSED
	   v_pol_cntr       := 0;

	   IF var_policy_no <> v_policy_no OR var_policy_no IS NULL THEN
		  v_pol_cntr := 1;
	   ELSIF var_policy_no = v_policy_no THEN
		  v_pol_cntr := 0;
	   END IF;
       -- POLICYNO BEING PROCESSED IS ALREADY A DIFFERENT POLICY
       var_policy_no := v_policy_no;
       IF q4_exists = 'Y' THEN
	      FOR indx IN ext_risk_row.FIRST..ext_risk_row.LAST LOOP
	      --if within the range
		    IF v_pol_tsi >= ext_risk_row(indx).range_from AND
			   v_pol_tsi <= ext_risk_row(indx).range_to THEN
               ext_risk_row(indx).policy_count := NVL(ext_risk_row(indx).policy_count,0) + v_pol_cntr;
               IF v_share_type  = v_reten_shr_tp THEN
			   	  IF v_share_cd = v_reten_shr_cd THEN
			      	 ext_risk_row(indx).net_retention     := ext_risk_row(indx).net_retention     + NVL(v_prem_amt,0);
				  	 ext_risk_row(indx).net_retention_tsi := ext_risk_row(indx).net_retention_tsi + NVL(v_tsi_amt,0);
				  	 ext_risk_row(indx).net_retention_cnt := ext_risk_row(indx).net_retention_cnt + 1;
			   	  ELSE
			      	 ext_risk_row(indx).sec_net_retention_prem := ext_risk_row(indx).sec_net_retention_prem + NVL(v_prem_amt,0);
				  	 ext_risk_row(indx).sec_net_retention_tsi  := ext_risk_row(indx).sec_net_retention_tsi  + NVL(v_tsi_amt,0);
				  	 ext_risk_row(indx).sec_net_retention_cnt  := ext_risk_row(indx).sec_net_retention_cnt  + 1;
			   	  END IF;
		       ELSIF v_share_type = v_facul_shr_tp THEN
			      IF v_share_cd   = v_facul_shr_cd THEN
			      	 ext_risk_row(indx).facultative     := ext_risk_row(indx).facultative     + NVL(v_prem_amt,0);
				  	 ext_risk_row(indx).facultative_tsi := ext_risk_row(indx).facultative_tsi + NVL(v_tsi_amt,0);
				  	 ext_risk_row(indx).facultative_cnt := ext_risk_row(indx).facultative_cnt + 1;
			   	  END IF;
			   ELSIF v_share_type = v_trty_shr_tp THEN
			   	  --Separate Quota Share to other Treaty.
			   	  IF v_acct_trty_type = v_acct_trty_tp THEN
				  	 ext_risk_row(indx).quota_share     := ext_risk_row(indx).quota_share     + NVL(v_prem_amt,0);
				  	 ext_risk_row(indx).quota_share_tsi := ext_risk_row(indx).quota_share_tsi + NVL(v_tsi_amt,0);
				  	 ext_risk_row(indx).quota_share_cnt := ext_risk_row(indx).quota_share_cnt + 1;
		       	  ELSE
			      /*Added by Iris Bordey 12.12.2003
				  **Loop for each vv_share_cd.  vv_share_cd holds share_cd from giis_dist_share
				  **of treaty only (trty_type = 2) -- excluding quota_share.
				  **Purpose of the script is to collect/determine used treaty share_cd cd.
				  */
				  	 IF q5_exists = 'Y' THEN
						FOR trty IN vv_trty_share_cd.FIRST..vv_trty_share_cd.LAST LOOP
					       IF v_share_cd = vv_trty_share_cd(trty) THEN
						   	  vv_count(trty)    := vv_count(trty)    + 1;
						   END IF;
					    END LOOP;
					 END IF;

				  	 /*to keep tsi amd prem summation for each range and trty share_cd*/
				  	 FOR x IN vv_index_range.FIRST..vv_index_range.LAST LOOP
				     	 IF vv_index_range(x) = indx AND vv_index_share(x) = v_share_cd THEN
					   	 	vv_index_prem_amt(x) := vv_index_prem_amt(x) + NVL(v_prem_amt,0);
					   		vv_index_tsi_amt(x)  := vv_index_tsi_amt(x)  + NVL(v_tsi_amt,0);
					   		vv_index_count(x)    := vv_index_count(x)    + 1;
					     END IF;
				  	 END LOOP;
			      END IF; --end for acct_trty_type
  			   END IF;--end for each share_type
            END IF; --end if it is within range
	      END LOOP; --LOOP per range
	   END IF;
     END LOOP;--LOOP per policy

	 /*Added by Iris Bordey 12.12.2003
	 **1. The ff. script will populate the collection that will keep the value
	 **   to update treaty tsi and treaty premium on gipi_risk_profile.
	 **2. Rec_counter identifies the column to populate. For ex. rec_counter = 1 will
	 **   populate treaty_tsi, rec_counter = 2 to populate treaty2_tsi and so on...
	 **3. vv_index_range(grp) determines the rec. num to populate or to which
	 **   range it will be populated.
	 */
	 rec_counter := 0;
	 IF q5_exists = 'Y' THEN
		 FOR rec IN vv_trty_share_cd.FIRST..vv_trty_share_cd.LAST LOOP
	       IF vv_count(rec) <> 0 THEN
		      rec_counter := rec_counter + 1;
			  IF q4_exists = 'Y' THEN
				  FOR grp IN vv_index_range.FIRST..vv_index_range.LAST LOOP
				    IF vv_trty_share_cd(rec) = vv_index_share(grp) THEN
					   IF rec_counter = 1 THEN
					      ext_risk_row(vv_index_range(grp)).treaty
						     := ext_risk_row(vv_index_range(grp)).treaty + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 2 THEN
					      ext_risk_row(vv_index_range(grp)).treaty2_prem
						     := ext_risk_row(vv_index_range(grp)).treaty2_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty2_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty2_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty2_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty2_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty2_name := vv_index_trty_name(grp);
		               ELSIF  rec_counter = 3 THEN
					      ext_risk_row(vv_index_range(grp)).treaty3_prem
						     := ext_risk_row(vv_index_range(grp)).treaty3_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty3_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty3_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty3_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty3_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty3_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 4 THEN
					      ext_risk_row(vv_index_range(grp)).treaty4_prem
						     := ext_risk_row(vv_index_range(grp)).treaty4_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty4_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty4_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty4_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty4_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty4_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 5 THEN
					      ext_risk_row(vv_index_range(grp)).treaty5_prem
						     := ext_risk_row(vv_index_range(grp)).treaty5_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty5_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty5_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty5_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty5_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty5_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 6 THEN
					      ext_risk_row(vv_index_range(grp)).treaty6_prem
						     := ext_risk_row(vv_index_range(grp)).treaty6_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty6_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty6_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty6_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty6_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty6_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 7 THEN
					      ext_risk_row(vv_index_range(grp)).treaty7_prem
						     := ext_risk_row(vv_index_range(grp)).treaty7_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty7_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty7_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty7_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty7_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty7_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 8 THEN
					      ext_risk_row(vv_index_range(grp)).treaty8_prem
						     := ext_risk_row(vv_index_range(grp)).treaty8_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty8_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty8_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty8_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty8_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty8_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 9 THEN
					      ext_risk_row(vv_index_range(grp)).treaty9_prem
						     := ext_risk_row(vv_index_range(grp)).treaty9_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty9_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty9_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty9_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty9_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty9_name := vv_index_trty_name(grp);
					   ELSIF  rec_counter = 10 THEN
					      ext_risk_row(vv_index_range(grp)).treaty10_prem
						     := ext_risk_row(vv_index_range(grp)).treaty10_prem + vv_index_prem_amt(grp);
						  ext_risk_row(vv_index_range(grp)).treaty10_cnt
						     := ext_risk_row(vv_index_range(grp)).treaty10_cnt + vv_index_count(grp);
						  ext_risk_row(vv_index_range(grp)).treaty10_tsi
						     := ext_risk_row(vv_index_range(grp)).treaty10_tsi + vv_index_tsi_amt(grp);
						  ext_risk_row(vv_index_range(grp)).trty10_name := vv_index_trty_name(grp);
					   END IF;
					END IF;
				  END LOOP;
				END IF;
			END IF;
		 END LOOP;
	 END IF;
     -- if table gipi_risk_profile is changed to accomodate 2nd ret, here is where it
	 -- should be changed
     DBMS_OUTPUT.PUT_LINE('START 4: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
     DBMS_OUTPUT.PUT_LINE('TOTAL ROWS PROCESSED: '||TO_CHAR(counter));
     DBMS_OUTPUT.PUT_LINE('EXT_RISK_ROW.FIRST: '||TO_CHAR(ext_risk_row.FIRST));
     DBMS_OUTPUT.PUT_LINE('EXT_RISK_ROW.LAST: '||TO_CHAR(ext_risk_row.LAST));
     FOR transfer IN ext_risk_row.FIRST..ext_risk_row.LAST LOOP
       UPDATE gipi_risk_profile
	   SET policy_count = ext_risk_row(transfer).policy_count,
	   treaty_tsi    = ext_risk_row(transfer).treaty_tsi,
	   treaty2_tsi   = ext_risk_row(transfer).treaty2_tsi,
	   treaty3_tsi   = ext_risk_row(transfer).treaty3_tsi,
	   treaty4_tsi   = ext_risk_row(transfer).treaty4_tsi,
	   treaty5_tsi   = ext_risk_row(transfer).treaty5_tsi,
	   treaty6_tsi   = ext_risk_row(transfer).treaty6_tsi,
	   treaty7_tsi   = ext_risk_row(transfer).treaty7_tsi,
	   treaty8_tsi   = ext_risk_row(transfer).treaty8_tsi,
	   treaty9_tsi   = ext_risk_row(transfer).treaty9_tsi,
	   treaty10_tsi  = ext_risk_row(transfer).treaty10_tsi,
	   treaty2_prem  = ext_risk_row(transfer).treaty2_prem,
	   treaty3_prem  = ext_risk_row(transfer).treaty3_prem,
	   treaty4_prem  = ext_risk_row(transfer).treaty4_prem,
	   treaty5_prem  = ext_risk_row(transfer).treaty5_prem,
	   treaty6_prem  = ext_risk_row(transfer).treaty6_prem,
	   treaty7_prem  = ext_risk_row(transfer).treaty7_prem,
	   treaty8_prem  = ext_risk_row(transfer).treaty8_prem,
	   treaty9_prem  = ext_risk_row(transfer).treaty9_prem,
	   treaty10_prem = ext_risk_row(transfer).treaty10_prem,
	   treaty_cnt    = ext_risk_row(transfer).treaty_cnt,
	   treaty2_cnt   = ext_risk_row(transfer).treaty2_cnt,
	   treaty3_cnt   = ext_risk_row(transfer).treaty3_cnt,
	   treaty4_cnt   = ext_risk_row(transfer).treaty4_cnt,
	   treaty5_cnt   = ext_risk_row(transfer).treaty5_cnt,
	   treaty6_cnt   = ext_risk_row(transfer).treaty6_cnt,
 	   treaty7_cnt   = ext_risk_row(transfer).treaty7_cnt,
	   treaty8_cnt   = ext_risk_row(transfer).treaty8_cnt,
	   treaty9_cnt   = ext_risk_row(transfer).treaty9_cnt,
	   treaty10_cnt  = ext_risk_row(transfer).treaty10_cnt,
	   net_retention = ext_risk_row(transfer).net_retention,
	   net_retention_tsi  = ext_risk_row(transfer).net_retention_tsi,
	   net_retention_cnt  = ext_risk_row(transfer).net_retention_cnt,
	   facultative        = ext_risk_row(transfer).facultative,
	   facultative_tsi    = ext_risk_row(transfer).facultative_tsi,
	   facultative_cnt    = ext_risk_row(transfer).facultative_cnt,
	   quota_share		  = ext_risk_row(transfer).quota_share,
	   quota_share_tsi	  = ext_risk_row(transfer).quota_share_tsi,
	   quota_share_cnt	  = ext_risk_row(transfer).quota_share_cnt,
	   treaty			  = ext_risk_row(transfer).treaty,
	   sec_net_retention_prem = ext_risk_row(transfer).sec_net_retention_prem,
	   sec_net_retention_tsi = ext_risk_row(transfer).sec_net_retention_tsi,
	   sec_net_retention_cnt = ext_risk_row(transfer).sec_net_retention_cnt,
	   trty_name             = ext_risk_row(transfer).trty_name,
	   trty2_name             = ext_risk_row(transfer).trty2_name,
	   trty3_name             = ext_risk_row(transfer).trty3_name,
	   trty4_name             = ext_risk_row(transfer).trty4_name,
	   trty5_name             = ext_risk_row(transfer).trty5_name,
	   trty6_name             = ext_risk_row(transfer).trty6_name,
	   trty7_name             = ext_risk_row(transfer).trty7_name,
	   trty8_name             = ext_risk_row(transfer).trty8_name,
	   trty9_name             = ext_risk_row(transfer).trty9_name,
	   trty10_name            = ext_risk_row(transfer).trty10_name
       WHERE range_to = ext_risk_row(transfer).range_to
         AND line_cd           = NVL(v_line_cd, line_cd)
         AND NVL(subline_cd,1) = NVL(v_subline_cd,NVL(subline_cd,1))
  	     AND all_line_tag = v_line_tag
  	     AND user_id = v_user
         AND TRUNC(date_from) = TRUNC(v_date_from)
         AND TRUNC(date_to) = TRUNC(v_date_to);
     COMMIT;
	 END LOOP;
  ELSIF NVL(v_exist,'N') != 'Y' THEN
     NULL;
  END IF;
  DBMS_OUTPUT.PUT_LINE(counter);
  DBMS_OUTPUT.PUT_LINE('END: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
END;

PROCEDURE get_poldist_ext
  /*  this procedure gets the ann_tsi and dist_no of the policy
      being processed and saves the info to the gipi_polrisk_ext1.
  */
  (p_line_cd     gipi_polbasic.line_cd%TYPE,
   p_subline_cd  gipi_polbasic.subline_cd%TYPE,
   p_basis       VARCHAR2,
   p_date_from   DATE,
   p_date_to     DATE)
IS
  TYPE policy_id_tab       IS TABLE OF gipi_polbasic.policy_id%TYPE;
  TYPE line_cd_tab         IS TABLE OF gipi_polbasic.line_cd%TYPE;
  TYPE subline_cd_tab      IS TABLE OF gipi_polbasic.subline_cd%TYPE;
  TYPE iss_cd_tab          IS TABLE OF gipi_polbasic.iss_cd%TYPE;
  TYPE issue_yy_tab        IS TABLE OF gipi_polbasic.issue_yy%TYPE;
  TYPE pol_seq_no_tab      IS TABLE OF gipi_polbasic.pol_seq_no%TYPE;
  TYPE renew_no_tab        IS TABLE OF gipi_polbasic.renew_no%TYPE;
  TYPE dist_no_tab         IS TABLE OF giuw_pol_dist.dist_no%TYPE;
  TYPE ann_tsi_tab         IS TABLE OF gipi_polbasic.ann_tsi_amt%TYPE;
  vv_ann_tsi_amt           ann_tsi_tab;
  vv_policy_id			   policy_id_tab;
  vv_line_cd               line_cd_tab;
  vv_subline_cd            subline_cd_tab;
  vv_iss_cd                iss_cd_tab;
  vv_issue_yy              issue_yy_tab;
  vv_pol_seq_no            pol_seq_no_tab;
  vv_renew_no              renew_no_tab;
  vv_dist_no               dist_no_tab;
BEGIN
  DELETE FROM gipi_polrisk_ext1
    WHERE user_id = USER;
  COMMIT;
  SELECT a.policy_id,          a.line_cd, 	  		    a.subline_cd,
         a.iss_cd,             a.issue_yy,			    a.pol_seq_no,
  	     a.renew_no,           b.dist_no,               Get_Ann_Tsi(a.line_cd,
		                                                            a.subline_cd,
																	a.iss_cd,
																	a.issue_yy,
																	a.pol_seq_no,
																	a.renew_no,
																	p_date_from,
																	p_date_to,
																	p_basis)
    BULK COLLECT INTO
	     vv_policy_id,         vv_line_cd, 	  		    vv_subline_cd,
         vv_iss_cd,            vv_issue_yy,			    vv_pol_seq_no,
  	     vv_renew_no,          vv_dist_no,              vv_ann_tsi_amt
    FROM gipi_polbasic a,
         giuw_pol_dist b
   WHERE a.line_cd LIKE  p_line_cd
     AND a.subline_cd LIKE  p_subline_cd
     --> modified by bdarusin 11222002 to include spoiled policies
	 --  if policy is spoiled, check the spld_acct_ent_date
	 /*AND NVL(a.pol_flag,a.pol_flag) IN ('1','2','3','4','X')
     AND Date_Risk(a.acct_ent_date, a.eff_date, a.issue_date, p_basis, p_date_from, p_date_to) = 1*/
     AND Date_Risk(a.acct_ent_date, a.eff_date, a.issue_date, a.booking_mth, a.booking_year,
	     a.spld_acct_ent_date, a.pol_flag, p_basis, p_date_from, p_date_to, a.cancel_date,a.policy_id) = 1
	 -->>
	 --INSERTED BY BDARUSIN 081602
	 --IF POLICY IS NOT WITHIN GIVEN DATE OF PARAMETERS, ITS ENDT WILL NOT BE INCLUDED
	 AND (a.endt_seq_no = 0
	      OR
		  (a.endt_seq_no <> 0
		   AND EXISTS (SELECT 1
              FROM gipi_polbasic c
			 WHERE c.line_cd     = a.line_cd
			   AND c.subline_cd  = a.subline_cd
			   AND c.iss_cd      = a.iss_cd
			   AND c.issue_yy    = a.issue_yy
			   AND c.pol_seq_no  = a.pol_seq_no
			   AND c.renew_no    = a.renew_no
			   AND c.endt_seq_no = 0
  			   --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
			   --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
			   AND Date_Risk(c.acct_ent_date, c.eff_date, c.issue_date,c.booking_mth, c.booking_year,
			       c.spld_acct_ent_date, c.pol_flag, p_basis, p_date_from, p_date_to, c.cancel_date,c.policy_id) = 1)
			))
	 --<< END OF INSERTED STATEMENT BY BDARUSIN, 081602
     AND a.policy_id = b.policy_id
     --AND b.dist_flag = '3';
     AND b.dist_flag = DECODE(a.pol_flag,'5','4','3');--if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
  IF NOT SQL%NOTFOUND THEN
     FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
	   INSERT INTO gipi_polrisk_ext1
         (policy_id,          line_cd, 	  		    subline_cd,
          iss_cd,             issue_yy,			    pol_seq_no,
  	      renew_no,           dist_no,              ann_tsi_amt,
		  user_id)
       VALUES
	     (vv_policy_id(i),    vv_line_cd(i), 	    vv_subline_cd(i),
          vv_iss_cd(i),       vv_issue_yy(i),		vv_pol_seq_no(i),
  	      vv_renew_no(i),     vv_dist_no(i),        vv_ann_tsi_amt(i),
		  USER);
     COMMIT;
  END IF;
END;

PROCEDURE get_share_ext IS
  /*  THIS PROCEDURE GETS THE SHARE_CD, SHARE_TYPE, PERIL_CD, PERIL_TYPE
      AND ACCT_TRTY_TYPE OF THE LINE
	  AND SAVES THE INFO TO THE GIPI_SHARISK_EXT2 TABLE.
  */
  TYPE line_cd_tab         IS TABLE OF giis_peril.line_cd%TYPE;
  TYPE peril_cd_tab        IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE peril_type_tab      IS TABLE OF giis_peril.peril_type%TYPE;
  TYPE share_cd_tab        IS TABLE OF giis_dist_share.share_cd%TYPE;
  TYPE acct_trty_type_tab  IS TABLE OF giis_dist_share.acct_trty_type%TYPE;
  TYPE share_type_tab      IS TABLE OF giis_dist_share.share_type%TYPE;
  vv_line_cd               line_cd_tab;
  vv_peril_cd              peril_cd_tab;
  vv_peril_type            peril_type_tab;
  vv_share_cd              share_cd_tab;
  vv_acct_trty_type        acct_trty_type_tab;
  vv_share_type            share_type_tab;
BEGIN
  DELETE FROM gipi_sharisk_ext2
   WHERE user_id = USER;
  COMMIT;
  SELECT d.line_cd,          d.peril_cd,          d.peril_type,
         e.share_cd,		 e.acct_trty_type,    e.share_type
    BULK COLLECT INTO
	     vv_line_cd,         vv_peril_cd,         vv_peril_type,
         vv_share_cd,		 vv_acct_trty_type,   vv_share_type
    FROM giis_peril d,
         giis_dist_share e
   WHERE d.line_cd = e.line_cd;
  IF NOT SQL%NOTFOUND THEN
     FORALL i IN vv_line_cd.FIRST..vv_line_cd.LAST
       INSERT INTO gipi_sharisk_ext2
         (line_cd,          peril_cd,             peril_type,
          share_cd,		    acct_trty_type,       share_type,
		  user_id)
       VALUES
	     (vv_line_cd(i),    vv_peril_cd(i),       vv_peril_type(i),
          vv_share_cd(i),   vv_acct_trty_type(i), vv_share_type(i),
		  USER);
     COMMIT;
  END IF;
END;

FUNCTION Date_Risk
   /*Modified by Iris Bordey (01.08.2003)
   **Added the parameters p_month and p_year for p_dt_type = 'BD' (booking date)
   **Evaluates booking month and booking year against p_fmdate and p_todate
   **when p_dt_type = 'BD'*/
  /*  this function checks if the acct_ent_date, eff_date, or issue_date
      of the policy is within the given date range
	  revised by bdarusin, 11222002,
	  if extract is by acct_ent_date, include spoiled policies but
	  check the spld_acct_ent_date*/

  /* modified by rollie 15sep2005
  ** if pol_flag='4' check cancel date (p_ct)
  ** if cancel date of the latest endorsement is greater than p_todate then return(1)
     else return(0)
   */

  (p_ad        IN DATE,
   p_ed        IN DATE,
   p_id        IN DATE,
   p_month     IN VARCHAR2,
   p_year      IN NUMBER,
   p_spld_ad   IN DATE,
   p_pol_flag  IN VARCHAR2,
   p_dt_type   IN VARCHAR2,
   p_fmdate    IN DATE,
   p_todate    IN DATE,
   p_ct		   IN DATE,
   p_policy_id IN NUMBER)
  RETURN NUMBER IS
    v_booking_fmdate  DATE;
	v_booking_todate  DATE;
	v_val_pol_flag	  VARCHAR2(1);
	v_line_cd		  gipi_polbasic.line_cd%TYPE;
	v_subline_cd	  gipi_polbasic.subline_cd%TYPE;
	v_iss_cd		  gipi_polbasic.iss_cd%TYPE;
	v_issue_yy		  gipi_polbasic.issue_yy%TYPE;
	v_pol_seq_no	  gipi_polbasic.pol_seq_no%TYPE;
	v_cancel_date	  DATE;
  BEGIN
    v_val_pol_flag := 'N';
    IF p_pol_flag = '5' THEN
	   IF p_dt_type = 'AD' AND TRUNC(p_spld_ad) >= p_fmdate
	      AND TRUNC(p_spld_ad) <= p_todate THEN
	      RETURN (1);
	   ELSE
	      RETURN (0);
	   END IF;
	ELSE
       IF p_dt_type = 'AD' AND TRUNC(p_ad) >= p_fmdate AND TRUNC(p_ad) <= p_todate THEN
	      IF p_pol_flag = '4' THEN
		     v_val_pol_flag := 'Y';
		  ELSE
		     RETURN(1);
		  END IF;
	   ELSIF p_dt_type = 'ED' AND TRUNC(p_ed) >= p_fmdate AND TRUNC(p_ed) <= p_todate THEN
	      IF p_pol_flag = '4' THEN
		     v_val_pol_flag := 'Y';
		  ELSE
		     RETURN(1);
		  END IF;
	   ELSIF p_dt_type = 'ID' AND TRUNC(p_id) >= p_fmdate AND TRUNC(p_id) <= p_todate THEN
	      IF p_pol_flag = '4' THEN
		     v_val_pol_flag := 'Y';
		  ELSE
		     RETURN(1);
		  END IF;
	   ELSIF p_dt_type = 'BD' THEN
	      DBMS_OUTPUT.PUT_LINE('BD');
	      v_booking_fmdate := TO_DATE('01-'||SUBSTR(p_month,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY');
          v_booking_todate := LAST_DAY(TO_DATE('01-'||SUBSTR(p_month,1,3)||'-'||TO_CHAR(p_year),'DD-MON-YYYY'));
	      IF v_booking_fmdate >= p_fmdate AND v_booking_todate <= p_todate THEN
             IF p_pol_flag = '4' THEN
		     	v_val_pol_flag := 'Y';
			 ELSE
		     	RETURN(1);
		  	 END IF;
          ELSE
             RETURN (0);
          END IF;
	   END IF;
	   IF v_val_pol_flag = 'Y' THEN
  	      BEGIN
		  	SELECT cancel_date
		      INTO v_cancel_date
		      FROM gipi_polbasic a,(SELECT line_cd, subline_cd, iss_cd, issue_yy, pol_seq_no, renew_no
           		 	                  FROM gipi_polbasic
                         		     WHERE policy_id=p_policy_id) b
             WHERE a.line_cd    = b.line_cd
		       AND a.subline_cd = b.subline_cd
   			   AND a.iss_cd     = b.iss_cd
   			   AND a.issue_yy   = b.issue_yy
   			   AND a.pol_seq_no = b.pol_seq_no
			   AND a.renew_no   = b.renew_no
   			   AND endt_seq_no  = ( SELECT MAX(endt_seq_no)
                           	   	      FROM gipi_polbasic c
                          		     WHERE c.line_cd 	=  b.line_cd
                            		   AND c.subline_cd = b.subline_cd
                            		   AND c.iss_cd 	= b.iss_cd
                            		   AND c.issue_yy   = b.issue_yy
                            		   AND c.pol_seq_no = b.pol_seq_no
									   AND c.renew_no   = b.renew_no);
		  EXCEPTION
		    WHEN NO_DATA_FOUND THEN
			  NULL;
		  END;
		  IF v_cancel_date <= p_todate THEN
		     RETURN (0);
		  ELSE
		  	 RETURN (1);
		  END IF;

	   END IF;
	   RETURN (0);
	END IF;
  END;

FUNCTION Get_Ann_Tsi
  /*  THIS FUNCTION GETS THE ANN_TSI AMOUNT OF THE LATEST ENDT OF THE POLICY
  */
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
     p_from       DATE,
     p_to         DATE,
	 p_basis	  VARCHAR2)

  RETURN NUMBER IS
    TYPE cur1_type IS REF CURSOR;
    cur1           cur1_type;
    v_ann_tsi      gipi_polbasic.ann_tsi_amt%TYPE;

  BEGIN
    FOR cur1 IN
      (SELECT SUM(y.tsi_amt) tsi_amt
        FROM gipi_polbasic x, gipi_item y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
         AND x.renew_no   = p_renew_no
		 AND x.policy_id  = y.policy_id
         --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
	     --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
         /*AND X.POL_FLAG IN ('1','2','3','4','x')
		 AND DATE_RISK(X.ACCT_ENT_DATE, X.EFF_DATE, X.ISSUE_DATE, P_BASIS, P_FROM, P_TO) = 1*/
		 AND Date_Risk(x.acct_ent_date, x.eff_date, x.issue_date,x.booking_mth,x.booking_year,
		     x.spld_acct_ent_date, x.pol_flag, p_basis, p_from, p_to, x.cancel_date, x.policy_id) = 1
         --AND DIST_FLAG = '3'
         AND dist_flag = DECODE(x.pol_flag,'5','4','3')--IF POL_FLAG IS 5, DIST_FLAG SHLD BE 4, ELSE DIST_FLAG SHLD BE 3
         AND (x.endt_seq_no = 0 OR
             (x.endt_seq_no <> 0
              AND EXISTS (SELECT 1
                       	    FROM gipi_polbasic c
        		           WHERE c.line_cd     = x.line_cd
  		                     AND c.subline_cd  = x.subline_cd
		                     AND c.iss_cd      = x.iss_cd
		                     AND c.issue_yy    = x.issue_yy
          		             AND c.pol_seq_no  = x.pol_seq_no
           		             AND c.renew_no    = x.renew_no
               		         AND c.endt_seq_no = 0
							 --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
							 --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
 	    	         		 /*AND DATE_RISK(C.ACCT_ENT_DATE, C.EFF_DATE,
							   C.ISSUE_DATE, P_BASIS, P_FROM, P_TO) = 1*/
 	    	         		 AND Date_Risk(c.acct_ent_date, c.eff_date,
							   c.issue_date,c.booking_mth, c.booking_year, c.spld_acct_ent_date, c.pol_flag,
							   p_basis, p_from, p_to, c.cancel_date, c.policy_id) = 1
							 ))))
    LOOP
      v_ann_tsi := cur1.tsi_amt;
      EXIT;
    END LOOP;
    RETURN v_ann_tsi;
  END;
  FUNCTION Get_Item_Ann_Tsi
    (p_line_cd    VARCHAR2,
     p_subline_cd VARCHAR2,
     p_iss_cd     VARCHAR2,
     p_issue_yy   NUMBER,
     p_pol_seq_no NUMBER,
     p_renew_no   NUMBER,
	 p_item_no    NUMBER,
     p_from       DATE,
     p_to         DATE,
	 p_basis	  VARCHAR2)
RETURN NUMBER IS
  v_item_ann_tsi			gipi_item.ann_tsi_amt%TYPE := 0;
BEGIN
  FOR tsi IN (SELECT SUM(y.tsi_amt) tsi_amt
                FROM gipi_polbasic x,
		             gipi_item     y
               WHERE 1=1
          	     AND x.policy_id  = y.policy_id
	             AND y.item_no    = p_item_no
                 AND x.line_cd    = p_line_cd
                 AND x.subline_cd = p_subline_cd
                 AND x.iss_cd     = p_iss_cd
                 AND x.issue_yy   = p_issue_yy
                 AND x.pol_seq_no = p_pol_seq_no
                 AND x.renew_no   = p_renew_no
		 		 --> modified by bdarusin 11222002 to include spoiled policies
	     		 --  if policy is spoiled, check the spld_acct_ent_date
		         AND Date_Risk(x.acct_ent_date, x.eff_date, x.issue_date,x.booking_mth,x.booking_year,
		                       x.spld_acct_ent_date, x.pol_flag, p_basis, p_from, p_to, x.cancel_date,
							   x.policy_id) = 1
                 --if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
		         AND dist_flag = DECODE(x.pol_flag,'5','4','3')
                 AND (x.endt_seq_no = 0 OR
                     (x.endt_seq_no <> 0
                     AND EXISTS (SELECT 1 --check if orginal policy exists
                            	   FROM gipi_polbasic c
        		                  WHERE c.line_cd     = x.line_cd
  		                            AND c.subline_cd  = x.subline_cd
		                            AND c.iss_cd      = x.iss_cd
		                            AND c.issue_yy    = x.issue_yy
          		                    AND c.pol_seq_no  = x.pol_seq_no
           		                    AND c.renew_no    = x.renew_no
               		                AND c.endt_seq_no = 0
							        --> modified by bdarusin 11222002 to include spoiled policies
							        --  if policy is spoiled, check the spld_acct_ent_date
 	    	         		        AND Date_Risk(c.acct_ent_date, c.eff_date,
							                                     c.issue_date,c.booking_mth, c.booking_year,
																 c.spld_acct_ent_date, c.pol_flag,
							                                     p_basis, p_from, p_to, c.cancel_date,
																 c.policy_id) = 1)
					 )))
  LOOP
    v_item_ann_tsi := tsi.tsi_amt;
	EXIT;
  END LOOP;
  RETURN(v_item_ann_tsi);
END;
END;
/

DROP PACKAGE BODY CPI.P_RISK_PROFILE_07DEC2005;

