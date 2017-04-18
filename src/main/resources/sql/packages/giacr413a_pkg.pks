CREATE OR REPLACE PACKAGE CPI.giacr413a_pkg AS

/*
** Created by : Benedict G. Castillo
** Date Created : 07.11.2013
** Description : GIACR413A_PKG-Commisions Paid
*/

TYPE giacr413a_type IS RECORD(
    company_name        VARCHAR2(100),
    company_address     VARCHAR2(400),
    period              VARCHAR2(50),
    tran_post           VARCHAR2(50),
    flag                VARCHAR2(2),
    iss_cd              gipi_comm_invoice.iss_cd%TYPE,
    branch_name         VARCHAR2(30),
    intm_type           giis_intermediary.intm_type%TYPE,
    intm_desc           VARCHAR2(20),
    intm_no             giac_comm_payts.intm_no%TYPE,
    intm_name           giis_intermediary.intm_name%TYPE,
    line_cd             gipi_polbasic.line_cd%TYPE,
    comm                giac_comm_payts.comm_amt%TYPE,
    wtax                giac_comm_payts.wtax_amt%TYPE,
    input_vat           NUMBER(12,2),
    net_amt             NUMBER(12,2)
);
TYPE giacr413a_tab IS TABLE OF giacr413a_type;

FUNCTION populate_giacr413a(
    p_branch            VARCHAR2,
    p_from_date         VARCHAR2,
    p_to_date           VARCHAR2,
    p_tran_post         VARCHAR2,
    p_module_id         VARCHAR2,
    p_intm_type         VARCHAR2,
    p_user_id           VARCHAR2
)
RETURN giacr413a_tab PIPELINED; 

END giacr413a_PKG;
/


