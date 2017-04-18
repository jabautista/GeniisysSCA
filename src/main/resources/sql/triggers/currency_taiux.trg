DROP TRIGGER CPI.CURRENCY_TAIUX;

CREATE OR REPLACE TRIGGER CPI.CURRENCY_TAIUX
AFTER INSERT OR UPDATE
ON CPI.GIIS_CURRENCY FOR EACH ROW
DECLARE
BEGIN
  DECLARE
  BEGIN
    IF updating THEN
       FOR c1 IN (       SELECT rowid
                           FROM giac_currency
                          WHERE main_currency_cd = :new.main_currency_cd
                            AND inactivity_date IS NULL
                  FOR UPDATE OF inactivity_date)
       LOOP
         UPDATE giac_currency
            SET inactivity_date = sysdate,
                active_flag = 'I',
                last_update = sysdate
          WHERE rowid = c1.rowid;
         EXIT;
       END LOOP;
    END IF;
    INSERT INTO  giac_currency
                (main_currency_cd      , currency_rt      , effectivity_date ,
                 active_flag           , user_id          , last_update)
         VALUES (:new.main_currency_cd , :new.currency_rt , SYSDATE ,
                 'A'                   , :new.user_id     , :new.last_update);
  EXCEPTION
    WHEN OTHERS THEN
      RAISE;
  END;

END;
/


