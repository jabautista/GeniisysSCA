DROP PROCEDURE CPI.EXT_PRODUCTION;

CREATE OR REPLACE PROCEDURE CPI.Ext_Production IS
/**
Created by: Lhen Valderrama
Date Modified : 10/02/03
This bulk procedure will extract the production summary (including RI production) with
acct_prod_date, book_prod_date, issue_date and incept_date as basis for the time period.
**/
TYPE tab_acct_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_book_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_inc_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_iss_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_exp_date		 IS TABLE OF gipi_polbasic.expiry_date%TYPE;
TYPE tab_prod_tsi		 IS TABLE OF eim_production_ext.prod_prem%TYPE;
TYPE tab_prod_prem		 IS TABLE OF eim_production_ext.prod_tsi%TYPE;
TYPE tab_prod_nop		 IS TABLE OF eim_production_ext.prod_nop%TYPE;
TYPE tab_line			 IS TABLE OF eim_production_ext.line_cd%TYPE;
TYPE tab_subline		 IS TABLE OF eim_production_ext.subline_cd%TYPE;
TYPE tab_branch		 	 IS TABLE OF eim_production_ext.branch_cd%TYPE;
TYPE tab_intm			 IS TABLE OF eim_production_ext.intm_no%TYPE;
TYPE tab_intm_type		 IS TABLE OF eim_production_ext.intm_type%TYPE;
TYPE tab_assd			 IS TABLE OF eim_production_ext.assd_no%TYPE;
TYPE tab_pol_id		 	 IS TABLE OF eim_production_ext.policy_id%TYPE;
TYPE tab_pol_no		 	 IS TABLE OF eim_production_ext.policy_no%TYPE;
TYPE tab_pol_flag		 IS TABLE OF eim_production_ext.pol_flag%TYPE;
TYPE tab_ren_stat		 IS TABLE OF eim_production_ext.ren_stat%TYPE;

v_acct_date		 tab_acct_date;
v_book_date		 tab_book_date;
v_inc_date		 tab_inc_date;
v_iss_date		 tab_iss_date;
v_exp_date		 tab_exp_date;
v_prod_tsi		 tab_prod_tsi;
v_prod_prem		 tab_prod_prem;
v_prod_nop		 tab_prod_nop;
v_line			 tab_line;
v_subline		 tab_subline;
v_branch		 tab_branch;
v_intm			 tab_intm;
v_intm_type		 tab_intm_type;
v_assd			 tab_assd;
v_pol_id		 tab_pol_id;
v_pol_no		 tab_pol_no;
v_pol_flag		 tab_pol_flag;
v_ren_stat		 tab_ren_stat;

BEGIN

/**to delete previous data before extraction to have an updated data**/
DELETE eim_production_ext
 WHERE user_id = USER;

/**union has been created below to grouped the data into production and RI production**/
  SELECT acct_prod_date,
  		 book_prod_date,
		 incept_prod_date,
		 issue_prod_date,
		 expiry_date,
	   	 SUM(NVL(prod_tsi,0)) prod_tsi,
	   	 SUM(NVL(prod_prem,0)) prod_prem,
	   	 SUM(NVL(prod_nop,0)) prod_nop,
		 line,
		 subline,
		 branch,
		 intm,
		 intm_type,
		 assd,
	   	 policy_id,
		 RTRIM(policy_no) policy_no,
		 pol_flag,
		 ren_stat
	BULK COLLECT INTO
	     v_acct_date ,
		 v_book_date ,
		 v_inc_date	 ,
		 v_iss_date	 ,
		 v_exp_date,
		 v_prod_tsi	 ,
		 v_prod_prem ,
		 v_prod_nop	 ,
		 v_line		 ,
		 v_subline	 ,
		 v_branch	 ,
		 v_intm		 ,
		 v_intm_type ,
		 v_assd		 ,
		 v_pol_id	 ,
		 v_pol_no	 ,
		 v_pol_flag	 ,
		 v_ren_stat
    FROM (SELECT TRUNC(a.acct_ent_date) acct_prod_date,
	 		     LAST_DAY(TO_DATE(a.booking_mth || ',' || TO_CHAR(a.booking_year),'FMMONTH,YYYY')) book_prod_date,
			     TRUNC(a.eff_date) incept_prod_date,
			     TRUNC(a.issue_date) issue_prod_date,
				 TRUNC(a.expiry_date) expiry_date,
       	 		 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2)) prod_tsi,
       			 SUM(ROUND(c.premium_amt*d.currency_rt,2)) prod_prem,
       			 SUM(DECODE(a.endt_seq_no, 0,1,0)) prod_nop,
				 a.line_cd line,
	   			 a.subline_cd subline,
	   			 a.iss_cd branch,
	   			 c.intrmdry_intm_no intm,
				 i.intm_type,
	   			 b.assd_no assd,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no) policy_no,
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS') ren_stat
            FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
	   			 giis_intermediary i,
      			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED BUSINESS' ren_flag
				   FROM gipi_polnrep a
				  WHERE 1=1
				    AND ren_rep_sw = 1
					AND a.old_policy_id >-1
					AND a.new_policy_id >-1) g
           WHERE 1 = 1
   	         AND e.line_cd     = f.line_cd
   	 		 AND f.line_cd     = a.line_cd(+)
   	 		 AND f.subline_cd  = a.subline_cd(+)
   	 		 AND a.par_id      = b.par_id
   	 		 AND a.policy_id   = c.policy_id
   	 		 AND a.policy_id   = c.policy_id
   	 		 AND a.policy_id   = c.policy_id+0
			 AND a.policy_id   = g.ren_policy(+)
   	 		 AND c.iss_cd      = d.iss_cd
   	 		 AND c.prem_seq_no = d.prem_seq_no
			 AND c.intrmdry_intm_no = i.intm_no
   	 		 AND a.policy_id > -1
   	 		 AND b.par_id > -1
   	 		 AND NVL(e.sc_tag,'N') <> 'Y'
   			 AND NVL(f.op_flag, 'N') <> 'Y'
   	 		 AND e.line_cd > '%'
   	 		 AND c.iss_cd > '%'
   	 		 AND c.prem_seq_no > -10
           GROUP BY TRUNC(a.acct_ent_date),
	 		     LAST_DAY(TO_DATE(a.booking_mth || ',' || TO_CHAR(a.booking_year),'FMMONTH,YYYY')),
			     TRUNC(a.eff_date),
			     TRUNC(a.issue_date),
				 TRUNC(a.expiry_date),
				 a.line_cd,
	   			 a.subline_cd,
	   			 a.iss_cd ,
	   			 c.intrmdry_intm_no,
				 i.intm_type,
	   			 b.assd_no,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no),
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS')
          UNION
		  SELECT TRUNC(a.spld_acct_ent_date) acct_prod_date,
		  		 TO_DATE(NULL, 'MM/DD/YYYY') book_prod_date,
				 TO_DATE(NULL, 'MM/DD/YYYY') incept_prod_date,
				 TO_DATE(NULL, 'MM/DD/YYYY') issue_prod_date,
				 TRUNC(a.expiry_date) expiry_date,
       	 		 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2) * -1) prod_tsi,
       			 SUM(ROUND(c.premium_amt*d.currency_rt,2) * -1) prod_prem,
       			 SUM(DECODE(a.endt_seq_no, 0,1,0)) prod_nop,
				 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch,
	   			 c.intrmdry_intm_no intm,
				 i.intm_type,
	   			 b.assd_no assd,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no) policy_no,
				 a.pol_flag,
 				 NVL(g.ren_flag,'NEW BUSINESS') ren_stat
            FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
				 giis_intermediary i,
       			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED BUSINESS' ren_flag
				   FROM gipi_polnrep a
				  WHERE 1=1
				    AND ren_rep_sw = 1
					AND a.old_policy_id >-1
					AND a.new_policy_id >-1) g
           WHERE 1 = 1
   		     AND f.line_cd     = e.line_cd
   			 AND f.line_cd     = a.line_cd(+)
   			 AND f.subline_cd  = a.subline_cd(+)
   			 AND a.par_id      = b.par_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id+0
			 AND a.policy_id   = g.ren_policy(+)
  			 AND c.iss_cd      = d.iss_cd
   			 AND c.prem_seq_no = d.prem_seq_no
			 AND c.intrmdry_intm_no = i.intm_no
   			 AND a.policy_id > -1
   			 AND b.par_id > -1
   			 AND NVL(e.sc_tag,'N') <> 'Y'
  			 AND NVL(f.op_flag, 'N') <> 'Y'
   			 AND e.line_cd > '%'
  			 AND c.iss_cd > '%'
   			 AND c.prem_seq_no > -10
			 AND a.spld_acct_ent_date IS NOT NULL
           GROUP BY TRUNC(a.spld_acct_ent_date),
		   		 TO_DATE(NULL, 'MM/DD/YYYY'),
				 TO_DATE(NULL, 'MM/DD/YYYY'),
				 TO_DATE(NULL, 'MM/DD/YYYY'),
  	   	   		 TRUNC(a.expiry_date),
       	 		 f.line_cd,
	   			 f.subline_cd,
	   			 a.iss_cd,
	   			 c.intrmdry_intm_no,
				 i.intm_type,
	   			 b.assd_no,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no),
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS')
          UNION
          SELECT TRUNC(a.acct_ent_date) acct_prod_date,
	   	  		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')) book_prod_date,
	   			 TRUNC(b.eff_date) incept_prod_date,
	   			 TRUNC(b.issue_date) issue_prod_date,
				 TRUNC(b.expiry_date) expiry_date,
       	 		 SUM(NVL(c.dist_tsi,0)) prod_tsi,
	   			 SUM(NVL(c.dist_prem,0)) prod_prem,
	   			 SUM(DECODE(b.endt_seq_no, 0, 1, 0)) prod_nop,
	   			 b.line_cd,
  	   			 b.subline_cd,
	   			 b.iss_cd,
	   			 0 intm_no,
              	 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	  			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no) policy_no,
	   			 b.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS') ren_stat
            FROM giuw_pol_dist a,
       			 gipi_polbasic b,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e,
	   			 gipi_parlist d,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED POLICY' ren_flag
				   FROM gipi_polnrep a
				  WHERE 1=1
				    AND ren_rep_sw = 1
					AND a.old_policy_id >-1
					AND a.new_policy_id >-1) g
           WHERE 1=1
   		     AND a.policy_id = b.policy_id
			 AND b.policy_id = g.ren_policy(+)
   			 AND b.par_id = d.par_id
   			 AND a.dist_no = c.dist_no
   			 AND c.line_cd = e.line_cd
   			 AND c.share_cd = e.share_cd+0
   			 AND c.share_cd = e.share_cd+0
   			 AND c.line_cd >'%'
   			 AND c.share_cd > 0
   			 AND e.share_type IN ('1','2','3')
   			 AND b.iss_cd = 'RI'
           GROUP BY TRUNC(a.acct_ent_date),
 	   	   		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')),
	   			 TRUNC(b.eff_date),
	   			 TRUNC(b.issue_date),
       			 TRUNC(b.expiry_date),
       	 		 b.line_cd,
	   			 b.subline_cd,
	   			 b.iss_cd,
	   			 0,
	   		     NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no),
	   		     b.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS')
          UNION
		  SELECT TRUNC(a.acct_neg_date) acct_prod_date,
	   	  		 TO_DATE(NULL, 'MM/DD/YYYY') book_prod_date,
	   			 TO_DATE(NULL, 'MM/DD/YYYY') incept_prod_date,
	   			 TO_DATE(NULL, 'MM/DD/YYYY') issue_prod_date,
				 TRUNC(b.expiry_date) expiry_date,
       	 		 SUM(NVL(c.dist_tsi,0)*-1) prod_tsi,
	   			 SUM(NVL(c.dist_prem,0)*-1) prod_prem,
	   			 SUM(DECODE(b.endt_seq_no, 0, 1, 0)) prod_nop,
	   	         b.line_cd,
  	   			 b.subline_cd,
	   			 b.iss_cd,
	   			 0 intm_no,
                 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no) policy_no,
	   			 b.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS') ren_stat
            FROM giuw_pol_dist a,
        	   	 gipi_polbasic b,
       			 giuw_policyds_dtl c,
      			 giis_dist_share e,
	   			 gipi_parlist d,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED BUSINESS' ren_flag
				   FROM gipi_polnrep a
				  WHERE 1=1
				    AND ren_rep_sw = 1
					AND a.old_policy_id >-1
					AND a.new_policy_id >-1) g
           WHERE 1=1
             AND a.policy_id = b.policy_id
			 AND b.policy_id = g.ren_policy(+)
   		  	 AND b.par_id = d.par_id
   			 AND a.dist_no = c.dist_no
   			 AND c.line_cd = e.line_cd
   			 AND c.share_cd = e.share_cd+0
   			 AND c.share_cd = e.share_cd+0
   			 AND c.line_cd >'%'
   			 AND c.share_cd > 0
   			 AND e.share_type IN ('1','2','3')
   			 AND b.iss_cd = 'RI'
   			 AND a.acct_neg_date IS NOT NULL
           GROUP BY TRUNC(a.acct_neg_date),
 	   	  		 TO_DATE(NULL, 'MM/DD/YYYY'),
	   			 TO_DATE(NULL, 'MM/DD/YYYY'),
	   			 TO_DATE(NULL, 'MM/DD/YYYY'),
       			 TRUNC(b.expiry_date),
       	 		 b.line_cd,
	   			 b.subline_cd,
	   			 b.iss_cd,
	   			 0,
                 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no),
	   			 b.pol_flag,
				 NVL(g.ren_flag,'NEW BUSINESS'))
   GROUP BY acct_prod_date,
   		 book_prod_date,
		 incept_prod_date,
		 issue_prod_date,
		 expiry_date,
		 line,
		 subline,
		 branch,
		 intm,
		 intm_type,
		 assd,
		 policy_id,
		 RTRIM(policy_no),
		 pol_flag,
		 ren_stat;

IF SQL%FOUND THEN
  FOR cnt IN
      v_acct_date.first..v_acct_date.last
  LOOP
    INSERT INTO eim_production_ext (
      acct_prod_date, 	   line_name,
	  subline_name, 	   branch_name,
	  user_id, 			   intermediary_name,
	  intm_type_desc,	   assured_name,
	  prod_tsi, 		   prod_prem,
	  prod_nop, 		   policy_id,
 	  policy_no,		   book_prod_date,
	  incept_prod_date,	   issue_prod_date,
	  pol_flag,			   extraction_date,
	  line_cd,			   subline_cd,
	  branch_cd,		   intm_no,
	  intm_type,		   assd_no,
	  ytd_prem,			   ytd_tsi,
	  ytd_nop,			   ren_stat,
	  expiry_date)
    VALUES (
      v_acct_date(cnt),                 Get_Line_Name(v_line(cnt)),
	  Get_Subline_Name(v_subline(cnt)), Get_Iss_Name(v_branch(cnt)),
	  NULL,				   			    DECODE(NVL(v_intm(cnt),0), 0, NULL, Get_Intm_Name(v_intm(cnt))),
	  Get_Intm_Type_Desc(v_intm_type(cnt)), Get_Assd_Name(v_assd(cnt)),
	  v_prod_tsi(cnt),	   	            v_prod_prem(cnt),
	  v_prod_nop(cnt),	   	            v_pol_id(cnt),
	  v_pol_no(cnt),		            v_book_date(cnt),
	  v_inc_date(cnt),                  v_iss_date(cnt),
	  v_pol_flag(cnt),		            TRUNC(SYSDATE),
	  v_line(cnt),			            v_subline(cnt),
	  v_branch(cnt),		            v_intm(cnt),
	  v_intm_type(cnt),		            v_assd(cnt),
	  0,					            0,
 	  0,							    v_ren_stat(cnt),
	  v_exp_date(cnt));
  END LOOP;
  COMMIT;
END IF;
END;
/

DROP PROCEDURE CPI.EXT_PRODUCTION;
