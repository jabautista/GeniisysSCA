DROP PROCEDURE CPI.EXT_PRODUCTION_LOSS;

CREATE OR REPLACE PROCEDURE CPI.Ext_Production_Loss IS
/**
 Created by: Lhen Valderrama
 Date Modified : 09/09/03
 This bulk procedure will extract production summary(including RI production) versus losses
 summary on a particular period, regardless if there is no production summary but has losses
 summary and vice versa.
**/
TYPE tab_acct_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_book_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_iss_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_inc_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_prod_tsi		 IS TABLE OF eim_prodloss_ext.prod_prem%TYPE;
TYPE tab_prod_prem		 IS TABLE OF eim_prodloss_ext.prod_tsi%TYPE;
TYPE tab_prod_nop		 IS TABLE OF eim_prodloss_ext.prod_nop%TYPE;
TYPE tab_loss_prem		 IS TABLE OF eim_prodloss_ext.loss_prem%TYPE;
TYPE tab_res_amt	 	 IS TABLE OF eim_prodloss_ext.res_amt%TYPE;
TYPE tab_sett_amt	 	 IS TABLE OF eim_prodloss_ext.sett_amt%TYPE;
TYPE tab_loss_tsi		 IS TABLE OF eim_prodloss_ext.loss_tsi_amt%TYPE;
TYPE tab_no_cases		 IS TABLE OF eim_prodloss_ext.no_cases%TYPE;
TYPE tab_os_loss		 IS TABLE OF eim_prodloss_ext.os_loss_amt%TYPE;
TYPE tab_can_loss		 IS TABLE OF eim_prodloss_ext.can_loss_amt%TYPE;
TYPE tab_line			 IS TABLE OF eim_prodloss_ext.line_cd%TYPE;
TYPE tab_subline		 IS TABLE OF eim_prodloss_ext.subline_cd%TYPE;
TYPE tab_branch		 	 IS TABLE OF eim_prodloss_ext.branch_cd%TYPE;
TYPE tab_intm			 IS TABLE OF eim_prodloss_ext.intm_no%TYPE;
TYPE tab_intm_type		 IS TABLE OF eim_prodloss_ext.intm_type%TYPE;
TYPE tab_assd			 IS TABLE OF eim_prodloss_ext.assd_no%TYPE;
TYPE tab_pol_id		 	 IS TABLE OF eim_prodloss_ext.policy_id%TYPE;
TYPE tab_pol_no		 	 IS TABLE OF eim_prodloss_ext.policy_no%TYPE;
TYPE tab_pol_flag		 IS TABLE OF eim_prodloss_ext.pol_flag%TYPE;
TYPE tab_ren_stat		 IS TABLE OF eim_prodloss_ext.ren_stat%TYPE;

v_acct_date		 tab_acct_date;
v_book_date		 tab_book_date;
v_iss_date		 tab_iss_date;
v_inc_date		 tab_inc_date;
v_prod_tsi		 tab_prod_tsi;
v_prod_prem		 tab_prod_prem;
v_prod_nop		 tab_prod_nop;
v_loss_prem		 tab_loss_prem;
v_res_amt	 	 tab_res_amt;
v_sett_amt	 	 tab_sett_amt;
v_loss_tsi		 tab_loss_tsi;
v_no_cases		 tab_no_cases;
v_os_loss		 tab_os_loss;
v_can_loss		 tab_can_loss;
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

/** to delete previous data before extracting to have an updated data**/
DELETE eim_prodloss_ext
 WHERE user_id = USER;

/** union has been created here to grouped data of production and of losses **/
  SELECT acct_prod_date,
  		 book_prod_date,
		 incept_prod_date,
		 issue_prod_date,
		 line,
		 subline,
		 branch,
		 intm,
		 intm_type,
		 assd,
	   	 policy_id,
		 policy_no,
		 pol_flag,
		 ren_stat,
	   	 SUM(NVL(prod_tsi,0)) prod_tsi,
	   	 SUM(NVL(prod_prem,0)) prod_prem,
	   	 SUM(NVL(prod_nop,0)) prod_nop,
		 SUM(NVL(loss_prem,0)) loss_prem,
	   	 SUM(NVL(reserve_amt,0)) reserve_amt,
	   	 SUM(NVL(settled_amt,0)) settled_amt,
	   	 SUM(NVL(loss_tsi_amt,0)) loss_tsi,
	   	 SUM(NVL(no_cases,0)) no_cases,
	   	 SUM(NVL(os_losses,0)) os_losses,
	   	 SUM(NVL(cancelled_losses,0)) cancelled_loss
	BULK COLLECT INTO
	  	 v_acct_date,
		 v_book_date,
		 v_iss_date	,
		 v_inc_date	,
		 v_line		,
		 v_subline	,
		 v_branch	,
		 v_intm		,
		 v_intm_type,
		 v_assd		,
		 v_pol_id	,
		 v_pol_no	,
		 v_pol_flag ,
		 v_ren_stat ,
		 v_prod_tsi	,
		 v_prod_prem,
		 v_prod_nop	,
		 v_loss_prem,
		 v_res_amt	,
		 v_sett_amt	,
		 v_loss_tsi	,
		 v_no_cases	,
		 v_os_loss	,
		 v_can_loss
    FROM (SELECT TRUNC(a.acct_ent_date) acct_prod_date,
	 		     LAST_DAY(TO_DATE(a.booking_mth || ',' || TO_CHAR(a.booking_year),'FMMONTH,YYYY')) book_prod_date,
			   	 TRUNC(a.eff_date) incept_prod_date,
			   	 TRUNC(a.issue_date) issue_prod_date,
       	 		 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch,
	   			 c.intrmdry_intm_no intm,
				 i.intm_type,
	   			 b.assd_no assd,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no) policy_no,
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY') ren_stat,
            	 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2)) prod_tsi,
       			 SUM(ROUND(c.premium_amt*d.currency_rt,2)) prod_prem,
       			 SUM(DECODE(a.endt_seq_no, 0,1,0)) prod_nop,
				 0 loss_prem,
	   			 0 reserve_amt,
	   			 0 settled_amt,
	   			 0 loss_tsi_amt,
	   			 0 no_cases,
	   			 0 os_losses,
	   			 0 cancelled_losses
	   		FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
	   			 giis_intermediary i,
      			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED POLICY' ren_flag
				   FROM gipi_polnrep a
				  WHERE ren_rep_sw = 1) g
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
       	 		 f.line_cd,
	   			 f.subline_cd,
	   			 a.iss_cd,
	   			 c.intrmdry_intm_no,
				 i.intm_type,
	   			 b.assd_no,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no),
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY')
          UNION
		  SELECT TRUNC(a.spld_acct_ent_date) acct_prod_date,
		  		 TO_DATE(NULL, 'MM/DD/YYYY') book_prod_date,
				 TO_DATE(NULL, 'MM/DD/YYYY') incept_prod_date,
				 TO_DATE(NULL, 'MM/DD/YYYY') issue_prod_date,
                 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch,
	   			 c.intrmdry_intm_no intm,
				 i.intm_type,
	   			 b.assd_no assd,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no) policy_no,
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY') ren_stat,
				 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2) * -1) prod_tsi,
       			 SUM(ROUND(c.premium_amt*d.currency_rt,2) * -1) prod_prem,
       			 SUM(DECODE(a.endt_seq_no, 0,1,0)) prod_nop,
				 0 loss_prem,
	   			 0 reserve_amt,
	   			 0 settled_amt,
	   			 0 loss_tsi_amt,
	   			 0 no_cases,
	   			 0 os_losses,
	   			 0 cancelled_losses
	        FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
				 giis_intermediary i,
       			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED POLICY' ren_flag
				   FROM gipi_polnrep a
				  WHERE ren_rep_sw = 1) g
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
                 f.line_cd,
	   			 f.subline_cd,
	   			 a.iss_cd,
	   			 c.intrmdry_intm_no,
				 i.intm_type,
	   			 b.assd_no,
				 a.policy_id,
				 RTRIM(a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no),
				 a.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY')
		  UNION
		  SELECT TRUNC(a.acct_ent_date) acct_prod_date,
	   	  		 LAST_DAY(TO_DATE(b.booking_mth || ',' || TO_CHAR(b.booking_year),'FMMONTH,YYYY')) book_prod_date,
	   			 TRUNC(b.eff_date) incept_prod_date,
	   			 TRUNC(b.issue_date) issue_prod_date,
       			 b.line_cd,
  	   			 b.subline_cd,
	   			 b.iss_cd,
	   			 0 intm_no,
              	 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no) policy_no,
	   			 b.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY') ren_stat,
				 SUM(NVL(c.dist_tsi,0)) prod_tsi,
	   			 SUM(NVL(c.dist_prem,0)) prod_prem,
	   			 SUM(DECODE(b.endt_seq_no, 0, 1, 0)) prod_nop,
	   			 0 loss_prem,
       			 0 reserve_amt,
	   			 0 settled_amt,
	   			 0 loss_tsi_amt,
	   			 0 no_cases,
	   			 0 os_losses,
	   			 0 cancelled_losses
            FROM giuw_pol_dist a,
      		 	 gipi_polbasic b,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e,
	   			 gipi_parlist d,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED POLICY' ren_flag
				   FROM gipi_polnrep a
				  WHERE ren_rep_sw = 1) g
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
       			 b.line_cd,
  	   			 b.subline_cd,
	   			 b.iss_cd,
	   			 0,
              	 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no),
	   			 b.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY')
		  UNION
		  SELECT TRUNC(a.acct_neg_date) acct_prod_date,
	   	  		 TO_DATE(NULL, 'MM/DD/YYYY') book_prod_date,
	   			 TO_DATE(NULL, 'MM/DD/YYYY') incept_prod_date,
	   			 TO_DATE(NULL, 'MM/DD/YYYY') issue_prod_date,
       			 b.line_cd,
  	   			 b.subline_cd,
	  			 b.iss_cd,
	   			 0 intm_no,
                 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no) policy_no,
	  			 b.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY') ren_stat,
				 SUM(NVL(c.dist_tsi,0)*-1) prod_tsi,
	   			 SUM(NVL(c.dist_prem,0)*-1) prod_prem,
	   			 SUM(DECODE(b.endt_seq_no, 0, 1, 0)) prod_nop,
	   			 0 loss_prem,
				 0 reserve_amt,
	   			 0 settled_amt,
	   			 0 loss_tsi_amt,
	   			 0 no_cases,
	   			 0 os_losses,
	   			 0 cancelled_losses
  			FROM giuw_pol_dist a,
       			 gipi_polbasic b,
       			 giuw_policyds_dtl c,
       			 giis_dist_share e,
	   			 gipi_parlist d,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED POLICY' ren_flag
				   FROM gipi_polnrep a
				  WHERE ren_rep_sw = 1) g
 		   WHERE 1=1
   		     AND a.policy_id = b.policy_id
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
       			 b.line_cd,
  	   			 b.subline_cd,
	  			 b.iss_cd,
	   			 0,
                 NULL,
	   			 d.assd_no,
	   			 b.policy_id,
	   			 RTRIM(b.line_cd||'-'||b.subline_cd||'-'||b.iss_cd||'-'||b.issue_yy||'-'||b.pol_seq_no||'-'||b.renew_no),
	  			 b.pol_flag,
				 NVL(g.ren_flag,'NEW POLICY')
	 	  UNION
		  SELECT TRUNC(a.clm_file_date) acct_prod_date,
				 TRUNC(a.clm_file_date) book_prod_date,
				 TRUNC(a.clm_file_date) incept_prod_date,
				 TRUNC(a.clm_file_date) issue_prod_date,
	   	  		 a.line_cd line,
	   			 a.subline_cd subline,
	   			 a.pol_iss_cd branch,
	   			 c.intm_no intm,
				 i.intm_type,
	   			 a.assd_no assd,
				 e.policy_id,
	   			 RTRIM(e.line_cd||'-'||e.subline_cd||'-'||e.iss_cd||'-'||e.issue_yy||'-'||e.pol_seq_no||'-'||e.renew_no) policy_no,
	   			 e.pol_flag,
				 NVL(h.ren_flag, 'NEW POLICY') ren_stat,
				 0 prod_tsi,
	   			 0 prod_prem,
	   			 0 prod_nop,
				 e.prem_amt loss_prem,
	   			 SUM(NVL(f.reserve_expenses,0) + NVL(f.reserve_losses,0)) reserve_amt,
       			 SUM(NVL(g.exp_paid,0) + NVL(g.losses_paid,0)) settled_amt,
       			 SUM(NVL(b.ann_tsi_amt,0)) tsi_amt,
       			 COUNT(DISTINCT b.claim_id) no_cases,/*to count distinct claim_id in gicl_item_peril*/
       			 SUM(DECODE(SIGN(DECODE(a.clm_stat_cd, 'WD', 0, 'CC', 0,'DN', 0, 'CD', 0,
	          	 		     (NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + (NVL(f.reserve_losses,0) - NVL(g.losses_paid,0)))), -1, 0,
			  			         DECODE(a.clm_stat_cd, 'WD', 0, 'CC', 0,'DN', 0, 'CD', 0,
	          				 (NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + (NVL(f.reserve_losses,0) - NVL(g.losses_paid,0))))) os_loss ,
	   			 SUM(DECODE(a.clm_stat_cd, 'AA', 0, 'AP', 0, 'CD', 0, 'FN', 0, 'FP', 0, 'NO', 0, 'NW', 0, 'OP', 0, 'PB', 0,
				            (NVL(f.reserve_expenses,0) - NVL(g.exp_paid,0)) + (NVL(f.reserve_losses,0) - NVL(g.losses_paid,0)))) cancelled_losses
            FROM gicl_claims a,
       			 gicl_item_peril b,
       			 gicl_intm_itmperil c,
				 giis_intermediary i,
       			 gipi_polbasic e,
          		 (SELECT SUM(NVL(expense_reserve,0)) reserve_expenses,
		  		  		 SUM(NVL(loss_reserve,0)) reserve_losses,
               	  		 claim_id,
  		   	   	  		 item_no,
			   	  		 peril_cd
                    FROM gicl_clm_res_hist
                   WHERE 1=1
                     AND NVL(dist_sw, 'N') = 'Y'
           	  		 AND claim_id >0
				   GROUP BY claim_id,
  		   	   	  		 item_no,
			   	  		 peril_cd) f,
		         (SELECT a.claim_id,
	   		   	  		 a.item_no,
			   	  		 a.peril_cd,
               	  		 SUM(NVL(a.losses_paid,0)) losses_paid,
               	  		 SUM(NVL(a.expenses_paid,0)) exp_paid
                    FROM gicl_clm_res_hist a ,
		  	   	  		 gicl_item_peril b
                   WHERE 1 = 1
		             AND a.claim_id = b.claim_id
		   	  		 AND a.item_no = b.item_no
		   	  		 AND a.peril_cd = b.peril_cd
           	  		 AND a.tran_id IS NOT NULL
           	  		 AND NVL(a.cancel_tag,'N') = 'N'
				   GROUP BY a.claim_id,
	   		   	  		 a.item_no,
			   	  		 a.peril_cd) g,
				 (SELECT DISTINCT a.old_policy_id ren_policy,
				        'RENEWED POLICY' ren_flag
				   FROM gipi_polnrep a
				  WHERE ren_rep_sw = 1) h
           WHERE 1=1
             AND a.claim_id = b.claim_id+0
   			 AND a.claim_id = b.claim_id+0
   			 AND b.claim_id = f.claim_id(+)
   			 AND b.claim_id = g.claim_id(+)
   			 AND b.item_no  = g.item_no(+)
   			 AND b.peril_cd = g.peril_cd(+)
   			 AND b.item_no = f.item_no(+)
   			 AND b.peril_cd = f.peril_cd(+)
			 AND e.policy_id = h.ren_policy(+)
   			 AND b.claim_id = c.claim_id
   			 AND b.peril_cd = c.peril_cd
   			 AND b.item_no =  c.item_no
   			 AND a.line_cd = e.line_cd
  			 AND a.subline_cd = e.subline_cd
   			 AND a.pol_iss_cd = e.iss_cd
   			 AND a.issue_yy = e.issue_yy
   			 AND a.pol_seq_no = e.pol_seq_no
   			 AND a.renew_no = e.renew_no
			 AND c.intm_no = i.intm_no
   			 AND a.claim_id>0
		   GROUP BY TRUNC(a.clm_file_date),
				 TRUNC(a.clm_file_date),
				 TRUNC(a.clm_file_date),
				 TRUNC(a.clm_file_date),
	   	  		 a.line_cd,
	   			 a.subline_cd,
	   			 a.pol_iss_cd,
	   			 c.intm_no,
				 i.intm_type,
	   			 a.assd_no,
				 e.policy_id,
	   			 RTRIM(e.line_cd||'-'||e.subline_cd||'-'||e.iss_cd||'-'||e.issue_yy||'-'||e.pol_seq_no||'-'||e.renew_no),
	   			 e.pol_flag,
				 NVL(h.ren_flag, 'NEW POLICY'),
				 e.prem_amt)
   GROUP BY acct_prod_date,
  		 book_prod_date,
		 incept_prod_date,
		 issue_prod_date,
		 line,
		 subline,
		 branch,
		 intm,
		 intm_type,
		 assd,
	   	 policy_id,
		 policy_no,
		 pol_flag,
		 ren_stat;

  IF SQL%FOUND THEN
     FOR cnt IN
	   v_acct_date.first..v_acct_date.last
	 LOOP
	   INSERT INTO eim_prodloss_ext (
       	 acct_prod_date, 	   line_name,
		 subline_name, 		   branch_name,
		 user_id, 			   intermediary_name,
		 intm_type_desc,	   assured_name,
		 prod_tsi, 			   prod_prem,
		 prod_nop, 			   res_amt,
		 sett_amt, 			   loss_tsi_amt,
		 no_cases, 			   os_loss_amt,
		 can_loss_amt,		   loss_prem,
		 policy_id,			   policy_no,
		 book_prod_date,	   incept_prod_date,
		 issue_prod_date,	   pol_flag,
		 extraction_date,	   line_cd,
		 subline_cd,		   branch_cd,
		 intm_no,			   intm_type,
		 assd_no,			   ren_stat)
       VALUES (
       	 v_acct_date(cnt),	                   Get_Line_Name(v_line(cnt)),
		 Get_Subline_Name(v_subline(cnt)),	   Get_Iss_Name(v_branch(cnt)),
		 NULL,				   				   DECODE(v_intm(cnt), 0, NULL, Get_Intm_Name(v_intm(cnt))),
		 Get_Intm_Type_Desc(v_intm_type(cnt)), Get_Assd_Name(v_assd(cnt)),
		 v_prod_tsi(cnt),      				   v_prod_prem(cnt),
		 v_prod_nop(cnt),	   				   v_res_amt(cnt),
		 v_sett_amt(cnt),	   				   v_loss_tsi(cnt),
		 v_no_cases(cnt),      				   v_os_loss(cnt),
		 v_can_loss(cnt),	   				   v_loss_prem(cnt),
		 v_pol_id(cnt),		   				   RTRIM(v_pol_no(cnt)),
		 v_book_date(cnt),	   				   v_inc_date(cnt),
		 v_iss_date(cnt),      				   v_pol_flag(cnt),
		 TRUNC(SYSDATE),	   				   v_line(cnt),
		 v_subline(cnt),	   				   v_branch(cnt),
		 v_intm(cnt),		   				   v_intm_type(cnt),
		 v_assd(cnt),						   v_ren_stat(cnt));
	 END LOOP;
     COMMIT;
  END IF;
END;
/

DROP PROCEDURE CPI.EXT_PRODUCTION_LOSS;
