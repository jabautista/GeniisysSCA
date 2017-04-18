CREATE OR REPLACE PACKAGE CPI.GIACS044_PKG AS

    TYPE method_list_type IS RECORD(
        procedure_id       giac_deferred_procedures.procedure_id%TYPE,
        procedure_desc     giac_deferred_procedures.procedure_desc%TYPE
    );
    
    TYPE method_list_tab IS TABLE OF method_list_type;
    
    TYPE gd_gross_type IS RECORD(
        year               giac_deferred_extract.year%TYPE,
        mm                 VARCHAR2(20), --mikel 02.04.2016 changed from 12 to 20
        procedure_desc     giac_deferred_procedures.procedure_desc%TYPE,
        numerator_factor   VARCHAR2(4),
        denominator_factor VARCHAR2(4),
        iss_cd             giac_deferred_gross_prem.iss_cd%TYPE,
        line_cd            giac_deferred_gross_prem.line_cd%TYPE,
        prem_amt           giac_deferred_gross_prem.prem_amt%TYPE,
        def_prem_amt       giac_deferred_gross_prem.def_prem_amt%TYPE,
        prev_def_prem_amt  giac_deferred_gross_prem.prev_def_prem_amt%TYPE,
        def_prem_amt_diff  giac_deferred_gross_prem.def_prem_amt_diff%TYPE,
        user_id            giac_deferred_gross_prem.user_id%TYPE,
        last_update        VARCHAR2(10),
        line_name          giis_line.line_name%TYPE,
        iss_name           giis_issource.iss_name%TYPE,
        policy_no          giac_deferred_gross_prem_pol.policy_no%TYPE,
        eff_date           VARCHAR2(10),
        expiry_date        VARCHAR2(10),
        comp_sw            giac_deferred_gross_prem.comp_sw%TYPE --mikel 02.26.2016 GENQA 5288  
    );
    
    TYPE gd_gross_tab IS TABLE OF gd_gross_type;
    
    TYPE gd_ri_ceded_type IS RECORD(
        year               giac_deferred_extract.year%TYPE,
        mm                 VARCHAR2(20), --mikel 02.04.2016 changed from 12 to 20
        procedure_desc     giac_deferred_procedures.procedure_desc%TYPE,
        numerator_factor   VARCHAR2(4),
        denominator_factor VARCHAR2(4),
        iss_cd             giac_deferred_ri_prem_ceded.iss_cd%TYPE,
        line_cd            giac_deferred_ri_prem_ceded.line_cd%TYPE,
        share_type         VARCHAR2(50),
        dist_prem          giac_deferred_ri_prem_ceded.dist_prem%TYPE,
        def_dist_prem      giac_deferred_ri_prem_ceded.def_dist_prem%TYPE,
        prev_def_dist_prem giac_deferred_ri_prem_ceded.prev_def_dist_prem%TYPE,
        def_dist_prem_diff giac_deferred_ri_prem_ceded.def_dist_prem_diff%TYPE,
        user_id            giac_deferred_ri_prem_ceded.user_id%TYPE,
        last_update        VARCHAR2(10),
        line_name          giis_line.line_name%TYPE,
        iss_name           giis_issource.iss_name%TYPE,
        shr_type           giac_deferred_ri_prem_cede_dtl.share_type%TYPE,
        policy_no          giac_deferred_gross_prem_pol.policy_no%TYPE,
        eff_date           VARCHAR2(10),
        expiry_date        VARCHAR2(10),
        comp_sw            giac_deferred_gross_prem.comp_sw%TYPE --mikel 02.26.2016 GENQA 5288 
    );
    
    TYPE gd_ri_ceded_tab IS TABLE OF gd_ri_ceded_type; 

    TYPE gd_inc_type IS RECORD(
        year               giac_deferred_extract.year%TYPE,
        mm                 VARCHAR2(20), --mikel 02.04.2016 changed from 12 to 20
        procedure_desc     giac_deferred_procedures.procedure_desc%TYPE,
        numerator_factor   VARCHAR2(4),
        denominator_factor VARCHAR2(4),
        iss_cd             giac_deferred_comm_income.iss_cd%TYPE,
        line_cd            giac_deferred_comm_income.line_cd%TYPE,
        share_type         VARCHAR2(50),
        comm_income        giac_deferred_comm_income.comm_income%TYPE,
        def_comm_income    giac_deferred_comm_income.def_comm_income%TYPE,
        prev_def_comm_income giac_deferred_comm_income.prev_def_comm_income%TYPE,
        def_comm_income_diff giac_deferred_comm_income.def_comm_income_diff%TYPE,
        user_id            giac_deferred_comm_income.user_id%TYPE,
        last_update        VARCHAR2(10),
        line_name          giis_line.line_name%TYPE,
        iss_name           giis_issource.iss_name%TYPE,
        shr_type           giac_deferred_ri_prem_cede_dtl.share_type%TYPE,
        policy_no          giac_deferred_gross_prem_pol.policy_no%TYPE,
        eff_date           VARCHAR2(10),
        expiry_date        VARCHAR2(10),
        comp_sw            giac_deferred_gross_prem.comp_sw%TYPE --mikel 02.26.2016 GENQA 5288         
    );
    
    TYPE gd_inc_tab IS TABLE OF gd_inc_type;      
     
    TYPE gd_exp_type IS RECORD(
        year                    giac_deferred_extract.year%TYPE,
        mm                 VARCHAR2(20), --mikel 02.04.2016 changed from 12 to 20
        procedure_desc          giac_deferred_procedures.procedure_desc%TYPE,
        numerator_factor        VARCHAR2(4),
        denominator_factor      VARCHAR2(4),
        iss_cd                  giac_deferred_comm_expense.iss_cd%TYPE,
        line_cd                 giac_deferred_comm_expense.line_cd%TYPE,
        comm_expense            giac_deferred_comm_expense.comm_expense%TYPE,
        def_comm_expense        giac_deferred_comm_expense.def_comm_expense%TYPE,
        prev_def_comm_expense   giac_deferred_comm_expense.prev_def_comm_expense%TYPE,
        def_comm_expense_diff   giac_deferred_comm_expense.def_comm_expense_diff%TYPE,
        user_id                 giac_deferred_comm_expense.user_id%TYPE,
        last_update             VARCHAR2(10),
        line_name               giis_line.line_name%TYPE,
        iss_name                giis_issource.iss_name%TYPE,
        policy_no               giac_deferred_gross_prem_pol.policy_no%TYPE,
        eff_date                VARCHAR2(10),
        expiry_date             VARCHAR2(10),
        comp_sw            giac_deferred_gross_prem.comp_sw%TYPE --mikel 02.26.2016 GENQA 5288         
    );
    
    TYPE gd_exp_tab IS TABLE OF gd_exp_type;
    
    TYPE gd_net_prem_type IS RECORD(
        year                giac_deferred_extract.year%TYPE,
        mm                 VARCHAR2(20), --mikel 02.04.2016 changed from 12 to 20
        procedure_desc      giac_deferred_procedures.procedure_desc%TYPE,
        numerator_factor    VARCHAR2(4),
        denominator_factor  VARCHAR2(4),
        iss_cd              giac_deferred_net_prem_v.iss_cd%TYPE,
        line_cd             giac_deferred_net_prem_v.line_cd%TYPE,
        gross_prem          giac_deferred_net_prem_v.gross_prem%TYPE,
        total_ri_ceded      giac_deferred_net_prem_v.total_ri_ceded%TYPE,
        net_prem            giac_deferred_net_prem_v.net_prem%TYPE,
        user_id             giac_deferred_net_prem_v.user_id%TYPE,
        last_update         VARCHAR2(10)
    );
    
    TYPE gd_net_prem_tab IS TABLE OF gd_net_prem_type; 

    TYPE extract_hist_type IS RECORD(
        year                giac_deferred_extract.year%TYPE,
        mm                  giac_deferred_extract.mm%TYPE,
        user_id             giac_deferred_extract.user_id%TYPE,
        last_extract        VARCHAR2(50),
        procedure_desc      giac_deferred_procedures.procedure_desc%TYPE,
        gen_user            giac_deferred_extract.gen_user%TYPE,
        gen_date            VARCHAR2(50),
        gen_tag             giac_deferred_extract.gen_tag%TYPE      
    );
    
    TYPE extract_hist_tab IS TABLE OF extract_hist_type;  
    
    TYPE acct_entries_type IS RECORD(
        gl_acct_code        VARCHAR2 (500),
        sl_cd               giac_acct_entries.sl_cd%TYPE,
        debit_amt           giac_acct_entries.debit_amt%TYPE,
        credit_amt          giac_acct_entries.credit_amt%TYPE,
        debit_amt_total     giac_acct_entries.debit_amt%TYPE,
        credit_amt_total    giac_acct_entries.credit_amt%TYPE,
        gl_acct_name        giac_chart_of_accts.gl_acct_name%TYPE,
        sl_name             giac_sl_lists.sl_name%TYPE,
        remarks             giac_acct_entries.remarks%TYPE,
        user_id             giac_acct_entries.user_id%TYPE,
        last_update         VARCHAR2(50),
        tran_date           VARCHAR2(50),
        year_gen            VARCHAR2(50),
        mm_gen              VARCHAR2(50),
        fund_cd             VARCHAR2(10),
        branch_cd           VARCHAR2(10),
        gacc_tran_id        giac_acct_entries.gacc_tran_id%TYPE
    );       
    
    TYPE acct_entries_tab IS TABLE OF acct_entries_type;
    
    TYPE branch_list_type IS RECORD(
        include_tag         VARCHAR(1),
        branch_cd           giac_branches.branch_cd%TYPE,
        branch_name         giac_branches.branch_name%TYPE 
    );
    
    TYPE branch_list_tab IS TABLE OF branch_list_type;

    FUNCTION check_iss(
        p_user_id       giis_users.user_id%TYPE
    )
        RETURN VARCHAR2;
    
    FUNCTION get_method_list
        RETURN method_list_tab PIPELINED;
        
    FUNCTION check_data_extracted(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
        RETURN VARCHAR2;
    
    FUNCTION check_gen_tag(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
        RETURN VARCHAR2;
    
    FUNCTION check_status(
        p_year  giac_deferred_extract.year%TYPE,
        p_mm    giac_deferred_extract.mm%TYPE 
    )
        RETURN VARCHAR2;

    PROCEDURE set_tran_flag(
        p_year  giac_deferred_extract.year%TYPE,
        p_mm    giac_deferred_extract.mm%TYPE
    );
    
    PROCEDURE call_deferred_procedures(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_msg       OUT VARCHAR
    );
    
    FUNCTION get_gd_gross(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_gross_tab PIPELINED;
        
    FUNCTION get_gd_ri_ceded(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED;

    FUNCTION get_gd_inc(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_inc_tab PIPELINED;       
               
    FUNCTION get_gd_exp(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_exp_tab PIPELINED; 

    FUNCTION get_gd_net_prem(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_net_prem_tab PIPELINED;       

    FUNCTION get_gd_retrocede(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_extract.procedure_id%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED;          
    
    FUNCTION get_extract_hist(
        p_fund_cd          giac_deferred_procedures.fund_cd%TYPE
    )
        RETURN extract_hist_tab PIPELINED;

    FUNCTION get_gd_gross_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
    )
        RETURN gd_gross_tab PIPELINED;
        
    FUNCTION get_gd_ri_ceded_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giac_deferred_ri_prem_cede_dtl.share_type%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED;        

    FUNCTION get_gd_inc_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giac_deferred_comm_income_dtl.share_type%TYPE
    )
        RETURN gd_inc_tab PIPELINED;  

    FUNCTION get_gd_exp_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE
    )
        RETURN gd_exp_tab PIPELINED;         

    FUNCTION get_gd_retrocede_dtl(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_iss_cd        giis_issource.iss_cd%TYPE,
        p_line_cd       giis_line.line_cd%TYPE,
        p_share_type    giac_deferred_ri_prem_cede_dtl.share_type%TYPE
    )
        RETURN gd_ri_ceded_tab PIPELINED;

    FUNCTION check_last_compute(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    )
        RETURN VARCHAR2;
        
    PROCEDURE deferred_compute_straight(
        p_year   NUMBER, 
        p_mm     NUMBER, 
        p_method NUMBER
    );
    
    PROCEDURE call_deferred_compute(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    );
    
    PROCEDURE compute_amounts(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE
    );
    
    PROCEDURE cancel_acct_entries(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_msg       OUT VARCHAR2
    );    
  
    PROCEDURE aeg_chk_chrt_of_accts_giacs044(
        cca_gl_acct_category    GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
        cca_gl_control_acct     GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
        cca_gl_sub_acct_1       GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
        cca_gl_sub_acct_2       GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
        cca_gl_sub_acct_3       GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
        cca_gl_sub_acct_4       GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
        cca_gl_sub_acct_5       GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
        cca_gl_sub_acct_6       GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
        cca_gl_sub_acct_7       GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
        cca_gl_acct_id   IN OUT GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE,    
        p_msg               OUT VARCHAR2
    );
    
    PROCEDURE aeg_check_level_giacs044(
        cl_level         IN NUMBER,
        cl_value         IN NUMBER,
        cl_sub_acct1 IN OUT NUMBER,
        cl_sub_acct2 IN OUT NUMBER,
        cl_sub_acct3 IN OUT NUMBER,
        cl_sub_acct4 IN OUT NUMBER,
        cl_sub_acct5 IN OUT NUMBER,
        cl_sub_acct6 IN OUT NUMBER,
        cl_sub_acct7 IN OUT NUMBER    
    );

    PROCEDURE aeg_gen_acctran_entry_giacs044(
        p_tran_id         OUT NUMBER,
        p_tran_class      IN  VARCHAR2,
        p_gfun_fund_cd    IN  VARCHAR2,
        p_gibr_branch_cd  IN  VARCHAR2,
        p_tran_date       IN  VARCHAR2,
        p_year            IN  giac_deferred_extract.year%TYPE,
        p_mm              IN  giac_deferred_extract.mm%TYPE,
        p_user_id         IN  giac_users.user_id%TYPE,
        p_msg             OUT VARCHAR2
    );
    
    PROCEDURE aeg_gen_acct_entries_giacs044(
        p_tran_id        IN  NUMBER,
        p_fund_cd        IN  VARCHAR2,
        p_branch_cd      IN  VARCHAR2,
        p_line_cd        IN  VARCHAR2,
        p_sl_cd          IN  NUMBER,       	
        p_amount         IN  NUMBER,
        p_item_no        IN  NUMBER,
        p_tran_flag      IN  VARCHAR2,
        p_dr_cr_flag     IN  VARCHAR2,
        p_acct_trty_type IN  NUMBER,
        p_module_id      IN  VARCHAR2,
        p_user_id        IN  giac_users.user_id%TYPE,
        p_msg            OUT VARCHAR2
    );
    
    PROCEDURE reverse_posted_trans(
        p_year       IN  giac_deferred_extract.year%TYPE,
        p_mm         IN  giac_deferred_extract.mm%TYPE,
        p_tran_date  IN  VARCHAR2,
        p_user_id    IN  giac_users.user_id%TYPE,       
        p_msg        OUT VARCHAR2
    );
    
    PROCEDURE gen_acct_entries_gross(
        p_year         IN  giac_deferred_extract.year%TYPE,
        p_mm           IN  giac_deferred_extract.mm%TYPE,
        p_tran_date    IN  VARCHAR2,        
        p_user_id      IN  giac_users.user_id%TYPE,         
        p_procedure_id IN  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id    IN  VARCHAR2,
        p_msg          OUT VARCHAR2             
    );
    
    PROCEDURE gen_acct_entries_ri_prem(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_tran_date     VARCHAR2,        
        p_user_id       giac_users.user_id%TYPE,         
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id     VARCHAR2,
        p_msg       OUT VARCHAR2          
    );
    
    PROCEDURE gen_acct_entries_comm_inc(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_tran_date     VARCHAR2,        
        p_user_id       giac_users.user_id%TYPE,         
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id     VARCHAR2,
        p_msg       OUT VARCHAR2        
    );    

    PROCEDURE gen_acct_entries_comm_exp(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_tran_date     VARCHAR2,        
        p_user_id       giac_users.user_id%TYPE,         
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_module_id     VARCHAR2,
        p_msg       OUT VARCHAR2         
    );
    
    PROCEDURE set_gen_tag(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_user_id       giac_users.user_id%TYPE,
        p_msg       OUT VARCHAR2
    );
    
    FUNCTION get_acct_entries(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_table         VARCHAR2        
    )
        RETURN acct_entries_tab PIPELINED;
        
    FUNCTION get_gl_summary(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_procedure_id  giac_deferred_procedures.procedure_id%TYPE,
        p_table         VARCHAR2        
    )
        RETURN acct_entries_tab PIPELINED;

    FUNCTION get_branch_list(
        p_year          giac_deferred_extract.year%TYPE,
        p_mm            giac_deferred_extract.mm%TYPE,
        p_user_id       giac_deferred_extract.user_id%TYPE
    )
        RETURN branch_list_tab PIPELINED;
            
                                                              
END GIACS044_PKG; 
/

