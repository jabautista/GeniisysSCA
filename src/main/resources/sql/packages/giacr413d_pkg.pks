CREATE OR REPLACE PACKAGE CPI.GIACR413D_PKG AS

TYPE GIACR413D_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE,
    intm_type           GIIS_INTERMEDIARY.INTM_TYPE%TYPE,
    intm_desc           GIIS_INTM_TYPE.INTM_DESC%TYPE,
    intm_no             GIIS_INTERMEDIARY.INTM_NO%TYPE,
    intm_name           GIIS_INTERMEDIARY.INTM_NAME%TYPE,
    comm                GIAC_COMM_PAYTS.COMM_AMT%TYPE,
    wtax                GIAC_COMM_PAYTS.WTAX_AMT%TYPE,
    input_vat           GIAC_COMM_PAYTS.INPUT_VAT_AMT%TYPE,
    post_format         VARCHAR2(30),
    period              VARCHAR2(50)
);

TYPE GIACR413D_tab IS TABLE OF GIACR413D_type;

FUNCTION populate_GIACR413D(
    p_intm_type      GIIS_INTERMEDIARY.INTM_TYPE%TYPE,
    p_tran_post      VARCHAR2,
    p_from_date      DATE,
    p_to_date        DATE,
    p_user_id        GIIS_USERS.USER_ID%TYPE
)
    RETURN GIACR413D_tab PIPELINED;
END GIACR413D_PKG;
/


