CREATE OR REPLACE PACKAGE CPI.MN_POLICY_DOC_PKG AS

  /* report variables */
	par_par					varchar2(40)  ;--:= 'POLICY CERTIFICATE';
  par_policy				varchar2(40)  ;--:= 'POLICY SCHEDULE';
  endt_par					varchar2(40)  ;--:= 'ENDORSEMENT CERTIFICATE';
  endt_policy				varchar2(40)  ;
  par						constant varchar2(20)  := 'PAR No.     :';
  policy					constant varchar2(20)  := 'Policy No.  :';
  par_header				constant varchar2(100) := 'SAMPLE POLICY';
  endt_header				constant varchar2(100) := 'SAMPLE ENDORSEMENT';
  tax_breakdown     		giis_document.text%type;
  display_policy_term       giis_document.text%type; 
  print_mortgagee			giis_document.text%type;
  print_item_total  		giis_document.text%type;
  print_peril       		giis_document.text%type;
  print_renewal_top 		giis_document.text%type;
  print_doc_subtitle1       giis_document.text%type;
  print_doc_subtitle2       giis_document.text%type;
  print_doc_subtitle3       giis_document.text%type;
  print_doc_subtitle4       giis_document.text%type;
  print_deductibles  		giis_document.text%type;
  print_accessories_above   giis_document.text%type;
  print_all_warranties		giis_document.text%type;
  print_wrrnties_fontbig    giis_document.text%type;
  print_last_endtxt         giis_document.text%type;
  print_sub_info            giis_document.text%type;
  doc_tax_breakdown			giis_document.text%type;		
  PRINT_PREMIUM_RATE        giis_document.text%type;		
  PRINT_MORT_AMT            giis_document.text%type;
  PRINT_SUM_INSURED         giis_document.text%type;
  PRINT_ONE_ITEM_TITLE		giis_document.text%type;
  PRINT_REPORT_TITLE		giis_document.text%type;
  PRINT_INTM_NAME			giis_document.text%type;
  DOC_TOTAL_IN_BOX          giis_document.text%type; 
  DOC_SUBTITLE1             giis_document.text%type; 
  DOC_SUBTITLE2             giis_document.text%type; 
  DOC_SUBTITLE3             giis_document.text%type; 
  DOC_SUBTITLE4             giis_document.text%type; 
  INVOICE_POLICY_CURRENCY   gixx_invoice.policy_currency%type;
  DOC_SUBTITLE4_BEFORE_WC   giis_document.text%type;
  PRINT_TIME                giis_document.text%type; 
  deductible_title			giis_document.text%type; 
  print_upper_case			giis_document.text%type; 
  sum_insured_title			giis_document.text%type; 
  item_title				giis_document.text%type; 
  peril_title				giis_document.text%type;
  PRINT_GROUPED_BENEFICIARY giis_document.text%type;
  --PRINT_ALL_WARRANTIES  	giis_document.text%type;
  PRINT_DEDUCT_TEXT_AMT     giis_document.text%type;
  grouped_item_title		giis_document.text%type;
  personnel_item_title		giis_document.text%type;
  personnel_subtitle1		giis_document.text%type;
  personnel_subtitle2		giis_document.text%type;
  grouped_subtitle			giis_document.text%type;
  vestype_desc				giis_vestype.vestype_desc%type;
  ATTESTATION_TITLE			giis_document.text%type;  
  DOC_ATTESTATION1          giis_document.text%type;
  DOC_ATTESTATION2          giis_document.text%type;
  print_cargo_desc			giis_document.text%type;
  PRINT_REF_POL_NO			giis_document.text%type;
  PRINT_CURRENCY_DESC		giis_document.text%type;
  PRINT_SHORT_NAME   		giis_document.text%type;
  PRINT_NULL_MORTGAGEE		giis_document.text%type;
  LEASED_TO                   giis_document.text%type; -- created by Rosch, 05222006
  PRINT_CENTS                 giis_document.text%type; -- created by Rosch, 05222006
  PRINT_DED_TEXT_PERIL        giis_document.text%type; -- created by Rosch, 05222006
  HIDE_LINE                   giis_document.text%type; -- ging 071806
  PRINT_MOP_WORDINGS          giis_document.text%type; -- ging 073106
  PRINT_MOP_DEDUCTIBLES       giis_document.text%type; -- ging 073106
  MOP_WORDINGS                giis_document.text%type; -- ging 073106
  MRN_WORDINGS                giis_document.text%type; -- ging 073106
  MAR_WORDINGS                giis_document.text%type; -- ging 073106
  PRINT_SURVEY_SETTLING_AGENT giis_document.text%type; -- ging 080106
  SURVEY_WORDINGS		      giis_document.text%type; -- ging 080106
  PRINT_COVERAGE_RATE         giis_document.text%type; -- ging 080206
  WITHOUT_ITEM_NO             giis_document.text%type; -- ging 080206
  PRINT_ORIGIN_DEST_ABOVE	  giis_document.text%type; -- ging 080206
  PRINT_MOP_NO_ABOVE		  giis_document.text%type; -- ging 080206
  PAR_ENDT_HEADER             giis_document.text%type; -- ging 080306
  PRINT_GEN_INFO_ABOVE        giis_document.text%type; -- ging 080306
  ALL_SUBLINE_WORDINGS1       giis_document.text%type; -- ging 080806
  ALL_SUBLINE_WORDINGS2       giis_document.text%type; -- ging 080806
  MARINE_CO_INSURANCE         giis_document.text%type; -- ging 081106
  PACK_METHOD                 giis_document.text%type; -- ging 081106
  PRINT_DECLARATION_NO		  giis_document.text%type; -- ging 081406
  DISPLAY_ANN_TSI             giis_document.text%type; -- ging 081406
  MOP_MAP_WORDINGS            giis_document.text%type; -- ging 082906
  SURVEY_TITLE                giis_document.text%type; -- ging 110706
  PRINT_OPEN_RISK             giis_document.text%type; -- ging 111706  
  POLICY_TITLE_RISK           giis_document.text%type; -- ging 111706  
  POLICY_TITLE_OPEN           giis_document.text%type; -- ging 111706  
  PRINT_ZERO_PREMIUM          giis_document.text%type; -- abe 04.28.2007
  DISPLAY_REF_POL_NO		  giis_document.text%type; -- vj 072507
  PRINT_LOWER_DTLS			  giis_document.text%type;	-- allan 031308
  PRINT_POLNO_ENDT			  giis_document.text%type;
  TSI_LABEL1				  giis_document.text%type;
  TSI_LABEL2				  giis_document.text%type;
  INCLUDE_TSI				  giis_document.text%type;
  SUM_INSURED_TITLE2		  giis_document.text%type;
  POLICY_SIGLABEL		      giis_document.text%type;  --added by vercel 07.15.2008
  PRINT_AUTHORIZED_SIGNATORY  giis_document.text%type;  --added by vercel 07.15.2008
  PRINT_DEDUCTIBLE_RT		  giis_document.text%type;  --added by APRIL 07.15.2008
  print_deductible_amt        giis_document.text%TYPE;-- added by petermkaw 11202009 
	/*end for report variables */

  TYPE mn_policy_doc_type IS RECORD(
    par_seq_no1      	  VARCHAR2(50),
    extract_id1           GIXX_POLBASIC.extract_id%TYPE,
    par_id       		  GIXX_POLBASIC.policy_id%TYPE,
    policy_number         VARCHAR2(50),
    iss_cd        		  GIXX_POLBASIC.iss_cd%TYPE,
    line_cd         	  GIXX_POLBASIC.line_cd%TYPE,
    par_no   			  VARCHAR2(50),
	par_orig   			  VARCHAR2(50),
	line_line_name		  GIIS_LINE.line_name%TYPE,
	subline_subline_name  GIIS_SUBLINE.subline_name%TYPE,
	subline_subline_cd	  GIIS_SUBLINE.subline_cd%TYPE,
	subline_line_cd	  	  GIIS_SUBLINE.line_cd%TYPE,
	basic_incept_date	  VARCHAR2(50),
	basic_incept_time	  VARCHAR2(50),
	basic_expiry_date	  VARCHAR2(50),
	basic_expiry_time	  VARCHAR2(50),
	basic_expiry_tag	  GIXX_POLBASIC.expiry_tag%TYPE,
	basic_issue_date	  VARCHAR2(50),
	basic_tsi_amt		  GIXX_POLBASIC.tsi_amt%TYPE,
	subline_subline_time  VARCHAR2(50),
	basic_acct_of_cd	  GIXX_POLBASIC.acct_of_cd%TYPE,
	basic_mortg_name	  GIXX_POLBASIC.mortg_name%TYPE,
	assd_name			  GIIS_ASSURED.assd_name%TYPE,
	address1			  GIXX_PARLIST.address1%TYPE,
	address2			  GIXX_PARLIST.address2%TYPE,
	address3			  GIXX_PARLIST.address3%TYPE,
	basic_addr   		  VARCHAR2(4000),--GIXX_POLBASIC.old_address1%TYPE,
	basic_pol_flag		  GIXX_POLBASIC.pol_flag%TYPE,
	basic_line_cd		  GIXX_POLBASIC.line_cd%TYPE,
	basic_ref_pol_no	  GIXX_POLBASIC.ref_pol_no%TYPE,
	basic_assd_no		  GIXX_POLBASIC.assd_no%TYPE,
	label_tag1			  VARCHAR2(20),--GIXX_POLBASIC.label_tag%TYPE,
	endt_no				  VARCHAR2(50),
	pol_endt_no			  VARCHAR2(50),
	endt_expiry_date	  VARCHAR2(50),
	basic_eff_date		  VARCHAR2(50),
	eff_date			  GIXX_POLBASIC.eff_date%TYPE,
	endt_expiry_tag		  GIXX_POLBASIC.endt_expiry_tag%TYPE,
	basic_incept_tag	  GIXX_POLBASIC.incept_tag%TYPE,
	basic_subline_cd	  GIXX_POLBASIC.subline_cd%TYPE,
	basic_iss_cd		  GIXX_POLBASIC.iss_cd%TYPE,
	basic_issue_yy		  GIXX_POLBASIC.issue_yy%TYPE,
	basic_pol_seq_no	  GIXX_POLBASIC.pol_seq_no%TYPE,
	basic_renew_no		  GIXX_POLBASIC.renew_no%TYPE,
	basic_eff_time		  VARCHAR2(50),
	basic_endt_expiry_time VARCHAR2(50),
	par_par_type		  GIXX_PARLIST.par_type%TYPE,
	par_par_status		  GIXX_PARLIST.par_status%TYPE,
	basic_co_insurance_sw GIXX_POLBASIC.co_insurance_sw%TYPE,
	username			  VARCHAR2(40),
	intm_no				  VARCHAR2(50),
	intm_name			  GIIS_INTERMEDIARY.intm_name%TYPE,
	agent_intm_name		  GIIS_INTERMEDIARY.intm_name%TYPE,
	parent_intm_name	  GIIS_INTERMEDIARY.intm_name%TYPE,
	agent_intm_no		  GIIS_INTERMEDIARY.intm_no%TYPE,
	parent_intm_no	  	  GIIS_INTERMEDIARY.intm_no%TYPE,
	basic_tsi_amt_1		  GIXX_POLBASIC.tsi_amt%TYPE,
	subline_open_policy	  GIIS_SUBLINE.op_flag%TYPE,
	subline_time		  VARCHAR2(50),
	basic_assd_number	  GIXX_POLBASIC.assd_no%TYPE,
	cred_br	  			  GIXX_POLBASIC.cred_branch%TYPE,
	label_tag			  GIXX_POLBASIC.label_tag%TYPE,
	basic_printed_cnt	  GIXX_POLBASIC.polendt_printed_cnt%TYPE,
	basic_printed_dt	  GIXX_POLBASIC.polendt_printed_date%TYPE,
	ann_tsi_amt			  GIXX_POLBASIC.ann_tsi_amt%TYPE,
	f_survey_title		  VARCHAR2(2000),
	f_par_no_ref_no		  VARCHAR2(50),
	f_signatory_name	  giis_signatory_names.file_name%type,
	f_attestation1		  giis_document.text%type,
	f_attestation2		  giis_document.text%type,
	f_renewal			  VARCHAR2(1000),
	f_header			  giis_document.text%type,
	f_company			  VARCHAR2(100),
	f_label				  giis_document.text%type,
	f_signatory			  giis_signatory_names.DESIGNATION%TYPE,
	f_upper_comp		  VARCHAR2(100),
	f_acct_of_cd		  VARCHAR2(50),
	F_REF_INV_NO		  gixx_invoice.ref_inv_no%type,
	F_2NDHEADER			  VARCHAR2(500),
	F_2NDHEADER1		  VARCHAR2(500),
	f_declaration		  gixx_open_policy.decltn_no%type,
	f_2NDHEADER2		  VARCHAR2(500),
	f_2NDHEADER3		  VARCHAR2(500),
	f_report_title		  giis_document.text%type,
	f_open_policy		  VARCHAR2(100),
	f_line_name			  GIIS_LINE.line_name%TYPE,
	f_DOC_SUBTITLE1		  giis_document.text%type,
	f_DOC_SUBTITLE2		  giis_document.text%type,
	f_DOC_SUBTITLE3		  giis_document.text%type,
	f_DOC_SUBTITLE4		  giis_document.text%type,
	F_PERIL_TITLE3		  giis_document.text%type,
	F_INTM_NUMBER		  varchar2(100),
	F_INTM_NAME			  varchar2(240),
	F_ATTESTATION_TITLE	  giis_document.text%type,
	f_assd_name			  varchar2(500),
	f_user				  varchar2(500),
	F_TSI_TITLE			  giis_document.text%type,
	F_BASIC_TSI_SPELL	  VARCHAR2(400),
	f_dash				  VARCHAR2(100),
	F_policy_id_0		  gipi_polbasic.policy_id%TYPE,
	F_MORTGAGEE_TITLE	  VARCHAR2(100)
	);
	    
  TYPE mn_policy_doc_tab IS TABLE OF mn_policy_doc_type;
  
  FUNCTION get_mn_policy_doc_details(p_extract_id		 GIXX_POLBASIC.extract_id%TYPE)
    RETURN mn_policy_doc_tab PIPELINED;
  
  PROCEDURE Initialize_Variables (p_report_id IN VARCHAR2);
  
  FUNCTION CF_REPORT_TITLE(p_par_type    GIXX_PARLIST.par_type%TYPE,
  		   				   p_par_status	 GIXX_PARLIST.par_status%TYPE,
						   p_subline_cd	 GIIS_SUBLINE.subline_cd%TYPE)
    RETURN VARCHAR2;
	
  FUNCTION cf_open_policy(p_extract_id	GIXX_POLBASIC.extract_id%TYPE) 
    RETURN VARCHAR2;
	
  function CF_LINE_NAME(p_par_id   GIXX_POLBASIC.policy_id%TYPE,
  		   				p_line_name GIIS_LINE.line_name%TYPE) 
    return VARCHAR2;
	
  function CF_INTM_NUMBER(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE,
  		   				  p_subline_line_cd		  GIIS_SUBLINE.line_cd%TYPE,
						  p_subline_subline_cd	  GIIS_SUBLINE.subline_cd%TYPE,
						  p_basic_iss_cd 		  GIXX_POLBASIC.iss_cd%TYPE,
						  p_basic_issue_yy		  GIXX_POLBASIC.issue_yy%TYPE,
						  p_basic_pol_seq_no	  GIXX_POLBASIC.pol_seq_no%TYPE,
						  p_basic_renew_no		  GIXX_POLBASIC.renew_no%TYPE)
    return VARCHAR2;
	
  function CF_INTM_NAME(  p_extract_id			  GIXX_POLBASIC.extract_id%TYPE,
  		   				  p_subline_line_cd		  GIIS_SUBLINE.line_cd%TYPE,
						  p_subline_subline_cd	  GIIS_SUBLINE.subline_cd%TYPE,
						  p_basic_iss_cd 		  GIXX_POLBASIC.iss_cd%TYPE,
						  p_basic_issue_yy		  GIXX_POLBASIC.issue_yy%TYPE,
						  p_basic_pol_seq_no	  GIXX_POLBASIC.pol_seq_no%TYPE,
						  p_basic_renew_no		  GIXX_POLBASIC.renew_no%TYPE) 
    return VARCHAR2;
	
  function CF_ASSD_NAME(p_label_tag1	    VARCHAR2,
  		   				p_basic_acct_of_cd  GIXX_POLBASIC.acct_of_cd%TYPE,
						p_basic_assd_number GIXX_POLBASIC.assd_no%TYPE)
    return VARCHAR2;
	
  function CF_USER(p_par_id		gixx_polbasic.par_id%TYPE,
  		   		   p_par_status GIXX_PARLIST.par_status%TYPE)
    return VARCHAR2;
	
  function CF_BASIC_TSI_SPELL(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE,
  		   					  p_basic_co_insurance_sw GIXX_POLBASIC.co_insurance_sw%TYPE)
    return varchar2;
	
  function CF_DASH(p_report_title	VARCHAR2) 
    return VARCHAR2;
	
  function CF_policy_id_0(p_par_id		gixx_polbasic.par_id%TYPE) 
    return Number;
	
  function CF_MORTGAGEE_TITLE(p_extract_id			  GIXX_POLBASIC.extract_id%TYPE) 
    return VARCHAR2;

END MN_POLICY_DOC_PKG;
/


