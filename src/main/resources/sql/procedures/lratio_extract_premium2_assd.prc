DROP PROCEDURE CPI.LRATIO_EXTRACT_PREMIUM2_ASSD;

CREATE OR REPLACE PROCEDURE CPI.Lratio_Extract_Premium2_Assd
                      (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
                       p_peril_cd           giis_peril.peril_cd%TYPE,
                       p_assd_no            giis_assured.assd_no%TYPE,
                       p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
                       p_date_param         NUMBER,
                       p_issue_param        NUMBER,
                       p_curr1_date         gipi_polbasic.issue_date%TYPE,
                       p_curr2_date         gipi_polbasic.issue_date%TYPE,
                       p_prev1_date         gipi_polbasic.issue_date%TYPE,
                       p_prev2_date         gipi_polbasic.issue_date%TYPE,
                       p_prev_year          VARCHAR2,
			     p_curr_exists    OUT VARCHAR2,
			     p_prev_exists    OUT VARCHAR2,
                       p_ext_proc           VARCHAR2) AS
  /*beth 03082003
  **     this procedure extract premiums written both for current and previous year
  **     this is used if date parameter is policy's accounting entry date
  **     and if assd_no parameter is given
  */
  -- hardy 011404
  -- add currency_rt to codes
  --declare varray variables that will be needed during extraction of record
  TYPE policy_id_tab   IS TABLE OF gipi_polbasic.policy_id%TYPE;
  TYPE curr_prem_tab   IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
  TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
  TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
  TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE date24_tab      IS TABLE OF VARCHAR2(10);
  vv_policy_id         policy_id_tab;
  vv_prem              curr_prem_tab;
  vv_line_cd           line_cd_tab;
  vv_subline_cd        subline_cd_tab;
  vv_iss_cd            iss_cd_tab;
  vv_peril_cd          peril_cd_tab;
  vv_date24            date24_tab;
BEGIN --main
  p_curr_exists := 'N';
  p_prev_exists := 'N';
  BEGIN --extract current year premiums written
    --delete records in extract table for the current user
    DELETE gicl_lratio_curr_prem_ext
     WHERE user_id = USER;
    BEGIN--select all records from gipi_polbasic for record
  	     --with accounting entry  date within the current year
      SELECT d.policy_id,     d.line_cd,
	       d.subline_cd,    d.iss_cd, c.peril_cd,
             SUM(NVL(c.prem_amt,0)*NVL(b.currency_rt,1)) prem_amt,
             TO_CHAR(d.acct_ent_date,'MM-DD-YYYY')
      BULK COLLECT
        INTO vv_policy_id,    vv_line_cd,
	         vv_subline_cd,   vv_iss_cd,
			 vv_peril_cd,     vv_prem,
			 vv_date24
        FROM gipi_polbasic d,
             gipi_itmperil c,
			 (SELECT currency_rt, policy_id, item_no
			    FROM gipi_item) b
       WHERE d.policy_id = c.policy_id
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND c.peril_cd = NVL(p_peril_cd, c.peril_cd)
         AND TRUNC(d.acct_ent_date) >= p_curr1_date
         AND TRUNC(d.acct_ent_date) <= p_curr2_date
         AND d.pol_flag IN ('1','2','3','4','X')
		 AND Get_Latest_Assured_No(d.line_cd,
                                   d.subline_cd,
                                   d.iss_cd,
                                   d.issue_yy,
                                   d.pol_seq_no,
                                   d.renew_no,
                                   p_curr1_date,
                                   p_curr2_date) = p_assd_no
		 AND c.policy_id = b.policy_id
	     AND c.item_no = b.item_no
      GROUP BY d.policy_id,     d.line_cd,
	         d.subline_cd,    d.iss_cd, c.peril_cd,
               TO_CHAR(d.acct_ent_date,'MM-DD-YYYY');
     --insert record on table gicl_lratio_curr_prem_ext
      IF SQL%FOUND THEN
  		 p_curr_exists := 'Y';
         FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
  	       INSERT INTO gicl_lratio_curr_prem_ext
    	     (session_id, 	  assd_no,      	policy_id,
		      line_cd,        subline_cd,       iss_cd,
 		      peril_cd,       prem_amt,         user_id,
			  date_for_24th)
           VALUES
	     (p_session_id,	  p_assd_no,        vv_policy_id(i),
		  vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i),
		  vv_peril_cd(i), vv_prem(i),       USER,
		  TO_DATE(vv_date24(i),'MM-DD-YYYY'));
   	     --after insert refresh arrays by deleting data
	     vv_policy_id.DELETE;
	     vv_prem.DELETE;
	     vv_line_cd.DELETE;
	     vv_subline_cd.DELETE;
   	     vv_iss_cd.DELETE;
         vv_peril_cd.DELETE;
         vv_date24.DELETE;
      END IF;
    END;--select all records from gipi_polbasic for record
	    --with accounting entry date within the current year
    BEGIN --select all records from gipi_polbasic for record
   	      --with spoiled accounting entry date within the current year
      SELECT d.policy_id,     d.line_cd,
	         d.subline_cd,    d.iss_cd, c.peril_cd,
             SUM(NVL(c.prem_amt,0)*NVL(b.currency_rt,1)) prem_amt,
             TO_CHAR(d.spld_acct_ent_date,'MM-DD-YYYY')
      BULK COLLECT
        INTO vv_policy_id,    vv_line_cd,
	         vv_subline_cd,   vv_iss_cd,
			 vv_peril_cd, 	  vv_prem,
			 vv_date24
        FROM gipi_polbasic d,
             gipi_itmperil c,
			 (SELECT currency_rt, policy_id, item_no
			    FROM gipi_item) b
       WHERE d.policy_id = c.policy_id
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND c.peril_cd = NVL(p_peril_cd, c.peril_cd)
         AND TRUNC(d.spld_acct_ent_date) >= p_curr1_date
         AND TRUNC(d.spld_acct_ent_date) <= p_curr2_date
         AND d.pol_flag IN ('1','2','3','4','X')
		 AND Get_Latest_Assured_No(d.line_cd,
                                   d.subline_cd,
                                   d.iss_cd,
                                   d.issue_yy,
                                   d.pol_seq_no,
                                   d.renew_no,
                                   p_curr1_date,
                                   p_curr2_date) = p_assd_no
		 AND c.policy_id = b.policy_id
	     AND c.item_no = b.item_no
      GROUP BY d.policy_id,     d.line_cd,
	           d.subline_cd,    d.iss_cd, c.peril_cd,
               TO_CHAR(d.spld_acct_ent_date,'MM-DD-YYYY');
      --insert record on table gicl_lratio_curr_prem_ext
      IF SQL%FOUND THEN
 		 p_curr_exists := 'Y';
         FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
	       INSERT INTO gicl_lratio_curr_prem_ext
    	     (session_id, 	 assd_no,      	    policy_id,
 			  line_cd,       subline_cd,        iss_cd,
			  peril_cd,      prem_amt,          spld_sw,
			  user_id,       date_for_24th)
           VALUES
	         (p_session_id,	 p_assd_no,         vv_policy_id(i),
			  vv_line_cd(i), vv_subline_cd(i),  vv_iss_cd(i),
			  vv_peril_cd(i),-vv_prem(i),       'Y',
			  USER,          TO_DATE(vv_date24(i),'MMM-DD-YYYY'));
   	     --after insert refresh arrays by deleting data
	     vv_policy_id.DELETE;
	     vv_prem.DELETE;
	     vv_line_cd.DELETE;
	     vv_subline_cd.DELETE;
   	     vv_iss_cd.DELETE;
         vv_peril_cd.DELETE;
         vv_date24.DELETE;
      END IF;
    END;--select all records from gipi_polbasic for record
  	    --with spoiled accounting entry date within the current year
  	-- delete records in table gicl_lratio_curr_prem_ext if accounting entry date
	-- and spoiled accounting entry date is within the current date parameter
    FOR del_spld IN(
      SELECT a.policy_id
        FROM gicl_lratio_curr_prem_ext a,
             gicl_lratio_curr_prem_ext b
       WHERE a.session_id = p_session_id
         AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND a.session_id = b.session_id
         AND a.policy_id = b.policy_id
         AND NVL(a.spld_sw,'N') = 'Y'
         AND NVL(b.spld_sw,'N') = 'N' )
    LOOP
      DELETE gicl_lratio_curr_prem_ext
       WHERE policy_id = del_spld.policy_id
         AND session_id = p_session_id;
    END LOOP;
  END;--extract current year premiums written
  BEGIN --extract previous year premiums written
    --delete records in extract table for the current user
    DELETE gicl_lratio_prev_prem_ext
     WHERE user_id = USER;
    BEGIN --select all records from gipi_polbasic for record
	  --with accounting entry  date within the previous year
      SELECT d.policy_id,     d.line_cd,
             d.subline_cd,    d.iss_cd, c.peril_cd,
	       SUM(NVL(c.prem_amt,0)*NVL(b.currency_rt,1)) prem_amt,
             TO_CHAR(d.acct_ent_date,'MM-DD-YYYY')
      BULK COLLECT
        INTO vv_policy_id,    vv_line_cd,
  	         vv_subline_cd,   vv_iss_cd,
			 vv_peril_cd,     vv_prem,
			 vv_date24
        FROM gipi_polbasic d,
             gipi_itmperil c,
			 (SELECT currency_rt, policy_id, item_no
			    FROM gipi_item) b
       WHERE d.policy_id = c.policy_id
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND c.peril_cd = NVL(p_peril_cd, c.peril_cd)
         --AND TO_CHAR(d.acct_ent_date,'YYYY') = p_prev_year
         AND ((p_ext_proc = 'S'
              AND TO_CHAR(d.acct_ent_date,'YYYY') = p_prev_year)
              OR
              (p_ext_proc = 'M'
              AND TRUNC(d.acct_ent_date) >= p_prev1_date
              AND TRUNC(d.acct_ent_date) <= p_prev2_date))
         AND d.pol_flag IN ('1','2','3','4','X')
		 AND Get_Latest_Assured_No(d.line_cd,
                                   d.subline_cd,
                                   d.iss_cd,
                                   d.issue_yy,
                                   d.pol_seq_no,
                                   d.renew_no,
                                   p_prev1_date,
                                   p_prev2_date) = p_assd_no
		 AND c.policy_id = b.policy_id
	     AND c.item_no = b.item_no
       GROUP BY d.policy_id,     d.line_cd,
  	          d.subline_cd,    d.iss_cd, c.peril_cd,
                TO_CHAR(d.acct_ent_date,'MM-DD-YYYY');
      --insert record on table gicl_lratio_prev_prem_ext
      IF SQL%FOUND THEN
		 p_prev_exists := 'Y';
         FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
  	       INSERT INTO gicl_lratio_prev_prem_ext
    	     (session_id, 	  assd_no,      	policy_id,
		      line_cd,        subline_cd,       iss_cd,
			  peril_cd,       prem_amt,         user_id,
			  date_for_24th)
           VALUES
	     (p_session_id,	  p_assd_no,        vv_policy_id(i),
		  vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i),
		  vv_peril_cd(i), vv_prem(i),       USER,
		  TO_DATE(vv_date24(i),'MM-DD-YYYY'));
   	     --after insert refresh arrays by deleting data
	     vv_policy_id.DELETE;
	     vv_prem.DELETE;
	     vv_line_cd.DELETE;
	     vv_subline_cd.DELETE;
   	     vv_iss_cd.DELETE;
         vv_peril_cd.DELETE;
         vv_date24.DELETE;
      END IF;
    END;--select all records from gipi_polbasic for record
 	    --with accountung entry date within the previous year
    BEGIN --select all records from gipi_polbasic for record
 	    --with spoiled accounting entry date within the previous year
      SELECT d.policy_id,     d.line_cd,
	         d.subline_cd,    d.iss_cd, c.peril_cd,
             SUM(NVL(c.prem_amt,0)*NVL(b.currency_rt,1)) prem_amt,
             TO_CHAR(d.spld_acct_ent_date,'MM-DD-YYYY')
      BULK COLLECT
        INTO vv_policy_id,    vv_line_cd,
	         vv_subline_cd,   vv_iss_cd,
			 vv_peril_cd,     vv_prem,
			 vv_date24
        FROM gipi_polbasic d,
             gipi_itmperil c,
			 (SELECT currency_rt, policy_id, item_no
			    FROM gipi_item) b
       WHERE d.policy_id = c.policy_id
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND d.iss_cd = NVL(p_iss_cd, d.iss_cd)
         AND c.peril_cd = NVL(p_peril_cd, c.peril_cd)
         --AND TO_CHAR(d.spld_acct_ent_date,'YYYY') = p_prev_year
         AND ((p_ext_proc = 'S'
              AND TO_CHAR(d.spld_acct_ent_date,'YYYY') = p_prev_year)
              OR
              (p_ext_proc = 'M'
              AND TRUNC(d.spld_acct_ent_date) >= p_prev1_date
              AND TRUNC(d.spld_acct_ent_date) <= p_prev2_date))
         AND d.pol_flag IN ('1','2','3','4','X')
		 AND Get_Latest_Assured_No(d.line_cd,
                                   d.subline_cd,
                                   d.iss_cd,
                                   d.issue_yy,
                                   d.pol_seq_no,
                                   d.renew_no,
                                   p_prev1_date,
                                   p_prev2_date) = p_assd_no
		 AND c.policy_id = b.policy_id
	     AND c.item_no = b.item_no
       GROUP BY d.policy_id,     d.line_cd,
 	            d.subline_cd,    d.iss_cd, c.peril_cd,
             TO_CHAR(d.spld_acct_ent_date,'MM-DD-YYYY');
      --insert record on table gicl_lratio_prev_prem_ext
      IF SQL%FOUND THEN
		 p_prev_exists := 'Y';
         FORALL i IN vv_policy_id.FIRST..vv_policy_id.LAST
	       INSERT INTO gicl_lratio_prev_prem_ext
    	     (session_id, 	 assd_no,      	   policy_id,
			  line_cd,       subline_cd,       iss_cd,
			  peril_cd,      prem_amt,         spld_sw,
			  user_id, date_for_24th)
           VALUES
	         (p_session_id,	 p_assd_no,        vv_policy_id(i),
			  vv_line_cd(i), vv_subline_cd(i), vv_iss_cd(i),
			  vv_peril_cd(i),-vv_prem(i),      'Y',
			  USER, TO_DATE(vv_date24(i),'MM-DD-YYYY'));
      END IF;
    END;--select all records from gipi_polbasic for record
 	    --with spoiled accounting entry date within the previous year
  	-- delete records in table gicl_lratio_prev_prem_ext if accounting entry date
	-- and spoiled accounting entry date is within the current date parameter
    FOR del_spld IN(
      SELECT a.policy_id
        FROM gicl_lratio_prev_prem_ext a,
             gicl_lratio_prev_prem_ext b
       WHERE a.session_id = p_session_id
         AND check_user_per_iss_cd2(a.line_cd,a.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND a.session_id = b.session_id
         AND a.policy_id = b.policy_id
         AND NVL(a.spld_sw,'N') = 'Y'
         AND NVL(b.spld_sw,'N') = 'N' )
    LOOP
      DELETE gicl_lratio_prev_prem_ext
       WHERE policy_id = del_spld.policy_id
         AND session_id = p_session_id;
    END LOOP;
  END; -- extract previous year premiums written
END; --main
/


