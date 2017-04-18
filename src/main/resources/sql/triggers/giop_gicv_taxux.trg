DROP TRIGGER CPI.GIOP_GICV_TAXUX;

CREATE OR REPLACE TRIGGER CPI.GIOP_GICV_TAXUX
AFTER UPDATE OF OR_FLAG ON CPI.GIAC_ORDER_OF_PAYTS FOR EACH ROW
DECLARE
  V_BALANCE      GIAC_AGING_SOA_DETAILS.BALANCE_AMT_DUE%TYPE;
  VAR_TRAN_ID    GIAC_COMM_VOUCHER.CV_TRAN_ID%TYPE;
  V_DUMMY        VARCHAR2(1);
  V_CV_TRAN_ID   GIAC_COMM_VOUCHER.CV_TRAN_ID%TYPE;
BEGIN
   IF :NEW.OR_FLAG = 'C' THEN
     /*  added by janet ang 03-23-2000 */
     /*  upon cancellation of an OR, the CV's which choose the special w/tax rate  **
     **  in the comm_voucher module will revert back to the normal w/tax rate      */
     BEGIN
       FOR ja1 IN (
         SELECT DISTINCT iss_cd, prem_seq_no
         FROM GIAC_COMM_VOUCHER
         WHERE gacc_tran_id = :NEW.gacc_tran_id
         AND tran_flag != 'D'
         AND NVL(print_flag,'0') NOT IN ('1','2','3','4')
         AND transaction_type IN ('1','3')   ) LOOP
           UPDATE GIAC_COMM_INVOICE
           SET spl_wholding_tax = NULL, last_update = SYSDATE, user_id = NVL (giis_users_pkg.app_user, USER)
           WHERE iss_cd = ja1.iss_cd
           AND prem_Seq_no = ja1.prem_seq_no
           AND spl_wholding_tax IS NOT NULL;
           UPDATE GIAC_COMM_INV_PERIL
           SET spl_wholding_tax = NULL, last_update = SYSDATE, user_id = NVL (giis_users_pkg.app_user, USER)
           WHERE iss_cd = ja1.iss_cd
           AND prem_Seq_no = ja1.prem_seq_no
           AND spl_wholding_tax IS NOT NULL;
       END LOOP ja1;
     END;
     /*  created by janet ang, january, 2000                              */
     /*  will cancel also the CV's with the same print_doc
     **  and recreate the transactions not created in that o.r.
     **  for future reprinting when bill becomes fully paid
     */
     FOR ja IN (
       SELECT DISTINCT print_doc
       FROM GIAC_COMM_VOUCHER
       WHERE ref_no = :NEW.or_pref_suf||'-'||TO_CHAR(:NEW.or_no)
       AND tran_flag != 'D'
       AND NVL(print_flag,'0') NOT IN ('1','2','3','4')  ) LOOP
       UPDATE GIAC_COMM_VOUCHER
       SET print_flag = '2'
       WHERE print_doc = ja.print_doc
       AND NVL(print_flag,'0') NOT IN ('1','2','3','4')
       AND tran_flag != 'D';
       FOR ja1 IN (
         SELECT
          CV_TRAN_ID       ,INTM_NO         ,ISS_CD           ,PREM_SEQ_NO     ,
          INST_NO          ,GACC_TRAN_ID    ,LINE_CD          ,SUBLINE_CD      ,
          ISSUE_YY         ,POL_SEQ_NO      ,ENDT_ISS_CD      ,ENDT_YY         ,
          ENDT_SEQ_NO      ,RENEW_NO        ,ASSD_NO          ,TRAN_CLASS      ,
          TRAN_FLAG        ,TRAN_DATE       ,COLLECTION_AMT   ,FUND_CD         ,
          FUND_DESC        ,BRANCH_CD       ,BRANCH_NAME      ,REF_NO          ,
          CV_DATE          ,COMMV_PREF      ,COMM_VCR_NO      ,PREMIUM_AMT     ,
          COMMISSION_AMT   ,WHOLDING_TAX    ,ADVANCES         ,DISCOUNT        ,
          INPUT_VAT        ,OTHER_CHARGES   ,NOTARIAL_FEE     ,TAX_AMT         ,
          PR_FLAG          ,CPI_REC_NO      ,CPI_BRANCH_CD    ,LAST_UPDATE     ,
          user_ID          ,PRINT_FLAG      ,PRINT_DOC        ,TRANSACTION_TYPE
         FROM GIAC_COMM_VOUCHER
         WHERE print_flag = '2'
         AND print_doc = ja.print_doc
         AND ref_no != :NEW.or_pref_suf||'-'||TO_CHAR(:NEW.or_no)
         AND gacc_tran_id != :NEW.gacc_tran_id
         AND tran_flag != 'D'
         ORDER BY cv_tran_id) LOOP
         IF NVL(var_tran_id,0) != ja1.cv_tran_id THEN
            SELECT NVL(MAX(cv_tran_id),0) + 1
            INTO v_cv_tran_id
            FROM GIAC_COMM_VOUCHER;
            var_tran_id := ja1.cv_tran_id;
         END IF;
         INSERT INTO GIAC_COMM_VOUCHER (
            CV_TRAN_ID       ,INTM_NO         ,ISS_CD           ,PREM_SEQ_NO     ,
            INST_NO          ,GACC_TRAN_ID    ,LINE_CD          ,SUBLINE_CD      ,
            ISSUE_YY         ,POL_SEQ_NO      ,ENDT_ISS_CD      ,ENDT_YY         ,
            ENDT_SEQ_NO      ,RENEW_NO        ,ASSD_NO          ,TRAN_CLASS      ,
            TRAN_FLAG        ,TRAN_DATE       ,COLLECTION_AMT   ,FUND_CD         ,
            FUND_DESC        ,BRANCH_CD       ,BRANCH_NAME      ,REF_NO          ,
            CV_DATE          ,COMMV_PREF      ,COMM_VCR_NO      ,PREMIUM_AMT     ,
            COMMISSION_AMT   ,WHOLDING_TAX    ,ADVANCES         ,DISCOUNT        ,
            INPUT_VAT        ,OTHER_CHARGES   ,NOTARIAL_FEE     ,TAX_AMT         ,
            PR_FLAG          ,CPI_REC_NO      ,CPI_BRANCH_CD    ,LAST_UPDATE     ,
            user_ID          ,PRINT_FLAG      ,PRINT_DOC        ,TRANSACTION_TYPE)
         VALUES (
            v_CV_TRAN_ID     ,ja1.INTM_NO      ,ja1.ISS_CD        ,ja1.PREM_SEQ_NO ,
            ja1.INST_NO      ,ja1.GACC_TRAN_ID ,ja1.LINE_CD       ,ja1.SUBLINE_CD  ,
            ja1.ISSUE_YY     ,ja1.POL_SEQ_NO   ,ja1.ENDT_ISS_CD   ,ja1.ENDT_YY     ,
            ja1.ENDT_SEQ_NO  ,ja1.RENEW_NO     ,ja1.ASSD_NO       ,ja1.TRAN_CLASS  ,
            ja1.TRAN_FLAG    ,ja1.TRAN_DATE    ,ja1.COLLECTION_AMT,ja1.FUND_CD     ,
            ja1.FUND_DESC    ,ja1.BRANCH_CD    ,ja1.BRANCH_NAME   ,ja1.REF_NO      ,
            NULL             ,NULL             ,NULL              ,ja1.PREMIUM_AMT ,
            ja1.COMMISSION_AMT,ja1.WHOLDING_TAX,ja1.ADVANCES      ,ja1.DISCOUNT    ,
            ja1.INPUT_VAT    ,ja1.OTHER_CHARGES,ja1.NOTARIAL_FEE  ,ja1.TAX_AMT     ,
            NULL             ,ja1.CPI_REC_NO   ,ja1.CPI_BRANCH_CD ,ja1.LAST_UPDATE ,
            ja1.user_ID      ,NULL             ,NULL              ,ja1.TRANSACTION_TYPE);
         /* update the user, last_update and tran_flag of the recreated **
         ** transactions as to when the document was cancelled          */
         UPDATE GIAC_COMM_VOUCHER
         SET user_ID = NVL (giis_users_pkg.app_user, USER), LAST_UPDATE = SYSDATE, tran_flag = 'D'
         WHERE print_doc = ja.print_doc
         AND print_flag = '2';
       END LOOP ja1;
     END LOOP ja;
     /*  tag all transactions in CV that have the same tran_id as deleted */
     UPDATE GIAC_COMM_VOUCHER
     SET tran_flag = 'D'
     WHERE gacc_tran_id = :OLD.gacc_tran_id;
   END IF;
   IF :OLD.OR_FLAG = 'P' AND :NEW.OR_FLAG = 'N' THEN --spoilage
     /*  will cancel also the CV's with the same print_doc
     **  and will also recreate all the transactions coz spoilage of an OR
     **  doesn't nullify the transactions in it.
     */
     FOR ja IN (
       SELECT DISTINCT print_doc
       FROM GIAC_COMM_VOUCHER
       WHERE ref_no = :OLD.or_pref_suf||'-'||TO_CHAR(:OLD.or_no)
       AND tran_flag != 'D'
       AND NVL(print_flag,'0') NOT IN ('1','2','3','4')  ) LOOP
       UPDATE GIAC_COMM_VOUCHER
       SET print_flag = '1'
       WHERE print_doc = ja.print_doc
       AND NVL(print_flag,'0') NOT IN ('1','2','3','4')
       AND tran_flag != 'D';
       FOR ja1 IN
         (SELECT
          CV_TRAN_ID       ,INTM_NO         ,ISS_CD           ,PREM_SEQ_NO     ,
          INST_NO          ,GACC_TRAN_ID    ,LINE_CD          ,SUBLINE_CD      ,
          ISSUE_YY         ,POL_SEQ_NO      ,ENDT_ISS_CD      ,ENDT_YY         ,
          ENDT_SEQ_NO      ,RENEW_NO        ,ASSD_NO          ,TRAN_CLASS      ,
          TRAN_FLAG        ,TRAN_DATE       ,COLLECTION_AMT   ,FUND_CD         ,
          FUND_DESC        ,BRANCH_CD       ,BRANCH_NAME      ,
            DECODE(REF_NO,:OLD.or_pref_suf||'-'||:OLD.or_no,NULL,ref_no) ref_no,
          CV_DATE          ,COMMV_PREF      ,COMM_VCR_NO      ,PREMIUM_AMT     ,
          COMMISSION_AMT   ,WHOLDING_TAX    ,ADVANCES         ,DISCOUNT        ,
          INPUT_VAT        ,OTHER_CHARGES   ,NOTARIAL_FEE     ,TAX_AMT         ,
          PR_FLAG          ,CPI_REC_NO      ,CPI_BRANCH_CD    ,LAST_UPDATE     ,
          user_ID          ,PRINT_FLAG      ,PRINT_DOC        ,TRANSACTION_TYPE
         FROM GIAC_COMM_VOUCHER
         WHERE print_flag = '1'
         AND print_doc = ja.print_doc
         AND tran_flag != 'D'
         ORDER BY cv_tran_id  ) LOOP
         IF NVL(var_tran_id,0) != ja1.cv_tran_id THEN
           SELECT NVL(MAX(cv_tran_id),0) + 1
           INTO v_cv_tran_id
           FROM GIAC_COMM_VOUCHER;
           var_tran_id := ja1.cv_tran_id;
         END IF;
         INSERT INTO GIAC_COMM_VOUCHER (
           CV_TRAN_ID       ,INTM_NO         ,ISS_CD           ,PREM_SEQ_NO     ,
           INST_NO          ,GACC_TRAN_ID    ,LINE_CD          ,SUBLINE_CD      ,
           ISSUE_YY         ,POL_SEQ_NO      ,ENDT_ISS_CD      ,ENDT_YY         ,
           ENDT_SEQ_NO      ,RENEW_NO        ,ASSD_NO          ,TRAN_CLASS      ,
           TRAN_FLAG        ,TRAN_DATE       ,COLLECTION_AMT   ,FUND_CD         ,
           FUND_DESC        ,BRANCH_CD       ,BRANCH_NAME      ,REF_NO          ,
           CV_DATE          ,COMMV_PREF      ,COMM_VCR_NO      ,PREMIUM_AMT     ,
           COMMISSION_AMT   ,WHOLDING_TAX    ,ADVANCES         ,DISCOUNT        ,
           INPUT_VAT        ,OTHER_CHARGES   ,NOTARIAL_FEE     ,TAX_AMT         ,
           PR_FLAG          ,CPI_REC_NO      ,CPI_BRANCH_CD    ,LAST_UPDATE     ,
           user_ID          ,PRINT_FLAG      ,PRINT_DOC        ,TRANSACTION_TYPE)
        VALUES (
           v_CV_TRAN_ID     ,ja1.INTM_NO      ,ja1.ISS_CD        ,ja1.PREM_SEQ_NO ,
           ja1.INST_NO      ,ja1.GACC_TRAN_ID ,ja1.LINE_CD       ,ja1.SUBLINE_CD  ,
           ja1.ISSUE_YY     ,ja1.POL_SEQ_NO   ,ja1.ENDT_ISS_CD   ,ja1.ENDT_YY     ,
           ja1.ENDT_SEQ_NO  ,ja1.RENEW_NO     ,ja1.ASSD_NO       ,ja1.TRAN_CLASS  ,
           ja1.TRAN_FLAG    ,ja1.TRAN_DATE    ,ja1.COLLECTION_AMT,ja1.FUND_CD     ,
           ja1.FUND_DESC    ,ja1.BRANCH_CD    ,ja1.BRANCH_NAME   ,ja1.REF_NO      ,
           NULL             ,NULL             ,NULL              ,ja1.PREMIUM_AMT ,
           ja1.COMMISSION_AMT,ja1.WHOLDING_TAX,ja1.ADVANCES      ,ja1.DISCOUNT    ,
           ja1.INPUT_VAT    ,ja1.OTHER_CHARGES,ja1.NOTARIAL_FEE  ,ja1.TAX_AMT     ,
           NULL             ,ja1.CPI_REC_NO   ,ja1.CPI_BRANCH_CD ,ja1.LAST_UPDATE ,
           ja1.user_ID      ,NULL             ,NULL              ,ja1.TRANSACTION_TYPE);
         UPDATE GIAC_COMM_VOUCHER
         SET user_ID = NVL (giis_users_pkg.app_user, USER), LAST_UPDATE = SYSDATE, tran_flag = 'D'
         WHERE print_doc = ja1.print_doc
         AND print_flag = '1';
       END LOOP ja1;
     END LOOP ja;
   END IF;
   IF :NEW.OR_FLAG = 'P' THEN
    -- will update giac_comm_voucher with OR NO
    UPDATE GIAC_COMM_VOUCHER
    SET REF_NO = :NEW.OR_PREF_SUF ||'-'|| TO_CHAR(:NEW.OR_NO)
    WHERE GACC_TRAN_ID = :NEW.GACC_TRAN_ID
    AND NVL(PRINT_FLAG,'0') NOT IN ('1','2','3')
    AND cv_tran_id > 0; --added by totel--2/5/2007--for optimization purposes
    /*  FOR COLLECTION OF PREMIUMS AND NEGATIVE ENDORSEMENTS */
    FOR JA1 IN (
      SELECT DISTINCT B140_ISS_CD, B140_PREM_SEQ_NO
      FROM GIAC_DIRECT_PREM_COLLNS
      WHERE GACC_TRAN_ID = :NEW.GACC_TRAN_ID
      AND TRANSACTION_TYPE IN (1,3) ) LOOP
      BEGIN
        SELECT SUM( NVL(BALANCE_AMT_DUE,0))
        INTO V_BALANCE
        FROM GIAC_AGING_SOA_DETAILS
        WHERE ISS_CD = JA1.B140_ISS_CD
        AND PREM_SEQ_NO = JA1.B140_PREM_SEQ_NO;
          IF NVL( V_BALANCE,0) = 0 THEN
             UPDATE GIAC_COMM_VOUCHER
             SET PRINT_DOC = :NEW.OR_PREF_SUF||'-'|| TO_CHAR(:NEW.OR_NO), PR_FLAG = 'N'
             WHERE ISS_CD = JA1.B140_ISS_CD
             AND PREM_SEQ_NO = JA1.B140_PREM_SEQ_NO
             AND PRINT_DOC IS NULL
             AND TRAN_FLAG != 'D'
             AND TRANSACTION_TYPE IN (1,3)
             AND NVL(PRINT_FLAG,'0') NOT IN ('1','2','3','4')
             AND NVL(PR_FLAG,'0') != 'Y'
             AND cv_tran_id > 0; --added by totel--2/5/2007--for optimization purposes
          END IF;
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          RAISE_APPLICATION_ERROR( -20099, 'INVOICE NO HAS NO RECORD IN GIAC_AGING_SOA_DETAILS.');
      END;
    END LOOP JA1;
    /* FOR REFUND OF COLLECTIONS AND NEGATIVE ENDORSEMENTS */
    FOR JA2 IN (
      SELECT B140_ISS_CD, B140_PREM_SEQ_NO
      FROM GIAC_DIRECT_PREM_COLLNS
      WHERE GACC_TRAN_ID = :NEW.GACC_TRAN_ID
      AND transaction_type IN ( 2 , 4)  ) LOOP
      UPDATE GIAC_COMM_VOUCHER
      SET PRINT_DOC = :NEW.OR_PREF_SUF||'-'|| TO_CHAR(:NEW.OR_NO)
      WHERE PR_FLAG = 'N'
      AND iss_cd = ja2.b140_iss_cd
      AND prem_seq_no = ja2.b140_prem_Seq_no
      AND transaction_type IN (2,4)
      AND tran_flag != 'D'
      AND NVL(print_flag,'0') NOT IN ('1','2','3','4');
    END LOOP JA2;
   END IF;
END;
/


