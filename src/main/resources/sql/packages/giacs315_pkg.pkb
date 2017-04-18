CREATE OR REPLACE PACKAGE BODY CPI.GIACS315_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   12.16.2013
     ** Referenced by:  GIACS315 - User per Function Maintenance
     **/
    FUNCTION get_module_lov    
       RETURN module_tab PIPELINED
    AS
        lov     module_type;
    BEGIN   
        FOR i IN (SELECT DISTINCT module_id
                    FROM GIAC_FUNCTIONS
                   WHERE active_tag = 'Y')
        LOOP
            lov.module_id       := i.module_id;
            
            BEGIN
                SELECT module_name
                  INTO lov.module_name
                  FROM GIAC_MODULES
                 WHERE module_id = i.module_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    lov.module_name := null;
            END;
            
            BEGIN
                SELECT scrn_rep_name
                  INTO lov.scrn_rep_name
                  FROM GIAC_MODULES
                 WHERE module_id = i.module_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    lov.scrn_rep_name := null;
            END;
            
            PIPE ROW(lov);
        END LOOP;
    END get_module_lov;


    FUNCTION get_function_lov(
        p_module_id     GIAC_FUNCTIONS.MODULE_ID%type
    ) RETURN function_tab PIPELINED
    AS
        lov     function_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_FUNCTIONS
                   WHERE active_tag = 'Y'
                     AND UPPER(module_id) = UPPER(p_module_id))
        LOOP
            lov.function_code   := i.function_code;
            lov.function_name   := i.function_name;
            lov.function_desc   := i.function_desc;            
            
            PIPE ROW(lov);
        END LOOP;
    END get_function_lov;
    

    FUNCTION get_user_lov
        RETURN user_tab PIPELINED
    AS
        lov     user_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_USERS
                   WHERE active_tag = 'Y')
        LOOP
            lov.user_id     := i.user_id;
            lov.user_name   := i.user_name;
            
            PIPE ROW(lov);
        END LOOP;
    END get_user_lov;
    
    
    FUNCTION get_rec_list(
        p_module_id         GIAC_USER_FUNCTIONS.MODULE_ID%type,
        p_function_code     GIAC_USER_FUNCTIONS.FUNCTION_CODE%type
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR i IN (SELECT a.*, DECODE(valid_tag, 'Y', 'Valid', 'N', 'Not Valid') dsp_valid_tag
                    FROM GIAC_USER_FUNCTIONS a
                   WHERE module_id = p_module_id
                     AND function_code = p_function_code)
        LOOP
            rec.module_id           := i.module_id;
            rec.function_code       := i.function_code;
            rec.user_id             := i.user_id;
            rec.user_function_id    := i.user_function_id;
            rec.valid_tag           := i.valid_tag;
            rec.dsp_valid_tag       := i.dsp_valid_tag;
            rec.validity_dt         := i.validity_dt;
            rec.termination_dt      := i.termination_dt;
            rec.remarks             := i.remarks;
            rec.tran_user_id        := i.tran_user_id;
            rec.last_update         := TO_CHAR(i.last_update, 'MM-DD-RRRR HH:MI:SS AM');
            
            BEGIN
                SELECT user_name
                  INTO rec.user_name
                  FROM GIAC_USERS
                 WHERE user_id = i.user_id;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                    rec.user_name   := null;
            END;
            
            PIPE ROW(rec);
        END LOOP;
    END get_rec_list;  
    
    PROCEDURE set_rec (p_rec    GIAC_USER_FUNCTIONS%rowtype)
    AS
    BEGIN
        MERGE INTO GIAC_USER_FUNCTIONS
        USING DUAL
           ON (module_id = p_rec.module_id
               AND function_code = p_rec.function_code
               AND user_id = p_rec.user_id
               AND user_function_id = p_rec.user_function_id)
         WHEN NOT MATCHED THEN
            INSERT (module_id, function_code, user_id, user_function_id, valid_tag, validity_dt, termination_dt,
                    remarks, tran_user_id, last_update)
            VALUES (p_rec.module_id, p_rec.function_code, p_rec.user_id, p_rec.user_function_id, p_rec.valid_tag, p_rec.validity_dt, p_rec.termination_dt,
                    p_rec.remarks, p_rec.tran_user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE 
               SET  valid_tag       = p_rec.valid_tag,
                    validity_dt     = p_rec.validity_dt,
                    termination_dt  = p_rec.termination_dt,
                    remarks         = p_rec.remarks,
                    tran_user_id    = p_rec.tran_user_id,
                    last_update     = SYSDATE
         ;
    END set_rec;
    
    
    PROCEDURE del_rec(
        p_module_id         GIAC_USER_FUNCTIONS.MODULE_ID%type,
        p_function_code     GIAC_USER_FUNCTIONS.FUNCTION_CODE%type,
        p_user_id           GIAC_USER_FUNCTIONS.USER_ID%type,
        p_user_function_id  GIAC_USER_FUNCTIONS.USER_FUNCTION_ID%type
    )AS
    BEGIN
        DELETE FROM GIAC_USER_FUNCTIONS
         WHERE module_id = p_module_id
           AND function_code = p_function_code
           AND user_id = p_user_id
           AND user_function_id = p_user_function_id;
    END del_rec;

END GIACS315_PKG;
/


