DROP TRIGGER CPI.GICL_CLM_RES_HIST_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GICL_CLM_RES_HIST_TAIUX
/* automatic re-opening of item-peril and claim after cancellation of claim payment */
AFTER INSERT OR UPDATE ON CPI.GICL_CLM_RES_HIST FOR EACH ROW
DECLARE
  v_tran_type			giac_direct_claim_payts.transaction_type%TYPE;
  v_clm_stat			gicl_claims.clm_stat_cd%TYPE;
  v_old_stat			gicl_claims.old_stat_cd%TYPE;
  v_flag				gicl_item_peril.close_flag%TYPE;	   
BEGIN
  FOR t IN (SELECT transaction_type 
              FROM giac_direct_claim_payts
			 WHERE claim_id = :NEW.claim_id
			   AND advice_id = :NEW.advice_id
			   AND clm_loss_id = :NEW.clm_loss_id
			   AND gacc_tran_id = :NEW.tran_id)
  LOOP
    v_tran_type := t.transaction_type;			   
    FOR s IN (SELECT clm_stat_cd, old_stat_cd, close_flag
                FROM gicl_claims a, gicl_item_peril b
               WHERE a.claim_id = b.claim_id
			     AND a.claim_id = :NEW.claim_id
			     AND b.item_no = :NEW.item_no
				 AND b.peril_cd = :NEW.peril_cd)
    LOOP
      v_clm_stat := s.clm_stat_cd;
      v_old_stat := s.old_stat_cd; 	     
	  v_flag := s.close_flag;    	
      IF INSERTING THEN
         IF v_tran_type = 2 THEN
            IF v_flag = 'CC' THEN
               UPDATE gicl_item_peril
                  SET close_flag = 'AP',
	                  close_date = SYSDATE
                WHERE claim_id = :NEW.claim_id
                  AND item_no = :NEW.item_no
	              AND peril_cd = :NEW.peril_cd;
            END IF;				  
            IF v_clm_stat = 'CD' THEN
               UPDATE gicl_claims
                  SET clm_stat_cd = v_old_stat,
                      old_stat_cd = NULL,
                      close_date = NULL 
                WHERE claim_id = :NEW.claim_id;
            END IF;
         END IF;
      ELSIF UPDATING THEN
         IF (:NEW.cancel_tag = 'Y' AND v_tran_type = 1) THEN
            IF v_flag = 'CC' THEN 
               UPDATE gicl_item_peril
                  SET close_flag = 'AP',
	                  close_date = NULL
                WHERE claim_id = :NEW.claim_id
                  AND item_no = :NEW.item_no
     	          AND peril_cd = :NEW.peril_cd; 
            END IF;				  
            IF v_clm_stat = 'CD' THEN
               UPDATE gicl_claims
                  SET clm_stat_cd = v_old_stat,
		              old_stat_cd = NULL,
     	              close_date = NULL 
                WHERE claim_id = :NEW.claim_id;
			END IF; 
         END IF;
      END IF;
    END LOOP;
  END LOOP;		  	 	 	 
END;
/


