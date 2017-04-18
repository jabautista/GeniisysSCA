CREATE OR REPLACE PACKAGE BODY GIACR601_CSV_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 10.11.2016
   **  Reference By : (GIACR601- CONVERTED FILES FOR UPLOADING)
   **  Description  : PRINTING OF CSV REPORT
   */
   FUNCTION GIACR601_TRAN1_A (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE
   )
        RETURN GIACR601_TRAN1_A_TAB PIPELINED
   AS
        v_rec           GIACR601_TRAN1_A_TYPE; 
   BEGIN                                       
        FOR x IN (SELECT A.SOURCE_CD, 
                         B.SOURCE_NAME SOURCE, 
                         A.TRANSACTION_TYPE,
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION, 
                         A.FILE_NO,                          
                         A.FILE_NAME,                     
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,    
                         B.ATM_TAG,
                         A.RI_CD 
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD
                     AND TRUNC(A.CONVERT_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.CONVERT_DATE)) AND NVL(P_TO_DATE,TRUNC(A.CONVERT_DATE))      
                     AND A.TRANSACTION_TYPE = 1   
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)   
                     AND B.ATM_TAG = 'N'                           
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.FILE_NO             := x.FILE_NO;            
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;
            v_rec.FILE_STATUS         := x.FILE_STATUS; 
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;                         
                       
            FOR y IN (SELECT A.PAYOR, 
                             A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||LTRIM(TO_CHAR(A.ISSUE_YY, '09'))||'-'||
                               LTRIM (TO_CHAR (A.POL_SEQ_NO, '0999999'))||'-'||LTRIM (TO_CHAR (A.RENEW_NO, '09')) POLICY_NO,
                             A.COLLECTION_AMT,        
                             B.PAY_MODE, 
                             B.BANK,
                             B.CHECK_CLASS,
                             B.CHECK_NO,
                             B.CHECK_DATE,
                             B.COLLECTION_AMT AMOUNT, 
                             A.PREM_CHK_FLAG||'-'||A.CHK_REMARKS  CHECK_RESULTS,      
                             A.SOURCE_CD,        
                             A.FILE_NO               		                               
                        FROM GIAC_UPLOAD_PREM A, GIAC_UPLOAD_PREM_DTL B
                       WHERE A.SOURCE_CD = B.SOURCE_CD
                         AND A.FILE_NO = B.FILE_NO
                         AND A.LINE_CD = B.LINE_CD
                         AND A.SUBLINE_CD = B.SUBLINE_CD 
                         AND A.ISS_CD = B.ISS_CD
                         AND A.ISSUE_YY = B.ISSUE_YY
                         AND A.POL_SEQ_NO = B.POL_SEQ_NO
                         AND A.RENEW_NO = B.RENEW_NO
                         AND A.PAYOR = B.PAYOR     
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO    
                     )       
            LOOP                           
                v_rec.PAYOR               := y.PAYOR; 
                v_rec.POLICY_NO           := y.POLICY_NO;
                v_rec.COLLECTION_AMT      := y.COLLECTION_AMT;        
                v_rec.PAY_MODE            := y.PAY_MODE; 
                v_rec.BANK                := y.BANK;
                v_rec.CHECK_CLASS         := y.CHECK_CLASS;
                v_rec.CHECK_NO            := y.CHECK_NO;
                v_rec.CHECK_DATE          := y.CHECK_DATE;
                v_rec.AMOUNT              := y.AMOUNT; 
                v_rec.CHECK_RESULTS       := y.CHECK_RESULTS;                  
                                      
                PIPE ROW (v_rec);                          
            END LOOP;                    
        END LOOP;             
   END GIACR601_TRAN1_A;    
   FUNCTION GIACR601_TRAN1_B (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE
   )
        RETURN GIACR601_TRAN1_B_TAB PIPELINED
   AS
        v_rec           GIACR601_TRAN1_B_TYPE; 
   BEGIN                                  
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,                         
                         A.FILE_NAME,                       
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD       
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD
                     AND TRUNC(A.CONVERT_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.CONVERT_DATE)) AND NVL(P_TO_DATE,TRUNC(A.CONVERT_DATE))      
                     AND A.TRANSACTION_TYPE = 1   
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+) 
                     AND B.ATM_TAG = 'Y'                                  
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.FILE_NO             := x.FILE_NO;            
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;
            v_rec.FILE_STATUS         := x.FILE_STATUS; 
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;                                                           

            FOR y IN (SELECT A.PAYOR, 
                             A.BILL_NO ATM_NUMBER,
                             A.COLLECTION_AMT,
                             B.PAY_MODE, 
                             B.BANK, 
                             B.CHECK_CLASS, 
                             B.CHECK_NO, 
                             B.CHECK_DATE, 
                             B.COLLECTION_AMT AMOUNT,
                             A.PREM_CHK_FLAG||'-'||A.CHK_REMARKS  CHECK_RESULTS,		   
                             A.SOURCE_CD, 
                             A.FILE_NO
                        FROM GIAC_UPLOAD_PREM_ATM A, GIAC_UPLOAD_PREM_ATM_DTL B
                       WHERE A.SOURCE_CD = B.SOURCE_CD
                         AND A.FILE_NO = B.FILE_NO
                         AND TO_CHAR(A.BILL_NO) = B.BILL_NO
                         AND A.PAYOR = B.PAYOR
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO    
                     )
            LOOP
                v_rec.PAYOR               := y.PAYOR; 
                v_rec.ATM_NO              := y.ATM_NUMBER;
                v_rec.COLLECTION_AMT      := y.COLLECTION_AMT;        
                v_rec.PAY_MODE            := y.PAY_MODE; 
                v_rec.BANK                := y.BANK;
                v_rec.CHECK_CLASS         := y.CHECK_CLASS;
                v_rec.CHECK_NO            := y.CHECK_NO;
                v_rec.CHECK_DATE          := y.CHECK_DATE;
                v_rec.AMOUNT              := y.AMOUNT; 
                v_rec.CHECK_RESULTS       := y.CHECK_RESULTS;        
                          
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;
   END GIACR601_TRAN1_B;  
   FUNCTION GIACR601_TRAN2 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE 
   )
        RETURN GIACR601_TRAN2_TAB PIPELINED
   AS
        v_rec           GIACR601_TRAN2_TYPE; 
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         C.INTM_TYPE || '-' || A.INTM_NO || '/' || C.REF_INTM_CD || '/' || C.INTM_NAME INTERMEDIARY,                          
                         A.FILE_NAME,                      
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD       
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD
                     AND TRUNC(A.CONVERT_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.CONVERT_DATE)) AND NVL(P_TO_DATE,TRUNC(A.CONVERT_DATE))      
                     AND A.TRANSACTION_TYPE = 2
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)                                 
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.INTERMEDIARY        := x.INTERMEDIARY;            
            v_rec.FILE_NO             := x.FILE_NO;            
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;
            v_rec.FILE_STATUS         := x.FILE_STATUS; 
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;  
               
            FOR i IN (SELECT B.PAYOR,
                             B.LINE_CD||'-'||B.SUBLINE_CD||'-'||B.ISS_CD||'-'||LTRIM(TO_CHAR(B.ISSUE_YY, '09'))||'-'||
                             LTRIM (TO_CHAR (B.POL_SEQ_NO, '0999999'))||'-'||LTRIM (TO_CHAR (B.RENEW_NO, '09'))||
                             DECODE (
                                     NVL (B.ENDT_SEQ_NO, 0),
                                     0, '',
                                        ' / '
                                     || B.ENDT_ISS_CD
                                     || '-'
                                     || LTRIM (TO_CHAR (B.ENDT_YY, '09'))
                                     || '-'
                                     || LTRIM (TO_CHAR (B.ENDT_SEQ_NO, '0999999'))
                                    ) POLICY_NO,                               
                             B.GROSS_PREM_AMT GROSS_PREMIUM,
                             B.COMM_AMT COMMISSION,
                             B.WHTAX_AMT WITHHOLDING_TAX,
                             B.INPUT_VAT_AMT INPUT_VAT,
                             B.NET_AMT_DUE,
                             B.PREM_CHK_FLAG||'/'||B.COMM_CHK_FLAG||'-'||B.CHK_REMARKS CHECK_RESULTS,
                             A.SOURCE_CD, 
                             A.FILE_NO,  
                             B.ENDT_SEQ_NO             
                        FROM GIAC_UPLOAD_FILE A, GIAC_UPLOAD_PREM_COMM B
                       WHERE A.SOURCE_CD = B.SOURCE_CD
                         AND A.FILE_NO = B.FILE_NO  
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO    
                     )
            LOOP
                v_rec.PAYOR               := i.PAYOR;
                v_rec.POLICY_NO           := i.POLICY_NO;
                v_rec.GROSS_PREMIUM       := i.GROSS_PREMIUM;
                v_rec.COMMISSION          := i.COMMISSION;
                v_rec.WITHHOLDING_TAX     := i.WITHHOLDING_TAX;
                v_rec.INPUT_VAT           := i.INPUT_VAT;
                v_rec.NET_AMT_DUE         := i.NET_AMT_DUE;
                v_rec.ENDT_SEQ_NO         := i.ENDT_SEQ_NO;                
                v_rec.CHECK_RESULTS       := i.CHECK_RESULTS;                        
                                                                                                   
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;            
   END GIACR601_TRAN2;   
   FUNCTION GIACR601_TRAN3 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE 
   )
        RETURN GIACR601_TRAN3_TAB PIPELINED
   AS
        v_rec           GIACR601_TRAN3_TYPE; 
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,                       
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD       
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD
                     AND TRUNC(A.CONVERT_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.CONVERT_DATE)) AND NVL(P_TO_DATE,TRUNC(A.CONVERT_DATE))      
                     AND A.TRANSACTION_TYPE = 3
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)                                 
                 )   
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.CEDING_COMPANY      := x.CEDING_COMPANY;
            v_rec.FILE_NO             := x.FILE_NO;            
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;
            v_rec.FILE_STATUS         := x.FILE_STATUS; 
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;                   
   
            FOR i IN (SELECT B.ASSURED,
                             B.LINE_CD||'-'||B.SUBLINE_CD||'-'||ISS_CD||'-'||LTRIM(TO_CHAR(ISSUE_YY, '09'))||'-'||LTRIM(TO_CHAR(POL_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(RENEW_NO, '09')) POLICY_NO,
                             B.FPREM_AMT PREMIUM,
                             B.FTAX_AMT VAT_ON_PREM,        
                             B.FCOMM_AMT RI_COMMISSION,
                             B.FCOMM_VAT VAT_ON_COMM,      
                             B.FCOLLECTION_AMT NET_DUE,      
                             B.PREM_CHK_FLAG||' - '||B.CHK_REMARKS CHECK_RESULTS,                     
                             A.CURRENCY_DESC CURRENCY,
                             B.CONVERT_RATE, 
                             B.SOURCE_CD,
                             B.FILE_NO
                        FROM GIIS_CURRENCY A, GIAC_UPLOAD_INWFACUL_PREM B       
                       WHERE A.MAIN_CURRENCY_CD = B.CURRENCY_CD
                         AND B.SOURCE_CD = x.SOURCE_CD       
                         AND B.FILE_NO = x.FILE_NO            
                     )
            LOOP
                v_rec.CONVERT_RATE        := i.CONVERT_RATE;                
                v_rec.CHECK_RESULTS       := i.CHECK_RESULTS;              
                v_rec.ASSURED             := i.ASSURED;
                v_rec.POLICY_NO           := i.POLICY_NO;
                v_rec.PREMIUM             := i.PREMIUM;
                v_rec.VAT_ON_PREM         := i.VAT_ON_PREM;
                v_rec.RI_COMMISSION       := i.RI_COMMISSION;
                v_rec.VAT_ON_COMM         := i.VAT_ON_COMM;
                v_rec.NET_DUE             := i.NET_DUE;
                v_rec.CURRENCY            := i.CURRENCY;                      
                            
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;           
   END GIACR601_TRAN3;      
   FUNCTION GIACR601_TRAN4 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE 
   )
        RETURN GIACR601_TRAN4_TAB PIPELINED
   AS
        v_rec           GIACR601_TRAN4_TYPE; 
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,                      
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD       
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD
                     AND TRUNC(A.CONVERT_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.CONVERT_DATE)) AND NVL(P_TO_DATE,TRUNC(A.CONVERT_DATE))      
                     AND A.TRANSACTION_TYPE = 4
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)                                 
                 )   
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.REINSURER           := x.CEDING_COMPANY;
            v_rec.FILE_NO             := x.FILE_NO;            
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;
            v_rec.FILE_STATUS         := x.FILE_STATUS; 
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;     
   
            FOR i IN (SELECT B.CURRENCY_DESC CURRENCY, 
                             A.CONVERT_RATE,
                             A.LINE_CD||'-'||LTRIM(TO_CHAR(A.BINDER_YY, '09'))||'-'||LTRIM(TO_CHAR(A.BINDER_SEQ_NO, '0999999')) BINDER_NO,
                             A.FPREM_AMT PREMIUM, 
                             A.FPREM_VAT VAT_ON_PREM, 
                             A.FCOMM_AMT RI_COMMISSION, 
                             A.FCOMM_VAT VAT_ON_COMM, 
                             A.FWHOLDING_VAT WITHHOLDING_VAT, 
                             A.FDISB_AMT NET_DUE,       
                             A.PREM_CHK_FLAG||' - '||A.CHK_REMARKS CHECK_RESULTS,        
                             A.SOURCE_CD,
                             A.FILE_NO
                        FROM GIAC_UPLOAD_OUTFACUL_PREM A, GIIS_CURRENCY B
                       WHERE B.MAIN_CURRENCY_CD = A.CURRENCY_CD
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO                                                           
                     )
            LOOP
                v_rec.CURRENCY            := i.CURRENCY;
                v_rec.CONVERT_RATE        := i.CONVERT_RATE;                        
                v_rec.BINDER_NO             := i.BINDER_NO;
                v_rec.PREMIUM             := i.PREMIUM;
                v_rec.VAT_ON_PREM         := i.VAT_ON_PREM;
                v_rec.RI_COMMISSION       := i.RI_COMMISSION;
                v_rec.VAT_ON_COMM         := i.VAT_ON_COMM;
                v_rec.WITHHOLDING_VAT         := i.WITHHOLDING_VAT;
                v_rec.NET_DUE             := i.NET_DUE;
                v_rec.CHECK_RESULTS       := i.CHECK_RESULTS;      
                         
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;
   END GIACR601_TRAN4;    
   FUNCTION GIACR601_TRAN5 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE 
   )
        RETURN GIACR601_TRAN5_TAB PIPELINED
   AS
        v_rec           GIACR601_TRAN5_TYPE; 
   BEGIN
        FOR x IN (SELECT A.SOURCE_CD, 
                         B.SOURCE_NAME SOURCE, 
                         A.TRANSACTION_TYPE,
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION, 
                         A.FILE_NO,                          
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,    
                         B.ATM_TAG,
                         A.RI_CD 
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD
                     AND TRUNC(A.CONVERT_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.CONVERT_DATE)) AND NVL(P_TO_DATE,TRUNC(A.CONVERT_DATE))      
                     AND A.TRANSACTION_TYPE = 5   
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)                          
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.FILE_NO             := x.FILE_NO;            
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.DEPOSIT_DATE        := x.DEPOSIT_DATE;  
            v_rec.CONVERT_DATE        := x.CONVERT_DATE;            
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;
            v_rec.FILE_STATUS         := x.FILE_STATUS; 
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;  
               
            FOR i IN (SELECT B.PAYOR,
                             B.BANK_REF_NO,      
                             B.COLLECTION_AMT,
                             B.PREM_CHK_FLAG || '-' || B.CHK_REMARKS CHECK_RESULTS,
                             A.SOURCE_CD,
                             A.FILE_NO
                        FROM GIAC_UPLOAD_FILE A, GIAC_UPLOAD_PREM_REFNO B
                       WHERE A.SOURCE_CD = B.SOURCE_CD
                         AND A.FILE_NO = B.FILE_NO
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO        
                     )
            LOOP
                v_rec.PAYOR               := i.PAYOR;
                v_rec.BANK_REF_NO         := i.BANK_REF_NO;
                v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;
                v_rec.CHECK_RESULTS       := i.CHECK_RESULTS;
                v_rec.SOURCE_CD           := i.SOURCE_CD;
                v_rec.FILE_NO             := i.FILE_NO;
                          
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;    
   END GIACR601_TRAN5;      
END GIACR601_CSV_PKG; 
/