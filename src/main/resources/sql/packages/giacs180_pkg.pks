CREATE OR REPLACE PACKAGE CPI.GIACS180_PKG
AS

    TYPE soa_params_type IS RECORD(
        user_id           giac_soa_rep_ext_param.user_id%TYPE,
        rep_date          giac_soa_rep_ext_param.rep_date%TYPE,
        cut_off           giac_soa_rep_ext_param.param_date%TYPE,
        date_as_of        giac_soa_rep_ext_param.as_of_date%TYPE, 
--      added by gab 10.13.2016 SR 4016  
        dsp_cut_off           VARCHAR2(15),
        dsp_date_as_of        VARCHAR2(15),
--      end gab        
        date_tag          giac_soa_rep_ext_param.date_tag%TYPE,
        intm_no           giac_soa_rep_ext_param.intm_no%TYPE,
        intm_type         giac_soa_rep_ext_param.intm_type%TYPE,
        assd_no           giac_soa_rep_ext_param.assd_no%TYPE,
        special_pol       giac_soa_rep_ext_param.inc_special_pol%TYPE,
        extract_days      giac_soa_rep_ext_param.extract_aging_days%TYPE,
        branch_cd         giac_soa_rep_ext_param.branch_cd%TYPE,
        payt_date         giac_soa_rep_ext_param.PAYT_DATE%TYPE,        -- shan 02.27.2015
        
        branch_name          giis_issource.iss_name%TYPE,            -- used to display the branch name upon fetching of param branch_cd
        intm_type_desc    giis_intm_type.intm_desc%TYPE,            -- used to display the intm type desc upon fetching of param intm_type
        intm_name        giis_intermediary.intm_name%TYPE,        -- used to display the intm name upon fetching of param intm_no
        assd_name        giis_assured.assd_name%TYPE,                -- used to display the assd name upon fetching of param assd_no
        
        extract_date    giac_soa_rep_ext_param.extract_date%TYPE,
        branch_param    giac_soa_rep_ext_param.branch_param%TYPE,
        from_date1      giac_soa_rep_ext_param.from_date1%TYPE,
        to_date1        giac_soa_rep_ext_param.to_date1%TYPE,
        from_date2      giac_soa_rep_ext_param.from_date2%TYPE,
        to_date2        giac_soa_rep_ext_param.to_date2%TYPE,
        
        book_tag      VARCHAR2(1),
        incep_tag     VARCHAR2(1),
        issue_tag     VARCHAR2(1),
        book_date_fr  DATE,
        book_date_to  DATE,
        issue_date_fr DATE,
        issue_date_to DATE,
        incep_date_fr DATE,
        incep_date_to DATE,
--      added by gab 10.13.2016 SR 4016  
        dsp_book_date_fr  VARCHAR2(15),
        dsp_book_date_to  VARCHAR2(15),
        dsp_issue_date_fr VARCHAR2(15),
        dsp_issue_date_to VARCHAR2(15),
        dsp_incep_date_fr VARCHAR2(15),
        dsp_incep_date_to VARCHAR2(15),
--        end gab
        
        message       VARCHAR2(2000)
    );
    
    TYPE soa_params_tab IS TABLE OF soa_params_type;
    
    FUNCTION get_default_dates(
        p_user_id       giis_users.user_id%TYPE        
    ) RETURN soa_params_tab PIPELINED;
    
    FUNCTION get_extract_date(
        p_user_id       giis_users.user_id%TYPE ,
        p_rep_date      giac_soa_rep_ext_param.rep_date%TYPE       
    ) RETURN soa_params_tab PIPELINED;
    
    PROCEDURE extract_soa_rep_dtls(
       p_special_pol    GIAC_SOA_REP_EXT_PARAM.INC_SPECIAL_POL%TYPE,
       p_branch_cd      GIAC_SOA_REP_EXT_PARAM.branch_cd%TYPE,
       p_intm_no        GIAC_SOA_REP_EXT_PARAM.intm_no%TYPE,
       p_intm_type      GIAC_SOA_REP_EXT_PARAM.intm_type%TYPE,
       p_assd_no        GIAC_SOA_REP_EXT_PARAM.assd_no%TYPE,
       p_rep_date       GIAC_SOA_REP_EXT_PARAM.rep_date%TYPE,
       p_book_tag       VARCHAR2,
       p_book_date_fr   giac_soa_rep_ext_param.from_date1%TYPE,     
       p_book_date_to   giac_soa_rep_ext_param.to_date1%TYPE,       
       p_incep_tag      VARCHAR2,
       p_incep_date_fr  giac_soa_rep_ext_param.from_date1%TYPE,     
       p_incep_date_to  giac_soa_rep_ext_param.to_date1%TYPE,       
       p_issue_tag      VARCHAR2,
       p_issue_date_fr  giac_soa_rep_ext_param.from_date1%TYPE,     
       p_issue_date_to  giac_soa_rep_ext_param.to_date1%TYPE,       
       p_date_as_of     GIAC_SOA_REP_EXT_PARAM.as_of_date%TYPE,
       p_cut_off_date   GIAC_SOA_REP_EXT_PARAM.param_date%TYPE,
       p_inc_pdc        VARCHAR2,
       p_row_counter    OUT NUMBER,
       p_extract_days   GIAC_SOA_REP_EXT_PARAM.extract_aging_days%TYPE,          --mod1 start/end
       p_branch_param   GIAC_SOA_REP_EXT_PARAM.branch_param%TYPE,
       p_message        OUT VARCHAR2,
       p_user_id        GIAC_SOA_REP_EXT_PARAM.user_id%TYPE,
       p_payt_date      VARCHAR2        -- shan 12.09.2014
    );
    
    PROCEDURE break_taxes(
        p_user_id               giac_soa_rep_tax_ext.user_id%TYPE,
        p_cut_off_date          GIAC_SOA_REP_EXT_PARAM.param_date%TYPE,
        p_payt_date             VARCHAR2,        -- shan 04.10.2015
        p_message               OUT VARCHAR2
    );
    
    FUNCTION set_default_dates1(
        p_user_id       giac_soa_rep_ext_param.user_id%TYPE,
        p_rep_date      giac_soa_rep_ext_param.REP_DATE%type
    ) RETURN soa_params_tab PIPELINED;
    
    FUNCTION get_remarks 
        RETURN VARCHAR2;
        
    ------- used for Print Collection Letter button
    TYPE soa_detail_type IS RECORD(
        intm_no                 giac_soa_rep_ext.intm_no%TYPE,
        intm_name               giac_soa_rep_ext.intm_name%TYPE,
        assd_no                 giac_soa_rep_ext.assd_no%TYPE,
        assd_name               giac_soa_rep_ext.assd_name%TYPE,
        policy_no               giac_soa_rep_ext.policy_no%TYPE,
        policy_no2              VARCHAR2(50),   -- substr of policy_no (used in GAGT.print_intm) 
        endt_no                 VARCHAR2(50),   -- substr of policy_no (used in GAGT.print_intm)
        bill_no                 VARCHAR2(20),   -- combination of iss_cd-prem_seq_no-inst_no
        iss_cd                  giac_soa_rep_ext.iss_cd%TYPE,
        prem_seq_no             giac_soa_rep_ext.prem_seq_no%TYPE,
        inst_no                 giac_soa_rep_ext.inst_no%TYPE,
        aging_id                giac_soa_rep_ext.aging_id%TYPE,
        column_title            giac_soa_rep_ext.column_title%TYPE,
        balance_amt_due         giac_soa_rep_ext.balance_amt_due%TYPE,
        prem_bal_due            giac_soa_rep_ext.prem_bal_due%TYPE,
        tax_bal_due             giac_soa_rep_ext.tax_bal_due%TYPE,
        --total_amt_due           NUMBER(20,2),    -- sum of balance_amt_due
        inc_tag                 VARCHAR2(1),     -- flag to identify if row is checked or not.
        
        -- used in filterByAging
        fund_cd                 GIAC_AGING_TOTALS_INTM_V.gibr_gfun_fund_cd%TYPE,
        branch_cd               GIAC_AGING_TOTALS_INTM_V.gibr_branch_cd%TYPE,
        aging_bal_amt_due       GIAC_AGING_TOTALS_INTM_V.balance_amt_due%TYPE,
        aging_prem_bal_due      GIAC_AGING_TOTALS_INTM_V.prem_balance_due%TYPE,
        aging_tax_bal_due       GIAC_AGING_TOTALS_INTM_V.tax_balance_due%TYPE,
        age_level               giac_aging_parameters.column_heading%TYPE,
        
        -- used in Reprint Collection Letter
        coll_let_no             giac_colln_letter.coll_let_no%TYPE,
        coll_seq_no             giac_colln_letter.coll_seq_no%TYPE,
        coll_year               giac_colln_letter.coll_year%TYPE,
        user_id                 giac_colln_letter.user_id%TYPE,
        last_update             giac_colln_letter.last_update%TYPE,
        last_update2            VARCHAR2(200)
    );
    
    TYPE soa_detail_tab IS TABLE OF soa_detail_type;
    
    FUNCTION get_intm_gsoa_dtl(
        p_intm_no      GIIS_INTERMEDIARY.INTM_NO%TYPE,
        p_user_id      giis_users.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED;
    
    FUNCTION get_assd_gsoa_dtl(
        p_assd_no      GIIS_ASSURED.assd_no%TYPE,
        p_user_id      giis_users.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED;    
    
    FUNCTION get_aging_intm_list (p_user_id VARCHAR2)
      RETURN soa_detail_tab PIPELINED;
    
    FUNCTION get_aging_assd_list (p_user_id VARCHAR2)
      RETURN soa_detail_tab PIPELINED;
    
    FUNCTION get_list_all_aging (
        p_user_id           VARCHAR2,
        p_view_type         VARCHAR2,
        p_index             NUMBER,
        p_intm_no           giac_soa_rep_ext.INTM_NO%type,
        p_intm_name         giac_soa_rep_ext.INTM_NAME%type,
        p_assd_no           giac_soa_rep_ext.ASSD_NO%type,
        p_assd_name         giac_soa_rep_ext.ASSD_NAME%type,
        p_balance_amt_due   giac_soa_rep_ext.BALANCE_AMT_DUE%type
    ) RETURN soa_detail_tab PIPELINED;
    
    FUNCTION get_aging_totals_intm(
        p_intm_no       GIAC_AGING_TOTALS_INTM_V.intm_no%TYPE,
        p_user_id       VARCHAR2
    ) RETURN soa_detail_tab PIPELINED;
    
    FUNCTION get_aging_totals_assd(
        p_assd_no       GIAC_AGING_TOTALS_ASSD_V.assd_no%TYPE,
        p_user_id       VARCHAR2
    ) RETURN soa_detail_tab PIPELINED;
    
    -- saves the collection letter parameters before calling the report
    -- GIACR410
    PROCEDURE populate_parameters(
        p_iss_cd                  giac_soa_rep_ext.iss_cd%TYPE,
        p_prem_seq_no             giac_soa_rep_ext.prem_seq_no%TYPE,
        p_inst_no                 giac_soa_rep_ext.inst_no%TYPE,
        p_balance_amt_due         giac_soa_rep_ext.balance_amt_due%TYPE,
        p_coll_let_no             OUT giac_colln_letter.coll_let_no%TYPE
    );
    
    /*FUNCTION process_intm_assd(
        p_view_type         VARCHAR2
    ) RETURN VARCHAR2;*/
    
    FUNCTION process_intm_assd2(
        p_view_type     VARCHAR2,
        p_assd_no       giac_soa_rep_ext.assd_no%TYPE,
        p_intm_no       giac_soa_rep_ext.intm_no%TYPE,
        p_aging_id      giac_soa_rep_ext.aging_id%TYPE,
        p_user_id       giac_soa_rep_ext.user_id%TYPE,
        p_assd_no_list  VARCHAR2,
        p_intm_no_list  VARCHAR2,
        p_aging_id_list VARCHAR2,
        p_from_button   VARCHAR2
    ) RETURN VARCHAR2; -- soa_detail_tab PIPELINED;
    
    FUNCTION get_colln_letter(
        p_user_id           giac_colln_letter.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED;

    FUNCTION fetch_parameters(
        p_iss_cd                  giac_soa_rep_ext.iss_cd%TYPE,
        p_prem_seq_no             giac_soa_rep_ext.prem_seq_no%TYPE,
        p_inst_no                 giac_soa_rep_ext.inst_no%TYPE,
        p_user_id                 giac_soa_rep_ext.user_id%TYPE
    ) RETURN soa_detail_tab PIPELINED;
    
    FUNCTION check_user_data(
        p_user_id           GIAC_SOA_REP_EXT.user_id%TYPE
    ) RETURN VARCHAR2;
    
    PROCEDURE check_existing_report(
        p_report_id       giis_reports.report_id%TYPE
    );
    
    FUNCTION check_user_child_records(
        p_pdc_ext       VARCHAR2,
        p_user_id       GIAC_SOA_REP_EXT.user_id%TYPE
    ) RETURN VARCHAR2;
    
    TYPE giis_assured_type IS RECORD(
      assd_no         GIIS_ASSURED.assd_no%TYPE,
      assd_name       GIIS_ASSURED.assd_name%TYPE
    );

    TYPE giis_assured_tab IS TABLE OF giis_assured_type;

    FUNCTION get_giis_assured(
        p_user_id       VARCHAR2  
    )RETURN giis_assured_tab PIPELINED;
        
    TYPE intm_list_type IS RECORD(
        intm_no        GIIS_INTERMEDIARY.intm_no%TYPE,
        intm_name      GIIS_INTERMEDIARY.intm_name%TYPE
    );    
  
    TYPE intm_list_tab IS TABLE OF intm_list_type;
    
    FUNCTION get_giacs180_intm_lov(
        p_user_id       VARCHAR2
   ) RETURN intm_list_tab PIPELINED;
   
   
   -------------------------------------------
    TYPE v_list IS TABLE OF CLOB INDEX BY PLS_INTEGER;   -- stores selected assd/intm
    v_nt    v_list;
        
    
    FUNCTION add_to_collection(
        p_is_new_item   VARCHAR2,
        p_index         NUMBER,
        p_str           VARCHAR2
    ) RETURN NUMBER;
    
    
    FUNCTION get_coll_element(
        p_index     NUMBER
    ) RETURN CLOB;
    
    
    FUNCTION clob_to_table(
        p_value     clob,
        p_delimiter VARCHAR2
    ) RETURN sys.odcivarchar2list PIPELINED;
    
    
    PROCEDURE delete_coll_element(
        p_index     NUMBER
    );

END GIACS180_PKG;
/
