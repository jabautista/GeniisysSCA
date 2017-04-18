DROP TRIGGER CPI.GCIP_GCIP_TAIUD;

CREATE OR REPLACE TRIGGER CPI.GCIP_GCIP_TAIUD
AFTER INSERT OR UPDATE OR DELETE ON CPI.GIPI_COMM_INV_PERIL FOR EACH ROW
BEGIN
  IF INSERTING THEN
    FOR JA1 IN (
    SELECT * FROM GIPI_COMM_INVOICE
    WHERE ISS_CD = :NEW.ISS_CD
    AND PREM_SEQ_NO = :NEW.PREM_sEQ_NO
    AND INTRMDRY_INTM_NO = :NEW.INTRMDRY_INTM_NO) LOOP
    BEGIN
      INSERT INTO GIAC_COMM_INVOICE
    (INTRMDRY_INTM_NO     ,     POLICY_ID            ,     ISS_CD               ,
     PREM_SEQ_NO          ,     SHARE_PERCENTAGE     ,     PREMIUM_AMT          ,
     COMMISSION_AMT       ,     WHOLDING_TAX         ,     GACC_TRAN_ID         ,
     BOND_RATE            ,     PARENT_INTM_NO       ,  SPL_WHOLDING_TAX     ,
         LAST_UPDATE          ,  user_ID              )
      VALUES
    (JA1.INTRMDRY_INTM_NO ,     JA1.POLICY_ID        ,     JA1.ISS_CD           ,
     JA1.PREM_SEQ_NO      ,     JA1.SHARE_PERCENTAGE ,     JA1.PREMIUM_AMT      ,
     JA1.COMMISSION_AMT   ,     JA1.WHOLDING_TAX     ,     JA1.GACC_TRAN_ID     ,
     JA1.BOND_RATE        ,     JA1.PARENT_INTM_NO   ,  NULL                 ,
     SYSDATE              ,  NVL (giis_users_pkg.app_user, USER)                 );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
    END LOOP JA1;
    BEGIN
      INSERT INTO GIAC_COMM_INV_PERIL
    (INTRMDRY_INTM_NO     ,     POLICY_ID            ,     ISS_CD               ,
     PREM_SEQ_NO          ,     PERIL_CD             ,  PREMIUM_AMT          ,
     COMMISSION_AMT       ,     COMMISSION_RT        ,  WHOLDING_TAX         ,
         SPL_WHOLDING_TAX     ,  LAST_UPDATE          ,  user_ID              )
      VALUES
    (:NEW.INTRMDRY_INTM_NO,     :NEW.POLICY_ID       ,     :NEW.ISS_CD          ,
     :NEW.PREM_SEQ_NO     ,     :NEW.PERIL_CD        ,  :NEW.PREMIUM_AMT     ,
      :NEW.COMMISSION_AMT  ,  :NEW.COMMISSION_RT   ,  :NEW.WHOLDING_TAX    ,
     NULL                 ,  SYSDATE              ,  NVL (giis_users_pkg.app_user, USER)                 );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  ELSIF DELETING THEN
    DELETE FROM giac_comm_inv_peril
       WHERE iss_cd = :OLD.iss_cd
       AND prem_Seq_no = :OLD.prem_seq_no
       AND intrmdry_intm_no = :OLD.intrmdry_intm_no;
    DELETE FROM giac_comm_invoice
       WHERE iss_cd = :OLD.iss_cd
       AND prem_Seq_no = :OLD.prem_seq_no
       AND intrmdry_intm_no = :OLD.intrmdry_intm_no;
  ELSIF UPDATING THEN
    FOR JA1 IN (
    SELECT * FROM GIPI_COMM_INVOICE
    WHERE ISS_CD = :NEW.ISS_CD
    AND PREM_SEQ_NO = :NEW.PREM_sEQ_NO
    AND INTRMDRY_INTM_NO = :NEW.INTRMDRY_INTM_NO) LOOP
      DELETE FROM giac_comm_inv_peril
       WHERE iss_cd = :OLD.iss_cd
       AND prem_Seq_no = :OLD.prem_seq_no
       AND intrmdry_intm_no = :OLD.intrmdry_intm_no
       AND peril_cd = :OLD.peril_cd;
      BEGIN
        UPDATE giac_comm_invoice
        SET INTRMDRY_INTM_NO = :NEW.intrmdry_intm_no,
            PREMIUM_AMT  = JA1.PREMIUM_AMT,
            SHARE_PERCENTAGE = JA1.SHARE_PERCENTAGE,
            COMMISSION_AMT = JA1.commission_amt,
            WHOLDING_TAX = JA1.wholding_tax,
            PARENT_INTM_NO = JA1.parent_intm_no,
            SPL_WHOLDING_TAX = NULL,
            LAST_UPDATE  = SYSDATE,
            user_ID = NVL (giis_users_pkg.app_user, USER)
        WHERE policy_Id = ja1.policy_id
        AND iss_cd = :OLD.iss_cd
        AND prem_seq_no = :OLD.prem_seq_no
        AND intrmdry_intm_no = :OLD.intrmdry_intm_no;
      END;
    END LOOP JA1;
    BEGIN
      INSERT INTO GIAC_COMM_INV_PERIL
    (INTRMDRY_INTM_NO     ,     POLICY_ID            ,     ISS_CD               ,
     PREM_SEQ_NO          ,     PERIL_CD             ,  PREMIUM_AMT          ,
     COMMISSION_AMT       ,     COMMISSION_RT        ,  WHOLDING_TAX         ,
     SPL_WHOLDING_TAX     ,  LAST_UPDATE          ,  user_ID              )
      VALUES
    (:NEW.INTRMDRY_INTM_NO,     :NEW.POLICY_ID       ,     :NEW.ISS_CD          ,
     :NEW.PREM_SEQ_NO     ,     :NEW.PERIL_CD        ,  :NEW.PREMIUM_AMT     ,
     :NEW.COMMISSION_AMT  ,  :NEW.COMMISSION_RT   ,  :NEW.WHOLDING_TAX    ,
     NULL                 ,  SYSDATE              ,  NVL (giis_users_pkg.app_user, USER)                 );
    EXCEPTION
      WHEN DUP_VAL_ON_INDEX THEN
        NULL;
    END;
  END IF;
END;
/


