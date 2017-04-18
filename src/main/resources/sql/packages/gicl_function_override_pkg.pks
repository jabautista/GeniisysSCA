CREATE OR REPLACE PACKAGE CPI.GICL_FUNCTION_OVERRIDE_PKG
AS
    TYPE funct_override_list IS RECORD (
        module_id       giac_functions.MODULE_ID%type,
        module_name     giac_modules.MODULE_NAME%type,    
        function_code   giac_functions.FUNCTION_CODE%type,
        function_name   giac_functions.FUNCTION_NAME%type
    );
    
    TYPE funct_override_list_tab IS TABLE OF funct_override_list;
    
    TYPE funct_override_info IS RECORD (
        approve_sw      VARCHAR2(1),
        override_id     GICL_FUNCTION_OVERRIDE.OVERRIDE_ID%TYPE,
        line_cd         GICL_FUNCTION_OVERRIDE.LINE_CD%TYPE,
        iss_cd          GICL_FUNCTION_OVERRIDE.ISS_CD%TYPE,
        module_id       GICL_FUNCTION_OVERRIDE.MODULE_ID%TYPE,
        function_cd     GICL_FUNCTION_OVERRIDE.FUNCTION_CD%TYPE,
        display         GICL_FUNCTION_OVERRIDE.DISPLAY%TYPE,
        module_name     giac_modules.MODULE_NAME%type,
        request_date    GICL_FUNCTION_OVERRIDE.REQUEST_DATE%TYPE,  --VARCHAR2(10), 
        request_by      GICL_FUNCTION_OVERRIDE.REQUEST_BY%TYPE,
        override_user   GICL_FUNCTION_OVERRIDE.OVERRIDE_USER%TYPE,
        override_date   GICL_FUNCTION_OVERRIDE.OVERRIDE_DATE%TYPE,
        remarks         GICL_FUNCTION_OVERRIDE.REMARKS%TYPE,
        user_id         GICL_FUNCTION_OVERRIDE.USER_ID%TYPE,
        last_update     GICL_FUNCTION_OVERRIDE.LAST_UPDATE%TYPE,
        dsp_last_update VARCHAR2(50)
    );
    
    TYPE funct_override_info_tab IS TABLE OF funct_override_info;
    
    FUNCTION get_functions_list (
        p_user_id       VARCHAR2
    ) RETURN funct_override_list_tab PIPELINED;
    
    FUNCTION get_function_records (
        --p_module_id     giac_functions.MODULE_ID%TYPE,
        p_function_cd   giac_functions.FUNCTION_CODE%TYPE,
        p_user_id       VARCHAR2
    ) RETURN funct_override_info_tab PIPELINED;

    PROCEDURE update_function_override(
        p_override_id       GICL_FUNCTION_OVERRIDE.OVERRIDE_ID%TYPE,
        p_override_user     GICL_FUNCTION_OVERRIDE.OVERRIDE_USER%TYPE,
        p_remarks           GICL_FUNCTION_OVERRIDE.REMARKS%TYPE
    );
    
    PROCEDURE update_record_remarks(
        p_override_id   GICL_FUNCTION_OVERRIDE.OVERRIDE_ID%TYPE,
        p_remarks       GICL_FUNCTION_OVERRIDE.REMARKS%TYPE,
        p_user_id       GICL_FUNCTION_OVERRIDE.USER_ID%TYPE      
    );
    
END GICL_FUNCTION_OVERRIDE_PKG;
/


