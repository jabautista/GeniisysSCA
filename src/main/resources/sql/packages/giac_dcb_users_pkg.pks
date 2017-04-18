CREATE OR REPLACE PACKAGE CPI.giac_dcb_users_pkg
AS
   TYPE giac_dcb_users_type IS RECORD (
      gibr_fund_cd     giac_dcb_users.gibr_fund_cd%TYPE,
      gibr_branch_cd   giac_dcb_users.gibr_branch_cd%TYPE,
      cashier_cd       giac_dcb_users.cashier_cd%TYPE,
      dcb_user_id      giac_dcb_users.dcb_user_id%TYPE,
      valid_tag        GIAC_DCB_USERS.valid_tag%TYPE,
      effectivity_dt   GIAC_DCB_USERS.effectivity_dt%TYPE,
      expiry_dt        GIAC_DCB_USERS.expiry_dt%TYPE
   );

   TYPE giac_dcb_users_tab IS TABLE OF giac_dcb_users_type;

   FUNCTION get_cashier_cd (
      p_fund_cd     giac_dcb_users.gibr_fund_cd%TYPE,
      p_branch_cd   giac_dcb_users.gibr_branch_cd%TYPE,
	  p_user_id     giac_dcb_users.user_id%TYPE
   )
      RETURN giac_dcb_users_tab PIPELINED;
      
   FUNCTION get_valid_user_info(
      p_fund_cd     giac_dcb_users.gibr_fund_cd%TYPE,
      p_branch_cd   giac_dcb_users.gibr_branch_cd%TYPE,
      p_user_id     giac_dcb_users.user_id%TYPE
   ) RETURN giac_dcb_users_tab PIPELINED;
   
   FUNCTION check_if_user_exists(p_user_id  GIAC_DCB_USERS.user_id%TYPE)
     RETURN VARCHAR2;
   
END giac_dcb_users_pkg;
/


