CREATE OR REPLACE PACKAGE CPI.giacr255_pkg AS

/*
**Created by:  Benedict G. Castillo
**Date Created: 07/23/2013
**Description: GIACR255 - Taxes Withheld -Detailed
*/

TYPE giacr255_type IS RECORD(
    company_name        VARCHAR2(200),
    company_address     VARCHAR2(500),
    flag                VARCHAR2(2),
    v_date              VARCHAR2(200),
    payee_class         giis_payee_class.class_desc%TYPE,
    name                VARCHAR2(700),
    tran_date           giac_acctrans.tran_date%TYPE,
    posting_date        giac_acctrans.posting_date%TYPE,
    ref_no              VARCHAR2(50),
    income              NUMBER(18,2),
    wtax                NUMBER(18,2)
);
TYPE giacr255_tab IS TABLE OF giacr255_type;

FUNCTION populate_giacr255(
    p_date1             VARCHAR2,
    p_date2             VARCHAR2,
    p_exclude_tag       VARCHAR2,
    p_module_id         VARCHAR2,
    p_payee             VARCHAR2,
    p_post_tran_toggle  VARCHAR2,
    p_user_id           VARCHAR2

) RETURN giacr255_tab PIPELINED;

END giacr255_pkg;
/


