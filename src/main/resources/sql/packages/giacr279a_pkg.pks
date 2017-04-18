CREATE OR REPLACE PACKAGE CPI.giacr279a_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07.16.2013
**Description: GIACR279A - Losses Recoverable from Facultative RI 
*/

TYPE giacr279a_type IS RECORD(
    company_name            VARCHAR2(500),
    company_address         VARCHAR2(500),
    as_of_date              VARCHAR2(100),
    cut_off_date            VARCHAR2(100),
    flag                    VARCHAR2(2),
    title                   VARCHAR2(200),
    ri_cd                   giac_loss_rec_soa_ext.ri_cd%TYPE,
    ri_name                 giac_loss_rec_soa_ext.ri_name%TYPE,
    line_cd                 giac_loss_rec_soa_ext.line_cd%TYPE,
    line_name               giac_loss_rec_soa_ext.line_name%TYPE,
    fla_date                giac_loss_rec_soa_ext.fla_date%TYPE,
    fla_no                  giac_loss_rec_soa_ext.fla_no%TYPE,
    claim_no                giac_loss_rec_soa_ext.claim_no%TYPE,
    claim_id                giac_loss_rec_soa_ext.claim_id%TYPE,
    policy_no               giac_loss_rec_soa_ext.policy_no%TYPE,
    assd_name               giac_loss_rec_soa_ext.assd_name%TYPE,
    assd_no                 giac_loss_rec_soa_ext.assd_no%TYPE, --CarloR sr-5350 06.24.2016
    payee_type              giac_loss_rec_soa_ext.payee_type%TYPE,
    amount_due              giac_loss_rec_soa_ext.amount_due%TYPE
);
TYPE giacr279a_tab IS TABLE OF giacr279a_type;

FUNCTION populate_giacr279a(
    p_as_of_date        VARCHAR2,
    p_cut_off_date      VARCHAR2,
    p_line_cd           VARCHAR2,
    p_ri_cd             VARCHAR2,
    p_user_id           VARCHAR2,
    p_payee_type        VARCHAR2,
    p_payee_type2       VARCHAR2
)
RETURN giacr279a_tab PIPELINED;

TYPE column_title_type IS RECORD(
    column_no               giis_report_aging.column_no%TYPE,
    column_title            giis_report_aging.column_title%TYPE
);
TYPE column_title_tab IS TABLE OF column_title_type;

FUNCTION get_column_title RETURN column_title_tab PIPELINED;

TYPE matrix_details_type IS RECORD(
    column_no               giis_report_aging.column_no%TYPE,
    policy_no               giac_loss_rec_soa_ext.policy_no%TYPE,
    claim_no                giac_loss_rec_soa_ext.claim_no%TYPE, 
    payee_type              giac_loss_rec_soa_ext.payee_type%TYPE,
    fla_no                  giac_loss_rec_soa_ext.fla_no%TYPE,
    amount_due              giac_loss_rec_soa_ext.amount_due%TYPE,
    line_cd                 giac_loss_rec_soa_ext.line_cd%TYPE,
    ri_cd                 giac_loss_rec_soa_ext.ri_cd%TYPE
);
TYPE matrix_details_tab IS TABLE OF matrix_details_type;

FUNCTION get_matrix_details(
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
    p_amount_due            giac_loss_rec_soa_ext.amount_due%TYPE
    
)
RETURN matrix_details_tab PIPELINED;


END giacr279a_pkg;
/


