CREATE OR REPLACE PACKAGE CPI.twenty_fourth_validation
AS

  TYPE deff_rec_type IS RECORD (policy_id           NUMBER,
                                iss_cd              VARCHAR2(5),
                                cred_branch         VARCHAR2(5),
                                line_cd             VARCHAR2(7),
                                policy_no           VARCHAR2(100),
                                booking_month       VARCHAR2(15),
                                booking_year        NUMBER,
                                effectivity_date    DATE,
                                acct_ent_date       DATE,
                                prem_amt            NUMBER(16,2),
                                spoiled_date        DATE,
                                spld_acct_ent_date  DATE,
                                pol_flag            VARCHAR2(10),
                                jan_1               NUMBER(16,2),
                                feb_1               NUMBER(16,2),
                                mar_1               NUMBER(16,2),
                                apr_1               NUMBER(16,2),
                                may_1               NUMBER(16,2),
                                jun_1               NUMBER(16,2),
                                jul_1               NUMBER(16,2),
                                aug_1               NUMBER(16,2),
                                sep_1               NUMBER(16,2),
                                oct_1               NUMBER(16,2),
                                nov_1               NUMBER(16,2),
                                dec_1               NUMBER(16,2),
                                jan_2               NUMBER(16,2),
                                feb_2               NUMBER(16,2),
                                mar_2               NUMBER(16,2),
                                apr_2               NUMBER(16,2),
                                may_2               NUMBER(16,2),
                                jun_2               NUMBER(16,2),
                                jul_2               NUMBER(16,2),
                                aug_2               NUMBER(16,2),
                                sep_2               NUMBER(16,2),
                                oct_2               NUMBER(16,2),
                                nov_2               NUMBER(16,2),
                                dec_2               NUMBER(16,2)
                                );
  
  TYPE deff_rec_type_table IS TABLE OF deff_rec_type;
  
  TYPE deff_rec_type_ri IS RECORD (policy_id           NUMBER,
                                iss_cd              VARCHAR2(5),
                                cred_branch         VARCHAR2(5),
                                line_cd             VARCHAR2(7),
                                acct_trty_type      NUMBER,
                                policy_no           VARCHAR2(100),
                                booking_month       VARCHAR2(15),
                                booking_year        NUMBER,
                                effectivity_date    DATE,
                                acct_ent_date       DATE,
                                prem_amt            NUMBER(16,2),
                                dist_flag           VARCHAR2(3),
                                dist_no             NUMBER,
                                spoiled_date        DATE,
                                spld_acct_ent_date  DATE,
                                pol_flag            VARCHAR2(10),
                                jan_1               NUMBER(16,2),
                                feb_1               NUMBER(16,2),
                                mar_1               NUMBER(16,2),
                                apr_1               NUMBER(16,2),
                                may_1               NUMBER(16,2),
                                jun_1               NUMBER(16,2),
                                jul_1               NUMBER(16,2),
                                aug_1               NUMBER(16,2),
                                sep_1               NUMBER(16,2),
                                oct_1               NUMBER(16,2),
                                nov_1               NUMBER(16,2),
                                dec_1               NUMBER(16,2),
                                jan_2               NUMBER(16,2),
                                feb_2               NUMBER(16,2),
                                mar_2               NUMBER(16,2),
                                apr_2               NUMBER(16,2),
                                may_2               NUMBER(16,2),
                                jun_2               NUMBER(16,2),
                                jul_2               NUMBER(16,2),
                                aug_2               NUMBER(16,2),
                                sep_2               NUMBER(16,2),
                                oct_2               NUMBER(16,2),
                                nov_2               NUMBER(16,2),
                                dec_2               NUMBER(16,2)
                                );
  
  TYPE deff_rec_type_table_ri IS TABLE OF deff_rec_type_ri;
  
  TYPE def_ri_comm_income IS RECORD (line_cd            VARCHAR2(5),
                                     acct_trty_type     NUMBER,
                                     policy_id          NUMBER,
                                     iss_cd             VARCHAR2(5),
                                     cred_branch        VARCHAR2(5),
                                     policy_no          VARCHAR2(40),
                                     commission_amt     NUMBER(16,2),
                                     booking_month      VARCHAR2(30),
                                     booking_year       NUMBER,
                                     effectivity_date   DATE,
                                     acct_ent_date      DATE,
                                     spld_date          DATE,
                                     spld_acct_ent_date DATE,
                                     pol_flag           VARCHAR2(10),
                                     dist_no            NUMBER,
                                     dist_flag          VARCHAR2(5),
                                     ri_cd              NUMBER,
                                     jan_1               NUMBER(16,2),
                                     feb_1               NUMBER(16,2),
                                     mar_1               NUMBER(16,2),
                                     apr_1               NUMBER(16,2),
                                     may_1               NUMBER(16,2),
                                     jun_1               NUMBER(16,2),
                                     jul_1               NUMBER(16,2),
                                     aug_1               NUMBER(16,2),
                                     sep_1               NUMBER(16,2),
                                     oct_1               NUMBER(16,2),
                                     nov_1               NUMBER(16,2),
                                     dec_1               NUMBER(16,2),
                                     jan_2               NUMBER(16,2),
                                     feb_2               NUMBER(16,2),
                                     mar_2               NUMBER(16,2),
                                     apr_2               NUMBER(16,2),
                                     may_2               NUMBER(16,2),
                                     jun_2               NUMBER(16,2),
                                     jul_2               NUMBER(16,2),
                                     aug_2               NUMBER(16,2),
                                     sep_2               NUMBER(16,2),
                                     oct_2               NUMBER(16,2),
                                     nov_2               NUMBER(16,2),
                                     dec_2               NUMBER(16,2));
                                        
  TYPE def_ri_comm_income_tab IS TABLE OF def_ri_comm_income;
  
  TYPE def_facul_prem IS RECORD (line_cd            VARCHAR2(5),
                                 acct_trty_type     NUMBER,
                                 policy_id          NUMBER,
                                 iss_cd             VARCHAR2(5),
                                 cred_branch        VARCHAR2(5),
                                 policy_no          VARCHAR2(40),
                                 prem_amt           NUMBER(16,2),
                                 booking_month      VARCHAR2(30),
                                 booking_year       NUMBER,
                                 effectivity_date   DATE,
                                 acct_ent_date      DATE,
                                 acc_rev_date       DATE,
                                 spld_date          DATE,
                                 spld_acct_ent_date DATE,
                                 pol_flag           VARCHAR2(3),
                                 dist_no            NUMBER,
                                 dist_flag          VARCHAR2(5),
                                 jan_1               NUMBER(16,2),
                                 feb_1               NUMBER(16,2),
                                 mar_1               NUMBER(16,2),
                                 apr_1               NUMBER(16,2),
                                 may_1               NUMBER(16,2),
                                 jun_1               NUMBER(16,2),
                                 jul_1               NUMBER(16,2),
                                 aug_1               NUMBER(16,2),
                                 sep_1               NUMBER(16,2),
                                 oct_1               NUMBER(16,2),
                                 nov_1               NUMBER(16,2),
                                 dec_1               NUMBER(16,2),
                                 jan_2               NUMBER(16,2),
                                 feb_2               NUMBER(16,2),
                                 mar_2               NUMBER(16,2),
                                 apr_2               NUMBER(16,2),
                                 may_2               NUMBER(16,2),
                                 jun_2               NUMBER(16,2),
                                 jul_2               NUMBER(16,2),
                                 aug_2               NUMBER(16,2),
                                 sep_2               NUMBER(16,2),
                                 oct_2               NUMBER(16,2),
                                 nov_2               NUMBER(16,2),
                                 dec_2               NUMBER(16,2));
                                 
  TYPE def_facul_prem_tab IS TABLE OF def_facul_prem;
  
  TYPE def_comm_exp IS RECORD (cred_branch          VARCHAR2(5),
                               iss_cd               VARCHAR2(5),
                               line_cd              VARCHAR2(5),
                               policy_id            NUMBER,
                               policy_no            VARCHAR2(40),
                               intm_no              NUMBER,
                               booking_month        VARCHAR2(30),
                               booking_year         NUMBER,
                               eff_date             DATE,
                               acct_ent_date        DATE,
                               spld_date            DATE,
                               spld_acct_ent_date   DATE,
                               pol_flag             VARCHAR2(3),
                               comm_amt             NUMBER,
                               jan_1               NUMBER(16,2),
                               feb_1               NUMBER(16,2),
                               mar_1               NUMBER(16,2),
                               apr_1               NUMBER(16,2),
                               may_1               NUMBER(16,2),
                               jun_1               NUMBER(16,2),
                               jul_1               NUMBER(16,2),
                               aug_1               NUMBER(16,2),
                               sep_1               NUMBER(16,2),
                               oct_1               NUMBER(16,2),
                               nov_1               NUMBER(16,2),
                               dec_1               NUMBER(16,2),
                               jan_2               NUMBER(16,2),
                               feb_2               NUMBER(16,2),
                               mar_2               NUMBER(16,2),
                               apr_2               NUMBER(16,2),
                               may_2               NUMBER(16,2),
                               jun_2               NUMBER(16,2),
                               jul_2               NUMBER(16,2),
                               aug_2               NUMBER(16,2),
                               sep_2               NUMBER(16,2),
                               oct_2               NUMBER(16,2),
                               nov_2               NUMBER(16,2),
                               dec_2               NUMBER(16,2));
                               
  TYPE def_comm_exp_tab IS TABLE OF def_comm_exp;

  TYPE deff_rec_type_sum IS RECORD  (cred_branch VARCHAR2(5),
                                     line_cd     VARCHAR2(7),
                                     prem_amt    NUMBER,
                                     jan_1               NUMBER(16,2),
                                     feb_1               NUMBER(16,2),
                                     mar_1               NUMBER(16,2),
                                     apr_1               NUMBER(16,2),
                                     may_1               NUMBER(16,2),
                                     jun_1               NUMBER(16,2),
                                     jul_1               NUMBER(16,2),
                                     aug_1               NUMBER(16,2),
                                     sep_1               NUMBER(16,2),
                                     oct_1               NUMBER(16,2),
                                     nov_1               NUMBER(16,2),
                                     dec_1               NUMBER(16,2),
                                     jan_2               NUMBER(16,2),
                                     feb_2               NUMBER(16,2),
                                     mar_2               NUMBER(16,2),
                                     apr_2               NUMBER(16,2),
                                     may_2               NUMBER(16,2),
                                     jun_2               NUMBER(16,2),
                                     jul_2               NUMBER(16,2),
                                     aug_2               NUMBER(16,2),
                                     sep_2               NUMBER(16,2),
                                     oct_2               NUMBER(16,2),
                                     nov_2               NUMBER(16,2),
                                     dec_2               NUMBER(16,2));
                                       
  TYPE deff_rec_type_sum_table IS TABLE OF deff_rec_type_sum;
  
  TYPE def_rec_type_sum IS RECORD   (cred_branch  VARCHAR2(5),
                                     line_cd      VARCHAR2(7),
                                     comm_amt     NUMBER(16,2),
                                     jan_1               NUMBER(16,2),
                                     feb_1               NUMBER(16,2),
                                     mar_1               NUMBER(16,2),
                                     apr_1               NUMBER(16,2),
                                     may_1               NUMBER(16,2),
                                     jun_1               NUMBER(16,2),
                                     jul_1               NUMBER(16,2),
                                     aug_1               NUMBER(16,2),
                                     sep_1               NUMBER(16,2),
                                     oct_1               NUMBER(16,2),
                                     nov_1               NUMBER(16,2),
                                     dec_1               NUMBER(16,2),
                                     jan_2               NUMBER(16,2),
                                     feb_2               NUMBER(16,2),
                                     mar_2               NUMBER(16,2),
                                     apr_2               NUMBER(16,2),
                                     may_2               NUMBER(16,2),
                                     jun_2               NUMBER(16,2),
                                     jul_2               NUMBER(16,2),
                                     aug_2               NUMBER(16,2),
                                     sep_2               NUMBER(16,2),
                                     oct_2               NUMBER(16,2),
                                     nov_2               NUMBER(16,2),
                                     dec_2               NUMBER(16,2));
                                     
  TYPE def_rec_type_sum_tab IS TABLE OF def_rec_type_sum;
  
  TYPE def_adv_book IS RECORD (policy_id           NUMBER,
                                iss_cd              VARCHAR2(5),
                                cred_branch         VARCHAR2(5),
                                line_cd             VARCHAR2(7),
                                policy_no           VARCHAR2(100),
                                booking_month       VARCHAR2(15),
                                booking_year        NUMBER,
                                effectivity_date    DATE,
                                acct_ent_date       DATE,
                                prem_amt            NUMBER(16,2),
                                spoiled_date        DATE,
                                spld_acct_ent_date  DATE,
                                pol_flag            VARCHAR2(10));
  
  TYPE def_adv_book_tab IS TABLE OF def_adv_book;
  
  TYPE def_expired IS RECORD (policy_id           NUMBER,
                                iss_cd              VARCHAR2(5),
                                cred_branch         VARCHAR2(5),
                                line_cd             VARCHAR2(7),
                                policy_no           VARCHAR2(100),
                                booking_month       VARCHAR2(15),
                                booking_year        NUMBER,
                                effectivity_date    DATE,
                                acct_ent_date       DATE,
                                prem_amt            NUMBER(16,2),
                                spoiled_date        DATE,
                                spld_acct_ent_date  DATE,
                                pol_flag            VARCHAR2(10));
  
  TYPE def_expired_tab IS TABLE OF def_expired;
  
  PROCEDURE extract_gross_premium (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_ri_prem       (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_ri_income1    (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_ri_income2    (p_extract_mm NUMBER, p_extract_year NUMBER);  
  
  PROCEDURE extract_facul_prem    (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_comm_exp      (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_comm_exp_ri   (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_grossprem_prod (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_premceded_prod (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  PROCEDURE extract_all           (p_extract_mm NUMBER, p_extract_year NUMBER);
  
  FUNCTION get_gross_premium_dtl
    RETURN deff_rec_type_table PIPELINED;
    
  FUNCTION get_gross_premium_summary
    RETURN deff_rec_type_sum_table PIPELINED;
    
  FUNCTION get_ri_premium_dtl
    RETURN deff_rec_type_table_ri PIPELINED;
  
  FUNCTION get_ri_premium_summary 
    RETURN deff_rec_type_sum_table PIPELINED;
    
  FUNCTION get_ri_income1_dtl
    RETURN def_ri_comm_income_tab PIPELINED;
    
  FUNCTION get_ri_income1_summary
    RETURN def_rec_type_sum_tab PIPELINED;
    
  FUNCTION get_ri_income2_dtl
    RETURN def_ri_comm_income_tab PIPELINED; 
    
  FUNCTION get_ri_income2_summary
    RETURN def_rec_type_sum_tab PIPELINED;
    
  FUNCTION get_all_ri_income_dtl
    RETURN def_ri_comm_income_tab PIPELINED;
    
  FUNCTION get_all_ri_income_summary
    RETURN def_rec_type_sum_tab PIPELINED;
    
  FUNCTION get_facul_prem_dtl
    RETURN def_facul_prem_tab PIPELINED;
    
  FUNCTION get_facul_prem_summary
    RETURN deff_rec_type_sum_table PIPELINED;
    
  FUNCTION get_comm_exp_dtl
    RETURN def_comm_exp_tab PIPELINED;
    
  FUNCTION get_comm_exp_summary
    RETURN def_rec_type_sum_tab PIPELINED;
    
  FUNCTION get_comm_exp_ri_dtl
    RETURN def_comm_exp_tab PIPELINED;
    
  FUNCTION get_comm_exp_ri_summary
    RETURN def_rec_type_sum_tab PIPELINED;
    
 -- FUNCTION get_advanced_book_gpw
 --   RETURN def_adv_book_tab PIPELINED;
    
 -- FUNCTION get_expired_policies
--    RETURN def_expired_tab PIPELINED;
END;
/

DROP PACKAGE CPI.TWENTY_FOURTH_VALIDATION;
