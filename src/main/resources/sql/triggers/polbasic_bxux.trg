DROP TRIGGER CPI.POLBASIC_BXUX;

CREATE OR REPLACE TRIGGER CPI.POLBASIC_BXUX
   BEFORE UPDATE
   ON CPI.GIPI_POLBASIC    FOR EACH ROW
DECLARE
   v_hist_no           GIPI_BOOKING_HIST.HIST_NO%TYPE;
   v_old_iss_cd        gipi_polbasic.iss_cd%TYPE          := :OLD.iss_cd;
   v_iss_cd            gipi_polbasic.iss_cd%TYPE          := :NEW.iss_cd;
   v_old_cred_branch   gipi_polbasic.cred_branch%TYPE     := :OLD.cred_branch;
   v_cred_branch       gipi_polbasic.cred_branch%TYPE     := :NEW.cred_branch;
   v_prem_seq          gipi_invoice.prem_seq_no%TYPE;
   v_policy_id         gipi_polbasic.policy_id%TYPE       := :NEW.policy_id;
   v_takeup_seq        gipi_invoice.takeup_seq_no%TYPE;
   v_old_rswitch       gipi_polbasic.reg_policy_sw%TYPE   := :OLD.reg_policy_sw;
   v_rswitch           gipi_polbasic.reg_policy_sw%TYPE   := :NEW.reg_policy_sw;
BEGIN

   IF ( (:old.reg_policy_sw <> :new.reg_policy_sw )
    or (:old.cred_branch <> :new.cred_branch) 
    or (nvl(:old.endt_type, 'A') = 'N' AND (:old.booking_mth <> :new.booking_mth or :old.booking_year <> :new.booking_year )))
        THEN
        
    
    
    FOR i IN (SELECT iss_cd, takeup_seq_no, prem_seq_no, multi_booking_mm, multi_booking_yy
              FROM gipi_invoice
              WHERE policy_id = :OLD.policy_id)
    LOOP
        v_hist_no := NULL;
 
        SELECT MAX(hist_no)+1
        INTO v_hist_no
        FROM gipi_booking_hist
        WHERE policy_id = :OLD.policy_id
        AND takeup_seq_no = i.takeup_seq_no
        AND iss_cd = i.iss_cd
        AND prem_seq_no = i.prem_seq_no;
    
        IF v_hist_no IS NULL THEN
            v_hist_no := NVL(v_hist_no,1);
        END IF;
         
       INSERT INTO gipi_booking_hist
               (policy_id, takeup_seq_no, hist_no, iss_cd, prem_seq_no,
                old_reg_pol_sw, new_reg_pol_sw, old_cred_branch,
                new_cred_branch, old_booking_mm, new_booking_mm,
                old_booking_yy, new_booking_yy, user_id, last_update
               )
       VALUES 
               (v_policy_id, i.takeup_seq_no, v_hist_no, i.iss_cd, i.prem_seq_no,
                v_old_rswitch, v_rswitch , v_old_cred_branch,
                v_cred_branch, i.multi_booking_mm, i.multi_booking_mm,
                i.multi_booking_yy, i.multi_booking_yy, NVL (giis_users_pkg.app_user, USER), SYSDATE 
               );  
    END LOOP;
      
     IF NVL(:old.endt_type, 'A') = 'N' THEN
        v_hist_no := null;
       
       select max(hist_no) + 1 into v_hist_no 
        from gipi_booking_hist 
        where policy_id = :old.policy_id; 
        
        if v_hist_no is null 
            then v_hist_no := NVL(v_hist_no,1); 
        end if; 
        
       INSERT INTO gipi_booking_hist
               (policy_id, takeup_seq_no, hist_no, iss_cd, prem_seq_no,
                old_reg_pol_sw, new_reg_pol_sw, old_cred_branch,
                new_cred_branch, old_booking_mm, new_booking_mm,
                old_booking_yy, new_booking_yy, user_id, last_update
               )
       VALUES 
               (v_policy_id, 0, v_hist_no, :NEW.iss_cd, 0,
                v_old_rswitch, v_rswitch , v_old_cred_branch,
                v_cred_branch, :OLD.booking_mth, :NEW.booking_mth,
                :OLD.booking_year, :NEW.booking_year, NVL (giis_users_pkg.app_user, USER), SYSDATE 
               ); 
    END IF;
    
   END IF;
              
END;
/


