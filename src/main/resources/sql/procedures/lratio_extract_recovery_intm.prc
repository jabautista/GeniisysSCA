DROP PROCEDURE CPI.LRATIO_EXTRACT_RECOVERY_INTM;

CREATE OR REPLACE PROCEDURE CPI.Lratio_Extract_Recovery_Intm
  	                  (p_line_cd            giis_line.line_cd%TYPE,
                       p_subline_cd         giis_subline.subline_cd%TYPE,
                       p_iss_cd             giis_issource.iss_cd%TYPE,
					   p_peril_cd           giis_peril.peril_cd%TYPE,
					   p_intm_no            giis_intermediary.intm_no%TYPE,
					   p_assd_no            giis_assured.assd_no%TYPE,
                       p_session_id         gicl_loss_ratio_ext.session_id%TYPE,
                       p_date_param         NUMBER,
                       p_issue_param        NUMBER,
                       p_curr1_date         gipi_polbasic.issue_date%TYPE,
                       p_curr2_date         gipi_polbasic.issue_date%TYPE,
                       p_prev1_date         gipi_polbasic.issue_date%TYPE,
                       p_prev2_date         gipi_polbasic.issue_date%TYPE,
					   p_curr_exists    OUT VARCHAR2,
					   p_prev_exists    OUT VARCHAR2) AS
  /* beth 03082003
  **      this procedure extracts all loss recover for current and
  **      previou year parameter
  **      this procedure is used if parameter intm_no is given or
  **      id\f extraction is per intm_no
  */
  --declare varray variables that will be needed during extraction of record
  TYPE rec_amt_tab     IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
  TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
  TYPE rec_id_tab      IS TABLE OF gicl_clm_recovery.recovery_id%TYPE;
  TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
  TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
  TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
  TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
  vv_rec_id            rec_id_tab;
  vv_rec_amt           rec_amt_tab;
  vv_assd_no           assd_no_tab;
  vv_line_cd           line_cd_tab;
  vv_subline_cd        subline_cd_tab;
  vv_iss_cd            iss_cd_tab;
  vv_intm_no           intm_no_tab;
  vv_peril_cd          peril_cd_tab;
BEGIN --main
  p_curr_exists := 'N';
  p_prev_exists := 'N';
  BEGIN  --extract previous year recovery amount
    --delete records in extract table gicl_lratio_prev_recovery_ext for the current user
    DELETE gicl_lratio_prev_recovery_ext
     WHERE user_id = USER;
	--retrieved all valid recovery record for previous year
    SELECT b.assd_no,     a.recovery_id, line_cd,
	       subline_cd,    iss_cd,        d.peril_cd,
		   c.intm_no,
           SUM(NVL(recovered_amt,0) * (NVL(d.recoverable_amt,0)
		   / Get_Rec_Amt(d.recovery_id)) * (NVL(c.premium_amt,0)
           / Get_Intm_Prem(c.claim_id))) recovered_amt
    bulk collect
      INTO vv_assd_no,    vv_rec_id,     vv_line_cd,
	       vv_subline_cd, vv_iss_cd,     vv_peril_cd,
		   vv_intm_no,    vv_rec_amt
      FROM gicl_recovery_payt a, gicl_claims b,
           gicl_intm_itmperil c, gicl_clm_recovery_dtl d
     WHERE 1 = 1
       AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
       AND b.line_cd = NVL(p_line_cd, b.line_cd)
       AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
       AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd)
           = NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
       AND b.assd_no = NVL(p_assd_no, b.assd_no)
	   AND d.peril_cd = NVL(p_peril_cd, d.peril_cd)
       AND a.claim_id = b.claim_id
       AND b.claim_id   = c.claim_id
	   AND a.recovery_id = d.recovery_id
	   AND c.claim_id = d.claim_id
       AND c.intm_no    = NVL(p_intm_no,c.intm_no)
       AND NVL(cancel_tag,'N') = 'N'
--       AND TO_NUMBER(TO_CHAR(TRUNC(tran_date), 'YYYY'))<= TO_NUMBER(p_prev_year)
       AND TRUNC(tran_date) >= p_prev1_date
       AND TRUNC(tran_date)<= p_prev2_date
     GROUP BY b.assd_no,     a.recovery_id, line_cd,
	          subline_cd,    iss_cd,        d.peril_cd,
			  c.intm_no;
	--insert record in table gicl_lratio_prev_recovery_ext
    IF SQL%FOUND THEN
  	   p_prev_exists := 'Y';
       forall i IN vv_rec_id.first..vv_rec_id.last
         INSERT INTO gicl_lratio_prev_recovery_ext
           (session_id,     recovery_id,     assd_no,
		    line_cd,        subline_cd,      iss_cd,
            peril_cd,       recovered_amt,   intm_no,
			user_id)
         VALUES
           (p_session_id,   vv_rec_id(i),     vv_assd_no(i),
		    vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i),
			vv_peril_cd(i), vv_rec_amt(i),    vv_intm_no(i),
			USER);
       --after insert refresh arrays by deleting data
	   vv_rec_id.DELETE;
	   vv_assd_no.DELETE;
	   vv_intm_no.DELETE;
	   vv_rec_amt.DELETE;
	   vv_line_cd.DELETE;
	   vv_subline_cd.DELETE;
	   vv_iss_cd.DELETE;
	   vv_peril_cd.DELETE;
    END IF;
  END;
  BEGIN
    --delete records in extract table gicl_lratio_curr_recovery_ext for the current user
    DELETE gicl_lratio_curr_recovery_ext
     WHERE user_id = USER;
	--retrieved all valid recovery record for current year
    SELECT b.assd_no,     a.recovery_id, line_cd,
	       subline_cd,    iss_cd,        d.peril_cd,
		   c.intm_no,
           SUM(NVL(recovered_amt,0) * (NVL(d.recoverable_amt,0)
		   / Get_Rec_Amt(d.recovery_id)) * (NVL(c.premium_amt,0)
           / Get_Intm_Prem(c.claim_id))) recovered_amt
    bulk collect
      INTO vv_assd_no,    vv_rec_id,     vv_line_cd,
	       vv_subline_cd, vv_iss_cd,     vv_peril_cd,
		   vv_intm_no,    vv_rec_amt
      FROM gicl_recovery_payt a, gicl_claims b,
           gicl_intm_itmperil c, gicl_clm_recovery_dtl d
     WHERE 1 = 1
      AND check_user_per_iss_cd2(b.line_cd,b.iss_cd,'GICLS204',USER) = 1 --angelo092507
      AND b.line_cd = NVL(p_line_cd, b.line_cd)
      AND b.subline_cd = NVL(p_subline_cd, b.subline_cd)
      AND DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd)
          = NVL(p_iss_cd, DECODE(p_issue_param, 1, b.iss_cd, b.pol_iss_cd))
      AND b.assd_no = NVL(p_assd_no, b.assd_no)
	  AND d.peril_cd = NVL(p_peril_cd, d.peril_cd)
      AND a.claim_id = b.claim_id
      AND b.claim_id   = c.claim_id
	  AND a.recovery_id = d.recovery_id
	  AND a.claim_id = d.claim_id
      AND c.intm_no    = NVL(p_intm_no,c.intm_no)
      AND NVL(cancel_tag,'N') = 'N'
      AND TRUNC(tran_date) >= p_curr1_date
      AND TRUNC(tran_date)<= p_curr2_date
    GROUP BY b.assd_no,     a.recovery_id, line_cd,
  	         subline_cd,    iss_cd,        d.peril_cd,
			 c.intm_no;
	--insert record in table gicl_lratio_curr_recovery_ext
    IF SQL%FOUND THEN
  	   p_curr_exists := 'Y';
       forall i IN vv_rec_id.first..vv_rec_id.last
         INSERT INTO gicl_lratio_curr_recovery_ext
           (session_id,     recovery_id,     assd_no,
		    line_cd,        subline_cd,      iss_cd,
            peril_cd,       recovered_amt,   intm_no,
			user_id)
         VALUES
           (p_session_id,   vv_rec_id(i),     vv_assd_no(i),
		    vv_line_cd(i),  vv_subline_cd(i), vv_iss_cd(i),
            vv_peril_cd(i), vv_rec_amt(i),    vv_intm_no(i),
			USER);
    END IF;
  END;
END;
/


