CREATE OR REPLACE PACKAGE BODY CPI.p_risk_profile_flt AS
  /*
    this package is used by the risk profile extract module.
	it uses the tables :
	   gipi_risk_profile,
	   gipi_polrisk_ext1 and
	   gipi_sharisk_ext2.
  */
PROCEDURE Risk_Profile_Ext
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
  new_facul_num    NUMBER := 11;
  v_policy_count   NUMBER := 0;
  rec_counter      NUMBER := 0;
  v_exist          VARCHAR2(1) := 'N';
  v_policy_no      VARCHAR2(50);
  TYPE grp_tab IS TABLE OF gipi_risk_profile%ROWTYPE INDEX BY BINARY_INTEGER;
  TYPE number_varray IS TABLE OF NUMBER INDEX BY BINARY_INTEGER;
  temp_risk_row    grp_tab;
  ext_risk_row     grp_tab;
  grp              grp_tab;
  range_to         number_varray;
  range_from       number_varray;
  share_cd         number_varray;
  tsi_amt          number_varray;
  prem_amt         number_varray;
  policy           number_varray;
  -- FOR USE AS TEMPORARY STORAGE FOR PREMIUMS AND TSI PER POLICY_NO --
  t_share_cd       number_varray;
  t_prem_amt       number_varray;
  t_tsi_amt        number_varray;
  t_count          number_varray;
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
  CURSOR cv IS
    SELECT range_to
      FROM gipi_risk_profile a
     WHERE a.line_cd           = NVL(v_line_cd, a.line_cd)
       AND NVL(a.subline_cd,1) = NVL(v_subline_cd,NVL(a.subline_cd,1))
	   AND a.all_line_tag = v_line_tag
	   AND a.user_id = v_user
       AND TRUNC(a.date_from) = TRUNC(v_date_from)
       AND TRUNC(a.date_to) = TRUNC(v_date_to)
     ORDER BY range_to ASC;  --IMPT
  CURSOR cv2 IS
    SELECT range_from
      FROM gipi_risk_profile a
     WHERE a.line_cd           = NVL(v_line_cd, a.line_cd)
       AND NVL(a.subline_cd,1) = NVL(v_subline_cd,NVL(a.subline_cd,1))
	   AND a.all_line_tag = v_line_tag
	   AND a.user_id = v_user
       AND TRUNC(a.date_from) = TRUNC(v_date_from)
       AND TRUNC(a.date_to) = TRUNC(v_date_to)
     ORDER BY range_to ASC;  --IMPT
  CURSOR net_ret_facul IS
    SELECT param_value_n, param_name
      FROM giis_parameters
     WHERE param_name IN ('NET_RETENTION','FACULTATIVE');
  CURSOR share_type_cd IS--
    SELECT rv_low_value, rv_meaning
      FROM cg_ref_codes
     WHERE rv_domain = 'GIIS_DIST_SHARE.SHARE_TYPE';
BEGIN
  dbms_output.put_line('START  : '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
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
  dbms_output.put_line('CHECK EXISTS: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
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
	 /* TO SET THE RANGE IN PLACE */
     rec_counter := 0;
     FOR indx IN cv LOOP
       rec_counter := rec_counter + 1;
       range_to(rec_counter) := indx.range_to;
     END LOOP;
     rec_counter := 0;
     FOR indx IN cv2 LOOP
       rec_counter := rec_counter + 1;
	   range_from(rec_counter) := indx.range_from;
     END LOOP;
    /* TRANSFER RANGE TO COLLECTION TO ROWTYPE BECAUSE BULK COLLECT DOES NOT WORK ON RECORD TYPES */
     dbms_output.put_line('TRANSFER FROM BULK: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
     FOR indx IN range_to.first..range_to.last LOOP
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
     END LOOP;
     dbms_output.put_line('START OPEN FOR: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
	 FOR rec IN 1..11 LOOP
       t_share_cd(rec) := 0;
       t_prem_amt(rec) := 0;
	   t_tsi_amt(rec)  := 0;
	   t_count(rec)    := 0;
     END LOOP;
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
     GROUP BY a.line_cd,  	 a.subline_cd,			a.iss_cd,
     	     a.issue_yy,	 a.pol_seq_no,			a.renew_no,
      	     c.share_cd,	 c.acct_trty_type,      c.share_type,
     		 a.ann_tsi_amt)
	LOOP
	   v_policy_no := rc.line_cd||rc.subline_cd||rc.iss_cd||rc.issue_yy||rc.pol_seq_no||rc.renew_no;
	   v_share_cd := rc.share_cd;
	   v_acct_trty_type := rc.acct_trty_type;
	   v_share_type := rc.share_type;
	   v_pol_tsi := rc.pol_tsi;
	   v_prem_amt := rc.prem_amt;
	   v_tsi_amt := rc.tsi_amt;
       counter := counter + 1;  --JUST WANT TO CHECK HOW MANY RECORDS WERE PROCESSED
       IF v_share_cd = v_facul_shr_cd AND v_share_type = v_facul_shr_tp THEN  -- SO THAT INITIALIZATION WILL NOT REACH 999
          v_share_cd := new_facul_num;
       END IF;
		 -- CLEAR COLLECTION FOR NEXT POLICY  --BDARUSIN  ->
          t_share_cd.DELETE;
          t_prem_amt.DELETE;
 		  t_tsi_amt.DELETE;
		  t_count.DELETE;
		  FOR rec IN 1..11 LOOP
            t_share_cd(rec) := 0;
            t_prem_amt(rec) := 0;
	  	    t_tsi_amt(rec)  := 0;
		    t_count(rec)    := 0;
		  END LOOP;
	  	  rec_counter := 0; --
          --INITIALIZE--
          t_share_cd(v_share_cd) := v_share_cd;
          t_prem_amt(v_share_cd) := 0;
		  t_tsi_amt(v_share_cd) := 0;
		  t_count(v_share_cd) := 0;
          --INSERT VALUES--
		  t_prem_amt(v_share_cd) := NVL(v_prem_amt,0);
		  t_tsi_amt(v_share_cd) := NVL(v_tsi_amt,0);
		  t_count(v_share_cd) := 1;  --BDARUSIN  <-
		  v_pol_cntr := 0;
		 IF var_policy_no <> v_policy_no OR var_policy_no IS NULL THEN
		   v_pol_cntr := 1;
	     ELSIF var_policy_no = v_policy_no THEN
		   v_pol_cntr := 0;
		 END IF;
         -- POLICYNO BEING PROCESSED IS ALREADY A DIFFERENT POLICY
          var_policy_no := v_policy_no;
          FOR indx IN ext_risk_row.first..ext_risk_row.last LOOP
--            IF V_TOTAL_TSI_AMT <= EXT_RISK_ROW(INDX).RANGE_TO THEN  --COMMENTED OUT BY BDARUSIN NOV, 2001
--            IF V_POL_TSI BETWEEN EXT_RISK_ROW(INDX).RANGE_FROM AND EXT_RISK_ROW(INDX).RANGE_TO THEN  --BDARUSIN NOV, 2001
			  IF v_pol_tsi >= ext_risk_row(indx).range_from AND
			     v_pol_tsi <= ext_risk_row(indx).range_to THEN
               ext_risk_row(indx).policy_count := NVL(ext_risk_row(indx).policy_count,0) + v_pol_cntr;
               -- INSERT INTO RIGHT RANGE AND SHARE_CD, THEN EXIT SO IT'l move TO NEXT RECORD
			   FOR ext IN t_share_cd.first..t_share_cd.last LOOP
			     IF t_share_cd.EXISTS(ext) THEN
				    IF v_share_type = v_reten_shr_tp THEN
                       IF t_share_cd(ext) = v_reten_shr_cd THEN  --insert into net_retention column
					      ext_risk_row(indx).net_retention := ext_risk_row(indx).net_retention + t_prem_amt(ext);
					      ext_risk_row(indx).net_retention_tsi := ext_risk_row(indx).net_retention_tsi + t_tsi_amt(ext);
					      ext_risk_row(indx).net_retention_cnt := ext_risk_row(indx).net_retention_cnt + t_count(ext);
					   ELSE
					      ext_risk_row(indx).sec_net_retention_prem := ext_risk_row(indx).sec_net_retention_prem + t_prem_amt(ext);
					      ext_risk_row(indx).sec_net_retention_tsi := ext_risk_row(indx).sec_net_retention_tsi + t_tsi_amt(ext);
					      ext_risk_row(indx).sec_net_retention_cnt := ext_risk_row(indx).sec_net_retention_cnt + t_count(ext);  --added jan 02, 2002
					   END IF;
					ELSIF v_share_type = v_facul_shr_tp THEN
					   IF t_share_cd(ext) = new_facul_num THEN --v_facul_shr_cd then --insert into facultative column
					      ext_risk_row(indx).facultative := ext_risk_row(indx).facultative + t_prem_amt(ext);
					      ext_risk_row(indx).facultative_tsi := ext_risk_row(indx).facultative_tsi + t_tsi_amt(ext);
					      ext_risk_row(indx).facultative_cnt := ext_risk_row(indx).facultative_cnt + t_count(ext);
					   END IF;
					ELSIF v_share_type = v_trty_shr_tp THEN
					      -- check first if treaty share_cd within 2 to 10, then insert into
					      -- corresponding column with the same column number, if share_cd
						  -- is = 1 then, into treaty and treaty_tsi column
					   IF v_acct_trty_type = 3 THEN
					      ext_risk_row(indx).quota_share := ext_risk_row(indx).quota_share + t_prem_amt(ext);
						  ext_risk_row(indx).quota_share_tsi := ext_risk_row(indx).quota_share_tsi + t_tsi_amt(ext);
						  ext_risk_row(indx).quota_share_cnt := ext_risk_row(indx).quota_share_cnt + t_count(ext);
					   ELSE
					      --ext_risk_row(indx).treaty := ext_risk_row(indx).treaty + t_prem_amt(ext);
					      IF t_share_cd(ext) = 1 THEN
  					         ext_risk_row(indx).treaty := ext_risk_row(indx).treaty + t_prem_amt(ext);
					         ext_risk_row(indx).treaty_tsi := ext_risk_row(indx).treaty_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty_cnt := ext_risk_row(indx).treaty_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 2 THEN
  					         ext_risk_row(indx).treaty2_prem := ext_risk_row(indx).treaty2_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty2_tsi  := ext_risk_row(indx).treaty2_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty2_cnt  := ext_risk_row(indx).treaty2_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 3 THEN
  					         ext_risk_row(indx).treaty3_prem := ext_risk_row(indx).treaty3_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty3_tsi := ext_risk_row(indx).treaty3_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty3_cnt := ext_risk_row(indx).treaty3_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 4 THEN
  					         ext_risk_row(indx).treaty4_prem := ext_risk_row(indx).treaty4_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty4_tsi := ext_risk_row(indx).treaty4_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty4_cnt := ext_risk_row(indx).treaty4_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 5 THEN
  					         ext_risk_row(indx).treaty5_prem := ext_risk_row(indx).treaty5_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty5_tsi := ext_risk_row(indx).treaty5_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty5_cnt := ext_risk_row(indx).treaty5_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 6 THEN
  					         ext_risk_row(indx).treaty6_prem := ext_risk_row(indx).treaty6_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty6_tsi := ext_risk_row(indx).treaty6_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty6_cnt := ext_risk_row(indx).treaty6_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 7 THEN
  					         ext_risk_row(indx).treaty7_prem := ext_risk_row(indx).treaty7_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty7_tsi := ext_risk_row(indx).treaty7_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty7_cnt := ext_risk_row(indx).treaty7_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 8 THEN
  					         ext_risk_row(indx).treaty8_prem := ext_risk_row(indx).treaty8_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty8_tsi := ext_risk_row(indx).treaty8_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty8_cnt := ext_risk_row(indx).treaty8_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 9 THEN
  					         ext_risk_row(indx).treaty9_prem := ext_risk_row(indx).treaty9_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty9_tsi := ext_risk_row(indx).treaty9_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty9_cnt := ext_risk_row(indx).treaty9_cnt + t_count(ext);
					      ELSIF t_share_cd(ext) = 10 THEN
  					         ext_risk_row(indx).treaty10_prem := ext_risk_row(indx).treaty10_prem + t_prem_amt(ext);
					         ext_risk_row(indx).treaty10_tsi := ext_risk_row(indx).treaty10_tsi + t_tsi_amt(ext);
					         ext_risk_row(indx).treaty10_cnt := ext_risk_row(indx).treaty10_cnt + t_count(ext);
                          END IF;
					   END IF;
					END IF;
                 END IF;
               END LOOP;
               EXIT;
			END IF;
		  END LOOP;
     END LOOP;
     -- if table gipi_risk_profile is changed to accomodate 2nd ret, here is where it
	 -- should be changed
     dbms_output.put_line('START 4: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
     dbms_output.put_line('TOTAL ROWS PROCESSED: '||TO_CHAR(counter));
     dbms_output.put_line('EXT_RISK_ROW.FIRST: '||TO_CHAR(ext_risk_row.first));
     dbms_output.put_line('EXT_RISK_ROW.LAST: '||TO_CHAR(ext_risk_row.last));
     FOR transfer IN ext_risk_row.first..ext_risk_row.last LOOP
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
	   sec_net_retention_cnt = ext_risk_row(transfer).sec_net_retention_cnt
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
  dbms_output.put_line(counter);
  dbms_output.put_line('END: '||TO_CHAR(SYSDATE,'MMDDYYYY HH:MI:SS AM'));
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
  DELETE FROM gipi_polrisk_ext1;
  COMMIT;
  SELECT a.policy_id,          a.line_cd, 	  		    a.subline_cd,
         a.iss_cd,             a.issue_yy,			    a.pol_seq_no,
  	     a.renew_no,           b.dist_no,               get_ann_tsi(a.line_cd,
		                                                            a.subline_cd,
																	a.iss_cd,
																	a.issue_yy,
																	a.pol_seq_no,
																	a.renew_no,
																	p_date_from,
																	p_date_to,
																	p_basis)
    bulk collect INTO
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
     AND date_risk(a.acct_ent_date, a.eff_date, a.issue_date,
	     a.spld_acct_ent_date, a.pol_flag, p_basis, p_date_from, p_date_to) = 1
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
			   AND date_risk(c.acct_ent_date, c.eff_date, c.issue_date,
			       c.spld_acct_ent_date, c.pol_flag, p_basis, p_date_from, p_date_to) = 1)
			))
	 --<< END OF INSERTED STATEMENT BY BDARUSIN, 081602
     AND a.policy_id = b.policy_id
     --AND b.dist_flag = '3';
     AND b.dist_flag = DECODE(a.pol_flag,'5','4','3');--if pol_flag is 5, dist_flag shld be 4, else dist_flag shld be 3
  IF NOT SQL%NOTFOUND THEN
     forall i IN vv_policy_id.first..vv_policy_id.last
       INSERT INTO gipi_polrisk_ext1
         (policy_id,          line_cd, 	  		    subline_cd,
          iss_cd,             issue_yy,			    pol_seq_no,
  	      renew_no,           dist_no,              ann_tsi_amt)
       VALUES
	     (vv_policy_id(i),    vv_line_cd(i), 	    vv_subline_cd(i),
          vv_iss_cd(i),       vv_issue_yy(i),		vv_pol_seq_no(i),
  	      vv_renew_no(i),     vv_dist_no(i),        vv_ann_tsi_amt(i));
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
  DELETE FROM gipi_sharisk_ext2;
  COMMIT;
  SELECT d.line_cd,          d.peril_cd,          d.peril_type,
         e.share_cd,		 e.acct_trty_type,    e.share_type
    bulk collect INTO
	     vv_line_cd,         vv_peril_cd,         vv_peril_type,
         vv_share_cd,		 vv_acct_trty_type,   vv_share_type
    FROM giis_peril d,
         giis_dist_share e
   WHERE d.line_cd = e.line_cd;
  IF NOT SQL%NOTFOUND THEN
     forall i IN vv_line_cd.first..vv_line_cd.last
       INSERT INTO gipi_sharisk_ext2
         (line_cd,          peril_cd,             peril_type,
          share_cd,		    acct_trty_type,       share_type)
       VALUES
	     (vv_line_cd(i),    vv_peril_cd(i),       vv_peril_type(i),
          vv_share_cd(i),   vv_acct_trty_type(i), vv_share_type(i));
     COMMIT;
  END IF;
END;

FUNCTION date_risk
  /*  this function checks if the acct_ent_date, eff_date, or issue_date
      of the policy is within the given date range
	  revised by bdarusin, 11222002,
	  if extract is by acct_ent_date, include spoiled policies but
	  check the spld_acct_ent_date*/

  (p_ad       IN DATE,
   p_ed       IN DATE,
   p_id       IN DATE,
   p_spld_ad  IN DATE,
   p_pol_flag IN VARCHAR2,
   p_dt_type  IN VARCHAR2,
   p_fmdate   IN DATE,
   p_todate   IN DATE)
  RETURN NUMBER IS
  BEGIN
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
	   ELSIF p_dt_type = 'ED' AND TRUNC(p_ed) >= p_fmdate AND TRUNC(p_ed) <= p_todate THEN
	      RETURN (1);
	   ELSIF p_dt_type = 'ID' AND TRUNC(p_id) >= p_fmdate AND TRUNC(p_id) <= p_todate THEN
	      RETURN (1);
	    --ELSE
	    --   RETURN (0);
	   END IF;
	   RETURN (0);
	END IF;
  END;

FUNCTION get_ann_tsi
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
      (SELECT SUM(x.tsi_amt) tsi_amt
        FROM gipi_polbasic x
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
         AND x.renew_no   = p_renew_no
         --> MODIFIED BY BDARUSIN 11222002 TO INCLUDE SPOILED POLICIES
	     --  IF POLICY IS SPOILED, CHECK THE SPLD_ACCT_ENT_DATE
         /*AND X.POL_FLAG IN ('1','2','3','4','x')
		 AND DATE_RISK(X.ACCT_ENT_DATE, X.EFF_DATE, X.ISSUE_DATE, P_BASIS, P_FROM, P_TO) = 1*/
		 AND date_risk(x.acct_ent_date, x.eff_date, x.issue_date,
		     x.spld_acct_ent_date, x.pol_flag, p_basis, p_from, p_to) = 1
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
 	    	         		 AND date_risk(c.acct_ent_date, c.eff_date,
							   c.issue_date, c.spld_acct_ent_date, c.pol_flag,
							   p_basis, p_from, p_to) = 1
							 ))))
    LOOP
      v_ann_tsi := cur1.tsi_amt;
      EXIT;
    END LOOP;
    RETURN v_ann_tsi;
  END;
  FUNCTION get_tarf_cd
  /* created by bdarusin 12/17/2002
  ** this function returns the tarf_cd of the latest endt_seq_no. this function is only used
  ** for fire policies
  */
    (p_line_cd      VARCHAR2,
     p_subline_cd   VARCHAR2,
     p_iss_cd       VARCHAR2,
     p_issue_yy     NUMBER,
     p_pol_seq_no   NUMBER,
	 p_endt_iss_cd  VARCHAR2,
	 p_endt_yy      NUMBER,
	 p_endt_seq_no  NUMBER,
     p_renew_no     NUMBER,
     p_item_no      NUMBER,
     p_dt_type      VARCHAR2,
     p_from         DATE,
     p_to           DATE,
	 p_basis        VARCHAR2)
  RETURN NUMBER IS
    v_tarf_cd     gipi_fireitem.tarf_cd%TYPE;
  BEGIN
    FOR cur1 IN (
      SELECT y.tarf_cd
        FROM gipi_polbasic x,
             gipi_fireitem y
       WHERE x.line_cd    = p_line_cd
         AND x.subline_cd = p_subline_cd
         AND x.iss_cd     = p_iss_cd
         AND x.issue_yy   = p_issue_yy
         AND x.pol_seq_no = p_pol_seq_no
		 AND x.endt_iss_cd = p_endt_iss_cd
		 AND x.endt_yy     = p_endt_yy
		 AND x.endt_seq_no = p_endt_seq_no
         AND x.renew_no   = p_renew_no
         AND date_risk(x.acct_ent_date, x.eff_date, x.issue_date,
	         x.spld_acct_ent_date, x.pol_flag, p_basis, p_from, p_to) = 1
         AND NOT EXISTS(SELECT 'X'
                          FROM gipi_polbasic m,
                               gipi_fireitem  n
                         WHERE m.line_cd = p_line_cd
                           AND m.subline_cd = p_subline_cd
                           AND m.iss_cd     = p_iss_cd
                           AND m.issue_yy   = p_issue_yy
                           AND m.pol_seq_no = p_pol_seq_no
		 				   AND m.endt_iss_cd = p_endt_iss_cd
		 				   AND m.endt_yy     = p_endt_yy
		 				   AND m.endt_seq_no = p_endt_seq_no
                           AND m.renew_no   = p_renew_no
				           AND date_risk(m.acct_ent_date, m.eff_date, m.issue_date,
					           m.spld_acct_ent_date, m.pol_flag, p_basis, p_from, p_to) = 1
                           AND m.endt_seq_no > x.endt_seq_no
                           AND NVL(m.back_stat,5) = 2
                           AND m.policy_id  = n.policy_id
                           AND n.item_no    = p_item_no
                           AND n.tarf_cd IS NOT NULL)
        AND x.policy_id  = y.policy_id
        AND y.item_no    = p_item_no
        AND y.tarf_cd IS NOT NULL
        ORDER BY x.eff_date DESC)
    LOOP
      v_tarf_cd := cur1.tarf_cd;
      EXIT;
    END LOOP;
    RETURN v_tarf_cd;
  END;

END;
/


