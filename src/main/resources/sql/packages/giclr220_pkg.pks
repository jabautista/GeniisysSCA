CREATE OR REPLACE PACKAGE CPI.giclr220_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/19/2013
**Description:GICLR220 - Biggest Claims
*/
TYPE giclr220_type IS RECORD(
    flag                VARCHAR2(2),
    date_lbl            VARCHAR2(500),
    company_name        VARCHAR2(500),
    company_address     VARCHAR2(500),
    title               VARCHAR2(200),
    line_name           VARCHAR2(25),
    subline_name        VARCHAR2(35),
    iss_name            VARCHAR2(25),
    intm_name           VARCHAR2(250),
    assd_name           VARCHAR2(505),
    claim_number        VARCHAR2(30),
    policy_number       VARCHAR2(50),
    assd_name_det       giis_assured.assd_name%TYPE,
    intm_name_det       VARCHAR2(1000),
    loss_date           gicl_clm_summary.loss_date%TYPE,
    clm_file_date       gicl_clm_summary.clm_file_date%TYPE,
    loss_amt            gicl_clm_summary.loss_amt%TYPE,
    expense_amt         gicl_clm_summary.expense_amt%TYPE,
    net_ret_loss        gicl_clm_summary.net_ret_loss%TYPE,
    net_ret_exp         gicl_clm_summary.net_ret_exp%TYPE,
    facul_exp           gicl_clm_summary.facul_exp%TYPE,
    facul_loss          gicl_clm_summary.facul_loss%TYPE,
    treaty_loss         gicl_clm_summary.treaty_loss%TYPE,
    treaty_exp          gicl_clm_summary.treaty_exp%TYPE,
    xol_loss            gicl_clm_summary.xol_loss%TYPE,
    xol_exp             gicl_clm_summary.xol_exp%TYPE,
    loss_exp_amt        NUMBER(16,2),
    v_ri_cd             giac_parameters.param_value_v%TYPE ,
    dummy               giac_parameters.param_value_v%TYPE                 
);
TYPE giclr220_tab IS TABLE OF giclr220_type;

FUNCTION populate_giclr220 (
    p_col               VARCHAR2,
    p_amt               VARCHAR2,
    p_assd_no           NUMBER,
    p_date              VARCHAR2,
    p_date_as           DATE,
    p_date_fr           DATE,
    p_date_to           DATE,
    p_extract_type      VARCHAR2,
    p_intm_no           NUMBER,
    p_iss_cd            VARCHAR2,
    p_line_cd           VARCHAR2,
    p_loss_exp          VARCHAR2,
    p_session_id        NUMBER,
    p_subline_cd        VARCHAR2
)
RETURN giclr220_tab PIPELINED;
END giclr220_pkg;
/


