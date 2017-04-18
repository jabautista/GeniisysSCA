CREATE OR REPLACE PACKAGE CPI.GIPIR037C_PKG

AS
    TYPE gipir037c_type IS RECORD(
        assd_name               giis_assured.assd_name%TYPE,
        tsi_amt                 gixx_firestat_summary_dtl.tsi_amt%TYPE,
        prem_amt                gixx_firestat_summary_dtl.prem_amt%TYPE,
        tarf_cd                 gixx_firestat_summary_dtl.tarf_cd%TYPE,
        policy_no               VARCHAR2(100),
        tarf_desc               giis_tariff.tarf_desc%TYPE,
        company_name            giis_parameters.param_value_v%TYPE,
        company_address         giis_parameters.param_value_v%TYPE,
        v_date                  VARCHAR2(100)
    );
    
    TYPE gipir037c_tab IS TABLE OF gipir037c_type;
    
    FUNCTION get_gipir037c_details(
        p_date                   VARCHAR2,
        p_as_of                  VARCHAR2,
        p_from_date              VARCHAR2,
        p_to_date                VARCHAR2, 
        p_user_id                VARCHAR2,
        p_zone_type              VARCHAR2
    )RETURN gipir037c_tab PIPELINED;
     
END GIPIR037C_PKG;
/


