CREATE OR REPLACE PACKAGE CPI.GIACR601_CSV_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 10.11.2016
   **  Reference By : (GIACR601- CONVERTED FILES FOR UPLOADING)
   **  Description  : PRINTING OF CSV REPORT
   */
   TYPE GIACR601_TRAN1_A_TYPE IS RECORD (
        SOURCE_CD           GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        SOURCE              GIAC_FILE_SOURCE.SOURCE_NAME%TYPE,
        TRAN_TYPE           GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        TRANSACTION         CG_REF_CODES.RV_MEANING%TYPE,
        FILE_NO             GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        UPLOAD_DATE         GIAC_UPLOAD_FILE.UPLOAD_DATE%TYPE,
        FILE_STATUS         CG_REF_CODES.RV_MEANING%TYPE,   
        ATM_TAG             GIAC_FILE_SOURCE.ATM_TAG%TYPE,
        RI_CD               GIAC_UPLOAD_FILE.RI_CD%TYPE,                 
        PAYOR               GIAC_UPLOAD_PREM_REFNO.PAYOR%TYPE,
        POLICY_NO           VARCHAR2 (200),
        COLLECTION_AMT      GIAC_UPLOAD_PREM.COLLECTION_AMT%TYPE,
        PAY_MODE            GIAC_UPLOAD_PREM_DTL.PAY_MODE%TYPE,
        BANK                GIAC_UPLOAD_PREM_DTL.BANK%TYPE,
        CHECK_CLASS         GIAC_UPLOAD_PREM_DTL.CHECK_CLASS%TYPE,  
        CHECK_NO            GIAC_UPLOAD_PREM_DTL.CHECK_NO%TYPE,
        CHECK_DATE          GIAC_UPLOAD_PREM_DTL.CHECK_DATE%TYPE,
        AMOUNT              GIAC_UPLOAD_PREM_DTL.COLLECTION_AMT%TYPE,
        CHECK_RESULTS       VARCHAR2 (2100)         
   );
   TYPE GIACR601_TRAN1_A_TAB IS TABLE OF GIACR601_TRAN1_A_TYPE;
-------------------------------------------------------------------------------   
   TYPE GIACR601_TRAN1_B_TYPE IS RECORD (
        SOURCE_CD           GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        SOURCE              GIAC_FILE_SOURCE.SOURCE_NAME%TYPE,
        TRAN_TYPE           GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,        
        TRANSACTION         CG_REF_CODES.RV_MEANING%TYPE,
        FILE_NO             GIAC_UPLOAD_FILE.FILE_NO%TYPE,        
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        UPLOAD_DATE         GIAC_UPLOAD_FILE.UPLOAD_DATE%TYPE,
        FILE_STATUS         CG_REF_CODES.RV_MEANING%TYPE, 
        ATM_TAG             GIAC_FILE_SOURCE.ATM_TAG%TYPE,
        RI_CD               GIAC_UPLOAD_FILE.RI_CD%TYPE,          
        PAYOR               GIAC_UPLOAD_PREM_ATM.PAYOR%TYPE,
        ATM_NO              GIAC_UPLOAD_PREM_ATM.BILL_NO%TYPE,
        COLLECTION_AMT      GIAC_UPLOAD_PREM_ATM.COLLECTION_AMT%TYPE,
        PAY_MODE            GIAC_UPLOAD_PREM_ATM_DTL.PAY_MODE%TYPE,
        BANK                GIAC_UPLOAD_PREM_ATM_DTL.BANK%TYPE,
        CHECK_CLASS         GIAC_UPLOAD_PREM_ATM_DTL.CHECK_CLASS%TYPE,    
        CHECK_NO            GIAC_UPLOAD_PREM_ATM_DTL.CHECK_NO%TYPE,
        CHECK_DATE          GIAC_UPLOAD_PREM_ATM_DTL.CHECK_DATE%TYPE,
        AMOUNT              GIAC_UPLOAD_PREM_ATM_DTL.COLLECTION_AMT%TYPE,
        CHECK_RESULTS		VARCHAR2 (2100)
   );
   TYPE GIACR601_TRAN1_B_TAB IS TABLE OF GIACR601_TRAN1_B_TYPE; 
-------------------------------------------------------------------------------   
   TYPE GIACR601_TRAN2_TYPE IS RECORD (
        SOURCE_CD           GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        SOURCE              GIAC_FILE_SOURCE.SOURCE_NAME%TYPE,
        TRAN_TYPE           GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        TRANSACTION         CG_REF_CODES.RV_MEANING%TYPE,
        INTERMEDIARY        VARCHAR2 (400),
        FILE_NO             GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        UPLOAD_DATE         GIAC_UPLOAD_FILE.UPLOAD_DATE%TYPE,
        FILE_STATUS         CG_REF_CODES.RV_MEANING%TYPE,   
        ATM_TAG             GIAC_FILE_SOURCE.ATM_TAG%TYPE,
        RI_CD               GIAC_UPLOAD_FILE.RI_CD%TYPE,             
        PAYOR               GIAC_UPLOAD_PREM_COMM.PAYOR%TYPE,
        POLICY_NO           VARCHAR2 (100), 
        GROSS_PREMIUM       GIAC_UPLOAD_PREM_COMM.GROSS_PREM_AMT%TYPE,
        COMMISSION          GIAC_UPLOAD_PREM_COMM.COMM_AMT%TYPE,
        WITHHOLDING_TAX     GIAC_UPLOAD_PREM_COMM.WHTAX_AMT%TYPE,
        INPUT_VAT           GIAC_UPLOAD_PREM_COMM.INPUT_VAT_AMT%TYPE,
        NET_AMT_DUE         GIAC_UPLOAD_PREM_COMM.NET_AMT_DUE%TYPE, 
        ENDT_SEQ_NO         GIAC_UPLOAD_PREM_COMM.ENDT_SEQ_NO%TYPE,        
        CHECK_RESULTS		VARCHAR2 (2100)
   );
   TYPE GIACR601_TRAN2_TAB IS TABLE OF GIACR601_TRAN2_TYPE;
-------------------------------------------------------------------------------   
   TYPE GIACR601_TRAN3_TYPE IS RECORD (
        SOURCE_CD           GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        SOURCE              GIAC_FILE_SOURCE.SOURCE_NAME%TYPE,
        TRAN_TYPE           GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        TRANSACTION         CG_REF_CODES.RV_MEANING%TYPE,
        CEDING_COMPANY      GIIS_REINSURER.RI_NAME%TYPE,
        FILE_NO             GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        UPLOAD_DATE         GIAC_UPLOAD_FILE.UPLOAD_DATE%TYPE,
        FILE_STATUS         CG_REF_CODES.RV_MEANING%TYPE,   
        ATM_TAG             GIAC_FILE_SOURCE.ATM_TAG%TYPE,
        RI_CD               GIAC_UPLOAD_FILE.RI_CD%TYPE,  

        CURRENCY		    GIIS_CURRENCY.CURRENCY_DESC%TYPE,       
        CONVERT_RATE        GIAC_UPLOAD_INWFACUL_PREM.CONVERT_RATE%TYPE,   
        ASSURED             GIAC_UPLOAD_INWFACUL_PREM.ASSURED%TYPE,
        POLICY_NO           VARCHAR2 (100), 
        PREMIUM             GIAC_UPLOAD_INWFACUL_PREM.FPREM_AMT%TYPE,
        VAT_ON_PREM         GIAC_UPLOAD_INWFACUL_PREM.FTAX_AMT%TYPE,
        RI_COMMISSION       GIAC_UPLOAD_INWFACUL_PREM.FCOMM_AMT%TYPE,
        VAT_ON_COMM         GIAC_UPLOAD_INWFACUL_PREM.FCOMM_VAT%TYPE,
        NET_DUE             GIAC_UPLOAD_INWFACUL_PREM.FCOLLECTION_AMT%TYPE,     
        CHECK_RESULTS       VARCHAR2 (2100)           
   );
   TYPE GIACR601_TRAN3_TAB IS TABLE OF GIACR601_TRAN3_TYPE;   
-------------------------------------------------------------------------------   
   TYPE GIACR601_TRAN4_TYPE IS RECORD (
        SOURCE_CD           GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        SOURCE              GIAC_FILE_SOURCE.SOURCE_NAME%TYPE,
        TRAN_TYPE           GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        TRANSACTION         CG_REF_CODES.RV_MEANING%TYPE,
        REINSURER           GIIS_REINSURER.RI_NAME%TYPE,
        FILE_NO             GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        UPLOAD_DATE         GIAC_UPLOAD_FILE.UPLOAD_DATE%TYPE,
        FILE_STATUS         CG_REF_CODES.RV_MEANING%TYPE,   
        ATM_TAG             GIAC_FILE_SOURCE.ATM_TAG%TYPE,
        RI_CD               GIAC_UPLOAD_FILE.RI_CD%TYPE,     
   
        CURRENCY		    GIIS_CURRENCY.CURRENCY_DESC%TYPE,  
        CONVERT_RATE        GIAC_UPLOAD_OUTFACUL_PREM.CONVERT_RATE%TYPE,
        BINDER_NO           VARCHAR2 (100), 
        PREMIUM             GIAC_UPLOAD_OUTFACUL_PREM.FPREM_AMT%TYPE,
        VAT_ON_PREM         GIAC_UPLOAD_OUTFACUL_PREM.FPREM_VAT%TYPE,
        RI_COMMISSION       GIAC_UPLOAD_OUTFACUL_PREM.FCOMM_AMT%TYPE,
        VAT_ON_COMM         GIAC_UPLOAD_OUTFACUL_PREM.FCOMM_VAT%TYPE,
        WITHHOLDING_VAT     GIAC_UPLOAD_OUTFACUL_PREM.FWHOLDING_VAT%TYPE,
        NET_DUE             GIAC_UPLOAD_OUTFACUL_PREM.FDISB_AMT%TYPE,
        CHECK_RESULTS       VARCHAR2 (2100)
   );
   TYPE GIACR601_TRAN4_TAB IS TABLE OF GIACR601_TRAN4_TYPE;  
-------------------------------------------------------------------------------   
   TYPE GIACR601_TRAN5_TYPE IS RECORD (
        SOURCE_CD           GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        SOURCE              GIAC_FILE_SOURCE.SOURCE_NAME%TYPE,
        TRAN_TYPE           GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        TRANSACTION         CG_REF_CODES.RV_MEANING%TYPE,
        FILE_NO             GIAC_UPLOAD_FILE.FILE_NO%TYPE,
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        DEPOSIT_DATE        GIAC_UPLOAD_FILE.PAYMENT_DATE%TYPE,    
        CONVERT_DATE        GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        UPLOAD_DATE         GIAC_UPLOAD_FILE.UPLOAD_DATE%TYPE,
        FILE_STATUS         CG_REF_CODES.RV_MEANING%TYPE,   
        ATM_TAG             GIAC_FILE_SOURCE.ATM_TAG%TYPE,
        RI_CD               GIAC_UPLOAD_FILE.RI_CD%TYPE,  
           
        PAYOR               GIAC_UPLOAD_PREM_REFNO.PAYOR%TYPE,
        BANK_REF_NO         GIAC_UPLOAD_PREM_REFNO.BANK_REF_NO%TYPE,
        COLLECTION_AMT      GIAC_UPLOAD_PREM_REFNO.COLLECTION_AMT%TYPE,        
        CHECK_RESULTS       VARCHAR2 (4100)
   );
   TYPE GIACR601_TRAN5_TAB IS TABLE OF GIACR601_TRAN5_TYPE;                
   FUNCTION GIACR601_TRAN1_A (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE
   )
        RETURN GIACR601_TRAN1_A_TAB PIPELINED;
   FUNCTION GIACR601_TRAN1_B (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE   
   )
        RETURN GIACR601_TRAN1_B_TAB PIPELINED;    
   FUNCTION GIACR601_TRAN2 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE  
   )
        RETURN GIACR601_TRAN2_TAB PIPELINED;
   FUNCTION GIACR601_TRAN3 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE  
   )
        RETURN GIACR601_TRAN3_TAB PIPELINED;        
   FUNCTION GIACR601_TRAN4 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE  
   )
        RETURN GIACR601_TRAN4_TAB PIPELINED;  
   FUNCTION GIACR601_TRAN5 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_FILE.CONVERT_DATE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE  
   )
        RETURN GIACR601_TRAN5_TAB PIPELINED;                          

END GIACR601_CSV_PKG;
/