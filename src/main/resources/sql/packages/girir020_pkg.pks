CREATE OR REPLACE PACKAGE CPI.GIRIR020_PKG
AS

    TYPE report_details_type IS RECORD(
        company_name        GIIS_PARAMETERS.param_value_v%type,
        company_address     VARCHAR2(500),
        cf_paramdate        VARCHAR2(50),
        ri_name             giis_reinsurer.RI_NAME%type,
        bill_address1       giis_reinsurer.BILL_ADDRESS1%type,
        bill_address2       giis_reinsurer.BILL_ADDRESS2%type,
        bill_address3       giis_reinsurer.BILL_ADDRESS3%type,
        currency_desc       giis_currency.CURRENCY_DESC%type,
        policy_no           varchar2(40),
        policy_id           gipi_polbasic.POLICY_ID%type,
        endt_seq_no         gipi_polbasic.ENDT_SEQ_NO%type,
        assd_name           giis_assured.ASSD_NAME%type,
        loc_voy_unit        giri_distfrps.LOC_VOY_UNIT%type,
        binder_seq_no       varchar2(15),
        expiry_date         varchar2(10),
        ri_tsi_amt          giri_frps_ri.RI_TSI_AMT%type,
        ri_shr_pct          giri_frps_ri.RI_SHR_PCT%type,
        remarks             giri_frps_ri.REMARKS%type
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    FUNCTION CF_COMPANY_NAME
        RETURN VARCHAR2;
        
        
    FUNCTION CF_COMPANY_ADDRESS
        RETURN VARCHAR2;
     
    
    FUNCTION get_report_details(
        p_ri_sname      giis_reinsurer.RI_SNAME%type,
        p_start_date    giuw_pol_dist.EXPIRY_DATE%type,
        p_end_date      giuw_pol_dist.EXPIRY_DATE%type
    ) RETURN report_details_tab PIPELINED;

    
    TYPE item_details_type IS RECORD(
        policy_id           gipi_polbasic.POLICY_ID%type,
        district_no         gipi_fireitem.DISTRICT_NO%type,
        block_no            gipi_fireitem.BLOCK_NO%type
    );
    
    TYPE item_details_tab IS TABLE OF item_details_type;
    
    
    FUNCTION get_item_details(
        p_policy_id     gipi_polbasic.POLICY_ID%type
    ) RETURN item_details_tab PIPELINED;
        
END GIRIR020_PKG;
/


