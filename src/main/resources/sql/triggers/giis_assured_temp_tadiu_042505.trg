DROP TRIGGER CPI.GIIS_ASSURED_TEMP_TADIU_042505;

CREATE OR REPLACE TRIGGER CPI.GIIS_ASSURED_TEMP_TADIU_042505
AFTER DELETE OR UPDATE OR INSERT
ON CPI.GIIS_ASSURED FOR EACH ROW
DECLARE
  ws_fund_cd    GIAC_SL_LISTS.fund_cd%TYPE;
  ws_sl_type_cd GIAC_SL_LISTS.sl_type_cd%TYPE;
  ws_sl_cd      GIAC_SL_LISTS.sl_cd%TYPE        := NVL(:NEW.assd_no, :OLD.assd_no);
  ws_sl_nm      GIAC_SL_LISTS.sl_name%TYPE      := NVL(:NEW.assd_name, :OLD.assd_name);
  ws_pno GIIS_PAYEES.payee_no%TYPE  := NVL(:NEW.assd_no, :OLD.assd_no);
  ws_pcd GIIS_PAYEES.payee_class_cd%TYPE;
  ws_plast GIIS_PAYEES.payee_last_name%TYPE := NVL(:NEW.assd_name, :OLD.assd_name);
  ws_addr1 GIIS_PAYEES.mail_addr1%TYPE  := NVL(:NEW.mail_addr1,NVL(:OLD.mail_addr1,'*'));
  ws_addr2 GIIS_PAYEES.mail_addr2%TYPE  := NVL(:NEW.mail_addr2,NVL(:OLD.mail_addr2,'*'));
  ws_addr3 GIIS_PAYEES.mail_addr3%TYPE  := NVL(:NEW.mail_addr3,NVL(:OLD.mail_addr3,'*'));
  --ws_tin GIIS_PAYEES.tin%TYPE   := '---';
  ws_tin GIIS_PAYEES.tin%TYPE   := NVL(:NEW.assd_tin,'---'); --added by bonok :: 8.22.2012 :: SR#0009794
  ws_tag GIIS_PAYEES.allow_tag%TYPE  := 'Y';
  ws_designation  GIIS_PAYEES.designation%TYPE  := NVL(:NEW.designation,NVL(:OLD.designation,'*'));
  ws_contact_pers GIIS_PAYEES.contact_pers%TYPE  := NVL(:NEW.contact_pers,NVL(:OLD.contact_pers,'*'));
  ws_phone_no   GIIS_PAYEES.phone_no%TYPE  := NVL(:NEW.phone_no,NVL(:OLD.phone_no,'*'));
BEGIN
  --
  -- get fund code ....
  --
  BEGIN
    SELECT param_value_v
      INTO ws_fund_cd
      FROM giac_parameters
     WHERE param_name = 'FUND_CD';
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20780, 'FUND_CD NOT FOUND IN GIAC_PARAMETERS TABLE.');
  END;
  --
  -- get payee class code ....
  --
  BEGIN
    SELECT param_value_v
      INTO ws_pcd
      FROM giac_parameters
     WHERE param_name = 'ASSD_CLASS_CD';
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20777,'ASSD_CLASS_CD NOT FOUND IN GIAC_PARAMETERS TABLE.');
  END;
  --
  -- get sl type code ....
  --
  ws_sl_type_cd := '1';
  IF UPDATING THEN
     --
     -- update giac sl lists...
     --
     UPDATE giac_sl_lists
        SET sl_name     = ws_sl_nm,
            user_id     = NVL (giis_users_pkg.app_user, USER),
            last_update = SYSDATE
      WHERE fund_cd     = ws_fund_cd
        AND sl_type_cd  = ws_sl_type_cd
        AND sl_cd       = ws_sl_cd;
     --
     -- update giis_payees...
     --
     UPDATE GIIS_PAYEES
        SET payee_last_name = ws_plast,
     mail_addr1      = ws_addr1,
     mail_addr2      = ws_addr2,
     mail_addr3      = ws_addr3,
     tin      = ws_tin,
            designation     = ws_designation,
            contact_pers    = ws_contact_pers,
            phone_no        = ws_phone_no,
     user_id         = NVL (giis_users_pkg.app_user, USER),
            last_update     = SYSDATE
      WHERE payee_no        = ws_pno
        AND payee_class_cd  = ws_pcd;
  ELSIF INSERTING THEN
     --
     -- insert into giac sl lists....
     --
     INSERT INTO giac_sl_lists
        (fund_cd   , sl_type_cd   , sl_cd   , sl_name ,
         remarks   , user_id      , last_update)
     VALUES
        (ws_fund_cd, ws_sl_type_cd, ws_sl_cd, ws_sl_nm,
         'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON ASSURED TABLE.',
         NVL (giis_users_pkg.app_user, USER)     , SYSDATE);
     --
     -- insert into giis payees....
     --
     INSERT INTO GIIS_PAYEES
        (payee_no, payee_class_cd, payee_last_name, mail_addr1, mail_addr2, mail_addr3,
  designation, contact_pers, phone_no, tin, allow_tag, remarks, user_id, last_update)
     VALUES
        (ws_pno, ws_pcd, ws_plast, ws_addr1, ws_addr2, ws_addr3,
         ws_designation, ws_contact_pers, ws_phone_no, ws_tin, ws_tag,
  'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON ASSURED TABLE.', NVL (giis_users_pkg.app_user, USER), SYSDATE);
  ELSIF DELETING THEN
     --
     -- delete from giac sl lists....
     --
     DELETE FROM giac_sl_lists
      WHERE fund_cd    = ws_fund_cd
        AND sl_type_cd = ws_sl_type_cd
        AND sl_cd      = ws_sl_cd;
     --
     -- delete from giis payees....
     --
     DELETE GIIS_PAYEES
      WHERE payee_no       = ws_pno
        AND payee_class_cd = ws_pcd;
   END IF;
END;
/

ALTER TRIGGER CPI.GIIS_ASSURED_TEMP_TADIU_042505 DISABLE;


