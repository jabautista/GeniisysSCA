CREATE OR REPLACE PACKAGE BODY CPI.GIACS301_PKG
AS
    /** Created By:     Shan Bati
     ** Date Created:   11.25.2013
     ** Referenced By:  GIACS301 - Accounting Parameters Maintenance
     **/
    FUNCTION get_param_type_lov
        RETURN param_type_lov_tab PIPELINED
    AS
        lov     param_type_lov_type;
    BEGIN
        FOR i IN (SELECT  substr(RV_LOW_VALUE,1,1)  RV_LOW_VALUE,
                          substr(RV_MEANING,1,8)  RV_MEANING
                    FROM  CG_REF_CODES
                   WHERE  RV_DOMAIN = 'GIAC_PARAMETERS.PARAM_TYPE'
                   ORDER  BY  RV_LOW_VALUE)
        LOOP
            lov.rv_low_value    := i.rv_low_value;
            lov.rv_meaning      := i.rv_meaning;
            
            PIPE ROW(lov);
        END LOOP;
    END get_param_type_lov;
    
     
    FUNCTION get_rec_list (
        p_param_name        GIAC_PARAMETERS.PARAM_NAME%type
    ) RETURN rec_tab PIPELINED
    AS
        rec     rec_type;
    BEGIN
        FOR i IN (SELECT *
                    FROM GIAC_PARAMETERS
                   WHERE UPPER(param_name) LIKE UPPER(NVL(p_param_name, '%')))
        LOOP
            rec.param_name          := i.param_name;
            rec.param_type          := i.param_type;
            rec.param_value_d       := i.param_value_d;
            rec.dsp_param_value_d   := TO_CHAR (i.param_value_d, 'MM-DD-YYYY'); 
            rec.param_value_n       := i.param_value_n;
            rec.param_value_v       := i.param_value_v;
            rec.remarks             := i.remarks;
            rec.user_id             := i.user_id;
            rec.last_update         := TO_CHAR (i.last_update, 'MM-DD-YYYY HH:MI:SS AM');  
            
             BEGIN
                CHK_CHAR_REF_CODES(
                  rec.param_type                      /* MOD: Value to be validated    */
                 ,rec.MEAN_PARAM_TYPE           /* MOD: Domain meaning           */
                 ,'GIAC_PARAMETERS.PARAM_TYPE');  /* IN : Reference codes domain   */
             EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  rec.mean_param_type := NULL;
             END;  
        
            PIPE ROW(rec);
        END LOOP;
    END get_rec_list;
    

    PROCEDURE set_rec (p_rec GIAC_PARAMETERS%ROWTYPE)
    AS
    BEGIN
        MERGE INTO GIAC_PARAMETERS
         USING DUAL
         ON (param_name = p_rec.param_name)
         WHEN NOT MATCHED THEN
            INSERT (param_name, param_type, param_value_d, param_value_n, param_value_v, remarks, user_id, last_update)
            VALUES (p_rec.param_name, p_rec.param_type, p_rec.param_value_d, p_rec.param_value_n, p_rec.param_value_v, 
                    p_rec.remarks, p_rec.user_id, SYSDATE)
         WHEN MATCHED THEN
            UPDATE
               SET param_type       = p_rec.param_type,
                   param_value_d    = p_rec.param_value_d,
                   param_value_n    = p_rec.param_value_n,
                   param_value_v    = p_rec.param_value_v,
                   remarks          = p_rec.remarks, 
                   user_id          = p_rec.user_id, 
                   last_update      = SYSDATE
        ;
        
    END set_rec;
    

    PROCEDURE del_rec (p_param_name GIAC_PARAMETERS.PARAM_NAME%type)
    AS
    BEGIN
        DELETE FROM GIAC_PARAMETERS
         WHERE param_name = p_param_name;
    END del_rec;
    

    PROCEDURE val_del_rec (p_param_name GIAC_PARAMETERS.PARAM_NAME%type)
    AS
    BEGIN
        null;
    END val_del_rec;
    
   
    PROCEDURE val_add_rec(p_param_name GIAC_PARAMETERS.PARAM_NAME%type)
    AS
         v_exists   VARCHAR2 (1);
    BEGIN
        FOR i IN (SELECT '1'
                    FROM GIAC_PARAMETERS a
                   WHERE a.param_name = p_param_name)
        LOOP
            v_exists := 'Y';
            EXIT;
        END LOOP;

        IF v_exists = 'Y' THEN
            raise_application_error (-20001,
                                     'Geniisys Exception#E#Record already exists with the same Param Name.'
                                     );
        END IF;
    END val_add_rec;
    


END GIACS301_PKG;
/


