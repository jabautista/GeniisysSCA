CREATE OR REPLACE PACKAGE BODY GIACR602A_CSV_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 10.13.2016
   **  Reference By : (GIACR602A - CONVERTED BUT NOT UPLOADED RECORDS)
   **  Description  : PRINTING OF CSV REPORT
   */
   FUNCTION GIACR602A (
        P_SOURCE_CD         GIAC_UPLOAD_PREM_REFNO.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_PREM_REFNO.UPLOAD_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_PREM_REFNO.UPLOAD_DATE%TYPE
   )
        RETURN GIACR602A_TAB PIPELINED
   AS
        v_rec           GIACR602A_TYPE;      
   BEGIN
        FOR i IN (SELECT C.SOURCE_CD,
                         C.SOURCE_NAME,
                         TRUNC(A.UPLOAD_DATE) UPLOAD_DATE,
                         A.UPLOAD_NO BATCH_NO,
                         A.PAYOR,
                         A.BANK_REF_NO,
                         A.FILE_NO,
                         B.FILE_NAME,
                         D.TRAN_CLASS,
                         CONCAT(E.OR_PREF_SUF,E.OR_NO) REF_NO,
                         E.PARTICULARS,
                         A.COLLECTION_AMT
                   FROM GIAC_UPLOAD_PREM_REFNO A,
                        GIAC_UPLOAD_FILE B,
                        GIAC_FILE_SOURCE C,
                        GIAC_ACCTRANS D,
                        GIAC_ORDER_OF_PAYTS E
                  WHERE A.SOURCE_CD = B.SOURCE_CD 
                    AND A.FILE_NO = B.FILE_NO
                    AND A.SOURCE_CD = C.SOURCE_CD
                    AND A.TRAN_ID = D.TRAN_ID
                    AND A.TRAN_ID = E.GACC_TRAN_ID
                    AND B.TRANSACTION_TYPE = '5'
                    AND A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                    AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))                          
                 )
        LOOP
            v_rec.SOURCE_CD           := i.SOURCE_CD;
            v_rec.SOURCE_NAME         := i.SOURCE_NAME;
            v_rec.UPLOAD_DATE         := i.UPLOAD_DATE;            
            v_rec.BATCH_NO            := i.BATCH_NO;
            v_rec.PAYOR               := i.PAYOR;
            v_rec.BANK_REF_NO         := i.BANK_REF_NO;
            v_rec.FILE_NO             := i.FILE_NO;               
            v_rec.FILE_NAME           := i.FILE_NAME;
            v_rec.TRAN_CLASS          := i.TRAN_CLASS;    
            v_rec.REF_NO              := i.REF_NO;        
            v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;                    
            v_rec.PARTICULARS         := i.PARTICULARS;                                                      
                      
            PIPE ROW (v_rec);
        END LOOP;
   END GIACR602A;
END GIACR602A_CSV_PKG; 
/