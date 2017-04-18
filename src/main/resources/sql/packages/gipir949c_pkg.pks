CREATE OR REPLACE PACKAGE CPI.GIPIR949C_PKG
AS

    TYPE report_type IS RECORD(
        company_name        giis_parameters.param_value_v%type,
        company_address     giis_parameters.param_value_v%type,
        top_header          VARCHAR2(100),
        
        ranges              VARCHAR2(200),
        range_from          GIPI_RISK_PROFILE_ITEM.range_from%type,
        block_risk          giis_risks.risk_desc%type,
        sum_insured         NUMBER(18,2),
        prem_amount         NUMBER(18,2),
        risk_count          NUMBER(10),
        print_details       VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;


    FUNCTION populate_report(
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2
    ) RETURN report_tab PIPELINED;
    
END GIPIR949C_PKG;
/


