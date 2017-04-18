CREATE OR REPLACE PACKAGE BODY CPI.GIACR503_PKG AS

    FUNCTION get_trial_balance(
        p_tran_mm       GIAC_tb_sl_ext.tran_mm%TYPE,
        p_tran_year     GIAC_tb_sl_ext.tran_year%TYPE
    ) RETURN trial_balance_tab PIPELINED
    IS
        v_balance           trial_balance_type;
    BEGIN
        
        SELECT giisp.v('COMPANY_NAME'), giisp.v('COMPANY_ADDRESS'), SYSDATE
          INTO v_balance.cf_company_name, v_balance.cf_company_add, v_balance.cf_1
          FROM dual;
    
        v_balance.cf_as_of := cf_as_ofFormula(p_tran_mm, p_tran_year);
        
        FOR rec IN (SELECT get_gl_acct_no(gl_acct_id) get_gl_acct_no_gl_acct_id, 
                           gl_acct_name, 
                           sl_cd, 
                           sl_name,
                           DECODE(SIGN(SUM(BEG_DEBIT-BEG_CREDIT)),1,SUM(BEG_DEBIT-BEG_CREDIT),0) beg_debit,
                           DECODE(SIGN(SUM(BEG_DEBIT-BEG_CREDIT)),-1,ABS(SUM(BEG_DEBIT-BEG_CREDIT)),0) beg_credit,
                           SUM(month_DEBIT) trans_debit,
                           SUM(month_credit) trans_credit,
                           DECODE(SIGN(SUM(end_DEBIT-end_CREDIT)),1,SUM(end_DEBIT-end_CREDIT),0) end_debit,
                           DECODE(SIGN(SUM(end_DEBIT-end_CREDIT)),-1,ABS(SUM(end_DEBIT-end_CREDIT)),0) end_credit 
                      FROM GIAC_tb_sl_ext
                     WHERE tran_mm = p_tran_mm
                       AND tran_year = p_tran_year
                     GROUP BY get_gl_acct_no(gl_acct_id), gl_acct_name, sl_cd, sl_name
                     ORDER BY get_gl_acct_no(gl_acct_id), sl_cd)
        LOOP
            v_balance.get_gl_acct_no_gl_acct_id := rec.get_gl_acct_no_gl_acct_id;
            v_balance.gl_acct_name := rec.gl_acct_name;
            v_balance.sl_cd := rec.sl_cd;
            v_balance.sl_name := rec.sl_name;
            v_balance.beg_debit := rec.beg_debit;
            v_balance.beg_credit := rec.beg_credit;
            v_balance.trans_debit := rec.trans_debit;
            v_balance.trans_credit := rec.trans_credit;
            v_balance.end_debit := rec.end_debit;
            v_balance.end_credit := rec.end_credit;
            
            PIPE ROW(v_balance);
        END LOOP;
        
    END get_trial_balance;
    
    FUNCTION cf_as_ofFormula(
        p_tran_mm       GIAC_tb_sl_ext.tran_mm%TYPE,
        p_tran_year     GIAC_tb_sl_ext.tran_year%TYPE
    ) RETURN VARCHAR
    IS
        v_as_of varchar2(40);
        v_mm    varchar2(10) ;
    BEGIN
        IF nvl(p_tran_mm,0) <= 0 or nvl(p_tran_mm,0) > 12 THEN
            v_mm := nvl(p_tran_mm,0);
        ELSE
            v_mm := rtrim(ltrim(to_char(to_date(to_char(p_tran_mm),'MM'),'Month')));
        END IF;
        
        v_as_of := 'As of '||v_mm||', '||ltrim(rtrim(to_char(p_tran_year)));
        
        RETURN(v_as_of);
    END cf_as_ofFormula;

END GIACR503_PKG;
/


