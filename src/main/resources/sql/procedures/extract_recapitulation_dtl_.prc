DROP PROCEDURE CPI.EXTRACT_RECAPITULATION_DTL_;

CREATE OR REPLACE PROCEDURE CPI.Extract_Recapitulation_Dtl_(p_from_date DATE, p_to_date DATE)
  AS
  	TYPE tab_region_cd 	   	      IS TABLE OF gixx_recapitulation_dtl.region_cd%TYPE;
  	TYPE tab_ind_grp_cd 	   	  IS TABLE OF gixx_recapitulation_dtl.ind_grp_cd%TYPE;
	TYPE tab_line_cd			  IS TABLE OF gixx_recapitulation_dtl.line_cd%TYPE;
	TYPE tab_policy_id   	   	  IS TABLE OF gixx_recapitulation_dtl.policy_id%TYPE;
	TYPE tab_premium_amt 	   	  IS TABLE OF gixx_recapitulation_dtl.premium_amt%TYPE;
	TYPE tab_assd_no			  IS TABLE OF giis_assured.assd_no%TYPE;
	v_region_cd					  tab_region_cd;
	v_ind_grp_cd 				  tab_ind_grp_cd;
	v_line_cd					  tab_line_cd;
    v_policy_id 				  tab_policy_id;
    v_premium_amt 				  tab_premium_amt;
    v_todate 					  DATE;
	v_fromdate 					  DATE;
	v_assd_no					  tab_assd_no;
BEGIN
  /* Modified by Grace 05272004
  ** Added the from-to date in the extraction
  */
  DELETE FROM gixx_recapitulation_dtl;
  COMMIT;
  v_fromdate := p_from_date;--TO_DATE('01-JAN-'||p_year);
  v_todate   := p_to_date;--TO_DATE('31-DEC-'||p_year);
  SELECT c.assd_no,
  		 g.region_cd,
         h.ind_grp_cd,
		 a.line_cd,
		 SUM(DECODE((SIGN(v_fromdate - a.acct_ent_date) * 4)
              + SIGN(NVL(a.spld_acct_ent_date, v_todate+60) - v_todate),
			  1, 1,
			 -3, 1,
			  3,-1,
			  4,-1, 0) * (b.prem_amt * b.currency_rt)) premium_amt,
         a.policy_id
  BULK COLLECT INTO
         v_assd_no,
		 v_region_cd,
		 v_ind_grp_cd,
		 v_line_cd,
		 v_premium_amt,
		 v_policy_id

    FROM gipi_item           b,
         giis_region         g,
	     gipi_parlist        d,
	     giis_assured        c,
         giis_industry       f,
	     giis_industry_group h,
		 gipi_polbasic       a
   WHERE 1=1
	 --LINK GIPI_POLBASIC AND GIPI_ITEM
	 AND a.policy_id    = b.policy_id
	 --LINK GIPI_ITEM AND GIIS_REGION
     AND b.region_cd = g.region_cd
	 --LINK GIPI_POLBASIC AND GIPI_PARLIST
     AND a.par_id       = d.par_id
	 --LINK GIPI_PARLIST AND GIIS_ASSURED
     AND d.assd_no      = c.assd_no
	 --LINK GIIS_ASSURED AND GIIS_INDUSTRY
     AND NVL(a.industry_cd, c.industry_cd) = f.industry_cd
	 --LINK GIIS_INDUSTRY AND GIIS_INDUSTRY_GRP
     AND f.ind_grp_cd   = h.ind_grp_cd
	 AND a.iss_cd != Giisp.v('ISS_CD_RI')
     AND (   (    TRUNC(a.acct_ent_date) >= v_fromdate
              AND TRUNC(a.acct_ent_date) <= v_todate)
          OR (    TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) >= v_fromdate
              AND TRUNC(NVL(a.spld_acct_ent_date,a.acct_ent_date)) <= v_todate))
   GROUP BY g.region_cd, h.ind_grp_cd, a.line_cd, a.policy_id, c.assd_no;
  IF SQL%FOUND THEN
     FOR cnt IN  v_region_cd.FIRST..v_region_cd.LAST
	 LOOP
		INSERT INTO gixx_recapitulation_dtl
   		 	     (assd_no,region_cd, ind_grp_cd, line_cd, policy_id, premium_amt)
        VALUES (v_assd_no(cnt),v_region_cd(cnt), v_ind_grp_cd(cnt), v_line_cd(cnt), v_policy_id(cnt), v_premium_amt(cnt));
	  END LOOP;
     COMMIT;
  END IF;
END;
/


