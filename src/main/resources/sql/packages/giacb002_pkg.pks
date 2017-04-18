CREATE OR REPLACE PACKAGE CPI.GIACB002_PKG
AS 

   PROCEDURE re_take_up (p_prod_date       IN       DATE,
                         p_new_prod_date   OUT      DATE,
                         p_msg             OUT      VARCHAR2);
                         
    PROCEDURE prod_take_up (p_fund_cd           IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                            p_sql_path          IN OUT VARCHAR2,
                            p_gen_home          IN OUT giac_parameters.param_value_v%TYPE,
                            p_ri_iss_cd         IN OUT giac_parameters.param_value_v%TYPE,
                            p_msg               IN OUT VARCHAR2);
                            
    PROCEDURE prod_take_up_proc (p_prod_date            IN       DATE,
                                 p_new_prod_date        IN OUT   DATE,
                                 p_exclude_special      IN OUT   VARCHAR2,
                                 p_gen_home             IN OUT   giac_parameters.param_value_v%TYPE,
                                 p_sql_path             IN       VARCHAR2,
                                 p_fund_cd              IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                 p_ri_iss_cd            IN       giac_parameters.param_value_v%TYPE,
                                 p_prem_rec_gross_tag   IN       giac_parameters.param_value_v%TYPE,
                                 p_user_id              IN       giis_users.user_id%TYPE,
                                 p_process              IN OUT   VARCHAR2,
                                 p_msg                  IN OUT   VARCHAR2);
                            
    PROCEDURE run_sql_report(path 				IN VARCHAR2,
                             p_prod_date 		IN DATE,
                             p_new_prod_date 	IN OUT DATE,
                             p_sql_name 		IN VARCHAR2,
                             p_line_dep 		IN giac_module_entries.line_dependency_level%type,
                             p_intm_dep 		IN giac_module_entries.intm_type_level%type,
                             p_item_no  		IN giac_module_entries.item_no%type,
                             p_ca_dep           IN GIAC_MODULE_ENTRIES.ca_treaty_type_level%type,
                             p_msg      		IN OUT VARCHAR2);
                             
    PROCEDURE create_batch_entries (p_prod_date IN DATE, 
                                    p_module_name IN VARCHAR2);
                                    
    PROCEDURE insert_giac_acctrans (p_prod_date       IN       DATE,
                                    p_new_prod_date   IN       DATE,
                                    p_fund_cd         IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                    p_tran_class      IN       giac_acctrans.tran_class%TYPE,
                                    p_tran_flag       IN       giac_acctrans.tran_flag%TYPE,
                                    p_user_id         IN       giis_users.user_id%TYPE,
                                    p_gacc_tran_id    IN OUT   giac_acctrans.tran_id%TYPE,
                                    p_msg             IN OUT   VARCHAR2);
                                    
    PROCEDURE update_giac_treaty_batch_ext;
    
    PROCEDURE bae2_copy_to_gtc_gtcd(p_prod_date 		IN DATE,
                                    p_new_prod_date 	IN OUT DATE,
                                    p_sql_name 		    IN OUT VARCHAR2,
                                    p_line_dep 		    IN giac_module_entries.line_dependency_level%type,
                                    p_intm_dep 		    IN giac_module_entries.intm_type_level%type,
                                    p_item_no  		    IN giac_module_entries.item_no%type,
                                    p_ca_dep            IN GIAC_MODULE_ENTRIES.ca_treaty_type_level%type,
                                    p_msg      		    IN OUT VARCHAR2);
                                    
    PROCEDURE bae2_create_prem_ceded (p_prod_date           IN       DATE,
                                      p_new_prod_date       IN OUT   DATE,
                                      p_process             IN OUT   VARCHAR2,
                                      p_msg                 IN OUT   VARCHAR2,
                                      p_module_item_no_pc   IN OUT   giac_module_entries.item_no%TYPE,
                                      p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                      p_sql_name            IN OUT   VARCHAR2,
                                      p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                      p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                      p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                      p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                      
    PROCEDURE bae2_create_comm_inc (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_ci   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                    
    PROCEDURE bae2_create_funds_held (p_prod_date           IN       DATE,
                                       p_new_prod_date       IN OUT   DATE,
                                       p_process             IN OUT   VARCHAR2,
                                       p_msg                 IN OUT   VARCHAR2,
                                       p_module_item_no_fh   IN OUT   giac_module_entries.item_no%TYPE,
                                       p_module_item_no_dt   IN OUT   giac_module_entries.item_no%TYPE,
                                       p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                       p_sql_name            IN OUT   VARCHAR2,
                                       p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                       p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                       p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                       p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                       
    PROCEDURE bae2_create_due_to_treaty (p_prod_date           IN       DATE,
                                         p_new_prod_date       IN OUT   DATE,
                                         p_process             IN OUT   VARCHAR2,
                                         p_msg                 IN OUT   VARCHAR2,
                                         p_module_item_no_dt   IN OUT   giac_module_entries.item_no%TYPE,
                                         p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                         p_sql_name            IN OUT   VARCHAR2,
                                         p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                         p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                         p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                         p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                         
    PROCEDURE bae2_create_comm_vat (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_ov   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                    
    PROCEDURE bae2_create_prem_vat (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_iv   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                    
    PROCEDURE bae2_create_def_credit_wvat (p_prod_date             IN       DATE,
                                           p_new_prod_date         IN OUT   DATE,
                                           p_process               IN OUT   VARCHAR2,
                                           p_msg                   IN OUT   VARCHAR2,
                                           p_module_item_no_dcwv   IN OUT   giac_module_entries.item_no%TYPE,
                                           p_module_name           IN OUT   giac_modules.module_name%TYPE,
                                           p_sql_name              IN OUT   VARCHAR2,
                                           p_line_dep              IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                           p_intm_dep              IN OUT   giac_module_entries.intm_type_level%TYPE,
                                           p_ca_dep                IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                           p_item_no               IN OUT   giac_module_entries.item_no%TYPE);
                                           
    PROCEDURE bae2_create_def_wvat_payable (p_prod_date             IN       DATE,
                                            p_new_prod_date         IN OUT   DATE,
                                            p_process               IN OUT   VARCHAR2,
                                            p_msg                   IN OUT   VARCHAR2,
                                            p_module_item_no_dwvp   IN OUT   giac_module_entries.item_no%TYPE,
                                            p_module_name           IN OUT   giac_modules.module_name%TYPE,
                                            p_sql_name              IN OUT   VARCHAR2,
                                            p_line_dep              IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                            p_intm_dep              IN OUT   giac_module_entries.intm_type_level%TYPE,
                                            p_ca_dep                IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                            p_item_no               IN OUT   giac_module_entries.item_no%TYPE);
                                            
    PROCEDURE bae2_create_prem_tax (p_prod_date           IN       DATE,
                                    p_new_prod_date       IN OUT   DATE,
                                    p_process             IN OUT   VARCHAR2,
                                    p_msg                 IN OUT   VARCHAR2,
                                    p_module_item_no_pt   IN OUT   giac_module_entries.item_no%TYPE,
                                    p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                    p_sql_name            IN OUT   VARCHAR2,
                                    p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                    p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                    p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                    p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                    
    PROCEDURE transfer_to_giac_acct_entries;
    
    PROCEDURE check_debit_credit_amounts (p_prod_date                IN       DATE,
                                          p_module_item_no_inc_adj   IN       giac_module_entries.item_no%TYPE,
                                          p_module_item_no_exp_adj   IN       giac_module_entries.item_no%TYPE,
                                          p_module_name              IN       giac_modules.module_name%TYPE,
                                          p_fund_cd                  IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                          p_user_id                  IN       giis_users.user_id%TYPE,
                                          p_balance                  IN OUT   NUMBER,
                                          p_msg                      IN OUT   VARCHAR2);
                                          
    PROCEDURE adjust (v_tran_id                  IN   giac_acctrans.tran_id%TYPE,
                      v_module_item_no           IN   giac_module_entries.item_no%TYPE,
                      v_branch_cd                IN   giac_acctrans.gibr_branch_cd%TYPE,
                      p_module_item_no_exp_adj   IN   giac_module_entries.item_no%TYPE,
                      p_module_name              IN   giac_modules.module_name%TYPE,
                      p_fund_cd                  IN   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                      p_module_item_no_inc_adj   IN   giac_module_entries.item_no%TYPE,
                      p_user_id                  IN   giis_users.user_id%TYPE,
                      p_balance                  IN   NUMBER);
                      
    PROCEDURE update_giuw_pol_dist (p_prod_date IN DATE, 
                                    p_new_prod_date IN DATE);
                                    
    PROCEDURE bae2_create_prem_retroceded(p_prod_date           IN       DATE,
                                          p_new_prod_date       IN OUT   DATE,
                                          p_process             IN OUT   VARCHAR2,
                                          p_msg                 IN OUT   VARCHAR2,
                                          p_module_item_no_prc  IN OUT   giac_module_entries.item_no%TYPE,
                                          p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                          p_sql_name            IN OUT   VARCHAR2,
                                          p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                          p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                          p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                          p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                          
    PROCEDURE bae2_create_comm_inc_retro(p_prod_date           IN       DATE,
                                         p_new_prod_date       IN OUT   DATE,
                                         p_process             IN OUT   VARCHAR2,
                                         p_msg                 IN OUT   VARCHAR2,
                                         p_module_item_no_cir  IN OUT   giac_module_entries.item_no%TYPE,
                                         p_module_name         IN OUT   giac_modules.module_name%TYPE,
                                         p_sql_name            IN OUT   VARCHAR2,
                                         p_line_dep            IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                         p_intm_dep            IN OUT   giac_module_entries.intm_type_level%TYPE,
                                         p_ca_dep              IN OUT   giac_module_entries.ca_treaty_type_level%TYPE,
                                         p_item_no             IN OUT   giac_module_entries.item_no%TYPE);
                                    
END;
/


