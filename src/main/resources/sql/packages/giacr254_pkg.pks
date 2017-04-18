CREATE OR REPLACE PACKAGE CPI.giacr254_pkg AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/23/2013
**Description: GIACR254 : Tax Withheld
*/

TYPE giacr254_type IS RECORD(
    company_name        VARCHAR2(200),
    company_address     VARCHAR2(500),
    flag                VARCHAR2(2),
    v_date              VARCHAR2(100),
    bir_tax_cd          giac_wholding_taxes.bir_tax_cd%TYPE,
    whtax_desc          giac_wholding_taxes.whtax_desc%TYPE,
    payee_class         giis_payee_class.class_desc%TYPE,
    name                VARCHAR2(700),
    buss_add            VARCHAR2(500),
    tin                 giis_payees.tin%TYPE,
    trans_date          giac_acctrans.tran_date%TYPE,
    posting_date        giac_acctrans.posting_date%TYPE,
    tran_class          giac_acctrans.tran_class%TYPE,
    income              NUMBER(18,2),
    wtax                NUMBER(18,2),
    refno               VARCHAR2(20)
);
TYPE giacr254_tab IS TABLE OF giacr254_type;

FUNCTION populate_giacr254(
    p_date1                 VARCHAR2,
    p_date2                 VARCHAR2,
    p_exclude_tag           VARCHAR2,
    p_module_id             VARCHAR2,
    p_payee                 VARCHAR2,
    p_post_tran_toggle      VARCHAR2,
    p_tax_id                VARCHAR2,
    p_user_id               VARCHAR2
    
)
RETURN giacr254_tab PIPELINED;
END giacr254_pkg;
/


