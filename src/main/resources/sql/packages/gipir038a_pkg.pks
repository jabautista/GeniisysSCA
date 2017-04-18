CREATE OR REPLACE PACKAGE CPI.GIPIR038A_PKG

AS
    TYPE gipir038a_type IS RECORD(
        count_tarf            NUMBER,         
        nvl_tariff_cd2        GIXX_FIRESTAT_SUMMARY.tariff_cd%TYPE,    
        nvl_tariff_zone2      GIXX_FIRESTAT_SUMMARY.tariff_zone%TYPE,  
        tariff_cd             GIXX_FIRESTAT_SUMMARY.tariff_cd%TYPE,
        tariff_zone3          GIXX_FIRESTAT_SUMMARY.tariff_cd%TYPE,
        tariff                VARCHAR2(100),
        sum_tsi_amt           GIXX_FIRESTAT_SUMMARY.tsi_amt%TYPE,
        sum_prem_amt          GIXX_FIRESTAT_SUMMARY.prem_amt%TYPE,
        company_name          giis_parameters.param_value_v%TYPE,
        title                 VARCHAR2(100),    
        var_header            VARCHAR2(100)                   
    );
    
    TYPE gipir038a_tab IS TABLE OF gipir038a_type;
    
    FUNCTION get_gipir038a_details(
           p_zone_type          VARCHAR2,
           p_user_id            VARCHAR2,
           p_as_of_sw           VARCHAR2,
           p_expired_as_of      VARCHAR2,
           p_period_start       VARCHAR2,
           p_period_end         VARCHAR2
           
    )
       RETURN gipir038a_tab PIPELINED;
       
    TYPE flood_zone_type IS RECORD(
        flood_zone             giis_flood_zone.flood_zone%TYPE,   
        flood_zone2            VARCHAR2(100)
    );
    
    TYPE flood_zone_tab IS TABLE OF flood_zone_type;
    
    FUNCTION get_flood_zone_details
    
    RETURN flood_zone_tab PIPELINED;
    
END GIPIR038A_PKG;
/


