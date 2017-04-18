DROP PROCEDURE CPI.POPULATE_SOA;

CREATE OR REPLACE PROCEDURE CPI.POPULATE_SOA(p_policy_id IN GIPI_INVOICE.policy_id%TYPE)
IS
  ws_fund_cd            GIIS_FUNDS.fund_cd%TYPE;
  ws_policy_id          GIPI_INVOICE.policy_id%TYPE;
  ws_curr_rt            GIPI_INVOICE.currency_rt%TYPE;
  ws_curr_cd            GIPI_INVOICE.currency_cd%TYPE;
  ws_colln_amt          GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE;
  ws_gidp_prem          GIAC_DIRECT_PREM_COLLNS.premium_amt%TYPE;
  ws_gidp_tax           GIAC_DIRECT_PREM_COLLNS.tax_amt%TYPE;
  ws_gidp_rt            GIAC_DIRECT_PREM_COLLNS.convert_rate%TYPE;
  ws_max_no_days        GIAC_AGING_PARAMETERS.max_no_days%TYPE;
  ws_aging_id           GIAC_AGING_SOA_DETAILS.gagp_aging_id%TYPE;
  ws_nxt_age_lvl_dt     GIAC_AGING_SOA_DETAILS.next_age_level_dt%TYPE;
  ws_line_cd            GIAC_AGING_SOA_DETAILS.a150_line_cd%TYPE;
  ws_assd_no            GIAC_AGING_SOA_DETAILS.a020_assd_no%TYPE;
  ws_total_amt_due      GIAC_AGING_SOA_DETAILS.total_amount_due%TYPE;
  ws_total_payts        GIAC_AGING_SOA_DETAILS.total_payments%TYPE;
  ws_temp_payts         GIAC_AGING_SOA_DETAILS.temp_payments%TYPE;
  ws_bal_amt_due        GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE;
  ws_prem_bal_due       GIAC_AGING_SOA_DETAILS.prem_balance_due%TYPE;
  ws_tax_bal_due        GIAC_AGING_SOA_DETAILS.tax_balance_due%TYPE;
  ws_colln_amt2         GIAC_DIRECT_PREM_COLLNS.collection_amt%TYPE; --mikel 05.31.2012
  CURSOR b300 IS
    SELECT a.iss_cd, a.prem_seq_no,
           a.inst_no, a.prem_amt,
           a.tax_amt, a.due_date,
           rownum
      FROM gipi_installment a,
           gipi_invoice b,
           gipi_polbasic c
     WHERE a.iss_cd=b.iss_cd
       AND a.prem_seq_no=b.prem_seq_no
       AND b.policy_id=c.policy_id
       AND c.pol_flag<>'5'
       AND c.policy_id in (p_policy_id)  -- enter policy_id/s here
       ORDER by 1, 2, 3;
  b300_buf                b300%ROWTYPE;
  ws_overdue              NUMBER(8,4);
  ws_rowid                VARCHAR2(20);
  ws_rowcnt               NUMBER(5);
  ins_ctr                 NUMBER(5);
  upd_ctr                 NUMBER(5);
BEGIN
  BEGIN
    SELECT param_value_v
      INTO ws_fund_cd
      FROM giac_parameters
     WHERE param_name = 'FUND_CD';
  EXCEPTION
    WHEN no_data_found THEN
      RAISE_APPLICATION_ERROR(-20000, 'No data found in GIAC PARAMETERS table.');
  END;
  FOR b300_rec IN b300 LOOP
    b300_buf.iss_cd      := b300_rec.iss_cd;
    b300_buf.prem_seq_no := b300_rec.prem_seq_no;
    b300_buf.inst_no     := b300_rec.inst_no;
    b300_buf.due_date    := b300_rec.due_date;
    ws_rowcnt            := b300_rec.rownum;
    --
    -- Populate the line code, assured number and total amount due...
    --
    BEGIN
      SELECT policy_id, NVL(currency_rt,1), currency_cd
        INTO ws_policy_id, ws_curr_rt, ws_curr_cd
        FROM gipi_invoice
       WHERE iss_cd      = b300_buf.iss_cd
         AND prem_seq_no = b300_buf.prem_seq_no;
    EXCEPTION
        WHEN no_data_found THEN
--dbms_output.put_line(ws_fund_cd||'-'||b300_buf.iss_cd||'-'||ws_overdue||'-'||ws_rowcnt);
          RAISE_APPLICATION_ERROR(-20016,'No record found in GIPI_INVOICE table.');
        WHEN too_many_rows THEN
          RAISE_APPLICATION_ERROR(-20017,'Too many rows found in GIPI_INVOICE table.');
    END;
    --
    --
    IF ws_policy_id IS NOT null THEN
      --
      --
      b300_buf.prem_amt    := b300_rec.prem_amt * NVL(ws_curr_rt,1);
      b300_buf.tax_amt     := b300_rec.tax_amt * NVL(ws_curr_rt,1);
      ws_total_amt_due := NVL(b300_buf.prem_amt,0) +
                          NVL(b300_buf.tax_amt,0);
      --
      --
      BEGIN
         SELECT a.assd_no, b.line_cd
           INTO ws_assd_no, ws_line_cd
           FROM gipi_polbasic b, gipi_parlist a
          WHERE a.par_id      = b.par_id
            AND b.policy_id   = ws_policy_id;
      EXCEPTION
          WHEN no_data_found THEN
--dbms_output.put_line(ws_fund_cd||'-'||b300_buf.iss_cd||'-'||ws_overdue||'-'||ws_rowcnt);
            RAISE_APPLICATION_ERROR(-20018,'No record found in GIPI_POLBASIC table.');
          WHEN too_many_rows THEN
            RAISE_APPLICATION_ERROR(-20019,'Too many rows found in GIPI_POLBASIC table.');
      END;
    END IF;
    --
    -- Populate the collection amount in giac direct premium collections...
    --
    BEGIN
      SELECT SUM(a.collection_amt), SUM(a.premium_amt), SUM(a.tax_amt)
        INTO ws_colln_amt, ws_gidp_prem, ws_gidp_tax
        FROM giac_direct_prem_collns a, giac_acctrans b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                      FROM giac_reversals c, giac_acctrans d
                                     WHERE c.reversing_tran_id = d.tran_id
                                       AND d.tran_flag <> 'D')
         AND b.tran_flag <> 'D'
         AND a.b140_iss_cd = b300_buf.iss_cd
         AND a.b140_prem_seq_no = b300_buf.prem_seq_no
         AND a.inst_no = b300_buf.inst_no;
    EXCEPTION
      WHEN no_data_found THEN
        ws_colln_amt := 0;
        ws_gidp_prem := 0;
        ws_gidp_tax  := 0;
      WHEN too_many_rows THEN
         RAISE_APPLICATION_ERROR(-20019,'Too many rows found in GIAC_DIRECT_PREM_COLLNS table.');
    END;
    
    /* added by mikel 05.31.2012
    ** assign valule for temp_payments; only OPEN transactions should be on this column   
    */
    BEGIN
      SELECT SUM(a.collection_amt)
        INTO ws_colln_amt2
        FROM giac_direct_prem_collns a, giac_acctrans b
       WHERE a.gacc_tran_id = b.tran_id
         AND a.gacc_tran_id NOT IN (SELECT c.gacc_tran_id
                                      FROM giac_reversals c, giac_acctrans d
                                     WHERE c.reversing_tran_id = d.tran_id
                                       AND d.tran_flag <> 'D')
         AND b.tran_flag = 'O'
         AND a.b140_iss_cd = b300_buf.iss_cd
         AND a.b140_prem_seq_no = b300_buf.prem_seq_no
         AND a.inst_no = b300_buf.inst_no;
    EXCEPTION
      WHEN no_data_found THEN
        ws_colln_amt2 := 0;
      WHEN too_many_rows THEN
         RAISE_APPLICATION_ERROR(-20019,'Too many rows found in GIAC_DIRECT_PREM_COLLNS table.');
    END; --end mikel 05.31.2012
    --
    --
    ws_total_payts  := NVL(ws_total_payts, 0) + NVL(ws_colln_amt, 0);
    --ws_temp_payts   := NVL(ws_total_payts, 0) + NVL(ws_colln_amt, 0);
    ws_temp_payts   := NVL(ws_colln_amt2, 0); --mikel 05.31.2012; replaced the code above
    ws_bal_amt_due  := NVL(ws_total_amt_due, 0) - NVL(ws_total_payts, 0);
    ws_prem_bal_due := NVL(b300_buf.prem_amt, 0) - NVL(ws_gidp_prem, 0);
    ws_tax_bal_due  := NVL(b300_buf.tax_amt, 0) - NVL(ws_gidp_tax, 0);
    --
    --
    ws_overdue := (TRUNC(SYSDATE) - TRUNC(b300_buf.due_date) + 1);
    --
    -- Validate the due date and populate the aging id and next age level date...
    --
    IF ws_overdue  > 0 THEN
      BEGIN
        SELECT aging_id, max_no_days
          INTO ws_aging_id, ws_max_no_days
          FROM giac_aging_parameters
         WHERE gibr_gfun_fund_cd = ws_fund_cd
           AND gibr_branch_cd    = b300_buf.iss_cd
           AND min_no_days      <= ABS(ws_overdue)
           AND max_no_days      >= ABS(ws_overdue)
           AND over_due_tag      = 'Y';
        ws_nxt_age_lvl_dt := b300_buf.due_date + ws_max_no_days;
      EXCEPTION
        WHEN no_data_found THEN 
--dbms_output.put_line(ws_fund_cd||'-'||b300_buf.iss_cd||'-'||b300_buf.prem_seq_no||'-'||b300_buf.due_date||'-y-'||ws_overdue||'-'||ws_rowcnt);
          RAISE_APPLICATION_ERROR(-20015,'No record found in GIAC_AGING_PARAMETERS table.');
        WHEN too_many_rows THEN 
          RAISE_APPLICATION_ERROR(-20014,'Too many rows found in GIAC_AGING_PARAMETERS table.');
      END;
    ELSE
      BEGIN
        SELECT aging_id, max_no_days
          INTO ws_aging_id, ws_max_no_days
          FROM giac_aging_parameters
         WHERE gibr_gfun_fund_cd = ws_fund_cd
           AND gibr_branch_cd    = b300_buf.iss_cd
           AND min_no_days      <= ROUND(ABS(ws_overdue))
           AND max_no_days      >= ROUND(ABS(ws_overdue))
           AND over_due_tag      = 'N';
        ws_nxt_age_lvl_dt := b300_buf.due_date;
      EXCEPTION
        WHEN no_data_found THEN 
--dbms_output.put_line(ws_fund_cd||'-'||b300_buf.iss_cd||'-'||b300_buf.prem_seq_no||'-'||b300_buf.due_date||'-n'||ws_overdue||'-'||ws_rowcnt);
          RAISE_APPLICATION_ERROR(-20015,'No record found in GIAC_AGING_PARAMETERS table.');
        WHEN too_many_rows THEN
          RAISE_APPLICATION_ERROR(-20014,'Too many rows found in GIAC_AGING_PARAMETERS table.');
      END;
    END IF;
    --
    -- Check if the particular record exists in GIAC AGING SOA DETAILS table.
    -- If it exists, update the record else create a new record.
    --
    BEGIN
      SELECT 'X'--rowid --mikel 11.07.2012
        INTO ws_rowid
        FROM giac_aging_soa_details
       WHERE ---a150_line_cd  = ws_line_cd
        --- AND a020_assd_no  = ws_assd_no
    -----     AND gagp_aging_id = ws_aging_id
          inst_no       = b300_buf.inst_no
         AND prem_seq_no   = b300_buf.prem_seq_no
         AND iss_cd        = b300_buf.iss_cd;
    EXCEPTION
      WHEN no_data_found THEN
      ins_ctr := NVL(ins_ctr, 0) + 1;
      BEGIN
        INSERT into GIAC_AGING_SOA_DETAILS(gagp_aging_id   , a150_line_cd   , a020_assd_no     ,
                                           iss_cd          , prem_seq_no    , total_amount_due ,
                                           total_payments  , temp_payments  , balance_amt_due  ,
                                           prem_balance_due, tax_balance_due, next_age_level_dt,
                                           inst_no)
                                    VALUES(ws_aging_id    , ws_line_cd          , ws_assd_no       ,
                                           b300_buf.iss_cd, b300_buf.prem_seq_no, ws_total_amt_due ,
                                           ws_total_payts , ws_temp_payts       , ws_bal_amt_due   ,
                                           ws_prem_bal_due, ws_tax_bal_due      , ws_nxt_age_lvl_dt,
                                           b300_buf.inst_no);
      END;
    END;
    IF ws_rowid IS NOT null THEN
      UPDATE giac_aging_soa_details
    --     SET total_payments   = NVL(total_payments, 0) + ws_total_payts,
    --         temp_payments    = NVL(temp_payments, 0) + ws_temp_payts,
    --         balance_amt_due  = NVL(balance_amt_due, 0) + ws_bal_amt_due,
    --         prem_balance_due = NVL(prem_balance_due, 0) + ws_prem_bal_due,
    --         tax_balance_due  = NVL(tax_balance_due, 0) + ws_tax_bal_due
    --      WHERE rowid = ws_rowid;
    SET total_payments   = ws_total_payts,
             temp_payments      = ws_temp_payts,
             balance_amt_due    = ws_bal_amt_due,
             prem_balance_due   = ws_prem_bal_due,
             tax_balance_due    = ws_tax_bal_due
           WHERE --rowid = ws_rowid;
           inst_no       = b300_buf.inst_no
         AND prem_seq_no   = b300_buf.prem_seq_no
         AND iss_cd        = b300_buf.iss_cd; --mikel 11.07.2012
      upd_ctr := NVL(upd_ctr, 0) + 1;
--      IF MOD(upd_ctr, 250) = 0 THEN
--        dbms_output.put_line(upd_ctr || ' records already exists.');
--      END IF;
    END IF;
    ws_total_payts  := 0;
    ws_temp_payts   := 0;
    ws_bal_amt_due  := 0;
    ws_prem_bal_due := 0;
    ws_tax_bal_due  := 0;
    ws_colln_amt    := 0;
    ws_gidp_prem    := 0;
    ws_gidp_tax     := 0;
    COMMIT;
  END LOOP;
--        dbms_output.put_line(upd_ctr || ' records already exists.');
--        dbms_output.put_line(ins_ctr || ' records processed.');
--        dbms_output.put_line('total = '||ws_rowcnt);
END;
/


