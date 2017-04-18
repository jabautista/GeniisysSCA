CREATE OR REPLACE PACKAGE CPI.bonds_endt_pkg
AS
  par_par                    VARCHAR2(20);
  par_policy                 VARCHAR2(25);
  endt_par                   VARCHAR2(30);
  endt_policy                VARCHAR2(35);
  par                        CONSTANT VARCHAR2(20)  := 'PAR No.';
  policy                     giis_document.text%TYPE; 
  par_header                 CONSTANT VARCHAR2(100) := 'SAMPLE POLICY';
  endt_header                CONSTANT VARCHAR2(100) := 'SAMPLE ENDORSEMENT';
  tax_breakdown              giis_document.text%TYPE;
  print_mortgagee            giis_document.text%TYPE;
  print_item_total           giis_document.text%TYPE;
  print_peril                giis_document.text%TYPE;
  print_renewal_top          giis_document.text%TYPE;
  print_doc_subtitle1        giis_document.text%TYPE;
  print_doc_subtitle2        giis_document.text%TYPE;
  print_doc_subtitle3        giis_document.text%TYPE;
  print_doc_subtitle4        giis_document.text%TYPE;
  print_deductibles          giis_document.text%TYPE;
  print_accessories_above    giis_document.text%TYPE;
  print_all_warranties       giis_document.text%TYPE;
  print_wrrnties_fontbig     giis_document.text%TYPE;
  print_last_endtxt          giis_document.text%TYPE;
  print_sub_info             giis_document.text%TYPE;
  doc_tax_breakdown          giis_document.text%TYPE;        
  print_premium_rate         giis_document.text%TYPE;        
  print_mort_amt             giis_document.text%TYPE;
  print_sum_insured          giis_document.text%TYPE;
  print_one_item_title       giis_document.text%TYPE;
  print_report_title         giis_document.text%TYPE;
  print_intm_name            giis_document.text%TYPE;
  doc_total_in_box           giis_document.text%TYPE;
  doc_subtitle1              giis_document.text%TYPE;
  doc_subtitle2              giis_document.text%TYPE;
  doc_subtitle3              giis_document.text%TYPE;
  doc_subtitle4              giis_document.text%TYPE;
  invoice_policy_currency    gixx_invoice.policy_currency%TYPE;
  doc_subtitle4_before_wc    giis_document.text%TYPE;
  print_time                 giis_document.text%TYPE; 
  deductible_title           giis_document.text%TYPE; 
  print_upper_case           giis_document.text%TYPE; 
  sum_insured_title          giis_document.text%TYPE; 
  item_title                 giis_document.text%TYPE; 
  peril_title                giis_document.text%TYPE; 
  doc_attestation1           giis_document.text%TYPE;
  doc_attestation2           giis_document.text%TYPE;
  attestation_title          giis_document.text%TYPE;
  print_ref_pol_no           giis_document.text%TYPE;
  print_currency_desc        giis_document.text%TYPE;
  print_short_name           giis_document.text%TYPE;
  print_null_mortgagee       giis_document.text%TYPE;
  display_policy_term        giis_document.text%TYPE;
  print_lower_dtls           giis_document.text%TYPE;
  print_polno_endt           giis_document.text%TYPE;
  print_cents                giis_document.text%TYPE; 
  display_ann_tsi            giis_document.text%TYPE;
  
 
  TYPE report_type IS RECORD(  
      /*report package values*/  
      
      rt_par_par                    VARCHAR2(20),
      rt_par_policy                 VARCHAR2(25),
      rt_endt_par                   VARCHAR2(30),
      rt_endt_policy                VARCHAR2(35),
      rt_par                        VARCHAR2(20),
      rt_policy                     giis_document.text%TYPE,
      rt_par_header                 VARCHAR2(100),
      rt_endt_header                VARCHAR2(100),
      rt_tax_breakdown              giis_document.text%TYPE,
      rt_print_mortgagee            giis_document.text%TYPE,
      rt_print_item_total           giis_document.text%TYPE,
      rt_print_peril                giis_document.text%TYPE,
      rt_print_renewal_top          giis_document.text%TYPE,
      rt_print_doc_subtitle1        giis_document.text%TYPE,
      rt_print_doc_subtitle2        giis_document.text%TYPE,
      rt_print_doc_subtitle3        giis_document.text%TYPE,
      rt_print_doc_subtitle4        giis_document.text%TYPE,
      rt_print_deductibles          giis_document.text%TYPE,
      rt_print_accessories_above    giis_document.text%TYPE,
      rt_print_all_warranties       giis_document.text%TYPE,
      rt_print_wrrnties_fontbig     giis_document.text%TYPE,
      rt_print_last_endtxt          giis_document.text%TYPE,
      rt_print_sub_info             giis_document.text%TYPE,
      rt_doc_tax_breakdown          giis_document.text%TYPE,        
      rt_print_premium_rate         giis_document.text%TYPE,        
      rt_print_mort_amt             giis_document.text%TYPE,
      rt_print_sum_insured          giis_document.text%TYPE,
      rt_print_one_item_title       giis_document.text%TYPE,
      rt_print_report_title         giis_document.text%TYPE,
      rt_print_intm_name            giis_document.text%TYPE,
      rt_doc_total_in_box           giis_document.text%TYPE, 
      rt_doc_subtitle1              giis_document.text%TYPE, 
      rt_doc_subtitle2              giis_document.text%TYPE,
      rt_doc_subtitle3              giis_document.text%TYPE,
      rt_doc_subtitle4              giis_document.text%TYPE,
      rt_invoice_policy_currency    gixx_invoice.policy_currency%TYPE,
      rt_doc_subtitle4_before_wc    giis_document.text%TYPE,
      rt_print_time                 giis_document.text%TYPE,
      rt_deductible_title           giis_document.text%TYPE,
      rt_print_upper_case           giis_document.text%TYPE,
      rt_sum_insured_title          giis_document.text%TYPE,
      rt_item_title                 giis_document.text%TYPE,
      rt_peril_title                giis_document.text%TYPE,
      rt_doc_attestation1           giis_document.text%TYPE,
      rt_doc_attestation2           giis_document.text%TYPE,
      rt_attestation_title          giis_document.text%TYPE,
      rt_print_ref_pol_no           giis_document.text%TYPE,
      rt_print_currency_desc        giis_document.text%TYPE,
      rt_print_short_name           giis_document.text%TYPE,
      rt_print_null_mortgagee       giis_document.text%TYPE,
      rt_display_policy_term        giis_document.text%TYPE,
      rt_print_lower_dtls           giis_document.text%TYPE,
      rt_print_polno_endt           giis_document.text%TYPE,
      rt_print_cents                giis_document.text%TYPE,
      rt_display_ann_tsi            giis_document.text%TYPE,
      /*main report*/
      --par_seq_no1                   VARCHAR2(20),
	  par_seq_no1                   VARCHAR2(30), -- bonok :: 10.01.2012
      extract_id1                   NUMBER(10),
      par_id                        NUMBER(10),
      policy_number                 VARCHAR2(50),
      par_no                        VARCHAR2(50),
      par_orig                      VARCHAR2(50),
      line_line_name                giis_line.LINE_NAME%TYPE,
      subline_subline_name          giis_subline.subline_name%TYPE,
      subline_subline_cd            giis_subline.subline_cd%TYPE,
      subline_line_cd               giis_subline.line_cd%TYPE,
      basic_incept_date             VARCHAR2(30),
      basic_expiry_date             VARCHAR2(30),
      basic_expiry_tag              gixx_polbasic.expiry_tag%TYPE,
      basic_issue_date              VARCHAR2(30),
      basic_tsi_amt                 gixx_polbasic.tsi_amt%TYPE,
      subline_subline_time          VARCHAR2(30),--giis_subline.subline_time%TYPE,
      basic_acct_of_cd              gixx_polbasic.acct_of_cd%TYPE,
      basic_mortg_name              gixx_polbasic.mortg_name%TYPE,
      address1                      gixx_polbasic.old_address1%TYPE,
      address2                      gixx_polbasic.old_address2%TYPE,
      address3                      gixx_polbasic.old_address3%TYPE,
      basic_addr                    VARCHAR2(150),
      basic_pol_flag                gixx_polbasic.pol_flag%TYPE,
      fleet_print_tag               gixx_polbasic.fleet_print_tag%TYPE,
      basic_line_cd                 gixx_polbasic.line_cd%TYPE,
      basic_ref_pol_no              gixx_polbasic.ref_pol_no%TYPE,
      basic_assd_no                 gixx_polbasic.assd_no%TYPE,
      label_tag                     VARCHAR2(30),
      endt_no                       VARCHAR2(20),
      pol_endt_no                   VARCHAR2(50),
      endt_expiry_date              VARCHAR2(20),
      basic_eff_date                VARCHAR2(20),
      endt_expiry_tag               gixx_polbasic.endt_expiry_tag%TYPE,
      basic_incept_tag              gixx_polbasic.incept_tag%TYPE,
      basic_subline_cd              gixx_polbasic.subline_cd%TYPE,
      basic_iss_cd                  gixx_polbasic.iss_cd%TYPE,
      basic_issue_yy                gixx_polbasic.issue_yy%TYPE,
      basic_pol_seq_no              gixx_polbasic.pol_seq_no%TYPE,
      basic_renew_no                gixx_polbasic.renew_no%TYPE,
      basic_eff_time                VARCHAR2(30),
      basic_endt_expiry_time        VARCHAR2(30),
      par_par_type                  gixx_parlist.par_type%TYPE,
      par_par_status                gixx_parlist.par_status%TYPE,
      basic_co_insurance_sw         gixx_polbasic.co_insurance_sw%TYPE,
      subline_open_policy           giis_subline.op_flag%TYPE,
      basic_tsi_amt_1               gixx_polbasic.tsi_amt%TYPE, -- remove this // du 
      cred_br                       gixx_polbasic.cred_branch%TYPE,
      -- Q_1
      invoice_prem_amt              NUMBER(12,2),
      -- Q_TSI
      tsi_fx_name                   giis_currency.short_name%TYPE,
      tsi_fx_desc                   giis_currency.currency_desc%TYPE,
      tsi_spelled_tsi               VARCHAR2(200),
      -- Q_INVOICE
      premium_amt                   gixx_invoice.prem_amt%TYPE,
      tax_amt                       gixx_invoice.tax_amt%TYPE,
      other_charges                 gixx_invoice.other_charges%TYPE,
      total                         gixx_invoice.other_charges%TYPE,
      policy_currency               gixx_invoice.other_charges%TYPE,
      -- Q_BOND_ITEM
      su_obligee_name               giis_obligee.obligee_name%TYPE, 
      su_bond_detail                gixx_bond_basic.bond_dtl%TYPE,               
      su_indemnity                  gixx_bond_basic.indemnity_text%TYPE,
      su_np_name                    giis_notary_public.np_name%TYPE,
      su_clause_desc                giis_bond_class_clause.clause_desc%TYPE,
      su_coll_flag                  gixx_bond_basic.coll_flag%TYPE,
      su_coll_desc                  VARCHAR(100),
      su_waiver_limit               gixx_bond_basic.waiver_limit%TYPE,
      su_contract_date              gixx_bond_basic.contract_date%TYPE,
      su_contract_dtl               gixx_bond_basic.contract_dtl%TYPE,
      --  Headers -- 
      cf_header_1                   VARCHAR2(50),
      cf_header_2                   VARCHAR2(50),
      cf_header_3                   VARCHAR2(50),
      cf_header_4                   VARCHAR2(50),
      cf_label                      VARCHAR2(50),
      cf_report_title               VARCHAR2(50),
      short_name                    VARCHAR2(20),
      cf_assd_name                  VARCHAR2(500), --change by steven 9.20.2012 from: VARCHAR2(100)	to: VARCHAR2(500)
      cf_tax_amt                    NUMBER(16,2),
      cf_amt_due                    NUMBER(16,2),
      cf_acct_of_cd                 giis_assured.assd_name%TYPE,
      cf_prem_title                 VARCHAR2(50),
      cf_prem_amt                   gixx_orig_invoice.tax_amt%TYPE, -- yet unused
      cf_currency                   giis_currency.currency_desc%TYPE,
      cf_premium_amt                NUMBER(16,2),
      -- for M_08 -- initialize_variables_m_08
      -- for m_20
      cf_user                       VARCHAR2(50),
      cf_intm_no                    VARCHAR2(400),
      cf_intm_name                  VARCHAR2(100),
      cf_ref_inv_no                 gixx_invoice.ref_inv_no%TYPE,
      cf_signatory                  VARCHAR2(50),
      cf_designation                VARCHAR2(50),
      cf_company                    giis_parameters.param_value_v%TYPE,
      cf_renewal            VARCHAR(1000),
      -- FOR q_warranties // init_vars_q_warranties
      endttext01            GIXX_ENDTTEXT.ENDT_TEXT01%TYPE,
      endttext02            GIXX_ENDTTEXT.ENDT_TEXT02%TYPE,
      endttext03            GIXX_ENDTTEXT.ENDT_TEXT03%TYPE,
      endttext04            GIXX_ENDTTEXT.ENDT_TEXT04%TYPE,
      endttext05            GIXX_ENDTTEXT.ENDT_TEXT05%TYPE,
      endttext06            GIXX_ENDTTEXT.ENDT_TEXT06%TYPE,
      endttext07            GIXX_ENDTTEXT.ENDT_TEXT07%TYPE,
      endttext08            GIXX_ENDTTEXT.ENDT_TEXT08%TYPE,
      endttext09            GIXX_ENDTTEXT.ENDT_TEXT09%TYPE,
      endttext10            GIXX_ENDTTEXT.ENDT_TEXT10%TYPE,
      endttext11            GIXX_ENDTTEXT.ENDT_TEXT11%TYPE,
      endttext12            GIXX_ENDTTEXT.ENDT_TEXT12%TYPE,
      endttext13            GIXX_ENDTTEXT.ENDT_TEXT13%TYPE,
      endttext14            GIXX_ENDTTEXT.ENDT_TEXT14%TYPE,
      endttext15            GIXX_ENDTTEXT.ENDT_TEXT15%TYPE,
      endttext16            GIXX_ENDTTEXT.ENDT_TEXT16%TYPE,
      endttext17            GIXX_ENDTTEXT.ENDT_TEXT17%TYPE,
      polwc_change_tag      gixx_polwc.change_tag%TYPE,
      wc_wc_cd              gixx_polwc.wc_cd%TYPE,
      wc_print_sw           gixx_polwc.print_sw%TYPE,
      v_count               NUMBER(2),
      v_mort_count          NUMBER(3)/*,
    /*su_obligee_name       giis_obligee.obligee_name%TYPE,
      su_bond_detail        gixx_bond_basic.bond_dtl%TYPE,
      su_indemnity             gixx_bond_basic.indemnity_text%TYPE,
      su_np_name            giis_notary_public.np_name%TYPE,
      su_clause_desc        giis_bond_class_clause.clause_desc%TYPE,
      su_coll_flag          gixx_bond_basic.coll_flag%TYPE,
      su_waiver_limit       gixx_bond_basic.waiver_limit%TYPE,
      su_contract_date      gixx_bond_basic.contract_date%TYPE,
      su_contract_dtl       gixx_bond_basic.contract_dtl%TYPE*/
  );
  
  TYPE report_tab IS TABLE OF report_type;
  
  FUNCTION  get_report_details(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE,
    p_report_id    GIIS_DOCUMENT.report_id%TYPE)
  RETURN report_tab PIPELINED;  

  PROCEDURE initialize_variables (
     p_report_id IN giis_document.report_id%TYPE
  );  

  FUNCTION policy_currency(
     p_extract_id               gixx_polbasic.extract_id%TYPE, 
     p_basic_co_insurance_sw    gixx_polbasic.co_insurance_sw%TYPE
  ) RETURN VARCHAR2;
  
  TYPE q2_type IS RECORD(
    invtax_tax_cd     gixx_orig_inv_tax.tax_cd%TYPE,
    invtax_tax_amt    gixx_orig_inv_tax.tax_amt%TYPE,
    taxcharg_tax_desc giis_tax_charges.tax_desc%TYPE,
    tax_charge_include_tag giis_tax_charges.include_tag%TYPE
  );
  
  TYPE q2_tab IS TABLE OF q2_type;
  
  FUNCTION get_bonds_endt_q2(
    p_extract_id               gixx_polbasic.extract_id%TYPE
  )RETURN q2_tab PIPELINED;
  
  FUNCTION get_bonds_endt_premium_amt(  
      p_extract_id               gixx_polbasic.extract_id%TYPE,
      p_par_par_type             gixx_parlist.par_type%TYPE,
      p_par_par_status           gixx_parlist.par_status%TYPE,
      p_basic_co_insurance_sw    gixx_polbasic.co_insurance_sw%TYPE,
      p_report                   report_type
  )RETURN NUMBER;
  
  PROCEDURE initialize_variables_m_20(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_report_id             IN  giis_document.report_id%TYPE,
    p_basic_co_insurance_sw IN  gixx_polbasic.co_insurance_sw%TYPE,
    p_subline_subline_cd    IN  giis_subline.subline_cd%TYPE,
    p_subline_line_cd       IN  giis_subline.line_cd%TYPE,
    p_basic_iss_cd          IN  gixx_polbasic.iss_cd%TYPE,
    p_basic_issue_yy        IN  gixx_polbasic.issue_yy%TYPE,
    p_basic_pol_seq_no      IN  gixx_polbasic.pol_seq_no%TYPE,
    p_basic_renew_no        IN  gixx_polbasic.renew_no%TYPE,
    p_par_id                IN  gixx_parlist.par_id%TYPE, -- or number (10)
    p_par_par_status        IN  gixx_parlist.par_status%TYPE,
    p_cf_user               OUT VARCHAR2, --gixx_polbasic.user_id%TYPE, 9 + 40+
    p_cf_intm_no            OUT VARCHAR2, -- 400
    p_cf_intm_name          OUT VARCHAR2, -- 100
    p_cf_ref_inv_no         OUT gixx_invoice.ref_inv_no%TYPE,
    p_cf_signatory          OUT VARCHAR2, -- 50
    p_cf_designation        OUT VARCHAR2, -- 50
    p_cf_company            OUT giis_parameters.param_value_v%TYPE
  );
 
   PROCEDURE initialize_variables_m_17(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_report_id             IN  giis_document.report_id%TYPE,
    p_par_id                IN  gixx_parlist.par_id%TYPE, -- or number (10)
    p_par_par_status        IN  gixx_parlist.par_status%TYPE,
    p_cf_renewal            OUT VARCHAR2
  );
  
  PROCEDURE initialize_variables_m_08(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_print_null_mortgagee  IN  giis_document.text%TYPE,
    --p_mortgagee_name        
    p_cf_mortgagee_title    OUT VARCHAR2
    --p_cf_mortgagee_name     OUT 
  );
  
  PROCEDURE init_vars_q_warranties(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_wc_wc_title           OUT gixx_polwc.wc_title%TYPE,
    p_polwc_wc_text01       OUT VARCHAR2, --2000
    p_polwc_wc_text02       OUT VARCHAR2,     p_polwc_wc_text03       OUT VARCHAR2, 
    p_polwc_wc_text04       OUT VARCHAR2,     p_polwc_wc_text05       OUT VARCHAR2, 
    p_polwc_wc_text06       OUT VARCHAR2,     p_polwc_wc_text07       OUT VARCHAR2, 
    p_polwc_wc_text08       OUT VARCHAR2,     p_polwc_wc_text09       OUT VARCHAR2, 
    p_polwc_wc_text10       OUT VARCHAR2,     p_polwc_wc_text11       OUT VARCHAR2, 
    p_polwc_wc_text12       OUT VARCHAR2,     p_polwc_wc_text13       OUT VARCHAR2, 
    p_polwc_wc_text14       OUT VARCHAR2,     p_polwc_wc_text15       OUT VARCHAR2, 
    p_polwc_wc_text16       OUT VARCHAR2,     p_polwc_wc_text17       OUT VARCHAR2, 
    p_warrc_wc_text01       OUT VARCHAR2, --2000              
    p_warrc_wc_text02       OUT VARCHAR2,    p_warrc_wc_text03       OUT VARCHAR2,
    p_warrc_wc_text04       OUT VARCHAR2,    p_warrc_wc_text05       OUT VARCHAR2,
    p_warrc_wc_text06       OUT VARCHAR2,    p_warrc_wc_text07       OUT VARCHAR2,
    p_warrc_wc_text08       OUT VARCHAR2,    p_warrc_wc_text09       OUT VARCHAR2,
    p_warrc_wc_text10       OUT VARCHAR2,    p_warrc_wc_text11       OUT VARCHAR2,
    p_warrc_wc_text12       OUT VARCHAR2,    p_warrc_wc_text13       OUT VARCHAR2,
    p_warrc_wc_text14       OUT VARCHAR2,    p_warrc_wc_text15       OUT VARCHAR2,
    p_warrc_wc_text16       OUT VARCHAR2,    p_warrc_wc_text17       OUT VARCHAR2,
    p_polwc_change_tag    OUT VARCHAR2, -- 1
    p_wc_wc_cd            OUT VARCHAR2, -- 4 
    p_wc_print_sw         OUT VARCHAR2
  );
      
  TYPE q_mortgagee_type IS RECORD(
    q_mortgagee_iss_cd  gixx_mortgagee.iss_cd%TYPE,
    q_mortgagee_name    giis_mortgagee.mortg_name%TYPE,
    q_mortgagee_item_no gixx_mortgagee.item_no%TYPE,
    q_mortgagee_amount  gixx_mortgagee.amount%TYPE
  );
  
  TYPE q_mortgagee_tab IS TABLE OF q_mortgagee_type;
  
  FUNCTION get_bonds_endt_q_mortgagee(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN q_mortgagee_tab PIPELINED;
  
  TYPE q_coinsurance_type IS RECORD(
    coinsurer_ri_tsi_amt    gixx_co_insurer.co_ri_tsi_amt%TYPE, --VARCHAR2(20),
    reinsurer_ri_name       giis_reinsurer.ri_name%TYPE
  );
  
  TYPE q_coinsurance_tab IS TABLE OF q_coinsurance_type;
  
  FUNCTION get_q_coinsurance(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN q_coinsurance_tab PIPELINED;  
  
  PROCEDURE init_vars_m_15(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_basic_co_insurance_sw IN  gixx_polbasic.co_insurance_sw%TYPE,
    p_print_cents           IN  giis_document.text%TYPE, 
    p_display_ann_tsi       IN  giis_document.text%TYPE,
    p_print_short_name      IN  giis_document.text%TYPE,
    p_short_name            IN  VARCHAR2,        
    p_cf_spell_tsi          OUT VARCHAR2,
    p_cf_basic_tsi_spell    OUT VARCHAR2
  );
  
  /*
  PROCEDURE init_vars_m_11(
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE--,
   -- p_cf_doc_subtitle1      OUT 
  );
  */
  
  PROCEDURE get_endt_text( -- TO BE DELETED
    p_extract_id            IN  gixx_polbasic.extract_id%TYPE,
    p_endttext01            OUT GIXX_ENDTTEXT.ENDT_TEXT01%TYPE,
    p_endttext02            OUT GIXX_ENDTTEXT.ENDT_TEXT02%TYPE,
    p_endttext03            OUT GIXX_ENDTTEXT.ENDT_TEXT03%TYPE,
    p_endttext04            OUT GIXX_ENDTTEXT.ENDT_TEXT04%TYPE,
    p_endttext05            OUT GIXX_ENDTTEXT.ENDT_TEXT05%TYPE,
    p_endttext06            OUT GIXX_ENDTTEXT.ENDT_TEXT06%TYPE,
    p_endttext07            OUT GIXX_ENDTTEXT.ENDT_TEXT07%TYPE,
    p_endttext08            OUT GIXX_ENDTTEXT.ENDT_TEXT08%TYPE,
    p_endttext09            OUT GIXX_ENDTTEXT.ENDT_TEXT09%TYPE,
    p_endttext10            OUT GIXX_ENDTTEXT.ENDT_TEXT10%TYPE,
    p_endttext11            OUT GIXX_ENDTTEXT.ENDT_TEXT11%TYPE,
    p_endttext12            OUT GIXX_ENDTTEXT.ENDT_TEXT12%TYPE,
    p_endttext13            OUT GIXX_ENDTTEXT.ENDT_TEXT13%TYPE,
    p_endttext14            OUT GIXX_ENDTTEXT.ENDT_TEXT14%TYPE,
    p_endttext15            OUT GIXX_ENDTTEXT.ENDT_TEXT15%TYPE,
    p_endttext16            OUT GIXX_ENDTTEXT.ENDT_TEXT16%TYPE,
    p_endttext17            OUT GIXX_ENDTTEXT.ENDT_TEXT17%TYPE
  ); 
  
  TYPE q_warranties_type IS RECORD(
    wc_wc_title            gixx_polwc.wc_title%TYPE, 
    polwc_wc_text01        gixx_polwc.wc_text01%TYPE, 
    polwc_wc_text02        gixx_polwc.wc_text02%TYPE,
    polwc_wc_text03        gixx_polwc.wc_text03%TYPE,
    polwc_wc_text04        gixx_polwc.wc_text04%TYPE,
    polwc_wc_text05        gixx_polwc.wc_text05%TYPE,
    polwc_wc_text06        gixx_polwc.wc_text06%TYPE,
    polwc_wc_text07        gixx_polwc.wc_text07%TYPE,
    polwc_wc_text08        gixx_polwc.wc_text08%TYPE,
    polwc_wc_text09        gixx_polwc.wc_text09%TYPE,
    polwc_wc_text10        gixx_polwc.wc_text10%TYPE,
    polwc_wc_text11        gixx_polwc.wc_text11%TYPE,
    polwc_wc_text12        gixx_polwc.wc_text12%TYPE,
    polwc_wc_text13        gixx_polwc.wc_text13%TYPE,
    polwc_wc_text14        gixx_polwc.wc_text14%TYPE,
    polwc_wc_text15        gixx_polwc.wc_text15%TYPE,
    polwc_wc_text16        gixx_polwc.wc_text16%TYPE,
    polwc_wc_text17        gixx_polwc.wc_text17%TYPE,
    polwc_allnull_flag  VARCHAR2(1),              
    warrc_wc_text01        giis_warrcla.wc_text01%TYPE, 
    warrc_wc_text02        giis_warrcla.wc_text02%TYPE,
    warrc_wc_text03        giis_warrcla.wc_text03%TYPE,
    warrc_wc_text04        giis_warrcla.wc_text04%TYPE,
    warrc_wc_text05        giis_warrcla.wc_text05%TYPE,
    warrc_wc_text06        giis_warrcla.wc_text06%TYPE,
    warrc_wc_text07        giis_warrcla.wc_text07%TYPE,
    warrc_wc_text08        giis_warrcla.wc_text08%TYPE,
    warrc_wc_text09        giis_warrcla.wc_text09%TYPE,
    warrc_wc_text10        giis_warrcla.wc_text10%TYPE,
    warrc_wc_text11        giis_warrcla.wc_text11%TYPE,
    warrc_wc_text12        giis_warrcla.wc_text12%TYPE,
    warrc_wc_text13        giis_warrcla.wc_text13%TYPE,
    warrc_wc_text14        giis_warrcla.wc_text14%TYPE,
    warrc_wc_text15        giis_warrcla.wc_text15%TYPE,
    warrc_wc_text16        giis_warrcla.wc_text16%TYPE,
    warrc_wc_text17        giis_warrcla.wc_text11%TYPE,
    warrc_allnull_flag  VARCHAR(1),
    polwc_change_tag    gixx_polwc.change_tag%TYPE,
    wc_wc_cd            gixx_polwc.wc_cd%TYPE, 
    wc_print_sw            gixx_polwc.print_sw%TYPE
  );
  
  TYPE q_warranties_tab IS TABLE OF q_warranties_type;
  
  FUNCTION get_bondendt_q_warranties(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN q_warranties_tab PIPELINED;
  
  TYPE polgenin_type IS RECORD(
    gen_info01  gixx_polgenin.gen_info01%TYPE,    gen_info02  gixx_polgenin.gen_info02%TYPE,
    gen_info03  gixx_polgenin.gen_info03%TYPE,    gen_info04  gixx_polgenin.gen_info04%TYPE,
    gen_info05  gixx_polgenin.gen_info05%TYPE,    gen_info06  gixx_polgenin.gen_info06%TYPE,
    gen_info07  gixx_polgenin.gen_info07%TYPE,    gen_info08  gixx_polgenin.gen_info08%TYPE,
    gen_info09  gixx_polgenin.gen_info09%TYPE,    gen_info10  gixx_polgenin.gen_info10%TYPE,
    gen_info11  gixx_polgenin.gen_info11%TYPE,    gen_info12  gixx_polgenin.gen_info12%TYPE,
    gen_info13  gixx_polgenin.gen_info13%TYPE,    gen_info14  gixx_polgenin.gen_info14%TYPE,
    gen_info15  gixx_polgenin.gen_info15%TYPE,    gen_info16  gixx_polgenin.gen_info16%TYPE,
    gen_info17  gixx_polgenin.gen_info17%TYPE,
    initial_info01  gixx_polgenin.initial_info01%TYPE,  initial_info02  gixx_polgenin.initial_info02%TYPE,
    initial_info03  gixx_polgenin.initial_info03%TYPE,  initial_info04  gixx_polgenin.initial_info04%TYPE,
    initial_info05  gixx_polgenin.initial_info05%TYPE,  initial_info06  gixx_polgenin.initial_info06%TYPE,
    initial_info07  gixx_polgenin.initial_info07%TYPE,  initial_info08  gixx_polgenin.initial_info08%TYPE,
    initial_info09  gixx_polgenin.initial_info09%TYPE,  initial_info10  gixx_polgenin.initial_info10%TYPE,
    initial_info11  gixx_polgenin.initial_info11%TYPE,  initial_info12  gixx_polgenin.initial_info12%TYPE,
    initial_info13  gixx_polgenin.initial_info13%TYPE,  initial_info14  gixx_polgenin.initial_info14%TYPE,
    initial_info15  gixx_polgenin.initial_info15%TYPE,  initial_info16  gixx_polgenin.initial_info16%TYPE,
    initial_info17  gixx_polgenin.initial_info17%TYPE
  );
  
  TYPE polgenin_tab IS TABLE OF polgenin_type;
  
  FUNCTION get_bondendt_polgenin(
    p_extract_id   GIXX_POLBASIC.extract_id%TYPE
  )RETURN polgenin_tab PIPELINED;
  
  PROCEDURE get_surety_details(
    p_extract_id        IN  gixx_polbasic.extract_id%TYPE,
    p_su_obligee_name   OUT giis_obligee.obligee_name%TYPE,
    p_su_bond_detail    OUT gixx_bond_basic.bond_dtl%TYPE,
    p_su_indemnity         OUT gixx_bond_basic.indemnity_text%TYPE,
    p_su_np_name        OUT giis_notary_public.np_name%TYPE,
    p_su_clause_desc    OUT giis_bond_class_clause.clause_desc%TYPE,
    p_su_coll_flag      OUT gixx_bond_basic.coll_flag%TYPE,
    p_su_coll_desc      OUT VARCHAR2,
    p_su_waiver_limit   OUT gixx_bond_basic.waiver_limit%TYPE,
    p_su_contract_date  OUT gixx_bond_basic.contract_date%TYPE,
    p_su_contract_dtl   OUT gixx_bond_basic.contract_dtl%TYPE
  );
  
END bonds_endt_pkg;
/


