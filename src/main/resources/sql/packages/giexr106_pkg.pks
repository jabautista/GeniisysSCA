CREATE OR REPLACE PACKAGE CPI.GIEXR106_PKG
AS

TYPE get_details_type IS RECORD(
            ri_cd               number,
            extract_id          number,
            line_cd             varchar2(100),
            policy_no           varchar2(100),
            ri_policy_no        varchar2(100),
            orig_tsi_amt        number,
            our_tsi_amt         number,
            accept_date         date,
            expiry_date         varchar2(100), --date, edited by gab 11.09.2015
            assd_no             number,
            assd_name           giis_assured.assd_name%TYPE, --editted by MJ for consolidation 01022012 [FROM varchar2(100)]
            ri_name             varchar2(100),
            mail_address1       varchar2(100),
            mail_address2       varchar2(100),
            mail_address3       varchar2(100),
            pct_accepted        number,
            company_name        giis_parameters.param_value_v%TYPE, -- changed by robert 09272013 from varchar2(100),
            company_address     giis_parameters.param_value_v%TYPE, -- changed by robert 09272013 from varchar2(100),
            expiry_month        varchar2(50),
            expiry_year         VARCHAR2(10),
            line_name           varchar2(100),
            ri_binder_no        varchar2(100),
            location            varchar2(2000),
            destn               varchar2(2000),
            vessel              varchar2(2000),
            incept_date         varchar2(100), --date, edited by gab 11.09.2015
            remarks             giri_inpolbas.remarks%TYPE, -- changed by robert 09272013 from varchar2(2000)      
            policy_id           gipi_polbasic.policy_id%TYPE   
            );
   TYPE get_details_tab IS TABLE OF get_details_type;
   
  FUNCTION get_details(p_extract_id           gixx_inw_tran.extract_id%TYPE
                       --p_expiry_month         varchar2,
                       --p_expiry_year          VARCHAR2
                       )
        RETURN get_details_tab PIPELINED;
        
   FUNCTION cf_policy_idformula (p_policy_no            varchar2)
   RETURN NUMBER;

    FUNCTION cf_loc_risk1formula(p_policy_id           gipi_polbasic.policy_id%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION cf_loc_risk2formula(p_policy_id           gipi_polbasic.policy_id%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION cf_loc_risk3formula(p_policy_id           gipi_polbasic.policy_id%TYPE)
       RETURN VARCHAR2;
       
   FUNCTION cf_locationformula(p_policy_id           gipi_polbasic.policy_id%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION cf_destnformula(p_policy_id           gipi_polbasic.policy_id%TYPE)
   RETURN VARCHAR2;
   
   FUNCTION cf_vessel_cdformula(p_policy_id       gipi_polbasic.policy_id%TYPE)
    RETURN VARCHAR2;
    
   FUNCTION cf_vessel_nameformula(/*p_policy_id       gipi_polbasic.policy_id%TYPE*/ --benjo 10.26.2015 comment out
                                  p_vessel_cd       giis_vessel.vessel_cd%TYPE) --benjo 10.26.2015 GENQA-SR-5059
    RETURN VARCHAR2;
   
   FUNCTION cf_vesselformula(p_policy_id       gipi_polbasic.policy_id%TYPE)
    RETURN CHAR;
   
   FUNCTION cf_incept_dateformula(p_policy_id       gipi_polbasic.policy_id%TYPE)
    RETURN DATE;
    
   FUNCTION cf_remarksformula(p_policy_id       gipi_polbasic.policy_id%TYPE)
    RETURN CHAR;
    
END GIEXR106_PKG;
/


