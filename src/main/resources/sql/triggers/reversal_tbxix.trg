DROP TRIGGER CPI.REVERSAL_TBXIX;

CREATE OR REPLACE TRIGGER CPI.REVERSAL_TBXIX
BEFORE INSERT
ON CPI.GIAC_REVERSALS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
     v_ri                   giis_parameters.param_value_v%TYPE;
     v_rb                   giis_parameters.param_value_v%TYPE;
     v_gif                  giis_parameters.param_value_v%TYPE;
     v_gr                   giis_parameters.param_value_v%TYPE;
     v_policy_id            gipi_polbasic.policy_id%TYPE;
     v_line_cd              gipi_polbasic.line_cd%TYPE;
     v_assd_no              gipi_polbasic.assd_no%TYPE;
     v_aging_id             giac_aging_parameters.aging_id%TYPE;
     v_max_no_days          giac_aging_parameters.max_no_days%TYPE;
     v_next_age_level_dt    DATE;
     v_overdue              NUMBER(4);
     v_due_date             gipi_installment.due_date%TYPE;
     v_total_payts          giac_aging_soa_details.total_payments%TYPE;
     v_temp_payments        giac_aging_soa_details.temp_payments%TYPE;
     v_gibr_gfun_fund_cd    giac_aging_parameters.gibr_gfun_fund_cd%TYPE;
     v_gibr_branch_cd       giac_aging_parameters.gibr_branch_cd%TYPE;
     v_a020_assd_no         giac_aging_soa_details.a020_assd_no%TYPE;
     v_gagp_aging_id        giac_aging_soa_details.gagp_aging_id%TYPE;
  BEGIN
     FOR X IN (SELECT  param_name, param_value_v
                 FROM  giis_parameters
               WHERE  param_name IN ('RI','RB',
                     'ACCTG_FOR_FUND_CODE','ACCTG_ISS_CD_GR')) LOOP
        IF x.param_name = 'RI' THEN
           v_ri  := X.param_value_v;
        ELSIF x.param_name = 'RB' THEN
           v_rb  := X.param_value_v;
          /* Parameter used to identify the fund code used for acctg
          */
        ELSIF x.param_name = 'ACCTG_FOR_FUND_CODE' THEN
           v_gif := X.param_value_v;
          /* Parameter used to identify specific accounting iss_cds
          ** for report use.
          */
        ELSIF x.param_name = 'ACCTG_ISS_CD_GR' THEN
           v_gr  := X.param_value_v;
        END IF;
     END LOOP;
     IF v_ri IS  NULL THEN
        RAISE_APPLICATION_ERROR(-20010,'Parameter RI does not exist in giac parameters.', TRUE);
     END IF;
     IF v_rb IS  NULL THEN
        RAISE_APPLICATION_ERROR(-20010,'Parameter RB does not exist in giac parameters.', TRUE);
     END IF;
     IF v_gif IS  NULL THEN
        RAISE_APPLICATION_ERROR(-20010,'Parameter ACCTG_FOR_FUND_CODE does not exist in giac parameters.', TRUE);
     END IF;
     IF v_gr IS  NULL THEN
        RAISE_APPLICATION_ERROR(-20010,'Parameter ACCTG_ISS_CD_GR does not exist in giac parameters.', TRUE);
     END IF;
     ---
     DECLARE
        CURSOR A IS
           SELECT b140_iss_cd, b140_prem_seq_no, inst_no,
                  NVL(collection_amt,0) collection_amt,
                  NVL(premium_amt,0) premium_amt,
                  NVL(tax_amt,0) tax_amt
             FROM giac_direct_prem_collns
            WHERE gacc_tran_id = :NEW.gacc_tran_id;
     BEGIN
       IF :NEW.rev_corr_tag='R' THEN
         FOR A_REC IN A LOOP
           SELECT SUM(NVL(b.collection_amt,0))
             INTO v_total_payts
             FROM giac_direct_prem_collns b,giac_acctrans c
            WHERE b.b140_iss_cd        = a_rec.b140_iss_cd
              AND b.b140_prem_seq_no   = a_rec.b140_prem_seq_no
              AND c.tran_id            = b.gacc_tran_id
              AND c.tran_flag          <> 'D'
              AND c.tran_id    NOT IN(SELECT gacc_tran_id
                                        FROM giac_acctrans d,giac_reversals e
                                       WHERE d.tran_id = e.reversing_tran_id
                                         AND d.tran_flag <> 'D');
           SELECT NVL(SUM(NVL(b.collection_amt,0)),0)
             INTO v_temp_payments
             FROM giac_direct_prem_collns b,giac_acctrans c
            WHERE b.b140_iss_cd        = a_rec.b140_iss_cd
              AND b.b140_prem_seq_no   = a_rec.b140_prem_seq_no
              AND c.tran_id            = b.gacc_tran_id
              AND c.tran_flag  NOT IN('D','P','C')
              AND c.tran_id    NOT IN(SELECT gacc_tran_id
                                        FROM giac_acctrans d,giac_reversals e
                                       WHERE d.tran_id = e.reversing_tran_id
                                           AND d.tran_flag <> 'D');
           SELECT policy_id
             INTO v_policy_id
             FROM gipi_invoice
            WHERE iss_cd      = a_rec.b140_iss_cd
              AND prem_seq_no = a_rec.b140_prem_seq_no;
           SELECT assd_no,line_cd
             INTO v_assd_no,v_line_cd
             FROM gipi_polbasic
            WHERE policy_id   = v_policy_id;
           SELECT due_date
             INTO v_due_date
             FROM gipi_installment
            WHERE iss_cd      = a_rec.b140_iss_cd
              AND prem_seq_no = a_rec.b140_prem_seq_no
              AND inst_no     = a_rec.inst_no;
           v_overdue := SYSDATE - v_due_date + 1;
           IF v_overdue  >= 0 THEN
              SELECT AGING_ID,MAX_NO_DAYS
                INTO v_aging_id,v_max_no_days
                FROM giac_aging_parameters
               WHERE gibr_gfun_fund_cd = v_gif AND
                     gibr_branch_cd    = a_rec.b140_iss_cd AND
                     min_no_days      <= ABS(v_overdue) AND
                     max_no_days      >= ABS(v_overdue) AND
                     over_due_tag      = 'Y';
           ELSE
              SELECT aging_id,max_no_days
                INTO v_aging_id,v_max_no_days
                FROM giac_aging_parameters
               WHERE gibr_gfun_fund_cd = v_gif AND
                     gibr_branch_cd    = a_rec.b140_iss_cd AND
                     min_no_days      <= ABS(v_overdue) AND
                     max_no_days      >= ABS(v_overdue) AND
                     over_due_tag      = 'N';
           END IF;
           IF v_overdue <= 0 THEN
              v_next_age_level_dt := v_due_date;
           ELSE
              v_next_age_level_dt := v_due_date + v_max_no_days;
           END IF;
  --
           IF a_rec.b140_iss_cd NOT IN (v_ri, v_gr, v_rb) THEN
             BEGIN
               BEGIN
                 SELECT gagp_aging_id
                   INTO v_gagp_aging_id
                   FROM giac_aging_soa_details
                  WHERE iss_cd        = a_rec.b140_iss_cd
                    AND prem_seq_no   = a_rec.b140_prem_seq_no
                    AND inst_no       = a_rec.inst_no;
                   --AND gagp_aging_id = v_aging_id --commented by alfie 03302010 to avoid ora - 000001 error
                   --AND a020_assd_no  = v_assd_no -- commented by alfie 03302010
                   --AND a150_line_cd  = v_line_cd; -- commented by alfie 03302010
                   UPDATE giac_aging_soa_details
                      SET /*temp_payments    = temp_payments       -  a_rec.collection_amt, -- removed to prevent update on temp_payments 
                                                                                               when cancelling posted transactions
                                                                                               by Jayson 01.18.2011 */
                          total_payments   = total_payments      -  a_rec.collection_amt,
                          balance_amt_due  = balance_amt_due     +  a_rec.collection_amt,
                          prem_balance_due = prem_balance_due    +  a_rec.premium_amt,
                          tax_balance_due  = tax_balance_due     +  a_rec.tax_amt
                   WHERE iss_cd        = a_rec.b140_iss_cd
                     AND prem_seq_no   = a_rec.b140_prem_seq_no
                     AND inst_no       = a_rec.inst_no;
                   --  AND gagp_aging_id = v_aging_id  -- removed to be able to update correct amounts in giac_aging_soa_details when cancelling a transaction by Jayson 09.23.2010
                   --  AND a020_assd_no  = v_assd_no  -- removed to be able to update correct amounts in giac_aging_soa_details when cancelling a transaction by Jayson 09.23.2010
                   --  AND a150_line_cd  = v_line_cd;  -- removed to be able to update correct amounts in giac_aging_soa_details when cancelling a transaction by Jayson 09.23.2010
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                   INSERT INTO giac_aging_soa_details
                     (gagp_aging_id, a150_line_cd, a020_assd_no,
                      iss_cd, prem_seq_no, total_amount_due,
                      total_payments, temp_payments, balance_amt_due,
                      prem_balance_due, tax_balance_due, next_age_level_dt,
                      inst_no)
                    VALUES(
                      v_aging_id, v_line_cd, v_assd_no,
                      a_rec.b140_iss_cd, a_rec.b140_prem_seq_no, a_rec.collection_amt,
                      v_total_payts,v_temp_payments, a_rec.collection_amt,
                      a_rec.premium_amt, a_rec.tax_amt, v_next_age_level_dt,
                      a_rec.inst_no);
               END;
                 SELECT gibr_gfun_fund_cd,gibr_branch_cd
                   INTO v_gibr_gfun_fund_cd,v_gibr_branch_cd
                     FROM giac_aging_parameters
                       WHERE aging_id = v_aging_id;
         -- 1
               BEGIN
                 SELECT gagp_aging_id
                   INTO v_gagp_aging_id
                   FROM giac_aging_totals
                 WHERE gagp_aging_id = v_aging_id;
                   UPDATE giac_aging_totals
                     SET balance_amt_due  = balance_amt_due  + a_rec.collection_amt,
                         prem_balance_due = prem_balance_due + a_rec.premium_amt,
                         tax_balance_due  = tax_balance_due  + a_rec.tax_amt
                   WHERE gagp_aging_id    = v_aging_id;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                  INSERT INTO giac_aging_totals
                      (gibr_gfun_fund_cd,gibr_branch_cd,
                       gagp_aging_id,balance_amt_due,
                       prem_balance_due,tax_balance_due)
                   VALUES (v_gibr_gfun_fund_cd,v_gibr_branch_cd,
                       v_aging_id,a_rec.collection_amt,
                       a_rec.premium_amt,a_rec.tax_amt);
               END;
         -- 2
               BEGIN
                 SELECT a020_assd_no
                   INTO v_a020_assd_no
                   FROM giac_aging_summaries
                  WHERE gagp_aging_id = v_aging_id AND
                        a020_assd_no  = v_assd_no;
                    UPDATE giac_aging_summaries
                      SET balance_amt_due  = balance_amt_due  + a_rec.collection_amt,
                          prem_balance_due = prem_balance_due + a_rec.premium_amt,
                          tax_balance_due  = tax_balance_due  + a_rec.tax_amt
                    WHERE gagp_aging_id    = v_aging_id AND
                          a020_assd_no     = v_assd_no;
               EXCEPTION
                 WHEN NO_DATA_FOUND THEN
                    INSERT INTO giac_aging_summaries
                       (gagp_aging_id,a020_assd_no,balance_amt_due,
                        prem_balance_due,tax_balance_due)
                    VALUES(v_aging_id,v_assd_no,a_rec.collection_amt,
                        a_rec.premium_amt,a_rec.tax_amt);
               END;
         -- 3
               BEGIN
                 SELECT a020_assd_no
                   INTO v_a020_assd_no
                   FROM giac_soa_summaries
                  WHERE a020_assd_no = v_assd_no;
                    UPDATE giac_soa_summaries
                      SET balance_amt_due  = balance_amt_due  + a_rec.collection_amt,
                          prem_balance_due = prem_balance_due + a_rec.premium_amt,
                          tax_balance_due  = tax_balance_due  + a_rec.tax_amt
                    WHERE a020_assd_no     = v_assd_no;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    INSERT INTO giac_soa_summaries
                      (a020_assd_no,balance_amt_due,
                       prem_balance_due,tax_balance_due)
                    VALUES (v_assd_no, a_rec.collection_amt,
                       a_rec.premium_amt,a_rec.tax_amt);
              END;
        -- 4
              BEGIN
                SELECT a020_assd_no
                  INTO v_a020_assd_no
                  FROM giac_aging_assd_line
                 WHERE a020_assd_no    = v_assd_no
                   AND a150_line_cd    = v_line_cd
                   AND gagp_aging_id   = v_aging_id;
                     UPDATE giac_aging_assd_line
                       SET balance_amt_due  = balance_amt_due  + a_rec.collection_amt,
                           prem_balance_due = prem_balance_due + a_rec.premium_amt,
                           tax_balance_due  = tax_balance_due  + a_rec.tax_amt
                     WHERE a020_assd_no     = v_assd_no
                       AND a150_line_cd     = v_line_cd
                       AND gagp_aging_id    = v_aging_id;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   INSERT INTO giac_aging_assd_line
                              (gagp_aging_id,a020_assd_no,
                               a150_line_cd,balance_amt_due,
                               prem_balance_due,tax_balance_due)
                   VALUES(v_aging_id,v_assd_no,
                          v_line_cd,a_rec.collection_amt,
                          a_rec.premium_amt,a_rec.tax_amt);
              END;
        -- 5
              BEGIN
                SELECT gagp_aging_id
                  INTO v_gagp_aging_id
                  FROM giac_aging_line_totals
                 WHERE a150_line_cd    = v_line_cd
                   AND gagp_aging_id   = v_aging_id;
                     UPDATE giac_aging_line_totals
                       SET balance_amt_due  = balance_amt_due  + a_rec.collection_amt,
                           prem_balance_due = prem_balance_due + a_rec.premium_amt,
                           tax_balance_due  = tax_balance_due  + a_rec.tax_amt
                     WHERE a150_line_cd     = v_line_cd
                       AND gagp_aging_id    = v_aging_id;
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                   INSERT INTO giac_aging_line_totals
                        (gagp_aging_id,
                         a150_line_cd,balance_amt_due,
                         prem_balance_due,tax_balance_due)
                   VALUES(v_aging_id,
                          v_line_cd,a_rec.collection_amt,
                          a_rec.premium_amt,a_rec.tax_amt);
              END;
            END;
           END IF;
        END LOOP;
       END IF;
    END;
  END;
END;
/


