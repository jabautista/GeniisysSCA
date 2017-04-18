CREATE OR REPLACE PACKAGE BODY GIACR601A_CSV_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 10.11.2016
   **  Reference By : (GIACR601A-  LIST OF SUNDRY CREDIT)
   **  Description  : PRINTING OF CSV REPORT
   */
   FUNCTION GIACR601A (
        P_AS_OF_DATE        GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE
   )
        RETURN GIACR601A_TAB PIPELINED
   AS
        v_rec           GIACR601A_TYPE;                      
   BEGIN
        FOR i IN (SELECT B.SOURCE_NAME SOURCE,
                        A.TRANSACTION_TYPE,        
                        (SELECT E.RV_MEANING
                           FROM CG_REF_CODES E 
                          WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                            AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                        C.PAYOR, 
                        C.BANK_REF_NO,     
                        A.FILE_NAME,        
                        A.PAYMENT_DATE DEPOSIT_DATE, 
                        A.CONVERT_DATE CONVERT_DATE, 
                        C.COLLECTION_AMT,       
                        C.PREM_CHK_FLAG||'-'||C.CHK_REMARKS CHECK_RESULTS,	                 
                        A.SOURCE_CD, 
                        A.FILE_NO
                 FROM GIAC_UPLOAD_FILE A,
                      GIAC_FILE_SOURCE B,
                      GIAC_UPLOAD_PREM_REFNO C      
                 WHERE A.SOURCE_CD = B. SOURCE_CD
                 AND A.SOURCE_CD = C.SOURCE_CD
                 AND A.FILE_NO = C.FILE_NO
                 AND A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                 AND TRUNC(A.CONVERT_DATE) <= NVL(P_AS_OF_DATE,TRUNC(A.CONVERT_DATE))
                 AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)
                 AND A.TRANSACTION_TYPE = '5'
                 AND A.FILE_STATUS NOT IN ('1', 'C')
                 AND C.UPLOAD_DATE IS NULL
                 AND A.UPLOAD_DATE IS NOT NULL                           
                 )
        LOOP         
            v_rec.SOURCE_CD           := i.SOURCE_CD; 
            v_rec.SOURCE              := i.SOURCE;
            v_rec.TRAN_TYPE           := i.TRANSACTION_TYPE; 
            v_rec.TRANSACTION         := i.TRANSACTION;          
            v_rec.PAYOR               := i.PAYOR; 
            v_rec.BANK_REF_NO         := i.BANK_REF_NO;
            v_rec.FILE_NO             := i.FILE_NO;              
            v_rec.FILE_NAME           := i.FILE_NAME;
            v_rec.DEPOSIT_DATE        := i.DEPOSIT_DATE;  
            v_rec.CONVERT_DATE        := i.CONVERT_DATE;
            v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;
            v_rec.CHECK_RESULTS       := i.CHECK_RESULTS;                                    
                      
            PIPE ROW (v_rec);
        END LOOP;     
   END GIACR601A;             
END GIACR601A_CSV_PKG; 
/