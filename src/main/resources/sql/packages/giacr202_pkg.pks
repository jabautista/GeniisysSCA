CREATE OR REPLACE PACKAGE CPI.giacr202_pkg
AS
   FUNCTION get_gl_acct_code (
      p_gacc_tran_id    giac_acct_entries.gacc_tran_id%TYPE,
      p_acct_entry_id   giac_acct_entries.acct_entry_id%TYPE
   )
      RETURN VARCHAR2;

   TYPE giacr202_record_type IS RECORD (
      gl_acct_code      VARCHAR2 (100),
      gl_acct_name      VARCHAR2 (100),
      month_grp         VARCHAR2 (50),
      tran_class        VARCHAR2 (10),
      company_name      VARCHAR2 (500),
      company_address   VARCHAR2 (500),
      date_from         VARCHAR2 (100),
      date_to           VARCHAR2 (100),
      branch_name       giac_branches.branch_name%TYPE,
      month_grp_date    DATE,
      --benjo 08.03.2015 UCPBGEN-SR-19710
      sl_type_cd        giac_acct_entries.sl_type_cd%TYPE,
      sl_source_cd      giac_acct_entries.sl_source_cd%TYPE,
      sl_cd             giac_acct_entries.sl_cd%TYPE,
      sl_name           VARCHAR2 (32767),
      tran_date         VARCHAR2 (50),
      gacc_tran_id      giac_acct_entries.gacc_tran_id%TYPE,
      posting_date      VARCHAR2 (50),
      NAME              VARCHAR2 (32767),
      particulars       VARCHAR2 (32767),
      tran_flag         giac_acctrans.tran_flag%TYPE,
      cf_ref_no         VARCHAR2 (1000),
      print_tran_class  VARCHAR2 (1),
      print_sl          VARCHAR2 (1),
      print_tran_date   VARCHAR2 (1),
      --benjo end
      debit             NUMBER,
      credit            NUMBER,
      cf_bal            NUMBER,
      jv_ref_no         VARCHAR2 (100) -- added by gab 09.14.2015
   );

   TYPE giacr202_record_tab IS TABLE OF giacr202_record_type;

   FUNCTION /*get_giacr202_records*/ get_giacr202_records_old ( --benjo 08.03.2015 UCPBGEN-SR-19710
      p_branch_cd    VARCHAR2,
      p_company      VARCHAR2,
      p_control      VARCHAR2,
      p_sub_1        VARCHAR2,
      p_sub_2        VARCHAR2,
      p_sub_3        VARCHAR2,
      p_sub_4        VARCHAR2,
      p_sub_5        VARCHAR2,
      p_sub_6        VARCHAR2,
      p_sub_7        VARCHAR2,
      p_tran_class   VARCHAR2,
      p_sl_cd        VARCHAR2,
      p_sl_type_cd   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_tran_post    VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2,
      p_category     VARCHAR2
   )
      RETURN giacr202_record_tab PIPELINED;

   FUNCTION get_giacr202_records ( --benjo 08.03.2015 UCPBGEN-SR-19710
      p_branch_cd    VARCHAR2,
      p_company      VARCHAR2,
      p_control      VARCHAR2,
      p_sub_1        VARCHAR2,
      p_sub_2        VARCHAR2,
      p_sub_3        VARCHAR2,
      p_sub_4        VARCHAR2,
      p_sub_5        VARCHAR2,
      p_sub_6        VARCHAR2,
      p_sub_7        VARCHAR2,
      p_tran_class   VARCHAR2,
      p_sl_cd        VARCHAR2,
      p_sl_type_cd   VARCHAR2,
      p_tran_flag    VARCHAR2,
      p_tran_post    VARCHAR2,
      p_date_from    VARCHAR2,
      p_date_to      VARCHAR2,
      p_category     VARCHAR2,
      -- jhing GENQA 5280,5200 added parameters p_user_id and p_module_id
      p_user_id      VARCHAR2,
      p_module_id    VARCHAR2
   )
      RETURN giacr202_record_tab PIPELINED;
      
   TYPE sl_type IS RECORD (
      sl_type_cd     giac_acct_entries.sl_type_cd%TYPE,
      sl_source_cd   giac_acct_entries.sl_source_cd%TYPE,
      sl_cd          giac_acct_entries.sl_cd%TYPE,
      sl_name        VARCHAR2 (32767),
      debit          NUMBER,
      credit         NUMBER,
      cf_bal         NUMBER
   );

   TYPE sl_tab IS TABLE OF sl_type;

   FUNCTION get_sl (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE
   )
      RETURN sl_tab PIPELINED;

   TYPE tran_date_type IS RECORD (
      tran_date   giac_acctrans.tran_date%TYPE
   );

   TYPE tran_date_tab IS TABLE OF tran_date_type;

   FUNCTION get_tran_date (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE
   )
      RETURN tran_date_tab PIPELINED;

   TYPE details_type IS RECORD (
      gacc_tran_id   giac_acct_entries.gacc_tran_id%TYPE,
      posting_date   DATE,
      NAME           VARCHAR2 (32767),
      particulars    VARCHAR2 (32767),
      tran_flag      giac_acctrans.tran_flag%TYPE,
      col_ref_no     VARCHAR2 (1000),
      jv_ref_no      VARCHAR2 (1000),
      cf_ref_no      VARCHAR2 (1000)
   );

   TYPE details_tab IS TABLE OF details_type;

   FUNCTION get_details (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE,
      p_tran_date        DATE
   )
      RETURN details_tab PIPELINED;

   TYPE amounts_type IS RECORD (
      debit    NUMBER,
      credit   NUMBER,
      cf_bal   NUMBER
   );

   TYPE amounts_tab IS TABLE OF amounts_type;

   FUNCTION get_amounts (
      p_branch_cd        VARCHAR2,
      p_company          VARCHAR2,
      p_tran_class       VARCHAR2,
      p_sl_cd            VARCHAR2,
      p_sl_type_cd       VARCHAR2,
      p_tran_flag        VARCHAR2,
      p_tran_post        VARCHAR2,
      p_date_from        VARCHAR2,
      p_date_to          VARCHAR2,
      p_gl_acct_code     VARCHAR2,
      p_month_grp_date   DATE,
      p_tran_date        DATE,
      p_gacc_tran_id     NUMBER
   )
      RETURN amounts_tab PIPELINED;
END;
/
