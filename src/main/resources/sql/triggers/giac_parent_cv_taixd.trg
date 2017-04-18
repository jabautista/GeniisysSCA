DROP TRIGGER CPI.GIAC_PARENT_CV_TAIXD;

CREATE OR REPLACE TRIGGER CPI.GIAC_PARENT_CV_TAIXD 
AFTER INSERT OR DELETE ON CPI.GIAC_DIRECT_PREM_COLLNS FOR EACH ROW
DECLARE
 v_rowid              VARCHAR2(40);
BEGIN
 IF INSERTING THEN
  BEGIN --TO CHECK IF DIVISOR IS EQUAL TO ZERO lina 12292005
        FOR C IN ( SELECT PREM_AMT + NVL(OTHER_CHARGES,0) + NVL(NOTARIAL_FEE,0) divisor
                     FROM GIPI_INVOICE
                    WHERE iss_cd = :NEW.B140_ISS_CD
                      AND prem_seq_no = :NEW.b140_prem_seq_no) LOOP
                       IF C.DIVISOR != 0 THEN
        --insert into giac_parent_comm_voucher--
        BEGIN
          FOR rec IN (
            SELECT DISTINCT
                   C.GFUN_FUND_CD,
                   C.GIBR_BRANCH_CD,
                   D.POLICY_ID,
                   f.assd_No,
                   DECODE( E.ENDT_SEQ_NO , 0,
                     SUBSTR(E.LINE_CD ||'-'|| E.SUBLINE_CD||'-'|| E.ISS_CD||'-'||
                     TO_CHAR( E.ISSUE_YY)||'-'|| TO_CHAR( E.POL_SEQ_NO,'FM0000000' )||'-'||
                     TO_CHAR( E.RENEW_NO, 'FM00' ) , 1,37),
                   SUBSTR( E.LINE_CD ||'-'|| E.SUBLINE_CD||'-'|| E.ISS_CD||'-'||
                     TO_CHAR( E.ISSUE_YY)||'-'|| TO_CHAR( E.POL_SEQ_NO , 'FM0000000' ) ||'-'|| E.ENDT_ISS_CD
                     ||'-'|| TO_CHAR( E.ENDT_YY) ||'-'||TO_CHAR( E.ENDT_SEQ_NO, 'FM000000' )||'-'||
                     TO_CHAR( E.RENEW_NO, 'FM00' ), 1,37)) POLICY_NO,
                   A.INTM_NO,
                   A.CHLD_INTM_NO,
                    A.ISS_CD,
                   A.PREM_sEQ_NO,
                   A.COMMISSION_AMT,
                   C.TRAN_DATE,
                   C.TRAN_CLASS,
                   C.TRAN_CLASS_NO,
                   (D.PREM_AMT + NVL(OTHER_CHARGES,0) + NVL(NOTARIAL_FEE,0)) * D.CURRENCY_RT PREM,
                   :NEW.PREMIUM_AMT / ((D.PREM_AMT + NVL(OTHER_CHARGES,0) + NVL(NOTARIAL_FEE,0)) * D.CURRENCY_RT) RATIO,
                   A.COMMISSION_AMT * ( :NEW.PREMIUM_AMT / ((D.PREM_AMT + NVL(OTHER_CHARGES,0) + NVL(NOTARIAL_FEE,0)) * D.CURRENCY_RT)) COMM,
                   A.WHOLDING_TAX * (   :NEW.PREMIUM_AMT / ((D.PREM_AMT + NVL(OTHER_CHARGES,0) + NVL(NOTARIAL_FEE,0)) * D.CURRENCY_RT)) WHOLDING_TAX
              FROM GIAC_PARENT_COMM_INVOICE A,
--                    GIAC_DIRECT_PREM_COLLNS B,
                   GIAC_ACCTRANS C,
                   GIPI_INVOICE  D,
                   GIPI_POLBASIC E,
                   GIPI_PARLIST  f
              WHERE A.ISS_CD = :NEW.B140_ISS_CD
                AND A.PREM_SEQ_NO = :NEW.B140_PREM_SEQ_NO
                AND :NEW.GACC_TRAN_ID = C.TRAN_ID
                AND A.ISS_CD = D.ISS_CD
                AND A.PREM_SEQ_NO = D.PREM_SEQ_NO
                AND D.POLICY_ID = E.POLICY_ID
                AND e.par_id = f.par_id       ) LOOP
              INSERT INTO GIAC_PARENT_COMM_VOUCHER
                 (GFUN_FUND_CD     ,GIBR_BRANCH_CD    ,GACC_TRAN_ID      ,POLICY_ID         ,
                 POLICY_NO         ,INTM_NO           ,ISS_CD            ,PREM_SEQ_NO       ,
                 INST_NO           ,COMMISSION_AMT    ,TRANSACTION_TYPE  ,COLLECTION_AMT    ,
                 PREMIUM_AMT       ,TAX_AMT           ,TRAN_DATE         ,TRAN_CLASS        ,
                 TRAN_CLASS_NO     ,TOTAL_PREM        ,RATIO             ,COMMISSION_DUE    ,
                 PRINT_TAG         ,PRINT_DATE        ,CHLD_INTM_NO      ,INPUT_VAT         ,
                 ADVANCES          ,WITHHOLDING_TAX   ,ASSD_NO           ,OCV_PREF_SUF      ,
                 CANCEL_TAG)
              VALUES
                 (rec.GFUN_FUND_CD ,rec.GIBR_BRANCH_CD,:NEW.GACC_TRAN_ID ,rec.POLICY_ID     ,
                 rec.POLICY_NO    ,rec.INTM_NO       ,:NEW.b140_ISS_CD   ,:NEW.b140_PREM_sEQ_NO   ,
                 :NEW.INST_NO      ,rec.COMMISSION_AMT,:NEW.TRANSACTION_TYPE,:NEW.COLLECTION_AMT,
                 :NEW.PREMIUM_AMT ,:NEW.TAX_AMT     ,rec.TRAN_DATE      ,rec.TRAN_CLASS    ,
                 rec.TRAN_CLASS_NO,rec.PREM          ,rec.RATIO         ,rec.COMM          ,
                 'N'              ,NULL              ,rec.CHLD_INTM_NO  ,0                 ,
                 0                ,rec.WHOLDING_TAX  ,rec.ASSD_NO       ,NULL              ,
                 'N');
          END LOOP;
        END;
          END IF;
        END LOOP;
  END;
 ELSIF DELETING THEN
    --allow to delete if print_date is null only--meaning C.V. not yet printed--
    BEGIN
      DELETE FROM GIAC_PARENT_COMM_VOUCHER
      WHERE gacc_tran_id = :OLD.gacc_tran_id
        AND iss_cd = :OLD.b140_iss_cd
        AND prem_Seq_no = :OLD.b140_prem_seq_no
        AND inst_no = :OLD.inst_no
        AND transaction_type = :OLD.transaction_type
        AND print_date IS NULL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END ;
    BEGIN
      UPDATE GIAC_PARENT_COMM_VOUCHER
        SET cancel_tag = 'Y'
        WHERE gacc_tran_id = :OLD.gacc_tran_id
        AND iss_cd = :OLD.b140_iss_cd
        AND prem_Seq_no = :OLD.b140_prem_seq_no
        AND inst_no = :OLD.inst_no
        AND transaction_type = :OLD.transaction_type
        AND print_date IS NOT NULL;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        NULL;
    END ;
 END IF;
END;
/


