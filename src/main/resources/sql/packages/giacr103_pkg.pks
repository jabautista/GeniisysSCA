CREATE OR REPLACE PACKAGE CPI.GIACR103_PKG AS

/*
**Created by: Benedict G. Castillo
**Date Created: 07/25/2013
**Description: GIACR103 : LIST OF UNDISTRIBUTED POLICIES
*/

TYPE giacr103_type IS RECORD(
    flag            VARCHAR2(2),
    company_name    VARCHAR2(300),
    company_address VARCHAR2(500),
    as_of           VARCHAR2(100),
    dist_flag       gipi_polbasic.dist_flag%TYPE,
    rv_meaning      cg_ref_codes.rv_meaning%TYPE,
    line_name       VARCHAR(30),
    subline_name    VARCHAR2(40),
    policy_endor    VARCHAR2(200),
    issue_date      gipi_polbasic.issue_date%TYPE,
    incept_date     gipi_polbasic.incept_date%TYPE,
    assd_name       giis_assured.assd_name%TYPE,
    tsi_amt         gipi_polbasic.tsi_amt%TYPE,
    prem_amt        gipi_polbasic.prem_amt%TYPE
    
);
TYPE giacr103_tab IS TABLE OF giacr103_type;

FUNCTION populate_giacr103(
    p_line_cd       VARCHAR2,
    p_user_id       VARCHAR2
)RETURN giacr103_tab PIPELINED;

END GIACR103_PKG;
/
