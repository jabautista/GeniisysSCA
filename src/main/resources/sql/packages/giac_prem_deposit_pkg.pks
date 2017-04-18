CREATE OR REPLACE PACKAGE CPI.GIAC_PREM_DEPOSIT_PKG 
AS
   TYPE giac_prem_deposit_type IS RECORD (
      or_print_tag			   GIAC_PREM_DEPOSIT.or_print_tag%TYPE,
	  item_no				   GIAC_PREM_DEPOSIT.item_no%TYPE,
	  transaction_type		   GIAC_PREM_DEPOSIT.transaction_type%TYPE,
	  tran_type_name	   	   CG_REF_CODES.rv_meaning%TYPE,
	  old_item_no			   GIAC_PREM_DEPOSIT.old_item_no%TYPE,
	  old_tran_type			   GIAC_PREM_DEPOSIT.old_tran_type%TYPE,
	  b140_iss_cd			   GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
	  iss_name				   GIIS_ISSOURCE.iss_name%TYPE,
	  b140_prem_seq_no		   GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
	  inst_no				   GIAC_PREM_DEPOSIT.inst_no%TYPE,
	  collection_amt		   GIAC_PREM_DEPOSIT.collection_amt%TYPE,
	  dep_flag				   GIAC_PREM_DEPOSIT.dep_flag%TYPE,
	  assd_no				   GIAC_PREM_DEPOSIT.assd_no%TYPE,
	  assured_name			   GIAC_PREM_DEPOSIT.assured_name%TYPE,
	  intm_no				   GIAC_PREM_DEPOSIT.intm_no%TYPE,
	  intm_name				   GIIS_INTERMEDIARY.intm_name%TYPE,
	  ri_cd					   GIAC_PREM_DEPOSIT.ri_cd%TYPE,
	  ri_name				   GIIS_REINSURER.ri_name%TYPE,
	  par_seq_no			   GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
	  quote_seq_no			   GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
	  line_cd				   GIAC_PREM_DEPOSIT.line_cd%TYPE,
	  subline_cd			   GIAC_PREM_DEPOSIT.subline_cd%TYPE,
	  iss_cd				   GIAC_PREM_DEPOSIT.iss_cd%TYPE,
	  issue_yy				   GIAC_PREM_DEPOSIT.issue_yy%TYPE,
	  pol_seq_no			   GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
	  renew_no				   GIAC_PREM_DEPOSIT.renew_no%TYPE,
	  colln_dt				   GIAC_PREM_DEPOSIT.colln_dt%TYPE,
	  gacc_tran_id			   GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
	  old_tran_id			   GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
	  remarks				   GIAC_PREM_DEPOSIT.remarks%TYPE,
	  user_id				   GIAC_PREM_DEPOSIT.user_id%TYPE,
	  last_update			   GIAC_PREM_DEPOSIT.last_update%TYPE,
	  currency_cd			   GIAC_PREM_DEPOSIT.currency_cd%TYPE,
	  convert_rate			   GIAC_PREM_DEPOSIT.convert_rate%TYPE,
	  foreign_curr_amt		   GIAC_PREM_DEPOSIT.foreign_curr_amt%TYPE,
	  or_tag				   GIAC_PREM_DEPOSIT.or_tag%TYPE,
	  comm_rec_no			   GIAC_PREM_DEPOSIT.comm_rec_no%TYPE,
	  bill_no				   VARCHAR2(50),
	  par_yy				   GIAC_PREM_DEPOSIT.par_yy%TYPE
   );
   
  /*
  **  Created by   :  Emman
  **  Date Created :  08.04.2010
  **  Reference By : (GIACS026 - Premium Deposit)
  **  Description  : Used in VALIDATE_TRAN_TYPE2 procedure
  */ 
   TYPE giac_prem_deposit_2_type IS RECORD (
      gacc_tran_id			   GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
	  item_no				   GIAC_PREM_DEPOSIT.item_no%TYPE,
   	  assd_no				   GIAC_PREM_DEPOSIT.assd_no%TYPE,
	  assured_name			   GIIS_ASSURED.assd_name%TYPE,
	  b140_iss_cd			   GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
	  b140_prem_seq_no		   GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
	  inst_no				   GIAC_PREM_DEPOSIT.inst_no%TYPE,
	  line_cd				   GIAC_PREM_DEPOSIT.line_cd%TYPE,
	  subline_cd			   GIAC_PREM_DEPOSIT.subline_cd%TYPE,
	  iss_cd				   GIAC_PREM_DEPOSIT.iss_cd%TYPE,
	  issue_yy				   GIAC_PREM_DEPOSIT.issue_yy%TYPE,
	  pol_seq_no			   GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
	  renew_no				   GIAC_PREM_DEPOSIT.renew_no%TYPE,
	  par_seq_no			   GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
	  par_yy				   GIAC_PREM_DEPOSIT.par_yy%TYPE,
	  quote_seq_no			   GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
	  remarks				   GIAC_PREM_DEPOSIT.remarks%TYPE,
	  transaction_type	   	   GIAC_PREM_DEPOSIT.transaction_type%TYPE,
	  collection_amt		   GIAC_PREM_DEPOSIT.collection_amt%TYPE
   );
   
   TYPE old_item_no_list_type IS RECORD (
      count_               NUMBER,
      rownum_              NUMBER,
   	  branch_cd			   GIAC_ACCTRANS.gibr_branch_cd%TYPE,
	  old_item_no		   GIAC_PREM_DEPOSIT.item_no%TYPE,
	  old_tran_type		   GIAC_PREM_DEPOSIT.transaction_type%TYPE,
	  old_tran_id		   GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
	  dsp_collection_amt   GIAC_PREM_DEPOSIT.collection_amt%TYPE,
	  dsp_tran_year		   GIAC_ACCTRANS.tran_year%TYPE,
	  dsp_tran_month	   GIAC_ACCTRANS.tran_month%TYPE,
	  dsp_tran_seq_no	   GIAC_ACCTRANS.tran_seq_no%TYPE,
	  dsp_particulars	   GIAC_PREM_DEPOSIT.remarks%TYPE,
	  dsp_tran_class	   GIAC_ACCTRANS.tran_class%TYPE,
	  dsp_tran_class_no	   GIAC_ACCTRANS.tran_class_no%TYPE,
	  assd_no			   GIAC_PREM_DEPOSIT.assd_no%TYPE,
	  dep_flag			   GIAC_PREM_DEPOSIT.dep_flag%TYPE,
	  ri_cd				   GIAC_PREM_DEPOSIT.ri_cd%TYPE,
	  intm_no			   GIAC_PREM_DEPOSIT.intm_no%TYPE,
	  line_cd			   GIAC_PREM_DEPOSIT.line_cd%TYPE,
	  subline_cd		   GIAC_PREM_DEPOSIT.subline_cd%TYPE,
	  iss_cd			   GIAC_PREM_DEPOSIT.iss_cd%TYPE,
	  issue_yy			   GIAC_PREM_DEPOSIT.issue_yy%TYPE,
	  pol_seq_no		   GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
	  renew_no			   GIAC_PREM_DEPOSIT.renew_no%TYPE,
	  b140_iss_cd		   GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
	  b140_prem_seq_no	   GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
	  comm_rec_no		   GIAC_PREM_DEPOSIT.comm_rec_no%TYPE,
      inst_no              GIAC_PREM_DEPOSIT.inst_no%TYPE,
	  dsp_policy_no		   VARCHAR2(100),
	  dsp_old_tran_no	   VARCHAR2(100),
  	  old_tran_id2		   GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
	  old_tran_id_for_1	   GIAC_PREM_DEPOSIT.old_tran_id%TYPE, --for tran_type 1
	  old_tran_id_for_3	   GIAC_PREM_DEPOSIT.old_tran_id%TYPE, --for tran_type 3
      dsp_assd_name        GIIS_ASSURED.assd_name%TYPE,
      dsp_intm_name        GIIS_INTERMEDIARY.intm_name%TYPE,
      dsp_reinsurer_name   GIIS_REINSURER.ri_name%TYPE,
      dsp_par_no           VARCHAR2(100),
      par_line_cd          GIAC_PREM_DEPOSIT.line_cd%TYPE,
      par_iss_cd           GIAC_PREM_DEPOSIT.iss_cd%TYPE,
      par_yy               GIAC_PREM_DEPOSIT.par_yy%TYPE,
      par_seq_no           GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
      quote_seq_no         GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
      currency_cd          GIAC_PREM_DEPOSIT.currency_cd%TYPE,     
      convert_rate         GIAC_PREM_DEPOSIT.convert_rate%TYPE,    
      foreign_curr_amt     GIAC_PREM_DEPOSIT.foreign_curr_amt%TYPE,
      currency_desc        GIIS_CURRENCY.currency_desc%TYPE  
   );
   
   TYPE collection_amt_sum_type IS RECORD (
      gacc_tran_id			   GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
      old_tran_id			   GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
	  old_item_no			   GIAC_PREM_DEPOSIT.old_item_no%TYPE,
	  collection_amt_sum	   GIAC_PREM_DEPOSIT.old_tran_id%TYPE
   );
   
   /*
  **  Created by   :  Emman
  **  Date Created :  08.06.2010
  **  Reference By : (GIACS026 - Premium Deposit)
  **  Description  : Used in ISS_CD_TRIGGER
  */ 
   TYPE giac_aging_soa_policy_type IS RECORD (
   	  policy_id						  GIPI_POLBASIC.policy_id%TYPE,
      line_cd						  GIPI_POLBASIC.line_cd%TYPE,
	  subline_cd					  GIPI_POLBASIC.subline_cd%TYPE,
	  iss_cd						  GIPI_POLBASIC.iss_cd%TYPE,
	  issue_yy						  GIPI_POLBASIC.issue_yy%TYPE,
	  pol_seq_no					  GIPI_POLBASIC.pol_seq_no%TYPE,
	  renew_no						  GIPI_POLBASIC.renew_no%TYPE,
	  b140_iss_cd					  GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
	  prem_seq_no					  GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
	  inst_no						  GIAC_AGING_SOA_DETAILS.inst_no%TYPE
   );   
 
 	TYPE par_no_list_type IS RECORD ( --edited by steven 12/18/2012
	  dsp_par_no			  VARCHAR2(100),
      par_line_cd			  GIAC_PREM_DEPOSIT.line_cd%TYPE,
      par_iss_cd			  GIAC_PREM_DEPOSIT.iss_cd%TYPE,
	  par_yy			      GIAC_PREM_DEPOSIT.par_yy%TYPE,
	  par_seq_no	       	  GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
	  quote_seq_no		      GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
	  pol_line_cd 			  GIPI_POLBASIC.line_cd%TYPE,
	  pol_subline_cd 		  GIPI_POLBASIC.subline_cd%TYPE,
	  pol_iss_cd 			  GIPI_POLBASIC.iss_cd%TYPE,
	  pol_issue_yy 			  GIPI_POLBASIC.issue_yy%TYPE,
	  pol_pol_seq_no 		  GIPI_POLBASIC.pol_seq_no%TYPE,
	  pol_renew_no 			  GIPI_POLBASIC.renew_no%TYPE,
	  assd_no				  GIIS_ASSURED.assd_no%TYPE,
      assd_name       		  GIIS_ASSURED.assd_name%TYPE,
	  policy_no				  VARCHAR(50)
   );
   
   TYPE giac_prem_dep_tg_type IS RECORD(
     tran_id                GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
     gfun_fund_cd           GIAC_ACCTRANS.gfun_fund_cd%TYPE,
     gibr_branch_cd         GIAC_ACCTRANS.gibr_branch_cd%TYPE,
     generation_type        GIAC_MODULES.generation_type%TYPE,
     collection_amt         GIAC_PREM_DEPOSIT.collection_amt%TYPE,
     dep_flag               GIAC_PREM_DEPOSIT.dep_flag%TYPE,
     assd_no                GIAC_PREM_DEPOSIT.assd_no%TYPE,
	 assured_name           GIAC_PREM_DEPOSIT.assured_name%TYPE,
	 intm_no                GIAC_PREM_DEPOSIT.intm_no%TYPE,
	 ri_cd                  GIAC_PREM_DEPOSIT.ri_cd%TYPE,
     par_seq_no             GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
     par_yy                 GIAC_PREM_DEPOSIT.par_yy%TYPE,
	 quote_seq_no           GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
	 line_cd                GIAC_PREM_DEPOSIT.line_cd%TYPE,
     subline_cd             GIAC_PREM_DEPOSIT.subline_cd%TYPE,
     iss_cd                 GIAC_PREM_DEPOSIT.iss_cd%TYPE,
	 issue_yy               GIAC_PREM_DEPOSIT.issue_yy%TYPE,
     pol_seq_no             GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
     renew_no               GIAC_PREM_DEPOSIT.renew_no%TYPE,
	 colln_dt               GIAC_PREM_DEPOSIT.colln_dt%TYPE,
	 old_tran_id            GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
     currency_cd            GIAC_PREM_DEPOSIT.currency_cd%TYPE,
     convert_rate           GIAC_PREM_DEPOSIT.convert_rate%TYPE,
     foreign_curr_amt       GIAC_PREM_DEPOSIT.foreign_curr_amt%TYPE,
     or_tag                 GIAC_PREM_DEPOSIT.or_tag%TYPE,
	 remarks                GIAC_PREM_DEPOSIT.remarks%TYPE,
	 user_id                GIAC_PREM_DEPOSIT.user_id%TYPE,
     last_update            GIAC_PREM_DEPOSIT.last_update%TYPE,
	 intm_name			  	GIIS_INTERMEDIARY.intm_name%TYPE,
	 ri_name				GIIS_REINSURER.ri_name%TYPE,
	 gacc_tran_id			GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,			
     bill_no				VARCHAR2(50),
	 comm_rec_no			GIAC_PREM_DEPOSIT.comm_rec_no%TYPE,
	 or_print_tag			GIAC_PREM_DEPOSIT.or_print_tag%TYPE,
	 item_no				GIAC_PREM_DEPOSIT.item_no%TYPE,
	 transaction_type		GIAC_PREM_DEPOSIT.transaction_type%TYPE,
	 tran_type_name			CG_REF_CODES.rv_meaning%TYPE,
	 old_item_no			GIAC_PREM_DEPOSIT.old_item_no%TYPE,
	 old_tran_type			GIAC_PREM_DEPOSIT.old_tran_type%TYPE,
	 b140_iss_cd			GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
	 iss_name				GIIS_ISSOURCE.iss_name%TYPE,
	 b140_prem_seq_no		GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
	 inst_no				GIAC_PREM_DEPOSIT.inst_no%TYPE,
	 dsp_dep_flag			varchar2(50),
	 dsp_par_yy				varchar2(50),
	 dsp_par_seq_no			varchar2(50),
	 dsp_quote_seq_no		varchar2(50),
	 tran_date				GIAC_ACCTRANS.tran_date%TYPE,
	 tran_flag				GIAC_ACCTRANS.tran_flag%TYPE,
	 tran_class				GIAC_ACCTRANS.tran_class%TYPE,
     tran_class_no			GIAC_ACCTRANS.tran_class_no%TYPE,
	 particulars			GIAC_ACCTRANS.particulars%TYPE,
	 tran_year				GIAC_ACCTRANS.tran_year%TYPE,
	 tran_month				GIAC_ACCTRANS.tran_month%TYPE,
	 tran_seq_no			GIAC_ACCTRANS.tran_seq_no%TYPE,
	 dsp_old_tran_no		varchar2(50),
     currency_desc          GIIS_CURRENCY.currency_desc%TYPE,-- kris 02.01.2013
     dsp_par_no           VARCHAR2(100) 
   ); 
   
   TYPE giac_acctrans_type IS RECORD(
     tran_id                GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
     gfun_fund_cd           GIAC_ACCTRANS.gfun_fund_cd%TYPE,
     gibr_branch_cd         GIAC_ACCTRANS.gibr_branch_cd%TYPE,
	 dsp_tran_flag			GIAC_ACCTRANS.tran_flag%TYPE,
	 dsp_tran_date			GIAC_ACCTRANS.tran_date%TYPE,
	 dsp_tran_year		   	GIAC_ACCTRANS.tran_year%TYPE,
	 dsp_tran_month	   		GIAC_ACCTRANS.tran_month%TYPE,
	 dsp_tran_seq_no	   	GIAC_ACCTRANS.tran_seq_no%TYPE,
	 dsp_particulars	   	GIAC_PREM_DEPOSIT.remarks%TYPE,
	 dsp_tran_class	   		GIAC_ACCTRANS.tran_class%TYPE,
	 dsp_tran_class_no	   	GIAC_ACCTRANS.tran_class_no%TYPE
   );
	
   TYPE giis_currency_list_type IS RECORD(
     main_currency_cd	    GIIS_CURRENCY.main_currency_cd%TYPE, 	
	 currency_desc  		GIIS_CURRENCY.currency_desc%TYPE,
	 currency_rt			GIIS_CURRENCY.currency_rt%TYPE,
	 short_name				GIIS_CURRENCY.short_name%TYPE		
   );
   
   TYPE iss_cd_list_type IS RECORD(
    b140_iss_cd				GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
	b140_prem_seq_no  		GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
	inst_no					GIAC_AGING_SOA_DETAILS.inst_no%TYPE,
	dsp_a150_line_cd		GIAC_AGING_SOA_DETAILS.a150_line_cd%TYPE,
	dsp_total_amount_due	GIAC_AGING_SOA_DETAILS.total_amount_due%TYPE,
	dsp_total_payments		GIAC_AGING_SOA_DETAILS.total_payments%TYPE,
	dsp_temp_payments		GIAC_AGING_SOA_DETAILS.temp_payments%TYPE,
	dsp_balance_amt_due		GIAC_AGING_SOA_DETAILS.balance_amt_due%TYPE,
	dsp_a020_assd_no		GIAC_AGING_SOA_DETAILS.a020_assd_no%TYPE,
	assured_name 			GIIS_ASSURED.assd_name%TYPE
   );
   
   TYPE ri_iss_cd_list_type IS RECORD(
    ri_cd					GIAC_AGING_RI_SOA_DETAILS.a180_ri_cd%TYPE,
	b140_prem_seq_no  		GIAC_AGING_RI_SOA_DETAILS.prem_seq_no%TYPE,
	inst_no					GIAC_AGING_RI_SOA_DETAILS.inst_no%TYPE,
	dsp_a150_line_cd		GIAC_AGING_RI_SOA_DETAILS.a150_line_cd%TYPE,
	dsp_total_amount_due	GIAC_AGING_RI_SOA_DETAILS.total_amount_due%TYPE,
	dsp_total_payments		GIAC_AGING_RI_SOA_DETAILS.total_payments%TYPE,
	dsp_temp_payments		GIAC_AGING_RI_SOA_DETAILS.temp_payments%TYPE,
	dsp_balance_amt_due		VARCHAR2(50),
	dsp_a020_assd_no		GIAC_AGING_RI_SOA_DETAILS.a020_assd_no%TYPE,
	assured_name 			GIIS_ASSURED.assd_name%TYPE
   );
   
   TYPE assd_name_list_type IS RECORD(
    assd_no					GIIS_ASSURED.assd_no%TYPE,
	assured_name  			GIIS_ASSURED.assd_name%TYPE,
	find_text 			    VARCHAR2(100)
   );
   
   TYPE intm_name_list_type IS RECORD(
    intm_no					GIIS_INTERMEDIARY.intm_no%TYPE,
	intm_name  				GIIS_INTERMEDIARY.intm_name%TYPE,
	find_text 			    VARCHAR2(100)
   );
   
   TYPE pol_no_list_type IS RECORD(--edited by steven 12/18/2012
	line_cd			GIPI_POLBASIC.line_cd%TYPE,
	subline_cd		GIPI_POLBASIC.subline_cd%TYPE,
	iss_cd			GIPI_POLBASIC.iss_cd%TYPE,
	issue_yy		GIPI_POLBASIC.issue_yy%TYPE,
	pol_seq_no		GIPI_POLBASIC.pol_seq_no%TYPE,
	renew_no		GIPI_POLBASIC.renew_no%TYPE,
	policy_no		VARCHAR(50),
	assd_no			GIIS_ASSURED.assd_no%TYPE,
	policy_id		GIPI_POLBASIC.policy_id%TYPE,
    assd_name       GIIS_ASSURED.assd_name%TYPE, --change by steven 12/18/2012  from:VARCHAR2(200),  to:GIIS_ASSURED.assd_name%TYPE,
    endt_seq_no		GIPI_POLBASIC.endt_seq_no%TYPE,
	par_line_cd  	GIPI_PARLIST.line_cd%TYPE,
	par_iss_cd  	GIPI_PARLIST.iss_cd%TYPE,
	par_yy  		GIPI_PARLIST.par_yy%TYPE,
	par_seq_no  	GIPI_PARLIST.par_seq_no%TYPE,
	quote_seq_no	GIPI_PARLIST.quote_seq_no%TYPE,
	dsp_par_no		VARCHAR2(100)
	);
   
   TYPE giac_prem_deposit_tab IS TABLE OF giac_prem_deposit_type;
   
   TYPE giac_prem_deposit_cur IS REF CURSOR RETURN giac_prem_deposit_type;
   
   TYPE giac_prem_deposit_2_tab IS TABLE OF giac_prem_deposit_2_type;
   
   TYPE collection_amt_sum_tab IS TABLE OF collection_amt_sum_type;
   
   TYPE old_item_no_list_tab IS TABLE OF old_item_no_list_type;
   
   TYPE giac_aging_soa_policy_tab IS TABLE OF giac_aging_soa_policy_type;
   
   TYPE par_no_list_tab IS TABLE OF par_no_list_type;
   
   TYPE giac_prem_dep_tg_tab IS TABLE OF giac_prem_dep_tg_type;
   
   TYPE giac_acctrans_tab IS TABLE OF giac_acctrans_type;
   
   TYPE giis_currency_list_tab IS TABLE OF giis_currency_list_type;
   
   TYPE iss_cd_list_tab IS TABLE OF  iss_cd_list_type;
   
   TYPE ri_iss_cd_list_tab IS TABLE OF  ri_iss_cd_list_type;
   
   TYPE assd_name_list_tab IS TABLE OF assd_name_list_type;
   
   TYPE intm_name_list_tab IS TABLE OF intm_name_list_type;
   
   TYPE pol_no_list_tab IS TABLE OF pol_no_list_type;
   
   FUNCTION get_giac_prem_deposit (
   	  p_tran_id      giac_prem_deposit.gacc_tran_id%TYPE
   ) RETURN giac_prem_deposit_tab PIPELINED;
   
   PROCEDURE set_giac_prem_deposit (p_gacc_tran_id			GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
  								   p_item_no				GIAC_PREM_DEPOSIT.item_no%TYPE,
								   p_transaction_type		GIAC_PREM_DEPOSIT.transaction_type%TYPE,
								   p_collection_amt			GIAC_PREM_DEPOSIT.collection_amt%TYPE,
								   p_dep_flag				GIAC_PREM_DEPOSIT.dep_flag%TYPE,
								   p_assd_no				GIAC_PREM_DEPOSIT.assd_no%TYPE,
								   p_ri_cd					GIAC_PREM_DEPOSIT.ri_cd%TYPE,
								   p_b140_prem_seq_no		GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
								   p_inst_no				GIAC_PREM_DEPOSIT.inst_no%TYPE,
								   p_old_tran_id			GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
								   p_old_item_no			GIAC_PREM_DEPOSIT.old_item_no%TYPE,
								   p_old_tran_type			GIAC_PREM_DEPOSIT.old_tran_type%TYPE,
								   p_issue_yy				GIAC_PREM_DEPOSIT.issue_yy%TYPE,
								   p_pol_seq_no				GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
								   p_renew_no				GIAC_PREM_DEPOSIT.renew_no%TYPE,
								   p_par_seq_no				GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
								   p_par_yy					GIAC_PREM_DEPOSIT.par_yy%TYPE,
								   p_quote_seq_no			GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
								   p_currency_cd			GIAC_PREM_DEPOSIT.currency_cd%TYPE,
								   p_convert_rate			GIAC_PREM_DEPOSIT.convert_rate%TYPE,
								   p_foreign_curr_amt		GIAC_PREM_DEPOSIT.foreign_curr_amt%TYPE,
								   p_b140_iss_cd			GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
								   p_line_cd				GIAC_PREM_DEPOSIT.line_cd%TYPE,
								   p_subline_cd				GIAC_PREM_DEPOSIT.subline_cd%TYPE,
								   p_iss_cd					GIAC_PREM_DEPOSIT.iss_cd%TYPE,
								   p_assured_name			GIAC_PREM_DEPOSIT.assured_name%TYPE,
								   p_remarks				GIAC_PREM_DEPOSIT.remarks%TYPE,
								   p_colln_dt				GIAC_PREM_DEPOSIT.colln_dt%TYPE,
								   p_or_print_tag			GIAC_PREM_DEPOSIT.or_print_tag%TYPE,
								   p_user_id				GIAC_PREM_DEPOSIT.user_id%TYPE,
								   p_last_update			GIAC_PREM_DEPOSIT.last_update%TYPE,
								   p_or_tag					GIAC_PREM_DEPOSIT.or_tag%TYPE,
								   p_upload_tag				GIAC_PREM_DEPOSIT.upload_tag%TYPE,
								   p_intm_no				GIAC_PREM_DEPOSIT.intm_no%TYPE,
								   p_comm_rec_no			GIAC_PREM_DEPOSIT.comm_rec_no%TYPE,
								   p_par_line_cd          GIAC_PREM_DEPOSIT.par_line_cd%TYPE,
                                   p_par_iss_cd           GIAC_PREM_DEPOSIT.par_iss_cd%TYPE);
   
   PROCEDURE del_giac_prem_deposit (p_gacc_tran_id		GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
   			 					    p_item_no			GIAC_PREM_DEPOSIT.item_no%TYPE,
									p_transaction_type  GIAC_PREM_DEPOSIT.transaction_type%TYPE);
   
   FUNCTION get_total_collections (
   	  p_tran_id      giac_prem_deposit.gacc_tran_id%TYPE
   ) RETURN NUMBER;
   
   FUNCTION get_old_item_no_list (
     p_transaction_type   giac_prem_deposit.transaction_type%TYPE,
     p_control_module     VARCHAR2,
     p_user_id            giis_users.user_id%TYPE,
     p_find_text     VARCHAR2,
     p_order_by      VARCHAR2,
     p_asc_desc_flag VARCHAR2,
     p_from          NUMBER,
     p_to            NUMBER
   ) RETURN old_item_no_list_tab PIPELINED;
   
   FUNCTION get_old_item_no_for_4_list (
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER
   )
      RETURN old_item_no_list_tab PIPELINED;   
   
   FUNCTION get_giac_prem_deposit_list RETURN giac_prem_deposit_2_tab PIPELINED;
    
   PROCEDURE get_giac_prem_deposit_records(
     p_tran_id							   IN  giac_prem_deposit.gacc_tran_id%TYPE,
	 p_gfun_fund_cd	 					   IN  giac_acctrans.gfun_fund_cd%TYPE,
	 p_gibr_branch_cd   				   IN  giac_acctrans.gibr_branch_cd%TYPE,
	 p_giac_prem_deposit_list			   OUT giac_prem_deposit_cur,
	 p_giac_acctrans					   OUT giac_acctrans_pkg.giac_acctrans_cur,
	 p_giis_currency_list				   OUT giis_currency_pkg.giis_currency_cur,
	 p_generation_type					   OUT giac_modules.generation_type%TYPE
   );
   
   FUNCTION get_old_tran_id (
     p_dsp_tran_year		GIAC_ACCTRANS.tran_year%TYPE,
	 p_dsp_tran_month		GIAC_ACCTRANS.tran_month%TYPE,
	 p_dsp_tran_seq_no		GIAC_ACCTRANS.tran_seq_no%TYPE,
	 p_iss_cd				GIAC_ACCTRANS.gibr_branch_cd%TYPE,
	 p_dsp_tran_class_no	GIAC_ACCTRANS.tran_class_no%TYPE
   ) RETURN GIAC_PREM_DEPOSIT.old_tran_id%TYPE;
   
   FUNCTION get_old_tran_id_by_tran_type (
     p_tran_type			GIAC_PREM_DEPOSIT.transaction_type%TYPE,
     p_dsp_tran_year		GIAC_ACCTRANS.tran_year%TYPE,
	 p_dsp_tran_month		GIAC_ACCTRANS.tran_month%TYPE,
	 p_dsp_tran_seq_no		GIAC_ACCTRANS.tran_seq_no%TYPE,
	 p_old_item_no			GIAC_PREM_DEPOSIT.item_no%TYPE
   ) RETURN GIAC_PREM_DEPOSIT.old_tran_id%TYPE;
   
   FUNCTION get_collection_sum_list_for_2
    RETURN collection_amt_sum_tab PIPELINED;
	
   FUNCTION get_collection_sum_list_for_4
    RETURN collection_amt_sum_tab PIPELINED;

   FUNCTION get_giac_aging_soa_policy_list
    RETURN giac_aging_soa_policy_tab PIPELINED;
	
   PROCEDURE update_giac_text (p_gacc_tran_id  GIAC_ACCTRANS.tran_id%TYPE,
   			 				   p_gen_type	   GIAC_MODULES.generation_type%TYPE,
   			 				   p_tran_source   VARCHAR2,
   			 				   p_or_flag	   VARCHAR2,
							   p_user_id	   giis_users.user_id%TYPE);
							   
   PROCEDURE del_giac_prem_dep_by_recno(p_gacc_tran_id			IN GIAC_COMM_PAYTS.gacc_tran_id%TYPE,
  									   p_iss_cd					IN GIAC_COMM_PAYTS.iss_cd%TYPE,
									   p_prem_seq_no			IN GIAC_COMM_PAYTS.prem_seq_no%TYPE,
									   p_intm_no				IN GIAC_COMM_PAYTS.intm_no%TYPE,
									   p_record_no				IN GIAC_COMM_PAYTS.record_no%TYPE);
									   
   PROCEDURE collection_default_amt(p_gacc_tran_id		IN	   GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
   			 					 p_transaction_type		IN	   GIAC_PREM_DEPOSIT.transaction_type%TYPE,
		  						 p_dsp_tran_year		IN	   GIAC_ACCTRANS.tran_year%TYPE,
								 p_dsp_tran_month		IN	   GIAC_ACCTRANS.tran_month%TYPE,
								 p_dsp_tran_seq_no		IN	   GIAC_ACCTRANS.tran_seq_no%TYPE,
								 p_old_item_no			IN	   GIAC_PREM_DEPOSIT.old_item_no%TYPE,
								 p_default_value		IN OUT NUMBER,
		  						 p_old_tran_id			IN OUT GIAC_PREM_DEPOSIT.old_tran_id%TYPE,		  						 
		  						 p_var_pck_swtch		IN OUT NUMBER,
								 p_var_pck_tot_coll		IN OUT NUMBER,
								 p_var_pck_tot_coll_2	IN OUT NUMBER,
								 p_var_pck_gcba_gti		IN OUT GIAC_BANK_COLLNS.gcba_gacc_tran_id%TYPE,
								 p_var_pck_gcba_in		IN OUT GIAC_BANK_COLLNS.gcba_item_no%TYPE,
								 p_message				   OUT VARCHAR2);
								 
   PROCEDURE get_par_seq_no(p_old_item_no				IN     GIAC_PREM_DEPOSIT.old_item_no%TYPE,
		  				 p_old_tran_type			IN	   GIAC_PREM_DEPOSIT.old_tran_type%TYPE,
						 p_old_tran_id				IN	   GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
						 p_par_line_cd				   OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
						 p_par_iss_cd				   OUT GIAC_PREM_DEPOSIT.iss_cd%TYPE,
						 p_par_yy	 				   OUT GIAC_PREM_DEPOSIT.par_yy%TYPE,
						 p_par_seq_no				   OUT GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
						 p_quote_seq_no				   OUT GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
						 p_remarks					   OUT GIAC_PREM_DEPOSIT.remarks%TYPE);
						 
   PROCEDURE get_par_seq_no2(p_line_cd					IN     GIAC_PREM_DEPOSIT.line_cd%TYPE,
		  				 p_subline_cd				IN     GIAC_PREM_DEPOSIT.subline_cd%TYPE,
						 p_iss_cd					IN     GIAC_PREM_DEPOSIT.iss_cd%TYPE,
						 p_issue_yy					IN     GIAC_PREM_DEPOSIT.issue_yy%TYPE,
						 p_pol_seq_no				IN     GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
                         p_b140_iss_cd              IN     GIPI_INVOICE.iss_cd%TYPE,
                         p_prem_seq_no              IN     GIPI_INVOICE.prem_seq_no%TYPE,						 
						 p_assd_no					IN     GIAC_PREM_DEPOSIT.assd_no%TYPE,
						 p_par_line_cd				   OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
						 p_par_iss_cd				   OUT GIAC_PREM_DEPOSIT.iss_cd%TYPE,
						 p_par_yy	 				   OUT GIAC_PREM_DEPOSIT.par_yy%TYPE,
						 p_par_seq_no				   OUT GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
						 p_quote_seq_no				   OUT GIAC_PREM_DEPOSIT.quote_seq_no%TYPE);
						 
   PROCEDURE VALIDATE_TRAN_TYPE1(
		   p_b140_iss_cd								IN     GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
		   p_b140_prem_seq_no							IN     GIAC_AGING_SOA_DETAILS.prem_seq_no%TYPE,
		   p_inst_no									IN     GIAC_AGING_SOA_DETAILS.inst_no%TYPE,	   
		   p_assd_no									IN OUT    GIIS_ASSURED.assd_no%TYPE,
		   p_drv_assured_name							IN OUT GIIS_ASSURED.assd_name%TYPE,
		   p_assured_name								IN OUT GIIS_ASSURED.assd_name%TYPE,
		   p_dsp_a150_line_cd							IN OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
		   p_line_cd									IN OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
		   p_subline_cd									IN OUT GIAC_PREM_DEPOSIT.subline_cd%TYPE,
		   p_iss_cd										IN OUT GIAC_PREM_DEPOSIT.iss_cd%TYPE,
		   p_issue_yy									IN OUT GIAC_PREM_DEPOSIT.issue_yy%TYPE,
		   p_pol_seq_no									IN OUT GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
		   p_renew_no									IN OUT GIAC_PREM_DEPOSIT.renew_no%TYPE);
		   
   PROCEDURE validate_tran_type2 (p_transaction_type		IN OUT GIAC_PREM_DEPOSIT.transaction_type%TYPE,
		  					   p_dsp_tran_year			IN OUT GIAC_ACCTRANS.tran_year%TYPE,
		  					   p_dsp_tran_month			IN OUT GIAC_ACCTRANS.tran_month%TYPE,
							   p_dsp_tran_seq_no		IN OUT GIAC_ACCTRANS.tran_seq_no%TYPE,
							   p_dsp_tran_class_no		IN OUT GIAC_ACCTRANS.tran_class_no%TYPE,
							   p_old_item_no			IN OUT GIAC_PREM_DEPOSIT.old_item_no%TYPE,
							   p_old_tran_type			IN OUT GIAC_PREM_DEPOSIT.old_tran_type%TYPE,
		  					   p_old_tran_id			IN OUT GIAC_PREM_DEPOSIT.old_tran_id%TYPE,
							   p_assd_no				IN OUT GIAC_PREM_DEPOSIT.assd_no%TYPE,
							   p_par_seq_no				IN OUT GIAC_PREM_DEPOSIT.par_seq_no%TYPE,
							   p_par_yy					IN OUT GIAC_PREM_DEPOSIT.par_yy%TYPE,
							   p_quote_seq_no			IN OUT GIAC_PREM_DEPOSIT.quote_seq_no%TYPE,
							   p_line_cd				IN OUT GIAC_PREM_DEPOSIT.line_cd%TYPE,
							   p_subline_cd				IN OUT GIAC_PREM_DEPOSIT.subline_cd%TYPE,
							   p_iss_cd					IN OUT GIAC_PREM_DEPOSIT.iss_cd%TYPE,
							   p_issue_yy				IN OUT GIAC_PREM_DEPOSIT.issue_yy%TYPE,
							   p_pol_seq_no				IN OUT GIAC_PREM_DEPOSIT.pol_seq_no%TYPE,
							   p_renew_no				IN OUT GIAC_PREM_DEPOSIT.renew_no%TYPE,
							   p_b140_iss_cd			IN OUT GIAC_PREM_DEPOSIT.b140_iss_cd%TYPE,
							   p_b140_prem_seq_no		IN OUT GIAC_PREM_DEPOSIT.b140_prem_seq_no%TYPE,
							   p_inst_no				IN OUT GIAC_PREM_DEPOSIT.inst_no%TYPE,
							   p_dsp_par_no				IN OUT VARCHAR2,
							   p_message				OUT VARCHAR2);
							   
   FUNCTION check_gipd_gipd_fk (p_old_tran_id			GIAC_PREM_DEPOSIT.gacc_tran_id%TYPE,
   							    p_old_item_no			GIAC_PREM_DEPOSIT.item_no%TYPE,
								p_old_tran_type			GIAC_PREM_DEPOSIT.transaction_type%TYPE)
	 RETURN VARCHAR2;
	
	
	FUNCTION get_par_no_lov ( --edited bby steven 12/18/2012
      /*p_par_line_cd    giac_prem_deposit.line_cd%TYPE,
      p_par_iss_cd     giac_prem_deposit.iss_cd%TYPE,
      p_par_yy         giac_prem_deposit.par_yy%TYPE,
      p_par_seq_no     giac_prem_deposit.par_seq_no%TYPE,
      p_quote_seq_no   giac_prem_deposit.quote_seq_no%TYPE,
      p_dsp_par_no     VARCHAR2,*/
	  p_assd_no 	   GIIS_ASSURED.assd_no%TYPE,
      p_user_id        VARCHAR2,
      p_find_text      VARCHAR2
   	)
      RETURN par_no_list_tab PIPELINED;
	
  FUNCTION get_prem_dep_tg( p_tran_id                  IN  giac_prem_deposit.gacc_tran_id%TYPE,
     					   	p_gfun_fund_cd             IN  giac_acctrans.gfun_fund_cd%TYPE,
     						p_gibr_branch_cd           IN  giac_acctrans.gibr_branch_cd%TYPE,
							p_item_no					   giac_prem_deposit.item_no%TYPE,
							p_tran_type_name			   cg_ref_codes.rv_meaning%TYPE,
							p_old_tran_id				   giac_prem_deposit.old_tran_id%TYPE,
							p_iss_name					   giis_issource.iss_name%TYPE,
							p_bill_no					   VARCHAR2,
							p_inst_no					   giac_prem_deposit.inst_no%TYPE,
							p_collection_amt			   giac_prem_deposit.collection_amt%TYPE,
							p_dep_flag					   giac_prem_deposit.dep_flag%TYPE)
		RETURN giac_prem_dep_tg_tab PIPELINED;
		
	FUNCTION get_giac_acctrans(	p_tran_id                 IN  giac_prem_deposit.gacc_tran_id%TYPE,
 	 							p_gfun_fund_cd            IN  giac_acctrans.gfun_fund_cd%TYPE,
     							p_gibr_branch_cd          IN  giac_acctrans.gibr_branch_cd%TYPE)
		RETURN giac_acctrans_tab PIPELINED;
	
	FUNCTION get_giis_currency_list
    	RETURN giis_currency_list_tab PIPELINED;

	FUNCTION get_generation_type(p_module_name 		IN GIAC_MODULES.module_name%type)
	 	RETURN VARCHAR2;
		
	FUNCTION get_iss_cd_lov(
      p_module_id       GIIS_MODULES.module_id%TYPE,
      p_user_id         GIIS_USERS.user_id%TYPE,
      p_iss_cd          GIAC_AGING_SOA_DETAILS.iss_cd%TYPE,
      p_tran_type       GIAC_PREM_DEPOSIT.transaction_type%TYPE
   )
		RETURN iss_cd_list_tab PIPELINED;
		
	FUNCTION get_ri_iss_cd_lov
		RETURN ri_iss_cd_list_tab PIPELINED;
		
	FUNCTION get_assd_name_lov(	p_assd_no	       	   	GIIS_ASSURED.assd_no%TYPE,
								p_assured_name		  	GIIS_ASSURED.assd_name%TYPE,
								p_find_text 			VARCHAR2)
		RETURN assd_name_list_tab PIPELINED;
	
	FUNCTION get_intm_name_lov(	p_intm_no	       	   	GIIS_INTERMEDIARY.intm_no%TYPE,
								p_intm_name		  		GIIS_INTERMEDIARY.intm_name%TYPE,
								p_find_text 			VARCHAR2)
		RETURN intm_name_list_tab PIPELINED;
		
	 FUNCTION get_giac_pol_no_lov (
									  /*p_policy_no     VARCHAR2,
									  p_line_cd       gipi_polbasic.line_cd%TYPE,
									  p_subline_cd    gipi_polbasic.subline_cd%TYPE,
									  p_iss_cd        gipi_polbasic.iss_cd%TYPE,
									  p_issue_yy      gipi_polbasic.issue_yy%TYPE,
									  p_pol_seq_no    gipi_polbasic.pol_seq_no%TYPE,
									  p_renew_no      gipi_polbasic.renew_no%TYPE,
									  p_assd_name     giis_assured.assd_name%TYPE,
									  p_endt_seq_no   gipi_polbasic.endt_seq_no%TYPE,*/
									  p_assd_no		  GIIS_ASSURED.assd_no%TYPE,
                                      p_user_id       VARCHAR2,
									  p_find_text     VARCHAR2
								   )
      RETURN pol_no_list_tab PIPELINED;
	  
END giac_prem_deposit_pkg;
/


