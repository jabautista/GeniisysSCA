DROP TRIGGER CPI.GICL_RESERVE_RIDS_TAIXX;

CREATE OR REPLACE TRIGGER CPI.GICL_RESERVE_RIDS_TAIXX
AFTER INSERT OR DELETE ON CPI.GICL_RESERVE_RIDS FOR EACH ROW
DECLARE
   V_LINE_CD           GIIS_LINE.LINE_CD%TYPE;
   V_SHARE_TYPE        GIIS_DIST_SHARE.SHARE_TYPE%TYPE;
   V_TSI_AMT           GICL_ITEM_PERIL.ANN_TSI_AMT%TYPE;
   V_SHR_TSI_PCT       GICL_RESERVE_DS.SHR_PCT%TYPE;
BEGIN
   IF INSERTING THEN
      BEGIN
         SELECT LINE_CD
           INTO V_LINE_CD
           FROM GICL_CLAIMS
          WHERE CLAIM_ID  = :NEW.CLAIM_ID;
      EXCEPTION
          WHEN OTHERS THEN
             NULL;
      END;
      BEGIN
         SELECT SHARE_TYPE
           INTO V_SHARE_TYPE
           FROM GIIS_DIST_SHARE
          WHERE SHARE_CD  = :NEW.GRP_SEQ_NO
            AND LINE_CD   = V_LINE_CD;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT ANN_TSI_AMT
           INTO V_TSI_AMT
           FROM GICL_ITEM_PERIL
          WHERE PERIL_CD        = :NEW.PERIL_CD
            AND ITEM_NO         = :NEW.ITEM_NO
			AND GROUPED_ITEM_NO = :NEW.GROUPED_ITEM_NO
            AND CLAIM_ID        = :NEW.CLAIM_ID;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      BEGIN
         SELECT SHR_PCT
           INTO V_SHR_TSI_PCT
           FROM GICL_RESERVE_DS
          WHERE GRP_SEQ_NO       = :NEW.GRP_SEQ_NO
            AND CLM_DIST_NO      = :NEW.CLM_DIST_NO
            AND CLM_RES_HIST_ID  = :NEW.CLM_RES_HIST_ID
            AND CLAIM_ID         = :NEW.CLAIM_ID;
      EXCEPTION
         WHEN OTHERS THEN
            NULL;
      END;
      INSERT INTO GICL_POLICY_DIST_RI(CLAIM_ID,
                      ITEM_NO,
                      PERIL_CD,
                      LINE_CD,
                      SHARE_TYPE,
                      SHARE_CD,
                      RI_CD,
                      PRNT_RI_CD,
                      SHR_RI_TSI_PCT,
                      SHR_RI_TSI_AMT,
                      GROUPED_ITEM_NO)
               VALUES(:NEW.CLAIM_ID,
                      :NEW.ITEM_NO,
                      :NEW.PERIL_CD,
                      V_LINE_CD,
                      V_SHARE_TYPE,
                      :NEW.GRP_SEQ_NO,
                      :NEW.RI_CD,
                      :NEW.PRNT_RI_CD,
                      :NEW.SHR_RI_PCT_REAL,
                      V_TSI_AMT*(V_SHR_TSI_PCT/100)*
                      (:NEW.SHR_RI_PCT_REAL/100),
					  :NEW.GROUPED_ITEM_NO);
   ELSIF DELETING THEN
   		 DELETE FROM GICL_POLICY_DIST_RI
		 WHERE CLAIM_ID=:OLD.CLAIM_ID
		 AND ITEM_NO=:OLD.ITEM_NO
		 AND PERIL_CD=:OLD.PERIL_CD
		 AND SHARE_CD=:OLD.GRP_SEQ_NO;
   END IF;
END;
/


