DROP PROCEDURE CPI.GET_DRCR_AMT;

CREATE OR REPLACE PROCEDURE CPI.GET_DRCR_AMT(
	var_drcr_tag  IN giac_module_entries.dr_cr_tag%type,
	var_amount    IN gipi_invoice.prem_amt%type,
	var_credit_amt IN OUT giac_acct_entries.debit_amt%type,
	var_debit_amt IN OUT giac_acct_entries.debit_amt%type) IS
BEGIN
IF  var_drcr_tag  = 'D' THEN
     IF var_amount > 0 THEN
	var_debit_amt  := abs(var_amount);
	var_credit_amt := 0;
     ELSE
	var_debit_amt  := 0;
	var_credit_amt := abs(var_amount);
     END IF;
  ELSE  ---drcr_tag = 'C'
     IF var_amount > 0 THEN
	var_debit_amt  := 0;
	var_credit_amt := abs(var_amount);
     ELSE
	var_debit_amt  := abs(var_amount);
	var_credit_amt := 0;
     END IF;
END IF;
END;
/


