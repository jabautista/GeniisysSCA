CREATE OR REPLACE PACKAGE CPI.giacr060_pkg
AS
   TYPE main_type IS RECORD (
      gl_acct_code      VARCHAR2 (200),
      gl_acct_name      VARCHAR2 (200),
      db_amt            NUMBER (16, 2),
      cd_amt            NUMBER (16, 2),
      bal               NUMBER (16, 2),
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      from_date         VARCHAR2 (100),
      to_date           VARCHAR2 (100),
      branch            VARCHAR2 (100)
   );

   TYPE main_tab IS TABLE OF main_type;

   FUNCTION get_main_rep (
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2,
      p_fund_cd      VARCHAR2,
      p_branch_cd    VARCHAR2,
      p_category     VARCHAR2,
      p_control      VARCHAR2,
      p_tran_class   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_tran_post    VARCHAR2,
      p_from_date    VARCHAR2,
      p_to_date      VARCHAR2,
      p_sub_1        VARCHAR2,
      p_sub_2        VARCHAR2,
      p_sub_3        VARCHAR2,
      p_sub_4        VARCHAR2,
      p_sub_5        VARCHAR2,
      p_sub_6        VARCHAR2,
      p_sub_7        VARCHAR2
   )
      RETURN main_tab PIPELINED;

   TYPE month_grp_type IS RECORD (
      month_grp   VARCHAR2 (20)
   );

   TYPE month_grp_tab IS TABLE OF month_grp_type;
   
   -- jhing added new types - GENQA 5280, 5200
 TYPE mainrec_grp_type IS RECORD
   (
      gl_acct_code      VARCHAR2 (500),
      gl_acct_name      giac_chart_of_accts.gl_acct_name%TYPE,
      month_grp         VARCHAR2 (100),
      month_grp2        DATE,
      tran_class        giac_acctrans.tran_class%TYPE,
      tot_debit_amt     NUMBER (16, 2),
      tot_credit_amt    NUMBER (16, 2),
      tot_balance       NUMBER (16, 2),
      branch_name       giac_branches.branch_name%TYPE,
      company_name      VARCHAR2 (200),
      company_address   VARCHAR2 (200),
      company_tin       giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      gen_version			giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      from_date         VARCHAR2 (100),
      TO_DATE           VARCHAR2 (100),
      month_grp_seq     NUMBER , 
      year_grp_seq      NUMBER
   );   
   
   
   TYPE mainrec_grp_tble IS TABLE OF mainrec_grp_type; 
   -- end of added code jhing   - GENQA 5280, 5200

   FUNCTION get_month_grps (
      p_user_id        VARCHAR2,
      p_module_id      VARCHAR2,
      p_fund_cd        VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_category       VARCHAR2,
      p_control        VARCHAR2,
      p_tran_class     VARCHAR2,
      p_tran_flag      VARCHAR2,
      p_tran_post      VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_gl_acct_code   VARCHAR2
   )
      RETURN month_grp_tab PIPELINED;

   TYPE tran_class_type IS RECORD (
      tran_class   VARCHAR2 (100),
      db_amt       NUMBER (16, 2),
      cd_amt       NUMBER (16, 2),
      bal          NUMBER (16, 2)
   );

   TYPE tran_class_tab IS TABLE OF tran_class_type;
   
   TYPE branchCdTbl IS TABLE of giis_issource.iss_cd%TYPE ; -- jhing  - GENQA 5280, 5200

   FUNCTION get_tran_class (
      p_user_id        VARCHAR2,
      p_module_id      VARCHAR2,
      p_fund_cd        VARCHAR2,
      p_branch_cd      VARCHAR2,
      p_category       VARCHAR2,
      p_control        VARCHAR2,
      p_tran_class     VARCHAR2,
      p_tran_flag      VARCHAR2,
      p_tran_post      VARCHAR2,
      p_from_date      VARCHAR2,
      p_to_date        VARCHAR2,
      p_gl_acct_code   VARCHAR2,
      p_month_grp      VARCHAR2
   )
      RETURN tran_class_tab PIPELINED;
      
      -- jhing 01.21.2015 added new function  - GENQA 5280, 5200
      
FUNCTION generate_mainrec (p_branch_cd     VARCHAR2,
                               p_category      VARCHAR2,
                               p_fund_cd       VARCHAR2,
                               p_control       VARCHAR2,
                               p_from_date     VARCHAR2,
                               p_to_date       VARCHAR2,
                               p_tran_post     VARCHAR2,
                               p_sub1          VARCHAR2,
                               p_sub2          VARCHAR2,
                               p_sub3          VARCHAR2,
                               p_sub4          VARCHAR2,
                               p_sub5          VARCHAR2,
                               p_sub6          VARCHAR2,
                               p_sub7          VARCHAR2,
                               p_tran_flag     VARCHAR2,
                               p_tran_class    VARCHAR2,
                               p_all_branches  VARCHAR2,
                               p_user_id       VARCHAR2,
                               p_module_id     VARCHAR2)
      RETURN mainrec_grp_tble
      PIPELINED;    
      
  FUNCTION get_Branch_WithAccess ( p_module_id VARCHAR2,
                                   p_user_id   VARCHAR2 )
  RETURN VARCHAR2;    
  
  

END;
/


