DROP TRIGGER CPI.GICL_ITEM_PERIL_TAIUX2;

CREATE OR REPLACE TRIGGER CPI.GICL_ITEM_PERIL_TAIUX2
    AFTER INSERT OR UPDATE OF claim_id, item_no, peril_cd, grouped_item_no
	ON CPI.GICL_ITEM_PERIL FOR EACH ROW
DECLARE
  --BETH 07102002
  --     recreate this trigger to solve error in getting intermediary record
  v_claim_id                  gicl_item_peril.claim_id%TYPE  :=  :NEW.claim_id;
  v_item_no                   gicl_item_peril.item_no%TYPE   :=  :NEW.item_no;
  v_peril_cd                  gicl_item_peril.peril_cd%TYPE  :=  :NEW.peril_cd;
  v_grouped_item_no			  gicl_item_peril.grouped_item_no%TYPE := NVL(:NEW.grouped_item_no,0);
  v_loss_date                 gicl_clm_item.loss_date%TYPE;
  v_tot_prem_amt              gipi_itmperil.prem_amt%TYPE;
  v_intm_shr_pct              gipi_comm_invoice.share_percentage%TYPE;
  v_intm_no                   giis_intermediary.intm_no%TYPE;
  v_losses_paid               gicl_clm_res_hist.losses_paid%TYPE;
  -- function that will retrieved the parent intermediary of
  -- a particular intermediary
  FUNCTION get_parent_intm(p_intrmdry_intm_no    IN giis_intermediary.intm_no%TYPE)
                           RETURN NUMBER IS
    v_intm_no        giis_intermediary.intm_no%TYPE;
  BEGIN
    BEGIN
       SELECT NVL(a.parent_intm_no,a.intm_no)
         INTO v_intm_no
         FROM giis_intermediary a
        WHERE intm_no            = p_intrmdry_intm_no;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        v_intm_no  := p_intrmdry_intm_no;
      WHEN OTHERS THEN
        v_intm_no  := p_intrmdry_intm_no;
    END;
    RETURN v_intm_no;
  END get_parent_intm;
BEGIN
  -- for update of claim_id, peril_cd and item_no
  -- delete first the records in table gicl_intmperil
  -- so that duplication of records will be eliminated
  IF UPDATING THEN
     DELETE FROM gicl_intm_itmperil
      WHERE claim_id  = :OLD.claim_id
        AND peril_cd  = :OLD.peril_cd
   	    AND item_no   = :OLD.item_no
		AND grouped_item_no = :OLD.grouped_item_no;
  END IF;
  -- get information from table gicl_claims
  FOR clm_info IN(
    SELECT TRUNC(c003.loss_date) loss_date, c003.pol_eff_date, c003.expiry_date,
           c003.line_cd,   c003.subline_cd,   c003.pol_iss_cd,
           c003.issue_yy,  c003.pol_seq_no,   c003.renew_no
      FROM gicl_claims c003
     WHERE c003.claim_id = v_claim_id)
  LOOP
    -- get the total premium from table gipi_itmperil
    -- for the particular item and peril
    BEGIN
      SELECT SUM(b380.prem_amt) tot_prem_amt
        INTO v_tot_prem_amt
        FROM gipi_polbasic b250,
             gipi_itmperil b380
       WHERE b250.policy_id   = b380.policy_id
         AND b250.line_cd     = clm_info.line_cd
         AND b250.subline_cd  = clm_info.subline_cd
         AND b250.iss_cd      = clm_info.pol_iss_cd
         AND b250.issue_yy    = clm_info.issue_yy
         AND b250.pol_seq_no  = clm_info.pol_seq_no
         AND b250.renew_no    = clm_info.renew_no
         AND b250.pol_flag   IN ('1','2','3','X' )
         AND TRUNC(DECODE(b250.eff_date,b250.incept_date,clm_info.pol_eff_date,
                    b250.eff_date))     <= clm_info.loss_date
         AND TRUNC(DECODE(b250.expiry_date,NVL(b250.endt_expiry_date,b250.expiry_date),
                    clm_info.expiry_date, b250.endt_expiry_date))     >= clm_info.loss_date
         AND b250.dist_flag        = '3'
         AND b380.peril_cd         = v_peril_cd
         AND b380.item_no          = v_item_no;
    EXCEPTION
    WHEN OTHERS THEN
      NULL;
    END;
    -- retrieve all the records from gipi_polbasic of policy and all endt.
    FOR policies_rec IN (
      SELECT b250.policy_id
        FROM gipi_polbasic b250
       WHERE b250.line_cd     = clm_info.line_cd
         AND b250.subline_cd  = clm_info.subline_cd
         AND b250.iss_cd      = clm_info.pol_iss_cd
         AND b250.issue_yy    = clm_info.issue_yy
         AND b250.pol_seq_no  = clm_info.pol_seq_no
         AND b250.renew_no    = clm_info.renew_no
         AND b250.pol_flag   IN ('1','2','3','X' )
         AND TRUNC(DECODE(b250.eff_date,b250.incept_date,clm_info.pol_eff_date,
                    b250.eff_date))     <= clm_info.loss_date
         AND TRUNC(DECODE(b250.expiry_date,NVL(b250.endt_expiry_date,b250.expiry_date),
                    clm_info.expiry_date, b250.endt_expiry_date))     >= clm_info.loss_date
         AND b250.dist_flag        = '3'
         AND EXISTS         (SELECT 'X'
                               FROM gipi_itmperil b380
                              WHERE b380.policy_id     = b250.policy_id
                                AND b380.peril_cd         = v_peril_cd
                                AND b380.item_no          = v_item_no)
     ORDER BY b250 .policy_id)
    LOOP
      -- get the invoice record per policy_id retrieved
      FOR invoice_rec IN (
        SELECT d.iss_cd,
               d.prem_seq_no,
               SUM(b.prem_amt) prem_amt
          FROM gipi_itmperil b,
               gipi_item c,
               gipi_invoice d
         WHERE c.item_no          = b.item_no
           AND c.policy_id        = b.policy_id
           AND c.item_grp         = d.item_grp
           AND c.policy_id        = d.policy_id
           AND b.peril_cd         = v_peril_cd
           AND b.item_no          = v_item_no
           AND c.policy_id        = policies_rec.policy_id
      GROUP BY d.item_grp,d.iss_cd,d.prem_seq_no)
      LOOP
        -- get the share percentage per intermediary for the item peril
        FOR intermediary_rec IN
         (SELECT a.intrmdry_intm_no,
                 a.share_percentage
            FROM gipi_comm_invoice a
           WHERE a.prem_seq_no  = invoice_rec.prem_seq_no
             AND a.iss_cd       = invoice_rec.iss_cd
             AND a.policy_id    = policies_rec.policy_id)
        LOOP
          --retrieve the parent intermediary using the function
          v_intm_no    := get_parent_intm(intermediary_rec.intrmdry_intm_no);
          BEGIN
            -- compute amts to get the percent of a particular intm
            -- it should the amount per invoice * the share percent of the intm.
            -- over the total premium of the item peril
            v_intm_shr_pct  := (invoice_rec.prem_amt * (intermediary_rec.share_percentage))/
                               v_tot_prem_amt;
          EXCEPTION
            WHEN ZERO_DIVIDE THEN
              v_intm_shr_pct  := 0;
          END;
          -- if the computed share percent per intermediary <> 0 then
          -- insert/update records in gicl_intm_itmperil using the computed share percent
          IF v_intm_shr_pct <> 0 THEN
             BEGIN
               UPDATE gicl_intm_itmperil
                  SET shr_intm_pct    = shr_intm_pct + v_intm_shr_pct,
                      premium_amt     = premium_amt + ((v_intm_shr_pct*v_tot_prem_amt)/100)
                WHERE intm_no         = intermediary_rec.intrmdry_intm_no
				  AND grouped_item_no = v_grouped_item_no
                  AND peril_cd        = v_peril_cd
                  AND item_no         = v_item_no
                  AND claim_id        = v_claim_id;
               IF SQL%NOTFOUND THEN
                  INSERT INTO gicl_intm_itmperil
                               (claim_id,
                                item_no,
                                peril_cd,
								grouped_item_no,
                                intm_no,
                                parent_intm_no,
                                shr_intm_pct,
                                premium_amt)
                         VALUES(v_claim_id,
                                v_item_no,
                                v_peril_cd,
								v_grouped_item_no,
                                intermediary_rec.intrmdry_intm_no,
                                v_intm_no,
                                v_intm_shr_pct,
                                (v_intm_shr_pct*v_tot_prem_amt)/100);
               END IF;
             END;
          ELSE
          -- if the computed share percent per intermediary = 0 then
          -- insert/update records in gicl_intm_itmperil using the share percent from gipi_comm_inv_peril
             BEGIN
               UPDATE gicl_intm_itmperil
                  SET shr_intm_pct    = intermediary_rec.share_percentage,
                      premium_amt     = premium_amt + ((v_intm_shr_pct*v_tot_prem_amt)/100)
                WHERE intm_no         = intermediary_rec.intrmdry_intm_no
				  AND grouped_item_no = v_grouped_item_no
                  AND peril_cd        = v_peril_cd
                  AND item_no         = v_item_no
                  AND claim_id        = v_claim_id;
               IF SQL%NOTFOUND THEN
                  INSERT INTO gicl_intm_itmperil
                               (claim_id,
                                item_no,
                                peril_cd,
								grouped_item_no,
                                intm_no,
                                parent_intm_no,
                                shr_intm_pct,
                                premium_amt)
                         VALUES(v_claim_id,
                                v_item_no,
                                v_peril_cd,
								v_grouped_item_no,
                                intermediary_rec.intrmdry_intm_no,
                                v_intm_no,
                                intermediary_rec.share_percentage,
                                (v_intm_shr_pct*v_tot_prem_amt)/100);
               END IF;
             END;
          END IF;
        END LOOP;
      END LOOP;
    END LOOP;
  END LOOP;
END;
/

ALTER TRIGGER CPI.GICL_ITEM_PERIL_TAIUX2 DISABLE;


