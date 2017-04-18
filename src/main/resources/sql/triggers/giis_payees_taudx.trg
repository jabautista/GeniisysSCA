DROP TRIGGER CPI.GIIS_PAYEES_TAUDX;

CREATE OR REPLACE TRIGGER CPI.GIIS_PAYEES_TAUDX
   AFTER UPDATE OF bank_cd, bank_branch, bank_acct_type,
                   bank_acct_name, bank_acct_no,
                   bank_acct_app_tag, bank_acct_app_user
   ON CPI.GIIS_PAYEES FOR EACH ROW
BEGIN
  -- insert for changes made to column bank_cd
  IF NVL(:OLD.bank_cd,'_NULL_') <> NVL(:NEW.bank_cd,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_CD',
                 NVL(:OLD.bank_cd,'-NULL-'), nvl(:NEW.bank_cd,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
  
  -- insert for changes made to column bank_branch
  IF NVL(:OLD.bank_branch,'_NULL_') <> NVL(:NEW.bank_branch,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_BRANCH',
                 NVL(:OLD.bank_branch,'-NULL-'), nvl(:NEW.bank_branch,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
  
  -- insert for changes made to column bank_acct_type
  IF NVL(:OLD.bank_acct_type,'_NULL_') <> NVL(:NEW.bank_acct_type,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_ACCT_TYPE',
                 NVL(:OLD.bank_acct_type,'-NULL-'), nvl(:NEW.bank_acct_type,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
  
  -- insert for changes made to column bank_acct_name
  IF NVL(:OLD.bank_acct_name,'_NULL_') <> NVL(:NEW.bank_acct_name,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_ACCT_NAME',
                 NVL(:OLD.bank_acct_name,'-NULL-'), nvl(:NEW.bank_acct_name,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
  
  -- insert for changes made to column bank_acct_no
  IF NVL(:OLD.bank_acct_no,'_NULL_') <> NVL(:NEW.bank_acct_no,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_ACCT_NO',
                 NVL(:OLD.bank_acct_no,'-NULL-'), nvl(:NEW.bank_acct_no,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
  
  -- insert for changes made to column bank_acct_app_tag
  IF NVL(:OLD.bank_acct_app_tag,'_NULL_') <> NVL(:NEW.bank_acct_app_tag,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_ACCT_APP_TAG',
                 NVL(:OLD.bank_acct_app_tag,'-NULL-'), nvl(:NEW.bank_acct_app_tag,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
  
  -- insert for changes made to column bank_acct_app_user
  IF NVL(:OLD.bank_acct_app_user,'_NULL_') <> NVL(:NEW.bank_acct_app_user,'_NULL_') THEN
    INSERT INTO cpi.giis_payee_bank_acct_hist
                (payee_class_cd, payee_no, field,
                 old_value, new_value, user_id, last_update)
         VALUES (:OLD.payee_class_cd, :OLD.payee_no, 'BANK_ACCT_APP_USER',
                 NVL(:OLD.bank_acct_app_user,'-NULL-'), nvl(:NEW.bank_acct_app_user,'-NULL-'), NVL(giis_users_pkg.app_user, USER), SYSDATE);
  END IF;
END;
/


