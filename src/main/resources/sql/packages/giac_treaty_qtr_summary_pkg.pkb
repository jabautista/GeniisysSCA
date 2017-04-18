CREATE OR REPLACE PACKAGE BODY CPI.GIAC_TREATY_QTR_SUMMARY_PKG
AS

    FUNCTION get_trty_qtr_summary(
        p_line_cd       giis_dist_share.line_cd%TYPE,
        p_share_cd      giis_dist_share.share_cd%TYPE,
        p_trty_yy       GIAC_TREATY_EXTRACT.TRTY_YY%TYPE,
        p_ri_cd         giis_reinsurer.ri_cd%TYPE,
        p_year          giac_treaty_cessions.cession_year%TYPE,
        p_qtr           giac_treaty_perils.proc_qtr%TYPE
    ) RETURN giac_trty_qtr_summ_tab PIPELINED
    IS
        v_summ          giac_trty_qtr_summ_type;
    BEGIN
    
        FOR rec IN (SELECT ri_cd, line_cd, trty_yy, sharE_cd, trty_shr_pct, proc_year, proc_qtr,
                           premium_ceded_amt, 
                           commission_amt,          
                           clm_loss_paid_amt,
                           clm_loss_expense_amt,
                           prem_resv_retnd_amt,
                           funds_held_pct,
                           outstanding_loss_amt,
                           prem_resv_relsd_amt,
                           released_int_amt,
                           wht_tax_rt,
                           wht_tax_amt,
                           ending_bal_amt,
                           prev_balance_due,
                           previous_bal_amt,
                           retained_int_amt,
                           summary_id,
                           acct_trty_type,
                           extract_date,
                           int_on_prem_pct,
                           prem_tax_amt,
                           final_tag,
                           user_id, last_update
                      FROM GIAC_TREATY_QTR_SUMMARY
                     WHERE line_cd      = p_line_cd
                       AND trty_yy      = p_trty_yy
                       AND share_cd     = p_share_cd
                       AND ri_cd        = p_ri_cd
                       AND proc_year    = p_year
                       AND proc_qtr     = p_qtr)
        LOOP
        
            BEGIN
              SELECT trty_name 
                INTO v_summ.treaty_name
                FROM giis_dist_share
               WHERE line_cd    = rec.line_cd
                 AND share_cd   = rec.share_cd
                 AND trty_yy    = rec.trty_yy;
            EXCEPTION
                 WHEN OTHERS THEN
                    v_summ.treaty_name := NULL;
            END;

            BEGIN
              SELECT line_name 
                INTO v_summ.line_name
                FROM giis_line
               WHERE line_cd = rec.line_cd;
            EXCEPTION
                 WHEN OTHERS THEN
                    v_summ.line_name := NULL;
            END;

            BEGIN
              SELECT ri_name 
                INTO v_summ.ri_name
                FROM giis_reinsurer
               WHERE ri_cd = rec.ri_cd;
            EXCEPTION
                 WHEN OTHERS THEN
                    v_summ.ri_name := NULL;
            END;
            
            v_summ.ri_cd                 := rec.ri_cd;
            v_summ.line_cd               := rec.line_cd;
            v_summ.trty_yy               := rec.trty_yy;
            v_summ.sharE_cd              := rec.sharE_cd;
            v_summ.trty_shr_pct          := rec.trty_shr_pct;
            v_summ.proc_year             := rec.proc_year;
            v_summ.proc_qtr              := rec.proc_qtr;
            
            v_summ.premium_ceded_amt     := rec.premium_ceded_amt;
            v_summ.commission_amt        := rec.commission_amt;
            v_summ.clm_loss_paid_amt     := rec.clm_loss_paid_amt;
            v_summ.clm_loss_expense_amt  := rec.clm_loss_expense_amt;
            v_summ.prem_resv_retnd_amt   := rec.prem_resv_retnd_amt;
             
            v_summ.funds_held_pct        := rec.funds_held_pct;
            v_summ.outstanding_loss_amt  := rec.outstanding_loss_amt;
            v_summ.prem_resv_relsd_amt   := rec.prem_resv_relsd_amt;
            v_summ.released_int_amt      := rec.released_int_amt;
            v_summ.wht_tax_rt            := rec.wht_tax_rt;
            v_summ.wht_tax_amt           := rec.wht_tax_amt;             
                           
            v_summ.ending_bal_amt        := rec.ending_bal_amt;
            v_summ.prev_balance_due      := rec.prev_balance_due;     
            v_summ.previous_bal_amt      := rec.previous_bal_amt;     
            v_summ.retained_int_amt      := rec.retained_int_amt;     
            v_summ.summary_id            := rec.summary_id;                         
                           
            v_summ.acct_trty_type        := rec.acct_trty_type;
            v_summ.extract_date          := rec.extract_date;
            v_summ.int_on_prem_pct       := rec.int_on_prem_pct;
            v_summ.prem_tax_amt          := rec.prem_tax_amt;
            v_summ.final_tag             := rec.final_tag;
            v_summ.user_id               := rec.user_id;
            v_summ.last_update_str       := TO_CHAR(rec.last_update, 'mm-dd-yyyy');
        
            PIPE ROW(v_summ);
        END LOOP;
    
    END get_trty_qtr_summary;
    
    PROCEDURE update_treaty_statement(
        p_treaty        GIAC_TREATY_QTR_SUMMARY%ROWTYPE
    ) IS
        v_gtcash_prev_resv_bal      GIAC_TREATY_CASH_ACCT.PREV_RESV_BALANCE%TYPE;
        v_gtcash_new_resv_balance   GIAC_TREATY_CASH_ACCT.RESV_BALANCE%TYPE;
    BEGIN
    
        UPDATE GIAC_TREATY_QTR_SUMMARY
           SET outstanding_loss_amt = p_treaty.outstanding_loss_amt,
               prem_resv_relsd_amt  = p_treaty.prem_resv_relsd_amt,
               released_int_amt     = p_treaty.released_int_amt,
               wht_tax_amt          = p_treaty.wht_tax_amt,
               ending_bal_amt       = p_treaty.ending_bal_amt
         WHERE summary_id           = p_treaty.summary_id; 
         
         
        SELECT prev_resv_balance
          INTO v_gtcash_prev_resv_bal
          FROM GIAC_TREATY_CASH_ACCT
         WHERE summary_id = p_treaty.summary_id;
         
        v_gtcash_new_resv_balance := NVL(v_gtcash_prev_resv_bal, 0) - NVL(p_treaty.prem_resv_relsd_amt, 0);
        
        GIAC_TREATY_CASH_ACCT_PKG.updatE_resv_balance(p_treaty.summary_id, v_gtcash_new_resv_balance);
           
    END update_treaty_statement;

END GIAC_TREATY_QTR_SUMMARY_PKG;
/


