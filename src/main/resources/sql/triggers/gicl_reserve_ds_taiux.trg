DROP TRIGGER CPI.GICL_RESERVE_DS_TAIUX;

CREATE OR REPLACE TRIGGER CPI.GICL_RESERVE_DS_TAIUX
AFTER INSERT OR UPDATE OF negate_tag ON CPI.GICL_RESERVE_DS FOR EACH ROW
DECLARE
   v_line_cd           GIIS_LINE.line_cd%TYPE;
   v_share_type        GIIS_DIST_SHARE.share_type%TYPE;
   v_tsi_amt           GICL_ITEM_PERIL.ann_tsi_amt%TYPE;
/* the variables below is used to check if the to-be-inserted record
** already exists but with different share distribution
** (as in the case of inserting Net Retention for distribution records
** w/o Net Retention, thus, there is new distribution share).
** If so, update record and insert new entry, Net Ret. Pia, 08.10.04 */
   v_rec_exist         VARCHAR2(1) := 'N';
BEGIN

--MODIFIED BY EMCY da051806te: add NVL for all instance of grouped_item_no
  IF INSERTING THEN
     BEGIN
       SELECT line_cd
         INTO v_line_cd
         FROM GICL_CLAIMS
        WHERE claim_id  = :NEW.claim_id;
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;
     BEGIN
       SELECT share_type
         INTO v_share_type
         FROM GIIS_DIST_SHARE
        WHERE share_cd  = :NEW.grp_seq_no
          AND line_cd   = v_line_cd;
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;
     BEGIN
       SELECT ann_tsi_amt
         INTO v_tsi_amt
         FROM GICL_ITEM_PERIL
        WHERE peril_cd        = :NEW.peril_cd
          AND item_no         = :NEW.item_no
          AND claim_id        = :NEW.claim_id
   AND grouped_item_no = NVL(:NEW.grouped_item_no,0);
     EXCEPTION
       WHEN OTHERS THEN
         NULL;
     END;
  -- check if record exists in table. Pia, 08.10.04
  FOR chk IN
    (SELECT 'Y'
       FROM GICL_POLICY_DIST
   WHERE claim_id   = :NEW.claim_id
     AND item_no    = :NEW.item_no
       --added nvl on grouped_item_no to handle null values benidex
     AND nvl(grouped_item_no,0) = NVL(:NEW.grouped_item_no,0)
     AND peril_cd   = :NEW.peril_cd
     AND share_type = v_share_type
     AND share_cd   = :NEW.grp_seq_no
     AND line_cd    = v_line_cd)
     LOOP
    v_rec_exist := 'Y';
    EXIT;
  END LOOP;
     -- if exists, update record w/ new share distribution. Pia, 08.10.04
  IF v_rec_exist = 'Y' THEN
     UPDATE GICL_POLICY_DIST
     SET shr_tsi_pct = :NEW.shr_pct,
         shr_tsi_amt = v_tsi_amt * :NEW.shr_pct/100
      WHERE claim_id    = :NEW.claim_id
     AND item_no     = :NEW.item_no
     AND grouped_item_no = NVL(:NEW.grouped_item_no,0)
     AND peril_cd    = :NEW.peril_cd
     AND share_type  = v_share_type
     AND share_cd    = :NEW.grp_seq_no
     AND line_cd     = :NEW.line_cd; -- end of modification. Pia, 08.10.04
  ELSE
        INSERT INTO GICL_POLICY_DIST(claim_id, item_no, peril_cd,
                                     line_cd, share_type, share_cd,
                                     shr_tsi_pct, shr_tsi_amt, grouped_item_no)
                              VALUES(:NEW.claim_id, :NEW.item_no, :NEW.peril_cd,
                                     v_line_cd, v_share_type, :NEW.grp_seq_no,
                                     :NEW.shr_pct, v_tsi_amt*:NEW.shr_pct/100, NVL(:NEW.grouped_item_no,0));
     END IF;
  ELSIF UPDATING THEN
     IF :NEW.negate_tag = 'Y' THEN
         DELETE FROM GICL_POLICY_DIST_RI
               WHERE peril_cd     = :NEW.peril_cd
                 AND item_no      = :NEW.item_no
     AND NVL(grouped_item_no,0)/*emcyDA042407te@pcic*/ = NVL(:NEW.grouped_item_no,0)
                 AND claim_id     = :NEW.claim_id;
         DELETE FROM GICL_POLICY_DIST
               WHERE peril_cd     = :NEW.peril_cd
                 AND item_no      = :NEW.item_no
     AND NVL(grouped_item_no,0)/*emcyDA042407te@pcic*/ = NVL(:NEW.grouped_item_no,0)
                 AND claim_id     = :NEW.claim_id;
     END IF;
  END IF;
END;
/


