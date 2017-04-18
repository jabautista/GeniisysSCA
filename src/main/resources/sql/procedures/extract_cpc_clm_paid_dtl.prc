DROP PROCEDURE CPI.EXTRACT_CPC_CLM_PAID_DTL;

CREATE OR REPLACE PROCEDURE CPI.Extract_Cpc_Clm_Paid_Dtl (p_year             NUMBER) AS
  TYPE paid_amt_tab           IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE claim_id_tab           IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE intm_no_tab            IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE parent_intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE tran_id_tab            IS TABLE OF giac_acctrans.tran_id%TYPE;
  vv_claim_id          claim_id_tab;
  vv_tran_id           tran_id_tab;
  vv_paid_amt          paid_amt_tab;
  vv_intm_no           intm_no_tab;
  vv_parent_intm_no    parent_intm_no_tab;
BEGIN
  --delete records in extract table giac_cpc_clm_paid_dtl for the transaction year
  DELETE GIAC_CPC_CLM_PAID_DTL
   WHERE tran_year = p_year;
  --retrieve all paid claim for the current year
  --transactions must not be cancelled
  SELECT b.claim_id,
		 c.intm_no,
		 c.parent_intm_no,
		 tran_id,
         NVL(SUM(NVL(losses_paid,0)+ NVL(expenses_paid,0)),0) loss_paid
  BULK COLLECT
    INTO vv_claim_id,
	     vv_intm_no,
		 vv_parent_intm_no,
		 vv_tran_id,
		 vv_paid_amt
    FROM gicl_clm_res_hist a, gicl_claims b,
	     gicl_intm_itmperil c,
		 giis_peril d,
		 giis_line e,
		 giis_subline f
   WHERE 1 = 1
     AND a.claim_id = b.claim_id
     AND tran_id IS NOT NULL
     AND NVL(cancel_tag,'N') = 'N'
     AND a.claim_id          = c.claim_id
     AND a.item_no           = c.item_no
     AND a.peril_cd          = c.peril_cd
     AND TO_CHAR(date_paid,'YYYY') = p_year
	 AND a.peril_cd = d.peril_cd
	 AND b.line_cd = d.line_cd
     AND NVL(d.prof_comm_tag, 'N') = 'Y'
	 AND b.line_cd = f.line_cd
	 AND b.subline_cd = f.subline_cd
	 AND NVL(f.prof_comm_tag, 'N') = 'Y'
 	 AND b.line_cd = e.line_cd
	 AND NVL(e.prof_comm_tag, 'N') = 'Y'
    GROUP BY b.claim_id, c.intm_no, c.parent_intm_no, tran_id;
  --INSERT RECORD ON TABLE giac_cpc_clm_paid_dtl
  IF SQL% FOUND THEN
     FORALL i IN vv_claim_id.first..vv_claim_id.last
       INSERT INTO GIAC_CPC_CLM_PAID_DTL
         (tran_year,       intm_no,          parent_intm_no,     tran_id,
          claim_id,        paid_amt,         user_id,            last_update)
       VALUES
         (p_year,          vv_intm_no(i),    vv_parent_intm_no(i), vv_tran_id(i),
          vv_claim_id(i),  vv_paid_amt(i),    USER,               SYSDATE);
  END IF;
  COMMIT;
END;
/


