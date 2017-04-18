DROP TRIGGER CPI.GIEX_DEP_PERL;

CREATE OR REPLACE TRIGGER CPI.GIEX_DEP_PERL
BEFORE INSERT OR UPDATE
ON CPI.GIEX_DEP_PERL FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    :NEW.user_ID := NVL (giis_users_pkg.app_user, USER);
    :NEW.LAST_UPDATE := SYSDATE;
  END;
END;
/

