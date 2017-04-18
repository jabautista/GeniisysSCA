CREATE OR REPLACE PACKAGE CPI.GIPIS193_PKG
AS

    TYPE item_type IS RECORD(
        policy_id       GIPI_ITEM.POLICY_ID%type,
        item_no         GIPI_ITEM.ITEM_NO%type,
        item_title      GIPI_ITEM.ITEM_TITLE%type,
        make            GIPI_VEHICLE.MAKE%type,
        motor_no        GIPI_VEHICLE.MOTOR_NO%type,
        serial_no       GIPI_VEHICLE.SERIAL_NO%type,
        plate_no        GIPI_VEHICLE.PLATE_NO%type,
        tsi_amt         GIPI_ITEM.TSI_AMT%type,
        prem_amt        GIPI_ITEM.PREM_AMT%type,
        cred_branch     GIPI_POLBASIC.CRED_BRANCH%type,
        policy_no       VARCHAR2(100),
        assd_no         GIPI_POLBASIC.ASSD_NO%type,
        assd_name       GIIS_ASSURED.ASSD_NAME%type,
        incept_date     GIPI_POLBASIC.INCEPT_DATE%type,
        expiry_date     GIPI_POLBASIC.EXPIRY_DATE%type,
        eff_date        GIPI_POLBASIC.EFF_DATE%type,
        issue_date      GIPI_POLBASIC.ISSUE_DATE%type,
        line_cd         GIPI_POLBASIC.line_cd%TYPE,        
        iss_cd          GIPI_POLBASIC.iss_cd%TYPE
    );
    
    TYPE item_tab IS TABLE OF item_type;
    
    FUNCTION get_vehicle_item_listing(
        p_plate_no      GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     VARCHAR2,
        p_as_of_date    VARCHAR2,
        p_from_date     VARCHAR2,
        p_to_date       VARCHAR2,
        p_user_id       VARCHAR2
    ) RETURN item_tab PIPELINED;
    
    
    PROCEDURE get_vehicle_item_totals(
        p_plate_no      IN  GIPI_VEHICLE.PLATE_NO%type,
        p_cred_branch   IN  GIPI_POLBASIC.CRED_BRANCH%type,
        p_date_type     IN  VARCHAR2,
        p_as_of_date    IN  VARCHAR2,
        p_from_date     IN  VARCHAR2,
        p_to_date       IN  VARCHAR2,
        p_user_id       IN  VARCHAR2,
        p_sum_tsi_amt   OUT NUMBER,
        p_sum_prem_amt  OUT NUMBER
    );
    
END GIPIS193_PKG;
/


