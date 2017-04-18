CREATE OR REPLACE PACKAGE CPI.GIIS_ISSOURCE_PKG
AS
   /********************************** FUNCTION 1 ************************************/

   TYPE issue_source_list_type IS RECORD
   (
      iss_cd     GIIS_ISSOURCE.iss_cd%TYPE,
      iss_name   GIIS_ISSOURCE.iss_name%TYPE
   );

   TYPE issue_source_acctg_list_type IS RECORD
   (
      iss_cd               GIIS_ISSOURCE.iss_cd%TYPE,
      iss_name             GIIS_ISSOURCE.iss_name%TYPE,
      user_iss_cd_access   NUMBER
   );

   TYPE issue_source_list_tab IS TABLE OF issue_source_list_type;

   TYPE issue_source_acctg_list_tab IS TABLE OF issue_source_acctg_list_type;

   TYPE issue_source_acctg_list_cur IS REF CURSOR
      RETURN issue_source_acctg_list_type;

   FUNCTION get_issue_source_list (p_iss_cd GIIS_ISSOURCE.iss_cd%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;

   /********************************** FUNCTION 2 ************************************
     MODULE: GIPIS002
     RECORD GROUP NAME: ISS_SOURCE
   ***********************************************************************************/

   FUNCTION get_issue_source_all_list
      RETURN issue_source_list_tab
      PIPELINED;


   /********************************** FUNCTION 3 ************************************
     MODULE: GIPIS050
     RECORD GROUP NAME: CGFK$B240_ISS_CD
   ***********************************************************************************/

   FUNCTION get_checked_issue_source_list (
      p_line_cd      GIIS_LINE.line_cd%TYPE,
      p_user_id      VARCHAR2,
      p_module_id    GIIS_USER_GRP_MODULES.module_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;

   FUNCTION get_iss_name (p_iss_cd GIIS_ISSOURCE.ISS_CD%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_iss_code (p_iss_name IN GIIS_ISSOURCE.iss_name%TYPE)
      RETURN VARCHAR2;

   FUNCTION get_iss_code (parameter_ri_switch    VARCHAR2,
                          cg$ctrl_cgu$user       VARCHAR2)
      RETURN VARCHAR2;

    /********************************** FUNCTION ************************************
  MODULE: GIACS007
  RECORD GROUP NAME: GDPC_ISS_CD1
***********************************************************************************/
   FUNCTION get_iss_code_per_acctg_module (moduleName    VARCHAR2,
                                           p_user_id     VARCHAR2)
      RETURN issue_source_list_tab
      PIPELINED;

    /********************************** FUNCTION ************************************
  MODULE: GIACS020
  RECORD GROUP NAME: ISS_CD_GROUP
***********************************************************************************/
   FUNCTION get_iss_cd_for_comm_invoice (p_module_name    VARCHAR2,
                                         p_user_id        VARCHAR2)
      RETURN issue_source_acctg_list_tab
      PIPELINED;

   /********************************** FUNCTION ************************************
   MODULE: GIACS018
   RECORD GROUP NAME: ISS_RG
 ***********************************************************************************/
   FUNCTION get_gicl_advice_iss_cd_listing (
      p_tran_type      GIAC_INW_CLAIM_PAYTS.transaction_type%TYPE,
      p_iss_cd         GIIS_ISSOURCE.iss_cd%TYPE,
      p_module_name    GIAC_MODULES.module_name%TYPE,
      p_user_id        giis_users.user_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;

   TYPE acct_iss_cd_list_type IS RECORD
   (
      iss_cd        GIIS_ISSOURCE.iss_cd%TYPE,
      iss_name      GIIS_ISSOURCE.iss_name%TYPE,
      acct_iss_cd   GIIS_ISSOURCE.acct_iss_cd%TYPE
   );

   TYPE acct_iss_cd_list_tab IS TABLE OF acct_iss_cd_list_type;

   FUNCTION get_acct_iss_cd_list
      RETURN acct_iss_cd_list_tab
      PIPELINED;

   FUNCTION get_pack_par_issue_source_list (
      p_line_cd      GIIS_LINE.line_cd%TYPE,
      p_module_id    GIIS_USER_GRP_MODULES.module_id%TYPE,
      p_user_id      GIIS_USERS.user_id%TYPE,
      p_ri_switch    VARCHAR2)
      RETURN issue_source_list_tab
      PIPELINED;

   FUNCTION get_region_cd (p_iss_cd IN giis_issource.iss_cd%TYPE)
      RETURN giis_issource.region_cd%TYPE;

   FUNCTION get_issue_source_ri_list
      RETURN issue_source_list_tab
      PIPELINED;

   FUNCTION get_iss_source_by_cred_br_tag (
      p_cred_br_tag GIIS_ISSOURCE.cred_br_tag%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;

   FUNCTION get_iss_cd_name (p_user_id      GIIS_USERS.user_id%TYPE,
                             p_line_cd      GIIS_LINE.line_cd%TYPE,
                             p_module_id    GIIS_MODULES.module_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;

   PROCEDURE validate_pol_iss_cd (
      p_pol_line_cd   IN     giis_line.line_cd%TYPE,
      p_pol_iss_cd    IN     giis_user_grp_line.iss_cd%TYPE,
      p_iss_ri        IN     giis_parameters.param_value_v%TYPE,
      p_user_id       IN     giis_users.user_id%TYPE,
      p_module_id     IN     giis_user_grp_modules.module_id%TYPE,
      p_msg              OUT VARCHAR2);

   FUNCTION get_polbasic_iss_list (
      p_line_cd       gipi_polbasic.line_cd%TYPE,
      p_subline_cd    gipi_polbasic.subline_cd%TYPE,
      p_user_id       giis_users.user_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;

   PROCEDURE validate_purge_iss_cd (
      p_iss_cd      IN     GIIS_ISSOURCE.iss_cd%TYPE,
      p_iss_name       OUT GIIS_ISSOURCE.iss_name%TYPE,
      p_line_cd     IN     GIIS_LINE.line_cd%TYPE,
      p_module_id   IN     GIIS_MODULES.module_id%TYPE,
      p_iss_ri         OUT VARCHAR2);

   --bonok :: 04.10.2012 :: issue source LOV for GIEXS006
   FUNCTION get_exp_rep_issource_lov (
      p_line_cd      GIIS_LINE.line_cd%TYPE,
      p_module_id    GIIS_USER_GRP_MODULES.module_id%TYPE,
      p_user_id      GIIS_USERS.USER_ID%TYPE) --PHILFIRE-SR-15082 incomplete listing for user JC
      RETURN issue_source_list_tab
      PIPELINED;

   --bonok :: 04.17.2012 :: validate issue source for GIEXS006
   FUNCTION validate_iss_cd_giexs006 (
      p_iss_cd       giis_issource.iss_cd%TYPE,
      p_line_cd      giis_line.line_cd%TYPE,
      p_module_id    giis_user_grp_modules.module_id%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;


   FUNCTION get_giri_winpolbas_issource (p_find_text VARCHAR2)
      RETURN issue_source_list_tab
      PIPELINED;
	
   --emsy 09.04.2012 ~ get issuing source for GIIMM001
   FUNCTION get_create_quotation_iss_cd(p_line_cd      giis_line.line_cd%TYPE,
     									p_module_id    giis_user_grp_modules.module_id%TYPE,
	 									p_user_id      giis_users.user_id%TYPE)
	RETURN issue_source_list_tab
	PIPELINED;
	
   FUNCTION validate_iss_cd (p_user_id      VARCHAR2,--GIIS_USERS.user_id%TYPE,
						 	 p_line_cd      VARCHAR2,--GIIS_LINE.line_cd%TYPE,
						 	 p_module_id    VARCHAR2,--GIIS_MODULES.module_id%TYPE,
							 p_iss_cd		VARCHAR2)
   RETURN VARCHAR2;
   
   FUNCTION get_iss_cd_by_cred_tag_exc_ri (
      p_cred_br_tag GIIS_ISSOURCE.cred_br_tag%TYPE)
      RETURN issue_source_list_tab
      PIPELINED;
      
   --shan 03.14.2013 -issue source LOV for GICLS201
   FUNCTION get_iss_gicls201_LOV(p_module_id     GIIS_USER_GRP_MODULES.MODULE_ID%TYPE)
        RETURN issue_source_list_tab PIPELINED;
        
   -- shan 03.15.2013
    PROCEDURE get_issue_name_gicls201(
        p_module_id     IN  GIIS_MODULES.MODULE_ID%TYPE,
        p_iss_cd        IN  GIIS_ISSOURCE.ISS_CD%TYPE,
        p_user          IN  GIIS_USERS.USER_ID%type,
        p_iss_name      OUT GIIS_ISSOURCE.ISS_NAME%TYPE,
        p_found         OUT VARCHAR2
    );
    
    -- added by Kris 05.03.2013 for GIACS180
    FUNCTION get_giacs180_iss_lov (
        p_user_id       giis_users.user_id%TYPE,
        p_module_id     giis_modules.module_id%TYPE
    ) RETURN issue_source_list_tab PIPELINED;
   
   --Kenneth L. 04.24.2013
    FUNCTION get_iss_lov_giuts022(
       p_search         VARCHAR2,
       p_user_id        giis_users.user_id%TYPE
    )
     RETURN issue_source_list_tab PIPELINED;
     
   --Kenneth L. 04.24.2013
    FUNCTION get_endt_iss_lov_giuts022(
       p_search         VARCHAR2,
       p_user_id        giis_users.user_id%TYPE
    )
     RETURN issue_source_list_tab PIPELINED;
    
    --added by : Kenneth L. 07.16.2013 :for giacs286
    FUNCTION get_giacs286_iss_lov(
        p_user_id              GIIS_USERS.user_id%type
    ) RETURN issue_source_list_tab PIPELINED;
    
    FUNCTION get_basic_issource_lov(
       p_user_id        VARCHAR2,
       p_module_id      VARCHAR2
    )
       RETURN issue_source_list_tab PIPELINED;

   FUNCTION get_all_issource_lov(
      p_iss_cd          giis_issource.iss_cd%TYPE
   ) RETURN issue_source_list_tab PIPELINED;
   
   FUNCTION get_gicls254_iss_lov(
      p_line_cd      VARCHAR2,
      p_iss_cd       VARCHAR2,
      p_user_id      VARCHAR2
   )
      RETURN issue_source_list_tab PIPELINED;
      
   FUNCTION get_giacs299_branch_lov(
      p_module_id          giis_modules.module_id%TYPE,
      p_user_id            giis_users.user_id%TYPE,
      p_keyword            VARCHAR2
   ) RETURN issue_source_list_tab PIPELINED;
   
   /* benjo 11.12.2015 UW-SPECS-2015-087 */
   FUNCTION get_giexs001_cred_branch_lov(
      p_user_id            giis_users.user_id%TYPE,
      p_line_cd            giis_line.line_cd%TYPE,
      p_module_id          giis_modules.module_id%TYPE
   ) RETURN issue_source_list_tab PIPELINED;
          
END GIIS_ISSOURCE_PKG;
/
