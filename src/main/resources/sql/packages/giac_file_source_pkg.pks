CREATE OR REPLACE PACKAGE CPI.giac_file_source_pkg AS

   TYPE file_source_lov_type IS RECORD (
      source_cd     giac_file_source.source_cd%TYPE,
      source_name   giac_file_source.source_name%TYPE,
      atm_tag       giac_file_source.atm_tag%TYPE
   );
   
   TYPE file_source_lov_tab IS TABLE OF file_source_lov_type;
--------------------------------------------------------------------- Dren Niebres 10.03.2016 SR-4572 : Added LOV for GIACS605 Source
   TYPE GIACS605_SOURCE_LOV_TYPE IS RECORD (
      SOURCE_CD         GIAC_FILE_SOURCE.SOURCE_CD%TYPE,
      SOURCE_NAME       GIAC_FILE_SOURCE.SOURCE_NAME%TYPE
   ); 
   TYPE GIACS605_SOURCE_LOV_TAB IS TABLE OF GIACS605_SOURCE_LOV_TYPE;  
--------------------------------------------------------------------- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Source
   TYPE GIACS606_SOURCE_LOV_TYPE IS RECORD (
      SOURCE_CD         GIAC_FILE_SOURCE.SOURCE_CD%TYPE,
      SOURCE_NAME       GIAC_FILE_SOURCE.SOURCE_NAME%TYPE
   ); 
   TYPE GIACS606_SOURCE_LOV_TAB IS TABLE OF GIACS606_SOURCE_LOV_TYPE;    
   FUNCTION get_file_source_lov
      RETURN file_source_lov_tab PIPELINED;
      
   FUNCTION check_file_name (
      p_file_name VARCHAR2,
      p_transaction_type VARCHAR2,
      p_source_cd VARCHAR2
   )
      RETURN VARCHAR2;
      
   FUNCTION get_amt_tag (p_source_cd VARCHAR2)
      RETURN VARCHAR2;
      
   FUNCTION get_or_tag  (p_source_cd VARCHAR2)
      RETURN VARCHAR2;
      
   PROCEDURE insert_giac_upload_file (
      p_source_cd           IN  VARCHAR2,
      p_file_name           IN  VARCHAR2,
      p_convert_date        IN  VARCHAR2,
      p_transaction_type    IN  VARCHAR2,
      p_remarks             IN  VARCHAR2,
      p_user_id             IN  VARCHAR2,
      p_file_no             OUT VARCHAR2
   );   
   
   TYPE file_source_lov_type2 IS RECORD (
      source_cd     giac_file_source.source_cd%TYPE,
      source_name   giac_file_source.source_name%TYPE,
      atm_tag       giac_file_source.atm_tag%TYPE
   );
   
   TYPE file_source_lov_tab2 IS TABLE OF file_source_lov_type2;
   
   FUNCTION get_file_source_lov2
      RETURN file_source_lov_tab2 PIPELINED;
   FUNCTION GET_GIACS605_SOURCE_LOV ( -- Dren Niebres 10.03.2016 SR-4572 : Added LOV for GIACS605 Source
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS605_SOURCE_LOV_TAB PIPELINED;    
   FUNCTION GET_GIACS606_SOURCE_LOV (-- Dren Niebres 10.03.2016 SR-4573 : Added LOV for GIACS606 Source
        P_SEARCH        VARCHAR2
   ) 
      RETURN GIACS606_SOURCE_LOV_TAB PIPELINED;     
   
END;
/
