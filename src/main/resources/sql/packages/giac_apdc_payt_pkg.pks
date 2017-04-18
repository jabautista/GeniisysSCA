CREATE OR REPLACE PACKAGE CPI.giac_apdc_payt_pkg
AS

   TYPE giac_apdc_payt_type IS RECORD (
         apdc_id                GIAC_APDC_PAYT.apdc_id%TYPE,
      fund_cd                GIAC_APDC_PAYT.fund_cd%TYPE,
      branch_cd                GIAC_APDC_PAYT.branch_cd%TYPE,
      apdc_date                GIAC_APDC_PAYT.apdc_date%TYPE,
      apdc_pref                GIAC_APDC_PAYT.apdc_pref%TYPE,
      apdc_no                GIAC_APDC_PAYT.apdc_no%TYPE,
      cashier_cd            GIAC_APDC_PAYT.cashier_cd%TYPE,
      payor                    GIAC_APDC_PAYT.payor%TYPE,
      apdc_flag                GIAC_APDC_PAYT.apdc_flag%TYPE,
      apdc_flag_meaning        CG_REF_CODES.rv_meaning%TYPE,
      user_id                GIAC_APDC_PAYT.user_id%TYPE,
      last_update            GIAC_APDC_PAYT.last_update%TYPE,
      particulars            GIAC_APDC_PAYT.particulars%TYPE,
      ref_apdc_no            GIAC_APDC_PAYT.ref_apdc_no%TYPE,
      cic_print_tag            GIAC_APDC_PAYT.cic_print_tag%TYPE,
      address_1                GIAC_APDC_PAYT.address_1%TYPE,
      address_2                GIAC_APDC_PAYT.address_2%TYPE,
      address_3                GIAC_APDC_PAYT.address_3%TYPE
   );
   
   TYPE giac_apdc_payt_tab IS TABLE OF giac_apdc_payt_type;
   
   FUNCTION get_giac_apdc_payt(p_apdc_id GIAC_APDC_PAYT.apdc_id%TYPE)
     RETURN giac_apdc_payt_tab PIPELINED;
   
   PROCEDURE pop_apdc(
       p_fund_cd        IN        GIAC_BRANCHES.gfun_fund_cd%TYPE,
          p_branch_cd        IN        GIAC_BRANCHES.branch_cd%TYPE,
       p_apdc_flag        IN        GIAC_APDC_PAYT.apdc_flag%TYPE,
       p_doc_pref_suf    OUT        GIAC_DOC_SEQUENCE.doc_pref_suf%TYPE,
       p_dsp_status        OUT        VARCHAR2,
       p_default_currency OUT   GIIS_CURRENCY.main_currency_cd%TYPE,       
       p_or_particulars_text OUT GIAC_PARAMETERS.param_value_v%TYPE,
       p_prem_tax_priority OUT  GIAC_PARAMETERS.param_value_v%TYPE
    );
    
    PROCEDURE set_giac_apdc_payt(
       p_apdc_id                 GIAC_APDC_PAYT.apdc_id%TYPE,
       p_fund_cd                 GIAC_APDC_PAYT.fund_cd%TYPE,
       p_branch_cd                 GIAC_APDC_PAYT.branch_cd%TYPE,
       p_apdc_date                 GIAC_APDC_PAYT.apdc_date%TYPE,
       p_apdc_pref                 GIAC_APDC_PAYT.apdc_pref%TYPE,
       p_apdc_no                 GIAC_APDC_PAYT.apdc_no%TYPE,
       p_cashier_cd                 GIAC_APDC_PAYT.cashier_cd%TYPE,
       p_payor                     GIAC_APDC_PAYT.payor%TYPE,
       p_apdc_flag                 GIAC_APDC_PAYT.apdc_flag%TYPE,
       p_particulars             GIAC_APDC_PAYT.particulars%TYPE,
       p_ref_apdc_no             GIAC_APDC_PAYT.ref_apdc_no%TYPE,
       p_address_1                 GIAC_APDC_PAYT.address_1%TYPE,
       p_address_2                 GIAC_APDC_PAYT.address_2%TYPE,
       p_address_3                 GIAC_APDC_PAYT.address_3%TYPE,
       p_cic_print_tag             GIAC_APDC_PAYT.cic_print_tag%TYPE
    );
    
    PROCEDURE delete_giac_apdc_payt (
       p_apdc_id            GIAC_APDC_PAYT.apdc_id%TYPE
    );
    
    FUNCTION verify_apdc_no(
        p_apdc_no            GIAC_APDC_PAYT.apdc_no%TYPE,
        p_apdc_pref            GIAC_APDC_PAYT.apdc_pref%TYPE,
        p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
        p_fund_cd            GIAC_BRANCHES.gfun_fund_cd%TYPE
    ) RETURN VARCHAR2;
    
    PROCEDURE get_doc_seq_no(
        p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
        p_fund_cd            GIAC_BRANCHES.gfun_fund_cd%TYPE,
        p_doc_seq_no        OUT GIAC_APDC_PAYT.apdc_no%TYPE
    );
    
    PROCEDURE save_print_changes(
        p_apdc_id                 GIAC_APDC_PAYT.apdc_id%TYPE,
        p_apdc_no                 GIAC_APDC_PAYT.apdc_no%TYPE,
        p_new_seq_no             GIAC_DOC_SEQUENCE.doc_seq_no%TYPE,
        p_branch_cd                 GIAC_BRANCHES.branch_cd%TYPE,
        p_fund_cd                 GIAC_BRANCHES.gfun_fund_cd%TYPE,
        p_cic_print_tag         giac_apdc_payt.cic_print_tag%TYPE
    );
    FUNCTION get_apdc_ref_no(
        p_tran_id                giac_acctrans.tran_id%TYPE
    ) RETURN VARCHAR2;
   
   FUNCTION get_giac_apdc_payt_listing(
         p_fund_cd                GIAC_BRANCHES.gfun_fund_cd%TYPE,
         p_branch_cd            GIAC_BRANCHES.branch_cd%TYPE,
         p_apdc_date            VARCHAR2,
      p_apdc_no             VARCHAR2,
      p_payor               VARCHAR2,
      p_ref_apdc_no         VARCHAR2,
      p_particulars         VARCHAR2,
      p_status              VARCHAR2,
      p_apdc_flag           giac_apdc_payt.apdc_flag%TYPE --benjo 11.08.2016 SR-5802
   )RETURN giac_apdc_payt_tab PIPELINED;   
   
   PROCEDURE cancel_apdc_payt(p_apdc_id IN GIAC_APDC_PAYT.apdc_id%TYPE);
   
   PROCEDURE giacs090_post_commit(p_apdc_id GIAC_APDC_PAYT.apdc_id%TYPE);
   
END giac_apdc_payt_pkg;
/


