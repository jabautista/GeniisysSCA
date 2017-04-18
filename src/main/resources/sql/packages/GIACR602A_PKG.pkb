CREATE OR REPLACE PACKAGE BODY GIACR602A_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 05.06.2015
   **  Reference By : (GIACR602A - CONVERTED BUT NOT UPLOADED RECORDS)
   **  Description  : POPULATE CONVERTED BUT NOT UPLOADED RECORDS REPORT
   */
   FUNCTION POPULATE_GIACR602A (
        P_SOURCE_CD         GIAC_UPLOAD_PREM_REFNO.SOURCE_CD%TYPE,
        P_FROM_DATE         GIAC_UPLOAD_PREM_REFNO.UPLOAD_DATE%TYPE,
        P_TO_DATE           GIAC_UPLOAD_PREM_REFNO.UPLOAD_DATE%TYPE
   )
        RETURN POPULATE_GIACR602A_TAB PIPELINED
   AS
        v_rec           POPULATE_GIACR602A_TYPE; 
        v_comp_name     GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
        v_comp_address  GIIS_PARAMETERS.PARAM_VALUE_V%TYPE;
        v_report_title  GIIS_REPORTS.REPORT_TITLE%TYPE;
        v_report_date   VARCHAR2 (400);        
   BEGIN
        SELECT PARAM_VALUE_V
          INTO v_comp_name
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_NAME';
        
        SELECT PARAM_VALUE_V
          INTO v_comp_address
          FROM GIIS_PARAMETERS
         WHERE PARAM_NAME = 'COMPANY_ADDRESS';   
         
        SELECT REPORT_TITLE 
          INTO v_report_title
          FROM GIIS_REPORTS
         WHERE REPORT_ID = 'GIACR602A';    
         
        IF P_FROM_DATE = P_TO_DATE THEN
            v_report_date := TO_CHAR(P_FROM_DATE, 'Fm Month DD, YYYY');
            
        ELSIF P_FROM_DATE IS NULL THEN
            v_report_date := 'From  to ' || TO_CHAR(P_TO_DATE, 'Fm Month DD, YYYY');  
            
        ELSIF P_TO_DATE IS NULL THEN
            v_report_date := 'From ' || TO_CHAR(P_FROM_DATE, 'Fm Month DD, YYYY') || ' to';
            
        ELSE
            v_report_date := 'From ' || TO_CHAR(P_FROM_DATE, 'Fm Month DD, YYYY') || ' to ' || TO_CHAR(P_TO_DATE, 'Fm Month DD, YYYY');                          
            
        END IF;                                        
   
        FOR i IN (SELECT C.SOURCE_NAME,
                         TRUNC(A.UPLOAD_DATE) UPLOAD_DATE,
                         A.UPLOAD_NO BATCH_NO,
                         A.PAYOR,
                         A.BANK_REF_NO,
                         B.FILE_NAME,
                         D.TRAN_CLASS,
                         CONCAT(E.OR_PREF_SUF,E.OR_NO) REF_NO,
                         E.PARTICULARS,
                         A.COLLECTION_AMT,
                         C.SOURCE_CD
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
            v_rec.COMPANY_NAME        := v_comp_name;
            v_rec.COMPANY_ADDRESS     := v_comp_address; 
            v_rec.REPORT_TITLE        := v_report_title;
            v_rec.REPORT_DATE         := v_report_date;
            v_rec.SOURCE_NAME         := i.SOURCE_NAME;
            v_rec.UPLOAD_DATE         := i.UPLOAD_DATE;            
            v_rec.BATCH_NO            := i.BATCH_NO;
            v_rec.PAYOR               := i.PAYOR;
            v_rec.BANK_REF_NO         := i.BANK_REF_NO;
            v_rec.FILE_NAME           := i.FILE_NAME;
            v_rec.TRAN_CLASS          := i.TRAN_CLASS;    
            v_rec.REF_NO              := i.REF_NO;             
            v_rec.PARTICULARS         := i.PARTICULARS;
            v_rec.COLLECTION_AMT      := i.COLLECTION_AMT;
            v_rec.SOURCE_CD           := i.SOURCE_CD;                                                          
                      
            PIPE ROW (v_rec);
        END LOOP;

        
        IF  v_rec.COMPANY_NAME IS NULL THEN
            v_rec.COMPANY_NAME        := v_comp_name;
            v_rec.COMPANY_ADDRESS     := v_comp_address; 
            v_rec.REPORT_TITLE        := v_report_title;  
            v_rec.REPORT_DATE         := v_report_date;
            PIPE ROW (v_rec);
        END IF;   
   END POPULATE_GIACR602A;
  
END GIACR602A_PKG; 
/