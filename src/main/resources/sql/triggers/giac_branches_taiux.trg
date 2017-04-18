DROP TRIGGER CPI.GIAC_BRANCHES_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GIAC_BRANCHES_TAIUX
/*Created by Edison 03.30.2012
**Everytime branches maintenance will update its address, tel_no,
**and branch_tin, issuing source maintenance will also update 
**this columns.
*/
AFTER UPDATE ON CPI.GIAC_BRANCHES FOR EACH ROW
DECLARE
    PRAGMA AUTONOMOUS_TRANSACTION;
BEGIN
    --Disabled the trigger in giis_issource to avoid circular update between two tables
    EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.GIIS_ISSOURCE_TAIUD DISABLE';
    EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.TRG1_ISSOURCE DISABLE';
      IF UPDATING THEN
          UPDATE CPI.GIIS_ISSOURCE
             SET ADDRESS1      = :NEW.ADDRESS1,
                 ADDRESS2      = :NEW.ADDRESS2,
                 ADDRESS3      = :NEW.ADDRESS3,
                 TEL_NO        = :NEW.TEL_NO,
                 BRANCH_TIN_CD = :NEW.BRANCH_TIN              
           WHERE ISS_CD = :NEW.branch_cd;
      END IF;
    --Enabled the trigger in giis_issource
    EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.GIIS_ISSOURCE_TAIUD ENABLE';  
    EXECUTE IMMEDIATE 'ALTER TRIGGER CPI.TRG1_ISSOURCE ENABLE';    
END;
/

ALTER TRIGGER CPI.GIAC_BRANCHES_TAIUX DISABLE;


