BEGIN
      MERGE INTO CPI.GIIS_REPORTS 
      USING DUAL
              ON ( REPORT_ID = 'SAWT')
         WHEN NOT MATCHED THEN
            INSERT (REPORT_ID,  REPORT_TITLE, DESTYPE,  PARAMFORM,  
                    REPORT_MODE,  ORIENTATION,  BACKGROUND, USER_ID, 
                    LAST_UPDATE, BIR_TAG,  BIR_FORM_TYPE,  BIR_FREQ_TAG, 
                    BIR_WITH_REPORT, ADD_SOURCE,  CSV_FILE_SW, DISABLE_FILE_SW)
            VALUES ('SAWT', 'Summary Alphalist of Withholding Taxes', 'FILE', 'NO',
                     'CHARACTER', 'PORTRAIT', 'NO', 'CPI',  
                     SYSDATE, 'Y', 'SAWT', 'A', 
                     'Y', 'P', 'N', 'N')
         WHEN MATCHED THEN
            UPDATE
               SET REPORT_TITLE = 'Summary Alphalist of Withholding Taxes', DESTYPE = 'FILE' , PARAMFORM= 'NO',
                   REPORT_MODE ='CHARACTER', ORIENTATION='PORTRAIT',BACKGROUND='NO', USER_ID='CPI',
                   LAST_UPDATE = SYSDATE, BIR_TAG = 'Y', BIR_FORM_TYPE = 'SAWT', BIR_FREQ_TAG = 'A',
                   BIR_WITH_REPORT = 'Y', ADD_SOURCE = 'P', CSV_FILE_SW = 'N', DISABLE_FILE_SW = 'N'
            ;
END;