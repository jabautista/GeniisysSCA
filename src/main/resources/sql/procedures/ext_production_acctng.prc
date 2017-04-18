DROP PROCEDURE CPI.EXT_PRODUCTION_ACCTNG;

CREATE OR REPLACE PROCEDURE CPI.Ext_Production_Acctng IS
/**
 Created by: Lhen Valderrama
 Date Created : 10/31/03
 This bulk procedure will extract production summary(including RI production) versus payment
 summary on a particular period, regardless if there is no production summary but has acctng
 transaction made summary and vice versa.
**/

TYPE tab_acct_date		 IS TABLE OF gipi_polbasic.acct_ent_date%TYPE;
TYPE tab_line			 IS TABLE OF eim_prodacctg_ext.line_cd%TYPE;
TYPE tab_subline		 IS TABLE OF eim_prodacctg_ext.subline_cd%TYPE;
TYPE tab_branch		 	 IS TABLE OF eim_prodacctg_ext.branch_cd%TYPE;
TYPE tab_intm			 IS TABLE OF eim_prodacctg_ext.intm_no%TYPE;
TYPE tab_assd			 IS TABLE OF eim_prodacctg_ext.assd_no%TYPE;
TYPE tab_pol_id		 	 IS TABLE OF eim_prodacctg_ext.policy_id%TYPE;
TYPE tab_prod_tsi		 IS TABLE OF eim_prodacctg_ext.prod_prem%TYPE;
TYPE tab_prod_prem		 IS TABLE OF eim_prodacctg_ext.prod_tsi%TYPE;
TYPE tab_prod_nop		 IS TABLE OF eim_prodacctg_ext.prod_nop%TYPE;
TYPE tab_colln_branch	 IS TABLE OF eim_prodacctg_ext.colln_branch%TYPE;
TYPE tab_or_pref_suf	 IS TABLE OF eim_prodacctg_ext.or_pref_suf%TYPE;
TYPE tab_or_no	 		 IS TABLE OF eim_prodacctg_ext.or_no%TYPE;
TYPE tab_payor	 		 IS TABLE OF eim_prodacctg_ext.payor%TYPE;
TYPE tab_prem_seq_no 	 IS TABLE OF eim_prodacctg_ext.prem_seq_no%TYPE;
TYPE tab_colln_prem	 	 IS TABLE OF eim_prodacctg_ext.colln_prem%TYPE;
TYPE tab_comm_amt		 IS TABLE OF eim_prodacctg_ext.comm_amt%TYPE;
TYPE tab_input_vat 		 IS TABLE OF eim_prodacctg_ext.input_vat%TYPE;
TYPE tab_tax_amt	 	 IS TABLE OF eim_prodacctg_ext.tax_amt%TYPE;
TYPE tab_colln_amt	 	 IS TABLE OF eim_prodacctg_ext.colln_amt%TYPE;
TYPE tab_particulars	 IS TABLE OF eim_prodacctg_ext.particulars%TYPE;
TYPE tab_tran_date	 	 IS TABLE OF eim_prodacctg_ext.tran_date%TYPE;
TYPE tab_posting_date	 IS TABLE OF eim_prodacctg_ext.posting_date%TYPE;

v_acct_date		 tab_acct_date;
v_line			 tab_line;
v_subline		 tab_subline;
v_branch		 tab_branch;
v_intm			 tab_intm;
v_assd			 tab_assd;
v_pol_id		 tab_pol_id;
v_prod_tsi		 tab_prod_tsi;
v_prod_prem		 tab_prod_prem;
v_prod_nop		 tab_prod_nop;
v_colln_branch	 tab_colln_branch;
v_or_pref_suf	 tab_or_pref_suf;
v_or_no			 tab_or_no;
v_payor			 tab_payor;
v_prem_seq_no	 tab_prem_seq_no;
v_colln_prem	 tab_colln_prem;
v_comm_amt		 tab_comm_amt;
v_input_vat		 tab_input_vat;
v_tax_amt		 tab_tax_amt;
v_colln_amt		 tab_colln_amt;
v_particulars	 tab_particulars;
v_tran_date		 tab_tran_date;
v_posting_date	 tab_posting_date;

BEGIN

/** to delete previous data before extracting to have an updated data**/
DELETE eim_prodacctg_ext
 WHERE user_id = USER;

/** union has been created here to grouped data of production and of losses **/
  SELECT acct_prod_date,
       	 line,
	   	 subline,
	   	 branch,
	   	 intm,
	   	 assd,
	   	 policy_id,
       	 prod_tsi,
       	 prod_prem,
       	 prod_nop,
	   	 colln_branch,
	   	 or_pref_suf,
		 or_no,
	   	 payor,
       	 prem_seq_no,
       	 colln_prem,
	   	 comm_amt,
	   	 input_vat,
       	 tax_amt,
       	 colln_amt,
	   	 particulars,
	   	 tran_date,
	   	 posting_date
	BULK COLLECT INTO
		 v_acct_date	 ,
		 v_line			 ,
		 v_subline		 ,
		 v_branch		 ,
		 v_intm			 ,
		 v_assd			 ,
		 v_pol_id		 ,
		 v_prod_tsi		 ,
		 v_prod_prem	 ,
		 v_prod_nop		 ,
		 v_colln_branch	 ,
		 v_or_pref_suf	 ,
		 v_or_no		 ,
		 v_payor		 ,
		 v_prem_seq_no	 ,
		 v_colln_prem	 ,
		 v_comm_amt		 ,
		 v_input_vat	 ,
		 v_tax_amt		 ,
		 v_colln_amt	 ,
		 v_particulars	 ,
		 v_tran_date	 ,
		 v_posting_date
    FROM (SELECT TRUNC(a.acct_ent_date) acct_prod_date,
       	 		 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch,
	   			 c.intrmdry_intm_no intm,
	   			 b.assd_no assd,
	   			 a.policy_id,
	   			 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2)) prod_tsi,
       			 SUM(ROUND(c.premium_amt*d.currency_rt,2)) prod_prem,
       			 SUM(DECODE(a.endt_seq_no, 0,1,0)) prod_nop,
	   			 h.colln_branch,
				 h.or_pref_suf,
	   			 h.or_no,
	   			 h.payor,
				 h.prem_seq_no,
       			 SUM(NVL(h.premium_amt,0)) colln_prem,
	   			 SUM(NVL(h.comm_amt,0)) comm_amt,
	   			 SUM(NVL(h.input_vat_amt,0)) input_vat,
       			 SUM(NVL(h.tax_amt,0)) tax_amt,
       			 SUM(NVL(h.collection_amt,0)) colln_amt,
	   			 h.particulars,
	   			 h.tran_date,
	   			 h.posting_date
            FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
       			 gipi_invoice d,
       			 giis_line e,
       			 giis_subline f,
       			 (SELECT a.gibr_branch_cd colln_branch,
           	   	 		 a.or_pref_suf,
						 a.or_no,
           	   			 a.payor,
           	   			 b.b140_prem_seq_no prem_seq_no,
           	   			 b.premium_amt,
           	   			 e.comm_amt,
           	   			 e.input_vat_amt,
           	   			 b.tax_amt,
           	   			 b.collection_amt,
           	   			 a.particulars,
			   			 c.tran_date,
			   			 c.posting_date,
                    	 b.b140_iss_cd iss_cd
 				    FROM giac_direct_prem_collns b,
	  	   	   			 giac_acctrans c,
           	   			 giac_comm_payts e,
	 	   	   			 giac_order_of_payts a
                   WHERE a.gacc_tran_id = b.gacc_tran_id
       	             AND a.gacc_tran_id = c.tran_id
       	   			 AND c.tran_flag <> 'D'
       	   			 AND e.gacc_tran_id = a.gacc_tran_id
       	   			 AND e.iss_cd = b.b140_iss_cd
       	   			 AND e.prem_seq_no = b.b140_prem_seq_no
       	   			 AND NOT EXISTS (SELECT gacc_tran_id
                    	               FROM giac_acctrans z,giac_reversals t
                                      WHERE z.tran_id = t.reversing_tran_id
                                        AND z.tran_id = a.gacc_tran_id
                     		  			AND z.tran_flag <>'D')) h
           WHERE 1 = 1
             AND e.line_cd     = f.line_cd
   			 AND f.line_cd     = a.line_cd(+)
   			 AND f.subline_cd  = a.subline_cd(+)
   			 AND a.par_id      = b.par_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id+0
   			 AND c.iss_cd 	 = h.iss_cd(+)
   			 AND c.prem_seq_no = h.prem_seq_no(+)
   			 AND c.iss_cd      = d.iss_cd
   			 AND c.prem_seq_no = d.prem_seq_no
   			 AND a.policy_id > -1
   			 AND b.par_id > -1
   			 AND NVL(e.sc_tag,'N') <> 'Y'
   			 AND NVL(f.op_flag, 'N') <> 'Y'
   			 AND e.line_cd > '%'
   			 AND c.iss_cd > '%'
   			 AND c.prem_seq_no > -10
			 AND a.acct_ent_date IS NOT NULL
           GROUP BY TRUNC(a.acct_ent_date),
       	   		 f.line_cd,
	  			 f.subline_cd,
	   			 a.iss_cd,
	   			 c.intrmdry_intm_no,
	   			 b.assd_no,
	   			 a.policy_id,
				 a.pol_flag,
	   			 h.colln_branch,
				 h.or_pref_suf,
	   			 h.or_no,
	   			 h.payor,
      			 h.prem_seq_no,
	  			 h.particulars,
	   			 h.tran_date,
	   			 h.posting_date
          UNION
          SELECT TRUNC(a.spld_acct_ent_date) acct_prod_date,
       	  		 f.line_cd line,
	   			 f.subline_cd subline,
	   			 a.iss_cd branch,
	   			 c.intrmdry_intm_no intm,
	   			 b.assd_no assd,
	   			 a.policy_id,
	   			 SUM(ROUND(a.tsi_amt*c.share_percentage/100,2)*-1) prod_tsi,
       			 SUM(ROUND(c.premium_amt*d.currency_rt,2)*-1) prod_prem,
       			 SUM(DECODE(a.endt_seq_no, 0,1,0)) prod_nop,
	   			 h.colln_branch,
       			 h.or_pref_suf,
				 h.or_no,
      			 h.payor,
       			 h.prem_seq_no,
       			 SUM(NVL(h.premium_amt,0)*-1) colln_prem,
	   			 SUM(NVL(h.comm_amt,0)*-1) comm_amt,
	   			 SUM(NVL(h.input_vat_amt,0)*-1) input_vat,
       			 SUM(NVL(h.tax_amt,0)*-1) tax_amt,
       			 SUM(NVL(h.collection_amt,0)*-1) colln_amt,
	   			 h.particulars,
	   			 h.tran_date,
	   			 h.posting_date
            FROM gipi_parlist b,
       			 gipi_polbasic a,
       			 gipi_comm_invoice c,
      			 gipi_invoice d,
       			 giis_line e,
      			 giis_subline f,
       			 (SELECT a.gibr_branch_cd colln_branch,
           	   	 		 a.or_pref_suf,
						 a.or_no,
           	   			 a.payor,
           	   			 b.b140_prem_seq_no prem_seq_no,
           	   			 b.premium_amt,
           	   			 e.comm_amt,
           	  			 e.input_vat_amt,
           	   			 b.tax_amt,
           	   			 b.collection_amt,
           	   			 a.particulars,
			  			 c.tran_date,
			   			 c.posting_date,
		   	   			 b.b140_iss_cd iss_cd
                    FROM giac_direct_prem_collns b,
	  	   	   			 giac_acctrans c,
           	   			 giac_comm_payts e,
	 	   	   			 giac_order_of_payts a
                   WHERE a.gacc_tran_id = b.gacc_tran_id
       	             AND a.gacc_tran_id = c.tran_id
       	   			 AND c.tran_flag <> 'D'
       	   			 AND e.gacc_tran_id = a.gacc_tran_id
       	   			 AND e.iss_cd = b.b140_iss_cd
       	   			 AND e.prem_seq_no = b.b140_prem_seq_no
       	   			 AND NOT EXISTS (SELECT gacc_tran_id
                    	     		   FROM giac_acctrans z,giac_reversals t
                                      WHERE z.tran_id = t.reversing_tran_id
                                        AND z.tran_id = a.gacc_tran_id
                     		  			AND z.tran_flag <>'D')) h
           WHERE 1 = 1
             AND e.line_cd     = f.line_cd
   			 AND f.line_cd     = a.line_cd(+)
   			 AND f.subline_cd  = a.subline_cd(+)
   			 AND a.par_id      = b.par_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id
   			 AND a.policy_id   = c.policy_id+0
   			 AND c.iss_cd 	   = h.iss_cd(+)
   			 AND c.prem_seq_no = h.prem_seq_no(+)
   			 AND c.iss_cd      = d.iss_cd
   			 AND c.prem_seq_no = d.prem_seq_no
   			 AND a.policy_id > -1
   			 AND b.par_id > -1
   			 AND NVL(e.sc_tag,'N') <> 'Y'
   			 AND NVL(f.op_flag, 'N') <> 'Y'
   			 AND e.line_cd > '%'
   			 AND c.iss_cd > '%'
   			 AND c.prem_seq_no > -10
   			 AND a.spld_acct_ent_date IS NOT NULL
           GROUP BY TRUNC(a.spld_acct_ent_date),
       	   		 f.line_cd,
	   			 f.subline_cd,
	   			 a.iss_cd,
	   			 c.intrmdry_intm_no,
	   			 b.assd_no,
	   			 a.policy_id,
	   			 h.colln_branch,
	   			 h.or_pref_suf,
				 h.or_no,
	   			 h.payor,
       			 h.prem_seq_no,
	   			 h.particulars,
	   			 h.tran_date,
	   			 h.posting_date);

  IF SQL%FOUND THEN
     FOR cnt IN
	   v_acct_date.first..v_acct_date.last
	 LOOP
	   INSERT INTO eim_prodacctg_ext (
       	 acct_prod_date, 			  	  	   assd_no,
		 assured_name, 						   prem_seq_no,
		 branch_cd, 						   branch_name,
		 colln_amt, 						   colln_branch,
		 colln_branch_name, 				   colln_prem,
		 comm_amt, 							   extraction_date,
		 input_vat, 						   intermediary_name,
		 intm_no, 							   intm_type,
		 intm_type_desc, 					   line_cd,
		 line_name, 						   or_no,
		 particulars, 						   payor,
		 policy_id,							   policy_no,
		 posting_date,		 				   prod_nop,
		 prod_tsi, 							   subline_cd,
		 subline_name, 						   tax_amt,
		 tran_date, 						   user_id,
		 prod_prem,							   or_pref_suf)
       VALUES (
       	 v_acct_date(cnt),	                   v_assd(cnt),
		 Get_Assd_Name(v_assd(cnt)),		   v_prem_seq_no(cnt),
		 v_branch(cnt),						   Get_Iss_Name(v_branch(cnt)),
		 v_colln_amt(cnt),					   v_colln_branch(cnt),
		 Get_Iss_Name(v_colln_branch(cnt)),	   v_colln_prem(cnt),
		 v_comm_amt(cnt),					   TRUNC(SYSDATE),
		 v_input_vat(cnt),					   Get_Intm_Name(v_intm(cnt)),
		 v_intm(cnt),						   Get_Intm_Type(v_intm(cnt)),
		 Get_Intm_Type_Desc(Get_Intm_Type(v_intm(cnt))),v_line(cnt),
		 Get_Line_Name(v_line(cnt)),		   v_or_no(cnt),
		 v_particulars(cnt),				   v_payor(cnt),
		 v_pol_id(cnt),						   Get_Policy_No(v_pol_id(cnt)),
		 v_posting_date(cnt),				   v_prod_nop(cnt),
		 v_prod_tsi(cnt),					   v_subline(cnt),
		 Get_Subline_Name(v_subline(cnt)),	   v_tax_amt(cnt),
		 v_tran_date(cnt),					   NULL,
		 v_prod_prem(cnt),					   v_or_pref_suf(cnt));
	 END LOOP;
     COMMIT;
  END IF;
END;
/

DROP PROCEDURE CPI.EXT_PRODUCTION_ACCTNG;