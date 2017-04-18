CREATE OR REPLACE PACKAGE CPI.GIACS213_PKG
AS
 
    TYPE vehicle_type IS RECORD(
        policy_id           GIPI_VEHICLE.POLICY_ID%type,
        item_no             GIPI_VEHICLE.ITEM_NO%type,
        plate_no            GIPI_VEHICLE.PLATE_NO%type,
        dsp_bill_no         VARCHAR2(25),
        dsp_prem_seq_no     gipi_invoice.PREM_SEQ_NO%type,
        dsp_bill_iss_cd     gipi_invoice.ISS_CD%type,
        dsp_line_cd         gipi_polbasic.LINE_CD%type,
        dsp_subline_cd      gipi_polbasic.SUBLINE_CD%type,
        dsp_iss_cd          gipi_polbasic.ISS_CD%type,
        dsp_issue_yy        gipi_polbasic.ISSUE_YY%type,
        dsp_pol_seq_no      gipi_polbasic.POL_SEQ_NO%type,
        dsp_endt_seq_no     gipi_polbasic.ENDT_SEQ_NO%type,
        dsp_endt_type       gipi_polbasic.ENDT_TYPE%type,
        dsp_assd_no         gipi_polbasic.ASSD_NO%type,
        dsp_assd_name       giis_assured.ASSD_NAME%type     
    );
    
    TYPE vehicle_tab IS TABLE OF vehicle_type;
    
    
    FUNCTION get_vehicle_list(
        p_assd_no       GIPI_POLBASIC.ASSD_NO%type,
        p_user_id       GIPI_POLBASIC.USER_ID%type
    ) RETURN vehicle_tab PIPELINED;

    
    FUNCTION count_vehicles_insured(
        p_assd_no       GIPI_POLBASIC.ASSD_NO%type
    ) RETURN NUMBER;
    
    
END GIACS213_PKG;
/


