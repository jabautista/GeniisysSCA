CREATE OR REPLACE PACKAGE CPI.GIACR062_PKG
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
      TO_DATE           VARCHAR2 (100),
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
      
   TYPE details_type IS RECORD (
      tran_post     DATE,
      gacc_tran_id  giac_acct_entries.gacc_tran_id%TYPE,
      tran_id       VARCHAR2 (100),
      tran_class    VARCHAR2 (20),
      jv_ref_no     VARCHAR2 (100),
      col_ref_no    VARCHAR2 (100),
      cf_ref_no     VARCHAR2 (1000),
      particulars   VARCHAR2 (32767),
      db_amt        NUMBER (16, 2),
      cd_amt        NUMBER (16, 2),
      balance       NUMBER (16, 2),
      jv_ref_no2     VARCHAR2(100) --added by gab 09.14.2015
   );
   
   TYPE details_tab IS TABLE OF details_type;
   -- added by jhing 01.25.2016  - GENQA 5280, 5200
   TYPE giacr062_type IS RECORD
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
      gen_version       giis_parameters.param_value_v%TYPE, -- bonok :: 3.22.2017 :: SR 5964
      from_date         VARCHAR2 (100),
      TO_DATE           VARCHAR2 (100),
      tran_date         giac_acctrans.tran_date%TYPE,
      posting_date      giac_acctrans.posting_date%TYPE,
      name              VARCHAR2 (2000),
      tran_flag         giac_acctrans.tran_flag%TYPE,
      tran_id           VARCHAR2 (12),
      ref_no            VARCHAR2 (100),
      jv_ref_no         VARCHAR2 (100),
      particulars       VARCHAR2 (2000),
      month_grp_seq     NUMBER , 
      year_grp_seq      NUMBER ,
      p_date_rec        DATE
   );

   TYPE giacr062_tab IS TABLE OF giacr062_type;   
   
   -- end of added code by jhing  - GENQA 5280, 5200
   
   FUNCTION get_details (
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
      p_gl_acct_code   VARCHAR2
   )
      RETURN details_tab PIPELINED;
      
      -- new function jhing - GENQA 5280, 5200
   FUNCTION generate_giacr062 (p_branch_cd     VARCHAR2,
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
      RETURN giacr062_tab
      PIPELINED;      
      
   FUNCTION get_cf_ref_no (p_tran_id       VARCHAR2,
                           p_col_ref_no    VARCHAR2,
                           p_tran_class    VARCHAR2)
      RETURN VARCHAR2;      
   
END;
/
