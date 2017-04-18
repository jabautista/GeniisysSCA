DROP FUNCTION CPI.CHECK_GENERATED_OR;

CREATE OR REPLACE FUNCTION CPI.check_generated_or(p_apdc_id	GIAC_APDC_PAYT.apdc_id%TYPE)
	RETURN VARCHAR
	
	IS
  v_generated_or  		   VARCHAR2(2);
  v_id 	   				   GIAC_ORDER_OF_PAYTS.gacc_tran_id%TYPE;
  v_flag   				   GIAC_ORDER_OF_PAYTS.or_flag%TYPE;
BEGIN
   /*
   ** Created by: angelo
   ** Description: checks if an acknowledgment receipt has a generated OR before cancelling
   */	 

   	FOR c IN (SELECT DISTINCT c.gacc_tran_id gacc_tran_id, c.or_flag --distinct so that cancel_ack will only pop once (instance where the tran_id has multiple items)
								FROM giac_direct_prem_collns a, 
					   			   giac_apdc_payt_dtl b, 
					 				   giac_order_of_payts c 
			   		   WHERE a.gacc_tran_id (+) = b.gacc_tran_id 
			   		     AND b.gacc_tran_id = c.gacc_tran_id
			   		     AND b.gacc_tran_id IN (SELECT gacc_tran_id
						 	 				   	  FROM giac_apdc_payt_dtl
												 WHERE apdc_id = p_apdc_id) -- changed to compare to all gacc_tran_id in selected apdc_id
			   		     AND b.pdc_id > 0) 
			   		   --AND c.or_flag = 'P')
		
    LOOP
		v_id := c.gacc_tran_id;
		v_flag := c.or_flag;
		
		IF v_flag IN ('P', 'N') THEN	
			--IF v_id = :gapd.gacc_tran_id THEN
				/*msg_alert ('Please cancel the existing O.R. first.', 'I', TRUE);*/
				v_generated_or := 'Y';
			/*ELSIF v_id <> :gapd.gacc_tran_id OR v_id IS NULL THEN
				v_alert := show_alert('CANCEL_ACK');
			END IF;*/
		ELSIF v_flag = 'C' THEN
 	    	/*v_alert := show_alert('CANCEL_ACK');*/
			v_generated_or := 'N';
		END IF;
		
	END LOOP;
	RETURN v_generated_or;
   
END;
/


