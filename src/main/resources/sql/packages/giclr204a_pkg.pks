CREATE OR REPLACE PACKAGE CPI.GICLR204A_PKG AS

TYPE GICLR204A_type IS RECORD(
    company_name        GIAC_PARAMETERS.param_value_v%TYPE,
    company_address     GIAC_PARAMETERS.param_value_v%TYPE,
    line_cd             gicl_loss_ratio_ext.LINE_CD%TYPE,
    line_name           GIIS_LINE.line_name%TYPE,
    loss_ratio_date     gicl_loss_ratio_ext.LOSS_RATIO_DATE%TYPE,
    curr_prem_amt       gicl_loss_ratio_ext.CURR_PREM_AMT%TYPE,
    prem_res_cy         gicl_loss_ratio_ext.CURR_PREM_AMT%TYPE,
    prem_res_py         gicl_loss_ratio_ext.PREV_PREM_AMT%TYPE,
    loss_paid_amt       gicl_loss_ratio_ext.LOSS_PAID_AMT%TYPE,
    curr_loss_res       gicl_loss_ratio_ext.CURR_LOSS_RES%TYPE,
    prev_loss_res       gicl_loss_ratio_ext.PREV_LOSS_RES%TYPE,
    premiums_earned     gicl_loss_ratio_ext.PREV_PREM_RES%TYPE,
    losses_incurred     gicl_loss_ratio_ext.CURR_LOSS_RES%TYPE,
    subline_name        giis_subline.SUBLINE_NAME%TYPE,
    iss_name            giis_issource.ISS_NAME%TYPE,
    intm_name           giis_intermediary.INTM_NAME%TYPE,
    assd_name           GIIS_ASSURED.ASSD_NAME%TYPE,
    loss_ratio          NUMBER(16,4), --Dren Niebres 06.03.2016 SR-21428
    as_of_date          VARCHAR2(100)
);

TYPE GICLR204A_tab IS TABLE OF GICLR204A_type;

FUNCTION populate_items(
    p_session_id NUMBER,
    p_date       DATE,
    p_line_cd   GIIS_LINE.LINE_CD%TYPE,
    p_subline_cd GIIS_SUBLINE.SUBLINE_CD%TYPE,
    p_intm_no GIIS_INTERMEDIARY.intm_no%TYPE,
    p_iss_cd GIIS_ISSOURCE.iss_CD%TYPE,
    p_ASSD_NO    GIIS_assured.ASSD_NO%TYPE
    
    
)
RETURN GICLR204A_tab PIPELINED;

FUNCTION get_line_name(
    p_line_cd GIIS_LINE.LINE_CD%TYPE
    
)
RETURN VARCHAR2;

FUNCTION get_subline_name(
    p_subline_cd GIIS_SUBLINE.SUBLINE_CD%TYPE
    
)
RETURN VARCHAR2;

FUNCTION get_iss_name(
    p_iss_cd GIIS_ISSOURCE.iss_CD%TYPE
    
)
RETURN VARCHAR2;

FUNCTION get_intm_name(
    p_intm_no GIIS_INTERMEDIARY.intm_no%TYPE
    
)
RETURN VARCHAR2;

FUNCTION get_assd_name(
    p_assd_no GIIS_ASSURED.ASSD_NO%TYPE
    
)
RETURN VARCHAR2;

END GICLR204A_PKG;
/


