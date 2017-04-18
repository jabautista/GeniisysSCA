DROP PROCEDURE CPI.POST_FORMS_COMMIT_GIPIS017;

CREATE OR REPLACE PROCEDURE CPI.Post_forms_commit_gipis017(
	   	  		  p_par_id			GIPI_PARLIST.par_id%TYPE		 
	   	  		  )
		IS 
  v_prem_rt   GIPI_WINVOICE.bond_rate%TYPE;
  v_tsi_amt   GIPI_WINVOICE.bond_tsi_amt%TYPE;
  v_input_vat_rt GIIS_REINSURER.INPUT_VAT_RATE%TYPE;
BEGIN
  --aaron 022609 to retrieve input vat rate to be used for the computation of ri_comm_vat
  FOR X IN (SELECT input_vat_rate
			  FROM GIRI_WINPOLBAS a, GIIS_REINSURER b
		     WHERE a.ri_cd = b.ri_cd
			   AND par_id = p_par_id)
  LOOP
	v_input_vat_rt := X.input_vat_rate;
  END LOOP;

  SELECT prem_rt, tsi_amt
  	INTO v_prem_rt, v_tsi_amt
  	FROM GIPI_WITMPERL
   WHERE par_id = p_par_id;
 	
  UPDATE GIPI_WINVOICE
 	 SET bond_rate = v_prem_rt,
 	     bond_tsi_amt = v_tsi_amt,
 	     ri_comm_vat = (ri_comm_amt*NVL(v_input_vat_rt,0))/100 -- aaron 022609
   WHERE par_id = p_par_id;

  EXCEPTION
	WHEN NO_DATA_FOUND THEN
	  NULL;		  		  
END;
/


