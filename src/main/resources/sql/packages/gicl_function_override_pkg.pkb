CREATE OR REPLACE PACKAGE BODY CPI.GICL_FUNCTION_OVERRIDE_PKG
AS
    
    FUNCTION get_functions_list (
        p_user_id       VARCHAR2
    ) RETURN funct_override_list_tab PIPELINED
    IS
        v_fo_list_tab   funct_override_list;
        
    BEGIN
        FOR i IN   (SELECT a.module_id, a.function_code, a.function_name, b.module_name 
                      FROM giac_functions a, giac_modules b, giac_user_functions c 
                     WHERE a.module_id = b.module_id 
                       AND a.active_tag = 'Y' 
                       AND a.override_sw = 'Y' 
                       AND a.function_code = c.function_code 
                       AND a.module_id = c.module_id 
                       AND c.user_id = p_user_id 
                       AND c.valid_tag = 'Y' 
                       AND c.validity_dt < SYSDATE 
                       AND NVL(termination_dt, SYSDATE) >= SYSDATE)
        LOOP
            SELECT DISTINCT b.module_name
              INTO v_fo_list_tab.module_name
              FROM giac_functions a, giac_modules b
             WHERE b.module_id = i.module_id;
       
            v_fo_list_tab.module_id     := i.module_id;
            --v_fo_list_tab.module_name   := i.module_name;
            v_fo_list_tab.function_code := i.function_code;
            v_fo_list_tab.function_name := i.function_name;
            
            PIPE ROW(v_fo_list_tab);
        END LOOP;
    END get_functions_list;    
    
    
    FUNCTION get_function_records (
        --p_module_id     giac_functions.MODULE_ID%TYPE,
        p_function_cd   giac_functions.FUNCTION_CODE%TYPE,
        p_user_id       VARCHAR2
    ) RETURN funct_override_info_tab PIPELINED
    IS
        v_fo_info_tab   funct_override_info;
    BEGIN
        FOR i IN   (SELECT a.override_id, a.line_cd, a.iss_cd, a.module_id, a.function_cd, a.display, e.module_name, a.request_date,
                           a.request_by, a.override_user, a.override_date, a.remarks, a.user_id,a.last_update
                      FROM GICL_FUNCTION_OVERRIDE a, giac_modules e 
                     WHERE a.override_user IS NULL 
                       AND a.module_id = e.module_id
                       AND Check_User_Per_Line2(a.line_cd,a.ISS_CD,'GICLS183', p_user_id) = 1                       
                       --AND Check_User_Per_iss_cd_acctg2(a.line_cd,a.ISS_CD,'GICLS183', p_user_id) = 1
                       --AND a.module_id = p_module_id
                       AND a.function_cd = p_function_cd)
        LOOP
            v_fo_info_tab.approve_sw        := 'N';
            v_fo_info_tab.override_id       := i.override_id;
            v_fo_info_tab.line_cd           := i.line_cd;
            v_fo_info_tab.iss_cd            := i.iss_cd;
            v_fo_info_tab.module_id         := i.module_id;
            v_fo_info_tab.function_cd       := i.function_cd;
            v_fo_info_tab.display           := i.display;
            v_fo_info_tab.module_name       := i.module_name;
            v_fo_info_tab.request_date      := i.request_date;
            v_fo_info_tab.request_by        := i.request_by;
            v_fo_info_tab.override_user     := i.override_user;
            v_fo_info_tab.override_date     := i.override_date;
            v_fo_info_tab.remarks           := i.remarks;
            v_fo_info_tab.user_id           := i.user_id;
            v_fo_info_tab.last_update       := i.last_update; 
            v_fo_info_tab.dsp_last_update   := TO_CHAR(i.last_update, 'MM-DD-YYYY HH:MI:SS AM');
        
            PIPE ROW(v_fo_info_tab);
        END LOOP;
    END get_function_records;
    
    
    PROCEDURE update_function_override(
        p_override_id       GICL_FUNCTION_OVERRIDE.OVERRIDE_ID%TYPE,
        p_override_user     GICL_FUNCTION_OVERRIDE.OVERRIDE_USER%TYPE,
        p_remarks           GICL_FUNCTION_OVERRIDE.REMARKS%TYPE
    )
    AS
    BEGIN
        UPDATE GICL_FUNCTION_OVERRIDE
           SET override_user = p_override_user,
               override_date = SYSDATE,
               remarks = p_remarks
         WHERE override_id = p_override_id;
    END update_function_override;
    
    
   PROCEDURE update_record_remarks(
        p_override_id   GICL_FUNCTION_OVERRIDE.OVERRIDE_ID%TYPE,
        p_remarks       GICL_FUNCTION_OVERRIDE.REMARKS%TYPE,
        p_user_id       GICL_FUNCTION_OVERRIDE.USER_ID%TYPE      
    )
    AS
    BEGIN
        UPDATE GICL_FUNCTION_OVERRIDE
           SET remarks = p_remarks,
               user_id = p_user_id
         WHERE override_id = p_override_id ;
    END update_record_remarks;
    
END GICL_FUNCTION_OVERRIDE_PKG;
/


