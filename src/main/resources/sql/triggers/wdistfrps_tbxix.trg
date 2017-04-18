DROP TRIGGER CPI.WDISTFRPS_TBXIX;

CREATE OR REPLACE TRIGGER CPI.WDISTFRPS_TBXIX
BEFORE INSERT
ON CPI.GIRI_WDISTFRPS FOR EACH ROW
DECLARE
BEGIN
  DECLARE
    p_exist   VARCHAR2(1) := 'N';
  BEGIN
    FOR A IN (SELECT FRPS_SEQ_NO,ROWID FROM GIIS_FRPS_SEQ
               WHERE LINE_CD=:NEW.LINE_CD
                 AND FRPS_YY=:NEW.FRPS_YY
              FOR UPDATE OF FRPS_SEQ_NO) LOOP
           IF A.FRPS_SEQ_NO > 99999998 THEN
             UPDATE GIIS_FRPS_SEQ
                SET LAST_UPDATE = SYSDATE,user_ID=NVL (giis_users_pkg.app_user, USER),
                    FRPS_SEQ_NO = 1
              WHERE ROWID = A.ROWID;
             :NEW.FRPS_SEQ_NO := 1;
           ELSE
             UPDATE GIIS_FRPS_SEQ
                SET LAST_UPDATE = SYSDATE,user_ID=NVL (giis_users_pkg.app_user, USER),
                    FRPS_SEQ_NO = A.FRPS_SEQ_NO + 1
              WHERE ROWID = A.ROWID;
              :NEW.FRPS_SEQ_NO := A.FRPS_SEQ_NO + 1;
           END IF;
           p_exist  := 'Y';
           EXIT;
    END LOOP;
    IF p_exist = 'N' THEN
       :NEW.FRPS_SEQ_NO  := 1;
       INSERT INTO GIIS_FRPS_SEQ
           (LINE_CD,FRPS_YY,FRPS_SEQ_NO,user_ID,LAST_UPDATE)
       VALUES
           (:NEW.LINE_CD,:NEW.FRPS_YY,:NEW.FRPS_SEQ_NO,NVL (giis_users_pkg.app_user, USER),SYSDATE);
    END IF;
  END;
END;
/


