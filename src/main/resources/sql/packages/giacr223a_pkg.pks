CREATE OR REPLACE PACKAGE CPI.GIACR223A_PKG
AS

    TYPE giacr223a_type IS RECORD (
        ri_cd               giis_reinsurer.ri_cd%TYPE,
        reinsurer           giis_reinsurer.ri_name%TYPE,
        treaty_name         giis_dist_share.trty_name%TYPE,
        period              VARCHAR2(100),
        loss_paid           NUMBER(20,2),
        loss_expense        NUMBER(20,2),
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE
    );
    
    TYPE giacr223a_tab IS TABLE OF giacr223a_type;
    
    FUNCTION get_report_details(
        p_line_cd           giac_treaty_claims.LINE_CD%TYPE,
        p_trty_yy           giac_treaty_claims.trty_yy%TYPE,
        p_treaty_seq_no     giac_treaty_claims.treaty_seq_no%TYPE,
        p_proc_year         giac_treaty_claims.proc_year%TYPE,
        p_proc_qtr          giac_treaty_claims.proc_qtr%TYPE
    ) RETURN giacr223a_tab PIPELINED;    
    
END GIACR223A_PKG;
/


