DROP TRIGGER CPI.FLOOD_ZONE_TBXIU;

CREATE OR REPLACE TRIGGER CPI.FLOOD_ZONE_TBXIU
BEFORE INSERT OR UPDATE
ON CPI.GIIS_FLOOD_ZONE FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  begin
     :new.user_id  :=  NVL (giis_users_pkg.app_user, USER);
     :new.last_update := sysdate;
  end;

END;
/


