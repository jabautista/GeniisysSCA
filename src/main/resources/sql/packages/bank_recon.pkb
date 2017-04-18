CREATE OR REPLACE PACKAGE BODY CPI.Bank_Recon IS

FUNCTION get_book_amt(p_tran_mm IN VARCHAR2,
                      p_tran_year IN NUMBER,
					  p_book_tran_cd IN VARCHAR2,
					  p_bank_cd IN VARCHAR2,
                      p_bank_acct_cd IN VARCHAR2) RETURN NUMBER IS
  v_recon_start_dt DATE;
  v_recon_end_dt DATE;
  v_book_amt  GIAC_BANK_TRAN_DTL.tran_amount%TYPE;
BEGIN
  BEGIN
    SELECT TO_DATE(p_tran_mm||'/'||p_tran_year,'MM/RRRR'),LAST_DAY(TO_DATE(p_tran_mm||'/'||p_tran_year,'MM/RRRR'))
      INTO v_recon_start_dt, v_recon_end_dt
      FROM dual;
  END;
  IF p_book_tran_cd = 'CDCCA' THEN
	FOR c1 IN (SELECT SUM(A.amount) amount
	 		     FROM GIAC_ACCTRANS c,
				      GIAC_DCB_BANK_DEP b,
					  GIAC_BANK_DEP_SLIPS A
				WHERE 1=1
				  AND c.tran_id = b.gacc_tran_id
				  AND b.gacc_tran_id = A.gacc_tran_id
				  AND b.fund_cd = A.fund_cd
				  AND b.branch_cd = A.branch_cd
				  AND b.dcb_year = A.dcb_year
				  AND b.dcb_no = A.dcb_no
				  AND b.item_no = A.item_no
				  AND b.pay_mode = 'CA'
				  AND b.bank_cd = p_bank_cd
				  AND b.bank_acct_cd = p_bank_acct_cd				  				  
				  AND c.posting_date BETWEEN v_recon_start_dt AND v_recon_end_dt)
	LOOP
	  v_book_amt := c1.amount;
	END LOOP;
  ELSIF p_book_tran_cd = 'CDCCK' THEN
    FOR c1 IN (SELECT SUM(A.amount) amount
                             FROM GIAC_ACCTRANS c,
                                  GIAC_DCB_BANK_DEP b,
                                    GIAC_BANK_DEP_SLIPS A
                            WHERE 1=1
                              AND c.tran_id = b.gacc_tran_id                            
                              AND b.gacc_tran_id = A.gacc_tran_id
                              AND b.fund_cd = A.fund_cd
                              AND b.branch_cd = A.branch_cd
                              AND b.dcb_year = A.dcb_year
                              AND b.dcb_no = A.dcb_no
                              AND b.item_no = A.item_no
                              AND b.pay_mode = 'CHK' -- apura03082012 from CK to CHK
                              AND b.bank_cd = p_bank_cd
                              AND b.bank_acct_cd = p_bank_acct_cd                                                
                              AND c.posting_date BETWEEN v_recon_start_dt AND v_recon_end_dt)
    LOOP
        v_book_amt := c1.amount;
    END LOOP;
  ELSIF p_book_tran_cd = 'CDCCM' THEN
    FOR c1 IN (SELECT SUM(A.amount) amount
                             FROM GIAC_ACCTRANS c,
                                  GIAC_DCB_BANK_DEP b,
                                    GIAC_BANK_DEP_SLIPS A
                            WHERE 1=1
                              AND c.tran_id = b.gacc_tran_id
                              AND b.gacc_tran_id = A.gacc_tran_id
                              AND b.fund_cd = A.fund_cd
                              AND b.branch_cd = A.branch_cd
                              AND b.dcb_year = A.dcb_year
                              AND b.dcb_no = A.dcb_no
                              AND b.item_no = A.item_no
                              AND b.pay_mode = 'CM'
                              AND b.bank_cd = p_bank_cd
                              AND b.bank_acct_cd = p_bank_acct_cd                                                
                              AND c.posting_date BETWEEN v_recon_start_dt AND v_recon_end_dt)
    LOOP
        v_book_amt := c1.amount;
    END LOOP;
  ELSIF p_book_tran_cd = 'JVII' THEN
    FOR c1 IN (SELECT SUM(NVL(debit_amt,0)+NVL(credit_amt,0)) amount 
                 FROM GIAC_BANK_ACCOUNTS c,
                      GIAC_ACCT_ENTRIES b, 
                      GIAC_ACCTRANS A 
                WHERE 1=1   
                  AND b.gacc_tran_id = A.tran_id
                  AND b.gl_acct_id = c.gl_acct_id
                  AND c.bank_cd = p_bank_cd
                  AND c.bank_acct_cd = p_bank_acct_cd                  
                  AND A.tran_class = 'JV'
                  AND A.jv_tran_type = 'II'  
                  AND A.posting_date BETWEEN v_recon_start_dt AND v_recon_end_dt)
    LOOP
        v_book_amt := c1.amount;
    END LOOP;    
  ELSIF p_book_tran_cd = 'COL' THEN
    FOR c1 IN (SELECT SUM(NVL(debit_amt,0)+NVL(credit_amt,0)) amount 
                 FROM GIAC_BANK_ACCOUNTS c,
                      GIAC_ACCT_ENTRIES b, 
                      GIAC_ACCTRANS A 
                WHERE 1=1
                  AND b.gacc_tran_id = A.tran_id
                  AND b.gl_acct_id = c.gl_acct_id   
                  AND c.bank_cd = p_bank_cd
                  AND c.bank_acct_cd = p_bank_acct_cd
                  AND A.tran_class = 'COL'   
                  AND A.jv_tran_mm = TO_CHAR(TO_DATE(p_tran_mm,'MON'),'MM')
                  AND A.jv_tran_yy = p_tran_year)
    LOOP
        v_book_amt := c1.amount;
    END LOOP;    
  ELSIF p_book_tran_cd = 'DV' THEN
    FOR c1 IN (SELECT SUM(amount) amount
                             FROM GIAC_CHK_DISBURSEMENT A
                            WHERE A.bank_cd = p_bank_cd
                               AND A.bank_acct_cd = p_bank_acct_cd                  
                              AND A.Check_Date BETWEEN v_recon_start_dt AND v_recon_end_dt
                              AND check_stat <> 3)
    LOOP
        v_book_amt := c1.amount;
    END LOOP;
  END IF;
  RETURN(v_book_amt);
END;

FUNCTION get_bank_amt(p_bank_cd IN VARCHAR2,
                      p_bank_acct_cd IN VARCHAR2,
                      p_tran_mm IN VARCHAR2,
                      p_tran_year IN NUMBER,
                      p_bank_tran_cd IN VARCHAR2) RETURN NUMBER IS
  v_bank_amt  GIAC_BANK_TRAN_DTL.tran_amount%TYPE;                      
BEGIN
  FOR c1 IN (SELECT tran_amount 
               FROM GIAC_BANK_TRAN_DTL A
              WHERE A.bank_cd = p_bank_cd
                AND A.bank_acct_cd = p_bank_acct_cd
                AND A.tran_mm = p_tran_mm
                AND A.tran_year = p_tran_year
                AND A.bank_tran_cd = p_bank_tran_cd)
  LOOP
    v_bank_amt := c1.tran_amount;
    EXIT;
  END LOOP;
  RETURN(v_bank_amt);
END;  

FUNCTION get_bank_amt2(p_bank_cd IN VARCHAR2, -- add new function apura02292012
                       p_bank_acct_cd IN VARCHAR2,
                       p_tran_mm IN VARCHAR2,
                       p_tran_year IN NUMBER,
                       p_bank_tran_cd IN VARCHAR2) RETURN NUMBER IS
  v_bank_amt  GIAC_BANK_TRAN_DTL.tran_amount%TYPE;                      
BEGIN
  FOR c1 IN (SELECT sum(tran_amount) tran_amount --add sum function apura02292012
               FROM GIAC_BANK_TRAN_DTL A
              WHERE A.bank_cd = p_bank_cd
                AND A.bank_acct_cd = p_bank_acct_cd
                AND A.tran_mm = p_tran_mm
                AND A.tran_year = p_tran_year
                AND A.bank_tran_cd = p_bank_tran_cd)
  LOOP
    v_bank_amt := c1.tran_amount;
    EXIT;
  END LOOP;
  RETURN(v_bank_amt);
END;  

FUNCTION check_equi_amt(p_bank_cd IN VARCHAR2, -- add new function apura02292012
                        p_bank_acct_cd IN VARCHAR2,
                        p_bank_tran_cd IN VARCHAR2,
                        p_tran_mm IN VARCHAR2,
                        p_tran_year IN NUMBER,
                        p_tran_amount IN NUMBER,
                        p_message IN VARCHAR2) RETURN VARCHAR2 IS
  v_message GIAC_BANK_BOOK_TRAN.remarks%TYPE;
  v_recon_start_dt DATE;
  v_recon_end_dt DATE;
  v_book_tran_cd  giac_bank_book_tran.book_tran_cd%TYPE;
  v_amount  giac_bank_tran_dtl.tran_amount%TYPE;
BEGIN
    BEGIN
    SELECT TO_DATE(p_tran_mm||'/'||p_tran_year,'MM/RRRR'),last_day(TO_DATE(p_tran_mm||'/'||p_tran_year,'MM/RRRR'))
      INTO v_recon_start_dt, v_recon_end_dt
      FROM dual;
  END;
    FOR c1 IN (SELECT book_tran_cd
                 FROM giac_bank_book_tran a
                WHERE a.bank_cd = p_bank_cd
                  AND a.bank_tran_cd = p_bank_tran_cd)
    LOOP
        v_book_tran_cd := c1.book_tran_cd;
    END LOOP;    
    IF v_book_tran_cd = 'CDCCA' THEN
            FOR c1 IN (SELECT SUM(a.amount) amount
                                     FROM giac_dcb_bank_dep b,
                                            giac_bank_dep_slips a
                                    WHERE 1=1
                                      AND b.gacc_tran_id = a.gacc_tran_id
                                      AND b.fund_cd = a.fund_cd
                                      AND b.branch_cd = a.branch_cd
                                      AND b.dcb_year = a.dcb_year
                                      AND b.dcb_no = a.dcb_no
                                      AND b.item_no = a.item_no
                                      AND b.pay_mode = 'CA'
                                      AND a.validation_dt BETWEEN v_recon_start_dt and v_recon_end_dt)
            LOOP
                v_amount := NVL(c1.amount,0);
            END LOOP;         
            IF v_amount <> p_tran_amount THEN
                     v_message := 'The amount of cash deposits do not tally with the actual amount of cash '||
                               'deposits per validation date in close DCB.';
            END IF;    
    ELSIF v_book_tran_cd = 'CDCCK' THEN
            FOR c1 IN (SELECT SUM(a.amount) amount
                                     FROM giac_dcb_bank_dep b,
                                            giac_bank_dep_slips a
                                    WHERE 1=1
                                      AND b.gacc_tran_id = a.gacc_tran_id
                                      AND b.fund_cd = a.fund_cd
                                      AND b.branch_cd = a.branch_cd
                                      AND b.dcb_year = a.dcb_year
                                      AND b.dcb_no = a.dcb_no
                                      AND b.item_no = a.item_no
                                      AND b.pay_mode = 'CHK' -- apura03082012 from CK to CHK
                                      AND a.validation_dt BETWEEN v_recon_start_dt and v_recon_end_dt)
            LOOP
                v_amount := NVL(c1.amount,0);
            END LOOP;         
            IF v_amount <> p_tran_amount THEN
                     v_message := 'The amount of check deposits do not tally with the actual amount of check '||
                               'deposits per validation date in close DCB.';
            END IF;        
    ELSIF v_book_tran_cd = 'CDCCM' THEN
            FOR c1 IN (SELECT SUM(a.amount) amount
                                     FROM giac_dcb_bank_dep b,
                                            giac_bank_dep_slips a
                                    WHERE 1=1
                                      AND b.gacc_tran_id = a.gacc_tran_id
                                      AND b.fund_cd = a.fund_cd
                                      AND b.branch_cd = a.branch_cd
                                      AND b.dcb_year = a.dcb_year
                                      AND b.dcb_no = a.dcb_no
                                      AND b.item_no = a.item_no
                                      AND b.pay_mode = 'CM'
                                      AND a.validation_dt BETWEEN v_recon_start_dt and v_recon_end_dt)
            LOOP
                v_amount := NVL(c1.amount,0);
            END LOOP;         
            IF v_amount <> p_tran_amount THEN
                     v_message := 'The amount of credit memo do not tally with the actual amount of credit '||
                               'memo per validation date in close DCB.';
            END IF;        
    ELSIF v_book_tran_cd = 'DV' THEN        
            FOR c1 IN (SELECT SUM(b.amount) amount
                                     FROM giac_chk_disbursement b,
                                          giac_chk_release_info a
                                    WHERE b.gacc_tran_id = a.gacc_tran_id
                                      AND b.item_no = a.item_no
                                      AND a.clearing_date BETWEEN v_recon_start_dt and v_recon_end_dt)
            LOOP
                v_amount := NVL(c1.amount,0);
            END LOOP;         
            IF v_amount <> p_tran_amount THEN
                     v_message := 'The amount of actual disbursement do not tally with the actual amount of '||
                               'checks cleared by bank.';
            END IF;    
    END IF; 
    RETURN(v_message);   
END;   
END;
/


