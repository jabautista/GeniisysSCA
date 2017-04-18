DROP PROCEDURE CPI.CALC_PAYMENT_SCHED_GIPIS026;

CREATE OR REPLACE PROCEDURE CPI.CALC_PAYMENT_SCHED_GIPIS026(
               --P_PAYT_TERMS_DESC GIIS_PAYTERM.PAYT_TERMS_DESC%TYPE
			   P_PAYT_TERMS GIPI_WINVOICE.PAYT_TERMS%TYPE
       ,P_DUE_DATE     GIPI_WINSTALLMENT.DUE_DATE%TYPE   
       ,P_PREM_AMT      GIPI_WINSTALLMENT.PREM_AMT%TYPE
       ,P_TAX_AMT      GIPI_WINSTALLMENT.TAX_AMT%TYPE
       ,P_PAR_ID      GIPI_WINSTALLMENT.PAR_ID%TYPE
       ,P_ITEM_GRP      GIPI_WINSTALLMENT.ITEM_GRP%TYPE,
	   P_TAKEUP_SEQ_NO GIPI_WINSTALLMENT.TAKEUP_SEQ_NO%TYPE )IS
   v_no_of_payt    giis_payterm.no_of_payt%TYPE;
   v_inst_no       gipi_winstallment.inst_no%TYPE := 0;
   v_due_date      gipi_winstallment.due_date%TYPE;
   v_share_pct     gipi_winstallment.share_pct%TYPE := 0;
   v_prem_amt      gipi_winstallment.prem_amt%TYPE := 0;
   v_tax_amt       gipi_winstallment.tax_amt%TYPE := 0;
   
   CURSOR C1 IS SELECT no_of_payt
                FROM giis_payterm
				WHERE payt_terms = P_PAYT_TERMS;
               -- WHERE payt_terms_desc = P_payt_terms_desc;
BEGIN
   OPEN C1;
   FETCH C1 INTO v_no_of_payt;
   v_due_date := P_due_date;
   v_share_pct := 100/v_no_of_payt;
   v_prem_amt := P_prem_amt/v_no_of_payt;
   v_tax_amt := P_tax_amt;

  DELETE gipi_winstallment
    WHERE par_id   = P_par_id  
    AND   item_grp = P_item_grp;

   FOR i IN 1..v_no_of_payt LOOP
     v_inst_no := v_inst_no + 1;
     IF v_inst_no > 1 THEN
        v_tax_amt := 0;
        v_due_date := v_due_date + ROUND(366/v_no_of_payt);
     END IF;
        INSERT INTO gipi_winstallment(par_id,item_grp,inst_no,due_date,share_pct,
                                      prem_amt,tax_amt, takeup_seq_no)
                    VALUES(P_par_id,P_item_grp,v_inst_no,v_due_date,
                           v_share_pct,v_prem_amt,v_tax_amt, p_takeup_seq_no);
   END LOOP;
   CLOSE C1;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
    NULL;
END;
/


