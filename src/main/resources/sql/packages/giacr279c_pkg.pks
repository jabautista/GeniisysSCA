CREATE OR REPLACE PACKAGE CPI.giacr279c_pkg AS

/*
**Crated by: Benedict G. Castillo
**Date Created: 07.18.2013
**Description: GIACR279C- Losses Recoverable from Facultative RI
*/

TYPE giacr279c_type IS RECORD(
    company_name            VARCHAR2(500),
    company_address         VARCHAR2(500),
    title                   VARCHAR2(100),
    flag                    VARCHAR2(2),
    as_of                   VARCHAR2(100),
    cut_off                 VARCHAR2(100),
    ri_cd                   giac_loss_rec_soa_ext.ri_cd%TYPE,
    ri_name                 giac_loss_rec_soa_ext.ri_name%TYPE,
    line_cd                 giac_loss_rec_soa_ext.line_cd%TYPE,
    line_name               giac_loss_rec_soa_ext.line_name%TYPE,
    short_name              giis_currency.short_name%TYPE,
    convert_rate            giac_loss_rec_soa_ext.convert_rate%TYPE,
    convert_rates           VARCHAR2(20),
    fla_date                giac_loss_rec_soa_ext.fla_date%TYPE,
    fla_no                  giac_loss_rec_soa_ext.fla_no%TYPE,
    claim_id                giac_loss_rec_soa_ext.claim_id%TYPE,
    claim_no                giac_loss_rec_soa_ext.claim_no%TYPE,
    policy_no               giac_loss_rec_soa_ext.policy_no%TYPE,
    assd_no                 giac_loss_rec_soa_ext.assd_no%TYPE, --RCarlo SR-5352 06.27.2016
    assd_name               giac_loss_rec_soa_ext.assd_name%TYPE,
    payee_type              giac_loss_rec_soa_ext.payee_type%TYPE,
    convert_amt             NUMBER(16,2),
    amount_due              giac_loss_rec_soa_ext.amount_due%TYPE
);
TYPE giacr279c_tab IS TABLE OF giacr279c_type;

FUNCTION populate_giacr279c(
    p_as_of_date            VARCHAR2,
    p_cut_off_date          VARCHAR2,
    p_line_cd               VARCHAR2,
    p_payee_type            VARCHAR2,
    p_payee_type2           VARCHAR2,
    p_ri_cd                 VARCHAR2,
    p_user_id               VARCHAR2
)
RETURN giacr279c_tab PIPELINED;

TYPE matrix_header_type IS RECORD(
    column_no               giis_report_aging.column_no%TYPE,
    column_title            giis_report_aging.column_title%TYPE
);
TYPE matrix_header_tab IS TABLE OF matrix_header_type;

FUNCTION get_giacr279c_matrix_header RETURN matrix_header_tab PIPELINED;

TYPE matrix_details_type IS RECORD(
    column_no               giis_report_aging.column_no%TYPE,
    convert_amt             NUMBER(16,2),
    claim_no                giac_loss_rec_soa_ext.claim_no%TYPE,
    convert_rate            giac_loss_rec_soa_ext.convert_rate%TYPE,
    short_name              giis_currency.short_name%TYPE,
    line_cd                 giac_loss_rec_soa_ext.line_cd%TYPE,
    ri_cd                   giac_loss_rec_soa_ext.ri_cd%TYPE,
    flag                    VARCHAR2(2)
);
TYPE matrix_details_tab IS TABLE OF matrix_details_type;

FUNCTION get_giacr279c_matrix_details(
    p_as_of_date            VARCHAR2,
    p_cut_off_date          VARCHAR2,
    p_ri_cd                 VARCHAR2,
    p_line_cd               VARCHAR2,
    p_user_id               VARCHAR2,
    p_policy_no             giac_loss_rec_soa_ext.policy_no%TYPE,
    p_claim_no              giac_loss_rec_soa_ext.claim_no%TYPE, 
    p_payee_type            giac_loss_rec_soa_ext.payee_type%TYPE,
    p_payee_type2           giac_loss_rec_soa_ext.payee_type%TYPE,
    p_fla_no                giac_loss_rec_soa_ext.fla_no%TYPE,
    p_amount_due            giac_loss_rec_soa_ext.amount_due%TYPE,
    p_convert_rate          giac_loss_rec_soa_ext.convert_rate%TYPE,
    p_short_name            giis_currency.short_name%TYPE
    
)
RETURN matrix_details_tab PIPELINED;

END giacr279c_pkg;
/


