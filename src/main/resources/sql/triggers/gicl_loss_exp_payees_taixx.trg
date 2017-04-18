DROP TRIGGER CPI.GICL_LOSS_EXP_PAYEES_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GICL_LOSS_EXP_PAYEES_TAIXX
-- by jayr 12292003
-- this will insert to gicl_clm_claimant or gicl_exp_payees after insert
--modified by beth 02172004
--   insert to gicl_clm_claimant or gicl_exp_payees only if payee is not yet existing
AFTER INSERT
ON CPI.GICL_LOSS_EXP_PAYEES REFERENCING NEW AS NEW OLD AS OLD
FOR EACH ROW
DECLARE
  v_chk     VARCHAR2(1) := 'N';
BEGIN
  IF :NEW.payee_type = 'L' THEN
     FOR a IN (SELECT 'x'
                 FROM gicl_clm_claimant
                WHERE claim_id = :NEW.claim_id
                  AND payee_class_cd = :NEW.payee_class_cd
                  AND clmnt_no = :NEW.payee_cd)
     LOOP
       v_chk := 'Y';
     END LOOP;
     IF v_chk = 'N' THEN
        INSERT INTO gicl_clm_claimant (claim_id,payee_class_cd,clmnt_no,user_id,last_update,clm_clmnt_no)
        VALUES (:NEW.claim_id,:NEW.payee_class_cd,:NEW.payee_cd,NVL (giis_users_pkg.app_user, USER),SYSDATE,:NEW.clm_clmnt_no);
     END IF;
  ELSE
     FOR a IN (SELECT 'x'
                 FROM gicl_exp_payees
                WHERE claim_id = :NEW.claim_id
                  AND payee_class_cd = :NEW.payee_class_cd
                  AND adj_company_cd = :NEW.payee_cd)
     LOOP
       v_chk := 'Y';
     END LOOP;
     IF v_chk = 'N' THEN
        INSERT INTO gicl_exp_payees (claim_id,payee_class_cd,adj_company_cd,assign_date,user_id,last_update)
        VALUES (:NEW.claim_id,:NEW.payee_class_cd,:NEW.payee_cd,SYSDATE,NVL (giis_users_pkg.app_user, USER),SYSDATE);
     END IF;
  END IF;
END;
/


