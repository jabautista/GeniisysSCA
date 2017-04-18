CREATE OR REPLACE PACKAGE CPI.GIRIR001B_PKG
AS

    TYPE report_details_type IS RECORD(
        line_name               GIIS_LINE.LINE_NAME%type,
        binder_no               VARCHAR2(100),
        print_binder_no         VARCHAR2(1),
        binder_number           VARCHAR2(100),
        print_binder_number     VARCHAR2(1),
        your_share              VARCHAR2(50),
        prem_tax                GIRI_BINDER.PREM_TAX%TYPE,
        binder_date             GIRI_BINDER.BINDER_DATE%TYPE,
        ri_name                 GIIS_REINSURER.RI_NAME%TYPE,
        bill_address1           GIIS_REINSURER.BILL_ADDRESS1%TYPE,
        bill_address2           GIIS_REINSURER.BILL_ADDRESS2%TYPE,
        bill_address3           GIIS_REINSURER.BILL_ADDRESS3%TYPE,
        attention               GIIS_REINSURER.ATTENTION%TYPE,
        cf_first_paragraph      VARCHAR2(200),  
        assd_no                 GIPI_POLBASIC.ASSD_NO%TYPE,
        cf_assd_name            giis_assured.assd_name %type,
        policy_no               VARCHAR2(30),
        loc_voy_unit            GIRI_DISTFRPS.LOC_VOY_UNIT%TYPE,
        endt_no                 VARCHAR2(20),
        ri_term                 VARCHAR2(50),
        sum_insured             VARCHAR2(70),
        endt_seq_no2            GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
        confirm_no              GIRI_BINDER.CONFIRM_NO%TYPE,
        confirm_date            GIRI_BINDER.CONFIRM_DATE%TYPE,
        ds_no                   VARCHAR2(50),
        dist_no                 GIRI_DISTFRPS.DIST_NO%TYPE,
        dist_seq_no             GIRI_DISTFRPS.DIST_SEQ_NO%TYPE,
        frps_no                 VARCHAR2(30),
        cf_mop_number           VARCHAR2(30),
        bndr_remarks1           GIRI_FRPS_RI.BNDR_REMARKS1%TYPE,
        bndr_remarks2           GIRI_FRPS_RI.BNDR_REMARKS2%TYPE,
        bndr_remarks3           GIRI_FRPS_RI.BNDR_REMARKS3%TYPE,
        fnl_binder_id           GIRI_BINDER.FNL_BINDER_ID%TYPE,
        policy_id               GIPI_POLBASIC.POLICY_ID%TYPE,
        par_id                  GIPI_POLBASIC.PAR_ID%TYPE,
        endt_seq_no             GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
        endt_yy                 GIPI_POLBASIC.ENDT_YY%TYPE,
        endt_iss_cd             GIPI_POLBASIC.ENDT_ISS_CD%TYPE,
        subline_cd              GIPI_POLBASIC.SUBLINE_CD%TYPE,
        cf_endt_no              VARCHAR2(30),
        line_cd                 GIPI_POLBASIC.LINE_CD%TYPE,
        cf_heading              VARCHAR2(30),
        line_cd1                GIRI_FRPS_RI.LINE_CD%TYPE,
        frps_yy                 GIRI_FRPS_RI.FRPS_YY%TYPE,
        frps_seq_no             GIRI_FRPS_RI.FRPS_SEQ_NO%TYPE,
        cf_svu                  VARCHAR2(20),
        reverse_sw              GIRI_FRPS_RI.REVERSE_SW%TYPE,
        other_charges           GIRI_FRPS_RI.OTHER_CHARGES%TYPE,
        cf_property             VARCHAR2(100),
        user_id                 VARCHAR2(15),
        ri_flag                 GIRI_DISTFRPS.RI_FLAG%TYPE,
        net_due                 NUMBER(12, 2),
        cf_comp_nm              giis_parameters.param_value_v%TYPE,
        local_foreign_sw        VARCHAR2(5) --MJO 10232013
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    TYPE report_perils_type IS RECORD(
        gross_prem              GIRI_FRPS_PERIL_GRP.PREM_AMT%TYPE,
        cf_gross_prem1          NUMBER(16, 2),
        ri_prem_amt             GIRI_BINDER_PERIL.RI_PREM_AMT%TYPE,
        cf_ri_prem_amt1         NUMBER(16, 2),
        ri_comm_rt              GIRI_BINDER_PERIL.RI_COMM_RT%TYPE,
        ri_comm_amt             GIRI_BINDER_PERIL.RI_COMM_AMT%TYPE,
        cf_ri_comm_amt1         NUMBER(16, 2),
        less_ri_comm_amt        GIRI_BINDER_PERIL.RI_PREM_AMT%TYPE,
        cf_lcomm_amt1           NUMBER(16, 2),
        peril_title             GIRI_FRPS_PERIL_GRP.PERIL_TITLE%TYPE,
        --start MJO  10232013
        ri_prem_vat                 GIRI_BINDER.ri_prem_vat%TYPE,
        ri_comm_vat                 GIRI_BINDER.ri_comm_vat%TYPE,
        less_comm_vat               NUMBER,
        ri_wholding_vat             NUMBER
        -- end MJO 10232013
    );
    
    TYPE report_perils_tab IS TABLE OF report_perils_type;
    
    
    FUNCTION CF_FIRST_PARAGRAPH(
        p_policy_id     gipi_polbasic.POLICY_ID%type,
        p_par_id        gipi_parlist.PAR_ID%type,
        p_endt_seq_no   GIPI_POLBASIC.ENDT_SEQ_NO%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_MOP_NUMBER(
        p_policy_id     gipi_polbasic.POLICY_ID%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_ASSD_NAME(
        p_assd_no   GIIS_ASSURED.ASSD_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_PROPERTY(
        p_policy_id     GIPI_INVOICE.POLICY_ID%TYPE,
        p_dist_no       GIUW_POLICYDS.DIST_NO%TYPE,
        p_dist_seq_no   GIUW_ITEMDS.DIST_SEQ_NO%TYPE
    ) RETURN VARCHAR2;
    
    
    FUNCTION CF_COMP_NM
        RETURN VARCHAR2;
        
    
    FUNCTION get_report_details(
        p_line_cd           GIRI_BINDER.LINE_CD%type,
        p_binder_yy         GIRI_BINDER.BINDER_YY%type,
        p_binder_seq_no     GIRI_BINDER.BINDER_SEQ_NO%type
    ) RETURN report_details_tab PIPELINED;
    
    
    FUNCTION get_report_perils(
        p_fnl_binder_id     GIRI_BINDER.FNL_BINDER_ID%type,
        p_line_cd           GIRI_BINDER.LINE_CD%type,
        p_frps_yy           GIRI_BINDER.BINDER_YY%type,
        p_frps_seq_no       GIRI_BINDER.BINDER_SEQ_NO%type,
        p_reverse_sw        GIRI_FRPS_RI.REVERSE_SW%TYPE,
        p_ri_flag           GIRI_DISTFRPS.RI_FLAG%TYPE
    ) RETURN report_perils_tab PIPELINED;

END GIRIR001B_PKG;
/


