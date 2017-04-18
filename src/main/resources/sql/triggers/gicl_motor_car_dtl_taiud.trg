DROP TRIGGER CPI.GICL_MOTOR_CAR_DTL_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GICL_MOTOR_CAR_DTL_TAIUD
AFTER INSERT OR UPDATE OR DELETE
ON CPI.GICL_MOTOR_CAR_DTL FOR EACH ROW
BEGIN
  IF INSERTING THEN
     INSERT INTO GICL_CLM_ITEM
       (CLAIM_ID                ,ITEM_NO                   ,
        CURRENCY_CD             ,user_ID                   ,
        LAST_UPDATE             ,ITEM_TITLE                ,
        LOSS_DATE                ,CURRENCY_RATE             ,
        GROUPED_ITEM_NO)
     VALUES
       (:NEW.CLAIM_ID          ,:NEW.ITEM_NO              ,
        :NEW.CURRENCY_CD       ,:NEW.user_ID              ,
        :NEW.LAST_UPDATE       ,:NEW.ITEM_TITLE           ,
        :NEW.LOSS_DATE           ,:NEW.CURRENCY_RATE        ,
        0);
  ELSIF UPDATING THEN
    BEGIN
     UPDATE GICL_CLM_ITEM
        SET ITEM_TITLE    = :NEW.ITEM_TITLE,
            LOSS_DATE     = :NEW.LOSS_DATE,
     user_ID       = NVL (giis_users_pkg.app_user, USER),
            LAST_UPDATE   = SYSDATE
      WHERE CLAIM_ID = :NEW.CLAIM_ID
        AND ITEM_NO  = :NEW.ITEM_NO;
    END;
  ELSIF DELETING THEN
    BEGIN
     DELETE FROM GICL_CLM_ITEM
       WHERE CLAIM_ID =  :OLD.CLAIM_ID
         AND ITEM_NO  =  :OLD.ITEM_NO;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
    END;
  END IF;
END;
/


