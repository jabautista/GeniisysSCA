CREATE OR REPLACE PACKAGE CPI.GIEXR108_PKG
AS
    TYPE get_details_type IS RECORD(
                iss_name            giis_issource.iss_name%TYPE,
                line_name           giis_line.line_name%TYPE,
                subline_name        giis_subline.subline_name%TYPE,
                intm_no             giex_ren_ratio_dtl.intm_no%TYPE,
                intm_name           giis_intermediary.intm_name%TYPE,
                assd_no             giex_ren_ratio_dtl.assd_no%TYPE,
                assd_name           giis_assured.assd_name%TYPE,
                expiry_date         gipi_polbasic.expiry_date%TYPE,
                policy_id           gipi_polbasic.policy_id%TYPE,
                prem_amt            giex_ren_ratio_dtl.prem_amt%TYPE,              
                prem_renew_amt      giex_ren_ratio_dtl.prem_renew_amt%TYPE,
                ref_pol_no          gipi_polbasic.ref_pol_no%TYPE,
                policy_no           VARCHAR(100),
                remarks             VARCHAR2(500),
                company_name        VARCHAR2(2000),
                company_address     VARCHAR2(2000),
                renewal_policy      VARCHAR(4000),
                ref_ren_pol         VARCHAR(100),
                ref_ren_pol2        VARCHAR(100),
                ren_prem_amt        VARCHAR(5000),
                report_title        giis_reports.report_title%TYPE,
                date_range          VARCHAR2(2000),
                v_flag              VARCHAR2(1)
    );
    TYPE get_details_tab IS TABLE OF get_details_type;
    
    FUNCTION get_details(p_date_from        DATE,
                     p_date_to              DATE,
                     p_iss_cd               VARCHAR2,
                     p_cred_cd              VARCHAR2,
                     p_intm_no              NUMBER,
                     p_line_cd              VARCHAR2,
                     p_user_id              giis_users.user_id%TYPE)
                     
    RETURN get_details_tab PIPELINED;
    FUNCTION get_company_name
    RETURN VARCHAR2;
    
    FUNCTION get_comp_address
    RETURN VARCHAR2;
    
    FUNCTION date_formula(p_date_from       DATE,
                          p_date_to         DATE
    )
    RETURN VARCHAR2;
    
    FUNCTION intm_name_formula(p_intm_no        giex_ren_ratio_dtl.intm_no%TYPE
    )
    RETURN VARCHAR2;
    
    FUNCTION renewal_policy_formula(p_remarks       VARCHAR2,
                                    p_policy_id     gipi_polbasic.policy_id%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION ref_ren_pol(p_cp_1         NUMBER)
    RETURN VARCHAR2;
    
    FUNCTION ren_prem_amt(p_remarks       VARCHAR2,
                          p_policy_id     gipi_polbasic.policy_id%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION expiry_date(p_policy_id            gipi_polbasic.policy_id%TYPE)
    RETURN DATE;
    
    FUNCTION ref_ren_pol2(p_cp_1         NUMBER)
    RETURN VARCHAR2;
    
END GIEXR108_PKG;
/


