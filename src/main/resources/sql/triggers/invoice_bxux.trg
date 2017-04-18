DROP TRIGGER CPI.INVOICE_BXUX;

CREATE OR REPLACE TRIGGER CPI.INVOICE_BXUX
   BEFORE UPDATE
   ON CPI.GIPI_INVOICE    FOR EACH ROW
DECLARE
   v_hist_no           GIPI_BOOKING_HIST.HIST_NO%TYPE;
   v_old_iss_cd        gipi_invoice.iss_cd%TYPE             := :OLD.iss_cd;
   v_iss_cd            gipi_invoice.iss_cd%TYPE             := :NEW.iss_cd;
   v_cred_branch       gipi_polbasic.cred_branch%TYPE;
   v_prem_seq          gipi_invoice.prem_seq_no%TYPE         := :NEW.prem_seq_no;
   v_policy_id         gipi_invoice.policy_id%TYPE           := :NEW.policy_id;
   v_takeup_seq        gipi_invoice.takeup_seq_no%TYPE       := :NEW.takeup_seq_no;
   v_old_booking_mth   gipi_invoice.multi_booking_mm%TYPE    := :OLD.multi_booking_mm;
   v_booking_mth       gipi_invoice.multi_booking_mm%TYPE    := :NEW.multi_booking_mm;
   v_old_bkng_yy       gipi_invoice.multi_booking_yy%TYPE    := :OLD.multi_booking_yy;
   v_bkng_yy           gipi_invoice.multi_booking_yy%TYPE    := :NEW.multi_booking_yy;
   v_rswitch           gipi_polbasic.reg_policy_sw%TYPE;
BEGIN
    
    
    IF v_booking_mth != :OLD.multi_booking_mm OR v_bkng_yy != :OLD.multi_booking_yy THEN
    
        BEGIN
    
        SELECT cred_branch, reg_policy_sw
        INTO v_cred_branch, v_rswitch
        FROM gipi_polbasic
        WHERE policy_id = :OLD.policy_id;
    
        SELECT MAX(hist_no)+1
        INTO v_hist_no
        FROM gipi_booking_hist
        WHERE policy_id = :NEW.policy_id
        AND takeup_seq_no = :NEW.takeup_seq_no
        AND iss_cd = :NEW.iss_cd
        AND prem_seq_no = :NEW.prem_seq_no;
    
            IF v_hist_no IS NULL THEN
                v_hist_no := 1;
            END IF;
    
    
   
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_hist_no := 1;
        END;
    
        INSERT INTO gipi_booking_hist
               (policy_id, takeup_seq_no, hist_no, iss_cd, prem_seq_no,
                old_reg_pol_sw, new_reg_pol_sw, old_cred_branch,
                new_cred_branch, old_booking_mm, new_booking_mm,
                old_booking_yy, new_booking_yy, user_id, last_update
               )
        VALUES (v_policy_id, v_takeup_seq, v_hist_no, v_iss_cd, v_prem_seq,
                v_rswitch, v_rswitch, v_cred_branch,
                v_cred_branch, v_old_booking_mth, v_booking_mth,
                v_old_bkng_yy, v_bkng_yy, NVL (giis_users_pkg.app_user, USER) , SYSDATE
               );   
    END IF;
END;
/


