CREATE OR REPLACE PACKAGE CPI.giacr256_pkg AS

/*
**Created by : Benedict G. Castillo
**Date Created: 07/24/2013
**Description : GIACR256 - TAXES WITHHELD FROM ALL PAYEES - DETAILED
*/

TYPE giacr256_type IS RECORD(
    company_name            VARCHAR2(200),
    company_address         VARCHAR2(500),
    flag                    VARCHAR2(2),
    v_label                 VARCHAR2(100),
    payee_class             giis_payee_class.class_desc%TYPE,
    name                    VARCHAR2(700),
    mail_add                VARCHAR2(500),
    tin                     giis_payees.tin%TYPE,
    v_desc                  VARCHAR2(500),
    bir_tax_cd              giac_wholding_taxes.bir_tax_cd%TYPE,
    tran_date               giac_acctrans.tran_date%TYPE,
    posting_date            giac_acctrans.posting_date%TYPE,
    ref_no                  VARCHAR2(50),
    income                  NUMBER(18,2),
    wtax                    NUMBER(18,2)
);
TYPE giacr256_tab IS TABLE OF giacr256_type;

FUNCTION populate_giacr256(
    p_date1             VARCHAR2,
    p_date2             VARCHAR2,
    p_exclude_tag       VARCHAR2,
    p_module_id         VARCHAR2,
    p_payee             VARCHAR2,
    p_post_tran_toggle  VARCHAR2,
    p_tax_cd            VARCHAR2, --Added by Jerome 09.26.2016 SR 5671
    p_user_id           VARCHAR2
)RETURN giacr256_tab PIPELINED;
END giacr256_pkg;
/


