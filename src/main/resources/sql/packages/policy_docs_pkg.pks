CREATE OR REPLACE PACKAGE CPI.POLICY_DOCS_PKG
AS
    /* report variables */
    par_par                        VARCHAR2(40)  := 'POLICY CERTIFICATE';
    par_policy                    VARCHAR2(40)  := 'POLICY SCHEDULE';
    endt_par                    VARCHAR2(40)  := 'ENDORSEMENT CERTIFICATE';
    endt_policy                    VARCHAR2(40)  := 'ENDORSEMENT SCHEDULE';
    par                            CONSTANT VARCHAR2(20)  := 'PAR No.      ';
    POLICY                        CONSTANT VARCHAR2(20)  := 'Policy No.   ';
    par_header                    CONSTANT VARCHAR2(100) := 'SAMPLE POLICY';
    endt_header                    CONSTANT VARCHAR2(100) := 'SAMPLE ENDORSEMENT';
    all_subline_wordings1        GIIS_DOCUMENT.text%TYPE;
    all_subline_wordings2        GIIS_DOCUMENT.text%TYPE;
    attestation_title            GIIS_DOCUMENT.text%TYPE;
    block_description            GIIS_DOCUMENT.text%TYPE;
    boundary_title                GIIS_DOCUMENT.text%TYPE;
    ca_deductible_levels        GIIS_DOCUMENT.text%TYPE;
    casualty_co_insurance        GIIS_DOCUMENT.text%TYPE;
    constr_remarks_title        GIIS_DOCUMENT.text%TYPE;
    construction_title            GIIS_DOCUMENT.text%TYPE;
    deductible_title            GIIS_DOCUMENT.text%TYPE; 
    display_ann_tsi                GIIS_DOCUMENT.text%TYPE;
    display_policy_term            GIIS_DOCUMENT.text%TYPE;
    display_property_type        GIIS_DOCUMENT.text%TYPE;
    display_ref_pol_no            GIIS_DOCUMENT.text%TYPE;
    doc_attestation1            GIIS_DOCUMENT.text%TYPE;
    doc_attestation2            GIIS_DOCUMENT.text%TYPE;
    doc_subtitle1                GIIS_DOCUMENT.text%TYPE; 
    doc_subtitle2                GIIS_DOCUMENT.text%TYPE; 
    doc_subtitle3                GIIS_DOCUMENT.text%TYPE; 
    doc_subtitle4                GIIS_DOCUMENT.text%TYPE; 
    doc_subtitle4_before_wc        GIIS_DOCUMENT.text%TYPE;
    doc_subtitle5                GIIS_DOCUMENT.text%TYPE;
    doc_subtitle5_before_wc        GIIS_DOCUMENT.text%TYPE;
    doc_tax_breakdown            GIIS_DOCUMENT.text%TYPE;
    doc_total_in_box            GIIS_DOCUMENT.text%TYPE; 
    grouped_item_title            GIIS_DOCUMENT.text%TYPE;
    grouped_subtitle            GIIS_DOCUMENT.text%TYPE;
    hide_line                    GIIS_DOCUMENT.text%TYPE;
    include_tsi                    GIIS_DOCUMENT.text%TYPE;
    invoice_policy_currency        GIXX_INVOICE.policy_currency%TYPE;
    item_title                    GIIS_DOCUMENT.text%TYPE; 
    leased_to                    GIIS_DOCUMENT.text%TYPE;
    mar_wordings                GIIS_DOCUMENT.text%TYPE;
    mop_map_wordings            GIIS_DOCUMENT.text%TYPE;
    mrn_wordings                GIIS_DOCUMENT.text%TYPE;
    occupancy_remarks_title        GIIS_DOCUMENT.text%TYPE;
    occupancy_title                GIIS_DOCUMENT.text%TYPE;
    pack_method                    GIIS_DOCUMENT.text%TYPE;
    peril_title                    GIIS_DOCUMENT.text%TYPE;
    personnel_item_title        GIIS_DOCUMENT.text%TYPE;
    personnel_subtitle1            GIIS_DOCUMENT.text%TYPE;
    personnel_subtitle2            GIIS_DOCUMENT.text%TYPE;
    personnel_subtitle3            GIIS_DOCUMENT.text%TYPE;
    policy_siglabel                GIIS_DOCUMENT.text%TYPE; 
    print_acc_tsi                GIIS_DOCUMENT.text%TYPE;
    print_accessories_above        GIIS_DOCUMENT.text%TYPE;
    print_all_warranties        GIIS_DOCUMENT.text%TYPE;
    print_authorized_signatory  GIIS_DOCUMENT.text%TYPE;
    print_cargo_desc            GIIS_DOCUMENT.text%TYPE;
    print_cents                    GIIS_DOCUMENT.text%TYPE;
    print_currency_desc            GIIS_DOCUMENT.text%TYPE;
    print_declaration_no        GIIS_DOCUMENT.text%TYPE;
    print_ded_text                GIIS_DOCUMENT.text%TYPE;
    print_ded_text_only            GIIS_DOCUMENT.text%TYPE;
    print_ded_text_peril        GIIS_DOCUMENT.text%TYPE;
    print_ded_twice                GIIS_DOCUMENT.text%TYPE;
    print_deduct_text_amt        GIIS_DOCUMENT.text%TYPE;
    print_deductible_amt        GIIS_DOCUMENT.text%TYPE;
	print_deductible_rt         GIIS_DOCUMENT.text%TYPE;
    print_deductibles            GIIS_DOCUMENT.text%TYPE;
    print_district_block        GIIS_DOCUMENT.text%TYPE;
    print_doc_signature_pol1    GIIS_DOCUMENT.text%TYPE;
    print_doc_signature_pol2    GIIS_DOCUMENT.text%TYPE;
    print_doc_subtitle1            GIIS_DOCUMENT.text%TYPE;
    print_doc_subtitle2            GIIS_DOCUMENT.text%TYPE;
    print_doc_subtitle3            GIIS_DOCUMENT.text%TYPE;
    print_doc_subtitle4            GIIS_DOCUMENT.text%TYPE;
    print_doc_subtitle5            GIIS_DOCUMENT.text%TYPE;
    print_dtls_below_user        GIIS_DOCUMENT.text%TYPE;
    print_gen_info_above        GIIS_DOCUMENT.text%TYPE;
    print_grouped_beneficiary    GIIS_DOCUMENT.text%TYPE;
    print_intm_name                GIIS_DOCUMENT.text%TYPE;
    print_item_total            GIIS_DOCUMENT.text%TYPE;
    print_last_endtxt            GIIS_DOCUMENT.text%TYPE;
    print_lower_dtls            GIIS_DOCUMENT.text%TYPE;
    print_mop_deductibles        GIIS_DOCUMENT.text%TYPE;
    print_mop_no_above            GIIS_DOCUMENT.text%TYPE;
    print_mop_wordings            GIIS_DOCUMENT.text%TYPE;
    print_mort_amt                GIIS_DOCUMENT.text%TYPE;
    print_mortgagee                GIIS_DOCUMENT.text%TYPE;
    print_mortgagee_name        GIIS_DOCUMENT.text%TYPE;
    print_null_mortgagee        GIIS_DOCUMENT.text%TYPE;
    print_one_item_title        GIIS_DOCUMENT.text%TYPE;
    print_origin_dest_above        GIIS_DOCUMENT.text%TYPE;
    print_peril                    GIIS_DOCUMENT.text%TYPE;
    print_peril_name_long        GIIS_DOCUMENT.text%TYPE;
    print_polno_endt            GIIS_DOCUMENT.text%TYPE;
    print_premium_rate            GIIS_DOCUMENT.text%TYPE;
    print_ref_pol_no            GIIS_DOCUMENT.text%TYPE;
    print_renewal_top            GIIS_DOCUMENT.text%TYPE;
    print_report_title            GIIS_DOCUMENT.text%TYPE;
    print_short_name            GIIS_DOCUMENT.text%TYPE;
    print_signatory                GIIS_DOCUMENT.text%TYPE;
    print_sub_info                GIIS_DOCUMENT.text%TYPE;
    print_sum_insured            GIIS_DOCUMENT.text%TYPE;
    print_survey_settling_agent GIIS_DOCUMENT.text%TYPE;
    print_tabular                GIIS_DOCUMENT.text%TYPE;
    print_tariff_zone           GIIS_DOCUMENT.text%TYPE;
    print_time                    GIIS_DOCUMENT.text%TYPE; 
    print_upper_case            GIIS_DOCUMENT.text%TYPE; 
    print_wrrnties_fontbig        GIIS_DOCUMENT.text%TYPE;
    print_zero_premium            GIIS_DOCUMENT.text%TYPE;
    print_zone                    GIIS_DOCUMENT.text%TYPE;
    sum_insured_title            GIIS_DOCUMENT.text%TYPE; 
    sum_insured_title2            GIIS_DOCUMENT.text%TYPE;
    survey_title                GIIS_DOCUMENT.text%TYPE;
    survey_wordings                GIIS_DOCUMENT.text%TYPE;
    tax_breakdown                GIIS_DOCUMENT.text%TYPE;
    tsi_label1                    GIIS_DOCUMENT.text%TYPE;
    tsi_label2                    GIIS_DOCUMENT.text%TYPE;
    without_item_no                GIIS_DOCUMENT.text%TYPE;
    beneficiary_item_title        GIIS_DOCUMENT.text%TYPE;
    beneficiary_subtitle1        GIIS_DOCUMENT.text%TYPE;
    beneficiary_subtitle2        GIIS_DOCUMENT.text%TYPE;
    print_deductible_amt_total    GIIS_DOCUMENT.text%TYPE;
    show_signature                 GIIS_DOCUMENT.text%TYPE;  -- bonok :: 7.30.2015 :: SR 19544
    /*end for report variables */
    
    TYPE report_type IS RECORD (
        /* package specs variables */
        rv_par_par                        VARCHAR2(50),
        rv_par_policy                    VARCHAR2(50),
        rv_endt_par                        VARCHAR2(50),
        rv_endt_policy                    VARCHAR2(50),
        rv_par                            VARCHAR2(50),
        rv_policy                        VARCHAR2(50),
        rv_par_header                    VARCHAR2(50),
        rv_endt_header                    VARCHAR2(50),
        rv_attestation_title            GIIS_DOCUMENT.text%TYPE,
        rv_block_description            GIIS_DOCUMENT.text%TYPE,
        rv_boundary_title                GIIS_DOCUMENT.text%TYPE,
        rv_ca_deductible_levels            GIIS_DOCUMENT.text%TYPE,
        rv_casualty_co_insurance        GIIS_DOCUMENT.text%TYPE,
        rv_constr_remarks_title            GIIS_DOCUMENT.text%TYPE,
        rv_construction_title            GIIS_DOCUMENT.text%TYPE,
        rv_deductible_title                GIIS_DOCUMENT.text%TYPE,
        rv_display_ann_tsi                GIIS_DOCUMENT.text%TYPE,
        rv_display_policy_term            GIIS_DOCUMENT.text%TYPE,
        rv_display_property_type        GIIS_DOCUMENT.text%TYPE,
        rv_display_ref_pol_no            GIIS_DOCUMENT.text%TYPE,
        rv_doc_attestation1                GIIS_DOCUMENT.text%TYPE,
        rv_doc_attestation2                GIIS_DOCUMENT.text%TYPE,
        rv_doc_subtitle1                GIIS_DOCUMENT.text%TYPE, 
        rv_doc_subtitle2                GIIS_DOCUMENT.text%TYPE, 
        rv_doc_subtitle3                GIIS_DOCUMENT.text%TYPE, 
        rv_doc_subtitle4                GIIS_DOCUMENT.text%TYPE, 
        rv_doc_subtitle4_before_wc        GIIS_DOCUMENT.text%TYPE,
        rv_doc_subtitle5                GIIS_DOCUMENT.text%TYPE,
        rv_doc_subtitle5_before_wc        GIIS_DOCUMENT.text%TYPE,
        rv_doc_tax_breakdown            GIIS_DOCUMENT.text%TYPE,
        rv_doc_total_in_box                GIIS_DOCUMENT.text%TYPE, 
        rv_grouped_item_title            GIIS_DOCUMENT.text%TYPE,
        rv_grouped_subtitle                GIIS_DOCUMENT.text%TYPE,
        rv_hide_line                    GIIS_DOCUMENT.text%TYPE,    
        rv_include_tsi                    GIIS_DOCUMENT.text%TYPE,
        rv_invoice_policy_currency        GIXX_INVOICE.policy_currency%TYPE,
        rv_item_title                    GIIS_DOCUMENT.text%TYPE,
        rv_leased_to                    GIIS_DOCUMENT.text%TYPE,
        rv_occupancy_remarks_title        GIIS_DOCUMENT.text%TYPE,
        rv_occupancy_title                GIIS_DOCUMENT.text%TYPE,
        rv_pack_method                    GIIS_DOCUMENT.text%TYPE,
        rv_peril_title                    GIIS_DOCUMENT.text%TYPE,
        rv_personnel_item_title            GIIS_DOCUMENT.text%TYPE,
        rv_personnel_subtitle1            GIIS_DOCUMENT.text%TYPE,
        rv_personnel_subtitle2            GIIS_DOCUMENT.text%TYPE,
        rv_personnel_subtitle3            GIIS_DOCUMENT.text%TYPE,
        rv_policy_siglabel                GIIS_DOCUMENT.text%TYPE, 
        rv_print_acc_tsi                GIIS_DOCUMENT.text%TYPE,
        rv_print_accessories_above        GIIS_DOCUMENT.text%TYPE,
        rv_print_all_warranties            GIIS_DOCUMENT.text%TYPE,
        rv_print_authorized_signatory      GIIS_DOCUMENT.text%TYPE,
        rv_print_cargo_desc                GIIS_DOCUMENT.text%TYPE,
        rv_print_cents                    GIIS_DOCUMENT.text%TYPE,
        rv_print_currency_desc            GIIS_DOCUMENT.text%TYPE,
        rv_print_declaration_no            GIIS_DOCUMENT.text%TYPE,
        rv_print_ded_text                GIIS_DOCUMENT.text%TYPE,
        rv_print_ded_text_only            GIIS_DOCUMENT.text%TYPE,
        rv_print_ded_text_peril            GIIS_DOCUMENT.text%TYPE,
        rv_print_ded_twice                GIIS_DOCUMENT.text%TYPE,
        rv_print_deduct_text_amt        GIIS_DOCUMENT.text%TYPE,
        rv_print_deductible_amt            GIIS_DOCUMENT.text%TYPE,
        rv_print_deductible_rt            GIIS_DOCUMENT.text%TYPE,
		rv_print_deductibles            GIIS_DOCUMENT.text%TYPE,
        rv_print_district_block            GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_signature_pol1        GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_signature_pol2        GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_subtitle1            GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_subtitle2            GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_subtitle3            GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_subtitle4            GIIS_DOCUMENT.text%TYPE,
        rv_print_doc_subtitle5            GIIS_DOCUMENT.text%TYPE,
        rv_print_dtls_below_user        GIIS_DOCUMENT.text%TYPE,
        rv_print_gen_info_above            GIIS_DOCUMENT.text%TYPE,
        rv_print_grouped_beneficiary    GIIS_DOCUMENT.text%TYPE,
        rv_print_intm_name                GIIS_DOCUMENT.text%TYPE,
        rv_print_item_total                GIIS_DOCUMENT.text%TYPE,
        rv_print_last_endtxt            GIIS_DOCUMENT.text%TYPE,
        rv_print_lower_dtls                GIIS_DOCUMENT.text%TYPE,
        rv_print_mop_deductibles        GIIS_DOCUMENT.text%TYPE,
        rv_print_mop_no_above            GIIS_DOCUMENT.text%TYPE,
        rv_print_mop_wordings            GIIS_DOCUMENT.text%TYPE,
        rv_print_mort_amt                GIIS_DOCUMENT.text%TYPE,
        rv_print_mortgagee                GIIS_DOCUMENT.text%TYPE,
        rv_print_mortgagee_name            GIIS_DOCUMENT.text%TYPE,
        rv_print_null_mortgagee            GIIS_DOCUMENT.text%TYPE,
        rv_print_one_item_title            GIIS_DOCUMENT.text%TYPE,
        rv_print_origin_dest_above        GIIS_DOCUMENT.text%TYPE,
        rv_print_peril                    GIIS_DOCUMENT.text%TYPE,
        rv_print_peril_name_long        GIIS_DOCUMENT.text%TYPE,
        rv_print_polno_endt                GIIS_DOCUMENT.text%TYPE,
        rv_print_premium_rate            GIIS_DOCUMENT.text%TYPE,
        rv_print_ref_pol_no                GIIS_DOCUMENT.text%TYPE,
        rv_print_renewal_top            GIIS_DOCUMENT.text%TYPE,
        rv_print_report_title            GIIS_DOCUMENT.text%TYPE,
        rv_print_short_name                GIIS_DOCUMENT.text%TYPE,
        rv_print_signatory                GIIS_DOCUMENT.text%TYPE,
        rv_print_sub_info                GIIS_DOCUMENT.text%TYPE,
        rv_print_sum_insured            GIIS_DOCUMENT.text%TYPE,
        rv_print_survey_settling_agent     GIIS_DOCUMENT.text%TYPE,
        rv_print_tabular                GIIS_DOCUMENT.text%TYPE,
        rv_print_tariff_zone            GIIS_DOCUMENT.text%TYPE,
        rv_print_time                    GIIS_DOCUMENT.text%TYPE,
        rv_print_upper_case                GIIS_DOCUMENT.text%TYPE,
        rv_print_wrrnties_fontbig        GIIS_DOCUMENT.text%TYPE,
        rv_print_zero_premium            GIIS_DOCUMENT.text%TYPE,
        rv_print_zone                    GIIS_DOCUMENT.text%TYPE,
        rv_sum_insured_title            GIIS_DOCUMENT.text%TYPE,
        rv_sum_insured_title2            GIIS_DOCUMENT.text%TYPE,
        rv_survey_title                    GIIS_DOCUMENT.text%TYPE,
        rv_survey_wordings                GIIS_DOCUMENT.text%TYPE,
        rv_tax_breakdown                GIIS_DOCUMENT.text%TYPE,
        rv_tsi_label1                    GIIS_DOCUMENT.text%TYPE,
        rv_tsi_label2                    GIIS_DOCUMENT.text%TYPE,
        rv_without_item_no                GIIS_DOCUMENT.text%TYPE,
        rv_beneficiary_item_title        GIIS_DOCUMENT.text%TYPE,
        rv_beneficiary_subtitle1        GIIS_DOCUMENT.text%TYPE,
        rv_beneficiary_subtitle2        GIIS_DOCUMENT.text%TYPE,
        rv_print_deductible_amt_total   GIIS_DOCUMENT.text%TYPE,
        rv_item_count                   NUMBER,
        rv_print_fleet_tag                GIIS_DOCUMENT.text%TYPE, -- bonok :: 09.11.2012
        rv_print_deductible_type        GIIS_DOCUMENT.text%TYPE, -- marco - 11.21.2012
        rv_show_signature          GIIS_DOCUMENT.text%TYPE,  -- bonok :: 7.30.2015 :: SR 19544
        /* end for package specs variables */
        /* report function fields */
        f_header                VARCHAR2(50),
        f_report_title            VARCHAR2(50),
        f_dash                    VARCHAR2(60),
        assured_name            GIIS_ASSURED.assd_name%TYPE,
        f_assd_name                VARCHAR2(600),--GIIS_ASSURED.assd_name%TYPE, changed datatype to varchar2(600) by robert 04.26.2013 sr 12880
        par_policy_label        VARCHAR2(30),
        f_prem_title            VARCHAR2(30),
        f_prem_title_short_name    VARCHAR2(10),
        prem_label_amount        NUMBER(38,2),
        f_acct_of_cd            VARCHAR2(500),
        f_currency                VARCHAR2(30),
        f_amount_due_title        VARCHAR2(30),
        f_amount_due            NUMBER(16,2),
        f_amount_due_short_name    VARCHAR2(10),
        f_tsi_label1            VARCHAR2(20),
        f_tsi_amt                VARCHAR2(20),
        f_tsi_label2            VARCHAR2(25),
        f_acc_sum                NUMBER(38,2),
        f_premium_amt            NUMBER(20,2),
        f_tax_amt                NUMBER(20,2),
        f_other_charges            NUMBER(20,2),
        f_total_tsi                NUMBER(20,2),
        f_currency_name            VARCHAR2(50),
        f_basic_tsi_spell        VARCHAR2(500),
        f_total_in_words        VARCHAR2(500),
        f_acc_sum_word            VARCHAR2(500),
        f_renewal                VARCHAR2(100),
        f_signatory_header        VARCHAR2(3000),
        f_signatory_text1        VARCHAR2(2000),
        f_signatory_text2        VARCHAR2(2000),
        f_company                VARCHAR2(100),
        f_signatory                VARCHAR2(100),
        f_signature_img          VARCHAR2(100),  -- bonok :: 7.30.2015 :: SR 19544
        f_designation            VARCHAR2(100),
        f_user                    VARCHAR2(100),
        f_intm_no                VARCHAR2(100),
        f_intm_name             VARCHAR2(500),   --VARCHAR2(100), changed by Nica 12.21.2011
        f_ref_inv_no            VARCHAR2(120),
        f_policy_id                NUMBER(12),
        f_mop_map_wordings        GIIS_DOCUMENT.text%TYPE,
        f_mop_wordings            GIIS_DOCUMENT.text%TYPE,
        --robert 12/16/2011
        label_assd            VARCHAR2(30), 
        /* end for report function fields */
        /* main query fields */
        par_seq_no1                VARCHAR2(50),
        extract_id1                GIXX_POLBASIC.extract_id%TYPE,
        par_id                    GIXX_POLBASIC.policy_id%TYPE,
        policy_number            VARCHAR2(50),        
        par_no                    VARCHAR2(50),
        par_orig                VARCHAR2(50),
        line_line_name            GIIS_LINE.line_name%TYPE,
        subline_subline_name    GIIS_SUBLINE.subline_name%TYPE,
        subline_subline_cd        GIIS_SUBLINE.subline_cd%TYPE,
        subline_line_cd            GIIS_LINE.line_cd%TYPE,
        basic_incept_date        VARCHAR2(30),
        basic_expiry_date        VARCHAR2(30),
        basic_expiry_tag        GIXX_POLBASIC.expiry_tag%TYPE,
        basic_issue_date        VARCHAR2(30),
        basic_tsi_amt            GIXX_POLBASIC.tsi_amt%TYPE,
        subline_subline_time    VARCHAR2(30),
        basic_acct_of_cd        GIXX_POLBASIC.acct_of_cd%TYPE,
        basic_mortg_name        GIXX_POLBASIC.mortg_name%TYPE,
        basic_assd_no            NUMBER(12),
        address1                VARCHAR2(50),
        address2                VARCHAR2(50),
        address3                VARCHAR2(50),        
        basic_addr                VARCHAR2(180),
        basic_pol_flag            GIXX_POLBASIC.pol_flag%TYPE,
        basic_line_cd            GIXX_POLBASIC.line_cd%TYPE,
        basic_ref_pol_no        GIXX_POLBASIC.ref_pol_no%TYPE,
        basic_assd_no2            GIXX_POLBASIC.assd_no%TYPE,
        label_tag                VARCHAR2(20),
        label_tag1                GIXX_POLBASIC.label_tag%TYPE,
        -- end of pol info --
        endt_no                    VARCHAR2(50),
        pol_endt_no                VARCHAR2(50),
        endt_expiry_date        VARCHAR2(30),
        basic_eff_date            VARCHAR2(30),
        eff_date                GIXX_POLBASIC.eff_date%TYPE,
        endt_expiry_tag            GIXX_POLBASIC.endt_expiry_tag%TYPE,
        basic_incept_tag        GIXX_POLBASIC.incept_tag%TYPE,
        basic_subline_cd        GIXX_POLBASIC.subline_cd%TYPE,
        basic_iss_cd            GIXX_POLBASIC.iss_cd%TYPE,
        basic_issue_yy            GIXX_POLBASIC.issue_yy%TYPE,
        basic_pol_seq_no        GIXX_POLBASIC.pol_seq_no%TYPE,
        basic_renew_no            GIXX_POLBASIC.renew_no%TYPE,
        basic_eff_time            VARCHAR2(35),
        basic_endt_expiry_time    VARCHAR2(35),
        eff_date_time             GIXX_POLBASIC.eff_date%TYPE, --abie 07212011
        -- end of endt policy --
        par_par_type            GIXX_PARLIST.par_type%TYPE,
        par_par_status            GIXX_PARLIST.par_status%TYPE,
        basic_co_insurance_sw    GIXX_POLBASIC.co_insurance_sw%TYPE,
        username                VARCHAR(30),
        subline_open_policy        GIIS_SUBLINE.op_flag%TYPE,
        cred_br                    GIXX_POLBASIC.cred_branch%TYPE,
        assd_name                VARCHAR2(600),--GIIS_ASSURED.assd_name%TYPE, changed datatype to varchar2(600) by robert 04.26.2013 sr 12880
        in_acct_of                GIIS_ASSURED.assd_name%TYPE,
        mop_no                    VARCHAR2(100), --VARCHAR2(50), --benjo 09.10.2015 GENQA-SR-4905 50->100
        /* end for main query fields */
        /* other variables */
        show_mortgagee            VARCHAR2(1) := 'N',
        show_deductible_text    GIXX_DEDUCTIBLES.deductible_text%TYPE,
        show_polgenin            VARCHAR2(1) := 'N',
        show_perils                VARCHAR2(1) := 'Y',
        show_polgenin_gen_info    VARCHAR2(1) := 'N',
        show_perils2            VARCHAR2(1) := 'N',
        show_item                VARCHAR2(1) := 'N',
        show_warr_and_clauses    VARCHAR2(1) := 'N',
        show_intm_no            VARCHAR2(1) := 'N',
        show_intm_name            VARCHAR2(1) := 'N',
        show_ref_pol_no            VARCHAR2(1) := 'N',
        show_doc_total_in_box    VARCHAR2(1) := 'N',
        show_basic_tsi_spell    VARCHAR2(1) := 'N',
        show_acc_sum_word        VARCHAR2(1) := 'N',
        show_par_no                VARCHAR2(1) := 'N',
        show_cred_br            VARCHAR2(1) := 'N',
        show_policy_id            VARCHAR2(1) := 'N',
        show_mn_item_header        VARCHAR2(1) := 'N'
        /* end for other variables */);
        
    TYPE report_tab IS TABLE OF report_type;
    
    TYPE eng_taxes_type IS RECORD(
        extract_id              GIXX_INV_TAX.extract_id%TYPE, 
        invtax_tax_cd           GIXX_INV_TAX.tax_cd%TYPE, 
        invtax_tax_amt          NUMBER,
        taxcharg_tax_desc       GIIS_TAX_CHARGES.tax_desc%TYPE, 
        tax_charge_include_tag  GIIS_TAX_CHARGES.include_tag%TYPE, 
        taxcharg_sequence       NUMBER,
        count_tax               NUMBER    
    );
       
    TYPE eng_taxes_tab IS TABLE OF eng_taxes_type;
    
    FUNCTION get_report_details(
        p_extract_id IN GIXX_POLBASIC.extract_id%TYPE,
        p_report_id    IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN report_tab PIPELINED;    
    
    PROCEDURE initialize_variables (p_report_id IN GIIS_DOCUMENT.report_id%TYPE);
    
    FUNCTION get_giisp_v_param(p_report_id    IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN VARCHAR2;    
    
    FUNCTION CF_TSI_AMT2 (
        p_extract_id IN GIXX_POLBASIC.extract_id%TYPE,
        p_basic_tsi_amt IN GIXX_POLBASIC.tsi_amt%TYPE,
        p_basic_co_insurance_sw IN GIXX_POLBASIC.co_insurance_sw%TYPE) RETURN NUMBER;
    
    FUNCTION get_line_name(p_report_id IN GIIS_DOCUMENT.report_id%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION get_pol_doc_prem_title (p_print_upper_case IN GIIS_DOCUMENT.text%TYPE)
    RETURN VARCHAR2;
    
    FUNCTION get_eng_taxes_list(p_extract_id     IN   GIXX_INV_TAX.extract_id%TYPE)
    RETURN eng_taxes_tab PIPELINED;
    
END Policy_Docs_Pkg;
/


