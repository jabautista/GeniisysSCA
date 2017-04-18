CREATE OR REPLACE PACKAGE CPI.GIPIR037B_PKG


AS
    TYPE gipir037b_type IS RECORD(
        trty_name               giis_dist_share.trty_name%TYPE,
        assd_name               gipi_firestat_zone_dtl_v.assd_name%TYPE,
        policy_no               gipi_firestat_zone_dtl_v.policy_no%TYPE,
        share_tsi_amt           gipi_firestat_zone_dtl_v.share_tsi_amt%TYPE,
        share_prem_amt          gipi_firestat_zone_dtl_v.share_prem_amt%TYPE,
        company_name            giis_parameters.param_value_v%TYPE,
        company_address         giis_parameters.param_value_v%TYPE,
        v_date                  VARCHAR2(100)
        
    );
    
    TYPE gipir037b_tab IS TABLE OF gipir037b_type;
    
    FUNCTION get_gipir037b_details(
        p_as_of_sw               gipi_firestat_zone_dtl_v.as_of_sw%TYPE,            
        p_user_id                VARCHAR2,
        p_date                   VARCHAR2,
        p_as_of                  VARCHAR2,
        p_from_date              VARCHAR2,
        p_to_date                VARCHAR2  
        
    )RETURN gipir037b_tab PIPELINED;
    
    FUNCTION get_gipir037b_details_v2(
        p_as_of_sw               gipi_firestat_zone_dtl_v.as_of_sw%TYPE,            
        p_user_id                VARCHAR2,
        p_date                   VARCHAR2,
        p_as_of                  VARCHAR2,
        p_from_date              VARCHAR2,
        p_to_date                VARCHAR2,
        p_zone_type              VARCHAR2,  
        p_line_cd_fi             VARCHAR2
    )RETURN gipir037b_tab PIPELINED;    
    
END GIPIR037B_PKG;
/


