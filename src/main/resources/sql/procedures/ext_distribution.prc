DROP PROCEDURE CPI.EXT_DISTRIBUTION;

CREATE OR REPLACE PROCEDURE CPI.Ext_Distribution IS

/** Created by : Lhen Valderrama
    Date Created/Modified: 09/16/03
	This procedure will extract data for Distribution table (including net_retention, treaty
	and facultative amounts) to be use by GenIISys Dashboard.
**/

TYPE tab_acct_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_book_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_iss_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_inc_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_branch		 	 IS TABLE OF eim_distribution_ext.branch_cd%TYPE;
TYPE tab_line			 IS TABLE OF eim_distribution_ext.line_cd%TYPE;
TYPE tab_subline		 IS TABLE OF eim_distribution_ext.subline_cd%TYPE;
TYPE tab_assd			 IS TABLE OF eim_distribution_ext.assd_no%TYPE;
TYPE tab_intm			 IS TABLE OF eim_distribution_ext.intm_no%TYPE;
TYPE tab_intm_type		 IS TABLE OF eim_distribution_ext.intm_type%TYPE;
TYPE tab_share_type		 IS TABLE OF eim_distribution_ext.share_type%TYPE;
TYPE tab_share_desc		 IS TABLE OF eim_distribution_ext.share_type_desc%TYPE;
TYPE tab_dist_prem		 IS TABLE OF eim_distribution_ext.dist_prem_amt%TYPE;
TYPE tab_dist_tsi		 IS TABLE OF eim_distribution_ext.dist_tsi_amt%TYPE;
TYPE tab_trty_name		 IS TABLE OF eim_distribution_ext.trty_ri_name%TYPE;
TYPE tab_line_type	 	 IS TABLE OF eim_distribution_ext.line_business%TYPE;
TYPE tab_pol_flag		 IS TABLE OF eim_distribution_ext.pol_flag%TYPE;

v_acct_date		 tab_acct_date;
v_book_date		 tab_book_date;
v_iss_date		 tab_iss_date;
v_inc_date		 tab_inc_date;
v_branch		 tab_branch;
v_line			 tab_line;
v_subline		 tab_subline;
v_assd			 tab_assd;
v_intm			 tab_intm;
v_intm_type		 tab_intm_type;
v_share_type	 tab_share_type;
v_share_desc	 tab_share_desc;
v_dist_prem		 tab_dist_prem;
v_dist_tsi		 tab_dist_tsi;
v_trty_name		 tab_trty_name;
v_line_type		 tab_line_type;
v_pol_flag		 tab_pol_flag;


BEGIN

/**to delete previous data before extraction of current data**/
DELETE eim_distribution_ext
 WHERE user_id = USER;


  SELECT acct_prod_date,
  		 book_prod_date,
		 issue_prod_date,
		 eff_prod_date,
		 iss_cd branch_cd,
		 line_cd,
		 subline_cd,
		 assd_no,
		 intm_no,
		 intm_type,
		 share_type,
		 type_of_share,
		 SUM(NVL(dist_prem_amt,0)) dist_prem_amt,
		 SUM(NVL(dist_tsi_amt,0)) dist_tsi_amt,
		 trty_ri_name,
		 line_type,
		 pol_flag
	BULK COLLECT INTO
	     v_acct_date,
		 v_book_date,
		 v_iss_date	,
		 v_inc_date	,
		 v_branch 	,
		 v_line		,
		 v_subline	,
		 v_assd		,
		 v_intm		,
		 v_intm_type	,
		 v_share_type	,
		 v_share_desc	,
		 v_dist_prem	,
		 v_dist_tsi		,
		 v_trty_name	,
		 v_line_type	,
		 v_pol_flag
    FROM (
          SELECT TRUNC(a.acct_ent_date) acct_prod_date,
	   	   		 TO_DATE('01/'||booking_mth||'/'||TO_CHAR(booking_year),'DD/MM/YY') book_prod_date,
	   	 		 TRUNC(b.issue_date) issue_prod_date,
	   	 		 TRUNC(b.eff_date) eff_prod_date,
	   	 		 b.iss_cd,
       	 		 b.line_cd,
       	 		 b.subline_cd,
       	 		 h.assd_no,
	   	 		 x.intrmdry_intm_no intm_no,
	   	 		 y.intm_type,
       	 		 e.share_type,
       			 DECODE(e.share_type, '1', 'NET RETENTION', '2', 'TREATY', '3',  'FACULTATIVE', NULL) type_of_share,
       	 		 DECODE(e.share_type, '1', NVL(c.dist_prem,0), '2', NVL(c.dist_prem,0), '3',  NVL(g.ri_prem_amt,0), 0) dist_prem_amt,
       	 		 DECODE(e.share_type, '1', NVL(c.dist_tsi,0), '2', NVL(c.dist_tsi,0), '3',  NVL(g.ri_tsi_amt,0), 0) dist_tsi_amt,
       	 		 DECODE(e.share_type, '2', f.trty_name, '3', g.ri_name, NULL) trty_ri_name,
				 'DIRECT' line_type,
				 b.pol_flag
            FROM giuw_pol_dist a,
       			 gipi_polbasic b,
	   			 gipi_comm_invoice x,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e,
       			 gipi_parlist h,
	   			 giis_intermediary y,
       			 (SELECT DISTINCT trty_name,
               	 		 line_cd,
               			 share_cd
                    FROM giis_dist_share
                   WHERE share_type = '2') f,
                 (SELECT d.ri_name,
               	 		 b.dist_no,
               			 b.dist_seq_no,
                         SUM(ROUND(c.ri_prem_amt/b.currency_rt,2)) ri_prem_amt,
                         SUM(ROUND(c.ri_tsi_amt/b.currency_rt,2)) ri_tsi_amt
                    FROM giri_distfrps b,
                         giri_frps_ri c,
               			 giis_reinsurer d
                   WHERE 1=1
                     AND b.line_cd     = c.line_cd
           			 AND b.frps_yy+0     = c.frps_yy
           			 AND b.frps_seq_no = c.frps_seq_no
           			 AND c.ri_cd = d.ri_cd
           			 AND b.ri_flag NOT IN ('3','4')
           			 AND c.reverse_sw <> 'Y'
           			 AND c.frps_yy     > -1
           			 AND c.frps_seq_no > -1
           			 AND c.ri_seq_no   > -1
           			 AND b.line_cd > '%'
                   GROUP BY d.ri_name,
               	   		 b.dist_no,
               			 b.dist_seq_no) g
           WHERE 1=1
             AND a.policy_id = b.policy_id
   			 AND a.dist_no = c.dist_no
   			 AND c.dist_no = g.dist_no(+)
   			 AND c.dist_seq_no = g.dist_seq_no(+)
   			 AND c.line_cd = e.line_cd
   			 AND c.share_cd = e.share_cd+0
   			 AND c.share_cd = e.share_cd+0
   			 AND e.share_cd = f.share_cd(+)
   			 AND e.line_cd = f.line_cd(+)
   			 AND b.par_id = h.par_id
   			 AND b.policy_id = x.policy_id
  			 AND x.intrmdry_intm_no = y.intm_no
   			 AND y.intm_no > 0
			 AND a.dist_flag = 3
   			 AND NVL(b.endt_type, 'A') = 'A'
   			 AND c.line_cd >'%'
   			 AND c.share_cd > 0
          UNION
		  SELECT TRUNC(a.acct_neg_date) acct_prod_date,
	   	  		 TO_DATE(NULL, 'DD/MM/YY') book_prod_date,
	   			 TO_DATE(NULL, 'DD/MM/YY') issue_prod_date,
	   			 TO_DATE(NULL, 'DD/MM/YY') eff_prod_date,
       			 b.iss_cd,
       			 b.line_cd,
       			 b.subline_cd,
       			 h.assd_no,
	   			 x.intrmdry_intm_no intm_no,
	   			 y.intm_type,
       			 e.share_type,
       			 DECODE(e.share_type, '1', 'NET RETENTION', '2', 'TREATY', '3',  'FACULTATIVE', NULL) type_of_share,
       			 DECODE(e.share_type, '1', NVL(c.dist_prem,0)*-1, '2', NVL(c.dist_prem,0)*-1, '3',  NVL(g.ri_prem_amt,0)*-1, 0) share_amt,
       			 DECODE(e.share_type, '1', NVL(c.dist_tsi,0)*-1, '2', NVL(c.dist_tsi,0)*-1, '3',  NVL(g.ri_tsi_amt,0)*-1, 0) share_tsi_amt,
       	 		 DECODE(e.share_type, '2', f.trty_name, '3', g.ri_name, NULL) ri_name,
				 'DIRECT' line_type,
				 b.pol_flag
            FROM giuw_pol_dist a,
       			 gipi_polbasic b,
	   			 gipi_comm_invoice x,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e ,
       			 gipi_parlist h,
	   			 giis_intermediary y,
       			 (SELECT DISTINCT trty_name,
               	 		 line_cd,
               			 share_cd
                    FROM giis_dist_share
                   WHERE share_type = '2') f,
                 (SELECT d.ri_name,
               	 		 b.dist_no,
               			 b.dist_seq_no,
               			 SUM(ROUND(c.ri_prem_amt/b.currency_rt,2)) ri_prem_amt,
               			 SUM(ROUND(c.ri_tsi_amt/b.currency_rt,2)) ri_tsi_amt
                    FROM giri_distfrps b,
               			 giri_frps_ri c,
               			 giis_reinsurer d
                   WHERE 1=1
                     AND b.line_cd     = c.line_cd
          			 AND b.frps_yy+0     = c.frps_yy
           			 AND b.frps_seq_no = c.frps_seq_no
           			 AND c.ri_cd = d.ri_cd
           			 AND b.ri_flag NOT IN ('3','4')
           			 AND c.reverse_sw <> 'Y'
           			 AND c.frps_yy     > -1
           			 AND c.frps_seq_no > -1
           			 AND c.ri_seq_no   > -1
           			 AND b.line_cd > '%'
                   GROUP BY d.ri_name,
               	   		 b.dist_no,
               			 b.dist_seq_no) g
           WHERE 1=1
             AND a.policy_id = b.policy_id
   			 AND a.dist_no = c.dist_no
   			 AND c.dist_no = g.dist_no(+)
   			 AND c.dist_seq_no = g.dist_seq_no(+)
   			 AND c.line_cd = e.line_cd
   			 AND c.share_cd = e.share_cd+0
   			 AND c.share_cd = e.share_cd+0
   			 AND e.share_cd = f.share_cd(+)
   			 AND e.line_cd = f.line_cd(+)
   			 AND b.policy_id = x.policy_id
   			 AND x.intrmdry_intm_no = y.intm_no
   			 AND NVL(b.endt_type, 'A') = 'A'
			 AND a.dist_flag = 3
   			 AND c.line_cd > '%'
   			 AND a.par_id = h.par_id
		  UNION
 		  SELECT TRUNC(a.acct_ent_date) acct_prod_date,
	   	   		 TO_DATE('01/'||booking_mth||'/'||TO_CHAR(booking_year),'DD/MM/YY') book_prod_date,
	   	 		 TRUNC(b.issue_date) issue_prod_date,
	   	 		 TRUNC(b.eff_date) eff_prod_date,
	   	 		 b.iss_cd,
       	 		 b.line_cd,
       	 		 b.subline_cd,
       	 		 h.assd_no,
	   	 		 0 intm_no,
	   	 		 NULL,
       	 		 e.share_type,
       			 DECODE(e.share_type, '1', 'NET RETENTION', '2', 'TREATY', '3',  'FACULTATIVE', NULL) type_of_share,
       	 		 DECODE(e.share_type, '1', NVL(c.dist_prem,0), '2', NVL(c.dist_prem,0), '3',  NVL(g.ri_prem_amt,0), 0) dist_prem_amt,
       	 		 DECODE(e.share_type, '1', NVL(c.dist_tsi,0), '2', NVL(c.dist_tsi,0), '3',  NVL(g.ri_tsi_amt,0), 0) dist_tsi_amt,
       	 		 DECODE(e.share_type, '2', f.trty_name, '3', g.ri_name, NULL) trty_ri_name,
				 'ASSUMED' line_type,
				 b.pol_flag
            FROM giuw_pol_dist a,
       			 gipi_polbasic b,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e,
       			 gipi_parlist h,
       			 (SELECT DISTINCT trty_name,
               	 		 line_cd,
               			 share_cd
                    FROM giis_dist_share
                   WHERE share_type = '2') f,
                 (SELECT d.ri_name,
               	 		 b.dist_no,
               			 b.dist_seq_no,
                         SUM(ROUND(c.ri_prem_amt/b.currency_rt,2)) ri_prem_amt,
                         SUM(ROUND(c.ri_tsi_amt/b.currency_rt,2)) ri_tsi_amt
                    FROM giri_distfrps b,
                         giri_frps_ri c,
               			 giis_reinsurer d
                   WHERE 1=1
                     AND b.line_cd     = c.line_cd
           			 AND b.frps_yy+0     = c.frps_yy
           			 AND b.frps_seq_no = c.frps_seq_no
           			 AND c.ri_cd = d.ri_cd
           			 AND b.ri_flag NOT IN ('3','4')
           			 AND c.reverse_sw <> 'Y'
           			 AND c.frps_yy     > -1
           			 AND c.frps_seq_no > -1
           			 AND c.ri_seq_no   > -1
           			 AND b.line_cd > '%'
                   GROUP BY d.ri_name,
               	   		 b.dist_no,
               			 b.dist_seq_no) g
           WHERE 1=1
             AND a.policy_id = b.policy_id
   			 AND a.dist_no = c.dist_no
   			 AND c.dist_no = g.dist_no(+)
   			 AND c.dist_seq_no = g.dist_seq_no(+)
   			 AND c.line_cd = e.line_cd
   			 AND c.share_cd = e.share_cd+0
   			 AND c.share_cd = e.share_cd+0
   			 AND e.share_cd = f.share_cd(+)
   			 AND e.line_cd = f.line_cd(+)
   			 AND b.par_id = h.par_id
			 AND a.dist_flag = 3
   			 AND NVL(b.endt_type, 'A') = 'A'
   			 AND c.line_cd >'%'
   			 AND c.share_cd > 0
			 AND b.iss_cd = 'RI'
		  UNION
	      SELECT TRUNC(a.acct_neg_date) acct_prod_date,
	   	  		 TO_DATE(NULL, 'DD/MM/YY') book_prod_date,
	   			 TO_DATE(NULL, 'DD/MM/YY') issue_prod_date,
	   			 TO_DATE(NULL, 'DD/MM/YY') eff_prod_date,
       			 b.iss_cd,
       			 b.line_cd,
       			 b.subline_cd,
       			 h.assd_no,
	   			 0 intm_no,
	   			 NULL,
       			 e.share_type,
       			 DECODE(e.share_type, '1', 'NET RETENTION', '2', 'TREATY', '3',  'FACULTATIVE', NULL) type_of_share,
       			 DECODE(e.share_type, '1', NVL(c.dist_prem,0)*-1, '2', NVL(c.dist_prem,0)*-1, '3',  NVL(g.ri_prem_amt,0)*-1, 0) share_amt,
       			 DECODE(e.share_type, '1', NVL(c.dist_tsi,0)*-1, '2', NVL(c.dist_tsi,0)*-1, '3',  NVL(g.ri_tsi_amt,0)*-1, 0) share_tsi_amt,
       	 		 DECODE(e.share_type, '2', f.trty_name, '3', g.ri_name, NULL) ri_name,
				 'ASSUMED' line_type,
				 b.pol_flag
            FROM giuw_pol_dist a,
       			 gipi_polbasic b,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e ,
       			 gipi_parlist h,
       			 (SELECT DISTINCT trty_name,
               	 		 line_cd,
               			 share_cd
                    FROM giis_dist_share
                   WHERE share_type = '2') f,
                 (SELECT d.ri_name,
               	 		 b.dist_no,
               			 b.dist_seq_no,
               			 SUM(ROUND(c.ri_prem_amt/b.currency_rt,2)) ri_prem_amt,
               			 SUM(ROUND(c.ri_tsi_amt/b.currency_rt,2)) ri_tsi_amt
                    FROM giri_distfrps b,
               			 giri_frps_ri c,
               			 giis_reinsurer d
                   WHERE 1=1
                     AND b.line_cd     = c.line_cd
          			 AND b.frps_yy+0     = c.frps_yy
           			 AND b.frps_seq_no = c.frps_seq_no
           			 AND c.ri_cd = d.ri_cd
           			 AND b.ri_flag NOT IN ('3','4')
           			 AND c.reverse_sw <> 'Y'
           			 AND c.frps_yy     > -1
           			 AND c.frps_seq_no > -1
           			 AND c.ri_seq_no   > -1
           			 AND b.line_cd > '%'
                   GROUP BY d.ri_name,
               	   		 b.dist_no,
               			 b.dist_seq_no) g
           WHERE 1=1
             AND a.policy_id = b.policy_id
   			 AND a.dist_no = c.dist_no
   			 AND c.dist_no = g.dist_no(+)
   			 AND c.dist_seq_no = g.dist_seq_no(+)
   			 AND c.line_cd = e.line_cd
   			 AND c.share_cd = e.share_cd+0
   			 AND c.share_cd = e.share_cd+0
   			 AND e.share_cd = f.share_cd(+)
   			 AND e.line_cd = f.line_cd(+)
   			 AND NVL(b.endt_type, 'A') = 'A'
			 AND a.dist_flag = 3
   			 AND c.line_cd > '%'
   			 AND a.par_id = h.par_id
			 AND b.iss_cd = 'RI')
   GROUP BY acct_prod_date,
  		 book_prod_date,
		 issue_prod_date,
		 eff_prod_date,
		 iss_cd,
		 line_cd,
		 subline_cd,
		 assd_no,
		 intm_no,
		 intm_type,
		 share_type,
		 type_of_share,
		 trty_ri_name,
		 line_type,
		 pol_flag;

IF SQL%FOUND THEN
  FOR cnt IN
    v_acct_date.first..v_acct_date.last
  LOOP

  INSERT INTO eim_distribution_ext (
    user_id,                     acct_prod_date,
	book_prod_date, 			 issue_prod_date,
	eff_prod_date, 				 share_type,
	share_type_desc, 			 dist_prem_amt,
	dist_tsi_amt, 				 trty_ri_name,
	line_business, 				 branch_name,
	line_name, 					 subline_name,
	intermediary_name, 			 intm_type_desc,
	assured_name, 				 pol_flag,
	extraction_date, 			 line_cd,
	subline_cd, 				 branch_cd,
	intm_no, 					 intm_type,
	assd_no)
  VALUES (
    NULL, 						 v_acct_date(cnt),
	v_book_date(cnt),			 v_iss_date(cnt),
	v_inc_date(cnt),			 v_share_type(cnt),
	v_share_desc(cnt),			 v_dist_prem(cnt),
	v_dist_tsi(cnt),			 v_trty_name(cnt),
	v_line_type(cnt),			 Get_Iss_Name(v_branch(cnt)),
	Get_Line_Name(v_line(cnt)),  Get_Subline_Name(v_subline(cnt)),
	DECODE(v_intm(cnt), 0, NULL, Get_Intm_Name(v_intm(cnt))),
	Get_Intm_Type_Desc(v_intm_type(cnt)),
	Get_Assd_Name(v_assd(cnt)),	 v_pol_flag(cnt),
	TRUNC(SYSDATE),				 v_line(cnt),
	v_subline(cnt),		  	 	 v_branch(cnt),
	v_intm(cnt),				 v_intm_type(cnt),
	v_assd(cnt));

END LOOP;
COMMIT;
END IF;
END;
/

DROP PROCEDURE CPI.EXT_DISTRIBUTION;
