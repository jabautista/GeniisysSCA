CREATE OR REPLACE PACKAGE CPI.Bank_Recon IS
/*
--  Created By: A.R.C.
--  Created On: 12/05/2004
--  Remarks   : This package was created to contain all procedures, functions used
--              in BANK RECONCILING.
*/
/*
** Modified By: APURA
** Modified On: 02/29/2012
** Remarks    : Added another functions GET_BANK_AMT2 and CHECK_EQUI_AMT for GIBRS001 v.9/9/2008 2:57pm.
**
*/
  FUNCTION get_book_amt(p_tran_mm IN VARCHAR2,
                        p_tran_year IN NUMBER,
                        p_book_tran_cd IN VARCHAR2,
                        p_bank_cd IN VARCHAR2,
                        p_bank_acct_cd IN VARCHAR2) RETURN NUMBER;
						
  FUNCTION get_bank_amt(p_bank_cd IN VARCHAR2,
                        p_bank_acct_cd IN VARCHAR2,
                        p_tran_mm IN VARCHAR2,
                        p_tran_year IN NUMBER,
                        p_bank_tran_cd IN VARCHAR2) RETURN NUMBER;
						
  FUNCTION get_bank_amt2(p_bank_cd IN VARCHAR2,
                         p_bank_acct_cd IN VARCHAR2,
                         p_tran_mm IN VARCHAR2,
                         p_tran_year IN NUMBER,
                         p_bank_tran_cd IN VARCHAR2) RETURN NUMBER;
						 
  FUNCTION check_equi_amt(p_bank_cd IN VARCHAR2,
                          p_bank_acct_cd IN VARCHAR2,
                          p_bank_tran_cd IN VARCHAR2,
                          p_tran_mm IN VARCHAR2,
                          p_tran_year IN NUMBER,
                          p_tran_amount IN NUMBER,
                          p_message IN VARCHAR2) RETURN VARCHAR2;
END;
/


