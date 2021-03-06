CREATE OR REPLACE PACKAGE CPI.GIPI_PACK_WPOLBAS_PKG AS

	TYPE gipis031A_pack_wpolbas_type IS RECORD (
		   pack_par_id				 		   GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
		   label_tag						   GIPI_PACK_WPOLBAS.label_tag%TYPE,
		   endt_expiry_tag					   GIPI_PACK_WPOLBAS.endt_expiry_tag%TYPE,
		   line_cd							   GIPI_PACK_WPOLBAS.line_cd%TYPE,
		   subline_cd						   GIPI_PACK_WPOLBAS.subline_cd%TYPE,
		   iss_cd							   GIPI_PACK_WPOLBAS.iss_cd%TYPE,
		   issue_yy							   GIPI_PACK_WPOLBAS.issue_yy%TYPE,
		   pol_seq_no						   GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
		   renew_no							   GIPI_PACK_WPOLBAS.renew_no%TYPE,
		   assd_no							   GIPI_PACK_WPOLBAS.assd_no%TYPE,
		   old_assd_no						   GIPI_PACK_WPOLBAS.old_assd_no%TYPE,
		   acct_of_cd						   GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
		   endt_iss_cd						   GIPI_PACK_WPOLBAS.endt_iss_cd%TYPE,
		   endt_yy							   GIPI_PACK_WPOLBAS.endt_yy%TYPE,
		   endt_seq_no						   GIPI_PACK_WPOLBAS.endt_seq_no%TYPE,
		   incept_date						   GIPI_PACK_WPOLBAS.incept_date%TYPE,
		   incept_tag						   GIPI_PACK_WPOLBAS.incept_tag%TYPE,
		   expiry_date						   GIPI_PACK_WPOLBAS.expiry_date%TYPE,
		   expiry_tag						   GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
		   prem_warr_tag					   GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
		   eff_date							   GIPI_PACK_WPOLBAS.eff_date%TYPE,
		   endt_expiry_date					   GIPI_PACK_WPOLBAS.endt_expiry_date%TYPE,
		   place_cd							   GIPI_PACK_WPOLBAS.place_cd%TYPE,
		   place							   GIIS_ISSOURCE_PLACE.place%TYPE,
		   issue_date						   GIPI_PACK_WPOLBAS.issue_date%TYPE,
		   type_cd							   GIPI_PACK_WPOLBAS.type_cd%TYPE,
		   ref_pol_no						   GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
		   manual_renew_no					   GIPI_PACK_WPOLBAS.manual_renew_no%TYPE,
		   pol_flag							   GIPI_PACK_WPOLBAS.pol_flag%TYPE,
		   acct_of_cd_sw					   GIPI_PACK_WPOLBAS.acct_of_cd_sw%TYPE,
		   region_cd						   GIPI_PACK_WPOLBAS.region_cd%TYPE,
		   nbt_region_desc					   GIIS_REGION.region_desc%TYPE,
		   industry_cd	 					   GIPI_PACK_WPOLBAS.industry_cd%TYPE,
		   nbt_ind_desc						   GIIS_INDUSTRY.industry_nm%TYPE,
		   address1							   GIPI_PACK_WPOLBAS.address1%TYPE,
		   address2							   GIPI_PACK_WPOLBAS.address2%TYPE,
		   address3							   GIPI_PACK_WPOLBAS.address3%TYPE,
		   old_address1						   GIPI_PACK_WPOLBAS.old_address1%TYPE,
		   old_address2						   GIPI_PACK_WPOLBAS.old_address2%TYPE,
		   old_address3						   GIPI_PACK_WPOLBAS.old_address3%TYPE,
		   cred_branch						   GIPI_PACK_WPOLBAS.cred_branch%TYPE,
		   dsp_cred_branch					   GIIS_ISSOURCE.iss_name%TYPE,
		   bank_ref_no						   GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
		   mortg_name						   GIPI_PACK_WPOLBAS.mortg_name%TYPE,
		   booking_year						   GIPI_PACK_WPOLBAS.booking_year%TYPE,
		   booking_mth						   GIPI_PACK_WPOLBAS.booking_mth%TYPE,
		   covernote_printed_sw				   GIPI_PACK_WPOLBAS.covernote_printed_sw%TYPE,
		   quotation_printed_sw				   GIPI_PACK_WPOLBAS.quotation_printed_sw%TYPE,
		   foreign_acc_sw					   GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
		   invoice_sw						   GIPI_PACK_WPOLBAS.invoice_sw%TYPE,
		   auto_renew_flag					   GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
		   prorate_flag						   GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
		   comp_sw							   GIPI_PACK_WPOLBAS.comp_sw%TYPE,
		   short_rt_percent					   GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,
		   prov_prem_tag					   GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,
		   fleet_print_tag					   GIPI_PACK_WPOLBAS.fleet_print_tag%TYPE,
		   with_tariff_sw					   GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
		   prov_prem_pct					   GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
		   ref_open_pol_no					   GIPI_PACK_WPOLBAS.ref_open_pol_no%TYPE,
		   same_polno_sw					   GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
		   ann_tsi_amt						   GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
		   prem_amt							   GIPI_PACK_WPOLBAS.prem_amt%TYPE,
		   tsi_amt							   GIPI_PACK_WPOLBAS.tsi_amt%TYPE,
		   ann_prem_amt						   GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
		   reg_policy_sw					   GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,
		   co_insurance_sw					   GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
		   user_id							   GIPI_PACK_WPOLBAS.user_id%TYPE,
		   pack_pol_flag					   GIPI_PACK_WPOLBAS.pack_pol_flag%TYPE,
		   designation						   GIPI_PACK_WPOLBAS.designation%TYPE,
		   back_stat						   GIPI_PACK_WPOLBAS.back_stat%TYPE,
		   risk_tag							   GIPI_PACK_WPOLBAS.risk_tag%TYPE,
		   bancassurance_sw					   GIPI_PACK_WPOLBAS.bancassurance_sw%TYPE,
		   banc_type_cd						   GIPI_PACK_WPOLBAS.banc_type_cd%TYPE,
		   dsp_banc_type_desc				   GIIS_BANC_TYPE.banc_type_desc%TYPE,
		   area_cd							   GIPI_PACK_WPOLBAS.area_cd%TYPE,
		   dsp_area_desc					   GIIS_BANC_AREA.area_desc%TYPE,
		   branch_cd						   GIPI_PACK_WPOLBAS.branch_cd%TYPE,
		   dsp_branch_desc					   GIIS_BANC_BRANCH.branch_desc%TYPE,
		   dsp_area_cd						   GIIS_BANC_BRANCH.area_cd%TYPE,
		   manager_cd						   GIPI_PACK_WPOLBAS.manager_cd%TYPE,
		   assd_name						   GIIS_ASSURED.assd_name%TYPE
	);
	
	TYPE rc_gipi_pack_wpolbas_cur IS REF CURSOR RETURN gipis031A_pack_wpolbas_type;

    TYPE gipi_pack_wpolbas_type IS RECORD
     (pack_par_id               GIPI_PACK_WPOLBAS.pack_par_id%TYPE,      
     label_tag                  GIPI_PACK_WPOLBAS.label_tag%TYPE,
     assd_no                    GIPI_PACK_WPOLBAS.assd_no%TYPE, 
     assd_name                  GIIS_ASSURED.assd_name%TYPE,
     in_account_of              GIIS_ASSURED.assd_name%TYPE, 
     subline_cd                 GIPI_PACK_WPOLBAS.subline_cd%TYPE,
     surcharge_sw               GIPI_PACK_WPOLBAS.surcharge_sw%TYPE,
     manual_renew_no            VARCHAR(25),
     discount_sw                GIPI_PACK_WPOLBAS.discount_sw%TYPE,
     pol_flag                   GIPI_PACK_WPOLBAS.pol_flag%TYPE, 
     pol_flag_desc              CG_REF_CODES.rv_meaning%TYPE,
     type_cd                    GIPI_PACK_WPOLBAS.type_cd%TYPE,
     type_desc                  GIIS_POLICY_TYPE.type_desc%TYPE,
     address1                   GIPI_PACK_WPOLBAS.address1%TYPE, 
     address2                   GIPI_PACK_WPOLBAS.address2%TYPE,
     address3                   GIPI_PACK_WPOLBAS.address3%TYPE,
     booking_year               GIPI_PACK_WPOLBAS.booking_year%TYPE,
     booking_mth                GIPI_PACK_WPOLBAS.booking_mth%TYPE,
     incept_date                GIPI_PACK_WPOLBAS.incept_date%TYPE,
     expiry_date                GIPI_PACK_WPOLBAS.expiry_date%TYPE,
     issue_date                 GIPI_PACK_WPOLBAS.issue_date%TYPE, 
     place_cd                   GIPI_PACK_WPOLBAS.place_cd%TYPE,     
     incept_tag                 GIPI_PACK_WPOLBAS.incept_tag%TYPE,
     expiry_tag                 GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
     risk_tag                   GIPI_PACK_WPOLBAS.risk_tag%TYPE,
     risk                       CG_REF_CODES.rv_meaning%TYPE,
     ref_pol_no                 GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
     industry_cd                GIPI_PACK_WPOLBAS.industry_cd%TYPE, 
     industry_nm                GIIS_INDUSTRY.industry_nm%TYPE,     
     region_cd                  GIPI_PACK_WPOLBAS.region_cd%TYPE, 
     region_desc                GIIS_REGION.region_desc%TYPE,
     cred_branch                GIPI_PACK_WPOLBAS.cred_branch%TYPE, 
     iss_name                   GIIS_ISSOURCE.iss_name%TYPE,
     iss_cd                     GIPI_PACK_WPOLBAS.iss_cd%TYPE,  
     quotation_printed_sw       GIPI_PACK_WPOLBAS.quotation_printed_sw%TYPE,
     covernote_printed_sw       GIPI_PACK_WPOLBAS.covernote_printed_sw%TYPE,
     pack_pol_flag              GIPI_PACK_WPOLBAS.pack_pol_flag%TYPE,
     auto_renew_flag            GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
     prem_warr_tag			    GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
     foreign_acc_sw             GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
     reg_policy_sw              GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,                                  
     fleet_print_tag            GIPI_PACK_WPOLBAS.fleet_print_tag%TYPE,
     with_tariff_sw             GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
     co_insurance_sw            GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
     prorate_flag               GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
     comp_sw                    GIPI_PACK_WPOLBAS.comp_sw%TYPE,
     short_rt_percent           GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,     
     prov_prem_tag              GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,                                        
     prov_prem_pct              GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
     designation			    GIPI_PACK_WPOLBAS.designation%TYPE,
     acct_of_cd                 GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
     invoice_sw                 GIPI_PACK_WPOLBAS.invoice_sw%TYPE,
     line_cd                    GIPI_PACK_WPOLBAS.line_cd%TYPE,
     same_polno_sw              GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
     endt_expiry_date           GIPI_PACK_WPOLBAS.endt_expiry_date%TYPE,
     eff_date                   GIPI_PACK_WPOLBAS.eff_date%TYPE,
     issue_yy                   GIPI_PACK_WPOLBAS.issue_yy%TYPE,
     mortg_name                 GIPI_PACK_WPOLBAS.mortg_name%TYPE,
     validate_tag               GIPI_PACK_WPOLBAS.validate_tag%TYPE,
     pol_seq_no                 GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
     endt_expiry_tag            GIPI_PACK_WPOLBAS.endt_expiry_tag%TYPE,
     endt_iss_cd                GIPI_PACK_WPOLBAS.endt_iss_cd%TYPE,
     acct_of_cd_sw              GIPI_PACK_WPOLBAS.acct_of_cd_sw%TYPE,
     old_assd_no                GIPI_PACK_WPOLBAS.old_assd_no%TYPE,
     old_address1               GIPI_PACK_WPOLBAS.old_address1%TYPE,
     old_address2               GIPI_PACK_WPOLBAS.old_address2%TYPE,
     old_address3               GIPI_PACK_WPOLBAS.old_address3%TYPE,
     ann_tsi_amt                GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
     prem_amt                   GIPI_PACK_WPOLBAS.prem_amt%TYPE,
     tsi_amt                    GIPI_PACK_WPOLBAS.tsi_amt%TYPE,
     ann_prem_amt               GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
     msg_alert                  VARCHAR2(32767),
     renew_no                   GIPI_PACK_WPOLBAS.renew_no%TYPE,
     ref_open_pol_no            GIPI_PACK_WPOLBAS.ref_open_pol_no%TYPE,
     endt_yy                    GIPI_PACK_WPOLBAS.endt_yy%TYPE,
     endt_seq_no                GIPI_PACK_WPOLBAS.endt_seq_no%TYPE,
     back_stat                  GIPI_PACK_WPOLBAS.back_stat%TYPE,
     plan_sw				    GIPI_PACK_WPOLBAS.plan_sw%TYPE,
	 plan_cd				    GIPI_PACK_WPOLBAS.Plan_cd%TYPE,
	 plan_ch_tag			    GIPI_PACK_WPOLBAS.plan_ch_tag%TYPE,
     company_cd                 GIPI_PACK_WPOLBAS.company_cd%TYPE,
     employee_cd                GIPI_PACK_WPOLBAS.employee_cd%TYPE,
     bank_ref_no                GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
     banc_type_cd               GIPI_PACK_WPOLBAS.banc_type_cd%TYPE,
     bancassurance_sw           GIPI_PACK_WPOLBAS.bancassurance_sw%TYPE,
     area_cd                    GIPI_PACK_WPOLBAS.area_cd%TYPE,
     branch_cd                  GIPI_PACK_WPOLBAS.branch_cd%TYPE,
     manager_cd                 GIPI_PACK_WPOLBAS.manager_cd%TYPE
	 );
     
     TYPE gipi_pack_wpolbas_tab IS TABLE OF gipi_pack_wpolbas_type;

  PROCEDURE update_pack_polbas(p_pack_par_id		GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
  							   p_tsi_amt			GIPI_PACK_WPOLBAS.tsi_amt%TYPE,
							   p_prem_amt			GIPI_PACK_WPOLBAS.prem_amt%TYPE,
							   p_ann_tsi_amt		GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
							   p_ann_prem_amt		GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE);

  PROCEDURE create_gipi_pack_wpolbas (p_quote_id IN	GIPI_QUOTE.QUOTE_ID%TYPE,
  									  p_line_cd	 IN	GIPI_QUOTE.LINE_CD%TYPE,
									  p_iss_cd	 IN	GIPI_QUOTE.ISS_CD%TYPE,
									  p_assd_no	 IN	GIPI_QUOTE.ASSD_NO%TYPE,
									  p_par_id	 IN	GIPI_PARLIST.PAR_ID%TYPE,
									  p_message  OUT VARCHAR2,
									  p_user_id  IN  VARCHAR2);
                                      
  FUNCTION get_gipi_pack_wpolbas_details(p_pack_par_id   GIPI_PACK_WPOLBAS.pack_par_id%TYPE) 
    RETURN gipi_pack_wpolbas_tab PIPELINED;
	
  PROCEDURE set_gipi_pack_wpolbas (
  		   p_par_id				 		   	   GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
		   p_endt_expiry_tag				   GIPI_PACK_WPOLBAS.endt_expiry_tag%TYPE,
		   p_line_cd						   GIPI_PACK_WPOLBAS.line_cd%TYPE,
		   p_subline_cd						   GIPI_PACK_WPOLBAS.subline_cd%TYPE,
		   p_iss_cd							   GIPI_PACK_WPOLBAS.iss_cd%TYPE,
		   p_issue_yy						   GIPI_PACK_WPOLBAS.issue_yy%TYPE,
		   p_pol_seq_no						   GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
		   p_renew_no						   GIPI_PACK_WPOLBAS.renew_no%TYPE,
		   p_assd_no						   GIPI_PACK_WPOLBAS.assd_no%TYPE,
		   p_old_assd_no					   GIPI_PACK_WPOLBAS.old_assd_no%TYPE,
		   p_acct_of_cd						   GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
		   p_endt_iss_cd					   GIPI_PACK_WPOLBAS.endt_iss_cd%TYPE,
		   p_endt_yy						   GIPI_PACK_WPOLBAS.endt_yy%TYPE,
		   p_endt_seq_no					   GIPI_PACK_WPOLBAS.endt_seq_no%TYPE,
		   p_incept_date					   GIPI_PACK_WPOLBAS.incept_date%TYPE,
		   p_incept_tag						   GIPI_PACK_WPOLBAS.incept_tag%TYPE,
		   p_expiry_date					   GIPI_PACK_WPOLBAS.expiry_date%TYPE,
		   p_expiry_tag						   GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
		   p_prem_warr_tag					   GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
		   p_eff_date						   GIPI_PACK_WPOLBAS.eff_date%TYPE,
		   p_endt_expiry_date				   GIPI_PACK_WPOLBAS.endt_expiry_date%TYPE,
		   p_place_cd						   GIPI_PACK_WPOLBAS.place_cd%TYPE,
		   p_issue_date						   GIPI_PACK_WPOLBAS.issue_date%TYPE,
		   p_type_cd						   GIPI_PACK_WPOLBAS.type_cd%TYPE,
		   p_ref_pol_no						   GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
		   p_manual_renew_no				   GIPI_PACK_WPOLBAS.manual_renew_no%TYPE,
		   p_pol_flag						   GIPI_PACK_WPOLBAS.pol_flag%TYPE,
		   p_acct_of_cd_sw					   GIPI_PACK_WPOLBAS.acct_of_cd_sw%TYPE,
		   p_region_cd						   GIPI_PACK_WPOLBAS.region_cd%TYPE,
		   p_industry_cd	 				   GIPI_PACK_WPOLBAS.industry_cd%TYPE,
		   p_address1						   GIPI_PACK_WPOLBAS.address1%TYPE,
		   p_address2						   GIPI_PACK_WPOLBAS.address2%TYPE,
		   p_address3						   GIPI_PACK_WPOLBAS.address3%TYPE,
		   p_old_address1					   GIPI_PACK_WPOLBAS.old_address1%TYPE,
		   p_old_address2					   GIPI_PACK_WPOLBAS.old_address2%TYPE,
		   p_old_address3					   GIPI_PACK_WPOLBAS.old_address3%TYPE,
		   p_cred_branch					   GIPI_PACK_WPOLBAS.cred_branch%TYPE,
		   --p_bank_ref_no					   GIPI_PACK_WPOLBAS.bank_ref_no%TYPE, -- temporarily removed, add later
		   p_booking_year					   GIPI_PACK_WPOLBAS.booking_year%TYPE,
		   p_booking_mth					   GIPI_PACK_WPOLBAS.booking_mth%TYPE,
		   p_covernote_printed_sw			   GIPI_PACK_WPOLBAS.covernote_printed_sw%TYPE,
		   p_quotation_printed_sw			   GIPI_PACK_WPOLBAS.quotation_printed_sw%TYPE,
		   p_foreign_acc_sw					   GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
		   p_invoice_sw						   GIPI_PACK_WPOLBAS.invoice_sw%TYPE,
		   p_auto_renew_flag				   GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
		   p_prorate_flag					   GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
		   p_comp_sw						   GIPI_PACK_WPOLBAS.comp_sw%TYPE,
		   p_short_rt_percent				   GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,
		   p_prov_prem_tag					   GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,
		   p_fleet_print_tag				   GIPI_PACK_WPOLBAS.fleet_print_tag%TYPE,
		   p_with_tariff_sw					   GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
		   p_prov_prem_pct					   GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
		   p_same_polno_sw					   GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
		   p_ann_tsi_amt					   GIPI_PACK_WPOLBAS.ann_tsi_amt%TYPE,
		   p_prem_amt						   GIPI_PACK_WPOLBAS.prem_amt%TYPE,
		   p_tsi_amt						   GIPI_PACK_WPOLBAS.tsi_amt%TYPE,
		   p_ann_prem_amt					   GIPI_PACK_WPOLBAS.ann_prem_amt%TYPE,
		   p_reg_policy_sw					   GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,
		   p_co_insurance_sw				   GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
		   p_user_id						   GIPI_PACK_WPOLBAS.user_id%TYPE,
		   p_pack_pol_flag					   GIPI_PACK_WPOLBAS.pack_pol_flag%TYPE,
		   p_designation					   GIPI_PACK_WPOLBAS.designation%TYPE,
		   p_risk_tag						   GIPI_PACK_WPOLBAS.risk_tag%TYPE,
         p_label_tag                   GIPI_PACK_WPOLBAS.label_tag%TYPE -- bonok :: 05.19.2014
		   );

  Procedure get_gipi_pack_wpolbas_par_no (
        p_par_id        IN  GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
        p_line_cd       OUT GIPI_PACK_WPOLBAS.line_cd%TYPE,
        p_subline_cd    OUT GIPI_PACK_WPOLBAS.subline_cd%TYPE,
        p_iss_cd        OUT GIPI_PACK_WPOLBAS.iss_cd%TYPE,
        p_issue_yy      OUT GIPI_PACK_WPOLBAS.issue_yy%TYPE,
        p_pol_seq_no    OUT GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
        p_renew_no      OUT GIPI_PACK_WPOLBAS.renew_no%TYPE);

  PROCEDURE gipis031a_new_form_instance (p_par_id						IN     GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
			  							   p_b240_line_cd				IN	   GIPI_PACK_PARLIST.line_cd%TYPE,
			  							   p_b540_subline_cd			IN	   GIPI_PACK_WPOLBAS.subline_cd%TYPE,
										   p_b540_iss_cd				IN	   GIPI_PACK_WPOLBAS.iss_cd%TYPE,
										   p_b540_issue_yy				IN	   GIPI_PACK_WPOLBAS.issue_yy%TYPE,
										   p_b540_pol_seq_no			IN	   GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
										   p_b540_renew_no				IN	   GIPI_PACK_WPOLBAS.renew_no%TYPE,
			  							   p_var_lc_mc					   OUT GIIS_PARAMETERS.param_value_v%TYPE,
										   p_var_lc_ac					   OUT GIIS_PARAMETERS.param_value_v%TYPE,
										   p_var_lc_en					   OUT GIIS_PARAMETERS.param_value_v%TYPE,
										   p_var_subline_mop			   OUT GIIS_PARAMETERS.param_value_v%TYPE,
										   p_var_v_advance_booking		   OUT VARCHAR2,
										   p_param_var_vdate			   OUT GIAC_PARAMETERS.param_value_n%TYPE,
										   p_req_ref_pol_no				   OUT VARCHAR2,
										   p_banca_dtl_btn_visible		   OUT VARCHAR2,										   
										   p_g_cancellation_type		   OUT VARCHAR2,										   
										   p_g_cancel_tag				   OUT VARCHAR2,										   
										   p_c_mop_subline				   OUT VARCHAR2,										   
										   p_show_marine_detail_button	   OUT VARCHAR2,										   
										   p_region_cd					   OUT VARCHAR2,										   
										   p_existing_claim				   OUT VARCHAR2,
										   p_paid_amt					   OUT NUMBER,										   
										   p_req_survey_sett_agent		   OUT VARCHAR2,
										   p_check_line_subline			   OUT NUMBER,
										   p_check_existing_claims		   OUT VARCHAR2,								   
										   p_message					   OUT VARCHAR2);
              									   
  PROCEDURE get_acct_of_cd(p_line_cd    				IN     VARCHAR2,
	                         p_subline_cd 				IN	   VARCHAR2, 
	                         p_iss_cd     				IN	   VARCHAR2, 
	                         p_issue_yy   				IN	   NUMBER,
	                         p_pol_seq_no 				IN	   NUMBER,
	                         p_renew_no   				IN	   NUMBER,
							 p_b540_eff_date			IN	   GIPI_PACK_WPOLBAS.eff_date%TYPE,
							 p_b540_acct_of_cd			IN OUT GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
							 p_b540_label_tag			IN OUT GIPI_PACK_WPOLBAS.label_tag%TYPE,
							 p_param_modal_flag			IN OUT VARCHAR2);
                             
  PROCEDURE get_gipi_pack_wpolbas_exist (p_pack_par_id  IN      GIPI_PACK_WPOLBAS.pack_par_id%TYPE,
  						        	     p_exist        OUT     NUMBER);
  
  FUNCTION get_gipi_pack_wpolbas_def_val (p_pack_par_id     GIPI_PACK_WPOLBAS.pack_par_id%TYPE)
    RETURN gipi_pack_wpolbas_tab PIPELINED;
    
  PROCEDURE set_gipi_pack_wpolbas2 ( 
     p_pack_par_id              IN  GIPI_PACK_WPOLBAS.pack_par_id%TYPE,           
     p_label_tag                IN  GIPI_PACK_WPOLBAS.label_tag%TYPE,
     p_assd_no                  IN  GIPI_PACK_WPOLBAS.assd_no%TYPE,
     p_subline_cd               IN  GIPI_PACK_WPOLBAS.subline_cd%TYPE,
     p_surcharge_sw             IN  GIPI_PACK_WPOLBAS.surcharge_sw%TYPE,
     p_manual_renew_no          IN  GIPI_PACK_WPOLBAS.manual_renew_no%TYPE,
     p_discount_sw              IN  GIPI_PACK_WPOLBAS.discount_sw%TYPE,
     p_pol_flag                 IN  GIPI_PACK_WPOLBAS.pol_flag%TYPE,
     p_type_cd                  IN  GIPI_PACK_WPOLBAS.type_cd%TYPE,
     p_address1                 IN  GIPI_PACK_WPOLBAS.address1%TYPE,
     p_address2                 IN  GIPI_PACK_WPOLBAS.address2%TYPE,
     p_address3                 IN  GIPI_PACK_WPOLBAS.address3%TYPE,
     p_booking_year             IN  GIPI_PACK_WPOLBAS.booking_year%TYPE,
     p_booking_mth              IN  GIPI_PACK_WPOLBAS.booking_mth%TYPE,
     p_incept_date              IN  GIPI_PACK_WPOLBAS.incept_date%TYPE,
     p_expiry_date              IN  GIPI_PACK_WPOLBAS.expiry_date%TYPE,
     p_issue_date               IN  GIPI_PACK_WPOLBAS.issue_date%TYPE,
     p_place_cd                 IN  GIPI_PACK_WPOLBAS.place_cd%TYPE,     
     p_incept_tag               IN  GIPI_PACK_WPOLBAS.incept_tag%TYPE,
     p_expiry_tag               IN  GIPI_PACK_WPOLBAS.expiry_tag%TYPE,
     p_risk_tag                 IN  GIPI_PACK_WPOLBAS.risk_tag%TYPE,
     p_ref_pol_no               IN  GIPI_PACK_WPOLBAS.ref_pol_no%TYPE,
     p_industry_cd              IN  GIPI_PACK_WPOLBAS.industry_cd%TYPE,
     p_region_cd                IN  GIPI_PACK_WPOLBAS.region_cd%TYPE,
     p_cred_branch              IN  GIPI_PACK_WPOLBAS.cred_branch%TYPE,
     p_quotation_printed_sw     IN  GIPI_PACK_WPOLBAS.quotation_printed_sw%TYPE,
     p_covernote_printed_sw     IN  GIPI_PACK_WPOLBAS.covernote_printed_sw%TYPE,
     p_pack_pol_flag            IN  GIPI_PACK_WPOLBAS.pack_pol_flag%TYPE,
     p_auto_renew_flag          IN  GIPI_PACK_WPOLBAS.auto_renew_flag%TYPE,
     p_foreign_acc_sw           IN  GIPI_PACK_WPOLBAS.foreign_acc_sw%TYPE,
     p_reg_policy_sw            IN  GIPI_PACK_WPOLBAS.reg_policy_sw%TYPE,                                  
     p_prem_warr_tag            IN  GIPI_PACK_WPOLBAS.prem_warr_tag%TYPE,
     p_fleet_print_tag          IN  GIPI_PACK_WPOLBAS.fleet_print_tag%TYPE,
     p_with_tariff_sw           IN  GIPI_PACK_WPOLBAS.with_tariff_sw%TYPE,
     p_co_insurance_sw          IN  GIPI_PACK_WPOLBAS.co_insurance_sw%TYPE,
     p_prorate_flag             IN  GIPI_PACK_WPOLBAS.prorate_flag%TYPE,
     p_comp_sw                  IN  GIPI_PACK_WPOLBAS.comp_sw%TYPE,
     p_short_rt_percent         IN  GIPI_PACK_WPOLBAS.short_rt_percent%TYPE,     
     p_prov_prem_tag            IN  GIPI_PACK_WPOLBAS.prov_prem_tag%TYPE,                                        
     p_prov_prem_pct            IN  GIPI_PACK_WPOLBAS.prov_prem_pct%TYPE,
     p_user_id                  IN  GIPI_PACK_WPOLBAS.user_id%TYPE,
     p_line_cd                  IN  GIPI_PACK_WPOLBAS.line_cd%TYPE,
     p_designation              IN  GIPI_PACK_WPOLBAS.designation%TYPE,
     p_acct_of_cd               IN  GIPI_PACK_WPOLBAS.acct_of_cd%TYPE,
     p_iss_cd                   IN  GIPI_PACK_WPOLBAS.iss_cd%TYPE,
     p_invoice_sw               IN  GIPI_PACK_WPOLBAS.invoice_sw%TYPE,
     p_renew_no                 IN  GIPI_PACK_WPOLBAS.renew_no%TYPE,
     p_issue_yy                 IN  GIPI_PACK_WPOLBAS.issue_yy%TYPE,
     p_ref_open_pol_no          IN  GIPI_PACK_WPOLBAS.ref_open_pol_no%TYPE,
     p_same_polno_sw            IN  GIPI_PACK_WPOLBAS.same_polno_sw%TYPE,
     p_endt_yy                  IN  GIPI_PACK_WPOLBAS.endt_yy%TYPE,
     p_endt_seq_no              IN  GIPI_PACK_WPOLBAS.endt_seq_no%TYPE,
     p_mortg_name               IN  GIPI_PACK_WPOLBAS.mortg_name%TYPE,
     p_validate_tag             IN  GIPI_PACK_WPOLBAS.validate_tag%TYPE,
     p_endt_expiry_date         IN  GIPI_PACK_WPOLBAS.endt_expiry_date%TYPE,
     p_company_cd               IN  GIPI_PACK_WPOLBAS.company_cd%TYPE,
     p_employee_cd              IN  GIPI_PACK_WPOLBAS.employee_cd%TYPE,
     p_bank_ref_no              IN  GIPI_PACK_WPOLBAS.bank_ref_no%TYPE,
     p_banc_type_cd             IN  GIPI_PACK_WPOLBAS.banc_type_cd%TYPE,
     p_bancassurance_sw         IN  GIPI_PACK_WPOLBAS.bancassurance_sw%TYPE,
     p_area_cd                  IN  GIPI_PACK_WPOLBAS.area_cd%TYPE,
     p_branch_cd                IN  GIPI_PACK_WPOLBAS.branch_cd%TYPE,
     p_manager_cd               IN  GIPI_PACK_WPOLBAS.manager_cd%TYPE,
     p_plan_cd                  IN  GIPI_PACK_WPOLBAS.plan_cd%TYPE,
     p_plan_sw                  IN  GIPI_PACK_WPOLBAS.plan_sw%TYPE,
     v_update_issue_date        IN  VARCHAR2
     );
	 
  FUNCTION CHECK_POL_FOR_ENDT_TO_CANCEL (
	p_line_cd			IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
	p_subline_cd		IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
	p_iss_cd			IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
	p_issue_yy			IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no		IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no			IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
  RETURN VARCHAR2;
  
  FUNCTION check_gipi_witmperl_exists (p_par_id			IN GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2;
	
  FUNCTION check_gipi_witem_exists (p_par_id			IN GIPI_PACK_PARLIST.pack_par_id%TYPE)
    RETURN VARCHAR2;
	
  FUNCTION GET_RECORDS_FOR_PACK_ENDT (
	p_line_cd		IN GIPI_PACK_WPOLBAS.line_cd%TYPE,
	p_subline_cd	IN GIPI_PACK_WPOLBAS.subline_cd%TYPE,
	p_iss_cd		IN GIPI_PACK_WPOLBAS.iss_cd%TYPE,
	p_issue_yy		IN GIPI_PACK_WPOLBAS.issue_yy%TYPE,
	p_pol_seq_no	IN GIPI_PACK_WPOLBAS.pol_seq_no%TYPE,
	p_renew_no		IN GIPI_PACK_WPOLBAS.renew_no%TYPE)
RETURN Gipis031_Ref_Cursor_Pkg.cancel_record_tab PIPELINED;

  PROCEDURE generate_bank_ref_no_for_pack(
    p_pack_par_id        IN   gipi_pack_wpolbas.pack_par_id%TYPE,
	p_acct_iss_cd        IN   giis_ref_seq.acct_iss_cd%TYPE,
	p_branch_cd          IN   giis_ref_seq.branch_cd%TYPE,
	p_bank_ref_no       OUT   gipi_pack_wpolbas.bank_ref_no%TYPE,
	p_msg_alert         OUT   VARCHAR2);
    
    PROCEDURE COPY_PACK_POL_WPOLBAS(
        p_pack_par_id           IN gipi_parlist.pack_par_id%TYPE,
        p_line_cd               IN gipi_parlist.line_cd%TYPE,
        p_iss_cd                IN gipi_parlist.iss_cd%TYPE,
        p_par_type              IN gipi_parlist.par_type%TYPE,
        p_pack_policy_id       OUT VARCHAR2,
        p_msg_alert            OUT VARCHAR2,
        p_change_stat           IN VARCHAR2
        );    
    
    PROCEDURE del_gipi_pack_wpolbas(p_pack_par_id         gipi_pack_wpolbas.pack_par_id%TYPE);
    
END GIPI_PACK_WPOLBAS_PKG;
/


