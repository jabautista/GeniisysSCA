DROP TRIGGER CPI.GIIS_OBLIGEE_TADIU;

CREATE OR REPLACE TRIGGER CPI.GIIS_OBLIGEE_TADIU
/* created by: adrel
** date created: 08132009
** description: to insert, update or delete record on giis_payees,when inserting,
**              updating or deleting records on giis_obligee
*/
AFTER DELETE OR UPDATE OR INSERT
ON CPI.GIIS_OBLIGEE FOR EACH ROW
DECLARE
 ws_fund_cd      GIAC_SL_LISTS.fund_cd%TYPE;
 ws_sl_type_cd   GIAC_SL_LISTS.sl_type_cd%TYPE;
 ws_sl_cd        GIAC_SL_LISTS.sl_cd%TYPE         := NVL(:NEW.OBLIGEE_NO, :OLD.OBLIGEE_NO);
 ws_sl_nm        GIAC_SL_LISTS.sl_name%TYPE       := NVL(:NEW.OBLIGEE_name, :OLD.OBLIGEE_name);
 ws_pno          GIIS_PAYEES.payee_no%TYPE        := NVL(:NEW.OBLIGEE_NO, :OLD.OBLIGEE_NO);
 ws_pcd          GIIS_PAYEES.payee_class_cd%TYPE;
 ws_plast        GIIS_PAYEES.payee_last_name%TYPE := NVL(:NEW.OBLIGEE_name, :OLD.OBLIGEE_name);
 ws_addr1        GIIS_PAYEES.mail_addr1%TYPE      := NVL(:NEW.ADDRESS1,NVL(:OLD.ADDRESS1,'*'));
 ws_addr2        GIIS_PAYEES.mail_addr2%TYPE      := NVL(:NEW.ADDRESS2,NVL(:OLD.ADDRESS2,'*'));
 ws_addr3        GIIS_PAYEES.mail_addr3%TYPE      := NVL(:NEW.ADDRESS3,NVL(:OLD.ADDRESS3,'*'));
 ws_tin          GIIS_PAYEES.tin%TYPE             := '-';
 ws_tag          GIIS_PAYEES.allow_tag%TYPE       := 'Y';
 ws_designation  GIIS_PAYEES.designation%TYPE     := NVL(:NEW.designation,NVL(:OLD.designation,'*'));
 ws_contact_pers GIIS_PAYEES.contact_pers%TYPE    := NVL(:NEW.contact_person,NVL(:OLD.contact_person,'*'));
 ws_sl_type_tag  GIIS_PAYEE_CLASS.sl_type_tag%TYPE;
BEGIN
 BEGIN
    SELECT sl_type_tag,sl_type_cd
      INTO ws_sl_type_tag,ws_sl_type_cd
      FROM GIIS_PAYEE_CLASS
     WHERE payee_class_cd = (SELECT param_value_v
                               FROM GIAC_PARAMETERS
                              WHERE param_name= 'OBLIGEE_CLASS_CD') ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
       RAISE_APPLICATION_ERROR(-20800,'Geniisys Exception#E#PAYEE_CLASS_CD FOR OBLIGEE NOT FOUND IN GIIS_PAYEE_CLASS TABLE.');
 END;
    IF ws_sl_type_tag = 'Y' THEN
       BEGIN
          SELECT param_value_v
            INTO ws_fund_cd
            FROM GIAC_PARAMETERS
           WHERE param_name = 'FUND_CD';
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
               RAISE_APPLICATION_ERROR(-20780, 'Geniisys Exception#E#FUND_CD NOT FOUND IN GIAC_PARAMETERS TABLE.');
       END;
      -- ws_sl_type_cd := '1';
     END IF;
 BEGIN
   SELECT param_value_v
     INTO ws_pcd
     FROM GIAC_PARAMETERS
    WHERE param_name = 'OBLIGEE_CLASS_CD';
 EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RAISE_APPLICATION_ERROR(-20777,'Geniisys Exception#E#MORTGAGEE_CLASS_CD NOT FOUND IN GIAC_PARAMETERS TABLE.');
 END;
 /* IF UPDATING, INSERTING OR DELETING */
 IF UPDATING THEN
    IF ws_sl_type_tag = 'Y' THEN
       UPDATE GIAC_SL_LISTS
          SET sl_name     = ws_sl_nm,
              user_id     = NVL (giis_users_pkg.app_user, USER),
              last_update = SYSDATE
        WHERE fund_cd     = ws_fund_cd
          AND sl_type_cd  = ws_sl_type_cd
          AND sl_cd       = ws_sl_cd;
    END IF;
       UPDATE GIIS_PAYEES
          SET payee_last_name = ws_plast,
                      mail_addr1      = ws_addr1,
                  mail_addr2      = ws_addr2,
                  mail_addr3      = ws_addr3,
                  tin                     = ws_tin,
              designation     = ws_designation,
              contact_pers    = ws_contact_pers,
                  user_id         = NVL (giis_users_pkg.app_user, USER),
              last_update     = SYSDATE
        WHERE payee_no        = ws_pno
          AND payee_class_cd  = ws_pcd;
 ELSIF INSERTING THEN
     IF ws_sl_type_tag = 'Y' THEN
       INSERT INTO GIAC_SL_LISTS
                  (fund_cd,
                   sl_type_cd,
                   sl_cd,
                   sl_name,
                   remarks,
                   user_id,
                   last_update)
             VALUES
                   (ws_fund_cd,
                    ws_sl_type_cd,
                    ws_sl_cd,
                    ws_sl_nm,
                    'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON GIIS_OBLIGEE TABLE.',
                    NVL (giis_users_pkg.app_user, USER),
                    SYSDATE);
      END IF;
        INSERT INTO GIIS_PAYEES
                   (payee_no,
                            payee_class_cd,
                            payee_last_name,
                            mail_addr1,
                            mail_addr2,
                            mail_addr3,
                            designation,
                            contact_pers,
                            tin,
                            allow_tag,
                            remarks,
                            user_id,
                            last_update)
             VALUES
                   (ws_pno,
                            ws_pcd,
                            ws_plast,
                            ws_addr1,
                            ws_addr2,
                            ws_addr3,
                    ws_designation,
                            ws_contact_pers,
                            ws_tin,
                            ws_tag,
                            'THIS IS GENERATED BY THE SYSTEM AFTER INSERT ON OBLIGEE TABLE.',
                            NVL (giis_users_pkg.app_user, USER),
                            SYSDATE);
 ELSIF DELETING THEN
    IF ws_sl_type_tag = 'Y' THEN
       DELETE
         FROM GIAC_SL_LISTS
        WHERE fund_cd    = ws_fund_cd
          AND sl_type_cd = ws_sl_type_cd
          AND sl_cd      = ws_sl_cd;
    END IF;
       DELETE
         FROM GIIS_PAYEES
        WHERE payee_no       = ws_pno
          AND payee_class_cd = ws_pcd;
 END IF;
END;
/

