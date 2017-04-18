CREATE OR REPLACE PACKAGE BODY CPI.GIACR220_PKG
AS

    -- functions for columnFormulae
    FUNCTION cf_sum_cash_ending_credit(
        p_prev_balance          giac_treaty_cash_acct.prev_balance%TYPE,
        p_balance_as_above      giac_treaty_cash_acct.balance_as_above%TYPE,
        p_our_remittance        GIAC_TREATY_CASH_ACCT.OUR_REMITTANCE%TYPE,
        p_your_remittance       GIAC_TREATY_CASH_ACCT.YOUR_REMITTANCE%TYPE,
        p_cash_call_paid        GIAC_TREATY_CASH_ACCT.CASH_CALL_PAID%TYPE,
        p_cash_bal_in_favor     GIAC_TREATY_CASH_ACCT.CASH_BAL_IN_FAVOR%TYPE
    ) RETURN NUMBER
    IS
        v_ending    NUMBER(15,2);
        v_item_10   VARCHAR2(1);
        v_item_11   VARCHAR2(1);
        v_item_12   VARCHAR2(1);
        v_item_13   VARCHAR2(1);
        v_item_14   VARCHAR2(1);
        v_item_15   VARCHAR2(1);
    BEGIN
    
          SELECT dr_cr_tag 
            INTO v_item_10
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 10;

           SELECT dr_cr_tag 
            INTO v_item_11
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 11;

           SELECT dr_cr_tag 
            INTO v_item_12
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 12;

           SELECT dr_cr_tag 
            INTO v_item_13
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 13;

           SELECT dr_cr_tag 
            INTO v_item_14
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 14;

           SELECT dr_cr_tag 
            INTO v_item_15
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 15;

           SELECT   DECODE(v_item_10,'C',NVL(p_prev_balance,0),0) 
                  + DECODE(v_item_11,'C',NVL(p_balance_as_above,0),0) 
                  + DECODE(v_item_12,'C',NVL(p_our_remittance,0),0) 
                  + DECODE(v_item_13,'C',NVL(p_your_remittance,0),0) 
                  + DECODE(v_item_14,'C',NVL(p_cash_call_paid,0),0) 
                  + DECODE(v_item_15,'C',NVL(p_cash_bal_in_favor,0),0)
             INTO v_ending
             FROM DUAL;
             
           RETURN v_ending;
           --RETURN NULL; 
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RETURN 0;
    END cf_sum_cash_ending_credit;
    
    
    FUNCTION CF_sum_cash_ending_debit(
        p_prev_balance          giac_treaty_cash_acct.prev_balance%TYPE,
        p_balance_as_above      giac_treaty_cash_acct.balance_as_above%TYPE,
        p_our_remittance        GIAC_TREATY_CASH_ACCT.OUR_REMITTANCE%TYPE,
        p_your_remittance       GIAC_TREATY_CASH_ACCT.YOUR_REMITTANCE%TYPE,
        p_cash_call_paid        GIAC_TREATY_CASH_ACCT.CASH_CALL_PAID%TYPE,
        p_cash_bal_in_favor     GIAC_TREATY_CASH_ACCT.CASH_BAL_IN_FAVOR%TYPE
    ) RETURN NUMBER
    IS
       v_ending    NUMBER(15,2);
       v_item_10   VARCHAR2(1);
       v_item_11   VARCHAR2(1);
       v_item_12   VARCHAR2(1);
       v_item_13   VARCHAR2(1);
       v_item_14   VARCHAR2(1);
       v_item_15   VARCHAR2(1);
    BEGIN
    
          SELECT dr_cr_tag 
            INTO v_item_10
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 10;

           SELECT dr_cr_tag 
            INTO v_item_11
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 11;

           SELECT dr_cr_tag 
            INTO v_item_12
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 12;

           SELECT dr_cr_tag 
            INTO v_item_13
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 13;

           SELECT dr_cr_tag 
            INTO v_item_14
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 14;

           SELECT dr_cr_tag 
            INTO v_item_15
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 15;

           SELECT   DECODE(v_item_10,'D',NVL(p_prev_balance,0),0) 
                  + DECODE(v_item_11,'D',NVL(p_balance_as_above,0),0) 
                  + DECODE(v_item_12,'D',NVL(p_our_remittance,0),0) 
                  + DECODE(v_item_13,'D',NVL(p_your_remittance,0),0) 
                  + DECODE(v_item_14,'D',NVL(p_cash_call_paid,0),0) 
                  + DECODE(v_item_15,'D',NVL(p_cash_bal_in_favor,0),0)
             INTO v_ending
             FROM DUAL;
             
           RETURN v_ending;
           
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN 0;
    
    END CF_sum_cash_ending_debit;
    
    
    FUNCTION CF_sum_ending_credit(
        p_premium_ceded_amt         giac_treaty_qtr_summary.premium_ceded_amt%TYPE,
        p_commission_amt            giac_treaty_qtr_summary.commission_amt%TYPE,
        p_clm_loss_paid_amt         giac_treaty_qtr_summary.clm_loss_paid_amt%TYPE,
        p_clm_loss_expense_amt      giac_treaty_qtr_summary.clm_loss_expense_amt%TYPE,
        p_prem_resv_retnd_amt       giac_treaty_qtr_summary.prem_resv_retnd_amt%TYPE,
        p_prem_resv_relsd_amt       giac_treaty_qtr_summary.prem_resv_relsd_amt%TYPE,
        p_released_int_amt          giac_treaty_qtr_summary.released_int_amt%TYPE,
        p_wht_tax_amt               giac_treaty_qtr_summary.wht_tax_amt%TYPE,
        p_ending_bal_amt            giac_treaty_qtr_summary.ending_bal_amt%TYPE
    ) RETURN NUMBER
    IS
       v_ending   NUMBER(15,2);
       v_item_1   VARCHAR2(1);
       v_item_2   VARCHAR2(1);
       v_item_3   VARCHAR2(1);
       v_item_4   VARCHAR2(1);
       v_item_5   VARCHAR2(1);
       v_item_6   VARCHAR2(1);
       v_item_7   VARCHAR2(1);
       v_item_8   VARCHAR2(1);
       v_item_9   VARCHAR2(1);
    BEGIN
    
          SELECT dr_cr_tag 
            INTO v_item_1
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 1;

           SELECT dr_cr_tag 
            INTO v_item_2
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 2;

           SELECT dr_cr_tag 
            INTO v_item_3
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 3;

           SELECT dr_cr_tag 
            INTO v_item_4
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 4;

           SELECT dr_cr_tag 
            INTO v_item_5
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 5;

           SELECT dr_cr_tag 
            INTO v_item_5
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 5;

           SELECT dr_cr_tag 
            INTO v_item_6
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 6;

           SELECT dr_cr_tag 
            INTO v_item_7
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 7;

           SELECT dr_cr_tag 
            INTO v_item_8
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 8;

           SELECT dr_cr_tag 
            INTO v_item_9
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 9;


           SELECT DECODE(v_item_1, 'C', NVL(p_premium_ceded_amt,0),0) +
                  DECODE(v_item_2, 'C', NVL(p_commission_amt,0),0) +
                  DECODE(v_item_3, 'C', NVL(p_clm_loss_paid_amt,0),0) +
                  DECODE(v_item_4, 'C', NVL(p_clm_loss_expense_amt,0),0) +
                  DECODE(v_item_5, 'C', NVL(p_prem_resv_retnd_amt,0),0) +
                  DECODE(v_item_6, 'C', NVL(p_prem_resv_relsd_amt,0),0) +
                  DECODE(v_item_7, 'C', NVL(p_released_int_amt,0),0) +
                  DECODE(v_item_8, 'C', NVL(p_wht_tax_amt,0),0) +
                  DECODE(v_item_9, 'C', NVL(p_ending_bal_amt,0),0) 
             INTO v_ending
             FROM DUAL;

           RETURN v_ending;
           
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN 0;
    
    END CF_sum_ending_credit;
    
    
    FUNCTION CF_sum_ending_debit(
        p_premium_ceded_amt         giac_treaty_qtr_summary.premium_ceded_amt%TYPE,
        p_commission_amt            giac_treaty_qtr_summary.commission_amt%TYPE,
        p_clm_loss_paid_amt         giac_treaty_qtr_summary.clm_loss_paid_amt%TYPE,
        p_clm_loss_expense_amt      giac_treaty_qtr_summary.clm_loss_expense_amt%TYPE,
        p_prem_resv_retnd_amt       giac_treaty_qtr_summary.prem_resv_retnd_amt%TYPE,
        p_prem_resv_relsd_amt       giac_treaty_qtr_summary.prem_resv_relsd_amt%TYPE,
        p_released_int_amt          giac_treaty_qtr_summary.released_int_amt%TYPE,
        p_wht_tax_amt               giac_treaty_qtr_summary.wht_tax_amt%TYPE,
        p_ending_bal_amt            giac_treaty_qtr_summary.ending_bal_amt%TYPE
    ) RETURN NUMBER
    IS
       v_ending   NUMBER(15,2);
       v_item_1   VARCHAR2(1);
       v_item_2   VARCHAR2(1);
       v_item_3   VARCHAR2(1);
       v_item_4   VARCHAR2(1);
       v_item_5   VARCHAR2(1);
       v_item_6   VARCHAR2(1);
       v_item_7   VARCHAR2(1);
       v_item_8   VARCHAR2(1);
       v_item_9   VARCHAR2(1);
    BEGIN
    
          SELECT dr_cr_tag 
            INTO v_item_1
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 1;

           SELECT dr_cr_tag 
            INTO v_item_2
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 2;

           SELECT dr_cr_tag 
            INTO v_item_3
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 3;

           SELECT dr_cr_tag 
            INTO v_item_4
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 4;

           SELECT dr_cr_tag 
            INTO v_item_5
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 5;

           SELECT dr_cr_tag 
            INTO v_item_5
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 5;

           SELECT dr_cr_tag 
            INTO v_item_6
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 6;

           SELECT dr_cr_tag 
            INTO v_item_7
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 7;

           SELECT dr_cr_tag 
            INTO v_item_8
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 8;

           SELECT dr_cr_tag 
            INTO v_item_9
            FROM giac_modules gm,
                 giac_module_entries gme
           WHERE gm.module_name = 'GIACS220'
             AND gm.module_id = gme.module_id
             AND gme.item_no = 9;

           SELECT DECODE(v_item_1, 'D', NVL(p_premium_ceded_amt,0),0) +
                  DECODE(v_item_2, 'D', NVL(p_commission_amt,0),0) +
                  DECODE(v_item_3, 'D', NVL(p_clm_loss_paid_amt,0),0) +
                  DECODE(v_item_4, 'D', NVL(p_clm_loss_expense_amt,0),0) +
                  DECODE(v_item_5, 'D', NVL(p_prem_resv_retnd_amt,0),0) +
                  DECODE(v_item_6, 'D', NVL(p_prem_resv_relsd_amt,0),0) +
                  DECODE(v_item_7, 'D', NVL(p_released_int_amt,0),0) +
                  DECODE(v_item_8, 'D', NVL(p_wht_tax_amt,0),0) +
                  DECODE(v_item_9, 'D', NVL(p_ending_bal_amt,0),0) 
             INTO v_ending
             FROM DUAL;

           RETURN v_ending;
           
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
         RETURN 0;
    
    END CF_sum_ending_debit;
    
    
    FUNCTION CF_trty_comm_rt(
        p_line_cd           giac_treaty_qtr_summary.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_qtr_summary.trty_yy%TYPE,
        p_share_cd          giac_treaty_qtr_summary.share_cd%TYPE,
        p_ri_cd             giac_treaty_qtr_summary.ri_cd%TYPE,
        p_proc_year         giac_treaty_qtr_summary.proc_year%TYPE,
        p_proc_qtr          giac_treaty_qtr_summary.proc_qtr%TYPE
    ) RETURN NUMBER 
    IS
        v_comm_rt    giac_treaty_comm_v.trty_comm_rt%TYPE;
    BEGIN
    
       v_comm_rt := 0;
       
       FOR cur1 IN (SELECT MAX(trty_comm_rt) trty_comm_rt
                      FROM giac_treaty_comm_v
                     WHERE line_cd   = p_line_cd
                       AND trty_yy   = p_trty_yy
                       AND share_cd  = p_share_cd
                       AND ri_cd     = p_ri_cd
                       AND proc_year = p_proc_year
                       AND proc_qtr  = p_proc_qtr)
       LOOP
          v_comm_rt := cur1.trty_comm_rt;
          EXIT;
       END LOOP;
       
       RETURN v_comm_rt;
    
    END CF_trty_comm_rt;
    
    
    
    --- main report

    FUNCTION get_report_details(
        p_line_cd           giac_treaty_qtr_summary.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_qtr_summary.trty_yy%TYPE,
        p_share_cd          giac_treaty_qtr_summary.share_cd%TYPE,
        p_ri_cd             giac_treaty_qtr_summary.ri_cd%TYPE,
        p_proc_year         giac_treaty_qtr_summary.proc_year%TYPE,
        p_proc_qtr          giac_treaty_qtr_summary.proc_qtr%TYPE
    ) RETURN giacr220_tab PIPELINED 
    IS
        v_dtl       giacr220_type;
        v_count     NUMBER(1) := 0;
    BEGIN
    
        BEGIN        
           SELECT param_value_v 
             INTO v_dtl.company_name
             FROM giac_parameters 
            WHERE param_name LIKE 'COMPANY_NAME';           
        END;
        
        BEGIN        
           SELECT param_value_v 
             INTO v_dtl.gi_address
             FROM giac_parameters 
            WHERE param_name LIKE 'GI_ADDRESS';           
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_1
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 1;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_2
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 2;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_3
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 3;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_4
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 4;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_5
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 5;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_6
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 6;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_7
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 7;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_8
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 8;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_9
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 9;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_10
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 10;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_11
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 11;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_12
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 12;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_13
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 13;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_14
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 14;
        END;
        
        BEGIN
           SELECT dr_cr_tag 
             INTO v_dtl.dr_cr_tag_15
             FROM giac_modules gm,
                  giac_module_entries gme
            WHERE gm.module_name = 'GIACS220'
              AND gm.module_id = gme.module_id
              AND gme.item_no = 15;
        END;
        
        -- main query
        FOR rec IN (SELECT a.summary_id,      
                           a.line_cd,
                           a.trty_yy,
                           a.share_cd,
                           a.ri_cd,
                           substr(get_ri_name(ri_cd),1,50) ri_name, 
                           a.proc_qtr, 
                           a.proc_year,
                           b.trty_name,
                           a.acct_trty_type,
                           a.extract_date,
                           NVL(a.premium_ceded_amt,0) premium_ceded_amt, 
                           NVL(a.trty_shr_pct, 0) trty_shr_pct,
                           NVL(a.outstanding_loss_amt,0) OL_amt,
                           NVL(a.commission_amt, 0) commission_amt,
                           NVL(a.clm_loss_paid_amt, 0) clm_loss_paid_amt, 
                           NVL(a.clm_loss_expense_amt, 0) clm_loss_expense_amt, 
                           NVL(a.prem_resv_retnd_amt, 0) prem_resv_retnd_amt,
                           NVL(a.prem_resv_relsd_amt, 0) prem_resv_relsd_amt,
                           NVL(a.funds_held_pct, 0) funds_held_pct,
                           NVL(a.int_on_prem_pct, 0) int_on_prem_pct,
                           NVL(a.released_int_amt, 0) released_int_amt,
                           NVL(a.wht_tax_amt, 0) wht_tax_amt,
                           NVL(a.wht_tax_rt, 0) wht_tax_rt,
                           NVL(a.ending_bal_amt, 0) ending_bal_amt,
                           NVL(a.previous_bal_amt, 0) previous_bal_amt,
                           NVL(c.prev_balance, 0) prev_balance,
                           c.prev_balance_dt,
                           NVL(c.balance_as_above, 0) balance_as_above,
                           NVL(c.our_remittance, 0) our_remittance,
                           NVL(c.your_remittance, 0) your_remittance,
                           NVL(c.cash_call_paid, 0) cash_call_paid,
                           NVL(c.cash_bal_in_favor, 0) cash_bal_in_favor,
                           NVL(c.resv_balance, 0) resv_balance, 
                           NVL(c.prev_resv_balance, 0) prev_resv_balance,
                           c.prev_resv_bal_dt,
                           c.resv_balance_dt  
                      FROM giac_treaty_qtr_summary a,
                           giis_dist_share b,
                           giac_treaty_cash_acct c
                     WHERE 1=1
                       and a.line_cd    = NVL(p_line_cd, a.line_cd)
                       and a.trty_yy    = NVL(p_trty_yy, a.trty_yy)
                       and a.share_cd   = NVL(p_share_cd, a.share_cd)
                       and a.ri_cd      = NVL(p_ri_cd, a.ri_cd)
                       and a.proc_year  = NVL(p_proc_year, a.proc_year)
                       and a.proc_qtr   = NVL(p_proc_qtr, a.proc_qtr)
                       and a.summary_id = c.summary_id 
                       and a.line_cd    = b.line_cd
                       and a.trty_yy    = b.trty_yy
                       and a.share_cd   = b.share_cd)
        LOOP
            v_count := 1;
            
            v_dtl.summary_id            := rec.summary_id;
            v_dtl.line_cd               := rec.line_cd;
            v_dtl.trty_yy               := rec.trty_yy;
            v_dtl.share_cd              := rec.share_cd;
            v_dtl.ri_cd                 := rec.ri_cd;
            v_dtl.ri_name               := rec.ri_name;
            v_dtl.proc_qtr              := rec.proc_qtr;
            v_dtl.proc_year             := rec.proc_year;
            v_dtl.trty_name             := rec.trty_name;
            v_dtl.acct_trty_type        := rec.acct_trty_type;
            v_dtl.extract_date          := rec.extract_date;
            v_dtl.premium_ceded_amt     := rec.premium_ceded_amt;
            v_dtl.trty_shr_pct          := rec.trty_shr_pct;
            v_dtl.OUTSTANDING_LOSS_AMT  := rec.ol_amt;
            v_dtl.commission_amt        := rec.commission_amt;
            v_dtl.clm_loss_paid_amt     := rec.clm_loss_paid_amt;
            v_dtl.clm_loss_expense_amt  := rec.clm_loss_expense_amt;
            v_dtl.prem_resv_retnd_amt   := rec.prem_resv_retnd_amt;
            v_dtl.prem_resv_relsd_amt   := rec.prem_resv_relsd_amt;
            v_dtl.funds_held_pct        := rec.funds_held_pct;
            v_dtl.int_on_prem_pct       := rec.int_on_prem_pct;
            v_dtl.released_int_amt      := rec.released_int_amt;
            v_dtl.wht_tax_amt           := rec.wht_tax_amt;
            v_dtl.wht_tax_rt            := rec.wht_tax_rt;
            v_dtl.ending_bal_amt        := rec.ending_bal_amt;
            v_dtl.previous_bal_amt      := rec.previous_bal_amt;
            v_dtl.prev_balance          := rec.prev_balance;
            v_dtl.prev_balance_dt       := rec.prev_balance_dt;
            v_dtl.balance_as_above      := rec.balance_as_above;
            v_dtl.our_remittance        := rec.our_remittance;
            v_dtl.your_remittance       := rec.your_remittance;
            v_dtl.cash_call_paid        := rec.cash_call_paid;
            v_dtl.cash_bal_in_favor     := rec.cash_bal_in_favor;
            v_dtl.resv_balance          := rec.resv_balance;
            v_dtl.prev_resv_balance     := rec.prev_resv_balance;
            v_dtl.prev_resv_bal_dt      := rec.prev_resv_bal_dt;
            v_dtl.resv_balance_dt       := rec.resv_balance_dt;
            
            BEGIN
               SELECT TO_CHAR(to_date(rec.proc_qtr,'j'),'Jspth') || ' Quarter, ' || TO_CHAR(rec.proc_year)
                 INTO v_dtl.period
                 FROM dual;
            END;
            
            v_dtl.cf_sum_cash_ending_credit := cf_sum_cash_ending_credit(rec.prev_balance, 
                                                                         rec.balance_as_above, 
                                                                         rec.our_remittance, 
                                                                         rec.your_remittance, 
                                                                         rec.cash_call_paid, 
                                                                         rec.cash_bal_in_favor);
            v_dtl.CF_sum_cash_ending_debit := CF_sum_cash_ending_debit(rec.prev_balance, 
                                                                       rec.balance_as_above, 
                                                                       rec.our_remittance, 
                                                                       rec.your_remittance, 
                                                                       rec.cash_call_paid, 
                                                                       rec.cash_bal_in_favor); 
                                                                       
            v_dtl.CF_sum_ending_credit := CF_sum_ending_credit(rec.premium_ceded_amt,
                                                               rec.commission_amt,
                                                               rec.clm_loss_paid_amt,
                                                               rec.clm_loss_expense_amt,
                                                               rec.prem_resv_retnd_amt,
                                                               rec.prem_resv_relsd_amt,
                                                               rec.released_int_amt,
                                                               rec.wht_tax_amt,
                                                               rec.ending_bal_amt);
            
            v_dtl.CF_sum_ending_debit := CF_sum_ending_debit(rec.premium_ceded_amt,
                                                             rec.commission_amt,
                                                             rec.clm_loss_paid_amt,
                                                             rec.clm_loss_expense_amt,
                                                             rec.prem_resv_retnd_amt,
                                                             rec.prem_resv_relsd_amt,
                                                             rec.released_int_amt,
                                                             rec.wht_tax_amt,
                                                             rec.ending_bal_amt);
                                                             
            BEGIN
                SELECT param_value_v
                  INTO v_dtl.prem_ceded_brk
                  FROM giac_parameters
                 WHERE param_name LIKE 'PREM_CEDED_BRK';
            END;
            
            BEGIN
                SELECT param_value_n
                  INTO v_dtl.comm_amt_brk
                  FROM giac_parameters
                 WHERE param_name LIKE 'COMM_AMT_BRK';
            END;            
            
            BEGIN
                SELECT param_value_v
                  INTO v_dtl.loss_paid_brk
                  FROM giac_parameters
                 WHERE param_name LIKE 'LOSS_PAID_BRK';
            END;
            
            BEGIN
                SELECT param_value_v
                  INTO v_dtl.EXP_PAID_BRK
                  FROM giac_parameters
                 WHERE param_name LIKE 'EXP_PAID_BRK';
            END;
            
            PIPE ROW(v_dtl);
        END LOOP;    
        
        IF v_count = 0 THEN
            PIPE ROW(v_dtl);
        END IF;
        
    
    END get_report_details;
    
    -- for query2
    FUNCTION get_subreport2(
        p_line_cd           giac_treaty_perils_v.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_perils_v.trty_yy%TYPE,
        p_share_cd          giac_treaty_perils_v.share_cd%TYPE,
        p_ri_cd             giac_treaty_perils_v.ri_cd%TYPE,
        p_proc_year         giac_treaty_perils_v.proc_year%TYPE,
        p_proc_qtr          giac_treaty_perils_v.proc_qtr%TYPE
    ) RETURN subreport_tab PIPELINED
    IS
        v_sub       subreport_type;
    BEGIN
    
        FOR rec IN (SELECT line_cd, trty_yy, share_cd, ri_cd, proc_year, proc_qtr,
                           peril_cd, premium_amt, commission_amt
                      FROM giac_treaty_perils_v
                     WHERE line_cd   = p_line_cd
                       AND trty_yy   = p_trty_yy
                       AND share_cd  = p_share_cd
                       AND ri_cd     = p_ri_cd
                       AND proc_year = p_proc_year
                       AND proc_qtr  = p_proc_qtr)
        LOOP
        
            v_sub.line_cd        := rec.line_cd;
            v_sub.trty_yy        := rec.trty_yy;
            v_sub.share_cd       := rec.share_cd;
            v_sub.ri_cd          := rec.ri_cd;
            v_sub.proc_year      := rec.proc_year;
            v_sub.proc_qtr       := rec.proc_qtr;
            v_sub.premium_amt    := rec.premium_amt;
            v_sub.commission_amt := rec.commission_amt;
            v_sub.peril_cd       := rec.peril_cd;
            v_sub.peril_name     := get_peril_name(rec.line_cd, rec.peril_cd);
            
            PIPE ROW(v_sub);
        END LOOP;
    
    END get_subreport2;
    
    -- for query3
    FUNCTION get_subreport3(
        p_line_cd           giac_treaty_comm_v.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_comm_v.trty_yy%TYPE,
        p_share_cd          giac_treaty_comm_v.share_cd%TYPE,
        p_ri_cd             giac_treaty_comm_v.ri_cd%TYPE,
        p_proc_year         giac_treaty_comm_v.proc_year%TYPE,
        p_proc_qtr          giac_treaty_comm_v.proc_qtr%TYPE
    ) RETURN subreport_tab PIPELINED
    IS
        v_sub       subreport_type;
    BEGIN
    
        FOR rec IN (SELECT line_cd, trty_yy, share_cd, ri_cd, proc_year, proc_qtr,
                           trty_comm_rt, premium_amt, commission_amt
                      FROM giac_treaty_comm_v 
                     WHERE line_cd   = p_line_cd
                       AND trty_yy   = p_trty_yy
                       AND share_cd  = p_share_cd
                       AND ri_cd     = p_ri_cd
                       AND proc_year = p_proc_year
                       AND proc_qtr  = p_proc_qtr)
        LOOP
        
            v_sub.line_cd        := rec.line_cd;
            v_sub.trty_yy        := rec.trty_yy;
            v_sub.share_cd       := rec.share_cd;
            v_sub.ri_cd          := rec.ri_cd;
            v_sub.proc_year      := rec.proc_year;
            v_sub.proc_qtr       := rec.proc_qtr;
            v_sub.premium_amt    := rec.premium_amt;
            v_sub.commission_amt := rec.commission_amt;
            v_sub.trty_comm_rt   := rec.trty_comm_rt;
            
            PIPE ROW(v_sub);
        END LOOP;
    
    END get_subreport3;    
    
    -- for query4
    FUNCTION get_subreport4(
        p_line_cd           giac_treaty_claims_v.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_claims_v.trty_yy%TYPE,
        p_share_cd          giac_treaty_claims_v.share_cd%TYPE,
        p_ri_cd             giac_treaty_claims_v.ri_cd%TYPE,
        p_proc_year         giac_treaty_claims_v.proc_year%TYPE,
        p_proc_qtr          giac_treaty_claims_v.proc_qtr%TYPE
    ) RETURN subreport_tab PIPELINED
    IS
        v_sub       subreport_type;
    BEGIN
    
        FOR rec IN (SELECT line_cd, trty_yy, share_cd, ri_cd, proc_year, proc_qtr,
                           peril_cd, loss_paid_amt, loss_exp_amt, treaty_Seq_no
                      FROM giac_treaty_claims_v  
                     WHERE line_cd   = p_line_cd
                       AND trty_yy   = p_trty_yy
                       AND share_cd  = p_share_cd
                       AND ri_cd     = p_ri_cd
                       AND proc_year = p_proc_year
                       AND proc_qtr  = p_proc_qtr)
        LOOP
        
            v_sub.line_cd        := rec.line_cd;
            v_sub.trty_yy        := rec.trty_yy;
            v_sub.share_cd       := rec.share_cd;
            v_sub.ri_cd          := rec.ri_cd;
            v_sub.proc_year      := rec.proc_year;
            v_sub.proc_qtr       := rec.proc_qtr;
            v_sub.peril_cd       := rec.peril_cd;
            v_sub.peril_name     := get_peril_name(rec.line_cd, rec.peril_cd);
            v_sub.loss_paid_amt  := rec.loss_paid_amt;
            v_sub.loss_exp_amt   := rec.loss_exp_amt;
            v_sub.treaty_Seq_no  := rec.treaty_Seq_no;
            
            PIPE ROW(v_sub);
        END LOOP;
    
    END get_subreport4;
    
    
    
    

END GIACR220_PKG;
/


