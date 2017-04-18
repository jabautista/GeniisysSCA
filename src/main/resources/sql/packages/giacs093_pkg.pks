CREATE OR REPLACE PACKAGE CPI.GIACS093_PKG
AS

    TYPE branch_lov_type IS RECORD (
        branch_cd           GIAC_BRANCHES.branch_cd%TYPE,
        branch_name         GIAC_BRANCHES.branch_name%TYPE
   );
   
   TYPE branch_lov_tab IS TABLE OF branch_lov_type;
   
   
    FUNCTION get_branch_lov(
        p_user      GIIS_USERS.USER_ID%type
    ) RETURN branch_lov_tab PIPELINED;	
        
    FUNCTION validate_branch_cd(
        p_branch_cd     GIAC_BRANCHES.BRANCH_CD%type,
        p_user          GIIS_USERS.USER_ID%type
    ) RETURN VARCHAR2;
    
    
    PROCEDURE POPULATE_GIAC_PDC(
        p_as_of_date        IN  giac_apdc_payt_dtl.CHECK_DATE%type,
        p_cut_off_date      IN  giac_order_of_payts.OR_DATE%type,
        p_branch_cd         IN  GIAC_BRANCHES.BRANCH_CD%type,
        p_register          IN  VARCHAR2,
        p_outstanding       IN  VARCHAR2,
        p_user              IN  GIAC_PDC_EXT.USER_ID%type,
        p_extract_flag      OUT VARCHAR2,
        p_begin_extract     OUT VARCHAR2,
        p_end_extract       OUT VARCHAR2,
        p_msg               OUT VARCHAR2        
    );
    
    PROCEDURE last_extract_params(
        p_user_id           IN  VARCHAR2,
        p_as_of_date        OUT VARCHAR2,
        p_cut_off_date      OUT VARCHAR2,
        p_pdc_type          OUT VARCHAR2,
        p_branch_cd         OUT VARCHAR2,
        p_branch_name       OUT VARCHAR2
    );
    
END GIACS093_PKG;
/


