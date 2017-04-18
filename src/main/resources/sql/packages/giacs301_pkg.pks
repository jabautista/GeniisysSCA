CREATE OR REPLACE PACKAGE CPI.GIACS301_PKG
AS
    TYPE param_type_lov_type IS RECORD(
        rv_low_value        CG_REF_CODES.RV_LOW_VALUE%type,
        rv_meaning          CG_REF_CODES.RV_MEANING%type
    );
    
    TYPE param_type_lov_tab IS TABLE OF param_type_lov_type;
    
    FUNCTION get_param_type_lov
        RETURN param_type_lov_tab PIPELINED;
        

    TYPE rec_type IS RECORD(
        param_name          GIAC_PARAMETERS.PARAM_NAME%type,
        param_type          GIAC_PARAMETERS.PARAM_TYPE%type,
        mean_param_type     VARCHAR2(240),
        param_value_d       GIAC_PARAMETERS.PARAM_VALUE_D%type,
        dsp_param_value_d   VARCHAR(30),
        param_value_n       GIAC_PARAMETERS.PARAM_VALUE_N%type,
        param_value_v       GIAC_PARAMETERS.PARAM_VALUE_V%type,
        remarks             GIAC_PARAMETERS.REMARKS%type,
        user_id             GIAC_PARAMETERS.USER_ID%type,
        last_update         VARCHAR2(30)
    );
    
    TYPE rec_tab IS TABLE OF rec_type;

    FUNCTION get_rec_list (
        p_param_name        GIAC_PARAMETERS.PARAM_NAME%type
    ) RETURN rec_tab PIPELINED;

    PROCEDURE set_rec (p_rec GIAC_PARAMETERS%ROWTYPE);

    PROCEDURE del_rec (p_param_name GIAC_PARAMETERS.PARAM_NAME%type);

    PROCEDURE val_del_rec (p_param_name GIAC_PARAMETERS.PARAM_NAME%type);
   
    PROCEDURE val_add_rec(p_param_name GIAC_PARAMETERS.PARAM_NAME%type);

END GIACS301_PKG;
/


