DROP PROCEDURE CPI.EXT_REINSURANCE;

CREATE OR REPLACE PROCEDURE CPI.Ext_Reinsurance IS

/** Created by: Lhen Valderrama
    Date Created  : 09/15/03
	Date Modified : 10/06/03
	This bulk procedure will extract the data for Reinsurance Production only with Outward,
	Inward and Difference amount.
**/

TYPE tab_acct_date	     IS TABLE OF eim_reinsurance_ext.acct_prod_date%TYPE;
TYPE tab_book_date	     IS TABLE OF eim_reinsurance_ext.booking_date%TYPE;
TYPE tab_incept_date	 IS TABLE OF eim_reinsurance_ext.incept_date%TYPE;
TYPE tab_issue_date	     IS TABLE OF eim_reinsurance_ext.issue_date%TYPE;
TYPE tab_line	         IS TABLE OF eim_reinsurance_ext.line_cd%TYPE;
TYPE tab_subline		 IS TABLE OF eim_reinsurance_ext.subline_cd%TYPE;
TYPE tab_branch		 	 IS TABLE OF eim_reinsurance_ext.branch_cd%TYPE;
TYPE tab_ri		         IS TABLE OF eim_reinsurance_ext.ri_name%TYPE;
TYPE tab_out_nop		 IS TABLE OF eim_reinsurance_ext.outw_nop%TYPE;
TYPE tab_out_prem	 	 IS TABLE OF eim_reinsurance_ext.outw_prem_amt%TYPE;
TYPE tab_out_tsi		 IS TABLE OF eim_reinsurance_ext.out_tsi_amt%TYPE;
TYPE tab_in_nop		     IS TABLE OF eim_reinsurance_ext.inw_nop%TYPE;
TYPE tab_in_prem		 IS TABLE OF eim_reinsurance_ext.inw_prem_amt%TYPE;
TYPE tab_in_tsi		     IS TABLE OF eim_reinsurance_ext.inw_tsi_amt%TYPE;
TYPE tab_diff_nop		 IS TABLE OF eim_reinsurance_ext.diff_nop%TYPE;
TYPE tab_diff_prem		 IS TABLE OF eim_reinsurance_ext.diff_prem_amt%TYPE;
TYPE tab_diff_tsi		 IS TABLE OF eim_reinsurance_ext.diff_tsi_amt%TYPE;

v_acct_date			 tab_acct_date;
v_book_date			 tab_book_date;
v_incept_date		 tab_incept_date;
v_issue_date		 tab_issue_date;
v_line				 tab_line;
v_subline			 tab_subline;
v_branch			 tab_branch;
v_ri				 tab_ri;
v_out_nop			 tab_out_nop;
v_out_prem			 tab_out_prem;
v_out_tsi			 tab_out_tsi;
v_in_nop			 tab_in_nop;
v_in_prem			 tab_in_prem;
v_in_tsi			 tab_in_tsi;
v_diff_nop			 tab_diff_nop;
v_diff_prem			 tab_diff_prem;
v_diff_tsi			 tab_diff_tsi;

BEGIN

DELETE eim_reinsurance_ext
 WHERE user_id = USER;

  SELECT acct_prod_date,
	   	 booking_date,
	   	 incept_date,
		 issue_date,
      	 line_cd,
	   	 subline_cd,
	   	 iss_cd,
      	 ri_name,
       	 SUM(NVL(outw_nop,0)) outw_nop,
       	 SUM(NVL(share_amt,0)) outw_prem_amt,
       	 SUM(NVL(share_tsi_amt,0)) outw_tsi_amt,
       	 SUM(NVL(inw_nop,0)) inw_nop,
       	 SUM(NVL(prem,0)) inw_prem,
       	 SUM(NVL(tsi,0)) inw_tsi,
	   	 SUM(NVL(inw_nop,0) - NVL(outw_nop,0)) diff_nop,
	   	 SUM(NVL(prem,0) - NVL(share_amt,0)) diff_prem,
	   	 SUM(NVL(tsi,0) - NVL(share_tsi_amt,0)) diff_tsi
    BULK COLLECT INTO
	     v_acct_date     ,
		 v_book_date	 ,
		 v_incept_date	 ,
		 v_issue_date	 ,
		 v_line			 ,
		 v_subline		 ,
		 v_branch		 ,
		 v_ri			 ,
		 v_out_nop		 ,
		 v_out_prem		 ,
		 v_out_tsi		 ,
		 v_in_nop		 ,
		 v_in_prem		 ,
		 v_in_tsi		 ,
		 v_diff_nop		 ,
		 v_diff_prem	 ,
		 v_diff_tsi
    FROM (SELECT TRUNC(b250.acct_ent_date) acct_prod_date,
	  		     LAST_DAY(TO_DATE(b250.booking_mth || ',' || TO_CHAR(b250.booking_year),'FMMONTH,YYYY')) booking_date,
			     TRUNC(b250.eff_date) incept_date,
			 	 TRUNC(b250.issue_date) issue_date,
             	 b250.line_cd,
	  		 	 b250.subline_cd,
			 	 b250.iss_cd,
			 	 a140.ri_name ri_name,
			 	 SUM(DECODE(NVL(b250.endt_seq_no,0), 0, 1, 0)) outw_nop,
			 	 SUM(NVL(d005.ri_prem_amt,0)) share_amt,
             	 SUM(NVL(d005.ri_tsi_amt,0)) share_tsi_amt,
			 	 0 inw_nop,
			 	 0 prem,
			 	 0 tsi
            FROM gipi_polbasic b250,
                 giuw_pol_dist c080,
                 giri_distfrps d060,
             	 giri_frps_ri d070,
             	 gipi_parlist b240,
             	 giri_binder d005,
             	 giis_line a120,
             	 giis_subline a130,
             	 giis_reinsurer a140
           WHERE d060.line_cd >= '%'
             AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
         	 AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
         	 AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
         	 AND c080.dist_no = d060.dist_no
         	 AND b250.par_id = b240.par_id
         	 AND c080.policy_id = b250.policy_id
         	 AND d070.fnl_binder_id = d005.fnl_binder_id
         	 AND NVL (a120.line_cd, a120.line_cd) = NVL (b250.line_cd, b250.line_cd)
         	 AND NVL (b250.line_cd, b250.line_cd) = NVL (a130.line_cd, a130.line_cd)
         	 AND NVL (b250.subline_cd, b250.subline_cd) = NVL (a130.subline_cd, a130.subline_cd)
         	 AND d005.ri_cd = a140.ri_cd
         	 AND NVL (b250.endt_type, 'A') = 'A'
         	 AND d005.reverse_date IS NULL
	       GROUP BY TRUNC(b250.acct_ent_date),
	  		 	 LAST_DAY(TO_DATE(b250.booking_mth || ',' || TO_CHAR(b250.booking_year),'FMMONTH,YYYY')),
			 	 TRUNC(b250.eff_date),
			 	 TRUNC(b250.issue_date),
             	 b250.line_cd,
	  		 	 b250.subline_cd,
			 	 b250.iss_cd,
			 	 a140.ri_name
	      UNION
	      SELECT TRUNC(b250.spld_acct_ent_date) acct_prod_date,
	  		 	 TO_DATE(NULL, 'DD/MM/YYYY') booking_date,
			 	 TO_DATE(NULL, 'DD/MM/YYYY') incept_date,
			 	 TO_DATE(NULL, 'DD/MM/YYYY') issue_date,
             	 b250.line_cd,
	  		 	 b250.subline_cd,
			 	 b250.iss_cd,
			 	 a140.ri_name ri_name,
			 	 SUM(DECODE(NVL(b250.endt_seq_no,0), 0, 1, 0)) outw_nop,
			 	 SUM(NVL(d005.ri_prem_amt,0)*-1) share_amt,
             	 SUM(NVL(d005.ri_tsi_amt,0)*-1) share_tsi_amt,
			 	 0 inw_nop,
			 	 0 prem,
			 	 0 tsi
            FROM gipi_polbasic b250,
             	 giuw_pol_dist c080,
             	 giri_distfrps d060,
             	 giri_frps_ri d070,
             	 gipi_parlist b240,
             	 giri_binder d005,
             	 giis_line a120,
             	 giis_subline a130,
             	 giis_reinsurer a140
           WHERE d060.line_cd >= '%'
             AND NVL (d060.line_cd, d060.line_cd) = d070.line_cd
         	 AND NVL (d060.frps_yy, d060.frps_yy) = d070.frps_yy
         	 AND NVL (d060.frps_seq_no, d060.frps_seq_no) = d070.frps_seq_no
         	 AND c080.dist_no = d060.dist_no
         	 AND b250.par_id = b240.par_id
         	 AND c080.policy_id = b250.policy_id
         	 AND d070.fnl_binder_id = d005.fnl_binder_id
         	 AND NVL (a120.line_cd, a120.line_cd) = NVL (b250.line_cd, b250.line_cd)
         	 AND NVL (b250.line_cd, b250.line_cd) = NVL (a130.line_cd, a130.line_cd)
         	 AND NVL (b250.subline_cd, b250.subline_cd) = NVL (a130.subline_cd, a130.subline_cd)
         	 AND d005.ri_cd = a140.ri_cd
         	 AND NVL (b250.endt_type, 'A') = 'A'
         	 AND d005.reverse_date IS NULL
	       GROUP BY TRUNC(b250.spld_acct_ent_date),
	  		 	 TO_DATE(NULL, 'DD/MM/YYYY'),
			 	 TO_DATE(NULL, 'DD/MM/YYYY'),
			 	 TO_DATE(NULL, 'DD/MM/YYYY'),
             	 b250.line_cd,
	  		 	 b250.subline_cd,
			 	 b250.iss_cd,
			 	 a140.ri_name
		  UNION
		  SELECT TRUNC(b.acct_ent_date) acct_prod_date,
       	   		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')) booking_date,
  	 			 TRUNC(b.eff_date) incept_date,
				 TRUNC(b.issue_date) issue_date,
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name,
				 0 outw_nop,
               	 0 share_amt,
              	 0 share_tsi_amt,
               	 SUM(DECODE(NVL(b.endt_seq_no,0), 0, 1, 0)) inw_nop,
               	 SUM(NVL(ROUND(NVL(c.dist_prem,0) * d.trty_shr_pct / 100, 2),0)) prem,
               	 SUM(NVL(ROUND(NVL(c.dist_tsi,0) * d.trty_shr_pct / 100 ,2),0)) tsi
            FROM giuw_pol_dist a,
               	 gipi_polbasic b,
               	 giuw_policyds_dtl c,
               	 giis_dist_share e,
               	 giis_trty_panel d,
               	 giis_reinsurer f
           WHERE 1=1
             AND a.policy_id = b.policy_id
      	   	 AND a.dist_no = c.dist_no
      	   	 AND c.line_cd = e.line_cd
      	   	 AND c.share_cd = e.share_cd+0
      	   	 AND c.share_cd = e.share_cd+0
      	   	 AND e.share_cd = d.trty_seq_no
      	   	 AND e.line_cd = d.line_cd
      	   	 AND e.trty_yy = d.trty_yy
      	   	 AND d.ri_cd = f.ri_cd
      	   	 AND c.line_cd >'%'
      	   	 AND c.share_cd > 0
      	   	 AND e.share_type = '2'
			 AND NVL(b.endt_type, 'A') = 'A'
           GROUP BY TRUNC(b.acct_ent_date),
       	   		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')),
  	 			 TRUNC(b.eff_date),
				 TRUNC(b.issue_date),
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name
          UNION
          SELECT TRUNC(b.spld_acct_ent_date) acct_prod_date,
			   	 TO_DATE(NULL, 'DD/MM/YYYY') booking_date,
			   	 TO_DATE(NULL, 'DD/MM/YYYY') incept_date,
				 TO_DATE(NULL, 'DD/MM/YYYY') issue_date,
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name,
               	 0 outw_nop,
               	 0 share_amt,
               	 0 share_tsi_amt,
               	 SUM(DECODE(NVL(b.endt_seq_no,0), 0, 1, 0)) inw_nop,
               	 SUM(ROUND(NVL(c.dist_prem,0) * d.trty_shr_pct / 100, 2)*-1) prem,
               	 SUM(ROUND(NVL(c.dist_tsi,0) * d.trty_shr_pct / 100 ,2)*-1) tsi
            FROM giuw_pol_dist a,
               	 gipi_polbasic b,
               	 giuw_policyds_dtl c,
               	 giis_dist_share e,
               	 giis_trty_panel d,
               	 giis_reinsurer f
           WHERE 1=1
             AND a.policy_id = b.policy_id
           	 AND a.dist_no = c.dist_no
           	 AND c.line_cd = e.line_cd
           	 AND c.share_cd = e.share_cd+0
           	 AND c.share_cd = e.share_cd+0
           	 AND e.share_cd = d.trty_seq_no
           	 AND e.line_cd = d.line_cd
           	 AND e.trty_yy = d.trty_yy
           	 AND d.ri_cd = f.ri_cd
           	 AND c.line_cd >'%'
           	 AND c.share_cd > 0
           	 AND e.share_type = '2'
			 AND NVL(b.endt_type, 'A') = 'A'
           GROUP BY TRUNC(b.spld_acct_ent_date),
		 	   	 TO_DATE(NULL, 'DD/MM/YYYY'),
			   	 TO_DATE(NULL, 'DD/MM/YYYY'),
				 TO_DATE(NULL, 'DD/MM/YYYY'),
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name
 		  UNION
		  SELECT TRUNC(b.acct_ent_date) acct_prod_date,
       	   		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')) booking_date,
  	 			 TRUNC(b.eff_date) incept_date,
				 TRUNC(b.issue_date) issue_date,
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name,
               	 0 outw_nop,
               	 0 share_amt,
               	 0 share_tsi_amt,
               	 SUM(DECODE(NVL(b.endt_seq_no,0), 0, 1, 0)) inw_nop,
               	 SUM(NVL(c.dist_prem,0)) prem,
			   	 SUM(NVL(c.dist_tsi,0)) tsi
            FROM giuw_pol_dist a,
               	 gipi_polbasic b,
               	 giuw_policyds_dtl c,
               	 giis_dist_share e,
               	 giri_inpolbas d,
               	 giis_reinsurer f
           WHERE 1=1
             AND a.policy_id = b.policy_id
      	   	 AND a.policy_id = d.policy_id
      	   	 AND a.dist_no = c.dist_no
      	   	 AND c.line_cd = e.line_cd
      	   	 AND c.share_cd = e.share_cd+0
      	   	 AND c.share_cd = e.share_cd+0
      	   	 AND d.ri_cd = f.ri_cd
      	   	 AND c.line_cd >'%'
      	   	 AND c.share_cd > 0
      	   	 AND e.share_type = '1'
      	   	 AND b.iss_cd = 'RI'
			 AND NVL(b.endt_type, 'A') = 'A'
           GROUP BY TRUNC(b.acct_ent_date),
       	   		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')),
  	 			 TRUNC(b.eff_date),
				 TRUNC(b.issue_date),
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name
          UNION
          SELECT TRUNC(b.spld_acct_ent_date) acct_prod_date,
			   	 TO_DATE(NULL, 'DD/MM/YYYY') booking_date,
			   	 TO_DATE(NULL, 'DD/MM/YYYY') incept_date,
				 TO_DATE(NULL, 'DD/MM/YYYY') issue_date,
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name,
               	 0 outw_nop,
               	 0 share_amt,
               	 0 share_tsi_amt,
               	 SUM(DECODE(NVL(b.endt_seq_no,0), 0, 1, 0)) inw_nop,
               	 SUM(NVL(c.dist_prem,0)*-1) prem,
			   	 SUM(NVL(c.dist_tsi,0)*-1) tsi
            FROM giuw_pol_dist a,
               	 gipi_polbasic b,
               	 giuw_policyds_dtl c,
               	 giis_dist_share e,
               	 giri_inpolbas d,
               	 giis_reinsurer f
           WHERE 1=1
             AND a.policy_id = b.policy_id
       	   	 AND a.policy_id = d.policy_id
       	   	 AND a.dist_no = c.dist_no
       	   	 AND c.line_cd = e.line_cd
       	   	 AND c.share_cd = e.share_cd+0
       	   	 AND c.share_cd = e.share_cd+0
       	   	 AND d.ri_cd = f.ri_cd
       	   	 AND c.line_cd >'%'
       	   	 AND c.share_cd > 0
       	   	 AND e.share_type = '1'
       	   	 AND b.iss_cd = 'RI'
			 AND NVL(b.endt_type, 'A') = 'A'
           GROUP BY TRUNC(b.spld_acct_ent_date),
			   	 TO_DATE(NULL, 'DD/MM/YYYY'),
			   	 TO_DATE(NULL, 'DD/MM/YYYY'),
				 TO_DATE(NULL, 'DD/MM/YYYY'),
               	 b.line_cd,
			   	 b.subline_cd,
			   	 b.iss_cd,
               	 f.ri_name)
   GROUP BY acct_prod_date,
      	 booking_date,
	  	 incept_date,
		 issue_date,
      	 line_cd,
	  	 subline_cd,
	  	 iss_cd,
      	 ri_name;

IF SQL%FOUND THEN
   FOR cnt IN
       v_acct_date.first..v_acct_date.last
   LOOP
     INSERT INTO eim_reinsurance_ext (
       line_cd,  			         subline_cd,
	   branch_cd, 					 user_id,
	   acct_prod_date, 			 	 booking_date,
	   incept_date, 				 issue_date,
	   ri_name,					 	 outw_nop,
	   outw_prem_amt,				 out_tsi_amt,
	   inw_nop,					 	 inw_prem_amt,
	   inw_tsi_amt,				 	 diff_nop,
	   diff_prem_amt,				 diff_tsi_amt,
	   line_name,					 subline_name,
	   branch_name,				 	 extraction_date)
     VALUES (
       v_line(cnt),		         	 v_subline(cnt),
	   v_branch(cnt),		       	 NULL,
	   v_acct_date(cnt),             v_book_date(cnt),
	   v_incept_date(cnt),           v_issue_date(cnt),
	   v_ri(cnt),		             v_out_nop(cnt),
	   v_out_prem(cnt),	             v_out_tsi(cnt),
	   v_in_nop(cnt),		         v_in_prem(cnt),
	   v_in_tsi(cnt),				 v_diff_nop(cnt),
	   v_diff_prem(cnt),		     v_diff_tsi(cnt),
	   Get_Line_Name(v_line(cnt)),   Get_Subline_Name(v_subline(cnt)),
	   Get_Iss_Name(v_branch(cnt)),	 TRUNC(SYSDATE));
   END LOOP;
   COMMIT;
END IF;
END;
/

DROP PROCEDURE CPI.EXT_REINSURANCE;
