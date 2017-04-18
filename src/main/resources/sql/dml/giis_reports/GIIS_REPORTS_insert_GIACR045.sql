SET SERVEROUTPUT ON
DECLARE
   v_exist   NUMBER :=0;
   
BEGIN
   SELECT 1
     INTO v_exist
     FROM CPI.GIIS_REPORTS 
    WHERE report_id = 'GIACR045';
    
   IF v_exist = 1 THEN
        DBMS_OUTPUT.PUT_LINE('GIACR045 existing.');    
   END IF;
   
EXCEPTION
    WHEN NO_DATA_FOUND THEN
         INSERT INTO CPI.GIIS_REPORTS (REPORT_ID,  REPORT_TITLE,   LINE_CD,    SUBLINE_CD,     REPORT_TYPE,    REPORT_DESC,    DESTYPE,        DESNAME,
                                       DESFORMAT,  PARAMFORM,      COPIES,     REPORT_MODE,    ORIENTATION,    BACKGROUND,     GENERATION_FREQUENCY,
                                       EIS_TAG,    REMARKS,        USER_ID,    LAST_UPDATE,    DOC_TYPE,       CPI_REC_NO,     CPI_BRANCH_CD, MODULE_TAG,
                                       DOCUMENT_TAG,   VERSION,    BIR_TAG,    BIR_FORM_TYPE,  BIR_FREQ_TAG,   PAGESIZE,       ADD_SOURCE,      CSV_FILE_SW)
            VALUES ('GIACR045', 'Detailed 24th Method', NULL, NULL,  NULL, NULL, NULL, NULL,
                   NULL, NULL, 1, NULL,  'DEFAULT', NULL, NULL, NULL,  NULL, 'CPI', SYSDATE,
                   NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'P', NULL);

      COMMIT;
      DBMS_OUTPUT.PUT_LINE('GIACR045 inserted.');

END;
