CREATE OR REPLACE PACKAGE CPI.gipi_installment_pkg
AS
/******************************************************************************
   NAME:       GIPI_INSTALLMENT_PKG
   PURPOSE:

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        8/18/2010    ANTHONY SANTOS   Created checkInstNo for GIAC007 check_instno
******************************************************************************/
 TYPE gipi_installment_list_type IS RECORD (
 	  prem_seq_no gipi_installment.prem_seq_no%TYPE,
 	  iss_cd gipi_installment.iss_cd%TYPE,
	  due_date gipi_installment.due_date%TYPE 
 );
 
 TYPE gipi_installment_tab IS TABLE OF gipi_installment_list_type;
/*
   FUNCTION checkinstno (
      p_prem_seq_no   gipi_installment.prem_seq_no%TYPE,
      p_iss_cd        gipi_installment.iss_cd%TYPE
   )
      RETURN NUMBER;*/
	  
   FUNCTION get_date_due(p_inst_no gipi_installment.prem_seq_no%TYPE,
   						 p_prem_seq_no   gipi_installment.prem_seq_no%TYPE,
						 p_iss_cd        gipi_installment.iss_cd%TYPE,
						 p_tran_date     varchar2)
      RETURN NUMBER;
	  
 TYPE gipi_installment_list_type2 IS RECORD (
 	  prem_seq_no gipi_installment.prem_seq_no%TYPE,
	  iss_cd 	  gipi_installment.iss_cd%TYPE,
	  inst_no	  gipi_installment.inst_no%TYPE
 );	  	  
 
 TYPE gipi_installment_inst_no_tab IS TABLE OF gipi_installment_list_type2;
 
   FUNCTION get_inst_no_list(p_iss_cd 	    gipi_installment.iss_cd%TYPE,
   							 p_prem_seq_no  gipi_installment.prem_seq_no%TYPE)
	  RETURN gipi_installment_inst_no_tab PIPELINED;
      
/**
* Rey Jadlocon
* 08.05.2011
* payment schedule
**/
 TYPE payment_schedule_type IS RECORD(
    total_shr          GIPI_INSTALLMENT.SHARE_PCT%TYPE,
    total_prem         GIPI_INSTALLMENT.PREM_AMT%TYPE,
    total_tax          GIPI_INSTALLMENT.TAX_AMT%TYPE,
    total_tax_due      GIPI_INSTALLMENT.TAX_AMT%TYPE,
    inst_no            GIPI_INSTALLMENT.INST_NO%TYPE,
    due_date           GIPI_INSTALLMENT.DUE_DATE%TYPE,
    share_pct          GIPI_INSTALLMENT.SHARE_PCT%TYPE,
    prem_amt           GIPI_INSTALLMENT.PREM_AMT%TYPE,
    total_due          GIPI_INSTALLMENT.PREM_AMT%TYPE,
    tax_amt            GIPI_INSTALLMENT.TAX_AMT%TYPE,
    str_due_date       VARCHAR(50) -- added by: Angelo 04.22.2014
);

    TYPE payment_schedule_tab IS TABLE OF payment_schedule_type;
    
	FUNCTION get_payment_schedule(
		p_policy_id  GIPI_POLBASIC.policy_id%TYPE,
		p_item_no	 GIPI_ITEM.item_no%TYPE,
		p_item_grp	 GIPI_ITEM.item_grp%TYPE
	)
      RETURN payment_schedule_tab PIPELINED;

PROCEDURE get_unpaid_premiums_dtls (
      p_line_cd               gicl_claims.line_cd%TYPE,
      p_subline_cd            gicl_claims.subline_cd%TYPE,
      p_pol_iss_cd            gicl_claims.pol_iss_cd%TYPE,
      p_issue_yy              gicl_claims.issue_yy%TYPE,
      p_pol_seq_no            gicl_claims.pol_seq_no%TYPE,
      p_renew_no              gicl_claims.renew_no%TYPE,
      p_iss_cd                gicl_claims.iss_cd%TYPE,
      p_clm_file_date         varchar2,
      p_prem_seq_no     OUT   gipi_invoice.prem_seq_no%TYPE,
      p_balance_amt_due OUT   giac_aging_soa_details.balance_amt_due%TYPE,
      p_curr_type       OUT   varchar2,
      p_validate_unpaid OUT   varchar2,
      p_message         OUT   VARCHAR2
);        

    PROCEDURE chk_inst_no_giacs007 (
        p_iss_cd             IN giac_direct_prem_collns.b140_iss_cd%TYPE,
        p_prem_seq_no        IN giac_direct_prem_collns.b140_prem_seq_no%TYPE,
        p_inst_no            IN OUT giac_direct_prem_collns.inst_no%TYPE,
        p_mesg               OUT VARCHAR2
    );
    
    TYPE invoice_payterm_type IS RECORD(
        iss_cd          gipi_installment.iss_cd%TYPE,
        prem_seq_no     gipi_installment.prem_seq_no%TYPE,
        item_grp        gipi_installment.item_grp%TYPE,
        inst_no         gipi_installment.inst_no%TYPE,
        share_pct       gipi_installment.share_pct%TYPE,
        tax_amt         gipi_installment.tax_amt%TYPE,
        prem_amt        gipi_installment.prem_amt%TYPE,
        due_date        VARCHAR2(50) --gipi_installment.due_date%TYPE --VARCHAR2(50)
    );
    
    TYPE invoice_payterm_tab IS TABLE OF invoice_payterm_type;
    
    FUNCTION get_invoice_payterm(
        p_iss_cd        gipi_installment.iss_cd%TYPE,
        p_prem_seq_no   gipi_installment.prem_seq_no%TYPE,
        p_item_grp      gipi_installment.item_grp%TYPE
    ) RETURN invoice_payterm_tab PIPELINED;

END gipi_installment_pkg;
/


