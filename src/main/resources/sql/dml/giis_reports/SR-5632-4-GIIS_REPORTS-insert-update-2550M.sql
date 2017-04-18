BEGIN
      MERGE INTO CPI.GIIS_REPORTS 
      USING DUAL
              ON ( REPORT_ID = '2550M')
         WHEN NOT MATCHED THEN
            INSERT (REPORT_ID,  REPORT_TITLE, DESTYPE,  PARAMFORM,  
                    REPORT_MODE,  ORIENTATION,  BACKGROUND, USER_ID, 
                    LAST_UPDATE, BIR_TAG,  BIR_FORM_TYPE,  BIR_FREQ_TAG, 
                    BIR_WITH_REPORT, ADD_SOURCE,  CSV_FILE_SW, DISABLE_FILE_SW)
            VALUES ('2550M', 'Monthly Value-Added Tax Declaration', 'FILE', 'NO',
                     'CHARACTER', 'PORTRAIT', 'NO', 'CPI',  
                     SYSDATE, 'Y', 'RELIEF', 'M', 
                     'Y', 'P', 'N', 'N')
         WHEN MATCHED THEN
            UPDATE
               SET REPORT_TITLE = 'Monthly Value-Added Tax Declaration', DESTYPE = 'FILE' , PARAMFORM= 'NO',
                   REPORT_MODE ='CHARACTER', ORIENTATION='PORTRAIT',BACKGROUND='NO', USER_ID='CPI',
                   LAST_UPDATE = SYSDATE, BIR_TAG = 'Y', BIR_FORM_TYPE = 'RELIEF', BIR_FREQ_TAG = 'M',
                   BIR_WITH_REPORT = 'Y', ADD_SOURCE = 'P', CSV_FILE_SW = 'N', DISABLE_FILE_SW = 'N'
            ;
END;