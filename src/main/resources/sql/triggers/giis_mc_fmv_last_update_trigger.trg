/* Created by   : Dren Niebres
 * Date Created : 06.20.2016
 * Remarks      : SR-5278
 */
CREATE OR REPLACE TRIGGER CPI.GIIS_MC_FMV_TRG
BEFORE INSERT OR UPDATE
ON CPI.GIIS_MC_FMV FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    begin
      :new.user_id     :=  NVL (giis_users_pkg.app_user, USER);
      :new.last_update :=  sysdate;
    end;
END;
/
