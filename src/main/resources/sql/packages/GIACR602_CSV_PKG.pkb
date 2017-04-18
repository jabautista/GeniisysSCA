CREATE OR REPLACE PACKAGE BODY GIACR602_CSV_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 04.27.2015
   **  Reference By : (GIACR602-  LIST OF UPLOADED FILES)
   **  Description  : POPULATE LIST OF UPLOADED FILES REPORT
   */
   FUNCTION GIACR602_TRAN1_A (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE
   )
        RETURN GIACR602_TRAN1_A_TAB PIPELINED
   AS
        v_rec               GIACR602_TRAN1_A_TYPE; 
        v_ref_no            VARCHAR(50);
        v_pref              VARCHAR(10);
        v_temp_no           NUMBER(38);
        v_particulars       VARCHAR2 (2100);
        v_tran_id           NUMBER(38);        
   BEGIN                                                           
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         C.INTM_TYPE || '-' || A.INTM_NO || '/' || C.REF_INTM_CD || '/' || C.INTM_NAME INTERMEDIARY, 
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD,       
                         A.TRAN_CLASS, 
                         A.TRAN_ID,
                         A.INTM_NO                            
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD     
                     AND A.TRANSACTION_TYPE = 1  
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)      
                     AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))        
                     AND B.ATM_TAG = 'N'                  
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.FILE_NO             := x.FILE_NO;
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.CONVERT_DATE        := x.CONVERT_DATE;      
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;                  
            v_rec.FILE_STATUS         := x.FILE_STATUS;
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;
            v_rec.TRAN_CLASS          := x.TRAN_CLASS;
            v_rec.TRAN_ID             := x.TRAN_ID;
            v_rec.INTM_NO             := x.INTM_NO;                                        
                      
            FOR i IN (SELECT PAYOR, 
                             LINE_CD||'-'||SUBLINE_CD||'-'||ISS_CD||'-'||LTRIM(TO_CHAR(ISSUE_YY, '09'))||'-'||
                             LTRIM (TO_CHAR (POL_SEQ_NO, '0999999'))||'-'||LTRIM (TO_CHAR (RENEW_NO, '09')) POLICY_NO, 
                             COLLECTION_AMT,
                             TRAN_ID
                        FROM GIAC_UPLOAD_PREM 
                       WHERE SOURCE_CD = x.SOURCE_CD
                         AND FILE_NO = x.FILE_NO   
                     )
            LOOP
                v_rec.PAYOR               := i.PAYOR; 
                v_rec.POLICY_NO           := i.POLICY_NO;
                v_rec.TRAN_CLASS          := x.TRAN_CLASS;
                v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;
                
                IF x.TRAN_CLASS = 'JV' THEN        		
                    BEGIN 		
                        SELECT A.JV_NO, A.TRAN_CLASS, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars 
                          FROM GIAC_ACCTRANS A
                         WHERE A.TRAN_ID = x.TRAN_ID;              

                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no :=NULL;  
                        END IF; 
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;   
                              
                ELSIF x.TRAN_CLASS = 'DV' THEN            		
                    BEGIN      		
                        SELECT A.DV_NO, A.DV_PREF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_DISB_VOUCHERS A
                         WHERE A.GACC_TRAN_ID = x.TRAN_ID;
                         
                        IF  v_temp_no IS NULL THEN
                            SELECT A.DOCUMENT_CD||'-'||A.BRANCH_CD||'-'||A.DOC_YEAR||'-'||A.DOC_MM||'-'||A.DOC_SEQ_NO
                              INTO v_ref_no 
                              FROM GIAC_PAYT_REQUESTS A, GIAC_PAYT_REQUESTS_DTL B
                             WHERE A.REF_ID = B.GPRQ_REF_ID
                               AND B.TRAN_ID = x.TRAN_ID;                        
                        ELSE
                            v_ref_no := v_pref|| '-' ||TO_CHAR(v_temp_no);                
                        END IF;
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;                           
                    
                ELSIF x.TRAN_CLASS = 'COL' THEN               	               
                    BEGIN
                        SELECT DISTINCT A.OR_NO, A.OR_PREF_SUF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;               
                         
                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no := NULL; 
                        END IF;

                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;                     
                           
                    END;                  
                    
                ELSE
                    v_ref_no :=NULL;  
                                               
                END IF;     
                
                v_rec.REF_NO              := v_ref_no;
                v_rec.PARTICULARS         := v_particulars;     
                 
                PIPE ROW (v_rec);                
            END LOOP;
        END LOOP;
   END GIACR602_TRAN1_A;    
   FUNCTION GIACR602_TRAN1_B (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE
   )
        RETURN GIACR602_TRAN1_B_TAB PIPELINED
   AS
        v_rec               GIACR602_TRAN1_B_TYPE; 
        v_ref_no            VARCHAR(50);
        v_pref              VARCHAR(10);
        v_temp_no           NUMBER(38);
        v_particulars       VARCHAR2 (2100);        
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD,       
                         A.TRAN_CLASS, 
                         A.TRAN_ID,
                         A.INTM_NO                            
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD     
                     AND A.TRANSACTION_TYPE = 1  
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)      
                     AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))        
                     AND B.ATM_TAG = 'Y'                  
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.FILE_NO             := x.FILE_NO;
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.CONVERT_DATE        := x.CONVERT_DATE;      
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;                  
            v_rec.FILE_STATUS         := x.FILE_STATUS;
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;
            v_rec.TRAN_CLASS          := x.TRAN_CLASS;
            v_rec.TRAN_ID             := x.TRAN_ID;
            v_rec.INTM_NO             := x.INTM_NO;
                 
            FOR i IN (SELECT PAYOR,
                             BILL_NO ATM_NUMBER,
                             COLLECTION_AMT,
                             TRAN_ID
                        FROM GIAC_UPLOAD_PREM_ATM
                       WHERE SOURCE_CD = x.SOURCE_CD
                         AND FILE_NO = x.FILE_NO     
                    ORDER BY COLLECTION_AMT
                     )
            LOOP
                v_rec.PAYOR               := i.PAYOR; 
                v_rec.ATM_NUMBER          := i.ATM_NUMBER;
                v_rec.TRAN_CLASS          := x.TRAN_CLASS;
                v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;
                          
                IF x.TRAN_CLASS = 'JV' THEN        		
                    BEGIN 		
                        SELECT A.JV_NO, A.TRAN_CLASS, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars 
                          FROM GIAC_ACCTRANS A
                         WHERE A.TRAN_ID = x.TRAN_ID;              

                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no :=NULL;  
                        END IF; 
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;   
                              
                ELSIF x.TRAN_CLASS = 'DV' THEN            		
                    BEGIN      		
                        SELECT A.DV_NO, A.DV_PREF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_DISB_VOUCHERS A
                         WHERE A.GACC_TRAN_ID = x.TRAN_ID;
                         
                        IF  v_temp_no IS NULL THEN
                            SELECT A.DOCUMENT_CD||'-'||A.BRANCH_CD||'-'||A.DOC_YEAR||'-'||A.DOC_MM||'-'||A.DOC_SEQ_NO
                              INTO v_ref_no 
                              FROM GIAC_PAYT_REQUESTS A, GIAC_PAYT_REQUESTS_DTL B
                             WHERE A.REF_ID = B.GPRQ_REF_ID
                               AND B.TRAN_ID = x.TRAN_ID;                        
                        ELSE
                            v_ref_no := v_pref|| '-' ||TO_CHAR(v_temp_no);                
                        END IF;
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;                           
                    
                ELSIF x.TRAN_CLASS = 'COL' THEN   
                    BEGIN
                        SELECT DISTINCT A.OR_NO, A.OR_PREF_SUF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM_ATM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;               
                         
                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no := NULL; 
                        END IF;

                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;                     
                           
                    END;                 
                    
                ELSE
                    v_ref_no :=NULL;  
                                               
                END IF;     
                
                v_rec.REF_NO              := v_ref_no;
                v_rec.PARTICULARS         := v_particulars;     
                 
                PIPE ROW (v_rec);            
            END LOOP;
        END LOOP;        
   END GIACR602_TRAN1_B;  
   FUNCTION GIACR602_TRAN2 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE 
   )
        RETURN GIACR602_TRAN2_TAB PIPELINED
   AS
        v_rec               GIACR602_TRAN2_TYPE; 
        v_ref_no            VARCHAR(50);
        v_pref              VARCHAR(10);
        v_temp_no           NUMBER(38);
        v_particulars       VARCHAR2 (2100);           
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         C.INTM_TYPE || '-' || A.INTM_NO || '/' || C.REF_INTM_CD || '/' || C.INTM_NAME INTERMEDIARY, 
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD,       
                         A.TRAN_CLASS, 
                         A.TRAN_ID,
                         A.INTM_NO                            
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD     
                     AND A.TRANSACTION_TYPE = 2  
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)      
                     AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))                         
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.INTERMEDIARY        := x.INTERMEDIARY;            
            v_rec.FILE_NO             := x.FILE_NO;
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.CONVERT_DATE        := x.CONVERT_DATE;      
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;                  
            v_rec.FILE_STATUS         := x.FILE_STATUS;
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;
            v_rec.TRAN_CLASS          := x.TRAN_CLASS;
            v_rec.TRAN_ID             := x.TRAN_ID;
            v_rec.INTM_NO             := x.INTM_NO;                  
   
            FOR i IN (SELECT PAYOR, 
                             LINE_CD||'-'||SUBLINE_CD||'-'||ISS_CD||'-'||LTRIM(TO_CHAR(ISSUE_YY, '09'))||'-'||
                             LTRIM (TO_CHAR (POL_SEQ_NO, '0999999'))||'-'||LTRIM (TO_CHAR (RENEW_NO, '09')) POLICY_NO, 
                             GROSS_PREM_AMT GROSS_PREMIUM, 
                             COMM_AMT COMMISSION, 
                             WHTAX_AMT WITHHOLDING_TAX, 
                             INPUT_VAT_AMT INPUT_VAT, 
                             GROSS_PREM_AMT-(COMM_AMT-WHTAX_AMT+INPUT_VAT_AMT) NET_AMT_DUE,
                             TRAN_ID 
                        FROM GIAC_UPLOAD_PREM_COMM
                       WHERE SOURCE_CD = x.SOURCE_CD
                         AND FILE_NO = x.FILE_NO 
                     )
            LOOP
                v_rec.PAYOR               := i.PAYOR;
                v_rec.POLICY_NO           := i.POLICY_NO;
                v_rec.TRAN_CLASS          := x.TRAN_CLASS;
                
                IF x.TRAN_CLASS = 'JV' THEN        		
                    BEGIN 		
                        SELECT A.JV_NO, A.TRAN_CLASS, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars 
                          FROM GIAC_ACCTRANS A
                         WHERE A.TRAN_ID = x.TRAN_ID;              

                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no :=NULL;  
                        END IF; 
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;   
                              
                ELSIF x.TRAN_CLASS = 'DV' THEN            		
                    BEGIN      		
                        SELECT A.DV_NO, A.DV_PREF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_DISB_VOUCHERS A
                         WHERE A.GACC_TRAN_ID = x.TRAN_ID;
                         
                        IF  v_temp_no IS NULL THEN
                            SELECT A.DOCUMENT_CD||'-'||A.BRANCH_CD||'-'||A.DOC_YEAR||'-'||A.DOC_MM||'-'||A.DOC_SEQ_NO
                              INTO v_ref_no 
                              FROM GIAC_PAYT_REQUESTS A, GIAC_PAYT_REQUESTS_DTL B
                             WHERE A.REF_ID = B.GPRQ_REF_ID
                               AND B.TRAN_ID = x.TRAN_ID;                        
                        ELSE
                            v_ref_no := v_pref|| '-' ||TO_CHAR(v_temp_no);                
                        END IF;
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;                            
                    
                ELSIF x.TRAN_CLASS = 'COL' THEN               	               
                    BEGIN
                        SELECT DISTINCT A.OR_NO, A.OR_PREF_SUF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM_COMM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;               
                         
                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no := NULL; 
                        END IF;

                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;                     
                           
                    END;                 
                    
                ELSE
                    v_ref_no := NULL;  
                                               
                END IF;     
                
                v_rec.REF_NO              := v_ref_no;
                v_rec.PARTICULARS         := v_particulars; 
                v_rec.GROSS_PREMIUM       := i.GROSS_PREMIUM;
                v_rec.COMMISSION          := i.COMMISSION;
                v_rec.WITHHOLDING_TAX     := i.WITHHOLDING_TAX;
                v_rec.INPUT_VAT           := i.INPUT_VAT;
                v_rec.NET_AMT_DUE         := i.NET_AMT_DUE;
                                                                                                   
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;
   END GIACR602_TRAN2;   
   FUNCTION GIACR602_TRAN3 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE   
   )
        RETURN GIACR602_TRAN3_TAB PIPELINED
   AS
        v_rec               GIACR602_TRAN3_TYPE; 
        v_ref_no            VARCHAR(50);
        v_pref              VARCHAR(10);
        v_temp_no           NUMBER(38);
        v_particulars       VARCHAR2 (2100);       
   BEGIN 
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         C.INTM_TYPE || '-' || A.INTM_NO || '/' || C.REF_INTM_CD || '/' || C.INTM_NAME INTERMEDIARY, 
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD,       
                         A.TRAN_CLASS, 
                         A.TRAN_ID,
                         A.INTM_NO                            
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD     
                     AND A.TRANSACTION_TYPE = 3 
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)      
                     AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))                         
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.CEDING_COMPANY      := x.CEDING_COMPANY;             
            v_rec.FILE_NO             := x.FILE_NO;
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.CONVERT_DATE        := x.CONVERT_DATE;      
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;                  
            v_rec.FILE_STATUS         := x.FILE_STATUS;
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;
            v_rec.TRAN_CLASS          := x.TRAN_CLASS;
            v_rec.TRAN_ID             := x.TRAN_ID;
            v_rec.INTM_NO             := x.INTM_NO;     
                                        
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
                             B.FILE_NO,
                             B.TRAN_ID
                        FROM GIIS_CURRENCY A, GIAC_UPLOAD_INWFACUL_PREM B       
                       WHERE A.MAIN_CURRENCY_CD = B.CURRENCY_CD
                         AND B.SOURCE_CD = x.SOURCE_CD
                         AND B.FILE_NO = x.FILE_NO                    
                     )
            LOOP
            
                v_rec.ASSURED             := i.ASSURED;
                v_rec.POLICY_NO           := i.POLICY_NO;
                v_rec.TRAN_CLASS          := x.TRAN_CLASS;
                
                IF x.TRAN_CLASS = 'JV' THEN       
                    BEGIN 		
                        SELECT A.JV_NO, A.TRAN_CLASS, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars 
                          FROM GIAC_ACCTRANS A
                         WHERE A.TRAN_ID = x.TRAN_ID;              

                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no :=NULL;  
                        END IF; 
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;       
                                       
                ELSIF x.TRAN_CLASS = 'DV' THEN      
                    BEGIN      		
                        SELECT A.DV_NO, A.DV_PREF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_DISB_VOUCHERS A
                         WHERE A.GACC_TRAN_ID = x.TRAN_ID;
                         
                        IF  v_temp_no IS NULL THEN
                            SELECT A.DOCUMENT_CD||'-'||A.BRANCH_CD||'-'||A.DOC_YEAR||'-'||A.DOC_MM||'-'||A.DOC_SEQ_NO
                              INTO v_ref_no 
                              FROM GIAC_PAYT_REQUESTS A, GIAC_PAYT_REQUESTS_DTL B
                             WHERE A.REF_ID = B.GPRQ_REF_ID
                               AND B.TRAN_ID = x.TRAN_ID;                        
                        ELSE
                            v_ref_no := v_pref|| '-' ||TO_CHAR(v_temp_no);                
                        END IF;
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;                                                 
                    
                ELSIF x.TRAN_CLASS = 'COL' THEN         	
                    BEGIN
                        SELECT DISTINCT A.OR_NO, A.OR_PREF_SUF
                          INTO v_temp_no, v_pref
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;               
                         
                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no := NULL; 
                        END IF;

                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;                     
                           
                    END;   
                    
                    BEGIN                                       
                        SELECT DISTINCT A.PARTICULARS 
                          INTO v_particulars
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM_COMM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;
                           
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_particulars := NULL;                     
                           
                    END;                            
                ELSE
                    v_ref_no :=NULL;  
                                               
                END IF;     
                
                v_rec.REF_NO              := v_ref_no;
                v_rec.PARTICULARS         := v_particulars;   
                v_rec.PREMIUM             := i.PREMIUM;
                v_rec.VAT_ON_PREM         := i.VAT_ON_PREM;
                v_rec.RI_COMMISSION       := i.RI_COMMISSION;
                v_rec.VAT_ON_COMM         := i.VAT_ON_COMM;
                v_rec.NET_DUE             := i.NET_DUE;                    
                v_rec.CURRENCY            := i.CURRENCY;
                v_rec.CONVERT_RATE        := i.CONVERT_RATE;   
                         
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;        
   END GIACR602_TRAN3;      
   FUNCTION GIACR602_TRAN4 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE   
   )
        RETURN GIACR602_TRAN4_TAB PIPELINED
   AS
        v_rec               GIACR602_TRAN4_TYPE;
        v_ref_no            VARCHAR(50);
        v_pref              VARCHAR(10);
        v_temp_no           NUMBER(38);
        v_particulars       VARCHAR2 (2100);            
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         C.INTM_TYPE || '-' || A.INTM_NO || '/' || C.REF_INTM_CD || '/' || C.INTM_NAME INTERMEDIARY, 
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD,       
                         A.TRAN_CLASS, 
                         A.TRAN_ID,
                         A.INTM_NO                            
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD     
                     AND A.TRANSACTION_TYPE = 4 
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)      
                     AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))                         
                 )
        LOOP
            v_rec.SOURCE_CD           := x.SOURCE_CD;         
            v_rec.SOURCE              := x.SOURCE;
            v_rec.TRAN_TYPE           := x.TRANSACTION_TYPE;            
            v_rec.TRANSACTION         := x.TRANSACTION; 
            v_rec.REINSURER           := x.CEDING_COMPANY;             
            v_rec.FILE_NO             := x.FILE_NO;
            v_rec.FILE_NAME           := x.FILE_NAME;
            v_rec.CONVERT_DATE        := x.CONVERT_DATE;      
            v_rec.UPLOAD_DATE         := x.UPLOAD_DATE;                  
            v_rec.FILE_STATUS         := x.FILE_STATUS;
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;
            v_rec.TRAN_CLASS          := x.TRAN_CLASS;
            v_rec.TRAN_ID             := x.TRAN_ID;
            v_rec.INTM_NO             := x.INTM_NO; 
       
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
                             A.FILE_NO,
                             A.TRAN_ID
                        FROM GIAC_UPLOAD_OUTFACUL_PREM A, GIIS_CURRENCY B
                       WHERE B.MAIN_CURRENCY_CD = A.CURRENCY_CD
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO                                                           
                     )
            LOOP
                v_rec.CURRENCY            := i.CURRENCY;
                v_rec.CONVERT_RATE        := i.CONVERT_RATE;                        
                v_rec.BINDER_NO           := i.BINDER_NO;
                v_rec.TRAN_CLASS          := x.TRAN_CLASS;
                
                IF x.TRAN_CLASS = 'JV' THEN       
                    BEGIN 		
                        SELECT A.JV_NO, A.TRAN_CLASS, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars 
                          FROM GIAC_ACCTRANS A
                         WHERE A.TRAN_ID = x.TRAN_ID;              

                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no :=NULL;  
                        END IF; 
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;       
                                       
                ELSIF x.TRAN_CLASS = 'DV' THEN      
                    BEGIN      		
                        SELECT A.DV_NO, A.DV_PREF, A.PARTICULARS  
                          INTO v_temp_no, v_pref, v_particulars
                          FROM GIAC_DISB_VOUCHERS A
                         WHERE A.GACC_TRAN_ID = x.TRAN_ID;
                         
                        IF  v_temp_no IS NULL THEN
                            SELECT A.DOCUMENT_CD||'-'||A.BRANCH_CD||'-'||A.DOC_YEAR||'-'||A.DOC_MM||'-'||A.DOC_SEQ_NO
                              INTO v_ref_no 
                              FROM GIAC_PAYT_REQUESTS A, GIAC_PAYT_REQUESTS_DTL B
                             WHERE A.REF_ID = B.GPRQ_REF_ID
                               AND B.TRAN_ID = x.TRAN_ID;                        
                        ELSE
                            v_ref_no := v_pref|| '-' ||TO_CHAR(v_temp_no);                
                        END IF;
                         
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;   
                    
                    END;                                                 
                    
                ELSIF x.TRAN_CLASS = 'COL' THEN               	
                    BEGIN
                        SELECT DISTINCT A.OR_NO, A.OR_PREF_SUF
                          INTO v_temp_no, v_pref
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;               
                         
                        IF v_temp_no IS NOT NULL THEN  
                            v_ref_no := v_pref||'-'||TO_CHAR(v_temp_no); 
                        ELSE 
                            v_ref_no := NULL; 
                        END IF;

                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_ref_no := NULL;                     
                           
                    END;    
                    
                    BEGIN                                       
                        SELECT DISTINCT A.PARTICULARS 
                          INTO v_particulars
                          FROM GIAC_ORDER_OF_PAYTS A, GIAC_UPLOAD_PREM_COMM B
                         WHERE A.GACC_TRAN_ID = B.TRAN_ID
                           AND SOURCE_CD = x.SOURCE_CD    
                           AND FILE_NO = x.FILE_NO
                           AND A.GACC_TRAN_ID = i.TRAN_ID;
                           
                    EXCEPTION		
                    WHEN NO_DATA_FOUND THEN v_particulars := NULL;                     
                           
                    END;    
                    
                ELSE
                    v_ref_no :=NULL;  
                                               
                END IF;     
                
                v_rec.REF_NO              := v_ref_no;
                v_rec.PARTICULARS         := v_particulars;   
                v_rec.PREMIUM             := i.PREMIUM;
                v_rec.VAT_ON_PREM         := i.VAT_ON_PREM;
                v_rec.RI_COMMISSION       := i.RI_COMMISSION;
                v_rec.VAT_ON_COMM         := i.VAT_ON_COMM;
                v_rec.WITHHOLDING_VAT     := i.WITHHOLDING_VAT;
                v_rec.NET_DUE             := i.NET_DUE; 
                         
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;
   END GIACR602_TRAN4;    
   FUNCTION GIACR602_TRAN5 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE  
   )
        RETURN GIACR602_TRAN5_TAB PIPELINED
   AS
        v_rec           GIACR602_TRAN5_TYPE; 
   BEGIN
        FOR x IN (SELECT B.SOURCE_NAME SOURCE, 
                         (SELECT E.RV_MEANING 
                            FROM CG_REF_CODES E
                           WHERE E.RV_LOW_VALUE = A.TRANSACTION_TYPE
                             AND E.RV_DOMAIN =  'GIAC_UPLOAD_FILE.TRANSACTION_TYPE') TRANSACTION,
                         C.INTM_TYPE || '-' || A.INTM_NO || '/' || C.REF_INTM_CD || '/' || C.INTM_NAME INTERMEDIARY, 
                         D.RI_NAME CEDING_COMPANY,                           
                         A.FILE_NAME,       
                         A.PAYMENT_DATE DEPOSIT_DATE,         
                         A.CONVERT_DATE,                  
                         A.UPLOAD_DATE, 
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') FILE_STATUS,       
                         A.SOURCE_CD,
                         A.TRANSACTION_TYPE,        
                         A.FILE_NO,
                         B.ATM_TAG,         
                         A.RI_CD,       
                         A.TRAN_CLASS, 
                         A.TRAN_ID,
                         A.INTM_NO                            
                    FROM GIAC_UPLOAD_FILE A, GIAC_FILE_SOURCE B, GIIS_INTERMEDIARY C, GIIS_REINSURER D             
                   WHERE A.SOURCE_CD = NVL(P_SOURCE_CD,A.SOURCE_CD)
                     AND A.SOURCE_CD = B. SOURCE_CD     
                     AND A.TRANSACTION_TYPE = 5  
                     AND A.FILE_NAME = NVL(P_FILE_NAME,A.FILE_NAME)  
                     AND A.INTM_NO = C.INTM_NO(+) 
                     AND A.RI_CD = D.RI_CD(+)      
                     AND TRUNC(A.UPLOAD_DATE) BETWEEN NVL(P_FROM_DATE,TRUNC(A.UPLOAD_DATE)) AND NVL(P_TO_DATE,TRUNC(A.UPLOAD_DATE))                       
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
            v_rec.ATM_TAG             := x.ATM_TAG;
            v_rec.RI_CD               := x.RI_CD;
            v_rec.TRAN_CLASS          := x.TRAN_CLASS;
            v_rec.TRAN_ID             := x.TRAN_ID;
            v_rec.INTM_NO             := x.INTM_NO;        

            FOR i IN (SELECT A.PAYOR, 
                             A.BANK_REF_NO,
                             A.UPLOAD_DATE,
                             B.TRAN_CLASS, 
                             C.OR_PREF_SUF||'-'||C.OR_NO REF_NO, 
                             C.PARTICULARS,
                             A.COLLECTION_AMT
                        FROM GIAC_UPLOAD_PREM_REFNO A, 
                             GIAC_ACCTRANS B, 
                             GIAC_ORDER_OF_PAYTS C
                       WHERE A.TRAN_ID = B.TRAN_ID (+)
                         AND B.TRAN_ID = C.GACC_TRAN_ID (+)
                         AND A.SOURCE_CD = x.SOURCE_CD
                         AND A.FILE_NO = x.FILE_NO                           
                    ORDER BY A.UPLOAD_DATE
                     )
            LOOP
                v_rec.PAYOR               := i.PAYOR;
                v_rec.BANK_REF_NO         := i.BANK_REF_NO;
                v_rec.UPLOAD_DATE         := i.UPLOAD_DATE;
                v_rec.TRAN_CLASS          := i.TRAN_CLASS;
                v_rec.REF_NO              := i.REF_NO;
                v_rec.PARTICULARS         := i.PARTICULARS;
                v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;
                          
                PIPE ROW (v_rec);
            END LOOP;
        END LOOP;
   END GIACR602_TRAN5;      
END GIACR602_CSV_PKG; 
/