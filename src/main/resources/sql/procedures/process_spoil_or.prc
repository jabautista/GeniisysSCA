DROP PROCEDURE CPI.PROCESS_SPOIL_OR;

CREATE OR REPLACE PROCEDURE CPI.process_spoil_or (
   p_gacc_tran_id        IN       giac_order_of_payts.gacc_tran_id%TYPE,
   p_but_label           IN       VARCHAR2,
   p_or_flag             IN OUT   giac_order_of_payts.or_flag%TYPE,
   p_or_tag              IN       giac_order_of_payts.or_tag%TYPE,
   p_or_pref_suf         IN OUT   giac_order_of_payts.or_pref_suf%TYPE,
   p_or_no               IN OUT   giac_order_of_payts.or_no%TYPE,
   p_gibr_gfun_fund_cd            giac_order_of_payts.gibr_gfun_fund_cd%TYPE,
   p_gibr_branch_cd               giac_order_of_payts.gibr_branch_cd%TYPE,
   p_or_date                      varchar2,
   p_dcb_no                       giac_order_of_payts.dcb_no%TYPE,
   p_calling_form		 		  varchar2,
   p_module_name		 		  varchar2,
   p_or_cancellation			  varchar2,
   p_payor            giac_order_of_payts.payor%TYPE,
   p_collection_amt   giac_order_of_payts.collection_amt%TYPE,
   p_cashier_cd       giac_order_of_payts.cashier_cd%TYPE,
   p_gross_amt        giac_order_of_payts.gross_amt%TYPE,
   p_gross_tag        giac_order_of_payts.gross_tag%TYPE,
   p_item_no 		  giac_module_entries.item_no%TYPE,
   p_message             OUT      VARCHAR2
)
IS
   v_opctr          NUMBER          := 0;
   v_y_totctr       NUMBER;
   v_x_totctr       NUMBER;
   v_y_spoilctr     NUMBER;
   v_x_spoilctr     NUMBER;
   v_tran_id_msg1   VARCHAR2 (2000);
   v_tran_id_msg2   VARCHAR2 (2000);
   v_cancel_flag	VARCHAR2(1);
   v_cancel			VARCHAR2(1);
   v_closed_tag		VARCHAR2(1);
BEGIN
   SELECT COUNT (*)
     INTO v_opctr
     FROM giac_order_of_payts
    WHERE gacc_tran_id = p_gacc_tran_id
      AND gacc_tran_id IN (SELECT gacc_tran_id
                             FROM giac_direct_prem_collns);

   IF v_opctr > 0
   THEN
      check_commission (p_gacc_tran_id, v_cancel_flag);

      IF v_cancel_flag != 'Y'
      THEN
         FOR y IN (SELECT DISTINCT b140_iss_cd, b140_prem_seq_no
                              FROM giac_direct_prem_collns
                             WHERE gacc_tran_id = p_gacc_tran_id)
         LOOP
            v_y_totctr := NVL (v_y_totctr, 0) + 1;

            FOR x IN (SELECT DISTINCT gacc_tran_id
                                 FROM giac_direct_prem_collns
                                WHERE gacc_tran_id != p_gacc_tran_id
                                  AND b140_iss_cd = y.b140_iss_cd
                                  AND b140_prem_seq_no = y.b140_prem_seq_no)
            LOOP
               v_x_totctr := NVL (v_x_totctr, 0) + 1;
               check_commission (x.gacc_tran_id, v_cancel_flag);

               IF v_cancel_flag = 'Y'
               THEN
                  v_tran_id_msg1 :=
                     v_tran_id_msg1 || get_ref_no (x.gacc_tran_id)
                     || CHR (13);
                  v_x_spoilctr := NVL (v_x_spoilctr, 0) + 1;
               ELSE
                  v_tran_id_msg2 :=
                     v_tran_id_msg2 || get_ref_no (x.gacc_tran_id)
                     || CHR (13);
               END IF;
            END LOOP;

            IF v_x_totctr = NVL (v_x_spoilctr, 0)
            THEN
               v_y_spoilctr := NVL (v_y_spoilctr, 0) + 1;
            END IF;
         END LOOP;

         IF v_y_totctr > NVL (v_y_spoilctr, 0)
         THEN
            p_message :=
               (   'The commission of this bill was already settled. Please cancel the commission payment first before cancelling the O.R.'
                || CHR (13)
                || CHR (13)
                || 'Reference No.: '
                || CHR (13)
                || v_tran_id_msg1
                || v_tran_id_msg2
               );
            p_message :=
               (   'The commission of this bill was already settled. Please cancel the commission payment first before cancelling the O.R.'
                || CHR (13)
                || CHR (13)
                || 'Reference No.: '
                || CHR (13)
                || v_tran_id_msg1
                || v_tran_id_msg2
               );
            RETURN;
         END IF;
      END IF;
   END IF;

   IF p_but_label = 'Spoil OR'
   THEN
      IF p_or_flag = 'P'
      THEN
         IF p_or_tag IS NULL
         THEN
            spoil_or (p_gacc_tran_id,
                      p_or_pref_suf,
                      p_or_no,
                      p_gibr_gfun_fund_cd,
                      p_gibr_branch_cd,
                      p_or_date,
                      p_dcb_no,
                      p_or_flag,
                      p_message
                     );
			UPDATE giac_order_of_payts
			SET or_pref_suf = p_or_pref_suf,
				or_no		= p_or_no,
				or_flag		= p_or_flag
			WHERE gacc_tran_id =p_gacc_tran_id;	
         ELSE
            p_message := 'Spoiling of a manual O.R. is not allowed.';
         END IF;
      ELSIF p_or_flag = 'N'
      THEN
         p_message := 'This O.R. has not yet been printed.';
      ELSIF p_or_flag = 'C'
      THEN
         p_message := 'This O.R. has already been cancelled.';
      ELSIF p_or_flag = 'R'
      THEN
         p_message := 'This O.R. has already been cancelled and replaced.';
      ELSIF p_or_flag = 'D'
      THEN
         p_message := 'This O.R. has already been deleted.';
      ELSE
         p_message := 'Spoiling not allowed.';
      END IF;
	  
   ELSE
   
   FOR x IN (SELECT param_value_v cancel_param
                FROM giac_parameters 
               WHERE param_name = 'ALLOW_CANCEL_TRAN_FOR_CLOSED_MONTH')
      LOOP
      	v_cancel := x.cancel_param;
      EXIT;	
      END LOOP;	            
    FOR y IN (SELECT closed_tag 
                FROM giac_tran_mm 
               WHERE fund_cd = p_gibr_gfun_fund_cd
                 AND branch_cd = p_gibr_branch_cd 
                 AND tran_yr = TO_NUMBER(TO_CHAR( to_date(p_or_date,'MM-DD-YYYY'), 'YYYY')) 
                 AND tran_mm = TO_NUMBER(TO_CHAR( to_date(p_or_date,'MM-DD-YYYY'), 'MM')) )
    LOOP
    	v_closed_tag := y.closed_tag;
    EXIT;
    END LOOP;

    IF v_cancel = 'N' AND v_closed_tag = 'Y' THEN
    		p_message :=  'You are no longer allowed to cancel this transaction. The transaction month is already closed.';
	  ELSIF v_cancel = 'N' AND v_closed_tag = 'T' THEN
	  	  p_message :=  'You are no longer allowed to cancel this transaction. The transaction month is temporarily closed.';
	      
    ELSE -- Continue Cancellation 
	    IF p_or_flag = 'N' or  p_or_flag = 'P' THEN
		    IF p_or_flag = 'N' THEN			
			
			 cancel_or(p_dcb_no, p_gacc_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_or_pref_suf, p_or_no, p_or_date, p_message, p_calling_form, 
			 		    p_module_name, p_or_cancellation, p_payor, p_collection_amt, p_cashier_cd, p_or_tag, p_gross_amt, p_gross_tag, p_item_no, p_or_flag);
			ELSIF p_or_flag = 'P' THEN		
			 cancel_or(p_dcb_no, p_gacc_tran_id, p_gibr_gfun_fund_cd, p_gibr_branch_cd, p_or_pref_suf, p_or_no, p_or_date, p_message, p_calling_form, 
			 		    p_module_name, p_or_cancellation, p_payor, p_collection_amt, p_cashier_cd, p_or_tag, p_gross_amt, p_gross_tag, p_item_no, p_or_flag);			
		    ELSIF p_or_flag = 'C' THEN
		      p_message := 'This O.R. has already been cancelled.';
		    ELSIF p_or_flag = 'R' THEN
		      p_message := 'This O.R. has already been cancelled and replaced.';
		    ELSIF p_or_flag = 'D' THEN
		      p_message := 'This O.R. has already been deleted.';
		    ELSE
		      p_message := 'Cancellation not allowed.';
		    END IF;
	
	  --ELSE
	   -- p_message := 'Spoil_Cancel_OR_But: Invalid label.';
	  END IF;
   END IF;	
  END IF;	    
END;
/


