CREATE OR REPLACE PACKAGE CPI.GIACR606_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 05.11.2015
   **  Reference By : (GIACR606-  CONVERTED RECORDS PER STATUS)
   **  Description  : POPULATE CONVERTED RECORDS PER STATUS REPORT
   */
   TYPE POPULATE_GIACR606_TYPE IS RECORD (
        COMPANY_NAME        GIIS_PARAMETERS.PARAM_VALUE_V%TYPE,
        COMPANY_ADDRESS     GIIS_PARAMETERS.PARAM_VALUE_V%TYPE
   );
   TYPE POPULATE_GIACR606_TAB IS TABLE OF POPULATE_GIACR606_TYPE;
-------------------------------------------------------------------------------   
   TYPE POPULATE_GIACR606_TRAN1_TYPE IS RECORD (
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        STATUS              GIAC_UPLOAD_PREM.PREM_CHK_FLAG%TYPE,
        STATUS_MEANING      CG_REF_CODES.RV_MEANING%TYPE,           
        PAYOR               GIAC_UPLOAD_PREM.PAYOR%TYPE,
        POLICY_NO           VARCHAR2 (200),
        COLLECTION_AMT      GIAC_UPLOAD_PREM.COLLECTION_AMT%TYPE,
        CHK_REMARKS         GIAC_UPLOAD_PREM.CHK_REMARKS%TYPE,
        PAY_MODE            GIAC_UPLOAD_PREM_DTL.PAY_MODE%TYPE,
        BANK                GIAC_UPLOAD_PREM_DTL.BANK%TYPE,
        CHECK_CLASS         GIAC_UPLOAD_PREM_DTL.CHECK_CLASS%TYPE,  
        CHECK_NO            GIAC_UPLOAD_PREM_DTL.CHECK_NO%TYPE,
        CHECK_DATE          GIAC_UPLOAD_PREM_DTL.CHECK_DATE%TYPE,
        AMOUNT              GIAC_UPLOAD_PREM_DTL.COLLECTION_AMT%TYPE
   );
   TYPE POPULATE_GIACR606_TRAN1_TAB IS TABLE OF POPULATE_GIACR606_TRAN1_TYPE; 
---------------------------------------------------------------------------------   
   TYPE POPULATE_GIACR606_TRAN2_TYPE IS RECORD (
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        PREM_CHK_FLAG       GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG%TYPE,
        PREM_CHK_MEANING    CG_REF_CODES.RV_MEANING%TYPE,    
        COMM_CHK_FLAG       GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG%TYPE,
        COMM_CHK_MEANING    CG_REF_CODES.RV_MEANING%TYPE,    
        PAYOR               GIAC_UPLOAD_PREM_COMM.PAYOR%TYPE,
        POLICY_NO           VARCHAR2 (200),
        GROSS_PREM_AMT      GIAC_UPLOAD_PREM_COMM.GROSS_PREM_AMT%TYPE,
        COMM_AMT            GIAC_UPLOAD_PREM_COMM.COMM_AMT%TYPE,
        WHTAX_AMT           GIAC_UPLOAD_PREM_COMM.WHTAX_AMT%TYPE,
        INPUT_VAT_AMT       GIAC_UPLOAD_PREM_COMM.INPUT_VAT_AMT%TYPE,   
        NET_AMT_DUE         GIAC_UPLOAD_PREM_COMM.NET_AMT_DUE%TYPE,
        CHECKING_RESULTS    GIAC_UPLOAD_PREM_COMM.CHK_REMARKS%TYPE
   );
   TYPE POPULATE_GIACR606_TRAN2_TAB IS TABLE OF POPULATE_GIACR606_TRAN2_TYPE; 
---------------------------------------------------------------------------------   
   TYPE POPULATE_GIACR606_TRAN3_TYPE IS RECORD (
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        PREM_CHK_FLAG       GIAC_UPLOAD_INWFACUL_PREM.PREM_CHK_FLAG%TYPE,
        STATUS              CG_REF_CODES.RV_MEANING%TYPE,
        CURRENCY_DESC       GIIS_CURRENCY.CURRENCY_DESC%TYPE,
        CONVERT_RATE        GIAC_UPLOAD_INWFACUL_PREM.CONVERT_RATE%TYPE,
        ASSURED             GIAC_UPLOAD_INWFACUL_PREM.ASSURED%TYPE,
        POLICY_NO           VARCHAR2 (200),  
        PREMIUM             GIAC_UPLOAD_INWFACUL_PREM.FPREM_AMT%TYPE,
        VAT_ON_PREM         GIAC_UPLOAD_INWFACUL_PREM.FTAX_AMT%TYPE,
        RI_COMM             GIAC_UPLOAD_INWFACUL_PREM.FCOMM_AMT%TYPE,
        VAT_ON_COMM         GIAC_UPLOAD_INWFACUL_PREM.FCOMM_VAT%TYPE,
        NET_DUE             GIAC_UPLOAD_INWFACUL_PREM.FCOLLECTION_AMT%TYPE,
        CHECK_RESULTS       VARCHAR2 (2100) 
   );
   TYPE POPULATE_GIACR606_TRAN3_TAB IS TABLE OF POPULATE_GIACR606_TRAN3_TYPE; 
---------------------------------------------------------------------------------   
   TYPE POPULATE_GIACR606_TRAN4_TYPE IS RECORD (
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,        
        STATUS              CG_REF_CODES.RV_MEANING%TYPE,
        PREM_CHK_FLAG       GIAC_UPLOAD_OUTFACUL_PREM.PREM_CHK_FLAG%TYPE,
        CURRENCY_DESC       GIIS_CURRENCY.CURRENCY_DESC%TYPE,
        CONVERT_RATE        GIAC_UPLOAD_OUTFACUL_PREM.CONVERT_RATE%TYPE,
        BINDER_NO           VARCHAR2 (200),           
        PREMIUM             GIAC_UPLOAD_OUTFACUL_PREM.FPREM_AMT%TYPE,
        VAT_ON_PREM         GIAC_UPLOAD_OUTFACUL_PREM.FPREM_VAT%TYPE,
        RI_COMM             GIAC_UPLOAD_OUTFACUL_PREM.FCOMM_AMT%TYPE,
        VAT_ON_COMM         GIAC_UPLOAD_OUTFACUL_PREM.FCOMM_VAT%TYPE,
        WHOLDING_VAT        GIAC_UPLOAD_OUTFACUL_PREM.FWHOLDING_VAT%TYPE,
        NET_DUE             GIAC_UPLOAD_OUTFACUL_PREM.FDISB_AMT%TYPE,
        CHECK_RESULTS       VARCHAR2 (2100) 
   );
   TYPE POPULATE_GIACR606_TRAN4_TAB IS TABLE OF POPULATE_GIACR606_TRAN4_TYPE;
---------------------------------------------------------------------------------   
   TYPE POPULATE_GIACR606_TRAN5_TYPE IS RECORD (
        FILE_NAME           GIAC_UPLOAD_FILE.FILE_NAME%TYPE,        
        PREM_CHK_FLAG       GIAC_UPLOAD_PREM_REFNO.PREM_CHK_FLAG%TYPE,
        PREM_MEANING        CG_REF_CODES.RV_MEANING%TYPE,
        PAYOR               GIAC_UPLOAD_PREM_REFNO.PAYOR%TYPE,
        BANK_REF_NO         GIAC_UPLOAD_PREM_REFNO.BANK_REF_NO%TYPE,
        COLLECTION_AMT      GIAC_UPLOAD_PREM_REFNO.COLLECTION_AMT%TYPE, 
        CHK_REMARKS         GIAC_UPLOAD_PREM_REFNO.CHK_REMARKS%TYPE
   );
   TYPE POPULATE_GIACR606_TRAN5_TAB IS TABLE OF POPULATE_GIACR606_TRAN5_TYPE;  
   FUNCTION POPULATE_GIACR606 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_PREM.PREM_CHK_FLAG%TYPE,        
        P_TPREM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG%TYPE,
        P_TCOMM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG%TYPE       
   )
        RETURN POPULATE_GIACR606_TAB PIPELINED;
   FUNCTION POPULATE_GIACR606_TRAN1 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_PREM.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN1_TAB PIPELINED;
   FUNCTION POPULATE_GIACR606_TRAN2 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_TPREM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.PREM_CHK_FLAG%TYPE,
        P_TCOMM_CHECK_FLAG  GIAC_UPLOAD_PREM_COMM.COMM_CHK_FLAG%TYPE 
   )
        RETURN POPULATE_GIACR606_TRAN2_TAB PIPELINED;    
   FUNCTION POPULATE_GIACR606_TRAN3 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_INWFACUL_PREM.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN3_TAB PIPELINED;         
   FUNCTION POPULATE_GIACR606_TRAN4 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_OUTFACUL_PREM.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN4_TAB PIPELINED;   
   FUNCTION POPULATE_GIACR606_TRAN5 (
        P_SOURCE_CD         GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRAN_TYPE         GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE,
        P_FILE_NAME         GIAC_UPLOAD_FILE.FILE_NAME%TYPE,
        P_PREM_CHECK_FLAG   GIAC_UPLOAD_PREM_REFNO.PREM_CHK_FLAG%TYPE
   )
        RETURN POPULATE_GIACR606_TRAN5_TAB PIPELINED;                                  

END GIACR606_PKG;
/