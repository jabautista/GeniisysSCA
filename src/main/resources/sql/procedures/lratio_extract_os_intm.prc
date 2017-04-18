DROP PROCEDURE CPI.LRATIO_EXTRACT_OS_INTM;

CREATE OR REPLACE PROCEDURE CPI.Lratio_Extract_Os_Intm
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
                       p_prev1_date         gipi_polbasic.issue_date%TYPE,
                       p_prev2_date         gipi_polbasic.issue_date%TYPE,
					   p_curr_exists    OUT VARCHAR2,
					   p_prev_exists    OUT VARCHAR2) AS
  /*beth 03082003
  **     this procedure extract 2 sets of oustanding loss
  **     (1)for the current date parameter
  **    (2)for the previous year
  **    this procedure is used if intm_no parameter is given
  */
  -- hardy 011404
  -- add convert_rate in codes
  --declare varray variables that will be needed during extraction of record
  TYPE os_amt_tab      IS TABLE OF gipi_polbasic.prem_amt%TYPE;
  TYPE assd_no_tab     IS TABLE OF giis_assured.assd_no%TYPE;
  TYPE claim_id_tab    IS TABLE OF gicl_claims.claim_id%TYPE;
  TYPE peril_cd_tab    IS TABLE OF giis_peril.peril_cd%TYPE;
  TYPE line_cd_tab     IS TABLE OF giis_line.line_cd%TYPE;
  TYPE subline_cd_tab  IS TABLE OF giis_subline.subline_cd%TYPE;
  TYPE iss_cd_tab      IS TABLE OF giis_issource.iss_cd%TYPE;
  TYPE intm_no_tab     IS TABLE OF giis_intermediary.intm_no%TYPE;
  vv_claim_id          claim_id_tab;
  vv_os                os_amt_tab;
  vv_assd_no           assd_no_tab;
  vv_peril_cd          peril_cd_tab;
  vv_line_cd           line_cd_tab;
  vv_subline_cd        subline_cd_tab;
  vv_iss_cd            iss_cd_tab;
  vv_intm_no           intm_no_tab;
BEGIN --main
  p_curr_exists := 'N';
  p_prev_exists := 'N';
  BEGIN --extract current outstanding loss
    --delete records in extract table gicl_lratio_curr_os_ext for the current user
    DELETE gicl_lratio_curr_os_ext
     WHERE user_id = USER;
    BEGIN--retrieve all records with outstanding loss reserve for current year
	  --all records with loss payment less than the loss reserve will be retrived
      SELECT d.claim_id,        d.assd_no,
	         a.peril_cd,        d.line_cd,
			 d.subline_cd,      d.iss_cd,
			 e.intm_no,
             SUM(((NVL(a.loss_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.losses_paid,0)) * (e.shr_intm_pct/100)) loss
        BULK COLLECT
        INTO vv_claim_id,       vv_assd_no,
		     vv_peril_cd,       vv_line_cd,
			 vv_subline_cd,     vv_iss_cd,
			 vv_intm_no,        vv_os
        FROM gicl_clm_res_hist a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                WHERE tran_id IS NULL
                  AND b2.claim_id = b1.claim_id
                  AND b2.item_no  = b1.item_no
                  AND b2.peril_cd = b1.peril_cd
                  AND TRUNC(NVL(b2.close_date, p_curr2_date +365))
                      > TRUNC(p_curr2_date) ) b,
             (SELECT claim_id, item_no, peril_cd,
                     SUM(losses_paid) losses_paid
                FROM gicl_clm_res_hist
                WHERE 1 = 1
                  AND tran_id IS NOT NULL
                  AND NVL(cancel_tag,'N') = 'N'
                  AND TRUNC(date_paid) <= TRUNC(p_curr2_date)
             GROUP BY claim_id, item_no, peril_cd ) c,
             gicl_claims d,
             gicl_intm_itmperil e
       WHERE 1 = 1
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND d.assd_no = NVL(p_assd_no, d.assd_no)
         AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
             = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
         AND a.claim_id = d.claim_id
         AND a.claim_id = b.claim_id
         AND a.clm_res_hist_id = b.clm_res_hist_id
         AND b.claim_id = c.claim_id (+)
         AND b.item_no = c.item_no (+)
         AND b.peril_cd = c.peril_cd (+)
         AND d.claim_id = e.claim_id
         AND b.item_no  = e.item_no
         AND b.peril_cd = e.peril_cd
		 AND e.intm_no  = NVL(p_intm_no, e.intm_no)
         AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
         AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                    FROM gicl_clm_res_hist a2
                                   WHERE a2.claim_id =a.claim_id
                                     AND a2.item_no =a.item_no
                                     AND a2.peril_cd =a.peril_cd
                                     AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||
                                         TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')
                                         <= TRUNC(p_curr2_date)
                                     AND tran_id IS NULL)
         --AND TRUNC(NVL(close_date, p_curr2_date +365)) > p_curr2_date
       GROUP BY d.claim_id,        d.assd_no,
  	            a.peril_cd,        d.line_cd,
			    d.subline_cd,      d.iss_cd,
			    e.intm_no;
      --insert record on table gicl_lratio_curr_os_ext
      IF SQL%FOUND THEN
     	 p_curr_exists := 'Y';
         FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
	       INSERT INTO gicl_lratio_curr_os_ext
	         (session_id,      assd_no,          claim_id,       intm_no,
			  line_cd,         subline_cd,       iss_cd,         peril_cd,
			   os_amt,         user_id)
   	       VALUES
             (p_session_id,    vv_assd_no(i),    vv_claim_id(i), vv_intm_no(i),
			  vv_line_cd(i),   vv_subline_cd(i), vv_iss_cd(i),   vv_peril_cd(i),
			  vv_os(i),       USER);
         --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_assd_no.DELETE;
	     vv_peril_cd.DELETE;
	     vv_os.DELETE;
	     vv_line_cd.DELETE;
	     vv_subline_cd.DELETE;
	     vv_iss_cd.DELETE;
	     vv_intm_no.DELETE;
      END IF;
    END;--retrieve all records with outstanding loss reserve for current year
    BEGIN --retrieve all records with outstanding expense reserve for current year
	  --all records with expense payment less than the expense reserve will be retrived
      SELECT d.claim_id,        d.assd_no,
	         a.peril_cd,        d.line_cd,
			 d.subline_cd,      d.iss_cd,
			 e.intm_no,
			 SUM(((NVL(a.expense_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.exp_paid,0)) * (e.shr_intm_pct/100)) loss
        BULK COLLECT
        INTO vv_claim_id,       vv_assd_no,
		     vv_peril_cd,       vv_line_cd,
			 vv_subline_cd,     vv_iss_cd,
			 vv_intm_no,        vv_os
        FROM gicl_clm_res_hist a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                WHERE tran_id IS NULL
                  AND b2.claim_id = b1.claim_id
                  AND b2.item_no  = b1.item_no
                  AND b2.peril_cd = b1.peril_cd
                  AND TRUNC(NVL(b2.close_date2, p_curr2_date +365))
                      > TRUNC(p_curr2_date) ) b,
             (SELECT claim_id, item_no, peril_cd,
                     SUM(losses_paid) losses_paid,
                     SUM(expenses_paid) exp_paid
                FROM gicl_clm_res_hist
                WHERE 1 = 1
                  AND tran_id IS NOT NULL
                  AND NVL(cancel_tag,'N') = 'N'
                  AND TRUNC(date_paid) <= TRUNC(p_curr2_date)
             GROUP BY claim_id, item_no, peril_cd ) c,
             gicl_claims d,
             gicl_intm_itmperil e
       WHERE 1 = 1
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
             = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
         AND d.assd_no = NVL(p_assd_no, d.assd_no)
         AND a.claim_id = d.claim_id
         AND a.claim_id = b.claim_id
         AND a.clm_res_hist_id = b.clm_res_hist_id
         AND b.claim_id = c.claim_id (+)
         AND b.item_no = c.item_no (+)
         AND b.peril_cd = c.peril_cd (+)
		 AND d.claim_id = e.claim_id
         AND b.item_no  = e.item_no
         AND b.peril_cd = e.peril_cd
		 AND e.intm_no  = NVL(p_intm_no, e.intm_no)
         AND NVL(a.expense_reserve,0) > NVL(c.exp_paid,0)
         AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                    FROM gicl_clm_res_hist a2
                                   WHERE a2.claim_id =a.claim_id
                                     AND a2.item_no =a.item_no
                                     AND a2.peril_cd =a.peril_cd
                                     AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||
                                         TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')
                                         <= TRUNC(p_curr2_date)
                                     AND tran_id IS NULL)
         --AND TRUNC(NVL(close_date, p_curr2_date +365)) > p_curr2_date
       GROUP BY d.claim_id,        d.assd_no,
  	            a.peril_cd,        d.line_cd,
			    d.subline_cd,      d.iss_cd,
			    e.intm_no;
      --insert record on table gicl_lratio_curr_os_ext
      IF SQL%FOUND THEN
     	 p_curr_exists := 'Y';
         FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
	       INSERT INTO gicl_lratio_curr_os_ext
	         (session_id,      assd_no,          claim_id,       intm_no,
			  line_cd,         subline_cd,       iss_cd,         peril_cd,
			   os_amt,           user_id)
   	       VALUES
             (p_session_id,    vv_assd_no(i),    vv_claim_id(i), vv_intm_no(i),
			  vv_line_cd(i),   vv_subline_cd(i), vv_iss_cd(i),   vv_peril_cd(i),
			  vv_os(i),       USER);
	     --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_assd_no.DELETE;
	     vv_peril_cd.DELETE;
	     vv_os.DELETE;
	     vv_line_cd.DELETE;
	     vv_subline_cd.DELETE;
	     vv_iss_cd.DELETE;
	     vv_intm_no.DELETE;
      END IF;
    END; --retrieve all records with outstanding expense reserve for current year
  END;--extract current outstanding loss
  BEGIN --extract previous outstanding loss
    --delete records in extract table gicl_lratio_prev_os_ext for the current user
    DELETE gicl_lratio_prev_os_ext
     WHERE user_id = USER;
    BEGIN --retrieve all records with outstanding loss reserve for previous year
	  --all records with loss payment less than the loss reserve will be retrived
      SELECT d.claim_id,        d.assd_no,
	         a.peril_cd,        d.line_cd,
			 d.subline_cd,      d.iss_cd,
			 e.intm_no,
             SUM(((NVL(a.loss_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.losses_paid,0)) * (e.shr_intm_pct/100)) loss
        BULK COLLECT
        INTO vv_claim_id,       vv_assd_no,
		     vv_peril_cd,       vv_line_cd,
			 vv_subline_cd,     vv_iss_cd,
			 vv_intm_no,        vv_os
        FROM gicl_clm_res_hist a,
             (SELECT b1.claim_id, b1.clm_res_hist_id,
                     b1.item_no, b1.peril_cd
                FROM gicl_clm_res_hist b1 , gicl_item_peril b2
               WHERE tran_id IS NULL
                 AND b2.claim_id = b1.claim_id
                 AND b2.item_no  = b1.item_no
                 AND b2.peril_cd = b1.peril_cd
  			     AND TRUNC(NVL(b2.close_date, p_curr2_date +365))
                      > TRUNC(p_prev2_date)) b,
                 /*AND TO_CHAR(NVL(b2.close_date, p_curr2_date + 365),'YYYY')
                     > p_prev_year) b,*/
             (SELECT claim_id, item_no, peril_cd,
                     SUM(losses_paid) losses_paid,
                     SUM(expenses_paid) exp_paid
                FROM gicl_clm_res_hist
               WHERE 1 = 1
                 AND tran_id IS NOT NULL
                 AND NVL(cancel_tag,'N') = 'N'
                 AND TRUNC(date_paid) <= TRUNC(p_prev2_date)
              GROUP BY claim_id, item_no, peril_cd ) c,
              gicl_claims d,
              gicl_intm_itmperil e
       WHERE 1 = 1
         AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
     	 AND d.line_cd <> 'RI'
         AND d.line_cd = NVL(p_line_cd, d.line_cd)
         AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
         AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
             = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
         AND d.assd_no = NVL(p_assd_no, d.assd_no)
         AND a.claim_id = d.claim_id
         AND a.claim_id = b.claim_id
         AND a.clm_res_hist_id = b.clm_res_hist_id
         AND b.claim_id = c.claim_id (+)
         AND b.item_no = c.item_no (+)
         AND b.peril_cd = c.peril_cd (+)
         AND d.claim_id = e.claim_id
         AND b.item_no  = e.item_no
         AND b.peril_cd = e.peril_cd
		 AND e.intm_no  = NVL(p_intm_no, e.intm_no)
         AND NVL(a.loss_reserve,0) > NVL(c.losses_paid,0)
         AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                    FROM gicl_clm_res_hist a2
                                   WHERE a2.claim_id =a.claim_id
                                     AND a2.item_no =a.item_no
                                     AND a2.peril_cd =a.peril_cd
                                     /*AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                         <= TO_NUMBER(p_prev_year)*/
                                     AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||
                                         TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')
                                         <= TRUNC(p_prev2_date)
                                     AND tran_id IS NULL)
         /*AND TO_CHAR(NVL(d.close_date, p_curr2_date + 365),'YYYY')
             > p_prev_year*/
         --AND TRUNC(NVL(close_date, p_curr2_date +365)) > p_prev2_date
       GROUP BY d.claim_id,        d.assd_no,
  	            a.peril_cd,        d.line_cd,
			    d.subline_cd,      d.iss_cd,
			    e.intm_no;
      --insert record on table gicl_lratio_prev_os_ext
      IF SQL%FOUND THEN
     	 p_prev_exists := 'Y';
         FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
	       INSERT INTO gicl_lratio_prev_os_ext
	         (session_id,      assd_no,          claim_id,       intm_no,
			  line_cd,         subline_cd,       iss_cd,         peril_cd,
			   os_amt,           user_id)
   	       VALUES
             (p_session_id,    vv_assd_no(i),    vv_claim_id(i), vv_intm_no(i),
			  vv_line_cd(i),   vv_subline_cd(i), vv_iss_cd(i),   vv_peril_cd(i),
			  vv_os(i),       USER);
		 --after insert refresh arrays by deleting data
         vv_claim_id.DELETE;
	     vv_assd_no.DELETE;
	     vv_peril_cd.DELETE;
	     vv_os.DELETE;
	     vv_line_cd.DELETE;
	     vv_subline_cd.DELETE;
	     vv_iss_cd.DELETE;
	     vv_intm_no.DELETE;
      END IF;
    END; --retrieve all records with outstanding loss reserve for previous year
    BEGIN --retrieve all records with outstanding expense reserve for previous year
	  --all records with expense payment less than the expense reserve will be retrived
      SELECT d.claim_id,        d.assd_no,
	         a.peril_cd,        d.line_cd,
			 d.subline_cd,      d.iss_cd,
			 e.intm_no,
			 SUM(((NVL(a.expense_reserve,0)*NVL(a.convert_rate,1)) - NVL(c.exp_paid,0)) * (e.shr_intm_pct/100)) loss
       BULK COLLECT
        INTO vv_claim_id,       vv_assd_no,
		     vv_peril_cd,       vv_line_cd,
			 vv_subline_cd,     vv_iss_cd,
			 vv_intm_no,        vv_os
	     FROM gicl_clm_res_hist a,
              (SELECT b1.claim_id, b1.clm_res_hist_id,
                      b1.item_no, b1.peril_cd
                 FROM gicl_clm_res_hist b1 , gicl_item_peril b2
                 WHERE tran_id IS NULL
                   AND b2.claim_id = b1.claim_id
                   AND b2.item_no  = b1.item_no
                   AND b2.peril_cd = b1.peril_cd
				   AND TRUNC(NVL(b2.close_date2, p_curr2_date +365))
                      > TRUNC(p_prev2_date)) b,
                   /*AND TO_CHAR(NVL(b2.close_date, p_curr2_date + 365),'YYYY')
                       > p_prev_year) b,*/
                   (SELECT claim_id, item_no, peril_cd,
                           SUM(losses_paid) losses_paid,
                           SUM(expenses_paid) exp_paid
                      FROM gicl_clm_res_hist
                     WHERE 1 = 1
                       AND tran_id IS NOT NULL
                       AND NVL(cancel_tag,'N') = 'N'
                       AND TRUNC(date_paid) <= TRUNC(p_prev2_date)
                   GROUP BY claim_id, item_no, peril_cd ) c,
                   gicl_claims d,
                   gicl_intm_itmperil e
             WHERE 1 = 1
               AND check_user_per_iss_cd2(d.line_cd,d.iss_cd,'GICLS204',USER) = 1 --angelo092507
               AND d.line_cd = NVL(p_line_cd, d.line_cd)
               AND d.subline_cd = NVL(p_subline_cd, d.subline_cd)
               AND DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd)
                   = NVL(p_iss_cd, DECODE(p_issue_param, 1, d.iss_cd, d.pol_iss_cd))
               AND d.assd_no = NVL(p_assd_no, d.assd_no)
               AND a.claim_id = d.claim_id
               AND a.claim_id = b.claim_id
               AND a.clm_res_hist_id = b.clm_res_hist_id
               AND b.claim_id = c.claim_id (+)
               AND b.item_no = c.item_no (+)
               AND b.peril_cd = c.peril_cd (+)
			   AND d.claim_id = e.claim_id
               AND b.item_no  = e.item_no
               AND b.peril_cd = e.peril_cd
   		       AND e.intm_no  = NVL(p_intm_no, e.intm_no)
               AND NVL(a.expense_reserve,0) > NVL(c.exp_paid,0)
               AND a.clm_res_hist_id = (SELECT MAX(a2.clm_res_hist_id)
                                          FROM gicl_clm_res_hist a2
                                         WHERE a2.claim_id =a.claim_id
                                           AND a2.item_no =a.item_no
                                           AND a2.peril_cd =a.peril_cd
                                           /*AND NVL(a2.booking_year,TO_NUMBER(TO_CHAR(d.clm_file_date,'YYYY')))
                                               <= TO_NUMBER(p_prev_year)*/
                                           AND TO_DATE(NVL(a2.booking_month,TO_CHAR(d.clm_file_date,'FMMONTH')) ||' 01, '||
                                               TO_CHAR(NVL(a2.booking_year,TO_CHAR(d.clm_file_date,'YYYY'))),'FMMONTH DD, YYYY')
                                               <= TRUNC(p_prev2_date)
									       AND tran_id IS NULL)
/*               AND TO_CHAR(NVL(d.close_date, p_curr2_date + 365),'YYYY')
                       > p_prev_year*/
               --AND TRUNC(NVL(close_date2, p_curr2_date +365)) > p_prev2_date
       GROUP BY d.claim_id,        d.assd_no,
  	            a.peril_cd,        d.line_cd,
			    d.subline_cd,      d.iss_cd,
			    e.intm_no;
      --insert record on table gicl_lratio_prev_os_ext
      IF SQL%FOUND THEN
     	 p_prev_exists := 'Y';
         FORALL i IN vv_claim_id.FIRST..vv_claim_id.LAST
	       INSERT INTO gicl_lratio_prev_os_ext
	         (session_id,      assd_no,          claim_id,       intm_no,
			  line_cd,         subline_cd,       iss_cd,         peril_cd,
			   os_amt,           user_id)
   	       VALUES
             (p_session_id,    vv_assd_no(i),    vv_claim_id(i), vv_intm_no(i),
			  vv_line_cd(i),   vv_subline_cd(i), vv_iss_cd(i),   vv_peril_cd(i),
			  vv_os(i),       USER);
      END IF;
    END; --retrieve all records with outstanding expense reserve for previous year
  END;--extract previous outstanding loss
END; --main
/


