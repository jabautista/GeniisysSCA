CREATE OR REPLACE PACKAGE CPI.GIACR413C_PKG AS

    TYPE commission_payt_type IS RECORD (
        intm_no             giis_intermediary.intm_no%TYPE,
        intm_name           giis_intermediary.intm_name%TYPE,
        intm_type           giis_intermediary.intm_type%TYPE,
        intm_desc           giis_intm_type.intm_desc%TYPE,
        line_cd             gipi_polbasic.line_cd%TYPE,
        commission          NUMBER,
        witholding_tax      NUMBER,
        input_vat           NUMBER,
        net                 NUMBER,
        cf_company_name     GIAC_PARAMETERS.param_value_v%TYPE,
        cf_company_add      GIAC_PARAMETERS.param_value_v%TYPE,
        cf_period           VARCHAR2(50),
        cf_tran_post        VARCHAR2(50)
    );
    
    TYPE commission_payt_tab IS TABLE OF commission_payt_type;
    
    FUNCTION get_commission_payt_dtls(
        p_tran_post     NUMBER,
        p_from_dt       DATE,
        p_to_dt         DATE,
        p_intm_type     giis_intm_type.intm_type%TYPE,
        p_module_id     giis_modules.module_id%TYPE,
        p_user_id       giis_users.user_id%TYPE
    ) RETURN commission_payt_tab PIPELINED;
    
END GIACR413C_PKG;
/


