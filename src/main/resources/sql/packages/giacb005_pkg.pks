CREATE OR REPLACE PACKAGE CPI.GIACB005_PKG
AS
	
        PROCEDURE re_take_up(p_prod_date     IN  DATE,
                             p_cut_off_date  OUT DATE,
                             p_msg           OUT VARCHAR2); 
                             
    PROCEDURE prod_take_up(p_prod_date            IN       DATE,
                           p_cut_off_date         IN OUT   DATE,
                           p_exclude_special      IN OUT   VARCHAR2,
                           p_fund_cd              IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                           p_ri_iss_cd            IN OUT   giac_parameters.param_value_v%TYPE,
                           p_user_id              IN       giis_users.user_id%TYPE,
                           p_msg                  IN OUT   VARCHAR2);
                           
    PROCEDURE create_batch_entries(p_prod_date     IN   DATE,
                                   p_module_name   IN   giac_modules.module_name%TYPE);
                                   
    PROCEDURE update_giac_advanced_payt(p_prod_date         IN       DATE,
                                        p_var_count_row     IN OUT   NUMBER);
                                        
    PROCEDURE EXTRACT(p_prod_date                       IN DATE,
                      p_exclude_special                 IN giac_parameters.param_value_v%TYPE,
                      p_module_ent_prem_dep             IN giac_module_entries.item_no%TYPE,
                      p_module_ent_prem_rec             IN giac_module_entries.item_no%TYPE,
                      p_module_ent_def_evat             IN giac_module_entries.item_no%TYPE,
                      p_module_ent_evata                IN giac_module_entries.item_no%TYPE,
                      p_module_ent_evatb                IN giac_module_entries.item_no%TYPE,
                      p_iss_cd                          IN OUT giac_branches.branch_cd%TYPE,
                      p_process                         IN OUT VARCHAR2,
                      p_module_name                     IN giac_modules.module_name%TYPE,
                      p_acct_line_cd                    IN OUT giis_line.acct_line_cd%TYPE,
                      p_acct_intm_cd                    IN OUT giis_intm_type.acct_intm_cd%TYPE,
                      p_var_gl_acct_id                  IN OUT giac_acct_entries.gl_acct_id%TYPE,
                      p_var_sl_type_cd                  IN OUT giac_acct_entries.sl_type_cd%TYPE,
                      p_sl_source_cd                    IN OUT giac_acct_entries.sl_source_cd%TYPE,
                      p_msg                             IN OUT VARCHAR2,
                      p_fund_cd                         IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                      p_tran_class                      IN OUT giac_acctrans.tran_class%TYPE,
                      p_tran_flag                       IN OUT giac_acctrans.tran_flag%TYPE,
                      p_cut_off_date                    IN OUT DATE,
                      p_gacc_tran_id                    IN OUT giac_acctrans.tran_id%TYPE,
                      p_var_count_row                   IN OUT NUMBER,
                      p_assured                         IN OUT giac_sl_types.sl_type_cd%type);  
                                        
    PROCEDURE get_module_parameters (var_module_item_no          IN       giac_module_entries.item_no%TYPE,
                                     var_gl_acct_category        IN OUT   giac_module_entries.gl_acct_category%TYPE,
                                     var_gl_control_acct         IN OUT   giac_module_entries.gl_control_acct%TYPE,
                                     var_gl_sub_acct_1           IN OUT   giac_module_entries.gl_sub_acct_1%TYPE,
                                     var_gl_sub_acct_2           IN OUT   giac_module_entries.gl_sub_acct_2%TYPE,
                                     var_gl_sub_acct_3           IN OUT   giac_module_entries.gl_sub_acct_3%TYPE,
                                     var_gl_sub_acct_4           IN OUT   giac_module_entries.gl_sub_acct_4%TYPE,
                                     var_gl_sub_acct_5           IN OUT   giac_module_entries.gl_sub_acct_5%TYPE,
                                     var_gl_sub_acct_6           IN OUT   giac_module_entries.gl_sub_acct_6%TYPE,
                                     var_gl_sub_acct_7           IN OUT   giac_module_entries.gl_sub_acct_7%TYPE,
                                     var_intm_type_level         IN OUT   giac_module_entries.intm_type_level%TYPE,
                                     var_line_dependency_level   IN OUT   giac_module_entries.line_dependency_level%TYPE,
                                     var_old_new_acct_level      IN OUT   giac_module_entries.old_new_acct_level%TYPE,
                                     var_dr_cr_tag               IN OUT   giac_module_entries.dr_cr_tag%TYPE,
                                     p_module_name			     IN       GIAC_MODULES.module_name%type,
                                     p_msg						 IN OUT   VARCHAR2);
                                     
    PROCEDURE insert_giac_acctrans (iga_iss_cd 			IN giac_branches.branch_cd%TYPE,
                                    p_prod_date			IN DATE,
                                    p_cut_off_date		IN DATE,  
                                    p_iss_cd			IN OUT giac_branches.branch_cd%type,
                                    p_fund_cd			IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                    p_tran_class		IN OUT GIAC_ACCTRANS.tran_class%type,
                                    p_tran_flag			IN OUT GIAC_ACCTRANS.tran_flag%type,
                                    p_gacc_tran_id		IN OUT GIAC_ACCTRANS.tran_id%type);
                                    
    PROCEDURE entries (bpc_gl_acct_category        giac_chart_of_accts.gl_acct_category%TYPE,
                        bpc_gl_control_acct         giac_chart_of_accts.gl_control_acct%TYPE,
                        bpc_gl_sub_acct_1           giac_chart_of_accts.gl_sub_acct_1%TYPE,
                        bpc_gl_sub_acct_2           giac_chart_of_accts.gl_sub_acct_2%TYPE,
                        bpc_gl_sub_acct_3           giac_chart_of_accts.gl_sub_acct_3%TYPE,
                        bpc_gl_sub_acct_4           giac_chart_of_accts.gl_sub_acct_4%TYPE,
                        bpc_gl_sub_acct_5           giac_chart_of_accts.gl_sub_acct_5%TYPE,
                        bpc_gl_sub_acct_6           giac_chart_of_accts.gl_sub_acct_6%TYPE,
                        bpc_gl_sub_acct_7           giac_chart_of_accts.gl_sub_acct_7%TYPE,
                        bpc_intm_type_level         giac_module_entries.intm_type_level%TYPE,
                        bpc_line_dependency_level   giac_module_entries.line_dependency_level%TYPE,
                        bpc_dr_cr_tag               giac_module_entries.dr_cr_tag%TYPE,
                        bpc_assd_no                 gipi_parlist.assd_no%TYPE,
                        bpc_intm_no                 giis_intermediary.intm_no%type, --mikel 03.22.2016 AUII 5467
                        bpc_acct_line_cd            giis_line.acct_line_cd%TYPE,
                        bpc_acct_intm_cd            giis_intm_type.acct_intm_cd%TYPE,
                        bpc_coll_amt                NUMBER,
                        bpc_iss_cd                  gipi_polbasic.iss_cd%TYPE,
                        p_prod_date                 IN       DATE,
                        p_acct_line_cd              IN OUT   giis_line.acct_line_cd%TYPE,
                        p_acct_intm_cd              IN OUT   giis_intm_type.acct_intm_cd%TYPE,
                        p_var_gl_acct_id            IN OUT   giac_acct_entries.gl_acct_id%TYPE,
                        p_var_sl_type_cd            IN OUT   giac_acct_entries.sl_type_cd%TYPE,
                        p_sl_source_cd              IN OUT   giac_acct_entries.sl_source_cd%TYPE,
                        p_process                   IN OUT   VARCHAR2,
                        p_msg                       IN OUT   VARCHAR2,
                        p_gacc_tran_id              IN OUT   giac_acctrans.tran_id%TYPE,
                        p_tran_class                IN OUT   giac_acctrans.tran_class%TYPE,
                        p_fund_cd                   IN OUT   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                        p_cut_off_date              IN OUT   DATE,
                        p_tran_flag                 IN OUT   giac_acctrans.tran_flag%TYPE,
                        p_var_count_row             IN OUT   NUMBER,
                        p_assured                   IN OUT   giac_sl_types.sl_type_cd%type);
                        
    PROCEDURE bae_insert_update_acct_entries (iuae_gl_acct_category   giac_acct_entries.gl_acct_category%TYPE,
                                              iuae_gl_control_acct    giac_acct_entries.gl_control_acct%TYPE,
                                              iuae_gl_sub_acct_1      giac_acct_entries.gl_sub_acct_1%TYPE,
                                              iuae_gl_sub_acct_2      giac_acct_entries.gl_sub_acct_2%TYPE,
                                              iuae_gl_sub_acct_3      giac_acct_entries.gl_sub_acct_3%TYPE,
                                              iuae_gl_sub_acct_4      giac_acct_entries.gl_sub_acct_4%TYPE,
                                              iuae_gl_sub_acct_5      giac_acct_entries.gl_sub_acct_5%TYPE,
                                              iuae_gl_sub_acct_6      giac_acct_entries.gl_sub_acct_6%TYPE,
                                              iuae_gl_sub_acct_7      giac_acct_entries.gl_sub_acct_7%TYPE,
                                              iuae_sl_cd              giac_acct_entries.sl_cd%TYPE,
                                              iuae_gl_acct_id         giac_chart_of_accts.gl_acct_id%TYPE,
                                              iuae_branch_cd          giac_branches.branch_cd%TYPE,
                                              iuae_credit_amt         giac_acct_entries.credit_amt%TYPE,
                                              iuae_debit_amt          giac_acct_entries.debit_amt%TYPE,
                                              iuae_sl_type_cd         giac_acct_entries.sl_type_cd%TYPE,
                                              iuae_sl_source_cd       giac_acct_entries.sl_source_cd%TYPE,
                                              p_gacc_tran_id            IN OUT giac_acctrans.tran_id%TYPE,
                                              p_tran_class              IN OUT giac_acctrans.tran_class%TYPE,
                                              p_fund_cd                 IN OUT giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                              p_cut_off_date            IN OUT DATE,
                                              p_tran_flag               IN OUT giac_acctrans.tran_flag%TYPE,
                                              p_var_count_row           IN OUT NUMBER,
                                              p_process                 IN     VARCHAR2);
                                              
    PROCEDURE check_debit_credit_amounts(p_prod_date                IN       DATE,
                                         p_module_item_no_inc_adj   IN       giac_module_entries.item_no%TYPE,
                                         p_module_item_no_exp_adj   IN       giac_module_entries.item_no%TYPE,
                                         p_module_name              IN       giac_modules.module_name%TYPE,
                                         p_fund_cd                  IN       giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                                         p_balance                  IN OUT   NUMBER,
                                         p_msg                      IN OUT   VARCHAR2);
                                         
    PROCEDURE adjust (v_tran_id          giac_acctrans.tran_id%TYPE,
                      v_module_item_no   giac_module_entries.item_no%TYPE,
                      v_branch_cd        giac_acctrans.gibr_branch_cd%TYPE,
                      p_module_item_no_exp_adj   IN   giac_module_entries.item_no%TYPE,
                      p_module_name              IN   giac_modules.module_name%TYPE,
                      p_fund_cd                  IN   giac_acct_entries.gacc_gfun_fund_cd%TYPE,
                      p_module_item_no_inc_adj   IN   giac_module_entries.item_no%TYPE,
                      p_balance                  IN   NUMBER);
END;
/


