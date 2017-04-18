CREATE OR REPLACE PACKAGE CPI.GIRIR001C_PKG
AS

    TYPE report_details_type IS RECORD(
        cf_heading                  VARCHAR2(30),
        line_name                   GIIS_LINE.LINE_NAME%type,
        print_line_name             VARCHAR2(1),
        binder_no                   VARCHAR2(100),
        print_binder_no             VARCHAR2(1),
        binder_number               VARCHAR2(100),
        print_binder_number         VARCHAR2(1),
        binder_date                 GIRI_BINDER.BINDER_DATE%TYPE,
        cf_addressee                VARCHAR2(2000),
        cf_addressee_confirmation   VARCHAR2(2000),
        ri_name                     GIIS_REINSURER.RI_NAME%TYPE,
        bill_address1               GIIS_REINSURER.BILL_ADDRESS1%TYPE,
        bill_address2               GIIS_REINSURER.BILL_ADDRESS2%TYPE,
        bill_address3               GIIS_REINSURER.BILL_ADDRESS3%TYPE,
        attention                   GIIS_REINSURER.ATTENTION%TYPE,
        cf_first_paragraph          VARCHAR2(200),  
        assd_no                     GIPI_POLBASIC.ASSD_NO%TYPE,
        cf_assd_name                giis_assured.assd_name %type,
        policy_no                   VARCHAR2(30),
        loc_voy_unit                GIRI_DISTFRPS.LOC_VOY_UNIT%TYPE,
        endt_no                     VARCHAR2(20),
        cf_svu                      VARCHAR2(20),
        ri_term                     VARCHAR2(50),
        cf_sailing_date             VARCHAR2(30),
        print_cf_sailing_date       VARCHAR2(1),
        sum_insured                 VARCHAR2(70),
        your_share                  VARCHAR2(50),
        prem_tax                    GIRI_BINDER.PREM_TAX%TYPE,
        endt_seq_no2                GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
        confirm_no                  GIRI_BINDER.CONFIRM_NO%TYPE,
        confirm_date                GIRI_BINDER.CONFIRM_DATE%TYPE,
        ds_no                       VARCHAR2(50),
        dist_no                     GIRI_DISTFRPS.DIST_NO%TYPE,
        dist_seq_no                 GIRI_DISTFRPS.DIST_SEQ_NO%TYPE,
        frps_no                     VARCHAR2(30),
        cf_mop_number               VARCHAR2(30),
        bndr_remarks1               GIRI_FRPS_RI.BNDR_REMARKS1%TYPE,
        bndr_remarks2               GIRI_FRPS_RI.BNDR_REMARKS2%TYPE,
        bndr_remarks3               GIRI_FRPS_RI.BNDR_REMARKS3%TYPE,
        fnl_binder_id               GIRI_BINDER.FNL_BINDER_ID%TYPE,
        policy_id                   GIPI_POLBASIC.POLICY_ID%TYPE,
        par_id                      GIPI_POLBASIC.PAR_ID%TYPE,
        endt_seq_no                 GIPI_POLBASIC.ENDT_SEQ_NO%TYPE,
        endt_yy                     GIPI_POLBASIC.ENDT_YY%TYPE,
        endt_iss_cd                 GIPI_POLBASIC.ENDT_ISS_CD%TYPE,
        subline_cd                  GIPI_POLBASIC.SUBLINE_CD%TYPE,
        cf_endt_no                  VARCHAR2(30),
        line_cd                     GIPI_POLBASIC.LINE_CD%TYPE,
        line_cd1                    GIRI_FRPS_RI.LINE_CD%TYPE,
        frps_yy                     GIRI_FRPS_RI.FRPS_YY%TYPE,
        frps_seq_no                 GIRI_FRPS_RI.FRPS_SEQ_NO%TYPE,
        reverse_sw                  GIRI_FRPS_RI.REVERSE_SW%TYPE,
        reverse_date                GIRI_BINDER.REVERSE_DATE%type,
        other_charges               GIRI_FRPS_RI.OTHER_CHARGES%TYPE,
        cf_property                 VARCHAR2(100),
        user_id                     VARCHAR2(15),
        currency_rt                 GIRI_DISTFRPS.CURRENCY_RT%type,
        net_due                     NUMBER(12, 2),
        cf_comp_nm                  giis_parameters.param_value_v%TYPE,
        print_sign_ref_date_across1 VARCHAR2(1),                -- M_9 format trigger
        print_sign_ref_date_across2 VARCHAR2(1),                -- M_10 format trigger
        print_auth_rep_above        VARCHAR2(1),            --M_2 format trigger
        print_auth_sign_above       VARCHAR2(1),            --M_8 format trigger
        print_note                  VARCHAR2(1)             --M_5 format trigger
    );
    
    TYPE report_details_tab IS TABLE OF report_details_type;
    
    
    TYPE report_perils_type IS RECORD(
        peril_title                 GIRI_FRPS_PERIL_GRP.PERIL_TITLE%TYPE,
        fnl_binder_id               GIRI_BINDER.FNL_BINDER_ID%TYPE,
        line_cd                     GIRI_FRPS_RI.LINE_CD%type,
        frps_yy                     GIRI_FRPS_RI.FRPS_YY%type,
        frps_seq_no                 GIRI_FRPS_RI.FRPS_SEQ_NO%type,
        gross_prem                  GIRI_FRPS_PERIL_GRP.PREM_AMT%TYPE,
        ri_prem_amt                 GIRI_BINDER_PERIL.RI_PREM_AMT%TYPE,
        ri_comm_rt                  GIRI_BINDER_PERIL.RI_COMM_RT%TYPE,
        ri_comm_amt                 GIRI_BINDER_PERIL.RI_COMM_AMT%TYPE,
        less_ri_comm_amt            GIRI_BINDER_PERIL.RI_PREM_AMT%TYPE,
        ri_prem_vat                 GIRI_BINDER.RI_PREM_VAT%type,
        ri_comm_vat                 GIRI_BINDER.RI_COMM_VAT%type,
        ri_wholding_vat             GIRI_BINDER.RI_WHOLDING_VAT%type,
        cf_gross_prem               NUMBER(16,2),
        cf_ri_prem_amt              NUMBER(16,2),
        cf_ri_comm_amt              NUMBER(16,2),
        cf_lcomm_amt                NUMBER(16,2),
        cf_less_comm_vat            NUMBER(16,2),
        cf_ri_prem_vat              NUMBER(16,2),
        cf_ri_comm_vat              NUMBER(16,2),
        cf_ri_wholding_vat          NUMBER(16,2),
        cf_ri_wholding_vatcomm      NUMBER(12,2)
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
        p_dist_seq_no   GIUW_ITEMDS.DIST_SEQ_NO%TYPE,
        p_line_cd       GIPI_POLBASIC.LINE_CD%type,
        p_subline_cd    GIPI_POLBASIC.SUBLINE_CD%type
    ) RETURN VARCHAR2;
    
    
    FUNCTION PARAM_BOOL(
        p_type      VARCHAR2
    ) RETURN VARCHAR2;
    
    
    FUNCTION PARAM_CHAR(
        p_type      VARCHAR2,
        p_arg1      VARCHAR2
    ) RETURN VARCHAR2;   
    
    
    FUNCTION get_report_details(
        p_line_cd           GIRI_BINDER.LINE_CD%type,
        p_binder_yy         GIRI_BINDER.BINDER_YY%type,
        p_binder_seq_no     GIRI_BINDER.BINDER_SEQ_NO%type
    ) RETURN report_details_tab PIPELINED;
    
    
    FUNCTION get_report_perils(
        p_fnl_binder_id     GIRI_BINDER_PERIL.FNL_BINDER_ID%type,
        p_line_cd           GIRI_FRPS_RI.LINE_CD%type,
        p_frps_yy           GIRI_FRPS_RI.FRPS_YY%type,
        p_frps_seq_no       GIRI_FRPS_RI.FRPS_SEQ_NO%type,
        p_currency_rt       GIRI_DISTFRPS.CURRENCY_RT%type ,
        p_reverse_sw        GIRI_FRPS_RI.REVERSE_SW%TYPE,
        p_reverse_date      GIRI_BINDER.REVERSE_DATE%type       
    ) RETURN report_perils_tab PIPELINED;

END GIRIR001C_PKG;
/


