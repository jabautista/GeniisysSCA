CREATE OR REPLACE PACKAGE CPI.giacr201_pkg
AS
   FUNCTION get_gl_acct_code (p_gacc_tran_id     VARCHAR2,
                              p_acct_entry_id    VARCHAR2)
      RETURN VARCHAR2;

   TYPE giacr201_type IS RECORD
   (
      --      gacc_tran_id      giac_acct_entries.gacc_tran_id%TYPE,
      --      acct_entry_id     giac_acct_entries.acct_entry_id%TYPE,
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
      --added by vondanix 10.26.2015
      beg_cred_bal      NUMBER (16, 2),
      beg_deb_bal       NUMBER (16, 2),
      beg_bal           NUMBER (16, 2),
      end_cred_bal      NUMBER (16, 2),
      end_deb_bal       NUMBER (16, 2),
      end_bal           NUMBER (16, 2),
      -- added by jhing 01.19.2015
      tran_date         giac_acctrans.tran_date%TYPE,
      posting_date      giac_acctrans.posting_date%TYPE,
      name              VARCHAR2 (2000),
      tran_flag         giac_acctrans.tran_flag%TYPE,
      tran_id           VARCHAR2 (12),
      ref_no            VARCHAR2 (32767), --VARCHAR2(100), --edited by MarkS 04.12.2016
      jv_ref_no         VARCHAR2 (100),
      particulars       VARCHAR2 (2000),
      month_grp_seq     NUMBER , 
      year_grp_seq      NUMBER
   );

   TYPE giacr201_tab IS TABLE OF giacr201_type;

   FUNCTION generate_giacr201 (p_branch_cd     VARCHAR2,
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
                               p_beg_bal       VARCHAR2,
                               p_all_branches  VARCHAR2,
                               p_user_id       VARCHAR2,
                               p_module_id     VARCHAR2)
      RETURN giacr201_tab
      PIPELINED;

   TYPE grp_tran_date_type IS RECORD (tran_date DATE);

   TYPE grp_tran_date_tab IS TABLE OF grp_tran_date_type;

   FUNCTION get_giacr201_tran_date (p_branch_cd       VARCHAR2,
                                    p_fund_cd         VARCHAR2,
                                    p_tran_post       VARCHAR2,
                                    p_from_date       VARCHAR2,
                                    p_to_date         VARCHAR2,
                                    p_tran_flag       VARCHAR2,
                                    p_tran_class      VARCHAR2,
                                    p_gl_acct_code    VARCHAR2,
                                    p_month_grp       VARCHAR2)
      RETURN grp_tran_date_tab
      PIPELINED;

   TYPE giacr201_details_type IS RECORD
   (
      gacc_tran_id    VARCHAR2 (12),
      acct_entry_id   giac_acct_entries.acct_entry_id%TYPE,
      posting_date    giac_acctrans.posting_date%TYPE,
      NAME            VARCHAR2 (32727),
      particulars     VARCHAR2 (32727),
      tran_flag       giac_acctrans.tran_flag%TYPE,
      jv_ref_no       VARCHAR2 (1000),
      col_ref_no      VARCHAR2 (1000),
      cf_ref_no       VARCHAR2 (1000),
      jv_ref_no_2     VARCHAR2 (100)                -- added by gab 09.14.2015
   );

   TYPE giacr201_details_tab IS TABLE OF giacr201_details_type;

   FUNCTION get_giacr201_details (p_branch_cd       VARCHAR2,
                                  p_fund_cd         VARCHAR2,
                                  p_tran_post       VARCHAR2,
                                  p_from_date       VARCHAR2,
                                  p_to_date         VARCHAR2,
                                  p_tran_flag       VARCHAR2,
                                  p_tran_class      VARCHAR2,
                                  p_gl_acct_code    VARCHAR2,
                                  p_month_grp       VARCHAR2,
                                  p_tran_date       VARCHAR2)
      RETURN giacr201_details_tab
      PIPELINED;

   FUNCTION get_cf_ref_no (p_tran_id       VARCHAR2,
                           p_col_ref_no    VARCHAR2,
                           p_tran_class    VARCHAR2)
      RETURN VARCHAR2;

   TYPE giacr201_amounts_type IS RECORD
   (
      debit_amt    giac_acct_entries.debit_amt%TYPE,
      credit_amt   giac_acct_entries.credit_amt%TYPE,
      balance      NUMBER (12, 2)
   );

   TYPE giacr201_amounts_tab IS TABLE OF giacr201_amounts_type;

   FUNCTION get_giacr201_amounts (
      p_tran_post       VARCHAR2,
      p_tran_class      VARCHAR2,
      p_gl_acct_code    VARCHAR2,
      p_month_grp       VARCHAR2,
      p_tran_date       VARCHAR2,
      p_gacc_tran_id    giac_acct_entries.gacc_tran_id%TYPE)
      RETURN giacr201_amounts_tab
      PIPELINED;

   PROCEDURE get_totals (p_branch_cd      IN     VARCHAR2,
                         p_fund_cd        IN     VARCHAR2,
                         p_tran_post      IN     VARCHAR2,
                         p_from_date      IN     VARCHAR2,
                         p_to_date        IN     VARCHAR2,
                         p_tran_flag      IN     VARCHAR2,
                         p_tran_class     IN     VARCHAR2,
                         p_gl_acct_code   IN     VARCHAR2,
                         tot_debit_amt       OUT NUMBER,
                         tot_credit_amt      OUT NUMBER,
                         tot_balance         OUT NUMBER);
END;
/