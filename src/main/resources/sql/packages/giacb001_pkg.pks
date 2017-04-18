CREATE OR REPLACE PACKAGE CPI.GIACB001_PKG
AS
    PROCEDURE re_take_up(p_prod_date     IN  DATE,
                         p_new_prod_date OUT DATE, 
                         p_msg           OUT VARCHAR2 
                         );
                         
    PROCEDURE prod_take_up(p_msg                 IN OUT VARCHAR2, 
                           p_gen_home            IN OUT GIAC_PARAMETERS.param_value_v%type,
						   p_sql_path    		 IN OUT VARCHAR2,
                           p_var_param_value_n 	 IN OUT GIAC_PARAMETERS.param_value_n%type,
						   p_fund_cd           	 IN OUT GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
					       p_ri_iss_cd         	 IN OUT GIAC_PARAMETERS.param_value_v%type,
						   p_prem_rec_gross_tag  IN OUT GIAC_PARAMETERS.param_value_v%type);
                         
    PROCEDURE prod_take_up_proc(p_prod_date             IN DATE,
                                p_new_prod_date         IN OUT DATE,
                                p_exclude_special       IN OUT VARCHAR2,
                                p_gen_home    		    IN OUT GIAC_PARAMETERS.param_value_v%type,
						        p_sql_path    		    IN VARCHAR2,
                                p_var_param_value_n     IN GIAC_PARAMETERS.param_value_n%type,
						        p_fund_cd               IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
					            p_ri_iss_cd             IN GIAC_PARAMETERS.param_value_v%type,
                                p_prem_rec_gross_tag    IN GIAC_PARAMETERS.param_value_v%type,
                                p_user_id               IN GIIS_USERS.user_id%type,
                                p_process               IN OUT VARCHAR2,
                                p_msg                   IN OUT VARCHAR2);
                                
    PROCEDURE get_acct_intm_cd3(p_module_name IN VARCHAR2,
                                p_msg       IN OUT VARCHAR2);
    
    PROCEDURE bae1_copy_to_extract(p_prod_date          IN DATE,
                                   p_new_prod_date      IN OUT DATE,
                                   p_var_param_value_n  IN GIAC_PARAMETERS.param_value_n%type,
                                   p_exclude_special    IN VARCHAR2,
                                   p_line_dep           IN giac_module_entries.line_dependency_level%type,
                                   p_intm_dep           IN giac_module_entries.intm_type_level%type,
                                   p_item_no            IN giac_module_entries.item_no%type,
                                   p_sql_name           IN OUT VARCHAR2,
                                   p_msg                IN OUT VARCHAR2,
                                   p_process            IN OUT VARCHAR2);
                                   
    PROCEDURE run_sql_report(path IN VARCHAR2,
                             p_prod_date IN DATE,
                             p_new_prod_date IN OUT DATE,
                             p_sql_name IN VARCHAR2,
                             p_line_dep IN giac_module_entries.line_dependency_level%type,
                             p_intm_dep IN giac_module_entries.intm_type_level%type,
                             p_item_no  IN giac_module_entries.item_no%type,
                             p_process  IN OUT VARCHAR2,
                             p_msg      IN OUT VARCHAR2);
                             
    PROCEDURE extract_all_policies_2(p_prod_date			IN DATE,
                                     p_exclude_special      IN giac_parameters.param_value_v%type,
                                     p_spoiled_flag			IN GIPI_POLBASIC.pol_flag%type,
                                     p_ri_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_bb_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_fund_cd              IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                     p_bae_line_cd          IN giis_line.line_cd%type,
                                     p_marine_line          IN GIIS_LINE.line_cd%TYPE,
                                     p_marine_subline       IN GIIS_SUBLINE.subline_cd%TYPE,
                                     p_dist_flag            IN GIUW_POL_DIST.dist_flag%type,
                                     p_var_counter_positive IN OUT NUMBER,
                                     p_var_positive         IN VARCHAR2,
                                     p_var_counter_negative IN OUT NUMBER,
                                     p_var_negative         IN VARCHAR2,
                                     p_policies             IN OUT NUMBER);   
                                     
    PROCEDURE extract_all_policies_1(p_prod_date			IN DATE,
                                     p_exclude_special      IN giac_parameters.param_value_v%type,
                                     p_spoiled_flag			IN GIPI_POLBASIC.pol_flag%type,
                                     p_ri_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_bb_iss_cd            IN GIAC_PARAMETERS.param_value_v%type,
                                     p_fund_cd              IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                     p_bae_line_cd          IN giis_line.line_cd%type,
                                     p_marine_line          IN GIIS_LINE.line_cd%TYPE,
                                     p_marine_subline       IN GIIS_SUBLINE.subline_cd%TYPE,
                                     p_dist_flag            IN GIUW_POL_DIST.dist_flag%type,
                                     p_var_counter_positive IN OUT NUMBER,
                                     p_var_positive         IN VARCHAR2,
                                     p_var_counter_negative IN OUT NUMBER,
                                     p_var_negative         IN VARCHAR2,
                                     p_policies             IN OUT NUMBER);
                                     
    PROCEDURE create_batch_entries(p_prod_date      IN DATE,
                                   p_module_name	IN VARCHAR2);    
                                   
    PROCEDURE insert_giac_acctrans(p_prod_date      IN DATE,
                                   p_new_prod_date  IN DATE,
                                   p_fund_cd    	IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                   p_tran_class		IN GIAC_ACCTRANS.tran_class%type,
                                   p_tran_flag		IN GIAC_ACCTRANS.tran_flag%type,
                                   p_user_id    	IN GIIS_USERS.user_id%type,
                                   p_gacc_tran_id   IN OUT GIAC_ACCTRANS.tran_id%type,
                                   p_msg            IN OUT VARCHAR2);  
                                   
    PROCEDURE bae_taxes_payable(p_prem_rec_gross_tag 	IN GIAC_PARAMETERS.param_value_v%type,
                                p_tax_dr_cd_tag		    IN VARCHAR2,
                                p_var_positive		    IN VARCHAR2,
                                p_var_negative		    IN VARCHAR2,
                                p_fund_cd				IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                p_prod_date		        IN DATE,
                                p_new_prod_date	        IN DATE,
                                p_user_id			    IN GIIS_USERS.user_id%type,
                                p_tran_class		    IN GIAC_ACCTRANS.tran_class%type,
                                p_tran_flag		        IN GIAC_ACCTRANS.tran_flag%type,
                                p_var_count_row	        IN OUT NUMBER, 
                                p_row_counter		    IN OUT NUMBER,
                                p_gacc_tran_id		    IN OUT GIAC_ACCTRANS.tran_id%type,
                                p_msg                   IN OUT VARCHAR2);  
                                
    PROCEDURE bae_insert_update_acct_entries(iuae_gl_acct_category  GIAC_ACCT_ENTRIES.gl_acct_category%TYPE,
                                             iuae_gl_control_acct   GIAC_ACCT_ENTRIES.gl_control_acct%TYPE,
                                             iuae_gl_sub_acct_1     GIAC_ACCT_ENTRIES.gl_sub_acct_1%TYPE,
                                             iuae_gl_sub_acct_2     GIAC_ACCT_ENTRIES.gl_sub_acct_2%TYPE,
                                             iuae_gl_sub_acct_3     GIAC_ACCT_ENTRIES.gl_sub_acct_3%TYPE,
                                             iuae_gl_sub_acct_4     GIAC_ACCT_ENTRIES.gl_sub_acct_4%TYPE,
                                             iuae_gl_sub_acct_5     GIAC_ACCT_ENTRIES.gl_sub_acct_5%TYPE,
                                             iuae_gl_sub_acct_6     GIAC_ACCT_ENTRIES.gl_sub_acct_6%TYPE,
                                             iuae_gl_sub_acct_7     GIAC_ACCT_ENTRIES.gl_sub_acct_7%TYPE,
                                             iuae_sl_cd             GIAC_ACCT_ENTRIES.sl_cd%TYPE,
                                             iuae_gl_acct_id        GIAC_CHART_OF_ACCTS.gl_acct_id%TYPE, 
                                             iuae_acct_branch_cd    GIAC_branches.acct_branch_cd%type,
                                             iuae_credit_amt        GIAC_ACCT_ENTRIES.credit_amt%type,
                                             iuae_debit_amt         GIAC_ACCT_ENTRIES.debit_amt%type,
                                             iuae_sl_type_cd        GIAC_ACCT_ENTRIES.sl_type_cd%type,
                                             iuae_sl_source_cd      GIAC_ACCT_ENTRIES.sl_source_cd%type,  
                                             p_prod_date		 IN DATE,
                                             p_new_prod_date	 IN DATE,
                                             p_user_id			 IN GIIS_USERS.user_id%type,
                                             p_fund_cd			 IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                             p_tran_class		 IN GIAC_ACCTRANS.tran_class%type,
                                             p_tran_flag		 IN GIAC_ACCTRANS.tran_flag%type,
                                             p_var_count_row	 IN OUT NUMBER, 
                                             p_row_counter		 IN OUT NUMBER,
                                             p_gacc_tran_id		 IN OUT GIAC_ACCTRANS.tran_id%type,
                                             p_msg               IN OUT VARCHAR2);  
                                             
    PROCEDURE bae1_create_comm_expense(p_prod_date			IN DATE,
                                       p_new_prod_date		IN OUT DATE,
                                       p_process			IN OUT VARCHAR2,
                                       p_msg				IN OUT VARCHAR2,
                                       p_module_item_no_CE	IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                       p_module_name		IN OUT GIAC_MODULES.module_name%type,
                                       p_gen_home			IN OUT GIAC_PARAMETERS.param_value_v%type,
                                       p_folder				IN OUT VARCHAR2,
                                       p_sql_name			IN OUT VARCHAR2,
                                       p_line_dep			IN OUT giac_module_entries.line_dependency_level%type,
                                       p_intm_dep			IN OUT giac_module_entries.intm_type_level%type,
                                       p_ca_dep				IN OUT giac_module_entries.ca_treaty_type_level%type,
                                       p_item_no			IN OUT giac_module_entries.item_no%type);
                                       
    PROCEDURE bae1_create_comm_payable(p_prod_date			IN DATE,
                                       p_new_prod_date		IN OUT DATE,
                                       p_process			IN OUT VARCHAR2,
                                       p_msg				IN OUT VARCHAR2,
                                       p_module_item_no_CP	IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                       p_module_name		IN OUT GIAC_MODULES.module_name%type,
                                       p_gen_home			IN OUT GIAC_PARAMETERS.param_value_v%type,
                                       p_folder				IN OUT VARCHAR2,
                                       p_sql_name			IN OUT VARCHAR2,
                                       p_line_dep			IN OUT giac_module_entries.line_dependency_level%type,
                                       p_intm_dep			IN OUT giac_module_entries.intm_type_level%type,
                                       p_ca_dep				IN OUT giac_module_entries.ca_treaty_type_level%type,
                                       p_item_no			IN OUT giac_module_entries.item_no%type);  
                                       
    PROCEDURE bae1_create_gross_prem(p_prod_date			IN DATE,
                                     p_new_prod_date		IN OUT DATE,
                                     p_process				IN OUT VARCHAR2,
                                     p_msg					IN OUT VARCHAR2,
                                     p_module_item_no_GP	IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                     p_module_name			IN OUT GIAC_MODULES.module_name%type,
                                     p_gen_home				IN OUT GIAC_PARAMETERS.param_value_v%type,
                                     p_folder				IN OUT VARCHAR2,
                                     p_sql_name				IN OUT VARCHAR2,
                                     p_line_dep				IN OUT giac_module_entries.line_dependency_level%type,
                                     p_intm_dep				IN OUT giac_module_entries.intm_type_level%type,
                                     p_ca_dep				IN OUT giac_module_entries.ca_treaty_type_level%type,
                                     p_item_no				IN OUT giac_module_entries.item_no%type);   
                                     
    PROCEDURE bae1_create_prem_rec(p_prod_date			IN DATE,
                                   p_prem_rec_gross_tag IN GIAC_PARAMETERS.param_value_v%type,
                                   p_new_prod_date		IN OUT DATE,
                                   p_process			IN OUT VARCHAR2,
                                   p_msg				IN OUT VARCHAR2,
                                   p_module_item_no_PR1	IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                   p_module_item_no_PR2 IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                   p_module_item_no_OCI IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                   p_module_name		IN OUT GIAC_MODULES.module_name%type,
                                   p_gen_home			IN OUT GIAC_PARAMETERS.param_value_v%type,
                                   p_folder				IN OUT VARCHAR2,
                                   p_sql_name			IN OUT VARCHAR2,
                                   p_line_dep			IN OUT giac_module_entries.line_dependency_level%type,
                                   p_intm_dep			IN OUT giac_module_entries.intm_type_level%type,
                                   p_ca_dep				IN OUT giac_module_entries.ca_treaty_type_level%type,
                                   p_item_no			IN OUT giac_module_entries.item_no%type); 

    --added by mikel 06.15.2015; dr 4691 Wtax enhancements, BIR demo findings.                               
    PROCEDURE bae1_create_netcomm_payable (p_prod_date          IN DATE,
                                           p_new_prod_date      IN OUT DATE,
                                           p_process            IN OUT VARCHAR2,
                                           p_msg                IN OUT VARCHAR2,
                                           p_module_item_no_CP  IN OUT GIAC_MODULE_ENTRIES.item_no%type,
                                           p_module_name        IN OUT GIAC_MODULES.module_name%type,
                                           p_gen_home           IN OUT GIAC_PARAMETERS.param_value_v%type,
                                           p_folder             IN OUT VARCHAR2,
                                           p_sql_name           IN OUT VARCHAR2,
                                           p_line_dep           IN OUT giac_module_entries.line_dependency_level%type,
                                           p_intm_dep           IN OUT giac_module_entries.intm_type_level%type,
                                           p_ca_dep             IN OUT giac_module_entries.ca_treaty_type_level%type,
                                           p_item_no            IN OUT giac_module_entries.item_no%type);  
                                                                   
    PROCEDURE bae1_create_wtax        (p_prod_date              IN DATE,
                                       p_new_prod_date          IN OUT DATE,
                                       p_process                IN OUT VARCHAR2,
                                       p_msg                    IN OUT VARCHAR2,
                                       p_module_name            IN OUT GIAC_MODULES.module_name%type,
                                       p_gen_home               IN OUT GIAC_PARAMETERS.param_value_v%type,
                                       p_folder                 IN OUT VARCHAR2,
                                       p_sql_name               IN OUT VARCHAR2,
                                       p_line_dep               IN OUT giac_module_entries.line_dependency_level%type,
                                       p_intm_dep               IN OUT giac_module_entries.intm_type_level%type,
                                       p_ca_dep                 IN OUT giac_module_entries.ca_treaty_type_level%type,
                                       p_item_no                IN OUT giac_module_entries.item_no%type);                                                                                                                                                       
    --end mikel 06.15.2015
                                   
    PROCEDURE transfer_to_giac_acct_entries;    
	
    PROCEDURE check_debit_credit_amounts(p_prod_date				IN DATE,
                                         p_module_item_no_Inc_adj   IN GIAC_MODULE_ENTRIES.item_no%type,
                                         p_module_item_no_Exp_adj   IN GIAC_MODULE_ENTRIES.item_no%type,
                                         p_module_name			    IN GIAC_MODULES.module_name%type,
                                         p_fund_Cd				    IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                                         p_user_id				    IN GIIS_USERS.user_id%type,
                                         p_balance					IN OUT NUMBER);
                                         
    PROCEDURE adjust(v_tran_id                IN giac_acctrans.tran_id%type        ,
                     v_module_item_no         IN giac_module_entries.item_no%type  ,
                     v_branch_cd              IN giac_acctrans.gibr_branch_cd%type,
                     p_module_item_no_Exp_adj IN GIAC_MODULE_ENTRIES.item_no%type,		
                     p_module_name			  IN GIAC_MODULES.module_name%type,
                     p_fund_Cd				  IN GIAC_ACCT_ENTRIES.gacc_gfun_fund_cd%type,
                     p_module_item_no_Inc_adj IN GIAC_MODULE_ENTRIES.item_no%type,
                     p_user_id				  IN GIIS_USERS.user_id%type,
                     p_balance				  IN NUMBER);
                     
    PROCEDURE update_polbasic(p_prod_date 		IN DATE,
                              p_var_count_row	IN OUT NUMBER);
                              
    PROCEDURE update_giac_parent_comm(p_module_name			IN GIAC_MODULES.module_name%type,
                                      p_module_item_no_CP	IN GIAC_MODULE_ENTRIES.item_no%type,
                                      p_module_item_no_CE	IN GIAC_MODULE_ENTRIES.item_no%type,
                                      p_tran_class			IN GIAC_ACCTRANS.tran_class%type,
                                      p_tran_flag            IN GIAC_ACCTRANS.tran_flag%type,
                                      p_new_prod_date        IN DATE,
                                      p_var_count_row        IN OUT NUMBER,
                                      p_prod_date            IN DATE);
END; 
/

