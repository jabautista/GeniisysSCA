CREATE OR REPLACE PACKAGE CPI.giis_payees_pkg
AS
    TYPE giis_payees_full_type IS RECORD(
        payee_no                   giis_payees.payee_no%TYPE,
        payee_class_cd             giis_payees.payee_class_cd%TYPE,
        payee_last_name            giis_payees.payee_last_name%TYPE,
        mail_addr1                 giis_payees.mail_addr1%TYPE,
        tin                        giis_payees.tin%TYPE,
        allow_tag                  giis_payees.allow_tag%TYPE,
        payee_first_name           giis_payees.payee_first_name%TYPE,
        payee_middle_name          giis_payees.payee_middle_name%TYPE,
        mail_addr2                 giis_payees.mail_addr2%TYPE,
        mail_addr3                 giis_payees.mail_addr3%TYPE,
        contact_pers               giis_payees.contact_pers%TYPE,
        designation                giis_payees.designation%TYPE,
        phone_no                   giis_payees.phone_no%TYPE,
        user_id                    giis_payees.user_id%TYPE,
        last_update                giis_payees.last_update%TYPE,
        remarks                    giis_payees.remarks%TYPE,
        cpi_rec_no                 giis_payees.cpi_rec_no%TYPE,
        cpi_branch_cd              giis_payees.cpi_branch_cd%TYPE,
        fax_no                     giis_payees.fax_no%TYPE,
        cp_no                      giis_payees.cp_no%TYPE,
        sun_no                     giis_payees.sun_no%TYPE,
        smart_no                   giis_payees.smart_no%TYPE,
        globe_no                   giis_payees.globe_no%TYPE,
        ref_payee_cd               giis_payees.ref_payee_cd%TYPE,
        master_payee_no            giis_payees.master_payee_no%TYPE,
        bank_cd                    giis_payees.bank_cd%TYPE,
        bank_branch                giis_payees.bank_branch%TYPE,
        bank_acct_type             giis_payees.bank_acct_type%TYPE,
        bank_acct_name     		   giis_payees.bank_acct_name%TYPE,
        bank_acct_no       		   giis_payees.bank_acct_no%TYPE,
        dsp_payee_name             VARCHAR2(3200)
        );
        
    TYPE giis_payees_full_tab IS TABLE OF giis_payees_full_type;    

   TYPE giis_payees_type IS RECORD (
      extract_id        gixx_polbasic.extract_id%TYPE,
      survey_agent_cd   gixx_polbasic.survey_agent_cd%TYPE,
      survey_agent      giis_payees.payee_last_name%TYPE,
      survey_addr       VARCHAR2 (500),
      survey_phone      giis_payees.phone_no%TYPE,
      survey_fax        giis_payees.fax_no%TYPE,
      settling_agent    giis_payees.payee_last_name%TYPE,
      settling_addr     VARCHAR2 (500),
      settling_phone    giis_payees.phone_no%TYPE,
      settling_fax      giis_payees.fax_no%TYPE
   );

   TYPE giis_payees_tab IS TABLE OF giis_payees_type;

   FUNCTION get_payee_details (p_extract_id gixx_polbasic.extract_id%TYPE)
      RETURN giis_payees_tab PIPELINED;

   TYPE payees_list_type IS RECORD (
      payee_class_cd      giis_payees.payee_class_cd%TYPE,
      payee_no            giis_payees.payee_no%TYPE,
      payee_first_name    giis_payees.payee_first_name%TYPE,
      payee_middle_name   giis_payees.payee_middle_name%TYPE,
      payee_last_name     giis_payees.payee_last_name%TYPE
   );

   TYPE payees_list_tab IS TABLE OF payees_list_type;
   
   TYPE giis_payees_list_type IS RECORD (
      payee_class_cd      GIIS_PAYEES.payee_class_cd%TYPE,
      payee_no            GIIS_PAYEES.payee_no%TYPE,
      payee_first_name    GIIS_PAYEES.payee_first_name%TYPE,
      payee_middle_name   GIIS_PAYEES.payee_middle_name%TYPE,
      payee_last_name     GIIS_PAYEES.payee_last_name%TYPE,
      designation         GIIS_PAYEES.designation%TYPE,  
      nbt_payee_name      VARCHAR2 (32000),
      mail_addr           VARCHAR2 (32000),
      phone_no            GIIS_PAYEES.phone_no%TYPE,
      contact_pers        GIIS_PAYEES.contact_pers%TYPE    
   );
   
   TYPE giis_payees_list_tab IS TABLE OF giis_payees_list_type;

   FUNCTION get_payees_list
      RETURN payees_list_tab PIPELINED;

   FUNCTION get_payees_list (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_name       VARCHAR2
   )
      RETURN payees_list_tab PIPELINED;

   FUNCTION get_payees_list (p_payee_class_cd giis_payees.payee_class_cd%TYPE)
      RETURN payees_list_tab PIPELINED;

   TYPE survey_list_type IS RECORD (
      payee_no         giis_payees.payee_no%TYPE,
      nbt_payee_name   VARCHAR2 (32000)
   );

   TYPE survey_list_tab IS TABLE OF survey_list_type;

   FUNCTION get_survey_list
      RETURN survey_list_tab PIPELINED;

   FUNCTION get_settling_list
      RETURN survey_list_tab PIPELINED;

   FUNCTION get_company_list
      RETURN survey_list_tab PIPELINED;

   TYPE employee_list_type IS RECORD (
      employee_cd     giis_payees.ref_payee_cd%TYPE,
      emp_name        VARCHAR2 (32000),
      emp_no          giis_payees.payee_no%TYPE,
      master_emp_no   giis_payees.master_payee_no%TYPE
   );

   TYPE employee_list_tab IS TABLE OF employee_list_type;

   FUNCTION get_employee_list (p_company_cd giis_payees.master_payee_no%TYPE)
      RETURN employee_list_tab PIPELINED;

   PROCEDURE get_payee_name (
      p_payee_class_cd      IN       giis_payees.payee_class_cd%TYPE,
      p_payee_no            IN       giis_payees.payee_no%TYPE,
      p_payee_first_name    OUT      giis_payees.payee_first_name%TYPE,
      p_payee_middle_name   OUT      giis_payees.payee_middle_name%TYPE,
      p_payee_last_name     OUT      giis_payees.payee_last_name%TYPE
   );

   TYPE all_payees_type IS RECORD (
      class_desc       giis_payee_class.class_desc%TYPE,
      payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   );

   TYPE all_payees_tab IS TABLE OF all_payees_type;
   
   --ADDED BY maRKS 2016
   TYPE all_payees_type_giacs240_LOV IS RECORD (
      --added by MarkS SR-5862 12.12.2016 optimization
      count_            NUMBER,
      rownum_           NUMBER,
      --SR-5862
      class_desc       giis_payee_class.class_desc%TYPE,
      payee_class_cd   giis_payee_class.payee_class_cd%TYPE
   );

   TYPE all_payees_tab_giacs240_LOV IS TABLE OF all_payees_type_giacs240_LOV;

   FUNCTION get_all_payees
      RETURN all_payees_tab PIPELINED;

   FUNCTION get_payee_class
      RETURN all_payees_tab PIPELINED;
   
   FUNCTION get_payee_class_giacs240_LOV(
      p_find_text       VARCHAR2,
      p_order_by        VARCHAR2,
      p_asc_desc_flag   VARCHAR2,
      p_from            NUMBER,
      p_to              NUMBER,
      p_search_string   VARCHAR2
      )
      RETURN all_payees_tab_giacs240_LOV PIPELINED;
   
   TYPE payee_names_by_class_cd_type IS RECORD (
      payee_last_name   giis_payees.payee_last_name%TYPE,
	  payee_name         varchar2(500), --editted by MJ for consolidation 01022012 [FROM varchar2(290)]
      address           VARCHAR2 (500),
      payee_no          giis_payees.payee_no%TYPE
   );

   TYPE payee_names_by_class_cd_tab IS TABLE OF payee_names_by_class_cd_type;

   FUNCTION get_payees_by_item_no_class_cd (
      p_payee_class_cd   giis_payee_class.payee_class_cd%TYPE,
      p_claim_id         gicl_claims.claim_id%TYPE,
      p_item_no          NUMBER
   )
      RETURN payee_names_by_class_cd_tab pipelined;

   TYPE payee_names_by_class_type IS RECORD (
      payee_last_name   giis_payees.payee_last_name%TYPE,
      address           VARCHAR2 (500),
      attention         giis_payees.contact_pers%TYPE
   );

   TYPE payee_names_by_class_tab IS TABLE OF payee_names_by_class_type;

   FUNCTION get_payee_names_by_class_desc (p_send_to_cd VARCHAR2)
      RETURN payee_names_by_class_tab PIPELINED;

   FUNCTION get_payee_by_adjuster_listing
      RETURN survey_list_tab PIPELINED;
      
   FUNCTION get_payee_by_adj_lov(p_payee GIIS_ADJUSTER.payee_name%TYPE)
      RETURN survey_list_tab PIPELINED;
      
   TYPE payee_adj_list_type IS RECORD (
      priv_adj_cd   giis_adjuster.priv_adj_cd%TYPE,
      payee_name    VARCHAR2 (32000)
   );

   TYPE payee_adj_list_tab IS TABLE OF payee_adj_list_type;
   
   TYPE payee_adjuster_list_type IS RECORD (
      priv_adj_cd     GIIS_ADJUSTER.priv_adj_cd%TYPE,
      adj_company_cd  GIIS_ADJUSTER.adj_company_cd%TYPE,
      payee_name      GIIS_ADJUSTER.payee_name%TYPE,
      adj_co_name     VARCHAR2 (32000)
   );

   TYPE payee_adjuster_list_tab IS TABLE OF payee_adjuster_list_type;
   
   TYPE payee_name_lov_desc_type IS RECORD(
    payee_no            GICL_MC_TP_DTL.payee_no%TYPE,
    payee_name          VARCHAR2(32000)
   );
   TYPE payee_name_lov_desc_tab IS TABLE OF payee_name_lov_desc_type;

   FUNCTION get_payee_by_adjuster_listing2 (
      p_adj_company_cd   giis_adjuster.adj_company_cd%TYPE,
      p_claim_id         gicl_claims.claim_id%TYPE
   )
      RETURN payee_adj_list_tab PIPELINED;
	  
   FUNCTION get_tpclaimant_lov (
		p_claim_id     GICL_CLAIMS.claim_id%TYPE,
		p_signatory    VARCHAR2
   )
		RETURN payees_list_tab PIPELINED;
        
   FUNCTION get_giis_payees_list (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_payee_name       VARCHAR2
   )
      RETURN giis_payees_list_tab PIPELINED;
      
   FUNCTION get_payee_whole_name (
        p_payee_class_cd       giis_payees.payee_class_cd%TYPE,
        p_payee_no             giis_payees.payee_no%TYPE
   ) RETURN VARCHAR2;
   
   FUNCTION get_loss_exp_payees_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_assd_no          GIIS_PAYEES.payee_no%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_find_text        VARCHAR2 --editted by steven 11/19/2012
    )

   RETURN giis_payees_list_tab PIPELINED;
   
    FUNCTION get_all_loss_exp_payees_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_assd_no          GIIS_PAYEES.payee_no%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_find_text        VARCHAR2 --editted by steven 11/19/2012
    )

   RETURN giis_payees_list_tab PIPELINED;
   
   FUNCTION get_loss_exp_mortg_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE
    )

   RETURN giis_payees_list_tab PIPELINED;
   
   FUNCTION get_loss_exp_adjuster_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_name       VARCHAR2
   )

   RETURN payee_adjuster_list_tab PIPELINED;

    TYPE lawyer_type IS RECORD(
        lawyer_cd           GIIS_PAYEES.payee_no%TYPE,
        lawyer_class_cd     GIIS_PAYEES.payee_class_cd%TYPE,
        lawyer_name         VARCHAR2(32000)
        );
	
    TYPE lawyer_tab IS TABLE OF lawyer_type;
    
    FUNCTION get_lawyer_list(
    p_lawyer VARCHAR2   ---editted by John Dolon 6/27/2013
    ) 
    RETURN lawyer_tab PIPELINED;	
     
    FUNCTION get_giis_payee_list(p_payor_class_cd       giis_payees.payee_class_cd%TYPE)
    RETURN giis_payees_full_tab PIPELINED;
	
	FUNCTION get_giis_payee_list2(p_payee_class_cd       giis_payees.payee_class_cd%TYPE)
    RETURN giis_payees_list_tab PIPELINED;
	
  	FUNCTION get_gicls259_giis_payees_list (
      p_payee_class_cd   giis_payees.payee_class_cd%TYPE,
      p_find_text        VARCHAR2)
   	RETURN giis_payees_list_tab PIPELINED;
    
    FUNCTION get_motshop_list(
      p_payee_last_name     VARCHAR2
    )
       RETURN survey_list_tab PIPELINED;
    
    FUNCTION fetch_payee_name_lov(
      P_PAYEE_CLASS_CD      VARCHAR2
   )
    RETURN payee_name_lov_desc_tab PIPELINED;
    
    FUNCTION get_gicls210_payee_lov
        RETURN payees_list_tab PIPELINED;

     FUNCTION get_all_loss_exp_adjuster_list (
     p_payee_class_cd   GIIS_PAYEES.payee_class_cd%TYPE,
     p_claim_id         GICL_CLAIMS.claim_id%TYPE,
     p_item_no          GICL_ITEM_PERIL.item_no%TYPE,
     p_peril_cd         GICL_ITEM_PERIL.peril_cd%TYPE,
     p_payee_type       GICL_LOSS_EXP_PAYEES.payee_type%TYPE,
     p_payee_name       VARCHAR2
   )

   RETURN payee_adjuster_list_tab PIPELINED;

        
END giis_payees_pkg;
/


