CREATE OR REPLACE PROCEDURE CPI.Extract_Cpc_Os_Pcic (p_year             NUMBER,
                                                 p_intm_no          giis_intermediary.intm_no%TYPE,
                                                 p_user_id          giac_cpc_os_dtl.user_id%TYPE) AS --Added by Jerome Bautista 05.12.2016 SR 22335 AS
  TYPE paid_amt_tab           IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE claim_id_tab           IS TABLE OF GICL_CLAIMS.claim_id%TYPE;
  TYPE intm_no_tab            IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE parent_intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE peril_cd_tab           IS TABLE OF GICL_CLM_RES_HIST.peril_cd%TYPE;
  TYPE line_cd_tab            IS TABLE OF gicl_claims.line_cd%TYPE;
  TYPE facul_amt_tab          IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  vv_claim_id          claim_id_tab;
  vv_paid_amt          paid_amt_tab;
  vv_intm_no           intm_no_tab;
  vv_parent_intm_no    parent_intm_no_tab;
  vv_peril_cd          peril_cd_tab;
  vv_line_cd           line_cd_tab;
  vv_facul_amt         facul_amt_tab;
BEGIN
  --delete records in extract table giac_os_paid_dtl for the transaction year
  DELETE GIAC_CPC_OS_DTL
   WHERE tran_year = p_year
     AND intm_no   = NVL(p_intm_no, intm_no)
  	 AND user_id = p_user_id;--USER; -- Replaced by Jerome Bautista 05.12.2016 SR 22335
  BEGIN--retrieve all records with outstanding loss reserve for the year
	  --all records with loss payment less than the loss reserve will be retrived
    SELECT d.claim_id,
	       e.intm_no,
	       e.intm_no parent_intm_no,
           SUM(((NVL(a.loss_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.losses_paid,0)) * (e.shr_intm_pct/100)) loss,
   		   d.line_cd,
		   a.peril_cd,
		   NVL(SUM(NVL(i.shr_loss_res_amt,0)),0) facul_amt
      BULK COLLECT
      INTO vv_claim_id,
	       vv_intm_no,
		   vv_parent_intm_no,
		   vv_paid_amt,
   	       vv_line_cd,
		   vv_peril_cd,
           vv_facul_amt
      FROM GICL_CLM_RES_HIST a,
           (SELECT b1.claim_id, b1.clm_res_hist_id,
                   b1.item_no, b1.peril_cd
              FROM GICL_CLM_RES_HIST b1 , GICL_ITEM_PERIL b2
             WHERE tran_id IS NULL
               AND b2.claim_id = b1.claim_id
               AND b2.item_no  = b1.item_no
               AND b2.peril_cd = b1.peril_cd
               AND NVL(TO_NUMBER(TO_CHAR(b2.close_date,'YYYY')),p_year +1) > p_year ) b,
           (SELECT claim_id, item_no, peril_cd,
                   SUM(losses_paid) losses_paid
              FROM GICL_CLM_RES_HIST
             WHERE 1 = 1
               AND tran_id IS NOT NULL
               --AND NVL(cancel_tag,'N') = 'N'
               AND NVL(TO_NUMBER(TO_CHAR(cancel_date,'YYYY')),p_year +1) > p_year
               AND TO_CHAR(date_paid,'YYYY') <= p_year
           GROUP BY claim_id, item_no, peril_cd ) c,
           GICL_CLAIMS d,
           GICL_INTM_ITMPERIL e,
		   giis_peril f,
		   giis_line g,
		   giis_subline h,
    	   (SELECT shr_loss_res_amt, claim_id, clm_res_hist_id, clm_dist_no
		    FROM  GICL_RESERVE_DS
		   WHERE grp_seq_no =999) i
     WHERE 1 = 1
       AND a.claim_id = d.claim_id
       AND a.claim_id = b.claim_id
       AND check_user_per_iss_cd_acctg(null,d.iss_cd,'GIACS512')=1 --jongs 04.02.2013
       AND a.clm_res_hist_id = b.clm_res_hist_id
       AND b.claim_id = c.claim_id (+)
       AND b.item_no = c.item_no (+)
       AND b.peril_cd = c.peril_cd (+)
	   AND a.claim_id = i.claim_id(+)
       AND a.clm_res_hist_id = i.clm_res_hist_id(+)
       AND a.dist_no = i.clm_dist_no(+)
       AND d.claim_id = e.claim_id
       AND b.item_no  = e.item_no
       AND b.peril_cd = e.peril_cd
	   AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
	   AND e.intm_no = NVL(p_intm_no, e.intm_no)
       AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                  FROM GICL_CLM_RES_HIST a2
                                 WHERE a2.claim_id =a.claim_id
                                   AND a2.item_no =a.item_no
                                   AND a2.peril_cd =a.peril_cd
                                   AND a2.booking_year = p_year
                                   AND tran_id IS NULL)
       AND NVL(TO_NUMBER(TO_CHAR(close_date,'YYYY')),p_year +1) > p_year
       AND a.peril_cd = f.peril_cd
	   AND d.line_cd = f.line_cd
       AND NVL(f.prof_comm_tag, 'N') = 'Y'
	   AND d.line_cd = h.line_cd
	   AND d.subline_cd = h.subline_cd
	   AND NVL(h.prof_comm_tag, 'N') = 'Y'
  	   AND d.line_cd = g.line_cd
	   AND NVL(g.prof_comm_tag, 'N') = 'Y'
       GROUP BY d.claim_id, e.intm_no, e.parent_intm_no, a.peril_cd, d.line_cd;
      --insert record on table gicl_lratio_curr_os_ext
    IF SQL%FOUND THEN
       FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
           INSERT INTO GIAC_CPC_OS_DTL
            (tran_year,       intm_no,          parent_intm_no,
             claim_id,        os_amt,           user_id,            last_update,
  		     line_cd,         peril_cd,         facul_shr)
           VALUES
            (p_year,          vv_intm_no(i),    vv_parent_intm_no(i),
             vv_claim_id(i),  vv_paid_amt(i),    /*USER, Replaced by Jerome Bautista 05.12.2016 SR 22335*/  p_user_id,               SYSDATE,
 		     vv_line_cd(i),      vv_peril_cd(i),      vv_facul_amt(i));
         --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_paid_amt.DELETE;
	     vv_intm_no.DELETE;
 	     vv_parent_intm_no.DELETE;
         vv_line_cd.DELETE;
         vv_peril_cd.DELETE;
	     vv_facul_amt.DELETE;
     END IF;
  END;--retrieve all records with outstanding loss reserve for current year

  BEGIN--retrieve all records with outstanding expense reserve for the year
	  --all records with expense payment less than the expense reserve will be retrived
    SELECT d.claim_id,
	       e.intm_no,
	       e.parent_intm_no,
	 	   SUM(((NVL(a.expense_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.exp_paid,0)) * (e.shr_intm_pct/100)) loss,
		   d.line_cd,
		   a.peril_cd,
		   NVL(SUM(NVL(i.shr_exp_res_amt,0)),0) facul_amt
      BULK COLLECT
      INTO vv_claim_id,
	       vv_intm_no,
		   vv_parent_intm_no,
		   vv_paid_amt,
		   vv_line_cd,
		   vv_peril_cd,
           vv_facul_amt
      FROM GICL_CLM_RES_HIST a,
           (SELECT b1.claim_id, b1.clm_res_hist_id,
                   b1.item_no, b1.peril_cd
              FROM GICL_CLM_RES_HIST b1 , GICL_ITEM_PERIL b2
             WHERE tran_id IS NULL
               AND b2.claim_id = b1.claim_id
               AND b2.item_no  = b1.item_no
               AND b2.peril_cd = b1.peril_cd
               AND NVL(TO_NUMBER(TO_CHAR(b2.close_date,'YYYY')),p_year +1) > p_year ) b,
           (SELECT claim_id, item_no, peril_cd,
                   SUM(expenses_paid) exp_paid
              FROM GICL_CLM_RES_HIST
             WHERE 1 = 1
               AND tran_id IS NOT NULL
               --AND NVL(cancel_tag,'N') = 'N'
			   AND NVL(TO_NUMBER(TO_CHAR(cancel_date,'YYYY')),p_year +1) > p_year
               AND TO_CHAR(date_paid,'YYYY') <= p_year
           GROUP BY claim_id, item_no, peril_cd ) c,
           GICL_CLAIMS d,
           GICL_INTM_ITMPERIL e,
		   giis_peril f,
		   giis_line g,
		   giis_subline h,
    	   (SELECT shr_exp_res_amt, claim_id, clm_res_hist_id, clm_dist_no
		    FROM  GICL_RESERVE_DS
		   WHERE grp_seq_no =999) i
     WHERE 1 = 1
       AND a.claim_id = d.claim_id
       AND a.claim_id = b.claim_id
       AND a.clm_res_hist_id = b.clm_res_hist_id
       AND b.claim_id = c.claim_id (+)
       AND b.item_no = c.item_no (+)
       AND b.peril_cd = c.peril_cd (+)
  	   AND a.claim_id = i.claim_id(+)
       AND a.clm_res_hist_id = i.clm_res_hist_id(+)
       AND a.dist_no = i.clm_dist_no(+)
       AND d.claim_id = e.claim_id
       AND b.item_no  = e.item_no
       AND b.peril_cd = e.peril_cd
	   AND NVL(a.loss_reserve,0) > NVL(c.exp_paid,0)
  	   AND e.intm_no = NVL(p_intm_no, e.intm_no)
       AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                  FROM GICL_CLM_RES_HIST a2
                                 WHERE a2.claim_id =a.claim_id
                                   AND a2.item_no =a.item_no
                                   AND a2.peril_cd =a.peril_cd
                                   AND a2.booking_year = p_year
                                   AND tran_id IS NULL)
       AND NVL(TO_NUMBER(TO_CHAR(close_date,'YYYY')),p_year +1) > p_year
       AND a.peril_cd = f.peril_cd
	   AND d.line_cd = f.line_cd
       AND NVL(f.prof_comm_tag, 'N') = 'Y'
	   AND d.line_cd = h.line_cd
	   AND d.subline_cd = h.subline_cd
	   AND NVL(h.prof_comm_tag, 'N') = 'Y'
  	   AND d.line_cd = g.line_cd
	   AND NVL(g.prof_comm_tag, 'N') = 'Y'
       GROUP BY d.claim_id, e.intm_no, e.parent_intm_no, a.peril_cd, d.line_cd;
      --insert record on table gicl_lratio_curr_os_ext
    IF SQL%FOUND THEN
       FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
          INSERT INTO GIAC_CPC_OS_DTL
            (tran_year,       intm_no,          parent_intm_no,
             claim_id,        os_amt,           user_id,            last_update,
  		     line_cd,         peril_cd,         facul_shr)
           VALUES
            (p_year,          vv_intm_no(i),    vv_parent_intm_no(i),
             vv_claim_id(i),  vv_paid_amt(i),    /*USER, Replaced by Jerome Bautista 05.12.2016 SR 22335*/  p_user_id,               SYSDATE,
 		     vv_line_cd(i),      vv_peril_cd(i),      vv_facul_amt(i));
         --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_paid_amt.DELETE;
	     vv_intm_no.DELETE;
 	     vv_parent_intm_no.DELETE;
         vv_line_cd.DELETE;
         vv_peril_cd.DELETE;
	     vv_facul_amt.DELETE;
    END IF;
  END;--retrieve all records with outstanding expense reserve for the transaction current year
  DELETE GIAC_CPC_OS_DTL
   WHERE tran_year = p_year
     AND intm_no = NVL(p_intm_no, intm_no)
     AND os_amt <= 0
     AND user_id = p_user_id; -- Added by Jerome Bautista 05.12.2016 SR 22335
  COMMIT;
END; --main
/


