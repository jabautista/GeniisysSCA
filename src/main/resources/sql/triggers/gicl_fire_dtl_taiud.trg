DROP TRIGGER CPI.GICL_FIRE_DTL_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GICL_FIRE_DTL_TAIUD
AFTER INSERT OR UPDATE OR DELETE
ON CPI.GICL_FIRE_DTL FOR EACH ROW
BEGIN
  IF INSERTING THEN
     INSERT INTO gicl_clm_item
       (claim_id               ,item_no                   ,
        currency_cd            ,user_id                   ,
        last_update            ,item_title                ,
        loss_date	           ,currency_rate             ,
		grouped_item_no)
     VALUES
       (:NEW.claim_id          ,:NEW.item_no              ,
        :NEW.currency_cd       ,:NEW.user_id              ,
        :NEW.last_update       ,:NEW.item_title           ,
        :NEW.loss_date	       ,:NEW.currency_rate        ,
		0);
  ELSIF UPDATING THEN
    BEGIN
      UPDATE gicl_clm_item
      SET item_no         = :NEW.item_no,
          user_id         = :NEW.user_id,
          last_update     = :NEW.last_update,
          item_title      = :NEW.item_title,
          loss_date       = :NEW.loss_date
    WHERE claim_id        = :OLD.claim_id
      AND item_no         = :OLD.item_no;
    END;
  ELSIF DELETING THEN
    BEGIN
     DELETE FROM gicl_clm_item
       WHERE claim_id =  :OLD.claim_id
         AND item_no  =  :OLD.item_no;
    EXCEPTION
     WHEN NO_DATA_FOUND THEN
       NULL;
    END;
  END IF;
END;
/


