CREATE OR REPLACE PACKAGE CPI.giis_funds_pkg
AS
   TYPE fund_cd_type IS RECORD (
      fund_cd     giac_branches.gfun_fund_cd%TYPE,
      fund_desc   giis_funds.fund_desc%TYPE
   );

   TYPE fund_cd_tab IS TABLE OF fund_cd_type;

   FUNCTION get_fund_cd_lov (p_keyword VARCHAR2)
      RETURN fund_cd_tab PIPELINED;

   FUNCTION get_fund_cd_lov2
      RETURN fund_cd_tab PIPELINED;

   /*
   **  Created by   :  Justhel Bactung
   **  Date Created :  01.31.2013
   **  Reference By : (GIACS231 - Transaction Status)
   **  Description  : Gets the records of FUND_CD LOV
   */
   TYPE get_company_lov_type IS RECORD (
      fund_cd     giis_funds.fund_cd%TYPE,
      fund_desc   giis_funds.fund_desc%TYPE
   );

   TYPE get_company_lov_tab IS TABLE OF get_company_lov_type;

   FUNCTION get_company_lov_list (p_fund giis_funds.fund_desc%TYPE)
      RETURN get_company_lov_tab PIPELINED;
     
   FUNCTION get_fund_cd_lov3(
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_keyword  	   VARCHAR2
   )
      RETURN fund_cd_tab PIPELINED;
      
END giis_funds_pkg;
/


