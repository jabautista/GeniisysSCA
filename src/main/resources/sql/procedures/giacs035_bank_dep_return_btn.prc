DROP PROCEDURE CPI.GIACS035_BANK_DEP_RETURN_BTN;

CREATE OR REPLACE PROCEDURE CPI.giacs035_bank_dep_return_btn(p_pay_mode			IN     GIAC_DCB_BANK_DEP.pay_mode%TYPE,
		 					 p_gacc_tran_id			IN	   GIAC_DCB_BANK_DEP.gacc_tran_id%TYPE,
		 					 p_dcb_no				IN	   GIAC_DCB_BANK_DEP.dcb_no%TYPE,
							 p_item_no				IN	   GIAC_DCB_BANK_DEP.item_no%TYPE,
							 p_amount				IN	   GIAC_DCB_BANK_DEP.amount%TYPE,
							 p_var_with_otc			IN OUT VARCHAR2,
							 p_message				   OUT VARCHAR2)
IS
  /*
  **  Created by   :  Emman
  **  Date Created :  05.06.2011
  **  Reference By : (GIACS035 - Close DCB)
  **  Description  : Executes when return btn on Bank Dep is pressed.
  **  			     to make sure that details were entered after creating record on gbds block
  */
  
  /* created by: ging
  ** date created:091305
  ** description: 
  */ 
BEGIN
	p_message := 'SUCCESS';
	
	DECLARE
		v_dep_id  NUMBER;
		v_total   NUMBER;
		v_loc_sur NUMBER;
		v_dep_id2 NUMBER;
		v_loc_error_amt number;
		
	BEGIN
	
	 IF p_pay_mode <> 'CA' THEN	
	 	FOR Y IN(SELECT dep_id           
		           FROM giac_bank_dep_slips  
		          WHERE gacc_tran_id = p_gacc_tran_id
	              AND dcb_no = p_dcb_no
	              AND item_no = p_item_no)
	  LOOP
	  	v_dep_id2 := Y.dep_id;
	  	EXIT;
	  END LOOP;
	  
		IF v_dep_id2 IS NOT NULL THEN 
		   FOR A IN(SELECT dep_id               --added by ging 091605
		              FROM giac_bank_dep_slips  --to check if all deposits have its details
		             WHERE gacc_tran_id = p_gacc_tran_id
		               AND dcb_no = p_dcb_no
		               AND item_no = p_item_no
	               MINUS
	              SELECT dep_id
	                FROM giac_bank_dep_slip_dtl
	               WHERE dep_id IN(SELECT dep_id
		                               FROM giac_bank_dep_slips
		                              WHERE gacc_tran_id = p_gacc_tran_id
	              	                  AND dcb_no = p_dcb_no
	              	                  AND item_no = p_item_no))
	        LOOP
	     	    v_dep_id := A.dep_id;
	        END LOOP;
		        IF v_dep_id IS NOT NULL THEN
		   	       p_message := 'All deposits must have details.';
				   RETURN;
		        ELSE
		        	  FOR X IN (SELECT SUM(amount) total_amount           
		                          FROM giac_bank_dep_slips  
		                         WHERE gacc_tran_id = p_gacc_tran_id
		                           AND dcb_no = p_dcb_no
		                           AND item_no = p_item_no)
		                      LOOP
		                       	v_total := X.total_amount;
		                      	EXIT;
		                      END LOOP;
		              FOR Z IN --(SELECT local_sur, loc_error_amt
	                          (SELECT sum(local_sur)local_sur, sum(loc_error_amt) loc_error_amt
	                            FROM giac_bank_dep_slip_dtl
	                           WHERE dep_id  IN(SELECT dep_id
		                                           FROM giac_bank_dep_slips
		                                          WHERE gacc_tran_id = p_gacc_tran_id
	              	                              AND dcb_no = p_dcb_no
	              	                              AND item_no = p_item_no)      
	              	             AND (otc_tag = 'Y'
	              	             or error_tag = 'Y'))
		                      LOOP
		                      	v_loc_sur := Z.local_sur;
		                      	v_loc_error_amt := z.loc_error_amt;
		                      	EXIT;
		                      END LOOP;  
		                    
		              IF v_loc_sur IS NULL THEN
		              	 v_loc_sur := 0;
		              END IF;
		              IF v_loc_error_amt IS NULL THEN
		              	 v_loc_error_amt := 0;
		              END IF;
		              -- to change the v_loc_sur to 0 when there's no local_surcharge --
		                	                
		  	          IF v_total + v_loc_sur + v_loc_error_amt <> p_amount THEN
		  	 	           p_message := ' Total deposits should be equal to the amount per item_no in Close DCB ';          
		  	          ELSE
		                 p_var_with_otc := 'N';
		              END IF;
		        END IF;  
		ELSE
		    p_var_with_otc := 'N';     	
		END IF;	        	
	 ELSE
		  p_var_with_otc := 'N';
	 END IF;    
	     
	END;
END giacs035_bank_dep_return_btn;
/


