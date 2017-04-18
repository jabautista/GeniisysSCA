CREATE OR REPLACE PACKAGE CPI.giac_banks_details_pkg
AS
   TYPE giac_banks_details_type IS RECORD (
      bank_name    giac_banks.bank_name%TYPE,
      bank_sname   giac_banks.bank_sname%TYPE,
      bank_cd      giac_banks.bank_cd%TYPE
   );

   TYPE giac_banks_details_tab IS TABLE OF giac_banks_details_type;     
   FUNCTION get_bank_details
      RETURN giac_banks_details_tab PIPELINED;
      
   FUNCTION get_dcb_bank_name 
         RETURN giac_banks_details_tab PIPELINED;  
      
   FUNCTION cf_bank_snameformula (
      p_bank_cd    GIAC_BANKS.bank_cd%TYPE,
      p_paymode    GIAC_COLLECTION_DTL.pay_mode%TYPE
   ) RETURN VARCHAR2;

   FUNCTION get_giac_bank_listing(p_find_text VARCHAR2)
      RETURN giac_banks_details_tab PIPELINED;   
--------------------------------------------------------------------------   
   TYPE GIACS035_BANK_CD_LOV_TYPE IS RECORD (-- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_CD_LOV - Start
      BANK_CD         GIAC_BANKS.BANK_CD%TYPE,
      BANK_NAME       GIAC_BANKS.BANK_NAME%TYPE
   ); 
   TYPE GIACS035_BANK_CD_LOV_TAB IS TABLE OF GIACS035_BANK_CD_LOV_TYPE; 
   FUNCTION GET_GIACS035_BANK_CD_LOV (
        P_SEARCH        VARCHAR2
   ) 
   RETURN GIACS035_BANK_CD_LOV_TAB PIPELINED; -- dren 07.16.2015 : SR 0017729 - Added GIACS035_BANK_CD_LOV - End      
                  
END giac_banks_details_pkg;
/


