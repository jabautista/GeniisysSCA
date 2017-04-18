DROP PROCEDURE CPI.CALC_PAYMENT_SCHED_GIPIS017B;

CREATE OR REPLACE PROCEDURE CPI.CALC_PAYMENT_SCHED_GIPIS017B(
	   	  		  p_par_id			IN	 GIPI_PARLIST.par_id%TYPE,	
				  p_payt_term		IN GIIS_PAYTERM.payt_terms%TYPE,	
				  p_prem_amt		IN GIPI_WINVOICE.prem_amt%TYPE,  
				  p_tax_amt		    IN GIPI_WINVOICE.tax_amt%TYPE, 
				  p_line_cd			IN   GIPI_PARLIST.line_cd%TYPE,
				  p_assd_no			IN   GIPI_PARLIST.assd_no%TYPE
				  
	   )
 IS
  v_no_of_payt       giis_payterm.no_of_payt%TYPE := 1;
  v_payt_term        giis_payterm.payt_terms%TYPE;
  v_inst_no          gipi_winstallment.inst_no%TYPE := 0;
  v_due_date         gipi_winstallment.due_date%TYPE;
  v_share_pct        gipi_winstallment.share_pct%TYPE := 0;
  v_prem_amt         gipi_winstallment.prem_amt%TYPE := 0;
  v_tax_amt          gipi_winstallment.tax_amt%TYPE := 0;
  v_on_incept_tag    giis_payterm.on_incept_tag%TYPE;
  v_no_of_days       giis_payterm.no_of_days%TYPE;
      
BEGIN
  FOR DATE IN (SELECT eff_date
                 FROM gipi_wpolbas
                WHERE par_id  = P_PAR_ID)
  LOOP
    FOR A IN (SELECT nvl(on_incept_tag,'Y') on_incept_tag, no_of_days,
                     c.payt_terms payt_terms, c.no_of_payt no_of_payt
                FROM 
                     giis_payterm C
               WHERE payt_terms = p_payt_term) 
    LOOP
      v_on_incept_tag := a.on_incept_tag;
      v_no_of_days := nvl(a.no_of_days,0);
      v_payt_term := a.payt_terms;
      v_no_of_payt := a.no_of_payt;
   	  EXIT;
    END LOOP;           	
    
    IF v_payt_term IS NULL THEN 
      v_payt_term  := 'COD';
      v_no_of_payt := 1; 
    END IF;   
    
    IF nvl(v_on_incept_tag,'Y') = 'Y' THEN
      v_due_date  := DATE.eff_date;
    ELSE  
      v_due_date  := DATE.eff_date + nvl(v_no_of_days,0);
    END IF;   
    EXIT;
  END LOOP;
  v_share_pct := 100/v_no_of_payt;
  v_prem_amt  := p_prem_amt/v_no_of_payt;
  v_tax_amt   := p_tax_amt;
   
  DELETE gipi_winstallment
   WHERE par_id   = p_par_id; 
  
  FOR i IN 1..v_no_of_payt LOOP
    v_inst_no := nvl(v_inst_no,0) + 1;
    IF v_inst_no > 1 THEN
      v_tax_amt := 0;
      v_due_date := v_due_date + ROUND(366/v_no_of_payt);
    END IF;
    
    FOR x IN (SELECT count(takeup_seq_no) takeup_cnt
                FROM gipi_winvoice
               WHERE par_id = p_par_id)
    LOOP
    	FOR y IN (SELECT takeup_seq_no, tax_amt
                FROM gipi_winvoice
               WHERE par_id = p_par_id)
      LOOP
	    	IF y.takeup_seq_no = 1 THEN
		      INSERT INTO gipi_winstallment
		       (par_id,item_grp,inst_no,due_date,share_pct,
	          prem_amt,
	          tax_amt, takeup_seq_no)
	        VALUES
	         (p_par_id,1,v_inst_no,v_due_date, v_share_pct,
	          ROUND((v_prem_amt / x.takeup_cnt),2),
	          y.tax_amt,y.takeup_Seq_no);
	    	ELSIF y.takeup_seq_no <> x.takeup_cnt THEN
	    		INSERT INTO gipi_winstallment
		       (par_id,item_grp,inst_no,due_date,share_pct,
	          prem_amt,
	          tax_amt, takeup_seq_no)
	        VALUES
	         (p_par_id,1,v_inst_no,v_due_date, v_share_pct,
	          ROUND((v_prem_amt / x.takeup_cnt),2),
	          y.tax_amt,y.takeup_Seq_no);
	    	ELSE
	    		INSERT INTO gipi_winstallment
		       (par_id,item_grp,inst_no,due_date,share_pct,
	          prem_amt,
	          tax_amt, takeup_seq_no)
	        VALUES
	         (p_par_id,1,v_inst_no,v_due_date, v_share_pct,
	          v_prem_amt - (ROUND((v_prem_amt / x.takeup_cnt),2) * (x.takeup_cnt - 1)),
	          y.tax_amt,y.takeup_Seq_no);
	      END IF;
    	END LOOP; 
  	END LOOP;    
  END LOOP;

END;
/


