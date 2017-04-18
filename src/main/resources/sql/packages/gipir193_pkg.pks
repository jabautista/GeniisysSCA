CREATE OR REPLACE PACKAGE cpi.gipir193_pkg
AS

    TYPE report_type IS RECORD(
        plate_no            GIPI_VEHICLE.PLATE_NO%type,
        policy_no           VARCHAR2(100),
        assd_no             GIPI_POLBASIC.ASSD_NO%type,
        assd_name           GIIS_ASSURED.ASSD_NAME%type,
        incept_date         GIPI_POLBASIC.INCEPT_DATE%type,
        expiry_date         GIPI_POLBASIC.EXPIRY_DATE%type,
        item                VARCHAR2(60),
        make                GIPI_VEHICLE.MAKE%type,
        motor_no            GIPI_VEHICLE.MOTOR_NO%type,
        serial_no           GIPI_VEHICLE.SERIAL_NO%type,
        tsi_amt             GIPI_ITEM.TSI_AMT%type,
        prem_amt            GIPI_ITEM.PREM_AMT%type,
        company_name        GIIS_PARAMETERS.param_value_v%type,
        company_address     GIIS_PARAMETERS.param_value_v%type,
        cf_title            VARCHAR2(50),         
        print_details       VARCHAR2(1)
    );
    
    TYPE report_tab IS TABLE OF report_type;


    FUNCTION populate_report(
        p_plate_no      GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_user_id       VARCHAR2 
    ) RETURN report_tab PIPELINED;
    
    
END GIPIR193_PKG;
/
