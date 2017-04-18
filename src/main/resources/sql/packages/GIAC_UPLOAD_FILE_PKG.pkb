CREATE OR REPLACE PACKAGE BODY CPI.GIAC_UPLOAD_FILE_PKG
AS
   /*
   **  Created by   : Dren Niebres
   **  Date Created : 06.10.2015
   **  Reference By : (SR-0004572, SR-0004573 - CONVERTION OF GIACS605 AND GIACS606)
   **  Description  : PKG TO POPULATE LOV FOR FILENAME
   */
   FUNCTION GET_GIACS605_FILENAME_LOV(
        P_SEARCH                VARCHAR2,
        P_SOURCE_CD             GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRANSACTION_TYPE      GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE 
   ) 
      RETURN GIACS605_FILENAME_LOV_TAB PIPELINED
   IS
      V_LIST GIACS605_FILENAME_LOV_TYPE;
   BEGIN
        FOR I IN (
                  SELECT FILE_NAME
                    FROM GIAC_UPLOAD_FILE 
                   WHERE SOURCE_CD = NVL(P_SOURCE_CD,SOURCE_CD)
                     AND GIAC_UPLOAD_FILE.TRANSACTION_TYPE = NVL(P_TRANSACTION_TYPE, TRANSACTION_TYPE)        
                     AND FILE_NAME LIKE UPPER(P_SEARCH)
                ORDER BY FILE_NAME
        )
        LOOP
            V_LIST.FILE_NAME        := I.FILE_NAME; 
        
            PIPE ROW(V_LIST);
        END LOOP;
        
        RETURN;
   END;  
   FUNCTION GET_GIACS606_FILENAME_LOV(
        P_SEARCH                VARCHAR2,
        P_SOURCE_CD             GIAC_UPLOAD_FILE.SOURCE_CD%TYPE,
        P_TRANSACTION_TYPE      GIAC_UPLOAD_FILE.TRANSACTION_TYPE%TYPE 
   ) 
      RETURN GIACS606_FILENAME_LOV_TAB PIPELINED
   IS
      V_LIST GIACS606_FILENAME_LOV_TYPE;
   BEGIN
        FOR I IN (
                  SELECT FILE_NAME
                    FROM GIAC_UPLOAD_FILE 
                   WHERE SOURCE_CD = NVL(P_SOURCE_CD,SOURCE_CD)
                     AND GIAC_UPLOAD_FILE.TRANSACTION_TYPE = NVL(P_TRANSACTION_TYPE, TRANSACTION_TYPE)        
                     AND FILE_NAME LIKE UPPER(P_SEARCH)
                ORDER BY FILE_NAME
        )
        LOOP
            V_LIST.FILE_NAME        := I.FILE_NAME; 
        
            PIPE ROW(V_LIST);
        END LOOP;
        
        RETURN;
   END;       
END;
/
