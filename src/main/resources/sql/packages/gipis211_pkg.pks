CREATE OR REPLACE PACKAGE CPI.GIPIS211_PKG
AS
    
    TYPE mc_pol_par_type IS RECORD(
        par_id          GIPI_PARLIST.par_id%type,
        line_cd         GIPI_PARLIST.line_cd%type,
        iss_cd          GIPI_PARLIST.iss_cd%type,
        par_yy          GIPI_PARLIST.par_yy%type,
        par_seq_no      GIPI_PARLIST.par_seq_no%type,
        quote_seq_no    GIPI_PARLIST.quote_seq_no%type,
        par_number      VARCHAR(25),
        par_status      GIPI_PARLIST.par_status%type,
        assd_no         GIPI_PARLIST.assd_no%type,
        assd_name       GIIS_ASSURED.ASSD_NAME%type,
        incept_date     GIPI_WPOLBAS.incept_date%type,
        expiry_date     GIPI_WPOLBAS.expiry_date%type,
        underwriter     GIPI_PARLIST.underwriter%type,
        nbt_par_no      VARCHAR2(20)
    );
    
    TYPE mc_pol_par_tab IS TABLE OF mc_pol_par_type;
    
    
    FUNCTION get_motorcar_pol_par_listing(
        p_global_par_id         VARCHAR2,
        p_global_line_cd        GIPI_PARLIST.line_cd%type,
        p_user_id               VARCHAR2
    ) RETURN mc_pol_par_tab PIPELINED;
    
    
    
    TYPE vehicle_type IS RECORD(
        par_id              GIPI_WVEHICLE.PAR_ID%type,
        item_no             GIPI_WVEHICLE.ITEM_NO%type,
        item_desc           GIPI_WITEM.ITEM_DESC%type,
        plate_no            GIPI_WVEHICLE.PLATE_NO%type,
        serial_no           GIPI_WVEHICLE.SERIAL_NO%type,
        motor_no            GIPI_WVEHICLE.MOTOR_NO%type,
        nbt_policy_id       GIPI_POLBASIC.POLICY_ID%type,
        nbt_line_cd         GIPI_PARLIST.line_cd%type,
        nbt_iss_cd          GIPI_PARLIST.iss_cd%type,
        nbt_par_yy          GIPI_PARLIST.par_yy%type,
        nbt_par_seq_no      GIPI_PARLIST.par_seq_no%type,
        nbt_quote_seq_no    GIPI_PARLIST.quote_seq_no%type
    );
    
    TYPE vehicle_tab IS TABLE OF vehicle_type;
    
    
    FUNCTION get_motorcar_vehicle_listing(
        p_par_id        GIPI_WVEHICLE.PAR_ID%type,
        p_par_status    GIPI_PARLIST.par_status%type
    ) RETURN vehicle_tab PIPELINED;


    TYPE vehicle_items_type IS RECORD(
        par_id              GIPI_WVEHICLE.PAR_ID%type,
        par_no              VARCHAR2(100),
        line_cd             GIPI_PARLIST.line_cd%type,
        policy_id           GIPI_POLBASIC.POLICY_ID%type,
        policy_no           VARCHAR2(100),
        assd_name           GIIS_ASSURED.ASSD_NAME%type,
        plate_no            GIPI_WVEHICLE.PLATE_NO%type,
        serial_no           GIPI_WVEHICLE.SERIAL_NO%type,
        motor_no            GIPI_WVEHICLE.MOTOR_NO%type,
        incept_date         GIPI_POLBASIC.INCEPT_DATE%type,
        expiry_date         GIPI_POLBASIC.EXPIRY_DATE%type,
        tsi                 GIPI_ITEM.TSI_AMT%type,
        prem                GIPI_ITEM.PREM_AMT%type,
        prem_collns         NUMBER(18,2),
        claims_pd           NUMBER(18,2)
    );
    
    TYPE vehicle_items_tab IS TABLE OF vehicle_items_type;


    FUNCTION get_motorcar_vehicle_items(
        p_nbt_line_cd       GIPI_PARLIST.line_cd%type,
        p_nbt_plate_no      GIPI_WVEHICLE.PLATE_NO%type,
        p_nbt_serial_no     GIPI_WVEHICLE.SERIAL_NO%type,
        p_nbt_motor_no      GIPI_WVEHICLE.MOTOR_NO%type
    ) RETURN vehicle_items_tab PIPELINED;


END GIPIS211_PKG;
/


