DROP PROCEDURE CPI.CALC_PAYMENT_SCHED;

CREATE OR REPLACE PROCEDURE CPI.CALC_PAYMENT_SCHED(
				  p_par_id			IN	 GIPI_PARLIST.par_id%TYPE,	   
				  p_line_cd			IN   GIPI_PARLIST.line_cd%TYPE,
				  p_assd_no			IN   GIPI_PARLIST.assd_no%TYPE,
				  p_payt_term		OUT  GIIS_PAYTERM.payt_terms%TYPE		   
	   	  		  )
	    IS
   v_no_of_payt       GIIS_PAYTERM.no_of_payt%TYPE := 1;
   v_inst_no          GIPI_WINSTALLMENT.inst_no%TYPE := 0;
   v_due_date         GIPI_WINSTALLMENT.due_date%TYPE;
   v_share_pct        GIPI_WINSTALLMENT.share_pct%TYPE := 0;
   v_prem_amt         GIPI_WINSTALLMENT.prem_amt%TYPE := 0;
   v_tax_amt          GIPI_WINSTALLMENT.tax_amt%TYPE := 0;
   v_on_incept_tag    GIIS_PAYTERM.on_incept_tag%TYPE;
   v_no_of_days       GIIS_PAYTERM.no_of_days%TYPE;
   v_payt_term	  	  GIIS_PAYTERM.payt_terms%TYPE;   
   v_takeup_seq_no	  GIPI_WINVOICE.takeup_seq_no%TYPE; --added jerome orio to avoid ora-01400
BEGIN
  /*
  **  Created by   : Jerome Orio
  **  Date Created : March 19, 2010
  **  Reference By : (GIPIS017 - Bond Basic Information)
  **  Description  : CALC_PAYMENT_SCHED program unit
  */
  
/* This program computes for payment schedule of premiums, */
/* taxes and the appropriate installment due dates.        */
/* The premium is divided equally by the no of payment     */
/* while the tax is applied to first payment only.         */
   FOR DATE IN (SELECT eff_date
                  FROM GIPI_WPOLBAS
                 WHERE par_id  = p_par_id)
   LOOP
     -- GRACE 04/23/01
     -- assign a default value to the due date based on the effectivity date 
     -- and the on_incept_tag
     FOR A IN (SELECT NVL(on_incept_tag,'Y') on_incept_tag, no_of_days,
                      c.payt_terms payt_terms, c.no_of_payt no_of_payt
                 FROM GIIS_INTERMEDIARY A, GIIS_ASSURED_INTM B, GIIS_PAYTERM C
                WHERE a.intm_no    = b.intm_no 
                  AND b.line_cd    = p_line_cd
                  AND b.assd_no    = p_assd_no
                  AND a.payt_terms = c.payt_terms) LOOP
         v_on_incept_tag := a.on_incept_tag;
         v_no_of_days := NVL(a.no_of_days,0);
         v_payt_term := a.payt_terms;
         v_no_of_payt := a.no_of_payt;
   	     EXIT;
     END LOOP;           	
     IF v_payt_term IS NULL THEN 
        v_payt_term := 'COD';
        v_no_of_payt        := 1; 
     END IF;   
     IF NVL(v_on_incept_tag,'Y') = 'Y' THEN
     	  v_due_date  := DATE.eff_date;
     ELSE  
     	  v_due_date  := DATE.eff_date + NVL(v_no_of_days,0);
     END IF;   
     EXIT;
   END LOOP;
   v_share_pct := 100/v_no_of_payt;
   v_prem_amt := 0;
   v_tax_amt := 0;
   FOR AMT IN (SELECT prem_amt, tax_amt, takeup_seq_no
                 FROM GIPI_WINVOICE
                WHERE par_id = p_par_id) LOOP 
       v_prem_amt := amt.prem_amt/v_no_of_payt;
       v_tax_amt := amt.tax_amt;
	   v_takeup_seq_no := amt.takeup_seq_no;
       EXIT;
   END LOOP;    
   
   DELETE GIPI_WINSTALLMENT
    WHERE par_id   = p_par_id; 
   
   FOR i IN 1..v_no_of_payt LOOP
     v_inst_no := NVL(v_inst_no,0) + 1;
     IF v_inst_no > 1 THEN
        v_tax_amt := 0;
        v_due_date := v_due_date + ROUND(366/v_no_of_payt);
     END IF;
     INSERT INTO GIPI_WINSTALLMENT(par_id,item_grp,inst_no,due_date,share_pct,
                                prem_amt,tax_amt,takeup_seq_no)
          VALUES(p_par_id,1,v_inst_no,v_due_date,
                        v_share_pct,v_prem_amt,v_tax_amt,v_takeup_seq_no);
   END LOOP;
   p_payt_term := v_payt_term;
END;
/


