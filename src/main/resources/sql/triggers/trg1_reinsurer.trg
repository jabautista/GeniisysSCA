DROP TRIGGER CPI.TRG1_REINSURER;

CREATE OR REPLACE TRIGGER CPI.TRG1_REINSURER
BEFORE INSERT OR UPDATE
ON CPI.GIIS_REINSURER FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  begin
     :new.user_id  := NVL (giis_users_pkg.app_user, USER);
     :new.last_update := sysdate;
     /*
     if inserting then
        select reinsurer_ri_cd_s.nextval
          into :new.ri_cd
          from dual;
     end if;
     */
  end;
END;
/


