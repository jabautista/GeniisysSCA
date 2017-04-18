DROP PROCEDURE CPI.EXT_RENEWALS;

CREATE OR REPLACE PROCEDURE CPI.Ext_Renewals IS

/** Created by : Lhen Valderrama
    Date Created/Modified : 09/12/03
	This bulk procedure will extract data for renewal table which includes renewable_amt(premiums
	that are expiring on a given year and month), unrenewed_amt (premiums which are not
	renewed	after the expiration), renewals_amt (premiums that are being renewed before
	expiry year and	month) and late_renewals_amt (premiums that are being renewed after the
	expiry year and month).
    Functions for late renewed amounts and NOPs, renewed amounts and NOPs are included in
	this process.
**/

TYPE tab_line			 IS TABLE OF eim_renewals_ext.line_cd%TYPE;
TYPE tab_line_name	     IS TABLE OF eim_renewals_ext.line_name%TYPE;
TYPE tab_subline		 IS TABLE OF eim_renewals_ext.subline_cd%TYPE;
TYPE tab_subline_name	 IS TABLE OF eim_renewals_ext.subline_name%TYPE;
TYPE tab_branch		 	 IS TABLE OF eim_renewals_ext.branch_cd%TYPE;
TYPE tab_intm			 IS TABLE OF eim_renewals_ext.intm_no%TYPE;
TYPE tab_assd			 IS TABLE OF eim_renewals_ext.assd_no%TYPE;
TYPE tab_policy		 	 IS TABLE OF eim_renewals_ext.policy_id%TYPE;
TYPE tab_policy_no		 IS TABLE OF eim_renewals_ext.policy_no%TYPE;
TYPE tab_issue_yy		 IS TABLE OF eim_renewals_ext.issue_yy%TYPE;
TYPE tab_pol_seq_no		 IS TABLE OF eim_renewals_ext.pol_seq_no%TYPE;
TYPE tab_renew_no		 IS TABLE OF eim_renewals_ext.renew_no%TYPE;
TYPE tab_old_pol		 IS TABLE OF eim_renewals_ext.old_policy_id%TYPE;
TYPE tab_new_pol		 IS TABLE OF eim_renewals_ext.new_policy_id%TYPE;
TYPE tab_exp_date		 IS TABLE OF eim_renewals_ext.expiry_date%TYPE;
TYPE tab_ren_date		 IS TABLE OF eim_renewals_ext.renewed_date%TYPE;
TYPE tab_renble_tsi		 IS TABLE OF eim_renewals_ext.renewable_tsi_amt%TYPE;
TYPE tab_late_tsi		 IS TABLE OF eim_renewals_ext.late_tsi_amt%TYPE;
TYPE tab_renwd_tsi		 IS TABLE OF eim_renewals_ext.renewed_tsi_amt%TYPE;
TYPE tab_renwls_tsi		 IS TABLE OF eim_renewals_ext.renewals_tsi_amt%TYPE;
TYPE tab_renble_nop		 IS TABLE OF eim_renewals_ext.renewable_nop%TYPE;
TYPE tab_late_nop		 IS TABLE OF eim_renewals_ext.late_nop%TYPE;
TYPE tab_renwd_nop		 IS TABLE OF eim_renewals_ext.renewed_nop%TYPE;
TYPE tab_renwls_nop		 IS TABLE OF eim_renewals_ext.renewals_nop%TYPE;
TYPE tab_renble_prem	 IS TABLE OF eim_renewals_ext.renewable_prem_amt%TYPE;
TYPE tab_late_prem		 IS TABLE OF eim_renewals_ext.late_prem_amt%TYPE;
TYPE tab_renwd_prem		 IS TABLE OF eim_renewals_ext.renewed_prem_amt%TYPE;
TYPE tab_renwls_prem	 IS TABLE OF eim_renewals_ext.renewals_prem_amt%TYPE;

v_line					 tab_line;
v_line_name				 tab_line_name;
v_subline				 tab_subline;
v_subline_name			 tab_subline_name;
v_branch				 tab_branch;
v_intm					 tab_intm;
v_assd					 tab_assd;
v_policy				 tab_policy;
v_policy_no				 tab_policy_no;
v_issue_yy				 tab_issue_yy;
v_pol_seq				 tab_pol_seq_no;
v_renew_no				 tab_renew_no;
v_old_pol				 tab_old_pol;
v_new_pol				 tab_new_pol;
v_exp_date				 tab_exp_date;
v_ren_date				 tab_ren_date;
v_renble_tsi			 tab_renble_tsi;
v_late_tsi				 tab_late_tsi;
v_renwd_tsi				 tab_renwd_tsi;
v_renwls_tsi			 tab_renwls_tsi;
v_renble_nop			 tab_renble_nop;
v_late_nop				 tab_late_nop;
v_renwd_nop				 tab_renwd_nop;
v_renwls_nop			 tab_renwls_nop;
v_renble_prem			 tab_renble_prem;
v_late_prem				 tab_late_prem;
v_renwd_prem			 tab_renwd_prem;
v_renwls_prem			 tab_renwls_prem;

BEGIN

DELETE eim_renewals_ext
 WHERE user_id = USER;

  SELECT a.line_cd,
 		 e.line_name line_name,
		 a.subline_cd,
		 f.subline_name subline_name,
		 a.iss_cd,
		 c.intrmdry_intm_no intm_no,
		 b.assd_no,
		 a.policy_id policy_id,
		 a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no policy_no,
		 a.issue_yy,
		 a.pol_seq_no,
		 a.renew_no,
		 g.old_policy_id,
		 g.new_policy_id,
		 TRUNC(a.expiry_date) expiry_date,
		 g.ren_date,
	 	 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2)) renewable_tsi,
		 SUM(DECODE(Get_Late_Amt(TO_NUMBER(TO_CHAR(a.expiry_date, 'YYYY')), TO_NUMBER(TO_CHAR(a.expiry_date, 'MM')),
							      TO_NUMBER(TO_CHAR(g.ren_date, 'YYYY')), TO_NUMBER(TO_CHAR(g.ren_date, 'MM'))), 1,
								  NVL(g.ren_tsi_amt,0), 0)) late_tsi,
		 SUM(DECODE(Get_Late_Amt(TO_NUMBER(TO_CHAR(a.expiry_date, 'YYYY')), TO_NUMBER(TO_CHAR(a.expiry_date, 'MM')),
		 					      TO_NUMBER(TO_CHAR(g.ren_date, 'YYYY')), TO_NUMBER(TO_CHAR(g.ren_date, 'MM'))), 0,
								  NVL(g.ren_tsi_amt,0), 0)) renewed_tsi,
		 SUM(NVL(g.ren_tsi_amt,0)) ren_tsi,
		 SUM(ROUND(c.premium_amt*d.currency_rt,2)) renewable_prem,
		 SUM(DECODE(Get_Late_Amt(TO_NUMBER(TO_CHAR(a.expiry_date, 'YYYY')), TO_NUMBER(TO_CHAR(a.expiry_date, 'MM')),
		 					      TO_NUMBER(TO_CHAR(g.ren_date, 'YYYY')), TO_NUMBER(TO_CHAR(g.ren_date, 'MM'))), 1,
								  NVL(g.ren_prem_amt,0), 0)) late_prem,
		 SUM(DECODE(Get_Late_Amt(TO_NUMBER(TO_CHAR(a.expiry_date, 'YYYY')), TO_NUMBER(TO_CHAR(a.expiry_date, 'MM')),
		 					      TO_NUMBER(TO_CHAR(g.ren_date, 'YYYY')), TO_NUMBER(TO_CHAR(g.ren_date, 'MM'))), 0,
								  NVL(g.ren_prem_amt,0), 0)) renewed_prem,
		 SUM(NVL(g.ren_prem_amt,0)) ren_prem,
		 SUM(DECODE(a.endt_seq_no, 0,1,0)) renewable_nop,
		 SUM(DECODE(Get_Late_Amt(TO_NUMBER(TO_CHAR(a.expiry_date, 'YYYY')), TO_NUMBER(TO_CHAR(a.expiry_date, 'MM')),
		 					      TO_NUMBER(TO_CHAR(g.ren_date, 'YYYY')), TO_NUMBER(TO_CHAR(g.ren_date, 'MM'))), 1,
								  NVL(g.renewals_nop,0), 0)) late_nop,
		 SUM(DECODE(Get_Late_Amt(TO_NUMBER(TO_CHAR(a.expiry_date, 'YYYY')), TO_NUMBER(TO_CHAR(a.expiry_date, 'MM')),
		 					      TO_NUMBER(TO_CHAR(g.ren_date, 'YYYY')), TO_NUMBER(TO_CHAR(g.ren_date, 'MM'))), 0,
								  NVL(g.renewals_nop,0), 0)) renewed_nop,
		 SUM(NVL(g.renewals_nop,0)) ren_nop
	BULK COLLECT INTO
	     v_line				,
		 v_line_name		,
		 v_subline			,
		 v_subline_name		,
		 v_branch			,
		 v_intm				,
		 v_assd				,
		 v_policy			,
		 v_policy_no		,
		 v_issue_yy			,
		 v_pol_seq			,
		 v_renew_no			,
		 v_old_pol			,
		 v_new_pol			,
		 v_exp_date			,
		 v_ren_date			,
		 v_renble_tsi		,
		 v_late_tsi			,
		 v_renwd_tsi		,
		 v_renwls_tsi		,
		 v_renble_prem		,
		 v_late_prem		,
		 v_renwd_prem		,
		 v_renwls_prem		,
		 v_renble_nop		,
		 v_late_nop			,
		 v_renwd_nop		,
		 v_renwls_nop
    FROM gipi_parlist b,
		 gipi_polbasic a,
	   	 gipi_comm_invoice c,
	   	 gipi_invoice d,
	   	 giis_line e,
	   	 giis_subline f,
	   	 (SELECT a.old_policy_id,
          		 a.new_policy_id,
				 DECODE(c.endt_seq_no,0,1,0) renewals_nop,
				 ROUND((d.premium_amt * f.currency_rt),2) ren_prem_amt,
				 ROUND((c.tsi_amt * f.currency_rt),2) ren_tsi_amt,
				 TRUNC(b.expiry_date) expiry_date,
	    		 TRUNC(c.issue_date) ren_date
                 FROM gipi_polnrep a,
        			  gipi_polbasic b,
	     			  gipi_polbasic c,
	 	 			  gipi_comm_invoice d,
		 			  gipi_parlist e,
		 			  gipi_invoice f
                WHERE a.old_policy_id = b.policy_id
     		  	  AND a.new_policy_id = c.policy_id
	 			  AND c.policy_id = d.policy_id
	 			  AND f.iss_cd = d.iss_cd
	 			  AND f.prem_seq_no = d.prem_seq_no
	 			  AND c.par_id = e.par_id
     			  AND a.ren_rep_sw = '1'
	 			  AND c.pol_flag IN ('1','2', '3')
     			  AND a.old_policy_id >0
	 			  AND a.new_policy_id >0) g
   WHERE 1 = 1
     AND e.line_cd     =a.line_cd
   	 AND e.line_cd     = f.line_cd
   	 AND f.subline_cd  = a.subline_cd
   	 AND a.par_id      = b.par_id
   	 AND a.policy_id   = c.policy_id
   	 AND a.policy_id   = c.policy_id
   	 AND a.policy_id   = c.policy_id+0
   	 AND c.iss_cd      = d.iss_cd
   	 AND c.prem_seq_no = d.prem_seq_no
   	 AND a.policy_id = g.old_policy_id(+)
   	 AND a.policy_id > -1
   	 AND b.par_id > -1
   	 AND NVL(e.sc_tag,'N') <> 'Y'
   	 AND NVL(f.op_flag, 'N') <> 'Y'
	 AND a.pol_flag IN ('1', '2', '3')
   	 AND e.line_cd > '%'
   	 AND c.iss_cd > '%'
   	 AND c.prem_seq_no > -10
   	 AND NVL(a.endt_type, 'A') = 'A'
   GROUP BY a.line_cd,
		 e.line_name,
	     a.subline_cd,
	   	 f.subline_name,
	  	 a.iss_cd,
		 c.intrmdry_intm_no,
		 b.assd_no,
	 	 a.policy_id,
    	 a.line_cd||'-'||a.subline_cd||'-'||a.iss_cd||'-'||a.issue_yy||'-'||a.pol_seq_no||'-'||a.renew_no,
    	 a.issue_yy,
    	 a.pol_seq_no,
    	 a.renew_no,
    	 g.old_policy_id,
		 g.new_policy_id,
		 TRUNC(a.expiry_date),
	 	 g.ren_date;

IF SQL%FOUND THEN
  FOR cnt IN
    v_line.first..v_line.last
  LOOP

  INSERT INTO eim_renewals_ext (
    line_cd,  				   line_name,
	subline_cd, 			   subline_name,
	branch_cd,				   intm_no,
	assd_no,				   policy_id,
	policy_no,				   issue_yy,
	pol_seq_no, 			   renew_no,
	old_policy_id, 			   new_policy_id,
	expiry_date,			   renewed_date,
	renewable_tsi_amt, 		   late_tsi_amt,
	renewed_tsi_amt,		   renewals_tsi_amt,
	renewable_nop,			   late_nop,
	renewed_nop,			   renewals_nop,
	renewable_prem_amt,	 	   late_prem_amt,
	renewed_prem_amt, 		   renewals_prem_amt,
	branch_name,			   intm_name,
	intm_type_desc,			   assd_name,
	user_id,				   extraction_date)
  VALUES (
    v_line(cnt)			,	   v_line_name(cnt)	  	,
 	v_subline(cnt)		,	   v_subline_name(cnt)	,
	v_branch(cnt)		,	   v_intm(cnt)			,
	v_assd(cnt)			,	   v_policy(cnt)		,
	v_policy_no(cnt)	,	   v_issue_yy(cnt)		,
	v_pol_seq(cnt)		,	   v_renew_no(cnt)		,
	v_old_pol(cnt)		,	   v_new_pol(cnt)		,
	v_exp_date(cnt)		,	   v_ren_date(cnt)		,
	v_renble_tsi(cnt)	,	   v_late_tsi(cnt)			,
	v_renwd_tsi(cnt)	,	   v_renwls_tsi(cnt)	,
	v_renble_nop(cnt)	,	   v_late_nop(cnt)		,
	v_renwd_nop(cnt)	,	   v_renwls_nop(cnt)	,
	v_renble_prem(cnt)	,	   v_late_prem(cnt)		,
	v_renwd_prem(cnt)	,	   v_renwls_prem(cnt)	,
	Get_Iss_Name(v_branch(cnt)),Get_Intm_Name(v_intm(cnt)),
	Get_Intm_Type_Desc(v_intm(cnt)),Get_Assd_Name(v_assd(cnt)),
	NULL,					   TRUNC(SYSDATE));

  END LOOP;
  COMMIT;
END IF;
END;
/

DROP PROCEDURE CPI.EXT_RENEWALS;

