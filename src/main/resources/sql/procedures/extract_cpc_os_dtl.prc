DROP PROCEDURE CPI.EXTRACT_CPC_OS_DTL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Cpc_Os_Dtl (p_year             NUMBER) AS
  TYPE paid_amt_tab           IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE claim_id_tab           IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE intm_no_tab            IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE parent_intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
  vv_claim_id          claim_id_tab;
  vv_paid_amt          paid_amt_tab;
  vv_intm_no           intm_no_tab;
  vv_parent_intm_no    parent_intm_no_tab;
BEGIN
  --delete records in extract table giac_os_paid_dtl for the transaction year
  DELETE giac_cpc_os_dtl
   WHERE tran_year = p_year;
  BEGIN--retrieve all records with outstanding loss reserve for the year
	  --all records with loss payment less than the loss reserve will be retrived
    SELECT d.claim_id,
	       e.intm_no,
	       e.parent_intm_no,
           SUM(((NVL(a.loss_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.losses_paid,0)) * (e.shr_intm_pct/100)) loss
      BULK COLLECT
      INTO vv_claim_id,
	       vv_intm_no,
		   vv_parent_intm_no,
		   vv_paid_amt
      FROM gicl_clm_res_hist a,
           (SELECT b1.claim_id, b1.clm_res_hist_id,
                   b1.item_no, b1.peril_cd
              FROM gicl_clm_res_hist b1 , gicl_item_peril b2
             WHERE tran_id IS NULL
               AND b2.claim_id = b1.claim_id
               AND b2.item_no  = b1.item_no
               AND b2.peril_cd = b1.peril_cd
               AND NVL(TO_NUMBER(TO_CHAR(b2.close_date,'YYYY')),p_year +1) > p_year ) b,
           (SELECT claim_id, item_no, peril_cd,
                   SUM(losses_paid) losses_paid
              FROM gicl_clm_res_hist
             WHERE 1 = 1
               AND tran_id IS NOT NULL
               AND NVL(cancel_tag,'N') = 'N'
               AND TO_CHAR(date_paid,'YYYY') <= p_year
           GROUP BY claim_id, item_no, peril_cd ) c,
           gicl_claims d,
           gicl_intm_itmperil e,
		   giis_peril f,
		   giis_line g,
		   giis_subline h
     WHERE 1 = 1
       AND a.claim_id = d.claim_id
       AND a.claim_id = b.claim_id
       AND a.clm_res_hist_id = b.clm_res_hist_id
       AND b.claim_id = c.claim_id (+)
       AND b.item_no = c.item_no (+)
       AND b.peril_cd = c.peril_cd (+)
       AND d.claim_id = e.claim_id
       AND b.item_no  = e.item_no
       AND b.peril_cd = e.peril_cd
	   AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
       AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                  FROM gicl_clm_res_hist a2
                                 WHERE a2.claim_id =a.claim_id
                                   AND a2.item_no =a.item_no
                                   AND a2.peril_cd =a.peril_cd
                                   AND a2.booking_year <= p_year
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
       GROUP BY d.claim_id, e.intm_no, e.parent_intm_no;
      --insert record on table gicl_lratio_curr_os_ext
    IF SQL%FOUND THEN
       FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
           INSERT INTO giac_cpc_os_dtl
            (tran_year,       intm_no,          parent_intm_no,
             claim_id,        os_amt,           user_id,            last_update)
           VALUES
            (p_year,          vv_intm_no(i),    vv_parent_intm_no(i),
             vv_claim_id(i),  vv_paid_amt(i),    USER,               SYSDATE);
         --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_paid_amt.DELETE;
	     vv_intm_no.DELETE;
 	     vv_parent_intm_no.DELETE;
     END IF;
  END;--retrieve all records with outstanding loss reserve for current year

  BEGIN--retrieve all records with outstanding expense reserve for the year
	  --all records with expense payment less than the expense reserve will be retrived
    SELECT d.claim_id,
	       e.intm_no,
	       e.parent_intm_no,
	 	   SUM(((NVL(a.expense_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.exp_paid,0)) * (e.shr_intm_pct/100)) loss
      BULK COLLECT
      INTO vv_claim_id,
	       vv_intm_no,
		   vv_parent_intm_no,
		   vv_paid_amt
      FROM gicl_clm_res_hist a,
           (SELECT b1.claim_id, b1.clm_res_hist_id,
                   b1.item_no, b1.peril_cd
              FROM gicl_clm_res_hist b1 , gicl_item_peril b2
             WHERE tran_id IS NULL
               AND b2.claim_id = b1.claim_id
               AND b2.item_no  = b1.item_no
               AND b2.peril_cd = b1.peril_cd
               AND NVL(TO_NUMBER(TO_CHAR(b2.close_date,'YYYY')),p_year +1) > p_year ) b,
           (SELECT claim_id, item_no, peril_cd,
                   SUM(expenses_paid) exp_paid
              FROM gicl_clm_res_hist
             WHERE 1 = 1
               AND tran_id IS NOT NULL
               AND NVL(cancel_tag,'N') = 'N'
               AND TO_CHAR(date_paid,'YYYY') <= p_year
           GROUP BY claim_id, item_no, peril_cd ) c,
           gicl_claims d,
           gicl_intm_itmperil e
     WHERE 1 = 1
       AND a.claim_id = d.claim_id
       AND a.claim_id = b.claim_id
       AND a.clm_res_hist_id = b.clm_res_hist_id
       AND b.claim_id = c.claim_id (+)
       AND b.item_no = c.item_no (+)
       AND b.peril_cd = c.peril_cd (+)
       AND d.claim_id = e.claim_id
       AND b.item_no  = e.item_no
       AND b.peril_cd = e.peril_cd
	   AND NVL(a.loss_reserve,0) > NVL(c.exp_paid,0)
       AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                  FROM gicl_clm_res_hist a2
                                 WHERE a2.claim_id =a.claim_id
                                   AND a2.item_no =a.item_no
                                   AND a2.peril_cd =a.peril_cd
                                   AND a2.booking_year <= p_year
                                   AND tran_id IS NULL)
       AND NVL(TO_NUMBER(TO_CHAR(close_date,'YYYY')),p_year +1) > p_year
       GROUP BY d.claim_id, e.intm_no, e.parent_intm_no;
      --insert record on table gicl_lratio_curr_os_ext
    IF SQL%FOUND THEN
       FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
          INSERT INTO giac_cpc_os_dtl
            (tran_year,       intm_no,          parent_intm_no,
             claim_id,        os_amt,           user_id,            last_update)
           VALUES
            (p_year,          vv_intm_no(i),    vv_parent_intm_no(i),
             vv_claim_id(i),  vv_paid_amt(i),    USER,               SYSDATE);
         --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_paid_amt.DELETE;
	     vv_intm_no.DELETE;
 	     vv_parent_intm_no.DELETE;
    END IF;
  END;--retrieve all records with outstanding expense reserve for the transaction current year
  DELETE giac_cpc_os_dtl
   WHERE tran_year = p_year
     AND os_amt <= 0;
  COMMIT;
END; --main
/


