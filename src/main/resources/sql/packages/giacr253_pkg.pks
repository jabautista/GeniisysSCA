CREATE OR REPLACE PACKAGE CPI.giacr253_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/23/2013
**Description: GIACR253: TAXES WITHHELD
*/

TYPE giacr253_type IS RECORD(
    company_name        VARCHAR2(200),
    company_address     VARCHAR2(500),
    flag                VARCHAR2(2),
    v_date              VARCHAR2(100),
    bir_tax_cd          giac_wholding_taxes.bir_tax_cd%TYPE,
    whtax_desc          giac_wholding_taxes.whtax_desc%TYPE,
    class_desc          giis_payee_class.class_desc%TYPE,
    name                VARCHAR2(700),
    tin                 giis_payees.tin%TYPE,
    income              NUMBER(18,2),
    wtax                NUMBER(18,2)
);
TYPE giacr253_tab IS TABLE OF giacr253_type;

FUNCTION populate_giacr253(
    p_date1             VARCHAR2,
    p_date2             VARCHAR2,
    p_exculde_tag       VARCHAR2,
    p_exclude_tag       VARCHAR2,
    p_module_id         VARCHAR2,
    p_payee             VARCHAR2,
    p_post_tran_toggle  VARCHAR2,
    p_tax_id            VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr253_tab PIPELINED;

END giacr253_pkg;
/


