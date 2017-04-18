CREATE OR REPLACE PACKAGE CPI.GIPIR209_PKG
AS

    TYPE gipir209_type IS RECORD (
        company_name        giis_parameters.param_value_v%TYPE,
        company_address     giis_parameters.param_value_v%TYPE,
        assd_no             GIPI_POLBASIC.assd_no%TYPE,
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        incept_date         GIPI_POLBASIC.incept_date%TYPE,
        eff_date            GIPI_POLBASIC.eff_date%TYPE, 
        issue_date          GIPI_POLBASIC.issue_date%TYPE,
        expiry_date         GIPI_POLBASIC.expiry_date%TYPE,
        policy_id           GIPI_POLBASIC.policy_id%TYPE,
        item                VARCHAR2(1000),
        tsi_amt             GIPI_ITEM.tsi_amt%TYPE,
        prem_amt            GIPI_ITEM.prem_amt%TYPE,
        currency_rt_chk     VARCHAR2(1),
        policy_num          VARCHAR2(100),
        endt_iss_cd         GIPI_POLBASIC.endt_iss_cd%TYPE,
        endt_yy             GIPI_POLBASIC.endt_yy%TYPE,
        endt_seq_no         GIPI_POLBASIC.endt_seq_no%TYPE,
        ann_tsi_amt         GIPI_ITEM.ann_tsi_amt%TYPE,
        ann_prem_amt        GIPI_ITEM.ann_prem_amt%TYPE,
        pol_seq_no          GIPI_POLBASIC.pol_seq_no%TYPE,
        policy_num1         VARCHAR2(100),
        subtitle            VARCHAR2(1000)
    );
    
    TYPE gipir209_tab IS TABLE OF gipir209_type;
    
    FUNCTION get_report_details(
        P_FROM_DATE         DATE,
        P_TO_DATE           DATE,
        P_AS_OF_DATE        DATE,
        P_INC_FROM_DATE     DATE,
        P_INC_TO_DATE       DATE,
        P_INC_AS_OF_DATE    DATE,
        P_EFF_FROM_DATE     DATE,
        P_EFF_TO_DATE       DATE,
        P_EFF_AS_OF_DATE    DATE,
        P_ISS_FROM_DATE     DATE,
        P_ISS_TO_DATE       DATE,
        P_ISS_AS_OF_DATE    DATE,
        P_EXP_FROM_DATE     DATE,
        P_EXP_TO_DATE       DATE,
        P_EXP_AS_OF_DATE    DATE
    ) RETURN gipir209_tab PIPELINED;
    
END GIPIR209_PKG;
/


