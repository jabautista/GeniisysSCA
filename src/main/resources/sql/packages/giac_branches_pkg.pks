CREATE OR REPLACE PACKAGE CPI.GIAC_BRANCHES_PKG
AS
   TYPE branch_details_type IS RECORD (
      gfun_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      branch_cd        giac_branches.branch_cd%TYPE,
      acct_branch_cd   giac_branches.acct_branch_cd%TYPE,
      branch_name      giac_branches.branch_name%TYPE,
      user_id          giac_branches.user_id%TYPE,
      last_update      giac_branches.last_update%TYPE,
      remarks          giac_branches.remarks%TYPE,
      cpi_rec_no       giac_branches.cpi_rec_no%TYPE,
      cpi_branch_cd    giac_branches.cpi_branch_cd%TYPE,
      prnt_branch_cd   giac_branches.prnt_branch_cd%TYPE,
      bank_cd          giac_branches.bank_cd%TYPE,
      bank_acct_cd     giac_branches.bank_acct_cd%TYPE,
      comp_cd          giac_branches.comp_cd%TYPE,
      fund_desc        giis_funds.fund_desc%TYPE
   );

   TYPE branch_cd_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE
   );

   TYPE branch_details_tab IS TABLE OF branch_details_type;

   TYPE branch_cd_lov_tab IS TABLE OF branch_cd_lov_type;

   FUNCTION get_branch_details
      RETURN branch_details_tab PIPELINED;

   FUNCTION get_other_branch_or (
      p_module_id   VARCHAR2,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_details_tab PIPELINED;

   PROCEDURE get_dflt_bank_acct (
      p_branch_cd            giac_acct_entries.gacc_gibr_branch_cd%TYPE,
      p_fund_cd              giac_acct_entries.gacc_gfun_fund_cd%TYPE,
      p_user_id              giis_users.user_id%TYPE,
      p_bank_cd        OUT   giac_dcb_users.bank_cd%TYPE,
      p_bank_acct_cd   OUT   giac_dcb_users.bank_acct_cd%TYPE,
      p_bank_name      OUT   giac_banks.bank_name%TYPE,
      p_bank_acct_no   OUT   giac_bank_accounts.bank_acct_no%TYPE,
      p_message        OUT   VARCHAR2
   );

   FUNCTION get_branch_cd_lov (
      p_gfun_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_control_module   VARCHAR2,
      p_keyword          VARCHAR2,
      p_user             VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION get_giac_branches (p_user giis_users.user_id%TYPE)
      RETURN branch_details_tab PIPELINED;

   FUNCTION get_branch_lov (
      p_gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_keyword        VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION get_branch_details2 (p_branch_cd giac_branches.branch_cd%TYPE)
      RETURN branch_details_tab PIPELINED;

   TYPE get_other_branch_listing_type IS RECORD (
      gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      branch_cd      giac_branches.branch_cd%TYPE,
      branch_name    giac_branches.branch_name%TYPE
   );

   TYPE get_other_branch_listing_tab IS TABLE OF get_other_branch_listing_type;

   FUNCTION get_other_branch_listing (
      p_module_id    VARCHAR2,
      p_user_id      giis_users.user_id%TYPE,
      p_from_claim   VARCHAR2
   )
      RETURN get_other_branch_listing_tab PIPELINED;

   FUNCTION get_branch_cd_lov2 (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   VARCHAR2,
      p_user_id     VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED;

   /*
   **  Created by   :  Justhel Bactung
   **  Date Created :  01.31.2013
   **  Reference By : (GIACS231 - Transaction Status)
   **  Description  : Gets the records of BRANCH_CD LOV
   */
   TYPE get_branch_lov_type IS RECORD (
      branch_cd     giac_branches.branch_cd%TYPE,
      branch_name   giac_branches.branch_name%TYPE,
      fund_cd       giis_funds.fund_cd%TYPE,
      fund_desc     giis_funds.fund_desc%TYPE
   );

   TYPE get_branch_lov_tab IS TABLE OF get_branch_lov_type;

   FUNCTION get_branch_lov_list (
      p_module_id      giis_modules.module_id%TYPE,
      p_branch         giac_branches.branch_name%TYPE,
      p_gfun_fund_cd   giac_acctrans.gfun_fund_cd%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN get_branch_lov_tab PIPELINED;

   FUNCTION get_branch_cd_lov3 (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_module_id   VARCHAR2
   )
      RETURN get_branch_lov_tab PIPELINED;

   -- added by Kris 04.16.2013 for GIACS002
   FUNCTION get_branch_cd_lov4 (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_branch_cd   giac_branches.branch_cd%TYPE
   )
      RETURN branch_details_tab PIPELINED;

   --added by Shan 04.22.2013 for GIACS230
   FUNCTION get_branch_lov2 (
      p_gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      p_module_id      giis_modules.module_id%TYPE,
      p_search         giac_branches.branch_name%TYPE,
      p_user           giis_users.user_id%TYPE
   )
      RETURN branch_details_tab PIPELINED;

   FUNCTION fetch_branch_list (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   --pol cruz, GIACS072
   FUNCTION get_branch_cd_lov5 (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION validate_branch_cd (
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN VARCHAR2;

   --Kris 06.27.2013 for GIACS118
   FUNCTION get_branch_cd_lov6 (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED;

   --Kris 07.0+.2013 for GIACS184
   FUNCTION get_branch_cd_lov7 (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED;

   --added by Shan 06.13.2013 for GIACS117
   FUNCTION get_branch_lov3 (
      --p_gibr_branch_cd    GIAC_ORDER_OF_PAYTS.GIBR_BRANCH_CD%type,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION validate_giacs117_branch_cd (
      p_gibr_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_module_id        giis_modules.module_id%TYPE,
      p_user             giis_users.user_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_giacs178_branch_lov (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_details_tab PIPELINED;

   FUNCTION validate_giacs178_branch_cd (
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2,
      p_branch_cd   VARCHAR2
   )
      RETURN VARCHAR2;

   --added by Shan 06.19.2013 for GIACS170
   FUNCTION get_branch_lov4 (
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION validate_giacs170_branch_cd (
      p_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN VARCHAR2;

   --added by Shan 06.25.2013 for GIACS078
   FUNCTION get_branch_lov5 (
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION validate_giacs078_branch_cd (
      p_gibr_branch_cd   giac_order_of_payts.gibr_branch_cd%TYPE,
      p_module_id        giis_modules.module_id%TYPE,
      p_user             giis_users.user_id%TYPE
   )
      RETURN VARCHAR2;

   --added by shan 06.28.2013
   FUNCTION get_giacs273_branch_lov (
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION validate_giacs273_branch_cd (
      p_branch_cd   giac_branches.branch_cd%TYPE,
      p_fund_cd     giac_branches.gfun_fund_cd%TYPE,
      p_module_id   giis_modules.module_id%TYPE,
      p_user        giis_users.user_id%TYPE
   )
      RETURN VARCHAR2;

   FUNCTION get_branch_per_fund_lov (
      p_fund_cd     VARCHAR2,
      p_user_id     VARCHAR2,
      p_module_id   VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION get_branch_lov_in_acctrans (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION val_branch_cd_in_acctrans (
      p_module_id   giis_modules.module_id%TYPE,
      p_user_id     giis_users.user_id%TYPE,
      p_branch_cd   VARCHAR2
   )
      RETURN VARCHAR2;

   FUNCTION get_giacs127_branch_lov (p_user_id VARCHAR2, p_module_id VARCHAR2)
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION get_branch_giacs240_lov (
      p_gfun_fund_cd   giac_branches.gfun_fund_cd%TYPE,
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;

   FUNCTION get_branch_lovgiacs414 (p_user_id giis_users.user_id%TYPE)
      RETURN branch_cd_lov_tab PIPELINED;
      
   FUNCTION get_giacs053_branch_lov(
      p_fund_cd         giac_branches.gfun_fund_cd%TYPE,
      p_module_id       giis_modules.module_id%TYPE,
      p_user_id         giis_users.user_id%TYPE,
      p_find_text       VARCHAR2
   )
     RETURN branch_cd_lov_tab PIPELINED;

--kenneth L 10.14.2013
   FUNCTION get_giarpr001_branch_lov (
      p_user_id   giis_users.user_id%TYPE,
      p_month     NUMBER,
      p_year      NUMBER
   )
      RETURN branch_cd_lov_tab PIPELINED;
      
      FUNCTION get_generalbranch_lov (
      p_module_id      giis_modules.module_id%TYPE,
      p_user_id        giis_users.user_id%TYPE,
      p_keyword        VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED;
      
   FUNCTION get_dynamic_branch_lov (
      p_user_id        giis_users.user_id%TYPE,
      p_module_id      giis_modules.module_id%TYPE
   )
      RETURN branch_cd_lov_tab PIPELINED;
      
   FUNCTION get_giacs104branch_lov (
      p_user_id        giis_users.user_id%TYPE,
      p_keyword        VARCHAR2
   )
      RETURN branch_cd_lov_tab PIPELINED;
END GIAC_BRANCHES_PKG;
/
