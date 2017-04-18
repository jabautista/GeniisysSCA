DROP PROCEDURE CPI.LRATIO_EXTRACT_LOSS_PAID_INTM;

CREATE OR REPLACE PROCEDURE CPI.Lratio_Extract_Loss_Paid_Intm
                      (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
					   p_intm_no            giis_intermediary.intm_no%TYPE,
 					   p_assd_no            giis_assured.assd_no%TYPE,
                       p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
                       p_date_param         NUMBER,
                       p_issue_param        NUMBER,
                       p_curr1_date         gipi_polbasic.issue_date%TYPE,
                       p_curr2_date         gipi_polbasic.issue_date%TYPE,
					   p_exists             OUT VARCHAR2) AS
  /*beth 03082003
  **     this procedure extract all claim payment for the current date parameter
  **     this procedure is used if intm_no is given or if extraction
  **     is per intermediary
  */
  --declare varray variables that will be needed during extraction of record
  TYPE paid_amt_tab    IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
  TYPE claim_id_tab    IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
  TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
  TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
  TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
  vv_claim_id          claim_id_tab;
  vv_paid_amt          paid_amt_tab;
  vv_assd_no           assd_no_tab;
  vv_peril_cd          peril_cd_tab;
  vv_line_cd           line_cd_tab;
  vv_subline_cd        subline_cd_tab;
  vv_iss_cd            iss_cd_tab;
  vv_intm_no           intm_no_tab;
BEGIN
  --delete records in extract table gicl_lratio_loss_paid_ext for the current user
  DELETE gicl_lratio_loss_paid_ext
   WHERE user_id = USER;
  p_exists := 'N';
  --retrieve all paid claim for the current year
  --transactions must not be cancelled
  SELECT b.claim_id,    b.assd_no,
         b.line_cd,     b.subline_cd,
  	     b.iss_cd,      a.peril_cd,
		 c.intm_no,
         NVL(SUM(NVL(losses_paid,0)+ NVL(expenses_paid,0)),0) loss_paid
  bulk collect
    INTO vv_claim_id,   vv_assd_no,
	     vv_line_cd,    vv_subline_cd,
		 vv_iss_cd,     vv_peril_cd,
		 vv_intm_no,    vv_paid_amt
    FROM gicl_clm_res_hist a, gicl_claims b,
	     gicl_intm_itmperil c
   WHERE 1 = 1
     AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
	 AND b.line_cd = NVL(p_line_cd, b.line_cd)
     AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
     AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd)
         = NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
 	 AND b.assd_no = NVL(p_assd_no, b.assd_no)
     AND a.claim_id = b.claim_id
     AND tran_id IS NOT NULL
     AND NVL(cancel_tag,'N') = 'N'
     AND a.claim_id          = c.claim_id
     AND a.item_no           = c.item_no
     AND a.peril_cd          = c.peril_cd
     AND TRUNC(date_paid) >= p_curr1_date
     AND TRUNC(date_paid) <= p_curr2_date
     AND c.intm_no           = NVL(p_intm_no, c.intm_no)
    GROUP BY b.claim_id,    b.assd_no,
             b.line_cd,     b.subline_cd,
  	         b.iss_cd,      a.peril_cd,
		     c.intm_no;
  --INSERT RECORD ON TABLE GICL_LRATIO_LOSS_PAID_EXT
  IF SQL% FOUND THEN
     p_exists := 'Y';
     forall i IN vv_claim_id.first..vv_claim_id.last
       INSERT INTO gicl_lratio_loss_paid_ext
         (session_id,      assd_no,          peril_cd,      intm_no,
		  line_cd,         subline_cd,       iss_cd,
          claim_id,        loss_paid,        user_id)
       VALUES
         (p_session_id,    vv_assd_no(i),    vv_peril_cd(i), vv_intm_no(i),
		  vv_line_cd(i),   vv_subline_cd(i), vv_iss_cd(i),
          vv_claim_id(i),  vv_paid_amt(i),    USER);
  END IF;
END;
/


