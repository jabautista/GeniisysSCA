CREATE OR REPLACE PACKAGE CPI.PACK_POLICY_DOCS_PKG IS
  par_par                     VARCHAR2(40);
  par_policy                  VARCHAR2(40);
  endt_par                    VARCHAR2(40);
  endt_policy                 VARCHAR2(40);
  par                         CONSTANT VARCHAR2(20)  := 'PAR No.';
  policy                      CONSTANT VARCHAR2(20)  := 'Policy No.';
  par_header                  CONSTANT VARCHAR2(100) := 'SAMPLE POLICY';
  endt_header                 CONSTANT VARCHAR2(100) := 'SAMPLE ENDORSEMENT';
  tax_breakdown               GIIS_DOCUMENT.text%TYPE;
  display_policy_term         GIIS_DOCUMENT.text%TYPE;
  print_mortgagee             GIIS_DOCUMENT.text%TYPE;
  print_item_total            GIIS_DOCUMENT.text%TYPE;
  print_peril                 GIIS_DOCUMENT.text%TYPE;
  print_renewal_top           GIIS_DOCUMENT.text%TYPE;
  print_doc_subtitle1         GIIS_DOCUMENT.text%TYPE;
  print_doc_subtitle2         GIIS_DOCUMENT.text%TYPE;
  print_doc_subtitle3         GIIS_DOCUMENT.text%TYPE;
  print_doc_subtitle4         GIIS_DOCUMENT.text%TYPE;
  print_deductibles           GIIS_DOCUMENT.text%TYPE;
  print_accessories_above     GIIS_DOCUMENT.text%TYPE;
  print_all_warranties        GIIS_DOCUMENT.text%TYPE;
  print_wrrnties_fontbig      GIIS_DOCUMENT.text%TYPE;
  print_last_endtxt           GIIS_DOCUMENT.text%TYPE;
  print_sub_info              GIIS_DOCUMENT.text%TYPE;
  doc_tax_breakdown           GIIS_DOCUMENT.text%TYPE;        
  print_ref_pol_no            GIIS_DOCUMENT.text%TYPE;
  print_premium_rate          GIIS_DOCUMENT.text%TYPE;        
  print_mort_amt              GIIS_DOCUMENT.text%TYPE;
  print_sum_insured           GIIS_DOCUMENT.text%TYPE;
  print_one_item_title        GIIS_DOCUMENT.text%TYPE;
  print_report_title          GIIS_DOCUMENT.text%TYPE;
  print_intm_name             GIIS_DOCUMENT.text%TYPE;
  doc_total_in_box            GIIS_DOCUMENT.text%TYPE; 
  doc_subtitle1               GIIS_DOCUMENT.text%TYPE; 
  doc_subtitle2               GIIS_DOCUMENT.text%TYPE; 
  doc_subtitle3               GIIS_DOCUMENT.text%TYPE; 
  doc_subtitle4               GIIS_DOCUMENT.text%TYPE; 
  invoice_policy_currency     GIXX_INVOICE.policy_currency%TYPE;
  doc_subtitle4_before_wc     GIIS_DOCUMENT.text%TYPE;
  print_time                  GIIS_DOCUMENT.text%TYPE; 
  deductible_title            GIIS_DOCUMENT.text%TYPE; 
  print_upper_case            GIIS_DOCUMENT.text%TYPE; 
  sum_insured_title           GIIS_DOCUMENT.text%TYPE; 
  item_title                  GIIS_DOCUMENT.text%TYPE; 
  peril_title                 GIIS_DOCUMENT.text%TYPE;
  print_peril_long_name       GIIS_DOCUMENT.text%TYPE;
  print_deduct_text_amt       GIIS_DOCUMENT.text%TYPE;
  grouped_item_title          GIIS_DOCUMENT.text%TYPE;
  personnel_item_title        GIIS_DOCUMENT.text%TYPE;
  personnel_subtitle1         GIIS_DOCUMENT.text%TYPE;
  personnel_subtitle2         GIIS_DOCUMENT.text%TYPE;
  grouped_subtitle            GIIS_DOCUMENT.text%TYPE;
  attestation_title           GIIS_DOCUMENT.text%TYPE;
  print_currency_desc         GIIS_DOCUMENT.text%TYPE;
  print_peril_name_long       GIIS_DOCUMENT.text%TYPE;
  print_short_name            GIIS_DOCUMENT.text%TYPE;
  print_null_mortgagee        GIIS_DOCUMENT.text%TYPE;
--------------------------------------------------------------------------------
  print_grouped_beneficiary   GIIS_DOCUMENT.text%TYPE;
  beneficiary_item_title      GIIS_DOCUMENT.text%TYPE;
  beneficiary_subtitle1       GIIS_DOCUMENT.text%TYPE;
  beneficiary_subtitle2       GIIS_DOCUMENT.text%TYPE;
  block_description           GIIS_DOCUMENT.text%TYPE;
  boundary_title              GIIS_DOCUMENT.text%TYPE;
  constr_remarks_title        GIIS_DOCUMENT.text%TYPE;
  construction_title          GIIS_DOCUMENT.text%TYPE;
  occupancy_remarks_title     GIIS_DOCUMENT.text%TYPE;
  occupancy_title             GIIS_DOCUMENT.text%TYPE;
  print_zone                  GIIS_DOCUMENT.text%TYPE;
  doc_attestation1            GIIS_DOCUMENT.text%TYPE;
  doc_attestation2            GIIS_DOCUMENT.text%TYPE;
  doc_attestation3            GIIS_DOCUMENT.text%TYPE;
  print_tariff_zone           GIIS_DOCUMENT.text%TYPE;
  policy_siglabel             GIIS_DOCUMENT.text%TYPE;
---------------------@FPAC----------------------------
--------------------ALL LINES-------------------------
  FI                          GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_FI');
  EN                          GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_EN');
  MC                          GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_MC');
  MN                          GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_MN');
  CA                          GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_CA');
  AC                          GIIS_LINE.line_cd%TYPE := GIISP.V('LINE_CODE_AC');
  par_endt_header             GIIS_DOCUMENT.text%TYPE; 
  without_item_no             GIIS_DOCUMENT.text%TYPE;  
  print_ded_text_peril        GIIS_DOCUMENT.text%TYPE;
  line_hidden                 GIIS_DOCUMENT.text%TYPE;
  desc_label                  GIIS_DOCUMENT.text%TYPE;
  display_section             GIIS_DOCUMENT.text%TYPE;    
  v_counter                   NUMBER(2) :=0;
  v_policy_id                 GIXX_POLBASIC.policy_id%TYPE;   
  v_risk_no                   GIXX_ITEM.risk_no%TYPE;  
  v_remarks                   VARCHAR2(6000);
  print_cents                 GIIS_DOCUMENT.text%TYPE; 
  leased_to                   GIIS_DOCUMENT.text%TYPE;
  print_gen_info_above        GIIS_DOCUMENT.text%TYPE;  
  v_null                      NUMBER(1);
  display_ann_tsi             GIIS_DOCUMENT.text%TYPE; 
  display_tsi_endt            GIIS_DOCUMENT.text%TYPE; 
----------------------CASUALTY------------------------
  ca_print_one_item_title     GIIS_DOCUMENT.text%TYPE;
  ca_print_peril              GIIS_DOCUMENT.text%TYPE;   
  ca_print_deduct_text_amt    GIIS_DOCUMENT.text%TYPE;  
  ca_doc_subtitle2            GIIS_DOCUMENT.text%TYPE; 

---------------------ENGINEERING---------------------- 
  en_item_title               GIIS_DOCUMENT.text%TYPE;
  en_print_peril              GIIS_DOCUMENT.text%TYPE;  
  en_print_ded_text           GIIS_DOCUMENT.text%TYPE;  
  en_print_tabular            GIIS_DOCUMENT.text%TYPE; 
  
----------------------ACCIDENT------------------------
  pa_item_title               GIIS_DOCUMENT.text%TYPE; 
  pa_print_eff_exp_date       GIIS_DOCUMENT.text%TYPE;  
  pa_print_ded_text_peril     GIIS_DOCUMENT.text%TYPE;
  pa_print_peril              GIIS_DOCUMENT.text%TYPE; 

-----------------------FIRE---------------------------
  fi_display_district         GIIS_DOCUMENT.text%TYPE;  
  fi_display_type             GIIS_DOCUMENT.text%TYPE;
  fi_display_cons             GIIS_DOCUMENT.text%TYPE;
  fi_check_risk               GIIS_DOCUMENT.text%TYPE;      
  fi_print_peril              GIIS_DOCUMENT.text%TYPE;  
  fi_print_desc_below         GIIS_DOCUMENT.text%TYPE; 
  fi_curr_rt                  GIXX_ITEM.currency_rt%TYPE;
  v_risk_no2                  GIXX_ITEM.risk_no%TYPE; 
------------------MARINE CARGO------------------------
  mn_print_mop_deductibles    GIIS_DOCUMENT.text%TYPE; 
  mn_print_declaration_no     GIIS_DOCUMENT.text%TYPE;
  mn_pack_method              GIIS_DOCUMENT.text%TYPE;
  mn_print_cargo_desc         GIIS_DOCUMENT.text%TYPE;   
  mn_print_origin_dest_above  GIIS_DOCUMENT.text%TYPE;  
  mn_print_premium_rate       GIIS_DOCUMENT.text%TYPE; 
  mn_print_peril              GIIS_DOCUMENT.text%TYPE; 
  vestype_desc                GIIS_VESTYPE.vestype_desc%TYPE;
--------------------PNBGEN------------------------------------
  print_text_beside_signatory GIIS_DOCUMENT.text%TYPE;
  display_neg_amt             GIIS_DOCUMENT.text%TYPE;
  display_item_title          GIIS_DOCUMENT.text%TYPE;
  show_item_risk_amt          GIIS_DOCUMENT.text%TYPE;
  print_original              GIIS_DOCUMENT.text%TYPE;
  print_deductible_amt        GIIS_DOCUMENT.text%TYPE;
  bank_ref_no_label           GIIS_DOCUMENT.text%TYPE;
  
  TYPE pack_report_type IS RECORD (
        /* main query fields */
        par_seq_no1               VARCHAR2(50),
        extract_id1               GIXX_PACK_POLBASIC.extract_id%TYPE,
        par_id                    GIXX_PACK_POLBASIC.policy_id%TYPE,        
        par_no                    VARCHAR2(50),
        par_orig                  VARCHAR2(50),
        line_cd                   GIIS_LINE.line_cd%TYPE,
        line_line_name            GIIS_LINE.line_name%TYPE,
        subline_subline_name      GIIS_SUBLINE.subline_name%TYPE,
        subline_subline_cd        GIIS_SUBLINE.subline_cd%TYPE,
        subline_line_cd           GIIS_LINE.line_cd%TYPE,
        basic_incept_date         VARCHAR2(30),
        basic_expiry_date         VARCHAR2(30),
        basic_expiry_tag          GIXX_PACK_POLBASIC.expiry_tag%TYPE,
        basic_issue_date          VARCHAR2(30),
        basic_tsi_amt             GIXX_PACK_POLBASIC.tsi_amt%TYPE,
        subline_subline_time      VARCHAR2(30),
        basic_acct_of_cd          GIXX_PACK_POLBASIC.acct_of_cd%TYPE,
        basic_mortg_name          GIXX_PACK_POLBASIC.mortg_name%TYPE,
        basic_assd_no             NUMBER(12),
        address1                  VARCHAR2(50),
        address2                  VARCHAR2(50),
        address3                  VARCHAR2(50),        
        basic_addr                VARCHAR2(180),
        basic_pol_flag            GIXX_PACK_POLBASIC.pol_flag%TYPE,
        basic_line_cd             GIXX_PACK_POLBASIC.line_cd%TYPE,
        basic_ref_pol_no          GIXX_PACK_POLBASIC.ref_pol_no%TYPE,
        basic_assd_no2            GIXX_PACK_POLBASIC.assd_no%TYPE,
        label_tag                 VARCHAR2(20),
        label_tag1                GIXX_PACK_POLBASIC.label_tag%TYPE,
        -- end of pol info --
        endt_no                   VARCHAR2(50),
        pol_endt_no               VARCHAR2(50),
        endt_expiry_date          VARCHAR2(30),
        basic_eff_date            VARCHAR2(30),
        eff_date                  GIXX_PACK_POLBASIC.eff_date%TYPE,
        endt_expiry_tag           GIXX_PACK_POLBASIC.endt_expiry_tag%TYPE,
        basic_incept_tag          GIXX_PACK_POLBASIC.incept_tag%TYPE,
        basic_subline_cd          GIXX_PACK_POLBASIC.subline_cd%TYPE,
        basic_iss_cd              GIXX_PACK_POLBASIC.iss_cd%TYPE,
        basic_issue_yy            GIXX_PACK_POLBASIC.issue_yy%TYPE,
        basic_pol_seq_no          GIXX_PACK_POLBASIC.pol_seq_no%TYPE,
        basic_renew_no            GIXX_PACK_POLBASIC.renew_no%TYPE,
        basic_eff_time            VARCHAR2(35),
        basic_endt_expiry_time    VARCHAR2(35),
        -- end of endt policy --
        par_par_type              GIXX_PACK_PARLIST.par_type%TYPE,
        par_par_status            GIXX_PACK_PARLIST.par_status%TYPE,
        basic_co_insurance_sw     GIXX_PACK_POLBASIC.co_insurance_sw%TYPE,
        username                  VARCHAR(30),
        subline_open_policy       GIIS_SUBLINE.op_flag%TYPE,
        cred_br                   GIXX_PACK_POLBASIC.cred_branch%TYPE,
        assd_name                 GIIS_ASSURED.assd_name%TYPE,
        basic_printed_cnt         GIXX_PACK_POLBASIC.polendt_printed_cnt%TYPE,
        basic_printed_dt          GIXX_PACK_POLBASIC.polendt_printed_date%TYPE,
        endt_type                 GIXX_PACK_POLBASIC.endt_type%TYPE,
    /* end for main query fields */
    
    /* report function fields */
        f_header                  VARCHAR2(50),
        f_report_title            VARCHAR2(50),
        f_dash                    VARCHAR2(60),
        assured_name              GIIS_ASSURED.assd_name%TYPE,
        f_assd_name               GIIS_ASSURED.assd_name%TYPE,
        par_policy_label          VARCHAR2(30),
        f_prem_title              VARCHAR2(30),
        f_prem_title_short_name   VARCHAR2(10),
        prem_label_amount         NUMBER(38,2),
        f_acct_of_cd              VARCHAR2(500),
        f_currency                VARCHAR2(30),
        f_amount_due_title        VARCHAR2(30),
        f_amount_due              NUMBER(16,2),
        f_amount_due_short_name   VARCHAR2(10),
        f_tsi_label1              VARCHAR2(20),
        f_tsi_amt                 VARCHAR2(20),
        f_tsi_label2              VARCHAR2(25),
        f_acc_sum                 NUMBER(38,2),
        f_premium_amt             NUMBER(20,2),
        f_tax_amt                 NUMBER(20,2),
        f_other_charges           NUMBER(20,2),
        f_total_tsi               NUMBER(20,2),
        f_currency_name           VARCHAR2(50),
        f_basic_tsi_spell         VARCHAR2(500),
        f_total_in_words          VARCHAR2(500),
        f_acc_sum_word            VARCHAR2(500),
        f_renewal                 VARCHAR2(100),
        f_signatory_header        VARCHAR2(3000),
        f_signatory_text1         VARCHAR2(2000),
        f_signatory_text2         VARCHAR2(2000),
        f_company                 VARCHAR2(100),
        f_signatory               VARCHAR2(100),
        f_designation             VARCHAR2(100),
        f_file_name               giis_signatory_names.file_name%TYPE, -- bonok :: 8.5.2015 :: UCPB SR 20062
        f_user                    VARCHAR2(100),
        f_intm_no                 VARCHAR2(100),
        f_intm_name               VARCHAR2(100),
        f_ref_inv_no              VARCHAR2(120),
        f_policy_id               NUMBER(12),
    /* end for report function fields */
    
    /* package specs variables */
      rv_par_par                  VARCHAR2(40),
      rv_par_policy               VARCHAR2(40),
      rv_endt_par                 VARCHAR2(40),
      rv_endt_policy              VARCHAR2(40),
      rv_par                      VARCHAR2(20),
      rv_policy                   VARCHAR2(20),
      rv_par_header               VARCHAR2(100),
      rv_endt_header              VARCHAR2(100),
      rv_tax_breakdown            GIIS_DOCUMENT.text%TYPE,
      rv_display_policy_term      GIIS_DOCUMENT.text%TYPE,
      rv_print_mortgagee          GIIS_DOCUMENT.text%TYPE,
      rv_print_item_total         GIIS_DOCUMENT.text%TYPE,
      rv_print_peril              GIIS_DOCUMENT.text%TYPE,
      rv_print_renewal_top        GIIS_DOCUMENT.text%TYPE,
      rv_print_doc_subtitle1      GIIS_DOCUMENT.text%TYPE,
      rv_print_doc_subtitle2      GIIS_DOCUMENT.text%TYPE,
      rv_print_doc_subtitle3      GIIS_DOCUMENT.text%TYPE,
      rv_print_doc_subtitle4      GIIS_DOCUMENT.text%TYPE,
      rv_print_deductibles        GIIS_DOCUMENT.text%TYPE,
      rv_print_accessories_above  GIIS_DOCUMENT.text%TYPE,
      rv_print_all_warranties     GIIS_DOCUMENT.text%TYPE,
      rv_print_wrrnties_fontbig   GIIS_DOCUMENT.text%TYPE,
      rv_print_last_endtxt        GIIS_DOCUMENT.text%TYPE,
      rv_print_sub_info           GIIS_DOCUMENT.text%TYPE,
      rv_doc_tax_breakdown        GIIS_DOCUMENT.text%TYPE,        
      rv_print_ref_pol_no         GIIS_DOCUMENT.text%TYPE,
      rv_print_premium_rate       GIIS_DOCUMENT.text%TYPE,        
      rv_print_mort_amt           GIIS_DOCUMENT.text%TYPE,
      rv_print_sum_insured        GIIS_DOCUMENT.text%TYPE,
      rv_print_one_item_title     GIIS_DOCUMENT.text%TYPE,
      rv_print_report_title       GIIS_DOCUMENT.text%TYPE,
      rv_print_intm_name          GIIS_DOCUMENT.text%TYPE,
      rv_doc_total_in_box         GIIS_DOCUMENT.text%TYPE, 
      rv_doc_subtitle1            GIIS_DOCUMENT.text%TYPE, 
      rv_doc_subtitle2            GIIS_DOCUMENT.text%TYPE, 
      rv_doc_subtitle3            GIIS_DOCUMENT.text%TYPE, 
      rv_doc_subtitle4            GIIS_DOCUMENT.text%TYPE, 
      rv_invoice_policy_currency  GIXX_PACK_INVOICE.policy_currency%TYPE,
      rv_doc_subtitle4_before_wc  GIIS_DOCUMENT.text%TYPE,
      rv_print_time               GIIS_DOCUMENT.text%TYPE, 
      rv_deductible_title         GIIS_DOCUMENT.text%TYPE, 
      rv_print_upper_case         GIIS_DOCUMENT.text%TYPE, 
      rv_sum_insured_title        GIIS_DOCUMENT.text%TYPE, 
      rv_item_title               GIIS_DOCUMENT.text%TYPE, 
      rv_peril_title              GIIS_DOCUMENT.text%TYPE,
      rv_print_peril_long_name    GIIS_DOCUMENT.text%TYPE,
      rv_print_deduct_text_amt    GIIS_DOCUMENT.text%TYPE,
      rv_grouped_item_title       GIIS_DOCUMENT.text%TYPE,
      rv_personnel_item_title     GIIS_DOCUMENT.text%TYPE,
      rv_personnel_subtitle1      GIIS_DOCUMENT.text%TYPE,
      rv_personnel_subtitle2      GIIS_DOCUMENT.text%TYPE,
      rv_grouped_subtitle         GIIS_DOCUMENT.text%TYPE,
      rv_attestation_title        GIIS_DOCUMENT.text%TYPE,
      rv_print_currency_desc      GIIS_DOCUMENT.text%TYPE,
      rv_print_peril_name_long    GIIS_DOCUMENT.text%TYPE,
      rv_print_short_name         GIIS_DOCUMENT.text%TYPE,
      rv_print_null_mortgagee     GIIS_DOCUMENT.text%TYPE,

      --------------------------------------------------------------------------------
      rv_print_grouped_beneficiary   GIIS_DOCUMENT.text%TYPE,
      rv_beneficiary_item_title   GIIS_DOCUMENT.text%TYPE,
      rv_beneficiary_subtitle1    GIIS_DOCUMENT.text%TYPE,
      rv_beneficiary_subtitle2    GIIS_DOCUMENT.text%TYPE,
      rv_block_description        GIIS_DOCUMENT.text%TYPE,
      rv_boundary_title           GIIS_DOCUMENT.text%TYPE,
      rv_constr_remarks_title     GIIS_DOCUMENT.text%TYPE,
      rv_construction_title       GIIS_DOCUMENT.text%TYPE,
      rv_occupancy_remarks_title  GIIS_DOCUMENT.text%TYPE,
      rv_occupancy_title          GIIS_DOCUMENT.text%TYPE,
      rv_print_zone               GIIS_DOCUMENT.text%TYPE,
      rv_doc_attestation1         GIIS_DOCUMENT.text%TYPE,
      rv_doc_attestation2         GIIS_DOCUMENT.text%TYPE,
      rv_doc_attestation3         GIIS_DOCUMENT.text%TYPE,
      rv_print_tariff_zone        GIIS_DOCUMENT.text%TYPE,
    ---------------------@FPAC----------------------------
    --------------------ALL LINES-------------------------
      rv_par_endt_header          GIIS_DOCUMENT.text%TYPE, 
      rv_without_item_no          GIIS_DOCUMENT.text%TYPE,  
      rv_print_ded_text_peril     GIIS_DOCUMENT.text%TYPE,
      rv_line_hidden              GIIS_DOCUMENT.text%TYPE,
      rv_desc_label               GIIS_DOCUMENT.text%TYPE,
      rv_display_section          GIIS_DOCUMENT.text%TYPE,      
      rv_print_cents              GIIS_DOCUMENT.text%TYPE, 
      rv_leased_to                GIIS_DOCUMENT.text%TYPE,
      rv_print_gen_info_above     GIIS_DOCUMENT.text%TYPE,  
      rv_display_ann_tsi          GIIS_DOCUMENT.text%TYPE, 
      rv_display_tsi_endt         GIIS_DOCUMENT.text%TYPE, 
      
    ----------------------CASUALTY------------------------
      ca_print_one_item_title     GIIS_DOCUMENT.text%TYPE,
      ca_print_peril              GIIS_DOCUMENT.text%TYPE,   
      ca_print_deduct_text_amt    GIIS_DOCUMENT.text%TYPE,  
      ca_doc_subtitle2            GIIS_DOCUMENT.text%TYPE, 

    ---------------------ENGINEERING---------------------- 
      en_item_title               GIIS_DOCUMENT.text%TYPE,
      en_print_peril              GIIS_DOCUMENT.text%TYPE,  
      en_print_ded_text           GIIS_DOCUMENT.text%TYPE,  
      en_print_tabular            GIIS_DOCUMENT.text%TYPE, 
          
    ----------------------ACCIDENT------------------------
      pa_item_title               GIIS_DOCUMENT.text%TYPE, 
      pa_print_eff_exp_date       GIIS_DOCUMENT.text%TYPE,  
      pa_print_ded_text_peril     GIIS_DOCUMENT.text%TYPE,
      pa_print_peril              GIIS_DOCUMENT.text%TYPE, 

    -----------------------FIRE---------------------------
      fi_display_district         GIIS_DOCUMENT.text%TYPE,  
      fi_display_type             GIIS_DOCUMENT.text%TYPE,
      fi_display_cons             GIIS_DOCUMENT.text%TYPE,
      fi_check_risk               GIIS_DOCUMENT.text%TYPE,      
      fi_print_peril              GIIS_DOCUMENT.text%TYPE,  
      fi_print_desc_below         GIIS_DOCUMENT.text%TYPE, 
      fi_curr_rt                  GIXX_ITEM.currency_rt%TYPE,
           
    ------------------MARINE CARGO------------------------
      mn_print_mop_deductibles    GIIS_DOCUMENT.text%TYPE,
      mn_print_declaration_no     GIIS_DOCUMENT.text%TYPE,
      mn_pack_method              GIIS_DOCUMENT.text%TYPE,
      mn_print_cargo_desc         GIIS_DOCUMENT.text%TYPE,   
      mn_print_origin_dest_above  GIIS_DOCUMENT.text%TYPE,  
      mn_print_premium_rate       GIIS_DOCUMENT.text%TYPE, 
      mn_print_peril              GIIS_DOCUMENT.text%TYPE, 
      vestype_desc                GIIS_VESTYPE.vestype_desc%TYPE,
    --------------------PNBGEN-----------------------------
      rv_print_text_beside_signatory GIIS_DOCUMENT.text%TYPE,
      rv_display_neg_amt          GIIS_DOCUMENT.text%TYPE,
      rv_display_item_title       GIIS_DOCUMENT.text%TYPE,
      show_item_risk_amt          GIIS_DOCUMENT.text%TYPE,
      rv_print_original           GIIS_DOCUMENT.text%TYPE,
      rv_print_deductible_amt     GIIS_DOCUMENT.text%TYPE,
      rv_policy_siglabel          GIIS_DOCUMENT.text%TYPE,
      bank_ref_no_label           GIIS_DOCUMENT.text%TYPE,

    /* end for package specs variables */
    
    /*other variables*/
      show_mortgagee              VARCHAR2(1) := 'N',
      show_doc_total_in_box       VARCHAR2(1) := 'N',
      show_ref_pol_no             VARCHAR2(1) := 'N',
      show_polgenin_gen_info      VARCHAR2(1) := 'N',
      show_polwc_last             VARCHAR2(1) := 'N',
      show_bank_ref_no            VARCHAR2(1) := 'N',  
    /*end of other */
    
    /*ucpb specific enhancement*/
      print_deductible_type       VARCHAR(1),
    /*end of ucpb specific enhancement*/
    
      FI                          GIIS_LINE.line_cd%TYPE,
      EN                          GIIS_LINE.line_cd%TYPE,
      MC                          GIIS_LINE.line_cd%TYPE,
      MN                          GIIS_LINE.line_cd%TYPE,
      CA                          GIIS_LINE.line_cd%TYPE,
      AC                          GIIS_LINE.line_cd%TYPE
  );
  
  TYPE pack_report_tab IS TABLE OF pack_report_type;
  
  TYPE pack_policy_type IS RECORD (
     extract_id                 GIXX_ITEM.extract_id%TYPE,
     policy_id                  GIXX_ITEM.policy_id%TYPE,
     line_cd                    GIXX_ITEM.pack_line_cd%TYPE,
     show_deductible_text       VARCHAR2(1),
     show_warr_clause           VARCHAR2(1),
     show_wc_remarks            VARCHAR2(1),
     subreport_id               VARCHAR2(50)
  );
  
  TYPE pack_policy_tab IS TABLE OF pack_policy_type;
  
  TYPE pack_taxes_type IS RECORD (
     extract_id                   GIXX_PACK_INV_TAX.extract_id%TYPE,
     invtax_tax_amt               NUMBER(16,2), 
     invtax_tax_cd                GIXX_PACK_INV_TAX.tax_cd%TYPE,
     taxcharg_tax_desc            GIAC_TAXES.tax_name%TYPE
  );
  
  TYPE pack_taxes_tab IS TABLE OF pack_taxes_type;
  
  FUNCTION get_pack_report_details( p_extract_id    IN GIXX_PACK_POLBASIC.extract_id%TYPE,
                                    p_report_id     IN GIIS_DOCUMENT.report_id%TYPE,
                                    p_user_id       IN GIIS_USERS.user_id%TYPE)
    RETURN pack_report_tab PIPELINED;
    
  PROCEDURE initialize_package (p_rep_id    IN  GIIS_REPORTS.REPORT_ID%TYPE);
  
  FUNCTION get_pack_policy_taxes(p_extract_id         IN  GIXX_PACK_POLBASIC.extract_id%TYPE,
                                 p_co_insurance_sw    IN  GIXX_PACK_POLBASIC.co_insurance_sw%TYPE,
                                 p_display_neg_amt    IN  GIIS_DOCUMENT.text%TYPE)
                                   
    RETURN pack_taxes_tab PIPELINED;
  
  FUNCTION get_pack_policy(p_extract_id   GIXX_ITEM.extract_id%TYPE) 
    RETURN pack_policy_tab PIPELINED;

  FUNCTION check_deduct_text_display(p_extract_id    GIXX_ITEM.extract_id%TYPE,
                                     p_line_cd       GIXX_ITEM.pack_line_cd%TYPE,
                                     p_policy_id     GIXX_ITEM.policy_id%TYPE)
    RETURN VARCHAR2;

  FUNCTION check_pack_pol_warr_clause (p_extract_id   GIXX_ITEM.extract_id%TYPE,
                                       p_policy_id    GIXX_ITEM.policy_id%TYPE) 
    RETURN VARCHAR2;
  
  FUNCTION check_pack_wc_remarks (p_extract_id   GIXX_ITEM.extract_id%TYPE,
                                    p_policy_id    GIXX_ITEM.policy_id%TYPE) 

    RETURN VARCHAR2;
  
  FUNCTION get_subreport_id(p_line_cd       GIXX_ITEM.pack_line_cd%TYPE)
    RETURN VARCHAR2;
  
END;
/


