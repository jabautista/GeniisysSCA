DROP TRIGGER CPI.GICL_CLM_POLBAS_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GICL_CLM_POLBAS_TAIUD
  AFTER INSERT OR UPDATE OF LOSS_DATE OR DELETE ON CPI.GICL_CLAIMS   FOR EACH ROW
DECLARE
  /*Modified by: jen.04252007
  ** truncate :new.loss_date*/
  CURSOR POLBASIC IS
    SELECT POLICY_ID,
           EFF_DATE,
           EXPIRY_DATE,
           ENDT_TYPE,
           ENDT_YY,
           ENDT_SEQ_NO
      FROM GIPI_POLBASIC
     WHERE POL_FLAG                                   NOT IN ('4','5')
       --BETH 02272007AND DIST_FLAG                                   = DECODE(ENDT_TYPE, 'N', DIST_FLAG, '3')
       /*Modified by MJ 04/10/2014
	   AND TRUNC(EFF_DATE)                                    <= TRUNC(:NEW.LOSS_DATE)
       AND TRUNC(EXPIRY_DATE)                          		  >= TRUNC(:NEW.LOSS_DATE)
       AND TRUNC(NVL(ENDT_EXPIRY_DATE,TRUNC(:NEW.LOSS_DATE))) >= TRUNC(:NEW.LOSS_DATE)
       */
	   AND EFF_DATE                                    		  <= :NEW.LOSS_DATE
       AND EXPIRY_DATE                          		  	  >= :NEW.LOSS_DATE
       AND NVL(ENDT_EXPIRY_DATE,:NEW.LOSS_DATE) 			  >= :NEW.LOSS_DATE
	   AND RENEW_NO                                    		  = :NEW.RENEW_NO
       AND POL_SEQ_NO                                  		  = :NEW.POL_SEQ_NO
       AND ISSUE_YY                                    		  = :NEW.ISSUE_YY
       AND ISS_CD                                      		  = :NEW.POL_ISS_CD
       AND SUBLINE_CD                                  		  = :NEW.SUBLINE_CD
       AND LINE_CD                                     		  = :NEW.LINE_CD;
BEGIN
  IF DELETING OR UPDATING THEN
    DELETE FROM GICL_CLM_POLBAS
     WHERE CLAIM_ID        = :OLD.CLAIM_ID;
  END IF;
  IF INSERTING OR UPDATING THEN
    FOR POLBASIC_REC IN POLBASIC LOOP
      INSERT INTO GICL_CLM_POLBAS(CLAIM_ID,
                                  LOSS_DATE,
                                  POLICY_ID,
                                  EFF_DATE,
                                  EXPIRY_DATE,
                                  ENDT_TYPE,
                                  ENDT_YY,
                                  ENDT_SEQ_NO)
                     VALUES(:NEW.CLAIM_ID,
                                  :NEW.LOSS_DATE,
                                  POLBASIC_REC.POLICY_ID,
                                  POLBASIC_REC.EFF_DATE,
        POLBASIC_REC.EXPIRY_DATE,
                                  POLBASIC_REC.ENDT_TYPE,
                                  POLBASIC_REC.ENDT_YY,
                                  POLBASIC_REC.ENDT_SEQ_NO);
    END LOOP;
  END IF;
END;
/


