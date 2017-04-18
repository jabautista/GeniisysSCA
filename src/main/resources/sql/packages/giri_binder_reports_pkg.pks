CREATE OR REPLACE PACKAGE CPI.GIRI_BINDER_REPORTS_PKG AS
    
    /*report variables */
        binder_line                 GIIS_DOCUMENT.text%TYPE;
        binder_note                 GIIS_DOCUMENT.text%TYPE;
        binder_hdr                  GIIS_DOCUMENT.text%TYPE;
        binder_ftr                  GIIS_DOCUMENT.text%TYPE;
        binder_for                  GIIS_DOCUMENT.text%TYPE;
        binder_confirmation         GIIS_DOCUMENT.text%TYPE;
        frps_ret                    GIIS_DOCUMENT.text%TYPE;
        user_id			            GIIS_DOCUMENT.text%TYPE;
        hide			            GIIS_DOCUMENT.text%TYPE;
        addressee			        GIIS_DOCUMENT.text%TYPE;
        addressee_confirmation		GIIS_DOCUMENT.text%TYPE;
        print_line_name             GIIS_DOCUMENT.text%TYPE;
        print_auth_sig_above        GIIS_DOCUMENT.text%TYPE;
        print_sig_refdate_across    GIIS_DOCUMENT.text%TYPE;
        binder_hdr_endt             GIIS_DOCUMENT.text%TYPE;
        binder_hdr_ren              GIIS_DOCUMENT.text%TYPE;
     
    /* end of report variables*/
    
    
    TYPE giri_binder_report_type IS RECORD(
        line_name                   GIIS_LINE.line_name%TYPE,
        menu_line_cd                GIIS_LINE.menu_line_cd%TYPE, 
        binder_no                   VARCHAR2 (100), 
        binder_number               VARCHAR2 (100), 
        your_share                  VARCHAR2 (100), 
        prem_tax                    GIRI_BINDER.prem_tax%TYPE,
        binder_date                 GIRI_BINDER.binder_date%TYPE,
        ri_name                     GIIS_REINSURER.ri_name%TYPE, 
        bill_address1               GIIS_REINSURER.bill_address1%TYPE, 
        bill_address2               GIIS_REINSURER.bill_address2%TYPE, 
        bill_address3               GIIS_REINSURER.bill_address3%TYPE, 
        attention                   GIIS_REINSURER.attention%TYPE, 
        assd_no                     GIPI_POLBASIC.assd_no%TYPE,
        assd_name                   GIIS_ASSURED.assd_name%TYPE,
        policy_no                   VARCHAR2 (100), 
        loc_voy_unit                GIRI_DISTFRPS.loc_voy_unit%TYPE,
        endt_no                     VARCHAR2 (50), 
        ri_term                     VARCHAR2 (50), 
        sum_insured                 VARCHAR2 (100),  
        confirm_no                  GIRI_BINDER.confirm_no%TYPE, 
        confirm_date                GIRI_BINDER.confirm_date%TYPE, 
        ds_no                       VARCHAR2 (50), 
        dist_no                     GIRI_DISTFRPS.dist_no%TYPE, 
        dist_seq_no                 GIRI_DISTFRPS.dist_seq_no%TYPE, 
        frps_no                     VARCHAR2 (50), 
        remarks                     GIRI_FRPS_RI.remarks%TYPE, 
        bndr_remarks1               GIRI_FRPS_RI.bndr_remarks1%TYPE, 
        bndr_remarks2               GIRI_FRPS_RI.bndr_remarks2%TYPE, 
        bndr_remarks3               GIRI_FRPS_RI.bndr_remarks3%TYPE, 
        ri_accept_by                GIRI_FRPS_RI.ri_accept_by%TYPE, 
        ri_as_no                    GIRI_FRPS_RI.ri_as_no%TYPE, 
        ri_accept_date              GIRI_FRPS_RI.ri_accept_date%TYPE, 
        fnl_binder_id               GIRI_BINDER.fnl_binder_id%TYPE, 
        policy_id                   GIPI_POLBASIC.policy_id%TYPE, 
        par_id                      GIPI_POLBASIC.par_id%TYPE, 
        endt_seq_no                 GIPI_POLBASIC.endt_seq_no%TYPE, 
        endt_yy                     GIPI_POLBASIC.endt_yy%TYPE,
        endt_iss_cd                 GIPI_POLBASIC.endt_iss_cd%TYPE,
        subline_cd                  GIPI_POLBASIC.subline_cd%TYPE,
        subline_name                GIIS_SUBLINE.subline_name%TYPE, 
        line_cd                     GIPI_POLBASIC.line_cd%TYPE,
        cf_class                    VARCHAR2(100),
        cf_property                 VARCHAR2(100),
        mop_number                  VARCHAR2(100),
        sailing_date                VARCHAR2(100),
        show_sailing_date           VARCHAR2(1),    
        iss_cd                      GIPI_POLBASIC.iss_cd%TYPE, 
        line_cd_1                   GIRI_FRPS_RI.line_cd%TYPE, 
        frps_yy                     GIRI_FRPS_RI.frps_yy%TYPE,
        frps_seq_no                 GIRI_FRPS_RI.frps_seq_no%TYPE, 
        reverse_sw                  GIRI_FRPS_RI.reverse_sw%TYPE, 
        reverse_date                GIRI_BINDER.reverse_date%TYPE, 
        other_charges               GIRI_FRPS_RI.other_charges%TYPE, 
        ri_cd                       GIIS_REINSURER.ri_cd%TYPE, 
        user_id                     VARCHAR2 (20), 
        local_foreign_sw            GIIS_REINSURER.local_foreign_sw%TYPE, 
        short_name                  GIIS_CURRENCY.short_name%TYPE,
        signatory_label             GIAC_REP_SIGNATORY.label%TYPE,
        signatories                 GIIS_SIGNATORY_NAMES.file_name%TYPE,
        designation                 GIIS_SIGNATORY_NAMES.designation%TYPE,
        signatory                   GIIS_SIGNATORY_NAMES.signatory%TYPE,
        company_name		        GIIS_PARAMETERS.param_value_v%TYPE,
        vat_title                   GIIS_PARAMETERS.param_value_v%TYPE,
        prem_tax_title              GIIS_PARAMETERS.param_value_v%TYPE,
        cf_for                      VARCHAR2(2500),
        show_vat                    VARCHAR2(1),
        show_whold_vat              VARCHAR2(1),
        show_tax                    VARCHAR2(1),
        show_binder_as_no           VARCHAR2(1),    
        pol_flag                    gipi_polbasic.pol_flag%TYPE,
        /*report variables */
        rv_binder_line              GIIS_DOCUMENT.text%TYPE,
        rv_binder_note              GIIS_DOCUMENT.text%TYPE,
        rv_binder_hdr               GIIS_DOCUMENT.text%TYPE,
        rv_binder_ftr               GIIS_DOCUMENT.text%TYPE,
        rv_binder_for               GIIS_DOCUMENT.text%TYPE,
        rv_binder_confirmation      GIIS_DOCUMENT.text%TYPE,
        rv_frps_ret                 GIIS_DOCUMENT.text%TYPE,
        rv_user_id			        GIIS_DOCUMENT.text%TYPE,
        rv_hide			            GIIS_DOCUMENT.text%TYPE,
        rv_addressee			    GIIS_DOCUMENT.text%TYPE,
        rv_addressee_confirmation	GIIS_DOCUMENT.text%TYPE,
        rv_print_line_name          GIIS_DOCUMENT.text%TYPE,
        rv_print_auth_sig_above     GIIS_DOCUMENT.text%TYPE,
        rv_print_sig_refdate_across GIIS_DOCUMENT.text%TYPE
     
        /* end of report variables*/
    );
    
    TYPE giri_binder_report_tab IS TABLE OF giri_binder_report_type;
    
    TYPE giri_binder_report_peril_type IS RECORD(
        gross_prem                  NUMBER,       
        ri_prem_amt                 NUMBER,
        ri_comm_rt                  NUMBER,
        ri_comm_amt                 NUMBER,
        less_ri_comm_amt            NUMBER,
        fnl_binder_id               GIRI_BINDER_PERIL.fnl_binder_id%TYPE,
        line_cd                     GIRI_FRPS_RI.line_cd%TYPE,
        frps_yy                     GIRI_FRPS_RI.frps_yy%TYPE,
        frps_seq_no                 GIRI_FRPS_RI.frps_seq_no%TYPE,
        peril_title                 GIRI_FRPS_PERIL_GRP.peril_title%TYPE,
        ri_prem_vat                 GIRI_BINDER.ri_prem_vat%TYPE,
        ri_comm_vat                 GIRI_BINDER.ri_comm_vat%TYPE,
        peril_comm_vat              GIRI_BINDER_PERIL.ri_comm_vat%TYPE,
        less_comm_vat               NUMBER,
        v_sequence                  NUMBER,
        prt_flag                    VARCHAR2(2),
        ri_wholding_vat             NUMBER,
        display_peril               VARCHAR2(1),  -- jhing 03.30.2016 REPUBLICFULLWEB SR# 21773 
        cnt_disp_peril              NUMBER ,
        peril_rowno                 NUMBER 
    );
    
    TYPE giri_binder_report_peril_tab IS TABLE OF giri_binder_report_peril_type;
    
    FUNCTION get_giri_binder_report_details(p_line_cd       GIRI_BINDER.line_cd%TYPE,
                                            p_binder_yy     GIRI_BINDER.binder_yy%TYPE,
                                            p_binder_seq_no GIRI_BINDER.binder_seq_no%TYPE,
                                            p_report_id     GIIS_REPORTS.REPORT_ID%TYPE)
                                            
    RETURN giri_binder_report_tab PIPELINED;
    
    
    PROCEDURE initialize_report_variables (p_report_id   GIIS_REPORTS.REPORT_ID%TYPE);
    
    FUNCTION get_giri_binder_report_perils (p_fnl_binder_id     GIRI_BINDER_PERIL.fnl_binder_id%TYPE,
                                            p_line_cd           GIRI_FRPS_RI.line_cd%TYPE,
                                            p_frps_yy           GIRI_FRPS_RI.frps_yy%TYPE,
                                            p_frps_seq_no       GIRI_FRPS_RI.frps_seq_no%TYPE,
                                            p_reverse_sw        GIRI_FRPS_RI.reverse_sw%TYPE, 
                                            p_reverse_date      GIRI_BINDER.reverse_date%TYPE,
                                            p_ri_cd             GIIS_REINSURER.ri_cd%TYPE)
                                            
    RETURN giri_binder_report_peril_tab PIPELINED; 
    
    TYPE girir002_report_type IS RECORD(
        pre_binder_id       VARCHAR2(100),
        frps_no             VARCHAR2(1000),
        binder_no           VARCHAR2(1000),
        binder_date         GIRI_WBINDER.binder_date%TYPE,
        ri_name             GIIS_REINSURER.ri_name%TYPE,
        mail_address1       GIIS_REINSURER.mail_address1%TYPE,
        mail_address2       GIIS_REINSURER.mail_address2%TYPE,
        mail_address3       GIIS_REINSURER.mail_address3%TYPE,
        attention           GIRI_WBINDER.attention%TYPE,
        assd_name           GIIS_ASSURED.assd_name%TYPE,
        line_name           GIIS_LINE.line_name%TYPE,
        loc_voy_unit        GIRI_WDISTFRPS.loc_voy_unit%TYPE,
        policy_no           VARCHAR2(1000),
        endt_iss_cd         GIPI_POLBASIC.endt_iss_cd%TYPE,
        endt_yy             GIPI_POLBASIC.endt_yy%TYPE,
        endt_seq_no         GIPI_POLBASIC.endt_seq_no%TYPE,
        tsi_amt             VARCHAR2(1000),
        ri_term             VARCHAR2(1000),
        your_share          VARCHAR2(1000),
        ri_prem_amt         GIRI_WBINDER.ri_prem_amt%TYPE,
        bndr_remarks1       GIRI_WFRPS_RI.bndr_remarks1%TYPE,
        bndr_remarks2       GIRI_WFRPS_RI.bndr_remarks2%TYPE,
        bndr_remarks3       GIRI_WFRPS_RI.bndr_remarks3%TYPE,
        confirm_no          GIRI_WBINDER.confirm_no%TYPE,
        dist_par_no         VARCHAR2(1000),
        peril_title         VARCHAR2(1000),
        ri_comm_rt          VARCHAR2(1000),
        endt_no             VARCHAR2(1000)
    );
    
    TYPE girir002_report_tab IS TABLE OF girir002_report_type;
    
    FUNCTION get_girir002_details (
        p_line_cd           GIRI_WDISTFRPS.line_cd%TYPE,
        p_frps_yy           GIRI_WDISTFRPS.frps_yy%TYPE,
        p_frps_seq_no       GIRI_WDISTFRPS.frps_seq_no%TYPE
    )
    RETURN girir002_report_tab PIPELINED;
    
    TYPE girir001a_report_type IS RECORD(
        assd_no                gipi_parlist.assd_no%TYPE,
        attention              giis_reinsurer.attention%TYPE,
        user_id                VARCHAR2(50),  
        bill_address11         giis_reinsurer.bill_address1%TYPE,
        bill_address22         giis_reinsurer.bill_address2%TYPE,
        bill_address33         giis_reinsurer.bill_address3%TYPE,
        binder_date5           giri_binder.binder_date%TYPE,
        binder_no              VARCHAR2(100),
        binder_no1             VARCHAR2(100),
        confirm_date           giri_binder.confirm_date%TYPE,
        confirm_no             giri_binder.confirm_no%TYPE,
        endt_iss_cd            gipi_polbasic.endt_iss_cd%TYPE,
        endt_no                VARCHAR2(50),
        endt_seq_no            gipi_polbasic.endt_seq_no%TYPE,
        endt_seq_no2           gipi_polbasic.endt_seq_no%TYPE,
        endt_text              giri_binder.endt_text%TYPE,
        endt_yy                gipi_polbasic.endt_yy%TYPE,
        fnl_binder_id2         giri_binder.fnl_binder_id%TYPE,
        line_cd                gipi_polbasic.line_cd%TYPE,
        line_name              giis_line.line_name%TYPE,
        par_id                 gipi_polbasic.par_id%TYPE,
        policy_id              gipi_polbasic.policy_id%TYPE,
        policy_no              VARCHAR2(50),
        ri_name                giis_reinsurer.ri_name%TYPE,
        ri_term                VARCHAR2(100),       
        subline_cd             gipi_polbasic.subline_cd%TYPE,
        assd_name              giis_assured.assd_name%TYPE,
        endt		           VARCHAR2(30),
        mop		               VARCHAR2(27),
        m_svu                  VARCHAR2(20),
        first_paragraph        VARCHAR2(250),
        heading                VARCHAR2(100),
        m_company_nm		   giis_parameters.param_value_v%TYPE,
        param_attn             giis_reinsurer.attention%TYPE,
        reverse_date           giri_binder.reverse_date%TYPE
    );
    
    TYPE girir001a_report_tab IS TABLE OF girir001a_report_type;    
    
    FUNCTION get_girir001a_details(
        p_line_v             GIRI_BINDER.line_cd%TYPE,
        p_binder_yy_v        GIRI_BINDER.binder_yy%TYPE,
        p_binder_seq_no_v    GIRI_BINDER.binder_seq_no%TYPE,
        p_attention          GIIS_REINSURER.attention%TYPE
    )                                   
    RETURN girir001a_report_tab PIPELINED;

END GIRI_BINDER_REPORTS_PKG;
/


