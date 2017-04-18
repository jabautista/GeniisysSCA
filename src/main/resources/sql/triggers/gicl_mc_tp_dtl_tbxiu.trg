DROP TRIGGER CPI.GICL_MC_TP_DTL_TBXIU;

CREATE OR REPLACE TRIGGER CPI.GICL_MC_TP_DTL_TBXIU
BEFORE
INSERT OR UPDATE
ON CPI.GICL_MC_TP_DTL FOR
EACH ROW
DECLARE
BEGIN
BEGIN
:NEW.user_ID := NVL (giis_users_pkg.app_user, USER);
:NEW.LAST_UPDATE := SYSDATE;
END;
END;
/

