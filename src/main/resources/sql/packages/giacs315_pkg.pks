CREATE OR REPLACE PACKAGE CPI.GIACS315_PKG
AS
    TYPE module_type IS RECORD(
        module_id       GIAC_FUNCTIONS.MODULE_ID%type,
        module_name     GIAC_MODULES.MODULE_NAME%type,
        scrn_rep_name   GIAC_MODULES.SCRN_REP_NAME%type
    );
    
    TYPE module_tab IS TABLE OF module_type;
    
    
    FUNCTION get_module_lov    
        RETURN module_tab PIPELINED;
        
        
    TYPE function_type IS RECORD (    
        function_code   GIAC_FUNCTIONS.FUNCTION_CODE%type,
        function_name   GIAC_FUNCTIONS.FUNCTION_NAME%type,
        function_desc   GIAC_FUNCTIONS.FUNCTION_DESC%type
    );
    
    TYPE function_tab IS TABLE OF function_type;
    
    
    FUNCTION get_function_lov(
        p_module_id     GIAC_FUNCTIONS.MODULE_ID%type
    ) RETURN function_tab PIPELINED;
    
        
    TYPE user_type IS RECORD(
        user_id         GIAC_USERS.USER_ID%type,
        user_name       GIAC_USERS.USER_NAME%type
    );
    
    TYPE user_tab IS TABLE OF user_type;
    
    
    FUNCTION get_user_lov
        RETURN user_tab PIPELINED;
        
    
    TYPE rec_type IS RECORD(
        module_id           GIAC_USER_FUNCTIONS.MODULE_ID%type,
        function_code       GIAC_USER_FUNCTIONS.FUNCTION_CODE%type,
        user_id             GIAC_USER_FUNCTIONS.USER_ID%type,
        user_name           GIAC_USERS.USER_NAME%type,
        user_function_id    GIAC_USER_FUNCTIONS.USER_FUNCTION_ID%type,
        valid_tag           GIAC_USER_FUNCTIONS.VALID_TAG%type,
        dsp_valid_tag       VARCHAR2(10),
        validity_dt         GIAC_USER_FUNCTIONS.VALIDITY_DT%type,
        termination_dt      GIAC_USER_FUNCTIONS.TERMINATION_DT%type,
        remarks             GIAC_USER_FUNCTIONS.REMARKS%type,
        tran_user_id        GIAC_USER_FUNCTIONS.TRAN_USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;
    
    
    FUNCTION get_rec_list(
        p_module_id         GIAC_USER_FUNCTIONS.MODULE_ID%type,
        p_function_code     GIAC_USER_FUNCTIONS.FUNCTION_CODE%type
    ) RETURN rec_tab PIPELINED;   

    
    PROCEDURE set_rec (p_rec    GIAC_USER_FUNCTIONS%rowtype);
    
    
    PROCEDURE del_rec(
        p_module_id         GIAC_USER_FUNCTIONS.MODULE_ID%type,
        p_function_code     GIAC_USER_FUNCTIONS.FUNCTION_CODE%type,
        p_user_id           GIAC_USER_FUNCTIONS.USER_ID%type,
        p_user_function_id  GIAC_USER_FUNCTIONS.USER_FUNCTION_ID%type
    );

END GIACS315_PKG;
/


