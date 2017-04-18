CREATE OR REPLACE PACKAGE CPI.GIACR222A_PKG
AS

    TYPE giacr222a_type IS RECORD (
        line_cd                 giac_treaty_perils.line_cd%TYPE,
        trty_yy                 giac_treaty_perils.trty_yy%TYPE,
        share_cd                giac_treaty_perils.share_cd%TYPE,
        ri_cd                   giac_treaty_perils.ri_cd%TYPE,
        ri_name                 giis_reinsurer.ri_name%TYPE,
        proc_year               giac_treaty_perils.proc_year%TYPE,
        proc_qtr                giac_treaty_perils.proc_qtr%TYPE,
        peril_name              giis_peril.peril_name%TYPE,
        trty_name               giis_dist_share.trty_name%TYPE,
        period                  VARCHAR2(100),
        commission_amt          NUMBER(20,2),
        retain_amt              NUMBER(20,2),
        tax_amt                 NUMBER(20,2),
        company_name            giis_parameters.param_value_v%TYPE,
        company_address         giis_parameters.param_value_v%TYPE
    );
    
    TYPE giacr222a_tab IS TABLE OF giacr222a_type;
    
    FUNCTION get_report_details(
        p_line_cd       giac_treaty_perils.line_cd%TYPE,
        p_trty_yy       giac_treaty_perils.trty_yy%TYPE,
        p_share_cd      giac_treaty_perils.sharE_cd%TYPE,
       -- p_ri_cd         giac_treaty_perils.ri_cd%TYPE,
        p_proc_year     giac_treaty_perils.proc_year%TYPE,
        p_proc_qtr      giac_treaty_perils.proc_qtr%TYPE
    ) RETURN giacr222a_tab PIPELINED;

END GIACR222A_PKG;
/


