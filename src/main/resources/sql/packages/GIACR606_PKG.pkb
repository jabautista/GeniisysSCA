CREATE OR REPLACE PACKAGE BODY GIACR606_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 05.11.2015
   **  Reference By : (GIACR606-  CONVERTED RECORDS PER STATUS)
   **  Description  : POPULATE CONVERTED RECORDS PER STATUS REPORT
   */
   FUNCTION POPULATE_GIACR606 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_PREM.PREM_CHK_FLAG%TYPE,        
        P_TPREM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG%TYPE,
        P_TCOMM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG%TYPE   
   )
        RETURN POPULATE_GIACR606_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR606_TYPE; 
        v_comp_name     GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
        v_comp_address  GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
        v_report_title  GIIS_REPORTS.REPORT_TITLE%TYPE;  
   BEGIN
        SELECT PARAM_VALUE_V
          INTO v_comp_name
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_NAME';
         
        SELECT PARAM_VALUE_V
          INTO v_comp_address
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_ADDRESS';  

        v_rec.COMPANY_NAME        := v_comp_name;
        v_rec.COMPANY_ADDRESS     := v_comp_address; 
        PIPE ROW (v_rec);
     
   END POPULATE_GIACR606;   
   FUNCTION POPULATE_GIACR606_TRAN1 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_PREM.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN1_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR606_TRAN1_TYPE; 
   BEGIN
        FOR i IN (SELECT A.PREM_CHK_FLAG STATUS,
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = A.PREM_CHK_FLAG
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_PREM.PREM_CHK_FLAG') STATUS_MEANING,        
                         B.FILE_NAME,
                         A.PAYOR,    
                         A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||LTRIM(TO_CHAR(A.ISSUE_YY, '09'))||'-'||
                           LTRIM (TO_CHAR (A.POL_SEQ_NO, '0999999'))||'-'||LTRIM (TO_CHAR (A.RENEW_NO, '09')) POLICY_NO,                           
                         A.COLLECTION_AMT,
                         A.CHK_REMARKS,
                         C.PAY_MODE,
                         C.BANK, 
                         C.CHECK_CLASS,
                         C.CHECK_NO, 
                         C.CHECK_DATE, 
                         C.COLLECTION_AMT AMOUNT
                    FROM GIAC_UPLOAD_PREM A, GIAC_UPLOAD_FILE B, GIAC_UPLOAD_PREM_DTL C
                   WHERE A.SOURCE_CD = B.SOURCE_CD
                     AND A.FILE_NO = B.FILE_NO
                     AND B.SOURCE_CD = NVL(P_SOURCE_CD,B.SOURCE_CD)
                     AND B.FILE_NAME = NVL(P_FILE_NAME,B.FILE_NAME)
                     AND A.PREM_CHK_FLAG = NVL(P_PREM_CHECK_FLAG,A.PREM_CHK_FLAG)
                     AND B.TRANSACTION_TYPE = P_TRAN_TYPE
                     AND C.SOURCE_CD = A.SOURCE_CD
                     AND C.FILE_NO = A.FILE_NO
                     AND C.LINE_CD = A.LINE_CD
                     AND C.SUBLINE_CD = A.SUBLINE_CD 
                     AND C.ISS_CD = A.ISS_CD
                     AND C.ISSUE_YY = A.ISSUE_YY
                     AND C.POL_SEQ_NO= A.POL_SEQ_NO 
                     AND C.RENEW_NO = A.RENEW_NO
                     AND C.PAYOR = A.PAYOR 
                 )
        LOOP
            v_rec.STATUS              := i.STATUS;
            v_rec.STATUS_MEANING      := i.STATUS_MEANING;              
            v_rec.FILE_NAME           := i.FILE_NAME;
            v_rec.PAYOR               := i.PAYOR; 
            v_rec.POLICY_NO           := i.POLICY_NO;
            v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;   
            v_rec.CHK_REMARKS         := i.CHK_REMARKS;
            v_rec.PAY_MODE            := i.PAY_MODE; 
            v_rec.BANK                := i.BANK;
            v_rec.CHECK_CLASS         := i.CHECK_CLASS;
            v_rec.CHECK_NO            := i.CHECK_NO;
            v_rec.CHECK_DATE          := i.CHECK_DATE;
            v_rec.AMOUNT              := i.AMOUNT;
                      
            PIPE ROW (v_rec);
        END LOOP;
        RETURN;
   END POPULATE_GIACR606_TRAN1;     
   FUNCTION POPULATE_GIACR606_TRAN2 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_TPREM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG%TYPE,
        P_TCOMM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG%TYPE 
   )
        RETURN POPULATE_GIACR606_TRAN2_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR606_TRAN2_TYPE; 
   BEGIN
        FOR i IN (SELECT B.FILE_NAME,
                         PREM_CHK_FLAG,
                         (SELECT C.RV_MEANING
                            FROM CG_REF_CODES C 
                           WHERE C.RV_LOW_VALUE = A.PREM_CHK_FLAG
                             AND C.RV_DOMAIN = 'GIAC_UPLOAD_PREM.PREM_CHK_FLAG') PREM_CHK_MEANING,   
                         A.COMM_CHK_FLAG,
                         (SELECT D.RV_MEANING
                            FROM CG_REF_CODES D 
                           WHERE D.RV_LOW_VALUE = A.COMM_CHK_FLAG
                             AND D.RV_DOMAIN = 'GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG') COMM_CHK_MEANING,  
                         A.PAYOR,                         
                         A.LINE_CD||'-'||A.SUBLINE_CD||'-'||A.ISS_CD||'-'||LTRIM(TO_CHAR(A.ISSUE_YY, '09'))||'-'||
                         LTRIM (TO_CHAR (A.POL_SEQ_NO, '0999999'))||'-'||LTRIM (TO_CHAR (A.RENEW_NO, '09'))||
                         DECODE (
                                 NVL (A.ENDT_SEQ_NO, 0),
                                 0, '',
                                    ' / '
                                 || A.ENDT_ISS_CD
                                 || '-'
                                 || LTRIM (TO_CHAR (A.ENDT_YY, '09'))
                                 || '-'
                                 || LTRIM (TO_CHAR (A.ENDT_SEQ_NO, '0999999'))
                                ) POLICY_NO,  
                         
                         A.GROSS_PREM_AMT,
                         A.COMM_AMT, 
                         A.WHTAX_AMT, 
                         A.INPUT_VAT_AMT, 
                         A.NET_AMT_DUE,
                         A.CHK_REMARKS CHECKING_RESULTS
                    FROM GIAC_UPLOAD_PREM_COMM A, GIAC_UPLOAD_FILE B
                   WHERE A.FILE_NO = B.FILE_NO
                     AND A.SOURCE_CD = B.SOURCE_CD
                     AND B.SOURCE_CD = NVL(P_SOURCE_CD,B.SOURCE_CD)
                     AND B.FILE_NAME = NVL(P_FILE_NAME,B.FILE_NAME)
                     AND A.PREM_CHK_FLAG = NVL(P_TPREM_CHECK_FLAG,A.PREM_CHK_FLAG )
                     AND B.TRANSACTION_TYPE = P_TRAN_TYPE
                     AND A.COMM_CHK_FLAG = NVL(P_TCOMM_CHECK_FLAG, A.COMM_CHK_FLAG)
                 )
        LOOP           
            v_rec.FILE_NAME           := i.FILE_NAME;
            v_rec.PREM_CHK_FLAG       := i.PREM_CHK_FLAG;
            v_rec.PREM_CHK_MEANING    := i.PREM_CHK_MEANING;
            v_rec.COMM_CHK_FLAG       := i.COMM_CHK_FLAG;
            v_rec.COMM_CHK_MEANING    := i.COMM_CHK_MEANING;
            v_rec.PAYOR               := i.PAYOR; 
            v_rec.POLICY_NO           := i.POLICY_NO;
            v_rec.GROSS_PREM_AMT      := i.GROSS_PREM_AMT;
            v_rec.COMM_AMT            := i.COMM_AMT;                        
            v_rec.WHTAX_AMT           := i.WHTAX_AMT;            
            v_rec.INPUT_VAT_AMT       := i.INPUT_VAT_AMT;                        
            v_rec.NET_AMT_DUE         := i.NET_AMT_DUE;
            v_rec.CHECKING_RESULTS    := i.CHECKING_RESULTS; 
                      
            PIPE ROW (v_rec);
        END LOOP;
        RETURN;
   END POPULATE_GIACR606_TRAN2;        
   FUNCTION POPULATE_GIACR606_TRAN3 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_INWFACUL_PREM.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN3_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR606_TRAN3_TYPE; 
   BEGIN
        FOR i IN (SELECT C.FILE_NAME,
                         B.PREM_CHK_FLAG,
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = C.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') STATUS,           
                         A.CURRENCY_DESC,
                         B.CONVERT_RATE, 
                         B.ASSURED,       
                         B.LINE_CD||'-'||B.SUBLINE_CD||'-'||B.ISS_CD||'-'||LTRIM(TO_CHAR(B.ISSUE_YY, '09'))||'-'||LTRIM(TO_CHAR(B.POL_SEQ_NO, '0999999'))||'-'||LTRIM(TO_CHAR(B.RENEW_NO, '09')) POLICY_NO,
                         B.FPREM_AMT PREMIUM,
                         B.FTAX_AMT VAT_ON_PREM,
                         B.FCOMM_AMT RI_COMM,
                         B.FCOMM_VAT VAT_ON_COMM,
                         B.FCOLLECTION_AMT NET_DUE,
                         B.PREM_CHK_FLAG||' - '||B.CHK_REMARKS CHECK_RESULTS
                    FROM GIIS_CURRENCY A, GIAC_UPLOAD_INWFACUL_PREM B, GIAC_UPLOAD_FILE C
                   WHERE A.MAIN_CURRENCY_CD = B.CURRENCY_CD  
                     AND B.FILE_NO = C.FILE_NO
                     AND B.SOURCE_CD = C.SOURCE_CD
                     AND C.SOURCE_CD = NVL(P_SOURCE_CD,C.SOURCE_CD)
                     AND C.FILE_NAME = NVL(P_FILE_NAME,C.FILE_NAME)
                     AND B.PREM_CHK_FLAG = NVL(P_PREM_CHECK_FLAG, B.PREM_CHK_FLAG )
                     AND C.TRANSACTION_TYPE = P_TRAN_TYPE
                 )
        LOOP           
            v_rec.FILE_NAME          := i.FILE_NAME;
            v_rec.PREM_CHK_FLAG      := i.PREM_CHK_FLAG;
            v_rec.STATUS             := i.STATUS;
            v_rec.CURRENCY_DESC      := i.CURRENCY_DESC;
            v_rec.CONVERT_RATE       := i.CONVERT_RATE;
            v_rec.ASSURED            := i.ASSURED; 
            v_rec.POLICY_NO          := i.POLICY_NO;
            v_rec.PREMIUM            := i.PREMIUM;
            v_rec.VAT_ON_PREM        := i.VAT_ON_PREM;
            v_rec.RI_COMM            := i.RI_COMM;                        
            v_rec.VAT_ON_COMM        := i.VAT_ON_COMM;            
            v_rec.NET_DUE            := i.NET_DUE;                        
            v_rec.CHECK_RESULTS      := i.CHECK_RESULTS;
                      
            PIPE ROW (v_rec);
        END LOOP;
        RETURN;
   END POPULATE_GIACR606_TRAN3;        
   FUNCTION POPULATE_GIACR606_TRAN4 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_OUTFACUL_PREM.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN4_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR606_TRAN4_TYPE; 
   BEGIN
        FOR i IN (SELECT C.FILE_NAME,       
                         (SELECT E.RV_MEANING
                            FROM CG_REF_CODES E 
                           WHERE E.RV_LOW_VALUE = C.FILE_STATUS
                             AND E.RV_DOMAIN = 'GIAC_UPLOAD_FILE.FILE_STATUS') STATUS,       
                         B.PREM_CHK_FLAG,
                         A.CURRENCY_DESC,
                         B.CONVERT_RATE,
                         B.LINE_CD || '-' || LTRIM(TO_CHAR(B.BINDER_YY, '09')) || '-' || LTRIM(TO_CHAR(B.BINDER_SEQ_NO, '0999999')) BINDER_NO,              
                         B.FPREM_AMT PREMIUM, 
                         B.FPREM_VAT VAT_ON_PREM, 
                         B.FCOMM_AMT RI_COMM, 
                         B.FCOMM_VAT VAT_ON_COMM,
                         B.FWHOLDING_VAT WHOLDING_VAT,
                         B.FDISB_AMT NET_DUE, 
                         B.PREM_CHK_FLAG || ' - ' || B.CHK_REMARKS CHECK_RESULTS
                    FROM GIIS_CURRENCY A, GIAC_UPLOAD_OUTFACUL_PREM B, GIAC_UPLOAD_FILE C
                   WHERE A.MAIN_CURRENCY_CD = B.CURRENCY_CD 
                     AND B.FILE_NO = C.FILE_NO
                     AND B.SOURCE_CD = C.SOURCE_CD
                     AND C.SOURCE_CD = NVL(P_SOURCE_CD,C.SOURCE_CD)
                     AND C.FILE_NAME = NVL(P_FILE_NAME,C.FILE_NAME)
                     AND B.PREM_CHK_FLAG = NVL(P_PREM_CHECK_FLAG,B.PREM_CHK_FLAG )
                     AND C.TRANSACTION_TYPE = P_TRAN_TYPE
                 )
        LOOP           
            v_rec.FILE_NAME          := i.FILE_NAME;
            v_rec.STATUS             := i.STATUS;
            v_rec.PREM_CHK_FLAG      := i.PREM_CHK_FLAG;
            v_rec.CURRENCY_DESC      := i.CURRENCY_DESC;
            v_rec.CONVERT_RATE       := i.CONVERT_RATE;
            v_rec.BINDER_NO          := i.BINDER_NO; 
            v_rec.PREMIUM            := i.PREMIUM;
            v_rec.VAT_ON_PREM        := i.VAT_ON_PREM;
            v_rec.RI_COMM            := i.RI_COMM;                        
            v_rec.VAT_ON_COMM        := i.VAT_ON_COMM;              
            v_rec.WHOLDING_VAT       := i.WHOLDING_VAT;                        
            v_rec.NET_DUE            := i.NET_DUE;                        
            v_rec.CHECK_RESULTS      := i.CHECK_RESULTS;
                      
            PIPE ROW (v_rec);
        END LOOP;
        RETURN;
   END POPULATE_GIACR606_TRAN4;       
   FUNCTION POPULATE_GIACR606_TRAN5 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_PREM_REFNO.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN5_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR606_TRAN5_TYPE; 
   BEGIN
        FOR i IN (SELECT B.FILE_NAME,
                         A.PREM_CHK_FLAG, 
                         (SELECT RV_MEANING
                            FROM CG_REF_CODES 
                           WHERE RV_DOMAIN = 'GIAC_UPLOAD_PREM_REFNO.PREM_CHK_FLAG'
                             AND RV_LOW_VALUE = A.PREM_CHK_FLAG) PREM_MEANING,
                         A.PAYOR,
                         A.BANK_REF_NO, 
                         A.COLLECTION_AMT, 
                         A.CHK_REMARKS
                    FROM GIAC_UPLOAD_PREM_REFNO A, GIAC_UPLOAD_FILE B
                   WHERE A.FILE_NO = B.FILE_NO
                     AND A.SOURCE_CD = B.SOURCE_CD
                     AND B.SOURCE_CD = NVL(P_SOURCE_CD,B.SOURCE_CD)
                     AND B.FILE_NAME = NVL(P_FILE_NAME,B.FILE_NAME)
                     AND A.PREM_CHK_FLAG = NVL(P_PREM_CHECK_FLAG,A.PREM_CHK_FLAG)
                     AND B.TRANSACTION_TYPE = P_TRAN_TYPE
                 )
        LOOP           
            v_rec.FILE_NAME          := i.FILE_NAME;
            v_rec.PREM_CHK_FLAG      := i.PREM_CHK_FLAG;
            v_rec.PREM_MEANING       := i.PREM_MEANING;
            v_rec.PAYOR              := i.PAYOR;
            v_rec.BANK_REF_NO        := i.BANK_REF_NO; 
            v_rec.COLLECTION_AMT     := i.COLLECTION_AMT;
            v_rec.CHK_REMARKS        := i.CHK_REMARKS;
                      
            PIPE ROW (v_rec);
        END LOOP;
        RETURN;
   END POPULATE_GIACR606_TRAN5;         
END GIACR606_PKG; 
/